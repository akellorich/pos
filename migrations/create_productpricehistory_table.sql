-- Create table productpricehistory
CREATE TABLE IF NOT EXISTS `productpricehistory` (
    `priceid` INT AUTO_INCREMENT PRIMARY KEY,
    `productid` INT NOT NULL,
    `price` DECIMAL(18,2) NOT NULL,
    `addedby` INT NOT NULL,
    `dateadded` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Stored procedure to save product price history
DROP PROCEDURE IF EXISTS `spsaveproductpricehistory`;
DELIMITER $$
CREATE PROCEDURE `spsaveproductpricehistory`(
    IN $productid INT,
    IN $price DECIMAL(18,2),
    IN $userid INT
)
BEGIN
    INSERT INTO `productpricehistory` (`productid`, `price`, `addedby`, `dateadded`)
    VALUES ($productid, $price, $userid, NOW());
END$$
DELIMITER ;

-- Update spsaveproduct to call spsaveproductpricehistory on price changes
DROP PROCEDURE IF EXISTS `spsaveproduct`;
DELIMITER $$
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
        
        SET $id=(SELECT LAST_INSERT_ID());
        -- Save initial price history
        CALL spsaveproductpricehistory($id, $sellingprice, $userid);
    ELSE
        -- Check for changes in selling price before updating products
        IF (SELECT IFNULL(`sellingprice`, 0) FROM `products` WHERE clientid = $clientid AND `productid`=$id) != $sellingprice THEN
            CALL spsaveproductpricehistory($id, $sellingprice, $userid);
        END IF;

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

-- Create stored procedures to get product history data
DROP PROCEDURE IF EXISTS `spgetproductpricinghistory`;
DELIMITER $$
CREATE PROCEDURE `spgetproductpricinghistory`(
    IN $productid INT,
    IN $price_type VARCHAR(20),
    IN $startdate DATE,
    IN $enddate DATE
)
BEGIN
    IF $price_type = 'purchase' THEN
        SELECT DATE_FORMAT(g.datereceived, '%d-%b-%Y') AS date, 
               pod.unitprice AS buying, 
               '' AS selling, 
               '' AS margin, 
               g.datereceived AS unmodifieddate
        FROM goodsreceiveddetails gd
        JOIN goodsreceived g ON gd.grnno = g.grnno
        JOIN purchaseorders po ON po.purchaseorderno = gd.purchaseorderno
        JOIN purchaseorderdetails pod ON pod.purchaseorderid = po.purchaseorderid AND pod.itemcode = gd.itemcode
        WHERE gd.itemcode = $productid AND DATE(g.datereceived) BETWEEN $startdate AND $enddate
        ORDER BY g.datereceived DESC;
    ELSEIF $price_type = 'selling' THEN
        SELECT DATE_FORMAT(h.dateadded, '%d-%b-%Y') AS date, 
               '' AS buying, 
               h.price AS selling, 
               '' AS margin, 
               h.dateadded AS unmodifieddate
        FROM productpricehistory h
        WHERE h.productid = $productid AND DATE(h.dateadded) BETWEEN $startdate AND $enddate
        ORDER BY h.dateadded DESC;
    ELSE
        SELECT DATE_FORMAT(date, '%d-%b-%Y') AS date, buying, selling, margin, unmodifieddate
        FROM (
            SELECT g.datereceived AS date, 
                   pod.unitprice AS buying, 
                   '' AS selling, 
                   '' AS margin, 
                   g.datereceived AS unmodifieddate
            FROM goodsreceiveddetails gd
            JOIN goodsreceived g ON gd.grnno = g.grnno
            JOIN purchaseorders po ON po.purchaseorderno = gd.purchaseorderno
            JOIN purchaseorderdetails pod ON pod.purchaseorderid = po.purchaseorderid AND pod.itemcode = gd.itemcode
            WHERE gd.itemcode = $productid AND DATE(g.datereceived) BETWEEN $startdate AND $enddate
            
            UNION ALL
            
            SELECT h.dateadded AS date, 
                   '' AS buying, 
                   h.price AS selling, 
                   '' AS margin, 
                   h.dateadded AS unmodifieddate
            FROM productpricehistory h
            WHERE h.productid = $productid AND DATE(h.dateadded) BETWEEN $startdate AND $enddate
        ) combined
        ORDER BY unmodifieddate DESC;
    END IF;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spgetproductpurchasehistory`;
DELIMITER $$
CREATE PROCEDURE `spgetproductpurchasehistory`(
    IN $productid INT,
    IN $startdate DATE,
    IN $enddate DATE
)
BEGIN
    SELECT DATE_FORMAT(g.datereceived, '%d-%b-%Y') AS date, 
           sup.suppliername, 
           gd.purchaseorderno, 
           g.invoiceno, 
           DATE_FORMAT(g.datereceived, '%d-%b-%Y') AS deliverydate, 
           gd.quantity, 
           pod.unitprice, 
           (gd.quantity * pod.unitprice) AS total
    FROM goodsreceiveddetails gd
    JOIN goodsreceived g ON gd.grnno = g.grnno
    JOIN suppliers sup ON g.supplierid = sup.supplierid
    LEFT JOIN purchaseorders po ON po.purchaseorderno = gd.purchaseorderno
    LEFT JOIN purchaseorderdetails pod ON pod.purchaseorderid = po.purchaseorderid AND pod.itemcode = gd.itemcode
    WHERE gd.itemcode = $productid AND DATE(g.datereceived) BETWEEN $startdate AND $enddate
    ORDER BY g.datereceived DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spgetproductsaleshistory`;
DELIMITER $$
CREATE PROCEDURE `spgetproductsaleshistory`(
    IN $productid INT,
    IN $startdate DATE,
    IN $enddate DATE
)
BEGIN
    SELECT DATE_FORMAT(s.receiptdate, '%d-%b-%Y') AS date, 
           IFNULL(c.customername, 'Cash Customer') AS customername, 
           s.receiptno, 
           sd.quantity, 
           (sd.unitprice - IFNULL(sd.discount, 0)) AS unitprice, 
           (sd.quantity * (sd.unitprice - IFNULL(sd.discount, 0))) AS total, 
           CONCAT(u.firstname, ' ', u.lastname) AS transactedby
    FROM possalesdetails sd
    JOIN possales s ON sd.possaleid = s.possaleid
    LEFT JOIN customers c ON s.customerid = c.customerid
    LEFT JOIN user u ON s.addedby = u.userid
    WHERE sd.itemcode = $productid AND DATE(s.receiptdate) BETWEEN $startdate AND $enddate AND IFNULL(s.deleted, 0) = 0
    ORDER BY s.receiptdate DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spgetproducttransfershistory`;
DELIMITER $$
CREATE PROCEDURE `spgetproducttransfershistory`(
    IN $productid INT,
    IN $source_type VARCHAR(50),
    IN $source_id INT,
    IN $dest_type VARCHAR(50),
    IN $dest_id INT,
    IN $startdate DATE,
    IN $enddate DATE
)
BEGIN
    SELECT DATE_FORMAT(s.dateadded, '%d-%b-%Y') AS date,
           CONCAT('Transfer: ', s.sourcetype, ' (', 
                  CASE WHEN s.sourcetype = 'warehouse' THEN (SELECT description FROM warehouses WHERE id = s.sourceid) 
                       ELSE (SELECT posname FROM pointsofsale WHERE id = s.sourceid) END, 
                  ') -> ', s.destinationtype, ' (', 
                  CASE WHEN s.destinationtype = 'warehouse' THEN (SELECT description FROM warehouses WHERE id = s.destinationid) 
                       ELSE (SELECT posname FROM pointsofsale WHERE id = s.destinationid) END, ')') AS narration,
           s.referenceno AS reference,
           sd.quantity AS stockin,
           sd.quantity AS stockout,
           0 AS balance
    FROM stocktransferdetails sd
    JOIN stocktransfer s ON sd.transferid = s.stocktransferid
    WHERE sd.itemcode = $productid 
      AND DATE(s.dateadded) BETWEEN $startdate AND $enddate
      AND ($source_type = '0' OR s.sourcetype = $source_type)
      AND ($source_id = 0 OR s.sourceid = $source_id)
      AND ($dest_type = '0' OR s.destinationtype = $dest_type)
      AND ($dest_id = 0 OR s.destinationid = $dest_id)
    ORDER BY s.dateadded DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spgetproductspoilagehistory`;
DELIMITER $$
CREATE PROCEDURE `spgetproductspoilagehistory`(
    IN $productid INT,
    IN $categoryid INT,
    IN $startdate DATE,
    IN $enddate DATE
)
BEGIN
    SELECT DATE_FORMAT(s.dateadded, '%d-%b-%Y') AS date,
           sc.categoryname AS type,
           s.quantity,
           p.buyingprice AS unitprice,
           (s.quantity * p.buyingprice) AS total,
           CONCAT(u.firstname, ' ', u.lastname) AS addedby
    FROM spoilage s
    JOIN products p ON s.productid = p.productid
    JOIN spoilagecategory sc ON s.categoryid = sc.id
    LEFT JOIN user u ON s.addedby = u.userid
    WHERE s.productid = $productid 
      AND DATE(s.dateadded) BETWEEN $startdate AND $enddate
      AND ($categoryid = 0 OR s.categoryid = $categoryid)
    ORDER BY s.dateadded DESC;
END$$
DELIMITER ;
