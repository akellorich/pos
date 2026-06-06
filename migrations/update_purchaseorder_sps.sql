-- ==========================================
-- Migration: Purchase Order Stored Procedures Realignment
-- Created: 2026-05-29
-- ==========================================

DELIMITER $$

-- A. spgetsupplierpendingorders
DROP PROCEDURE IF EXISTS `spgetsupplierpendingorders`$$
CREATE PROCEDURE `spgetsupplierpendingorders`(
    IN $branchid INT,
    IN $supplierid INT
)
BEGIN
    SET @cutoffdate=IFNULL((SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`),'01-Jan-2001');
    SELECT DISTINCT `purchaseorderno` FROM `purchaseorders` p,`purchaseorderdetails` pd  
    WHERE p.`purchaseorderid`=pd.`purchaseorderid` AND p.`branchid` = $branchid AND p.`supplierid`=$supplierid 
    AND DATE_FORMAT(p.`date`,'%Y-%m-%d')>=@cutoffdate
    GROUP BY pd.`itemcode`, p.`purchaseorderno`
    HAVING SUM(pd.`quanity`)>IFNULL((SELECT SUM(gd.`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd
    WHERE g.`grnno`=gd.`grnno` AND gd.`itemcode`=pd.`itemcode` AND gd.purchaseorderno=p.purchaseorderno),0)
    ORDER BY p.`purchaseorderno`;
END$$

-- B. spgetpoitemsundelivered
DROP PROCEDURE IF EXISTS `spgetpoitemsundelivered`$$
CREATE PROCEDURE `spgetpoitemsundelivered`(
    IN $branchid INT,
    IN $purchaseorderid VARCHAR(50)
)
BEGIN
    SELECT p.`purchaseorderno`, pd.`itemcode` AS itemid, r.`itemcode`, r.`itemname`, pd.`unitprice`, pd.`quanity` AS ordered, IFNULL(r.serializable,0) `serializable`,
    pd.`quanity`-IFNULL((SELECT SUM(gd.quantity) FROM `goodsreceiveddetails` gd WHERE gd.`purchaseorderno`=p.`purchaseorderno` AND gd.`itemcode`=pd.itemcode),0) AS undelivered,
    IFNULL(r.disallowreceipt,0) `disallowreceipt`
    FROM `purchaseorders` p, `purchaseorderdetails` pd, `products` r
    WHERE p.`purchaseorderid`=pd.`purchaseorderid` AND pd.`itemcode`=r.productid 
    AND p.`branchid` = $branchid
    AND p.`purchaseorderno`=$purchaseorderid
    AND pd.`quanity`-IFNULL((SELECT SUM(gd.quantity) FROM `goodsreceiveddetails` gd WHERE gd.`purchaseorderno`=p.`purchaseorderno` AND gd.`itemcode`=pd.itemcode),0) >0 ;
END$$

-- C. spgetpurchaseorderdetails
DROP PROCEDURE IF EXISTS `spgetpurchaseorderdetails`$$
CREATE PROCEDURE `spgetpurchaseorderdetails`(
    IN $branchid INT,
    IN $id INT
)
BEGIN
    SELECT p.departmentid, p.`purchaseorderno`, p.`date`, p.`supplierid`, p.`expecteddate`, `fn_purchaseorderstatus`($id) `status`,
    p.`terms`, pd.`itemcode` AS itemid, pd.`quanity`, pd.`unitprice`, i.`itemcode`, `itemname`
    FROM `purchaseorders` p, `purchaseorderdetails` pd, `products` i
    WHERE p.`purchaseorderid` = pd.`purchaseorderid` AND pd.`itemcode` = i.`productid` 
    AND p.`branchid` = $branchid AND p.purchaseorderid = $id;
END$$

-- D. spsavegoodsreceived
DROP PROCEDURE IF EXISTS `spsavegoodsreceived`$$
CREATE PROCEDURE `spsavegoodsreceived`(
    IN $branchid INT,
    IN $refno VARCHAR(50),
    IN $warehouseid NUMERIC,
    IN $supplierid NUMERIC,
    IN $deliverynoteno VARCHAR(50),
    IN $userid NUMERIC,
    IN $saveinvoice BOOLEAN,
    IN $invoiceno VARCHAR(50),
    IN $inspectedby INT,
    IN $transferitems INT,
    IN $transferpos INT
)
BEGIN
    DECLARE v_grnno VARCHAR(50);
    START TRANSACTION;
        SET v_grnno = fngenerategrnno($branchid);

        INSERT INTO `goodsreceived`(branchid, `warehouseid`, `grnno`, `datereceived`, `supplierid`, `deliverynono`, `receivedby`, `status`, `inspectedby`)
        VALUES($branchid, $warehouseid, v_grnno, NOW(), $supplierid, $deliverynoteno, $userid, 'Confirmed', $inspectedby);

        INSERT INTO `goodsreceiveddetails`(branchid, `grnno`, `itemcode`, `purchaseorderno`, `quantity`, `serialno`)
        SELECT $branchid, v_grnno, `itemcode`, `purchaseorderno`, `quantity`, `serialno` FROM `tempgoodsreceived` WHERE branchid = $branchid AND `refno` = $refno;

        INSERT INTO `stockmovement`(branchid, `purchasedate`, `productid`, `purchaseid`, `purchasequantity`, `purchaseprice`, `purchasetaxrate`, `purchasetaxid`)
        SELECT $branchid, DATE_FORMAT(NOW(),'%Y-%m-%d'), tg.`itemcode`, p.purchaseorderid, tg.`quantity`,
            CASE WHEN pd.`taxinclusive` = 1 THEN (100 / (100 + p.taxrate)) * pd.unitprice ELSE pd.unitprice END,
            p.taxrate, p.taxid
        FROM `tempgoodsreceived` tg 
        JOIN `purchaseorders` p ON p.branchid = $branchid AND p.`purchaseorderno` = tg.`purchaseorderno`
        JOIN `purchaseorderdetails` pd ON pd.branchid = $branchid AND pd.`purchaseorderid` = p.`purchaseorderid`
        WHERE tg.branchid = $branchid AND tg.`refno` = $refno AND pd.itemcode = tg.itemcode;
        
        UPDATE `serials` SET `currentno` = `currentno` + 1 WHERE branchid = $branchid AND `documenttype` = 'Goods Received Note';
        
        DELETE FROM `tempgoodsreceived` WHERE branchid = $branchid AND `refno` = $refno;
        
        SELECT v_grnno AS grnno;
    COMMIT;
END$$

-- E. sp_filtergoodsreceivednotes
DROP PROCEDURE IF EXISTS `sp_filtergoodsreceivednotes`$$
CREATE PROCEDURE `sp_filtergoodsreceivednotes`(
    IN $branchid INT,
    IN $supplierid INT,
    IN $startdate DATE,
    IN $enddate DATE,
    IN $grnno VARCHAR(50),
    IN $deliverynoteno VARCHAR(50)
)
BEGIN
    IF $supplierid = 0 THEN
        SELECT g.`goodsreceivedid` AS receiptid, g.`warehouseid`, w.`description` AS warehousename, s.`supplierid`, s.`suppliername`, g.`grnno`, 
        DATE_FORMAT(g.`datereceived`,'%d-%b-%Y') AS datereceived, CONCAT(u.`firstname`,' ',u.`middlename`,' ',u.`lastname`) AS receivedbyname,
        CONCAT(i.`firstname`,' ',i.`middlename`,' ',i.`lastname`) AS inspectedbyname, g.`deliverynono`, SUM(gd.`quantity` * pd.unitprice) AS total
        FROM `goodsreceived` g 
        INNER JOIN `goodsreceiveddetails` gd ON g.`grnno` = gd.`grnno` AND g.branchid = gd.branchid
        INNER JOIN `suppliers` s ON s.`supplierid` = g.`supplierid`
        INNER JOIN `warehouses` w ON w.`id` = g.`warehouseid`
        LEFT OUTER JOIN `user` u ON u.`userid` = g.`receivedby`
        LEFT OUTER JOIN `user` i ON i.`userid` = g.`inspectedby`
        INNER JOIN `purchaseorders` p ON p.`purchaseorderno` = gd.`purchaseorderno` AND p.branchid = g.branchid
        INNER JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid` = p.`purchaseorderid` AND pd.branchid = g.branchid AND pd.itemcode = gd.itemcode
        WHERE g.branchid = $branchid 
        AND (DATE_FORMAT(g.datereceived,'%Y-%m-%d') BETWEEN $startdate AND $enddate) 
        AND g.grnno LIKE CONCAT('%',$grnno,'%') 
        AND g.deliverynono LIKE CONCAT('%',$deliverynoteno,'%')
        GROUP BY g.`goodsreceivedid`, g.`warehouseid`, w.`description`, s.`supplierid`, s.`suppliername`, g.`grnno`, g.`datereceived`, u.`firstname`, u.`middlename`, u.`lastname`, i.`firstname`, i.`middlename`, i.`lastname`, g.`deliverynono`
        ORDER BY g.grnno DESC;
    ELSE
        SELECT g.`goodsreceivedid` AS receiptid, g.`warehouseid`, w.`description` AS warehousename, s.`supplierid`, s.`suppliername`, g.`grnno`, 
        DATE_FORMAT(g.`datereceived`,'%d-%b-%Y') AS datereceived, CONCAT(u.`firstname`,' ',u.`middlename`,' ',u.`lastname`) AS receivedbyname,
        CONCAT(i.`firstname`,' ',i.`middlename`,' ',i.`lastname`) AS inspectedbyname, g.`deliverynono`, SUM(gd.`quantity` * pd.unitprice) AS total
        FROM `goodsreceived` g 
        INNER JOIN `goodsreceiveddetails` gd ON g.`grnno` = gd.`grnno` AND g.branchid = gd.branchid
        INNER JOIN `suppliers` s ON s.`supplierid` = g.`supplierid`
        INNER JOIN `warehouses` w ON w.`id` = g.`warehouseid`
        LEFT OUTER JOIN `user` u ON u.`userid` = g.`receivedby`
        LEFT OUTER JOIN `user` i ON i.`userid` = g.`inspectedby`
        INNER JOIN `purchaseorders` p ON p.`purchaseorderno` = gd.`purchaseorderno` AND p.branchid = g.branchid
        INNER JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid` = p.`purchaseorderid` AND pd.branchid = g.branchid AND pd.itemcode = gd.itemcode
        WHERE g.branchid = $branchid 
        AND (DATE_FORMAT(g.datereceived,'%Y-%m-%d') BETWEEN $startdate AND $enddate) 
        AND g.grnno LIKE CONCAT('%',$grnno,'%') 
        AND g.deliverynono LIKE CONCAT('%',$deliverynoteno,'%') 
        AND g.supplierid = $supplierid
        GROUP BY g.`goodsreceivedid`, g.`warehouseid`, w.`description`, s.`supplierid`, s.`suppliername`, g.`grnno`, g.`datereceived`, u.`firstname`, u.`middlename`, u.`lastname`, i.`firstname`, i.`middlename`, i.`lastname`, g.`deliverynono`
        ORDER BY g.grnno DESC; 
    END IF;
END$$

-- F. spgetgrnproducts
DROP PROCEDURE IF EXISTS `spgetgrnproducts`$$
CREATE PROCEDURE `spgetgrnproducts`(
    IN $branchid INT,
    IN $grnno VARCHAR(50)
)
BEGIN
    SELECT DISTINCT gd.`itemcode` AS productid, p.`itemcode`, p.`itemname` 
    FROM `goodsreceiveddetails` gd
    INNER JOIN `products` p ON gd.itemcode = p.productid
    INNER JOIN `goodsreceived` g ON g.grnno = gd.grnno AND g.branchid = gd.branchid
    WHERE gd.branchid = $branchid 
    AND (gd.`grnno` = $grnno OR g.`invoiceno` = $grnno)
    ORDER BY p.`itemname`;
END$$

-- G. spgetgrnitemdetails
DROP PROCEDURE IF EXISTS `spgetgrnitemdetails`$$
CREATE PROCEDURE `spgetgrnitemdetails`(
    IN $branchid INT,
    IN $grnno VARCHAR(50),
    IN $productid INT
)
BEGIN
    SELECT p.productid, p.`itemcode`, p.`itemname`, gd.`quantity`, od.`unitprice`, gd.`serialno`
    FROM `goodsreceived` g
    INNER JOIN `goodsreceiveddetails` gd ON g.grnno = gd.grnno AND g.branchid = gd.branchid
    INNER JOIN `products` p ON gd.itemcode = p.productid
    INNER JOIN `purchaseorders` o ON gd.purchaseorderno = o.purchaseorderno AND gd.branchid = o.branchid
    INNER JOIN `purchaseorderdetails` od ON od.purchaseorderid = o.purchaseorderid AND od.itemcode = p.productid AND od.branchid = o.branchid
    WHERE gd.branchid = $branchid 
    AND p.productid = $productid 
    AND (gd.grnno = $grnno OR g.invoiceno = $grnno);
END$$

-- H. sp_getgrnheaderdetails
DROP PROCEDURE IF EXISTS `sp_getgrnheaderdetails`$$
CREATE PROCEDURE `sp_getgrnheaderdetails`(
    IN $branchid INT,
    IN $grnno VARCHAR(50)
)
BEGIN
    SELECT m.`grnno`, DATE_FORMAT(m.`datereceived`,'%d-%b-%Y') AS datereceived, 
    CONCAT(r.firstname,' ', r.middlename,' ', r.lastname) AS receivedby,
    CONCAT(i.firstname,' ', i.middlename,' ', i.lastname) AS inspectedby,
    m.deliveredby, m.`deliverynono`, m.`narration`,
    '' AS projectname, '' AS materialusecase, 
    s.`suppliername`, s.`physicaladdress`, s.`postaladdress`, s.`mobile`, s.`email`
    FROM `goodsreceived` m
    INNER JOIN `suppliers` s ON m.`supplierid` = s.`supplierid`
    LEFT OUTER JOIN `user` r ON m.`receivedby` = r.`userid`
    LEFT OUTER JOIN `user` i ON m.`inspectedby` = i.`userid`
    WHERE m.branchid = $branchid AND m.grnno = $grnno;
END$$

-- I. sp_getgrnitems
DROP PROCEDURE IF EXISTS `sp_getgrnitems`$$
CREATE PROCEDURE `sp_getgrnitems`(
    IN $branchid INT,
    IN $grnno VARCHAR(50)
)
BEGIN
    SELECT m.`productid`, m.`itemcode`, m.itemname, m.unitofmeasure AS uom, SUM(rd.quantity) AS quantity, 
    '' AS serialnos, p.purchaseorderno AS pono, pd.unitprice, r.deliveredby
    FROM `products` m
    INNER JOIN `goodsreceiveddetails` rd ON rd.itemcode = m.`productid`
    INNER JOIN `goodsreceived` r ON r.`grnno` = rd.`grnno` AND r.branchid = rd.branchid
    INNER JOIN `purchaseorders` p ON p.`purchaseorderno` = rd.`purchaseorderno` AND p.branchid = rd.branchid
    INNER JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid` = p.`purchaseorderid` AND pd.itemcode = m.productid AND pd.branchid = p.branchid
    WHERE r.branchid = $branchid AND r.grnno = $grnno
    GROUP BY m.`productid`, m.`itemcode`, m.itemname, m.unitofmeasure, p.purchaseorderno, pd.unitprice, r.deliveredby
    ORDER BY m.itemname;
END$$

-- J. sp_getpoheaderdetails
DROP PROCEDURE IF EXISTS `sp_getpoheaderdetails`$$
CREATE PROCEDURE `sp_getpoheaderdetails`(
    IN $branchid INT,
    IN $pono VARCHAR(50)
)
BEGIN
    SELECT s.`suppliername`, s.`physicaladdress`, s.`postaladdress`, s.`town`, s.`postalcode`, s.mobile, s.email AS supplieremail,
    DATE_FORMAT(p.`date`,'%d-%b-%Y') orderdate, p.`purchaseorderno` orderno, 
    DATE_FORMAT(IFNULL(p.`expecteddate`,DATE_ADD(p.date, INTERVAL 7 DAY)),'%d-%b-%Y') expecteddate, c.`currencyname`, p.`terms`,
    CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) preparedby
    FROM `purchaseorders` p
    INNER JOIN `currencies` c ON p.`currencyid` = c.`id`
    INNER JOIN `suppliers` s ON p.supplierid = s.supplierid
    LEFT OUTER JOIN `user` u ON u.userid = p.addedby
    WHERE p.branchid = $branchid AND p.`purchaseorderno` = $pono;
END$$

-- K. sp_getpoitems
DROP PROCEDURE IF EXISTS `sp_getpoitems`$$
CREATE PROCEDURE `sp_getpoitems`(
    IN $branchid INT,
    IN $pono VARCHAR(50)
)
BEGIN
    SELECT i.`itemcode`, i.productid AS itemid, i.itemname, i.unitofmeasure AS uom, 
    pd.`quanity` AS quantity, pd.`unitprice`, pd.`taxinclusive`, a.`taxrate`, p.`taxid`, 
    pd.quanity * pd.unitprice AS total, IFNULL(a.`taxname`, 'VAT') AS taxname
    FROM `purchaseorders` p
    INNER JOIN `purchaseorderdetails` pd ON p.`purchaseorderid` = pd.`purchaseorderid` AND p.branchid = pd.branchid
    INNER JOIN `products` i ON pd.`itemcode` = i.`productid`
    LEFT OUTER JOIN `taxtypes` a ON p.`taxid` = a.id
    WHERE p.branchid = $branchid AND p.`purchaseorderno` = $pono
    ORDER BY i.itemname;
END$$

-- L. spgetpurchaseorders
DROP PROCEDURE IF EXISTS `spgetpurchaseorders`$$
CREATE PROCEDURE `spgetpurchaseorders`(IN $branchid INT)
BEGIN
    SELECT p.*, p.purchaseorderid AS id, s.suppliername, d.departmentname,
           IFNULL(CONCAT_WS(' ', u.firstname, u.middlename, u.lastname), 'System') AS addedbyname,
           IFNULL(SUM(pd.quanity * pd.unitprice), 0) AS ordertotal,
           `fn_purchaseorderstatus`(p.purchaseorderid) AS status
    FROM `purchaseorders` p
    JOIN `suppliers` s ON s.supplierid = p.supplierid
    LEFT JOIN `departments` d ON d.id = p.departmentid
    LEFT JOIN `user` u ON u.userid = p.addedby
    LEFT JOIN `purchaseorderdetails` pd ON pd.purchaseorderid = p.purchaseorderid
    WHERE p.branchid = $branchid
    GROUP BY p.purchaseorderid, s.suppliername, d.departmentname, u.firstname, u.middlename, u.lastname
    ORDER BY p.date DESC;
END$$

-- M. spsavepurchaseorder
DROP PROCEDURE IF EXISTS `spsavepurchaseorder`$$
CREATE PROCEDURE `spsavepurchaseorder`(IN $branchid INT, IN $id NUMERIC, IN $refno VARCHAR(50),
    IN $supplierid INT,
    IN $terms VARCHAR(1000),
    IN $category VARCHAR(50),
    IN $currencyid INT,
    IN $exchangerate DECIMAL(18,2),
    IN $departmentid INT,
    IN $taxid INT,
    IN $taxrate DECIMAL(18,2),
    IN $userid INT
)
BEGIN
    DECLARE v_purchaseorderno VARCHAR(50);
    DECLARE v_orderid NUMERIC;
    
    IF $id=0 THEN 
        START TRANSACTION;
            SET v_purchaseorderno = fngeneratepurchaseorderno($branchid);
            
            INSERT INTO `purchaseorders`(
                branchid, `purchaseorderno`, `date`, `supplierid`, `expecteddate`, `status`, `terms`, `departmentid`, `category`,
                `currencyid`, `exchangerate`, `taxid`, `taxrate`, `addedby`
            ) VALUES (
                $branchid, v_purchaseorderno, NOW(), $supplierid, NOW(), 'Pending', $terms, $departmentid, $category,
                $taxid, $exchangerate, $currencyid, $taxrate, $userid
            );
        
            SET v_orderid = LAST_INSERT_ID();
        
            INSERT INTO `purchaseorderdetails`(branchid, `purchaseorderid`, `itemcode`, `quanity`, `unitprice`, `taxable`, `taxinclusive`)
            SELECT $branchid, v_orderid, `itemcode`, `quantity`, `unitprice`, `taxable`, `taxinclusive` 
            FROM `temppurchaseorder` WHERE branchid = $branchid AND `refno` = $refno;
        
            DELETE FROM `temppurchaseorder` WHERE branchid = $branchid AND `refno` = $refno;
            
            UPDATE `serials` SET `currentno` = `currentno` + 1 WHERE branchid = $branchid AND `documenttype` = 'Purchase Order';
        COMMIT;
    ELSE
        START TRANSACTION;
            DELETE FROM `purchaseorderdetails` WHERE branchid = $branchid AND `purchaseorderid` = $id;
            
            UPDATE `purchaseorders` SET 
                `supplierid` = $supplierid, `terms` = $terms, `departmentid` = $departmentid, `category` = $category,
                `currencyid` = $currencyid, `exchangerate` = $exchangerate, `lastmodifiedon` = NOW(), `lastmodifiedby` = $userid, `taxid` = $taxid,
                `taxrate` = $taxrate
            WHERE branchid = $branchid AND `purchaseorderid` = $id;
            
            INSERT INTO `purchaseorderdetails`(branchid, `purchaseorderid`, `itemcode`, `quanity`, `unitprice`, `taxable`, `taxinclusive`)
            SELECT $branchid, $id, `itemcode`, `quantity`, `unitprice`, `taxable`, `taxinclusive` 
            FROM `temppurchaseorder` WHERE branchid = $branchid AND `refno` = $refno;
            
            DELETE FROM `temppurchaseorder` WHERE branchid = $branchid AND `refno` = $refno;
            
            SET v_purchaseorderno = (SELECT `purchaseorderno` FROM `purchaseorders` WHERE branchid = $branchid AND `purchaseorderid` = $id);
        COMMIT;
    END IF;
    
    SELECT v_purchaseorderno AS purchaseorderno;
END$$

-- N. spgetpurchaseorderdetails
DROP PROCEDURE IF EXISTS `spgetpurchaseorderdetails`$$
CREATE PROCEDURE `spgetpurchaseorderdetails`(
    IN $branchid INT,
    IN $id INT
)
BEGIN
    SELECT p.departmentid, p.`purchaseorderno`, p.`date`, p.`supplierid`, p.`expecteddate`, `fn_purchaseorderstatus`($id) `status`,
    p.`terms`, pd.`itemcode` AS itemid, pd.`quanity`, pd.`unitprice`, i.`itemcode`, i.`itemname`
    FROM `purchaseorders` p
    LEFT OUTER JOIN `purchaseorderdetails` pd ON p.`purchaseorderid` = pd.`purchaseorderid` AND p.branchid = pd.branchid
    LEFT OUTER JOIN `products` i ON pd.`itemcode` = i.`productid`
    WHERE p.`branchid` = $branchid AND p.purchaseorderid = $id;
END$$

DELIMITER ;

-- O. fngenerateproductcode (Fix branchid column not found in categories table)
DELIMITER $$
DROP FUNCTION IF EXISTS `fngenerateproductcode`$$
CREATE FUNCTION `fngenerateproductcode`(p_clientid INT, p_categoryid NUMERIC) RETURNS varchar(50) CHARSET latin1
BEGIN
    DECLARE v_itemcode VARCHAR(50);
    SET v_itemcode = (SELECT CONCAT(
        `prefix`,
        CASE CHAR_LENGTH(`currentno`) 
            WHEN 1 THEN '0000'
            WHEN 2 THEN '000'
            WHEN 3 THEN '00'
            WHEN 4 THEN '0'
            ELSE '' 
        END,
        `currentno`) FROM `categories` WHERE `clientid` = p_clientid AND `categoryid` = p_categoryid);
    RETURN v_itemcode;
END$$
DELIMITER ;

-- P. spsaveproduct (Fix clientid parameter typo in fn_generateproductcode)
DELIMITER $$
DROP PROCEDURE IF EXISTS `spsaveproduct`$$
CREATE PROCEDURE `spsaveproduct`(
    IN $clientid INT, 
    IN $id NUMERIC, 
    IN $itemcode VARCHAR(50),
    IN $itemname VARCHAR(50),
    IN $categoryid NUMERIC,
    IN $uom VARCHAR(50),
    IN $buyingprice DECIMAL(18,2),
    IN $sellingprice DECIMAL(18,2),
    IN $reorderlevel NUMERIC,
    IN $userid NUMERIC,
    IN $refno VARCHAR(50),
    IN $generateitemcode BOOL,
    IN $canserialize BOOL,
    IN $bundleitem BOOLEAN,
    IN $taxtypeid INT,
    IN $itemlength DECIMAL(18,2),
    IN $itemwidth DECIMAL(18,2),
    IN $itemheight DECIMAL(18,2),
    IN $allownegativesales BOOL,
    IN $saleby VARCHAR(50),
    IN $bundleproduct INT,
    IN $allowreturnexchange BOOL,
    IN $rawmaterial BOOL,
    IN $itemtype VARCHAR(50),
    IN $disallowpurchasing BOOL,
    IN $disallowreceipt BOOL,
    IN $disallowsale BOOL
)
BEGIN
    IF $id=0 THEN 
        IF $generateitemcode=1 THEN
            SET $itemcode=(SELECT fngenerateproductcode($clientid, $categoryid));
            UPDATE `categories` SET `currentno`=`currentno`+1 WHERE clientid = $clientid AND `categoryid`=$categoryid;
        END IF;
        INSERT INTO `products`(
            clientid, `itemcode`, `itemname`, `unitofmeasure`, `buyingprice`, `sellingprice`, `categoryid`, `dateadded`, `addedby`, `deleted`, `reorderlevel`, `serializable`,
            `bundleitem`, `taxtypeid`, `length`, `width`, `height`, `allownegativesales`, `saleby`, `bundledproduct`, `allowreturnexchange`,
            `rawmaterial`, `itemtype`, `disallowpurchasing`, `disallowreceipt`, `disallowsale`
        ) VALUES (
            $clientid, $itemcode, $itemname, $uom, $buyingprice, $sellingprice, $categoryid, NOW(), $userid, 0, $reorderlevel, $canserialize,
            $bundleitem, $taxtypeid, $itemlength, $itemwidth, $itemheight, $allownegativesales, $saleby, $bundleproduct, $allowreturnexchange,
            $rawmaterial, $itemtype, $disallowpurchasing, $disallowreceipt, $disallowsale
        );
    ELSE
        UPDATE `products` SET 
            `itemcode`=$itemcode, `itemname`=$itemname, `unitofmeasure`=$uom, `buyingprice`=$buyingprice, `sellingprice`=$sellingprice,
            `categoryid`=$categoryid, `reorderlevel`=$reorderlevel, `lastmodifiedon`=NOW(), `lastmodifiedby`=$userid, `serializable`=$canserialize, 
            `bundleitem`=$bundleitem, `taxtypeid`=$taxtypeid, `length`=$itemlength, `width`=$itemwidth, `height`=$itemheight, `allownegativesales`=$allownegativesales,
            `saleby`=$saleby, `bundledproduct`=$bundleproduct, `allowreturnexchange`=$allowreturnexchange,
            `rawmaterial`=$rawmaterial, `itemtype`=$itemtype, `disallowpurchasing`=$disallowpurchasing, `disallowreceipt`=$disallowreceipt, `disallowsale`=$disallowsale
        WHERE clientid = $clientid AND `productid`=$id;
    END IF;
END$$
DELIMITER ;

-- Q. spgetusernamefromuserid (Fix non-existent id column reference and clientid parameter mismatch)
DELIMITER $$
DROP PROCEDURE IF EXISTS `spgetusernamefromuserid`$$
CREATE PROCEDURE `spgetusernamefromuserid`(IN $userid INT)
BEGIN
    SELECT * FROM `user` WHERE `userid` = $userid;
END$$
DELIMITER ;

-- R. User and POS table schema corrections (Fix non-existent id column reference to userid/posid)
DELIMITER $$

DROP PROCEDURE IF EXISTS `spcheckuser`$$
CREATE PROCEDURE `spcheckuser`(`$clientid` INT, `$checkfield` VARCHAR(50), `$checkvalue` VARCHAR(50))
BEGIN
	IF $checkfield='username' THEN 
		SELECT * FROM `user` WHERE `userid`<>$clientid AND `username`=$checkvalue;
	ELSEIF $checkfield='email' THEN 
		SELECT * FROM `user` WHERE `userid`<>$clientid AND `email`=$checkvalue;
	ELSEIF $checkfield='mobile' THEN 
		SELECT * FROM `user` WHERE `userid`<>$clientid AND `mobile`=$checkvalue;
	END IF;
END$$

DROP PROCEDURE IF EXISTS `spdeleteuser`$$
CREATE PROCEDURE `spdeleteuser`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `user` SET `accountactive`=0,`lastmodifiedon`=NOW(),`lastmodifiedby`=$clientid, `reasoninactive`='Account deleted'
	WHERE `userid`=$id;
END$$

DROP PROCEDURE IF EXISTS `spdisableuseraccount`$$
CREATE PROCEDURE `spdisableuseraccount`(`$id` INT, `$reason` VARCHAR(500), `$clientid` INT)
BEGIN
	UPDATE `user` SET `accountactive`=0,`reasoninactive`=$reason,`lastmodifiedby`=$clientid,`lastmodifiedon`=NOW()
	WHERE `userid`=$id;
END$$

DROP PROCEDURE IF EXISTS `spenableuseraccount`$$
CREATE PROCEDURE `spenableuseraccount`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `user` SET `accountactive`=1, `lastmodifiedon`=NOW(),`lastmodifiedby`=$clientid
	WHERE `userid`=$id;
END$$

DROP PROCEDURE IF EXISTS `spgetnonuseroutlets`$$
CREATE PROCEDURE `spgetnonuseroutlets`(`$userid` INT)
BEGIN
	SELECT *
	FROM  `pointsofsale` s  
	WHERE `posid` NOT IN(SELECT `outletid` FROM `useroutlets` WHERE `userid`=$userid AND IFNULL(`deleted`,0)=0)
	AND IFNULL(s.deleted,0)=0
	ORDER BY posname;
END$$

DROP PROCEDURE IF EXISTS `spgetuserbyid`$$
CREATE PROCEDURE `spgetuserbyid`(`$clientid` INT)
BEGIN
	SELECT * FROM `user` WHERE `userid`=$clientid;
END$$

DROP PROCEDURE IF EXISTS `spsaveuser`$$
CREATE PROCEDURE `spsaveuser`(`$clientid` INT, `$userpassword` VARCHAR(50), `$systemadmin` BIT, `$username` VARCHAR(50), `$firstname` VARCHAR(50), `$middlename` VARCHAR(50), `$lastname` VARCHAR(50), `$email` VARCHAR(50), `$mobile` VARCHAR(50), `$changepasswordonlogon` BIT, `$accountactive` BIT, `$addedby` INT)
BEGIN
	IF $clientid=0 THEN 
		INSERT INTO `user`(`username`,`password`,`firstname`,`middlename`,`lastname`,`email`,`mobile`,`changepasswordonlogon`,`accountactive`,`addedby`,`dateadded`,systemadmin)
		VALUES($username,$userpassword,$firstname,$middlename,$lastname,$email,$mobile,$changepasswordonlogon,$accountactive,$addedby,NOW(),$systemadmin);
		SET $clientid=(SELECT MAX(`userid`) FROM `user`);
	ELSE
		UPDATE `user` SET `username`=$username,`firstname`=$firstname,`middlename`=$middlename,`lastname`=$lastname,`email`=$email,`mobile`=$mobile,
		`changepasswordonlogon`=$changepasswordonlogon,`systemadmin`=$systemadmin,`lastmodifiedby`=$addedby,`lastmodifiedon`=NOW()
		WHERE `userid`=$clientid;
	END IF;
	
	SELECT $clientid AS `userid`;
END$$

DROP PROCEDURE IF EXISTS `sp_checkuserprivilegewithcode`$$
CREATE PROCEDURE `sp_checkuserprivilegewithcode`(`$clientid` INT, `$objectcode` VARCHAR(50))
BEGIN
	IF EXISTS(SELECT * FROM `user` WHERE `userid`=$clientid AND `systemadmin`=1) THEN 
		SELECT 1 allowed;
	ELSEIF EXISTS(SELECT * FROM `roleprivileges` r 
		JOIN `objects` b ON b.`id`=r.`objectid`
		JOIN `roleusers` ru ON ru.`roleid`=r.`roleid` 
		WHERE ru.userid=$clientid AND `allowed`=1 AND b.code=$objectcode) THEN 
			SELECT 1 allowed;
	ELSEIF EXISTS(SELECT * FROM `userprivileges` p 
		JOIN `objects` o ON o.`id`=p.`objectid`
		WHERE p.`userid`=$clientid AND o.`code`=$objectcode AND `allowed`=1) THEN 
			SELECT 1 allowed;
	ELSE
		SELECT 0 allowed;
	END IF;	
END$$

DROP PROCEDURE IF EXISTS `sp_validateuserprivilege`$$
CREATE PROCEDURE `sp_validateuserprivilege`(`$userid` INT, `$objectid` INT)
BEGIN
	DECLARE $admin INT;
	DECLARE $valid INT DEFAULT 0;
	SET $admin=(SELECT systemadmin FROM `user` WHERE `userid`=$userid);
	IF $admin=1 THEN
		SET $valid=1;
	ELSE
		SET $valid=IFNULL((SELECT `allowed` FROM `userprivileges` WHERE `userid`=$userid AND `objectid`=$objectid),0);
	END IF;
	
	SELECT $valid AS `allowed`;
END$$

DELIMITER ;


