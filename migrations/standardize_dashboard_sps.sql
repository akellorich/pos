-- Standardize Dashboard Stored Procedures

-- 1. Dashboard Headers
DROP PROCEDURE IF EXISTS spgetdashboardheaders;
DELIMITER //
CREATE PROCEDURE `spgetdashboardheaders`(IN $branchid INT, IN $date DATE)
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM customers WHERE branchid = $branchid) AS activecustomers,
        (SELECT IFNULL(SUM(invoiceamount - invoicepayment), 0) FROM vwcustomerstomerstatement WHERE clientid = $branchid) AS openreceivables,
        (SELECT IFNULL(SUM(invoiceamount - settled), 0) FROM vwopenpayables) AS openpayables,
        (SELECT COUNT(*) FROM vwopenorders) AS openorders;
END //
DELIMITER ;

-- 2. Reorder Items
DROP PROCEDURE IF EXISTS spgetreorderitems;
DELIMITER //
CREATE PROCEDURE `spgetreorderitems`(IN $branchid INT)
BEGIN
    -- This assumes products table and reorderlevel column exist
    -- And a view for stock balances
    SELECT 
        p.itemname AS name,
        p.itemcode AS code,
        IFNULL(b.balance, 0) AS stock,
        p.reorderlevel AS reorder,
        'N/A' AS supplier
    FROM products p
    LEFT JOIN (
        SELECT productid, SUM(balance) AS balance 
        FROM vwpointofsaleitembalances 
        WHERE branchid = $branchid 
        GROUP BY productid
    ) b ON p.productid = b.productid
    WHERE IFNULL(b.balance, 0) <= p.reorderlevel
    LIMIT 10;
END //
DELIMITER ;

-- 3. Customer Performance
DROP PROCEDURE IF EXISTS spgetcustomerperformance;
DELIMITER //
CREATE PROCEDURE `spgetcustomerperformance`(IN $branchid INT, IN $startdate DATE, IN $enddate DATE)
BEGIN
    SELECT 
        c.customername AS name,
        'Regular Account' AS type,
        SUM(v.receipttotal) AS revenue,
        ROUND((SUM(v.receipttotal) / (SELECT SUM(receipttotal) FROM vwsalessummary2 WHERE branchid = $branchid AND DATE(transactiondate) BETWEEN $startdate AND $enddate) * 100), 1) AS share,
        'person' AS icon
    FROM vwsalessummary2 v
    JOIN customers c ON v.customerid = c.customerid
    WHERE v.branchid = $branchid AND DATE(v.transactiondate) BETWEEN $startdate AND $enddate
    GROUP BY v.customerid, c.customername
    ORDER BY revenue DESC
    LIMIT 4;
END //
DELIMITER ;

-- 4. Standardize Sales By Customer Count
DROP PROCEDURE IF EXISTS spgetsalesbycustomercount;
DELIMITER //
CREATE PROCEDURE `spgetsalesbycustomercount`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50))
BEGIN
	IF $daterange='Day' THEN
		SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`, 
		COUNT(IF(customername='WALKIN CUSTOMER',receiptno,NULL)) AS `walkin`, 
		COUNT(IF(customername<>'WALKIN CUSTOMER',receiptno,NULL)) AS `Regular` 
		FROM `vwsalessummary2` v
		WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN DATE($startdate) AND DATE($enddate)
		GROUP BY DATE_FORMAT(transactiondate,'%H') 
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Week' THEN
		SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`, 
		COUNT(IF(customername='WALKIN CUSTOMER',receiptno,NULL)) AS `walkin`, 
		COUNT(IF(customername<>'WALKIN CUSTOMER',receiptno,NULL)) AS `Regular` 
		FROM `vwsalessummary2` v
		WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN DATE($startdate) AND DATE($enddate)
		GROUP BY DATE_FORMAT(transactiondate,'%a') 
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Month' THEN
		SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`, 
		COUNT(IF(customername='WALKIN CUSTOMER',receiptno,NULL)) AS `walkin`, 
		COUNT(IF(customername<>'WALKIN CUSTOMER',receiptno,NULL)) AS `Regular` 
		FROM `vwsalessummary2` v
		WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN DATE($startdate) AND DATE($enddate)
		GROUP BY DATE_FORMAT(transactiondate,'%d') 
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Year' THEN
		SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`, 
		COUNT(IF(customername='WALKIN CUSTOMER',receiptno,NULL)) AS `walkin`, 
		COUNT(IF(customername<>'WALKIN CUSTOMER',receiptno,NULL)) AS `Regular` 
		FROM `vwsalessummary2` v
		WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN DATE($startdate) AND DATE($enddate)
		GROUP BY DATE_FORMAT(transactiondate,'%b') 
		ORDER BY v.transactiondate;
	END IF;
END //
DELIMITER ;

-- 5. Standardize Sales By Outlet
DROP PROCEDURE IF EXISTS spgetsalesbyoutlet;
DELIMITER //
CREATE PROCEDURE `spgetsalesbyoutlet`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
	SELECT pointofsale,SUM(receipttotal) AS total 
	FROM `vwsalessummary2` 
	WHERE branchid = $branchid AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
	GROUP BY pointofsale
	ORDER BY SUM(receipttotal) DESC;
END //
DELIMITER ;

-- 6. Standardize Sales By Salesperson
DROP PROCEDURE IF EXISTS spgetsalesbysalesperson;
DELIMITER //
CREATE PROCEDURE `spgetsalesbysalesperson`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
	SELECT userfullname,SUM(receipttotal) AS total 
	FROM `vwsalessummary2` 
	WHERE branchid = $branchid AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
	GROUP BY userfullname
	ORDER BY SUM(receipttotal) DESC;
END //
DELIMITER ;

-- 7. Standardize Best Selling Category
DROP PROCEDURE IF EXISTS spgetbestsellingcategory;
DELIMITER //
CREATE PROCEDURE `spgetbestsellingcategory`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
    SELECT `categoryname`, SUM(s.`quantity`) quantity, AVG(s.`unitprice`) unitprice
    FROM `categories` c,`products` p,`possales` o,`possalesdetails` s
    WHERE c.`categoryid`=p.`categoryid` AND p.`productid`=s.`itemcode` AND s.`possaleid`=o.possaleid
    AND o.branchid = $branchid AND DATE(o.`receiptdate`) BETWEEN DATE($startdate) AND DATE($enddate)
    GROUP BY `categoryname`
    ORDER BY SUM(quantity) DESC 
    LIMIT 5;
END //
DELIMITER ;

-- 8. Standardize Sale By Customer Value
DROP PROCEDURE IF EXISTS spgetsalebycustomervalue;
DELIMITER //
CREATE PROCEDURE `spgetsalebycustomervalue`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50))
BEGIN
	IF $daterange='Day' THEN
		SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,
		IFNULL(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
		IFNULL(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
		FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
		GROUP BY DATE_FORMAT(transactiondate,'%H') 
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Week' THEN
		SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,
		IFNULL(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
		IFNULL(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
		FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
		GROUP BY DATE_FORMAT(transactiondate,'%a')
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Month' THEN
		SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,
		IFNULL(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
		IFNULL(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
		FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
		GROUP BY DATE_FORMAT(transactiondate,'%d') 
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Year' THEN
		SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,
		IFNULL(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
		IFNULL(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
		FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
		GROUP BY DATE_FORMAT(transactiondate,'%b')
		ORDER BY v.transactiondate;
	END IF;
END //
DELIMITER ;
