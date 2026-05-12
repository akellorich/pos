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

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwcustomerreceipts` AS (select `r`.`id` AS `id`,date_format(`r`.`receiptdate`,'%Y-%m-%d') AS `date`,`o`.`posname` AS `posname`,`c`.`customername` AS `customername`,`r`.`receiptno` AS `receiptno`,`r`.`modeofpayment` AS `paymentmodeid`,`p`.`description` AS `description`,`r`.`referenceno` AS `reference`,ifnull(`r`.`banked`,0) AS `banked`,sum(`rd`.`amount`) AS `amount`,concat(`u`.`firstname`,' ',`u`.`lastname`) AS `addedby` from (((((`customerreceipts` `r` join `customerreceiptdetails` `rd`) join `customers` `c`) join `paymentmethods` `p`) join `pointsofsale` `o`) join `user` `u`) where `r`.`id` = `rd`.`receiptid` and `r`.`customerid` = `c`.`customerid` and `c`.`posid` = `o`.`id` and `r`.`modeofpayment` = `p`.`id` and ifnull(`r`.`deleted`,0) = 0 and `r`.`addedby` = `u`.`id` group by `r`.`id`,`o`.`posname`,`c`.`customername`,`r`.`receiptno`,`r`.`modeofpayment`,`p`.`description`,`r`.`referenceno`,`r`.`banked`,concat(`u`.`firstname`,' ',`u`.`lastname`) order by date_format(`r`.`receiptdate`,'%Y-%m-%d')) */;

/*View structure for view vwcustomerstomerstatement */

/*!50001 DROP TABLE IF EXISTS `vwcustomerstomerstatement` */;
/*!50001 DROP VIEW IF EXISTS `vwcustomerstomerstatement` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwcustomerstomerstatement` AS select `p`.`id` AS `id`,`c`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`c`.`physicaladdress` AS `physicaladdress`,`c`.`postaladdress` AS `postaladdress`,`c`.`mobile` AS `mobile`,`c`.`email` AS `email`,`p`.`receiptdate` AS `date`,'Invoice issued to customer' AS `narration`,`pm`.`reference` AS `reference`,`pm`.`amount` AS `invoiceamount`,0 AS `invoicepayment`,0 AS `order` from (((`customers` `c` join `possales` `p`) join `possalesdetails` `pd`) join `possalespayments` `pm`) where `c`.`customerid` = `p`.`customerid` and `p`.`id` = `pd`.`possaleid` and `pm`.`possaleid` = `p`.`id` and `pm`.`paymentmode` = 4 and date_format(`p`.`receiptdate`,'%Y-%m-%d') >= (select date_format(`startingparameters`.`cutoffdate`,'%Y-%m-%d') from `startingparameters`) group by `c`.`customerid`,`c`.`customername`,`c`.`physicaladdress`,`c`.`postaladdress`,`c`.`mobile`,`c`.`email`,`pm`.`reference`,`p`.`receiptdate` union select `cr`.`id` AS `id`,`c`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`c`.`physicaladdress` AS `physicaladdress`,`c`.`postaladdress` AS `postaladdress`,`c`.`mobile` AS `mobile`,`c`.`email` AS `email`,`cr`.`receiptdate` AS `date`,'Payment received. Thank You' AS `narration`,`cr`.`receiptno` AS `receiptno`,0 AS `invoiceamount`,sum(`cd`.`amount`) + 0 AS `invoicepayment`,1 AS `order` from ((`customers` `c` join `customerreceipts` `cr`) join `customerreceiptdetails` `cd`) where `c`.`customerid` = `cr`.`customerid` and `cr`.`id` = `cd`.`receiptid` and date_format(`cr`.`receiptdate`,'%Y-%m-%d') >= (select date_format(`startingparameters`.`cutoffdate`,'%Y-%m-%d') from `startingparameters`) group by `cr`.`id`,`c`.`customerid`,`c`.`customername`,`c`.`physicaladdress`,`c`.`postaladdress`,`c`.`mobile`,`c`.`email`,`cr`.`receiptdate`,`cr`.`receiptno` order by `date`,`order` */;

/*View structure for view vwopenorders */

/*!50001 DROP TABLE IF EXISTS `vwopenorders` */;
/*!50001 DROP VIEW IF EXISTS `vwopenorders` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwopenorders` AS (select `p`.`purchaseorderno` AS `purchaseorderno`,`p`.`date` AS `date`,`p`.`supplierid` AS `supplierid`,`pd`.`itemcode` AS `itemcode`,`pd`.`quanity` AS `quanity`,ifnull((select sum(`gd`.`quantity`) from (`goodsreceived` `g` join `goodsreceiveddetails` `gd`) where `g`.`grnno` = `gd`.`grnno` and `gd`.`itemcode` = `pd`.`itemcode`),0) AS `received` from (`purchaseorders` `p` join `purchaseorderdetails` `pd`) where `p`.`id` = `pd`.`purchaseorderid`) */;

/*View structure for view vwopenpayables */

/*!50001 DROP TABLE IF EXISTS `vwopenpayables` */;
/*!50001 DROP VIEW IF EXISTS `vwopenpayables` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwopenpayables` AS (select `si`.`supplierid` AS `supplierid`,`si`.`invoiceno` AS `invoiceno`,`si`.`invoicedate` AS `invoicedate`,`si`.`status` AS `status`,sum(`sid`.`quantity` * `sid`.`unitprice`) AS `invoiceamount`,ifnull((select sum(`pd`.`quantity` * `pd`.`unitprice`) from (`paymentvouchers` `p` join `paymentvoucherdetails` `pd`) where `p`.`id` = `pd`.`voucherid` and `pd`.`invoicenumber` = `si`.`invoiceno`),0) AS `settled` from (`supplierinvoice` `si` join `supplierinvoicedetails` `sid`) where `si`.`id` = `sid`.`invoiceid` and date_format(`si`.`invoicedate`,'%Y-%m-%d') >= (select date_format(`startingparameters`.`cutoffdate`,'%Y-%m-%d') from `startingparameters`) group by `si`.`supplierid`,`si`.`invoiceno`,`si`.`invoicedate`,`si`.`status` having sum(`sid`.`quantity` * `sid`.`unitprice`) > ifnull((select sum(`pd`.`quantity` * `pd`.`unitprice`) from (`paymentvouchers` `p` join `paymentvoucherdetails` `pd`) where `p`.`id` = `pd`.`voucherid` and `pd`.`invoicenumber` = `si`.`invoiceno`),0)) */;

/*View structure for view vwpaymentvouchers */

/*!50001 DROP TABLE IF EXISTS `vwpaymentvouchers` */;
/*!50001 DROP VIEW IF EXISTS `vwpaymentvouchers` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwpaymentvouchers` AS (select `p`.`id` AS `voucherid`,ifnull(`p`.`pettycashvoucher`,0) AS `pettycashvoucher`,`p`.`voucherno` AS `voucherno`,date_format(`p`.`date`,'%Y-%m-%d') AS `voucherdate`,`p`.`paymentmode` AS `paymentmodeid`,`m`.`description` AS `paymentmodedescription`,`p`.`pos` AS `posid`,`o`.`posname` AS `posname`,`p`.`supplier` AS `supplierid`,`s`.`suppliername` AS `suppliername`,`pd`.`invoicenumber` AS `invoicenumber`,`p`.`cashbookaccount` AS `cashbookaccountid`,`a`.`accountcode` AS `accountcode`,`a`.`accountname` AS `accountname`,`p`.`referenceno` AS `referenceno`,`p`.`status` AS `status`,sum(`pd`.`quantity` * `pd`.`unitprice`) AS `vouchertotal`,`p`.`addedby` AS `userid`,concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `username` from ((((((`paymentvouchers` `p` join `paymentvoucherdetails` `pd`) join `suppliers` `s`) join `paymentmethods` `m`) join `pointsofsale` `o`) join `glaccounts` `a`) join `user` `u`) where `p`.`id` = `pd`.`voucherid` and `p`.`supplier` = `s`.`supplierid` and `p`.`paymentmode` = `m`.`id` and `p`.`cashbookaccount` = `a`.`id` and `p`.`addedby` = `u`.`id` and `p`.`pos` = `o`.`id` group by `p`.`voucherno`) */;

/*View structure for view vwpointofsaleitembalances */

/*!50001 DROP TABLE IF EXISTS `vwpointofsaleitembalances` */;
/*!50001 DROP VIEW IF EXISTS `vwpointofsaleitembalances` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwpointofsaleitembalances` AS (select `s`.`id` AS `posid`,`s`.`posname` AS `posname`,`td`.`itemcode` AS `itemid`,`p`.`itemcode` AS `itemcode`,`p`.`itemname` AS `itemname`,`p`.`unitofmeasure` AS `unitofmeasure`,`p`.`buyingprice` AS `buyingprice`,ifnull(sum(if(`t`.`destinationid` = `s`.`id` and `t`.`destinationtype` = 'pos' and `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) AS `unitsreceived`,ifnull(sum(if(`t`.`sourceid` = `s`.`id` and `t`.`sourcetype` = 'pos' and `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) AS `issued` from (((`pointsofsale` `s` join `products` `p`) join `stocktransfer` `t`) join `stocktransferdetails` `td`) where (`s`.`id` = `t`.`sourceid` or `s`.`id` = `t`.`destinationid`) and `t`.`id` = `td`.`transferid` and `td`.`itemcode` = `p`.`productid` and `t`.`dateadded` >= ifnull((select `startingparameters`.`cutoffdate` from `startingparameters`),current_timestamp()) group by `s`.`id`,`s`.`posname`,`td`.`itemcode`,`p`.`itemcode`,`p`.`itemname`,`p`.`unitofmeasure`,`p`.`buyingprice`) */;

/*View structure for view vwsalessummary */

/*!50001 DROP TABLE IF EXISTS `vwsalessummary` */;
/*!50001 DROP VIEW IF EXISTS `vwsalessummary` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwsalessummary` AS (select date_format(`p`.`receiptdate`,'%Y-%m-%d') AS `transactiondate`,`pm`.`id` AS `id`,`p`.`receiptno` AS `receiptno`,`m`.`description` AS `paymentmode`,`pm`.`reference` AS `paymentmodereference`,`s`.`posname` AS `pointofsale`,`p`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`p`.`addedby` AS `userid`,`pm`.`amount` AS `receipttotal`,`p`.`pointofsaleid` AS `posid`,ifnull(`pm`.`banked`,0) AS `banked`,concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `userfullname`,`u`.`username` AS `username` from ((((((`pointsofsale` `s` join `possales` `p`) join `possalesdetails` `pd`) join `user` `u`) join `customers` `c`) join `paymentmethods` `m`) join `possalespayments` `pm`) where `p`.`id` = `pd`.`possaleid` and `p`.`customerid` = `c`.`customerid` and `p`.`addedby` = `u`.`id` and `p`.`pointofsaleid` = `s`.`id` and `pm`.`paymentmode` = `m`.`id` and `p`.`id` = `pm`.`possaleid` and ifnull(`p`.`deleted`,0) = 0 group by `p`.`receiptdate`,`p`.`receiptno`,`u`.`username`,`u`.`id`,`s`.`posname`,`p`.`customerid`,`c`.`customername`,`p`.`addedby`,`m`.`description`,`pm`.`reference`,`pm`.`id`,`p`.`pointofsaleid`,`pm`.`banked`,`u`.`firstname`,`u`.`middlename`,`u`.`lastname`) */;

/*View structure for view vwsalessummary2 */

/*!50001 DROP TABLE IF EXISTS `vwsalessummary2` */;
/*!50001 DROP VIEW IF EXISTS `vwsalessummary2` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwsalessummary2` AS (select `p`.`receiptdate` AS `transactiondate`,`pm`.`id` AS `id`,`p`.`receiptno` AS `receiptno`,`m`.`description` AS `paymentmode`,`pm`.`reference` AS `paymentmodereference`,`s`.`posname` AS `pointofsale`,`p`.`customerid` AS `customerid`,`c`.`customername` AS `customername`,`p`.`addedby` AS `userid`,`pm`.`amount` AS `receipttotal`,sum(`pd`.`quantity`) AS `quantity`,`p`.`pointofsaleid` AS `posid`,coalesce(`pm`.`banked`,0) AS `banked`,`u`.`firstname` AS `userfullname`,`u`.`username` AS `username` from ((((((`pointsofsale` `s` join `possales` `p` on(`p`.`pointofsaleid` = `s`.`id`)) join `possalesdetails` `pd` on(`p`.`id` = `pd`.`possaleid`)) join `user` `u` on(`p`.`addedby` = `u`.`id`)) join `customers` `c` on(`p`.`customerid` = `c`.`customerid`)) join `possalespayments` `pm` on(`p`.`id` = `pm`.`possaleid`)) join `paymentmethods` `m` on(`pm`.`paymentmode` = `m`.`id`)) where coalesce(`p`.`deleted`,0) = 0 group by `p`.`receiptdate`,`p`.`receiptno`,`u`.`username`,`u`.`id`,`s`.`posname`,`p`.`customerid`,`c`.`customername`,`p`.`addedby`,`m`.`description`,`pm`.`reference`,`pm`.`id`,`p`.`pointofsaleid`,`pm`.`banked`,`u`.`firstname`) */;

/*View structure for view vwstockcenters */

/*!50001 DROP TABLE IF EXISTS `vwstockcenters` */;
/*!50001 DROP VIEW IF EXISTS `vwstockcenters` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwstockcenters` AS select `pointsofsale`.`posname` AS `posname` from `pointsofsale` union select `warehouses`.`description` AS `description` from `warehouses` */;

/*View structure for view vwstockdetails */

/*!50001 DROP TABLE IF EXISTS `vwstockdetails` */;
/*!50001 DROP VIEW IF EXISTS `vwstockdetails` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwstockdetails` AS select date_format(`p`.`receiptdate`,'%d-%b-%Y') AS `date`,`s`.`posname` AS `posname`,`m`.`itemcode` AS `itemcode`,`m`.`itemname` AS `itemname`,`m`.`unitofmeasure` AS `unitofmeasure`,`m`.`buyingprice` AS `buyingprice`,avg(`pd`.`unitprice`) AS `sellingprice`,0 AS `purchases`,sum(`pd`.`quantity`) AS `quantitysold`,ifnull((select sum(`sd`.`quantity`) from (`stocktransfer` `s` join `stocktransferdetails` `sd`) where `s`.`id` = `sd`.`transferid` and `sd`.`itemcode` = `pd`.`itemcode` and `s`.`sourcetype` = 'pos' and `s`.`sourceid` = `s`.`id` and date_format(`s`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`receiptdate`,'%d-%b-%Y')),0) AS `transfersout`,ifnull((select sum(`sd`.`quantity`) from (`stocktransfer` `s` join `stocktransferdetails` `sd`) where `s`.`id` = `sd`.`transferid` and `sd`.`itemcode` = `pd`.`itemcode` and `s`.`destinationtype` = 'pos' and `s`.`destinationid` = `s`.`id` and date_format(`s`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`receiptdate`,'%d-%b-%Y')),0) AS `transfersin` from (((`products` `m` join `possales` `p`) join `possalesdetails` `pd`) join `pointsofsale` `s`) where `m`.`productid` = `pd`.`itemcode` and `p`.`id` = `pd`.`possaleid` and `p`.`pointofsaleid` = `s`.`id` group by date_format(`p`.`receiptdate`,'%d-b-Y'),`m`.`itemcode`,`m`.`itemname`,`m`.`unitofmeasure`,`m`.`buyingprice`,`s`.`posname` union select date_format(`p`.`datereceived`,'%d-%b-%Y') AS `date`,`s`.`description` AS `posname`,`m`.`itemcode` AS `itemcode`,`m`.`itemname` AS `itemname`,`m`.`unitofmeasure` AS `unitofmeasure`,ifnull((select avg(`xd`.`unitprice`) from (`purchaseorders` `x` join `purchaseorderdetails` `xd`) where `x`.`id` = `xd`.`purchaseorderid` and `x`.`purchaseorderno` = `pd`.`purchaseorderno`),0) AS `buyingprice`,`m`.`sellingprice` AS `sellingprice`,sum(`pd`.`quantity`) AS `purchases`,0 AS `quantitysold`,ifnull((select sum(`sd`.`quantity`) from (`stocktransfer` `s` join `stocktransferdetails` `sd`) where `s`.`id` = `sd`.`transferid` and `sd`.`itemcode` = `pd`.`itemcode` and `s`.`sourcetype` = 'warehouse' and `s`.`sourceid` = `s`.`id` and date_format(`s`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`datereceived`,'%d-%b-%Y')),0) AS `transfersout`,ifnull((select sum(`sd`.`quantity`) from (`stocktransfer` `s` join `stocktransferdetails` `sd`) where `s`.`id` = `sd`.`transferid` and `sd`.`itemcode` = `pd`.`itemcode` and `s`.`destinationtype` = 'warehouse' and `s`.`destinationid` = `s`.`id` and date_format(`s`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`datereceived`,'%d-%b-%Y')),0) AS `transfersin` from (((`products` `m` join `goodsreceived` `p`) join `goodsreceiveddetails` `pd`) join `warehouses` `s`) where `m`.`productid` = `pd`.`itemcode` and `p`.`grnno` = `pd`.`grnno` and `p`.`warehouseid` = `s`.`id` group by date_format(`p`.`datereceived`,'%d-b-Y'),`m`.`itemcode`,`m`.`itemname`,`m`.`unitofmeasure`,`m`.`buyingprice`,`s`.`description` */;

/*View structure for view vwstocktransfers */

/*!50001 DROP TABLE IF EXISTS `vwstocktransfers` */;
/*!50001 DROP VIEW IF EXISTS `vwstocktransfers` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwstocktransfers` AS (select `t`.`referenceno` AS `referenceno`,`t`.`sourcetype` AS `sourcetype`,`t`.`sourceid` AS `sourceid`,case when `t`.`sourcetype` = 'warehouse' then (select `warehouses`.`description` from `warehouses` where `warehouses`.`id` = `t`.`sourceid`) else (select `pointsofsale`.`posname` from `pointsofsale` where `pointsofsale`.`id` = `t`.`sourceid`) end AS `sourcename`,`t`.`destinationtype` AS `destinationtype`,`t`.`destinationid` AS `destinationid`,case when `t`.`destinationtype` = 'warehouse' then (select `warehouses`.`description` from `warehouses` where `warehouses`.`id` = `t`.`destinationid`) else (select `pointsofsale`.`posname` from `pointsofsale` where `pointsofsale`.`id` = `t`.`destinationid`) end AS `destinationame`,`t`.`addedby` AS `addedby`,`t`.`dateadded` AS `dateadded`,concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `username`,ifnull(concat(`i`.`firstname`,' ',`i`.`middlename`,' ',`i`.`lastname`),'_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _') AS `issuedto`,ifnull(concat(`c`.`firstname`,' ',`c`.`middlename`,' ',`c`.`lastname`),'_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _') AS `storecontroller` from (((`stocktransfer` `t` join `user` `u` on(`t`.`addedby` = `u`.`id`)) left join `user` `i` on(`i`.`id` = `t`.`issuedto`)) left join `user` `c` on(`c`.`id` = `t`.`storecontroller`)) order by `t`.`dateadded`) */;

/*View structure for view vwstores */

/*!50001 DROP TABLE IF EXISTS `vwstores` */;
/*!50001 DROP VIEW IF EXISTS `vwstores` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwstores` AS select `pointsofsale`.`posname` AS `posname` from `pointsofsale` where ifnull(`pointsofsale`.`deleted`,0) = 0 union select `warehouses`.`description` AS `description` from `warehouses` */;

/*View structure for view vwsupplierstatement */

/*!50001 DROP TABLE IF EXISTS `vwsupplierstatement` */;
/*!50001 DROP VIEW IF EXISTS `vwsupplierstatement` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwsupplierstatement` AS select `s`.`supplierid` AS `supplierid`,`s`.`suppliername` AS `suppliername`,`s`.`physicaladdress` AS `physicaladdress`,`s`.`postaladdress` AS `postaladdress`,`s`.`mobile` AS `mobile`,`s`.`email` AS `email`,`si`.`invoicedate` AS `invoicedate`,`si`.`invoiceno` AS `reference`,'Invoice received' AS `narrative`,sum(`sid`.`quantity` * `sid`.`unitprice`) AS `invoiceamount`,0 AS `invoicepayment`,0 AS `order` from ((`suppliers` `s` join `supplierinvoice` `si`) join `supplierinvoicedetails` `sid`) where `s`.`supplierid` = `si`.`supplierid` and `si`.`id` = `sid`.`invoiceid` group by `s`.`supplierid`,`s`.`suppliername`,`s`.`physicaladdress`,`s`.`postaladdress`,`s`.`mobile`,`s`.`email`,`si`.`invoicedate`,`si`.`invoiceno` union select `s`.`supplierid` AS `supplierid`,`s`.`suppliername` AS `suppliername`,`s`.`physicaladdress` AS `physicaladdress`,`s`.`postaladdress` AS `postaladdress`,`s`.`mobile` AS `mobile`,`s`.`email` AS `email`,`p`.`date` AS `date`,`p`.`voucherno` AS `voucherno`,concat('Payment issued via reference #',`p`.`referenceno`) AS `narrative`,0 AS `invoiceamount`,sum(`pd`.`quantity` * `pd`.`unitprice`) AS `invoicepayment`,1 AS `order` from ((`suppliers` `s` join `paymentvouchers` `p`) join `paymentvoucherdetails` `pd`) where `s`.`supplierid` = `p`.`supplier` and `p`.`id` = `pd`.`voucherid` group by `s`.`supplierid`,`s`.`suppliername`,`s`.`physicaladdress`,`s`.`postaladdress`,`s`.`mobile`,`s`.`email`,`p`.`date`,`p`.`voucherno`,`p`.`referenceno` */;

/*View structure for view vwwarehouseitembalances */

/*!50001 DROP TABLE IF EXISTS `vwwarehouseitembalances` */;
/*!50001 DROP VIEW IF EXISTS `vwwarehouseitembalances` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vwwarehouseitembalances` AS (select `w`.`id` AS `warehouseid`,`w`.`description` AS `warehousename`,`p`.`itemcode` AS `itemcode`,`p`.`itemname` AS `itemname`,`p`.`productid` AS `productid`,`p`.`unitofmeasure` AS `unitofmeasure`,`p`.`buyingprice` AS `buyingprice`,`p`.`sellingprice` AS `sellingprice`,`p`.`serializable` AS `serializable`,sum(`gd`.`quantity`) + ifnull((select sum(`sd`.`quantity`) from (`stocktransferdetails` `sd` join `stocktransfer` `s`) where `s`.`id` = `sd`.`transferid` and `s`.`destinationtype` = 'warehouse' and `s`.`destinationid` = `w`.`id` and `sd`.`itemcode` = `p`.`productid` and `s`.`dateadded` >= ifnull((select `startingparameters`.`cutoffdate` from `startingparameters`),current_timestamp())),0) AS `unitsreceived`,ifnull((select sum(`sd`.`quantity`) from (`stocktransferdetails` `sd` join `stocktransfer` `s`) where `s`.`id` = `sd`.`transferid` and `s`.`sourcetype` = 'warehouse' and `s`.`sourceid` = `w`.`id` and `sd`.`itemcode` = `p`.`productid` and `s`.`dateadded` >= ifnull((select `startingparameters`.`cutoffdate` from `startingparameters`),current_timestamp())),0) AS `issued` from (((`goodsreceived` `g` join `goodsreceiveddetails` `gd`) join `products` `p`) join `warehouses` `w`) where `w`.`id` = `g`.`warehouseid` and `g`.`grnno` = `gd`.`grnno` and `gd`.`itemcode` = `p`.`productid` group by `p`.`itemcode`,`p`.`itemname`,`p`.`unitofmeasure`,`p`.`buyingprice`,`p`.`sellingprice`,`p`.`serializable`,`w`.`id`,`w`.`description`,`p`.`productid`) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
