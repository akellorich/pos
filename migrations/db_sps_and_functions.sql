/*
SQLyog Enterprise v13.1.1 (64 bit)
MySQL - 10.4.27-MariaDB : Database - distributor
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngeneratecreditnoteno`() RETURNS varchar(50) CHARSET latin1
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngeneratecustomercreditrefno`() RETURNS varchar(50) CHARSET latin1
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

/* Function  structure for function  `fngenerategrnno` */

/*!50003 DROP FUNCTION IF EXISTS `fngenerategrnno` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngenerategrnno`() RETURNS varchar(50) CHARSET latin1
BEGIN
	declare $grnno varchar(50);
	SET $grnno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Goods Received Note');
	RETURN $grnno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratepaymentvoucherno` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratepaymentvoucherno` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngeneratepaymentvoucherno`() RETURNS varchar(50) CHARSET latin1
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngenerateproductcode`($categoryid numeric) RETURNS varchar(50) CHARSET latin1
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
		`currentno`) FROM `categories` WHERE `categoryid`=$categoryid);
	RETURN $itemcode;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratepurchaseorderno` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratepurchaseorderno` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngeneratepurchaseorderno`() RETURNS varchar(50) CHARSET latin1
BEGIN
	DECLARE $purchaseorderno VARCHAR(50);
	SET $purchaseorderno=(SELECT CONCAT(
		`prefix`,
		CASE CHAR_LENGTH(`currentno`) 
			WHEN 1 THEN '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			ELSE '' 
		END,
		`currentno`) FROM `serials` WHERE `documenttype`='Purchase Order');
	RETURN $purchaseorderno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneraterawmaterialcode` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneraterawmaterialcode` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngeneraterawmaterialcode`($categoryid numeric) RETURNS varchar(50) CHARSET latin1
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngeneratereceiptno`() RETURNS varchar(50) CHARSET latin1
BEGIN
	declare $receiptno varchar(50);
	set $receiptno=(select concat(
		`prefix`,
		case CHAR_LENGTH(`currentno`) 
			when 1 then '0000'
			WHEN 2 THEN '000'
			WHEN 3 THEN '00'
			WHEN 4 THEN '0'
			else '' 
		end,
		`currentno`) FROM `serials` where `documenttype`='Receipt');
	return $receiptno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngeneratereturninwardsref` */

/*!50003 DROP FUNCTION IF EXISTS `fngeneratereturninwardsref` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngeneratereturninwardsref`() RETURNS varchar(50) CHARSET latin1
BEGIN
	declare $grnno varchar(50);
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngeneratereturnoutwardsref`() RETURNS varchar(50) CHARSET latin1
BEGIN
	declare $grnno varchar(50);
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngeneratestocktransaferno`() RETURNS varchar(50) CHARSET latin1
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
		`currentno`) FROM `serials` WHERE `documenttype`='Stock Transfer');
	RETURN $stocktransferno;
    END */$$
DELIMITER ;

/* Function  structure for function  `fngetsupplieropeningbalance` */

/*!50003 DROP FUNCTION IF EXISTS `fngetsupplieropeningbalance` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fngetsupplieropeningbalance`($supplierid int,$startdate datetime) RETURNS decimal(18,2)
BEGIN
	declare $openingbalance numeric(18,2);
	declare $cutoffdate datetime;
	
	set $cutoffdate=date_format(ifnull((select `cutoffdate` from `startingparameters`),now()),'%Y-%m-%d');
	if $cutoffdate>$startdate then
		set $startdate=$cutoffdate;
	end if;
	set $startdate=date_sub($startdate, interval 1 day);
	set $openingbalance=(SELECT SUM(invoiceamount-invoicepayment) FROM `vwsupplierstatement` o 
	WHERE o.supplierid=$supplierid AND DATE_FORMAT(invoicedate,'%Y-%m-%d') between $cutoffdate and $startdate);
	return ifnull($openingbalance,0);
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_generatecustomerorderno` */

/*!50003 DROP FUNCTION IF EXISTS `fn_generatecustomerorderno` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_generatecustomerorderno`() RETURNS varchar(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
	declare $orderno varchar(50);
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_generatequoatationno`() RETURNS varchar(50) CHARSET utf8mb4
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_generaterequisitionno`() RETURNS varchar(50) CHARSET utf8mb4
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_generatesalesvoucherno`() RETURNS varchar(100) CHARSET latin1 COLLATE latin1_swedish_ci
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_getcustomersuspenseaccountbalance`($customerid int) RETURNS decimal(18,2)
BEGIN
	declare $accountbalance numeric(18,2);
	set $accountbalance=(select sum(ifnull(credit,0)-ifnull(debit,0)) from customersuspenseaccount where customerid=$customerid);
	return $accountbalance;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getgrntotal` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getgrntotal` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_getgrntotal`($grnno varchar(50)) RETURNS decimal(18,2)
BEGIN
    
	declare $total decimal(18,2);
	
	SELECT SUM(gd.quantity*unitprice) into $total
	FROM `goodsreceiveddetails` gd
	JOIN `purchaseorders` p ON p.`purchaseorderno`=gd.`purchaseorderno`
	JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid`=p.`id`
	WHERE `grnno`=$grnno;
	return ifnull($total,0);
	
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getitemstockbalance` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getitemstockbalance` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_getitemstockbalance`($productid INT,$asatdate DATE) RETURNS decimal(18,2)
BEGIN
	DECLARE $closingbalance NUMERIC(18,2);
	SELECT  cutoffdate INTO @startdate FROM `startingparameters`;
	SELECT CASE WHEN @startdate>@asatdate THEN @startdate ELSE @asatdate END INTO @asatdate;
	SET $closingbalance=IFNULL((SELECT SUM(`quantity`) FROM `goodsreceiveddetails` gd, `goodsreceived` g WHERE g.`grnno`=gd.`grnno` AND `itemcode`=$productid
	AND DATE_FORMAT(`datereceived`,'%Y-%m-%d') BETWEEN @startdate AND $asatdate),0) -
	-- Subtract the items sold
	IFNULL((SELECT SUM(`quantity`) FROM `possalesdetails` pd, `possales` p WHERE p.`id`=pd.`id` AND pd.`itemcode`=$productid 
	AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN @startdate AND $asatdate AND IFNULL(p.`deleted`,0)=0),0);
	RETURN $closingbalance;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getitemstorebalance` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getitemstorebalance` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_getitemstorebalance`($productid INT,$storeid int) RETURNS decimal(18,0)
BEGIN
		DECLARE $startdate DATE;
		DECLARE $enddate DATE;
		
		SELECT date(IFNULL(`stockcutoffdate`,'2001-01-01')),DATE(NOW())
		INTO $startdate,$enddate 
		FROM `startingparameters`;
		
		-- select reconciled balance 
		SELECT sum(`quantity`) INTO @reconciledstock
		FROM `stockreconciledbalancedetails` rd
		JOIN `stockreconciledbalance` r ON r.`id`=rd.`reconciliationid`
		WHERE `itemid`=$productid AND DATE(`reconciliationdate`) BETWEEN $startdate AND $enddate
		and posid=$storeid;
		
		SELECT SUM(quantity)
		INTO @transfersin
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE s.id=sd.`transferid` AND `destinationtype`='pos' AND `destinationid`=$storeid AND sd.`itemcode`=$productid
		AND DATE(s.`dateadded`) BETWEEN $startdate AND $enddate;
		
		SELECT SUM(quantity)
		INTO @transfersout
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE s.id=sd.`transferid` AND `sourcetype`='pos' AND `sourceid`=$storeid  AND sd.`itemcode`=$productid
		AND DATE(s.`dateadded`) BETWEEN $startdate AND $enddate;
		
		-- get sales
		SELECT SUM(quantity) 
		INTO @sales
		FROM `possalesdetails` pd
		JOIN `possales` p ON p.`id`=pd.`possaleid`
		WHERE itemcode=$productid AND DATE(`receiptdate`) BETWEEN $startdate AND $enddate 
		AND `pointofsaleid`=$storeid AND p.`deleted`=0;
	
	set @itembalance=ifnull(@transfersin,0)+ifnull(@reconciledstock,0)-ifnull(@transfersout,0)-ifnull(@sales,0);
	
	return @itembalance;
	
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getitemstorebalanceasat` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getitemstorebalanceasat` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_getitemstorebalanceasat`($productid INT,$storeid INT,$asat date) RETURNS decimal(18,2)
BEGIN
	DECLARE $startdate DATE;
		DECLARE $enddate DATE;
		
		SELECT DATE(IFNULL(`stockcutoffdate`,'2001-01-01')),$asat,
		date_add($asat, interval -1 day)
		INTO $startdate,$enddate,@basedate
		FROM `startingparameters`;
		
		-- select reconciled balance 
		SELECT SUM(`quantity`) INTO @reconciledstock
		FROM `stockreconciledbalancedetails` rd
		JOIN `stockreconciledbalance` r ON r.`id`=rd.`reconciliationid`
		WHERE `itemid`=$productid AND DATE(`reconciliationdate`) BETWEEN $startdate AND $enddate
		AND posid=$storeid;
		
		SELECT SUM(quantity)
		INTO @transfersin
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE s.id=sd.`transferid` AND `destinationtype`='pos' AND `destinationid`=$storeid AND sd.`itemcode`=$productid
		AND DATE(s.`dateadded`) BETWEEN $startdate AND @basedate;
		
		SELECT SUM(quantity)
		INTO @transfersout
		FROM `stocktransfer` s, `stocktransferdetails` sd
		WHERE s.id=sd.`transferid` AND `sourcetype`='pos' AND `sourceid`=$storeid  AND sd.`itemcode`=$productid
		AND DATE(s.`dateadded`) BETWEEN $startdate AND @basedate;
		
		-- get sales
		SELECT SUM(quantity) 
		INTO @sales
		FROM `possalesdetails` pd
		JOIN `possales` p ON p.`id`=pd.`possaleid`
		WHERE itemcode=$productid AND DATE(`receiptdate`) BETWEEN $startdate AND @basedate 
		AND `pointofsaleid`=$storeid AND p.`deleted`=0;
	
		SET @itembalance=IFNULL(@transfersin,0)+IFNULL(@reconciledstock,0)-IFNULL(@transfersout,0)-IFNULL(@sales,0);
	
		RETURN @itembalance;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getproductaverageprice` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getproductaverageprice` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_getproductaverageprice`($productid int,$startdate date,$enddate date) RETURNS decimal(18,4)
BEGIN
	declare $averageprice int;
	select IFNULL((SELECT AVG(`unitprice`) FROM `purchaseorderdetails` od, `purchaseorders` o 
			WHERE o.id=od.`purchaseorderid` AND DATE_FORMAT(o.`date`,'%Y-%m-%d') BETWEEN $startdate AND $enddate),
	(SELECT AVG(`unitprice`) FROM `purchaseorderdetails` od, `purchaseorders` o 
		WHERE o.id=od.`purchaseorderid` AND DATE_FORMAT(o.`date`,'%Y-%m-%d') <= $enddate)) 
	into $averageprice;
	return $averageprice;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_getwarehousestockbalance` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getwarehousestockbalance` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_getwarehousestockbalance`($productid int,$warehouseid int,$enddate date) RETURNS decimal(18,2)
BEGIN
	DECLARE $startdate DATE;
	-- DECLARE $enddate DATE;
	declare $purchases decimal(18,2);
	declare $transfersout decimal(18,2);
	declare $transfersin decimal(18,2);
	declare $reconciledstock decimal(18,2);
	
	SELECT DATE(IFNULL(`stockcutoffdate`,'2001-01-01'))
	INTO $startdate
	FROM `startingparameters`;
	
	-- Get ware houses receipts
	select sum(quantity) into $purchases 
	from `goodsreceived` g
	join `goodsreceiveddetails` gd on gd.`grnno`=g.`grnno` and `warehouseid`=$warehouseid and `itemcode`=$productid
	and date(`datereceived`) between $startdate and $enddate;
	
	-- Get Transfers out
	select sum(`quantity`) into $transfersout 
	from `stocktransfer` t 
	join `stocktransferdetails` td on td.`transferid`=t.`id`
	where `sourcetype`='warehouse' and `sourceid`=$warehouseid and 
	`itemcode`=$productid and `dateadded` between $startdate and $enddate;
	
	-- Get transfers In
	SELECT SUM(`quantity`) INTO $transfersin
	FROM `stocktransfer` t 
	JOIN `stocktransferdetails` td ON td.`transferid`=t.`id`
	WHERE `destinationtype`='warehouse' AND `destinationid`=$warehouseid AND 
	`itemcode`=$productid AND `dateadded` BETWEEN $startdate AND $enddate;
	
	-- Get reconciledstock
	select sum(`quantity`) into $reconciledstock
	from `stockreconciledbalance` s join `stockreconciledbalancedetails` sb on sb.`reconciliationid`=s.`id`
	where `itemid`=$productid and `category`='warehouse' and `posid`=$warehouseid and `reconciliationdate`
	between $startdate and $enddate;
	
	return ifnull($purchases,0)-ifnull($transfersout,0)+ifnull($transfersin,0)+ifnull($reconciledstock,0);
	
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_purchaseorderstatus` */

/*!50003 DROP FUNCTION IF EXISTS `fn_purchaseorderstatus` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_purchaseorderstatus`($purchaseorderid int) RETURNS varchar(50) CHARSET latin1
BEGIN
    
	DECLARE $approvallevelid INT;
	DECLARE $approvallevelname VARCHAR(100);
	DECLARE $purchaseorderstatus VARCHAR(50);
	DECLARE $finished INTEGER DEFAULT 0;
	
	DECLARE c1 CURSOR FOR SELECT `id`,`description` FROM `purchaseorderapprovallevels` ORDER BY `hierarchy`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET $finished=1;
	OPEN c1;
	
	SET $purchaseorderstatus='Approved';
	
	if exists(select * from `purchaseorders` where `id`=$purchaseorderid and ifnull(`rejected`,0)=1) then
		set $purchaseorderstatus='Rejected';
	else
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
	end if;
	
	RETURN $purchaseorderstatus;
	
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_receiptpaymentmodereferencenos` */

/*!50003 DROP FUNCTION IF EXISTS `fn_receiptpaymentmodereferencenos` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_receiptpaymentmodereferencenos`($receiptno varchar(50)) RETURNS varchar(4000) CHARSET latin1
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
	 
	 get_paymentmethods: LOOP
	 
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_receiptpaymentmodes`($receiptno varchar(50)) RETURNS varchar(4000) CHARSET latin1
BEGIN
	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE payment_mode VARCHAR(100) DEFAULT "";
	declare payment_modes varchar(4000) DEFAULT "";
	 -- declare cursor for employee email
	 DECLARE payment_modes_cursor CURSOR FOR 
	 SELECT `description` from `paymentmethods` p, `possalespayments` s, `possales` d  where p.`id`=s.`paymentmode`and d.`id`=s.`possaleid`  
	 and `receiptno`=$receiptno order by `description`;
	 
	 -- declare NOT FOUND handler
	 DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET v_finished = 1;
	 
	 OPEN payment_modes_cursor;
	 
	 get_paymentmethods: LOOP
	 
	 FETCH payment_modes_cursor INTO payment_mode;
	 
	 IF v_finished = 1 THEN 
	 LEAVE get_paymentmethods;
	 END IF;
	 
	 -- build payment mode list
	 if payment_modes='' then 
		SET payment_modes = payment_mode;
	 else
		SET payment_modes = CONCAT(payment_modes,",",payment_mode);
	 end if ;
	 
	 
	 END LOOP get_paymentmethods;
	 
	 CLOSE payment_modes_cursor;
	 return payment_modes;
    END */$$
DELIMITER ;

/* Function  structure for function  `fn_warehousestockbalanceasat` */

/*!50003 DROP FUNCTION IF EXISTS `fn_warehousestockbalanceasat` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `fn_warehousestockbalanceasat`($productid int,$warehouseid int,$enddate date) RETURNS decimal(18,2)
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` FUNCTION `spgeneratecustomerreceiptno`() RETURNS varchar(50) CHARSET latin1
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
		`currentno`) FROM `serials` WHERE `documenttype`='Customer Receipt');
	RETURN $receiptno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `emaillist` */

/*!50003 DROP PROCEDURE IF EXISTS  `emaillist` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `emaillist`()
BEGIN
	DECLARE finished int default 0;
	DECLARE emails_list varchar(500) default "";
	DECLARE email varchar(50) default "";
	DECLARE user_data CURSOR FOR SELECT email from customers limit 5;
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `import_data`()
begin	
	declare $suppliername varchar(250);
	declare $itemname varchar(250);
	declare $itemcode varchar(50);
	declare $categoryid varchar(50);
	declare $productcode varchar(50);
	declare $finished integer default 0;
	declare $tp datetime;
	declare $prefix varchar(3);
	declare c1 cursor for select suppliername,itemname from welbay_products;
	declare continue handler for NOT FOUND set $finished=1;
	SET $tp=NOW();
		
	open c1;
	get_product: LOOP
		fetch c1 into $suppliername,$itemname;		
		if $finished=1 then 
			leave get_product;
		end if;
		set $prefix=LEFT($suppliername,3);
		
		-- create category if not exists
		if not exists( SELECT `categoryname` FROM `categories` WHERE `categoryname`=$suppliername) then 
		
			INSERT INTO `categories`(`categoryname`,`dateadded`,`addedby`,`deleted`,`prefix`,`currentno`)
			VALUES($suppliername,$tp,1,0,$prefix,1) ;
		end if;
		
		-- Insert supplier 
		if not exists(select `suppliername` from `suppliers` where `suppliername`=$uppliername) THEN
			insert into `suppliers`(`suppliername`,`physicaladdress`,`postaladdress`,`creditlimit`,`mobile`,`email`,`dateadded`,`addedby`,`deleted`)
			values($suppliername,'','',0,'','',now(),1,0);
		end if;
		
		SET $categoryid=(select `categoryid` FROM `categories` WHERE `categoryname`=$suppliername); 
		
		-- generate product code
		set $productcode=`fngenerateproductcode`($categoryid);
		-- save the product
		insert into `products`(`itemcode`,`itemname`,`unitofmeasure`,`buyingprice`,`sellingprice`,`categoryid`,`dateadded`,`addedby`,`deleted`,`reorderlevel`)
		values($productcode,$itemname,'Rims',0,0,$categoryid,now(),1,0,10);
		-- Update product code
		update `categories` set `currentno`=`currentno`+1 where `categoryid`=$categoryid;
	END LOOP get_product;
	close c1;
end */$$
DELIMITER ;

/* Procedure structure for procedure `import_data_campari` */

/*!50003 DROP PROCEDURE IF EXISTS  `import_data_campari` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `import_data_campari`()
begin	
	declare $suppliername varchar(250);
	declare $itemname varchar(250);
	declare $itemcode varchar(50);
	declare $categoryid varchar(50);
	declare $productcode varchar(50);
	declare $finished integer default 0;
	declare $tp datetime;
	declare $prefix varchar(3);
	declare $bp decimal(10,0);
	declare $wp decimal(10,0);
	declare $sp decimal(10,0);
	declare c1 cursor for select upper(`Category`),itemname,`BP`,`RP`,`WP` from `campari_products`;
	declare continue handler for NOT FOUND set $finished=1;
	SET $tp=NOW();
		
	open c1;
	get_product: LOOP
		fetch c1 into $suppliername,$itemname,$bp,$sp,$wp;		
		if $finished=1 then 
			leave get_product;
		end if;
		set $prefix=LEFT($suppliername,3);
		
		-- create category if not exists
		if not exists( SELECT `categoryname` FROM `categories` WHERE `categoryname`=$suppliername) then 
		
			INSERT INTO `categories`(`categoryname`,`dateadded`,`addedby`,`deleted`,`prefix`,`currentno`)
			VALUES($suppliername,$tp,1,0,$prefix,1) ;
		end if;
		
		
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `import_payables`()
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	declare $supplierid int;
	declare $amount numeric(18,2);
	declare $pono varchar(50);
	declare $poid int;
	declare $podate datetime default '2020-06-01';
	declare $userid int default 5;
	declare $itemcode int;
	declare $grnno varchar(50);
	declare $warehouseid int default 1;
	declare $invoiceid int;
	-- declare cursor for employee email
	
		DEClARE curPayable 
			CURSOR FOR 
				SELECT `supplierid`,`amount` FROM `loyalty_payables`;
		-- declare NOT FOUND handler
		DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finished = 1;
		
		-- get balance item code
		set $itemcode=(select `productid` from  `products` WHERE `itemname`='Balance as at 01-Jun-2020');
		
		OPEN curPayable;
		getEmail: LOOP
			START TRANSACTION;
				FETCH curPayable INTO $supplierid,$amount;
				IF finished = 1 THEN 
					LEAVE getEmail;
				END IF;
				-- make purchase order
				-- generate pono
				set $pono=`fngeneratepurchaseorderno`();
				
				insert into `purchaseorders`(`purchaseorderno`,`date`,`supplierid`,`expecteddate`,`status`,`terms`,`addedby`)
				values($pono,$podate,$supplierid,$podate,'Pending','',$userid);
				
				set $poid=(select max(`id`) from `purchaseorders`);
				
				insert into `purchaseorderdetails`(`purchaseorderid`,`itemcode`,`quanity`,`unitprice`)
				values($poid,$itemcode,1,$amount);
				-- receive the items
				set $grnno=`fngenerategrnno`();
				
				insert into `goodsreceived`(`warehouseid`,`grnno`,`datereceived`,`supplierid`,`deliverynono`)
				values($warehouseid,$grnno,$podate,$supplierid,$grnno);
				
				insert into `goodsreceiveddetails`(`grnno`,`itemcode`,`purchaseorderno`,`quantity`)
				values($grnno,$itemcode,$pono,1);
				
				-- generate the invoice
				insert into `supplierinvoice`(`supplierid`,`invoiceno`,`invoicedate`,`addedby`,`dateadded`)
				values($supplierid,'BALBF01JUN2020',$podate,$userid,$podate);
				
				set $invoiceid=(select max(`id`) from `supplierinvoice`);
				
				insert into `supplierinvoicedetails`(`invoiceid`,`referenceno`,`itemcode`,`description`,`quantity`,`unitprice`)
				values($invoiceid,$grnno,$itemcode,'Opening Balance as at 01-Jun-2020',1,$amount);
				
				-- Increment PONO and GRN No
				update serials set currentno=currentno+1 where `documenttype` in('Goods Received Note','Purchase Order');
			commit; 
		END LOOP getEmail;
		CLOSE curPayable;       
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `import_receivables` */

/*!50003 DROP PROCEDURE IF EXISTS  `import_receivables` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `import_receivables`()
BEGIN
	declare $customerid integer;
	declare $amount numeric(18,2);
	declare $finished integer;
	declare $receiptno varchar(50);
	declare $userid int default 5;
	declare $posid int default 14;
	declare $id int;
	declare $productid int;
	declare $categoryid int default 29;
	declare $paymentmode int default 4;
	
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
		set $receiptno=`fngeneratereceiptno`();
		-- Add the POS sale
		insert into `possales`(`receiptno`,`receiptdate`,`customerid`,`pointofsaleid`,`addedby`)
		values($receiptno,'2020-06-01',$customerid,$posid,$userid);
		
		set $id=(select max(`id`) from `possales`);
		
		insert into `possalesdetails`(`possaleid`,`itemcode`,`quantity`,`unitprice`,`discount`)
		values($id,$productid,1,$amount,0);
		
		-- Add sale as credit
		insert into `possalespayments`(`possaleid`,`paymentmode`,`reference`,`amount`,`banked`,`bankingreference`)
		values($id,$paymentmode,$receiptno,$amount,1,$receiptno);
		
		-- Increment receipt number
		update `serials` set `currentno`=`currentno`+1 where `documenttype`='Receipt';
		
	END LOOP getCustomer;
	CLOSE curCustomer;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `savetemppurchaseorderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `savetemppurchaseorderdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `savetemppurchaseorderdetails`($refno varchar(50),$itemcode varchar(50),$quantity numeric,$unitprice numeric)
BEGIN
	DECLARE $itemid INT;
	SET $itemid=(SELECT `productid` FROM `products` WHERE `itemcode`=$itemcode);
	insert into `temppurchaseorder` (`refno`,`itemcode`,`quantity`,`unitprice`)
	values($refno,$itemid,$quantity,$unitprice);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spapprovepaymentvoucher` */

/*!50003 DROP PROCEDURE IF EXISTS  `spapprovepaymentvoucher` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spapprovepaymentvoucher`($id int,$userid int)
BEGIN
	declare $cashbookaccount int;
	start transaction;
		
		set $cashbookaccount=(select `cashbookaccount` from `paymentvouchers` where `id`=$id);
		-- update payment voucher status
		update `paymentvouchers` set `status`='Approved', `lastmodifiedby`=$userid, `lastmodifieddate`=now() where `id`=$id;
		-- insert the transaction into the GL
		-- begin with vrediting the cashbook account
		insert into `gltransactions` (`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		select `referenceno`,  v.dateadded,`cashbookaccount`,null,concat('Payment of voucher #',`voucherno`),0,sum(quantity*unitprice),$userid
		from `paymentvouchers` v, `paymentvoucherdetails` vd where v.`id`=vd.`voucherid` and v.`id`=$id;
		-- post the debit entries
		insert into `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		select `referenceno`, v.dateadded,`accountcharged`,$cashbookaccount,`description`,quantity*unitprice,0,$userid
		FROM `paymentvouchers` v, `paymentvoucherdetails` vd WHERE v.`id`=vd.`voucherid` AND v.`id`=$id;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spapprovepurchaseorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `spapprovepurchaseorder` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spapprovepurchaseorder`($id numeric,$userid numeric)
BEGIN
	update `purchaseorders` set `status`='Approved', `lastmodifiedon`=now(),`lastmodifiedby`=$userid where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcancelpaymentvoucher` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcancelpaymentvoucher` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcancelpaymentvoucher`($id int,$reason varchar(500),$userid int)
BEGIN
	update `paymentvouchers` set `status`='Cancelled', `reasoncancelled`=$reason, `lastmodifiedby`=$userid, `lastmodifieddate`=now()
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcancelpossale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcancelpossale` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcancelpossale`($receiptno varchar(50),$userid int,$reason varchar(100))
BEGIN
	update `possales` set `deleted`=1, `deletedon`=now(), `deletedby`=$userid, reason=$reason where `receiptno`=$receiptno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcancelpurchaseorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcancelpurchaseorder` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcancelpurchaseorder`($id numeric,$userid numeric,$reason varchar(100))
BEGIN
	update `purchaseorders` set `status`='Cancelled', `reasoncancelled`=$reason, `lastmodifiedon`=now(),`lastmodifiedby`=$userid
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spchangeuserpassword` */

/*!50003 DROP PROCEDURE IF EXISTS  `spchangeuserpassword` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spchangeuserpassword`($id numeric, $userpassword varchar(100), $changepasswordonlogon bit)
BEGIN
	update `user` 
	set `password`=$userpassword, `changepasswordonlogon`=$changepasswordonlogon 
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckcategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckcategory` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckcategory`($categoryid numeric,$checkfield varchar(50),$checkvalue varchar(50))
BEGIN
	if $checkfield='categoryname' then 
		select * from `categories` where `categoryid`<>$categoryid and `categoryname`=$checkvalue;
	elseif $checkfield='prefix' then 
		SELECT * FROM `categories` WHERE `categoryid`<>$categoryid AND `prefix`=$checkvalue;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckcrateadditionreference` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckcrateadditionreference` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckcrateadditionreference`($reference varchar(50))
BEGIN
	select * from `cratesinventory` where `reference`=$reference;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckcustomerdocuments` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckcustomerdocuments` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckcustomerdocuments`($id int,$document varchar(50),$docno varchar(50))
BEGIN
	if $document='pin' then
		select * from `customers` where `customerid`<>$id and `pinno`=$docno;
	elseif $document='id' then
		select * from `customers` where `customerid`<>$id and `idno`=$docno;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckcustomername` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckcustomername` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckcustomername`($customerid numeric,$customername varchar(50))
BEGIN
	select * from `customers` where `customerid`<>$customerid and `customername`=$customername;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckglaccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckglaccount` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckglaccount`($id int,$searchvariable varchar(50))
BEGIN
	select * from `glaccounts` 
	where `id`<>$id and (`accountcode`=$searchvariable or `accountname`=$searchvariable);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckglaccountgroup` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckglaccountgroup` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckglaccountgroup`($id int , $groupname varchar(50))
BEGIN
	select * from `glaccountgroups` where `id`<>$id and `groupname`=$groupname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckjournalrefereceno` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckjournalrefereceno` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckjournalrefereceno`($referenceno varchar(50))
BEGIN
	select * from `journals` where `referenceno`=$referenceno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckmpesatransactioncode` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckmpesatransactioncode` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckmpesatransactioncode`($refno varchar(50))
BEGIN
	select * from `mpesaconfirmation` where `reference`=$refno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckpaymentmodereference` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckpaymentmodereference` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckpaymentmodereference`($paymentmodeid int, $reference varchar(50))
BEGIN
	set @checkreference=(select `requiresref` from `paymentmethods` where `id`=$paymentmodeid);
	
	if @checkreference=1 then
		select * from `customerpayments` where `paymentmethodid`=$paymentmodeid and `reference`=$reference;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckpaymentvoucherno` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckpaymentvoucherno` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckpaymentvoucherno`($branchid int, $id int,$voucherno varchar(50))
BEGIN
	SELECT * FROM `paymentvouchers` WHERE `branchid` = $branchid AND `paymentvoucherid`<>$id AND `voucherno`=$voucherno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckposname` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckposname` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckposname`($id numeric, $posname varchar(50))
BEGIN
	select * from `pointsofsale` where `id`<>$id and `posname`=$posname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckproduct` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckproduct`($id numeric, $valuetocheck varchar(50),$category varchar(50))
BEGIN
	if $category='code' then
		select * from `products` where `productid`<>`$id` and `itemcode`=$valuetocheck;
	else
		select * from `products` WHERE `productid`<>$id and `itemname`=$valuetocheck;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckreferenceno` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckreferenceno` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckreferenceno`($paymentmode numeric,$referenceno varchar(50))
BEGIN
	select * FROM `possalespayments` where `paymentmode`=$paymentmode and `reference`=$referenceno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckrole` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckrole` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckrole`($roleid int,$rolename varchar(50))
BEGIN
	select * 
	from `roles` 
	where `roleid`<>$roleid and `rolename`=$rolename;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spchecksupplierdeliverynotenumber` */

/*!50003 DROP PROCEDURE IF EXISTS  `spchecksupplierdeliverynotenumber` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spchecksupplierdeliverynotenumber`($supplierid numeric,$dnoteno varchar(50))
BEGIN
	select * from `goodsreceived` where `supplierid`=$supplierid and `deliverynono`=$dnoteno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spchecksuppliername` */

/*!50003 DROP PROCEDURE IF EXISTS  `spchecksuppliername` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spchecksuppliername`($supplierid numeric,$suppliername varchar(50))
BEGIN
	select * from `suppliers` where `supplierid`<>$supplierid and `suppliername`=$suppliername;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spcheckuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `spcheckuser` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spcheckuser`($userid int,$checkfield varchar(50),$checkvalue varchar(50))
BEGIN
	if $checkfield='username' then 
		select * from `user` where `id`<>$userid and `username`=$checkvalue;
	elseif $checkfield='email' then 
		select * from `user` where `id`<>$userid AND `email`=$checkvalue;
	elseif $checkfield='mobile' then 
		SELECT * FROM `user` WHERE `id`<>$userid AND `mobile`=$checkvalue;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletecategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletecategory` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeletecategory`($categoryid numeric,$userid numeric)
BEGIN
	update `categories` set `deleted`=1, `lastmodifiedby`=$userid, `lastmodifiedon`=now() where `categoryid`=$categoryid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletecustomer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletecustomer` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeletecustomer`($customerid numeric,$userid numeric)
BEGIN
	update `customers` set `deleted`=1,`lastdatemodified`=now(),`lastmodifiedby`=$userid where `customerid`=$customerid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletecustomerdiscount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletecustomerdiscount` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeletecustomerdiscount`($id numeric,$userid int)
BEGIN
	update `customerdiscountsettings` set `deleted`=1, `lastmodifiedby`=$userid, `lastmodifiedon`=now()
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteglaccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteglaccount` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeleteglaccount`($id int,$userid int)
BEGIN
	update `glaccounts` set `deleted`=1, `lastdateupdated`=now(), `lastupdatedby`=$userid where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteglgroup` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteglgroup` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeleteglgroup`($id int,$userid int)
BEGIN
	update `glaccountgroups` set `deleted`=1,`lastupdatedby`=$userid,`lastdateupdated`=now() where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteheldsale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteheldsale` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeleteheldsale`($id int)
BEGIN
	start transaction;
		delete from `heldsalesdetails` where `heldsaleid`=$id;
		delete from `heldsales` where `id`=$id;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteoutlet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteoutlet` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeleteoutlet`($id int,$userid int)
BEGIN
	update `useroutlets` set deleted=1, `lastdatemodified`=now(),`lastmodifiedby`=$userid
	where id=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletepos` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletepos` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeletepos`($posid numeric,$userid numeric)
BEGIN
	update `pointsofsale` set `deleted`=1, `lastdatemodified`=now(), `lastmodifiedby`=$userid where `id`=$posid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteproduct` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeleteproduct`($productid numeric,$userid numeric)
BEGIN
	update `products` set `deleted`=1, `lastmodifiedon`=now(),`lastmodifiedby`=$userid where `productid`=$productid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleterole` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleterole` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeleterole`($roleid int,$userid int)
BEGIN
	update `roles` 
	set `deleted`=1, `deletedby`=$userid, `lastdatemodified`=now(), `lastmodifiedby`=$userid
	where `roleid`=$roleid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletesupplier` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletesupplier` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeletesupplier`($supplierid numeric,$userid numeric)
BEGIN
	update `suppliers` set `deleted`=1, `lastdatemodified`=now(),`lastmodifiedby`=$userid where `supplierid`=$supplierid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeletesupplierproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeletesupplierproduct` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeletesupplierproduct`($id int,$userid int)
BEGIN
	update `supplierproducts` set `deleted`=1, `lastmodifiedby`=$userid, `lastmodifieddate`=now()
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdeleteuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdeleteuser` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdeleteuser`($id int,$userid int)
BEGIN
	update `user` set `accountactive`=0,`lastmodifiedon`=now(),`lastmodifiedby`=$userid, `reasoninactive`='Account deleted'
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spdisableuseraccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spdisableuseraccount` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spdisableuseraccount`($id int,$reason varchar(500),$userid int)
BEGIN
	update `user` set `accountactive`=0,`reasoninactive`=$reason,`lastmodifiedby`=$userid,`lastmodifiedon`=now()
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spenableuseraccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spenableuseraccount` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spenableuseraccount`($id int,$userid int)
BEGIN
	update `user` set `accountactive`=1, `lastmodifiedon`=now(),`lastmodifiedby`=$userid
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spfilterproductsalesbymonth` */

/*!50003 DROP PROCEDURE IF EXISTS  `spfilterproductsalesbymonth` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spfilterproductsalesbymonth`($startdate varchar(50),$enddate varchar(50),$productname varchar(50))
BEGIN
	-- declare sql_dynamic varchar(5000);
	-- declare $sql_full varchar(7000);
	set session group_concat_max_len = 2048;
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
	FROM `pointsofsale` where `deleted`=0);
	-- SELECT  @sql_dynamic ;
	SET @sql=CONCAT('SELECT * FROM (SELECT m.`itemcode`,`itemname`,format(`unitprice`-`discount`,2) as `Unit Price`,',	
		@sql_dynamic,', SUM(quantity) as `Total Qty`, format(SUM(quantity*(`unitprice`-`discount`)),2) as `Total Value` 
		FROM `possales` p, `possalesdetails` pd, `pointsofsale` s, `products` m
		WHERE p.`id`=pd.`possaleid` AND p.`pointofsaleid`=s.`id` AND pd.`itemcode`=m.`productid` AND DATE_FORMAT(`p`.`receiptdate`,''%Y-%m-%d'') BETWEEN ''' ,$startdate,''' AND ''',$enddate,'''
		AND `itemname` LIKE ''%',$productname,'%'' AND IFNULL(p.`deleted`,0)=0 GROUP BY  m.`itemcode`,`Unit Price`,`itemname`  ORDER BY `itemname`) as a
		UNION	
		SELECT ''TOTAL'','''',FORMAT(AVG(`unitprice`),2),',@sql_dynamic,', SUM(quantity) as `Total Qty`,format(SUM(quantity*(`unitprice`-`discount`)),2) as `Total Value` 
		FROM `possales` p, `possalesdetails` pd, `pointsofsale` s, `products` m
		WHERE p.`id`=pd.`possaleid` AND p.`pointofsaleid`=s.`id` AND pd.`itemcode`=m.`productid` AND DATE_FORMAT(`p`.`receiptdate`,''%Y-%m-%d'') BETWEEN ''' ,$startdate,''' AND ''',$enddate,'''
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spfilterproductsbyname`($searchvalue varchar(50),$posid int)
BEGIN
	if $posid=0 then 
		select p.*, c.`categoryname`, concat(`firstname`,' ',`middlename`,' ',`lastname`)as addedbyname ,sellingprice-
		ifnull((select case when `percentage`=1 then (`value`/100)*`sellingprice`  else `value` end FROM `customerpricematrix` cs
				WHERE cs.`customercategoryid`=2 AND cs.`itemid`=p.`productid`),0) wholesaleprice
		from `products` p, `categories` c, `user` u
		where c.`categoryid`=p.`categoryid` and u.id=p.addedby and `itemname` like concat( '%',$searchvalue,'%') and p.deleted=0
		order by `itemname`;
	else
		SELECT p.*, c.`categoryname`, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`)AS addedbyname ,sellingprice-
		IFNULL((SELECT CASE WHEN `percentage`=1 THEN (`value`/100)*`sellingprice`  ELSE `value` END FROM `customerpricematrix` cs
				WHERE cs.`customercategoryid`=2 AND cs.`itemid`=p.`productid`),0) wholesaleprice
		FROM `products` p, `categories` c, `user` u
		WHERE c.`categoryid`=p.`categoryid` AND u.id=p.addedby AND `itemname` LIKE CONCAT( '%',$searchvalue,'%') AND p.deleted=0
		and c.categoryid in(select `productcategoryid` from`posproductcategories` where `posid`=$posid and `deleted`=0)
		ORDER BY `itemname`;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spfilterquotations` */

/*!50003 DROP PROCEDURE IF EXISTS  `spfilterquotations` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spfilterquotations`($customerid int,$startdate date,$enddate date,$quotestatus varchar(50))
BEGIN
	if $customerid=0 then
		if $quotestatus='All' then
			select q.*, c.`customername`, sum(quantity*unitprice) as `quotetotal`, DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotationdate
			from `quotation` q, `quotationdetails` qd,`customers`c
			where q.`id`=qd.`quoteid` and q.`customerid`=c.`customerid` and date_format(`quotedate`,'%Y-%m-%d') between $startdate and $enddate
			group by `quoteno`
			order by `quoteno` desc;
		else
			SELECT q.*, c.`customername`, SUM(quantity*unitprice) AS `quotetotal` , DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotationdate
			FROM `quotation` q, `quotationdetails` qd,`customers`c
			WHERE q.`id`=qd.`quoteid` AND q.`customerid`=c.`customerid` AND DATE_FORMAT(`quotedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			and `status`=$quotestatus	
			group by `quoteno`	
			ORDER BY `quoteno` DESC;
		end if;
	else
		IF $quotestatus='All' THEN
			SELECT q.*, c.`customername`, SUM(quantity*unitprice) AS `quotetotal` , DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotationdate
			FROM `quotation` q, `quotationdetails` qd,`customers`c
			WHERE q.`id`=qd.`quoteid` AND q.`customerid`=c.`customerid` AND DATE_FORMAT(`quotedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			and c.customerid=$customerid
			group by `quoteno`
			ORDER BY `quoteno` DESC;
		ELSE
			SELECT q.*, c.`customername`, SUM(quantity*unitprice) AS `quotetotal`, DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotationdate 
			FROM `quotation` q, `quotationdetails` qd,`customers`c
			WHERE q.`id`=qd.`quoteid` AND q.`customerid`=c.`customerid` AND DATE_FORMAT(`quotedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND `status`=$quotestatus AND c.customerid=$customerid	
			group by `quoteno`
			ORDER BY `quoteno` DESC;
		END IF;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spfilterstocktransfer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spfilterstocktransfer` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spfilterstocktransfer`($source varchar(50),$sourceid int,$destination varchar(50),$destinationid int,$startdate datetime,$enddate datetime)
BEGIN
	if $source='all' then
		if $destination='all' then
			select * FROM vwstocktransfers where  `dateadded` between $startdate and $enddate
			order by dateadded;
		elseif $destination='outlet' then
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			AND destinationid=$destinationid and destinationtype='pos' 
			ORDER BY dateadded;
		else
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			and destinationid=$destinationid and destinationtype='warehouse'
			ORDER BY dateadded;
		end if;
	else
		IF $destination='all' THEN
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			and sourceid=$sourceid
			ORDER BY dateadded;
		ELSEif $destination='outlet' then 
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			AND sourceid=$sourceid AND destinationid=$destinationid AND destinationtype='pos'
			ORDER BY dateadded;
		else
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			and sourceid=$sourceid AND destinationid=$destinationid and destinationtype='warehouse'
			ORDER BY dateadded;
		END IF;
	end if;
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetallusers`()
BEGIN
	select u.*, ifnull(concat(a.firstname,' ',a.middlename,' ',a.lastname),'System') as addedbyname 
	from `user` u  left OUTER join `user` a on u.addedby=a.id -- where u.`accountactive`=1 
	order by u.`firstname`,u.`middlename`,u.`lastname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetavailableproductserialnumbers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetavailableproductserialnumbers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetavailableproductserialnumbers`($itemid int)
BEGIN
	select `serialno` from `goodsreceiveddetails` g
	where `serialno` not in(select `serialno` from `possalesdetails` where `itemcode`=$itemid)
	and `itemcode`=$itemid
	order by `serialno`;
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetbestcustomer`($startdate datetime,$enddate datetime)
BEGIN
	select customername, sum(receipttotal) total 
	from `vwsalessummary`
	where  DATE_FORMAT(`transactiondate`,'%Y-%m-%d')  between $startdate and $enddate
	group by customername
	order by SUM(receipttotal) desc 
	LIMIt 5;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbestpos` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbestpos` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetbestpos`($startdate datetime,$enddate datetime)
BEGIN
	select pointofsale, sum(receipttotal) as total 
	from `vwsalessummary` 
	where transactiondate between $startdate and $enddate
	group by pointofsale
	order by sum(receipttotal) desc
	limit 5;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbestproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbestproduct` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetbestproduct`($startdate datetime,$enddate datetime)
BEGIN
	select p.`itemcode`,`itemname`, sum(quantity) sold from `products` p, `possales` s, `possalesdetails` sd
	where `productid`=sd.itemcode and s.`id`=sd.`possaleid` and DATE_FORMAT(`receiptdate`,'%Y-%m-%d')  between $startdate and $enddate
	group by p.`itemcode`,`itemname`
	order by SUM(quantity) desc
	LIMIt 5;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbestsellingcategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbestsellingcategory` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetbestsellingcategory`($startdate datetime,$enddate datetime)
BEGIN
	SELECT `categoryname`,SUM(s.`quantity`) quantity,AVG(s.`unitprice`) unitprice
	FROM `categories` c,`products` p,`possales` o,`possalesdetails` s
	WHERE c.`categoryid`=p.`categoryid` AND p.`productid`=s.`itemcode` AND s.`possaleid`=o.id
	AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	GROUP BY `categoryname`
	ORDER BY SUM(quantity) DESC 
	LIMIT 5;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbestsellingproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbestsellingproducts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetbestsellingproducts`($startdate datetime,$enddate datetime,$userid int)
BEGIN
	if $userid=0 then
		SELECT `categoryname`,`itemname`,SUM(s.`quantity`) quantity,AVG(s.`unitprice`) unitprice
		FROM `categories` c,`products` p,`possales` o,`possalesdetails` s
		WHERE c.`categoryid`=p.`categoryid` AND p.`productid`=s.`itemcode` AND s.`possaleid`=o.id
		AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY `categoryname`,`itemname`
		ORDER BY SUM(quantity) DESC 
		LIMIT 5;
	else
		SELECT `categoryname`,`itemname`,SUM(s.`quantity`) quantity,AVG(s.`unitprice`) unitprice
		FROM `categories` c,`products` p,`possales` o,`possalesdetails` s
		WHERE c.`categoryid`=p.`categoryid` AND p.`productid`=s.`itemcode` AND s.`possaleid`=o.id
		AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and o.addedby=$userid
		GROUP BY `categoryname`,`itemname`
		ORDER BY SUM(quantity) DESC 
		LIMIT 5;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetbundleitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetbundleitems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetbundleitems`()
BEGIN
	select * from products where bundleitem=1 and ifnull(deleted,0)=0
	order by `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcashbookaccounts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcashbookaccounts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcashbookaccounts`()
BEGIN
	select g.`id`,`accountcode`,`accountname`, `groupname` from `glaccounts` g, `glaccountgroups` p
	where p.`id`=g.`groupid` and p.`cashbookaccount`=1 order by `accountname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcategories` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcategories`()
BEGIN
	select c.*,concat(firstname,' ',middlename,' ' ,lastname) addedbyname from `categories` c, `user` u where u.id=c.addedby
	order by `categoryname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcategorydetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcategorydetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcategorydetails`($id int)
BEGIN
	select * from `categories` where `categoryid`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcrateadditionparameters` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcrateadditionparameters` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcrateadditionparameters`()
BEGIN
	select p.*,(select `buyingprice` from `products` where productid=p.productid) as price
	from `cratesinventorysettings` p;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcrateinventorysettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcrateinventorysettings` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcrateinventorysettings`()
BEGIN
	select s.*,ifnull((select `buyingprice` from `products` where productid=s.productid),0) as price
	from `cratesinventorysettings` s;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcreditnotevalue` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcreditnotevalue` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcreditnotevalue`($creditnotenumber varchar(50))
BEGIN
	select `noteno`,`dateadded`,sum(`quantity`*`unitprice`) as creditnotetotal
	from `creditnotes` c, `creditnotedetails` cd
	where c.`id`=cd.`noteid` and `noteno`=$creditnotenumber;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomeraginganalysis` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomeraginganalysis` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomeraginganalysis`($customerid int,$basedate datetime)
BEGIN
	SET @basedate=$basedate,@customerid=$customerid;
	
	select `cutoffdate` into @cutoffdate from `startingparameters`;
	set @cutoffdate=ifnull(@cutoffdate,'2022-01-01');
	
	SELECT 
		
		SUM(IF(`range`='thirty',`balance`,0)) AS `thirty` ,
		SUM(IF(`range`='sixty',`balance`,0)) AS `sixty` ,
		SUM(IF(`range`='ninety',`balance`,0)) AS `ninety` ,
		SUM(IF(`range`='onetwenty',`balance`,0)) AS `onetwenty` ,
		SUM(IF(`range`='aboveonetwenty',`balance`,0)) AS `aboveonetwenty`,
		SUM(`balance`) AS `total`
	FROM(
	SELECT c.`customerid`, p.id,c.`customername`,
	CASE 
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d'))<=30 THEN 'thirty' 
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d')) BETWEEN 31 AND 60 THEN 'sixty'
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d')) BETWEEN 61 AND 90 THEN 'ninety'
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d')) BETWEEN 91 AND 120 THEN 'onetwenty'
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d'))>120 THEN 'aboveonetwenty' 
	END `range`,
	pp.amount -
	IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`id`),0) /**/ AS balance
	FROM `possales` p, `possalesdetails` pd, `possalespayments` pp, `customers` c
	WHERE p.`id`=pd.`possaleid` AND pp.`possaleid`=p.`id` AND pp.`paymentmode`=4  AND c.`customerid`=p.`customerid` AND p.`customerid`=$customerid  
	AND  pp.amount - IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`id`),0)>0
	-- Filter by date from the cut off date
	AND DATE_FORMAT(p.`receiptdate`,'%Y-%m-%d')>=@cutoffdate
	GROUP BY c.`customerid`,p.id,c.`customername`) AS tab1;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomercategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomercategories` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomercategories`()
BEGIN
	select * from `customercategories` order by `description`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomercreditnotes` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomercreditnotes` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomercreditnotes`($customerid numeric)
BEGIN
	select `noteno` as creditnotenumber from `creditnotes` where `customerid`=$customerid and `used`=0
	order by `noteno`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomerdetails`($customerid numeric)
BEGIN
	select c.* ,(select `parent` from `zones` where `id`=`subzoneid`) mainzone
	from `customers` c
	where `customerid`=$customerid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerdiscountsettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerdiscountsettings` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomerdiscountsettings`($customerid int)
BEGIN
	select c.`id`,`itemcode`,`itemname`,`sellingprice`, `discount`,`percentage`,`expirydate` from `products` p, `customerdiscountsettings` c
	where c.`productid`=p.`productid` and `customerid`=$customerid and c.`deleted`=0 order by `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomeropenreceivables` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomeropenreceivables` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomeropenreceivables`($customerid int)
BEGIN
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	SELECT p.`id`,`customerid`,`receiptdate` AS transactiondate, SUM(`quantity`*(`unitprice`-ifnull(discount,0))) AS total,IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails`
	WHERE `possaleid`=p.`id`),0) AS paid,SUM(`quantity`*(`unitprice`-IFNULL(discount,0))) -
	IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`id`),0) AS balance
	FROM `possales` p, `possalesdetails` pd, `possalespayments` pp
	WHERE p.`id`=pd.`possaleid` and pp.`possaleid`=p.`id` AND pp.`paymentmode`=4 and p.`customerid`=$customerid  
	and date_format(`receiptdate`,'%Y-%m-%d')>=@cutoffdate
	GROUP BY p.`id`,`customerid`,`receiptdate`
	having SUM(`quantity`*(`unitprice`-IFNULL(discount,0))) - IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`id`),0) >0
	ORDER BY `receiptdate`, p.`id`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerreceiptdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerreceiptdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomerreceiptdetails`($receiptno varchar(50))
BEGIN
	SELECT c.`customerid` , `customername`, `receiptno`,`receiptdate`,
	p.`description` AS paymentmode, `referenceno`, CONCAT(`firstname`,' ',`middlename`,' ' ,`lastname`) servedby,
	CONCAT('Settlement of POS bill #' , `possaleid`) AS narration, `amount`
	FROM `customerreceipts` c, `customerreceiptdetails` cr, `paymentmethods` p, `user` u, `customers` m
	WHERE c.`id`=cr.`receiptid` AND c.`customerid`=m.customerid AND c.`addedby`=u.`id` AND c.`modeofpayment`=p.`id`
	AND c.`receiptno`=$receiptno
	
	UNION 
	
	SELECT c.`customerid` , `customername`, `receiptno`,`receiptdate`,
	p.`description` AS paymentmode, c.`referenceno`, CONCAT(`firstname`,`middlename`,`lastname`) servedby,
	'Customer amount overpaid'  AS narration, `credit` as amount
	FROM `customerreceipts` c, `customersuspenseaccount` cr, `paymentmethods` p, `user` u, `customers` m
	WHERE c.`receiptno`=cr.`referenceno` AND c.`customerid`=m.customerid AND c.`addedby`=u.`id` AND c.`modeofpayment`=p.`id`
	AND c.`receiptno`=$receiptno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomers`($posid int,$regular int,$onetime int)
BEGIN
	declare $defaultcustomer int;
	
	select `defaultcustomerid` into $defaultcustomer from `institution`;
	if $posid=0 then
		if $regular=1 then
			if $onetime=1 then
				select $defaultcustomer defaultcustomer,c.*,concat(`firstname`,' ',`middlename`,' ',`lastname`) as addedbyname , r.`description` as categoryname
				from `customers` c, `customercategories` r, `user` u where `deleted`=0  and r. `id`=c.`catid` and u.`id`=c.`addedby`  
				order by customername;
			else
				SELECT $defaultcustomer defaultcustomer,c.*,CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedbyname , r.`description` AS categoryname
				FROM `customers` c, `customercategories` r, `user` u WHERE `deleted`=0  AND r. `id`=c.`catid` AND u.`id`=c.`addedby` 
				and ifnull(`onetimecustomer`,0)=0
				ORDER BY customername;
			end if;
		else
			IF $onetime=1 THEN
				SELECT $defaultcustomer defaultcustomer,c.*,CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedbyname , r.`description` AS categoryname
				FROM `customers` c, `customercategories` r, `user` u WHERE `deleted`=0  AND r. `id`=c.`catid` AND u.`id`=c.`addedby`  
				AND IFNULL(`onetimecustomer`,0)=1
				ORDER BY customername;
			/*ELSE
				 Get no customers 
				 Since both regular and onetime hasnot been selected
			*/
			END IF;
		END IF;
	ELSE
		IF $regular=1 THEN
			IF $onetime=1 THEN
				SELECT $defaultcustomer defaultcustomer,c.*,CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedbyname , r.`description` AS categoryname
				FROM `customers` c, `customercategories` r, `user` u WHERE `deleted`=0  AND r. `id`=c.`catid` AND u.`id`=c.`addedby` 
				AND c.posid=$posid 
				ORDER BY customername;
			ELSE
				SELECT $defaultcustomer defaultcustomer,c.*,CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedbyname , r.`description` AS categoryname
				FROM `customers` c, `customercategories` r, `user` u WHERE `deleted`=0  AND r. `id`=c.`catid` AND u.`id`=c.`addedby` 
				AND IFNULL(`onetimecustomer`,0)=0 AND c.posid=$posid 
				ORDER BY customername;
			END IF;
		ELSE
			IF $onetime=1 THEN
				SELECT $defaultcustomer defaultcustomer,c.*,CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedbyname , r.`description` AS categoryname
				FROM `customers` c, `customercategories` r, `user` u WHERE `deleted`=0  AND r. `id`=c.`catid` AND u.`id`=c.`addedby`  
				AND IFNULL(`onetimecustomer`,0)=1 AND c.posid=$posid 
				ORDER BY customername;
			/*ELSE
				 Get no customers 
				 Since both regular and onetime hasnot been selected
			*/
			END IF;
		END IF;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerstatement` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerstatement` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomerstatement`($customerid int,$startdate datetime,$enddate datetime)
BEGIN
	SET @startdate=$startdate,@enddate=$enddate;
	SET @customerid=$customerid;
	
	select case when date_format(`cutoffdate`,'%Y-%m-%d')>@startdate then DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') else @startdate end
	into @startdate from `startingparameters`;
	
	select customerid,customername,physicaladdress,postaladdress,mobile,email, DATE_FORMAT(`date`,'%d-%b-%Y') `date`,`narration`,reference, invoiceamount,invoicepayment,
	ifnull((select sum(invoiceamount)-sum(invoicepayment) from vwcustomerstomerstatement v where v.customerid=s.customerid and  DATE_FORMAT(`date`,'%Y-%m-%d')<=@startdate),0) as `openingbalance`,
	ifnull((SELECT SUM(invoiceamount)-SUM(invoicepayment) FROM vwcustomerstomerstatement v WHERE v.customerid=s.customerid AND  DATE_FORMAT(`date`,'%Y-%m-%d')<=@enddate),0) AS `closingbalance`,
	IFNULL((SELECT SUM(invoiceamount) FROM vwcustomerstomerstatement v WHERE v.customerid=s.customerid AND  DATE_FORMAT(`date`,'%Y-%m-%d') between @startdate and @enddate),0) AS `invoices`,
	IFNULL((SELECT SUM(invoicepayment) FROM vwcustomerstomerstatement v WHERE v.customerid=s.customerid AND  DATE_FORMAT(`date`,'%Y-%m-%d') BETWEEN @startdate AND @enddate),0) AS `payments`
	
	from vwcustomerstomerstatement s
	where `customerid`=@customerid AND date_format(`date`,'%Y-%m-%d')  BETWEEN @startdate AND @enddate
	ORDER BY  DATE_FORMAT(`date`,'%Y-%m-%d'), `order`;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomerunbankedreceipts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomerunbankedreceipts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomerunbankedreceipts`($startdate datetime,$enddate datetime,$paymentmethod int)
BEGIN
	if $paymentmethod=0 then 
		select id,date_format(`date`,'%d-%b-%Y') as `date`, customername,posname,description,receiptno,reference,amount,addedby
		from vwcustomerreceipts where date between $startdate and $enddate and banked=0
		order by receiptno;
	else
		SELECT id,DATE_FORMAT(`date`,'%d-%b-%Y') AS `date`, customername,posname,description,receiptno,reference,amount,addedby
		FROM vwcustomerreceipts WHERE DATE BETWEEN $startdate AND $enddate AND banked=0 and paymentmodeid=$paymentmethod
		ORDER BY receiptno;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetcustomesuspenseaccountstatement` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetcustomesuspenseaccountstatement` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetcustomesuspenseaccountstatement`($customerid int,$startdate date,$enddate date)
BEGIN
	select date_format($startdate,'%d-%b-%Y') `date`,''  `referenceno`,'Opening balance' `narration`,
	case when sum(ifnull(credit,0)-ifnull(debit,0))>0 then credit else 0 end credit, 
	CASE WHEN SUM(IFNULL(credit,0)-IFNULL(debit,0))<0 THEN credit ELSE 0 END debit,'' as addedby
	FROM `customersuspenseaccount` where  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') < $startdate and  `customerid`=$customerid
	
	union
	
	select * from (select date_format(`transactiondate`,'%d-%b-%Y') `date`,`referenceno`,`narration`,`credit`,`debit`, concat(`firstname`,' ',`lastname`) addedby
	from `customersuspenseaccount` c, `user` u
	where c.`addedby`=u.`id` and date_format(`transactiondate`,'%Y-%m-%d') between $startdate and $enddate and c.`customerid`=$customerid
	order by `transactiondate`, `referenceno`) as a;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetdashboardheaders` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetdashboardheaders` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetdashboardheaders`( $summarydate DATETIME)
BEGIN
	DECLARE $activecustomers NUMERIC(18,2);
	DECLARE $openreceivables NUMERIC(18,2);
	DECLARE $openpayables NUMERIC(18,2);
	DECLARE $openorders NUMERIC(18,2);
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	
	SET $activecustomers=IFNULL((SELECT COUNT(DISTINCT customername) FROM `vwsalessummary2` WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d')=$summarydate),0);
	SET $openreceivables=IFNULL((SELECT COUNT(*) FROM `possales` p, `possalesdetails` pd, `possalespayments` pp, `customers` c
		WHERE p.`id`=pd.`possaleid` AND pp.`possaleid`=p.`id` AND pp.`paymentmode`=4  AND c.`customerid`=p.`customerid` 
		AND  pp.amount - IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`id`),0)>0 and date_format(`receiptdate`,'%Y-%m-%d')>@cutoffdate),0);
	SET $openpayables=IFNULL((SELECT COUNT(*) FROM vwopenpayables),0);
	SET $openorders=ifnull((SELECT COUNT(*) FROM `purchaseorders` p,`purchaseorderdetails` pd WHERE p.`id`=pd.`purchaseorderid`
			AND quanity>IFNULL((SELECT SUM(quantity) FROM `goodsreceived` g, `goodsreceiveddetails` gd WHERE g.`grnno`=gd.`grnno` AND gd.`itemcode`=pd.`itemcode`),0)
			AND DATE_FORMAT(p.`date`,'%Y-%m-%d')>=@cutoffdate),0);
	SELECT $activecustomers AS activecustomers,$openreceivables openreceivables,$openpayables  openpayables,$openorders openorders;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetdashboardsummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetdashboardsummary` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetdashboardsummary`($startdate datetime,$enddate datetime)
BEGIN
	DECLARE $totalsales NUMERIC(18,2) DEFAULT 0;
	DECLARE $margin NUMERIC(18,2) DEFAULT 0;
	DECLARE $topstorevalue NUMERIC(18,2) DEFAULT 0;
	DECLARE $topstorename VARCHAR(100)DEFAULT '';
	DECLARE $averagesale NUMERIC(18,2) DEFAULT 0;
    
	set $totalsales=(select sum(receipttotal) from `vwsalessummary` where transactiondate between $startdate and $enddate);
	set $margin=$totalsales - (SELECT sum(buyingprice*quantity)
		FROM `products` m, `possales` p, `possalesdetails` pd WHERE m.`productid`=pd.`itemcode` AND pd.`possaleid`=p.`id` 
		AND DATE_FORMAT(p.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate);
	set $topstorevalue=(select sum(receipttotal) from `vwsalessummary` WHERE transactiondate BETWEEN $startdate AND $enddate group by pointofsale order by sum(receipttotal) desc LIMIT 1);
	set $topstorename=(SELECT pointofsale FROM `vwsalessummary` WHERE transactiondate BETWEEN $startdate AND $enddate GROUP BY pointofsale ORDER BY SUM(receipttotal) DESC LIMIT 1);
	set $averagesale=(SELECT AVG(receipttotal) FROM `vwsalessummary` WHERE transactiondate BETWEEN $startdate AND $enddate);
	
	select ifnull($totalsales,0) as totalsales,ifnull($margin,0) as margin, ifnull($topstorevalue,0) as topstorevalue,ifnull($topstorename,'') topstorename,
	ifnull($averagesale,0) averagesale;
	
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
ENDdate=date_format($enddate,'%d-%m-%Y');*/
	SET @startdate=$startdate;
	SET @enddate=$enddate;
	
	SELECT * FROM (SELECT p.`itemcode` `Item Code`,`itemname` `Item Name`,FORMAT(`buyingprice`,0) `Buying Price`,FORMAT(`sellingprice`,0) `Selling Price`,FORMAT(SUM(quantity),2) AS `Units Sold`, 
	FORMAT(SUM(quantity*unitprice),2) AS `Total Sales`, FORMAT(SUM(discount),2) `Discount`
	FROM `products` p, `possales` s, `possalesdetails` sd
	WHERE p.`productid`=sd.`itemcode` AND sd.`possaleid`=s.`id`
	AND `receiptdate` BETWEEN @startdate AND @enddate AND IFNULL(s.deleted,0)=0
	GROUP BY p.`itemcode`,`itemname`,`buyingprice`,`sellingprice` ORDER BY itemname) AS q1
	UNION
	SELECT '' AS itemcode, 'TOTAL' AS itemname,0 AS `Buying Price`, 0 AS `Selling Price`, FORMAT(SUM(quantity),2) `Units Sold`, FORMAT(SUM(quantity*unitprice),2) AS `Total Sales`, FORMAT(SUM(discount),2) `Discount`
	FROM `products` p, `possales` s, `possalesdetails` sd
	WHERE p.`productid`=sd.`itemcode` AND sd.`possaleid`=s.`id` AND IFNULL(s.deleted,0)=0
	AND `receiptdate` BETWEEN @startdate AND @enddate;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetemailconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetemailconfiguration` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetemailconfiguration`()
BEGIN
	select * from `emailconfiguration`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglaccountclasses` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglaccountclasses` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetglaccountclasses`()
BEGIN
	select `id`,`classname`,replace(concat(`classname`, case when RIGHT(`classname`,1)='y' then 'ies' else 's' end),'y','') as newname 
	from glaccountclasses order by `classname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglaccountdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglaccountdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetglaccountdetails`($id int)
BEGIN
	SELECT a.* , g.id AS subgroupid, gg.`id` AS parentgroupid, c.`id` AS classid 
	FROM `glaccounts` a, `glaccountgroups` g, `glaccountgroups` gg, `glaccountclasses` c 
	WHERE  a.`groupid`=g.id AND g.`subactegoryof`=gg.id AND g.`glaccountclass`=c.id  and a.`id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglaccounts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglaccounts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetglaccounts`($groupid int)
BEGIN
	if $groupid=0 then
		select * from `glaccounts` where deleted=0 order by `accountname`;
	else
		SELECT * FROM `glaccounts` WHERE deleted=0 and `groupid`=$groupid ORDER BY `accountname`;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetglgroups` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetglgroups` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetglgroups`($category int)
BEGIN
	if $category=0 then
		select * from `glaccountgroups` order by `groupname`;
	else
		select * from `glaccountgroups` where `glaccountclass`=$category
		order by `groupname`;
	end if ;
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetglsubgroups`($groupid int)
BEGIN
	if $groupid=0 then
		select * from `glaccountgroups` where `subactegoryof`<>0 order by `groupname`;
	else
		select * from `glaccountgroups` where `subactegoryof`=$groupid order by `groupname`;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetgrnitemdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetgrnitemdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetgrnitemdetails`($grnno varchar(50),$productid int)
BEGIN
	SELECT p.productid,p.`itemcode`, `itemname`,gd.`quantity`,od.`unitprice`,`serialno`
	FROM  goodsreceived g,`goodsreceiveddetails` gd, `products` p, `purchaseorders` o, `purchaseorderdetails` od
	WHERE g.grnno=gd.grnno and gd.`itemcode`=p.productid and o.`id`=od.`purchaseorderid` and od.`itemcode`=p.productid 
	and gd.`purchaseorderno`=o.`purchaseorderno` AND p.productid=$productid AND (gd.grnno=$grnno or g.invoiceno=$grnno);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetgrnproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetgrnproducts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetgrnproducts`($grnno varchar(50))
BEGIN
	SELECT DISTINCT gd.`itemcode` AS productid, p.`itemcode`,`itemname` 
	FROM `goodsreceiveddetails` gd,`products` p, `goodsreceived` g
	WHERE  g.grnno=gd.grnno and gd.itemcode=p.productid 
	AND (gd.`grnno`=$grnno or g.`invoiceno`=$grnno) -- AND IFNULL(s.deleted,0)=0
	ORDER BY `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetheldsaledetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetheldsaledetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetheldsaledetails`($id int)
BEGIN
	select `itemcode`, `itemname`, `quantity`,`unitprice`,`discount`,
	`fn_getitemstorebalance`(p.productid ,posid)itembalance 
	from `heldsalesdetails` hd, `products` p, `heldsales` h
	where h.`id`=hd.`heldsaleid` and p.`productid`=hd.`productid` and `heldsaleid`=$id
	order by `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetheldsaleheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetheldsaleheader` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetheldsaleheader`($id int)
BEGIN
	select `customerid`,`posid` from `heldsales` where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetheldsales` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetheldsales` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetheldsales`($userid int)
BEGIN
	select h.`id`,`dateheld`,`customername`,`posname`
	from `heldsales` h, `customers` c, `pointsofsale` s
	where h.`customerid`=c.`customerid` and h.`posid`=s.`id` 
	and h.`addedby`=$userid order by h.`id` desc;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetinsertedcustomer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetinsertedcustomer` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetinsertedcustomer`()
BEGIN
	select max(customerid)as customerid from `customers` ;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetinstitutiondetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetinstitutiondetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetinstitutiondetails`()
BEGIN
	select * from `institution`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetinvoicegrns` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetinvoicegrns` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetinvoicegrns`($id int)
BEGIN
	declare $suppliercontrolaccount int;
	set $suppliercontrolaccount=(select id from `glaccounts` where `accountcode`=(select `account` from `glaccountsettings` where `description`='Suppliers Control Account'));
	select p.`itemcode`,description,sum(`quantity`) quantity,avg(`unitprice`) unitprice,$suppliercontrolaccount as accountcharged 
	from `supplierinvoicedetails` id, `products` p where p.`productid`=id.`itemcode` and `invoiceid`=$id
	group by p.`itemcode`,description;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetitemstatement` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetitemstatement` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetitemstatement`($itemcode VARCHAR(50),$startdate DATE,$enddate DATE)
BEGIN
	declare $productid int ;
	
	SET @startdate=$startdate;
	SELECT CASE WHEN `cutoffdate`>=@startdate THEN cutoffdate ELSE $startdate END INTO @startdate FROM `startingparameters`;
	SET @enddate=$enddate;
	SET @balancedate=DATE_SUB(@startdate, INTERVAL 1 DAY);
	SET @itemcode=$itemcode;
	
	SELECT `productid` into $productid 
	FROM `products` WHERE `itemcode`=$itemcode;
	
	-- get opening balance
	SELECT `productid`,`itemcode`,`itemname`,'Opening balance' description,NULL AS reference, DATE_FORMAT(@balancedate,'%d-%b-%Y') AS `date`,0 AS `sortkey`,NULL AS stockin, NULL AS stockout,fn_getitemstockbalance(productid,@balancedate) openingbalance, @balancedate AS unmodifieddate
	FROM `products` WHERE itemcode=@itemcode
	
	union
	
	-- get reconcilled balances
	select productid,itemcode,itemname,'Reconciled balance','<None>' reference,date_format(`reconciliationdate`,'%Y-%b-%d') `date`,1 sortkey,quantity stockin, null `stockout`,null openingbalance,`reconciliationdate` unmodifieddate
	from `stockreconciledbalance` s
	join `stockreconciledbalancedetails` sd on sd.`reconciliationid`=s.`id` 
	join products p on p.productid=sd.itemid 
	where `itemid`=$productid and DATE_FORMAT(`reconciliationdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	
	-- get purchases
	UNION
	SELECT productid, p.itemcode,`itemname`, 'Purchase' description, CONCAT(g.`grnno`,' : ',`deliverynono`) reference, DATE_FORMAT(`datereceived`,'%d-%b-%Y') AS `date`,1 AS `sortkey`,SUM(quantity) AS stockin, NULL AS stockout,NULL openingbalance,`datereceived` AS unmodifieddate
	FROM products p INNER JOIN `goodsreceiveddetails` gd ON p.productid=gd.`itemcode`
	INNER JOIN goodsreceived g ON gd.grnno=g.grnno
	WHERE p.itemcode=@itemcode AND DATE_FORMAT(`datereceived`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	GROUP BY  productid, p.itemcode,`itemname`, DATE_FORMAT(`datereceived`,'%d-%b-%Y'), g.`grnno`,`deliverynono`
	
	-- get sales
	UNION
	SELECT productid, p.itemcode,`itemname`, 'Sale' dscription,s.receiptno reference, DATE_FORMAT(`receiptdate`,'%d-%b-%Y') AS `date`,2 AS `sortkey`,NULL  AS stockin,SUM(quantity)AS stockout,NULL openingbalance, receiptdate AS unmodifieddate
	FROM products p INNER JOIN `possalesdetails` pd ON p.productid=pd.`itemcode`
	INNER JOIN `possales` s ON pd.`possaleid`=s.`id`
	WHERE p.itemcode=@itemcode AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and s.deleted=0
	GROUP BY  productid, p.itemcode,`itemname`, DATE_FORMAT(`receiptdate`,'%d-%b-%Y'), receiptno
	ORDER BY unmodifieddate,sortkey;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetmasterstocksheet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetmasterstocksheet` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetmasterstocksheet`($enddate date)
BEGIN
	SET @basedate=date_format(ifnull((SELECT `stockcutoffdate` FROM `startingparameters`),'2020-01-01'),'%Y-%m-%d');
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetmpesac2bparameters`()
BEGIN
	select c2burl,c2bshortcode,c2bmsisdn from mpesaconfiguration;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetmpesaconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetmpesaconfiguration` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetmpesaconfiguration`()
BEGIN
	select * from `mpesaconfiguration`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetmpesatransaction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetmpesatransaction` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetmpesatransaction`($amount int,$reference varchar(50))
BEGIN
	if $reference='' then
		select * from `mpesaconfirmation` where `amount`=$amount and date_format(`date`,'%Y-%m-%d')=date_format(now(),'%Y-%m-%d') AND IFNULL(`used`,0)=0;
	else
		SELECT * FROM `mpesaconfirmation` WHERE `reference`=$reference and ifnull(`used`,0)=0;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetnonuseroutlets` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetnonuseroutlets` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetnonuseroutlets`($userid int)
BEGIN
	SELECT *
	FROM  `pointsofsale` s  
	WHERE id not in(select `outletid` from `useroutlets` where `userid`=$userid and ifnull(`deleted`,0)=0)
	and ifnull(s.deleted,0)=0
	ORDER BY posname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetnonuserroles` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetnonuserroles` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetnonuserroles`($userid int)
BEGIN
	select * from `roles` 
	where roleid not in(select `roleid` from `roleusers` where `userid`=$userid)
	order by rolename;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetobjectdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetobjectdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetobjectdetails`($objectid int)
BEGIN
	select * from `objects` where `id`=$objectid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetobjects` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetobjects` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetobjects`($module varchar(50))
BEGIN
	if $module='' then
		select `id`,`description`,`module` from `objects` order by `description`;
	else
		select `id`,`description`,`module`  from `objects` where `module`=$module order by `description`;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetparentgroups` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetparentgroups` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetparentgroups`($classid int)
BEGIN
	if $classid=0 then
		select * from `glaccountgroups`where ifnull(`subactegoryof`,0)=0 order by `groupname`;
	else
		SELECT * FROM `glaccountgroups`WHERE IFNULL(`subactegoryof`,0)=0  and `glaccountclass`=$classid ORDER BY `groupname`;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentmethods` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentmethods` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpaymentmethods`()
BEGIN
	SELECT `id`,`description`,`image`,
	case when `default`=true then 1 else 0 end as `default`,
	case when `requiresrefno`=true then 1 else 0 end as`requiresrefno`,
	CASE WHEN `supplierslist`=TRUE THEN 1 ELSE 0 END AS`supplierslist` 
	FROM `paymentmethods` 
	where ifnull(`show`,1)=1
	ORDER BY `description`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentmethodsummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentmethodsummary` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpaymentmethodsummary`($startdate datetime,$enddate datetime)
BEGIN
	select paymentmode, sum(receipttotal) as total from `vwsalessummary`
	where transactiondate between $startdate and $enddate
	group by paymentmode  
	order by SUM(receipttotal) desc;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentvoucher` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentvoucher` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpaymentvoucher`($id varchar(50))
BEGIN
	select `suppliername`,`physicaladdress`,`postaladdress`,s.`mobile`,s.`email`, v.`voucherno`,date_format(v.`date`,'%d-%b-%Y') as voucherdate, `invoicenumber`,p.`description` as paymentmethod,`referenceno`,
	`itemcode`,vd.`description`,`quantity`,`unitprice`, concat(`firstname`, ' ',`middlename`,' ',`lastname`) as preparedby, o.`posname`
	from `paymentvouchers` v, `paymentvoucherdetails` vd, `paymentmethods` p, `suppliers` s, `user` u, `pointsofsale` o
	where v.`id`=vd.`voucherid` and v.`paymentmode`=p.id and v.`supplier`=s.supplierid and v.`addedby`=u.id and  o.id=v.`pos` 
	and v.`voucherno`=$id; -- v.`id`=$id;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentvoucherdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentvoucherdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpaymentvoucherdetails`($branchid int, $id varchar(50))
BEGIN
	SELECT p.paymentvoucherid AS id,`voucherno`, DATE_FORMAT(`date`,'%d-%b-%Y')`date`,`dateadded`,`addedby`,`paymentmode`,`pos`,`supplier`,`invoicenumber`,`cashbookaccount`,`referenceno`,`status`,`lastmodifiedby`,`lastmodifieddate` 
	FROM `paymentvouchers` p, paymentvoucherdetails pd  
	WHERE p.`branchid` = $branchid AND p.`paymentvoucherid`=pd.`voucherid` AND voucherno=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpaymentvouchers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpaymentvouchers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpaymentvouchers`($branchid int, $supplierid int,$posid int, $stat varchar(50),$paymentmode int, $startdate datetime,$enddate datetime,$pettycashvoucher boolean)
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
		(branchid = $branchid OR branchid IS NULL OR branchid = 0)
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpaymentvoucherstatus`($id int)
BEGIN
	select `status` from `paymentvouchers` where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpoitemsundelivered` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpoitemsundelivered` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpoitemsundelivered`($purchaseorderid varchar(50))
BEGIN
	SELECT p.`purchaseorderno`, pd.`itemcode`,`itemname`,`unitprice`,`quanity` AS ordered,ifnull(r.serializable,0) `serializable`,
	`quanity`-IFNULL((SELECT SUM(quantity) FROM `goodsreceiveddetails` WHERE `purchaseorderno`=p.`purchaseorderno` AND `itemcode`=pd.itemcode),0) AS undelivered
	FROM `purchaseorders` p, `purchaseorderdetails` pd, `products` r
	WHERE p.`id`=pd.`purchaseorderid` AND pd.`itemcode`=r.productid 
	AND p.`purchaseorderno`=$purchaseorderid
	AND `quanity`-IFNULL((SELECT SUM(quantity) FROM `goodsreceiveddetails` WHERE `purchaseorderno`=p.`purchaseorderno` AND `itemcode`=pd.itemcode),0) >0 ;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpos` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpos` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpos`()
BEGIN
	select p.*, concat(firstname,' ',middlename,' ',lastname) as addedbyname 
	from `pointsofsale` p, `user` u where u.id=p.addedby and `deleted`=0 order by `posname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetposdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetposdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetposdetails`($id numeric)
BEGIN
	select * from `pointsofsale` where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetposreceipts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetposreceipts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetposreceipts`($startdate datetime,$enddate datetime,$posid int, $modeofpay int)
BEGIN
	declare modeofpayname varchar(50) default "";
	if $modeofpay>0 then
		set modeofpayname=(select `description` from `paymentmethods` where `id`=$modeofpay);
	end if;
	
	if $posid=0 then 
		if $modeofpay=0 then
			SELECT s.`id`,`posname` ,`receiptno` , DATE_FORMAT(`receiptdate`,'%d-%b-%Y') AS `date`,`customername`,
			GROUP_CONCAT(DISTINCT m.description ORDER BY m.description) AS description, 
			GROUP_CONCAT( DISTINCT CASE WHEN p.`reference`='' THEN ' - ' ELSE p.reference END) reference, 
			CASE WHEN s.`deleted`=0 THEN 'Valid' ELSE 'Cancelled' END AS `status`,
			SUM(p.amount) AS `amount`,(SELECT CONCAT (`firstname`,' ',`middlename`) FROM `user` u WHERE u.id=s.`addedby`) AS `addedby`
			FROM `possales` s,`customers` c, `pointsofsale` o, `possalespayments` p, `paymentmethods` m
			WHERE s.`customerid`=c.`customerid` AND s.`pointofsaleid`=o.`id` AND p.`possaleid`=s.`id` AND m.`id`=p.`paymentmode`
			AND DATE_FORMAT(`s`.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY  s.id,`receiptno`
			ORDER BY s.id DESC;
		else
			SELECT s.`id`,`posname` ,`receiptno` , DATE_FORMAT(`receiptdate`,'%d-%b-%Y') AS `date`,`customername`,
			GROUP_CONCAT(DISTINCT m.description ORDER BY m.description) AS description, 
			GROUP_CONCAT( DISTINCT CASE WHEN p.`reference`='' THEN ' - ' ELSE p.reference END) reference, 
			CASE WHEN s.`deleted`=0 THEN 'Valid' ELSE 'Cancelled' END AS `status`,
			SUM(p.amount) AS `amount`,(SELECT CONCAT (`firstname`,' ',`middlename`) FROM `user` u WHERE u.id=s.`addedby`) AS `addedby`
			FROM `possales` s,`customers` c, `pointsofsale` o, `possalespayments` p, `paymentmethods` m
			WHERE s.`customerid`=c.`customerid` AND s.`pointofsaleid`=o.`id` AND p.`possaleid`=s.`id` AND m.`id`=p.`paymentmode`
			AND DATE_FORMAT(`s`.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY  s.id,`receiptno`
			having description like CONCAT('%',modeofpayname,'%')
			ORDER BY s.id DESC;
		end if;
	else	
	
		IF $modeofpay=0 THEN
			SELECT s.`id`,`posname` ,`receiptno` , DATE_FORMAT(`receiptdate`,'%d-%b-%Y') AS `date`,`customername`,
			GROUP_CONCAT(DISTINCT m.description ORDER BY m.description) AS description, 
			GROUP_CONCAT( DISTINCT CASE WHEN p.`reference`='' THEN ' - ' ELSE p.reference END) reference, 
			CASE WHEN s.`deleted`=0 THEN 'Valid' ELSE 'Cancelled' END AS `status`,
			SUM(p.amount) AS `amount`,(SELECT CONCAT (`firstname`,' ',`middlename`) FROM `user` u WHERE u.id=s.`addedby`) AS `addedby`
			FROM `possales` s,`customers` c, `pointsofsale` o, `possalespayments` p, `paymentmethods` m
			WHERE s.`customerid`=c.`customerid` AND s.`pointofsaleid`=o.`id` AND p.`possaleid`=s.`id` AND m.`id`=p.`paymentmode`
			AND DATE_FORMAT(`s`.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND s.`pointofsaleid`=$posid
			GROUP BY  s.id,`receiptno`, DATE_FORMAT(`receiptdate`,'%d-%b-%Y') , `customername`,s.deleted, `posname`,s.`addedby`
			ORDER BY s.id DESC;
		ELSE
			SELECT s.`id`,`posname` ,`receiptno` , DATE_FORMAT(`receiptdate`,'%d-%b-%Y') AS `date`,`customername`,
			GROUP_CONCAT(DISTINCT m.description ORDER BY m.description) AS description, 
			GROUP_CONCAT( DISTINCT CASE WHEN p.`reference`='' THEN ' - ' ELSE p.reference END) reference, 
			CASE WHEN s.`deleted`=0 THEN 'Valid' ELSE 'Cancelled' END AS `status`,
			SUM(p.amount) AS `amount`,(SELECT CONCAT (`firstname`,' ',`middlename`) FROM `user` u WHERE u.id=s.`addedby`) AS `addedby`
			FROM `possales` s,`customers` c, `pointsofsale` o, `possalespayments` p, `paymentmethods` m
			WHERE s.`customerid`=c.`customerid` AND s.`pointofsaleid`=o.`id` AND p.`possaleid`=s.`id` AND m.`id`=p.`paymentmode`
			AND DATE_FORMAT(`s`.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND s.`pointofsaleid`=$posid
			GROUP BY  s.id,`receiptno`, DATE_FORMAT(`receiptdate`,'%d-%b-%Y') , `customername`,s.deleted, `posname`,s.`addedby`
			HAVING description LIKE CONCAT('%',modeofpayname,'%')
			ORDER BY s.id DESC;
		END IF;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetposreceiptsforbanking` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetposreceiptsforbanking` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetposreceiptsforbanking`($startdate datetime,$enddate datetime,$posid int,$modeofpay int)
BEGIN
	DECLARE $modeofpayname VARCHAR(50) DEFAULT "";
	IF $modeofpay>0 THEN
		SET $modeofpayname=(SELECT `description` FROM `paymentmethods` WHERE `id`=$modeofpay);
	END IF;
	
	if $posid=0 then
		begin
			if $modeofpay=0 then
				SELECT id,pointofsale AS posname, receiptno,DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`, paymentmode AS `description`, paymentmodereference reference, receipttotal amount, 
				userfullname `addedby`, customername
				FROM `vwsalessummary` where DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and banked=0
				order by DATE_FORMAT(`transactiondate`,'%d-%b-%Y') , receiptno;
			else
				SELECT id,pointofsale AS posname, receiptno,DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`, paymentmode AS `description`, paymentmodereference reference, receipttotal amount, 
				userfullname `addedby`, customername
				FROM `vwsalessummary` WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and paymentmode=$modeofpayname and banked=0
				ORDER BY DATE_FORMAT(`transactiondate`,'%d-%b-%Y') , receiptno;
			end if;
		end;
	else
		begin
			IF $modeofpay=0 THEN
				SELECT id,pointofsale AS posname, receiptno,DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`, paymentmode AS `description`, paymentmodereference reference, receipttotal amount, 
				userfullname `addedby`, customername
				FROM `vwsalessummary` WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and posid=$posid and banked=0
				ORDER BY DATE_FORMAT(`transactiondate`,'%d-%b-%Y') , receiptno;
			ELSE
				SELECT id,pointofsale AS posname, receiptno,DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`, paymentmode AS `description`, paymentmodereference reference, receipttotal amount, 
				userfullname `addedby`, customername
				FROM `vwsalessummary` WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND paymentmode=$modeofpayname  AND posid=$posid and banked=0
				ORDER BY DATE_FORMAT(`transactiondate`,'%d-%b-%Y') , receiptno;
			END IF;
		end;
	end if;
		
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpossalespayments` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpossalespayments` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpossalespayments`($receiptno varchar(50))
BEGIN
	SELECT `description` AS paymentmethod, 
	case when p.`reference`='' then '-' else p.`reference` end as reference,`amount` 
	FROM `possalespayments` p, `paymentmethods` m, `possales` ps
	WHERE ps.`id`=p.`possaleid` AND p.`paymentmode`=m.`id` AND `receiptno`=$receiptno;
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetproductbycategory`($categoryid int)
BEGIN
	if $categoryid=0 then
		select * from `products` where `deleted`=0 order by `itemname`;
	else
		select * from `products` where `deleted`=0 and `categoryid`=$categoryid order by `itemname`;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetproductdetails`($itemcode varchar(50),$customerid numeric,$storeid int)
BEGIN
		if $storeid=0 then
			if $customerid=0 then
				select p.*, `fn_getitemstorebalance`(p.productid ,$storeid)itembalance,0 as discount  
				from `products` p 
				where `itemcode`=$itemcode and p.deleted=0;
				-- AND `categoryid` IN(SELECT `productcategoryid` FROM `posproductcategories` WHERE `posid`=$storeid AND `deleted`=0);
			else
				SELECT p.*,  `fn_getitemstorebalance`(p.productid ,$storeid)itembalance,
				IFNULL((SELECT CASE WHEN `percentage`=1 THEN (`value`/100)*`sellingprice` ELSE `value` END 
				FROM customercategories r INNER JOIN  customerpricematrix m ON m.`customercategoryid`=r.`id` 
				INNER JOIN `customers` c ON c.`catid`=r.`id` WHERE p.`productid`=m.`itemid` AND c.`customerid`=$customerid)
				,IFNULL((SELECT CASE WHEN percentage=1 THEN (`discount`/100)*`sellingprice` ELSE `discount` END FROM `customerdiscountsettings` cs
				WHERE cs.`customerid`=$customerid AND cs.`productid`=p.`productid` AND IFNULL(`deleted`,0)=0 -- AND DATE_FORMAT(`expirydate`,'%d-%b-%Y')>=DATE_FORMAT(NOW(),'%d-%b-%Y') 
				ORDER BY `expirydate` DESC LIMIT 1),0)) AS discount 
				FROM products p WHERE p.`itemcode`=$itemcode and p.deleted=0;
				-- and `categoryid` in(select `productcategoryid` from `posproductcategories` where `posid`=$storeid and `deleted`=0);
			end if;
		else
			IF $customerid=0 THEN
				SELECT p.*, `fn_getitemstorebalance`(p.productid ,$storeid)itembalance,0 AS discount  
				FROM `products` p 
				WHERE `itemcode`=$itemcode AND p.deleted=0
				AND `categoryid` IN(SELECT `productcategoryid` FROM `posproductcategories` WHERE `posid`=$storeid AND `deleted`=0);
			ELSE
				SELECT p.*,  `fn_getitemstorebalance`(p.productid ,$storeid)itembalance,
				IFNULL((SELECT CASE WHEN `percentage`=1 THEN (`value`/100)*`sellingprice` ELSE `value` END 
				FROM customercategories r INNER JOIN  customerpricematrix m ON m.`customercategoryid`=r.`id` 
				INNER JOIN `customers` c ON c.`catid`=r.`id` WHERE p.`productid`=m.`itemid` AND c.`customerid`=$customerid)
				,IFNULL((SELECT CASE WHEN percentage=1 THEN (`discount`/100)*`sellingprice` ELSE `discount` END FROM `customerdiscountsettings` cs
				WHERE cs.`customerid`=$customerid AND cs.`productid`=p.`productid` AND IFNULL(`deleted`,0)=0 -- AND DATE_FORMAT(`expirydate`,'%d-%b-%Y')>=DATE_FORMAT(NOW(),'%d-%b-%Y') 
				ORDER BY `expirydate` DESC LIMIT 1),0)) AS discount 
				FROM products p WHERE p.`itemcode`=$itemcode AND p.deleted=0
				AND `categoryid` IN(SELECT `productcategoryid` FROM `posproductcategories` WHERE `posid`=$storeid AND `deleted`=0);
			END IF;
		end if;
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetproductdiscountmatrix` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetproductdiscountmatrix` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetproductdiscountmatrix`($itemcode varchar(50))
BEGIN
	select c.`id` as customercategoryid, `description` as customercategory, `percentage`,`value` 
	from `customerpricematrix` m,`customercategories` c, `products` p
	where c.`id`=m.`customercategoryid` and p.`productid`=m.`itemid` and p.`itemcode`=$itemcode;
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
    ENDdate
		and ifnull(p.`deleted`,0)=0
		GROUP BY `itemcode`,`itemname`,`buyingprice`
		UNION 
		SELECT 'TOTAL: ' AS itemcode,'' AS itemname,
		FORMAT(AVG(`buyingprice`),2) AS `Buying Price`, FORMAT(AVG(`unitprice`),2) AS sellingprice, FORMAT(SUM(`quantity`),2) AS unitssold, 
		FORMAT(SUM(`buyingprice`*`quantity`),2) AS  `Total Purchases`, 
		FORMAT(SUM(`quantity`*(`unitprice`-IFNULL(discount,0))),2) AS  `Total Sales`,
		FORMAT(SUM((`unitprice`-IFNULL(discount,0))* `quantity`)- SUM(`buyingprice`*`quantity`),2) AS Margin
		FROM `products` m, `possales` p, `possalesdetails` pd
		WHERE m.`productid`=pd.`itemcode` AND pd.`possaleid`=p.`id` AND DATE_FORMAT(p.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		AND IFNULL(p.`deleted`,0)=0
		;
	else
		SELECT m.`itemcode`,`itemname`, FORMAT(`buyingprice`,2) AS `Buying Price`, FORMAT(AVG(`unitprice`),2) AS sellingprice, FORMAT(SUM(`quantity`),2) AS unitssold, 
		FORMAT(SUM(`buyingprice`*`quantity`),2) AS  `Total Purchases`, FORMAT(SUM((`unitprice`-IFNULL(discount,0)) * `quantity`),2) AS  `Total Sales`,
		FORMAT((SUM((`unitprice`-IFNULL(discount,0))* `quantity`))- (`buyingprice`*SUM(`quantity`)),2) AS Margin
		FROM `products` m, `possales` p, `possalesdetails` pd
		WHERE m.`productid`=pd.`itemcode` AND pd.`possaleid`=p.`id` 
		AND DATE_FORMAT(p.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND `pointofsaleid`=$posid
		AND IFNULL(p.`deleted`,0)=0
		GROUP BY `itemcode`,`itemname`,`buyingprice`
		UNION 
		SELECT 'TOTAL: ' AS itemcode,'' AS itemname,
		FORMAT(AVG(`buyingprice`),2) AS `Buying Price`, FORMAT(AVG(`unitprice`),2) AS sellingprice, FORMAT(SUM(`quantity`),2) AS unitssold, 
		FORMAT(SUM(`buyingprice`*`quantity`),2) AS  `Total Purchases`, 
		FORMAT(SUM(`quantity`*(`unitprice`-IFNULL(discount,0))),2) AS  `Total Sales`,
		FORMAT(SUM((`unitprice`-IFNULL(discount,0))* `quantity`)- SUM(`buyingprice`*`quantity`),2) AS Margin
		FROM `products` m, `possales` p, `possalesdetails` pd
		WHERE m.`productid`=pd.`itemcode` AND pd.`possaleid`=p.`id` AND DATE_FORMAT(p.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate 
		AND IFNULL(p.`deleted`,0)=0
		AND `pointofsaleid`=$posid 
		;
	end if;
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpropertydocumenttemplates`()
BEGIN
	select * from `propertydocumenttemplates` order by `description`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpurchaseorderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpurchaseorderdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpurchaseorderdetails`($id numeric)
BEGIN
    
	select p.departmentid,p.`purchaseorderno`,p.`date`,p.`supplierid`,p.`expecteddate`,`fn_purchaseorderstatus`($id)`status`,
	p.`terms`, pd.`itemcode` as itemid, pd.`quanity`,pd.`unitprice`, i.`itemcode`,`itemname`
	from `purchaseorders` p, `purchaseorderdetails` pd, `products` i
	where p.`id`=pd.`purchaseorderid` and pd.`itemcode`=i.`productid` and p.id=$id;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetpurchaseorders` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetpurchaseorders` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetpurchaseorders`()
BEGIN
	set @cutoffdate=ifnull((select date_format(`cutoffdate`,'%Y-%m-%d') from `startingparameters`),'2001-01-01');
	SELECT p.`id`,p.departmentid,`purchaseorderno`,DATE_FORMAT(`date`,'%Y-%m-%d') `date`,p.`supplierid`,
	-- case when exists(select * from `goodsreceiveddetails` where `purchaseorderno`=p.`purchaseorderno`) then 'received' else `status` end 
	`fn_purchaseorderstatus`(p.id)`status`,
	case when `taxinclusive`=1  then 
		SUM(`quanity`*`unitprice`) 
	else 
		sum(`quanity`*(unitprice*(100+`taxrate`)/100))
	end ordertotal, 
	CONCAT(`firstname`,' ',`middlename`/*,' ',`lastname`*/) addedby, `suppliername` 
	FROM `purchaseorders` p, `purchaseorderdetails` pd, `suppliers` s, `user` u
	WHERE p.`id`=pd.`purchaseorderid` AND p.`supplierid`=s.`supplierid` AND p.`addedby`=u.`id`
	AND DATE_FORMAT(`date`,'%Y-%m-%d')>=@cutoffdate
	GROUP BY p.`id`,`purchaseorderno`,`date`,`supplierid`,`status`, `suppliername` 
	ORDER BY `date` DESC;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetquotationterms` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetquotationterms` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetquotationterms`()
BEGIN
	select * from `quotationterms`
	order by `termname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreceiptdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreceiptdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreceiptdetails`($receiptno varchar(50))
BEGIN
	SELECT `posname`,`receiptno`,p.reference,pd.taxrate,
	date_format(`timestamp`,'%d-%b-%Y %H:%i:%s') receiptdate,`customername`,r.`itemcode`,
	concat(
	case when ifnull(`serialno`,'')<>'' then  
		concat (r.`itemname`,' [SN: ',`serialno`,']') 
	else 
		trim(CONCAT(`itemname`, ' ',case when `description`!='' then `description` else '' end)) 
	end,'  [',`abbreviation`,']') as `itemname`,
	sum(`quantity`) quantity,`unitprice`,`discount`,CONCAT(`firstname`,' ',`middlename`) AS servedby,
	c.postaladdress,c.email, c.mobile,c.town,c.postalcode, c.physicaladdress,c.pinno
	FROM `possales` p, `possalesdetails` pd, `customers` c, `pointsofsale` s, `products` r, `user` u, `taxtypes` ti
	WHERE p.`id`=pd.`possaleid`  AND p.`customerid`=c.`customerid` AND p.`pointofsaleid`=s.`id` 
	AND r.`productid`=pd.`itemcode` AND u.`id`=p.`addedby`  and ti.`id`=pd. `taxtypeid` AND p.`receiptno`=$receiptno
	group by `posname`,`receiptno`,`receiptdate`,`customername`,r.`itemcode`,r.`itemname`,`unitprice`,`discount`,`serialno`,servedby,
	c.postaladdress,c.email, c.mobile;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreceiptitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreceiptitems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreceiptitems`($receiptno varchar(50))
BEGIN
	select distinct sd.`itemcode` as productid, p.`itemcode`,
	trim(concat(`itemname` ,' ', case when `description`!='' then `description` else '' end)) itemname
	from `possalesdetails` sd,`products` p, `possales` s
	where sd.itemcode=p.productid and s.`id`=sd.`possaleid` and s.`receiptno`=$receiptno and ifnull(s.deleted,0)=0
	order by `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreceiptitemsdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreceiptitemsdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreceiptitemsdetails`($receiptno varchar(50),$productid int)
BEGIN
	select p.productid,p.`itemcode`, `itemname`,`quantity`,`unitprice`,`serialno`
	from `possales` s, `possalesdetails` sd, `products` p
	where s.`id`=sd.`possaleid` and sd.`itemcode`=p.productid 
	and p.productid=$productid and s.receiptno=$receiptno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreceiptvatanalysis` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreceiptvatanalysis` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreceiptvatanalysis`($receiptnumber varchar(50))
BEGIN
	select `abbreviation`,pd.`taxrate`,sum(quantity*unitprice) as total,sum(quantity*unitprice)*pd.`taxrate`/100 as vat
	from `possalesdetails` pd, `possales` p, `taxtypes` t
	where pd.`possaleid`=p.`id` and pd.`taxtypeid`=t.`id` and p.`receiptno`=$receiptnumber
	group by `abbreviation`,pd.`taxrate`
	order by pd.`taxrate`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturninwards` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturninwards` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreturninwards`($startdate date,$enddate date)
BEGIN
	SELECT r.id, DATE_FORMAT(r.`dateadded`,'%d-%b-%Y') dateadded, s.receiptno,p.itemcode,itemname,r.serialno,r.quantity,
	sd.unitprice,r.quantity*sd.unitprice total, refno, ifnull(collected,0) collected
	FROM `possales` s, `possalesdetails` sd, `products` p, `returninwards` r
	WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND p.productid=r.`productid` AND r.`possaleid`=s.id
	AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	ORDER BY r.`dateadded`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturninwardsdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturninwardsdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreturninwardsdetails`($refno varchar(50))
BEGIN
	select itemcode, itemname, serialno,quantity,narration
	from `returninwards` ri, products p
	where p.`productid`=ri.`productid` and `refno`=$refno
	order by itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturninwardsheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturninwardsheader` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreturninwardsheader`($refno varchar(50))
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreturninwardssummary`($asatdate date)
BEGIN
	SELECT itemcode,itemname, SUM(quantity) quantity,serialno,narration,DATE_FORMAT(ro.dateadded,'%d-%b-%Y') dateadded,refno
	FROM `returninwards` ro, products p
	WHERE ro.productid=p.productid AND DATE_FORMAT(ro.`dateadded`,'%Y-%m%-%d') <=$asatdate 
	AND ifnull(`collected`,0)=0
	GROUP BY itemcode,itemname,serialno,narration, refno
	ORDER BY itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturnoutwards` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturnoutwards` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreturnoutwards`($startdate date,$enddate date)
BEGIN
	SELECT r.id, DATE_FORMAT(r.`dateadded`,'%d-%b-%Y') dateadded, s.grnno,p.itemcode,itemname,r.serialno,r.quantity,
	od.unitprice  unitprice,r.quantity*od.`unitprice` total,r.refno, ifnull(r.delivered,0) delivered
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreturnoutwardsdetails`($refno varchar(50))
BEGIN
	select itemcode, itemname, serialno,quantity,narration
	from `returnoutwards` ro, products p
	where p.`productid`=ro.`productid` and `refno`=$refno
	order by itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturnoutwardsheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturnoutwardsheader` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreturnoutwardsheader`($refno varchar(50))
BEGIN
	SELECT ro.id,g.supplierid, suppliername, invoiceno,DATE_FORMAT(ro.`dateadded`,'%d-%b-%Y') dateadded,refno, concat(firstname,' ',lastname) username
	FROM returnoutwards ro, goodsreceived  g, suppliers s, user u
	WHERE ro.`grnid`=g.`id` AND s.`supplierid`=g.`supplierid` 
	and ro.refno=$refno and u.id=ro.addedby;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetreturnoutwardssummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetreturnoutwardssummary` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetreturnoutwardssummary`($asatdate date)
BEGIN
	select itemcode,itemname, sum(quantity) quantity,serialno,narration,date_format(ro.dateadded,'%d-%b-%Y') dateadded,refno
	from `returnoutwards` ro, products p
	where ro.productid=p.productid and date_format(ro.`dateadded`,'%Y-%m%-%d') <=$asatdate 
	and `delivered`=0
	group by itemcode,itemname,serialno,narration, refno
	order by itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetroledetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetroledetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetroledetails`($roleid int)
BEGIN
	select * from `roles` where `roleid`=$roleid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetroleprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetroleprivileges` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetroleprivileges`($roleid int)
BEGIN
	select * from `roleprivileges` where `roleid`=$roleid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetroles` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetroles` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetroles`()
BEGIN
	select * from `roles` where ifnull(`deleted`,0)=0
	order by `rolename`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetrolesforuserassignment` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetrolesforuserassignment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetrolesforuserassignment`()
BEGIN
	select `roleid`,`rolename` from `roles` order by `rolename`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetroleusers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetroleusers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetroleusers`($roleid int)
BEGIN
	select r.`userid`, `username`,`firstname`,`middlename`,`lastname` from `roleusers` r, `user` u
	where r.`userid`=u.`id` and `roleid`=$roleid
	order by `firstname`,`middlename`,`lastname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalebycustomervalue` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalebycustomervalue` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalebycustomervalue`($startdate datetime,$enddate datetime,$daterange varchar(50))
BEGIN
	IF $daterange='Day' THEN
		SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,
		ifnull(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
		ifnull(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
		FROM `vwsalessummary2` v WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY DATE_FORMAT(transactiondate,'%H') 
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Week' THEN
		SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,
		IFNULL(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
		IFNULL(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
		FROM `vwsalessummary2` v WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY DATE_FORMAT(transactiondate,'%a')
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Month' THEN
		SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,
		IFNULL(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
		IFNULL(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
		FROM `vwsalessummary2` v WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY DATE_FORMAT(transactiondate,'%d') 
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Year' THEN
		SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,
		IFNULL(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
		IFNULL(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
		FROM `vwsalessummary2` v WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY DATE_FORMAT(transactiondate,'%b')
		ORDER BY v.transactiondate; -- transactiondate;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbycustomercount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbycustomercount` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalesbycustomercount`($startdate datetime,$enddate datetime,$daterange varchar(50))
BEGIN
	IF $daterange='Day' THEN
		SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`, 
		COUNT(IF(customername='WALKIN CUSTOMER',id,NULL)) AS `walkin`, 
		COUNT(IF(customername<>'WALKIN CUSTOMER',id,NULL)) AS `Regular` 
		FROM `vwsalessummary2` v
		WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY DATE_FORMAT(transactiondate,'%H') 
		ordER BY v.transactiondate;
	ELSEIF $daterange='Week' THEN
		SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`, 
		COUNT(IF(customername='WALKIN CUSTOMER',id,NULL)) AS `walkin`, 
		COUNT(IF(customername<>'WALKIN CUSTOMER',id,NULL)) AS `Regular` 
		FROM `vwsalessummary2` v
		WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY DATE_FORMAT(transactiondate,'%a') 
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Month' THEN
		SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`, 
		COUNT(IF(customername='WALKIN CUSTOMER',id,NULL)) AS `walkin`, 
		COUNT(IF(customername<>'WALKIN CUSTOMER',id,NULL)) AS `Regular` 
		FROM `vwsalessummary2` v
		WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY DATE_FORMAT(transactiondate,'%d') 
		ORDER BY v.transactiondate;
	ELSEIF $daterange='Year' THEN
		SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`, 
		COUNT(IF(customername='WALKIN CUSTOMER',id,NULL)) AS `walkin`, 
		COUNT(IF(customername<>'WALKIN CUSTOMER',id,NULL)) AS `Regular` 
		FROM `vwsalessummary2` v
		WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY DATE_FORMAT(transactiondate,'%b') 
		ORDER BY v.transactiondate;
	END IF;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbyoutlet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbyoutlet` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalesbyoutlet`($startdate datetime,$enddate datetime)
BEGIN
	select pointofsale,sum(receipttotal) as total 
	from `vwsalessummary2` 
	where DATE_FORMAT(`transactiondate`,'%Y-%m-%d') between $startdate and $enddate
	group by pointofsale
	order by SUM(receipttotal) desc;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbypaymentmode` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbypaymentmode` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalesbypaymentmode`($startdate datetime,$enddate datetime,$userid int)
BEGIN
	if $userid=0 then 
		SELECT paymentmode AS `paymentmode`,SUM(receipttotal) AS amount
		FROM `vwsalessummary2` 
		WHERE DATE_FORMAT(transactiondate,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
		GROUP BY paymentmode 
		order BY transactiondate;
	else
		SELECT paymentmode AS `paymentmode`,SUM(receipttotal) AS amount
		FROM `vwsalessummary2` 
		WHERE DATE_FORMAT(transactiondate,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
		and userid=$userid
		GROUP BY paymentmode 
		ORDER BY transactiondate;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbypaymentmode2` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbypaymentmode2` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalesbypaymentmode2`($startdate datetime,$enddate datetime,$userid int)
BEGIN
	if $userid=0 then 
		SELECT paymentmode AS `paymentmode`,SUM(receipttotal) AS amount, count(*) as appears
		FROM `vwsalessummary2` 
		WHERE DATE_FORMAT(transactiondate,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
		GROUP BY paymentmode 
		ORDER BY transactiondate;
	else
		SELECT paymentmode AS `paymentmode`,SUM(receipttotal) AS amount, COUNT(*) AS appears
		FROM `vwsalessummary2` 
		WHERE DATE_FORMAT(transactiondate,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
		and userid=$userid
		GROUP BY paymentmode 
		ORDER BY transactiondate;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbyquantity` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbyquantity` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalesbyquantity`($startdate datetime,$enddate datetime,$daterange varchar(50),$userid int)
BEGIN
	if $userid=0 then
		IF $daterange='Day' THEN
			SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v where DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%H') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Week' THEN
			SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v where DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%a')
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Month' THEN
			SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v where DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%d') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Year' THEN
			SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v where DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%b')
			ORDER BY v.transactiondate;
		END IF;
	else
		IF $daterange='Day' THEN
			SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			and userid=$userid
			GROUP BY DATE_FORMAT(transactiondate,'%H') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Week' THEN
			SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid
			GROUP BY DATE_FORMAT(transactiondate,'%a')
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Month' THEN
			SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid
			GROUP BY DATE_FORMAT(transactiondate,'%d') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Year' THEN
			SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid
			GROUP BY DATE_FORMAT(transactiondate,'%b')
			ORDER BY v.transactiondate;
		END IF;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalesbysalesperson` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalesbysalesperson` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalesbysalesperson`($startdate datetime,$enddate datetime)
BEGIN
	SELECT userfullname,SUM(receipttotal) AS total 
	FROM `vwsalessummary2` 
	WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	group by userfullname
	ORDER BY SUM(receipttotal);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalessettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalessettings` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalessettings`()
BEGIN
	select * from `salessettings`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalessummarybycustomer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalessummarybycustomer` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalessummarybycustomer`($startdate datetime,$enddate datetime,$posname varchar(100), $userid int)
BEGIN
	if $posname='<All>' then 
		if $userid=0 then 
			SELECT date_format(transactiondate,'%d-%b-%Y') as transactiondate, pointofsale, customername,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			where transactiondate between $startdate and $enddate
			GROUP BY transactiondate, pointofsale, customername
			ORDER BY customername,transactiondate desc;
		else
			SELECT date_format(transactiondate,'%d-%b-%Y') as transactiondate, pointofsale, customername,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND userid=$userid
			GROUP BY transactiondate, pointofsale, customername
			ORDER BY transactiondate DESC;
		end if;
	else
		IF $userid=0 THEN 
			SELECT date_format(transactiondate,'%d-%b-%Y') as transactiondate, pointofsale, customername,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate and pointofsale=$posname
			GROUP BY transactiondate, pointofsale, customername
			ORDER BY customername,transactiondate desc;
		ELSE
			SELECT date_format(transactiondate,'%d-%b-%Y') as transactiondate, pointofsale, customername,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname and userid=$userid
			GROUP BY transactiondate, pointofsale, customername
			ORDER BY transactiondate desc;
		END IF;
	end  if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalessummarybyuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalessummarybyuser` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalessummarybyuser`($startdate datetime,$enddate datetime,$posname varchar(100), $userid int)
BEGIN
	if $posname='<All>' then 
		if $userid=0 then 
			SELECT date_format(transactiondate,'%d-%b-%Y') as transactiondate, pointofsale, userfullname,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			where transactiondate between $startdate and $enddate
			GROUP BY transactiondate, pointofsale, userfullname
			ORDER BY userfullname,transactiondate desc;
		else
			SELECT date_format(transactiondate,'%d-%b-%Y') as transactiondate, pointofsale, userfullname,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND userid=$userid
			GROUP BY transactiondate, pointofsale, userfullname
			ORDER BY transactiondate DESC;
		end if;
	else
		IF $userid=0 THEN 
			SELECT date_format(transactiondate,'%d-%b-%Y') as transactiondate, pointofsale, userfullname,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate and pointofsale=$posname
			GROUP BY transactiondate, pointofsale, userfullname
			ORDER BY userfullname,transactiondate desc;
		ELSE
			SELECT date_format(transactiondate,'%d-%b-%Y') as transactiondate, pointofsale, userfullname,
			SUM(IF (paymentmode = 'Cash', receipttotal, 0 )) AS Cash,
			SUM(IF (paymentmode = 'MPESA', receipttotal , 0)) AS Mpesa,
			SUM(IF (paymentmode = 'Credit', receipttotal , 0 )) AS Credit,
			SUM(IF (paymentmode = 'Cheque', receipttotal , 0 )) AS Cheque,
			SUM(IF (paymentmode = 'Card', receipttotal , 0 )) AS Card,
			SUM(receipttotal) AS Total
			FROM vwsalessummary
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname and userid=$userid
			GROUP BY transactiondate, pointofsale, userfullname
			ORDER BY transactiondate desc;
		END IF;
	end  if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsalestrend` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsalestrend` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsalestrend`($startdate datetime,$enddate datetime,$daterange varchar(50),$userid int)
BEGIN
	if $userid=0 then 
		if $daterange='Day' then
			select DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,sum(receipttotal) as amount
			from `vwsalessummary2` v where  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') between $startdate and $enddate
			group by DATE_FORMAT(transactiondate,'%H') 
			order by v.transactiondate;
		ELSEIF $daterange='Week' THEN
			SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v where  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			group by DATE_FORMAT(transactiondate,'%a')
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Month' THEN
			SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v where  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			group by DATE_FORMAT(transactiondate,'%d') 
			ORDER BY v.transactiondate;
		ELSEif $daterange='Year' then
			SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v where  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP by DATE_FORMAT(transactiondate,'%b')
			ORDER BY v.transactiondate; -- transactiondate;
		end if;
	else
		IF $daterange='Day' THEN
			SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			and userid=$userid 
			GROUP BY DATE_FORMAT(transactiondate,'%H') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Week' THEN
			SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid 
			GROUP BY DATE_FORMAT(transactiondate,'%a')
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Month' THEN
			SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid 
			GROUP BY DATE_FORMAT(transactiondate,'%d') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Year' THEN
			SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid 
			GROUP BY DATE_FORMAT(transactiondate,'%b')
			ORDER BY v.transactiondate; -- transactiondate;
		END IF;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsmsconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsmsconfiguration` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsmsconfiguration`()
BEGIN
	select * from `smsconfiguration`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetstocksheet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetstocksheet` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetstocksheet`($asat DATE)
BEGIN

    SET @asat = $asat;
    SET @cutoffdate = DATE(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters`), NOW()));
    SET @startdate = CONCAT(@cutoffdate, ' 00:00:00');
    SET @enddate = CONCAT(@asat, ' 23:59:59');

    -- Generate dynamic SQL to pivot stores into columns
    SET @sql_dynamic = (
        SELECT GROUP_CONCAT(
            CONCAT('ROUND(SUM(IF(storename = ''', `posname`, ''', units, 0)), 2) AS `', `posname`, '`')
        )
        FROM `vwstores`
    );

    -- Build main SQL body
    SET @sql = CONCAT(
        'WITH item_movements AS (
            SELECT c.categoryname, p.productid AS itemcode, p.itemname, p.buyingprice, p.sellingprice,
                   w.description AS storename,
                   SUM(
                       IFNULL(gr.qty, 0) + IFNULL(st_in.qty, 0) - IFNULL(st_out.qty, 0)
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
                JOIN stocktransfer s ON s.id = sd.transferid
                WHERE s.destinationtype = ''warehouse''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.destinationid
            ) st_in ON st_in.itemcode = p.productid AND st_in.destinationid = w.id
            LEFT JOIN (
                SELECT sd.itemcode, s.sourceid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.id = sd.transferid
                WHERE s.sourcetype = ''warehouse''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.sourceid
            ) st_out ON st_out.itemcode = p.productid AND st_out.sourceid = w.id
            GROUP BY c.categoryname, p.productid, p.itemname, p.buyingprice, p.sellingprice, w.description

            UNION ALL

            SELECT c.categoryname, p.productid AS itemcode, p.itemname, p.buyingprice, p.sellingprice,
                   ps.posname AS storename,
                   SUM(
                       IFNULL(stp_in.qty, 0) - IFNULL(stp_out.qty, 0) - IFNULL(sales.qty, 0) + IFNULL(recon.qty, 0)
                   ) AS units
            FROM categories c
            JOIN products p ON p.categoryid = c.categoryid
            JOIN pointsofsale ps
            LEFT JOIN (
                SELECT sd.itemcode, s.destinationid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.id = sd.transferid
                WHERE s.destinationtype = ''pos''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.destinationid
            ) stp_in ON stp_in.itemcode = p.productid AND stp_in.destinationid = ps.id
            LEFT JOIN (
                SELECT sd.itemcode, s.sourceid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.id = sd.transferid
                WHERE s.sourcetype = ''pos''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.sourceid
            ) stp_out ON stp_out.itemcode = p.productid AND stp_out.sourceid = ps.id
            LEFT JOIN (
                SELECT pd.itemcode, ps.pointofsaleid, SUM(pd.quantity) AS qty
                FROM possalesdetails pd
                JOIN possales ps ON pd.possaleid = ps.id
                WHERE IFNULL(ps.deleted, 0) = 0
                  AND ps.receiptdate BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY pd.itemcode, ps.pointofsaleid
            ) sales ON sales.itemcode = p.productid AND sales.pointofsaleid = ps.id
            LEFT JOIN (
                SELECT sd.itemid, s.posid, SUM(sd.quantity) AS qty
                FROM stockreconciledbalancedetails sd
                JOIN stockreconciledbalance s ON s.id = sd.reconciliationid
                WHERE s.reconciliationdate BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemid, s.posid
            ) recon ON recon.itemid = p.productid AND recon.posid = ps.id
            GROUP BY c.categoryname, p.productid, p.itemname, p.buyingprice, p.sellingprice, ps.posname
        )
        SELECT categoryname, itemcode, itemname, ', @sql_dynamic, ',
               ROUND(SUM(units), 2) AS `Total Quantity`,
               ROUND(SUM(units * buyingprice), 2) AS `Total Purchase`,
               ROUND(SUM(units * sellingprice), 2) AS `Total Selling`
        FROM item_movements
        GROUP BY categoryname, itemcode, itemname, buyingprice, sellingprice'
    );

    -- Execute the dynamic SQL
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetstocktransferbalance` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetstocktransferbalance` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetstocktransferbalance`($sourcetype varchar(50),$sourceid int,$itemcode varchar(50))
BEGIN
	if $sourcetype='warehouse' then 
		-- select * from `vwwarehouseitembalances` where warehouseid=$sourceid and itemcode=$itemcode;
		SELECT 
		`p`.`itemcode` AS `itemcode`,
		`p`.`itemname` AS `itemname`,
		`p`.`productid` AS `productid`,
		`p`.`unitofmeasure` AS `unitofmeasure`,
		`p`.`buyingprice` AS `buyingprice`,
		`p`.`sellingprice` AS `sellingprice`,
		`p`.`serializable` AS `serializable`,
		`fn_getwarehousestockbalance`(productid,$sourceid,curDATE()) unitsreceived, 0 as issued

		from products p where itemcode=$itemcode;
	else
		-- select * from `vwpointofsaleitembalances` where posid=$sourceid and  itemcode=$itemcode;
		SELECT
		  `s`.`id`            AS `posid`,
		  `s`.`posname`       AS `posname`,
		  `td`.`itemcode`     AS `itemid`,
		  `p`.`itemcode`      AS `itemcode`,
		  `p`.`itemname`      AS `itemname`,
		  `p`.`unitofmeasure` AS `unitofmeasure`,
		  `p`.`buyingprice`   AS `buyingprice`,
		  IFNULL(SUM(IF(`t`.`destinationid` = `s`.`id` AND `t`.`destinationtype` = 'pos' AND `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) 
		  +
		  -- Add Reconcilliation
		  ifnull((SELECT SUM(`quantity`)
		  FROM `stockreconciledbalancedetails` rd
		  JOIN `stockreconciledbalance` r ON r.`id`=rd.`reconciliationid`
		  WHERE `itemid`=p.productid AND DATE(`reconciliationdate`) BETWEEN IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters`),'2001-01-01') AND CURRENT_TIMESTAMP()
		  AND posid=$sourceid),0)
		  AS `unitsreceived`,
		  
		  IFNULL(SUM(IF(`t`.`sourceid` = `s`.`id` AND `t`.`sourcetype` = 'pos' AND `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) +
		  -- Add sales
		  ifnull((select sum(quantity) from `possales` ps 
			join `possalesdetails` pd on  pd.`possaleid`=ps.`id`
			where  pd.itemcode=p.productid and `receiptdate`>=IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters`),CURRENT_TIMESTAMP())
			and ps.`deleted`=0
		  ),0)
		  AS `issued`
		FROM (((`pointsofsale` `s`
		     JOIN `products` `p`)
		    JOIN `stocktransfer` `t`)
		   JOIN `stocktransferdetails` `td`)
		WHERE (`s`.`id` = `t`.`sourceid`
			OR `s`.`id` = `t`.`destinationid`)
		    AND `t`.`id` = `td`.`transferid`
		    AND `td`.`itemcode` = `p`.`productid`
		    AND `t`.`dateadded` >= IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters`),CURRENT_TIMESTAMP())
		    and s.id=$sourceid and p.itemcode=$itemcode;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetstocktransferdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetstocktransferdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetstocktransferdetails`($referenceno varchar(50))
BEGIN
	declare $id int;
	set $id=(select id from `stocktransfer` where `referenceno`=$referenceno);
	select p.`itemcode`,`itemname`,sum(`quantity`)quantity,`unitprice`, `serialno` 
	from `stocktransferdetails` t,`products` p
	where t.`itemcode`=p.`productid` and `transferid`=$id
	group by  p.`itemcode`,`itemname`,`unitprice`, `serialno` 
	order by `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetstocktransferheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetstocktransferheader` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetstocktransferheader`($referenceno varchar(50))
BEGIN
	SELECT * FROM `vwstocktransfers` 
	where referenceno=$referenceno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplieraginganalysis` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplieraginganalysis` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsupplieraginganalysis`($basedate datetime,$supplierid int)
BEGIN
	
	SET @basedate=$basedate,@supplierid=$supplierid;
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	
	SELECT  SUM(IF(`range`='1',amountoverdue,0)) AS `thirty`,  
		SUM(IF(`range`='31',amountoverdue,0)) AS `sixty`,
		SUM(IF(`range`='61',amountoverdue,0)) AS `ninenty` ,
		SUM(IF(`range`='91',amountoverdue,0)) AS `onetwenty` ,
		SUM(IF(`range`='120+',amountoverdue,0)) AS `aboveonetwenty`,
		 SUM(amountoverdue) AS `total`
	FROM (SELECT i.id AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,
	CASE 
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) <= 30 THEN '1' 
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 31 AND 60 THEN '31'
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 61 AND 90 THEN '61'
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 91 AND 120 THEN '91'
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d'))>120 THEN '120+' 
	END `range`,
	SUM(`quantity`*`unitprice`) -
	IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
	WHERE v.`id`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno` AND DATE_FORMAT(v.`date`,'%Y-%m-%d') BETWEEN @cutoffdate AND @basedate),0) AS amountoverdue
	FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
	WHERE i.`id`=id.`invoiceid` AND s.`supplierid`=i.`supplierid`  and s.`supplierid`=@supplierid
	and date_format(i.invoicedate,'%Y-%m-%d') between @cutoffdate AND @basedate
	GROUP BY i.id ,s.`supplierid`,suppliername,`invoiceno`,`status`,DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d'))
	ORDER BY `invoicedate` DESC, `invoiceno`) AS tab1
	GROUP BY suppliername;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsupplierdetails`($supplierid numeric)
BEGIN
	select * from `suppliers` where `supplierid`=$supplierid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierinvoices` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierinvoices` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsupplierinvoices`($supplierid int,$invoicestatus varchar(50),$startdate datetime,$enddate datetime)
BEGIN
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	set @accountdescription='Suppliers Control Account';
	set @accountcode=(select `account` from `glaccountsettings` where `description`=@accountdescription);
	
	set @accountid=(select `id` from `glaccounts` where `accountcode`=@accountcode);
	set @accountname=(SELECT `accountname` FROM `glaccounts` WHERE `accountcode`=@accountcode);
	
	if $supplierid=0 then
		begin
			if $invoicestatus='<All>' then
				select @accountid as accountcharged,@accountname as accountname, i.id AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,date_format(`invoicedate`,'%d-%b-%Y') invoicedate,sum(`quantity`*`unitprice`) as invoiceamount,`status`,
				ifnull((select sum(`quantity`*`unitprice`) from `paymentvouchers` v, `paymentvoucherdetails` vd 
				where v.`id`=vd.`voucherid` and `supplier`=s.supplierid and `invoicenumber`=`invoiceno`),0) as amountpaid
				from `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
				where i.`id`=id.`invoiceid` and s.`supplierid`=i.`supplierid` and date_format(`invoicedate`,'%Y-%m-%d') between $startdate and $enddate
				and DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
				GROUP BY i.id ,s.`supplierid`,suppliername,`invoiceno`,`status`, DATE_FORMAT(`invoicedate`,'%d-%b-%Y')
				ORDER BY DATE_FORMAT(`invoicedate`,'%d-%b-%Y') ;
			else
				SELECT  @accountid AS accountcharged,@accountname AS accountname,i.id AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,DATE_FORMAT(`invoicedate`,'%d-%b-%Y') invoicedate,SUM(`quantity`*`unitprice`) AS invoiceamount,`status`,
				IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
				WHERE v.`id`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno`),0) AS amountpaid
				FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
				WHERE i.`id`=id.`invoiceid` AND s.`supplierid`=i.`supplierid` AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
				and `status`=$invoicestatus AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
				GROUP BY i.id ,s.`supplierid`,suppliername,`invoiceno`,`status`, DATE_FORMAT(`invoicedate`,'%d-%b-%Y')
				ORDER BY DATE_FORMAT(`invoicedate`,'%d-%b-%Y') ;
			end if;
		end;
	else
		BEGIN
			IF $invoicestatus='<All>' then
				SELECT  @accountid AS accountcharged,@accountname AS accountname,i.id as invoiceid,s.`supplierid`,suppliername,`invoiceno`,DATE_FORMAT(`invoicedate`,'%d-%b-%Y') invoicedate,SUM(`quantity`*`unitprice`) AS invoiceamount,`status`,
				IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
				WHERE v.`id`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno`),0) AS amountpaid
				FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
				WHERE i.`id`=id.`invoiceid` AND s.`supplierid`=i.`supplierid` AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
				and s.supplierid=$supplierid AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
				GROUP BY i.id ,s.`supplierid`,suppliername,`invoiceno`,`status`, DATE_FORMAT(`invoicedate`,'%d-%b-%Y')
				ORDER BY DATE_FORMAT(`invoicedate`,'%d-%b-%Y') ;
			ELSE
				SELECT  @accountid AS accountcharged,@accountname AS accountname,i.id AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,DATE_FORMAT(`invoicedate`,'%d-%b-%Y') invoicedate,SUM(`quantity`*`unitprice`) AS invoiceamount,`status`,
				IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
				WHERE v.`id`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno`),0) AS amountpaid
				FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
				WHERE i.`id`=id.`invoiceid` AND s.`supplierid`=i.`supplierid` AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
				AND `status`=$invoicestatus AND s.supplierid=$supplierid AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
				GROUP BY i.id ,s.`supplierid`,suppliername,`invoiceno`,`status`, DATE_FORMAT(`invoicedate`,'%d-%b-%Y')
				ORDER BY DATE_FORMAT(`invoicedate`,'%d-%b-%Y') ;
			END IF;
		END;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierpendingorders` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierpendingorders` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsupplierpendingorders`($supplierid varchar(50))
BEGIN
	SET @cutoffdate=ifnull((SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`),'01-Jan-2001');
	SELECT DISTINCT `purchaseorderno` FROM `purchaseorders` p,`purchaseorderdetails` pd  
	WHERE p.`id`=pd.`purchaseorderid` AND `supplierid`=$supplierid -- and p.`status`='Pending' 
	and date_format(`date`,'%Y-%m-%d')>=@cutoffdate
	GROUP BY pd.`itemcode`, `purchaseorderno`
	HAVING SUM(`quanity`)>IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd
	WHERE g.`grnno`=gd.`grnno` AND gd.`itemcode`=pd.`itemcode` and gd.purchaseorderno=p.purchaseorderno),0)
	
	ORDER BY `purchaseorderno`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierproducts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsupplierproducts`($supplierid int)
BEGIN
	select s.`id` , s.`productid`,`itemcode`,`itemname`,s.`dateadded`, concat(`firstname`,' ',`middlename`,' ',`lastname`) as addedbyuser
	from `products` p, `supplierproducts` s, `user` u
	where p.`productid`=s.`productid` and  p.addedby=u.`id` and s.`supplierid`=$supplierid and s.`deleted`=0
	order by `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsuppliers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsuppliers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsuppliers`()
BEGIN	
	select s.*,concat(`firstname`,' ',`middlename`,' ',`lastname`) as addedbyname  
	from `suppliers` s, `user` u where  s.`addedby`=u.`id` and `deleted`=0 order by `suppliername`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsupplierstatement` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsupplierstatement` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsupplierstatement`($supplierid INT,$startdate DATETIME,$enddate DATETIME)
BEGIN
	SET @cutoffdate=DATE_FORMAT(IFNULL((SELECT`cutoffdate` FROM `startingparameters`),NOW()),'%Y-%m-%d');
	SET @startdate=$startdate,@enddate=$enddate,@supplierid=$supplierid;
	IF @cutoffdate>@startdate THEN 
		SET @startdate=@cutoffdate;
	END IF;
	SET @openingbalancedate=DATE_SUB(@startdate,INTERVAL 1 DAY);
	SELECT supplierid,suppliername,physicaladdress, postaladdress, mobile, email,DATE_FORMAT(invoicedate,'%d-%b-%Y') AS `date`, 
	`fngetsupplieropeningbalance`(@supplierid,@startdate) `openingbalance`,
	IFNULL((SELECT SUM(invoiceamount) FROM `vwsupplierstatement` o WHERE o.supplierid=@supplierid AND DATE_FORMAT(invoicedate,'%Y-%m-%d') BETWEEN @openingbalancedate AND @enddate),0) `invoices`,
	IFNULL((SELECT SUM(invoicepayment) FROM `vwsupplierstatement` o WHERE o.supplierid=@supplierid AND DATE_FORMAT(invoicedate,'%Y-%m-%d') BETWEEN @openingbalancedate AND @enddate),0) `payments`,
	reference,narrative,invoiceamount,invoicepayment,`order`
	FROM `vwsupplierstatement` v
	WHERE supplierid=@supplierid AND DATE_FORMAT(invoicedate,'%Y-%m-%d') BETWEEN @openingbalancedate AND @enddate
	ORDER BY invoicedate, `order`;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetsystemmodules` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetsystemmodules` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetsystemmodules`()
BEGIN
	select distinct `module` from `objects` 
	where `module` is not null 
	order by `module`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgettaxtypes` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgettaxtypes` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgettaxtypes`()
BEGIN
	select * from `taxtypes` order by `taxname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgettodaysdate` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgettodaysdate` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgettodaysdate`()
BEGIN
	select DATE_FORMAT(now(),'%Y-%m-%d') as today;
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetuninvoicedgrns`($supplierid int,$startdate datetime,$enddate datetime)
BEGIN
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	if $supplierid=0 then 
		SELECT g.`id`, g.`grnno`,`deliverynono`, DATE_FORMAT(`datereceived`,'%d-%b-%Y') `datereceived`,SUM(gd.`quantity`*pd.unitprice) AS `ordertotal`
		FROM `goodsreceived` g, `goodsreceiveddetails` gd, `purchaseorders` p, `purchaseorderdetails` pd
		WHERE g.`grnno`=gd.`grnno` AND gd.`purchaseorderno`=p.`purchaseorderno` AND p.`id`=pd.`purchaseorderid`  AND gd.itemcode=pd.itemcode AND IFNULL(invoiced,0)=0
		and g.`deliverynono` not like 'Opening Balance%' and DATE_FORMAT(`datereceived`,'%Y-%m-%d') between $startdate and $enddate 
		and  DATE_FORMAT(`datereceived`,'%Y-%m-%d')>=@cutoffdate
		GROUP BY  `id`, `grnno`,`deliverynono`,DATE_FORMAT(`datereceived`,'%d-%b-%Y')
		ORDER BY DATE_FORMAT(`datereceived`,'%d-%b-%Y'),  g.`grnno`;
	else
		SELECT g.`id`, g.`grnno`,`deliverynono` ,DATE_FORMAT(`datereceived`,'%d-%b-%Y') `datereceived`,SUM(gd.`quantity`*pd.unitprice) AS `ordertotal`
		FROM `goodsreceived` g, `goodsreceiveddetails` gd, `purchaseorders` p, `purchaseorderdetails` pd
		WHERE g.`grnno`=gd.`grnno` AND gd.`purchaseorderno`=p.`purchaseorderno` AND p.`id`=pd.`purchaseorderid`  AND gd.itemcode=pd.itemcode AND IFNULL(invoiced,0)=0
		and g.`deliverynono` NOT LIKE 'Opening Balance%' AND DATE_FORMAT(`datereceived`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and g.`supplierid`=$supplierid  
		AND DATE_FORMAT(`datereceived`,'%Y-%m-%d')>=@cutoffdate		
		GROUP BY  `id`, `grnno`,`deliverynono`,DATE_FORMAT(`datereceived`,'%d-%b-%Y')
		ORDER BY DATE_FORMAT(`datereceived`,'%d-%b-%Y'),  g.`grnno`;	
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuserbyid` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuserbyid` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetuserbyid`($userid int)
BEGIN
	select * from `user` where `id`=$userid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuserdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuserdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetuserdetails`($username varchar(50))
BEGIN
	select * from `user` WHERE `username`=$username;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetusernamefromuserid` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetusernamefromuserid` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetusernamefromuserid`($userid int)
BEGIN
	select * from `user` where `id`=$userid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuseroutlets` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuseroutlets` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetuseroutlets`($userid int)
BEGIN
	select o.*,`posname`
	from `useroutlets` o, `pointsofsale` s  
	where o.`userid`=$userid and s.`id`=o.outletid and ifnull(o.deleted,0)=0
	order by posname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuserprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuserprivileges` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetuserprivileges`($userid int)
BEGIN
	select * from `userprivileges` where userid=$userid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetuserroles` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetuserroles` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetuserroles`($userid int)
BEGIN
	select r.* from `roles` r, `roleusers` u
	where r.`roleid`=u.`roleid` and `userid`=$userid
	and ifnull(u.`deleted`,0)=0
	order by `rolename`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetvoucheritems` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetvoucheritems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetvoucheritems`($id varchar(50))
BEGIN
	select vd.*,`accountname` from `paymentvoucherdetails` vd, `paymentvouchers` v, `glaccounts` g 
	where  v.id=vd.`voucherid` and g.`id`=`accountcharged` and v.`voucherno`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgetwarehouses` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgetwarehouses` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgetwarehouses`()
BEGIN
	select * from `warehouses` order by `description`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spgteunitsofmeasure` */

/*!50003 DROP PROCEDURE IF EXISTS  `spgteunitsofmeasure` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spgteunitsofmeasure`()
BEGIN
	select * from `unitsofmeasure` order by `description`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sppostbanking` */

/*!50003 DROP PROCEDURE IF EXISTS  `sppostbanking` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sppostbanking`($refno varchar(50),$cashbookaccount int, $narration varchar(50),$reference varchar(50),$postas varchar(50),$userid int,$receiptbanked varchar(50))
BEGIN
	declare $salesaccount int;
	declare $transactiondate datetime;
	declare $debtorscontrolaccount int;
	set $transactiondate=now();
	
	set $salesaccount=(SELECT id FROM glaccounts WHERE accountcode =(SELECT`account` FROM `glaccountsettings` WHERE description='Sales'));
	SET $debtorscontrolaccount=(SELECT id FROM glaccounts WHERE accountcode =(SELECT`account` FROM `glaccountsettings` WHERE description='Debtors Control Account'));
	-- select $salesaccount;
	start transaction;
		-- post to sales or debtors control account individual transactions
		if $receiptbanked!='pos' then
			set $salesaccount=$debtorscontrolaccount;
		end if;
		
		insert into `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		select $reference, $transactiondate,$salesaccount, $cashbookaccount ,
			concat('Banking of receipt # ',`receiptno`, ' of reference #',`reference`,' issued to ',`customername`,' (',$narration,')'),
		0,`amount`,$userid from `tempbanking` where `refno`=$refno;
		
		-- post to the cashbbook account
		if $postas='single' then		
			insert into `gltransactions` (`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
			select $reference, $transactiondate,$cashbookaccount,$salesaccount, CONCAT('Banking of receipt # ',`receiptno`, ' of reference #',`reference`,' issued to ',`customername`,' (',$narration,')'),amount,0,$userid 
			FROM `tempbanking` WHERE `refno`=$refno; 
		else
			INSERT INTO `gltransactions` (`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
			SELECT $reference, $transactiondate,$cashbookaccount,$salesaccount, $narration,sum(amount),0,$userid 
			FROM `tempbanking` WHERE `refno`=$refno GROUP BY `refno`; 
		end if;
		-- update all receipts
		if $receiptbanked='pos' then 
			update `possalespayments` p, `tempbanking` b  
			set p.`banked`=1,p.`bankingreference`=$reference 
			where b.`id`=p.id;
		else
			update `customerreceipts` p, `tempbanking` b 
			set `banked`=1,`bankingrefno`=$reference
			where b.`id`=p.id;
		end if;
		-- remove temp data 
		delete from  `tempbanking` WHERE `refno`=$refno;
	COMMIT;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaceglgroupname` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaceglgroupname` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaceglgroupname`($id int,$glaccountclass int,$groupname varchar(50),$subcategoryof int, $cashbookaccount int,$userid int)
BEGIN
	if $id=0 then
		insert into `glaccountgroups`(`groupname`,`subactegoryof`,`dateadded`,`addedby`,`deleted`,`cashbookaccount`,`glaccountclass`)
		values($groupname,$subcategoryof,now(),$userid,0,$cashbookaccount,$glaccountclass);
	else
		update `glaccountgroups` set `groupname`=$groupname,`subactegoryof`=$subcategoryof,`cashbookaccount`=$cashbookaccouont,
		`glaccountclass`=$glaccountclass,`lastupdatedby`=$userid, `lastdateupdated`=now()
		where id=$id;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecategory` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavecategory`($categoryid numeric,$categoryname varchar(50),$prefix varchar(50),
	$currentno int,$userid numeric)
BEGIN
	if $categoryid=0 then
		insert into `categories`(`categoryname`,`prefix`,`currentno`,`dateadded`,`addedby`,`deleted`)
		values($categoryname,$prefix,$currentno,now(),$userid,0);	
	else
		update `categories` 
		set `categoryname`=$categoryname,`prefix`=$prefix,`currentno`=$currentno, 
		`lastmodifiedby`=$userid, `lastmodifiedon`=now()
		where `categoryid`=$categoryid;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecrateaddition` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecrateaddition` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavecrateaddition`($productid int,$quantity numeric(18,2),$unitprice numeric(18,2),$narration varchar(1000),
	$reference varchar(50),$userid int)
BEGIN
	insert into `cratesinventory`(`productid`,`quantity`,`unitprice`,`dateadded`,`narration`,`reference`,`addedby`)
	values($productid,$quantity,$unitprice,now(),$narration,$reference,$userid);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecrateinventorysettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecrateinventorysettings` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavecrateinventorysettings`($productid int, $supplierid int,$glaccountid int,$costcenter int, $paymentmode int,$paymentaccount int)
BEGIN
	if not exists(select * from `cratesinventorysettings`) then
		insert into `cratesinventorysettings`(`productid`,`supplierid`,`glaccountid`,`costcenterid`,`paymentmode`,`paymentaccount`)
		values($productid,$supplierid,$glaccountid,$costcenter,$paymentmode,$paymentaccount);
	else
		update `cratesinventorysettings` set `productid`=$productid,`supplierid`=$supplierid, `glaccountid`=$glaccountid,
		`costcenterid`=$costcenter,`paymentmode`=$paymentmode,`paymentaccount`=$paymentaccount;
	end if;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecreditnote` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecreditnote` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavecreditnote`($refno varchar(50),$customerid numeric,$userid numeric)
BEGIN
	DECLARE $creditnoteno VARCHAR(50);
	DECLARE $id NUMERIC;
	-- Generate the credit note number 
	set $creditnoteno=`fngeneratecreditnoteno`();
	START TRANSACTION;
		-- Insert credit note header 
		insert into `creditnotes`(`noteno`,`customerid`,`dateadded`,`addedby`)
		values($creditnoteno,$customerid,now(),$userid);
		-- get currently inserted id
		SET $id=(SELECT MAX(`id`) FROM `creditnotes`);
		-- insert credit note details 
		insert into `creditnotedetails`(`noteid`,`itemcode`,`quantity`,`unitprice`)
		select $id,`itemcode`,`quantity`,`unitprice` from `tempcreditnote` where `refno`=$refno;
		-- Increment credit note number counter
		update `serials` set `currentno`=`currentno`+1 where `documenttype`='Credit Note';
		-- Delete data from temp table
		delete from `tempcreditnote` where `refno`=$refno;
		-- get the credit note number generated
		select $creditnoteno as creditnotenumber;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecustomer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecustomer` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavecustomer`($customerid numeric, $customername varchar(50),$tradingname varchar(50),$physicaladdress varchar(100),$postaladdress varchar(100),
	$mobile varchar(50),$email varchar(50),$creditlimit numeric,$creditterm int,$userid numeric,$categoryid numeric,$posid int, $onetimecustomer bool,$pinno varchar(50),$idno varchar(50),
	$subzoneid int)
BEGIN
	-- Get the default pos if none was provided
	
	if $posid=0 then 
		set $posid=(select id from pointsofsale	where `default`=1);
	end if;
	
	if $customerid=0 then 
		insert into `customers`(`customername`,`tradingname`,`physicaladdress`,`postaladdress`,`mobile`,`email`,`creditlimit`,`creditterm`,`dateadded`,`addedby`,`deleted`,`catid`,`posid`,
		`onetimecustomer`,`pinno`,`idno`,`subzoneid`)
		values($customername,$tradingname,$physicaladdress,$postaladdress,$mobile,$email,$creditlimit,$creditterm,now(),$userid,0,$categoryid,$posid,$onetimecustomer,$pinno,$idno,$subzoneid);
	else
		update `customers` set `customername`=$customername,`tradingname`=$tradingname,`physicaladdress`=physicaladdress,`postaladdress`=postaladdress,`mobile`=$mobile,
		`email`=$email,`creditlimit`=$creditlimit,`creditterm`=$creditterm,`lastdatemodified`=now(),`lastmodifiedby`=$userid,`catid`=$categoryid, `posid`=$posid, 
		`onetimecustomer`=$onetimecustomer, `pinno`=$pinno,idno=$idno,subzoneid=$subzoneid
		where `customerid`=$customerid;
	end if ;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecustomerdiscountsettings` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecustomerdiscountsettings` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavecustomerdiscountsettings`($id numeric,$customerid numeric,$productid numeric,$discount numeric,
	$percentage bit,$userid numeric,$expirydate datetime)
BEGIN
	if $id=0 then
		insert into `customerdiscountsettings`(`customerid`,`productid`,`discount`,`percentage`,`dateadded`,`addedby`,`deleted`,`expirydate`)
		values($customerid,$productid,$discount,$percentage,now(),$userid,0,$expirydate);
	else	
		update `customerdiscountsettings` set `customerid`=$customerid,`productid`=$productid,`discount`=$discount,`percentage`=$percentage,
		`lastmodifiedby`=$userid,`lastmodifiedon`=now(), `expirydate`=$expirydate
		where `id`=$id;
	
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavecustomerreceipt` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavecustomerreceipt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavecustomerreceipt`($refno varchar(50),$customerid int, $modeofpayment int,
	$referenceno varchar(50),$userid int,$overpay numeric)
BEGIN
	declare $receiptno varchar(50);
	declare $receiptid numeric;
	-- generate code
	sET $receiptno=`spgeneratecustomerreceiptno`();
	start transaction;
		-- save receipt
		insert into `customerreceipts`(`receiptno`,`receiptdate`,`addedby`,`modeofpayment`,`referenceno`,`deleted`, `customerid`)
		values($receiptno,now(),$userid,$modeofpayment,$referenceno,0,$customerid);
		-- get the ID generated
		set $receiptid=(select max(`id`) from `customerreceipts`);
		-- save receipt details
		insert into `customerreceiptdetails` (`receiptid`,`possaleid`,`amount`)
		select $receiptid, `possaleid`,`amount` from `tempcustomerreceiptdetails` where `refno`=$refno;
		-- Add overpaid amount to suspense account if any
		if $overpay>0 then 
			insert into `customersuspenseaccount`(`customerid`,`transactiondate`,`referenceno`,`credit`,`addedby`,`narration`)
			values($customerid,now(),$receiptno,$overpay,$userid,'Customer amount overpaid');
		end if;
		-- Increment receipt number 
		update `serials` set `currentno`=`currentno`+1 where `documenttype`='Customer Receipt';
		-- delete temp receipt details
		DELETE FROM `tempcustomerreceiptdetails` WHERE  `refno`=$refno;
		-- return receipt number
		select  $receiptno  as receiptno;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveemailconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveemailconfiguration` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveemailconfiguration`($emailaddress varchar(100),$emailpassword varchar(50),$smtpserver varchar(50),$smtpport int,$usessl boolean)
BEGIN
	if not exists(select * from `emailconfiguration`) then
		insert into `emailconfiguration`(`emailaddress`,`password`,`smtpserver`,`usessl`,`smtpport`)
		values($emailaddress,$emailpassword,$smtpserver,$usessl,$smtpport);
	else
		update `emailconfiguration` 
		set `emailaddress`=$emailaddress,`password`=$emailpassword,`smtpserver`=$smtpserver,`usessl`=$usessl,`smtpport`=$smtpport;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveglaccount` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveglaccount` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveglaccount`($id int,$groupid int,$accountcode varchar(50),$accountname varchar(50),$userid int)
BEGIN
	if $id=0 then 
		insert into `glaccounts`(`groupid`,`accountcode`,`accountname`,`dateadded`,`addedby`,`deleted`)
		values($groupid,$accountcode,$accountname,now(),$userid,0);
	else
		update `glaccounts` set `groupid`=$groupid, `accountcode`=$accountcode,`accountname`=$accountname, `lastdateupdated`=now(),`lastupdatedby`=$userid
		where `id`=$id;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveglgroupname` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveglgroupname` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveglgroupname`($id int,$glaccountclass int,$groupname varchar(50),$subcategoryof int, $cashbookaccount int,$userid int)
BEGIN
	if $id=0 then
		insert into `glaccountgroups`(`groupname`,`subactegoryof`,`dateadded`,`addedby`,`deleted`,`cashbookaccount`,`glaccountclass`)
		values($groupname,$subcategoryof,now(),$userid,0,$cashbookaccount,$glaccountclass);
	else
		update `glaccountgroups` set `groupname`=$groupname,`subactegoryof`=$subcategoryof,`cashbookaccount`=$cashbookaccouont,
		`glaccountclass`=$glaccountclass,`lastupdatedby`=$userid, `lastdateupdated`=now()
		where id=$id;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavegltransaction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavegltransaction` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavegltransaction`($refno varchar(50),$transactiondate datetime,$referenceno varchar(50),$userid int)
BEGIN
	insert into `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
	select $referenceno,$transactiondate, `glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,$userid from `tempgltransaction` where `refno`=$refno;
	delete from `tempgltransaction` WHERE `refno`=$refno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavegoodsreceived` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavegoodsreceived` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavegoodsreceived`($refno varchar(50),$warehouseid numeric,$supplierid numeric,$deliverynoteno varchar(50),$userid numeric,
	$saveinvoice boolean,$invoiceno varchar(50),$inspectedby int,$transferitems int,$transferpos int)
BEGIN
	declare $grnno varchar(50);
	start transaction;
		-- generate goods received note number
		set $grnno=fngenerategrnno();
		-- save receipt details
		insert into `goodsreceived`(`warehouseid`,`grnno`,`datereceived`,`supplierid`,`deliverynono`,`receivedby`,`status`,`inspectedby`)
		values($warehouseid,$grnno,now(),$supplierid,$deliverynoteno,$userid,'Confirmed',$inspectedby);
		-- save received item details
		insert into `goodsreceiveddetails`(`grnno`,`itemcode`,`purchaseorderno`,`quantity`,`serialno`)
		select $grnno,`itemcode`,`purchaseorderno`,`quantity`,`serialno` from `tempgoodsreceived` where `refno`=$refno;
		-- Insert into stock movement
		insert into `stockmovement`(`purchasedate`,`productid`,`purchaseid`,`purchasequantity`,`purchaseprice`,`purchasetaxrate`,`purchasetaxid`)
		select date_format(now(),'%Y-%m-%d'),tg.`itemcode`,p.id,tg.`quantity`,
			case when `taxinclusive`=1 then (100/(100+p.taxrate))*pd.unitprice else pd.unitprice end,
		p.taxrate, p.taxid
		from `tempgoodsreceived` tg 
		join `purchaseorders` p on p.`purchaseorderno`=tg.`purchaseorderno`
		join `purchaseorderdetails` pd on pd.`purchaseorderid`=p.`id`
		where tg.`refno`=$refno and pd.itemcode=tg.itemcode;
		
		if $transferitems=1 then
		
			SET @refno = LEFT(UUID(), 8);
			
			INSERT INTO `tempstocktransfer`(`refno`,`itemcode`,`quantity`,`unitprice`,`serialno`)
			select @refno,t.`itemcode`,`quantity`,buyingprice,'' from `tempgoodsreceived` t
			join `products` p on p.`productid`=t.`itemcode`
			where `refno`=$refno;
			
			call `spsavestocktransfer`(@refno,'warehouse',$warehouseid,'pos',$transferpos,$userid,$userid,$userid);
			
		end if;
		
		-- increment counter for goods received
		UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Goods Received Note' ;
		
		-- Check if saving customer invoice 
		if $saveinvoice=1 then 
			-- Generate random ref number
			set @refno = LEFT(UUID(), 8);
			-- Add temp supplier invoice
			call `spsavetempsupplierinvoice`(@refno,$grnno);
			-- Save supplier invoice details
			call `spsavesupplierinvoice`(@refno,$invoiceno,$supplierid,now(),$userid);
		end if;
		-- delete data in the temporary table
		delete from `tempgoodsreceived` where `refno`=$refno;
		-- get the GRN Number generated
		select  $grnno as grnno;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveheldsale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveheldsale` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveheldsale`($refno varchar(50),$customerid int,$posid int,$userid int)
BEGIN
	declare $id numeric;
	start transaction;
			
		-- Save held sale		
		insert into `heldsales`(`customerid`,`posid`,`dateheld`,`addedby`)
		values($customerid,$posid,now(),$userid);
		
		-- get the currently inserted id
		SET $id=(SELECT MAX(`id`) FROM `heldsales`);
		
		-- post held sale details
		INSERT INTO `heldsalesdetails`(`heldsaleid`,`productid`,`quantity`,`unitprice`,`discount`)
		SELECT $id,`itemcode`,`quantity`,`unitprice`,`discount` FROM `tempsale` WHERE `refno`=$refno;
		-- delete the temporary data
		DELETE FROM `tempsale` WHERE `refno`=$refno;
		
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavejournaltransaction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavejournaltransaction` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavejournaltransaction`($refno varchar(50),$referenceno varchar(50), $description varchar(100),$userid int,$addtoledger bit)
BEGIN
	declare $journalid int;
	start transaction;
		-- insert the journal details
		insert into `journals`(`referenceno`,`date`,`description`,`addedby`,`addedtoledger`)
		values($referenceno,now(),$description,$userid,$addtoledger);
		-- get the journal id
		set $journalid=(select max(`id`) from `journals`);
		-- post journal transactions
		insert into `journaldetails`(`journalid`,`glaccount`,`narration`,`debit`,`credit`)
		select $journalid,`glaccount`,`narration`,`debit`,`credit` from `tempjournaldetails` where `refno`=$refno;
		
		-- post the info to the gl if requested
		if $addtoledger=1 then 
			insert into `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
			select $referenceno,now(),`glaccount`,null,`narration`,`debit`,`credit`,$userid from `tempjournaldetails` where `refno`=$refno;
		end if;
		
		-- delete temp journal data
		delete from `tempjournaldetails` WHERE `refno`=$refno;
		-- return the generated journal id
		select $journalid as `journalid`;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavempesac2bparameters` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavempesac2bparameters` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavempesac2bparameters`($url varchar(500),$shortcode varchar(50),$msisdn varchar(50))
BEGIN
	update `mpesaconfiguration` set c2burl=$url,c2bshortcode=$shortcode,c2bmsisdn=$msisdn;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavempesaconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavempesaconfiguration` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavempesaconfiguration`($consumerkey varchar(100),$consumersecret varchar(100),$validationurl varchar(500),$confirmationurl varchar(500),$paybillnumber varchar(10))
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavempesaconfirmation`($reference varchar(50),$transactiondate datetime,$amount numeric(18,2),$sendermobile varchar(50),$sendername varchar(50))
BEGIN
	insert into `mpesaconfirmation`(`date`,`reference`,`amount`,`sendermobile`,`sendername`)
	values($transactiondate,$reference,$amount,$sendermobile,$sendername);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavepaymentvoucher` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavepaymentvoucher` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavepaymentvoucher`($branchid int, $refno varchar(50),$id int,$voucherdate datetime,$voucherno varchar(50),$pos int,$supplier int,
	$paymentmode int,$cashbookaccount int,$reference varchar(50),$generatevoucherno int,$userid INt,$pettycash boolean,$craterefund boolean)
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
				DELETE  FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavepos`($id numeric,$posname varchar(50),$postype varchar(50),$printkitchenorders bool,$userid numeric)
BEGIN
	if $id=0 then 
		insert into `pointsofsale`(`posname`,`postype`,`printkitchenorders`,`dateadded`,`addedby`,`deleted`)
		values($posname,$postype,$printkitchenorders,now(),$userid,0);
		select max(`id`) into $id  from `pointsofsale`;
	else
		update `pointsofsale` 
		set `posname`=$posname, `postype`=$postype,`printkitchenorders`=$printkitchenorders,
		`lastdatemodified`=now(), `lastmodifiedby`=$userid
		WHERE id=$id;
	end if;
	select $id as posid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavepossale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavepossale` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavepossale`($refno varchar(50),$customerid numeric,$posid numeric,$transactiondate date,$reference varchar(50),$userid numeric)
BEGIN
	declare $receiptno varchar(50);
	declare $id int;
	declare $salesaccount int;
	declare $debtorscontrolaccount int;
	declare $creditsaleid int;
	declare $creditsales numeric(18,2);
	declare $creditreferenceno varchar(50);
	declare $customername varchar(100);
	declare $narration varchar(1000);
	declare $sessionid int;
	declare $fifoquantity decimal(18,2);
	DECLARE $stockmovementid INT;
	DECLARE $purchasebalance DECIMAL(18,4);
	DECLARE $tempproductid INT;
	DECLARE $tempquantity DECIMAL(18,4);
	DECLARE $tempunitprice DECIMAL(18,4);
	DECLARE $tempdiscount DECIMAL(18,4);
	DECLARE $tempserialno VARCHAR(50);
	DECLARE $temptaxid INT;
	DECLARE $temptaxrate DECIMAL(18,2);
	DECLARE $tempdescription VARCHAR(1000);
	DECLARE $finished INTEGER DEFAULT 0;
	
	-- Cursor for product details
	DECLARE tempproductcursor CURSOR FOR 
	SELECT `itemcode`,`quantity`,`unitprice`,`discount`,`serialno`,`taxtypeid`,`taxrate`,`description` 
		FROM `tempsale` WHERE `refno`=$refno;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET $finished=1;
	
	SET $salesaccount=(SELECT id FROM glaccounts WHERE accountcode =(SELECT`account` FROM `glaccountsettings` WHERE description='Sales'));
	SET $debtorscontrolaccount=(SELECT id FROM glaccounts WHERE accountcode =(SELECT`account` FROM `glaccountsettings` WHERE description='Debtors Control Account'));
	SET $creditsaleid=(SELECT id FROM paymentmethods WHERE description='Credit');
	SET $sessionid=(SELECT `sessionid` FROM `sessions` WHERE `status`='active');
	
	-- declare $creditnoteid int;
	SET $customername=(SELECT customername FROM `customers` WHERE `customerid`=$customerid);
	-- generate receipt number	
	SET $receiptno=fngeneratereceiptno();
	
	START TRANSACTION;
		-- Save receipt details
		INSERT INTO `possales`(`receiptno`,`receiptdate`,`customerid`,`pointofsaleid`,`addedby`,`sessionid`,`reference`,`timestamp`)
		VALUES($receiptno,$transactiondate,$customerid,$posid,$userid,$sessionid,$reference,now());
		
		-- get the currently inserted id
		SET $id=(SELECT MAX(`id`) FROM `possales`);
		
		-- Save product details
		INSERT INTO `possalesdetails`(`possaleid`,`itemcode`,`quantity`,`unitprice`,`discount`,`serialno`,`taxtypeid`,`taxrate`,`description`)
		select $id,itemcode,quantity,unitprice,discount,serialno,taxtypeid,taxrate,description
		from `tempsale`
		where `refno`=$refno;
				
		-- Generate invoice number
		SET @invoiceno=fngeneratecustomercreditrefno();
		-- post payment methods
		INSERT INTO `possalespayments`(`possaleid`,`paymentmode`,`reference`,`amount`)
		SELECT $id,`paymentmodeid`, CASE WHEN paymentmodeid=4 THEN @invoiceno ELSE `reference` END `reference`,`amount` FROM `temppossalespayment` WHERE `refno`=$refno;
		-- increment receiptnumber counter
		UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Receipt';
		
		-- Update all MPESA payments used to settle this transaction
		UPDATE `mpesaconfirmation` SET `used`=1, `receiptno`=$receiptno 
		WHERE `reference` IN(SELECT `reference` FROM `temppossalespayment` WHERE `paymentmodeid`=2 AND `refno`=$refno);
		
		-- update creditnote as used
		UPDATE `creditnotes` SET `used`=1, `possaleid`=$id WHERE `id` IN(SELECT `reference` FROM `temppossalespayment` WHERE `refno`=$refno AND `paymentmodeid`=4);
		-- Check if credit sale and post to GL debtors and sales
		SET $creditsales=IFNULL((SELECT amount FROM `temppossalespayment` WHERE `refno`=$refno AND `paymentmodeid`=$creditsaleid),0);
		-- set $creditreferenceno=(select `reference` from `temppossalespayment` WHERE `refno`=$refno);
		IF $creditsales>0 THEN 			
			SET $narration=CONCAT('Credit sale advanced to ',$customername,' account id: ',$customerid,' invoice ref: ',@invoiceno);
			-- check if the customers suspense account has money
			SET @debitedcustomerid= ABS((SELECT `reference` FROM `temppossalespayment` WHERE `refno`=$refno AND `paymentmodeid`=4));
			SET @customersuspensebalance=IFNULL(`fn_getcustomersuspenseaccountbalance`(@debitedcustomerid),0);
			IF @customersuspensebalance>=$creditsales THEN
				INSERT INTO `customersuspenseaccount`(`customerid`,`transactiondate`,`referenceno`,`debit`,`addedby`,`narration`)
				VALUES(@debitedcustomerid,NOW(),$receiptno,$creditsales,$userid,$narration);
				-- Add a receipt to the customers account for the whole amount
				SET @receiptno=`spgeneratecustomerreceiptno`();
				INSERT INTO `customerreceipts`(`receiptno`,`customerid`,`receiptdate`,`addedby`,`modeofpayment`,`referenceno`)
				VALUES(@receiptno,$customerid,NOW(),$userid,$creditsaleid,@invoiceno);
				-- get entered receipt id
				SET @receiptid=(SELECT MAX(id) FROM `customerreceipts`);
				-- add receipt details
				INSERT INTO `customerreceiptdetails`(`receiptid`,`possaleid`,`amount`)
				VALUES(@receiptid,$id,$creditsales);
			ELSE 
				-- SET @debitedcustomerid=ABS((SELECT `reference` FROM `temppossalespayment` WHERE `refno`=$refno AND `paymentmodeid`=4));
				INSERT INTO `customersuspenseaccount`(`customerid`,`transactiondate`,`referenceno`,`debit`,`addedby`,`narration`)
				VALUES(@debitedcustomerid,NOW(),$receiptno,@customersuspensebalance,$userid,$narration);
				
				-- Add a receipt to the customers account for the whole amount
				SET @receiptno=`spgeneratecustomerreceiptno`();
				INSERT INTO `customerreceipts`(`receiptno`,`customerid`,`receiptdate`,`addedby`,`modeofpayment`,`referenceno`)
				VALUES(@receiptno,$customerid,NOW(),$userid,$creditsaleid,@invoiceno);
				-- get entered receipt id
				SET @receiptid=(SELECT MAX(id) FROM `customerreceipts`);
				-- add receipt details
				INSERT INTO `customerreceiptdetails`(`receiptid`,`possaleid`,`amount`)
				VALUES(@receiptid,$id,@customersuspensebalance);
				
				SET $creditsales=$creditsales-@customersuspensebalance;
				
				IF $creditsales>0 THEN 
					-- Add the balance to the gl statement for debtors
					SET $customerid=ABS((SELECT `reference` FROM `temppossalespayment` WHERE `refno`=$refno AND `paymentmodeid`=4));
					SET $customername=(SELECT customername FROM `customers` WHERE `customerid`=$customerid);
					-- debit debtors control account
					INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
					VALUES($receiptno,NOW(),$debtorscontrolaccount,$salesaccount,$narration,$creditsales,0,$userid);
					-- credit sales account
					INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
					VALUES($receiptno,NOW(),$salesaccount,$debtorscontrolaccount,$narration,0,$creditsales,$userid);
					-- Increment the credit reference number counter
				END IF;
				
			END IF;
			UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Credit sale';
		END IF;
		
		-- Check if a crate was sold and reduce from the crates inventory
		IF EXISTS(SELECT * FROM tempsale WHERE `itemcode` IN(SELECT `productid` FROM `cratesinventorysettings`)) THEN 
			INSERT INTO `cratesinventory` (`productid`,`quantity`,`unitprice`,`dateadded`,`narration`,`reference`,`addedby`)
			SELECT `itemcode`,`quantity`,`unitprice`,NOW(),'Crate Deposit Received.', $receiptno,$userid FROM `tempsale`
			WHERE `itemcode` IN(SELECT `productid` FROM `cratesinventorysettings`);
		END IF;
		
		OPEN tempproductcursor;
			get_temp_product: LOOP
				FETCH tempproductcursor INTO $tempproductid,$tempquantity,$tempunitprice,$tempdiscount,$tempserialno,
				$temptaxid,$temptaxrate,$tempdescription;		
				IF $finished=1 THEN 
					LEAVE get_temp_product;
				END IF;
				
				-- Update stock movement
				/*while $tempquantity>0 do
					select $tempquantity `temquantity`; 
					-- Get stock quantity
					SELECT s.`stockmovementid`,`purchasequantity`-IFNULL(SUM(`salesquantity`),0) available
					into $stockmovementid,$purchasebalance
					FROM `stockmovement` s 
					left outer JOIN `stockmovementsalesdetails` sd ON sd.`stockmovementid`=s.stockmovementid
					JOIN `tempsale` t ON t.`itemcode`=s.`productid`
					LEFT OUTER JOIN `possales` m ON m.`id`=sd.possaleid
					WHERE `refno`=$refno AND ifnull(m.deleted,0)=0 and s.productid=$tempproductid
					GROUP BY  s.stockmovementid
					HAVING available>0
					order by s.stockmovementid limit 1;
					
					IF $tempquantity>0 THEN
						IF $purchasebalance>0 THEN                                                             
							IF $purchasebalance>$tempquantity THEN
								SET $fifoquantity=$tempquantity;
								SET $tempquantity=0;
							ELSE
								SET $fifoquantity=$purchasebalance;
								SET $tempquantity=$tempquantity-$purchasebalance;
							END IF;
							
							INSERT INTO `stockmovementsalesdetails`(`stockmovementid`,`possaleid`,`salesquantity`,`sellingprice`,`taxid`,`taxrate`)
							VALUES($stockmovementid,$id,$fifoquantity,$tempunitprice-$tempdiscount,$temptaxid,$temptaxrate);
						END IF;
					END IF;
				end while;*/
				WHILE $tempquantity > 0 DO
				    -- Ensure purchasebalance is always set to avoid infinite loops
				    SET $purchasebalance = 0;  

				    -- Get stock quantity
				    SELECT s.`stockmovementid`, COALESCE(`purchasequantity`-IFNULL(SUM(`salesquantity`),0), 0) available 
				    INTO $stockmovementid, $purchasebalance
				    FROM `stockmovement` s 
				    LEFT OUTER JOIN `stockmovementsalesdetails` sd ON sd.`stockmovementid`=s.stockmovementid
				    WHERE s.productid=$tempproductid
				    GROUP BY s.stockmovementid
				    HAVING available > 0
				    ORDER BY s.stockmovementid 
				    LIMIT 1;

				    -- Escape the loop if no stock movement is found
				    IF $stockmovementid IS NULL OR $purchasebalance <= 0 THEN 
					LEAVE get_temp_product;
				    END IF;

				    -- FIFO calculation
				    IF $purchasebalance > $tempquantity THEN
					SET $fifoquantity = $tempquantity;
					SET $tempquantity = 0;
				    ELSE
					SET $fifoquantity = $purchasebalance;
					SET $tempquantity = $tempquantity - $purchasebalance;
				    END IF;

				    -- Insert stock movement sales details
				    INSERT INTO `stockmovementsalesdetails`(`stockmovementid`,`possaleid`,`salesquantity`,`sellingprice`,`taxid`,`taxrate`)
				    VALUES ($stockmovementid, $id, $fifoquantity, $tempunitprice - $tempdiscount, $temptaxid, $temptaxrate);
				    
				END WHILE;
			END LOOP get_temp_product;
		CLOSE tempproductcursor;
		
		-- delete the temporary data
		-- DELETE FROM `tempsale` WHERE `refno`=$refno;
		DELETE FROM `temppossalespayment` WHERE `refno`=$refno;
		
		-- get the receipt number
		SELECT $receiptno AS receiptno;
	COMMIT;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveprivileges` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveprivileges`($id int,$category varchar(50),$refno varchar(50),$userid int)
BEGIN
	start transaction;
		if $category='user' then 
			begin
				-- delete all privileges
				delete from `userprivileges` where `userid`=$id;
				-- add the ones from the temp table
				insert into `userprivileges` (`userid`,`objectid`,`allowed`,`addedby`,`lastupdatedby`,`lastdateupdated`)
				select $id,`objectid`,`valid`,$userid,$userid,now() from `tempprivilege` where `refno`=$refno;
			end;
		else
			begin
				-- delete all role privileges
				delete from `roleprivileges` where `roleid`=$id;
				-- add new ones from the temp table
				insert into `roleprivileges`(`roleid`,`objectid`,`allowed`,`dateadded`,`addedby`)
				SELECT $id,`objectid`,`valid`,NOW(),$userid FROM `tempprivilege` WHERE `refno`=$refno; 
			end;
		end if;
		-- Remove temporary data
		delete from `tempprivilege` WHERE `refno`=$refno;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveproduct` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveproduct`($id numeric,$itemcode varchar(50),$itemname varchar(50),$categoryid numeric,$uom varchar(50),
	$buyingprice decimal(18,2),$sellingprice decimal(18,2),$reorderlevel numeric,$userid numeric,$refno varchar(50),
	$generateitemcode bool,$canserialize bool, $bundleitem boolean,$taxtypeid int,$itemlength decimal(18,2),$itemwidth decimal(18,2),$itemheight decimal(18,2),
	$allownegativesales bool,$saleby varchar(50),$bundleproduct int,$allowreturnexchange bool)
BEGIN
	declare $generatedid numeric;
	-- SET @taxrate=(select taxrate from `taxtypes` where `id`=$taxtypeid);
	start transaction;
		
		if $id=0 then 
			-- Check if we are generating item code
			if $generateitemcode=1 then
				-- Generate Item code
				set $itemcode=(select fngenerateproductcode($categoryid));
				-- Increment Counter
				update `categories` set `currentno`=`currentno`+1 where `categoryid`=$categoryid;
			end if;
			insert into `products`(`itemcode`,`itemname`,`unitofmeasure`,`buyingprice`,`sellingprice`,`categoryid`,`dateadded`,`addedby`,`deleted`,`reorderlevel`,`serializable`,
				`bundleitem`,`taxtypeid`,`length`,`width`,`height`,`allownegativesales`,`saleby`,`bundledproduct`,`allowreturnexchange`)
			values($itemcode,$itemname,$uom,$buyingprice,$sellingprice,$categoryid,now(),$userid,0,$reorderlevel,$canserialize,
				$bundleitem,$taxtypeid,$itemlength,$itemwidth,$itemheight,$allownegativesales,$saleby,$bundleproduct,$allowreturnexchange);
			set $id=(SELECT MAX(`productid`) FROM `products`);
		else
			update `products` set `itemcode`=$itemcode,`itemname`=$itemname,`unitofmeasure`=$uom,`buyingprice`=$buyingprice,`sellingprice`=$sellingprice,
			`categoryid`=$categoryid,`reorderlevel`=$reorderlevel ,`lastmodifiedon`=now(),`lastmodifiedby`=$userid , `serializable`=$canserialize, 
			`bundleitem`=$bundleitem,`taxtypeid`=$taxtypeid,`length`=$itemlength,`width`=$itemwidth,`height`=$itemheight,`allownegativesales`=$allownegativesales,
			`saleby`=$saleby,`bundledproduct`=$bundleproduct,`allowreturnexchange`=$allowreturnexchange
			where `productid`=$id;
		end if;
		-- delete existing price matrix
		delete from `customerpricematrix` where `itemid`=$id;
		
		-- insert price matrix
		insert into `customerpricematrix`(`itemid`,`customercategoryid`,`percentage`,`value`)
		SELECT $id,`catid`,`percentage`,`value` FROM `temppricematrix` WHERE `refno`=$refno;
		
		-- delete the temporary price matrix data 
		delete from `temppricematrix` where `refno`=$refno;
		
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavepurchaseorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavepurchaseorder` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavepurchaseorder`($id numeric,$refno varchar(50), $supplierid int,$terms varchar(1000),$category varchar(50),
	$currencyid int,$exchangerate decimal(18,2),$departmentid int,$taxid int,$taxrate decimal(18,2),$userid int)
BEGIN
	DECLARE $purchaseorderno VARCHAR(50);
	DECLARE $orderid NUMERIC;
	
	-- select `taxrate` into $taxrate from `taxtypes` where `id`=$taxid;
	
	if $id=0 then 
		start transaction;
		
			-- generate the purchase order number
			set $purchaseorderno=fngeneratepurchaseorderno();
			
			-- save the purchase order 
			insert into `purchaseorders`(`purchaseorderno`,`date`,`supplierid`,`expecteddate`,`status`,`terms`,`departmentid`,`category`,
				`currencyid`,`exchangerate`,`taxid`,`taxrate`,`addedby`)
			values($purchaseorderno,now(),$supplierid,now(),'Pending',$terms,$departmentid,$category,
				$taxid,$exchangerate,$currencyid,$taxrate,$userid);
		
			-- get the generated order id 
			select   max(`id`) into $orderid  From `purchaseorders`;
		
			-- save the purchase order details
			insert into `purchaseorderdetails`(`purchaseorderid`,`itemcode`,`quanity`,`unitprice`,`taxable`,`taxinclusive`)
			select $orderid,`itemcode`,`quantity`,`unitprice`,`taxable`,`taxinclusive` from `temppurchaseorder` where `refno`=$refno;
		
			-- delete temppurchase order data
			delete from `temppurchaseorder` where `refno`=$refno;
			
			-- increment the serial counter for purchase orders 
			UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Purchase Order';
		
		commit;
	else
		start transaction;
			
			-- delete purchase order details first
			delete from `purchaseorderdetails` where `purchaseorderid`=$id;
			
			-- update purchse order details
			update `purchaseorders` set `supplierid`=$supplierid,`terms`=$terms,`departmentid`=$departmentid,`category`=$category,
			`currencyid`=$currencyid,`exchangerate`=$exchangerate,`lastmodifiedon`=now(),`lastmodifiedby`=$userid,`taxid`=$taxid,
			`taxrate`=$taxrate
			where `id`=$id;
			
			-- insert purchase order details
			
			INSERT INTO `purchaseorderdetails`(`purchaseorderid`,`itemcode`,`quanity`,`unitprice`,`taxable`,`taxinclusive`)
			SELECT $id,`itemcode`,`quantity`,`unitprice`,`taxable`,`taxinclusive` FROM `temppurchaseorder` WHERE `refno`=$refno;
			
			-- delete temporary data
			DELETE FROM `temppurchaseorder` WHERE `refno`=$refno;
			
			-- get purchase order no from the id
			set $purchaseorderno=(select `purchaseorderno` from `purchaseorders` where `id`=$id);
		commit;
	
	end if;
	
	select $purchaseorderno as purchaseorderno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavereturninwards` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavereturninwards` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavereturninwards`($refno varchar(50),$receiptno varchar(50),$userid int,$narration varchar(1000))
BEGIN
	set @possaleid=(select id from `possales` where `receiptno`=$receiptno);
	-- Generate return inwards ref
	set @refno=`fngeneratereturninwardsref`();
	start transaction;
		insert into `returninwards`(`refno`,`possaleid`,`productid`,`serialno`,`quantity`,`dateadded`,`addedby`,`narration`)
		select @refno,@possaleid,`productid`,`serialno`,`quantity`,now(),$userid,$narration from `tempreturns` where `refno`=$refno;
		-- Update reference no generation counter
		update serials set currentno=currentno+1 where `documenttype`='Return Inwards';
		-- Delete temporary data
		delete from `tempreturns` WHERE `refno`=$refno;
		-- Return the generated reference number
		select @refno as referenceno;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavereturninwardscollection` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavereturninwardscollection` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavereturninwardscollection`($id int,$collectedby varchar(50),$userid int)
BEGIN
	update `returninwards` 
	set `collected`=1,`collectedby`=$collectedby,`datecollected`=now(),`issuedby`=$userid
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavereturnoutwards` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavereturnoutwards` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavereturnoutwards`($refno varchar(50),$grnno varchar(50),$narration varchar(1000),$userid int)
BEGIN
    
	set @grnid=(select id from `goodsreceived` where `grnno`=$grnno);
	set @refno=`fngeneratereturnoutwardsref`() ;
	
	start transaction;
		-- Add return outward item(s)
		insert into `returnoutwards`(`refno`,`grnid`,`productid`,`serialno`,`quantity`,`dateadded`,`addedby`,`narration`)
		select @refno,@grnid,`productid`,`serialno`,`quantity`,now(),$userid,$narration from `tempreturns` where `refno`=$refno;
		-- Increment refno generator counter
		update serials set currentno=currentno+1 where documenttype='Return Outwards';
		-- Delete temporary data
		delete from `tempreturns` where refno=$refno;
		-- return the serial number generated
		select @refno as referenceno;
	commit;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavereturnoutwardsreturn` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavereturnoutwardsreturn` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavereturnoutwardsreturn`($id int,$userid int)
BEGIN
	update `returnoutwards` 
	set `delivered`=1,`datedelivered`=now(), `receivedby`=$userid
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaverole` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaverole` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaverole`($roleid int,$rolename varchar(50), $roledescription varchar(50),$userid int)
BEGIN
	if $roleid=0 then
		insert into `roles` (`rolename`,`roledescription`,`deleted`,`addedby`,`dateadded`)
		values($rolename,$roledescription,0,$userid,now());
		set $roleid=(select max(`roleid`) `roleid` from `roles`);
	else
		update `roles` set `rolename`=$rolename,`roledescription`=$roledescription, `lastdatemodified`=now(), `lastmodifiedby`=$userid
		where `roleid`=$roleid;
	end if;
	select $roleid as `roleid`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveroleusers` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveroleusers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveroleusers`($userid int,$roleid int,$addedby int)
BEGIN
	if not exists (select * from `roleusers` where `roleid`=$roleid and `userid`=$userid and ifnull(`deleted`,0)=0) then
		insert into `roleusers`(`roleid`,`userid`,`dateadded`,`addedby`)
		values($roleid,$userid,now(),$addedby);
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavesmslog` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavesmslog` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavesmslog`($mobileno varchar(50),$customerid varchar(50),$message varchar(1000),$messageid varchar(50),$messagestatus varchar(50))
BEGIN
		insert into `smslog`(`mobileno`,`customerid`,`message`,`messageid`,`status`,`datesent`)
		values($mobileno,$customerid,$message,$messageid,$messagestatus,now());
	END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavestockreconciledbalance` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavestockreconciledbalance` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavestockreconciledbalance`($refno varchar(50),$narration varchar(50),
$posid int,$category varchar(50), $userid int)
BEGIN
	start transaction;
		set @reconciliationdate= DATE_FORMAT(CURDATE(), '%Y-%m-01');
		set @basedate=date_add(@reconciliationdate, interval -1 day);
		-- Insert reconciliation header
		insert into `stockreconciledbalance`(`reconciliationdate`,`userid`,`narration`,`posid`,`category`)
		values(@reconciliationdate,$userid,$narration,$posid,$category);
		-- Get the Inserted Id
		set @id=(select max(id) from `stockreconciledbalance`);
		
		-- Insert the reconciliation details
		if $category='outlet' then 				
			insert into `stockreconciledbalancedetails` (`reconciliationid`,`itemid`,`quantity`,`unitprice`)
			select @id, `itemid`,
				case /*when `fn_getitemstorebalance`(itemid,$posid)<0 then
					quantity+abs(`fn_getitemstorebalance`(itemid,$posid))*/
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
				CASE /*when `fn_getitemstorebalance`(itemid,$posid)<0 then
					quantity+abs(`fn_getitemstorebalance`(itemid,$posid))*/
				WHEN `fn_getwarehousestockbalance`(itemid,$posid,@basedate)> `quantity` THEN 
					-1*(`fn_getwarehousestockbalance`(itemid,$posid,@basedate)-`quantity`)
				ELSE
					`quantity`-`fn_getwarehousestockbalance`(itemid,$posid,@basedate)
				END,`unitprice` 
			FROM `tempstockreconcilebalancedetails` WHERE `refno`=$refno;
		END IF;
		-- Remove temporary data 
		DELETE FROM `tempstockreconcilebalancedetails` WHERE `refno`=$refno;
	COMMIT;	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavestocktransfer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavestocktransfer` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavestocktransfer`(
	$refno varchar(50),$sourcetype varchar(50),$sourceid numeric,$destinationtype varchar(50),$destinationid numeric,$userid numeric,
	$issuedto int,$storecontroller int)
BEGIN
	declare $transferrefno varchar(50);
	declare $id numeric;
	
	start transaction;
		-- generate reference number
		set $transferrefno=`fngeneratestocktransaferno`();
		-- save transfer header details
		insert into `stocktransfer`(`referenceno`,`sourcetype`,`sourceid`,`destinationtype`,`destinationid`,`addedby`,`dateadded`,`issuedto`,`storecontroller`)
		values($transferrefno,$sourcetype,$sourceid,$destinationtype,$destinationid,$userid,now(),$issuedto,$storecontroller);
		-- get the mpost recently inserted id
		set $id=(select max(`id`) from `stocktransfer`);
		-- save transfer items details
		insert into `stocktransferdetails`(`transferid`,`itemcode`,`quantity`,`unitprice`,`serialno`)
		select $id,`itemcode`,sum(`quantity`) as quantity,`unitprice`,`serialno` 
		from `tempstocktransfer` where `refno`=$refno 
		group by $id,`itemcode`,`unitprice`,`serialno`;
		-- increment counter
		update `serials` set `currentno`=`currentno`+1 where `documenttype`='Stock Transfer';
		-- delete temporary data
		delete from `tempstocktransfer` where `refno`=$refno;
		-- return reference number generated
		select  $transferrefno as transfercode;		
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavesupplier` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavesupplier` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavesupplier`($supplierid int,$suppliername varchar(50),$physicaladdress varchar(100),$postaladdress varchar(100),$creditlimit numeric,
    $mobile varchar(50),$email varchar(50),$supplierpinno varchar(50),$userid numeric)
BEGIN
	if $supplierid=0 then 
		insert into `suppliers`(`suppliername`,`physicaladdress`,`postaladdress`,`creditlimit`,`mobile`,`email`,`dateadded`,`addedby`,`deleted`,`supplierpinno`)
		values($suppliername,$physicaladdress,$postaladdress,$creditlimit,$mobile,$email,now(),$userid,0,$supplierpinno);
	else
		update `suppliers` set `suppliername`=$suppliername,`physicaladdress`=$physicaladdress,`postaladdress`=$postaladdress,`creditlimit`=$creditlimit,
		`mobile`=$mobile,`email`=$email, `lastdatemodified`=now(), `lastmodifiedby`=$userid,`supplierpinno`=$supplierpinno
		where `supplierid`=$supplierid;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavesupplierinvoice` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavesupplierinvoice` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavesupplierinvoice`($refno varchar(50),$invoiceno varchar(50),$supplierid int,$invoicedate datetime,$userid int)
BEGIN
	declare $id int;
	declare $inventoryaccount int;
	declare $suppliercontrolaccount int;
	declare $suppliername varchar(100);
	declare $description varchar(1000);
	declare $total numeric(10,2);
	
	start transaction;
		
		set $suppliername=(select `suppliername` from `suppliers` where `supplierid`=$supplierid);
		
		set $description=concat('Invoice #',$invoiceno,' received from ',$suppliername);
		
		-- select concat('The refno is:' ,$refno) as refno;
		
		
		set $total=(SELECT sum(g.`quantity`* pod.`unitprice`) FROM `tempsupplierinvoice` t, `products` p,
		`goodsreceiveddetails` g, `purchaseorders` po, `purchaseorderdetails` pod
		WHERE g.`grnno`=t.`grnno` AND g.`itemcode`=p.`productid` AND g.`purchaseorderno`=po.`purchaseorderno` AND po.`id`=pod.`purchaseorderid`
		AND p.productid=pod.itemcode AND t.refno=$refno);
		
		set $suppliercontrolaccount=(select `id` from `glaccounts` where `accountcode`=(select `account` from `glaccountsettings` where `description`='Suppliers Control Account'));
		
		set $inventoryaccount=(SELECT `id` FROM `glaccounts` WHERE `accountcode`=(SELECT `account` FROM `glaccountsettings` WHERE `description`='Cost of Goods Sold'));
		-- select concat('Total for invoice #',$invoiceno, ' is ',$total);
		-- save the invoice
		insert into `supplierinvoice`(`supplierid`,`invoiceno`,`invoicedate`,`addedby`,`dateadded`)
		values($supplierid,$invoiceno,$invoicedate,$userid,now());
		-- get invoice id
		set $id=(select max(`id`) from `supplierinvoice`); -- LAST_INSERT_ID('supplierinvoice');-- 
		-- add invoice details
		insert into `supplierinvoicedetails`(`invoiceid`,`referenceno`,`itemcode`,`description`,`quantity`,`unitprice`)
		SELECT $id,g.`grnno`,g.`itemcode`, p.`itemname`, g.`quantity`, pod.`unitprice` FROM `tempsupplierinvoice` t, `products` p,
		`goodsreceiveddetails` g, `purchaseorders` po, `purchaseorderdetails` pod
		WHERE g.`grnno`=t.`grnno` AND g.`itemcode`=p.`productid` AND g.`purchaseorderno`=po.`purchaseorderno` AND po.`id`=pod.`purchaseorderid`
		AND p.productid=pod.itemcode AND t.refno=$refno;
		-- update grn used
		update `goodsreceived` set `invoiced`=1, `invoiceno`=$id, `status`='Invoiced' where `grnno` in(select grnno from `tempsupplierinvoice` where `refno`=$refno);
		-- post gl entries
		-- Credit suppliers control account
		insert into `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		values($invoiceno,now(),$suppliercontrolaccount, $inventoryaccount, $description,0,$total,$userid) ;
		-- Debit Inventory
		INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		VALUES($invoiceno,NOW(), $inventoryaccount,$suppliercontrolaccount, $description,$total,0,$userid) ;
		-- delete temp data
		delete from `tempsupplierinvoice` where `refno`=$refno;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavesupplierproduct` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavesupplierproduct` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavesupplierproduct`($supplierid int,$productid int,$userid int)
BEGIN
	if not exists(select * from `supplierproducts` where `supplierid`=$supplierid and `productid`=$productid and `deleted`=0) then 
		insert into `supplierproducts`(`supplierid`,`productid`,`addedby`,`dateadded`,`deleted`)
		values($supplierid,$productid,$userid,now(),0);
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempbanking` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempbanking` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempbanking`($refno varchar(50),$receiptno varchar(50),$reference varchar(50),$amount decimal(10,2),$customername varchar(50),$id int)
BEGIN
	insert into `tempbanking`(`refno`,`receiptno`,`reference`,`amount`,`customername`,`id`)
	values($refno,$receiptno,$reference,$amount,$customername,$id);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempcreditnotedetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempcreditnotedetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempcreditnotedetails`($refno varchar(50),$itemcode varchar(50),$quantity numeric, $unitprice numeric)
BEGIN
	DECLARE $itemid INT;
	SET $itemid=(SELECT `productid` FROM `products` WHERE `itemcode`=$itemcode);
	insert into `tempcreditnote`(`refno`,`itemcode`,`quantity`,`unitprice`)
	values($refno,$itemid,$quantity,$unitprice);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempcustomerinvoice` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempcustomerinvoice` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempcustomerinvoice`($refno varchar(50),$grnno varchar(50))
BEGIN
	insert into `tempcustomerinvoice`(`refno`,`grnno`)
	values($refno,$grnno);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempgltransaction` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempgltransaction` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempgltransaction`($refno varchar(50),$glaccount int, $glcontraaccount int, $narration varchar(500),$debit float,$credit float)
BEGIN
	insert into `tempgltransaction`(`refno`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`)
	values($refno,$glaccount,@contraaccount,$narration,$debit,$credit);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempgoodsreceived` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempgoodsreceived` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempgoodsreceived`($refno varchar(50),$pono varchar(50),$itemcode int,$quantity decimal(11,2),$serialno varchar(50))
BEGIN
	-- declare $itemid int;
	-- set $itemid=(select `productid` from `products` where `itemcode`=$itemcode);
	insert into `tempgoodsreceived`(`refno`,`purchaseorderno`,`itemcode`,`quantity`,`serialno`)
	values($refno,$pono,$itemcode,$quantity,$serialno);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempjournaldetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempjournaldetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempjournaldetails`($refno varchar(50),$glaccount int,$narration varchar(100),$debit float,$credit float)
BEGIN
	insert into `tempjournaldetails`(`refno`,`glaccount`,`narration`,`debit`,`credit`)
	values($refno,$glaccount,$narration,$debit,$credit);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetemppossalepayment` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetemppossalepayment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetemppossalepayment`($refno varchar(50),$paymentmode int,$referenceno varchar(50), $amount decimal(18,2))
BEGIN	
	insert into `temppossalespayment`(`refno`,`paymentmodeid`,`reference`,`amount`)
	values($refno,$paymentmode,$referenceno,$amount);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetemppricematrix` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetemppricematrix` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetemppricematrix`($refno varchar(50),$catid numeric,$percentage bit,$val numeric)
BEGIN
	insert into `temppricematrix`(`refno`,`catid`,`percentage`,`value`)
	values($refno,$catid,$percentage,$val);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempprivilege` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempprivilege`($refno varchar(50),$id int, $objectid int,$valid bit)
BEGIN
	insert into `tempprivilege`(`refno`,`id`,`objectid`,`valid`)
	values($refno,$id,$objectid,$valid);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetemppurchaseorderitem` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetemppurchaseorderitem` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetemppurchaseorderitem`($refno varchar(50),$itemcode varchar(50),$quantity decimal(18,2),$unitprice decimal(18,2),
	$taxable int,$taxinclusive int)
BEGIN
	declare $itemid int;
	set $itemid=(select `productid` from `products` where `itemcode`=$itemcode);
	insert into `temppurchaseorder`(`refno`,`itemcode`,`quantity`,`unitprice`,`taxable`,`taxinclusive`)
	values($refno,$itemid,$quantity,$unitprice,$taxable,$taxinclusive);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempreconcilebalancedetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempreconcilebalancedetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempreconcilebalancedetails`($refno varchar(50),$itemid int,$quantity numeric(18,2),$unitprice numeric(18,2))
BEGIN
	insert into `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
	values($refno,$itemid,$quantity,$unitprice);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempreturns` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempreturns` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempreturns`($refno varchar(50),$productid varchar(50),$serialno varchar(50),$quantity numeric(18,2))
BEGIN
	insert into `tempreturns`(`refno`,`productid`,`quantity`,`serialno`)
	values($refno,$productid,$quantity,$serialno);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempsale` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempsale` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempsale`($refno varchar(50),$itemcode varchar(50),$quantity decimal(10,2),$unitprice decimal(10,2),
	$discount decimal(10,2),$serialno varchar(50),$description varchar(500))
BEGIN
	DECLARE $itemid INT;
	declare $taxtypeid int;
	declare $taxrate numeric(18,2);
	SET $itemid=(SELECT `productid` FROM `products` WHERE `itemcode`=$itemcode);
	SET $taxtypeid=(SELECT `taxtypeid` FROM `products` WHERE `itemcode`=$itemcode);
	SET $taxrate=(SELECT `taxrate` FROM `taxtypes` WHERE `id`=$taxtypeid);
	insert into `tempsale`(`refno`,`itemcode`,`unitprice`,`discount`,`quantity`,`serialno`,`taxtypeid`,`taxrate`,`description`)
	values($refno,$itemid,$unitprice,$discount,$quantity,$serialno,$taxtypeid,$taxrate,$description);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempstocktransfer` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempstocktransfer` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempstocktransfer`($refno varchar(50),$itemcode varchar(50),$unitprice numeric(10,2),$quantity numeric(10,2),$serialno varchar(50))
BEGIN
	DECLARE $itemid INT;
	SET $itemid=(SELECT `productid` FROM `products` WHERE `itemcode`=$itemcode);
	insert into `tempstocktransfer`(`refno`,`itemcode`,`quantity`,`unitprice`,`serialno`)
	values($refno,$itemid,$quantity,$unitprice,$serialno);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetempsupplierinvoice` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetempsupplierinvoice` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetempsupplierinvoice`($refno varchar(50),$grnno varchar(50))
BEGIN
	insert into `tempsupplierinvoice`(`refno`,`grnno`)
	values($refno,$grnno);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavetepmpaymentvoucherdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavetepmpaymentvoucherdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsavetepmpaymentvoucherdetails`($branchid int, $refno varchar(50),$itemcode varchar(50),$description varchar(500),$quantity decimal(10,3),$unitprice decimal(10,2),$accountcharged int,$invoicenumber varchar(50))
BEGIN
	INSERT INTO `temppaymentvoucherdetails`(`branchid`,`refno`,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber`)
	VALUES($branchid,$refno,$itemcode,$description,$quantity,$unitprice,$accountcharged,$invoicenumber);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveuser` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveuser`($userid int,$userpassword varchar(50),$systemadmin bit,$username varchar(50),$firstname varchar(50),$middlename varchar(50),$lastname varchar(50),
	$email varchar(50),$mobile varchar(50),$changepasswordonlogon bit,$accountactive bit,$addedby int)
BEGIN
	if $userid=0 then 
		-- begin
			insert into `user`(`username`,`password`,`firstname`,`middlename`,`lastname`,`email`,`mobile`,`changepasswordonlogon`,`accountactive`,`addedby`,`dateadded`,systemadmin)
			values($username,$userpassword,$firstname,$middlename,$lastname,$email,$mobile,$changepasswordonlogon,$accountactive,$addedby,now(),$systemadmin);
			set $userid=(select max(`id`) from `user`);
		-- end
	else
		update `user` set `username`=$username,`firstname`=$firstname,`middlename`=$middlename,`lastname`=$lastname,`email`=email,`mobile`=$mobile,
		`changepasswordonlogon`=$changepasswordonlogon,/*`accountactive`=$accountactive,*/`systemadmin`=$systemadmin,`lastmodifiedby`=$addedby,`lastmodifiedon`=NOW()
		WHERE `id`=$userid;
	END IF;
	
	SELECT $userid AS `userid`;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveuseroutlet` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveuseroutlet` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveuseroutlet`($userid int,$outletid int,$addedby int)
BEGIN
	
	if not exists(select * from `useroutlets` where `userid`=$userid and `outletid`=$outletid) then
		insert into `useroutlets`(`userid`,`outletid`,`dateadded`,`addedby`,`deleted`)
		values($userid,$outletid,now(),$addedby,0);
	else
		update `useroutlets` set `deleted`=0,`lastdatemodified`=now(),`lastmodifiedby`=$addedby
		where `userid`=$userid AND `outletid`=$outletid;
	end if;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsaveuserprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsaveuserprivilege` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spsaveuserprivilege`($userid int,$objectid int,$allowed bit,$useradding int)
BEGIN
	if not exists(select * from `userprivileges` where `objectid`=$objectid and `userid`=$userid) then
		insert into `userprivileges`(`objectid`,`userid`,`allowed`,`dateadded`,`addedby`)
		values($objectid,$userid,$allowed,now(),$useradding);
	else
		update `userprivileges` set `allowed`=$allowed, `lastdateupdated`=now(),`lastupdatedby`=$useradding 
		WHERE `objectid`=$objectid AND `userid`=$userid;
	end if ;
		
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sptempsavecustomerreceiptdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sptempsavecustomerreceiptdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sptempsavecustomerreceiptdetails`($refno varchar(50),$possaleid numeric,$amount numeric)
BEGIN
	insert into `tempcustomerreceiptdetails`(`refno`,`possaleid`,`amount`)
	values($refno,$possaleid,$amount);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spvalidateuserprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `spvalidateuserprivilege` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `spvalidateuserprivilege`(`$userid` INT, `$objectid` INT)
BEGIN
	declare $admin int;
	declare $valid int default 0;
	set $admin=(select systemadmin from `user` where `id`=$userid);
	if $admin=1 then
		set $valid=1;
	else
		set $valid=ifnull((select `allowed` from `userprivileges` where `userid`=$userid and `objectid`=$objectid),0);
	end if;
	
	select $valid as `allowed`;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_activatesession` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_activatesession` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_activatesession`($sessionfloat decimal(18,2), $userid int)
BEGIN
		insert into  `sessions`(`starttime`,`addedby`,`dateadded`,`floatamount`)
		values(now(),$userid,date_format(now(),'%Y-%m-%d'),$sessionfloat);
		
		select max(`sessionid`) sessionid 
		FROM `sessions`;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_approvepurchaseorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_approvepurchaseorder` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_approvepurchaseorder`($pono varchar(50),$approvallevelid int,$userid int,$narration varchar(500))
BEGIN
    
	set @poid=(select id from `purchaseorders` where `purchaseorderno`=$pono);
	
	insert into `purchaseorderapproval`(`poid`,`approvallevelid`,`approvaluser`,`approvaldate`,`narration`)
	values(@poid,$approvallevelid,$userid,now(),$narration);
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_cancelcustomerorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_cancelcustomerorder` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_cancelcustomerorder`($orderid int,$reason varchar(1000),$userid int)
BEGIN
		update `customerorders`
		set `status`='Cancelled',`datecancelled`=now(),`reasoncancelled`=$reason
		where `orderid`=$orderid;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkcustomercontact` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkcustomercontact` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_checkcustomercontact`($id int, $customerid int,$contactname varchar(50))
BEGIN
	select * 
	from `customercontacts` 
	where `id`!=$id and `customerid`=$customerid and `contactname`=$contactname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkdepartment` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkdepartment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_checkdepartment`($id int,$departmentname varchar(50))
BEGIN
	select * from departments  where `departmentname`=$departmentname and `id`<>$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkfleetvehicleregno` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkfleetvehicleregno` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_checkfleetvehicleregno`(`$vehicleid` INT, `$regno` VARCHAR(50))
BEGIN
	select * from `fleetvehicles` where `vehicleid`<>$vehicleid and `regno`=$regno;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkrawmaterial` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkrawmaterial` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_checkrawmaterial`($id int,$materialname varchar(50))
BEGIN
	select * from `rawmaterials` 
	where `materialid`<>$id and `materialname`=$materialname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checksessionid` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checksessionid` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_checksessionid`()
BEGIN
		select * from `sessions` where `status`='active';
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checktable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checktable` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_checktable`($tableid int,$posid int,$tablename varchar(50))
BEGIN
		select * 
		from `tables`
		where `tableid`!=$tableid and `posid`=$posid and `tablename`=$tablename and `deleted`=0;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkuserprivilegewithcode` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkuserprivilegewithcode` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_checkuserprivilegewithcode`($userid int,$objectcode varchar(50))
BEGIN
		-- Check if system administrator
		if exists(select * from `user` where `id`=$userid and `systemadmin`=1) then 
			select 1 allowed;
		-- Check if user has a role that was assined the privilege
		elseif exists(select * from `roleprivileges` r 
			join `objects` b on b.`id`=r.`objectid`
			join `roleusers` ru on ru.`roleid`=r.`roleid` 
			where ru.userid=$userid and `allowed`=1 and b.code=$objectcode) then 
				select 1 allowed;
		-- Check if user has privileges directly
		elseif exists(Select * from `userprivileges` p 
			join `objects` o on o.`id`=p.`objectid`
			where p.`userid`=$userid and o.`code`=$objectcode and `allowed`=1) then 
				select 1 allowed;
		-- User does not have the privileges
		else
			select 0 allowed;
		end if;	
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_checkzone` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_checkzone` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_checkzone`($id int,$zonename varchar(50))
BEGIN
	select * from `zones` where `id`<>$id and `zonename`=$zonename;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_closesession` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_closesession` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_closesession`($userid int)
BEGIN
		update `sessions`
		set `status`='closed',`closedby`=$userid, `dateclosed`=now()
		where `status`='active';
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletecustomercontact` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletecustomercontact` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_deletecustomercontact`($id int, $userid int)
BEGIN
	update `customercontacts` 
	set `deleted`=1, `datedeleted`=now(), `deletedby`=$userid
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletedepartment` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletedepartment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_deletedepartment`($id int)
BEGIN
	update `departments` set deleted=1 where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deleterawmaterial` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deleterawmaterial` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_deleterawmaterial`($materialid int,$userid int)
BEGIN
	update `rawmaterials` 
	set `deleted`=1,`datedeleted`=now(),`deletedby`=$userid
	where `materialid`=$materialid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletetable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletetable` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_deletetable`($tableid int,$userid int)
BEGIN
		update `tables`
		set `deleted`=1,`deletedby`=$userid, `datedeleted`=now()
		where `tableid`=$tableid;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_deletezone` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_deletezone` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_deletezone`($id int,$userid int)
BEGIN
	update `zones` set `deleted`=1,`datedeleted`=now(),`deletedby`=$userid
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filtercustomerorders` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filtercustomerorders` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_filtercustomerorders`($customerid int,$tableid int,$posid int,
$waiterid int,$startdate date,$enddate date,$orderstatus varchar(50))
BEGIN
		if $posid=0 then 
			if $customerid=0 then
				if $tableid=0 then
					if $waiterid=0 then 
						if $orderstatus='0' then 
							SELECT c.orderid,`orderno`,posname,r.customername,tablename,sum(quantity*unitprice) ordertotal,
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
							WHERE date_format(c.`dateadded`,'%Y-%m-%d') between $startdate and $enddate
							group by orderno
							ORDER BY orderno;
						else
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
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and c.status=$orderstatus
							GROUP BY orderno
							ORDER BY orderno;
						end if;
					else
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
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and c.waiterid=$waiterid
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
					end if;
				else
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
							WHERE DATE_FORMAT(c.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and c.tableid=$tableid
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
				end if;
			else
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
							and c.customerid=$customerid
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
			end if;
		else
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
							and c.posid=$posid
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
		end if;		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filterfleetrequisitions` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filterfleetrequisitions` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_filterfleetrequisitions`(`$supplierid` INT, `$costcenterid` INT, `$vehicleid` INT, `$startdate` DATE, `$enddate` DATE)
BEGIN
	if $supplierid=0 then
		if $costcenterid=0 then
			if $vehicleid=0 then 
				select r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded, `requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, case when `dateapproved` is null then 'Pending' else 'Approved' end as `status`
				from `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				where r.supplierid=s.supplierid and r.`costcenterid`=p.id and r.vehicleid=v.vehicleid 
				and date_format(r.`dateadded`,'%Y-%m-%d') between $startdate and $enddate 
				order by `requisitionno` desc;
			else
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and r.vehicleid=$vehicleid
				ORDER BY `requisitionno` DESC;
			end if;
		else
			IF $vehicleid=0 THEN 
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate and r.costcenterid=$costcenterid
				ORDER BY `requisitionno` DESC;
			ELSE
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid 
				AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND r.vehicleid=$vehicleid AND r.costcenterid=$costcenterid
				ORDER BY `requisitionno` DESC;
			END IF;
		end if;
	else
		IF $costcenterid=0 THEN
			IF $vehicleid=0 THEN 
				SELECT r.id,DATE_FORMAT(r.`dateadded`,'%d-%b-%Y')dateadded,`requisitionno`,`suppliername`,`posname`,`regno` vehiclename, quantity, quantity,unitprice unitprice, 
				unitprice*quantity total, CASE WHEN `dateapproved` IS NULL THEN 'Pending' ELSE 'Approved' END AS `status`
				FROM `fleetfuelrequisition` r, suppliers s, pointsofsale p, fleetvehicles v
				WHERE r.supplierid=s.supplierid AND r.`costcenterid`=p.id AND r.vehicleid=v.vehicleid and r.supplierid=$supplierid
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
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filtergoodsreceivednotes` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filtergoodsreceivednotes` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_filtergoodsreceivednotes`($supplierid int,$startdate date,$enddate date,$grnno varchar(50),$deliverynoteno varchar(50))
BEGIN
	if $supplierid=0 then
		SELECT g.`id` receiptid, `warehouseid`, w.`description` warehousename,s.`supplierid`,`suppliername`,g.`grnno`, 
		DATE_FORMAT(`datereceived`,'%d-%b-%Y') datereceived,CONCAT(u.`firstname`,' ',u.`middlename`,' ',u.`lastname`) receivedbyname,
		CONCAT(i.`firstname`,' ',i.`middlename`,' ',i.`lastname`)inspectedbyname,`deliverynono`,SUM(gd.`quantity`*pd.unitprice) total
		FROM `goodsreceived` g INNER JOIN `goodsreceiveddetails` gd ON g.`grnno`=gd.`grnno`
		INNER JOIN `suppliers` s ON s.`supplierid`=g.`supplierid`
		INNER JOIN `warehouses` w ON w.`id`=g.`warehouseid`
		INNER JOIN `user` u ON u.`id`=g.`receivedby`
		INNER JOIN `user` i ON i.id=g.`inspectedby`
		INNER JOIN `purchaseorders` p ON p.`purchaseorderno`=gd.`purchaseorderno`
		INNER JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid`=p.`id`
		where (DATE_FORMAT(datereceived,'%Y-%m-%d') BETWEEN $startdate AND $enddate)  and 
		g.grnno like concat('%',$grnno,'%') and deliverynono like concat('%',$deliverynoteno,'%')
		GROUP BY g.`id`, `warehouseid`, w.`description`,s.`supplierid`,`suppliername`,g.`grnno`
		ORDER BY g.grnno DESC;
	else
		SELECT g.`id` receiptid, `warehouseid`, w.`description` warehousename,s.`supplierid`,`suppliername`,g.`grnno`, 
		DATE_FORMAT(`datereceived`,'%d-%b-%Y') datereceived,CONCAT(u.`firstname`,' ',u.`middlename`,' ',u.`lastname`) receivedbyname,
		CONCAT(i.`firstname`,' ',i.`middlename`,' ',i.`lastname`)inspectedbyname,`deliverynono`,SUM(gd.`quantity`*pd.unitprice) total
		FROM `goodsreceived` g INNER JOIN `goodsreceiveddetails` gd ON g.`grnno`=gd.`grnno`
		INNER JOIN `suppliers` s ON s.`supplierid`=g.`supplierid`
		INNER JOIN `warehouses` w ON w.`id`=g.`warehouseid`
		INNER JOIN `user` u ON u.`id`=g.`receivedby`
		INNER JOIN `user` i ON i.id=g.`inspectedby`
		INNER JOIN `purchaseorders` p ON p.`purchaseorderno`=gd.`purchaseorderno`
		INNER JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid`=p.`id`
		WHERE (DATE_FORMAT(datereceived,'%Y-%m-%d') BETWEEN $startdate AND $enddate)  AND 
		g.grnno LIKE CONCAT('%',$grnno,'%') AND deliverynono LIKE CONCAT('%',$deliverynoteno,'%') and supplierid=$supplierid
		GROUP BY g.`id`, `warehouseid`, w.`description`,s.`supplierid`,`suppliername`,g.`grnno`
		ORDER BY g.grnno DESC; 
	end if;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filterspoilage` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filterspoilage` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_filterspoilage`(`$startdate` DATE, `$enddate` DATE, `$categoryid` INT, `$productid` INT)
BEGIN
	if $categoryid=0 then
		if $productid=0 then
			SELECT s.id, s.`categoryid`, s.`productid`, sc.`categoryname`,p.`itemcode`, p.`itemname`,`quantity`,`narration`,DATE_FORMAT(s.`dateadded`,'%d-%b-%Y') dateadded,
			CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedby
			FROM `spoilage` s, `products` p, `spoilagecategory` sc, `user` u
			WHERE s.`productid`=p.`productid` AND s.`categoryid`=sc.`id` AND s.`addedby`=u.`id` 
			and date_format(s.dateadded,'%Y-%m-%d') between $startdate and $enddate
			order by s.id desc;
		else 
			SELECT s.id, s.`categoryid`, s.`productid`, sc.`categoryname`,p.`itemcode`, p.`itemname`,`quantity`,`narration`,DATE_FORMAT(s.`dateadded`,'%d-%b-%Y') dateadded,
			CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedby
			FROM `spoilage` s, `products` p, `spoilagecategory` sc, `user` u
			WHERE s.`productid`=p.`productid` AND s.`categoryid`=sc.`id` AND s.`addedby`=u.`id` 
			AND DATE_FORMAT(s.dateadded,'%Y-%m-%d') BETWEEN $startdate AND $enddate and s.productid=$productid
			ORDER BY s.id DESC;
		end if;
	else
		IF $productid=0 THEN
			SELECT s.id, s.`categoryid`, s.`productid`, sc.`categoryname`,p.`itemcode`, p.`itemname`,`quantity`,`narration`,DATE_FORMAT(s.`dateadded`,'%d-%b-%Y') dateadded,
			CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedby
			FROM `spoilage` s, `products` p, `spoilagecategory` sc, `user` u
			WHERE s.`productid`=p.`productid` AND s.`categoryid`=sc.`id` AND s.`addedby`=u.`id` 
			AND DATE_FORMAT(s.dateadded,'%Y-%m-%d') BETWEEN $startdate AND $enddate and s.categoryid=$categoryid
			ORDER BY s.id DESC;
		ELSE 
			SELECT s.id, s.`categoryid`, s.`productid`, sc.`categoryname`,p.`itemcode`, p.`itemname`,`quantity`,`narration`,DATE_FORMAT(s.`dateadded`,'%d-%b-%Y') dateadded,
			CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedby
			FROM `spoilage` s, `products` p, `spoilagecategory` sc, `user` u
			WHERE s.`productid`=p.`productid` AND s.`categoryid`=sc.`id` AND s.`addedby`=u.`id` 
			AND DATE_FORMAT(s.dateadded,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND s.productid=$productid and s.categoryid=$categoryid
			ORDER BY s.id DESC;
		END IF;
	end if;	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_fleetapprovefuelrequisition` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_fleetapprovefuelrequisition` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_fleetapprovefuelrequisition`(`$id` INT, `$userid` INT)
BEGIN
	update `fleetfuelrequisition` set `approvedby`=$userid, `dateapproved`=now()
	where `id`=$id;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcontactscategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcontactscategories` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getcontactscategories`()
BEGIN
	select * 
	from `contactscategories` 
	order by `description`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcratesummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcratesummary` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getcratesummary`(`$enddate` DATE)
BEGIN
	set @productid=(select productid from `cratesinventorysettings`);
	SET @basedate=DATE_FORMAT(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters`),'2020-01-01'),'%Y-%m-%d');
	SET @enddate=$enddate;
	SET @obdate=DATE_SUB(@enddate, INTERVAL 1 DAY);
	SELECT `itemcode` `Product Code`,`itemname` `Product Name`,
		IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
			WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d') BETWEEN @basedate AND @obdate),0)-
		IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
			WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN @basedate AND @obdate AND IFNULL(s.deleted,0)=0),0) AS `openingbalance`,
		
		IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
			WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d')=@enddate),0)+
			-- Add crate refunds	for the date
		ifnull((select sum(quantity) from `cratesinventory` where `narration`='Crate deposit refund' and date_format(`dateadded`,'%Y-%m-%d')=@enddate),0)
		AS `purchases` ,
		
		IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
			WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d')=@enddate AND IFNULL(s.deleted,0)=0),0) AS `sales`,
			
		IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
			WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d') BETWEEN @basedate AND @obdate),0)-
		IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
			WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN @basedate AND @obdate  AND IFNULL(s.deleted,0)=0),0) +
		
		IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd 
			WHERE g.`grnno`=gd.grnno AND gd.`itemcode`=p.productid AND DATE_FORMAT(g.`datereceived`,'%Y-%m-%d')=@enddate),0) +
			-- Add crate refunds	for the date
		IFNULL((SELECT SUM(quantity) FROM `cratesinventory` WHERE `narration`='Crate deposit refund' AND DATE_FORMAT(`dateadded`,'%Y-%m-%d')=@enddate),0)
			-- Less crate sales for the date
		-
		
		IFNULL((SELECT SUM(`quantity`) FROM `possales` s, `possalesdetails` sd 
			WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND  DATE_FORMAT(`receiptdate`,'%Y-%m-%d')=@enddate AND IFNULL(s.deleted,0)=0),0) AS `closingbalance`
	FROM products p	where p.productid=@productid; -- ORDER BY itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcurrencies` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcurrencies` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getcurrencies`()
BEGIN
	select * from currencies 
	order by `default` desc, `currencyname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcustomercontacts` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcustomercontacts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getcustomercontacts`($customerid int)
BEGIN
	select c.*, t.description categoryname, concat(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname
	from `user` u, `customercontacts` c, `contactscategories` t
	where c.`categoryid`=t.`id` and c.`addedby`=u.`id` and ifnull(c.deleted,0)=0
	and `customerid`=$customerid
	order by contactname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getcustomerorderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getcustomerorderdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getcustomerorderdetails`($orderno varchar(50))
BEGIN
		select `orderno`,posname,r.customername,tablename, 
		concat(w.firstname,' ',w.middlename,' ',w.lastname) waitername,
		concat(u.firstname,' ',u.middlename,' ',u.lastname) username,
		DATE_FORMAT(c.dateadded, '%d-%b-%Y %H:%i') orderdate,
		itemcode, itemname,sum(quantity) quantity,unitprice
		from `customerorders` c
		join `customerorderdetails` cd on cd.`orderid`=c.`orderid`
		join `products` p on p.productid=cd.productid
		join `tables` t on t.tableid=c.tableid
		join `pointsofsale` s on s.id=c.posid
		join `user` w on w.id=c.waiterid
		join `user` u on u.id=c.`addedby`
		join `customers` r on r.`customerid`=c.customerid
		where c.orderno=$orderno
		group by itemcode
		order by p.itemname;
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getdefaultterms` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getdefaultterms` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getdefaultterms`()
BEGIN
	select * from `defaultterms`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getdepartmentdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getdepartmentdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getdepartmentdetails`($id int)
BEGIN
	select * from `departments` where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getdepartments` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getdepartments` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getdepartments`()
BEGIN	
	select d.* ,date_format(d.`dateadded`,'%d-%b-%Y') addedon, concat(u.`firstname`,' ',u.`middlename`,' ',u.`lastname`) addedbyname,
	concat(h.`firstname`,' ',h.`middlename`,' ',h.`lastname`) hodname
	from `departments`  d
	inner join  `user` u on d.`addedby`=u.id
	left outer join `user` h on  h.id=d.hodid
	where ifnull(`deleted`,0)=0 
	order by `departmentname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getemailconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getemailconfiguration` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getemailconfiguration`()
BEGIN
	select * from `emailconfiguration`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetbodytypes` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetbodytypes` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getfleetbodytypes`()
BEGIN
	select * from `fleetbodytypes` where ifnull(deleted,0)=0
	order by description;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetfueltypes` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetfueltypes` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getfleetfueltypes`()
BEGIN
	select * from `fleetfueltypes` where ifnull(deleted,0)=0
	order by description;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetrequisitiondetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetrequisitiondetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getfleetrequisitiondetails`(`$id` INT)
BEGIN
	select * from `fleetfuelrequisition` where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetrequisitionheaderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetrequisitionheaderdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getfleetrequisitionheaderdetails`(`$requisitionno` VARCHAR(50))
BEGIN
		SELECT `requisitionno`, DATE_FORMAT(r.`dateadded`,'%d-%b-%Y') requisitiondate, `regno`, `odoreading`, `posname`, s.`suppliername`,s.postalcode,s.town,
		s.`physicaladdress`,s.`postaladdress`,s.`email`,CONCAT(u.`firstname`,' ',u.`middlename`,' ',u.`lastname`) AS preparedby,
		`quantity`,`unitprice`,t.`description` AS fueltype,
		CONCAT(a.`firstname`,' ',a.`middlename`,' ',a.`lastname`) AS approvedby,
		CONCAT(q.`firstname`,' ',q.`middlename`,' ',q.`lastname`) AS requestedby
		FROM  `fleetfuelrequisition` r, `pointsofsale` p, `suppliers` s, `fleetvehicles` v, `user` u, `fleetfueltypes` t, `user` a, `user` q
		WHERE r.`supplierid`=s.supplierid AND r.`costcenterid`=p.id AND  r.`vehicleid`=v.vehicleid AND r.addedby=u.id
		AND r.approvedby=a.id AND r.requestedby=q.id AND t.`id`=v.`fueltypeid` and r.requisitionno=$requisitionno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getfleetvehicles` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getfleetvehicles` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getfleetvehicles`()
BEGIN
	select v.*, f.description as fueltype, b.description as bodytype , concat(firstname,' ',lastname) addedbyname
	from `fleetvehicles` v, `fleetfueltypes` f, `fleetbodytypes` b, `user` u
	where   v.`fueltypeid`=f.id and v.`bodytypeid`=b.id and v.addedby=u.id
	and ifnull(v.`deleted`,0)=0
	order by `regno`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getgrndetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getgrndetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getgrndetails`($grnno varchar(50))
BEGIN
		select p.`purchaseorderno`,r.itemcode, r.itemname, r.unitofmeasure,gd.quantity, pd.unitprice, gd.quantity*pd.unitprice linetotal
		from `goodsreceiveddetails` gd
		inner join `purchaseorders` p on p.`purchaseorderno`=gd.`purchaseorderno`
		inner join `purchaseorderdetails` pd on pd.`purchaseorderid`=p.`id`
		inner join `products` r on r.`productid`=gd.`itemcode` and r.productid=pd.`itemcode`
		where gd.grnno=$grnno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getgrnheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getgrnheader` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getgrnheader`($grnno varchar(100))
BEGIN
		select w.description as warehousename,suppliername, `physicaladdress`,`postaladdress`,s.`postalcode`,s.`town`,s.`mobile`,s.`email`,
		`grnno`,date_format(`datereceived`,'%d-%b-%Y %H:%i') datereceived, `deliverynono`,
		concat(r.firstname,' ',r.middlename,' ',r.lastname) receivedbyname
		from `goodsreceived` g
		join `suppliers` s on s.`supplierid`=g.`supplierid`
		join `user` r on r.`id`=g.`receivedby`
		join `warehouses` w on w.`id`=g.warehouseid
		where g.`grnno`=$grnno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getgrnheaderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getgrnheaderdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getgrnheaderdetails`($grnno varchar(50))
BEGIN
	
		select  `grnno`,DATE_FORMAT(`datereceived`,'%d-%b-%Y') datereceived,CONCAT(r.firstname,' ', r.middlename,' ', r.lastname) receivedby,
		CONCAT(i.firstname,' ', i.middlename,' ', i.lastname) inspectedby,deliveredby,`deliverynono`,`narration`,
		'' projectname, '' materialusecase, s.`suppliername`,s.`physicaladdress`,s.`postaladdress`,s.`mobile`,s.`email`
		FROM `goodsreceived` m, `suppliers` s, `user` r, `user` i
		WHERE m.`supplierid`=s.`supplierid` AND m.`receivedby`=r.`id` AND m.`inspectedby`=i.id AND grnno=$grnno;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getgrnitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getgrnitems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getgrnitems`($grnno varchar(50))
BEGIN
	sELECT `productid`,m.`itemcode`, m.itemname,m.unitofmeasure uom, SUM(rd.quantity) quantity, -- `fn_getgrnitemserialnumbers`($grnno,rd.materialid) 
	'' serialnos, p.purchaseorderno pono, pd.unitprice,deliveredby
	FROM `products` m
	INNER JOIN `goodsreceiveddetails` rd ON rd.itemcode=m.`productid`
	INNER JOIN `goodsreceived` r ON  r.`grnno` =rd.`grnno`
	INNER JOIN `purchaseorders`  p ON p.`purchaseorderno`=rd.`purchaseorderno`
	INNER JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid`=p.`id`
	WHERE r.grnno=$grnno and rd.itemcode=pd.itemcode
	GROUP BY  m.`itemcode`, m.`itemname`, unitofmeasure
	ORDER BY m.itemname  ;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getinputoutputvat` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getinputoutputvat` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getinputoutputvat`($startdate date,$enddate date)
BEGIN
		select itemcode, itemname,sum(quantity) quantitysold
		from `products` p
		join `possalesdetails` sd on sd.`itemcode`=p.productid 
		join `possales` s on s.id=sd.`possaleid`
		where date_format(s.`receiptdate`,'%Y-%m%-%d') between $startdate and $enddate
		group by itemcode;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getinputoutputvatreport` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getinputoutputvatreport` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getinputoutputvatreport`($startdate date,$enddate date)
BEGIN		
		SELECT `itemcode`,`itemname`,`unitofmeasure`,
		FORMAT(SUM(`salesquantity`),2)  qtysold,
		FORMAT(SUM(salesquantity*purchaseprice),2) totalpurchase,
		FORMAT(SUM(`purchaseprice`*`purchasetaxrate`/100)*salesquantity,2) inputvat,
		FORMAT(SUM(salesquantity*m.`sellingprice`),2) totalsales, 
		FORMAT(SUM(m.`sellingprice`*`taxrate`/100)*`salesquantity`,2) outputvat,
		 
		-- compute vat difference
		FORMAT(SUM(m.`sellingprice`*`taxrate`/100)*`salesquantity` -
		SUM(`purchaseprice`*`purchasetaxrate`/100)*salesquantity,2) vatdifference

		FROM `stockmovement` s
		JOIN `products` p ON s.productid=p.`productid`
		JOIN `stockmovementsalesdetails` m ON m.`stockmovementid`=s.`stockmovementid`
		WHERE `purchasedate` BETWEEN $startdate AND $enddate
		GROUP BY p.`productid`
		ORDER BY `itemname`;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getitemstorebalance` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getitemstorebalance` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getitemstorebalance`($productid INT,$storeid INT)
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
		
		select IFNULL(@transfersin,0) transfersin,IFNULL(@reconciledstock,0) reconciledstock,
		IFNULL(@transfersout,0) transfersout,IFNULL(@sales,0) sales,$startdate startdate,$enddate enddate;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getmaterialrequestapprovallevels` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getmaterialrequestapprovallevels` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getmaterialrequestapprovallevels`()
BEGIN
	select * 
	from `materialrequestapprovallevels` 
	order by `hierarchy`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getmaterialrequestdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getmaterialrequestdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getmaterialrequestdetails`($requisitionno varchar(50))
BEGIN
		select m.*, p.id as projectid from `materialrequest` m, `projectactivities` a, projects p 
		where m.`activityid`=a.`id` and a.`projectid`=p.`id` and `requisitionno`=$requisitionno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getmaterialrequisitiondetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getmaterialrequisitiondetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getmaterialrequisitiondetails`($requisitionno varchar(50))
BEGIN
	SELECT m.*, p.id AS projectid FROM `materialrequest` m, `projectactivities` a, projects p 
	WHERE m.`activityid`=a.`id` AND a.`projectid`=p.`id` AND `requisitionno`=$requisitionno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getmaterialrequisitionitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getmaterialrequisitionitems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getmaterialrequisitionitems`($requisitionid int)
BEGIN
	select m.`id`,`itemcode`,m.`description` as itemname, ifnull(`narration`,'') narration,u.`description` as uom, `quantity`,`unitprice`
	from `materialrequestdetails` mr, `materialdetails` m, `materialunitsofmeasure` u
	where m.`id`=mr.materialid and m.`unitofmeasureid`=u.`id` and `materialrequestid`=$requisitionid
	order by m.description;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getorderstotal` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getorderstotal` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getorderstotal`($refno varchar(50))
BEGIN
		select sum(quantity*unitprice) orderstotal
		from `customerorderdetails`
		where `orderid` in(select `orderid` from `temporderstosettle` where `refno`=$refno);
		
		delete from `temporderstosettle` 
		where `refno`=$refno;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpapergrammage` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpapergrammage` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpapergrammage`()
BEGIN
	select * from `papergrammage`
	order by `grammage`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getparentzones` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getparentzones` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getparentzones`()
BEGIN
	SELECT z.id,z.zonename,z.parent,z.dateadded,COUNT(c.customerid) customers, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname 
	FROM `zones` z
	INNER JOIN `user` u ON z.`addedby`=u.id
	left outer join `zones` zy on zy.`parent`=z.id
	LEFT OUTER JOIN `customers` c ON c.subzoneid=z.id
	WHERE z.`parent`=0 AND IFNULL(z.`deleted`,0)=0
	GROUP BY z.id,z.zonename,z.parent,z.dateadded
	ORDER BY `zonename`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpodetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpodetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpodetails`($pono varchar(50))
BEGIN
		select r.itemcode, itemname, unitofmeasure,
		sum(quanity) quantity, unitprice, sum(quanity)*unitprice as linetotal
		from `purchaseorderdetails` pd
		join `purchaseorders` p on p.`id`=pd.`purchaseorderid`
		join `products` r on r.`productid`=pd.`itemcode`
		where `purchaseorderno`=$pono
		group by r.itemcode
		order by `itemname`;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpoheader` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpoheader` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpoheader`($pono varchar(50))
BEGIN
		select `purchaseorderno`, `date`, suppliername, 
		concat('P.O Box', `postaladdress`,', ',`postalcode` ,' ',`town`) supplieraddress,
		concat(firstname,' ',middlename,' ',lastname) username
		from `purchaseorders` p
		join `suppliers` s on s.supplierid=p.supplierid
		join `user` u on u.`id`=p.`addedby`
		where p.`purchaseorderno`=$pono;
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpoheaderdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpoheaderdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpoheaderdetails`($pono varchar(50))
BEGIN
	SELECT `suppliername`,`physicaladdress`,`postaladdress`,`town`,`postalcode`,s.mobile,s.email AS supplieremail,
	DATE_FORMAT(`date`,'%d-%b-%Y') orderdate,`purchaseorderno` orderno, 
	DATE_FORMAT(IFNULL(`expecteddate`,DATE_ADD(p.date, INTERVAL 7 DAY)),'%d-%b-%Y') expecteddate,`currencyname`,`terms`,
	CONCAT(firstname,' ',middlename,' ',lastname) preparedby
	FROM `purchaseorders` p, `currencies` c, suppliers s, `user` u
	WHERE p.`currencyid`=c.`id`  AND p.supplierid=s.supplierid AND u.id=p.addedby and `purchaseorderno`=$pono;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpoidfrompono` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpoidfrompono` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpoidfrompono`($pono varchar(50))
BEGIN
	select `id` poid 
	from `purchaseorders` 
	where `purchaseorderno`=$pono;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpoitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpoitems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpoitems`($pono varchar(50))
BEGIN
	
	SELECT  i.`itemcode`,i.productid AS itemid, i.itemname, unitofmeasure uom, 
	pd.`quanity` quantity,pd.`unitprice`,pd.`taxinclusive`,a.`taxrate`, p.`taxid`, pd.quanity*pd.unitprice AS total,`taxname`
	FROM `purchaseorders` p, `purchaseorderdetails` pd, `products` i,`taxtypes` a
	WHERE p.`id`=pd.`purchaseorderid` AND pd.`itemcode`=i.`productid` AND p.`taxid`=a.id and `purchaseorderno`=$pono
	order by itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getposproductcategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getposproductcategories` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getposproductcategories`($posid int)
BEGIN
		select `categoryid`,`categoryname`,
		(select `poscategoryid` from `posproductcategories` where `productcategoryid`=categoryid and `posid`=$posid and deleted=0) poscategoryid
		from `categories`
		order by `categoryname`; 
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getposproductsbalancepivot` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getposproductsbalancepivot` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getposproductsbalancepivot`($startdate date,$enddate date,$posid int)
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getproductpurchasessummary`($startdate date,$enddate date)
BEGIN
    
	select p.`itemcode`,`itemname`,avg(`unitprice`) unitprice, sum(gd.`quantity`) quantity,sum(gd.`quantity`*`unitprice`) total
	from `products` p, `purchaseorderdetails` pod, `purchaseorders` po, `goodsreceived` g, `goodsreceiveddetails` gd
	where p.`productid`=pod.`itemcode` and pod.`purchaseorderid`=po.`id` and gd.`itemcode`=p.`productid` and g.`grnno`=gd.`grnno` 
	and gd.`purchaseorderno`=po.`purchaseorderno`
	and date_format(po.`date`,'%Y-%m-%d') between $startdate and $enddate
	group by  p.`itemcode`,`itemname`
	order by itemname;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getproductsalessummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getproductsalessummary` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getproductsalessummary`($startdate date,$enddate date)
BEGIN
	select p.`itemcode`,`itemname`,unitprice-discount unitprice, sum(`quantity`) quantity, sum(`quantity`*(`unitprice`-discount)) total
	from `products` p, `possales` s, `possalesdetails` sd
	where p.`productid`=sd.`itemcode` and sd.`possaleid`=s.`id` 
	and date_format(s.`receiptdate`,'%Y-%m-%d') between $startdate and $enddate
	and ifnull(s.`deleted`,0)=0
	group by p.`itemcode`,`itemname`,unitprice-discount
	order by `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovallevelname` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovallevelname` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpurchaseorderapprovallevelname`($hierarchy int)
BEGIN
	select `description` from `purchaseorderapprovallevels` where `hierarchy`=$hierarchy;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovallevels` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovallevels` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpurchaseorderapprovallevels`()
BEGIN
	select * 
	from `purchaseorderapprovallevels` 
	order by `hierarchy`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovallevelstatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovallevelstatus` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpurchaseorderapprovallevelstatus`($purchaseorderno varchar(50))
BEGIN
	set @id=(select id from `purchaseorders` where `purchaseorderno`=$purchaseorderno);
	select `id`,`description`,
	case when exists (select * from `purchaseorderapproval` where `poid`=@id and `approvallevelid`=m.id) then 'Approved'  else 'Pending' end `status`
	from `purchaseorderapprovallevels` m
	order by `hierarchy`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovalusers` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovalusers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpurchaseorderapprovalusers`($purchaseorderno varchar(50),$approvallevel int)
BEGIN
	set @departmentid=(select`departmentid` from `purchaseorders` where `purchaseorderno`=$purchaseorderno);
	select u.* from `user` u,`purchaseorderapprovalusers` a, `purchaseorderapprovallevels` l
	where a.`userid`=u.`id` and  a.`approvallevelid`=l.`id` and l.`hierarchy`=$approvallevel and a.`departmentid`=@departmentid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseorderapprovers` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseorderapprovers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpurchaseorderapprovers`($pono varchar(50))
BEGIN
	SELECT `description`,`hierarchy`,CONCAT(`firstname`,' ',`middlename`,' ',`lastname`)approvedby,signature,
	DATE_FORMAT(a.`approvaldate`,'%d-%b-%Y') approvaldate
	FROM `purchaseorderapproval` a,`purchaseorderapprovallevels` l, `user` u,  `purchaseorders` p
	WHERE a.`poid`=p.`id` AND a.`approvaluser`=u.id AND a.`approvallevelid`=l.`id` AND purchaseorderno=$pono
	ORDER BY `hierarchy`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseordercurrentstatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseordercurrentstatus` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpurchaseordercurrentstatus`($purchaseorderno varchar(50))
BEGIN
	set @id=(select id from `purchaseorders` where `purchaseorderno`=$purchaseorderno);
	select `fn_purchaseorderstatus`(@id) `status`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getpurchaseordernextapprovallevel` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getpurchaseordernextapprovallevel` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getpurchaseordernextapprovallevel`($purchaseorderno varchar(50))
BEGIN
	set @purchaseorderid=(select id from `purchaseorders` where `purchaseorderno`=$purchaseorderno);
	select a.`id`,`description`,`hierarchy`,ifnull(s.`id`,0)`approved`
	from `purchaseorderapprovallevels` a
	left outer join `purchaseorderapproval` s
	on a.`id`=s.`approvallevelid` and `poid`=@purchaseorderid
	where IFNULL(s.`id`,0)=0
	order by `hierarchy`
	limit 1;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getquotationapprovers` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getquotationapprovers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getquotationapprovers`($quoteno varchar(50))
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getquotationdetails`($quotationno VARCHAR(50))
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

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getquotationheaderdetails`($quoteno varchar(50))
BEGIN
	select `customername`,`physicaladdress`,`postaladdress`,`town`,`postalcode`,c.`mobile`,c.`email`,`quoteno`,date_format(`quotedate`,'%d-%b-%Y') quotedate,
	date_format(date_add(`quotedate`, interval 7 day),'%d-%b-%Y') expirydate, terms,CONCAT(firstname,' ',middlename,' ',lastname) preparedby
	from `quotation` q, `customers` c, `user` u
	where q.`customerid`=c.`customerid` and q.`addedby`=u.id and `quoteno`=$quoteno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getquotationitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getquotationitems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getquotationitems`($quoteno varchar(50))
BEGIN
	select `itemcode`,`itemname`,`unitofmeasure` uom,`quantity`,`unitprice`,
	case when category='general' then `description` else concat(format(qd.`length`,0),' X ',format(qd.`width`,0),' X ',format(qd.`height`,0)) end description,
	`quantity`*`unitprice` total,'VAT' taxname,16 taxrate
	from `quotation` q, `quotationdetails` qd, `products`p
	where q.`id`=qd.`quoteid` and qd.`itemid`=p.`productid` and `quoteno`=$quoteno
	order by `itemname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrawmaterialcategories` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrawmaterialcategories` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getrawmaterialcategories`()
BEGIN
	select * 
	from `rawmaterialcategories` 
	order by `categoryname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrawmaterialdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrawmaterialdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getrawmaterialdetails`($materialid int)
BEGIN
	select * 
	from `rawmaterials` 
	where `materialid`=$materialid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrawmaterials` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrawmaterials` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getrawmaterials`()
BEGIN
	select * from `rawmaterials` 
	where ifnull(`deleted`,0)=0
	order by `materialname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitionapprovallevelname` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitionapprovallevelname` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getrequisitionapprovallevelname`($hierarchy int)
BEGIN
	select `description` from `materialrequestapprovallevels` where `hierarchy`=$hierarchy;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitionapprovallevelstatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitionapprovallevelstatus` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getrequisitionapprovallevelstatus`($requisitionno varchar(50))
BEGIN
	set @id=(select id from `materialrequest` where `requisitionno`=$requisitionno);
	select `id`,`description`,
	case when exists (select * from `materialrequestapproval` where `materialrequestid`=@id and `approvallevelid`=m.id) then 'Approved'  else 'Pending' end `status`
	from `materialrequestapprovallevels` m
	order by `hierarchy`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitionapprovalusers` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitionapprovalusers` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getrequisitionapprovalusers`($requisitionno varchar(50),$approvallevel int)
BEGIN
	set @departmentid=(select`departmentid` from `materialrequest` where `requisitionno`=$requisitionno);
	select u.* from `user` u,`materialrequestapprovalusers` a, `materialrequestapprovallevels` l
	where a.`userid`=u.`id` and  a.`approvallevelid`=l.`id` and l.`hierarchy`=$approvallevel and a.`departmentid`=@departmentid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitioncurrentstatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitioncurrentstatus` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getrequisitioncurrentstatus`($requisitionno varchar(50))
BEGIN
	set @id=(select id from `materialrequest` where `requisitionno`=$requisitionno);
	select `fn_requisitionstatus`(@id) `status`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitiondefaultnonpurchasesupplier` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitiondefaultnonpurchasesupplier` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getrequisitiondefaultnonpurchasesupplier`()
BEGIN
	select `defaultnonpurchasesupplier` 
	from `materialrequisitionsettings`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getrequisitionnextapprovallevel` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getrequisitionnextapprovallevel` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getrequisitionnextapprovallevel`($requisitionno varchar(50))
BEGIN
	set @requisitionid=(select id from `materialrequest` where `requisitionno`=$requisitionno);
	select a.`id`,`description`,`hierarchy`,ifnull(s.`id`,0)`approved`
	from `materialrequestapprovallevels` a
	left outer join `materialrequestapproval` s
	on a.`id`=s.`approvallevelid` and `materialrequestid`=@requisitionid
	where IFNULL(s.`id`,0)=0
	order by `hierarchy`
	limit 1;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getreturnableproducts` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getreturnableproducts` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getreturnableproducts`()
BEGIN
		select * from `products`
		where `allowreturnexchange`=1
		order by `itemname`;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getsessioncollectionsummary` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getsessioncollectionsummary` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getsessioncollectionsummary`($sessionid int)
BEGIN
		select 'Float' paymentmode, floatamount amount from `sessions`
		where `sessionid`=$sessionid
		
		union
		
		select `description` paymentmode, sum(amount) amount
		from `possales` s 
		join `possalespayments` m on m.`possaleid`=s.`id`
		join `paymentmethods` t on t.`id`=m.`paymentmode`
		where `sessionid`=$sessionid and s.`deleted`=0
		group by paymentmode;
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getsessions` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getsessions` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getsessions`()
BEGIN
		select s.*, concat(o.firstname,' ',o.middlename,' ',o.lastname)openedby,
		ifnull(CONCAT(c.firstname,' ',c.middlename,' ',c.lastname),'-')closedby
		from `sessions` s
		join `user` o on o.`id`=s.`addedby`
		left outer join `user` c on c.id=s.`closedby`
		order by `sessionid` desc;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getspoilagecategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getspoilagecategory` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getspoilagecategory`()
BEGIN
	select * from `spoilagecategory`
	order by `categoryname`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getsubzones` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getsubzones` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getsubzones`($parent int)
BEGIN
	if $parent=0 then
		select z.id,z.zonename,z.parent,z.dateadded,count(c.customerid) customers, concat(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname 
		from `zones` z
		inner join `user` u on z.`addedby`=u.id
		left outer join `customers` c on c.subzoneid=z.id
		where z.`parent`>0 and ifnull(z.`deleted`,0)=0
		group by z.id,z.zonename,z.parent,z.dateadded
		order by `zonename`;
	else
		SELECT z.id,z.zonename,z.parent,z.dateadded,COUNT(c.customerid) customers, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname 
		FROM `zones` z
		INNER JOIN `user` u ON z.`addedby`=u.id
		LEFT OUTER JOIN `customers` c ON c.subzoneid=z.id
		WHERE z.`parent`=$parent AND IFNULL(z.`deleted`,0)=0
		GROUP BY z.id,z.zonename,z.parent,z.dateadded
		ORDER BY `zonename`;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_gettabledetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_gettabledetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_gettabledetails`($tableid int)
BEGIN
		select * from `tables`
		where `tableid`=$tableid;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_gettables` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_gettables` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_gettables`($posid int)
BEGIN
		if $posid=0 then 
			select t.*, posname,concat(firstname,' ',middlename,' ',lastname) addedbyname
			from `tables` t 
			join `pointsofsale` p on p.`id`=t.posid
			join `user` u on u.id=t.addedby
			where t.deleted=0
			order by posname,tablename;
		else
			SELECT t.*, posname,CONCAT(firstname,' ',middlename,' ',lastname) addedbyname
			FROM `tables` t 
			JOIN `pointsofsale` p ON p.`id`=t.posid
			JOIN `user` u ON u.id=t.addedby
			WHERE t.deleted=0 and t.posid=$posid
			ORDER BY tablename;
		
		end if;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_gettaxdetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_gettaxdetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_gettaxdetails`($id int)
BEGIN
	select * 
	from `taxtypes` 
	where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_gettransferreportbyitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_gettransferreportbyitems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_gettransferreportbyitems`($cat varchar(50),$id int,$startdate date,$enddate date)
BEGIN
    
	SET @type =$cat;
	SET @id=$id;
	SET @startdate=$startdate;
	SET @enddate=$enddate;
	-- select @startdate,@enddate;
	SELECT	sd.itemcode, p.`itemname`, 
	SUM(CASE WHEN `destinationtype`=@type AND `destinationid`=@id THEN `quantity` ELSE 0 END) AS transferin,
	SUM(CASE WHEN `sourcetype`=@type AND `sourceid`=@id THEN `quantity` ELSE 0 END) AS transferout
	FROM `stocktransfer` s, `stocktransferdetails` sd, `products` p
	WHERE s.`id`=sd.`transferid` AND sd.`itemcode`=p.`productid`
	AND DATE_FORMAT(s.`dateadded`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	-- and `destinationtype`=@type and `destinationid`=@destinationid
	GROUP BY sd.itemcode, p.`itemname`
	order by p.itemname;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getunissuedepartmentrequisitions` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getunissuedepartmentrequisitions` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getunissuedepartmentrequisitions`($departmentid int)
BEGIN
	select distinct requisitionid,requisitionno from `vw_requisitionitembalances` where departmentid=$departmentid
	order by requisitionno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getunissuedrequisitionitems` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getunissuedrequisitionitems` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getunissuedrequisitionitems`($requisitionid int)
BEGIN
	select * 
	from `vw_requisitionitembalances` where requisitionid=$requisitionid
	order by itemname;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getuserpurchaseorderapprovalprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getuserpurchaseorderapprovalprivileges` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getuserpurchaseorderapprovalprivileges`($userid int)
BEGIN
	select * 
	from `purchaseorderapprovalusers` 
	where `userid`=$userid and ifnull(valid,0)=1;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getuserrequisitionapprovalprivileges` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getuserrequisitionapprovalprivileges` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getuserrequisitionapprovalprivileges`($userid int)
BEGIN
	select * 
	from `materialrequestapprovalusers` 
	where `userid`=$userid and ifnull(valid,0)=1;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getuserswithprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getuserswithprivilege` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getuserswithprivilege`($objectid int)
BEGIN
	select * from `user` where id in(select userid from `userprivileges` where `objectid`=$objectid and `allowed`=1)
	or id in(select `userid` from `roleusers`  r, `roleprivileges` p where r.`roleid`=p.`roleid` and p.`objectid`=$objectid and `allowed`=1);
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getwarehousestocksummaryasat` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getwarehousestocksummaryasat` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getwarehousestocksummaryasat`($warehouseid int,$asat date)
BEGIN
		SET @openingbalancedate=date_add($asat, interval -1 day);
		SET @basedate=DATE(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters`),curDate())); 
		
		select p.itemcode,itemname,buyingprice,sellingprice,
		`fn_getwarehousestockbalance`(productid,$warehouseid,@openingbalancedate) openingbalance,
		-- Purchases
		ifnull(
			(select sum(quantity) from goodsreceived g join  goodsreceiveddetails gd on gd.grnno=g.grnno 
		where gd.itemcode=p.productid and date(datereceived)=$asat and warehouseid=$warehouseid),0) +
		-- Add Transfers in
		IFNULL((SELECT SUM(`quantity`) FROM `stocktransfer` s JOIN `stocktransferdetails` sd ON sd.`transferid`=s.id AND sd.`itemcode`=productid 
		WHERE  `destinationtype`='warehouse' AND `destinationid`=$warehouseid AND DATE(`dateadded`)=$asat),0) received,
		-- Generate Issues
		ifnull((select sum(`quantity`) from `stocktransfer` s join `stocktransferdetails` sd on sd.`transferid`=s.id and sd.`itemcode`=productid 
		where  `sourcetype`='warehouse' and `sourceid`=$warehouseid and date(`dateadded`)=$asat),0) issued
		from `products` p 
		GROUP BY p.productid
		order by itemname;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getwarehousingproductsbalancepivot` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getwarehousingproductsbalancepivot` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getwarehousingproductsbalancepivot`($startdate date,$enddate date,$warehouseid int)
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

/* Procedure structure for procedure `sp_getzonedetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getzonedetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getzonedetails`($id int)
BEGIN
	select * from `zones` where `id`=$id;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getzonesandsubzones` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getzonesandsubzones` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_getzonesandsubzones`()
BEGIN
	SELECT s.id subzoneid,s.zonename subzonename, p.zonename zonename, p.id zoneid
	FROM `zones` s, `zones` p
	WHERE s.`parent`=p.id  AND IFNULL(s.`deleted`,0)=0
	ORDER BY zonename,subzonename;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_resetuserpin` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_resetuserpin` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_resetuserpin`($userid int,$pin varchar(100),$salt varchar(50))
BEGIN
		update `user`
		set `pin`=$pin, `pinsalt`=$salt
		where id=$userid;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savecustomercontact` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savecustomercontact` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savecustomercontact`($id int,$customerid int, $categoryid int, $contactname varchar(100),$mobile varchar(100),$email varchar(100),$userid int)
BEGIN
	if $id=0 then 
		insert into `customercontacts`(`customerid`,`categoryid`,`contactname`,`mobile`,`email`,`dateadded`,`addedby`)
		values($customerid,$categoryid,$contactname,$mobile,$email,now(),$userid);
	else
		update `customercontacts` 
		set `categoryid`=$categoryid, `contactname`=$contactname, `mobile`=$mobile, `email`=$email,`customerid`=$customerid
		where `id`=$id;	 
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savecustomerorder` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savecustomerorder` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savecustomerorder`($refno varchar(50),$posid int,$customerid int,$tableid int,$userid int)
BEGIN
		-- Generate order number
		declare $orderno varchar(50)default `fn_generatecustomerorderno`() ;
		declare $orderid int default 0;		
		start transaction;
			-- Save customer order
			insert into `customerorders`(`orderno`,`posid`,`customerid`,`tableid`,`waiterid`,`dateadded`,`addedby`)
			values($orderno,$posid,$customerid,$tableid,$userid,now(),$userid);
			
			-- Get inserted orderid
			select max(`orderid`) into $orderid from `customerorders`;
			
			-- Save customer details
			insert into `customerorderdetails`(`orderid`,`productid`,`unitofmeasure`,`quantity`,`unitprice`,`taxid`,`taxrate`)
			select $orderid,t.productid,p.`unitofmeasure`,t.quantity,t.unitprice,p.`taxtypeid`, r.taxrate
			from `temcustomerorderdetails` t
			join `products` p on p.productid=t.productid
			join `taxtypes` r on r.`id`=p.`taxtypeid`
			where `refno`=$refno;
			
			-- Delete temporary data
			delete from `temcustomerorderdetails` where `refno`=$refno;
			
			-- Increment order no counter
			update serials 
			set currentno=currentno+1 
			where `documenttype`='Customer Order Number';
			
			-- Return order number
			select $orderno as `orderno`;
		commit;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savedepartment` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savedepartment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savedepartment`($id int,$departmentname varchar(50),$userid int,$hodid int)
BEGIN
	if $id=0 then 
		insert into `departments`(`departmentname`,`dateadded`,`addedby`, `hodid`)
		values($departmentname,now(),$userid,$hodid);
	else
		update `departments` 
		set `departmentname`=$departmentname , `hodid`=$hodid
		where `id`=$id;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveemailconfiguration` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveemailconfiguration` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_saveemailconfiguration`($emailaddress varchar(100),$emailpassword varchar(50),$smtpserver varchar(50),$smtpport int,$usessl boolean)
BEGIN
	if not exists(select * from `emailconfiguration`) then
		insert into `emailconfiguration`(`emailaddress`,`password`,`smtpserver`,`usessl`,`smtpport`)
		values($emailaddress,$emailpassword,$smtpserver,$usessl,$smtpport);
	else
		update `emailconfiguration` 
		set `emailaddress`=$emailaddress,`password`=$emailpassword,`smtpserver`=$smtpserver,`usessl`=$usessl,`smtpport`=$smtpport;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savefleetfuelrequisition` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savefleetfuelrequisition` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savefleetfuelrequisition`(`$id` INT, `$supplierid` INT, `$costcenterid` INT, `$vehicleid` INT, `$requestedby` INT, `$approvedby` INT, `$quantity` DECIMAL(18,2), `$unitprice` DECIMAL(18,2), `$odoreading` INT, `$userid` INT)
BEGIN
	if $id=0 then 
		-- Generate the Requisition number
		set @requisitionno=fn_generaterequisitionno();
		start transaction;
			insert into `fleetfuelrequisition`(`vehicleid`,`requisitionno`,`odoreading`,`costcenterid`,`supplierid`,`quantity`,`unitprice`,`dateadded`,`addedby`,`approvedby`,`requestedby`)
			values($vehicleid,@requisitionno,$odoreading,$costcenterid,$supplierid,$quantity,$unitprice,now(),$userid,$approvedby,$requestedby);
			-- Increment requisition number counter generator
			update serials set currentno=currentno+1 where `documenttype`='Requisition Number';
		commit;
	else	
		update `fleetfuelrequisition` set `vehicleid`=$vehicleid, `odoreading`=$odoreading, `costcenterid`=$costcenterid, `supplierid`=$supplierid,
		`quantity`=$quantity,`unitprice`=$unitprice,`requestedby`=$requestedby, `approvedby`=$approvedby
		where `id`=$id;
		set @requisitionno=(select `requisitionno` from `fleetfuelrequisition` where `id`=$id);
	end if;
	select @requisitionno as requisitionno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savefleetvehicle` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savefleetvehicle` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savefleetvehicle`(`$vehicleid` INT, `$regno` VARCHAR(50), `$bodytypeid` INT, `$fueltypeid` INT, `$enginerating` INT, `$userid` INT)
BEGIN
	if $vehicleid=0 then
		insert into `fleetvehicles`(`bodytypeid`,`fueltypeid`,`regno`,`enginerating`,`dateadded`,`addedby`,`deleted`)
		values($bodytypeid,$fueltypeid,$regno,$enginerating,now(),$userid,0);	
		set $vehicleid=(select max(vehicleid) from `fleetvehicles`);
	else
		update `fleetvehicles` set `bodytypeid`=$bodytypeid, `fueltypeid`=$fueltypeid, `regno`=$regno, `enginerating`=$enginerating
		where `vehicleid`=$vehicleid;
	end if;
	
	select $vehicleid as vehicleid;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveinstitutiondetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveinstitutiondetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_saveinstitutiondetails`($companyname varchar(50),$physicaladdress varchar(100),$postaladdress varchar(100),
$landline varchar(50),$email varchar(50),$mobile varchar(50),$pinno varchar(50),$autoinvoicegrn int,$postalcode varchar(50),$tagline varchar(50),
$website varchar(50),$receiptfooter varchar(1000),$defaultcustomer int,$mainbusinesstype varchar(50),$logo varchar(1000),$town varchar(100))
BEGIN
		if exists(select * from `institution`) then 
			update `institution`
			set `name`=$companyname,`physicaladdress`=$physicaladdress,`postaladdress`=$postaladdress,`landline`=$landline,
			`email`=$email,`mobile`=$mobile,`pinno`=$pinno,`autoaddinvoiceduringgrn`=$autoinvoicegrn,`postalcode`=$postalcode,
			`tagline`=$tagline,`website`=$website,`receiptfooter`=$receiptfooter,`defaultcustomerid`=$defaultcustomer,
			`mainbusinesstype`=$mainbusinesstype,`logo`=$logo,`town`=$town;
		else
			insert into `institution`(`name`,`physicaladdress`,`postaladdress`,`landline`,`email`,`mobile`,`pinno`,`town`,
			`autoaddinvoiceduringgrn`,`postalcode`,`tagline`,`website`,`receiptfooter`,`defaultcustomerid`,`mainbusinesstype`,`logo`)
			values($companyname,$physicaladdress,$postaladdress,$landline,$email,$mobile,$pinno,$town,$autoinvoicegrn,$postalcode,
			$tagline,$website,$receiptfooter,$defaultcustomer,$mainbusinesstype,$logo);
		end if;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savematerialrequisition` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savematerialrequisition` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savematerialrequisition`($id int,$refno varchar(50),$materialusecase int,$reference varchar(50),$narration varchar(5000),$scope varchar(50),$supplierid int,$activityid int,$departmentid int,$userid int,$purchaserequisition bool)
BEGIN
	start transaction;
		if $id=0 then 
			-- generate requisitionno
			set @requisitionno=`fn_generaterequisitionno`();
			-- save requisition
			insert into `materialrequest`(`requisitionno`,`materialusecase`,`reference`,`requestdate`,`requestedby`,`narration`,scope,supplierid,activityid,departmentid,`addedby`,`purchaserequisition`)
			values(@requisitionno,$materialusecase,$reference,now(),$userid,$narration,$scope,$supplierid,$activityid,$departmentid,$userid,$purchaserequisition);
			-- get the generated requisition id
			set @materialrequestid=(select max(id) from `materialrequest`);
			-- save requisition items
			insert into `materialrequestdetails`(`materialrequestid`,`materialid`,`quantity`,`unitprice`)
			select @materialrequestid,`itemid`,`quantity`,`unitprice` from `tempmaterialrequestdetails` where `refno`=$refno;
			-- remove temporary data
			delete from `tempmaterialrequestdetails` where `refno`=$refno;
			-- Increment requisition number counter
			update serials set currentnumber=currentnumber+1 where document='requisition';
			-- return generated requisition number
			select @requisitionno as requisitionno;
		else
			update `materialrequest` set `materialusecase`=$materialusecase,`reference`=$reference,`narration`=$narration,scope=$scope,supplierid=$supplierid,
			activityid=$activityid,departmentid=$departmentid, `purchaserequisition`=$purchaserequisition where `id`=$id;
			-- Remove materials added earlier
			delete from `materialrequestdetails` where `materialrequestid`=$id;
			-- Add materials requested
			INSERT INTO `materialrequestdetails`(`materialrequestid`,`materialid`,`quantity`,`unitprice`)
			SELECT $id,`itemid`,`quantity`,`unitprice` FROM `tempmaterialrequestdetails` WHERE `refno`=$refno;
			-- remove temporary data
			DELETE FROM `tempmaterialrequestdetails` WHERE `refno`=$refno;
			-- Return requsition number
			select requisitionno from `materialrequest` where id=$id;
		end if;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savematerialsreceived` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savematerialsreceived` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savematerialsreceived`($refno varchar(50),$source varchar(50),$reference varchar(50),$userid int,$inspectedby int,
	$materialusecaseid int,$projectid int,$deliveredby varchar(50),$sourceid int,$warehouseid int)
BEGIN
	start transaction;
	
		-- generate the GRN number
		set @grnno=`fn_generategrnnumber`();
		
		
		if $source='Customer' then 
			set @customerid=$sourceid;
		elseif $source='Supplier' then
			set @supplierid=$sourceid;
			set $projectid=NULL;
			set $materialusecaseid=NULL;
		end if;
		
		-- Add source details
		insert into `materialreceipts`(`grnno`,`source`,`deliverynoteno`,`datereceived`,`receivedby`,`inspectedby`,`materialusecaseid`,`supplierid`,`customerid`,`projectid`,`deliveredby`,`warehouseid`)
		values(@grnno,$source,$reference,now(),$userid,$inspectedby,$materialusecaseid,@supplierid,@customerid,$projectid,$deliveredby,$warehouseid);
		-- Get the inserted grnid
		set @receiptid=(select max(`id`) from `materialreceipts`);
		-- Add material details
		insert into `materialreceiptdetails`(`receiptid`,`materialid`,`quantity`,`unitprice`,`barcode`,`serialno`,`poid`,`tagno`)
		select @receiptid,`itemid`,quantity,`unitprice`,`fn_generatebarcode`(),`serialno`,case when poid=0 then NULL else poid end,`tagno` from `tempmaterialreceiptdetails`
		where `refno`=$refno;
		-- Remove temporary data
		delete from `tempmaterialreceiptdetails` where `refno`=$refno;
		--  Return the grn number generated
		select @grnno as grnno;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveposproductcategory` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveposproductcategory` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_saveposproductcategory`($posid int,$productcategoryid int,$categorystatus bool,$userid int)
BEGIN	
		if $categorystatus=1 then
			if not exists(select * from `posproductcategories` where `posid`=$posid and `productcategoryid`=$productcategoryid and `deleted`=0) then 
				insert into `posproductcategories`(`posid`,`productcategoryid`,`dateadded`,`addedby`)
				values($posid,$productcategoryid,now(),$userid);
			end if;
		else
			update `posproductcategories` 
			set `deleted`=1,`datedeleted`=now(),`deletedby`=$userid
			where `posid`=$posid and `productcategoryid`=$productcategoryid and deleted=0;
		end if;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savepurchaseorderprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savepurchaseorderprivilege` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savepurchaseorderprivilege`($userid int, $approvallevelid int, $departmentid int,$valid boolean,$addedby int)
BEGIN
	if not exists(select * from `purchaseorderapprovalusers` where `userid`=$userid and `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid) then	
		if $valid=1 then
			insert into `purchaseorderapprovalusers`(`approvallevelid`,`userid`,`departmentid`,`valid`,`addedby`,`dateadded`)
			values($approvallevelid,$userid,$departmentid,$valid,$addedby,now());
		end if;
	else
		if $valid=0 then
			update `purchaseorderapprovalusers` set `valid`=$valid,`invalidatedby`=$addedby,`dateinvalidated`=now()
			where `userid`=$userid AND `approvallevelid`=$approvallevelid and `departmentid`=$departmentid;
		else
			update`purchaseorderapprovalusers`  SET `valid`=$valid,`dateadded`=now(),`addedby`=$addedby
			where `userid`=$userid AND `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid;
		end if;
	end if;
		
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savequotation` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savequotation` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savequotation`($id int,$refno varchar(50),$customerid int, $terms varchar(1000),$category varchar(50),$userid int )
BEGIN
	if $id=0 then 
		start transaction;
			set @quotationvalidity=ifnull((select quotationvalidity from `institution`),30);
			-- Generate quotation number
			set @quotationno=`fn_generatequoatationno`();
			-- Set Quotation Expiry Date
			set @quotationexpirydate=date_add(now(), interval @quotationvalidity day);
			-- Insert quotation
			insert into `quotation`(`quoteno`,`quotedate`,`terms`,`customerid`,`expirydate`,`addedby`,`deleted`,`category`)
			values(@quotationno,now(),$terms,$customerid,@quotationexpirydate,$userid,0,$category);
			-- Get inserted ID
			set $id=(select max(id) from `quotation`);
			-- Insert quotation details
			insert into `quotationdetails`(`quoteid`,`itemid`,`description`,`quantity`,`unitprice`,`length`,`width`,`height`,`gsm`,
			`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`)
			select $id,`itemid`,`description`,`quantity`,`unitprice`,`length`,`width`,`height`,`gsm`,
			`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`
			from `tempquotationdetails` where `refno`=$refno;
			-- Increment quotation number counter
			update serials set currentno=currentno+1 where `documenttype`='Quotation Number';
			-- Delete temp data
			-- delete from `tempquotationdetails`  WHERE `refno`=$refno;
		commit;
	else	
		start transaction;
			update `quotation` set `customerid`=$customerid, `terms`=$terms where `id`=$id;
			-- delete quotation details
			delete from `quotationdetails` where `quoteid`=$id;
			-- Insert quotation details
			INSERT INTO `quotationdetails`(`quoteid`,`itemid`,`description`,`quantity`,`unitprice`,`length`,`width`,`height`,`gsm`,
			`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`)
			SELECT $id,`itemid`,`description`,`quantity`,`unitprice`,`length`,`width`,`height`,`gsm`,
			`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`
			FROM `tempquotationdetails` WHERE `refno`=$refno;
			-- Delete temp data
			DELETE FROM `tempquotationdetails`  WHERE `refno`=$refno;
			-- get quotation number
			set @quotationno=(select `quoteno` from `quotation` where `id`=$id);
		commit; 
	end if;
	select @quotationno as quoteno;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saverawmaterial` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saverawmaterial` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_saverawmaterial`($materialid int,$categoryid int,$materialname varchar(50),
	$uom varchar(50),$physicalproduct bool, $unitprice decimal(18,2),$itemcode varchar(50),$generateitemcode bool, $userid int)
BEGIN
	if $materialid=0 then 
		set $itemcode=fngeneraterawmaterialcode($categoryid);
		insert into `rawmaterials`(`materialname`,`categoryid`,`unitprice`,`physicalproduct`,`uom`,`dateadded`,`addedby`,`deleted`)
		values($materialname,$categoryid,$unitprice,$physicalproduct,$uom,now(),$userid,0);
		update `rawmaterialcategories` set `currentno`=`currentno`+1 where `categoryid`=$categoryid;
	else
		update `rawmaterials` set `materialname`=$materialname,`categoryid`=$categoryid, `unitprice`=$unitprice, 
		`physicalproduct`=$physicalproduct, `uom`=$uom
		where `materialid`=$materialid;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saverequisitionprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saverequisitionprivilege` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_saverequisitionprivilege`($userid int, $approvallevelid int, $departmentid int,$valid boolean,$addedby int)
BEGIN
	if not exists(select * from `materialrequestapprovalusers` where `userid`=$userid and `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid) then	
		if $valid=1 then
			insert into `materialrequestapprovalusers`(`approvallevelid`,`userid`,`departmentid`,`valid`,`addedby`,`dateadded`)
			values($approvallevelid,$userid,$departmentid,$valid,$addedby,now());
		end if;
	else
		if $valid=0 then
			update `materialrequestapprovalusers` set `valid`=$valid,`invalidatedby`=$addedby,`dateinvalidated`=now()
			where `userid`=$userid AND `approvallevelid`=$approvallevelid and `departmentid`=$departmentid;
		else
			update`materialrequestapprovalusers`  SET `valid`=$valid,`dateadded`=now(),`addedby`=$addedby
			where `userid`=$userid AND `approvallevelid`=$approvallevelid AND `departmentid`=$departmentid;
		end if;
	end if;
		
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savereturns` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savereturns` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savereturns`($outletid int,$warehouseid int,$paymentmodeid int,$reference varchar(100),$jsondata json, $returneditems json, $userid int)
BEGIN
		-- extract sales and returned items 
		DECLARE $i INT DEFAULT 0;
		DECLARE $total INT DEFAULT 0;
		declare $source varchar(50) default 'pos';
		declare $destination varchar(50) default 'warehouse';
		declare $productid int;
		declare $unitssold decimal(18,2);
		declare $unitsreturned decimal(18,2);
		declare $unitprice decimal(18,2);
		declare $refno varchar(50) default uuid();    
		declare $itemcode varchar(100);      
		declare $defaultcustomer int default (select `defaultcustomerid` from `institution` limit 1);                        
		declare $salesvoucherno varchar(50) default (select `fn_generatesalesvoucherno`());
		declare $salesvoucherid int;
		declare $salesvoucheramount decimal(18,2);
		
		select max(`voucherid`) into $salesvoucherid from `salesvoucher`;
		
		-- Process returned items if any
		set $total=JSON_length($returneditems);
		if $total>0 then
			-- Save sales voucher
			insert into `salesvoucher`(`voucherno`,`dateadded`,`addedby`)
			values($salesvoucherno,now(),$userid);
			
			select max(`voucherid`) into $salesvoucherid
			from `salesvoucher`;
			
			update serials set currentno=currentno+1
			where `documenttype`='Sales Voucher';
			
			WHILE $i < $total DO
				SET $itemcode = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].itemcode')));
				SET $productid = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].productid')));
				-- SET $unitssold = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].unitssold')));
				SET $unitsreturned = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].unitsreturned')));
				SET $unitprice = JSON_UNQUOTE(JSON_EXTRACT($returneditems, CONCAT('$[', $i, '].unitprice')));
				
				set $salesvoucheramount=$salesvoucheramount+($unitsreturned*$unitprice);
				
				insert into `salesvoucherdetails`(`voucherid`,`itemid`,`quantity`,`unitprice`)
				values($salesvoucherid,$productid,$unitsreturned,$unitprice);
				
				-- Get stock balance at the warehouse as at date
				set @productwarehousebalance=`fn_warehousestockbalanceasat`($productid,$warehouseid,curdate());
				-- Adjust stock for the item in the main warehouse
				insert into `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
				values($refno,$productid,$unitsreturned+@productwarehousebalance,$unitprice);
				
				SET $i = $i + 1;
			END WHILE;			
			-- Save permanent reconcilliation
			set @narration=concat('Returnable items received by sales voucher #',$salesvoucherno);
			call `spsavestockreconciledbalance`($refno,@narration,$warehouseid,'warehouse',$userid);
		end if;
		
		SET $total=JSON_LENGTH($jsondata);
		WHILE $i < $total DO
			SET $itemcode = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].itemcode')));
			SET $productid = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].productid')));
			SET $unitssold = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].unitssold')));
			SET $unitsreturned = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].unitsreturned')));
			SET $unitprice = JSON_UNQUOTE(JSON_EXTRACT($jsondata, CONCAT('$[', $i, '].unitprice')));
			
			-- Save Temp pos sale
			call `spsavetempsale`($refno ,$itemcode,$unitssold,$unitprice,0,'','');
			-- Save temp pos sale payment
			CALL `spsavetemppossalepayment`($refno,$paymentmodeid,$reference,$unitssold*$unitprice);
			
			if $salesvoucheramount>0 then
				CALL `spsavetemppossalepayment`($refno,8,$salesvoucherno,$salesvoucheramount);
			end if;
			
			-- Save temp stock transfer
			CALL `spsavetempstocktransfer`($refno,$itemcode,$unitprice,$unitsreturned,'');
			
			SET $i = $i + 1;
		END WHILE;

		-- save pos sale
		call `spsavepossale`($refno,$defaultcustomer,$outletid,curdate(),'',$userid);
		
		-- return back the stock
		call `spsavestocktransfer`($refno,$source,$outletid,$destination,$warehouseid,$userid,$userid,$userid);
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savespoilage` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savespoilage` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savespoilage`(`$id` INT, `$categoryid` INT, `$productid` INT, `$quantity` NUMERIC(18,2), 
`$narration` VARCHAR(1000), $storecategory varchar(50),$storeid int, `$userid` INT)
BEGIN
	if $id=0 then
		insert into `spoilage`(`categoryid`,`productid`,`quantity`,`narration`,`storecategory`,`storeid`,`dateadded`,`addedby`)
		values($categoryid,$productid,$quantity,$narration,$storecategory,$storeid,now(),$userid);
	else
		update `spoilage` set `categoryid`=$categoryid,`productid`=$productid,`quantity`=$quantity,`narration`=$narration,
		`storecategory`=$storecategory,`storeid`=$storeid
		where `id`=$id;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savetable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savetable` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savetable`($tableid int,$posid int,$tablename varchar(50),$userid int)
BEGIN
		if $tableid=0 then 
			insert into `tables`(`posid`,`tablename`,`dateadded`,`addedby`)
			values($posid,$tablename,now(),$userid);
		else
			update `tables`
			set `tablename`=$tablename, `posid`=$posid
			where `tableid`=$tableid;
		end if;
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savetempcustomerorderdetail` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savetempcustomerorderdetail` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savetempcustomerorderdetail`($refno varchar(50),$productid int,$quantity decimal(5,2),$unitprice decimal(7,2))
BEGIN
		insert into `temcustomerorderdetails`(`refno`,`productid`,`quantity`,`unitprice`)
		values($refno,$productid,$quantity,$unitprice);
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savetemporderstosettle` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savetemporderstosettle` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savetemporderstosettle`($refno varchar(50),$orderid int)
BEGIN
		insert into `temporderstosettle`(`refno`,`orderid`)
		values($refno,$orderid);
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savetempquotation` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savetempquotation` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savetempquotation`($refno varchar(50), $itemid int, $description varchar(500),$quantity decimal(18,2),$unitprice decimal(18,2),
	$ilength decimal(18,2),$width decimal(18,2),$height decimal(18,2),$gsm decimal(18,2),$weight decimal(18,4),$plies decimal(18,2), $jointallowance decimal(18,2),
	$trimallowance decimal(18,2),$profitmargin decimal(18,2),$printing decimal(18,2),$freight decimal(18,2),$waste decimal(18,2),$flutefactor decimal(18,2))
BEGIN
	insert into `tempquotationdetails`(`refno`,`itemid`,`quantity`,`unitprice`,`description`,`length`,`width`,`height`,`gsm`,
		`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`)
	values($refno,$itemid,$quantity,$unitprice,$description,$ilength,$width,$height,$gsm,$weight,$plies,$jointallowance,
		$trimallowance,$profitmargin,$printing,$freight,$waste,$flutefactor);
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveuser` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveuser` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_saveuser`($userid int,$userpassword varchar(50),$salt varchar(50),$systemadmin BOOL,
	$username varchar(50),$firstname varchar(50),$middlename varchar(50),$lastname varchar(50),
	$email varchar(50),$mobile varchar(50),$changepasswordonlogon BOOL,$accountactive BOOL,
	$pin varchar(100),$pinsalt varchar(50),$addedby int)
BEGIN
	if $userid=0 then 
		
		insert into `user`(`username`,`password`,`salt`,`firstname`,`middlename`,`lastname`,`email`,`mobile`,`changepasswordonlogon`,
		`accountactive`,`addedby`,`dateadded`,systemadmin,`pin`,`pinsalt`)
		values($username,$userpassword,$salt,$firstname,$middlename,$lastname,$email,$mobile,$changepasswordonlogon,
		$accountactive,$addedby,now(),$systemadmin,$pin,$pinsalt);
		set $userid=(select max(`id`) from `user`);

	else
		update `user` set `username`=$username,`firstname`=$firstname,`middlename`=$middlename,`lastname`=$lastname,`email`=email,`mobile`=$mobile,
		`changepasswordonlogon`=$changepasswordonlogon,`systemadmin`=$systemadmin,`lastmodifiedby`=$addedby,`lastmodifiedon`=now()
		where `id`=$userid;
	end if;
	
	select $userid as `userid`;
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveuserprofilephoto` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveuserprofilephoto` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_saveuserprofilephoto`($userid int,$documentname varchar(1000))
BEGIN
	update `user` set `profilephoto`=$documentname where `id`=$userid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_saveusersignature` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_saveusersignature` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_saveusersignature`($userid int,$documentname varchar(1000))
BEGIN
	update `user` set `signature`=$documentname where `id`=$userid;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_savezone` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_savezone` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_savezone`($id int,$zonename varchar(50),$parent int,$userid int)
BEGIN
	if $id=0 then
		insert into `zones`(`zonename`,`dateadded`,`addedby`,`deleted`,`parent`)
		values($zonename,now(),$userid,0,$parent);
	else	
		update `zones` set `zonename`=$zonename, `parent`=$parent where `id`=$id;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_settleorderpayments` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_settleorderpayments` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_settleorderpayments`($refno varchar(50),$userid int)
BEGIN
		declare $posid int;
		declare $customerid int;
		declare $receiptid int;
		declare $receiptno varchar(50);
		
		select posid, customerid into $posid,$customerid
		from `temporderstosettle` t 
		join `customerorders` c on c.`orderid`=t.`orderid`
		where `refno`=$refno limit 1;
		
		-- Save temp pos sale 
		insert into `tempsale`(`refno`,`itemcode`,`unitprice`,`discount`,`quantity`,`serialno`,`taxtypeid`,`taxrate`)
		select $refno,`productid`,`unitprice`,0,`quantity`,'',`taxid`,`taxrate`
		from `customerorderdetails` where `orderid` in(select `orderid` from `temporderstosettle` where `refno`=$refno);
		
		-- Save POS Sale
		call `spsavepossale`($refno,$customerid,$posid,now(),$userid);
		
		-- Get Id for the inserted receipt
		select max(`id`) into $receiptid from `possales`;
		
		select `receiptno` 
		into $receiptno 
		from `possales` where `id`=$receiptid;
		
		-- Update Orders as Settled
		update `customerorders` 
		set `status`='Paid', `settledby`=$userid,`receiptid`=$receiptid
		where `orderid` in(select orderid from `temporderstosettle` where `refno`=$refno);
		
		-- Remove temporary data
		delete from `temporderstosettle` where `refno`=$refno;
		
		-- Return the erecipt no
		select $receiptno as `receiptno`;
		
	END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_subzones` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_subzones` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_subzones`($parent int)
BEGIN
	if $parent=0 then
		select z.id,z.zonename,z.parent,z.dateadded,count(c.customerid) customers, concat(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname 
		from `zones` z
		inner join `user` u on z.`addedby`=u.id
		left outer join `customers` c on c.subzoneid=z.id
		where z.`parent`>0 and ifnull(z.`deleted`,0)=0
		group by z.id,z.zonename,z.parent,z.dateadded
		order by `zonename`;
	else
		SELECT z.id,z.zonename,z.parent,z.dateadded,COUNT(c.customerid) customers, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname 
		FROM `zones` z
		INNER JOIN `user` u ON z.`addedby`=u.id
		LEFT OUTER JOIN `customers` c ON c.subzoneid=z.id
		WHERE z.`parent`=$parent AND IFNULL(z.`deleted`,0)=0
		GROUP BY z.id,z.zonename,z.parent,z.dateadded
		ORDER BY `zonename`;
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_validatepurchaseorderapproval` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_validatepurchaseorderapproval` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_validatepurchaseorderapproval`($userid INT, $approvallevel INT,$departmentid INT)
BEGIN
	DECLARE $admin INT DEFAULT 0;
	DECLARE $valid INT DEFAULT 0;
	SET $admin=(SELECT systemadmin FROM `user` WHERE `id`=$userid);
	IF $admin=1 THEN
		SET $valid=1;
	ELSE
		IF $approvallevel=0 THEN 
			IF EXISTS(SELECT `valid` FROM `purchaseorderapprovalusers` WHERE `userid`=$userid AND departmentid=$departmentid AND valid=1) THEN
				SET $valid=1;
			END IF;
		ELSE
			SET $valid=IFNULL((SELECT `valid` FROM `purchaseorderapprovalusers` WHERE `userid`=$userid AND departmentid=$departmentid AND `approvallevelid`=$approvallevel AND valid=1),0);
		END IF;
	END IF;
	
	SELECT $valid AS `allowed`;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_validaterequisitionapproval` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_validaterequisitionapproval` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_validaterequisitionapproval`($userid int, $approvallevel int,$departmentid int)
BEGIN
	declare $admin INT DEFAULT 0;
	declare $valid int default 0;
	SET $admin=(SELECT systemadmin FROM `user` WHERE `id`=$userid);
	IF $admin=1 THEN
		SET $valid=1;
	ELSE
		if $approvallevel=0 then 
			if exists(SELECT `valid` FROM `materialrequestapprovalusers` WHERE `userid`=$userid AND departmentid=$departmentid and valid=1) then
				SET $valid=1;
			end if;
		else
			SET $valid=IFNULL((SELECT `valid` FROM `materialrequestapprovalusers` WHERE `userid`=$userid AND departmentid=$departmentid AND `approvallevelid`=$approvallevel and valid=1),0);
		end if;
	END IF;
	
	SELECT $valid AS `allowed`;
	
	
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_validateuserprivilege` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_validateuserprivilege` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`wovijlbc`@`localhost` PROCEDURE `sp_validateuserprivilege`($userid int,$objectid int)
BEGIN
	declare $admin int;
	declare $valid int default 0;
	set $admin=(select systemadmin from `user` where `id`=$userid);
	if $admin=1 then
		set $valid=1;
	else
		set $valid=ifnull((select `allowed` from `userprivileges` where `userid`=$userid and `objectid`=$objectid),0);
	end if;
	
	select $valid as `allowed`;
	
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
 `invoicepayment` decimal(33,0) ,
 `order` int(1) 
)*/;

/*Table structure for table `vwopenorders` */

DROP TABLE IF EXISTS `vwopenorders`;

/*!50001 DROP VIEW IF EXISTS `vwopenorders` */;
/*!50001 DROP TABLE IF EXISTS `vwopenorders` */;

/*!50001 CREATE TABLE  `vwopenorders`(
 `purchaseorderno` varchar(50) ,
 `date` datetime ,
 `supplierid` int(11) ,
 `itemcode` int(50) ,
 `quanity` decimal(10,2) ,
 `received` decimal(32,2) 
)*/;

/*Table structure for table `vwopenpayables` */

DROP TABLE IF EXISTS `vwopenpayables`;

/*!50001 DROP VIEW IF EXISTS `vwopenpayables` */;
/*!50001 DROP TABLE IF EXISTS `vwopenpayables` */;

/*!50001 CREATE TABLE  `vwopenpayables`(
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
 `itemid` int(50) ,
 `itemcode` varchar(50) ,
 `itemname` varchar(50) ,
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
 `username` varchar(50) 
)*/;

/*Table structure for table `vwsalessummary2` */

DROP TABLE IF EXISTS `vwsalessummary2`;

/*!50001 DROP VIEW IF EXISTS `vwsalessummary2` */;
/*!50001 DROP TABLE IF EXISTS `vwsalessummary2` */;

/*!50001 CREATE TABLE  `vwsalessummary2`(
 `transactiondate` datetime ,
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
 `itemname` varchar(50) ,
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
 `itemname` varchar(50) ,
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

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwcustomerreceipts` AS (select `r`.`id` AS `id`,date_format(`r`.`receiptdate`,'%Y-%m-%d') AS `date`,`o`.`posname` AS `posname`,`c`.`customername` AS `customername`,`r`.`receiptno` AS `receiptno`,`r`.`modeofpayment` AS `paymentmodeid`,`p`.`description` AS `description`,`r`.`referenceno` AS `reference`,ifnull(`r`.`banked`,0) AS `banked`,sum(`rd`.`amount`) AS `amount`,concat(`u`.`firstname`,' ',`u`.`lastname`) AS `addedby` from (((((`customerreceipts` `r` join `customerreceiptdetails` `rd`) join `customers` `c`) join `paymentmethods` `p`) join `pointsofsale` `o`) join `user` `u`) where `r`.`id` = `rd`.`receiptid` and `r`.`customerid` = `c`.`customerid` and `c`.`posid` = `o`.`id` and `r`.`modeofpayment` = `p`.`id` and ifnull(`r`.`deleted`,0) = 0 and `r`.`addedby` = `u`.`id` group by `r`.`id`,`o`.`posname`,`c`.`customername`,`r`.`receiptno`,`r`.`modeofpayment`,`p`.`description`,`r`.`referenceno`,`r`.`banked`,concat(`u`.`firstname`,' ',`u`.`lastname`) order by date_format(`r`.`receiptdate`,'%Y-%m-%d')) */;

/*View structure for view vwcustomerstomerstatement */

/*!50001 DROP TABLE IF EXISTS `vwcustomerstomerstatement` */;
/*!50001 DROP VIEW IF EXISTS `vwcustomerstomerstatement` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwcustomerstomerstatement` AS select `p`.`id` AS `id`,`c`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`c`.`physicaladdress` AS `physicaladdress`,`c`.`postaladdress` AS `postaladdress`,`c`.`mobile` AS `mobile`,`c`.`email` AS `email`,`p`.`receiptdate` AS `date`,'Invoice issued to customer' AS `narration`,`pm`.`reference` AS `reference`,`pm`.`amount` AS `invoiceamount`,0 AS `invoicepayment`,0 AS `order` from (((`customers` `c` join `possales` `p`) join `possalesdetails` `pd`) join `possalespayments` `pm`) where `c`.`customerid` = `p`.`customerid` and `p`.`id` = `pd`.`possaleid` and `pm`.`possaleid` = `p`.`id` and `pm`.`paymentmode` = 4 and date_format(`p`.`receiptdate`,'%Y-%m-%d') >= (select date_format(`startingparameters`.`cutoffdate`,'%Y-%m-%d') from `startingparameters`) group by `c`.`customerid`,`c`.`customername`,`c`.`physicaladdress`,`c`.`postaladdress`,`c`.`mobile`,`c`.`email`,`pm`.`reference`,`p`.`receiptdate` union select `cr`.`id` AS `id`,`c`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`c`.`physicaladdress` AS `physicaladdress`,`c`.`postaladdress` AS `postaladdress`,`c`.`mobile` AS `mobile`,`c`.`email` AS `email`,`cr`.`receiptdate` AS `date`,'Payment received. Thank You' AS `narration`,`cr`.`receiptno` AS `receiptno`,0 AS `invoiceamount`,sum(`cd`.`amount`) + 0 AS `invoicepayment`,1 AS `order` from ((`customers` `c` join `customerreceipts` `cr`) join `customerreceiptdetails` `cd`) where `c`.`customerid` = `cr`.`customerid` and `cr`.`id` = `cd`.`receiptid` and date_format(`cr`.`receiptdate`,'%Y-%m-%d') >= (select date_format(`startingparameters`.`cutoffdate`,'%Y-%m-%d') from `startingparameters`) group by `cr`.`id`,`c`.`customerid`,`c`.`customername`,`c`.`physicaladdress`,`c`.`postaladdress`,`c`.`mobile`,`c`.`email`,`cr`.`receiptdate`,`cr`.`receiptno` order by `date`,`order` */;

/*View structure for view vwopenorders */

/*!50001 DROP TABLE IF EXISTS `vwopenorders` */;
/*!50001 DROP VIEW IF EXISTS `vwopenorders` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwopenorders` AS (select `p`.`purchaseorderno` AS `purchaseorderno`,`p`.`date` AS `date`,`p`.`supplierid` AS `supplierid`,`pd`.`itemcode` AS `itemcode`,`pd`.`quanity` AS `quanity`,ifnull((select sum(`gd`.`quantity`) from (`goodsreceived` `g` join `goodsreceiveddetails` `gd`) where `g`.`grnno` = `gd`.`grnno` and `gd`.`itemcode` = `pd`.`itemcode`),0) AS `received` from (`purchaseorders` `p` join `purchaseorderdetails` `pd`) where `p`.`id` = `pd`.`purchaseorderid`) */;

/*View structure for view vwopenpayables */

/*!50001 DROP TABLE IF EXISTS `vwopenpayables` */;
/*!50001 DROP VIEW IF EXISTS `vwopenpayables` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwopenpayables` AS (select `si`.`supplierid` AS `supplierid`,`si`.`invoiceno` AS `invoiceno`,`si`.`invoicedate` AS `invoicedate`,`si`.`status` AS `status`,sum(`sid`.`quantity` * `sid`.`unitprice`) AS `invoiceamount`,ifnull((select sum(`pd`.`quantity` * `pd`.`unitprice`) from (`paymentvouchers` `p` join `paymentvoucherdetails` `pd`) where `p`.`id` = `pd`.`voucherid` and `pd`.`invoicenumber` = `si`.`invoiceno`),0) AS `settled` from (`supplierinvoice` `si` join `supplierinvoicedetails` `sid`) where `si`.`id` = `sid`.`invoiceid` and date_format(`si`.`invoicedate`,'%Y-%m-%d') >= (select date_format(`startingparameters`.`cutoffdate`,'%Y-%m-%d') from `startingparameters`) group by `si`.`supplierid`,`si`.`invoiceno`,`si`.`invoicedate`,`si`.`status` having sum(`sid`.`quantity` * `sid`.`unitprice`) > ifnull((select sum(`pd`.`quantity` * `pd`.`unitprice`) from (`paymentvouchers` `p` join `paymentvoucherdetails` `pd`) where `p`.`id` = `pd`.`voucherid` and `pd`.`invoicenumber` = `si`.`invoiceno`),0)) */;

/*View structure for view vwpaymentvouchers */

/*!50001 DROP TABLE IF EXISTS `vwpaymentvouchers` */;
/*!50001 DROP VIEW IF EXISTS `vwpaymentvouchers` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwpaymentvouchers` AS (select `p`.`id` AS `voucherid`,ifnull(`p`.`pettycashvoucher`,0) AS `pettycashvoucher`,`p`.`voucherno` AS `voucherno`,date_format(`p`.`date`,'%Y-%m-%d') AS `voucherdate`,`p`.`paymentmode` AS `paymentmodeid`,`m`.`description` AS `paymentmodedescription`,`p`.`pos` AS `posid`,`o`.`posname` AS `posname`,`p`.`supplier` AS `supplierid`,`s`.`suppliername` AS `suppliername`,`pd`.`invoicenumber` AS `invoicenumber`,`p`.`cashbookaccount` AS `cashbookaccountid`,`a`.`accountcode` AS `accountcode`,`a`.`accountname` AS `accountname`,`p`.`referenceno` AS `referenceno`,`p`.`status` AS `status`,sum(`pd`.`quantity` * `pd`.`unitprice`) AS `vouchertotal`,`p`.`addedby` AS `userid`,concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `username` from ((((((`paymentvouchers` `p` join `paymentvoucherdetails` `pd`) join `suppliers` `s`) join `paymentmethods` `m`) join `pointsofsale` `o`) join `glaccounts` `a`) join `user` `u`) where `p`.`id` = `pd`.`voucherid` and `p`.`supplier` = `s`.`supplierid` and `p`.`paymentmode` = `m`.`id` and `p`.`cashbookaccount` = `a`.`id` and `p`.`addedby` = `u`.`id` and `p`.`pos` = `o`.`id` group by `p`.`voucherno`) */;

/*View structure for view vwpointofsaleitembalances */

/*!50001 DROP TABLE IF EXISTS `vwpointofsaleitembalances` */;
/*!50001 DROP VIEW IF EXISTS `vwpointofsaleitembalances` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwpointofsaleitembalances` AS (select `s`.`id` AS `posid`,`s`.`posname` AS `posname`,`td`.`itemcode` AS `itemid`,`p`.`itemcode` AS `itemcode`,`p`.`itemname` AS `itemname`,`p`.`unitofmeasure` AS `unitofmeasure`,`p`.`buyingprice` AS `buyingprice`,ifnull(sum(if(`t`.`destinationid` = `s`.`id` and `t`.`destinationtype` = 'pos' and `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) AS `unitsreceived`,ifnull(sum(if(`t`.`sourceid` = `s`.`id` and `t`.`sourcetype` = 'pos' and `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) AS `issued` from (((`pointsofsale` `s` join `products` `p`) join `stocktransfer` `t`) join `stocktransferdetails` `td`) where (`s`.`id` = `t`.`sourceid` or `s`.`id` = `t`.`destinationid`) and `t`.`id` = `td`.`transferid` and `td`.`itemcode` = `p`.`productid` and `t`.`dateadded` >= ifnull((select `startingparameters`.`cutoffdate` from `startingparameters`),current_timestamp()) group by `s`.`id`,`s`.`posname`,`td`.`itemcode`,`p`.`itemcode`,`p`.`itemname`,`p`.`unitofmeasure`,`p`.`buyingprice`) */;

/*View structure for view vwsalessummary */

/*!50001 DROP TABLE IF EXISTS `vwsalessummary` */;
/*!50001 DROP VIEW IF EXISTS `vwsalessummary` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwsalessummary` AS (select date_format(`p`.`receiptdate`,'%Y-%m-%d') AS `transactiondate`,`pm`.`id` AS `id`,`p`.`receiptno` AS `receiptno`,`m`.`description` AS `paymentmode`,`pm`.`reference` AS `paymentmodereference`,`s`.`posname` AS `pointofsale`,`p`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`p`.`addedby` AS `userid`,`pm`.`amount` AS `receipttotal`,`p`.`pointofsaleid` AS `posid`,ifnull(`pm`.`banked`,0) AS `banked`,concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `userfullname`,`u`.`username` AS `username` from ((((((`pointsofsale` `s` join `possales` `p`) join `possalesdetails` `pd`) join `user` `u`) join `customers` `c`) join `paymentmethods` `m`) join `possalespayments` `pm`) where `p`.`id` = `pd`.`possaleid` and `p`.`customerid` = `c`.`customerid` and `p`.`addedby` = `u`.`id` and `p`.`pointofsaleid` = `s`.`id` and `pm`.`paymentmode` = `m`.`id` and `p`.`id` = `pm`.`possaleid` and ifnull(`p`.`deleted`,0) = 0 group by `p`.`receiptdate`,`p`.`receiptno`,`u`.`username`,`u`.`id`,`s`.`posname`,`p`.`customerid`,`c`.`customername`,`p`.`addedby`,`m`.`description`,`pm`.`reference`,`pm`.`id`,`p`.`pointofsaleid`,`pm`.`banked`,`u`.`firstname`,`u`.`middlename`,`u`.`lastname`) */;

/*View structure for view vwsalessummary2 */

/*!50001 DROP TABLE IF EXISTS `vwsalessummary2` */;
/*!50001 DROP VIEW IF EXISTS `vwsalessummary2` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwsalessummary2` AS (select `p`.`receiptdate` AS `transactiondate`,`pm`.`id` AS `id`,`p`.`receiptno` AS `receiptno`,`m`.`description` AS `paymentmode`,`pm`.`reference` AS `paymentmodereference`,`s`.`posname` AS `pointofsale`,`p`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`p`.`addedby` AS `userid`,`pm`.`amount` AS `receipttotal`,sum(`pd`.`quantity`) AS `quantity`,`p`.`pointofsaleid` AS `posid`,coalesce(`pm`.`banked`,0) AS `banked`,`u`.`firstname` AS `userfullname`,`u`.`username` AS `username` from ((((((`pointsofsale` `s` join `possales` `p` on(`p`.`pointofsaleid` = `s`.`id`)) join `possalesdetails` `pd` on(`p`.`id` = `pd`.`possaleid`)) join `user` `u` on(`p`.`addedby` = `u`.`id`)) join `customers` `c` on(`p`.`customerid` = `c`.`customerid`)) join `possalespayments` `pm` on(`p`.`id` = `pm`.`possaleid`)) join `paymentmethods` `m` on(`pm`.`paymentmode` = `m`.`id`)) where coalesce(`p`.`deleted`,0) = 0 group by `p`.`receiptdate`,`p`.`receiptno`,`u`.`username`,`u`.`id`,`s`.`posname`,`p`.`customerid`,`c`.`customername`,`p`.`addedby`,`m`.`description`,`pm`.`reference`,`pm`.`id`,`p`.`pointofsaleid`,`pm`.`banked`,`u`.`firstname`) */;

/*View structure for view vwstockcenters */

/*!50001 DROP TABLE IF EXISTS `vwstockcenters` */;
/*!50001 DROP VIEW IF EXISTS `vwstockcenters` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwstockcenters` AS select `pointsofsale`.`posname` AS `posname` from `pointsofsale` union select `warehouses`.`description` AS `description` from `warehouses` */;

/*View structure for view vwstockdetails */

/*!50001 DROP TABLE IF EXISTS `vwstockdetails` */;
/*!50001 DROP VIEW IF EXISTS `vwstockdetails` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwstockdetails` AS select date_format(`p`.`receiptdate`,'%d-%b-%Y') AS `date`,`s`.`posname` AS `posname`,`m`.`itemcode` AS `itemcode`,`m`.`itemname` AS `itemname`,`m`.`unitofmeasure` AS `unitofmeasure`,`m`.`buyingprice` AS `buyingprice`,avg(`pd`.`unitprice`) AS `sellingprice`,0 AS `purchases`,sum(`pd`.`quantity`) AS `quantitysold`,ifnull((select sum(`sd`.`quantity`) from (`stocktransfer` `s` join `stocktransferdetails` `sd`) where `s`.`id` = `sd`.`transferid` and `sd`.`itemcode` = `pd`.`itemcode` and `s`.`sourcetype` = 'pos' and `s`.`sourceid` = `s`.`id` and date_format(`s`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`receiptdate`,'%d-%b-%Y')),0) AS `transfersout`,ifnull((select sum(`sd`.`quantity`) from (`stocktransfer` `s` join `stocktransferdetails` `sd`) where `s`.`id` = `sd`.`transferid` and `sd`.`itemcode` = `pd`.`itemcode` and `s`.`destinationtype` = 'pos' and `s`.`destinationid` = `s`.`id` and date_format(`s`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`receiptdate`,'%d-%b-%Y')),0) AS `transfersin` from (((`products` `m` join `possales` `p`) join `possalesdetails` `pd`) join `pointsofsale` `s`) where `m`.`productid` = `pd`.`itemcode` and `p`.`id` = `pd`.`possaleid` and `p`.`pointofsaleid` = `s`.`id` group by date_format(`p`.`receiptdate`,'%d-b-Y'),`m`.`itemcode`,`m`.`itemname`,`m`.`unitofmeasure`,`m`.`buyingprice`,`s`.`posname` union select date_format(`p`.`datereceived`,'%d-%b-%Y') AS `date`,`s`.`description` AS `posname`,`m`.`itemcode` AS `itemcode`,`m`.`itemname` AS `itemname`,`m`.`unitofmeasure` AS `unitofmeasure`,ifnull((select avg(`xd`.`unitprice`) from (`purchaseorders` `x` join `purchaseorderdetails` `xd`) where `x`.`id` = `xd`.`purchaseorderid` and `x`.`purchaseorderno` = `pd`.`purchaseorderno`),0) AS `buyingprice`,`m`.`sellingprice` AS `sellingprice`,sum(`pd`.`quantity`) AS `purchases`,0 AS `quantitysold`,ifnull((select sum(`sd`.`quantity`) from (`stocktransfer` `s` join `stocktransferdetails` `sd`) where `s`.`id` = `sd`.`transferid` and `sd`.`itemcode` = `pd`.`itemcode` and `s`.`sourcetype` = 'warehouse' and `s`.`sourceid` = `s`.`id` and date_format(`s`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`datereceived`,'%d-%b-%Y')),0) AS `transfersout`,ifnull((select sum(`sd`.`quantity`) from (`stocktransfer` `s` join `stocktransferdetails` `sd`) where `s`.`id` = `sd`.`transferid` and `sd`.`itemcode` = `pd`.`itemcode` and `s`.`destinationtype` = 'warehouse' and `s`.`destinationid` = `s`.`id` and date_format(`s`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`datereceived`,'%d-%b-%Y')),0) AS `transfersin` from (((`products` `m` join `goodsreceived` `p`) join `goodsreceiveddetails` `pd`) join `warehouses` `s`) where `m`.`productid` = `pd`.`itemcode` and `p`.`grnno` = `pd`.`grnno` and `p`.`warehouseid` = `s`.`id` group by date_format(`p`.`datereceived`,'%d-b-Y'),`m`.`itemcode`,`m`.`itemname`,`m`.`unitofmeasure`,`m`.`buyingprice`,`s`.`description` */;

/*View structure for view vwstocktransfers */

/*!50001 DROP TABLE IF EXISTS `vwstocktransfers` */;
/*!50001 DROP VIEW IF EXISTS `vwstocktransfers` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwstocktransfers` AS (select `t`.`referenceno` AS `referenceno`,`t`.`sourcetype` AS `sourcetype`,`t`.`sourceid` AS `sourceid`,case when `t`.`sourcetype` = 'warehouse' then (select `warehouses`.`description` from `warehouses` where `warehouses`.`id` = `t`.`sourceid`) else (select `pointsofsale`.`posname` from `pointsofsale` where `pointsofsale`.`id` = `t`.`sourceid`) end AS `sourcename`,`t`.`destinationtype` AS `destinationtype`,`t`.`destinationid` AS `destinationid`,case when `t`.`destinationtype` = 'warehouse' then (select `warehouses`.`description` from `warehouses` where `warehouses`.`id` = `t`.`destinationid`) else (select `pointsofsale`.`posname` from `pointsofsale` where `pointsofsale`.`id` = `t`.`destinationid`) end AS `destinationame`,`t`.`addedby` AS `addedby`,`t`.`dateadded` AS `dateadded`,concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `username`,ifnull(concat(`i`.`firstname`,' ',`i`.`middlename`,' ',`i`.`lastname`),'_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _') AS `issuedto`,ifnull(concat(`c`.`firstname`,' ',`c`.`middlename`,' ',`c`.`lastname`),'_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _') AS `storecontroller` from (((`stocktransfer` `t` join `user` `u` on(`t`.`addedby` = `u`.`id`)) left join `user` `i` on(`i`.`id` = `t`.`issuedto`)) left join `user` `c` on(`c`.`id` = `t`.`storecontroller`)) order by `t`.`dateadded`) */;

/*View structure for view vwstores */

/*!50001 DROP TABLE IF EXISTS `vwstores` */;
/*!50001 DROP VIEW IF EXISTS `vwstores` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwstores` AS select `pointsofsale`.`posname` AS `posname` from `pointsofsale` where ifnull(`pointsofsale`.`deleted`,0) = 0 union select `warehouses`.`description` AS `description` from `warehouses` */;

/*View structure for view vwsupplierstatement */

/*!50001 DROP TABLE IF EXISTS `vwsupplierstatement` */;
/*!50001 DROP VIEW IF EXISTS `vwsupplierstatement` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwsupplierstatement` AS select `s`.`supplierid` AS `supplierid`,`s`.`suppliername` AS `suppliername`,`s`.`physicaladdress` AS `physicaladdress`,`s`.`postaladdress` AS `postaladdress`,`s`.`mobile` AS `mobile`,`s`.`email` AS `email`,`si`.`invoicedate` AS `invoicedate`,`si`.`invoiceno` AS `reference`,'Invoice received' AS `narrative`,sum(`sid`.`quantity` * `sid`.`unitprice`) AS `invoiceamount`,0 AS `invoicepayment`,0 AS `order` from ((`suppliers` `s` join `supplierinvoice` `si`) join `supplierinvoicedetails` `sid`) where `s`.`supplierid` = `si`.`supplierid` and `si`.`id` = `sid`.`invoiceid` group by `s`.`supplierid`,`s`.`suppliername`,`s`.`physicaladdress`,`s`.`postaladdress`,`s`.`mobile`,`s`.`email`,`si`.`invoicedate`,`si`.`invoiceno` union select `s`.`supplierid` AS `supplierid`,`s`.`suppliername` AS `suppliername`,`s`.`physicaladdress` AS `physicaladdress`,`s`.`postaladdress` AS `postaladdress`,`s`.`mobile` AS `mobile`,`s`.`email` AS `email`,`p`.`date` AS `date`,`p`.`voucherno` AS `voucherno`,concat('Payment issued via reference #',`p`.`referenceno`) AS `narrative`,0 AS `invoiceamount`,sum(`pd`.`quantity` * `pd`.`unitprice`) AS `invoicepayment`,1 AS `order` from ((`suppliers` `s` join `paymentvouchers` `p`) join `paymentvoucherdetails` `pd`) where `s`.`supplierid` = `p`.`supplier` and `p`.`id` = `pd`.`voucherid` group by `s`.`supplierid`,`s`.`suppliername`,`s`.`physicaladdress`,`s`.`postaladdress`,`s`.`mobile`,`s`.`email`,`p`.`date`,`p`.`voucherno`,`p`.`referenceno` */;

/*View structure for view vwwarehouseitembalances */

/*!50001 DROP TABLE IF EXISTS `vwwarehouseitembalances` */;
/*!50001 DROP VIEW IF EXISTS `vwwarehouseitembalances` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`wovijlbc`@`localhost` SQL SECURITY DEFINER VIEW `vwwarehouseitembalances` AS (select `w`.`id` AS `warehouseid`,`w`.`description` AS `warehousename`,`p`.`itemcode` AS `itemcode`,`p`.`itemname` AS `itemname`,`p`.`productid` AS `productid`,`p`.`unitofmeasure` AS `unitofmeasure`,`p`.`buyingprice` AS `buyingprice`,`p`.`sellingprice` AS `sellingprice`,`p`.`serializable` AS `serializable`,sum(`gd`.`quantity`) + ifnull((select sum(`sd`.`quantity`) from (`stocktransferdetails` `sd` join `stocktransfer` `s`) where `s`.`id` = `sd`.`transferid` and `s`.`destinationtype` = 'warehouse' and `s`.`destinationid` = `w`.`id` and `sd`.`itemcode` = `p`.`productid` and `s`.`dateadded` >= ifnull((select `startingparameters`.`cutoffdate` from `startingparameters`),current_timestamp())),0) AS `unitsreceived`,ifnull((select sum(`sd`.`quantity`) from (`stocktransferdetails` `sd` join `stocktransfer` `s`) where `s`.`id` = `sd`.`transferid` and `s`.`sourcetype` = 'warehouse' and `s`.`sourceid` = `w`.`id` and `sd`.`itemcode` = `p`.`productid` and `s`.`dateadded` >= ifnull((select `startingparameters`.`cutoffdate` from `startingparameters`),current_timestamp())),0) AS `issued` from (((`goodsreceived` `g` join `goodsreceiveddetails` `gd`) join `products` `p`) join `warehouses` `w`) where `w`.`id` = `g`.`warehouseid` and `g`.`grnno` = `gd`.`grnno` and `gd`.`itemcode` = `p`.`productid` group by `p`.`itemcode`,`p`.`itemname`,`p`.`unitofmeasure`,`p`.`buyingprice`,`p`.`sellingprice`,`p`.`serializable`,`w`.`id`,`w`.`description`,`p`.`productid`) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
