/*
SQLyog Ultimate v13.1.1 (32 bit)
MySQL - 10.4.32-MariaDB : Database - pos
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/* Function  structure for function  `fngeneratecreditnoteno` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratecreditnoteno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneratecreditnoteno`() RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE $grnno VARCHAR(50);
	SET $grnno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Credit Note');
	RETURN $grnno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratecustomercreditrefno` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratecustomercreditrefno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneratecustomercreditrefno`() RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE $receiptno VARCHAR(50);
	SET $receiptno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Credit Sale');
	RETURN $receiptno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratecustomerno` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratecustomerno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneratecustomerno`(p_branchid INT) RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
    DECLARE v_customerno VARCHAR(50);
    SET v_customerno = (SELECT CONCAT(
        `prefix`,
        CASE CHAR_LENGTH(`currentno`) 
            WHEN 1 THEN '0000'
            WHEN 2 THEN '000'
            WHEN 3 THEN '00'
            WHEN 4 THEN '0'
            ELSE '' 
        END,
        `currentno`) FROM `serials` WHERE branchid = p_branchid AND `documenttype` = 'Customer Number');
    RETURN v_customerno;
END */$$
DELIMITER ;

/* Function  structure for function  `fngenerategrnno` */

/*!50003 DROP FUNCTION IF EXISTS `fngenerategrnno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngenerategrnno`(p_branchid INT) RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
    DECLARE v_grnno VARCHAR(50);
    SET v_grnno = (SELECT CONCAT(
        `prefix`,
        CASE CHAR_LENGTH(`currentno`) 
            WHEN 1 THEN '0000'
            WHEN 2 THEN '000'
            WHEN 3 THEN '00'
            WHEN 4 THEN '0'
            ELSE '' 
        END,
        `currentno`) FROM `serials` WHERE branchid = p_branchid AND `documenttype` = 'Goods Received Note');
    RETURN v_grnno;
END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratepaymentvoucherno` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratepaymentvoucherno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneratepaymentvoucherno`() RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE $voucherno VARCHAR(50);
	SET $voucherno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Voucher Number');
	RETURN $voucherno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngenerateproductcode` */

/*!50003 DROP FUNCTION IF EXISTS `fngenerateproductcode` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngenerateproductcode`(p_clientid INT, p_categoryid NUMERIC) RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
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
END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratepurchaseorderno` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratepurchaseorderno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneratepurchaseorderno`(p_branchid INT) RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
    DECLARE v_purchaseorderno VARCHAR(50);
    SET v_purchaseorderno = (SELECT CONCAT(
        `prefix`,
        CASE CHAR_LENGTH(`currentno`) 
            WHEN 1 THEN '0000'
            WHEN 2 THEN '000'
            WHEN 3 THEN '00'
            WHEN 4 THEN '0'
            ELSE '' 
        END,
        `currentno`) FROM `serials` WHERE branchid = p_branchid AND `documenttype` = 'Purchase Order');
    RETURN v_purchaseorderno;
END */$$
DELIMITER ;

/* Function  structure for function  `fngeneraterawmaterialcode` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneraterawmaterialcode` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneraterawmaterialcode`(`$categoryid` NUMERIC) RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE $itemcode VARCHAR(50);
	SET $itemcode=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `rawmaterialcategories` WHERE `categoryid`=$categoryid);
	RETURN $itemcode;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratereceiptno` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratereceiptno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneratereceiptno`() RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE $receiptno VARCHAR(50);
	SET $receiptno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Receipt');
	RETURN $receiptno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratereturninwardsref` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratereturninwardsref` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneratereturninwardsref`() RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE $grnno VARCHAR(50);
	SET $grnno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Return Inwards');
	RETURN $grnno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratereturnoutwardsref` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratereturnoutwardsref` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneratereturnoutwardsref`() RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE $grnno VARCHAR(50);
	SET $grnno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Return Outwards');
	RETURN $grnno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratestocktransaferno` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratestocktransaferno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngeneratestocktransaferno`(p_branchid INT) RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
    DECLARE $stocktransferno VARCHAR(50);
    SET $stocktransferno=(SELECT CONCAT(
        `prefix`,
        CASE CHAR_LENGTH(`currentno`) 
            WHEN 1 THEN '0000'
            WHEN 2 THEN '000'
            WHEN 3 THEN '00'
            WHEN 4 THEN '0'
            ELSE '' 
        END,
        `currentno`) FROM `serials` WHERE branchid = p_branchid AND `documenttype`='Stock Transfer');
    RETURN $stocktransferno;
END */$$
DELIMITER ;

/* Function  structure for function  `fngetsupplieropeningbalance` */

/*!50003 DROP FUNCTION IF EXISTS `fngetsupplieropeningbalance` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fngetsupplieropeningbalance`($clientid INT,
    $supplierid INT, 
    $startdate DATETIME
) RETURNS decimal(18,2)
    DETERMINISTIC
BEGIN
    DECLARE $openingbalance DECIMAL(18,2);
    DECLARE $cutoffdate DATETIME;
    
    SET $cutoffdate = DATE_FORMAT(IFNULL((SELECT cutoffdate FROM startingparameters WHERE clientid = $clientid), NOW()), '%Y-%m-%d');
    
    IF $cutoffdate > $startdate THEN
        SET $startdate = $cutoffdate;
    END IF;
    
    SET $startdate = DATE_SUB($startdate, INTERVAL 1 DAY);
    
    SET $openingbalance = (SELECT SUM(invoiceamount - invoicepayment) FROM vwsupplierstatement o 
    WHERE o.clientid = $clientid AND o.supplierid = $supplierid AND DATE_FORMAT(invoicedate, '%Y-%m-%d') BETWEEN $cutoffdate AND $startdate);
    
    RETURN IFNULL($openingbalance, 0);
END */$$
DELIMITER ;

/* Function  structure for function  `fn_generatecustomerorderno` */

/*!50003 DROP FUNCTION IF EXISTS `fn_generatecustomerorderno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_generatecustomerorderno`() RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE $orderno VARCHAR(50);
	SET $orderno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Customer Order Number');
	RETURN $orderno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_generatequoatationno` */

/*!50003 DROP FUNCTION IF EXISTS `fn_generatequoatationno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_generatequoatationno`() RETURNS varchar(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
BEGIN
	DECLARE $quotatationno VARCHAR(50);
	SET $quotatationno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Quotation Number');
	RETURN $quotatationno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_generaterequisitionno` */

/*!50003 DROP FUNCTION IF EXISTS `fn_generaterequisitionno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_generaterequisitionno`() RETURNS varchar(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
BEGIN
	DECLARE $requisitionno VARCHAR(50);
	SET $requisitionno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Requisition Number');
	RETURN $requisitionno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_generatesalesvoucherno` */

/*!50003 DROP FUNCTION IF EXISTS `fn_generatesalesvoucherno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_generatesalesvoucherno`() RETURNS varchar(100) CHARSET latin1 COLLATE latin1_swedish_ci
    READS SQL DATA
BEGIN
	DECLARE $salesvoucher VARCHAR(50);
	SET $salesvoucher=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Sales Voucher');
	RETURN $salesvoucher;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getcustomersuspenseaccountbalance` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getcustomersuspenseaccountbalance` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_getcustomersuspenseaccountbalance`(`$customerid` INT) RETURNS decimal(18,2)
BEGIN
	DECLARE $accountbalance NUMERIC(18,2);
	SET $accountbalance=(SELECT SUM(IFNULL(credit,0)-IFNULL(debit,0)) FROM customersuspenseaccount WHERE customerid=$customerid);
	RETURN $accountbalance;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getgrntotal` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getgrntotal` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_getgrntotal`(`$grnno` VARCHAR(50)) RETURNS decimal(18,2)
BEGIN
    
	DECLARE $total DECIMAL(18,2);
	
	SELECT SUM(gd.quantity*unitprice) INTO $total
	FROM `goodsreceiveddetails` gd
	JOIN `purchaseorders` p ON p.`purchaseorderno`=gd.`purchaseorderno`
	JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid`=p.`id`
	WHERE `grnno`=$grnno;
	RETURN IFNULL($total,0);
	
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getitemstockbalance` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getitemstockbalance` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_getitemstockbalance`(`$productid` INT, `$asatdate` DATE) RETURNS decimal(18,2)
BEGIN
	DECLARE $closingbalance NUMERIC(18,2);
	SELECT  cutoffdate INTO @startdate FROM `startingparameters`;
	SELECT CASE WHEN @startdate>@asatdate THEN @startdate ELSE @asatdate END INTO @asatdate;
	SET $closingbalance=IFNULL((SELECT SUM(`quantity`) FROM `goodsreceiveddetails` gd, `goodsreceived` g WHERE g.`grnno`=gd.`grnno` AND `itemcode`=$productid
	AND DATE_FORMAT(`datereceived`,'%Y-%m-%d') BETWEEN @startdate AND $asatdate),0) -
	-- Subtract the items sold
	IFNULL((SELECT SUM(`quantity`) FROM `possalesdetails` pd, `possales` p WHERE p.`possaleid`=pd.`possaleid` AND pd.`itemcode`=$productid 
	AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN @startdate AND $asatdate AND IFNULL(p.`deleted`,0)=0),0);
	RETURN $closingbalance;
END */$$
DELIMITER ;

/* Function  structure for function  `fn_getitemstorebalance` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getitemstorebalance` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_getitemstorebalance`(`$productid` INT, `$storeid` INT) RETURNS decimal(18,0)
BEGIN
		DECLARE $startdate DATE;
		DECLARE $enddate DATE;
		
		SELECT DATE(IFNULL(`stockcutoffdate`,'2001-01-01')),DATE(NOW())
		INTO $startdate,$enddate 
		FROM `startingparameters`;
		
		-- select reconciled balance 
		SELECT SUM(`quantity`) INTO @reconciledstock
		FROM `stockreconciledbalancedetails` rd
		JOIN `stockreconciledbalance` r ON r.`stockreconciledbalanceid`=rd.`reconciliationid`
		WHERE rd.`itemid`=$productid AND DATE(r.`reconciliationdate`) BETWEEN $startdate AND $enddate
		AND r.posid=$storeid;
		
		SELECT SUM(quantity)
		INTO @transfersin
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE `s`.`stocktransferid`=sd.`transferid` AND `destinationtype`='pos' AND `destinationid`=$storeid AND sd.`itemcode`=$productid
		AND DATE(s.`dateadded`) BETWEEN $startdate AND $enddate;
		
		SELECT SUM(quantity)
		INTO @transfersout
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE `s`.`stocktransferid`=sd.`transferid` AND `sourcetype`='pos' AND `sourceid`=$storeid  AND sd.`itemcode`=$productid
		AND DATE(s.`dateadded`) BETWEEN $startdate AND $enddate;
		
		-- get sales
		SELECT SUM(quantity) 
		INTO @sales
		FROM `possalesdetails` pd
		JOIN `possales` p ON p.`possaleid`=pd.`possaleid`
		WHERE itemcode=$productid AND DATE(`receiptdate`) BETWEEN $startdate AND $enddate 
		AND `pointofsaleid`=$storeid AND p.`deleted`=0;
	
	SET @itembalance=IFNULL(@transfersin,0)+IFNULL(@reconciledstock,0)-IFNULL(@transfersout,0)-IFNULL(@sales,0);
	
	RETURN @itembalance;
	
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getitemstorebalanceasat` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getitemstorebalanceasat` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_getitemstorebalanceasat`(`$productid` INT, `$storeid` INT, `$asat` DATE) RETURNS decimal(18,2)
BEGIN
	DECLARE $startdate DATE;
		DECLARE $enddate DATE;
		
		SELECT DATE(IFNULL(`stockcutoffdate`,'2001-01-01')),$asat,
		DATE_ADD($asat, INTERVAL -1 DAY)
		INTO $startdate,$enddate,@basedate
		FROM `startingparameters`;
		
		-- select reconciled balance 
		SELECT SUM(`quantity`) INTO @reconciledstock
		FROM `stockreconciledbalancedetails` rd
		JOIN `stockreconciledbalance` r ON r.`stockreconciledbalanceid`=rd.`reconciliationid`
		WHERE `itemid`=$productid AND DATE(`reconciliationdate`) BETWEEN $startdate AND $enddate
		AND posid=$storeid;
		
		SELECT SUM(quantity)
		INTO @transfersin
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE`s`.`stocktransferid`=sd.`transferid` AND `destinationtype`='pos' AND `destinationid`=$storeid AND sd.`itemcode`=$productid
		AND DATE(s.`dateadded`) BETWEEN $startdate AND @basedate;
		
		SELECT SUM(quantity)
		INTO @transfersout
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE`s`.`stocktransferid`=sd.`transferid` AND `sourcetype`='pos' AND `sourceid`=$storeid  AND sd.`itemcode`=$productid
		AND DATE(s.`dateadded`) BETWEEN $startdate AND @basedate;
		
		-- get sales
		SELECT SUM(quantity) 
		INTO @sales
		FROM `possalesdetails` pd
		JOIN `possales` p ON p.`possaleid`=pd.`possaleid`
		WHERE itemcode=$productid AND DATE(`receiptdate`) BETWEEN $startdate AND @basedate 
		AND `pointofsaleid`=$storeid AND p.`deleted`=0;
	
		SET @itembalance=IFNULL(@transfersin,0)+IFNULL(@reconciledstock,0)-IFNULL(@transfersout,0)-IFNULL(@sales,0);
	
		RETURN @itembalance;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getproductaverageprice` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getproductaverageprice` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_getproductaverageprice`(`$productid` INT, `$startdate` DATE, `$enddate` DATE) RETURNS decimal(18,4)
BEGIN
	DECLARE $averageprice INT;
	SELECT IFNULL((SELECT AVG(`unitprice`) FROM `purchaseorderdetails` od, `purchaseorders` o 
			WHERE o.id=od.`purchaseorderid` AND DATE_FORMAT(o.`date`,'%Y-%m-%d') BETWEEN $startdate AND $enddate),
	(SELECT AVG(`unitprice`) FROM `purchaseorderdetails` od, `purchaseorders` o 
		WHERE o.id=od.`purchaseorderid` AND DATE_FORMAT(o.`date`,'%Y-%m-%d') <= $enddate)) 
	INTO $averageprice;
	RETURN $averageprice;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getwarehousestockbalance` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getwarehousestockbalance` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_getwarehousestockbalance`(`$productid` INT, `$warehouseid` INT, `$enddate` DATE) RETURNS decimal(18,2)
BEGIN
	DECLARE $startdate DATE;
	-- DECLARE $enddate DATE;
	DECLARE $purchases DECIMAL(18,2);
	DECLARE $transfersout DECIMAL(18,2);
	DECLARE $transfersin DECIMAL(18,2);
	DECLARE $reconciledstock DECIMAL(18,2);
	
	SELECT DATE(IFNULL(`stockcutoffdate`,'2001-01-01'))
	INTO $startdate
	FROM `startingparameters`;
	
	-- Get ware houses receipts
	SELECT SUM(quantity) INTO $purchases 
	FROM `goodsreceived` g
	JOIN `goodsreceiveddetails` gd ON gd.`grnno`=g.`grnno` AND `warehouseid`=$warehouseid AND `itemcode`=$productid
	AND DATE(`datereceived`) BETWEEN $startdate AND $enddate;
	
	-- Get Transfers out
	SELECT SUM(`quantity`) INTO $transfersout 
	FROM `stocktransfer` t 
	JOIN `stocktransferdetails` td ON td.`transferid`=`t`.`stocktransferid`
	WHERE `sourcetype`='warehouse' AND `sourceid`=$warehouseid AND 
	`itemcode`=$productid AND `dateadded` BETWEEN $startdate AND $enddate;
	
	-- Get transfers In
	SELECT SUM(`quantity`) INTO $transfersin
	FROM `stocktransfer` t 
	JOIN `stocktransferdetails` td ON td.`transferid`=`t`.`stocktransferid`
	WHERE `destinationtype`='warehouse' AND `destinationid`=$warehouseid AND 
	`itemcode`=$productid AND `dateadded` BETWEEN $startdate AND $enddate;
	
	-- Get reconciledstock
	SELECT SUM(`quantity`) INTO $reconciledstock
	FROM `stockreconciledbalance` s JOIN `stockreconciledbalancedetails` sb ON sb.`reconciliationid`=s.`stockreconciledbalanceid`
	WHERE `itemid`=$productid AND `category`='warehouse' AND `posid`=$warehouseid AND `reconciliationdate`
	BETWEEN $startdate AND $enddate;
	
	RETURN IFNULL($purchases,0)-IFNULL($transfersout,0)+IFNULL($transfersin,0)+IFNULL($reconciledstock,0);
	
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_purchaseorderstatus` */

/*!50003 DROP FUNCTION IF EXISTS `fn_purchaseorderstatus` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_purchaseorderstatus`(`$purchaseorderid` INT) RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
                DECLARE $approvallevelid INT;
                DECLARE $approvallevelname VARCHAR(100);
                DECLARE $purchaseorderstatus VARCHAR(50);
                DECLARE $finished INTEGER DEFAULT 0;
                
                DECLARE c1 CURSOR FOR SELECT `id`,`description` FROM `purchaseorderapprovallevels` ORDER BY `hierarchy`;
                DECLARE CONTINUE HANDLER FOR NOT FOUND SET $finished=1;
                OPEN c1;
                
                SET $purchaseorderstatus='Approved';
                
                IF EXISTS(SELECT * FROM `purchaseorders` WHERE `purchaseorderid`=$purchaseorderid AND IFNULL(`rejected`,0)=1) THEN
                    SET $purchaseorderstatus='Rejected';
                ELSE
                    get_product: LOOP
                        FETCH c1 INTO $approvallevelid,$approvallevelname;		
                        IF $finished=1 THEN 
                            LEAVE get_product;
                        END IF;
                        
                        IF NOT EXISTS(SELECT * FROM `purchaseorderapproval` WHERE `approvallevelid`=$approvallevelid AND `poid`=$purchaseorderid) THEN
                            SET $purchaseorderstatus=CONCAT('Pending ',$approvallevelname);
                            LEAVE get_product;
                        END IF;
                        
                    END LOOP get_product;
                    CLOSE c1;
                END IF;
                
                RETURN $purchaseorderstatus;
            END */$$
DELIMITER ;

/* Function  structure for function  `fn_receiptpaymentmodereferencenos` */

/*!50003 DROP FUNCTION IF EXISTS `fn_receiptpaymentmodereferencenos` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_receiptpaymentmodereferencenos`(`$receiptno` VARCHAR(50)) RETURNS varchar(4000) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE payment_mode VARCHAR(100) DEFAULT "";
	DECLARE payment_modes VARCHAR(4000) DEFAULT "";
	 -- declare cursor for employee email
	 DECLARE payment_modes_cursor CURSOR FOR 
	 SELECT `reference` FROM `paymentmethods` p, `possalespayments` s, `possales` d  WHERE p.`id`=s.`paymentmode`AND d.`id`=s.`possaleid`  
	 AND `receiptno`=$receiptno ORDER BY `description`;
	 
	 -- declare NOT FOUND handler
	 DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET v_finished = 1;
	 
	 OPEN payment_modes_cursor;
	 
	 get_paymentmethods:LOOP
	 
	 FETCH payment_modes_cursor INTO payment_mode;
	 
	 IF v_finished = 1 THEN 
	 LEAVE get_paymentmethods;
	 END IF;
	 
	 -- build payment mode list
	 IF payment_modes='' THEN 
		SET payment_modes = payment_mode;
	 ELSE
		SET payment_modes = CONCAT(payment_modes,",",payment_mode);
	 END IF ;
	 
	 
	 END LOOP get_paymentmethods;
	 
	 CLOSE payment_modes_cursor;
	 RETURN payment_modes;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_receiptpaymentmodes` */

/*!50003 DROP FUNCTION IF EXISTS `fn_receiptpaymentmodes` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_receiptpaymentmodes`(`$receiptno` VARCHAR(50)) RETURNS varchar(4000) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE payment_mode VARCHAR(100) DEFAULT "";
	DECLARE payment_modes VARCHAR(4000) DEFAULT "";
	 -- declare cursor for employee email
	 DECLARE payment_modes_cursor CURSOR FOR 
	 SELECT `description` FROM `paymentmethods` p, `possalespayments` s, `possales` d  WHERE p.`id`=s.`paymentmode`AND d.`id`=s.`possaleid`  
	 AND `receiptno`=$receiptno ORDER BY `description`;
	 
	 -- declare NOT FOUND handler
	 DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET v_finished = 1;
	 
	 OPEN payment_modes_cursor;
	 
	 get_paymentmethods:LOOP
	 
	 FETCH payment_modes_cursor INTO payment_mode;
	 
	 IF v_finished = 1 THEN 
	 LEAVE get_paymentmethods;
	 END IF;
	 
	 -- build payment mode list
	 IF payment_modes='' THEN 
		SET payment_modes = payment_mode;
	 ELSE
		SET payment_modes = CONCAT(payment_modes,",",payment_mode);
	 END IF ;
	 
	 
	 END LOOP get_paymentmethods;
	 
	 CLOSE payment_modes_cursor;
	 RETURN payment_modes;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_warehousestockbalanceasat` */

/*!50003 DROP FUNCTION IF EXISTS `fn_warehousestockbalanceasat` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `fn_warehousestockbalanceasat`(`$productid` INT, `$warehouseid` INT, `$enddate` DATE) RETURNS decimal(18,2)
BEGIN
	DECLARE $startdate DATE;
	-- DECLARE $enddate DATE;
	DECLARE $purchases DECIMAL(18,2);
	DECLARE $transfersout DECIMAL(18,2);
	DECLARE $transfersin DECIMAL(18,2);
	DECLARE $reconciledstock DECIMAL(18,2);
	
	SELECT DATE(IFNULL(`stockcutoffdate`,'01-01-2001'))
	INTO $startdate
	FROM `startingparameters`;
	
	-- Get ware houses receipts
	SELECT SUM(quantity) INTO $purchases 
	FROM `goodsreceived` g
	JOIN `goodsreceiveddetails` gd ON gd.`grnno`=g.`grnno` AND `warehouseid`=$warehouseid AND `itemcode`=$productid
	AND `datereceived` BETWEEN $startdate AND $enddate;
	
	-- Get Transfers out
	SELECT SUM(`quantity`) INTO $transfersout 
	FROM `stocktransfer` t 
	JOIN `stocktransferdetails` td ON td.`transferid`=t.`id`
	WHERE `sourcetype`='warehouse' AND `sourceid`=$warehouseid AND 
	`itemcode`=$productid AND `dateadded` BETWEEN $startdate AND $enddate;
	
	-- Get transfers In
	SELECT SUM(`quantity`) INTO $transfersout 
	FROM `stocktransfer` t 
	JOIN `stocktransferdetails` td ON td.`transferid`=t.`id`
	WHERE `destinationtype`='warehouse' AND `destinationid`=$warehouseid AND 
	`itemcode`=$productid AND `dateadded` BETWEEN $startdate AND $enddate;
	
	-- Get reconciledstock
	SELECT SUM(`quantity`) INTO $reconciledstock
	FROM `stockreconciledbalance` s JOIN `stockreconciledbalancedetails` sb ON sb.`reconciliationid`=s.`id`
	WHERE `itemid`=$productid AND `category`='warehouse' AND `posid`=$warehouseid AND `reconciliationdate`
	BETWEEN $startdate AND $enddate;
	
	RETURN IFNULL($purchases,0)-IFNULL($transfersout,0)+IFNULL($transfersin,0)+IFNULL($reconciledstock,0);
    END */$$
DELIMITER ;

/* Function  structure for function  `spgeneratecustomerreceiptno` */

/*!50003 DROP FUNCTION IF EXISTS `spgeneratecustomerreceiptno` */;
DELIMITER $$

/*!50003 CREATE  FUNCTION `spgeneratecustomerreceiptno`(p_branchid INT) RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
    DECLARE v_receiptno VARCHAR(50);
    SET v_receiptno = (SELECT CONCAT(
        `prefix`,
        CASE CHAR_LENGTH(`currentno`) 
            WHEN 1 THEN '0000'
            WHEN 2 THEN '000'
            WHEN 3 THEN '00'
            WHEN 4 THEN '0'
            ELSE '' 
        END,
        `currentno`) FROM `serials` WHERE branchid = p_branchid AND `documenttype` = 'Customer Receipt');
    RETURN v_receiptno;
END */$$
DELIMITER ;

/* Procedure structure for procedure `emaillist` */

/*!50003 DROP PROCEDURE IF EXISTS  `emaillist` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `emaillist`()
BEGIN
	DECLARE finished INT DEFAULT 0;
	DECLARE emails_list VARCHAR(500) DEFAULT "";
	DECLARE email VARCHAR(50) DEFAULT "";
	DECLARE user_data CURSOR FOR SELECT email FROM customers LIMIT 5;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	OPEN user_data;
	get_user_email: LOOP
	FETCH user_data INTO email;
		IF finished = 1 THEN
			LEAVE get_user_email;
		END IF;
		SET emails_list = CONCAT(emails_list,", ",email);
	END LOOP get_user_email;
	CLOSE user_data;
	SELECT emails_list;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `import_data` */

/*!50003 DROP PROCEDURE IF EXISTS  `import_data` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `import_data`()
BEGIN	
	DECLARE $suppliername VARCHAR(250);
	DECLARE $itemname VARCHAR(250);
	DECLARE $itemcode VARCHAR(50);
	DECLARE $categoryid VARCHAR(50);
	DECLARE $productcode VARCHAR(50);
	DECLARE $finished INTEGER DEFAULT 0;
	DECLARE $tp DATETIME;
	DECLARE $prefix VARCHAR(3);
	DECLARE c1 CURSOR FOR SELECT suppliername,itemname FROM welbay_products;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET $finished=1;
	SET $tp=NOW();
		
	OPEN c1;
	get_product: LOOP
		FETCH c1 INTO $suppliername,$itemname;		
		IF $finished=1 THEN 
			LEAVE get_product;
		END IF;
		SET $prefix=LEFT($suppliername,3);
		
		-- create category if not exists
		IF NOT EXISTS( SELECT `categoryname` FROM `categories` WHERE `categoryname`=$suppliername) THEN 
		
			INSERT INTO `categories`(`categoryname`,`dateadded`,`addedby`,`deleted`,`prefix`,`currentno`)
			VALUES($suppliername,$tp,1,0,$prefix,1) ;
		END IF;
		
		-- Insert supplier 
		IF NOT EXISTS(SELECT `suppliername` FROM `suppliers` WHERE `suppliername`=$uppliername) THEN
			INSERT INTO `suppliers`(`suppliername`,`physicaladdress`,`postaladdress`,`creditlimit`,`mobile`,`email`,`dateadded`,`addedby`,`deleted`)
			VALUES($suppliername,'','',0,'','',NOW(),1,0);
		END IF;
		
		SET $categoryid=(SELECT `categoryid` FROM `categories` WHERE `categoryname`=$suppliername); 
		
		-- generate product code
		SET $productcode=`fngenerateproductcode`($categoryid);
		-- save the product
		INSERT INTO `products`(`itemcode`,`itemname`,`unitofmeasure`,`buyingprice`,`sellingprice`,`categoryid`,`dateadded`,`addedby`,`deleted`,`reorderlevel`)
		VALUES($productcode,$itemname,'Rims',0,0,$categoryid,NOW(),1,0,10);
		-- Update product code
		UPDATE `categories` SET `currentno`=`currentno`+1 WHERE `categoryid`=$categoryid;
	END LOOP get_product;
	CLOSE c1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `import_data_campari` */

/*!50003 DROP PROCEDURE IF EXISTS  `import_data_campari` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `import_data_campari`()
BEGIN	
	DECLARE $suppliername VARCHAR(250);
	DECLARE $itemname VARCHAR(250);
	DECLARE $itemcode VARCHAR(50);
	DECLARE $categoryid VARCHAR(50);
	DECLARE $productcode VARCHAR(50);
	DECLARE $finished INTEGER DEFAULT 0;
	DECLARE $tp DATETIME;
	DECLARE $prefix VARCHAR(3);
	DECLARE $bp DECIMAL(10,0);
	DECLARE $wp DECIMAL(10,0);
	DECLARE $sp DECIMAL(10,0);
	DECLARE c1 CURSOR FOR SELECT UPPER(`Category`),itemname,`BP`,`RP`,`WP` FROM `campari_products`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET $finished=1;
	SET $tp=NOW();
		
	OPEN c1;
	get_product: LOOP
		FETCH c1 INTO $suppliername,$itemname,$bp,$sp,$wp;		
		IF $finished=1 THEN 
			LEAVE get_product;
		END IF;
		SET $prefix=LEFT($suppliername,3);
		
		-- create category if not exists
		IF NOT EXISTS( SELECT `categoryname` FROM `categories` WHERE `categoryname`=$suppliername) THEN 
		
			INSERT INTO `categories`(`categoryname`,`dateadded`,`addedby`,`deleted`,`prefix`,`currentno`)
			VALUES($suppliername,$tp,1,0,$prefix,1) ;
		END IF;
		
		
		-- Insert supplier 
		/*if not exists(select `suppliername` from `suppliers` where `suppliername`=$uppliername) THEN
			insert into `suppliers`(`suppliername`,`physicaladdress`,`postaladdress`,`creditlimit`,`mobile`,`email`,`dateadded`,`addedby`,`deleted`)
			values($suppliername,'','',0,'','',now(),5,0);
		end if;
		*/
		
		SET $categoryid=(SELECT `categoryid` FROM `categories` WHERE `categoryname`=$suppliername); 
		
		-- generate product code
		SET $productcode=`fngenerateproductcode`($categoryid);
		-- save the product
		INSERT INTO `products`(`itemcode`,`itemname`,`unitofmeasure`,`buyingprice`,`sellingprice`,`categoryid`,`dateadded`,`addedby`,`deleted`,`reorderlevel`,`wholesaleprice`)
		VALUES($productcode,$itemname,'Rims',$bp,$sp,$categoryid,NOW(),5,0,10,$wp);
		-- Update product code
		UPDATE `categories` SET `currentno`=`currentno`+1 WHERE `categoryid`=$categoryid;
	END LOOP get_product;
	CLOSE c1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `import_payables` */

/*!50003 DROP PROCEDURE IF EXISTS  `import_payables` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `import_payables`()
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE $supplierid INT;
	DECLARE $amount NUMERIC(18,2);
	DECLARE $pono VARCHAR(50);
	DECLARE $poid INT;
	DECLARE $podate DATETIME DEFAULT '2020-06-01';
	DECLARE $userid INT DEFAULT 5;
	DECLARE $itemcode INT;
	DECLARE $grnno VARCHAR(50);
	DECLARE $warehouseid INT DEFAULT 1;
	DECLARE $invoiceid INT;
	-- declare cursor for employee email
	
		DECLARE curPayable 
			CURSOR FOR 
				SELECT `supplierid`,`amount` FROM `loyalty_payables`;
		-- declare NOT FOUND handler
		DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finished = 1;
		
		-- get balance item code
		SET $itemcode=(SELECT `productid` FROM  `products` WHERE `itemname`='Balance as at 01-Jun-2020');
		
		OPEN curPayable;
		getEmail: LOOP
			START TRANSACTION;
				FETCH curPayable INTO $supplierid,$amount;
				IF finished = 1 THEN 
					LEAVE getEmail;
				END IF;
				-- make purchase order
				-- generate pono
				SET $pono=`fngeneratepurchaseorderno`();
				
				INSERT INTO `purchaseorders`(`purchaseorderno`,`date`,`supplierid`,`expecteddate`,`status`,`terms`,`addedby`)
				VALUES($pono,$podate,$supplierid,$podate,'Pending','',$userid);
				
				SET $poid=(SELECT MAX(`id`) FROM `purchaseorders`);
				
				INSERT INTO `purchaseorderdetails`(`purchaseorderid`,`itemcode`,`quanity`,`unitprice`)
				VALUES($poid,$itemcode,1,$amount);
				-- receive the items
				SET $grnno=`fngenerategrnno`();
				
				INSERT INTO `goodsreceived`(`warehouseid`,`grnno`,`datereceived`,`supplierid`,`deliverynono`)
				VALUES($warehouseid,$grnno,$podate,$supplierid,$grnno);
				
				INSERT INTO `goodsreceiveddetails`(`grnno`,`itemcode`,`purchaseorderno`,`quantity`)
				VALUES($grnno,$itemcode,$pono,1);
				
				-- generate the invoice
				INSERT INTO `supplierinvoice`(`supplierid`,`invoiceno`,`invoicedate`,`addedby`,`dateadded`)
				VALUES($supplierid,'BALBF01JUN2020',$podate,$userid,$podate);
				
				SET $invoiceid=(SELECT MAX(`id`) FROM `supplierinvoice`);
				
				INSERT INTO `supplierinvoicedetails`(`invoiceid`,`referenceno`,`itemcode`,`description`,`quantity`,`unitprice`)
				VALUES($invoiceid,$grnno,$itemcode,'Opening Balance as at 01-Jun-2020',1,$amount);
				
				-- Increment PONO and GRN No
				UPDATE serials SET currentno=currentno+1 WHERE `documenttype` IN('Goods Received Note','Purchase Order');
			COMMIT; 
		END LOOP getEmail;
		CLOSE curPayable;       
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `import_receivables` */

/*!50003 DROP PROCEDURE IF EXISTS  `import_receivables` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `import_receivables`()
BEGIN
	DECLARE $customerid INTEGER;
	DECLARE $amount NUMERIC(18,2);
	DECLARE $finished INTEGER;
	DECLARE $receiptno VARCHAR(50);
	DECLARE $userid INT DEFAULT 5;
	DECLARE $posid INT DEFAULT 14;
	DECLARE $id INT;
	DECLARE $productid INT;
	DECLARE $categoryid INT DEFAULT 29;
	DECLARE $paymentmode INT DEFAULT 4;
	
	DECLARE curCustomer 
		CURSOR FOR 
			SELECT customerid,amount FROM loyalty_receivables;
	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET $finished = 1;
	OPEN curCustomer;
	-- Create a product called opening balances
	IF NOT EXISTS(SELECT * FROM `products` WHERE `itemname`='Balance as at 01-Jun-2020') THEN
		INSERT INTO `products`(`itemcode`,`itemname`,`unitofmeasure`,`buyingprice`,`sellingprice`,`categoryid`,`dateadded`,`addedby`,`reorderlevel`,`wholesaleprice`)
		VALUES('BalBF','Balance as at 01-Jun-2020','EA',0,0,$categoryid,'2020-06-01',$userid,0,0);
		SET $productid=(SELECT MAX(`productid`) FROM `products`);
	ELSE
		SET $productid=(SELECT `productid` FROM `products` WHERE `itemname`='Balance as at 01-Jun-2020');
	END IF;
	
	getCustomer: LOOP
		FETCH curCustomer INTO $customerid,$amount;
		IF $finished = 1 THEN 
			LEAVE getCustomer;
		END IF;
		
		-- create customer invoice
		SET $receiptno=`fngeneratereceiptno`();
		-- Add the POS sale
		INSERT INTO `possales`(`receiptno`,`receiptdate`,`customerid`,`pointofsaleid`,`addedby`)
		VALUES($receiptno,'2020-06-01',$customerid,$posid,$userid);
		
		SET $id=(SELECT MAX(`id`) FROM `possales`);
		
		INSERT INTO `possalesdetails`(`possaleid`,`itemcode`,`quantity`,`unitprice`,`discount`)
		VALUES($id,$productid,1,$amount,0);
		
		-- Add sale as credit
		INSERT INTO `possalespayments`(`possaleid`,`paymentmode`,`reference`,`amount`,`banked`,`bankingreference`)
		VALUES($id,$paymentmode,$receiptno,$amount,1,$receiptno);
		
		-- Increment receipt number
		UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Receipt';
		
	END LOOP getCustomer;
	CLOSE curCustomer;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `savetemppurchaseorderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `savetemppurchaseorderdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `savetemppurchaseorderdetails`(`$refno` VARCHAR(50), `$itemcode` VARCHAR(50), `$quantity` NUMERIC, `$unitprice` NUMERIC)
BEGIN
	DECLARE $itemid INT;
	SET $itemid=(SELECT `productid` FROM `products` WHERE `itemcode`=$itemcode);
	INSERT INTO `temppurchaseorder` (`refno`,`itemcode`,`quantity`,`unitprice`)
	VALUES($refno,$itemid,$quantity,$unitprice);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spapprovepaymentvoucher` */

/*!50003 DROP PROCEDURE IF EXISTS  `spapprovepaymentvoucher` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spapprovepaymentvoucher`($branchid int,$id int,$userid int)
BEGIN
	declare $cashbookaccount int;
	start transaction;
		
		set $cashbookaccount=(select `cashbookaccount` from `paymentvouchers` where `branchid` = $branchid and `paymentvoucherid`=$id);
		-- update payment voucher status
		update `paymentvouchers` set `status`='Approved', `lastmodifiedby`=$userid, `lastmodifieddate`=now() where `branchid` = $branchid and `paymentvoucherid`=$id;
		-- insert the transaction into the GL
		-- begin with vrediting the cashbook account
		insert into `gltransactions` (`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		select `referenceno`,  v.dateadded,`cashbookaccount`,null,concat('Payment of voucher #',`voucherno`),0,sum(quantity*unitprice),$userid
		from `paymentvouchers` v, `paymentvoucherdetails` vd where v.`branchid` = $branchid and v.`paymentvoucherid`=vd.`voucherid` and v.`paymentvoucherid`=$id;
		-- post the debit entries
		insert into `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		select `referenceno`, v.dateadded,`accountcharged`,$cashbookaccount,`description`,quantity*unitprice,0,$userid
		FROM `paymentvouchers` v, `paymentvoucherdetails` vd WHERE v.`branchid` = $branchid and v.`paymentvoucherid`=vd.`voucherid` AND v.`paymentvoucherid`=$id;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spapprovepurchaseorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `spapprovepurchaseorder` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spapprovepurchaseorder`(`$id` NUMERIC, `$userid` NUMERIC)
BEGIN
	UPDATE `purchaseorders` SET `status`='Approved', `lastmodifiedon`=NOW(),`lastmodifiedby`=$userid WHERE `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcancelpaymentvoucher` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcancelpaymentvoucher` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcancelpaymentvoucher`($branchid int,$id int,$reason varchar(500),$userid int)
BEGIN
	update `paymentvouchers` set `status`='Cancelled', `reasoncancelled`=$reason, `lastmodifiedby`=$userid, `lastmodifieddate`=now()
	where `branchid` = $branchid and `paymentvoucherid`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcancelpossale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcancelpossale` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcancelpossale`(`$receiptno` VARCHAR(50), `$userid` INT, `$reason` VARCHAR(100))
BEGIN
	UPDATE `possales` SET `deleted`=1, `deletedon`=NOW(), `deletedby`=$userid, reason=$reason WHERE `receiptno`=$receiptno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcancelpurchaseorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcancelpurchaseorder` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcancelpurchaseorder`(`$id` NUMERIC, `$userid` NUMERIC, `$reason` VARCHAR(100))
BEGIN
	UPDATE `purchaseorders` SET `status`='Cancelled', `reasoncancelled`=$reason, `lastmodifiedon`=NOW(),`lastmodifiedby`=$userid
	WHERE `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spchangeuserpassword` */

/*!50003 DROP PROCEDURE IF EXISTS  `spchangeuserpassword` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spchangeuserpassword`(IN $clientid INT, IN $userid INT, IN $userpassword VARCHAR(100),
    IN $salt VARCHAR(50),
    IN $changepasswordonlogon TINYINT
)
BEGIN
    UPDATE `user` 
    SET `password` = $userpassword, 
        `salt` = $salt,
        `changepasswordonlogon` = $changepasswordonlogon 
    WHERE clientid = $clientid AND userid = $userid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckcategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckcategory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckcategory`(IN $clientid INT, IN $id INT, IN $field VARCHAR(50), IN $value VARCHAR(50))
BEGIN
    IF $field = 'categoryname' THEN
        SELECT * FROM `categories` WHERE clientid = $clientid AND `categoryid` <> $id AND `categoryname` = $value;
    ELSEIF $field = 'prefix' THEN
        SELECT * FROM `categories` WHERE clientid = $clientid AND `categoryid` <> $id AND `prefix` = $value;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckcrateadditionreference` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckcrateadditionreference` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckcrateadditionreference`(`$reference` VARCHAR(50))
BEGIN
	SELECT * FROM `cratesinventory` WHERE `reference`=$reference;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckcustomerdocuments` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckcustomerdocuments` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckcustomerdocuments`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckcustomername` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckcustomername` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckcustomername`(IN $clientid INT, IN $id INT, IN $name VARCHAR(50))
BEGIN
    SELECT * FROM `customers` WHERE clientid = $clientid AND `customerid` <> $id AND `customername` = $name;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckglaccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckglaccount` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckglaccount`(IN $branchid INT, IN $id INT, IN $searchvariable VARCHAR(50))
BEGIN
                SELECT * FROM `glaccounts` 
                WHERE `id` <> $id 
                  AND (`accountcode` = $searchvariable OR `accountname` = $searchvariable) 
                  AND `clientid` = $branchid 
                  AND `deleted` = 0;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckglaccountgroup` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckglaccountgroup` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckglaccountgroup`(IN $branchid INT, IN $id INT, IN $groupname VARCHAR(50))
BEGIN
                SELECT * FROM `glaccountgroups` 
                WHERE `id` <> $id AND `groupname` = $groupname AND `branchid` = $branchid;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckjournalrefereceno` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckjournalrefereceno` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckjournalrefereceno`(`$referenceno` VARCHAR(50))
BEGIN
	SELECT * FROM `journals` WHERE `referenceno`=$referenceno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckmpesatransactioncode` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckmpesatransactioncode` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckmpesatransactioncode`(`$refno` VARCHAR(50))
BEGIN
	SELECT * FROM `mpesaconfirmation` WHERE `reference`=$refno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckpaymentmodereference` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckpaymentmodereference` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckpaymentmodereference`(`$paymentmodeid` INT, `$reference` VARCHAR(50))
BEGIN
	SET @checkreference=(SELECT `requiresref` FROM `paymentmethods` WHERE `id`=$paymentmodeid);
	
	IF @checkreference=1 THEN
		SELECT * FROM `customerpayments` WHERE `paymentmethodid`=$paymentmodeid AND `reference`=$reference;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckpaymentvoucherno` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckpaymentvoucherno` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckpaymentvoucherno`(
    IN `$branchid` INT,
    IN `$id` INT,
    IN `$voucherno` VARCHAR(50)
)
BEGIN
    SELECT * FROM `paymentvouchers` WHERE `branchid` = `$branchid` AND `paymentvoucherid`<>$id AND `voucherno`=$voucherno;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckposname` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckposname` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckposname`(IN $branchid INT, IN $posid INT, IN $posname VARCHAR(50))
BEGIN
    SELECT * FROM pointsofsale 
    WHERE branchid = $branchid AND posid <> $posid AND posname = $posname AND deleted = 0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckproduct` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckproduct`(IN $clientid INT, IN $id NUMERIC, IN $valuetocheck VARCHAR(50), IN $category VARCHAR(50))
BEGIN
    IF $category='code' THEN
        SELECT * FROM `products` WHERE clientid = $clientid AND `productid` <> $id AND `itemcode` = $valuetocheck;
    ELSE
        SELECT * FROM `products` WHERE clientid = $clientid AND `productid` <> $id AND `itemname` = $valuetocheck;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckreferenceno` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckreferenceno` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckreferenceno`(IN $branchid INT, IN $modeid INT, IN $reference VARCHAR(50))
BEGIN
    SELECT * FROM `possalespayments` WHERE branchid = $branchid AND `paymentmode` = $modeid AND `reference` = $reference;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckrole` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckrole` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckrole`(
    IN $clientid INT,
    IN $roleid INT,
    IN $rolename VARCHAR(50)
)
BEGIN
    SELECT * 
    FROM `roles` 
    WHERE `clientid` = $clientid AND `roleid`<>$roleid AND `rolename`=$rolename;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spchecksupplierdeliverynotenumber` */

/*!50003 DROP PROCEDURE IF EXISTS  `spchecksupplierdeliverynotenumber` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spchecksupplierdeliverynotenumber`(IN $branchid INT, IN $supplierid INT, IN $deliverynoteno VARCHAR(50))
BEGIN
    SELECT * FROM `goodsreceived` WHERE branchid = $branchid AND `supplierid` = $supplierid AND `deliverynono` = $deliverynoteno;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spchecksuppliername` */

/*!50003 DROP PROCEDURE IF EXISTS  `spchecksuppliername` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spchecksuppliername`(
    IN $clientid INT,
    IN $supplierid INT,
    IN $suppliername VARCHAR(50)
)
BEGIN
    SELECT * FROM suppliers 
    WHERE clientid = $clientid 
    AND supplierid <> $supplierid 
    AND suppliername = $suppliername;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckuser` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spcheckuser`(
    IN `$clientid` INT, 
    IN `$userid` INT, 
    IN `$checkfield` VARCHAR(50), 
    IN `$checkvalue` VARCHAR(50)
)
BEGIN
    IF `$checkfield` = 'username' THEN 
        SELECT * FROM `user` 
        WHERE `clientid` = `$clientid` AND `userid` <> `$userid` AND `username` = `$checkvalue`;
    ELSEIF `$checkfield` = 'email' THEN 
        SELECT * FROM `user` 
        WHERE `clientid` = `$clientid` AND `userid` <> `$userid` AND `email` = `$checkvalue`;
    ELSEIF `$checkfield` = 'mobile' THEN 
        SELECT * FROM `user` 
        WHERE `clientid` = `$clientid` AND `userid` <> `$userid` AND `mobile` = `$checkvalue`;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletecategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletecategory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeletecategory`(IN $clientid INT, IN $id INT, IN $userid INT)
BEGIN
    UPDATE `categories` SET `deleted` = 1, `lastmodifiedon` = NOW(), `lastmodifiedby` = $userid
    WHERE clientid = $clientid AND `categoryid` = $id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletecity` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletecity` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeletecity`(IN $cityid INT)
BEGIN
    DELETE FROM cities WHERE cityid = $cityid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletecountry` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletecountry` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeletecountry`(IN $countryid INT)
BEGIN
    DELETE FROM countries WHERE countryid = $countryid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletecustomer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletecustomer` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeletecustomer`(IN $clientid INT, IN $customerid INT, IN $userid INT)
BEGIN
    UPDATE `customers` SET deleted = 1, lastmodifiedon = NOW(), lastmodifiedby = $userid
    WHERE clientid = $clientid AND customerid = $customerid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletecustomercontact` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletecustomercontact` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeletecustomercontact`(
    IN $clientid INT,
    IN $customercontactid INT,
    IN $deletedby INT
)
BEGIN
    UPDATE customercontacts SET
        deleted = 1,
        datedeleted = NOW(),
        deletedby = $deletedby
    WHERE customercontactid = $customercontactid AND clientid = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletecustomerdiscount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletecustomerdiscount` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeletecustomerdiscount`(
    IN $clientid INT,
    IN $id INT,
    IN $userid INT
)
BEGIN
    UPDATE customerdiscountsettings SET
        deleted = 1,
        lastmodifiedby = $userid,
        lastmodifiedon = NOW()
    WHERE id = $id AND clientid = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteglaccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteglaccount` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleteglaccount`(IN $branchid INT, IN $id INT, IN $clientid INT)
BEGIN
                UPDATE `glaccounts` 
                SET `deleted` = 1, `lastdateupdated` = NOW(), `lastupdatedby` = $clientid 
                WHERE `id` = $id AND `clientid` = $branchid;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteglgroup` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteglgroup` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleteglgroup`(IN $branchid INT, IN $id INT, IN $clientid INT)
BEGIN
                UPDATE `glaccountgroups` 
                SET `deleted` = 1, `lastupdatedby` = $clientid, `lastdateupdated` = NOW() 
                WHERE `id` = $id AND `branchid` = $branchid;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteheldsale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteheldsale` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleteheldsale`(`$id` INT)
BEGIN
	START TRANSACTION;
		DELETE FROM `heldsalesdetails` WHERE `heldsaleid`=$id;
		DELETE FROM `heldsales` WHERE `id`=$id;
	COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteoutlet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteoutlet` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleteoutlet`(`$id` INT, `$userid` INT)
BEGIN
	UPDATE `useroutlets` SET deleted=1, `lastdatemodified`=NOW(),`lastmodifiedby`=$userid
	WHERE id=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletepos` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletepos` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeletepos`(IN $branchid INT, IN $posid INT, IN $userid INT)
BEGIN
    UPDATE pointsofsale 
    SET deleted = 1, lastdatemodified = NOW(), lastmodifiedby = $userid
    WHERE branchid = $branchid AND posid = $posid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteproduct` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleteproduct`(IN $clientid INT, IN $productid INT, IN $userid INT)
BEGIN
    UPDATE `products` SET `deleted` = 1, `lastmodifiedon` = NOW(), `lastmodifiedby` = $userid 
    WHERE clientid = $clientid AND `productid` = $productid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteproduction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteproduction` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleteproduction`(
    IN $clientid INT,
    IN $id INT,
    IN $userid INT
)
BEGIN
    UPDATE `productions`
    SET `deleted` = 1, `lastupdatedby` = $userid, `lastdateupdated` = NOW()
    WHERE `clientid` = $clientid AND `id` = $id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteproductrecipe` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteproductrecipe` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleteproductrecipe`(IN $clientid INT, IN $recipeid INT)
BEGIN
    DELETE FROM `productrecipes` WHERE `clientid` = $clientid AND `id` = $recipeid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteproductsplitunit` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteproductsplitunit` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleteproductsplitunit`(IN $clientid INT, IN $id INT)
BEGIN
    DELETE FROM `productsplitunits` WHERE `clientid` = $clientid AND `id` = $id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleterole` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleterole` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleterole`(`$roleid` INT, `$clientid` INT)
BEGIN
	UPDATE `roles` 
	SET `deleted`=1, `deletedby`=$clientid, `lastdatemodified`=NOW(), `lastmodifiedby`=$clientid
	WHERE `roleid`=$roleid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletesupplier` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletesupplier` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeletesupplier`(
    IN $clientid INT,
    IN $supplierid INT,
    IN $userid INT
)
BEGIN
    UPDATE suppliers SET 
        deleted = 1,
        lastdatemodified = NOW(),
        lastmodifiedby = $userid
    WHERE clientid = $clientid AND supplierid = $supplierid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletesupplierproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletesupplierproduct` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeletesupplierproduct`(
    IN $clientid INT,
    IN $id INT,
    IN $userid INT
)
BEGIN
    UPDATE supplierproducts SET 
        deleted = 1, 
        lastmodifiedby = $userid, 
        lastmodifieddate = NOW()
    WHERE clientid = $clientid AND id = $id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteuser` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdeleteuser`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `user` SET `accountactive`=0,`lastmodifiedon`=NOW(),`lastmodifiedby`=$clientid, `reasoninactive`='Account deleted'
	WHERE `userid`=$id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spdisableuseraccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdisableuseraccount` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spdisableuseraccount`(`$id` INT, `$reason` VARCHAR(500), `$clientid` INT)
BEGIN
	UPDATE `user` SET `accountactive`=0,`reasoninactive`=$reason,`lastmodifiedby`=$clientid,`lastmodifiedon`=NOW()
	WHERE `userid`=$id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spenableuseraccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spenableuseraccount` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spenableuseraccount`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `user` SET `accountactive`=1, `lastmodifiedon`=NOW(),`lastmodifiedby`=$clientid
	WHERE `userid`=$id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spfilterproductsalesbymonth` */

/*!50003 DROP PROCEDURE IF EXISTS  `spfilterproductsalesbymonth` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spfilterproductsalesbymonth`($branchid int, `$startdate` VARCHAR(50), `$enddate` VARCHAR(50), `$productname` VARCHAR(50))
BEGIN
	-- declare sql_dynamic varchar(5000);
	-- declare $sql_full varchar(7000);
	SET SESSION group_concat_max_len = 2048;
	SET @sql_dynamic = (
	SELECT
		GROUP_CONCAT( DISTINCT
			CONCAT(
				'SUM(IF(posname = '''
				, posname
				, ''', quantity,0))  AS `'
				, posname,'`'
			)
		)
	FROM `pointsofsale` WHERE `deleted`=0);
	-- SELECT  @sql_dynamic ;
	SET @sql=CONCAT('SELECT * FROM (SELECT m.`itemcode`,`itemname`,format(`unitprice`-`discount`,2) as `Unit Price`,',	
		@sql_dynamic,', SUM(quantity) as `Total Qty`, format(SUM(quantity*(`unitprice`-`discount`)),2) as `Total Value` 
		FROM `possales` p, `possalesdetails` pd, `pointsofsale` s, `products` m
		WHERE p.`possaleid`=pd.`possaleid` AND p.`pointofsaleid`=s.`posid` AND pd.`itemcode`=m.`productid` AND DATE_FORMAT(`p`.`receiptdate`,''%Y-%m-%d'') BETWEEN ''' ,$startdate,''' AND ''',$enddate,'''
		AND `itemname` LIKE ''%',$productname,'%'' AND IFNULL(p.`deleted`,0)=0 GROUP BY  m.`itemcode`,`Unit Price`,`itemname`  ORDER BY `itemname`) as a
		UNION	
		SELECT ''TOTAL'','''',FORMAT(AVG(`unitprice`),2),',@sql_dynamic,', SUM(quantity) as `Total Qty`,format(SUM(quantity*(`unitprice`-`discount`)),2) as `Total Value` 
		FROM `possales` p, `possalesdetails` pd, `pointsofsale` s, `products` m
		WHERE p.`possaleid`=pd.`possaleid` AND p.`pointofsaleid`=s.`posid` AND pd.`itemcode`=m.`productid` AND DATE_FORMAT(`p`.`receiptdate`,''%Y-%m-%d'') BETWEEN ''' ,$startdate,''' AND ''',$enddate,'''
		AND `itemname` LIKE ''%',$productname,'%'' AND IFNULL(p.`deleted`,0)=0'
		);
	-- select @sql;
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spfilterproductsbyname` */

/*!50003 DROP PROCEDURE IF EXISTS  `spfilterproductsbyname` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spfilterproductsbyname`(IN $clientid INT, IN $name VARCHAR(50), IN $posid INT)
BEGIN
                IF $posid = 0 THEN 
                    SELECT p.*, 
                           c.`categoryname`, 
                           IFNULL(CONCAT(u.`firstname`, ' ', u.`middlename`, ' ', u.`lastname`), 'System') AS addedbyname,
                           p.`sellingprice` - IFNULL((
                               SELECT CASE WHEN cs.`percentage` = 1 THEN (cs.`value` / 100) * p.`sellingprice` ELSE cs.`value` END 
                               FROM `customerpricematrix` cs
                               WHERE cs.`customercategoryid` = 2 AND cs.`itemid` = p.`productid`
                           ), 0) wholesaleprice,
                           fn_getitemstorebalanceasat(p.productid, $posid, CURDATE()) AS available_stock
                    FROM `products` p
                    LEFT JOIN `categories` c ON p.`categoryid` = c.`categoryid` AND p.`clientid` = c.`clientid`
                    LEFT JOIN `user` u ON p.`addedby` = u.`userid` AND p.`clientid` = u.`clientid`
                    WHERE p.`clientid` = $clientid 
                      AND p.`itemname` LIKE CONCAT('%', $name, '%') 
                      AND p.`deleted` = 0
                    ORDER BY p.`itemname`;
                ELSE
                    SELECT p.*, 
                           c.`categoryname`, 
                           IFNULL(CONCAT(u.`firstname`, ' ', u.`middlename`, ' ', u.`lastname`), 'System') AS addedbyname,
                           p.`sellingprice` - IFNULL((
                               SELECT CASE WHEN cs.`percentage` = 1 THEN (cs.`value` / 100) * p.`sellingprice` ELSE cs.`value` END 
                               FROM `customerpricematrix` cs
                               WHERE cs.`customercategoryid` = 2 AND cs.`itemid` = p.`productid`
                           ), 0) wholesaleprice,
                           fn_getitemstorebalanceasat(p.productid, $posid, CURDATE()) AS available_stock
                    FROM `products` p
                    LEFT JOIN `categories` c ON p.`categoryid` = c.`categoryid` AND p.`clientid` = c.`clientid`
                    LEFT JOIN `user` u ON p.`addedby` = u.`userid` AND p.`clientid` = u.`clientid`
                    WHERE p.`clientid` = $clientid 
                      AND p.`itemname` LIKE CONCAT('%', $name, '%') 
                      AND p.`deleted` = 0
                      AND c.`categoryid` IN (
                          SELECT `productcategoryid` 
                          FROM `posproductcategories` 
                          WHERE `posid` = $posid AND `deleted` = 0
                      )
                    ORDER BY p.`itemname`;
                END IF;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spfilterquotations` */

/*!50003 DROP PROCEDURE IF EXISTS  `spfilterquotations` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spfilterquotations`(`$customerid` INT, `$startdate` DATE, `$enddate` DATE, `$quotestatus` VARCHAR(50))
BEGIN
	IF $customerid=0 THEN
		IF $quotestatus='All' THEN
			SELECT q.*, c.`customername`, SUM(quantity*unitprice) AS `quotetotal`, DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotationdate
			FROM `quotation` q, `quotationdetails` qd,`customers`c
			WHERE q.`id`=qd.`quoteid` AND q.`customerid`=c.`customerid` AND DATE_FORMAT(`quotedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY `quoteno`
			ORDER BY `quoteno` DESC;
		ELSE
			SELECT q.*, c.`customername`, SUM(quantity*unitprice) AS `quotetotal` , DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotationdate
			FROM `quotation` q, `quotationdetails` qd,`customers`c
			WHERE q.`id`=qd.`quoteid` AND q.`customerid`=c.`customerid` AND DATE_FORMAT(`quotedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND `status`=$quotestatus	
			GROUP BY `quoteno`	
			ORDER BY `quoteno` DESC;
		END IF;
	ELSE
		IF $quotestatus='All' THEN
			SELECT q.*, c.`customername`, SUM(quantity*unitprice) AS `quotetotal` , DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotationdate
			FROM `quotation` q, `quotationdetails` qd,`customers`c
			WHERE q.`id`=qd.`quoteid` AND q.`customerid`=c.`customerid` AND DATE_FORMAT(`quotedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND c.customerid=$customerid
			GROUP BY `quoteno`
			ORDER BY `quoteno` DESC;
		ELSE
			SELECT q.*, c.`customername`, SUM(quantity*unitprice) AS `quotetotal`, DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotationdate 
			FROM `quotation` q, `quotationdetails` qd,`customers`c
			WHERE q.`id`=qd.`quoteid` AND q.`customerid`=c.`customerid` AND DATE_FORMAT(`quotedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND `status`=$quotestatus AND c.customerid=$customerid	
			GROUP BY `quoteno`
			ORDER BY `quoteno` DESC;
		END IF;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spfilterrawproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spfilterrawproducts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spfilterrawproducts`(IN $clientid INT, IN $name VARCHAR(100))
BEGIN
    SELECT `productid`, `itemcode`, `itemname`, `buyingprice` AS `sellingprice`, `unitofmeasure` AS `uom` 
    FROM `products` 
    WHERE `clientid` = $clientid AND `deleted` = 0 AND `rawmaterial` = 1 
      AND (`itemname` LIKE CONCAT('%', $name, '%') OR `itemcode` LIKE CONCAT('%', $name, '%')) 
    ORDER BY `itemname` LIMIT 20;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spfilterstocktransfer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spfilterstocktransfer` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spfilterstocktransfer`(`$branchid` INT, `$source` VARCHAR(50), `$sourceid` INT, `$destination` VARCHAR(50), `$destinationid` INT, `$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	IF $source='all' THEN
		IF $destination='all' THEN
			SELECT v.* FROM vwstocktransfers v JOIN stocktransfer t ON v.referenceno = t.referenceno
			WHERE t.branchid = $branchid AND v.`dateadded` BETWEEN $startdate AND $enddate
			ORDER BY v.dateadded;
		ELSEIF $destination='outlet' THEN
			SELECT v.* FROM vwstocktransfers v JOIN stocktransfer t ON v.referenceno = t.referenceno
			WHERE t.branchid = $branchid AND v.`dateadded` BETWEEN $startdate AND $enddate
			AND v.destinationid=$destinationid AND v.destinationtype='pos' 
			ORDER BY v.dateadded;
		ELSE
			SELECT v.* FROM vwstocktransfers v JOIN stocktransfer t ON v.referenceno = t.referenceno
			WHERE t.branchid = $branchid AND v.`dateadded` BETWEEN $startdate AND $enddate
			AND v.destinationid=$destinationid AND v.destinationtype='warehouse'
			ORDER BY v.dateadded;
		END IF;
	ELSE
		IF $destination='all' THEN
			SELECT v.* FROM vwstocktransfers v JOIN stocktransfer t ON v.referenceno = t.referenceno
			WHERE t.branchid = $branchid AND v.`dateadded` BETWEEN $startdate AND $enddate
			AND v.sourceid=$sourceid
			ORDER BY v.dateadded;
		ELSEIF $destination='outlet' THEN 
			SELECT v.* FROM vwstocktransfers v JOIN stocktransfer t ON v.referenceno = t.referenceno
			WHERE t.branchid = $branchid AND v.`dateadded` BETWEEN $startdate AND $enddate
			AND v.sourceid=$sourceid AND v.destinationid=$destinationid AND v.destinationtype='pos'
			ORDER BY v.dateadded;
		ELSE
			SELECT v.* FROM vwstocktransfers v JOIN stocktransfer t ON v.referenceno = t.referenceno
			WHERE t.branchid = $branchid AND v.`dateadded` BETWEEN $startdate AND $enddate
			AND v.sourceid=$sourceid AND v.destinationid=$destinationid AND v.destinationtype='warehouse'
			ORDER BY v.dateadded;
		END IF;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetaccountspayableaginganalysis` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetaccountspayableaginganalysis` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetaccountspayableaginganalysis`($branchid INT, $basedate DATETIME)
BEGIN
	SET @basedate=$basedate;
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	
	SELECT  IFNULL(suppliername,'TOTAL') AS suppliername,SUM(amountoverdue) AS `total`,
		SUM(IF(`range`='1',amountoverdue,0)) AS `thirty`,  
		SUM(IF(`range`='31',amountoverdue,0)) AS `sixty`,
		SUM(IF(`range`='61',amountoverdue,0)) AS `ninenty` ,
		SUM(IF(`range`='91',amountoverdue,0)) AS `onetwenty` ,
		SUM(IF(`range`='120+',amountoverdue,0)) AS `aboveonetwenty` 
	FROM (
		SELECT i.supplierinvoiceid AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,
		CASE 
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 1 AND 30 THEN '1' 
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 31 AND 60 THEN '31'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 61 AND 90 THEN '61'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 91 AND 120 THEN '91'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d'))>=120 THEN '120+' 
		END AS `range`,
		SUM(`quantity`*`unitprice`) -
		IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
		WHERE v.`paymentvoucherid`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno` 
		AND v.branchid = $branchid AND DATE_FORMAT(v.`date`,'%Y-%m-%d')<=@basedate),0) AS amountoverdue
		FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
		WHERE i.`supplierinvoiceid`=id.`invoiceid` AND s.`supplierid`=i.`supplierid` 
		AND i.branchid = $branchid
		AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
		GROUP BY i.supplierinvoiceid ,s.`supplierid`,suppliername,`invoiceno`,`status`,DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d'))
		ORDER BY `invoicedate` DESC, `invoiceno`
	) AS tab1
	GROUP BY suppliername
	WITH ROLLUP;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetaccountsreceivableaginganalysis` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetaccountsreceivableaginganalysis` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetaccountsreceivableaginganalysis`($branchid INT, $basedate DATETIME)
BEGIN
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	SET @basedate=$basedate;
	SELECT IFNULL(customername,'TOTAL') AS `customername`, 
		SUM(`balance`) AS `total`,
		SUM(IF(`range`='thirty',`balance`,0)) AS `thirty` ,
		SUM(IF(`range`='sixty',`balance`,0)) AS `sixty` ,
		SUM(IF(`range`='ninety',`balance`,0)) AS `ninety` ,
		SUM(IF(`range`='onetwenty',`balance`,0)) AS `onetwenty` ,
		SUM(IF(`range`='aboveonetwenty',`balance`,0)) AS `aboveonetwenty` 
	FROM(
		SELECT c.`customerid`, p.possaleid AS id,c.`customername`,
		CASE 
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d'))<=30 THEN 'thirty' 
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d')) BETWEEN 31 AND 60 THEN 'sixty'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d')) BETWEEN 61 AND 90 THEN 'ninety'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d')) BETWEEN 91 AND 120 THEN 'onetwenty'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d'))>120 THEN 'aboveonetwenty' 
		END AS `range`,
		pp.amount -
		IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`possaleid`),0) AS balance
		FROM `possales` p, `possalesdetails` pd, `possalespayments` pp, `customers` c
		WHERE p.`possaleid`=pd.`possaleid` AND pp.`possaleid`=p.`possaleid` AND pp.`paymentmode`=4 AND c.`customerid`=p.`customerid`
		AND p.branchid = $branchid
		AND pp.amount - IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`possaleid`),0)>0
		AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d')>=@cutoffdate
		GROUP BY c.`customerid`,p.possaleid,c.`customername`
	) AS tab1
	GROUP BY customername
	WITH ROLLUP;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetallusers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetallusers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetallusers`(IN $clientid INT)
BEGIN
    SELECT u.*, IFNULL(CONCAT(a.firstname,' ',a.middlename,' ',a.lastname),'System') AS addedbyname 
    FROM `user` u  LEFT OUTER JOIN `user` a ON u.addedby=a.userid
    WHERE u.clientid = $clientid
    ORDER BY u.`firstname`,u.`middlename`,u.`lastname`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetavailableproductserialnumbers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetavailableproductserialnumbers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetavailableproductserialnumbers`(
    IN $clientid INT,
    IN $itemid INT
)
BEGIN
    SELECT `serialno` FROM `goodsreceiveddetails` g
    WHERE `serialno` NOT IN(SELECT `serialno` FROM `possalesdetails` WHERE `itemcode`=$itemid)
    AND `itemcode`=$itemid
    ORDER BY `serialno`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbalancesheet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbalancesheet` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetbalancesheet`($branchid INT, $startdate DATETIME, $enddate DATETIME)
BEGIN
	SET @startdate = $startdate, @enddate = $enddate;
	SELECT 'PROFIT' AS `accountcode`, CASE WHEN SUM(`debit`-`credit`)>0 THEN 'Profit Before Tax' ELSE 'Loss Before Tax' END AS `accountname`, 'Financed By' AS classname,
	'Profit / Loss' AS `groupname`, SUM(`credit`-`debit`) AS `total`
	FROM `glaccounts` g, `gltransactions` t, `glaccountgroups` p, `glaccountclasses` c
	WHERE g.`id`=t.`glaccount` AND p.`id`=g.`groupid` AND p.`glaccountclass`=c.`id` 
	  AND t.branchid = $branchid
	  AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	  AND classname IN('Income','Expense')
		
	UNION 
	SELECT `accountcode`, `accountname`, classname,
	`groupname`, ABS(SUM(`debit`-`credit`)) AS `total`
	FROM `glaccounts` g, `gltransactions` t, `glaccountgroups` p, `glaccountclasses` c
	WHERE g.`id`=t.`glaccount` AND p.`id`=g.`groupid` AND p.`glaccountclass`=c.`id` 
	  AND t.branchid = $branchid
	  AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	  AND classname NOT IN('Income','Expense')
	GROUP BY `accountcode`, `accountname`, `groupname`
	ORDER BY classname, `accountcode`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbestcustomer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbestcustomer` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetbestcustomer`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SELECT customername, SUM(receipttotal) total 
	FROM `vwsalessummary`
	WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
	GROUP BY customername
	ORDER BY SUM(receipttotal) DESC 
	LIMIT 5;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbestpos` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbestpos` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetbestpos`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SELECT pointofsale, SUM(receipttotal) AS total 
	FROM `vwsalessummary` 
	WHERE transactiondate BETWEEN $startdate AND $enddate
	GROUP BY pointofsale
	ORDER BY SUM(receipttotal) DESC
	LIMIT 5;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbestproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbestproduct` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetbestproduct`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SELECT p.`itemcode`,`itemname`, SUM(quantity) sold FROM `products` p, `possales` s, `possalesdetails` sd
	WHERE `productid`=sd.itemcode AND s.`id`=sd.`possaleid` AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
	GROUP BY p.`itemcode`,`itemname`
	ORDER BY SUM(quantity) DESC
	LIMIT 5;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbestsellingcategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbestsellingcategory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetbestsellingcategory`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
    SELECT `categoryname`, SUM(s.`quantity`) quantity, AVG(s.`unitprice`) unitprice
    FROM `categories` c,`products` p,`possales` o,`possalesdetails` s
    WHERE c.`categoryid`=p.`categoryid` AND p.`productid`=s.`itemcode` AND s.`possaleid`=o.possaleid
    AND o.branchid = $branchid AND DATE(o.`receiptdate`) BETWEEN DATE($startdate) AND DATE($enddate)
    GROUP BY `categoryname`
    ORDER BY SUM(quantity) DESC 
    LIMIT 5;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbestsellingproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbestsellingproducts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetbestsellingproducts`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $userid INT)
BEGIN
	IF $userid=0 THEN
		SELECT `categoryname`,`itemname`,SUM(s.`quantity`) quantity,AVG(s.`unitprice`) unitprice
		FROM `categories` c,`products` p,`possales` o,`possalesdetails` s
		WHERE c.`categoryid`=p.`categoryid` AND p.`productid`=s.`itemcode` AND s.`possaleid`=o.possaleid
		AND o.branchid = $branchid AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY `categoryname`,`itemname`
		ORDER BY SUM(quantity) DESC 
		LIMIT 5;
	ELSE
		SELECT `categoryname`,`itemname`,SUM(s.`quantity`) quantity,AVG(s.`unitprice`) unitprice
		FROM `categories` c,`products` p,`possales` o,`possalesdetails` s
		WHERE c.`categoryid`=p.`categoryid` AND p.`productid`=s.`itemcode` AND s.`possaleid`=o.possaleid
		AND o.branchid = $branchid AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND o.addedby=$userid
		GROUP BY `categoryname`,`itemname`
		ORDER BY SUM(quantity) DESC 
		LIMIT 5;
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbundleitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbundleitems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetbundleitems`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM products WHERE clientid = $clientid AND bundleitem=1 AND IFNULL(deleted,0)=0
    ORDER BY `itemname`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcashbookaccounts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcashbookaccounts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcashbookaccounts`()
BEGIN
	SELECT g.`id`,`accountcode`,`accountname`, `groupname` FROM `glaccounts` g, `glaccountgroups` p
	WHERE p.`id`=g.`groupid` AND p.`cashbookaccount`=1 ORDER BY `accountname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcategories` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcategories`(IN $clientid INT)
BEGIN
    SELECT c.*, IFNULL(CONCAT(u.firstname, ' ', u.middlename, ' ', u.lastname), 'System') AS addedbyname 
    FROM `categories` c 
    LEFT OUTER JOIN `user` u ON c.addedby = u.userid
    WHERE c.clientid = $clientid AND c.deleted = 0 
    ORDER BY c.categoryname;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcategorydetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcategorydetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcategorydetails`(IN $clientid INT, IN $id INT)
BEGIN
    SELECT * FROM `categories` WHERE clientid = $clientid AND `categoryid` = $id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcities` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcities` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcities`(IN $countryid INT)
BEGIN
    IF $countryid = 0 THEN
        SELECT c.*, co.countryname 
        FROM cities c
        JOIN countries co ON c.countryid = co.countryid
        ORDER BY co.countryname ASC, c.cityname ASC;
    ELSE
        SELECT * FROM cities 
        WHERE countryid = $countryid
        ORDER BY cityname ASC;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcontactscategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcontactscategories` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcontactscategories`(IN $clientid INT)
BEGIN
    SELECT * FROM contactscategories WHERE clientid = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcountries` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcountries` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcountries`()
BEGIN
    SELECT * FROM countries 
    ORDER BY isdefault DESC, countryname ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcrateadditionparameters` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcrateadditionparameters` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcrateadditionparameters`()
BEGIN
	SELECT p.*,(SELECT `buyingprice` FROM `products` WHERE productid=p.productid) AS price
	FROM `cratesinventorysettings` p;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcrateinventorysettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcrateinventorysettings` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcrateinventorysettings`()
BEGIN
	SELECT s.*,IFNULL((SELECT `buyingprice` FROM `products` WHERE productid=s.productid),0) AS price
	FROM `cratesinventorysettings` s;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcreditnotevalue` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcreditnotevalue` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcreditnotevalue`(`$creditnotenumber` VARCHAR(50))
BEGIN
	SELECT `noteno`,`dateadded`,SUM(`quantity`*`unitprice`) AS creditnotetotal
	FROM `creditnotes` c, `creditnotedetails` cd
	WHERE c.`id`=cd.`noteid` AND `noteno`=$creditnotenumber;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomeraginganalysis` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomeraginganalysis` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomeraginganalysis`(
    IN $clientid INT,
    IN $basedate DATETIME,
    IN $customerid INT
)
BEGIN
    SET @cutoffdate = (SELECT DATE_FORMAT(cutoffdate, '%Y-%m-%d') FROM startingparameters WHERE clientid = $clientid);
    IF @cutoffdate IS NULL THEN SET @cutoffdate = '2000-01-01'; END IF;
    
    SELECT 
        IFNULL(SUM(IF(`range` = 'thirty', balance, 0)), 0) AS `thirty`,
        IFNULL(SUM(IF(`range` = 'sixty', balance, 0)), 0) AS `sixty`,
        IFNULL(SUM(IF(`range` = 'ninety', balance, 0)), 0) AS `ninety`,
        IFNULL(SUM(IF(`range` = 'onetwenty', balance, 0)), 0) AS `onetwenty`,
        IFNULL(SUM(IF(`range` = 'aboveonetwenty', balance, 0)), 0) AS `aboveonetwenty`,
        IFNULL(SUM(balance), 0) AS `total`
    FROM (
        SELECT 
            c.customerid, 
            p.possaleid AS id,
            c.customername,
            CASE 
                WHEN DATEDIFF($basedate, DATE_FORMAT(p.receiptdate, '%Y-%m-%d')) <= 30 THEN 'thirty' 
                WHEN DATEDIFF($basedate, DATE_FORMAT(p.receiptdate, '%Y-%m-%d')) BETWEEN 31 AND 60 THEN 'sixty'
                WHEN DATEDIFF($basedate, DATE_FORMAT(p.receiptdate, '%Y-%m-%d')) BETWEEN 61 AND 90 THEN 'ninety'
                WHEN DATEDIFF($basedate, DATE_FORMAT(p.receiptdate, '%Y-%m-%d')) BETWEEN 91 AND 120 THEN 'onetwenty'
                WHEN DATEDIFF($basedate, DATE_FORMAT(p.receiptdate, '%Y-%m-%d')) > 120 THEN 'aboveonetwenty' 
            END AS `range`,
            pm.amount - IFNULL((SELECT SUM(amount) FROM customerreceiptdetails WHERE possaleid = p.possaleid), 0) AS balance
        FROM possales p
        JOIN possalespayments pm ON p.possaleid = pm.possaleid
        JOIN customers c ON c.customerid = p.customerid
        WHERE c.clientid = $clientid
        AND pm.paymentmode = 4 
        AND p.customerid = $customerid
        AND p.deleted = 0
        AND pm.amount - IFNULL((SELECT SUM(amount) FROM customerreceiptdetails WHERE possaleid = p.possaleid), 0) > 0
        AND DATE_FORMAT(p.receiptdate, '%Y-%m-%d') >= @cutoffdate
        GROUP BY c.customerid, p.possaleid, c.customername, p.receiptdate, pm.amount
    ) AS tab1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomercategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomercategories` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomercategories`(IN $clientid INT)
BEGIN
    SELECT 
        id, 
        description AS categoryname,
        `default`
    FROM customercategories 
    WHERE clientid = $clientid 
    ORDER BY description;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomercontacts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomercontacts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomercontacts`(IN $clientid INT, IN $customerid INT)
BEGIN
    SELECT 
        cc.*,
        cat.description AS categoryname
    FROM customercontacts cc
    LEFT JOIN contactscategories cat ON cc.categoryid = cat.id
    WHERE cc.clientid = $clientid 
    AND cc.customerid = $customerid 
    AND cc.deleted = 0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomercreditnotes` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomercreditnotes` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomercreditnotes`(`$customerid` NUMERIC)
BEGIN
	SELECT `noteno` AS creditnotenumber FROM `creditnotes` WHERE `customerid`=$customerid AND `used`=0
	ORDER BY `noteno`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomerdetails`(IN $clientid INT, IN $customerid INT)
BEGIN
    SELECT * FROM `customers` WHERE clientid = $clientid AND customerid = $customerid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerdiscountsettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerdiscountsettings` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomerdiscountsettings`(IN $clientid INT, IN $customerid INT)
BEGIN
    SELECT 
        c.id,
        p.itemcode,
        p.itemname,
        p.sellingprice, 
        c.discount,
        c.percentage,
        c.expirydate 
    FROM products p
    JOIN customerdiscountsettings c ON c.productid = p.productid
    WHERE c.clientid = $clientid 
    AND c.customerid = $customerid 
    AND c.deleted = 0 
    ORDER BY p.itemname;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomeropenreceivables` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomeropenreceivables` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomeropenreceivables`(IN $clientid INT, IN $customerid INT)
BEGIN
    SET @cutoffdate = (SELECT DATE_FORMAT(cutoffdate, '%Y-%m-%d') FROM startingparameters WHERE clientid = $clientid LIMIT 1);
    
    SELECT 
        p.possaleid,
        p.receiptno,
        p.reference AS refno,
        p.customerid,
        p.receiptdate AS transactiondate, 
        SUM(pd.quantity * (pd.unitprice - IFNULL(pd.discount, 0))) AS total,
        IFNULL((SELECT SUM(amount) FROM customerreceiptdetails WHERE possaleid = p.possaleid), 0) AS paid,
        SUM(pd.quantity * (pd.unitprice - IFNULL(pd.discount, 0))) - IFNULL((SELECT SUM(amount) FROM customerreceiptdetails WHERE possaleid = p.possaleid), 0) AS balance
    FROM possales p
    JOIN possalesdetails pd ON p.possaleid = pd.possaleid
    JOIN possalespayments pp ON pp.possaleid = p.possaleid
    WHERE pp.paymentmode = 4 
    AND p.customerid = $customerid  
    AND p.branchid IN (SELECT branchid FROM branches WHERE clientid = $clientid)
    AND (DATE_FORMAT(p.receiptdate, '%Y-%m-%d') >= @cutoffdate OR @cutoffdate IS NULL)
    GROUP BY p.possaleid, p.customerid, p.receiptdate
    HAVING balance > 0
    ORDER BY p.receiptdate, p.possaleid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerperformance` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerperformance` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomerperformance`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
    DECLARE $total_revenue DECIMAL(18,2);
    
    -- Calculate total revenue for the period and branch once
    SELECT IFNULL(SUM(receipttotal), 0) INTO $total_revenue 
    FROM vwsalessummary2 
    WHERE branchid = $branchid 
    AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate);

    -- Return performance by customer
    IF $total_revenue > 0 THEN
        SELECT 
            customername as name,
            CASE 
                WHEN customername = 'WALKIN CUSTOMER' THEN 'Retail'
                ELSE 'Regular Account' 
            END as type,
            SUM(receipttotal) as revenue,
            ROUND((SUM(receipttotal) / $total_revenue) * 100, 1) as share,
            CASE 
                WHEN customername = 'WALKIN CUSTOMER' THEN 'shopping_cart'
                ELSE 'person' 
            END as icon
        FROM vwsalessummary2
        WHERE branchid = $branchid
        AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
        GROUP BY customername
        ORDER BY revenue DESC
        LIMIT 10;
    ELSE
        -- Return empty result set if no revenue to avoid division by zero
        SELECT NULL as name, NULL as type, NULL as revenue, NULL as share, NULL as icon LIMIT 0;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerreceiptdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerreceiptdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomerreceiptdetails`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomers`(IN $clientid INT, IN $posid INT, IN $regularcustomers TINYINT, IN $onetimecustomers TINYINT)
BEGIN
    DECLARE $defaultcustomerid INT;
    
    -- Get default customer ID from clients table (column is named defaultcustomer)
    SELECT defaultcustomer INTO $defaultcustomerid FROM clients WHERE clientid = $clientid;
    
    SELECT 
        $defaultcustomerid AS defaultcustomerid,
        c.* 
    FROM customers c
    WHERE c.clientid = $clientid AND c.deleted = 0
    AND (($regularcustomers = 1 AND c.onetimecustomer = 0) OR ($onetimecustomers = 1 AND c.onetimecustomer = 1))
    ORDER BY c.customername;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerstatement` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerstatement` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomerstatement`(
    IN $clientid INT,
    IN $customerid INT, 
    IN $startdate DATETIME, 
    IN $enddate DATETIME
)
BEGIN
    SET @cutoffdate = (SELECT DATE_FORMAT(cutoffdate, '%Y-%m-%d') FROM startingparameters WHERE clientid = $clientid);
    IF @cutoffdate IS NULL THEN SET @cutoffdate = '2000-01-01'; END IF;
    
    IF $startdate < @cutoffdate THEN 
        SET $startdate = @cutoffdate;
    END IF;
    
    SELECT 
        s.customerid, s.customername, s.physicaladdress, s.postaladdress, s.mobile, s.email, 
        DATE_FORMAT(s.`date`, '%d-%b-%Y') AS `date`, 
        s.narration, s.reference, s.invoiceamount, s.invoicepayment,
        (SELECT contactname FROM customercontacts WHERE customerid = s.customerid AND clientid = $clientid LIMIT 1) AS primarycontact,
        (SELECT mobile FROM customercontacts WHERE customerid = s.customerid AND clientid = $clientid LIMIT 1) AS contactmobile,
        (SELECT email FROM customercontacts WHERE customerid = s.customerid AND clientid = $clientid LIMIT 1) AS contactemail,
        IFNULL((SELECT SUM(invoiceamount) - SUM(invoicepayment) FROM vwcustomerstomerstatement v WHERE v.clientid = $clientid AND v.customerid = s.customerid AND DATE_FORMAT(`date`, '%Y-%m-%d') < $startdate), 0) AS openingbalance,
        IFNULL((SELECT SUM(invoiceamount) - SUM(invoicepayment) FROM vwcustomerstomerstatement v WHERE v.clientid = $clientid AND v.customerid = s.customerid AND DATE_FORMAT(`date`, '%Y-%m-%d') <= $enddate), 0) AS closingbalance,
        IFNULL((SELECT SUM(invoiceamount) FROM vwcustomerstomerstatement v WHERE v.clientid = $clientid AND v.customerid = s.customerid AND DATE_FORMAT(`date`, '%Y-%m-%d') BETWEEN $startdate AND $enddate), 0) AS invoices,
        IFNULL((SELECT SUM(invoicepayment) FROM vwcustomerstomerstatement v WHERE v.clientid = $clientid AND v.customerid = s.customerid AND DATE_FORMAT(`date`, '%Y-%m-%d') BETWEEN $startdate AND $enddate), 0) AS payments
    FROM vwcustomerstomerstatement s
    WHERE clientid = $clientid 
    AND customerid = $customerid 
    AND DATE_FORMAT(`date`, '%Y-%m-%d') BETWEEN $startdate AND $enddate
    ORDER BY DATE_FORMAT(`date`, '%Y-%m-%d'), `order`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerunbankedreceipts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerunbankedreceipts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomerunbankedreceipts`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomesuspenseaccountstatement` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomesuspenseaccountstatement` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetcustomesuspenseaccountstatement`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetdashboardheaders` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetdashboardheaders` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetdashboardheaders`(IN $branchid INT, IN $date DATE)
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM customers WHERE clientid = (SELECT clientid FROM branches WHERE branchid = $branchid) AND deleted = 0) AS activecustomers,
        (SELECT IFNULL(SUM(invoiceamount - invoicepayment), 0) FROM vwcustomerstomerstatement WHERE branchid = $branchid) AS openreceivables,
        (SELECT IFNULL(SUM(invoiceamount - settled), 0) FROM vwopenpayables WHERE branchid = $branchid) AS openpayables,
        (SELECT COUNT(DISTINCT purchaseorderno) FROM vwopenorders WHERE branchid = $branchid) AS openorders;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetdashboardsummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetdashboardsummary` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetdashboardsummary`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	DECLARE $totalsales NUMERIC(18,2) DEFAULT 0;
	DECLARE $margin NUMERIC(18,2) DEFAULT 0;
	DECLARE $topstorevalue NUMERIC(18,2) DEFAULT 0;
	DECLARE $topstorename VARCHAR(100)DEFAULT '';
	DECLARE $averagesale NUMERIC(18,2) DEFAULT 0;
    
	SET $totalsales=(SELECT SUM(receipttotal) FROM `vwsalessummary` WHERE transactiondate BETWEEN $startdate AND $enddate);
	SET $margin=$totalsales - (SELECT SUM(buyingprice*quantity)
		FROM `products` m, `possales` p, `possalesdetails` pd WHERE m.`productid`=pd.`itemcode` AND pd.`possaleid`=p.`id` 
		AND DATE_FORMAT(p.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate);
	SET $topstorevalue=(SELECT SUM(receipttotal) FROM `vwsalessummary` WHERE transactiondate BETWEEN $startdate AND $enddate GROUP BY pointofsale ORDER BY SUM(receipttotal) DESC LIMIT 1);
	SET $topstorename=(SELECT pointofsale FROM `vwsalessummary` WHERE transactiondate BETWEEN $startdate AND $enddate GROUP BY pointofsale ORDER BY SUM(receipttotal) DESC LIMIT 1);
	SET $averagesale=(SELECT AVG(receipttotal) FROM `vwsalessummary` WHERE transactiondate BETWEEN $startdate AND $enddate);
	
	SELECT IFNULL($totalsales,0) AS totalsales,IFNULL($margin,0) AS margin, IFNULL($topstorevalue,0) AS topstorevalue,IFNULL($topstorename,'') topstorename,
	IFNULL($averagesale,0) averagesale;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetdiscountreport` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetdiscountreport` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetdiscountreport`($branchid INT, $startdate DATETIME, $enddate DATETIME)
BEGIN
	SET @startdate = $startdate;
	SET @enddate = $enddate;
	
	SELECT * FROM (
		SELECT p.`itemcode` AS `Item Code`, `itemname` AS `Item Name`, FORMAT(`buyingprice`, 0) AS `Buying Price`, FORMAT(`sellingprice`, 0) AS `Selling Price`, FORMAT(SUM(quantity), 2) AS `Units Sold`, 
		FORMAT(SUM(quantity*unitprice), 2) AS `Total Sales`, FORMAT(SUM(discount), 2) AS `Discount`
		FROM `products` p, `possales` s, `possalesdetails` sd
		WHERE p.`productid` = sd.`itemcode` AND sd.`possaleid` = s.`possaleid`
		AND s.`branchid` = $branchid
		AND `receiptdate` BETWEEN @startdate AND @enddate AND IFNULL(s.deleted, 0) = 0
		GROUP BY p.`itemcode`, `itemname`, `buyingprice`, `sellingprice` 
		ORDER BY itemname
	) AS q1
	UNION
	SELECT '' AS `Item Code`, 'TOTAL' AS `Item Name`, 0 AS `Buying Price`, 0 AS `Selling Price`, FORMAT(SUM(quantity), 2) AS `Units Sold`, FORMAT(SUM(quantity*unitprice), 2) AS `Total Sales`, FORMAT(SUM(discount), 2) AS `Discount`
	FROM `products` p, `possales` s, `possalesdetails` sd
	WHERE p.`productid` = sd.`itemcode` AND sd.`possaleid` = s.`possaleid` AND IFNULL(s.deleted, 0) = 0
	AND s.`branchid` = $branchid
	AND `receiptdate` BETWEEN @startdate AND @enddate;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetemailconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetemailconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetemailconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `emailconfiguration` WHERE `clientid` = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglaccountclasses` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglaccountclasses` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetglaccountclasses`()
BEGIN
	SELECT `id`,`classname`,REPLACE(CONCAT(`classname`, CASE WHEN RIGHT(`classname`,1)='y' THEN 'ies' ELSE 's' END),'y','') AS newname 
	FROM glaccountclasses ORDER BY `classname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglaccountdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglaccountdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetglaccountdetails`(IN $branchid INT, IN $id INT)
BEGIN
                SELECT a.*, g.id AS subgroupid, gg.`id` AS parentgroupid, c.`id` AS classid 
                FROM `glaccounts` a, `glaccountgroups` g, `glaccountgroups` gg, `glaccountclasses` c 
                WHERE a.`groupid` = g.id 
                  AND g.`subactegoryof` = gg.id 
                  AND g.`glaccountclass` = c.id 
                  AND a.`id` = $id 
                  AND a.`clientid` = $branchid;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglaccounts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglaccounts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetglaccounts`(IN $branchid INT, IN $groupid INT)
BEGIN
                IF $groupid = 0 THEN
                    SELECT * FROM `glaccounts` 
                    WHERE `clientid` = $branchid 
                      AND `deleted` = 0 
                    ORDER BY `accountname`;
                ELSE
                    SELECT * FROM `glaccounts` 
                    WHERE `groupid` = $groupid 
                      AND `clientid` = $branchid 
                      AND `deleted` = 0 
                    ORDER BY `accountname`;
                END IF;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglgroups` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglgroups` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetglgroups`(IN $branchid INT, IN $category INT)
BEGIN
                IF $category = 0 THEN
                    SELECT * FROM `glaccountgroups` 
                    WHERE `branchid` = $branchid AND `deleted` = 0 
                    ORDER BY `groupname`;
                ELSE
                    SELECT * FROM `glaccountgroups` 
                    WHERE `glaccountclass` = $category AND `branchid` = $branchid AND `deleted` = 0 
                    ORDER BY `groupname`;
                END IF ;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglstatement` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglstatement` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetglstatement`($branchid INT, $startdate DATETIME, $enddate DATETIME, $accountid INT)
BEGIN
	SET @startdate = $startdate, @enddate = $enddate, @accountid = $accountid;
	SET @openingbalancedate = DATE_SUB(@startdate, INTERVAL 1 DAY);
	SET @cutoffdate = (SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	
	SELECT `accountcode`, `accountname`, `classname`, DATE_FORMAT(`transactiondate`,'%d-%b-%Y') AS `transactiondate`, `referenceno`, `narration`, `debit`, `credit`,
	CONCAT(`firstname`,' ',`middlename`) AS `addedby`,
	IFNULL((SELECT SUM(IFNULL(`debit`,0)-IFNULL(`credit`,0)) FROM `gltransactions` WHERE `glaccount`=a.id AND `branchid`=$branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @cutoffdate and @openingbalancedate),0) AS `openingbalance`,
	IFNULL((SELECT SUM(IFNULL(`debit`,0)) FROM `gltransactions` WHERE `glaccount`=a.id AND `branchid`=$branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate),0) AS `debits`,
	IFNULL((SELECT SUM(IFNULL(`credit`,0)) FROM `gltransactions` WHERE `glaccount`=a.id AND `branchid`=$branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate),0) AS `credits`,
	IFNULL((SELECT SUM(IFNULL(`debit`,0)-IFNULL(`credit`,0)) FROM `gltransactions` WHERE `glaccount`=a.id AND `branchid`=$branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @cutoffdate AND @enddate),0) AS `closingbalance`
	FROM `glaccounts` a, `glaccountgroups` g, `glaccountclasses` c, `user` u, `gltransactions` t
	WHERE a.`groupid`=g.`id` AND g.`glaccountclass`=c.id AND a.`id`=t.`glaccount` AND t.`addedby`=u.`userid`
	  AND t.branchid = $branchid
	  AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate AND a.`id`=@accountid
	ORDER BY `transactiondate`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglsubgroups` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglsubgroups` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetglsubgroups`(IN $branchid INT, IN $groupid INT)
BEGIN
                IF $groupid=0 THEN
                    SELECT * FROM `glaccountgroups` 
                    WHERE `subactegoryof` <> 0 
                      AND `branchid` = $branchid 
                      AND `deleted` = 0 
                    ORDER BY `groupname`;
                ELSE
                    SELECT * FROM `glaccountgroups` 
                    WHERE `subactegoryof` = $groupid 
                      AND `branchid` = $branchid 
                      AND `deleted` = 0 
                    ORDER BY `groupname`;
                END IF;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetgrnitemdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetgrnitemdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetgrnitemdetails`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetgrnproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetgrnproducts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetgrnproducts`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetheldsaledetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetheldsaledetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetheldsaledetails`(`$id` INT)
BEGIN
	SELECT `itemcode`, `itemname`, `quantity`,`unitprice`,`discount`,
	`fn_getitemstorebalance`(p.productid ,posid)itembalance 
	FROM `heldsalesdetails` hd, `products` p, `heldsales` h
	WHERE h.`id`=hd.`heldsaleid` AND p.`productid`=hd.`productid` AND `heldsaleid`=$id
	ORDER BY `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetheldsaleheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetheldsaleheader` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetheldsaleheader`(`$id` INT)
BEGIN
	SELECT `customerid`,`posid` FROM `heldsales` WHERE `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetheldsales` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetheldsales` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetheldsales`(`$userid` INT)
BEGIN
	SELECT h.`id`,`dateheld`,`customername`,`posname`
	FROM `heldsales` h, `customers` c, `pointsofsale` s

	WHERE h.`customerid`=c.`customerid` AND h.`posid`=s.`id` 
	AND h.`addedby`=$userid ORDER BY h.`id` DESC;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetinsertedcustomer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetinsertedcustomer` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetinsertedcustomer`(
    IN $clientid INT
)
BEGIN
    SELECT MAX(customerid) AS customerid FROM `customers` WHERE `clientid` = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetinstitutiondetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetinstitutiondetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetinstitutiondetails`(IN `$clientid` INT)
BEGIN
    SELECT 
        clientid AS id,
        client_name AS `name`,
        physical_address AS physicaladdress,
        postaladdress,
        landline,
        email,
        phone_number AS mobile,
        pinno,
        autoaddinvoiceduringgrn AS autoinvoicegrn,
        postalcode,
        quotationvalidity,
        tagline,
        website,
        receiptfooter,
        defaultcustomer,
        mainbusinesstype,
        logo,
        town,
        printreceipt,
        sendtovault,
        allow_price_change AS allowpricechange,
        allow_negative_sales_globally AS allownegativesalesglobally
    FROM `clients` 
    WHERE clientid = `$clientid`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetinvoicegrns` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetinvoicegrns` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetinvoicegrns`(
    IN $clientid INT,
    IN $invoiceid INT
)
BEGIN
    DECLARE $suppliercontrolaccount INT;
    SET $suppliercontrolaccount = (SELECT id FROM `glaccounts` WHERE `clientid` = $clientid AND `accountcode` = (SELECT `account` FROM `glaccountsettings` WHERE `clientid` = $clientid AND `description` = 'Suppliers Control Account'));
    
    SELECT p.`itemcode`, id.`description`, SUM(id.`quantity`) AS quantity, AVG(id.`unitprice`) AS unitprice, $suppliercontrolaccount AS accountcharged 
    FROM `supplierinvoicedetails` id
    INNER JOIN `products` p ON p.`productid` = id.`itemcode` AND p.clientid = id.clientid
    WHERE id.clientid = $clientid AND id.`invoiceid` = $invoiceid
    GROUP BY p.`itemcode`, id.`description`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetitemstatement` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetitemstatement` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetitemstatement`(
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
    JOIN `stockreconciledbalancedetails` sd ON sd.`reconciliationid`=s.`stockreconciledbalanceid` 
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
    INNER JOIN `possales` s ON pd.`possaleid`=s.`possaleid`
    WHERE p.clientid = $clientid AND p.itemcode=@itemcode AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND s.deleted=0
    GROUP BY  productid, p.itemcode,`itemname`, DATE_FORMAT(`receiptdate`,'%d-%b-%Y'), receiptno
    ORDER BY unmodifieddate,sortkey;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetmasterstocksheet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetmasterstocksheet` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetmasterstocksheet`(`$enddate` DATE)
BEGIN
	SET @basedate=DATE_FORMAT(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters`),'2020-01-01'),'%Y-%m-%d');
	SET @enddate=$enddate;
	SET @obdate=DATE_SUB(@enddate, INTERVAL 1 DAY);
	SELECT `itemcode` `Product Code`,`itemname` `Product Name`,
		IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
			WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d') BETWEEN @basedate AND @obdate),0)-
		IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
			WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN @basedate AND @obdate AND IFNULL(s.deleted,0)=0),0) AS `Opening Balance`,
		
		IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
			WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d')=@enddate),0) AS `Purchases`,
		
		IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
			WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d')=@enddate AND IFNULL(s.deleted,0)=0),0) AS `Sales`,
			
		IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
			WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d') BETWEEN @basedate AND @obdate),0)-
		IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
			WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN @basedate AND @obdate  AND IFNULL(s.deleted,0)=0),0) +
		
		IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
			WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d')=@enddate),0) -
		
		IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
			WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d')=@enddate AND IFNULL(s.deleted,0)=0),0) AS `Closing Balance`
	FROM products p	ORDER BY itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetmpesac2bparameters` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetmpesac2bparameters` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetmpesac2bparameters`()
BEGIN
	SELECT c2burl,c2bshortcode,c2bmsisdn FROM mpesaconfiguration;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetmpesaconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetmpesaconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetmpesaconfiguration`()
BEGIN
	SELECT * FROM `mpesaconfiguration`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetmpesatransaction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetmpesatransaction` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetmpesatransaction`(`$amount` INT, `$reference` VARCHAR(50))
BEGIN
	IF $reference='' THEN
		SELECT * FROM `mpesaconfirmation` WHERE `amount`=$amount AND DATE_FORMAT(`date`,'%Y-%m-%d')=DATE_FORMAT(NOW(),'%Y-%m-%d') AND IFNULL(`used`,0)=0;
	ELSE
		SELECT * FROM `mpesaconfirmation` WHERE `reference`=$reference AND IFNULL(`used`,0)=0;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetnonuseroutlets` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetnonuseroutlets` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetnonuseroutlets`(`$userid` INT)
BEGIN
	SELECT *
	FROM  `pointsofsale` s  
	WHERE `posid` NOT IN(SELECT `outletid` FROM `useroutlets` WHERE `userid`=$userid AND IFNULL(`deleted`,0)=0)
	AND IFNULL(s.deleted,0)=0
	ORDER BY posname;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetnonuserroles` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetnonuserroles` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetnonuserroles`(`$clientid` INT)
BEGIN
	SELECT * FROM `roles` 
	WHERE roleid NOT IN(SELECT `roleid` FROM `roleusers` WHERE `userid`=$clientid)
	ORDER BY rolename;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetobjectdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetobjectdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetobjectdetails`(`$objectid` INT)
BEGIN
	SELECT * FROM `objects` WHERE `id`=$objectid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetobjects` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetobjects` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetobjects`(IN $clientid INT, IN $module VARCHAR(50))
BEGIN
    IF $module='' OR $module IS NULL THEN
        SELECT `id`,`description`,`module` FROM `objects` WHERE clientid = $clientid ORDER BY `description`;
    ELSE
        SELECT `id`,`description`,`module` FROM `objects` WHERE clientid = $clientid AND `module` = $module ORDER BY `description`;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetparentgroups` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetparentgroups` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetparentgroups`(IN $branchid INT, IN $classid INT)
BEGIN
                IF $classid=0 THEN
                    SELECT * FROM `glaccountgroups` 
                    WHERE IFNULL(`subactegoryof`,0)=0 
                      AND `branchid` = $branchid 
                      AND `deleted` = 0 
                    ORDER BY `groupname`;
                ELSE
                    SELECT * FROM `glaccountgroups` 
                    WHERE IFNULL(`subactegoryof`,0)=0 
                      AND `glaccountclass` = $classid 
                      AND `branchid` = $branchid 
                      AND `deleted` = 0 
                    ORDER BY `groupname`;
                END IF;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentmethods` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentmethods` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpaymentmethods`(IN $clientid INT, IN $branchid INT)
BEGIN
    SELECT * 
    FROM paymentmethods 
    WHERE clientid = $clientid 
    AND branchid = $branchid 
    AND `show` = 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentmethodsummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentmethodsummary` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpaymentmethodsummary`(IN $clientid INT, IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
    SELECT 
        paymentmode, 
        SUM(receipttotal) AS total 
    FROM `vwsalessummary`
    WHERE transactiondate BETWEEN $startdate AND $enddate
    AND clientid = $clientid
    GROUP BY paymentmode  
    ORDER BY SUM(receipttotal) DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentvoucher` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentvoucher` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpaymentvoucher`($branchid int, $id varchar(50))
BEGIN
	select `suppliername`,`physicaladdress`,`postaladdress`,s.`mobile`,s.`email`, v.`voucherno`,date_format(v.`date`,'%d-%b-%Y') as voucherdate, `invoicenumber`,p.`description` as paymentmethod,`referenceno`,
	`itemcode`,vd.`description`,`quantity`,`unitprice`, concat(`firstname`, ' ',`middlename`,' ',`lastname`) as preparedby, o.`posname`
	from `paymentvouchers` v, `paymentvoucherdetails` vd, `paymentmethods` p, `suppliers` s, `user` u, `pointsofsale` o
	where v.`branchid` = $branchid and v.`paymentvoucherid`=vd.`voucherid` and v.`paymentmode`=p.id and v.`supplier`=s.supplierid and v.`addedby`=u.userid and o.posid=v.`pos` 
	and v.`voucherno`=$id; -- v.`id`=$id;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentvoucherdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentvoucherdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpaymentvoucherdetails`(
        IN $branchid INT,
        IN $id VARCHAR(50)
    )
BEGIN
        SELECT p.paymentvoucherid AS id,`voucherno`, DATE_FORMAT(`date`,'%d-%b-%Y')`date`,`dateadded`,`addedby`,`paymentmode`,`pos`,`supplier`,`invoicenumber`,`cashbookaccount`,`referenceno`,`status`,`lastmodifiedby`,`lastmodifieddate` 
        FROM `paymentvouchers` p, paymentvoucherdetails pd  
        WHERE p.`branchid` = $branchid AND p.`paymentvoucherid`=pd.`voucherid` AND voucherno=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentvouchers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentvouchers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpaymentvouchers`($branchid int, $supplierid int,$posid int, $stat varchar(50),$paymentmode int, $startdate datetime,$enddate datetime,$pettycashvoucher boolean)
BEGIN
	SELECT 
		voucherid,
		pettycashvoucher,
		voucherno,
		DATE_FORMAT(voucherdate, '%d-%b-%Y') AS voucherdate,
		paymentmodeid,
		paymentmodedescription,
		posid,
		posname,
		supplierid,
		suppliername,
		invoicenumber,
		cashbookaccountid,
		accountcode,
		accountname,
		referenceno,
		`status`,
		vouchertotal,
		userid,
		username
	FROM vwpaymentvouchers
	WHERE 
		-- Multi-tenant scoping with legacy fallback
		branchid = $branchid
		-- Date range filtering (type-safe, ignores time component)
		AND DATE(voucherdate) BETWEEN DATE($startdate) AND DATE($enddate)
		-- Petty Cash vs Normal Payment Voucher filtering
		AND pettycashvoucher = $pettycashvoucher
		-- Dynamic supplier filtering
		AND ($supplierid = 0 OR supplierid = $supplierid)
		-- Dynamic POS filtering
		AND ($posid = 0 OR posid = $posid)
		-- Dynamic status filtering
		AND ($stat = 'all' OR `status` = $stat)
		-- Dynamic payment mode filtering
		AND ($paymentmode = 0 OR paymentmodeid = $paymentmode)
	ORDER BY voucherno, voucherdate;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentvoucherstatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentvoucherstatus` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpaymentvoucherstatus`($branchid int, $id int)
BEGIN
	select `status` from `paymentvouchers` where `branchid` = $branchid and `paymentvoucherid`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpoitemsundelivered` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpoitemsundelivered` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpoitemsundelivered`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpos` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpos` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpos`(IN $branchid INT)
BEGIN
    SELECT 
        p.*,
        p.posid AS id,
        p.posname AS description,
        CONCAT_WS(' ', u.firstname, u.middlename, u.lastname) AS addedbyname
    FROM pointsofsale p
    LEFT JOIN `user` u ON p.addedby = u.userid
    WHERE p.branchid = $branchid AND p.deleted = 0 
    ORDER BY p.posname;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetposdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetposdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetposdetails`(IN $branchid INT, IN $posid INT)
BEGIN
    SELECT *, posid AS id FROM pointsofsale WHERE branchid = $branchid AND posid = $posid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetposreceipts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetposreceipts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetposreceipts`(
        IN `$branchid` INT,
        IN `$startdate` DATETIME,
        IN `$enddate` DATETIME,
        IN `$posid` INT,
        IN `$modeofpay` INT
    )
BEGIN
        DECLARE modeofpayname VARCHAR(50) DEFAULT "";
        IF $modeofpay>0 THEN
            SET modeofpayname=(SELECT `description` FROM `paymentmethods` WHERE `id`=$modeofpay);
        END IF;
        
        IF $posid=0 THEN 
            IF $modeofpay=0 THEN
                SELECT s.`possaleid` AS `id`,`posname` ,`receiptno` , DATE_FORMAT(`receiptdate`,"%d-%b-%Y") AS `date`,`customername`,
                GROUP_CONCAT(DISTINCT m.description ORDER BY m.description) AS description, 
                GROUP_CONCAT( DISTINCT CASE WHEN p.`reference`="" THEN " - " ELSE p.reference END) reference, 
                CASE WHEN s.`deleted`=0 THEN "Valid" ELSE "Cancelled" END AS `status`,
                SUM(p.amount) AS `amount`,(SELECT CONCAT (`firstname`," ",`middlename`) FROM `user` u WHERE u.userid=s.`addedby`) AS `addedby`
                FROM `possales` s,`customers` c, `pointsofsale` o, `possalespayments` p, `paymentmethods` m
                WHERE s.`customerid`=c.`customerid` AND s.`pointofsaleid`=o.`posid` AND p.`possaleid`=s.`possaleid` AND m.`id`=p.`paymentmode`
                AND DATE_FORMAT(`s`.`receiptdate`,"%Y-%m-%d") BETWEEN $startdate AND $enddate
                AND s.`branchid` = $branchid
                GROUP BY  s.possaleid,`receiptno`
                ORDER BY s.possaleid DESC;
            ELSE
                SELECT s.`possaleid` AS `id`,`posname` ,`receiptno` , DATE_FORMAT(`receiptdate`,"%d-%b-%Y") AS `date`,`customername`,
                GROUP_CONCAT(DISTINCT m.description ORDER BY m.description) AS description, 
                GROUP_CONCAT( DISTINCT CASE WHEN p.`reference`="" THEN " - " ELSE p.reference END) reference, 
                CASE WHEN s.`deleted`=0 THEN "Valid" ELSE "Cancelled" END AS `status`,
                SUM(p.amount) AS `amount`,(SELECT CONCAT (`firstname`," ",`middlename`) FROM `user` u WHERE u.userid=s.`addedby`) AS `addedby`
                FROM `possales` s,`customers` c, `pointsofsale` o, `possalespayments` p, `paymentmethods` m
                WHERE s.`customerid`=c.`customerid` AND s.`pointofsaleid`=o.`posid` AND p.`possaleid`=s.`possaleid` AND m.`id`=p.`paymentmode`
                AND DATE_FORMAT(`s`.`receiptdate`,"%Y-%m-%d") BETWEEN $startdate AND $enddate
                AND s.`branchid` = $branchid
                GROUP BY  s.possaleid,`receiptno`
                HAVING description LIKE CONCAT("%",modeofpayname,"%")
                ORDER BY s.possaleid DESC;
            END IF;
        ELSE	
        
            IF $modeofpay=0 THEN
                SELECT s.`possaleid` AS `id`,`posname` ,`receiptno` , DATE_FORMAT(`receiptdate`,"%d-%b-%Y") AS `date`,`customername`,
                GROUP_CONCAT(DISTINCT m.description ORDER BY m.description) AS description, 
                GROUP_CONCAT( DISTINCT CASE WHEN p.`reference`="" THEN " - " ELSE p.reference END) reference, 
                CASE WHEN s.`deleted`=0 THEN "Valid" ELSE "Cancelled" END AS `status`,
                SUM(p.amount) AS `amount`,(SELECT CONCAT (`firstname`," ",`middlename`) FROM `user` u WHERE u.userid=s.`addedby`) AS `addedby`
                FROM `possales` s,`customers` c, `pointsofsale` o, `possalespayments` p, `paymentmethods` m
                WHERE s.`customerid`=c.`customerid` AND s.`pointofsaleid`=o.`posid` AND p.`possaleid`=s.`possaleid` AND m.`id`=p.`paymentmode`
                AND DATE_FORMAT(`s`.`receiptdate`,"%Y-%m-%d") BETWEEN $startdate AND $enddate AND s.`pointofsaleid`=$posid
                AND s.`branchid` = $branchid
                GROUP BY  s.possaleid,`receiptno`, DATE_FORMAT(`receiptdate`,"%d-%b-%Y") , `customername`,s.deleted, `posname`,s.`addedby`
                ORDER BY s.possaleid DESC;
            ELSE
                SELECT s.`possaleid` AS `id`,`posname` ,`receiptno` , DATE_FORMAT(`receiptdate`,"%d-%b-%Y") AS `date`,`customername`,
                GROUP_CONCAT(DISTINCT m.description ORDER BY m.description) AS description, 
                GROUP_CONCAT( DISTINCT CASE WHEN p.`reference`="" THEN " - " ELSE p.reference END) reference, 
                CASE WHEN s.`deleted`=0 THEN "Valid" ELSE "Cancelled" END AS `status`,
                SUM(p.amount) AS `amount`,(SELECT CONCAT (`firstname`," ",`middlename`) FROM `user` u WHERE u.userid=s.`addedby`) AS `addedby`
                FROM `possales` s,`customers` c, `pointsofsale` o, `possalespayments` p, `paymentmethods` m
                WHERE s.`customerid`=c.`customerid` AND s.`pointofsaleid`=o.`posid` AND p.`possaleid`=s.`possaleid` AND m.`id`=p.`paymentmode`
                AND DATE_FORMAT(`s`.`receiptdate`,"%Y-%m-%d") BETWEEN $startdate AND $enddate AND s.`pointofsaleid`=$posid
                AND s.`branchid` = $branchid
                GROUP BY  s.possaleid,`receiptno`, DATE_FORMAT(`receiptdate`,"%d-%b-%Y") , `customername`,s.deleted, `posname`,s.`addedby`
                HAVING description LIKE CONCAT("%",modeofpayname,"%")
                ORDER BY s.possaleid DESC;
            END IF;
        END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetposreceiptsforbanking` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetposreceiptsforbanking` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetposreceiptsforbanking`(
        IN `$branchid` INT,
        IN `$startdate` DATETIME,
        IN `$enddate` DATETIME,
        IN `$posid` INT,
        IN `$modeofpay` INT
    )
BEGIN
        DECLARE $modeofpayname VARCHAR(50) DEFAULT "";
        IF $modeofpay > 0 THEN
            SET $modeofpayname = (SELECT `description` FROM `paymentmethods` WHERE `id` = $modeofpay);
        END IF;
        
        IF $posid = 0 THEN
            BEGIN
                IF $modeofpay = 0 THEN
                    SELECT v.id, v.pointofsale AS posname, v.receiptno, DATE_FORMAT(v.`transactiondate`,"%d-%b-%Y") `date`, v.paymentmode AS `description`, v.paymentmodereference reference, v.receipttotal amount, 
                    v.userfullname `addedby`, v.customername
                    FROM `vwsalessummary` v
                    INNER JOIN `possales` p ON p.receiptno = v.receiptno
                    WHERE DATE_FORMAT(v.`transactiondate`,"%Y-%m-%d") BETWEEN $startdate AND $enddate AND v.banked = 0 AND p.branchid = $branchid
                    ORDER BY DATE_FORMAT(v.`transactiondate`,"%d-%b-%Y"), v.receiptno;
                ELSE
                    SELECT v.id, v.pointofsale AS posname, v.receiptno, DATE_FORMAT(v.`transactiondate`,"%d-%b-%Y") `date`, v.paymentmode AS `description`, v.paymentmodereference reference, v.receipttotal amount, 
                    v.userfullname `addedby`, v.customername
                    FROM `vwsalessummary` v
                    INNER JOIN `possales` p ON p.receiptno = v.receiptno
                    WHERE DATE_FORMAT(v.`transactiondate`,"%Y-%m-%d") BETWEEN $startdate AND $enddate AND v.paymentmode = $modeofpayname AND v.banked = 0 AND p.branchid = $branchid
                    ORDER BY DATE_FORMAT(v.`transactiondate`,"%d-%b-%Y"), v.receiptno;
                END IF;
            END;
        ELSE
            BEGIN
                IF $modeofpay = 0 THEN
                    SELECT v.id, v.pointofsale AS posname, v.receiptno, DATE_FORMAT(v.`transactiondate`,"%d-%b-%Y") `date`, v.paymentmode AS `description`, v.paymentmodereference reference, v.receipttotal amount, 
                    v.userfullname `addedby`, v.customername
                    FROM `vwsalessummary` v
                    INNER JOIN `possales` p ON p.receiptno = v.receiptno
                    WHERE DATE_FORMAT(v.`transactiondate`,"%Y-%m-%d") BETWEEN $startdate AND $enddate AND v.posid = $posid AND v.banked = 0 AND p.branchid = $branchid
                    ORDER BY DATE_FORMAT(v.`transactiondate`,"%d-%b-%Y"), v.receiptno;
                ELSE
                    SELECT v.id, v.pointofsale AS posname, v.receiptno, DATE_FORMAT(v.`transactiondate`,"%d-%b-%Y") `date`, v.paymentmode AS `description`, v.paymentmodereference reference, v.receipttotal amount, 
                    v.userfullname `addedby`, v.customername
                    FROM `vwsalessummary` v
                    INNER JOIN `possales` p ON p.receiptno = v.receiptno
                    WHERE DATE_FORMAT(v.`transactiondate`,"%Y-%m-%d") BETWEEN $startdate AND $enddate AND v.paymentmode = $modeofpayname AND v.posid = $posid AND v.banked = 0 AND p.branchid = $branchid
                    ORDER BY DATE_FORMAT(v.`transactiondate`,"%d-%b-%Y"), v.receiptno;
                END IF;
            END;
        END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpossalespayments` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpossalespayments` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpossalespayments`(
    IN $clientid INT,
    IN $branchid INT,
    IN $receiptno VARCHAR(50)
)
BEGIN
    SELECT 
        m.`description` AS paymentmethod, 
        CASE WHEN p.`reference`='' THEN '-' ELSE p.`reference` END AS reference,
        p.`amount` 
    FROM `possalespayments` p
    INNER JOIN `paymentmethods` m ON p.`paymentmode` = m.`id`
    INNER JOIN `possales` ps ON ps.`possaleid` = p.`possaleid`
    WHERE ps.`branchid` = $branchid 
    AND ps.`receiptno` = $receiptno
    AND m.`clientid` = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetposstockbalanceasatdate` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetposstockbalanceasatdate` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetposstockbalanceasatdate`($branchid INT, $asatdate DATETIME, $posid INT)
BEGIN	
	SET @startdate = (SELECT DATE_SUB($asatdate, INTERVAL 1 DAY));
	SET @basedate = DATE(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters`), NOW())); 
	
	SELECT `itemcode`, `itemname`, `buyingprice`, `sellingprice`, 
	`fn_getitemstorebalanceasat`(productid, $posid, @startdate) AS openingbalance,
	
	-- Compute Day's Transfers and Sales
	IFNULL((
		SELECT SUM(`quantity`) 
		FROM `stocktransfer` s, `stocktransferdetails` sd 
		WHERE s.`stocktransferid` = sd.`transferid` 
		  AND `destinationtype` = 'pos' 
		  AND `destinationid` = $posid 
		  AND s.`branchid` = $branchid
		  AND DATE(`dateadded`) >= @basedate 
		  AND DATE(`dateadded`) = $asatdate 
		  AND sd.`itemcode` = p.`productid`
	), 0) AS transfersin,
	
	IFNULL((
		SELECT SUM(`quantity`) 
		FROM `stocktransfer` s, `stocktransferdetails` sd 
		WHERE s.`stocktransferid` = sd.`transferid` 
		  AND `sourcetype` = 'pos' 
		  AND `sourceid` = $posid 
		  AND s.`branchid` = $branchid
		  AND DATE(`dateadded`) >= @basedate 
		  AND DATE(`dateadded`) = $asatdate 
		  AND sd.`itemcode` = p.`productid`
	), 0) AS transfersout,
	
	-- Compute Days Sales
	IFNULL((
		SELECT SUM(quantity) 
		FROM `possales` s, `possalesdetails` sd 
		WHERE s.`possaleid` = sd.`possaleid` 
		  AND s.`branchid` = $branchid
		  AND DATE(`receiptdate`) >= @basedate 
		  AND DATE(`receiptdate`) = $asatdate
		  AND s.`pointofsaleid` = $posid 
		  AND s.deleted = 0 
		  AND sd.`itemcode` = p.`productid` 
		  AND IFNULL(`deleted`, 0) = 0
	), 0) AS sales
	
	FROM `categories` c, `products` p
	WHERE p.`categoryid` = c.`categoryid` 
	ORDER BY itemname, p.itemcode;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductbycategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductbycategory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductbycategory`(IN `$clientid` INT, IN `$categoryid` INT, IN `$posid` INT)
BEGIN
                IF `$categoryid` = 0 THEN
                    SELECT *, fn_getitemstorebalanceasat(productid, `$posid`, CURDATE()) AS available_stock 
                    FROM `products` 
                    WHERE clientid = `$clientid` AND `deleted` = 0 
                    ORDER BY `itemname`;
                ELSE
                    SELECT *, fn_getitemstorebalanceasat(productid, `$posid`, CURDATE()) AS available_stock 
                    FROM `products` 
                    WHERE clientid = `$clientid` AND `categoryid` = `$categoryid` AND `deleted` = 0 
                    ORDER BY `itemname`;
                END IF;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductdetails`(IN $clientid INT, IN $productcode VARCHAR(50), IN $customerid INT, IN $storeid INT)
BEGIN
    SELECT * FROM `products` WHERE clientid = $clientid AND (`itemcode` = $productcode OR `itemname` = $productcode) AND `deleted` = 0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductdiscountmatrix` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductdiscountmatrix` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductdiscountmatrix`(
    IN $clientid INT,
    IN $itemcode VARCHAR(50)
)
BEGIN
    SELECT c.`id` AS customercategoryid, `description` AS customercategory, `percentage`,`value` 
    FROM `customerpricematrix` m,`customercategories` c, `products` p
    WHERE c.`id`=m.`customercategoryid` AND p.`productid`=m.`itemid` AND p.`itemcode`=$itemcode
    AND p.`clientid` = $clientid AND c.`clientid` = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductions` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductions` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductions`(
    IN $clientid INT,
    IN $alldates INT,
    IN $startdate DATE,
    IN $enddate DATE,
    IN $warehouseid INT,
    IN $productid INT
)
BEGIN
    SELECT pr.`id`, DATE_FORMAT(pr.`productiondate`, '%d-%b-%Y') AS `productiondate_fmt`, pr.`productiondate`, pr.`productid`, pr.`quantity`, pr.`warehouseid`, DATE_FORMAT(pr.`dateadded`, '%d-%b-%Y %H:%i') AS `dateadded_fmt`,
           p.`itemname`, p.`itemcode`, p.`uom`, w.`warehousename`, u.`username` AS `addedby`
    FROM `productions` pr
    INNER JOIN `products` p ON pr.`productid` = p.`productid`
    INNER JOIN `warehouses` w ON pr.`warehouseid` = w.`warehouseid`
    INNER JOIN `users` u ON pr.`addedby` = u.`userid`
    WHERE pr.`clientid` = $clientid
      AND pr.`deleted` = 0
      AND ($alldates = 1 OR (pr.`productiondate` BETWEEN $startdate AND $enddate))
      AND ($warehouseid = 0 OR pr.`warehouseid` = $warehouseid)
      AND ($productid = 0 OR pr.`productid` = $productid)
    ORDER BY pr.`productiondate` DESC, pr.`id` DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductpricinghistory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductpricinghistory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductpricinghistory`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductpurchasehistory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductpurchasehistory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductpurchasehistory`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductrecipes` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductrecipes` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductrecipes`(IN $clientid INT, IN $productid INT)
BEGIN
    SELECT pr.`id`, pr.`quantity`, p.`itemcode`, p.`itemname`, p.`unitofmeasure` AS `uom`, p.`buyingprice` AS `sellingprice`, (pr.`quantity` * p.`buyingprice`) AS `total`, pr.`recipeitemid`
    FROM `productrecipes` pr
    INNER JOIN `products` p ON pr.`recipeitemid` = p.`productid`
    WHERE pr.`clientid` = $clientid AND pr.`productid` = $productid
    ORDER BY p.`itemname`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductsaleshistory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductsaleshistory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductsaleshistory`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductsplitunits` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductsplitunits` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductsplitunits`(IN $clientid INT, IN $productid INT)
BEGIN
    SELECT psu.`id`, psu.`unitname`, psu.`unitsoftotal`, psu.`unitprice`, DATE_FORMAT(psu.`dateadded`, '%d-%b-%Y %H:%i') AS `dateadded`, u.`username` AS `addedby`, psu.`productid`
    FROM `productsplitunits` psu
    LEFT JOIN `user` u ON psu.`addedby` = u.`userid`
    WHERE psu.`clientid` = $clientid AND psu.`productid` = $productid
    ORDER BY psu.`unitname`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductspoilagehistory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductspoilagehistory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductspoilagehistory`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductswithrecipes` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductswithrecipes` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproductswithrecipes`(IN $clientid INT)
BEGIN
    SELECT DISTINCT p.`productid`, p.`itemname`, p.`itemcode`, p.`uom`
    FROM `products` p
    INNER JOIN `productrecipes` pr ON p.`productid` = pr.`productid`
    WHERE p.`clientid` = $clientid AND p.`deleted` = 0
    ORDER BY p.`itemname` ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproducttransfershistory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproducttransfershistory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetproducttransfershistory`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetprofitabilityreport` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetprofitabilityreport` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetprofitabilityreport`($branchid INT, $startdate VARCHAR(50), $enddate VARCHAR(50), $posid INT)
BEGIN
	IF $posid = 0 THEN 
		SELECT m.`itemcode`, `itemname`, FORMAT(`buyingprice`, 2) AS `Buying Price`, FORMAT(AVG(`unitprice`), 2) AS sellingprice, FORMAT(SUM(`quantity`), 2) AS unitssold, 
		FORMAT(SUM(`buyingprice` * `quantity`), 2) AS `Total Purchases`, FORMAT(SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`), 2) AS `Total Sales`,
		FORMAT((SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`)) - (`buyingprice` * SUM(`quantity`)), 2) AS Margin
		FROM `products` m, `possales` p, `possalesdetails` pd
		WHERE m.`productid` = pd.`itemcode` AND pd.`possaleid` = p.`possaleid` AND p.`branchid` = $branchid AND DATE_FORMAT(p.`receiptdate`, '%Y-%m-%d') BETWEEN $startdate AND $enddate
		AND IFNULL(p.`deleted`, 0) = 0
		GROUP BY `itemcode`, `itemname`, `buyingprice`
		UNION 
		SELECT 'TOTAL: ' AS itemcode, '' AS itemname,
		FORMAT(AVG(`buyingprice`), 2) AS `Buying Price`, FORMAT(AVG(`unitprice`), 2) AS sellingprice, FORMAT(SUM(`quantity`), 2) AS unitssold, 
		FORMAT(SUM(`buyingprice` * `quantity`), 2) AS `Total Purchases`, 
		FORMAT(SUM(`quantity` * (`unitprice` - IFNULL(discount, 0))), 2) AS `Total Sales`,
		FORMAT(SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`) - SUM(`buyingprice` * `quantity`), 2) AS Margin
		FROM `products` m, `possales` p, `possalesdetails` pd
		WHERE m.`productid` = pd.`itemcode` AND pd.`possaleid` = p.`possaleid` AND p.`branchid` = $branchid AND DATE_FORMAT(p.`receiptdate`, '%Y-%m-%d') BETWEEN $startdate AND $enddate
		AND IFNULL(p.`deleted`, 0) = 0
		;
	ELSE
		SELECT m.`itemcode`, `itemname`, FORMAT(`buyingprice`, 2) AS `Buying Price`, FORMAT(AVG(`unitprice`), 2) AS sellingprice, FORMAT(SUM(`quantity`), 2) AS unitssold, 
		FORMAT(SUM(`buyingprice` * `quantity`), 2) AS `Total Purchases`, FORMAT(SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`), 2) AS `Total Sales`,
		FORMAT((SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`)) - (`buyingprice` * SUM(`quantity`)), 2) AS Margin
		FROM `products` m, `possales` p, `possalesdetails` pd
		WHERE m.`productid` = pd.`itemcode` AND pd.`possaleid` = p.`possaleid` AND p.`branchid` = $branchid
		AND DATE_FORMAT(p.`receiptdate`, '%Y-%m-%d') BETWEEN $startdate AND $enddate AND `pointofsaleid` = $posid
		AND IFNULL(p.`deleted`, 0) = 0
		GROUP BY `itemcode`, `itemname`, `buyingprice`
		UNION 
		SELECT 'TOTAL: ' AS itemcode, '' AS itemname,
		FORMAT(AVG(`buyingprice`), 2) AS `Buying Price`, FORMAT(AVG(`unitprice`), 2) AS sellingprice, FORMAT(SUM(`quantity`), 2) AS unitssold, 
		FORMAT(SUM(`buyingprice` * `quantity`), 2) AS `Total Purchases`, 
		FORMAT(SUM(`quantity` * (`unitprice` - IFNULL(discount, 0))), 2) AS `Total Sales`,
		FORMAT(SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`) - SUM(`buyingprice` * `quantity`), 2) AS Margin
		FROM `products` m, `possales` p, `possalesdetails` pd
		WHERE m.`productid` = pd.`itemcode` AND pd.`possaleid` = p.`possaleid` AND p.`branchid` = $branchid AND DATE_FORMAT(p.`receiptdate`, '%Y-%m-%d') BETWEEN $startdate AND $enddate 
		AND IFNULL(p.`deleted`, 0) = 0
		AND `pointofsaleid` = $posid 
		;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetprofitandlossaccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetprofitandlossaccount` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetprofitandlossaccount`($branchid INT, $startdate DATETIME, $enddate DATETIME)
BEGIN
	SET @startdate = $startdate, @enddate = $enddate;
	SELECT `accountcode`, `accountname`, classname,
	ABS(SUM(`debit`-`credit`)) AS `total`
	FROM `glaccounts` g, `gltransactions` t, `glaccountgroups` p, `glaccountclasses` c
	WHERE g.`id`=t.`glaccount` AND p.`id`=g.`groupid` AND p.`glaccountclass`=c.`id` 
	  AND t.branchid = $branchid
	  AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	  AND classname IN('Income','Expense')
	GROUP BY `accountcode`, `accountname` 
	ORDER BY classname DESC, `accountcode`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetprofitandlossaccountdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetprofitandlossaccountdetails` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetprofitandlossaccountdetails`($branchid INT, $startdate DATETIME, $enddate DATETIME)
BEGIN
	SET @startdate = DATE_FORMAT($startdate, '%Y-%m-%d');
	SET @enddate = DATE_FORMAT($enddate, '%Y-%m-%d');
	SELECT `classname`, `accountcode`, `accountname`, SUM(IFNULL(debit,0)-IFNULL(credit,0)) AS amount
	FROM `glaccounts` g, `gltransactions` t, `glaccountgroups` r, `glaccountclasses` c
	WHERE g.`groupid`=r.`id` AND r.`glaccountclass`=c.`id` AND c.classname IN('Expense','Income')
	  AND g.`accountcode` NOT IN(SELECT account FROM `glaccountsettings`) 
	  AND t.`glaccount`=g.`id`
	  AND t.branchid = $branchid
	  AND DATE_FORMAT(transactiondate, '%Y-%m-%d') BETWEEN @startdate AND @enddate
	GROUP BY `classname`, `accountcode`, `accountname`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetprofitandlossaccountheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetprofitandlossaccountheader` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgetprofitandlossaccountheader`($branchid INT, $startdate DATETIME, $enddate DATETIME)
BEGIN
	SET @salesaccount = (SELECT id FROM glaccounts WHERE `accountcode`=(SELECT `account` FROM `glaccountsettings` WHERE `description`='Sales'));
	SET @stockaccount = (SELECT id FROM glaccounts WHERE `accountcode`=(SELECT `account` FROM `glaccountsettings` WHERE `description`='Cost of Goods Sold'));
	SET @startdate = DATE_FORMAT($startdate, '%Y-%m-%d');
	SET @enddate = DATE_FORMAT($enddate, '%Y-%m-%d');
	SET @cutoffdate = DATE_FORMAT((SELECT `cutoffdate` FROM `startingparameters`), '%Y-%m-%d');
	
	SET @salesamount = IFNULL((
		SELECT SUM(quantity*unitprice) 
		FROM possales p, possalesdetails pd 
		WHERE p.possaleid = pd.possaleid 
		  AND p.branchid = $branchid
		  AND DATE_FORMAT(p.receiptdate, '%Y-%m-%d') BETWEEN @startdate AND @enddate 
		  AND IFNULL(p.deleted, 0) = 0
	), 0);
	
	SET @purchases = (
		SELECT SUM(gd.quantity*pd.unitprice) 
		FROM goodsreceived g, goodsreceiveddetails gd, purchaseorders p, purchaseorderdetails pd 
		WHERE g.`grnno` = gd.`grnno` 
		  AND p.purchaseorderid = pd.`purchaseorderid` 
		  AND gd.`purchaseorderno` = p.purchaseorderno 
		  AND pd.`itemcode` = gd.`itemcode` 
		  AND g.branchid = $branchid
		  AND p.branchid = $branchid
		  AND DATE_FORMAT(g.`datereceived`, '%Y-%m-%d') BETWEEN @startdate AND @enddate
	);
	
	SET @startdate = DATE_SUB(@startdate, INTERVAL 1 DAY);
	SET @reconcilliationid = IFNULL((
		SELECT `stockreconciledbalanceid` 
		FROM `stockreconciledbalance` 
		WHERE branchid = $branchid 
		  AND DATE_FORMAT(`reconciliationdate`, '%Y-%m-%d') < @startdate 
		ORDER BY `reconciliationdate` DESC LIMIT 1
	), 0);
	
	SET @reconciliationdate = IFNULL((
		SELECT DATE_FORMAT(`reconciliationdate`, '%Y-%m-%d') 
		FROM `stockreconciledbalance` 
		WHERE branchid = $branchid 
		  AND DATE_FORMAT(`reconciliationdate`, '%Y-%m-%d') < @startdate 
		ORDER BY `reconciliationdate` DESC LIMIT 1
	), @startdate);
	
	SET @tentativestartdate = DATE_SUB(@startdate, INTERVAL 1 DAY);
	
	SET @openingstock = IFNULL((
		SELECT SUM(quantity*unitprice) 
		FROM `stockreconciledbalance` s, `stockreconciledbalancedetails` sb 
		WHERE s.`stockreconciledbalanceid` = sb.`reconciliationid` 
		  AND s.branchid = $branchid 
		  AND s.`stockreconciledbalanceid` = @reconcilliationid
	), 0);
	
	-- Get purchases since last reconciliation
	SET @purchasessincelastreconciliation = IFNULL((
		SELECT SUM(quantity*buyingprice) 
		FROM goodsreceiveddetails g, products p 
		WHERE p.`productid` = g.`itemcode` 
		  AND grnno IN (
			  SELECT grnno 
			  FROM `goodsreceived` 
			  WHERE branchid = $branchid 
				AND DATE_FORMAT(datereceived, '%Y-%m-%d') BETWEEN @reconciliationdate AND @tentativestartdate
		  )
	), 0);
	
	-- Get sales since last reconciliation
	SET @salessincelastreconciliation = IFNULL((
		SELECT SUM(quantity*buyingprice) 
		FROM `possales` p, `possalesdetails` pd, products r 
		WHERE p.`possaleid` = pd.`possaleid` 
		  AND r.`productid` = pd.`itemcode` 
		  AND p.branchid = $branchid 
		  AND DATE_FORMAT(`receiptdate`, '%Y-%m-%d') BETWEEN @reconciliationdate AND @tentativestartdate 
		  AND IFNULL(p.deleted, 0) = 0
	), 0);
	
	-- Compute the correct opening balance (using correct opening stock variable)
	SET @openingstock = @openingstock + @purchasessincelastreconciliation - @salessincelastreconciliation;
	
	-- Get purchases since start date
	SET @purchasessincestartdate = IFNULL((
		SELECT SUM(quantity*buyingprice) 
		FROM goodsreceiveddetails g, products p 
		WHERE p.`productid` = g.`itemcode` 
		  AND grnno IN (
			  SELECT grnno 
			  FROM `goodsreceived` 
			  WHERE branchid = $branchid 
				AND DATE_FORMAT(datereceived, '%Y-%m-%d') BETWEEN @startdate AND @enddate
		  )
	), 0);
	
	-- Get sales since start date
	SET @salessincestartdate = IFNULL((
		SELECT SUM(quantity*buyingprice) 
		FROM `possales` p, `possalesdetails` pd, products r 
		WHERE p.`possaleid` = pd.`possaleid` 
		  AND r.`productid` = pd.`itemcode` 
		  AND p.branchid = $branchid 
		  AND DATE_FORMAT(`receiptdate`, '%Y-%m-%d') BETWEEN @startdate AND @enddate 
		  AND IFNULL(p.deleted, 0) = 0
	), 0);
	
	-- Compute the closing stock
	SET @closingstock = @openingstock + @purchasessincestartdate - @salessincestartdate;
	
	SELECT @salesamount AS `sales`, @openingstock AS `openingstock`, @purchases AS `purchases`, @closingstock AS `closingstock`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpropertydocumenttemplates` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpropertydocumenttemplates` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpropertydocumenttemplates`()
BEGIN
	SELECT * FROM `propertydocumenttemplates` ORDER BY `description`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpurchaseorderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpurchaseorderdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpurchaseorderdetails`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpurchaseorders` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpurchaseorders` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetpurchaseorders`(IN $branchid INT)
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetquotationterms` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetquotationterms` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetquotationterms`()
BEGIN
	SELECT * FROM `quotationterms`
	ORDER BY `termname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreceiptdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreceiptdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreceiptdetails`(IN $clientid INT, IN $branchid INT, IN $receiptno VARCHAR(50))
BEGIN
    SELECT 
        s.*, 
        sd.*, 
        p.itemname, 
        p.itemcode, -- Explicitly selected to override sd.itemcode (productid) in PHP associative array
        SUM(sd.quantity) AS quantity, -- Override sd.quantity with aggregated quantity
        c.customername, 
        (SELECT GROUP_CONCAT(DISTINCT pm.description SEPARATOR ', ') 
         FROM possalespayments pay 
         JOIN paymentmethods pm ON pm.id = pay.paymentmode 
         WHERE pay.possaleid = s.possaleid
         AND pm.clientid = $clientid
        ) AS paymentmode, 
        CONCAT_WS(' ', u.firstname, u.lastname) AS servedby, 
        pos.posname AS posname
    FROM `possales` s
    JOIN `possalesdetails` sd ON s.possaleid = sd.possaleid
    JOIN `products` p ON p.productid = sd.itemcode
    JOIN `customers` c ON c.customerid = s.customerid
    JOIN `user` u ON u.userid = s.addedby
    JOIN `pointsofsale` pos ON pos.posid = s.pointofsaleid
    WHERE s.branchid = $branchid 
    AND s.receiptno = $receiptno
    GROUP BY sd.itemcode;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreceiptitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreceiptitems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreceiptitems`(`$receiptno` VARCHAR(50))
BEGIN
	SELECT DISTINCT sd.`itemcode` AS productid, p.`itemcode`,
	TRIM(CONCAT(`itemname` ,' ', CASE WHEN `description`!='' THEN `description` ELSE '' END)) itemname
	FROM `possalesdetails` sd,`products` p, `possales` s
	WHERE sd.itemcode=p.productid AND s.`id`=sd.`possaleid` AND s.`receiptno`=$receiptno AND IFNULL(s.deleted,0)=0
	ORDER BY `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreceiptitemsdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreceiptitemsdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreceiptitemsdetails`(`$receiptno` VARCHAR(50), `$productid` INT)
BEGIN
	SELECT p.productid,p.`itemcode`, `itemname`,`quantity`,`unitprice`,`serialno`
	FROM `possales` s, `possalesdetails` sd, `products` p
	WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid 
	AND p.productid=$productid AND s.receiptno=$receiptno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreceiptvatanalysis` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreceiptvatanalysis` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreceiptvatanalysis`(
    IN $clientid INT,
    IN $branchid INT,
    IN $receiptno VARCHAR(50)
)
BEGIN
    SELECT 
        t.`abbreviation`,
        IFNULL(pd.`taxrate`, t.`taxrate`) AS taxrate,
        SUM(pd.quantity * (pd.unitprice - pd.discount)) AS total,
        SUM(pd.quantity * (pd.unitprice - pd.discount)) * IFNULL(pd.`taxrate`, t.`taxrate`) / (100 + IFNULL(pd.`taxrate`, t.`taxrate`)) AS vat
    FROM `possalesdetails` pd
    INNER JOIN `possales` p ON pd.`possaleid` = p.`possaleid`
    INNER JOIN `products` prod ON pd.`itemcode` = prod.`productid`
    INNER JOIN `taxtypes` t ON IFNULL(pd.`taxtypeid`, prod.`taxtypeid`) = t.`id`
    WHERE p.`branchid` = $branchid 
    AND p.`receiptno` = $receiptno
    AND t.`clientid` = $clientid
    GROUP BY t.`abbreviation`, taxrate
    ORDER BY taxrate;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreorderitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreorderitems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreorderitems`(IN $branchid INT)
BEGIN
    
    
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturninwards` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturninwards` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreturninwards`(`$startdate` DATE, `$enddate` DATE)
BEGIN
	SELECT r.id, DATE_FORMAT(r.`dateadded`,'%d-%b-%Y') dateadded, s.receiptno,p.itemcode,itemname,r.serialno,r.quantity,
	sd.unitprice,r.quantity*sd.unitprice total, refno, IFNULL(collected,0) collected
	FROM `possales` s, `possalesdetails` sd, `products` p, `returninwards` r
	WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND p.productid=r.`productid` AND r.`possaleid`=s.id
	AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	ORDER BY r.`dateadded`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturninwardsdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturninwardsdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreturninwardsdetails`(`$refno` VARCHAR(50))
BEGIN
	SELECT itemcode, itemname, serialno,quantity,narration
	FROM `returninwards` ri, products p
	WHERE p.`productid`=ri.`productid` AND `refno`=$refno
	ORDER BY itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturninwardsheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturninwardsheader` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreturninwardsheader`(`$refno` VARCHAR(50))
BEGIN
	SELECT ri.id,c.customerid, customername, receiptno,DATE_FORMAT(ri.`dateadded`,'%d-%b-%Y') dateadded,refno, CONCAT(firstname,' ',lastname) username
	FROM returninwards ri, `possales` p, customers c, `user` u
	WHERE ri.`possaleid`=p.`id` AND p.`customerid`=c.`customerid` 
	AND ri.refno=$refno AND u.id=ri.addedby;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturninwardssummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturninwardssummary` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreturninwardssummary`(`$asatdate` DATE)
BEGIN
	SELECT itemcode,itemname, SUM(quantity) quantity,serialno,narration,DATE_FORMAT(ro.dateadded,'%d-%b-%Y') dateadded,refno
	FROM `returninwards` ro, products p
	WHERE ro.productid=p.productid AND DATE_FORMAT(ro.`dateadded`,'%Y-%m%-%d') <=$asatdate 
	AND IFNULL(`collected`,0)=0
	GROUP BY itemcode,itemname,serialno,narration, refno
	ORDER BY itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturnoutwards` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturnoutwards` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreturnoutwards`(`$startdate` DATE, `$enddate` DATE)
BEGIN
	SELECT r.id, DATE_FORMAT(r.`dateadded`,'%d-%b-%Y') dateadded, s.grnno,p.itemcode,itemname,r.serialno,r.quantity,
	od.unitprice  unitprice,r.quantity*od.`unitprice` total,r.refno, IFNULL(r.delivered,0) delivered
	FROM `goodsreceived` s, `goodsreceiveddetails` sd, `products` p, `returnoutwards` r,
	purchaseorders o, purchaseorderdetails od
	WHERE o.`id`=od.`purchaseorderid` AND sd.`purchaseorderno`=o.`purchaseorderno` AND od.`itemcode`=r.`productid`
	AND s.`grnno`=sd.`grnno` AND sd.`itemcode`=p.productid AND p.productid=r.`productid` AND r.`grnid`=s.id
	AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	ORDER BY r.`dateadded`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturnoutwardsdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturnoutwardsdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreturnoutwardsdetails`(`$refno` VARCHAR(50))
BEGIN
	SELECT itemcode, itemname, serialno,quantity,narration
	FROM `returnoutwards` ro, products p
	WHERE p.`productid`=ro.`productid` AND `refno`=$refno
	ORDER BY itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturnoutwardsheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturnoutwardsheader` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreturnoutwardsheader`(`$refno` VARCHAR(50))
BEGIN
	SELECT ro.id,g.supplierid, suppliername, invoiceno,DATE_FORMAT(ro.`dateadded`,'%d-%b-%Y') dateadded,refno, CONCAT(firstname,' ',lastname) username
	FROM returnoutwards ro, goodsreceived  g, suppliers s, USER u
	WHERE ro.`grnid`=g.`id` AND s.`supplierid`=g.`supplierid` 
	AND ro.refno=$refno AND u.id=ro.addedby;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturnoutwardssummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturnoutwardssummary` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetreturnoutwardssummary`(`$asatdate` DATE)
BEGIN
	SELECT itemcode,itemname, SUM(quantity) quantity,serialno,narration,DATE_FORMAT(ro.dateadded,'%d-%b-%Y') dateadded,refno
	FROM `returnoutwards` ro, products p
	WHERE ro.productid=p.productid AND DATE_FORMAT(ro.`dateadded`,'%Y-%m%-%d') <=$asatdate 
	AND `delivered`=0
	GROUP BY itemcode,itemname,serialno,narration, refno
	ORDER BY itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetroledetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetroledetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetroledetails`(
    IN $clientid INT,
    IN $roleid INT
)
BEGIN
    SELECT * FROM `roles` WHERE `clientid` = $clientid AND `roleid`=$roleid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetroleprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetroleprivileges` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetroleprivileges`(
    IN $clientid INT,
    IN $roleid INT
)
BEGIN
    SELECT rp.* FROM `roleprivileges` rp
    JOIN `roles` r ON rp.`roleid` = r.`roleid`
    WHERE r.`clientid` = $clientid AND rp.`roleid`=$roleid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetroles` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetroles` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetroles`(IN $clientid INT)
BEGIN
    SELECT * FROM `roles` WHERE clientid = $clientid AND `deleted` = 0 ORDER BY `rolename`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetrolesforuserassignment` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetrolesforuserassignment` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetrolesforuserassignment`(
    IN $clientid INT
)
BEGIN
    SELECT `roleid`,`rolename` FROM `roles` WHERE `clientid` = $clientid ORDER BY `rolename`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetroleusers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetroleusers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetroleusers`(
    IN $clientid INT,
    IN $roleid INT
)
BEGIN
    SELECT r.`userid`, `username`,`firstname`,`middlename`,`lastname` FROM `roleusers` r, `user` u
    WHERE r.`userid`=u.`userid` AND `roleid`=$roleid AND u.`clientid` = $clientid
    ORDER BY `firstname`,`middlename`,`lastname`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalebycustomervalue` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalebycustomervalue` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalebycustomervalue`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50))
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbycustomercount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbycustomercount` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalesbycustomercount`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50))
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbyoutlet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbyoutlet` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalesbyoutlet`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
	SELECT pointofsale,SUM(receipttotal) AS total 
	FROM `vwsalessummary2` 
	WHERE branchid = $branchid AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
	GROUP BY pointofsale
	ORDER BY SUM(receipttotal) DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbypaymentmode` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbypaymentmode` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalesbypaymentmode`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $userid INT)
BEGIN
	IF $userid=0 THEN 
		SELECT paymentmode AS `paymentmode`,SUM(receipttotal) AS amount
		FROM `vwsalessummary2` 
		WHERE branchid = $branchid AND DATE_FORMAT(transactiondate,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY paymentmode 
		ORDER BY transactiondate;
	ELSE
		SELECT paymentmode AS `paymentmode`,SUM(receipttotal) AS amount
		FROM `vwsalessummary2` 
		WHERE branchid = $branchid AND DATE_FORMAT(transactiondate,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		AND userid=$userid
		GROUP BY paymentmode 
		ORDER BY transactiondate;
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbypaymentmode2` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbypaymentmode2` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalesbypaymentmode2`(`$startdate` DATETIME, `$enddate` DATETIME, `$userid` INT)
BEGIN
	IF $userid=0 THEN 
		SELECT paymentmode AS `paymentmode`,SUM(receipttotal) AS amount, COUNT(*) AS appears
		FROM `vwsalessummary2` 
		WHERE DATE_FORMAT(transactiondate,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
		GROUP BY paymentmode 
		ORDER BY transactiondate;
	ELSE
		SELECT paymentmode AS `paymentmode`,SUM(receipttotal) AS amount, COUNT(*) AS appears
		FROM `vwsalessummary2` 
		WHERE DATE_FORMAT(transactiondate,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
		AND userid=$userid
		GROUP BY paymentmode 
		ORDER BY transactiondate;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbyquantity` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbyquantity` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalesbyquantity`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50), IN $userid INT)
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbysalesperson` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbysalesperson` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalesbysalesperson`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
	SELECT userfullname,SUM(receipttotal) AS total 
	FROM `vwsalessummary2` 
	WHERE branchid = $branchid AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
	GROUP BY userfullname
	ORDER BY SUM(receipttotal) DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalessettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalessettings` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalessettings`(IN $branchid INT)
BEGIN
    SELECT * FROM salessettings WHERE branchid = $branchid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalessummarybycustomer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalessummarybycustomer` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalessummarybycustomer`(IN `$branchid` INT, IN `$startdate` DATETIME, IN `$enddate` DATETIME, IN `$posname` VARCHAR(100), IN `$userid` INT)
BEGIN
	IF $posname='<All>' THEN 
		IF $userid=0 THEN 
			SELECT DATE_FORMAT(transactiondate,'%d-%b-%Y') AS transactiondate, pointofsale, customername,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND branchid = $branchid
			GROUP BY transactiondate, pointofsale, customername
			ORDER BY customername,transactiondate DESC;
		ELSE
			SELECT DATE_FORMAT(transactiondate,'%d-%b-%Y') AS transactiondate, pointofsale, customername,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND userid=$userid AND branchid = $branchid
			GROUP BY transactiondate, pointofsale, customername
			ORDER BY transactiondate DESC;
		END IF;
	ELSE
		IF $userid=0 THEN 
			SELECT DATE_FORMAT(transactiondate,'%d-%b-%Y') AS transactiondate, pointofsale, customername,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname AND branchid = $branchid
			GROUP BY transactiondate, pointofsale, customername
			ORDER BY customername,transactiondate DESC;
		ELSE
			SELECT DATE_FORMAT(transactiondate,'%d-%b-%Y') AS transactiondate, pointofsale, customername,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname AND userid=$userid AND branchid = $branchid
			GROUP BY transactiondate, pointofsale, customername
			ORDER BY transactiondate DESC;
		END IF;
	END  IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalessummarybyuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalessummarybyuser` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalessummarybyuser`(IN `$branchid` INT, IN `$startdate` DATETIME, IN `$enddate` DATETIME, IN `$posname` VARCHAR(100), IN `$userid` INT)
BEGIN
	IF $posname='<All>' THEN 
		IF $userid=0 THEN 
			SELECT DATE_FORMAT(transactiondate,'%d-%b-%Y') AS transactiondate, pointofsale, userfullname,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND branchid = $branchid
			GROUP BY transactiondate, pointofsale, userfullname
			ORDER BY userfullname,transactiondate DESC;
		ELSE
			SELECT DATE_FORMAT(transactiondate,'%d-%b-%Y') AS transactiondate, pointofsale, userfullname,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND userid=$userid AND branchid = $branchid
			GROUP BY transactiondate, pointofsale, userfullname
			ORDER BY transactiondate DESC;
		END IF;
	ELSE
		IF $userid=0 THEN 
			SELECT DATE_FORMAT(transactiondate,'%d-%b-%Y') AS transactiondate, pointofsale, userfullname,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname AND branchid = $branchid
			GROUP BY transactiondate, pointofsale, userfullname
			ORDER BY userfullname,transactiondate DESC;
		ELSE
			SELECT DATE_FORMAT(transactiondate,'%d-%b-%Y') AS transactiondate, pointofsale, userfullname,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname AND userid=$userid AND branchid = $branchid
			GROUP BY transactiondate, pointofsale, userfullname
			ORDER BY transactiondate DESC;
		END IF;
	END  IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalestrend` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalestrend` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsalestrend`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50), IN $userid INT)
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsmsconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsmsconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsmsconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `smsconfiguration` WHERE `clientid` = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetstocksheet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetstocksheet` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetstocksheet`(IN `$asat` DATE)
BEGIN
    SET @asat = `$asat`;
    SET @cutoffdate = DATE(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters`), NOW()));
    SET @startdate = CONCAT(@cutoffdate, ' 00:00:00');
    SET @enddate = CONCAT(@asat, ' 23:59:59');

    SET @sql_dynamic = (
        SELECT GROUP_CONCAT(
            CONCAT('ROUND(SUM(IF(storename = ''', `posname`, ''', units, 0)), 2) AS `', `posname`, '`')
        )
        FROM `vwstores`
    );

    SET @sql = CONCAT(
        'WITH item_movements AS (
            SELECT c.categoryname, p.itemcode AS itemcode, p.itemname, p.buyingprice, p.sellingprice,
                   w.description AS storename,
                   SUM(
                       IFNULL(gr.qty, 0) + IFNULL(st_in.qty, 0) - IFNULL(st_out.qty, 0) + IFNULL(recon.qty, 0)
                   ) AS units
            FROM categories c
            JOIN products p ON p.categoryid = c.categoryid
            JOIN warehouses w
            LEFT JOIN (
                SELECT gd.itemcode, g.warehouseid, SUM(gd.quantity) AS qty
                FROM goodsreceiveddetails gd
                JOIN goodsreceived g ON g.grnno = gd.grnno
                WHERE g.datereceived BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY gd.itemcode, g.warehouseid
            ) gr ON gr.itemcode = p.productid AND gr.warehouseid = w.id
            LEFT JOIN (
                SELECT sd.itemcode, s.destinationid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.stocktransferid = sd.transferid
                WHERE s.destinationtype = ''warehouse''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.destinationid
            ) st_in ON st_in.itemcode = p.productid AND st_in.destinationid = w.id
            LEFT JOIN (
                SELECT sd.itemcode, s.sourceid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.stocktransferid = sd.transferid
                WHERE s.sourcetype = ''warehouse''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.sourceid
            ) st_out ON st_out.itemcode = p.productid AND st_out.sourceid = w.id
            LEFT JOIN (
                SELECT sd.itemid, s.posid, SUM(sd.quantity) AS qty
                FROM stockreconciledbalancedetails sd
                JOIN stockreconciledbalance s ON s.stockreconciledbalanceid = sd.reconciliationid
                WHERE s.category = ''warehouse''
                  AND s.reconciliationdate BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemid, s.posid
            ) recon ON recon.itemid = p.productid AND recon.posid = w.id
            GROUP BY c.categoryname, p.itemcode, p.itemname, p.buyingprice, p.sellingprice, w.description

            UNION ALL

            SELECT c.categoryname, p.itemcode AS itemcode, p.itemname, p.buyingprice, p.sellingprice,
                   ps1.posname AS storename,
                   SUM(
                       IFNULL(stp_in.qty, 0) - IFNULL(stp_out.qty, 0) - IFNULL(sales.qty, 0) + IFNULL(recon.qty, 0)
                   ) AS units
            FROM categories c
            JOIN products p ON p.categoryid = c.categoryid
            JOIN pointsofsale ps1
            LEFT JOIN (
                SELECT sd.itemcode, s.destinationid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.stocktransferid = sd.transferid
                WHERE s.destinationtype = ''pos''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.destinationid
            ) stp_in ON stp_in.itemcode = p.productid AND stp_in.destinationid = ps1.posid
            LEFT JOIN (
                SELECT sd.itemcode, s.sourceid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.stocktransferid = sd.transferid
                WHERE s.sourcetype = ''pos''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.sourceid
            ) stp_out ON stp_out.itemcode = p.productid AND stp_out.sourceid = ps1.posid
            LEFT JOIN (
                SELECT pd.itemcode, ps.pointofsaleid, SUM(pd.quantity) AS qty
                FROM possalesdetails pd
                JOIN possales ps ON pd.possaleid = ps.possaleid
                WHERE IFNULL(ps.deleted, 0) = 0
                  AND ps.receiptdate BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY pd.itemcode, ps.pointofsaleid
            ) sales ON sales.itemcode = p.productid AND sales.pointofsaleid = ps1.posid
            LEFT JOIN (
                SELECT sd.itemid, s.posid, SUM(sd.quantity) AS qty
                FROM stockreconciledbalancedetails sd
                JOIN stockreconciledbalance s ON s.stockreconciledbalanceid = sd.reconciliationid
                WHERE s.category = ''outlet''
                  AND s.reconciliationdate BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemid, s.posid
            ) recon ON recon.itemid = p.productid AND recon.posid = ps1.posid
            GROUP BY c.categoryname, p.itemcode, p.itemname, p.buyingprice, p.sellingprice, ps1.posname
        )
        SELECT categoryname, itemcode, itemname, ', @sql_dynamic, ',
               ROUND(SUM(units), 2) AS `Total Quantity`,
               ROUND(SUM(units * buyingprice), 2) AS `Total Purchase`,
               ROUND(SUM(units * sellingprice), 2) AS `Total Selling`
        FROM item_movements
        GROUP BY categoryname, itemcode, itemname, buyingprice, sellingprice'
    );

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetstocktransferbalance` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetstocktransferbalance` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetstocktransferbalance`(
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
          `s`.`posid`            AS `posid`,
          `s`.`posname`       AS `posname`,
          `td`.`itemcode`     AS `itemid`,
          `p`.`productid`     AS `productid`,
          `p`.`itemcode`      AS `itemcode`,
          `p`.`itemname`      AS `itemname`,
          `p`.`unitofmeasure` AS `unitofmeasure`,
          `p`.`buyingprice`   AS `buyingprice`,
          `p`.`sellingprice`  AS `sellingprice`,
          `p`.`serializable`  AS `serializable`,
          IFNULL(SUM(IF(`t`.`destinationid` = `s`.`posid` AND `t`.`destinationtype` = 'pos' AND `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) 
          +
          IFNULL((SELECT SUM(`quantity`)
          FROM `stockreconciledbalancedetails` rd
          JOIN `stockreconciledbalance` r ON r.`stockreconciledbalanceid`=rd.`reconciliationid`
          WHERE `itemid`=p.productid AND DATE(`reconciliationdate`) BETWEEN IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters` WHERE `clientid` = $clientid),'2001-01-01') AND CURRENT_TIMESTAMP()
          AND posid=$sourceid),0)
          AS `unitsreceived`,
          
          IFNULL(SUM(IF(`t`.`sourceid` = `s`.`posid` AND `t`.`sourcetype` = 'pos' AND `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) +
          IFNULL((SELECT SUM(quantity) FROM `possales` ps 
            JOIN `possalesdetails` pd ON  pd.`possaleid`=ps.`possaleid`
            WHERE  pd.itemcode=p.productid AND `receiptdate`>=IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters` WHERE `clientid` = $clientid),CURRENT_TIMESTAMP())
            AND ps.`deleted`=0
          ),0)
          AS `issued`
        FROM `stocktransfer` `t`
        INNER JOIN `stocktransferdetails` `td` ON `t`.`stocktransferid` = `td`.`transferid`
        INNER JOIN `products` `p` ON `td`.`itemcode` = `p`.`productid`
        INNER JOIN `pointsofsale` `s` ON (`s`.`posid` = `t`.`sourceid` OR `s`.`posid` = `t`.`destinationid`)
        WHERE `t`.`dateadded` >= IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters` WHERE `clientid` = $clientid),CURRENT_TIMESTAMP())
            AND s.posid=$sourceid AND p.itemcode=$itemcode AND p.clientid = $clientid;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetstocktransferdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetstocktransferdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetstocktransferdetails`(`$referenceno` VARCHAR(50))
BEGIN
	DECLARE $id INT;
	SET $id=(SELECT stocktransferid FROM `stocktransfer` WHERE `referenceno`=$referenceno);
	SELECT p.`itemcode`,`itemname`,SUM(`quantity`)quantity,`unitprice`, `serialno` 
	FROM `stocktransferdetails` t,`products` p
	WHERE t.`itemcode`=p.`productid` AND `transferid`=$id
	GROUP BY  p.`itemcode`,`itemname`,`unitprice`, `serialno` 
	ORDER BY `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetstocktransferheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetstocktransferheader` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetstocktransferheader`(`$referenceno` VARCHAR(50))
BEGIN
	SELECT * FROM `vwstocktransfers` 
	WHERE referenceno=$referenceno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplieraginganalysis` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplieraginganalysis` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsupplieraginganalysis`(
    IN $clientid INT,
    IN $basedate DATETIME, 
    IN $supplierid INT
)
BEGIN
    SET @cutoffdate = (SELECT DATE_FORMAT(cutoffdate, '%Y-%m-%d') FROM startingparameters WHERE clientid = $clientid);
    IF @cutoffdate IS NULL THEN SET @cutoffdate = '2000-01-01'; END IF;
    
    SELECT 
        IFNULL(SUM(IF(`range` = '1', amountoverdue, 0)), 0) AS `thirty`,  
        IFNULL(SUM(IF(`range` = '31', amountoverdue, 0)), 0) AS `sixty`,
        IFNULL(SUM(IF(`range` = '61', amountoverdue, 0)), 0) AS `ninenty`,
        IFNULL(SUM(IF(`range` = '91', amountoverdue, 0)), 0) AS `onetwenty`,
        IFNULL(SUM(IF(`range` = '120+', amountoverdue, 0)), 0) AS `aboveonetwenty`,
        IFNULL(SUM(amountoverdue), 0) AS `total`
    FROM (
        SELECT 
            i.supplierinvoiceid AS invoiceid, 
            s.supplierid, 
            s.suppliername, 
            i.invoiceno,
            CASE 
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) <= 30 THEN '1' 
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) BETWEEN 31 AND 60 THEN '31'
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) BETWEEN 61 AND 90 THEN '61'
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) BETWEEN 91 AND 120 THEN '91'
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) > 120 THEN '120+' 
            END AS `range`,
            SUM(id.quantity * id.unitprice) -
            IFNULL((
                SELECT SUM(vd.quantity * vd.unitprice) 
                FROM paymentvouchers v 
                JOIN paymentvoucherdetails vd ON v.paymentvoucherid = vd.voucherid
                WHERE v.clientid = $clientid 
                AND v.supplier = s.supplierid 
                AND vd.invoicenumber = i.invoiceno 
                AND DATE_FORMAT(v.date, '%Y-%m-%d') BETWEEN @cutoffdate AND $basedate
            ), 0) AS amountoverdue
        FROM supplierinvoice i
        JOIN supplierinvoicedetails id ON i.supplierinvoiceid = id.invoiceid
        JOIN suppliers s ON s.supplierid = i.supplierid
        WHERE i.clientid = $clientid 
        AND s.clientid = $clientid
        AND s.supplierid = $supplierid
        AND i.status <> 'Cancelled'
        AND DATE_FORMAT(i.invoicedate, '%Y-%m-%d') BETWEEN @cutoffdate AND $basedate
        GROUP BY i.supplierinvoiceid, s.supplierid, s.suppliername, i.invoiceno, i.invoicedate
    ) AS tab1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsupplierdetails`(
    IN $clientid INT,
    IN $supplierid INT
)
BEGIN
    SELECT * FROM suppliers 
    WHERE clientid = $clientid AND supplierid = $supplierid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierinvoices` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierinvoices` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsupplierinvoices`(
    IN $clientid INT,
    IN $supplierid INT,
    IN $status VARCHAR(50),
    IN $startdate DATETIME,
    IN $enddate DATETIME
)
BEGIN
    DECLARE $accountid INT;
    DECLARE $accountname VARCHAR(100);
    
    SET $accountid = (SELECT `id` FROM `glaccounts` WHERE `clientid` = $clientid AND `accountcode` = (SELECT `account` FROM `glaccountsettings` WHERE `clientid` = $clientid AND `description` = 'Suppliers Control Account'));
    SET $accountname = (SELECT `accountname` FROM `glaccounts` WHERE `clientid` = $clientid AND `accountcode` = (SELECT `account` FROM `glaccountsettings` WHERE `clientid` = $clientid AND `description` = 'Suppliers Control Account'));

    SELECT $accountid AS accountcharged, $accountname AS accountname, 
           i.supplierinvoiceid AS invoiceid, s.`supplierid`, s.suppliername, i.`invoiceno`, 
           DATE_FORMAT(i.`invoicedate`,'%d-%b-%Y') AS invoicedate, 
           SUM(id.`quantity` * id.`unitprice`) AS invoiceamount, i.`status`,
           IFNULL((SELECT SUM(vd.`quantity` * vd.`unitprice`) 
                   FROM `paymentvouchers` v
                   INNER JOIN `paymentvoucherdetails` vd ON v.`paymentvoucherid` = vd.`voucherid` AND v.clientid = vd.clientid
                   WHERE v.clientid = $clientid AND v.`supplier` = s.supplierid AND vd.`invoicenumber` = i.invoiceno), 0) AS amountpaid
    FROM `supplierinvoice` i
    INNER JOIN `supplierinvoicedetails` id ON i.`supplierinvoiceid` = id.`invoiceid` AND i.clientid = id.clientid
    INNER JOIN `suppliers` s ON s.`supplierid` = i.`supplierid` AND s.clientid = i.clientid
    WHERE i.clientid = $clientid
      AND ($supplierid = 0 OR i.supplierid = $supplierid)
      AND ($status = '<All>' OR $status = 'All' OR i.status = $status)
      AND DATE_FORMAT(i.invoicedate,'%Y-%m-%d') BETWEEN DATE_FORMAT($startdate,'%Y-%m-%d') AND DATE_FORMAT($enddate,'%Y-%m-%d')
    GROUP BY i.supplierinvoiceid, s.`supplierid`, s.suppliername, i.`invoiceno`, i.`status`, i.`invoicedate`
    ORDER BY i.`invoicedate` DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierpendingorders` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierpendingorders` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsupplierpendingorders`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierproducts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsupplierproducts`(
    IN $clientid INT,
    IN $supplierid INT
)
BEGIN
    SELECT s.id, s.productid, p.itemcode, p.itemname, s.dateadded, 
           CONCAT(u.firstname, ' ', u.middlename, ' ', u.lastname) AS addedbyuser
    FROM products p
    JOIN supplierproducts s ON p.productid = s.productid
    JOIN user u ON s.addedby = u.userid
    WHERE s.clientid = $clientid 
    AND s.supplierid = $supplierid 
    AND s.deleted = 0
    ORDER BY p.itemname;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsuppliers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsuppliers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsuppliers`(IN $clientid INT)
BEGIN
    SELECT * FROM `suppliers` WHERE clientid = $clientid AND `deleted` = 0 ORDER BY `suppliername`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierstatement` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierstatement` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsupplierstatement`(
    IN $clientid INT,
    IN $supplierid INT, 
    IN $startdate DATETIME, 
    IN $enddate DATETIME
)
BEGIN
    SET @cutoffdate = DATE_FORMAT(IFNULL((SELECT cutoffdate FROM startingparameters WHERE clientid = $clientid), NOW()), '%Y-%m-%d');
    
    IF $startdate < @cutoffdate THEN 
        SET $startdate = @cutoffdate;
    END IF;
    
    SET @openingbalancedate = DATE_SUB($startdate, INTERVAL 1 DAY);
    
    SELECT 
        s.supplierid, s.suppliername, s.physicaladdress, s.postaladdress, s.mobile, s.email,
        DATE_FORMAT(v.invoicedate, '%d-%b-%Y') AS `date`, 
        fngetsupplieropeningbalance($clientid, $supplierid, $startdate) AS openingbalance,
        IFNULL((SELECT SUM(invoiceamount) FROM vwsupplierstatement o WHERE o.clientid = $clientid AND o.supplierid = $supplierid AND DATE_FORMAT(invoicedate, '%Y-%m-%d') BETWEEN $startdate AND $enddate), 0) AS invoices,
        IFNULL((SELECT SUM(invoicepayment) FROM vwsupplierstatement o WHERE o.clientid = $clientid AND o.supplierid = $supplierid AND DATE_FORMAT(invoicedate, '%Y-%m-%d') BETWEEN $startdate AND $enddate), 0) AS payments,
        v.reference, v.narrative, IFNULL(v.invoiceamount, 0) AS invoiceamount, IFNULL(v.invoicepayment, 0) AS invoicepayment, IFNULL(v.`order`, 0) AS `order`
    FROM suppliers s
    LEFT JOIN vwsupplierstatement v ON s.supplierid = v.supplierid AND s.clientid = v.clientid 
        AND DATE_FORMAT(v.invoicedate, '%Y-%m-%d') BETWEEN $startdate AND $enddate
    WHERE s.clientid = $clientid 
    AND s.supplierid = $supplierid
    ORDER BY v.invoicedate, v.`order`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsystemmodules` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsystemmodules` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetsystemmodules`(IN $clientid INT)
BEGIN
    SELECT DISTINCT `module` FROM `objects` 
    WHERE clientid = $clientid AND `module` IS NOT NULL 
    ORDER BY `module`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgettaxtypes` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgettaxtypes` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgettaxtypes`(IN $clientid INT)
BEGIN
    SELECT * FROM `taxtypes` WHERE clientid = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgettodaysdate` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgettodaysdate` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgettodaysdate`(IN $branchid INT)
BEGIN
    SELECT DATE_FORMAT(NOW(),'%Y-%m-%d') AS today;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgettrialbalance` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgettrialbalance` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `spgettrialbalance`($branchid INT, $startdate DATETIME, $enddate DATETIME)
BEGIN
	SET @startdate = $startdate, @enddate = $enddate;
	SELECT IFNULL(CONCAT(accountcode,' - ',accountname),'TOTAL') AS accountname, 
		SUM(IF(`total`>0,`total`,0)) AS debit,
		SUM(IF(`total`<0,ABS(`total`),0)) AS credit 
	FROM (
		SELECT `accountcode`, `accountname`,
		SUM(`debit`-`credit`) AS `total`
		FROM `glaccounts` g, `gltransactions` t
		WHERE g.`id`=t.`glaccount` AND t.branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
		GROUP BY `accountcode`, `accountname` 
		ORDER BY `accountcode`
	) tab1
	GROUP BY accountname
	WITH ROLLUP;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuninvoicedgrns` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuninvoicedgrns` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetuninvoicedgrns`(`$supplierid` INT, `$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	IF $supplierid=0 THEN 
		SELECT g.`goodsreceivedid`, g.`grnno`,`deliverynono`, DATE_FORMAT(`datereceived`,'%d-%b-%Y') `datereceived`,SUM(gd.`quantity`*pd.unitprice) AS `ordertotal`
		FROM `goodsreceived` g, `goodsreceiveddetails` gd, `purchaseorders` p, `purchaseorderdetails` pd
		WHERE g.`grnno`=gd.`grnno` AND gd.`purchaseorderno`=p.`purchaseorderno` AND p.`purchaseorderid`=pd.`purchaseorderid`  AND gd.itemcode=pd.itemcode AND IFNULL(invoiced,0)=0
		AND g.`deliverynono` NOT LIKE 'Opening Balance%' AND DATE_FORMAT(`datereceived`,'%Y-%m-%d') BETWEEN $startdate AND $enddate 
		AND  DATE_FORMAT(`datereceived`,'%Y-%m-%d')>=@cutoffdate
		GROUP BY  g.`goodsreceivedid`, `grnno`,`deliverynono`,DATE_FORMAT(`datereceived`,'%d-%b-%Y')
		ORDER BY DATE_FORMAT(`datereceived`,'%d-%b-%Y'),  g.`grnno`;
	ELSE
		SELECT g.`goodsreceivedid`, g.`grnno`,`deliverynono` ,DATE_FORMAT(`datereceived`,'%d-%b-%Y') `datereceived`,SUM(gd.`quantity`*pd.unitprice) AS `ordertotal`
		FROM `goodsreceived` g, `goodsreceiveddetails` gd, `purchaseorders` p, `purchaseorderdetails` pd
		WHERE g.`grnno`=gd.`grnno` AND gd.`purchaseorderno`=p.`purchaseorderno` AND p.`purchaseorderid`=pd.`purchaseorderid`  AND gd.itemcode=pd.itemcode AND IFNULL(invoiced,0)=0
		AND g.`deliverynono` NOT LIKE 'Opening Balance%' AND DATE_FORMAT(`datereceived`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND g.`supplierid`=$supplierid  
		AND DATE_FORMAT(`datereceived`,'%Y-%m-%d')>=@cutoffdate		
		GROUP BY  `goodsreceivedid`, `grnno`,`deliverynono`,DATE_FORMAT(`datereceived`,'%d-%b-%Y')
		ORDER BY DATE_FORMAT(`datereceived`,'%d-%b-%Y'),  g.`grnno`;	
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuserbyid` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuserbyid` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetuserbyid`(`$clientid` INT)
BEGIN
	SELECT * FROM `user` WHERE `userid`=$clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuserdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuserdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetuserdetails`(IN $username VARCHAR(50))
BEGIN
    SELECT 
        u.*, 
        COALESCE(b.branchname, 'Default Branch') AS branchname 
    FROM user u
    LEFT JOIN branches b ON u.defaultbranchid = b.branchid
    WHERE u.username = $username;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetusernamefromuserid` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetusernamefromuserid` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetusernamefromuserid`(IN $userid INT)
BEGIN
    SELECT * FROM `user` WHERE `userid` = $userid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuseroutlets` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuseroutlets` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetuseroutlets`(IN $branchid INT, IN $userid INT)
BEGIN
    SELECT o.*, s.posname
    FROM useroutlets o
    JOIN pointsofsale s ON s.posid = o.outletid
    WHERE s.branchid = $branchid 
    AND o.userid = $userid 
    AND IFNULL(o.deleted, 0) = 0
    ORDER BY s.posname;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuserprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuserprivileges` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetuserprivileges`(
    IN $clientid INT,
    IN $userid INT,
    IN $branchid INT
)
BEGIN
    SELECT up.* FROM `userprivileges` up
    JOIN `user` u ON up.`userid` = u.`userid`
    WHERE u.`clientid` = $clientid AND up.userid=$userid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuserroles` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuserroles` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetuserroles`(`$clientid` INT)
BEGIN
	SELECT r.* FROM `roles` r, `roleusers` u
	WHERE r.`roleid`=u.`roleid` AND `userid`=$clientid
	AND IFNULL(u.`deleted`,0)=0
	ORDER BY `rolename`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetvoucheritems` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetvoucheritems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetvoucheritems`(
    IN `$branchid` INT,
    IN `$id` VARCHAR(50)
)
BEGIN
	SELECT vd.*,`accountname` FROM `paymentvoucherdetails` vd, `paymentvouchers` v, `glaccounts` g 
	WHERE v.`branchid` = `$branchid` AND v.paymentvoucherid=vd.`voucherid` AND g.`id`=`accountcharged` AND v.`voucherno`=$id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetwarehouses` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetwarehouses` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgetwarehouses`(IN $clientid INT)
BEGIN
    SELECT * FROM `warehouses` WHERE clientid = $clientid ORDER BY `description`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spgteunitsofmeasure` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgteunitsofmeasure` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spgteunitsofmeasure`(IN $clientid INT)
BEGIN
    SELECT * FROM `unitsofmeasure` WHERE clientid = $clientid ORDER BY `description`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sppostbanking` */

/*!50003 DROP PROCEDURE IF EXISTS  `sppostbanking` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sppostbanking`(
        IN `$branchid` INT,
        IN `$refno` VARCHAR(50),
        IN `$cashbookaccount` INT,
        IN `$narration` VARCHAR(50),
        IN `$reference` VARCHAR(50),
        IN `$postas` VARCHAR(50),
        IN `$userid` INT,
        IN `$receiptbanked` VARCHAR(50)
    )
BEGIN
        DECLARE $salesaccount INT;
        DECLARE $transactiondate DATETIME;
        DECLARE $debtorscontrolaccount INT;
        SET $transactiondate = NOW();
        
        SET $salesaccount = (SELECT id FROM glaccounts WHERE accountcode = (SELECT `account` FROM `glaccountsettings` WHERE description = "Sales"));
        SET $debtorscontrolaccount = (SELECT id FROM glaccounts WHERE accountcode = (SELECT `account` FROM `glaccountsettings` WHERE description = "Debtors Control Account"));
        
        START TRANSACTION;
            -- post to sales or debtors control account individual transactions
            IF $receiptbanked != "pos" THEN
                SET $salesaccount = $debtorscontrolaccount;
            END IF;
            
            INSERT INTO `gltransactions`(`branchid`, `referenceno`, `transactiondate`, `glaccount`, `glcontraaccount`, `narration`, `debit`, `credit`, `addedby`)
            SELECT $branchid, $reference, $transactiondate, $salesaccount, $cashbookaccount,
                CONCAT("Banking of receipt # ", `receiptno`, " of reference #", `reference`, " issued to ", `customername`, " (", $narration, ")"),
                0, `amount`, $userid 
            FROM `tempbanking` 
            WHERE `refno` = $refno;
            
            -- post to the cashbook account
            IF $postas = "single" THEN		
                INSERT INTO `gltransactions` (`branchid`, `referenceno`, `transactiondate`, `glaccount`, `glcontraaccount`, `narration`, `debit`, `credit`, `addedby`)
                SELECT $branchid, $reference, $transactiondate, $cashbookaccount, $salesaccount, 
                    CONCAT("Banking of receipt # ", `receiptno`, " of reference #", `reference`, " issued to ", `customername`, " (", $narration, ")"),
                    amount, 0, $userid 
                FROM `tempbanking` 
                WHERE `refno` = $refno; 
            ELSE
                INSERT INTO `gltransactions` (`branchid`, `referenceno`, `transactiondate`, `glaccount`, `glcontraaccount`, `narration`, `debit`, `credit`, `addedby`)
                SELECT $branchid, $reference, $transactiondate, $cashbookaccount, $salesaccount, $narration, 
                    SUM(amount), 0, $userid 
                FROM `tempbanking` 
                WHERE `refno` = $refno 
                GROUP BY `refno`; 
            END IF;
            
            -- update all receipts
            IF $receiptbanked = "pos" THEN 
                UPDATE `possalespayments` p, `tempbanking` b  
                SET p.`banked` = 1, p.`bankingreference` = $reference 
                WHERE b.`id` = p.id;
            ELSE
                UPDATE `customerreceipts` p, `tempbanking` b 
                SET `banked` = 1, `bankingrefno` = $reference
                WHERE b.`id` = p.id;
            END IF;
            
            -- remove temp data 
            DELETE FROM `tempbanking` WHERE `refno` = $refno;
        COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaceglgroupname` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaceglgroupname` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaceglgroupname`(`$id` INT, `$glaccountclass` INT, `$groupname` VARCHAR(50), `$subcategoryof` INT, `$cashbookaccount` INT, `$clientid` INT)
BEGIN
	IF $id=0 THEN
		INSERT INTO `glaccountgroups`(`groupname`,`subactegoryof`,`dateadded`,`addedby`,`deleted`,`cashbookaccount`,`glaccountclass`)
		VALUES($groupname,$subcategoryof,NOW(),$clientid,0,$cashbookaccount,$glaccountclass);
	ELSE
		UPDATE `glaccountgroups` SET `groupname`=$groupname,`subactegoryof`=$subcategoryof,`cashbookaccount`=$cashbookaccouont,
		`glaccountclass`=$glaccountclass,`lastupdatedby`=$clientid, `lastdateupdated`=NOW()
		WHERE id=$id;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecategory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavecategory`(IN $clientid INT, IN $id INT, IN $name VARCHAR(50),
    IN $prefix VARCHAR(50),
    IN $currentno INT,
    IN $userid INT
)
BEGIN
    IF $id = 0 THEN
        INSERT INTO `categories` (clientid, `categoryname`, `prefix`, `currentno`, `dateadded`, `addedby`, `deleted`)
        VALUES (clientid, $name, $prefix, $currentno, NOW(), $userid, 0);
    ELSE
        UPDATE `categories` SET 
            `categoryname` = $name, `prefix` = $prefix, `currentno` = $currentno, 
            `lastmodifiedon` = NOW(), `lastmodifiedby` = $userid
        WHERE clientid = $clientid AND `categoryid` = $id;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecity` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecity` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavecity`(
    IN $cityid INT,
    IN $cityname VARCHAR(100),
    IN $countryid INT
)
BEGIN
    IF $cityid = 0 THEN
        INSERT INTO cities (cityname, countryid)
        VALUES ($cityname, $countryid);
    ELSE
        UPDATE cities SET 
            cityname = $cityname,
            countryid = $countryid
        WHERE cityid = $cityid;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecountry` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecountry` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavecountry`(
    IN $countryid INT,
    IN $countryname VARCHAR(100),
    IN $countrycode VARCHAR(10),
    IN $currency VARCHAR(50),
    IN $currencysymbol VARCHAR(10),
    IN $dialingcode VARCHAR(10),
    IN $isdefault TINYINT
)
BEGIN
    -- If setting as default, unset others
    IF $isdefault = 1 THEN
        UPDATE countries SET isdefault = 0;
    END IF;

    IF $countryid = 0 THEN
        INSERT INTO countries (countryname, countrycode, currency, currencysymbol, dialingcode, isdefault)
        VALUES ($countryname, $countrycode, $currency, $currencysymbol, $dialingcode, $isdefault);
    ELSE
        UPDATE countries SET 
            countryname = $countryname,
            countrycode = $countrycode,
            currency = $currency,
            currencysymbol = $currencysymbol,
            dialingcode = $dialingcode,
            isdefault = $isdefault
        WHERE countryid = $countryid;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecrateinventorysettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecrateinventorysettings` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavecrateinventorysettings`(`$productid` INT, `$supplierid` INT, `$glaccountid` INT, `$costcenter` INT, `$paymentmode` INT, `$paymentaccount` INT)
BEGIN
	IF NOT EXISTS(SELECT * FROM `cratesinventorysettings`) THEN
		INSERT INTO `cratesinventorysettings`(`productid`,`supplierid`,`glaccountid`,`costcenterid`,`paymentmode`,`paymentaccount`)
		VALUES($productid,$supplierid,$glaccountid,$costcenter,$paymentmode,$paymentaccount);
	ELSE
		UPDATE `cratesinventorysettings` SET `productid`=$productid,`supplierid`=$supplierid, `glaccountid`=$glaccountid,
		`costcenterid`=$costcenter,`paymentmode`=$paymentmode,`paymentaccount`=$paymentaccount;
	END IF;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecreditnote` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecreditnote` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavecreditnote`(`$refno` VARCHAR(50), `$customerid` NUMERIC, `$userid` NUMERIC)
BEGIN
	DECLARE $creditnoteno VARCHAR(50);
	DECLARE $id NUMERIC;
	-- Generate the credit note number 
	SET $creditnoteno=`fngeneratecreditnoteno`();
	START TRANSACTION;
		-- Insert credit note header 
		INSERT INTO `creditnotes`(`noteno`,`customerid`,`dateadded`,`addedby`)
		VALUES($creditnoteno,$customerid,NOW(),$userid);
		-- get currently inserted id
		SET $id=(SELECT MAX(`id`) FROM `creditnotes`);
		-- insert credit note details 
		INSERT INTO `creditnotedetails`(`noteid`,`itemcode`,`quantity`,`unitprice`)
		SELECT $id,`itemcode`,`quantity`,`unitprice` FROM `tempcreditnote` WHERE `refno`=$refno;
		-- Increment credit note number counter
		UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Credit Note';
		-- Delete data from temp table
		DELETE FROM `tempcreditnote` WHERE `refno`=$refno;
		-- get the credit note number generated
		SELECT $creditnoteno AS creditnotenumber;
	COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecustomer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecustomer` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavecustomer`(
    IN $clientid INT, 
    IN $customerid INT, 
    IN $customername VARCHAR(100),
    IN $tradingname VARCHAR(100),
    IN $physicaladdress VARCHAR(100),
    IN $postaladdress VARCHAR(100),
    IN $mobile VARCHAR(50),
    IN $email VARCHAR(50),
    IN $creditlimit DECIMAL(18,2),
    IN $creditterm INT,
    IN $userid INT,
    IN $category INT,
    IN $posid INT,
    IN $onetimecustomer TINYINT,
    IN $pinno VARCHAR(50),
    IN $idno VARCHAR(50),
    IN $subzoneid INT
)
BEGIN
    IF $customerid = 0 THEN
        BEGIN
            DECLARE v_customerno VARCHAR(50);
            
            -- Ensure Customer Number serial exists for safety
            IF NOT EXISTS (SELECT 1 FROM `serials` WHERE `documenttype` = 'Customer Number' AND `branchid` = 1) THEN
                INSERT INTO `serials` (`documenttype`, `prefix`, `currentno`, `branchid`) VALUES ('Customer Number', 'CUST', 1, 1);
            END IF;
            
            -- Generate customerno using fngeneratecustomerno
            SET v_customerno = fngeneratecustomerno(1);
            
            INSERT INTO `customers` (
                clientid, customername, tradingname, physicaladdress, postaladdress, mobile, email,
                creditlimit, creditterm, dateadded, addedby, deleted, categoryid, pointofsaleid,
                onetimecustomer, pinno, idno, subzoneid, customerno
            ) VALUES (
                $clientid, $customername, $tradingname, $physicaladdress, $postaladdress, $mobile, $email,
                $creditlimit, $creditterm, NOW(), $userid, 0, $category, $posid,
                $onetimecustomer, $pinno, $idno, $subzoneid, v_customerno
            );
            
            -- Increment the counter by 1
            UPDATE `serials` SET `currentno` = `currentno` + 1 WHERE `documenttype` = 'Customer Number' AND `branchid` = 1;
        END;
    ELSE
        UPDATE `customers` SET
            customername = $customername,
            tradingname = $tradingname,
            physicaladdress = $physicaladdress,
            postaladdress = $postaladdress,
            mobile = $mobile,
            email = $email,
            creditlimit = $creditlimit,
            creditterm = $creditterm,
            lastmodifiedon = NOW(),
            lastmodifiedby = $userid,
            categoryid = $category,
            pointofsaleid = $posid,
            onetimecustomer = $onetimecustomer,
            pinno = $pinno,
            idno = $idno,
            subzoneid = $subzoneid
        WHERE clientid = $clientid AND customerid = $customerid;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecustomercontact` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecustomercontact` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavecustomercontact`(
    IN $clientid INT,
    IN $customercontactid INT,
    IN $customerid INT,
    IN $categoryid INT,
    IN $contactname VARCHAR(100),
    IN $idno VARCHAR(20),
    IN $mobile VARCHAR(40),
    IN $email VARCHAR(50),
    IN $consentsigned TINYINT,
    IN $addedby INT
)
BEGIN
    IF $customercontactid = 0 THEN
        INSERT INTO customercontacts (
            clientid, customerid, categoryid, contactname, idno, mobile, email, consentsigned, addedby, dateadded
        ) VALUES (
            $clientid, $customerid, $categoryid, $contactname, $idno, $mobile, $email, $consentsigned, $addedby, NOW()
        );
    ELSE
        UPDATE customercontacts SET
            categoryid = $categoryid,
            contactname = $contactname,
            idno = $idno,
            mobile = $mobile,
            email = $email,
            consentsigned = $consentsigned
        WHERE customercontactid = $customercontactid AND clientid = $clientid;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecustomerdiscountsettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecustomerdiscountsettings` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavecustomerdiscountsettings`(
    IN $clientid INT,
    IN $id INT, 
    IN $customerid INT, 
    IN $productid INT, 
    IN $discount DECIMAL(10,2), 
    IN $percentage TINYINT, 
    IN $userid INT, 
    IN $expirydate DATETIME
)
BEGIN
    IF $id = 0 THEN
        INSERT INTO customerdiscountsettings (
            clientid, customerid, productid, discount, percentage, dateadded, addedby, deleted, expirydate
        ) VALUES (
            $clientid, $customerid, $productid, $discount, $percentage, NOW(), $userid, 0, $expirydate
        );
    ELSE    
        UPDATE customerdiscountsettings SET 
            customerid = $customerid,
            productid = $productid,
            discount = $discount,
            percentage = $percentage,
            lastmodifiedby = $userid,
            lastmodifiedon = NOW(), 
            expirydate = $expirydate
        WHERE id = $id AND clientid = $clientid;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecustomerreceipt` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecustomerreceipt` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavecustomerreceipt`(
    IN $branchid INT,
    IN $refno VARCHAR(50),
    IN $customerid INT,
    IN $modeofpayment INT,
    IN $referenceno VARCHAR(50),
    IN $userid INT,
    IN $overpay NUMERIC(18,2)
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveemailconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveemailconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveemailconfiguration`(
    IN $clientid INT,
    IN $emailaddress VARCHAR(100),
    IN $emailpassword VARCHAR(50),
    IN $smtpserver VARCHAR(50),
    IN $smtpport INT,
    IN $usessl BOOLEAN
)
BEGIN
    CALL sp_saveemailconfiguration($clientid, $emailaddress, $emailpassword, $smtpserver, $smtpport, $usessl);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveglaccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveglaccount` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveglaccount`(
                IN $branchid INT, 
                IN $id INT, 
                IN $groupid INT, 
                IN $accountcode VARCHAR(50), 
                IN $accountname VARCHAR(50), 
                IN $clientid INT
            )
BEGIN
                IF $id = 0 THEN 
                    INSERT INTO `glaccounts`(`groupid`,`accountcode`,`accountname`,`dateadded`,`addedby`,`deleted`,`clientid`)
                    VALUES($groupid,$accountcode,$accountname,NOW(),$clientid,0,$branchid);
                ELSE
                    UPDATE `glaccounts` 
                    SET `groupid` = $groupid, 
                        `accountcode` = $accountcode, 
                        `accountname` = $accountname, 
                        `lastdateupdated` = NOW(), 
                        `lastupdatedby` = $clientid
                    WHERE `id` = $id AND `clientid` = $branchid;
                END IF;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveglgroupname` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveglgroupname` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveglgroupname`(
                IN $branchid INT, 
                IN $id INT, 
                IN $glaccountclass INT, 
                IN $groupname VARCHAR(50), 
                IN $subcategoryof INT, 
                IN $cashbookaccount INT, 
                IN $clientid INT
            )
BEGIN
                IF $id = 0 THEN
                    INSERT INTO `glaccountgroups`(`groupname`,`subactegoryof`,`dateadded`,`addedby`,`deleted`,`cashbookaccount`,`glaccountclass`,`branchid`)
                    VALUES($groupname,$subcategoryof,NOW(),$clientid,0,$cashbookaccount,$glaccountclass,$branchid);
                ELSE
                    UPDATE `glaccountgroups` 
                    SET `groupname` = $groupname,
                        `subactegoryof` = $subcategoryof,
                        `cashbookaccount` = $cashbookaccount,
                        `glaccountclass` = $glaccountclass,
                        `lastupdatedby` = $clientid, 
                        `lastdateupdated` = NOW()
                    WHERE `id` = $id AND `branchid` = $branchid;
                END IF;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavegltransaction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavegltransaction` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavegltransaction`(`$refno` VARCHAR(50), `$transactiondate` DATETIME, `$referenceno` VARCHAR(50), `$userid` INT)
BEGIN
	INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
	SELECT $referenceno,$transactiondate, `glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,$userid FROM `tempgltransaction` WHERE `refno`=$refno;
	DELETE FROM `tempgltransaction` WHERE `refno`=$refno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavegoodsreceived` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavegoodsreceived` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavegoodsreceived`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveheldsale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveheldsale` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveheldsale`(`$refno` VARCHAR(50), `$customerid` INT, `$posid` INT, `$userid` INT)
BEGIN
	DECLARE $id NUMERIC;
	START TRANSACTION;
			
		-- Save held sale		
		INSERT INTO `heldsales`(`customerid`,`posid`,`dateheld`,`addedby`)
		VALUES($customerid,$posid,NOW(),$userid);
		
		-- get the currently inserted id
		SET $id=(SELECT MAX(`id`) FROM `heldsales`);
		
		-- post held sale details
		INSERT INTO `heldsalesdetails`(`heldsaleid`,`productid`,`quantity`,`unitprice`,`discount`)
		SELECT $id,`itemcode`,`quantity`,`unitprice`,`discount` FROM `tempsale` WHERE `refno`=$refno;
		-- delete the temporary data
		DELETE FROM `tempsale` WHERE `refno`=$refno;
		
	COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavejournaltransaction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavejournaltransaction` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavejournaltransaction`(`$refno` VARCHAR(50), `$referenceno` VARCHAR(50), `$description` VARCHAR(100), `$userid` INT, `$addtoledger` BIT)
BEGIN
	DECLARE $journalid INT;
	START TRANSACTION;
		-- insert the journal details
		INSERT INTO `journals`(`referenceno`,`date`,`description`,`addedby`,`addedtoledger`)
		VALUES($referenceno,NOW(),$description,$userid,$addtoledger);
		-- get the journal id
		SET $journalid=(SELECT MAX(`id`) FROM `journals`);
		-- post journal transactions
		INSERT INTO `journaldetails`(`journalid`,`glaccount`,`narration`,`debit`,`credit`)
		SELECT $journalid,`glaccount`,`narration`,`debit`,`credit` FROM `tempjournaldetails` WHERE `refno`=$refno;
		
		-- post the info to the gl if requested
		IF $addtoledger=1 THEN 
			INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
			SELECT $referenceno,NOW(),`glaccount`,NULL,`narration`,`debit`,`credit`,$userid FROM `tempjournaldetails` WHERE `refno`=$refno;
		END IF;
		
		-- delete temp journal data
		DELETE FROM `tempjournaldetails` WHERE `refno`=$refno;
		-- return the generated journal id
		SELECT $journalid AS `journalid`;
	COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavempesac2bparameters` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavempesac2bparameters` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavempesac2bparameters`(`$url` VARCHAR(500), `$shortcode` VARCHAR(50), `$msisdn` VARCHAR(50))
BEGIN
	UPDATE `mpesaconfiguration` SET c2burl=$url,c2bshortcode=$shortcode,c2bmsisdn=$msisdn;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavempesaconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavempesaconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavempesaconfiguration`(`$consumerkey` VARCHAR(100), `$consumersecret` VARCHAR(100), `$validationurl` VARCHAR(500), `$confirmationurl` VARCHAR(500), `$paybillnumber` VARCHAR(10))
BEGIN
	IF NOT EXISTS(SELECT * FROM `mpesaconfiguration`) THEN
		INSERT INTO `mpesaconfiguration`(`consumerkey`,`consumersecret`,`validationurl`,`confirmationurl`,`paybillnumber`)
		VALUES($consumerkey,$consumersecret,$validationurl,$confirmationurl,$paybillnumber);
	ELSE
		UPDATE `mpesaconfiguration` SET `consumerkey`=$consumerkey,`consumersecret`=$consumersecret,`validationurl`=$validationurl,
		`confirmationurl`=$confirmationurl,`paybillnumber`=$paybillnumber;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavempesaconfirmation` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavempesaconfirmation` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavempesaconfirmation`(`$reference` VARCHAR(50), `$transactiondate` DATETIME, `$amount` NUMERIC(18,2), `$sendermobile` VARCHAR(50), `$sendername` VARCHAR(50))
BEGIN
	INSERT INTO `mpesaconfirmation`(`date`,`reference`,`amount`,`sendermobile`,`sendername`)
	VALUES($transactiondate,$reference,$amount,$sendermobile,$sendername);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavepaymentvoucher` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavepaymentvoucher` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavepaymentvoucher`(
        IN $branchid INT,
        IN $refno VARCHAR(50),
        IN $id INT,
        IN $voucherdate DATETIME,
        IN $voucherno VARCHAR(50),
        IN $pos INT,
        IN $supplier INT,
        IN $paymentmode INT,
        IN $cashbookaccount INT,
        IN $reference VARCHAR(50),
        IN $generatevoucherno INT,
        IN $userid INT,
        IN $pettycash BOOLEAN,
        IN $craterefund BOOLEAN
    )
BEGIN
        DECLARE $productid INT;	
        DECLARE $narration VARCHAR(1000);
        SET $pettycash = IFNULL($pettycash,0);
        SET $craterefund=IFNULL($craterefund,0);
        
        IF $id=0 THEN 
            BEGIN
                START TRANSACTION;
                    -- generate voucher number
                    IF $generatevoucherno=1 THEN
                        SET $voucherno=`fngeneratepaymentvoucherno`();
                        UPDATE serials SET currentno=currentno+1 WHERE `documenttype`='Voucher Number';
                    END IF;
                    -- return voucher number	
                    SELECT $voucherno AS voucherno;
                    -- Add data to crate inventory
                    IF $craterefund=1 THEN 
                        SET $productid=(SELECT `productid` FROM `cratesinventorysettings`);
                        SET $narration='Crate Deposit Refund';
                        INSERT INTO `cratesinventory`(`productid`,`quantity`,`unitprice`,`dateadded`,`narration`,`reference`,`addedby`)
                        SELECT $productid,quantity,unitprice,NOW(),$narration,`invoicenumber`,$userid FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
                        -- Create temp order details
                        INSERT INTO `temppurchaseorder`(`refno`,`itemcode`,`quantity`,`unitprice`)
                        SELECT $refno,$productid,quantity,unitprice FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
                        -- Save order
                        CALL `spsavepurchaseorder`(0,$refno,$supplier,'Crate Deposit Refund',$userid);
                        SELECT MAX(`id`) INTO @poid FROM `purchaseorders`;
                        -- Receive Order
                        SELECT `id` INTO @warehouseid FROM `warehouses` ORDER BY `id` LIMIT 1;
                        SELECT `purchaseorderno` INTO @pono FROM `purchaseorders` WHERE `id`=@poid;
                        -- Get quantity from temp voucher details
                        SELECT quantity INTO @quantity FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
                        CALL `spsavetempgoodsreceived`($refno,@pono,$productid,@quantity,'');
                        CALL `spsavegoodsreceived`($refno,@warehouseid,$supplier,$voucherno,$userid,0,'');
                    END IF;
                    
                    -- insert voucher details
                    INSERT INTO `paymentvouchers`(`branchid`,`voucherno`,`date`,`addedby`,`paymentmode`,`pos`,`supplier`,`cashbookaccount`,`referenceno`,`status`,`dateadded`,`pettycashvoucher`)
                    VALUES($branchid,$voucherno,$voucherdate,$userid,$paymentmode,$pos,$supplier,$cashbookaccount,$reference,'Pending',NOW(),$pettycash);
                
                    SET $id=(SELECT MAX(paymentvoucherid) FROM `paymentvouchers`);
                    
                    -- insert voucher items
                    INSERT INTO `paymentvoucherdetails`(`branchid`,`voucherid`,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber`)
                    SELECT $branchid,$id,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber` FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
                    
                    -- remove temporary data
                    DELETE FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
                COMMIT;
            END;
        ELSE
            BEGIN
                START TRANSACTION;
                    -- return voucher number	
                    SELECT $voucherno AS voucherno;
                    -- delete previous value entries
                    DELETE FROM `paymentvoucherdetails` WHERE `voucherid`=$id;
                    -- modify voucher details
                    UPDATE `paymentvouchers` SET `voucherno`=$voucherno,`paymentmode`=$paymentmode,`pos`=$pos,`supplier`=$supplier,
                    `cashbookaccount`=$cashbookaccount,`referenceno`=$reference,`lastmodifiedby`=$userid,`lastmodifieddate`=NOW(),
                    `pettycashvoucher`=$pettycash
                    WHERE `paymentvoucherid`=$id AND `branchid`=$branchid;
                    -- add vouchers items
                    INSERT INTO `paymentvoucherdetails`(`branchid`,`voucherid`,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber`)
                    SELECT $branchid,$id,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber` FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
                    -- remove temporary data
                    DELETE FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
                COMMIT;
            END;
        END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavepos` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavepos` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavepos`(
    IN $branchid INT,
    IN $posid INT, 
    IN $posname VARCHAR(50), 
    IN $postype VARCHAR(50), 
    IN $printkitchenorders TINYINT,
    IN $userid INT
)
BEGIN
    IF $posid = 0 THEN 
        INSERT INTO pointsofsale (branchid, posname, postype, printkitchenorders, dateadded, addedby, deleted)
        VALUES ($branchid, $posname, $postype, $printkitchenorders, NOW(), $userid, 0);
        SET $posid = LAST_INSERT_ID();
    ELSE
        UPDATE pointsofsale 
        SET posname = $posname, postype = $postype, printkitchenorders = $printkitchenorders,
            lastdatemodified = NOW(), lastmodifiedby = $userid
        WHERE branchid = $branchid AND posid = $posid;
    END IF;
    SELECT $posid AS posid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavepossale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavepossale` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavepossale`(
    IN $branchid INT, 
    IN $refno VARCHAR(50),
    IN $customerid INT,
    IN $posid INT,
    IN $transactiondate DATETIME,
    IN $reference VARCHAR(50),
    IN $userid INT
)
BEGIN
    DECLARE $receiptno VARCHAR(50);
    DECLARE $id INT;
    DECLARE $customername VARCHAR(100);
    DECLARE $clientid INT;
    DECLARE $sessionid INT;
    DECLARE $finished INT DEFAULT 0;
    DECLARE $tempproductid INT;
    DECLARE $tempquantity DECIMAL(18,2);
    DECLARE $tempunitprice DECIMAL(18,2);
    DECLARE $tempdiscount DECIMAL(18,2);
    DECLARE $tempserialno VARCHAR(100);
    DECLARE $temptaxid INT;
    DECLARE $temptaxrate DECIMAL(18,2);
    DECLARE $tempdescription VARCHAR(250);
    DECLARE $stockmovementid INT;
    DECLARE $purchasebalance DECIMAL(18,2);
    DECLARE $fifoquantity DECIMAL(18,2);
    
    DECLARE cur_products CURSOR FOR 
        SELECT itemcode, quantity, unitprice, discount, serialno, 1 as taxid, 0 as taxrate, description 
        FROM tempsale WHERE branchid = $branchid AND refno = $refno;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET $finished = 1;

    SELECT clientid INTO $clientid FROM branches WHERE branchid = $branchid;
    
    SELECT sessionid INTO $sessionid FROM sessions WHERE branchid = $branchid AND addedby = $userid AND status = 'active' LIMIT 1;

    START TRANSACTION;
        SET $receiptno = (SELECT spgeneratecustomerreceiptno($branchid));
        SET $customername = (SELECT customername FROM customers WHERE clientid = $clientid AND customerid = $customerid);

        INSERT INTO possales (branchid, sessionid, receiptno, customerid, pointofsaleid, receiptdate, reference, addedby, deleted)
        VALUES ($branchid, $sessionid, $receiptno, $customerid, $posid, $transactiondate, $reference, $userid, 0);
        
        SET $id = LAST_INSERT_ID();

        INSERT INTO possalesdetails (branchid, possaleid, itemcode, quantity, unitprice, discount, serialno, taxtypeid, taxrate, description, uom)
        SELECT $branchid, $id, itemcode, quantity, unitprice, discount, serialno, taxtypeid, taxrate, description, uom
        FROM tempsale WHERE branchid = $branchid AND refno = $refno;

        INSERT INTO possalespayments (branchid, possaleid, paymentmode, reference, amount)
        SELECT $branchid, $id, paymentmodeid, reference, amount
        FROM temppossalespayment WHERE branchid = $branchid AND refno = $refno;

        UPDATE serials SET currentno = currentno + 1 WHERE branchid = $branchid AND documenttype = 'Customer Receipt';

        OPEN cur_products;
        loop_products: LOOP
            FETCH cur_products INTO $tempproductid, $tempquantity, $tempunitprice, $tempdiscount, $tempserialno, $temptaxid, $temptaxrate, $tempdescription;
            IF $finished = 1 THEN LEAVE loop_products; END IF;

            WHILE $tempquantity > 0 DO
                SET $stockmovementid = NULL;
                SET $purchasebalance = 0;

                SELECT s.stockmovementid, (s.purchasequantity - IFNULL(SUM(sd.salesquantity), 0)) as available
                INTO $stockmovementid, $purchasebalance
                FROM stockmovement s
                LEFT JOIN stockmovementsalesdetails sd ON s.stockmovementid = sd.stockmovementid
                WHERE s.branchid = $branchid AND s.productid = $tempproductid
                GROUP BY s.stockmovementid
                HAVING available > 0
                ORDER BY s.stockmovementid ASC LIMIT 1;

                IF $stockmovementid IS NULL THEN
                    SET $tempquantity = 0; 
                ELSE
                    IF $purchasebalance > $tempquantity THEN
                        SET $fifoquantity = $tempquantity;
                        SET $tempquantity = 0;
                    ELSE
                        SET $fifoquantity = $purchasebalance;
                        SET $tempquantity = $tempquantity - $purchasebalance;
                    END IF;

                    INSERT INTO stockmovementsalesdetails (branchid, stockmovementid, possaleid, salesquantity, sellingprice)
                    VALUES ($branchid, $stockmovementid, $id, $fifoquantity, $tempunitprice - $tempdiscount);
                END IF;
            END WHILE;
        END LOOP loop_products;
        CLOSE cur_products;

        DELETE FROM tempsale WHERE branchid = $branchid AND refno = $refno;
        DELETE FROM temppossalespayment WHERE branchid = $branchid AND refno = $refno;

        SELECT $receiptno AS receiptno;
    COMMIT;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveprivileges` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveprivileges`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveproduct` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveproduct`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveproduction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveproduction` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveproduction`(
    IN $id INT,
    IN $clientid INT,
    IN $productiondate DATE,
    IN $productid INT,
    IN $quantity DECIMAL(12,4),
    IN $warehouseid INT,
    IN $userid INT
)
BEGIN
    IF $id > 0 THEN
        UPDATE `productions`
        SET `productiondate` = $productiondate, `productid` = $productid, `quantity` = $quantity, `warehouseid` = $warehouseid, `lastupdatedby` = $userid, `lastdateupdated` = NOW()
        WHERE `clientid` = $clientid AND `id` = $id;
    ELSE
        INSERT INTO `productions` (`clientid`, `productiondate`, `productid`, `quantity`, `warehouseid`, `addedby`, `dateadded`)
        VALUES ($clientid, $productiondate, $productid, $quantity, $warehouseid, $userid, NOW());
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveproductpricehistory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveproductpricehistory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveproductpricehistory`(
    IN $productid INT,
    IN $price DECIMAL(18,2),
    IN $userid INT
)
BEGIN
    INSERT INTO `productpricehistory` (`productid`, `price`, `addedby`, `dateadded`)
    VALUES ($productid, $price, $userid, NOW());
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveproductrecipe` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveproductrecipe` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveproductrecipe`(
    IN $clientid INT,
    IN $productid INT,
    IN $recipeitemid INT,
    IN $quantity DECIMAL(10,4),
    IN $userid INT
)
BEGIN
    IF EXISTS(SELECT 1 FROM `productrecipes` WHERE `clientid` = $clientid AND `productid` = $productid AND `recipeitemid` = $recipeitemid) THEN
        UPDATE `productrecipes` 
        SET `quantity` = $quantity, `addedby` = $userid, `dateadded` = NOW() 
        WHERE `clientid` = $clientid AND `productid` = $productid AND `recipeitemid` = $recipeitemid;
    ELSE
        INSERT INTO `productrecipes` (`clientid`, `productid`, `recipeitemid`, `quantity`, `addedby`, `dateadded`) 
        VALUES ($clientid, $productid, $recipeitemid, $quantity, $userid, NOW());
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveproductsplitunit` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveproductsplitunit` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveproductsplitunit`(
    IN $id INT,
    IN $clientid INT,
    IN $productid INT,
    IN $unitname VARCHAR(50),
    IN $unitsoftotal DECIMAL(10,4),
    IN $unitprice DECIMAL(10,2),
    IN $userid INT
)
BEGIN
    IF $id > 0 THEN
        UPDATE `productsplitunits`
        SET `unitname` = $unitname, `unitsoftotal` = $unitsoftotal, `unitprice` = $unitprice, `addedby` = $userid, `dateadded` = NOW()
        WHERE `clientid` = $clientid AND `id` = $id;
    ELSE
        INSERT INTO `productsplitunits` (`clientid`, `productid`, `unitname`, `unitsoftotal`, `unitprice`, `addedby`, `dateadded`)
        VALUES ($clientid, $productid, $unitname, $unitsoftotal, $unitprice, $userid, NOW());
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavepurchaseorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavepurchaseorder` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavepurchaseorder`(IN $branchid INT, IN $id NUMERIC, IN $refno VARCHAR(50),
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavereturninwards` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavereturninwards` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavereturninwards`(`$refno` VARCHAR(50), `$receiptno` VARCHAR(50), `$userid` INT, `$narration` VARCHAR(1000))
BEGIN
	SET @possaleid=(SELECT id FROM `possales` WHERE `receiptno`=$receiptno);
	-- Generate return inwards ref
	SET @refno=`fngeneratereturninwardsref`();
	START TRANSACTION;
		INSERT INTO `returninwards`(`refno`,`possaleid`,`productid`,`serialno`,`quantity`,`dateadded`,`addedby`,`narration`)
		SELECT @refno,@possaleid,`productid`,`serialno`,`quantity`,NOW(),$userid,$narration FROM `tempreturns` WHERE `refno`=$refno;
		-- Update reference no generation counter
		UPDATE serials SET currentno=currentno+1 WHERE `documenttype`='Return Inwards';
		-- Delete temporary data
		DELETE FROM `tempreturns` WHERE `refno`=$refno;
		-- Return the generated reference number
		SELECT @refno AS referenceno;
	COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavereturninwardscollection` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavereturninwardscollection` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavereturninwardscollection`(`$id` INT, `$collectedby` VARCHAR(50), `$userid` INT)
BEGIN
	UPDATE `returninwards` 
	SET `collected`=1,`collectedby`=$collectedby,`datecollected`=NOW(),`issuedby`=$userid
	WHERE `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavereturnoutwards` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavereturnoutwards` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavereturnoutwards`(`$refno` VARCHAR(50), `$grnno` VARCHAR(50), `$narration` VARCHAR(1000), `$userid` INT)
BEGIN
    
	SET @grnid=(SELECT id FROM `goodsreceived` WHERE `grnno`=$grnno);
	SET @refno=`fngeneratereturnoutwardsref`() ;
	
	START TRANSACTION;
		-- Add return outward item(s)
		INSERT INTO `returnoutwards`(`refno`,`grnid`,`productid`,`serialno`,`quantity`,`dateadded`,`addedby`,`narration`)
		SELECT @refno,@grnid,`productid`,`serialno`,`quantity`,NOW(),$userid,$narration FROM `tempreturns` WHERE `refno`=$refno;
		-- Increment refno generator counter
		UPDATE serials SET currentno=currentno+1 WHERE documenttype='Return Outwards';
		-- Delete temporary data
		DELETE FROM `tempreturns` WHERE refno=$refno;
		-- return the serial number generated
		SELECT @refno AS referenceno;
	COMMIT;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavereturnoutwardsreturn` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavereturnoutwardsreturn` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavereturnoutwardsreturn`(`$id` INT, `$userid` INT)
BEGIN
	UPDATE `returnoutwards` 
	SET `delivered`=1,`datedelivered`=NOW(), `receivedby`=$userid
	WHERE `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaverole` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaverole` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaverole`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveroleusers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveroleusers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveroleusers`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavesmslog` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavesmslog` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavesmslog`(`$mobileno` VARCHAR(50), `$customerid` VARCHAR(50), `$message` VARCHAR(1000), `$messageid` VARCHAR(50), `$messagestatus` VARCHAR(50))
BEGIN
		INSERT INTO `smslog`(`mobileno`,`customerid`,`message`,`messageid`,`status`,`datesent`)
		VALUES($mobileno,$customerid,$message,$messageid,$messagestatus,NOW());
	END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavestockreconciledbalance` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavestockreconciledbalance` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavestockreconciledbalance`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavestocktransfer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavestocktransfer` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavestocktransfer`(
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
        
        SET $id=(SELECT MAX(`stocktransferid`) FROM `stocktransfer`);
        
        INSERT INTO `stocktransferdetails`(`transferid`,`itemcode`,`quantity`,`unitprice`,`serialno`)
        SELECT $id,`itemcode`,SUM(`quantity`) AS quantity,`unitprice`,`serialno` 
        FROM `tempstocktransfer` WHERE `refno`=$refno 
        GROUP BY $id,`itemcode`,`unitprice`,`serialno`;
        
        UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Stock Transfer' AND `branchid` = $branchid;
        DELETE FROM `tempstocktransfer` WHERE `refno`=$refno;
        SELECT  $transferrefno AS transfercode;        
    COMMIT;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavesupplier` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavesupplier` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavesupplier`(
    IN $clientid INT,
    IN $supplierid INT,
    IN $suppliername VARCHAR(50),
    IN $physicaladdress VARCHAR(100),
    IN $postaladdress VARCHAR(100),
    IN $creditlimit DECIMAL(10,2),
    IN $mobile VARCHAR(50),
    IN $supplierpinno VARCHAR(50),
    IN $email VARCHAR(50),
    IN $userid INT
)
BEGIN
    IF $supplierid = 0 THEN
        INSERT INTO suppliers (
            clientid, suppliername, physicaladdress, postaladdress, 
            creditlimit, mobile, email, dateadded, addedby, supplierpinno
        ) VALUES (
            $clientid, $suppliername, $physicaladdress, $postaladdress, 
            $creditlimit, $mobile, $email, NOW(), $userid, $supplierpinno
        );
    ELSE
        UPDATE suppliers SET
            suppliername = $suppliername,
            physicaladdress = $physicaladdress,
            postaladdress = $postaladdress,
            creditlimit = $creditlimit,
            mobile = $mobile,
            email = $email,
            supplierpinno = $supplierpinno,
            lastdatemodified = NOW(),
            lastmodifiedby = $userid
        WHERE clientid = $clientid AND supplierid = $supplierid;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavesupplierinvoice` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavesupplierinvoice` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavesupplierinvoice`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavesupplierproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavesupplierproduct` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavesupplierproduct`(
    IN $clientid INT,
    IN $supplierid INT,
    IN $productid INT,
    IN $userid INT
)
BEGIN
    IF NOT EXISTS(SELECT * FROM supplierproducts WHERE clientid = $clientid AND supplierid = $supplierid AND productid = $productid AND deleted = 0) THEN 
        INSERT INTO supplierproducts (clientid, supplierid, productid, addedby, dateadded, deleted)
        VALUES ($clientid, $supplierid, $productid, $userid, NOW(), 0);
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempbanking` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempbanking` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempbanking`(
        IN `$branchid` INT,
        IN `$refno` VARCHAR(50),
        IN `$receiptno` VARCHAR(50),
        IN `$reference` VARCHAR(50),
        IN `$amount` DECIMAL(10,2),
        IN `$customername` VARCHAR(50),
        IN `$id` INT
    )
BEGIN
        INSERT INTO `tempbanking`(`branchid`, `refno`, `receiptno`, `reference`, `amount`, `customername`, `id`)
        VALUES($branchid, $refno, $receiptno, $reference, $amount, $customername, $id);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempcreditnotedetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempcreditnotedetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempcreditnotedetails`(`$refno` VARCHAR(50), `$itemcode` VARCHAR(50), `$quantity` NUMERIC, `$unitprice` NUMERIC)
BEGIN
	DECLARE $itemid INT;
	SET $itemid=(SELECT `productid` FROM `products` WHERE `itemcode`=$itemcode);
	INSERT INTO `tempcreditnote`(`refno`,`itemcode`,`quantity`,`unitprice`)
	VALUES($refno,$itemid,$quantity,$unitprice);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempcustomerinvoice` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempcustomerinvoice` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempcustomerinvoice`(`$refno` VARCHAR(50), `$grnno` VARCHAR(50))
BEGIN
	INSERT INTO `tempcustomerinvoice`(`refno`,`grnno`)
	VALUES($refno,$grnno);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempgltransaction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempgltransaction` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempgltransaction`(`$refno` VARCHAR(50), `$glaccount` INT, `$glcontraaccount` INT, `$narration` VARCHAR(500), `$debit` FLOAT, `$credit` FLOAT)
BEGIN
	INSERT INTO `tempgltransaction`(`refno`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`)
	VALUES($refno,$glaccount,@contraaccount,$narration,$debit,$credit);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempgoodsreceived` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempgoodsreceived` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempgoodsreceived`(IN $branchid INT, IN $refno VARCHAR(50),
    IN $pono VARCHAR(50),
    IN $itemcode VARCHAR(50),
    IN $quantity DECIMAL(18,2),
    IN $serialno VARCHAR(100)
)
BEGIN
    INSERT INTO `tempgoodsreceived` (branchid, `refno`, `purchaseorderno`, `itemcode`, `quantity`, `serialno`)
    VALUES ($branchid, $refno, $pono, $itemcode, $quantity, $serialno);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempjournaldetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempjournaldetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempjournaldetails`(`$refno` VARCHAR(50), `$glaccount` INT, `$narration` VARCHAR(100), `$debit` FLOAT, `$credit` FLOAT)
BEGIN
	INSERT INTO `tempjournaldetails`(`refno`,`glaccount`,`narration`,`debit`,`credit`)
	VALUES($refno,$glaccount,$narration,$debit,$credit);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetemppossalepayment` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetemppossalepayment` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetemppossalepayment`(
    IN $branchid INT,
    IN $refno VARCHAR(50), 
    IN $paymentmode INT, 
    IN $referenceno VARCHAR(50), 
    IN $amount DECIMAL(18,2)
)
BEGIN	
    INSERT INTO `temppossalespayment`(`branchid`, `refno`, `paymentmodeid`, `reference`, `amount`)
    VALUES($branchid, $refno, $paymentmode, $referenceno, $amount);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetemppricematrix` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetemppricematrix` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetemppricematrix`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $catid NUMERIC,
    IN $percentage BIT,
    IN $val NUMERIC
)
BEGIN
    INSERT INTO `temppricematrix`(`refno`,`catid`,`percentage`,`value`)
    VALUES($refno,$catid,$percentage,$val);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempprivilege` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempprivilege`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $id INT,
    IN $objectid INT,
    IN $valid BIT
)
BEGIN
    INSERT INTO `tempprivilege`(`refno`,`id`,`objectid`,`valid`)
    VALUES($refno,$id,$objectid,$valid);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetemppurchaseorderitem` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetemppurchaseorderitem` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetemppurchaseorderitem`(IN $branchid INT, IN $refno VARCHAR(50),
    IN $itemcode VARCHAR(50),
    IN $quantity DECIMAL(18,2),
    IN $unitprice DECIMAL(18,2),
    IN $taxable BOOL,
    IN $taxinclusive BOOL
)
BEGIN
    INSERT INTO `temppurchaseorder` (branchid, `refno`, `itemcode`, `quantity`, `unitprice`, `taxable`, `taxinclusive`)
    VALUES ($branchid, $refno, $itemcode, $quantity, $unitprice, $taxable, $taxinclusive);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempreconcilebalancedetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempreconcilebalancedetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempreconcilebalancedetails`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $itemid INT,
    IN $quantity NUMERIC(18,2),
    IN $unitprice NUMERIC(18,2)
)
BEGIN
    INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
    VALUES($refno,$itemid,$quantity,$unitprice);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempreturns` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempreturns` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempreturns`(`$refno` VARCHAR(50), `$productid` VARCHAR(50), `$serialno` VARCHAR(50), `$quantity` NUMERIC(18,2))
BEGIN
	INSERT INTO `tempreturns`(`refno`,`productid`,`quantity`,`serialno`)
	VALUES($refno,$productid,$quantity,$serialno);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempsale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempsale` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempsale`(
    IN $branchid INT, 
    IN $refno VARCHAR(50),
    IN $itemcode VARCHAR(50),
    IN $quantity DECIMAL(18,2),
    IN $unitprice DECIMAL(18,2),
    IN $discount DECIMAL(18,2),
    IN $serialno VARCHAR(100),
    IN $description VARCHAR(250),
    IN $uom VARCHAR(50)
)
BEGIN
    INSERT INTO `tempsale` (branchid, `refno`, `itemcode`, `quantity`, `unitprice`, `discount`, `serialno`, `description`, `uom`)
    VALUES ($branchid, $refno, $itemcode, $quantity, $unitprice, $discount, $serialno, $description, $uom);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempstocktransfer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempstocktransfer` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempstocktransfer`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempsupplierinvoice` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempsupplierinvoice` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetempsupplierinvoice`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $grnno VARCHAR(50)
)
BEGIN
    INSERT INTO `tempsupplierinvoice`(`refno`,`grnno`)
    VALUES($refno,$grnno);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetepmpaymentvoucherdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetepmpaymentvoucherdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsavetepmpaymentvoucherdetails`(
    IN `$branchid` INT,
    IN `$refno` VARCHAR(50),
    IN `$itemcode` VARCHAR(50),
    IN `$description` VARCHAR(500),
    IN `$quantity` DECIMAL(10,3),
    IN `$unitprice` DECIMAL(10,2),
    IN `$accountcharged` INT,
    IN `$invoicenumber` VARCHAR(50)
)
BEGIN
    INSERT INTO `temppaymentvoucherdetails`(`branchid`,`refno`,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber`)
    VALUES($branchid,$refno,$itemcode,$description,$quantity,$unitprice,$accountcharged,$invoicenumber);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveuser` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveuser`(`$clientid` INT, `$userpassword` VARCHAR(50), `$systemadmin` BIT, `$username` VARCHAR(50), `$firstname` VARCHAR(50), `$middlename` VARCHAR(50), `$lastname` VARCHAR(50), `$email` VARCHAR(50), `$mobile` VARCHAR(50), `$changepasswordonlogon` BIT, `$accountactive` BIT, `$addedby` INT)
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveuseroutlet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveuseroutlet` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveuseroutlet`(`$userid` INT, `$outletid` INT, `$addedby` INT)
BEGIN
	
	IF NOT EXISTS(SELECT * FROM `useroutlets` WHERE `userid`=$userid AND `outletid`=$outletid) THEN
		INSERT INTO `useroutlets`(`userid`,`outletid`,`dateadded`,`addedby`,`deleted`)
		VALUES($userid,$outletid,NOW(),$addedby,0);
	ELSE
		UPDATE `useroutlets` SET `deleted`=0,`lastdatemodified`=NOW(),`lastmodifiedby`=$addedby
		WHERE `userid`=$userid AND `outletid`=$outletid;
	END IF;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveuserprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveuserprivilege` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spsaveuserprivilege`(
    IN $clientid INT, 
    IN $userid INT, 
    IN $branchid INT, 
    IN $objectid INT, 
    IN $allowed TINYINT, 
    IN $useradding INT
)
BEGIN
    IF NOT EXISTS(SELECT * FROM `userprivileges` WHERE `objectid` = $objectid AND `userid` = $userid AND `branchid` = $branchid) THEN
        INSERT INTO `userprivileges`(`branchid`, `objectid`, `userid`, `allowed`, `dateadded`, `addedby`)
        VALUES($branchid, $objectid, $userid, $allowed, NOW(), $useradding);
    ELSE
        UPDATE `userprivileges` 
        SET `allowed` = $allowed, `lastdateupdated` = NOW(), `lastupdatedby` = $useradding 
        WHERE `objectid` = $objectid AND `userid` = $userid AND `branchid` = $branchid;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sptempsavecustomerreceiptdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sptempsavecustomerreceiptdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sptempsavecustomerreceiptdetails`(
    IN $clientid INT,
    IN $refno VARCHAR(50),
    IN $possaleid NUMERIC,
    IN $amount NUMERIC
)
BEGIN
    INSERT INTO `tempcustomerreceiptdetails`(`refno`,`possaleid`,`amount`)
    VALUES($refno,$possaleid,$amount);
END */$$
DELIMITER ;

/* Procedure structure for procedure `spvalidateuserprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `spvalidateuserprivilege` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `spvalidateuserprivilege`(IN $branchid INT, IN $userid INT, IN $objectid INT)
BEGIN
    DECLARE $admin INT;
    DECLARE $valid INT DEFAULT 0;
    
    -- Check if user is a system admin (Admin usually bypasses individual privilege checks)
    SELECT systemadmin INTO $admin FROM `user` WHERE `userid` = $userid;
    
    IF $admin = 1 THEN
        SET $valid = 1;
    ELSE
        -- Check specific privilege for user and branch
        SELECT IFNULL(MAX(allowed), 0) INTO $valid 
        FROM `userprivileges` 
        WHERE `userid` = $userid 
        AND `branchid` = $branchid 
        AND `objectid` = $objectid;
    END IF;
    
    SELECT $valid AS `allowed`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_activatesession` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_activatesession` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_activatesession`(IN $branchid INT, IN $floatamount DECIMAL(18,2), IN $userid INT)
BEGIN
    INSERT INTO `sessions` (`branchid`, `floatamount`, `addedby`, `status`, `starttime`, `dateadded`)
    VALUES ($branchid, $floatamount, $userid, 'active', NOW(), NOW());
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_approvepurchaseorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_approvepurchaseorder` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_approvepurchaseorder`(
                IN `$pono` VARCHAR(50),
                IN `$approvallevelid` INT,
                IN `$userid` INT,
                IN `$narration` VARCHAR(500)
            )
BEGIN
                SET @poid = (SELECT `purchaseorderid` FROM `purchaseorders` WHERE `purchaseorderno` = $pono);
                
                INSERT INTO `purchaseorderapproval`(`poid`, `approvallevelid`, `approvaluser`, `approvaldate`, `narration`)
                VALUES(@poid, $approvallevelid, $userid, NOW(), $narration);
                
                -- Check if all approval levels have been achieved
                IF (SELECT `fn_purchaseorderstatus`(@poid)) = 'Approved' THEN
                    UPDATE `purchaseorders` 
                    SET `status` = 'Approved', 
                        `approvedby` = $userid, 
                        `approvaldate` = NOW() 
                    WHERE `purchaseorderid` = @poid;
                END IF;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_approverequisition` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_approverequisition` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_approverequisition`(
                IN `$requisitionno` VARCHAR(50),
                IN `$approvallevelid` INT,
                IN `$userid` INT,
                IN `$narration` VARCHAR(500)
            )
BEGIN
                SET @requisitionid = (SELECT id FROM `materialrequest` WHERE `requisitionno` = $requisitionno);
                
                INSERT INTO `materialrequestapproval`(`materialrequestid`, `approvallevelid`, `approvaluser`, `approvaldate`, `narration`)
                VALUES(@requisitionid, $approvallevelid, $userid, NOW(), $narration);
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_cancelcustomerorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_cancelcustomerorder` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_cancelcustomerorder`(`$orderid` INT, `$reason` VARCHAR(1000), `$userid` INT)
BEGIN
		UPDATE `customerorders`
		SET `status`='Cancelled',`datecancelled`=NOW(),`reasoncancelled`=$reason
		WHERE `orderid`=$orderid;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkbranch` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkbranch` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_checkbranch`(
    IN $branchid INT, 
    IN $branchname VARCHAR(100), 
    IN $clientid INT
)
BEGIN
    SELECT branchid FROM branches 
    WHERE branchname = $branchname AND branchid != $branchid AND clientid = $clientid AND deleted = 0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkcustomercontact` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkcustomercontact` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_checkcustomercontact`(`$id` INT, `$customerid` INT, `$contactname` VARCHAR(50))
BEGIN
	SELECT * 
	FROM `customercontacts` 
	WHERE `id`!=$id AND `customerid`=$customerid AND `contactname`=$contactname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkdepartment` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkdepartment` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_checkdepartment`(`$id` INT, `$departmentname` VARCHAR(50))
BEGIN
	SELECT * FROM departments  WHERE `departmentname`=$departmentname AND `id`<>$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkfleetvehicleregno` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkfleetvehicleregno` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_checkfleetvehicleregno`(`$vehicleid` INT, `$regno` VARCHAR(50))
BEGIN
	SELECT * FROM `fleetvehicles` WHERE `vehicleid`<>$vehicleid AND `regno`=$regno;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkrawmaterial` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkrawmaterial` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_checkrawmaterial`(`$id` INT, `$materialname` VARCHAR(50))
BEGIN
	SELECT * FROM `rawmaterials` 
	WHERE `materialid`<>$id AND `materialname`=$materialname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checksessionid` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checksessionid` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_checksessionid`(IN $branchid INT, IN $userid INT)
BEGIN
    SELECT * FROM `sessions` 
    WHERE `branchid` = $branchid 
    AND `addedby` = $userid
    AND `status` = 'active';
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checktable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checktable` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_checktable`(`$tableid` INT, `$posid` INT, `$tablename` VARCHAR(50))
BEGIN
		SELECT * 
		FROM `tables`
		WHERE `tableid`!=$tableid AND `posid`=$posid AND `tablename`=$tablename AND `deleted`=0;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkuserprivilegewithcode` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkuserprivilegewithcode` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_checkuserprivilegewithcode`(`$clientid` INT, `$objectcode` VARCHAR(50))
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkzone` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkzone` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_checkzone`(IN `$clientid` INT, IN `$id` INT, IN `$zonename` VARCHAR(100))
BEGIN
                    SELECT * FROM `zones` 
                    WHERE `clientid` = `$clientid` 
                      AND `zoneid` <> `$id` 
                      AND `zonename` = `$zonename` 
                      AND IFNULL(`deleted`, 0) = 0;
                END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_closesession` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_closesession` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_closesession`(IN $branchid INT, IN $userid INT)
BEGIN
    UPDATE `sessions`
    SET `status` = 'closed', `closedby` = $userid, `dateclosed` = NOW(), `endtime` = NOW()
    WHERE `branchid` = $branchid AND `status` = 'active';
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletebranch` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletebranch` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_deletebranch`(IN $branchid INT, IN $userid INT)
BEGIN
    UPDATE branches SET deleted = 1, lastupdatedby = $userid, lastdateupdated = NOW() 
    WHERE branchid = $branchid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletecustomercontact` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletecustomercontact` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_deletecustomercontact`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `customercontacts` 
	SET `deleted`=1, `datedeleted`=NOW(), `deletedby`=$clientid
	WHERE `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletedepartment` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletedepartment` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_deletedepartment`(`$id` INT)
BEGIN
	UPDATE `departments` SET deleted=1 WHERE `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deleterawmaterial` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deleterawmaterial` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_deleterawmaterial`(`$materialid` INT, `$clientid` INT)
BEGIN
	UPDATE `rawmaterials` 
	SET `deleted`=1,`datedeleted`=NOW(),`deletedby`=$clientid
	WHERE `materialid`=$materialid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletetable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletetable` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_deletetable`(`$tableid` INT, `$userid` INT)
BEGIN
		UPDATE `tables`
		SET `deleted`=1,`deletedby`=$userid, `datedeleted`=NOW()
		WHERE `tableid`=$tableid;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletezone` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletezone` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_deletezone`(IN `$clientid` INT, IN `$id` INT, IN `$userid` INT)
BEGIN
                    UPDATE `zones` 
                    SET `deleted` = 1, `datedeleted` = NOW(), `deletedby` = `$userid` 
                    WHERE `zoneid` = `$id` AND `clientid` = `$clientid`;
                END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filtercustomerorders` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filtercustomerorders` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_filtercustomerorders`(`$customerid` INT, `$tableid` INT, `$posid` INT, `$waiterid` INT, `$startdate` DATE, `$enddate` DATE, `$orderstatus` VARCHAR(50))
BEGIN
		IF $posid=0 THEN 
			IF $customerid=0 THEN
				IF $tableid=0 THEN
					IF $waiterid=0 THEN 
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					ELSE
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.waiterid=$waiterid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.waiterid=$waiterid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					END IF;
				ELSE
					IF $waiterid=0 THEN 
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.tableid=$tableid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.tableid=$tableid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					ELSE
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.waiterid=$waiterid
							AND c.tableid=$tableid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.waiterid=$waiterid AND c.tableid=$tableid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					END IF;
				END IF;
			ELSE
				IF $tableid=0 THEN
					IF $waiterid=0 THEN 
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
							AND c.customerid=$customerid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.customerid=$customerid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					ELSE
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.waiterid=$waiterid
							AND c.tableid=$tableid AND c.customerid=$customerid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.waiterid=$waiterid AND c.tableid=$tableid AND c.customerid=$customerid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					END IF;
				ELSE
					IF $waiterid=0 THEN 
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.tableid=$tableid
							AND c.tableid=$tableid AND c.customerid=$customerid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.tableid=$tableid AND c.tableid=$tableid AND c.customerid=$customerid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					ELSE
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.waiterid=$waiterid
							AND c.tableid=$tableid AND c.tableid=$tableid AND c.customerid=$customerid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.waiterid=$waiterid AND c.tableid=$tableid AND c.customerid=$customerid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					END IF;
				END IF;
			END IF;
		ELSE
			IF $customerid=0 THEN
				IF $tableid=0 THEN
					IF $waiterid=0 THEN 
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
							AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					ELSE
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.waiterid=$waiterid
							AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.waiterid=$waiterid AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					END IF;
				ELSE
					IF $waiterid=0 THEN 
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.tableid=$tableid
							AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.tableid=$tableid AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					ELSE
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.waiterid=$waiterid
							AND c.tableid=$tableid AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.waiterid=$waiterid AND c.tableid=$tableid AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					END IF;
				END IF;
			ELSE
				IF $tableid=0 THEN
					IF $waiterid=0 THEN 
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
							AND c.customerid=$customerid AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.customerid=$customerid AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					ELSE
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.waiterid=$waiterid
							AND c.tableid=$tableid AND c.customerid=$customerid AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.waiterid=$waiterid AND c.tableid=$tableid AND c.customerid=$customerid
							AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					END IF;
				ELSE
					IF $waiterid=0 THEN 
						IF $orderstatus='0' THEN 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.tableid=$tableid
							AND c.tableid=$tableid AND c.customerid=$customerid AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.tableid=$tableid AND c.tableid=$tableid AND c.customerid=$customerid
							AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					ELSE
						IF $orderstatus='0' THEN 
							SELECT  c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.waiterid=$waiterid
							AND c.tableid=$tableid AND c.tableid=$tableid AND c.customerid=$customerid
							AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						ELSE
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,SUM(quantity*unitprice) ordertotal ,
							CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
							CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
							DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate, c.status
							FROM `customerorders` c
							JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
							JOIN `products` p ON p.productid=cd.productid
							JOIN `tables` t ON t.tableid=c.tableid
							JOIN `pointsofsale` s ON s.id=c.posid
							JOIN `user` w ON w.id=c.waiterid
							JOIN `user` u ON u.id=c.`addedby`
							JOIN `customers` r ON r.`customerid`=c.customerid
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.status=$orderstatus
							AND c.waiterid=$waiterid AND c.tableid=$tableid AND c.customerid=$customerid
							AND c.posid=$posid
							GROUP BY orderno
							ORDER BY orderno;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filterfleetrequisitions` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filterfleetrequisitions` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_filterfleetrequisitions`(`$supplierid` INT, `$costcenterid` INT, `$vehicleid` INT, `$startdate` DATE, `$enddate` DATE)
BEGIN
	IF $supplierid=0 THEN
		IF $costcenterid=0 THEN
			IF $vehicleid=0 THEN 
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded, `requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate 
				ORDER BY `requisitionno` DESC;
			ELSE
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND r.vehicleid=$vehicleid
				ORDER BY `requisitionno` DESC;
			END IF;
		ELSE
			IF $vehicleid=0 THEN 
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND r.costcenterid=$costcenterid
				ORDER BY `requisitionno` DESC;
			ELSE
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND r.vehicleid=$vehicleid AND r.costcenterid=$costcenterid
				ORDER BY `requisitionno` DESC;
			END IF;
		END IF;
	ELSE
		IF $costcenterid=0 THEN
			IF $vehicleid=0 THEN 
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid AND r.supplierid=$supplierid
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate 
				ORDER BY `requisitionno` DESC;
			ELSE
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND r.vehicleid=$vehicleid  AND r.supplierid=$supplierid
				ORDER BY `requisitionno` DESC;
			END IF;
		ELSE
			IF $vehicleid=0 THEN 
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND r.costcenterid=$costcenterid  AND r.supplierid=$supplierid
				ORDER BY `requisitionno` DESC;
			ELSE
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND r.vehicleid=$vehicleid AND r.costcenterid=$costcenterid  AND r.supplierid=$supplierid
				ORDER BY `requisitionno` DESC;
			END IF;
		END IF;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filtergoodsreceivednotes` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filtergoodsreceivednotes` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_filtergoodsreceivednotes`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filterspoilage` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filterspoilage` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_filterspoilage`(`$startdate` DATE, `$enddate` DATE, `$categoryid` INT, `$productid` INT)
BEGIN
	IF $categoryid=0 THEN
		IF $productid=0 THEN
			SELECT s.id, s.`categoryid`, s.`productid`, sc.`categoryname`,p.`itemcode`, p.`itemname`,`quantity`,`narration`,DATE_FORMAT(s.`dateadded`,'%d-%b-%Y') dateadded,
			CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedby
			FROM `spoilage` s, `products` p, `spoilagecategory` sc, `user` u
			WHERE s.`productid`=p.`productid` AND s.`categoryid`=sc.`id` AND s.`addedby`=u.`id` 
			AND DATE_FORMAT(s.dateadded,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			ORDER BY s.id DESC;
		ELSE 
			SELECT s.id, s.`categoryid`, s.`productid`, sc.`categoryname`,p.`itemcode`, p.`itemname`,`quantity`,`narration`,DATE_FORMAT(s.`dateadded`,'%d-%b-%Y') dateadded,
			CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedby
			FROM `spoilage` s, `products` p, `spoilagecategory` sc, `user` u
			WHERE s.`productid`=p.`productid` AND s.`categoryid`=sc.`id` AND s.`addedby`=u.`id` 
			AND DATE_FORMAT(s.dateadded,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND s.productid=$productid
			ORDER BY s.id DESC;
		END IF;
	ELSE
		IF $productid=0 THEN
			SELECT s.id, s.`categoryid`, s.`productid`, sc.`categoryname`,p.`itemcode`, p.`itemname`,`quantity`,`narration`,DATE_FORMAT(s.`dateadded`,'%d-%b-%Y') dateadded,
			CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedby
			FROM `spoilage` s, `products` p, `spoilagecategory` sc, `user` u
			WHERE s.`productid`=p.`productid` AND s.`categoryid`=sc.`id` AND s.`addedby`=u.`id` 
			AND DATE_FORMAT(s.dateadded,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND s.categoryid=$categoryid
			ORDER BY s.id DESC;
		ELSE 
			SELECT s.id, s.`categoryid`, s.`productid`, sc.`categoryname`,p.`itemcode`, p.`itemname`,`quantity`,`narration`,DATE_FORMAT(s.`dateadded`,'%d-%b-%Y') dateadded,
			CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedby
			FROM `spoilage` s, `products` p, `spoilagecategory` sc, `user` u
			WHERE s.`productid`=p.`productid` AND s.`categoryid`=sc.`id` AND s.`addedby`=u.`id` 
			AND DATE_FORMAT(s.dateadded,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND s.productid=$productid AND s.categoryid=$categoryid
			ORDER BY s.id DESC;
		END IF;
	END IF;	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_fleetapprovefuelrequisition` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_fleetapprovefuelrequisition` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_fleetapprovefuelrequisition`(`$id` INT, `$userid` INT)
BEGIN
	UPDATE `fleetfuelrequisition` SET `approvedby`=$userid, `dateapproved`=NOW()
	WHERE `id`=$id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getbranchdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getbranchdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getbranchdetails`(IN $branchid INT)
BEGIN
    SELECT * FROM branches WHERE branchid = $branchid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getbranches` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getbranches` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getbranches`(IN $clientid INT)
BEGIN
    SELECT * FROM branches WHERE clientid = $clientid AND deleted = 0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcontactscategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcontactscategories` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getcontactscategories`()
BEGIN
	SELECT * 
	FROM `contactscategories` 
	ORDER BY `description`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcratesummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcratesummary` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getcratesummary`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcurrencies` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcurrencies` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getcurrencies`(IN $clientid INT)
BEGIN
    SELECT * FROM `currencies` WHERE clientid = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcustomercontacts` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcustomercontacts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getcustomercontacts`(`$customerid` INT)
BEGIN
	SELECT c.*, t.description categoryname, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname
	FROM `user` u, `customercontacts` c, `contactscategories` t
	WHERE c.`categoryid`=t.`id` AND c.`addedby`=u.`id` AND IFNULL(c.deleted,0)=0
	AND `customerid`=$customerid
	ORDER BY contactname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcustomerorderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcustomerorderdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getcustomerorderdetails`(`$orderno` VARCHAR(50))
BEGIN
		SELECT `orderno`,posname,r.customername,tablename, 
		CONCAT(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
		CONCAT(u.firstname,' ',u.middlename,' ',u.lastname) username,
		DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate,
		itemcode, itemname,SUM(quantity) quantity,unitprice
		FROM `customerorders` c
		JOIN `customerorderdetails` cd ON cd.`orderid`=c.`orderid`
		JOIN `products` p ON p.productid=cd.productid
		JOIN `tables` t ON t.tableid=c.tableid
		JOIN `pointsofsale` s ON s.id=c.posid
		JOIN `user` w ON w.id=c.waiterid
		JOIN `user` u ON u.id=c.`addedby`
		JOIN `customers` r ON r.`customerid`=c.customerid
		WHERE c.orderno=$orderno
		GROUP BY itemcode
		ORDER BY p.itemname;
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getdefaultterms` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getdefaultterms` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getdefaultterms`(IN $branchid INT)
BEGIN
    SELECT * FROM `defaultterms` WHERE branchid = $branchid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getdepartmentdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getdepartmentdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getdepartmentdetails`(`$id` INT)
BEGIN
	SELECT * FROM `departments` WHERE `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getdepartments` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getdepartments` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getdepartments`(IN $clientid INT)
BEGIN
    SELECT * FROM `departments` WHERE clientid = $clientid AND deleted = 0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getemailconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getemailconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getemailconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `emailconfiguration` WHERE `clientid` = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetbodytypes` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetbodytypes` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getfleetbodytypes`()
BEGIN
	SELECT * FROM `fleetbodytypes` WHERE IFNULL(deleted,0)=0
	ORDER BY description;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetfueltypes` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetfueltypes` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getfleetfueltypes`()
BEGIN
	SELECT * FROM `fleetfueltypes` WHERE IFNULL(deleted,0)=0
	ORDER BY description;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetrequisitiondetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetrequisitiondetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getfleetrequisitiondetails`(`$id` INT)
BEGIN
	SELECT * FROM `fleetfuelrequisition` WHERE `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetrequisitionheaderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetrequisitionheaderdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getfleetrequisitionheaderdetails`(`$requisitionno` VARCHAR(50))
BEGIN
		SELECT `requisitionno`, DATE_FORMAT(r.`dateadded`,'%d-%b-%Y') requisitiondate, `regno`, `odoreading`, `posname`, s.`suppliername`,s.postalcode,s.town,
		s.`physicaladdress`,s.`postaladdress`,s.`email`,CONCAT(u.`firstname`,' ',u.`middlename`,' ',u.`lastname`) AS preparedby,
		`quantity`,`unitprice`,t.`description` AS fueltype,
		CONCAT(a.`firstname`,' ',a.`middlename`,' ',a.`lastname`) AS approvedby,
		CONCAT(q.`firstname`,' ',q.`middlename`,' ',q.`lastname`) AS requestedby
		FROM  `fleetfuelrequisition` r, `pointsofsale` p, `suppliers` s, `fleetvehicles` v, `user` u, `fleetfueltypes` t, `user` a, `user` q
		WHERE r.`supplierid`=s.supplierid AND r.`costcenterid`=p.id AND  r.`vehicleid`=v.vehicleid AND r.addedby=u.id
		AND r.approvedby=a.id AND r.requestedby=q.id AND t.`id`=v.`fueltypeid` AND r.requisitionno=$requisitionno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetvehicles` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetvehicles` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getfleetvehicles`()
BEGIN
	SELECT v.*, f.description AS fueltype, b.description AS bodytype , CONCAT(firstname,' ',lastname) addedbyname
	FROM `fleetvehicles` v, `fleetfueltypes` f, `fleetbodytypes` b, `user` u
	WHERE   v.`fueltypeid`=f.id AND v.`bodytypeid`=b.id AND v.addedby=u.id
	AND IFNULL(v.`deleted`,0)=0
	ORDER BY `regno`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getgrndetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getgrndetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getgrndetails`(`$grnno` VARCHAR(50))
BEGIN
		SELECT p.`purchaseorderno`,r.itemcode, r.itemname, r.unitofmeasure,gd.quantity, pd.unitprice, gd.quantity*pd.unitprice linetotal
		FROM `goodsreceiveddetails` gd
		INNER JOIN `purchaseorders` p ON p.`purchaseorderno`=gd.`purchaseorderno`
		INNER JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid`=p.`id`
		INNER JOIN `products` r ON r.`productid`=gd.`itemcode` AND r.productid=pd.`itemcode`
		WHERE gd.grnno=$grnno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getgrnheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getgrnheader` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getgrnheader`(`$grnno` VARCHAR(100))
BEGIN
		SELECT w.description AS warehousename,suppliername, `physicaladdress`,`postaladdress`,s.`postalcode`,s.`town`,s.`mobile`,s.`email`,
		`grnno`,DATE_FORMAT(`datereceived`,'%d-%b-%Y %H:%i') datereceived, `deliverynono`,
		CONCAT(r.firstname,' ',r.middlename,' ',r.lastname) receivedbyname
		FROM `goodsreceived` g
		JOIN `suppliers` s ON s.`supplierid`=g.`supplierid`
		JOIN `user` r ON r.`id`=g.`receivedby`
		JOIN `warehouses` w ON w.`id`=g.warehouseid
		WHERE g.`grnno`=$grnno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getgrnheaderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getgrnheaderdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getgrnheaderdetails`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getgrnitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getgrnitems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getgrnitems`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getinputoutputvat` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getinputoutputvat` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getinputoutputvat`(`$startdate` DATE, `$enddate` DATE)
BEGIN
		SELECT itemcode, itemname,SUM(quantity) quantitysold
		FROM `products` p
		JOIN `possalesdetails` sd ON sd.`itemcode`=p.productid 
		JOIN `possales` s ON s.id=sd.`possaleid`
		WHERE DATE_FORMAT(s.`receiptdate`,'%Y-%m%-%d') BETWEEN $startdate AND $enddate
		GROUP BY itemcode;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getinputoutputvatreport` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getinputoutputvatreport` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getinputoutputvatreport`(IN `$branchid` INT, IN `$startdate` DATE, IN `$enddate` DATE)
BEGIN		
		SELECT `itemcode`,`itemname`,`unitofmeasure`,
		FORMAT(SUM(`salesquantity`),2)  qtysold,
		FORMAT(SUM(salesquantity*purchaseprice),2) totalpurchase,
		FORMAT(SUM(`purchaseprice`*`purchasetaxrate`/100)*salesquantity,2) inputvat,
		FORMAT(SUM(salesquantity*m.`sellingprice`),2) totalsales, 
		FORMAT(SUM(m.`sellingprice`*`taxrate`/100)*`salesquantity`,2) outputvat,
		 
		
		FORMAT(SUM(m.`sellingprice`*`taxrate`/100)*`salesquantity` -
		SUM(`purchaseprice`*`purchasetaxrate`/100)*salesquantity,2) vatdifference

		FROM `stockmovement` s
		JOIN `products` p ON s.productid=p.`productid`
		JOIN `stockmovementsalesdetails` m ON m.`stockmovementid`=s.`stockmovementid`
		WHERE `purchasedate` BETWEEN $startdate AND $enddate
		AND s.`branchid` = $branchid
		GROUP BY p.`productid`
		ORDER BY `itemname`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getitemstorebalance` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getitemstorebalance` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getitemstorebalance`(`$productid` INT, `$storeid` INT)
BEGIN
		DECLARE $startdate DATE;
		DECLARE $enddate DATE;
		
		SELECT IFNULL(DATE_FORMAT(`stockcutoffdate`,'%Y-%m-%d'),'01-01-2001'),DATE_FORMAT(NOW(),'%Y-%m-%d')
		INTO $startdate,$enddate 
		FROM `startingparameters`;
		
		-- select reconciled balance 
		SELECT SUM(`quantity`) INTO @reconciledstock
		FROM `stockreconciledbalancedetails` rd
		JOIN `stockreconciledbalance` r ON r.`id`=rd.`reconciliationid`
		WHERE `itemid`=$productid AND DATE_FORMAT(`reconciliationdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		AND posid=$storeid;
		
		SELECT SUM(quantity)
		INTO @transfersin
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE s.id=sd.`transferid` AND `destinationtype`='pos' AND `destinationid`=$storeid AND sd.`itemcode`=$productid
		AND DATE_FORMAT(s.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate;
		
		SELECT SUM(quantity)
		INTO @transfersout
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE s.id=sd.`transferid` AND `sourcetype`='pos' AND `sourceid`=$storeid  AND sd.`itemcode`=$productid
		AND DATE_FORMAT(s.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate;
		
		-- get sales
		SELECT SUM(quantity) 
		INTO @sales
		FROM `possalesdetails` pd
		JOIN `possales` p ON p.`id`=pd.`possaleid`
		WHERE itemcode=$productid AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate 
		AND `pointofsaleid`=$storeid AND p.`deleted`=0;
		
		SELECT IFNULL(@transfersin,0) transfersin,IFNULL(@reconciledstock,0) reconciledstock,
		IFNULL(@transfersout,0) transfersout,IFNULL(@sales,0) sales,$startdate startdate,$enddate enddate;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getloginuisettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getloginuisettings` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getloginuisettings`()
BEGIN
                SELECT * FROM `loginuisettings`;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getmaterialrequestapprovallevels` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getmaterialrequestapprovallevels` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getmaterialrequestapprovallevels`()
BEGIN
	SELECT * 
	FROM `materialrequestapprovallevels` 
	ORDER BY `hierarchy`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getmaterialrequestdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getmaterialrequestdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getmaterialrequestdetails`(`$requisitionno` VARCHAR(50))
BEGIN
		SELECT m.*, p.id AS projectid FROM `materialrequest` m, `projectactivities` a, projects p 
		WHERE m.`activityid`=a.`id` AND a.`projectid`=p.`id` AND `requisitionno`=$requisitionno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getmaterialrequisitiondetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getmaterialrequisitiondetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getmaterialrequisitiondetails`(`$requisitionno` VARCHAR(50))
BEGIN
	SELECT m.*, p.id AS projectid FROM `materialrequest` m, `projectactivities` a, projects p 
	WHERE m.`activityid`=a.`id` AND a.`projectid`=p.`id` AND `requisitionno`=$requisitionno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getmaterialrequisitionitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getmaterialrequisitionitems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getmaterialrequisitionitems`(`$requisitionid` INT)
BEGIN
	SELECT m.`id`,`itemcode`,m.`description` AS itemname, IFNULL(`narration`,'') narration,u.`description` AS uom, `quantity`,`unitprice`
	FROM `materialrequestdetails` mr, `materialdetails` m, `materialunitsofmeasure` u
	WHERE m.`id`=mr.materialid AND m.`unitofmeasureid`=u.`id` AND `materialrequestid`=$requisitionid
	ORDER BY m.description;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getorderstotal` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getorderstotal` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getorderstotal`(`$refno` VARCHAR(50))
BEGIN
		SELECT SUM(quantity*unitprice) orderstotal
		FROM `customerorderdetails`
		WHERE `orderid` IN(SELECT `orderid` FROM `temporderstosettle` WHERE `refno`=$refno);
		
		DELETE FROM `temporderstosettle` 
		WHERE `refno`=$refno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpapergrammage` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpapergrammage` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpapergrammage`(IN $branchid INT)
BEGIN
    SELECT * FROM `papergrammage` WHERE branchid = $branchid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getparentzones` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getparentzones` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getparentzones`(IN `$clientid` INT)
BEGIN
                    SELECT 
                        z.zoneid AS id, 
                        z.zonename, 
                        z.parent, 
                        z.dateadded, 
                        COUNT(c.customerid) AS customers, 
                        CONCAT(u.firstname, ' ', u.middlename, ' ', u.lastname) AS addedbyname 
                    FROM `zones` z
                    INNER JOIN `user` u ON z.`addedby` = u.userid
                    LEFT OUTER JOIN `customers` c ON c.subzoneid = z.zoneid AND IFNULL(c.deleted, 0) = 0
                    WHERE z.`clientid` = `$clientid` 
                      AND z.`parent` = 0 
                      AND IFNULL(z.`deleted`, 0) = 0
                    GROUP BY z.zoneid, z.zonename, z.parent, z.dateadded, u.firstname, u.middlename, u.lastname
                    ORDER BY z.`zonename`;
                END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpodetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpodetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpodetails`(`$pono` VARCHAR(50))
BEGIN
		SELECT r.itemcode, itemname, unitofmeasure,
		SUM(quanity) quantity, unitprice, SUM(quanity)*unitprice AS linetotal
		FROM `purchaseorderdetails` pd
		JOIN `purchaseorders` p ON p.`id`=pd.`purchaseorderid`
		JOIN `products` r ON r.`productid`=pd.`itemcode`
		WHERE `purchaseorderno`=$pono
		GROUP BY r.itemcode
		ORDER BY `itemname`;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpoheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpoheader` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpoheader`(`$pono` VARCHAR(50))
BEGIN
		SELECT `purchaseorderno`, `date`, suppliername, 
		CONCAT('P.O Box', `postaladdress`,', ',`postalcode` ,' ',`town`) supplieraddress,
		CONCAT(firstname,' ',middlename,' ',lastname) username
		FROM `purchaseorders` p
		JOIN `suppliers` s ON s.supplierid=p.supplierid
		JOIN `user` u ON u.`id`=p.`addedby`
		WHERE p.`purchaseorderno`=$pono;
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpoheaderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpoheaderdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpoheaderdetails`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpoidfrompono` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpoidfrompono` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpoidfrompono`(
                IN `$pono` VARCHAR(50)
            )
BEGIN
                SELECT `purchaseorderid` AS poid 
                FROM `purchaseorders` 
                WHERE `purchaseorderno` = $pono;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpoitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpoitems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpoitems`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getposproductcategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getposproductcategories` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getposproductcategories`(IN $branchid INT, IN $posid INT)
BEGIN
    SELECT 
        c.categoryid, 
        c.categoryname,
        pc.poscategoryid
    FROM categories c
    LEFT JOIN posproductcategories pc ON pc.productcategoryid = c.categoryid 
        AND pc.posid = $posid 
        AND pc.deleted = 0
    -- Note: Categories might need branchid filter too if they are branch-specific
    -- For now, we scope the link (posproductcategories) to the branch via the posid
    ORDER BY c.categoryname;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getposproductsbalancepivot` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getposproductsbalancepivot` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getposproductsbalancepivot`(`$startdate` DATE, `$enddate` DATE, `$posid` INT)
BEGIN
		SET SESSION group_concat_max_len = 1000000;
		-- Set the date range and warehouse ID
		SET @start_date = $startdate;
		SET @end_date = $enddate;
		SET @warehouseid = $posid;

		-- Generate a list of dates between the start and end date
		SELECT GROUP_CONCAT(
		    CONCAT(
			'fn_getitemstorebalanceasat(p.productid, ', @warehouseid, ', ''', 
			DATE_FORMAT(DATE(@start_date) + INTERVAL seq DAY, '%Y-%m-%d'), ''') AS `', 
			DATE_FORMAT(DATE(@start_date) + INTERVAL seq DAY, '%d-%b-%Y'), '`'
		    )
		    ORDER BY seq
		    SEPARATOR ', '
		) INTO @pivot_columns
		FROM (
		    SELECT a.N + b.N * 10 AS seq
		    FROM 
			(SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
			 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
			(SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) b
		    WHERE DATE(@start_date) + INTERVAL (a.N + b.N * 10) DAY <= @end_date
		) AS days;

		-- Build the final SQL
		SET @final_sql = CONCAT('
		    SELECT 
			p.productid,
			p.itemcode,
			p.itemname,
			', @pivot_columns, '
		    FROM products p
		    ORDER BY p.itemname
		');

		-- Prepare and execute the dynamic SQL
		PREPARE stmt FROM @final_sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;	
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getproductpurchasessummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getproductpurchasessummary` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getproductpurchasessummary`(IN `$branchid` INT, IN `$startdate` DATE, IN `$enddate` DATE)
BEGIN
	SELECT p.`itemcode`,`itemname`,AVG(`unitprice`) unitprice, SUM(gd.`quantity`) quantity,SUM(gd.`quantity`*`unitprice`) total
	FROM `products` p, `purchaseorderdetails` pod, `purchaseorders` po, `goodsreceived` g, `goodsreceiveddetails` gd
	WHERE p.`productid`=pod.`itemcode` AND pod.`purchaseorderid`=po.`purchaseorderid` AND gd.`itemcode`=p.`productid` AND g.`grnno`=gd.`grnno` 
	AND gd.`purchaseorderno`=po.`purchaseorderno`
	AND DATE_FORMAT(po.`date`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	AND po.`branchid` = $branchid
	GROUP BY  p.`itemcode`,`itemname`
	ORDER BY itemname;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getproductsalessummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getproductsalessummary` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getproductsalessummary`(IN `$branchid` INT, IN `$startdate` DATE, IN `$enddate` DATE)
BEGIN
	SELECT p.`itemcode`,`itemname`,unitprice-discount unitprice, SUM(`quantity`) quantity, SUM(`quantity`*(`unitprice`-discount)) total
	FROM `products` p, `possales` s, `possalesdetails` sd
	WHERE p.`productid`=sd.`itemcode` AND sd.`possaleid`=s.`possaleid` 
	AND DATE_FORMAT(s.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	AND IFNULL(s.`deleted`,0)=0
	AND s.`branchid` = $branchid
	GROUP BY p.`itemcode`,`itemname`,unitprice-discount
	ORDER BY `itemname`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovallevelname` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovallevelname` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpurchaseorderapprovallevelname`(`$hierarchy` INT)
BEGIN
	SELECT `description` FROM `purchaseorderapprovallevels` WHERE `hierarchy`=$hierarchy;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovallevels` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovallevels` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpurchaseorderapprovallevels`()
BEGIN
	SELECT * 
	FROM `purchaseorderapprovallevels` 
	ORDER BY `hierarchy`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovallevelstatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovallevelstatus` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpurchaseorderapprovallevelstatus`(
                IN `$purchaseorderno` VARCHAR(50)
            )
BEGIN
                SET @id = (SELECT `purchaseorderid` FROM `purchaseorders` WHERE `purchaseorderno` = $purchaseorderno);
                SELECT `id`, `description`,
                CASE WHEN EXISTS (SELECT * FROM `purchaseorderapproval` WHERE `poid` = @id AND `approvallevelid` = m.id) THEN 'Approved' ELSE 'Pending' END `status`
                FROM `purchaseorderapprovallevels` m
                ORDER BY `hierarchy`;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovalusers` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovalusers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpurchaseorderapprovalusers`(
                IN `$purchaseorderno` VARCHAR(50), 
                IN `$approvallevel` INT
            )
BEGIN
                SET @departmentid = (SELECT `departmentid` FROM `purchaseorders` WHERE `purchaseorderno` = $purchaseorderno);
                SELECT u.* 
                FROM `user` u, `purchaseorderapprovalusers` a, `purchaseorderapprovallevels` l
                WHERE a.`userid` = u.`userid` 
                  AND a.`approvallevelid` = l.`id` 
                  AND l.`hierarchy` = $approvallevel 
                  AND a.`departmentid` = @departmentid;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovers` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpurchaseorderapprovers`(
                IN `$pono` VARCHAR(50)
            )
BEGIN
                SELECT `description`, `hierarchy`, CONCAT(`firstname`, ' ', `middlename`, ' ', `lastname`) approvedby, signature,
                DATE_FORMAT(a.`approvaldate`, '%d-%b-%Y') approvaldate
                FROM `purchaseorderapproval` a, `purchaseorderapprovallevels` l, `user` u, `purchaseorders` p
                WHERE a.`poid` = p.`purchaseorderid` 
                  AND a.`approvaluser` = u.userid 
                  AND a.`approvallevelid` = l.`id` 
                  AND purchaseorderno = $pono
                ORDER BY `hierarchy`;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseordercurrentstatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseordercurrentstatus` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpurchaseordercurrentstatus`(
                IN `$purchaseorderno` VARCHAR(50)
            )
BEGIN
                SET @id = (SELECT `purchaseorderid` FROM `purchaseorders` WHERE `purchaseorderno` = $purchaseorderno);
                SELECT `fn_purchaseorderstatus`(@id) `status`;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseordernextapprovallevel` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseordernextapprovallevel` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getpurchaseordernextapprovallevel`(
                IN `$purchaseorderno` VARCHAR(50)
            )
BEGIN
                SET @purchaseorderid = (SELECT `purchaseorderid` FROM `purchaseorders` WHERE `purchaseorderno` = $purchaseorderno);
                SELECT a.`id`, `description`, `hierarchy`, IFNULL(s.`id`, 0) `approved`
                FROM `purchaseorderapprovallevels` a
                LEFT OUTER JOIN `purchaseorderapproval` s
                ON a.`id` = s.`approvallevelid` AND `poid` = @purchaseorderid
                WHERE IFNULL(s.`id`, 0) = 0
                ORDER BY `hierarchy`
                LIMIT 1;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getquotationapprovers` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getquotationapprovers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getquotationapprovers`(`$quoteno` VARCHAR(50))
BEGIN
	SELECT `description`,`hierarchy`,CONCAT(`firstname`,' ',`middlename`,' ',`lastname`)approvedby,signature,
	DATE_FORMAT(a.`approvaldate`,'%d-%b-%Y') approvaldate
	FROM `quotationapproval` a,`quotationapprovallevels` l, `user` u,  `quotation` q
	WHERE a.`quoteid`=q.`id` AND a.`userid`=u.id AND a.`approvallevelid`=l.`id` AND quoteno=$quoteno
	ORDER BY `hierarchy`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getquotationdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getquotationdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getquotationdetails`(`$quotationno` VARCHAR(50))
BEGIN
	SELECT `quoteno`,DATE_FORMAT(`quotedate`,'%d-%b-%Y')quotedate,DATE_FORMAT(`expirydate`,'%d-%b-%Y')expirydate, 
	`customername`,CONCAT('P.O Box ',c.`postaladdress`) address, c.`mobile`,c.`email`,`terms`,
	`itemid`,`itemcode`,`itemname`,`quantity`,`unitprice`, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) servedby
	FROM `quotation` q, `quotationdetails` qd, `products` p, `customers` c, `user` u
	WHERE q.`id`=qd.`quoteid` AND q.`customerid`=c.`customerid` AND qd.`itemid`=p.`productid` AND u.id=q.addedby
	AND quoteno=$quotationno; 
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getquotationheaderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getquotationheaderdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getquotationheaderdetails`(`$quoteno` VARCHAR(50))
BEGIN
	SELECT `customername`,`physicaladdress`,`postaladdress`,`town`,`postalcode`,c.`mobile`,c.`email`,`quoteno`,DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotedate,
	DATE_FORMAT(DATE_ADD(`quotedate`, INTERVAL 7 DAY),'%d-%b-%Y') expirydate, terms,CONCAT(firstname,' ',middlename,' ',lastname) preparedby
	FROM `quotation` q, `customers` c, `user` u
	WHERE q.`customerid`=c.`customerid` AND q.`addedby`=u.id AND `quoteno`=$quoteno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getquotationitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getquotationitems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getquotationitems`(`$quoteno` VARCHAR(50))
BEGIN
	SELECT `itemcode`,`itemname`,`unitofmeasure` uom,`quantity`,`unitprice`,
	CASE WHEN category='general' THEN `description` ELSE CONCAT(FORMAT(qd.`length`,0),' X ',FORMAT(qd.`width`,0),' X ',FORMAT(qd.`height`,0)) END description,
	`quantity`*`unitprice` total,'VAT' taxname,16 taxrate
	FROM `quotation` q, `quotationdetails` qd, `products`p
	WHERE q.`id`=qd.`quoteid` AND qd.`itemid`=p.`productid` AND `quoteno`=$quoteno
	ORDER BY `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrawmaterialcategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrawmaterialcategories` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getrawmaterialcategories`()
BEGIN
	SELECT * 
	FROM `rawmaterialcategories` 
	ORDER BY `categoryname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrawmaterialdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrawmaterialdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getrawmaterialdetails`(`$materialid` INT)
BEGIN
	SELECT * 
	FROM `rawmaterials` 
	WHERE `materialid`=$materialid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrawmaterials` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrawmaterials` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getrawmaterials`()
BEGIN
	SELECT * FROM `rawmaterials` 
	WHERE IFNULL(`deleted`,0)=0
	ORDER BY `materialname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitionapprovallevelname` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitionapprovallevelname` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getrequisitionapprovallevelname`(`$hierarchy` INT)
BEGIN
	SELECT `description` FROM `materialrequestapprovallevels` WHERE `hierarchy`=$hierarchy;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitionapprovallevelstatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitionapprovallevelstatus` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getrequisitionapprovallevelstatus`(`$requisitionno` VARCHAR(50))
BEGIN
	SET @id=(SELECT id FROM `materialrequest` WHERE `requisitionno`=$requisitionno);
	SELECT `id`,`description`,
	CASE WHEN EXISTS (SELECT * FROM `materialrequestapproval` WHERE `materialrequestid`=@id AND `approvallevelid`=m.id) THEN 'Approved'  ELSE 'Pending' END `status`
	FROM `materialrequestapprovallevels` m
	ORDER BY `hierarchy`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitionapprovalusers` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitionapprovalusers` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getrequisitionapprovalusers`(`$requisitionno` VARCHAR(50), `$approvallevel` INT)
BEGIN
	SET @departmentid=(SELECT`departmentid` FROM `materialrequest` WHERE `requisitionno`=$requisitionno);
	SELECT u.* FROM `user` u,`materialrequestapprovalusers` a, `materialrequestapprovallevels` l
	WHERE a.`userid`=u.`id` AND  a.`approvallevelid`=l.`id` AND l.`hierarchy`=$approvallevel AND a.`departmentid`=@departmentid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitioncurrentstatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitioncurrentstatus` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getrequisitioncurrentstatus`(`$requisitionno` VARCHAR(50))
BEGIN
	SET @id=(SELECT id FROM `materialrequest` WHERE `requisitionno`=$requisitionno);
	SELECT `fn_requisitionstatus`(@id) `status`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitiondefaultnonpurchasesupplier` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitiondefaultnonpurchasesupplier` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getrequisitiondefaultnonpurchasesupplier`()
BEGIN
	SELECT `defaultnonpurchasesupplier` 
	FROM `materialrequisitionsettings`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitionnextapprovallevel` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitionnextapprovallevel` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getrequisitionnextapprovallevel`(`$requisitionno` VARCHAR(50))
BEGIN
	SET @requisitionid=(SELECT id FROM `materialrequest` WHERE `requisitionno`=$requisitionno);
	SELECT a.`id`,`description`,`hierarchy`,IFNULL(s.`id`,0)`approved`
	FROM `materialrequestapprovallevels` a
	LEFT OUTER JOIN `materialrequestapproval` s
	ON a.`id`=s.`approvallevelid` AND `materialrequestid`=@requisitionid
	WHERE IFNULL(s.`id`,0)=0
	ORDER BY `hierarchy`
	LIMIT 1;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getreturnableproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getreturnableproducts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getreturnableproducts`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `products`
    WHERE `clientid` = $clientid AND `allowreturnexchange`=1
    ORDER BY `itemname`;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getsessioncollectionsummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getsessioncollectionsummary` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getsessioncollectionsummary`(IN $branchid INT, IN $sessionid INT)
BEGIN
    -- Basic summary for now, can be expanded based on transaction tables
    SELECT * FROM `sessions` WHERE `branchid` = $branchid AND `sessionid` = $sessionid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getsessions` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getsessions` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getsessions`(IN $branchid INT)
BEGIN
    SELECT s.*, 
           CONCAT(o.firstname, ' ', o.middlename, ' ', o.lastname) AS openedby,
           IFNULL(CONCAT(c.firstname, ' ', c.middlename, ' ', c.lastname), '-') AS closedby
    FROM `sessions` s
    LEFT JOIN `user` o ON o.`userid` = s.`addedby`
    LEFT JOIN `user` c ON c.`userid` = s.`closedby`
    WHERE s.`branchid` = $branchid
    ORDER BY s.`sessionid` DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getsmsconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getsmsconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getsmsconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `smsconfiguration` WHERE `clientid` = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getspoilagecategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getspoilagecategory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getspoilagecategory`()
BEGIN
	SELECT * FROM `spoilagecategory`
	ORDER BY `categoryname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getsubzones` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getsubzones` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getsubzones`(IN `$clientid` INT, IN `$parent` INT)
BEGIN
                    IF `$parent` = 0 THEN
                        SELECT 
                            z.zoneid AS id, 
                            z.zonename, 
                            z.parent, 
                            z.dateadded, 
                            COUNT(c.customerid) AS customers, 
                            CONCAT(u.firstname, ' ', u.middlename, ' ', u.lastname) AS addedbyname 
                        FROM `zones` z
                        INNER JOIN `user` u ON z.`addedby` = u.userid
                        LEFT OUTER JOIN `customers` c ON c.subzoneid = z.zoneid AND IFNULL(c.deleted, 0) = 0
                        WHERE z.`clientid` = `$clientid` 
                          AND z.`parent` > 0 
                          AND IFNULL(z.`deleted`, 0) = 0
                        GROUP BY z.zoneid, z.zonename, z.parent, z.dateadded, u.firstname, u.middlename, u.lastname
                        ORDER BY z.`zonename`;
                    ELSE
                        SELECT 
                            z.zoneid AS id, 
                            z.zonename, 
                            z.parent, 
                            z.dateadded, 
                            COUNT(c.customerid) AS customers, 
                            CONCAT(u.firstname, ' ', u.middlename, ' ', u.lastname) AS addedbyname 
                        FROM `zones` z
                        INNER JOIN `user` u ON z.`addedby` = u.userid
                        LEFT OUTER JOIN `customers` c ON c.subzoneid = z.zoneid AND IFNULL(c.deleted, 0) = 0
                        WHERE z.`clientid` = `$clientid` 
                          AND z.`parent` = `$parent` 
                          AND IFNULL(z.`deleted`, 0) = 0
                        GROUP BY z.zoneid, z.zonename, z.parent, z.dateadded, u.firstname, u.middlename, u.lastname
                        ORDER BY z.`zonename`;
                    END IF;
                END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_gettabledetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_gettabledetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_gettabledetails`(`$tableid` INT)
BEGIN
		SELECT * FROM `tables`
		WHERE `tableid`=$tableid;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_gettables` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_gettables` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_gettables`(IN $branchid INT, IN $posid INT)
BEGIN
    IF $posid = 0 THEN 
        SELECT 
            t.*, 
            t.id AS tableid,
            p.posname, 
            u.username AS addedbyname
        FROM `tables` t 
        JOIN `pointsofsale` p ON p.`posid` = t.posid
        JOIN `user` u ON u.userid = t.addedby
        WHERE t.deleted = 0 AND p.branchid = $branchid
        ORDER BY p.posname, t.tablename;
    ELSE
        SELECT 
            t.*, 
            t.id AS tableid,
            p.posname, 
            u.username AS addedbyname
        FROM `tables` t 
        JOIN `pointsofsale` p ON p.`posid` = t.posid
        JOIN `user` u ON u.userid = t.addedby
        WHERE t.deleted = 0 AND t.posid = $posid AND p.branchid = $branchid
        ORDER BY t.tablename;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_gettaxdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_gettaxdetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_gettaxdetails`(IN $clientid INT, IN $taxid INT)
BEGIN
    SELECT * FROM `taxtypes` WHERE clientid = $clientid AND id = $taxid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_gettransferreportbyitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_gettransferreportbyitems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_gettransferreportbyitems`(IN `$branchid` INT, IN `$cat` VARCHAR(50), IN `$id` INT, IN `$startdate` DATE, IN `$enddate` DATE)
BEGIN
	SET @type =$cat;
	SET @id=$id;
	SET @startdate=$startdate;
	SET @enddate=$enddate;
	SELECT	sd.itemcode, p.`itemname`, 
	SUM(CASE WHEN `destinationtype`=@type AND `destinationid`=@id THEN `quantity` ELSE 0 END) AS transferin,
	SUM(CASE WHEN `sourcetype`=@type AND `sourceid`=@id THEN `quantity` ELSE 0 END) AS transferout
	FROM `stocktransfer` s, `stocktransferdetails` sd, `products` p
	WHERE s.`stocktransferid`=sd.`transferid` AND sd.`itemcode`=p.`productid`
	AND DATE_FORMAT(s.`dateadded`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	AND s.`branchid` = $branchid
	GROUP BY sd.itemcode, p.`itemname`
	ORDER BY p.itemname;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getunissuedepartmentrequisitions` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getunissuedepartmentrequisitions` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getunissuedepartmentrequisitions`(`$departmentid` INT)
BEGIN
	SELECT DISTINCT requisitionid,requisitionno FROM `vw_requisitionitembalances` WHERE departmentid=$departmentid
	ORDER BY requisitionno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getunissuedrequisitionitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getunissuedrequisitionitems` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getunissuedrequisitionitems`(`$requisitionid` INT)
BEGIN
	SELECT * 
	FROM `vw_requisitionitembalances` WHERE requisitionid=$requisitionid
	ORDER BY itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getuserpurchaseorderapprovalprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getuserpurchaseorderapprovalprivileges` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getuserpurchaseorderapprovalprivileges`(`$userid` INT)
BEGIN
	SELECT * 
	FROM `purchaseorderapprovalusers` 
	WHERE `userid`=$userid AND IFNULL(valid,0)=1;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getuserrequisitionapprovalprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getuserrequisitionapprovalprivileges` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getuserrequisitionapprovalprivileges`(`$userid` INT)
BEGIN
	SELECT * 
	FROM `materialrequestapprovalusers` 
	WHERE `userid`=$userid AND IFNULL(valid,0)=1;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getuserswithprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getuserswithprivilege` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getuserswithprivilege`(
                IN `$objectid` INT
            )
BEGIN
                SELECT * FROM `user` 
                WHERE userid IN (SELECT userid FROM `userprivileges` WHERE `objectid` = $objectid AND `allowed` = 1)
                   OR userid IN (SELECT `userid` FROM `roleusers` r, `roleprivileges` p WHERE r.`roleid` = p.`roleid` AND p.`objectid` = $objectid AND `allowed` = 1);
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getwarehousingproductsbalancepivot` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getwarehousingproductsbalancepivot` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getwarehousingproductsbalancepivot`(`$startdate` DATE, `$enddate` DATE, `$warehouseid` INT)
BEGIN
		SET SESSION group_concat_max_len = 1000000;
		-- Set the date range and warehouse ID
		SET @start_date = $startdate;
		SET @end_date = $enddate;
		SET @warehouseid = $warehouseid;

		-- Generate a list of dates between the start and end date
		SELECT GROUP_CONCAT(
		    CONCAT(
			'fn_getwarehousestockbalance(p.productid, ', @warehouseid, ', ''', 
			DATE_FORMAT(DATE(@start_date) + INTERVAL seq DAY, '%Y-%m-%d'), ''') AS `', 
			DATE_FORMAT(DATE(@start_date) + INTERVAL seq DAY, '%d-%b-%Y'), '`'
		    )
		    ORDER BY seq
		    SEPARATOR ', '
		) INTO @pivot_columns
		FROM (
		    SELECT a.N + b.N * 10 AS seq
		    FROM 
			(SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
			 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
			(SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) b
		    WHERE DATE(@start_date) + INTERVAL (a.N + b.N * 10) DAY <= @end_date
		) AS days;

		-- Build the final SQL
		SET @final_sql = CONCAT('
		    SELECT 
			p.productid,
			p.itemcode,
			p.itemname,
			', @pivot_columns, '
		    FROM products p
		    ORDER BY p.itemname
		');

		-- Prepare and execute the dynamic SQL
		PREPARE stmt FROM @final_sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;	
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getwhatsappconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getwhatsappconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getwhatsappconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `whatsappconfiguration` WHERE `clientid` = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getzonedetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getzonedetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getzonedetails`(IN `$clientid` INT, IN `$id` INT)
BEGIN
                    SELECT `zoneid` AS id, `zonename`, `parent` 
                    FROM `zones` 
                    WHERE `zoneid` = `$id` AND `clientid` = `$clientid`;
                END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getzonesandsubzones` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getzonesandsubzones` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_getzonesandsubzones`(IN `$clientid` INT)
BEGIN
                    SELECT 
                        s.zoneid AS subzoneid, 
                        s.zonename AS subzonename, 
                        p.zonename AS zonename, 
                        p.zoneid AS zoneid
                    FROM `zones` s
                    INNER JOIN `zones` p ON s.`parent` = p.zoneid
                    WHERE s.`clientid` = `$clientid` 
                      AND IFNULL(s.`deleted`, 0) = 0 
                      AND IFNULL(p.`deleted`, 0) = 0
                    ORDER BY zonename, subzonename;
                END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_refundproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_refundproducts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_refundproducts`(`$receiptno` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci, `$reason` VARCHAR(1000), `$refno` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci, `$userid` INT)
BEGIN
		DECLARE $customerid INT;
		DECLARE $posid INT;
		DECLARE $totalamount DECIMAL(18,2);
		
		SELECT `customerid`,`pointofsaleid`
		INTO $customerid,$posid FROM `possales` WHERE `receiptno`=$receiptno;
		
		START TRANSACTION;
			UPDATE `possales`
			SET `deleted`=1,`deletedon`=NOW(),`deletedby`=$userid,`reason`=CONCAT('Customer refunded:',$reason)
			WHERE `receiptno`=$receiptno;
			
			-- Insert unrefunded products into temp receipt
			INSERT INTO `tempsale`(`refno`,`itemcode`,`unitprice`,`discount`,`quantity`,`serialno`,`taxtypeid`,`taxrate`,`description`)
			SELECT
			    $refno,
			    psd.itemcode,
			    psd.unitprice,
			    psd.discount,
			    (psd.quantity - COALESCE(r.refunded_qty, 0)) AS quantity_after_refund,
			    psd.`serialno`, psd.`taxtypeid`, psd.`taxrate`, psd.`description`
			FROM possales ps
			JOIN possalesdetails psd
			    ON psd.possaleid = ps.id
			LEFT JOIN (
			    SELECT
				refno,
				itemcode,
				SUM(quantity) AS refunded_qty
			    FROM temprefundedproducts
			    GROUP BY refno, itemcode
			) r
			   ON r.refno = $refno              -- ✅ moved here
			   AND r.itemcode = psd.itemcode
			WHERE ps.receiptno = $receiptno
			  AND (psd.quantity - COALESCE(r.refunded_qty, 0)) > 0; 
			
			-- Get total receipt value after refund
			
			SELECT SUM(quantity*(unitprice-discount)) 
			INTO $totalamount
			FROM `tempsale`
			WHERE `refno`=$refno;
			
			-- Insert refund payment method
			INSERT INTO `temppossalespayment`(`refno`,`paymentmodeid`,`reference`,`amount`)
			VALUES($refno,8,CONCAT('Refund:',$receiptno),$totalamount);
			
			CALL `spsavepossale`($refno, $customerid, $posid, NOW(), '', $userid);
			
		COMMIT;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_resetuserpin` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_resetuserpin` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_resetuserpin`(`$userid` INT, `$pin` VARCHAR(100), `$salt` VARCHAR(50))
BEGIN
                UPDATE `user`
                SET `pin`=$pin, `pinsalt`=$salt
                WHERE `userid`=$userid;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savebranch` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savebranch` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savebranch`(
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
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savecustomercontact` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savecustomercontact` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savecustomercontact`(`$id` INT, `$customerid` INT, `$categoryid` INT, `$contactname` VARCHAR(100), `$mobile` VARCHAR(100), `$email` VARCHAR(100), `$clientid` INT)
BEGIN
	IF $id=0 THEN 
		INSERT INTO `customercontacts`(`customerid`,`categoryid`,`contactname`,`mobile`,`email`,`dateadded`,`addedby`)
		VALUES($customerid,$categoryid,$contactname,$mobile,$email,NOW(),$clientid);
	ELSE
		UPDATE `customercontacts` 
		SET `categoryid`=$categoryid, `contactname`=$contactname, `mobile`=$mobile, `email`=$email,`customerid`=$customerid
		WHERE `id`=$id;	 
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savecustomerorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savecustomerorder` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savecustomerorder`(`$refno` VARCHAR(50), `$posid` INT, `$customerid` INT, `$tableid` INT, `$userid` INT)
BEGIN
		-- Generate order number
		DECLARE $orderno VARCHAR(50)DEFAULT `fn_generatecustomerorderno`() ;
		DECLARE $orderid INT DEFAULT 0;		
		START TRANSACTION;
			-- Save customer order
			INSERT INTO `customerorders`(`orderno`,`posid`,`customerid`,`tableid`,`waiterid`,`dateadded`,`addedby`)
			VALUES($orderno,$posid,$customerid,$tableid,$userid,NOW(),$userid);
			
			-- Get inserted orderid
			SELECT MAX(`orderid`) INTO $orderid FROM `customerorders`;
			
			-- Save customer details
			INSERT INTO `customerorderdetails`(`orderid`,`productid`,`unitofmeasure`,`quantity`,`unitprice`,`taxid`,`taxrate`)
			SELECT $orderid,t.productid,p.`unitofmeasure`,t.quantity,t.unitprice,p.`taxtypeid`, r.taxrate
			FROM `temcustomerorderdetails` t
			JOIN `products` p ON p.productid=t.productid
			JOIN `taxtypes` r ON r.`id`=p.`taxtypeid`
			WHERE `refno`=$refno;
			
			-- Delete temporary data
			DELETE FROM `temcustomerorderdetails` WHERE `refno`=$refno;
			
			-- Increment order no counter
			UPDATE serials 
			SET currentno=currentno+1 
			WHERE `documenttype`='Customer Order Number';
			
			-- Return order number
			SELECT $orderno AS `orderno`;
		COMMIT;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savedepartment` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savedepartment` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savedepartment`(`$id` INT, `$departmentname` VARCHAR(50), `$clientid` INT, `$hodid` INT)
BEGIN
	IF $id=0 THEN 
		INSERT INTO `departments`(`departmentname`,`dateadded`,`addedby`, `hodid`)
		VALUES($departmentname,NOW(),$clientid,$hodid);
	ELSE
		UPDATE `departments` 
		SET `departmentname`=$departmentname , `hodid`=$hodid
		WHERE `id`=$id;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveemailconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveemailconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_saveemailconfiguration`(
    IN $clientid INT,
    IN $emailaddress VARCHAR(100),
    IN $emailpassword VARCHAR(50),
    IN $smtpserver VARCHAR(50),
    IN $smtpport INT,
    IN $usessl BOOLEAN
)
BEGIN
    IF EXISTS(SELECT * FROM `emailconfiguration` WHERE `clientid` = $clientid) THEN
        UPDATE `emailconfiguration` 
        SET `emailaddress` = $emailaddress,
            `password` = $emailpassword,
            `smtpserver` = $smtpserver,
            `smtpport` = $smtpport,
            `usessl` = $usessl
        WHERE `clientid` = $clientid;
    ELSE
        INSERT INTO `emailconfiguration` (`clientid`, `emailaddress`, `password`, `smtpserver`, `smtpport`, `usessl`)
        VALUES ($clientid, $emailaddress, $emailpassword, $smtpserver, $smtpport, $usessl);
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savefleetvehicle` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savefleetvehicle` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savefleetvehicle`(`$vehicleid` INT, `$regno` VARCHAR(50), `$bodytypeid` INT, `$fueltypeid` INT, `$enginerating` INT, `$clientid` INT)
BEGIN
	IF $vehicleid=0 THEN
		INSERT INTO `fleetvehicles`(`bodytypeid`,`fueltypeid`,`regno`,`enginerating`,`dateadded`,`addedby`,`deleted`)
		VALUES($bodytypeid,$fueltypeid,$regno,$enginerating,NOW(),$clientid,0);	
		SET $vehicleid=(SELECT MAX(vehicleid) FROM `fleetvehicles`);
	ELSE
		UPDATE `fleetvehicles` SET `bodytypeid`=$bodytypeid, `fueltypeid`=$fueltypeid, `regno`=$regno, `enginerating`=$enginerating
		WHERE `vehicleid`=$vehicleid;
	END IF;
	
	SELECT $vehicleid AS vehicleid;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveinstitutiondetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveinstitutiondetails` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_saveinstitutiondetails`(
    IN $clientid INT,
    IN $companyname VARCHAR(100),
    IN $physicaladdress TEXT,
    IN $postaladdress VARCHAR(100),
    IN $landline VARCHAR(50),
    IN $email VARCHAR(100),
    IN $mobile VARCHAR(50),
    IN $pinno VARCHAR(50),
    IN $autoinvoicegrn TINYINT(1),
    IN $postalcode VARCHAR(50),
    IN $tagline VARCHAR(1000),
    IN $website VARCHAR(100),
    IN $receiptfooter VARCHAR(4000),
    IN $defaultcustomer INT,
    IN $mainbusinesstype VARCHAR(50),
    IN $logo VARCHAR(1000),
    IN $town VARCHAR(50),
    IN $allowpricechange TINYINT(1),
    IN $allownegativesalesglobally TINYINT(1)
)
BEGIN
    UPDATE `clients` SET 
        client_name = $companyname,
        physical_address = $physicaladdress,
        postaladdress = $postaladdress,
        landline = $landline,
        email = $email,
        phone_number = $mobile,
        pinno = $pinno,
        autoaddinvoiceduringgrn = $autoinvoicegrn,
        postalcode = $postalcode,
        tagline = $tagline,
        website = $website,
        receiptfooter = $receiptfooter,
        defaultcustomer = $defaultcustomer,
        mainbusinesstype = $mainbusinesstype,
        logo = $logo,
        town = $town,
        allow_price_change = $allowpricechange,
        allow_negative_sales_globally = $allownegativesalesglobally
    WHERE clientid = $clientid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savematerialrequisition` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savematerialrequisition` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savematerialrequisition`(`$id` INT, `$refno` VARCHAR(50), `$materialusecase` INT, `$reference` VARCHAR(50), `$narration` VARCHAR(5000), `$scope` VARCHAR(50), `$supplierid` INT, `$activityid` INT, `$departmentid` INT, `$userid` INT, `$purchaserequisition` BOOL)
BEGIN
	START TRANSACTION;
		IF $id=0 THEN 
			-- generate requisitionno
			SET @requisitionno=`fn_generaterequisitionno`();
			-- save requisition
			INSERT INTO `materialrequest`(`requisitionno`,`materialusecase`,`reference`,`requestdate`,`requestedby`,`narration`,scope,supplierid,activityid,departmentid,`addedby`,`purchaserequisition`)
			VALUES(@requisitionno,$materialusecase,$reference,NOW(),$userid,$narration,$scope,$supplierid,$activityid,$departmentid,$userid,$purchaserequisition);
			-- get the generated requisition id
			SET @materialrequestid=(SELECT MAX(id) FROM `materialrequest`);
			-- save requisition items
			INSERT INTO `materialrequestdetails`(`materialrequestid`,`materialid`,`quantity`,`unitprice`)
			SELECT @materialrequestid,`itemid`,`quantity`,`unitprice` FROM `tempmaterialrequestdetails` WHERE `refno`=$refno;
			-- remove temporary data
			DELETE FROM `tempmaterialrequestdetails` WHERE `refno`=$refno;
			-- Increment requisition number counter
			UPDATE serials SET currentnumber=currentnumber+1 WHERE document='requisition';
			-- return generated requisition number
			SELECT @requisitionno AS requisitionno;
		ELSE
			UPDATE `materialrequest` SET `materialusecase`=$materialusecase,`reference`=$reference,`narration`=$narration,scope=$scope,supplierid=$supplierid,
			activityid=$activityid,departmentid=$departmentid, `purchaserequisition`=$purchaserequisition WHERE `id`=$id;
			-- Remove materials added earlier
			DELETE FROM `materialrequestdetails` WHERE `materialrequestid`=$id;
			-- Add materials requested
			INSERT INTO `materialrequestdetails`(`materialrequestid`,`materialid`,`quantity`,`unitprice`)
			SELECT $id,`itemid`,`quantity`,`unitprice` FROM `tempmaterialrequestdetails` WHERE `refno`=$refno;
			-- remove temporary data
			DELETE FROM `tempmaterialrequestdetails` WHERE `refno`=$refno;
			-- Return requsition number
			SELECT requisitionno FROM `materialrequest` WHERE id=$id;
		END IF;
	COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savematerialsreceived` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savematerialsreceived` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savematerialsreceived`(`$refno` VARCHAR(50), `$source` VARCHAR(50), `$reference` VARCHAR(50), `$userid` INT, `$inspectedby` INT, `$materialusecaseid` INT, `$projectid` INT, `$deliveredby` VARCHAR(50), `$sourceid` INT, `$warehouseid` INT)
BEGIN
	START TRANSACTION;
	
		-- generate the GRN number
		SET @grnno=`fn_generategrnnumber`();
		
		
		IF $source='Customer' THEN 
			SET @customerid=$sourceid;
		ELSEIF $source='Supplier' THEN
			SET @supplierid=$sourceid;
			SET $projectid=NULL;
			SET $materialusecaseid=NULL;
		END IF;
		
		-- Add source details
		INSERT INTO `materialreceipts`(`grnno`,`source`,`deliverynoteno`,`datereceived`,`receivedby`,`inspectedby`,`materialusecaseid`,`supplierid`,`customerid`,`projectid`,`deliveredby`,`warehouseid`)
		VALUES(@grnno,$source,$reference,NOW(),$userid,$inspectedby,$materialusecaseid,@supplierid,@customerid,$projectid,$deliveredby,$warehouseid);
		-- Get the inserted grnid
		SET @receiptid=(SELECT MAX(`id`) FROM `materialreceipts`);
		-- Add material details
		INSERT INTO `materialreceiptdetails`(`receiptid`,`materialid`,`quantity`,`unitprice`,`barcode`,`serialno`,`poid`,`tagno`)
		SELECT @receiptid,`itemid`,quantity,`unitprice`,`fn_generatebarcode`(),`serialno`,CASE WHEN poid=0 THEN NULL ELSE poid END,`tagno` FROM `tempmaterialreceiptdetails`
		WHERE `refno`=$refno;
		-- Remove temporary data
		DELETE FROM `tempmaterialreceiptdetails` WHERE `refno`=$refno;
		--  Return the grn number generated
		SELECT @grnno AS grnno;
	COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveposproductcategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveposproductcategory` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_saveposproductcategory`(`$posid` INT, `$productcategoryid` INT, `$categorystatus` BOOL, `$userid` INT)
BEGIN	
		IF $categorystatus=1 THEN
			IF NOT EXISTS(SELECT * FROM `posproductcategories` WHERE `posid`=$posid AND `productcategoryid`=$productcategoryid AND `deleted`=0) THEN 
				INSERT INTO `posproductcategories`(`posid`,`productcategoryid`,`dateadded`,`addedby`)
				VALUES($posid,$productcategoryid,NOW(),$userid);
			END IF;
		ELSE
			UPDATE `posproductcategories` 
			SET `deleted`=1,`datedeleted`=NOW(),`deletedby`=$userid
			WHERE `posid`=$posid AND `productcategoryid`=$productcategoryid AND deleted=0;
		END IF;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savepurchaseorderprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savepurchaseorderprivilege` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savepurchaseorderprivilege`(`$userid` INT, `$approvallevelid` INT, `$departmentid` INT, `$valid` BOOLEAN, `$addedby` INT)
BEGIN
	IF NOT EXISTS(SELECT * FROM `purchaseorderapprovalusers` WHERE `userid`=$userid AND `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid) THEN	
		IF $valid=1 THEN
			INSERT INTO `purchaseorderapprovalusers`(`approvallevelid`,`userid`,`departmentid`,`valid`,`addedby`,`dateadded`)
			VALUES($approvallevelid,$userid,$departmentid,$valid,$addedby,NOW());
		END IF;
	ELSE
		IF $valid=0 THEN
			UPDATE `purchaseorderapprovalusers` SET `valid`=$valid,`invalidatedby`=$addedby,`dateinvalidated`=NOW()
			WHERE `userid`=$userid AND `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid;
		ELSE
			UPDATE`purchaseorderapprovalusers`  SET `valid`=$valid,`dateadded`=NOW(),`addedby`=$addedby
			WHERE `userid`=$userid AND `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid;
		END IF;
	END IF;
		
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savequotation` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savequotation` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savequotation`(`$id` INT, `$refno` VARCHAR(50), `$customerid` INT, `$terms` VARCHAR(1000), `$category` VARCHAR(50), `$userid` INT)
BEGIN
	IF $id=0 THEN 
		START TRANSACTION;
			SET @quotationvalidity=IFNULL((SELECT quotationvalidity FROM `institution`),30);
			-- Generate quotation number
			SET @quotationno=`fn_generatequoatationno`();
			-- Set Quotation Expiry Date
			SET @quotationexpirydate=DATE_ADD(NOW(), INTERVAL @quotationvalidity DAY);
			-- Insert quotation
			INSERT INTO `quotation`(`quoteno`,`quotedate`,`terms`,`customerid`,`expirydate`,`addedby`,`deleted`,`category`)
			VALUES(@quotationno,NOW(),$terms,$customerid,@quotationexpirydate,$userid,0,$category);
			-- Get inserted ID
			SET $id=(SELECT MAX(id) FROM `quotation`);
			-- Insert quotation details
			INSERT INTO `quotationdetails`(`quoteid`,`itemid`,`description`,`quantity`,`unitprice`,`length`,`width`,`height`,`gsm`,
			`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`)
			SELECT $id,`itemid`,`description`,`quantity`,`unitprice`,`length`,`width`,`height`,`gsm`,
			`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`
			FROM `tempquotationdetails` WHERE `refno`=$refno;
			-- Increment quotation number counter
			UPDATE serials SET currentno=currentno+1 WHERE `documenttype`='Quotation Number';
			-- Delete temp data
			-- delete from `tempquotationdetails`  WHERE `refno`=$refno;
		COMMIT;
	ELSE	
		START TRANSACTION;
			UPDATE `quotation` SET `customerid`=$customerid, `terms`=$terms WHERE `id`=$id;
			-- delete quotation details
			DELETE FROM `quotationdetails` WHERE `quoteid`=$id;
			-- Insert quotation details
			INSERT INTO `quotationdetails`(`quoteid`,`itemid`,`description`,`quantity`,`unitprice`,`length`,`width`,`height`,`gsm`,
			`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`)
			SELECT $id,`itemid`,`description`,`quantity`,`unitprice`,`length`,`width`,`height`,`gsm`,
			`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`
			FROM `tempquotationdetails` WHERE `refno`=$refno;
			-- Delete temp data
			DELETE FROM `tempquotationdetails`  WHERE `refno`=$refno;
			-- get quotation number
			SET @quotationno=(SELECT `quoteno` FROM `quotation` WHERE `id`=$id);
		COMMIT; 
	END IF;
	SELECT @quotationno AS quoteno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saverawmaterial` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saverawmaterial` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_saverawmaterial`(`$materialid` INT, `$categoryid` INT, `$materialname` VARCHAR(50), `$uom` VARCHAR(50), `$physicalproduct` BOOL, `$unitprice` DECIMAL(18,2), `$itemcode` VARCHAR(50), `$generateitemcode` BOOL, `$clientid` INT)
BEGIN
	IF $materialid=0 THEN 
		SET $itemcode=fngeneraterawmaterialcode($categoryid);
		INSERT INTO `rawmaterials`(`materialname`,`categoryid`,`unitprice`,`physicalproduct`,`uom`,`dateadded`,`addedby`,`deleted`)
		VALUES($materialname,$categoryid,$unitprice,$physicalproduct,$uom,NOW(),$clientid,0);
		UPDATE `rawmaterialcategories` SET `currentno`=`currentno`+1 WHERE `categoryid`=$categoryid;
	ELSE
		UPDATE `rawmaterials` SET `materialname`=$materialname,`categoryid`=$categoryid, `unitprice`=$unitprice, 
		`physicalproduct`=$physicalproduct, `uom`=$uom
		WHERE `materialid`=$materialid;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saverequisitionprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saverequisitionprivilege` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_saverequisitionprivilege`(`$userid` INT, `$approvallevelid` INT, `$departmentid` INT, `$valid` BOOLEAN, `$addedby` INT)
BEGIN
	IF NOT EXISTS(SELECT * FROM `materialrequestapprovalusers` WHERE `userid`=$userid AND `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid) THEN	
		IF $valid=1 THEN
			INSERT INTO `materialrequestapprovalusers`(`approvallevelid`,`userid`,`departmentid`,`valid`,`addedby`,`dateadded`)
			VALUES($approvallevelid,$userid,$departmentid,$valid,$addedby,NOW());
		END IF;
	ELSE
		IF $valid=0 THEN
			UPDATE `materialrequestapprovalusers` SET `valid`=$valid,`invalidatedby`=$addedby,`dateinvalidated`=NOW()
			WHERE `userid`=$userid AND `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid;
		ELSE
			UPDATE`materialrequestapprovalusers`  SET `valid`=$valid,`dateadded`=NOW(),`addedby`=$addedby
			WHERE `userid`=$userid AND `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid;
		END IF;
	END IF;
		
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savereturns` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savereturns` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savereturns`(`$outletid` INT, `$warehouseid` INT, `$paymentmodeid` INT, `$reference` VARCHAR(100), `$jsondata` JSON, `$returneditems` JSON, `$userid` INT)
BEGIN
		-- extract sales and returned items 
		DECLARE $i INT DEFAULT 0;
		DECLARE $total INT DEFAULT 0;
		DECLARE $source VARCHAR(50) DEFAULT 'pos';
		DECLARE $destination VARCHAR(50) DEFAULT 'warehouse';
		DECLARE $productid INT;
		DECLARE $unitssold DECIMAL(18,2);
		DECLARE $unitsreturned DECIMAL(18,2);
		DECLARE $unitprice DECIMAL(18,2);
		DECLARE $refno VARCHAR(50) DEFAULT UUID();    
		DECLARE $itemcode VARCHAR(100);      
		DECLARE $defaultcustomer INT DEFAULT (SELECT `defaultcustomerid` FROM `institution` LIMIT 1);                        
		DECLARE $salesvoucherno VARCHAR(50) DEFAULT (SELECT `fn_generatesalesvoucherno`());
		DECLARE $salesvoucherid INT;
		DECLARE $salesvoucheramount DECIMAL(18,2);
		
		SELECT MAX(`voucherid`) INTO $salesvoucherid FROM `salesvoucher`;
		
		-- Process returned items if any
		SET $total=JSON_LENGTH($returneditems);
		IF $total>0 THEN
			-- Save sales voucher
			INSERT INTO `salesvoucher`(`voucherno`,`dateadded`,`addedby`)
			VALUES($salesvoucherno,NOW(),$userid);
			
			SELECT MAX(`voucherid`) INTO $salesvoucherid
			FROM `salesvoucher`;
			
			UPDATE serials SET currentno=currentno+1
			WHERE `documenttype`='Sales Voucher';
			
			WHILE $i < $total DO
				SET $itemcode = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].itemcode')));
				SET $productid = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].productid')));
				-- SET $unitssold = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].unitssold')));
				SET $unitsreturned = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].unitsreturned')));
				SET $unitprice = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].unitprice')));
				
				SET $salesvoucheramount=$salesvoucheramount+($unitsreturned*$unitprice);
				
				INSERT INTO `salesvoucherdetails`(`voucherid`,`itemid`,`quantity`,`unitprice`)
				VALUES($salesvoucherid,$productid,$unitsreturned,$unitprice);
				
				-- Get stock balance at the warehouse as at date
				SET @productwarehousebalance=`fn_warehousestockbalanceasat`($productid,$warehouseid,CURDATE());
				-- Adjust stock for the item in $the main warehouse
				INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
				VALUES($refno,$productid,$unitsreturned+@productwarehousebalance,$unitprice);
				
				SET $i = $i + 1;
			END WHILE;			
			-- Save permanent reconcilliation
			SET @narration=CONCAT('Returnable items received by sales voucher #',$salesvoucherno);
			CALL `spsavestockreconciledbalance`($refno,@narration,$warehouseid,'warehouse',$userid);
		END IF;
		
		SET $total=JSON_LENGTH($jsondata);
		WHILE $i < $total DO
			SET $itemcode = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].itemcode')));
			SET $productid = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].productid')));
			SET $unitssold = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].unitssold')));
			SET $unitsreturned = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].unitsreturned')));
			SET $unitprice = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].unitprice')));
			
			-- Save Temp pos sale
			CALL `spsavetempsale`($refno ,$itemcode,$unitssold,$unitprice,0,'','');
			-- Save temp pos sale payment
			CALL `spsavetemppossalepayment`($refno,$paymentmodeid,$reference,$unitssold*$unitprice);
			
			IF $salesvoucheramount>0 THEN
				CALL `spsavetemppossalepayment`($refno,8,$salesvoucherno,$salesvoucheramount);
			END IF;
			
			-- Save temp stock transfer
			CALL `spsavetempstocktransfer`($refno,$itemcode,$unitprice,$unitsreturned,'');
			
			SET $i = $i + 1;
		END WHILE;

		-- save pos sale
		CALL `spsavepossale`($refno,$defaultcustomer,$outletid,CURDATE(),'',$userid);
		
		-- return back the stock
		CALL `spsavestocktransfer`($refno,$source,$outletid,$destination,$warehouseid,$userid,$userid,$userid);
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savesmsconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savesmsconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savesmsconfiguration`(
    IN $clientid INT,
    IN $apikey VARCHAR(255),
    IN $senderid VARCHAR(50),
    IN $partnerid VARCHAR(100),
    IN $url VARCHAR(255)
)
BEGIN
    IF EXISTS(SELECT * FROM `smsconfiguration` WHERE `clientid` = $clientid) THEN
        UPDATE `smsconfiguration`
        SET `apikey` = $apikey,
            `senderid` = $senderid,
            `partnerid` = $partnerid,
            `url` = $url
        WHERE `clientid` = $clientid;
    ELSE
        INSERT INTO `smsconfiguration` (`clientid`, `apikey`, `senderid`, `partnerid`, `url`)
        VALUES ($clientid, $apikey, $senderid, $partnerid, $url);
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savetable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savetable` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savetable`(`$tableid` INT, `$posid` INT, `$tablename` VARCHAR(50), `$userid` INT)
BEGIN
		IF $tableid=0 THEN 
			INSERT INTO `tables`(`posid`,`tablename`,`dateadded`,`addedby`)
			VALUES($posid,$tablename,NOW(),$userid);
		ELSE
			UPDATE `tables`
			SET `tablename`=$tablename, `posid`=$posid
			WHERE `tableid`=$tableid;
		END IF;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savetempcustomerorderdetail` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savetempcustomerorderdetail` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savetempcustomerorderdetail`(
    IN $branchid INT,
    IN $refno VARCHAR(50), 
    IN $productid INT, 
    IN $quantity DECIMAL(5,2), 
    IN $unitprice DECIMAL(7,2)
)
BEGIN
    INSERT INTO `temcustomerorderdetails`(`branchid`, `refno`, `productid`, `quantity`, `unitprice`)
    VALUES($branchid, $refno, $productid, $quantity, $unitprice);
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savetemporderstosettle` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savetemporderstosettle` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savetemporderstosettle`(
    IN $branchid INT,
    IN $refno VARCHAR(50), 
    IN $orderid INT
)
BEGIN
    INSERT INTO `temporderstosettle`(`branchid`, `refno`, `orderid`)
    VALUES($branchid, $refno, $orderid);
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savetempquotation` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savetempquotation` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savetempquotation`(`$refno` VARCHAR(50), `$itemid` INT, `$description` VARCHAR(500), `$quantity` DECIMAL(18,2), `$unitprice` DECIMAL(18,2), `$ilength` DECIMAL(18,2), `$width` DECIMAL(18,2), `$height` DECIMAL(18,2), `$gsm` DECIMAL(18,2), `$weight` DECIMAL(18,4), `$plies` DECIMAL(18,2), `$jointallowance` DECIMAL(18,2), `$trimallowance` DECIMAL(18,2), `$profitmargin` DECIMAL(18,2), `$printing` DECIMAL(18,2), `$freight` DECIMAL(18,2), `$waste` DECIMAL(18,2), `$flutefactor` DECIMAL(18,2))
BEGIN
	INSERT INTO `tempquotationdetails`(`refno`,`itemid`,`quantity`,`unitprice`,`description`,`length`,`width`,`height`,`gsm`,
		`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`)
	VALUES($refno,$itemid,$quantity,$unitprice,$description,$ilength,$width,$height,$gsm,$weight,$plies,$jointallowance,
		$trimallowance,$profitmargin,$printing,$freight,$waste,$flutefactor);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savetemprefundedproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savetemprefundedproducts` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savetemprefundedproducts`(`$refno` VARCHAR(50), `$itemcode` VARCHAR(50), `$quantity` DECIMAL(18,2))
BEGIN
		DECLARE $productid INT;
		
		SELECT productid 
		INTO $productid FROM `products` 
		WHERE `itemcode`=$itemcode;
		
		INSERT INTO `temprefundedproducts`(`refno`,`itemcode`,`quantity`)
		VALUES($refno,$productid,$quantity);
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveuser` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_saveuser`(
    IN $clientid INT,
    IN $defaultbranchid INT,
    IN $userid INT, 
    IN $userpassword VARCHAR(100),
    IN $salt VARCHAR(50),
    IN $profilephoto VARCHAR(255),
    IN $systemadmin TINYINT,
    IN $username VARCHAR(50),
    IN $firstname VARCHAR(50),
    IN $middlename VARCHAR(50),
    IN $lastname VARCHAR(50),
    IN $email VARCHAR(50),
    IN $mobile VARCHAR(50),
    IN $changepasswordonlogon TINYINT,
    IN $accountactive TINYINT,
    IN $pin VARCHAR(100),
    IN $pinsalt VARCHAR(50),
    IN $addedby INT
)
BEGIN
    IF $userid = 0 THEN 
        INSERT INTO `user`(
            clientid, defaultbranchid, username, password, salt, profilephoto, firstname, middlename, lastname, email, mobile, 
            changepasswordonlogon, accountactive, addedby, dateadded, systemadmin, pin, pinsalt
        ) VALUES (
            $clientid, $defaultbranchid, $username, $userpassword, $salt, $profilephoto, $firstname, $middlename, $lastname, $email, $mobile, 
            $changepasswordonlogon, $accountactive, $addedby, NOW(), $systemadmin, $pin, $pinsalt
        );
        SET $userid = LAST_INSERT_ID();
    ELSE
        UPDATE `user` SET 
            defaultbranchid = $defaultbranchid,
            username = $username, 
            profilephoto = CASE WHEN $profilephoto IS NOT NULL AND $profilephoto != '' THEN $profilephoto ELSE profilephoto END,
            firstname = $firstname, 
            middlename = $middlename, 
            lastname = $lastname, 
            email = $email, 
            mobile = $mobile,
            changepasswordonlogon = $changepasswordonlogon, 
            accountactive = $accountactive,
            systemadmin = $systemadmin, 
            lastmodifiedby = $addedby, 
            lastmodifiedon = NOW(),
            pin = $pin,
            pinsalt = $pinsalt
        WHERE userid = $userid;
    END IF;
    
    SELECT $userid AS userid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveuserprofilephoto` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveuserprofilephoto` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_saveuserprofilephoto`(
    IN $clientid INT, 
    IN $userid INT, 
    IN $profilephoto VARCHAR(255)
)
BEGIN
    UPDATE `user` SET profilephoto = $profilephoto WHERE clientid = $clientid AND userid = $userid;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveusersignature` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveusersignature` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_saveusersignature`(`$userid` INT, `$documentname` VARCHAR(1000))
BEGIN
                UPDATE `user` SET `signature`=$documentname WHERE `userid`=$userid;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savewhatsappconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savewhatsappconfiguration` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savewhatsappconfiguration`(
    IN $clientid INT,
    IN $apikey VARCHAR(255),
    IN $phone_number_id VARCHAR(100),
    IN $url VARCHAR(255)
)
BEGIN
    IF EXISTS(SELECT * FROM `whatsappconfiguration` WHERE `clientid` = $clientid) THEN
        UPDATE `whatsappconfiguration`
        SET `apikey` = $apikey,
            `phone_number_id` = $phone_number_id,
            `url` = $url
        WHERE `clientid` = $clientid;
    ELSE
        INSERT INTO `whatsappconfiguration` (`clientid`, `apikey`, `phone_number_id`, `url`)
        VALUES ($clientid, $apikey, $phone_number_id, $url);
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savezone` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savezone` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_savezone`(IN `$clientid` INT, IN `$id` INT, IN `$zonename` VARCHAR(100), IN `$parent` INT, IN `$userid` INT)
BEGIN
                    IF `$id` = 0 THEN
                        INSERT INTO `zones`(`clientid`, `zonename`, `dateadded`, `addedby`, `deleted`, `parent`)
                        VALUES(`$clientid`, `$zonename`, NOW(), `$userid`, 0, `$parent`);
                    ELSE
                        UPDATE `zones` 
                        SET `zonename` = `$zonename`, `parent` = `$parent` 
                        WHERE `zoneid` = `$id` AND `clientid` = `$clientid`;
                    END IF;
                END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_settleorderpayments` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_settleorderpayments` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_settleorderpayments`(`$refno` VARCHAR(50), `$userid` INT)
BEGIN
		DECLARE $posid INT;
		DECLARE $customerid INT;
		DECLARE $receiptid INT;
		DECLARE $receiptno VARCHAR(50);
		
		SELECT posid, customerid INTO $posid,$customerid
		FROM `temporderstosettle` t 
		JOIN `customerorders` c ON c.`orderid`=t.`orderid`
		WHERE `refno`=$refno LIMIT 1;
		
		-- Save temp pos sale 
		INSERT INTO `tempsale`(`refno`,`itemcode`,`unitprice`,`discount`,`quantity`,`serialno`,`taxtypeid`,`taxrate`)
		SELECT $refno,`productid`,`unitprice`,0,`quantity`,'',`taxid`,`taxrate`
		FROM `customerorderdetails` WHERE `orderid` IN(SELECT `orderid` FROM `temporderstosettle` WHERE `refno`=$refno);
		
		-- Save POS Sale
		CALL `spsavepossale`($refno,$customerid,$posid,NOW(),$userid);
		
		-- Get Id for the inserted receipt
		SELECT MAX(`id`) INTO $receiptid FROM `possales`;
		
		SELECT `receiptno` 
		INTO $receiptno 
		FROM `possales` WHERE `id`=$receiptid;
		
		-- Update Orders as Settled
		UPDATE `customerorders` 
		SET `status`='Paid', `settledby`=$userid,`receiptid`=$receiptid
		WHERE `orderid` IN(SELECT orderid FROM `temporderstosettle` WHERE `refno`=$refno);
		
		-- Remove temporary data
		DELETE FROM `temporderstosettle` WHERE `refno`=$refno;
		
		-- Return the erecipt no
		SELECT $receiptno AS `receiptno`;
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_subzones` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_subzones` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_subzones`(`$clientid` INT)
BEGIN
	IF $clientid=0 THEN
		SELECT z.id,z.zonename,z.parent,z.dateadded,COUNT(c.customerid) customers, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname 
		FROM `zones` z
		INNER JOIN `user` u ON z.`addedby`=u.id
		LEFT OUTER JOIN `customers` c ON c.subzoneid=z.id
		WHERE z.`parent`>0 AND IFNULL(z.`deleted`,0)=0
		GROUP BY z.id,z.zonename,z.parent,z.dateadded
		ORDER BY `zonename`;
	ELSE
		SELECT z.id,z.zonename,z.parent,z.dateadded,COUNT(c.customerid) customers, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname 
		FROM `zones` z
		INNER JOIN `user` u ON z.`addedby`=u.id
		LEFT OUTER JOIN `customers` c ON c.subzoneid=z.id
		WHERE z.`parent`=$clientid AND IFNULL(z.`deleted`,0)=0
		GROUP BY z.id,z.zonename,z.parent,z.dateadded
		ORDER BY `zonename`;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_validatepurchaseorderapproval` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_validatepurchaseorderapproval` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_validatepurchaseorderapproval`(
                IN `$clientid` INT,
                IN `$approvallevel` INT,
                IN `$departmentid` INT
            )
BEGIN
                DECLARE $admin INT DEFAULT 0;
                DECLARE $valid INT DEFAULT 0;
                SET $admin = (SELECT systemadmin FROM `user` WHERE `userid` = $clientid);
                IF $admin = 1 THEN
                    SET $valid = 1;
                ELSE
                    IF $approvallevel = 0 THEN 
                        IF EXISTS(SELECT `valid` FROM `purchaseorderapprovalusers` WHERE `userid` = $clientid AND departmentid = $departmentid AND valid = 1) THEN
                            SET $valid = 1;
                        END IF;
                    ELSE
                        SET $valid = IFNULL((SELECT `valid` FROM `purchaseorderapprovalusers` WHERE `userid` = $clientid AND departmentid = $departmentid AND `approvallevelid` = $approvallevel AND valid = 1), 0);
                    END IF;
                END IF;
                
                SELECT $valid AS `allowed`;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_validaterequisitionapproval` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_validaterequisitionapproval` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_validaterequisitionapproval`(
                IN `$clientid` INT,
                IN `$approvallevel` INT,
                IN `$departmentid` INT
            )
BEGIN
                DECLARE $admin INT DEFAULT 0;
                DECLARE $valid INT DEFAULT 0;
                SET $admin = (SELECT systemadmin FROM `user` WHERE `userid` = $clientid);
                IF $admin = 1 THEN
                    SET $valid = 1;
                ELSE
                    IF $approvallevel = 0 THEN 
                        IF EXISTS(SELECT `valid` FROM `materialrequestapprovalusers` WHERE `userid` = $clientid AND departmentid = $departmentid AND valid = 1) THEN
                            SET $valid = 1;
                        END IF;
                    ELSE
                        SET $valid = IFNULL((SELECT `valid` FROM `materialrequestapprovalusers` WHERE `userid` = $clientid AND departmentid = $departmentid AND `approvallevelid` = $approvallevel AND valid = 1), 0);
                    END IF;
                END IF;
                
                SELECT $valid AS `allowed`;
            END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_validateuserprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_validateuserprivilege` */;

DELIMITER $$

/*!50003 CREATE  PROCEDURE `sp_validateuserprivilege`(`$userid` INT, `$objectid` INT)
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
END */$$
DELIMITER ;

/*Table structure for table `vwcustomerreceipts` */

DROP TABLE IF EXISTS `vwcustomerreceipts`;

/*!50001 DROP VIEW IF EXISTS `vwcustomerreceipts` */;
/*!50001 DROP TABLE IF EXISTS `vwcustomerreceipts` */;

/*!50001 CREATE TABLE  `vwcustomerreceipts`(
 `id` int(11) ,
 `date` varchar(10) ,
 `posname` varchar(50) ,
 `customername` varchar(50) ,
 `receiptno` varchar(50) ,
 `paymentmodeid` int(11) ,
 `description` varchar(50) ,
 `reference` varchar(50) ,
 `banked` int(4) ,
 `amount` decimal(32,0) ,
 `addedby` varchar(101) 
)*/;

/*Table structure for table `vwcustomerstomerstatement` */

DROP TABLE IF EXISTS `vwcustomerstomerstatement`;

/*!50001 DROP VIEW IF EXISTS `vwcustomerstomerstatement` */;
/*!50001 DROP TABLE IF EXISTS `vwcustomerstomerstatement` */;

/*!50001 CREATE TABLE  `vwcustomerstomerstatement`(
 `branchid` int(11) ,
 `id` int(11) ,
 `customerid` int(11) ,
 `customername` varchar(50) ,
 `physicaladdress` varchar(50) ,
 `postaladdress` varchar(50) ,
 `mobile` varchar(50) ,
 `email` varchar(50) ,
 `date` datetime ,
 `narration` varchar(27) ,
 `reference` varchar(50) ,
 `invoiceamount` decimal(10,2) ,
 `invoicepayment` decimal(32,0) ,
 `order` int(1) 
)*/;

/*Table structure for table `vwopenorders` */

DROP TABLE IF EXISTS `vwopenorders`;

/*!50001 DROP VIEW IF EXISTS `vwopenorders` */;
/*!50001 DROP TABLE IF EXISTS `vwopenorders` */;

/*!50001 CREATE TABLE  `vwopenorders`(
 `branchid` int(11) ,
 `purchaseorderno` varchar(50) ,
 `date` datetime ,
 `supplierid` int(11) ,
 `itemcode` int(11) ,
 `quantity` decimal(10,2) ,
 `received` decimal(32,2) 
)*/;

/*Table structure for table `vwopenpayables` */

DROP TABLE IF EXISTS `vwopenpayables`;

/*!50001 DROP VIEW IF EXISTS `vwopenpayables` */;
/*!50001 DROP TABLE IF EXISTS `vwopenpayables` */;

/*!50001 CREATE TABLE  `vwopenpayables`(
 `branchid` int(11) ,
 `supplierid` int(11) ,
 `invoiceno` varchar(50) ,
 `invoicedate` datetime ,
 `status` varchar(50) ,
 `invoiceamount` decimal(42,4) ,
 `settled` decimal(42,6) 
)*/;

/*Table structure for table `vwpaymentvouchers` */

DROP TABLE IF EXISTS `vwpaymentvouchers`;

/*!50001 DROP VIEW IF EXISTS `vwpaymentvouchers` */;
/*!50001 DROP TABLE IF EXISTS `vwpaymentvouchers` */;

/*!50001 CREATE TABLE  `vwpaymentvouchers`(
 `voucherid` int(11) ,
 `branchid` int(11) ,
 `pettycashvoucher` int(4) ,
 `voucherno` varchar(50) ,
 `voucherdate` varchar(10) ,
 `paymentmodeid` int(11) ,
 `paymentmodedescription` varchar(50) ,
 `posid` int(11) ,
 `posname` varchar(50) ,
 `supplierid` int(11) ,
 `suppliername` varchar(50) ,
 `invoicenumber` varchar(50) ,
 `cashbookaccountid` int(11) ,
 `accountcode` varchar(50) ,
 `accountname` varchar(100) ,
 `referenceno` varchar(50) ,
 `status` varchar(50) ,
 `vouchertotal` decimal(42,6) ,
 `userid` int(11) ,
 `username` varchar(152) 
)*/;

/*Table structure for table `vwpointofsaleitembalances` */

DROP TABLE IF EXISTS `vwpointofsaleitembalances`;

/*!50001 DROP VIEW IF EXISTS `vwpointofsaleitembalances` */;
/*!50001 DROP TABLE IF EXISTS `vwpointofsaleitembalances` */;

/*!50001 CREATE TABLE  `vwpointofsaleitembalances`(
 `posid` int(11) ,
 `posname` varchar(50) ,
 `itemid` int(11) ,
 `itemcode` varchar(50) ,
 `itemname` varchar(255) ,
 `unitofmeasure` varchar(50) ,
 `buyingprice` decimal(10,2) ,
 `unitsreceived` decimal(32,2) ,
 `issued` decimal(32,2) 
)*/;

/*Table structure for table `vwsalessummary` */

DROP TABLE IF EXISTS `vwsalessummary`;

/*!50001 DROP VIEW IF EXISTS `vwsalessummary` */;
/*!50001 DROP TABLE IF EXISTS `vwsalessummary` */;

/*!50001 CREATE TABLE  `vwsalessummary`(
 `transactiondate` varchar(10) ,
 `id` int(11) ,
 `receiptno` varchar(50) ,
 `paymentmode` varchar(50) ,
 `paymentmodereference` varchar(50) ,
 `pointofsale` varchar(50) ,
 `customerid` int(11) ,
 `customername` varchar(50) ,
 `userid` int(11) ,
 `receipttotal` decimal(10,2) ,
 `posid` int(11) ,
 `banked` int(4) ,
 `userfullname` varchar(152) ,
 `username` varchar(50) ,
 `clientid` int(11) ,
 `branchid` int(11) 
)*/;

/*Table structure for table `vwsalessummary2` */

DROP TABLE IF EXISTS `vwsalessummary2`;

/*!50001 DROP VIEW IF EXISTS `vwsalessummary2` */;
/*!50001 DROP TABLE IF EXISTS `vwsalessummary2` */;

/*!50001 CREATE TABLE  `vwsalessummary2`(
 `branchid` int(11) ,
 `transactiondate` timestamp ,
 `id` int(11) ,
 `receiptno` varchar(50) ,
 `paymentmode` varchar(50) ,
 `paymentmodereference` varchar(50) ,
 `pointofsale` varchar(50) ,
 `customerid` int(11) ,
 `customername` varchar(50) ,
 `userid` int(11) ,
 `receipttotal` decimal(10,2) ,
 `quantity` decimal(32,2) ,
 `posid` int(11) ,
 `banked` int(4) ,
 `userfullname` varchar(50) ,
 `username` varchar(50) 
)*/;

/*Table structure for table `vwstockcenters` */

DROP TABLE IF EXISTS `vwstockcenters`;

/*!50001 DROP VIEW IF EXISTS `vwstockcenters` */;
/*!50001 DROP TABLE IF EXISTS `vwstockcenters` */;

/*!50001 CREATE TABLE  `vwstockcenters`(
 `posname` varchar(50) 
)*/;

/*Table structure for table `vwstockdetails` */

DROP TABLE IF EXISTS `vwstockdetails`;

/*!50001 DROP VIEW IF EXISTS `vwstockdetails` */;
/*!50001 DROP TABLE IF EXISTS `vwstockdetails` */;

/*!50001 CREATE TABLE  `vwstockdetails`(
 `date` varchar(40) ,
 `posname` varchar(50) ,
 `itemcode` varchar(50) ,
 `itemname` varchar(255) ,
 `unitofmeasure` varchar(50) ,
 `buyingprice` decimal(14,6) ,
 `sellingprice` decimal(14,6) ,
 `purchases` decimal(32,2) ,
 `quantitysold` decimal(32,2) ,
 `transfersout` decimal(32,2) ,
 `transfersin` decimal(32,2) 
)*/;

/*Table structure for table `vwstocktransfers` */

DROP TABLE IF EXISTS `vwstocktransfers`;

/*!50001 DROP VIEW IF EXISTS `vwstocktransfers` */;
/*!50001 DROP TABLE IF EXISTS `vwstocktransfers` */;

/*!50001 CREATE TABLE  `vwstocktransfers`(
 `referenceno` varchar(50) ,
 `sourcetype` varchar(50) ,
 `sourceid` int(11) ,
 `sourcename` varchar(50) ,
 `destinationtype` varchar(50) ,
 `destinationid` varchar(50) ,
 `destinationame` varchar(50) ,
 `addedby` int(11) ,
 `dateadded` datetime ,
 `username` varchar(152) ,
 `issuedto` varchar(152) ,
 `storecontroller` varchar(152) 
)*/;

/*Table structure for table `vwstores` */

DROP TABLE IF EXISTS `vwstores`;

/*!50001 DROP VIEW IF EXISTS `vwstores` */;
/*!50001 DROP TABLE IF EXISTS `vwstores` */;

/*!50001 CREATE TABLE  `vwstores`(
 `posname` varchar(50) 
)*/;

/*Table structure for table `vwsupplierstatement` */

DROP TABLE IF EXISTS `vwsupplierstatement`;

/*!50001 DROP VIEW IF EXISTS `vwsupplierstatement` */;
/*!50001 DROP TABLE IF EXISTS `vwsupplierstatement` */;

/*!50001 CREATE TABLE  `vwsupplierstatement`(
 `clientid` int(11) ,
 `supplierid` int(11) ,
 `suppliername` varchar(50) ,
 `physicaladdress` varchar(100) ,
 `postaladdress` varchar(100) ,
 `mobile` varchar(50) ,
 `email` varchar(50) ,
 `invoicedate` datetime ,
 `reference` varchar(50) ,
 `narrative` varchar(80) ,
 `invoiceamount` decimal(42,4) ,
 `invoicepayment` decimal(42,6) ,
 `order` int(1) 
)*/;

/*Table structure for table `vwwarehouseitembalances` */

DROP TABLE IF EXISTS `vwwarehouseitembalances`;

/*!50001 DROP VIEW IF EXISTS `vwwarehouseitembalances` */;
/*!50001 DROP TABLE IF EXISTS `vwwarehouseitembalances` */;

/*!50001 CREATE TABLE  `vwwarehouseitembalances`(
 `warehouseid` int(11) ,
 `warehousename` varchar(50) ,
 `itemcode` varchar(50) ,
 `itemname` varchar(255) ,
 `productid` int(11) ,
 `unitofmeasure` varchar(50) ,
 `buyingprice` decimal(10,2) ,
 `sellingprice` decimal(10,2) ,
 `serializable` tinyint(1) ,
 `unitsreceived` decimal(33,2) ,
 `issued` decimal(32,2) 
)*/;

/*View structure for view vwcustomerreceipts */

/*!50001 DROP TABLE IF EXISTS `vwcustomerreceipts` */;
/*!50001 DROP VIEW IF EXISTS `vwcustomerreceipts` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwcustomerreceipts` AS select `r`.`customerreceiptid` AS `id`,date_format(`r`.`receiptdate`,'%Y-%m-%d') AS `date`,`o`.`posname` AS `posname`,`c`.`customername` AS `customername`,`r`.`receiptno` AS `receiptno`,`r`.`modeofpayment` AS `paymentmodeid`,`p`.`description` AS `description`,`r`.`referenceno` AS `reference`,ifnull(`r`.`banked`,0) AS `banked`,sum(`rd`.`amount`) AS `amount`,concat(`u`.`firstname`,' ',`u`.`lastname`) AS `addedby` from (((((`customerreceipts` `r` join `customerreceiptdetails` `rd` on(`r`.`customerreceiptid` = `rd`.`receiptid`)) join `customers` `c` on(`r`.`customerid` = `c`.`customerid`)) join `paymentmethods` `p` on(`r`.`modeofpayment` = `p`.`id`)) join `pointsofsale` `o` on(`c`.`posid` = `o`.`posid`)) join `user` `u` on(`r`.`addedby` = `u`.`userid`)) where ifnull(`r`.`deleted`,0) = 0 group by `r`.`customerreceiptid`,`o`.`posname`,`c`.`customername`,`r`.`receiptno`,`r`.`modeofpayment`,`p`.`description`,`r`.`referenceno`,`r`.`banked`,`u`.`firstname`,`u`.`lastname`,`r`.`receiptdate` order by date_format(`r`.`receiptdate`,'%Y-%m-%d') */;

/*View structure for view vwcustomerstomerstatement */

/*!50001 DROP TABLE IF EXISTS `vwcustomerstomerstatement` */;
/*!50001 DROP VIEW IF EXISTS `vwcustomerstomerstatement` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwcustomerstomerstatement` AS select `p`.`branchid` AS `branchid`,`p`.`possaleid` AS `id`,`c`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`c`.`physicaladdress` AS `physicaladdress`,`c`.`postaladdress` AS `postaladdress`,`c`.`mobile` AS `mobile`,`c`.`email` AS `email`,`p`.`receiptdate` AS `date`,'Invoice issued to customer' AS `narration`,`pm`.`reference` AS `reference`,`pm`.`amount` AS `invoiceamount`,0 AS `invoicepayment`,0 AS `order` from ((`customers` `c` join `possales` `p` on(`c`.`customerid` = `p`.`customerid`)) join `possalespayments` `pm` on(`p`.`possaleid` = `pm`.`possaleid`)) where `pm`.`paymentmode` = 4 and `p`.`deleted` = 0 and cast(`p`.`receiptdate` as date) >= (select cast(`startingparameters`.`cutoffdate` as date) from `startingparameters` limit 1) union all select `cr`.`branchid` AS `branchid`,`cr`.`customerreceiptid` AS `id`,`c`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`c`.`physicaladdress` AS `physicaladdress`,`c`.`postaladdress` AS `postaladdress`,`c`.`mobile` AS `mobile`,`c`.`email` AS `email`,`cr`.`receiptdate` AS `date`,'Payment received. Thank You' AS `narration`,`cr`.`receiptno` AS `reference`,0 AS `invoiceamount`,sum(`cd`.`amount`) AS `invoicepayment`,1 AS `order` from ((`customers` `c` join `customerreceipts` `cr` on(`c`.`customerid` = `cr`.`customerid`)) join `customerreceiptdetails` `cd` on(`cr`.`customerreceiptid` = `cd`.`receiptid`)) where (`cr`.`deleted` is null or `cr`.`deleted` = 0) and cast(`cr`.`receiptdate` as date) >= (select cast(`startingparameters`.`cutoffdate` as date) from `startingparameters` limit 1) group by `cr`.`branchid`,`cr`.`customerreceiptid`,`c`.`customerid`,`cr`.`receiptdate`,`cr`.`receiptno` */;

/*View structure for view vwopenorders */

/*!50001 DROP TABLE IF EXISTS `vwopenorders` */;
/*!50001 DROP VIEW IF EXISTS `vwopenorders` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwopenorders` AS select `p`.`branchid` AS `branchid`,`p`.`purchaseorderno` AS `purchaseorderno`,`p`.`date` AS `date`,`p`.`supplierid` AS `supplierid`,`pd`.`itemcode` AS `itemcode`,`pd`.`quanity` AS `quantity`,ifnull((select sum(`gd`.`quantity`) from (`goodsreceived` `g` join `goodsreceiveddetails` `gd` on(`g`.`grnno` = `gd`.`grnno`)) where `gd`.`itemcode` = `pd`.`itemcode` and `g`.`branchid` = `p`.`branchid`),0) AS `received` from (`purchaseorders` `p` join `purchaseorderdetails` `pd` on(`p`.`purchaseorderid` = `pd`.`purchaseorderid`)) where `pd`.`quanity` > ifnull((select sum(`gd`.`quantity`) from (`goodsreceived` `g` join `goodsreceiveddetails` `gd` on(`g`.`grnno` = `gd`.`grnno`)) where `gd`.`itemcode` = `pd`.`itemcode` and `g`.`branchid` = `p`.`branchid`),0) */;

/*View structure for view vwopenpayables */

/*!50001 DROP TABLE IF EXISTS `vwopenpayables` */;
/*!50001 DROP VIEW IF EXISTS `vwopenpayables` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwopenpayables` AS select `si`.`branchid` AS `branchid`,`si`.`supplierid` AS `supplierid`,`si`.`invoiceno` AS `invoiceno`,`si`.`invoicedate` AS `invoicedate`,`si`.`status` AS `status`,sum(`sid`.`quantity` * `sid`.`unitprice`) AS `invoiceamount`,ifnull((select sum(`pd`.`quantity` * `pd`.`unitprice`) from (`paymentvouchers` `p` join `paymentvoucherdetails` `pd` on(`p`.`paymentvoucherid` = `pd`.`voucherid`)) where `pd`.`invoicenumber` = `si`.`invoiceno` and `p`.`branchid` = `si`.`branchid`),0) AS `settled` from (`supplierinvoice` `si` join `supplierinvoicedetails` `sid` on(`si`.`supplierinvoiceid` = `sid`.`invoiceid`)) where cast(`si`.`invoicedate` as date) >= (select cast(`startingparameters`.`cutoffdate` as date) from `startingparameters` limit 1) group by `si`.`branchid`,`si`.`supplierid`,`si`.`invoiceno`,`si`.`invoicedate`,`si`.`status` having sum(`sid`.`quantity` * `sid`.`unitprice`) > ifnull((select sum(`pd`.`quantity` * `pd`.`unitprice`) from (`paymentvouchers` `p` join `paymentvoucherdetails` `pd` on(`p`.`paymentvoucherid` = `pd`.`voucherid`)) where `pd`.`invoicenumber` = `si`.`invoiceno` and `p`.`branchid` = `si`.`branchid`),0) */;

/*View structure for view vwpaymentvouchers */

/*!50001 DROP TABLE IF EXISTS `vwpaymentvouchers` */;
/*!50001 DROP VIEW IF EXISTS `vwpaymentvouchers` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwpaymentvouchers` AS select `p`.`paymentvoucherid` AS `voucherid`,`p`.`branchid` AS `branchid`,ifnull(`p`.`pettycashvoucher`,0) AS `pettycashvoucher`,`p`.`voucherno` AS `voucherno`,date_format(`p`.`date`,'%Y-%m-%d') AS `voucherdate`,`p`.`paymentmode` AS `paymentmodeid`,`m`.`description` AS `paymentmodedescription`,`p`.`pos` AS `posid`,`o`.`posname` AS `posname`,`p`.`supplier` AS `supplierid`,`s`.`suppliername` AS `suppliername`,`pd`.`invoicenumber` AS `invoicenumber`,`p`.`cashbookaccount` AS `cashbookaccountid`,`a`.`accountcode` AS `accountcode`,`a`.`accountname` AS `accountname`,`p`.`referenceno` AS `referenceno`,`p`.`status` AS `status`,sum(`pd`.`quantity` * `pd`.`unitprice`) AS `vouchertotal`,`p`.`addedby` AS `userid`,concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `username` from ((((((`paymentvouchers` `p` join `paymentvoucherdetails` `pd` on(`p`.`paymentvoucherid` = `pd`.`voucherid`)) join `suppliers` `s` on(`p`.`supplier` = `s`.`supplierid`)) join `paymentmethods` `m` on(`p`.`paymentmode` = `m`.`id`)) join `pointsofsale` `o` on(`p`.`pos` = `o`.`posid`)) join `glaccounts` `a` on(`p`.`cashbookaccount` = `a`.`id`)) join `user` `u` on(`p`.`addedby` = `u`.`userid`)) group by `p`.`paymentvoucherid`,`p`.`branchid`,`p`.`pettycashvoucher`,`p`.`voucherno`,`p`.`date`,`p`.`paymentmode`,`m`.`description`,`p`.`pos`,`o`.`posname`,`p`.`supplier`,`s`.`suppliername`,`pd`.`invoicenumber`,`p`.`cashbookaccount`,`a`.`accountcode`,`a`.`accountname`,`p`.`referenceno`,`p`.`status`,`p`.`addedby`,`u`.`firstname`,`u`.`middlename`,`u`.`lastname` */;

/*View structure for view vwpointofsaleitembalances */

/*!50001 DROP TABLE IF EXISTS `vwpointofsaleitembalances` */;
/*!50001 DROP VIEW IF EXISTS `vwpointofsaleitembalances` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwpointofsaleitembalances` AS select `s`.`posid` AS `posid`,`s`.`posname` AS `posname`,`td`.`itemcode` AS `itemid`,`p`.`itemcode` AS `itemcode`,`p`.`itemname` AS `itemname`,`p`.`unitofmeasure` AS `unitofmeasure`,`p`.`buyingprice` AS `buyingprice`,ifnull(sum(if(`t`.`destinationid` = `s`.`posid` and `t`.`destinationtype` = 'pos' and `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) AS `unitsreceived`,ifnull(sum(if(`t`.`sourceid` = `s`.`posid` and `t`.`sourcetype` = 'pos' and `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) AS `issued` from (((`pointsofsale` `s` join `stocktransfer` `t` on(`s`.`posid` = `t`.`sourceid` or `s`.`posid` = `t`.`destinationid`)) join `stocktransferdetails` `td` on(`t`.`stocktransferid` = `td`.`transferid`)) join `products` `p` on(`td`.`itemcode` = `p`.`productid`)) where `t`.`dateadded` >= ifnull((select `startingparameters`.`cutoffdate` from `startingparameters` limit 1),current_timestamp()) group by `s`.`posid`,`s`.`posname`,`td`.`itemcode`,`p`.`itemcode`,`p`.`itemname`,`p`.`unitofmeasure`,`p`.`buyingprice` */;

/*View structure for view vwsalessummary */

/*!50001 DROP TABLE IF EXISTS `vwsalessummary` */;
/*!50001 DROP VIEW IF EXISTS `vwsalessummary` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwsalessummary` AS select date_format(`p`.`receiptdate`,'%Y-%m-%d') AS `transactiondate`,`pm`.`id` AS `id`,`p`.`receiptno` AS `receiptno`,`m`.`description` AS `paymentmode`,`pm`.`reference` AS `paymentmodereference`,`s`.`posname` AS `pointofsale`,`p`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`p`.`addedby` AS `userid`,`pm`.`amount` AS `receipttotal`,`p`.`pointofsaleid` AS `posid`,ifnull(`pm`.`banked`,0) AS `banked`,concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `userfullname`,`u`.`username` AS `username`,`s`.`clientid` AS `clientid`,`p`.`branchid` AS `branchid` from ((((((`pointsofsale` `s` join `possales` `p` on(`p`.`pointofsaleid` = `s`.`posid`)) join `possalesdetails` `pd` on(`p`.`possaleid` = `pd`.`possaleid`)) join `user` `u` on(`p`.`addedby` = `u`.`userid`)) join `customers` `c` on(`p`.`customerid` = `c`.`customerid`)) join `paymentmethods` `m` on(`m`.`clientid` = `s`.`clientid`)) join `possalespayments` `pm` on(`p`.`possaleid` = `pm`.`possaleid` and `pm`.`paymentmode` = `m`.`id`)) where ifnull(`p`.`deleted`,0) = 0 group by `p`.`receiptdate`,`p`.`receiptno`,`u`.`username`,`u`.`userid`,`s`.`posname`,`p`.`customerid`,`c`.`customername`,`p`.`addedby`,`m`.`description`,`pm`.`reference`,`pm`.`id`,`p`.`pointofsaleid`,`pm`.`banked`,`u`.`firstname`,`u`.`middlename`,`u`.`lastname`,`s`.`clientid`,`p`.`branchid` */;

/*View structure for view vwsalessummary2 */

/*!50001 DROP TABLE IF EXISTS `vwsalessummary2` */;
/*!50001 DROP VIEW IF EXISTS `vwsalessummary2` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwsalessummary2` AS select `p`.`branchid` AS `branchid`,`p`.`timestamp` AS `transactiondate`,`pm`.`id` AS `id`,`p`.`receiptno` AS `receiptno`,`m`.`description` AS `paymentmode`,`pm`.`reference` AS `paymentmodereference`,`s`.`posname` AS `pointofsale`,`p`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`p`.`addedby` AS `userid`,`pm`.`amount` AS `receipttotal`,sum(`pd`.`quantity`) AS `quantity`,`p`.`pointofsaleid` AS `posid`,coalesce(`pm`.`banked`,0) AS `banked`,`u`.`firstname` AS `userfullname`,`u`.`username` AS `username` from ((((((`pointsofsale` `s` join `possales` `p` on(`p`.`pointofsaleid` = `s`.`posid`)) join `possalesdetails` `pd` on(`p`.`possaleid` = `pd`.`possaleid`)) join `user` `u` on(`p`.`addedby` = `u`.`userid`)) join `customers` `c` on(`p`.`customerid` = `c`.`customerid`)) join `possalespayments` `pm` on(`p`.`possaleid` = `pm`.`possaleid`)) join `paymentmethods` `m` on(`pm`.`paymentmode` = `m`.`id`)) where coalesce(`p`.`deleted`,0) = 0 group by `p`.`branchid`,`p`.`receiptdate`,`p`.`receiptno`,`u`.`username`,`u`.`userid`,`s`.`posname`,`p`.`customerid`,`c`.`customername`,`p`.`addedby`,`m`.`description`,`pm`.`reference`,`pm`.`id`,`p`.`pointofsaleid`,`pm`.`banked`,`u`.`firstname` */;

/*View structure for view vwstockcenters */

/*!50001 DROP TABLE IF EXISTS `vwstockcenters` */;
/*!50001 DROP VIEW IF EXISTS `vwstockcenters` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwstockcenters` AS select `pointsofsale`.`posname` AS `posname` from `pointsofsale` union select `warehouses`.`description` AS `description` from `warehouses` */;

/*View structure for view vwstockdetails */

/*!50001 DROP TABLE IF EXISTS `vwstockdetails` */;
/*!50001 DROP VIEW IF EXISTS `vwstockdetails` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwstockdetails` AS select date_format(`p`.`receiptdate`,'%d-%b-%Y') AS `date`,`s`.`posname` AS `posname`,`m`.`itemcode` AS `itemcode`,`m`.`itemname` AS `itemname`,`m`.`unitofmeasure` AS `unitofmeasure`,`m`.`buyingprice` AS `buyingprice`,avg(`pd`.`unitprice`) AS `sellingprice`,0 AS `purchases`,sum(`pd`.`quantity`) AS `quantitysold`,ifnull((select sum(`std`.`quantity`) from (`stocktransfer` `st` join `stocktransferdetails` `std` on(`st`.`stocktransferid` = `std`.`transferid`)) where `std`.`itemcode` = `pd`.`itemcode` and `st`.`sourcetype` = 'pos' and `st`.`sourceid` = `s`.`posid` and date_format(`st`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`receiptdate`,'%d-%b-%Y')),0) AS `transfersout`,ifnull((select sum(`std`.`quantity`) from (`stocktransfer` `st` join `stocktransferdetails` `std` on(`st`.`stocktransferid` = `std`.`transferid`)) where `std`.`itemcode` = `pd`.`itemcode` and `st`.`destinationtype` = 'pos' and `st`.`destinationid` = `s`.`posid` and date_format(`st`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`receiptdate`,'%d-%b-%Y')),0) AS `transfersin` from (((`products` `m` join `possalesdetails` `pd` on(`m`.`productid` = `pd`.`itemcode`)) join `possales` `p` on(`p`.`possaleid` = `pd`.`possaleid`)) join `pointsofsale` `s` on(`p`.`pointofsaleid` = `s`.`posid`)) group by date_format(`p`.`receiptdate`,'%d-%b-%Y'),`s`.`posname`,`m`.`itemcode`,`m`.`itemname`,`m`.`unitofmeasure`,`m`.`buyingprice` union all select date_format(`p`.`datereceived`,'%d-%b-%Y') AS `date`,`s`.`description` AS `posname`,`m`.`itemcode` AS `itemcode`,`m`.`itemname` AS `itemname`,`m`.`unitofmeasure` AS `unitofmeasure`,ifnull((select avg(`xd`.`unitprice`) from (`purchaseorders` `x` join `purchaseorderdetails` `xd` on(`x`.`purchaseorderid` = `xd`.`purchaseorderid`)) where `x`.`purchaseorderno` = `pd`.`purchaseorderno`),0) AS `buyingprice`,`m`.`sellingprice` AS `sellingprice`,sum(`pd`.`quantity`) AS `purchases`,0 AS `quantitysold`,ifnull((select sum(`std`.`quantity`) from (`stocktransfer` `st` join `stocktransferdetails` `std` on(`st`.`stocktransferid` = `std`.`transferid`)) where `std`.`itemcode` = `pd`.`itemcode` and `st`.`sourcetype` = 'warehouse' and `st`.`sourceid` = `s`.`id` and date_format(`st`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`datereceived`,'%d-%b-%Y')),0) AS `transfersout`,ifnull((select sum(`std`.`quantity`) from (`stocktransfer` `st` join `stocktransferdetails` `std` on(`st`.`stocktransferid` = `std`.`transferid`)) where `std`.`itemcode` = `pd`.`itemcode` and `st`.`destinationtype` = 'warehouse' and `st`.`destinationid` = `s`.`id` and date_format(`st`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`datereceived`,'%d-%b-%Y')),0) AS `transfersin` from (((`products` `m` join `goodsreceiveddetails` `pd` on(`m`.`productid` = `pd`.`itemcode`)) join `goodsreceived` `p` on(`p`.`grnno` = `pd`.`grnno`)) join `warehouses` `s` on(`p`.`warehouseid` = `s`.`id`)) group by date_format(`p`.`datereceived`,'%d-%b-%Y'),`s`.`description`,`m`.`itemcode`,`m`.`itemname`,`m`.`unitofmeasure`,`m`.`buyingprice`,`m`.`sellingprice`,`pd`.`purchaseorderno` */;

/*View structure for view vwstocktransfers */

/*!50001 DROP TABLE IF EXISTS `vwstocktransfers` */;
/*!50001 DROP VIEW IF EXISTS `vwstocktransfers` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwstocktransfers` AS select `t`.`referenceno` AS `referenceno`,`t`.`sourcetype` AS `sourcetype`,`t`.`sourceid` AS `sourceid`,case when `t`.`sourcetype` = 'warehouse' then (select `warehouses`.`description` from `warehouses` where `warehouses`.`id` = `t`.`sourceid`) else (select `pointsofsale`.`posname` from `pointsofsale` where `pointsofsale`.`posid` = `t`.`sourceid`) end AS `sourcename`,`t`.`destinationtype` AS `destinationtype`,`t`.`destinationid` AS `destinationid`,case when `t`.`destinationtype` = 'warehouse' then (select `warehouses`.`description` from `warehouses` where `warehouses`.`id` = `t`.`destinationid`) else (select `pointsofsale`.`posname` from `pointsofsale` where `pointsofsale`.`posid` = `t`.`destinationid`) end AS `destinationame`,`t`.`addedby` AS `addedby`,`t`.`dateadded` AS `dateadded`,concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `username`,ifnull(concat(`i`.`firstname`,' ',`i`.`middlename`,' ',`i`.`lastname`),'_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _') AS `issuedto`,ifnull(concat(`c`.`firstname`,' ',`c`.`middlename`,' ',`c`.`lastname`),'_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _') AS `storecontroller` from (((`stocktransfer` `t` join `user` `u` on(`t`.`addedby` = `u`.`userid`)) left join `user` `i` on(`i`.`userid` = `t`.`issuedto`)) left join `user` `c` on(`c`.`userid` = `t`.`storecontroller`)) order by `t`.`dateadded` */;

/*View structure for view vwstores */

/*!50001 DROP TABLE IF EXISTS `vwstores` */;
/*!50001 DROP VIEW IF EXISTS `vwstores` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwstores` AS select `pointsofsale`.`posname` AS `posname` from `pointsofsale` where ifnull(`pointsofsale`.`deleted`,0) = 0 union select `warehouses`.`description` AS `description` from `warehouses` */;

/*View structure for view vwsupplierstatement */

/*!50001 DROP TABLE IF EXISTS `vwsupplierstatement` */;
/*!50001 DROP VIEW IF EXISTS `vwsupplierstatement` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwsupplierstatement` AS select `s`.`clientid` AS `clientid`,`s`.`supplierid` AS `supplierid`,`s`.`suppliername` AS `suppliername`,`s`.`physicaladdress` AS `physicaladdress`,`s`.`postaladdress` AS `postaladdress`,`s`.`mobile` AS `mobile`,`s`.`email` AS `email`,`si`.`invoicedate` AS `invoicedate`,`si`.`invoiceno` AS `reference`,'Invoice received' AS `narrative`,sum(`sid`.`quantity` * `sid`.`unitprice`) AS `invoiceamount`,0 AS `invoicepayment`,0 AS `order` from ((`suppliers` `s` join `supplierinvoice` `si` on(`s`.`supplierid` = `si`.`supplierid` and `s`.`clientid` = `si`.`clientid`)) join `supplierinvoicedetails` `sid` on(`si`.`supplierinvoiceid` = `sid`.`invoiceid` and `si`.`clientid` = `sid`.`clientid`)) where `si`.`status` <> 'Cancelled' group by `s`.`clientid`,`s`.`supplierid`,`s`.`suppliername`,`s`.`physicaladdress`,`s`.`postaladdress`,`s`.`mobile`,`s`.`email`,`si`.`invoicedate`,`si`.`invoiceno` union all select `s`.`clientid` AS `clientid`,`s`.`supplierid` AS `supplierid`,`s`.`suppliername` AS `suppliername`,`s`.`physicaladdress` AS `physicaladdress`,`s`.`postaladdress` AS `postaladdress`,`s`.`mobile` AS `mobile`,`s`.`email` AS `email`,`p`.`date` AS `invoicedate`,`p`.`voucherno` AS `reference`,concat('Payment issued via reference #',`p`.`referenceno`) AS `narrative`,0 AS `invoiceamount`,sum(`pd`.`quantity` * `pd`.`unitprice`) AS `invoicepayment`,1 AS `order` from ((`suppliers` `s` join `paymentvouchers` `p` on(`s`.`supplierid` = `p`.`supplier` and `s`.`clientid` = `p`.`clientid`)) join `paymentvoucherdetails` `pd` on(`p`.`paymentvoucherid` = `pd`.`voucherid` and `p`.`clientid` = `pd`.`clientid`)) where `p`.`status` <> 'Cancelled' group by `s`.`clientid`,`s`.`supplierid`,`s`.`suppliername`,`s`.`physicaladdress`,`s`.`postaladdress`,`s`.`mobile`,`s`.`email`,`p`.`date`,`p`.`voucherno`,`p`.`referenceno` */;

/*View structure for view vwwarehouseitembalances */

/*!50001 DROP TABLE IF EXISTS `vwwarehouseitembalances` */;
/*!50001 DROP VIEW IF EXISTS `vwwarehouseitembalances` */;

/*!50001 CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vwwarehouseitembalances` AS select `w`.`id` AS `warehouseid`,`w`.`description` AS `warehousename`,`p`.`itemcode` AS `itemcode`,`p`.`itemname` AS `itemname`,`p`.`productid` AS `productid`,`p`.`unitofmeasure` AS `unitofmeasure`,`p`.`buyingprice` AS `buyingprice`,`p`.`sellingprice` AS `sellingprice`,`p`.`serializable` AS `serializable`,sum(`gd`.`quantity`) + ifnull((select sum(`std`.`quantity`) from (`stocktransferdetails` `std` join `stocktransfer` `st` on(`st`.`stocktransferid` = `std`.`transferid`)) where `st`.`destinationtype` = 'warehouse' and `st`.`destinationid` = `w`.`id` and `std`.`itemcode` = `p`.`productid` and `st`.`dateadded` >= ifnull((select `startingparameters`.`cutoffdate` from `startingparameters` limit 1),current_timestamp())),0) AS `unitsreceived`,ifnull((select sum(`std`.`quantity`) from (`stocktransferdetails` `std` join `stocktransfer` `st` on(`st`.`stocktransferid` = `std`.`transferid`)) where `st`.`sourcetype` = 'warehouse' and `st`.`sourceid` = `w`.`id` and `std`.`itemcode` = `p`.`productid` and `st`.`dateadded` >= ifnull((select `startingparameters`.`cutoffdate` from `startingparameters` limit 1),current_timestamp())),0) AS `issued` from (((`goodsreceived` `g` join `goodsreceiveddetails` `gd` on(`g`.`grnno` = `gd`.`grnno`)) join `products` `p` on(`gd`.`itemcode` = `p`.`productid`)) join `warehouses` `w` on(`w`.`id` = `g`.`warehouseid`)) group by `p`.`itemcode`,`p`.`itemname`,`p`.`unitofmeasure`,`p`.`buyingprice`,`p`.`sellingprice`,`p`.`serializable`,`w`.`id`,`w`.`description`,`p`.`productid` */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
