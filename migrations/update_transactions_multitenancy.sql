-- ==========================================
-- Migration: Transactional Procedures Multi-Tenancy Upgrades
-- Created: 2026-05-29
-- ==========================================

DELIMITER $$

-- 1. spcheckcustomerdocuments
DROP PROCEDURE IF EXISTS `spcheckcustomerdocuments`$$
CREATE PROCEDURE `spcheckcustomerdocuments`(
    IN $clientid INT,
    IN $id INT,
    IN $document VARCHAR(50),
    IN $docno VARCHAR(50)
)
BEGIN
    IF $document='pin' THEN
        SELECT * FROM `customers` WHERE `clientid` = $clientid AND `customerid`<>$id AND `pinno`=$docno;
    ELSEIF $document='id' THEN
        SELECT * FROM `customers` WHERE `clientid` = $clientid AND `customerid`<>$id AND `idno`=$docno;
    END IF;
END$$

-- 2. sptempsavecustomerreceiptdetails
DROP PROCEDURE IF EXISTS `sptempsavecustomerreceiptdetails`$$
CREATE PROCEDURE `sptempsavecustomerreceiptdetails`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $possaleid NUMERIC,
    IN $amount NUMERIC
)
BEGIN
    INSERT INTO `tempcustomerreceiptdetails`(`refno`,`possaleid`,`amount`)
    VALUES($refno,$possaleid,$amount);
END$$

-- 3. spsavecustomerreceipt
DROP PROCEDURE IF EXISTS `spsavecustomerreceipt`$$
CREATE PROCEDURE `spsavecustomerreceipt`(
    IN $branchid INT,
    IN $refno VARCHAR(50),
    IN $customerid INT,
    IN $modeofpayment INT,
    IN $referenceno VARCHAR(50),
    IN $userid INT,
    IN $overpay NUMERIC
)
BEGIN
    DECLARE $receiptno VARCHAR(50);
    DECLARE $receiptid NUMERIC;
    SET $receiptno=`spgeneratecustomerreceiptno`($branchid);
    START TRANSACTION;
        INSERT INTO `customerreceipts`(`receiptno`,`receiptdate`,`addedby`,`modeofpayment`,`referenceno`,`deleted`, `customerid`)
        VALUES($receiptno,NOW(),$userid,$modeofpayment,$referenceno,0,$customerid);
        
        SET $receiptid=(SELECT MAX(`id`) FROM `customerreceipts`);
        
        INSERT INTO `customerreceiptdetails` (`receiptid`,`possaleid`,`amount`)
        SELECT $receiptid, `possaleid`,`amount` FROM `tempcustomerreceiptdetails` WHERE `refno`=$refno;
        
        IF $overpay>0 THEN 
            INSERT INTO `customersuspenseaccount`(`customerid`,`transactiondate`,`referenceno`,`credit`,`addedby`,`narration`)
            VALUES($customerid,NOW(),$receiptno,$overpay,$userid,'Customer amount overpaid');
        END IF;
        
        UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Customer Receipt' AND `branchid` = $branchid;
        DELETE FROM `tempcustomerreceiptdetails` WHERE  `refno`=$refno;
        SELECT  $receiptno  AS receiptno;
    COMMIT;
END$$

-- 4. spgetcustomerreceiptdetails
DROP PROCEDURE IF EXISTS `spgetcustomerreceiptdetails`$$
CREATE PROCEDURE `spgetcustomerreceiptdetails`(
    IN $clientid INT,
    IN $receiptno VARCHAR(50)
)
BEGIN
    SELECT c.`customerid` , `customername`, `receiptno`,`receiptdate`,
    p.`description` AS paymentmode, `referenceno`, CONCAT(`firstname`,' ',`middlename`,' ' ,`lastname`) servedby,
    CONCAT('Settlement of POS bill #' , `possaleid`) AS narration, `amount`
    FROM `customerreceipts` c, `customerreceiptdetails` cr, `paymentmethods` p, `user` u, `customers` m
    WHERE c.`id`=cr.`receiptid` AND c.`customerid`=m.customerid AND c.`addedby`=u.`userid` AND c.`modeofpayment`=p.`id`
    AND m.`clientid` = $clientid AND c.`receiptno`=$receiptno
    
    UNION 
    
    SELECT c.`customerid` , `customername`, `receiptno`,`receiptdate`,
    p.`description` AS paymentmode, c.`referenceno`, CONCAT(`firstname`,`middlename`,`lastname`) servedby,
    'Customer amount overpaid'  AS narration, `credit` AS amount
    FROM `customerreceipts` c, `customersuspenseaccount` cr, `paymentmethods` p, `user` u, `customers` m
    WHERE c.`receiptno`=cr.`referenceno` AND c.`customerid`=m.customerid AND c.`addedby`=u.`userid` AND c.`modeofpayment`=p.`id`
    AND m.`clientid` = $clientid AND c.`receiptno`=$receiptno;
END$$

-- 5. spgetcustomerunbankedreceipts
DROP PROCEDURE IF EXISTS `spgetcustomerunbankedreceipts`$$
CREATE PROCEDURE `spgetcustomerunbankedreceipts`(
    IN $clientid INT,
    IN $startdate DATETIME,
    IN $enddate DATETIME,
    IN $paymentmethod INT
)
BEGIN
    IF $paymentmethod=0 THEN 
        SELECT id,DATE_FORMAT(`date`,'%d-%b-%Y') AS `date`, customername,posname,description,receiptno,reference,amount,addedby
        FROM vwcustomerreceipts WHERE DATE BETWEEN $startdate AND $enddate AND banked=0 AND clientid = $clientid
        ORDER BY receiptno;
    ELSE
        SELECT id,DATE_FORMAT(`date`,'%d-%b-%Y') AS `date`, customername,posname,description,receiptno,reference,amount,addedby
        FROM vwcustomerreceipts WHERE DATE BETWEEN $startdate AND $enddate AND banked=0 AND paymentmodeid=$paymentmethod AND clientid = $clientid
        ORDER BY receiptno;
    END IF;
END$$

-- 6. spgetinsertedcustomer
DROP PROCEDURE IF EXISTS `spgetinsertedcustomer`$$
CREATE PROCEDURE `spgetinsertedcustomer`(
    IN $clientid INT
)
BEGIN
    SELECT MAX(customerid) AS customerid FROM `customers` WHERE `clientid` = $clientid;
END$$

-- 7. spgetcustomesuspenseaccountstatement
DROP PROCEDURE IF EXISTS `spgetcustomesuspenseaccountstatement`$$
CREATE PROCEDURE `spgetcustomesuspenseaccountstatement`(
    IN $clientid INT,
    IN $customerid INT,
    IN $startdate DATE,
    IN $enddate DATE
)
BEGIN
    SELECT DATE_FORMAT($startdate,'%d-%b-%Y') `date`,''  `referenceno`,'Opening balance' `narration`,
    CASE WHEN SUM(IFNULL(credit,0)-IFNULL(debit,0))>0 THEN credit ELSE 0 END credit, 
    CASE WHEN SUM(IFNULL(credit,0)-IFNULL(debit,0))<0 THEN credit ELSE 0 END debit,'' AS addedby
    FROM `customersuspenseaccount` WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') < $startdate AND  `customerid`=$customerid
    
    UNION
    
    SELECT * FROM (SELECT DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`,`referenceno`,`narration`,`credit`,`debit`, CONCAT(`firstname`,' ',`lastname`) addedby
    FROM `customersuspenseaccount` c, `user` u
    WHERE c.`addedby`=u.`userid` AND u.`clientid` = $clientid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.`customerid`=$customerid
    ORDER BY `transactiondate`, `referenceno`) AS a;
END$$

-- 8. spsavetemppricematrix
DROP PROCEDURE IF EXISTS `spsavetemppricematrix`$$
CREATE PROCEDURE `spsavetemppricematrix`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $catid NUMERIC,
    IN $percentage BIT,
    IN $val NUMERIC
)
BEGIN
    INSERT INTO `temppricematrix`(`refno`,`catid`,`percentage`,`value`)
    VALUES($refno,$catid,$percentage,$val);
END$$

-- 9. spgetstocktransferbalance
DROP PROCEDURE IF EXISTS `spgetstocktransferbalance`$$
CREATE PROCEDURE `spgetstocktransferbalance`(
    IN $clientid INT,
    IN $sourcetype VARCHAR(50),
    IN $sourceid INT,
    IN $itemcode VARCHAR(50)
)
BEGIN
    IF $sourcetype='warehouse' THEN 
        SELECT 
        `p`.`itemcode` AS `itemcode`,
        `p`.`itemname` AS `itemname`,
        `p`.`productid` AS `productid`,
        `p`.`unitofmeasure` AS `unitofmeasure`,
        `p`.`buyingprice` AS `buyingprice`,
        `p`.`sellingprice` AS `sellingprice`,
        `p`.`serializable` AS `serializable`,
        `fn_getwarehousestockbalance`(productid,$sourceid,CURDATE()) unitsreceived, 0 AS issued
        FROM products p WHERE p.clientid = $clientid AND itemcode=$itemcode;
    ELSE
        SELECT
          `s`.`id`            AS `posid`,
          `s`.`posname`       AS `posname`,
          `td`.`itemcode`     AS `itemid`,
          `p`.`productid`     AS `productid`,
          `p`.`itemcode`      AS `itemcode`,
          `p`.`itemname`      AS `itemname`,
          `p`.`unitofmeasure` AS `unitofmeasure`,
          `p`.`buyingprice`   AS `buyingprice`,
          `p`.`sellingprice`  AS `sellingprice`,
          `p`.`serializable`  AS `serializable`,
          IFNULL(SUM(IF(`t`.`destinationid` = `s`.`id` AND `t`.`destinationtype` = 'pos' AND `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) 
          +
          IFNULL((SELECT SUM(`quantity`)
          FROM `stockreconciledbalancedetails` rd
          JOIN `stockreconciledbalance` r ON r.`id`=rd.`reconciliationid`
          WHERE `itemid`=p.productid AND DATE(`reconciliationdate`) BETWEEN IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters` WHERE `clientid` = $clientid),'2001-01-01') AND CURRENT_TIMESTAMP()
          AND posid=$sourceid),0)
          AS `unitsreceived`,
          
          IFNULL(SUM(IF(`t`.`sourceid` = `s`.`id` AND `t`.`sourcetype` = 'pos' AND `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) +
          IFNULL((SELECT SUM(quantity) FROM `possales` ps 
            JOIN `possalesdetails` pd ON  pd.`possaleid`=ps.`id`
            WHERE  pd.itemcode=p.productid AND `receiptdate`>=IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters` WHERE `clientid` = $clientid),CURRENT_TIMESTAMP())
            AND ps.`deleted`=0
          ),0)
          AS `issued`
        FROM `stocktransfer` `t`
        INNER JOIN `stocktransferdetails` `td` ON `t`.`id` = `td`.`transferid`
        INNER JOIN `products` `p` ON `td`.`itemcode` = `p`.`productid`
        INNER JOIN `pointsofsale` `s` ON (`s`.`id` = `t`.`sourceid` OR `s`.`id` = `t`.`destinationid`)
        WHERE `t`.`dateadded` >= IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters` WHERE `clientid` = $clientid),CURRENT_TIMESTAMP())
            AND s.id=$sourceid AND p.itemcode=$itemcode AND p.clientid = $clientid;
    END IF;
END$$

-- 10. spsavetempstocktransfer
DROP PROCEDURE IF EXISTS `spsavetempstocktransfer`$$
CREATE PROCEDURE `spsavetempstocktransfer`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $itemcode VARCHAR(50),
    IN $unitprice NUMERIC(10,2),
    IN $quantity NUMERIC(10,2),
    IN $serialno VARCHAR(50)
)
BEGIN
    DECLARE $itemid INT;
    SET $itemid=(SELECT `productid` FROM `products` WHERE `clientid` = $clientid AND `itemcode`=$itemcode);
    INSERT INTO `tempstocktransfer`(`refno`,`itemcode`,`quantity`,`unitprice`,`serialno`)
    VALUES($refno,$itemid,$quantity,$unitprice,$serialno);
END$$

-- 11. spsavestocktransfer
DROP PROCEDURE IF EXISTS `spsavestocktransfer`$$
CREATE PROCEDURE `spsavestocktransfer`(
    IN $branchid INT,
    IN $refno VARCHAR(50),
    IN $sourcetype VARCHAR(50),
    IN $sourceid NUMERIC,
    IN $destinationtype VARCHAR(50),
    IN $destinationid NUMERIC,
    IN $userid NUMERIC,
    IN $issuedto INT,
    IN $storecontroller INT
)
BEGIN
    DECLARE $transferrefno VARCHAR(50);
    DECLARE $id NUMERIC;
    
    START TRANSACTION;
        SET $transferrefno=`fngeneratestocktransaferno`($branchid);
        INSERT INTO `stocktransfer`(`branchid`,`referenceno`,`sourcetype`,`sourceid`,`destinationtype`,`destinationid`,`addedby`,`dateadded`,`issuedto`,`storecontroller`)
        VALUES($branchid,$transferrefno,$sourcetype,$sourceid,$destinationtype,$destinationid,$userid,NOW(),$issuedto,$storecontroller);
        
        SET $id=(SELECT MAX(`id`) FROM `stocktransfer`);
        
        INSERT INTO `stocktransferdetails`(`transferid`,`itemcode`,`quantity`,`unitprice`,`serialno`)
        SELECT $id,`itemcode`,SUM(`quantity`) AS quantity,`unitprice`,`serialno` 
        FROM `tempstocktransfer` WHERE `refno`=$refno 
        GROUP BY $id,`itemcode`,`unitprice`,`serialno`;
        
        UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Stock Transfer' AND `branchid` = $branchid;
        DELETE FROM `tempstocktransfer` WHERE `refno`=$refno;
        SELECT  $transferrefno AS transfercode;        
    COMMIT;
END$$

-- 12. spgetproductdiscountmatrix
DROP PROCEDURE IF EXISTS `spgetproductdiscountmatrix`$$
CREATE PROCEDURE `spgetproductdiscountmatrix`(
    IN $clientid INT,
    IN $itemcode VARCHAR(50)
)
BEGIN
    SELECT c.`id` AS customercategoryid, `description` AS customercategory, `percentage`,`value` 
    FROM `customerpricematrix` m,`customercategories` c, `products` p
    WHERE c.`id`=m.`customercategoryid` AND p.`productid`=m.`itemid` AND p.`itemcode`=$itemcode
    AND p.`clientid` = $clientid AND c.`clientid` = $clientid;
END$$

-- 13. spsavetempreconcilebalancedetails
DROP PROCEDURE IF EXISTS `spsavetempreconcilebalancedetails`$$
CREATE PROCEDURE `spsavetempreconcilebalancedetails`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $itemid INT,
    IN $quantity NUMERIC(18,2),
    IN $unitprice NUMERIC(18,2)
)
BEGIN
    INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
    VALUES($refno,$itemid,$quantity,$unitprice);
END$$

-- 14. spsavestockreconciledbalance
DROP PROCEDURE IF EXISTS `spsavestockreconciledbalance`$$
CREATE PROCEDURE `spsavestockreconciledbalance`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $narration VARCHAR(50),
    IN $posid INT,
    IN $category VARCHAR(50),
    IN $userid INT
)
BEGIN
    START TRANSACTION;
        SET @reconciliationdate= CURDATE();
        SET @basedate=DATE_ADD(@reconciliationdate, INTERVAL -1 DAY);
        
        INSERT INTO `stockreconciledbalance`(`branchid`,`reconciliationdate`,`userid`,`narration`,`posid`,`category`)
        VALUES($clientid,@reconciliationdate,$userid,$narration,$posid,$category);
        
        SET @id=(SELECT MAX(stockreconciledbalanceid) FROM `stockreconciledbalance`);
        
        IF $category='outlet' THEN                 
            INSERT INTO `stockreconciledbalancedetails` (`reconciliationid`,`itemid`,`quantity`,`unitprice`)
            SELECT @id, `itemid`,
                CASE 
                WHEN `fn_getitemstorebalanceasat`(itemid,$posid,@basedate)> `quantity` THEN 
                    -1*(`fn_getitemstorebalanceasat`(itemid,$posid,@basedate)-`quantity`)
                ELSE
                    `quantity`-`fn_getitemstorebalanceasat`(itemid,$posid,@basedate)
                END,`unitprice` 
                FROM `tempstockreconcilebalancedetails` WHERE `refno`=$refno;
        ELSE
            SET @basedate=@reconciliationdate;
            INSERT INTO `stockreconciledbalancedetails` (`reconciliationid`,`itemid`,`quantity`,`unitprice`)
            SELECT @id, `itemid`,
                CASE 
                WHEN `fn_getwarehousestockbalance`(itemid,$posid,@basedate)> `quantity` THEN 
                    -1*(`fn_getwarehousestockbalance`(itemid,$posid,@basedate)-`quantity`)
                ELSE
                    `quantity`-`fn_getwarehousestockbalance`(itemid,$posid,@basedate)
                END,`unitprice` 
            FROM `tempstockreconcilebalancedetails` WHERE `refno`=$refno;
        END IF;
        
        DELETE FROM `tempstockreconcilebalancedetails` WHERE `refno`=$refno;
    COMMIT;    
END$$

-- 15. spgetavailableproductserialnumbers
DROP PROCEDURE IF EXISTS `spgetavailableproductserialnumbers`$$
CREATE PROCEDURE `spgetavailableproductserialnumbers`(
    IN $clientid INT,
    IN $itemid INT
)
BEGIN
    SELECT `serialno` FROM `goodsreceiveddetails` g
    WHERE `serialno` NOT IN(SELECT `serialno` FROM `possalesdetails` WHERE `itemcode`=$itemid)
    AND `itemcode`=$itemid
    ORDER BY `serialno`;
END$$

-- 16. spgetbundleitems
DROP PROCEDURE IF EXISTS `spgetbundleitems`$$
CREATE PROCEDURE `spgetbundleitems`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM products WHERE clientid = $clientid AND bundleitem=1 AND IFNULL(deleted,0)=0
    ORDER BY `itemname`;
END$$

-- 17. spgetitemstatement
DROP PROCEDURE IF EXISTS `spgetitemstatement`$$
CREATE PROCEDURE `spgetitemstatement`(
    IN $clientid INT,
    IN $itemcode VARCHAR(50),
    IN $startdate DATE,
    IN $enddate DATE
)
BEGIN
    DECLARE $productid INT ;
    
    SET @startdate=$startdate;
    SELECT CASE WHEN `cutoffdate`>=@startdate THEN cutoffdate ELSE $startdate END INTO @startdate FROM `startingparameters` WHERE `clientid` = $clientid;
    SET @enddate=$enddate;
    SET @balancedate=DATE_SUB(@startdate, INTERVAL 1 DAY);
    SET @itemcode=$itemcode;
    
    SELECT `productid` INTO $productid 
    FROM `products` WHERE `clientid` = $clientid AND `itemcode`=$itemcode;
    
    SELECT `productid`,`itemcode`,`itemname`,'Opening balance' description,NULL AS reference, DATE_FORMAT(@balancedate,'%d-%b-%Y') AS `date`,0 AS `sortkey`,NULL AS stockin, NULL AS stockout,fn_getitemstockbalance(productid,@balancedate) openingbalance, @balancedate AS unmodifieddate
    FROM `products` WHERE clientid = $clientid AND itemcode=@itemcode
    
    UNION
    
    SELECT productid,itemcode,itemname,'Reconciled balance','<None>' reference,DATE_FORMAT(`reconciliationdate`,'%Y-%b-%d') `date`,1 sortkey,quantity stockin, NULL `stockout`,NULL openingbalance,`reconciliationdate` unmodifieddate
    FROM `stockreconciledbalance` s
    JOIN `stockreconciledbalancedetails` sd ON sd.`reconciliationid`=s.`id` 
    JOIN products p ON p.productid=sd.itemid 
    WHERE p.clientid = $clientid AND `itemid`=$productid AND DATE_FORMAT(`reconciliationdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
    
    UNION
    SELECT productid, p.itemcode,`itemname`, 'Purchase' description, CONCAT(g.`grnno`,' : ',`deliverynono`) reference, DATE_FORMAT(`datereceived`,'%d-%b-%Y') AS `date`,1 AS `sortkey`,SUM(quantity) AS stockin, NULL AS stockout,NULL openingbalance,`datereceived` AS unmodifieddate
    FROM products p INNER JOIN `goodsreceiveddetails` gd ON p.productid=gd.`itemcode`
    INNER JOIN goodsreceived g ON gd.grnno=g.grnno
    WHERE p.clientid = $clientid AND p.itemcode=@itemcode AND DATE_FORMAT(`datereceived`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
    GROUP BY  productid, p.itemcode,`itemname`, DATE_FORMAT(`datereceived`,'%d-%b-%Y'), g.`grnno`,`deliverynono`
    
    UNION
    SELECT productid, p.itemcode,`itemname`, 'Sale' dscription,s.receiptno reference, DATE_FORMAT(`receiptdate`,'%d-%b-%Y') AS `date`,2 AS `sortkey`,NULL  AS stockin,SUM(quantity)AS stockout,NULL openingbalance, receiptdate AS unmodifieddate
    FROM products p INNER JOIN `possalesdetails` pd ON p.productid=pd.`itemcode`
    INNER JOIN `possales` s ON pd.`possaleid`=s.`id`
    WHERE p.clientid = $clientid AND p.itemcode=@itemcode AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND s.deleted=0
    GROUP BY  productid, p.itemcode,`itemname`, DATE_FORMAT(`receiptdate`,'%d-%b-%Y'), receiptno
    ORDER BY unmodifieddate,sortkey;
END$$

-- 18. sp_getcratesummary
DROP PROCEDURE IF EXISTS `sp_getcratesummary`$$
CREATE PROCEDURE `sp_getcratesummary`(
    IN $clientid INT,
    IN $enddate DATE
)
BEGIN
    SET @productid=(SELECT productid FROM `cratesinventorysettings`);
    SET @basedate=DATE_FORMAT(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters` WHERE `clientid` = $clientid),'2020-01-01'),'%Y-%m-%d');
    SET @enddate=$enddate;
    SET @obdate=DATE_SUB(@enddate, INTERVAL 1 DAY);
    SELECT `itemcode` `Product Code`,`itemname` `Product Name`,
        IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
            WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d') BETWEEN @basedate AND @obdate),0)-
        IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
            WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN @basedate AND @obdate AND IFNULL(s.deleted,0)=0),0) AS `openingbalance`,
        
        IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
            WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d')=@enddate),0)+
        IFNULL((SELECT SUM(quantity) FROM `cratesinventory` WHERE `narration`='Crate deposit refund' AND DATE_FORMAT(`dateadded`,'%Y-%m-%d')=@enddate),0)
        AS `purchases` ,
        
        IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
            WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d')=@enddate AND IFNULL(s.deleted,0)=0),0) AS `sales`,
            
        IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
            WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d') BETWEEN @basedate AND @obdate),0)-
        IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
            WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid &&  DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN @basedate AND @obdate  AND IFNULL(s.deleted,0)=0),0) +
        
        IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
            WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d')=@enddate),0) +
        IFNULL((SELECT SUM(quantity) FROM `cratesinventory` WHERE `narration`='Crate deposit refund' AND DATE_FORMAT(`dateadded`,'%Y-%m-%d')=@enddate),0)
        -
        IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
            WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d')=@enddate AND IFNULL(s.deleted,0)=0),0) AS `closingbalance`
    FROM products p    WHERE p.clientid = $clientid AND p.productid=@productid;
END$$

-- 19. sp_getreturnableproducts
DROP PROCEDURE IF EXISTS `sp_getreturnableproducts`$$
CREATE PROCEDURE `sp_getreturnableproducts`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `products`
    WHERE `clientid` = $clientid AND `allowreturnexchange`=1
    ORDER BY `itemname`;
END$$

-- 20. sp_savebranch
DROP PROCEDURE IF EXISTS `sp_savebranch`$$
CREATE PROCEDURE `sp_savebranch`(
    IN $branchid INT,
    IN $branchname VARCHAR(100),
    IN $location VARCHAR(100),
    IN $clientid INT,
    IN $userid INT
)
BEGIN
    IF $branchid = 0 THEN
        INSERT INTO branches (branchname, location, clientid, addedby, dateadded)
        VALUES ($branchname, $location, $clientid, $userid, NOW());
    ELSE
        UPDATE branches SET 
            branchname = $branchname,
            location = $location,
            lastupdatedby = $userid,
            lastdateupdated = NOW()
        WHERE branchid = $branchid AND clientid = $clientid;
    END IF;
END$$

-- 21. sp_checkbranch
DROP PROCEDURE IF EXISTS `sp_checkbranch`$$
CREATE PROCEDURE `sp_checkbranch`(
    IN $branchid INT, 
    IN $branchname VARCHAR(100), 
    IN $clientid INT
)
BEGIN
    SELECT branchid FROM branches 
    WHERE branchname = $branchname AND branchid != $branchid AND clientid = $clientid AND deleted = 0;
END$$

-- 22. spsavetempsupplierinvoice
DROP PROCEDURE IF EXISTS `spsavetempsupplierinvoice`$$
CREATE PROCEDURE `spsavetempsupplierinvoice`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $grnno VARCHAR(50)
)
BEGIN
    INSERT INTO `tempsupplierinvoice`(`refno`,`grnno`)
    VALUES($refno,$grnno);
END$$

-- 23. spsavesupplierinvoice
DROP PROCEDURE IF EXISTS `spsavesupplierinvoice`$$
CREATE PROCEDURE `spsavesupplierinvoice`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $invoiceno VARCHAR(50),
    IN $supplierid INT,
    IN $invoicedate DATETIME,
    IN $userid INT
)
BEGIN
    DECLARE $id INT;
    DECLARE $inventoryaccount INT;
    DECLARE $suppliercontrolaccount INT;
    DECLARE $suppliername VARCHAR(100);
    DECLARE $description VARCHAR(1000);
    DECLARE $total NUMERIC(10,2);
    
    START TRANSACTION;
        SET $suppliername=(SELECT `suppliername` FROM `suppliers` WHERE `clientid` = $clientid AND `supplierid`=$supplierid);
        SET $description=CONCAT('Invoice #',$invoiceno,' received from ',$suppliername);
        
        SET $total=(SELECT SUM(g.`quantity`* pod.`unitprice`) FROM `tempsupplierinvoice` t, `products` p,
        `goodsreceiveddetails` g, `purchaseorders` po, `purchaseorderdetails` pod
        WHERE g.`grnno`=t.`grnno` AND g.`itemcode`=p.`productid` AND g.`purchaseorderno`=po.`purchaseorderno` AND po.`purchaseorderid`=pod.`purchaseorderid`
        AND p.productid=pod.itemcode AND t.refno=$refno AND p.clientid = $clientid);
        
        SET $suppliercontrolaccount=(SELECT `id` FROM `glaccounts` WHERE `clientid` = $clientid AND `accountcode`=(SELECT `account` FROM `glaccountsettings` WHERE `clientid` = $clientid AND `description`='Suppliers Control Account'));
        SET $inventoryaccount=(SELECT `id` FROM `glaccounts` WHERE `clientid` = $clientid AND `accountcode`=(SELECT `account` FROM `glaccountsettings` WHERE `clientid` = $clientid AND `description`='Cost of Goods Sold'));
        
        INSERT INTO `supplierinvoice`(`supplierid`,`invoiceno`,`invoicedate`,`addedby`,`dateadded`,`clientid`)
        VALUES($supplierid,$invoiceno,$invoicedate,$userid,NOW(),$clientid);
        
        SET $id=(SELECT MAX(`supplierinvoiceid`) FROM `supplierinvoice`);
        
        INSERT INTO `supplierinvoicedetails`(`invoiceid`,`referenceno`,`itemcode`,`description`,`quantity`,`unitprice`)
        SELECT $id,g.`grnno`,g.`itemcode`, p.`itemname`, g.`quantity`, pod.`unitprice` FROM `tempsupplierinvoice` t, `products` p,
        `goodsreceiveddetails` g, `purchaseorders` po, `purchaseorderdetails` pod
        WHERE g.`grnno`=t.`grnno` AND g.`itemcode`=p.`productid` AND g.`purchaseorderno`=po.`purchaseorderno` AND po.`purchaseorderid`=pod.`purchaseorderid`
        AND p.productid=pod.itemcode AND t.refno=$refno AND p.clientid = $clientid;
        
        UPDATE `goodsreceived` SET `invoiced`=1, `invoiceno`=$id, `status`='Invoiced' WHERE `grnno` IN(SELECT grnno FROM `tempsupplierinvoice` WHERE `refno`=$refno);
        
        INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
        VALUES($invoiceno,NOW(),$suppliercontrolaccount, $inventoryaccount, $description,0,$total,$userid) ;
        
        INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
        VALUES($invoiceno,NOW(), $inventoryaccount,$suppliercontrolaccount, $description,$total,0,$userid) ;
        
        DELETE FROM `tempsupplierinvoice` WHERE `refno`=$refno;
    COMMIT;
END$$

-- 24. spgetroleusers
DROP PROCEDURE IF EXISTS `spgetroleusers`$$
CREATE PROCEDURE `spgetroleusers`(
    IN $clientid INT,
    IN $roleid INT
)
BEGIN
    SELECT r.`userid`, `username`,`firstname`,`middlename`,`lastname` FROM `roleusers` r, `user` u
    WHERE r.`userid`=u.`userid` AND `roleid`=$roleid AND u.`clientid` = $clientid
    ORDER BY `firstname`,`middlename`,`lastname`;
END$$

-- 25. spgetroledetails
DROP PROCEDURE IF EXISTS `spgetroledetails`$$
CREATE PROCEDURE `spgetroledetails`(
    IN $clientid INT,
    IN $roleid INT
)
BEGIN
    SELECT * FROM `roles` WHERE `clientid` = $clientid AND `roleid`=$roleid;
END$$

-- 26. spgetrolesforuserassignment
DROP PROCEDURE IF EXISTS `spgetrolesforuserassignment`$$
CREATE PROCEDURE `spgetrolesforuserassignment`(
    IN $clientid INT
)
BEGIN
    SELECT `roleid`,`rolename` FROM `roles` WHERE `clientid` = $clientid ORDER BY `rolename`;
END$$

-- 27. spgetroleprivileges
DROP PROCEDURE IF EXISTS `spgetroleprivileges`$$
CREATE PROCEDURE `spgetroleprivileges`(
    IN $clientid INT,
    IN $roleid INT
)
BEGIN
    SELECT rp.* FROM `roleprivileges` rp
    JOIN `roles` r ON rp.`roleid` = r.`roleid`
    WHERE r.`clientid` = $clientid AND rp.`roleid`=$roleid;
END$$

-- 28. spgetuserprivileges
DROP PROCEDURE IF EXISTS `spgetuserprivileges`$$
CREATE PROCEDURE `spgetuserprivileges`(
    IN $clientid INT,
    IN $userid INT,
    IN $branchid INT
)
BEGIN
    SELECT up.* FROM `userprivileges` up
    JOIN `user` u ON up.`userid` = u.`userid`
    WHERE u.`clientid` = $clientid AND up.userid=$userid;
END$$

-- 29. spsavetempprivilege
DROP PROCEDURE IF EXISTS `spsavetempprivilege`$$
CREATE PROCEDURE `spsavetempprivilege`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $id INT,
    IN $objectid INT,
    IN $valid BIT
)
BEGIN
    INSERT INTO `tempprivilege`(`refno`,`id`,`objectid`,`valid`)
    VALUES($refno,$id,$objectid,$valid);
END$$

-- 30. spcheckrole
DROP PROCEDURE IF EXISTS `spcheckrole`$$
CREATE PROCEDURE `spcheckrole`(
    IN $clientid INT,
    IN $roleid INT,
    IN $rolename VARCHAR(50)
)
BEGIN
    SELECT * 
    FROM `roles` 
    WHERE `clientid` = $clientid AND `roleid`<>$roleid AND `rolename`=$rolename;
END$$

-- 31. spsaveprivileges
DROP PROCEDURE IF EXISTS `spsaveprivileges`$$
CREATE PROCEDURE `spsaveprivileges`(
    IN $clientid INT,
    IN $id INT,
    IN $category VARCHAR(50),
    IN $refno VARCHAR(50),
    IN $userid INT
)
BEGIN
    START TRANSACTION;
        IF $category='user' THEN 
            BEGIN
                DELETE FROM `userprivileges` WHERE `userid`=$id;
                INSERT INTO `userprivileges` (`userid`,`objectid`,`allowed`,`addedby`,`lastupdatedby`,`lastdateupdated`)
                SELECT $id,`objectid`,`valid`,$userid,$userid,NOW() FROM `tempprivilege` WHERE `refno`=$refno;
            END;
        ELSE
            BEGIN
                DELETE FROM `roleprivileges` WHERE `roleid`=$id;
                INSERT INTO `roleprivileges`(`roleid`,`objectid`,`allowed`,`dateadded`,`addedby`)
                SELECT $id,`objectid`,`valid`,NOW(),$userid FROM `tempprivilege` WHERE `refno`=$refno; 
            END;
        END IF;
        DELETE FROM `tempprivilege` WHERE `refno`=$refno;
    COMMIT;
END$$

-- 32. spsaverole
DROP PROCEDURE IF EXISTS `spsaverole`$$
CREATE PROCEDURE `spsaverole`(
    IN $clientid INT,
    IN $roleid INT,
    IN $rolename VARCHAR(50),
    IN $roledescription VARCHAR(50),
    IN $userid INT
)
BEGIN
    IF $roleid=0 THEN
        INSERT INTO `roles` (`rolename`,`roledescription`,`deleted`,`addedby`,`dateadded`,`clientid`)
        VALUES($rolename,$roledescription,0,$userid,NOW(),$clientid);
        SET $roleid=(SELECT MAX(`roleid`) `roleid` FROM `roles` WHERE `clientid` = $clientid);
    ELSE
        UPDATE `roles` SET `rolename`=$rolename,`roledescription`=$roledescription, `lastdatemodified`=NOW(), `lastmodifiedby`=$userid
        WHERE `roleid`=$roleid AND `clientid` = $clientid;
    END IF;
    SELECT $roleid AS `roleid`;
END$$

-- 33. spsaveroleusers
DROP PROCEDURE IF EXISTS `spsaveroleusers`$$
CREATE PROCEDURE `spsaveroleusers`(
    IN $clientid INT,
    IN $userid INT,
    IN $roleid INT,
    IN $addedby INT
)
BEGIN
    IF NOT EXISTS (SELECT * FROM `roleusers` WHERE `roleid`=$roleid AND `userid`=$userid AND IFNULL(`deleted`,0)=0) THEN
        INSERT INTO `roleusers`(`roleid`,`userid`,`dateadded`,`addedby`)
        VALUES($roleid,$userid,NOW(),$addedby);
    END IF;
END$$

DELIMITER ;
