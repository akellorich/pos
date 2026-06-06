DELIMITER $$

USE `pos`$$

-- 1. spgetsalebycustomervalue
DROP PROCEDURE IF EXISTS `spgetsalebycustomervalue`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetsalebycustomervalue`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50))
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
        CASE WHEN $daterange='Day' THEN HOUR(transactiondate) END ASC,
        CASE WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate) END ASC,
        CASE WHEN $daterange='Month' THEN DAY(transactiondate) END ASC,
        CASE WHEN $daterange='Year' THEN MONTH(transactiondate) END ASC,
        CASE WHEN $daterange NOT IN ('Day','Week','Month','Year') THEN DATE(transactiondate) END ASC;
END$$

-- 2. spgetsalesbycustomercount
DROP PROCEDURE IF EXISTS `spgetsalesbycustomercount`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetsalesbycustomercount`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50))
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
        CASE WHEN $daterange='Day' THEN HOUR(transactiondate) END ASC,
        CASE WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate) END ASC,
        CASE WHEN $daterange='Month' THEN DAY(transactiondate) END ASC,
        CASE WHEN $daterange='Year' THEN MONTH(transactiondate) END ASC,
        CASE WHEN $daterange NOT IN ('Day','Week','Month','Year') THEN DATE(transactiondate) END ASC;
END$$

-- 3. spgetsalesbyquantity
DROP PROCEDURE IF EXISTS `spgetsalesbyquantity`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetsalesbyquantity`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50), IN $userid INT)
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
        CASE WHEN $daterange='Day' THEN HOUR(transactiondate) END ASC,
        CASE WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate) END ASC,
        CASE WHEN $daterange='Month' THEN DAY(transactiondate) END ASC,
        CASE WHEN $daterange='Year' THEN MONTH(transactiondate) END ASC,
        CASE WHEN $daterange NOT IN ('Day','Week','Month','Year') THEN DATE(transactiondate) END ASC;
END$$

-- 4. spgetsalestrend
DROP PROCEDURE IF EXISTS `spgetsalestrend`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetsalestrend`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50), IN $userid INT)
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
        1
    ORDER BY 
        CASE WHEN $daterange='Day' THEN HOUR(transactiondate) END ASC,
        CASE WHEN $daterange='Week' THEN DAYOFWEEK(transactiondate) END ASC,
        CASE WHEN $daterange='Month' THEN DAY(transactiondate) END ASC,
        CASE WHEN $daterange='Year' THEN MONTH(transactiondate) END ASC,
        CASE WHEN $daterange NOT IN ('Day','Week','Month','Year') THEN DATE(transactiondate) END ASC;
END$$

DELIMITER ;
