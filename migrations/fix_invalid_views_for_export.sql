-- Migration: Fix invalid database views to resolve SQLyog Error 1356 when exporting database
-- Description: Recreates views using the correct primary key columns (e.g. customerreceiptid, posid, userid, paymentvoucherid, stocktransferid) 
-- and modern JOIN syntax.

-- 1. vwcustomerreceipts
DROP VIEW IF EXISTS `vwcustomerreceipts`;
CREATE VIEW `vwcustomerreceipts` AS 
select 
  `r`.`customerreceiptid` AS `id`,
  date_format(`r`.`receiptdate`,'%Y-%m-%d') AS `date`,
  `o`.`posname` AS `posname`,
  `c`.`customername` AS `customername`,
  `r`.`receiptno` AS `receiptno`,
  `r`.`modeofpayment` AS `paymentmodeid`,
  `p`.`description` AS `description`,
  `r`.`referenceno` AS `reference`,
  ifnull(`r`.`banked`,0) AS `banked`,
  sum(`rd`.`amount`) AS `amount`,
  concat(`u`.`firstname`,' ',`u`.`lastname`) AS `addedby` 
from `customerreceipts` `r` 
join `customerreceiptdetails` `rd` on `r`.`customerreceiptid` = `rd`.`receiptid`
join `customers` `c` on `r`.`customerid` = `c`.`customerid`
join `paymentmethods` `p` on `r`.`modeofpayment` = `p`.`id`
join `pointsofsale` `o` on `c`.`posid` = `o`.`posid`
join `user` `u` on `r`.`addedby` = `u`.`userid`
where ifnull(`r`.`deleted`,0) = 0 
group by 
  `r`.`customerreceiptid`,
  `o`.`posname`,
  `c`.`customername`,
  `r`.`receiptno`,
  `r`.`modeofpayment`,
  `p`.`description`,
  `r`.`referenceno`,
  `r`.`banked`,
  `u`.`firstname`,
  `u`.`lastname`,
  `r`.`receiptdate`
order by date_format(`r`.`receiptdate`,'%Y-%m-%d');


-- 2. vwpaymentvouchers
DROP VIEW IF EXISTS `vwpaymentvouchers`;
CREATE VIEW `vwpaymentvouchers` AS
select 
  `p`.`paymentvoucherid` AS `voucherid`,
  `p`.`branchid` AS `branchid`,
  ifnull(`p`.`pettycashvoucher`,0) AS `pettycashvoucher`,
  `p`.`voucherno` AS `voucherno`,
  date_format(`p`.`date`,'%Y-%m-%d') AS `voucherdate`,
  `p`.`paymentmode` AS `paymentmodeid`,
  `m`.`description` AS `paymentmodedescription`,
  `p`.`pos` AS `posid`,
  `o`.`posname` AS `posname`,
  `p`.`supplier` AS `supplierid`,
  `s`.`suppliername` AS `suppliername`,
  `pd`.`invoicenumber` AS `invoicenumber`,
  `p`.`cashbookaccount` AS `cashbookaccountid`,
  `a`.`accountcode` AS `accountcode`,
  `a`.`accountname` AS `accountname`,
  `p`.`referenceno` AS `referenceno`,
  `p`.`status` AS `status`,
  sum(`pd`.`quantity` * `pd`.`unitprice`) AS `vouchertotal`,
  `p`.`addedby` AS `userid`,
  concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `username` 
from `paymentvouchers` `p`
join `paymentvoucherdetails` `pd` on `p`.`paymentvoucherid` = `pd`.`voucherid`
join `suppliers` `s` on `p`.`supplier` = `s`.`supplierid`
join `paymentmethods` `m` on `p`.`paymentmode` = `m`.`id`
join `pointsofsale` `o` on `p`.`pos` = `o`.`posid`
join `glaccounts` `a` on `p`.`cashbookaccount` = `a`.`id`
join `user` `u` on `p`.`addedby` = `u`.`userid`
group by 
  `p`.`paymentvoucherid`,
  `p`.`branchid`,
  `p`.`pettycashvoucher`,
  `p`.`voucherno`,
  `p`.`date`,
  `p`.`paymentmode`,
  `m`.`description`,
  `p`.`pos`,
  `o`.`posname`,
  `p`.`supplier`,
  `s`.`suppliername`,
  `pd`.`invoicenumber`,
  `p`.`cashbookaccount`,
  `a`.`accountcode`,
  `a`.`accountname`,
  `p`.`referenceno`,
  `p`.`status`,
  `p`.`addedby`,
  `u`.`firstname`,
  `u`.`middlename`,
  `u`.`lastname`;


-- 3. vwpointofsaleitembalances
DROP VIEW IF EXISTS `vwpointofsaleitembalances`;
CREATE VIEW `vwpointofsaleitembalances` AS
select 
  `s`.`posid` AS `posid`,
  `s`.`posname` AS `posname`,
  `td`.`itemcode` AS `itemid`,
  `p`.`itemcode` AS `itemcode`,
  `p`.`itemname` AS `itemname`,
  `p`.`unitofmeasure` AS `unitofmeasure`,
  `p`.`buyingprice` AS `buyingprice`,
  ifnull(sum(if(`t`.`destinationid` = `s`.`posid` and `t`.`destinationtype` = 'pos' and `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) AS `unitsreceived`,
  ifnull(sum(if(`t`.`sourceid` = `s`.`posid` and `t`.`sourcetype` = 'pos' and `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) AS `issued` 
from `pointsofsale` `s`
join `stocktransfer` `t` on (`s`.`posid` = `t`.`sourceid` or `s`.`posid` = `t`.`destinationid`)
join `stocktransferdetails` `td` on `t`.`stocktransferid` = `td`.`transferid`
join `products` `p` on `td`.`itemcode` = `p`.`productid`
where `t`.`dateadded` >= ifnull((select `cutoffdate` from `startingparameters` limit 1), current_timestamp())
group by 
  `s`.`posid`,
  `s`.`posname`,
  `td`.`itemcode`,
  `p`.`itemcode`,
  `p`.`itemname`,
  `p`.`unitofmeasure`,
  `p`.`buyingprice`;


-- 4. vwstockdetails
DROP VIEW IF EXISTS `vwstockdetails`;
CREATE VIEW `vwstockdetails` AS 
select 
  date_format(`p`.`receiptdate`,'%d-%b-%Y') AS `date`,
  `s`.`posname` AS `posname`,
  `m`.`itemcode` AS `itemcode`,
  `m`.`itemname` AS `itemname`,
  `m`.`unitofmeasure` AS `unitofmeasure`,
  `m`.`buyingprice` AS `buyingprice`,
  avg(`pd`.`unitprice`) AS `sellingprice`,
  0 AS `purchases`,
  sum(`pd`.`quantity`) AS `quantitysold`,
  ifnull((
    select sum(`std`.`quantity`) 
    from `stocktransfer` `st` 
    join `stocktransferdetails` `std` on `st`.`stocktransferid` = `std`.`transferid` 
    where `std`.`itemcode` = `pd`.`itemcode` 
      and `st`.`sourcetype` = 'pos' 
      and `st`.`sourceid` = `s`.`posid` 
      and date_format(`st`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`receiptdate`,'%d-%b-%Y')
  ),0) AS `transfersout`,
  ifnull((
    select sum(`std`.`quantity`) 
    from `stocktransfer` `st` 
    join `stocktransferdetails` `std` on `st`.`stocktransferid` = `std`.`transferid` 
    where `std`.`itemcode` = `pd`.`itemcode` 
      and `st`.`destinationtype` = 'pos' 
      and `st`.`destinationid` = `s`.`posid` 
      and date_format(`st`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`receiptdate`,'%d-%b-%Y')
  ),0) AS `transfersin` 
from `products` `m` 
join `possalesdetails` `pd` on `m`.`productid` = `pd`.`itemcode`
join `possales` `p` on `p`.`possaleid` = `pd`.`possaleid` 
join `pointsofsale` `s` on `p`.`pointofsaleid` = `s`.`posid` 
group by 
  date_format(`p`.`receiptdate`,'%d-%b-%Y'),
  `s`.`posname`,
  `m`.`itemcode`,
  `m`.`itemname`,
  `m`.`unitofmeasure`,
  `m`.`buyingprice`

union all

select 
  date_format(`p`.`datereceived`,'%d-%b-%Y') AS `date`,
  `s`.`description` AS `posname`,
  `m`.`itemcode` AS `itemcode`,
  `m`.`itemname` AS `itemname`,
  `m`.`unitofmeasure` AS `unitofmeasure`,
  ifnull((
    select avg(`xd`.`unitprice`) 
    from `purchaseorders` `x` 
    join `purchaseorderdetails` `xd` on `x`.`purchaseorderid` = `xd`.`purchaseorderid` 
    where `x`.`purchaseorderno` = `pd`.`purchaseorderno`
  ),0) AS `buyingprice`,
  `m`.`sellingprice` AS `sellingprice`,
  sum(`pd`.`quantity`) AS `purchases`,
  0 AS `quantitysold`,
  ifnull((
    select sum(`std`.`quantity`) 
    from `stocktransfer` `st` 
    join `stocktransferdetails` `std` on `st`.`stocktransferid` = `std`.`transferid` 
    where `std`.`itemcode` = `pd`.`itemcode` 
      and `st`.`sourcetype` = 'warehouse' 
      and `st`.`sourceid` = `s`.`id` 
      and date_format(`st`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`datereceived`,'%d-%b-%Y')
  ),0) AS `transfersout`,
  ifnull((
    select sum(`std`.`quantity`) 
    from `stocktransfer` `st` 
    join `stocktransferdetails` `std` on `st`.`stocktransferid` = `std`.`transferid` 
    where `std`.`itemcode` = `pd`.`itemcode` 
      and `st`.`destinationtype` = 'warehouse' 
      and `st`.`destinationid` = `s`.`id` 
      and date_format(`st`.`dateadded`,'%d-%b-%Y') = date_format(`p`.`datereceived`,'%d-%b-%Y')
  ),0) AS `transfersin` 
from `products` `m` 
join `goodsreceiveddetails` `pd` on `m`.`productid` = `pd`.`itemcode`
join `goodsreceived` `p` on `p`.`grnno` = `pd`.`grnno` 
join `warehouses` `s` on `p`.`warehouseid` = `s`.`id` 
group by 
  date_format(`p`.`datereceived`,'%d-%b-%Y'),
  `s`.`description`,
  `m`.`itemcode`,
  `m`.`itemname`,
  `m`.`unitofmeasure`,
  `m`.`buyingprice`,
  `m`.`sellingprice`,
  `pd`.`purchaseorderno`;


-- 5. vwstocktransfers
DROP VIEW IF EXISTS `vwstocktransfers`;
CREATE VIEW `vwstocktransfers` AS 
select 
  `t`.`referenceno` AS `referenceno`,
  `t`.`sourcetype` AS `sourcetype`,
  `t`.`sourceid` AS `sourceid`,
  case when `t`.`sourcetype` = 'warehouse' then (select `warehouses`.`description` from `warehouses` where `warehouses`.`id` = `t`.`sourceid`) else (select `pointsofsale`.`posname` from `pointsofsale` where `pointsofsale`.`posid` = `t`.`sourceid`) end AS `sourcename`,
  `t`.`destinationtype` AS `destinationtype`,
  `t`.`destinationid` AS `destinationid`,
  case when `t`.`destinationtype` = 'warehouse' then (select `warehouses`.`description` from `warehouses` where `warehouses`.`id` = `t`.`destinationid`) else (select `pointsofsale`.`posname` from `pointsofsale` where `pointsofsale`.`posid` = `t`.`destinationid`) end AS `destinationame`,
  `t`.`addedby` AS `addedby`,
  `t`.`dateadded` AS `dateadded`,
  concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `username`,
  ifnull(concat(`i`.`firstname`,' ',`i`.`middlename`,' ',`i`.`lastname`),'_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _') AS `issuedto`,
  ifnull(concat(`c`.`firstname`,' ',`c`.`middlename`,' ',`c`.`lastname`),'_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _') AS `storecontroller` 
from `stocktransfer` `t` 
join `user` `u` on `t`.`addedby` = `u`.`userid`
left join `user` `i` on `i`.`userid` = `t`.`issuedto`
left join `user` `c` on `c`.`userid` = `t`.`storecontroller`
order by `t`.`dateadded`;


-- 6. vwwarehouseitembalances
DROP VIEW IF EXISTS `vwwarehouseitembalances`;
CREATE VIEW `vwwarehouseitembalances` AS
select 
  `w`.`id` AS `warehouseid`,
  `w`.`description` AS `warehousename`,
  `p`.`itemcode` AS `itemcode`,
  `p`.`itemname` AS `itemname`,
  `p`.`productid` AS `productid`,
  `p`.`unitofmeasure` AS `unitofmeasure`,
  `p`.`buyingprice` AS `buyingprice`,
  `p`.`sellingprice` AS `sellingprice`,
  `p`.`serializable` AS `serializable`,
  sum(`gd`.`quantity`) + ifnull((
    select sum(`std`.`quantity`) 
    from `stocktransferdetails` `std` 
    join `stocktransfer` `st` on `st`.`stocktransferid` = `std`.`transferid` 
    where `st`.`destinationtype` = 'warehouse' 
      and `st`.`destinationid` = `w`.`id` 
      and `std`.`itemcode` = `p`.`productid` 
      and `st`.`dateadded` >= ifnull((select `cutoffdate` from `startingparameters` limit 1), current_timestamp())
  ),0) AS `unitsreceived`,
  ifnull((
    select sum(`std`.`quantity`) 
    from `stocktransferdetails` `std` 
    join `stocktransfer` `st` on `st`.`stocktransferid` = `std`.`transferid` 
    where `st`.`sourcetype` = 'warehouse' 
      and `st`.`sourceid` = `w`.`id` 
      and `std`.`itemcode` = `p`.`productid` 
      and `st`.`dateadded` >= ifnull((select `cutoffdate` from `startingparameters` limit 1), current_timestamp())
  ),0) AS `issued` 
from `goodsreceived` `g` 
join `goodsreceiveddetails` `gd` on `g`.`grnno` = `gd`.`grnno`
join `products` `p` on `gd`.`itemcode` = `p`.`productid`
join `warehouses` `w` on `w`.`id` = `g`.`warehouseid`
group by 
  `p`.`itemcode`,
  `p`.`itemname`,
  `p`.`unitofmeasure`,
  `p`.`buyingprice`,
  `p`.`sellingprice`,
  `p`.`serializable`,
  `w`.`id`,
  `w`.`description`,
  `p`.`productid`;
