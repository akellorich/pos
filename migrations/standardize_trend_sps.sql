-- Standardize Dashboard Trend Stored Procedures for accurate Year/Month/Week/Day reporting
-- This script updates spgetsalestrend, spgetsalesbyquantity, spgetsalesbycustomercount, and spgetsalebycustomervalue
-- Fixed: Removed ambiguous grouping to ensure proper summarization by month/day/etc.

-- 1. Update spgetsalestrend
DROP PROCEDURE IF EXISTS spgetsalestrend;
DELIMITER //
CREATE PROCEDURE `spgetsalestrend`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50), IN $userid INT)
BEGIN
    SELECT 
        CASE 
            WHEN $daterange='Day' THEN DATE_FORMAT(transactiondate,'%H:00')
            WHEN $daterange='Week' THEN DATE_FORMAT(transactiondate,'%a')
            WHEN $daterange='Month' THEN DATE_FORMAT(transactiondate,'%d')
            WHEN $daterange='Year' THEN DATE_FORMAT(transactiondate,'%b')
            ELSE DATE_FORMAT(transactiondate,'%Y-%m-%d')
        END AS `transactiondate`,
        SUM(receipttotal) AS amount
    FROM `vwsalessummary2`
    WHERE branchid = $branchid 
    AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
    AND ($userid = 0 OR userid = $userid)
    GROUP BY 
        CASE 
            WHEN $daterange='Day' THEN HOUR(transactiondate)
            WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate)
            WHEN $daterange='Month' THEN DAY(transactiondate)
            WHEN $daterange='Year' THEN MONTH(transactiondate)
            ELSE DATE(transactiondate)
        END,
        1 -- Refer to the first column (the CASE result alias) to ensure summarization
    ORDER BY 
        CASE 
            WHEN $daterange='Day' THEN HOUR(transactiondate)
            WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate)
            WHEN $daterange='Month' THEN DAY(transactiondate)
            WHEN $daterange='Year' THEN MONTH(transactiondate)
            ELSE DATE(transactiondate)
        END;
END //

-- 2. Update spgetsalesbyquantity
DROP PROCEDURE IF EXISTS spgetsalesbyquantity;
CREATE PROCEDURE `spgetsalesbyquantity`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50), IN $userid INT)
BEGIN
    SELECT 
        CASE 
            WHEN $daterange='Day' THEN DATE_FORMAT(transactiondate,'%H:00')
            WHEN $daterange='Week' THEN DATE_FORMAT(transactiondate,'%a')
            WHEN $daterange='Month' THEN DATE_FORMAT(transactiondate,'%d')
            WHEN $daterange='Year' THEN DATE_FORMAT(transactiondate,'%b')
            ELSE DATE_FORMAT(transactiondate,'%Y-%m-%d')
        END AS `transactiondate`,
        SUM(quantity) AS quantity
    FROM `vwsalessummary2`
    WHERE branchid = $branchid 
    AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
    AND ($userid = 0 OR userid = $userid)
    GROUP BY 
        CASE 
            WHEN $daterange='Day' THEN HOUR(transactiondate)
            WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate)
            WHEN $daterange='Month' THEN DAY(transactiondate)
            WHEN $daterange='Year' THEN MONTH(transactiondate)
            ELSE DATE(transactiondate)
        END,
        1
    ORDER BY 
        CASE 
            WHEN $daterange='Day' THEN HOUR(transactiondate)
            WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate)
            WHEN $daterange='Month' THEN DAY(transactiondate)
            WHEN $daterange='Year' THEN MONTH(transactiondate)
            ELSE DATE(transactiondate)
        END;
END //

-- 3. Update spgetsalesbycustomercount
DROP PROCEDURE IF EXISTS spgetsalesbycustomercount;
CREATE PROCEDURE `spgetsalesbycustomercount`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50))
BEGIN
    SELECT 
        CASE 
            WHEN $daterange='Day' THEN DATE_FORMAT(transactiondate,'%H:00')
            WHEN $daterange='Week' THEN DATE_FORMAT(transactiondate,'%a')
            WHEN $daterange='Month' THEN DATE_FORMAT(transactiondate,'%d')
            WHEN $daterange='Year' THEN DATE_FORMAT(transactiondate,'%b')
            ELSE DATE_FORMAT(transactiondate,'%Y-%m-%d')
        END AS `transactiondate`,
        COUNT(DISTINCT IF(customername='WALKIN CUSTOMER', receiptno, NULL)) AS `walkin`, 
        COUNT(DISTINCT IF(customername<>'WALKIN CUSTOMER', receiptno, NULL)) AS `Regular` 
    FROM `vwsalessummary2`
    WHERE branchid = $branchid 
    AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
    GROUP BY 
        CASE 
            WHEN $daterange='Day' THEN HOUR(transactiondate)
            WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate)
            WHEN $daterange='Month' THEN DAY(transactiondate)
            WHEN $daterange='Year' THEN MONTH(transactiondate)
            ELSE DATE(transactiondate)
        END,
        1
    ORDER BY 
        CASE 
            WHEN $daterange='Day' THEN HOUR(transactiondate)
            WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate)
            WHEN $daterange='Month' THEN DAY(transactiondate)
            WHEN $daterange='Year' THEN MONTH(transactiondate)
            ELSE DATE(transactiondate)
        END;
END //

-- 4. Update spgetsalebycustomervalue
DROP PROCEDURE IF EXISTS spgetsalebycustomervalue;
CREATE PROCEDURE `spgetsalebycustomervalue`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50))
BEGIN
    SELECT 
        CASE 
            WHEN $daterange='Day' THEN DATE_FORMAT(transactiondate,'%H:00')
            WHEN $daterange='Week' THEN DATE_FORMAT(transactiondate,'%a')
            WHEN $daterange='Month' THEN DATE_FORMAT(transactiondate,'%d')
            WHEN $daterange='Year' THEN DATE_FORMAT(transactiondate,'%b')
            ELSE DATE_FORMAT(transactiondate,'%Y-%m-%d')
        END AS `transactiondate`,
        IFNULL(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
        IFNULL(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
    FROM `vwsalessummary2`
    WHERE branchid = $branchid 
    AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
    GROUP BY 
        CASE 
            WHEN $daterange='Day' THEN HOUR(transactiondate)
            WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate)
            WHEN $daterange='Month' THEN DAY(transactiondate)
            WHEN $daterange='Year' THEN MONTH(transactiondate)
            ELSE DATE(transactiondate)
        END,
        1
    ORDER BY 
        CASE 
            WHEN $daterange='Day' THEN HOUR(transactiondate)
            WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate)
            WHEN $daterange='Month' THEN DAY(transactiondate)
            WHEN $daterange='Year' THEN MONTH(transactiondate)
            ELSE DATE(transactiondate)
        END;
END //

DELIMITER ;
