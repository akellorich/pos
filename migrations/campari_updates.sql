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
CREATE DATABASE /*!32312 IF NOT EXISTS*/`distributor` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;

USE `distributor`;

/* Function  structure for function  `fn_getwarehousestockbalance` */

/*!50003 DROP FUNCTION IF EXISTS `fn_getwarehousestockbalance` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `fn_getwarehousestockbalance`($productid int,$warehouseid int) RETURNS decimal(18,2)
BEGIN
	DECLARE $startdate DATE;
	DECLARE $enddate DATE;
	declare $purchases decimal(18,2);
	declare $transfersout decimal(18,2);
	declare $transfersin decimal(18,2);
	
	SELECT IFNULL(DATE_FORMAT(`stockcutoffdate`,'%Y-%m-%d'),'01-01-2001'),DATE_FORMAT(NOW(),'%Y-%m-%d')
	INTO $startdate,$enddate 
	FROM `startingparameters`;
	
	-- Get ware houses receipts
	select sum(quantity) into $purchases 
	from `goodsreceived` g
	join `goodsreceiveddetails` gd on gd.`grnno`=g.`grnno` and `warehouseid`=$warehouseid and `itemcode`=$productid
	and `datereceived` between $startdate and $enddate;
	
	-- Get Transfers out
	select sum(`quantity`) into $transfersout 
	from `stocktransfer` t 
	join `stocktransferdetails` td on td.`transferid`=t.`id`
	where `sourcetype`='warehouse' and `sourceid`=$warehouseid and 
	`itemcode`=$productid and `dateadded` between $startdate and $enddate;
	
	-- Get transfers In
	SELECT SUM(`quantity`) INTO $transfersout 
	FROM `stocktransfer` t 
	JOIN `stocktransferdetails` td ON td.`transferid`=t.`id`
	WHERE `destinationtype`='warehouse' AND `destinationid`=$warehouseid AND 
	`itemcode`=$productid AND `dateadded` BETWEEN $startdate AND $enddate;
	
	return ifnull($purchases,0)-ifnull($transfersout,0)+ifnull($transfersin,0);
	
    END */$$
DELIMITER ;

/* Procedure structure for procedure `spsavestockreconciledbalance` */

/*!50003 DROP PROCEDURE IF EXISTS  `spsavestockreconciledbalance` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `spsavestockreconciledbalance`($refno varchar(50),$narration varchar(50),
$posid int,$category varchar(50), $userid int)
BEGIN
	start transaction;
		-- Insert reconcilliation header
		insert into `stockreconciledbalance`(`reconciliationdate`,`userid`,`narration`,`posid`,`category`)
		values(now(),$userid,$narration,$posid,$category);
		-- Get the Inserted Id
		set @id=(select max(id) from `stockreconciledbalance`);
		
		-- Insert the reconcilliation details
		if $category='outlet' then 		
			insert into `stockreconciledbalancedetails` (`reconciliationid`,`itemid`,`quantity`,`unitprice`)
			select @id, `itemid`,
				case /*when `fn_getitemstorebalance`(itemid,$posid)<0 then
					quantity+abs(`fn_getitemstorebalance`(itemid,$posid))*/
				when `fn_getitemstorebalance`(itemid,$posid)> `quantity` then 
					-1*(`fn_getitemstorebalance`(itemid,$posid)-`quantity`)
				else
					`quantity`-`fn_getitemstorebalance`(itemid,$posid)
				end,
			`unitprice` from `tempstockreconcilebalancedetails` where `refno`=$refno;
		else
			INSERT INTO `stockreconciledbalancedetails` (`reconciliationid`,`itemid`,`quantity`,`unitprice`)
			SELECT @id, `itemid`,
				CASE /*when `fn_getitemstorebalance`(itemid,$posid)<0 then
					quantity+abs(`fn_getitemstorebalance`(itemid,$posid))*/
				WHEN `fn_getwarehousestockbalance`(itemid,$posid)> `quantity` THEN 
					-1*(`fn_getwarehousestockbalance`(itemid,$posid)-`quantity`)
				ELSE
					`quantity`-`fn_getwarehousestockbalance`(itemid,$posid)
				END,
			`unitprice` FROM `tempstockreconcilebalancedetails` WHERE `refno`=$refno;
		end if;
		-- Remove temporary data 
		delete from `tempstockreconcilebalancedetails` where `refno`=$refno;
	commit;	
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
