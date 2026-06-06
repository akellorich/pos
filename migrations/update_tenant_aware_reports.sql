-- Migration to update stored procedures and views to support multi-tenancy and branch isolation by branchid

-- 1. Update vwsalessummary view to select and group by branchid
CREATE OR REPLACE VIEW pos.vwsalessummary AS 
select date_format(`p`.`receiptdate`,'%Y-%m-%d') AS `transactiondate`,
`pm`.`id` AS `id`,
`p`.`receiptno` AS `receiptno`,
`m`.`description` AS `paymentmode`,
`pm`.`reference` AS `paymentmodereference`,
`s`.`posname` AS `pointofsale`,
`p`.`customerid` AS `customerid`,
`c`.`customername` AS `customername`,
`p`.`addedby` AS `userid`,
`pm`.`amount` AS `receipttotal`,
`p`.`pointofsaleid` AS `posid`,
ifnull(`pm`.`banked`,0) AS `banked`,
concat(`u`.`firstname`,' ',`u`.`middlename`,' ',`u`.`lastname`) AS `userfullname`,
`u`.`username` AS `username`,
`s`.`clientid` AS `clientid`,
`p`.`branchid` AS `branchid`
from ((((((`pos`.`pointsofsale` `s` join `pos`.`possales` `p` on(`p`.`pointofsaleid` = `s`.`posid`)) join `pos`.`possalesdetails` `pd` on(`p`.`possaleid` = `pd`.`possaleid`)) join `pos`.`user` `u` on(`p`.`addedby` = `u`.`userid`)) join `pos`.`customers` `c` on(`p`.`customerid` = `c`.`customerid`)) join `pos`.`paymentmethods` `m` on(`m`.`clientid` = `s`.`clientid`)) join `pos`.`possalespayments` `pm` on(`p`.`possaleid` = `pm`.`possaleid` and `pm`.`paymentmode` = `m`.`id`)) 
where ifnull(`p`.`deleted`,0) = 0 
group by `p`.`receiptdate`,`p`.`receiptno`,`u`.`username`,`u`.`userid`,`s`.`posname`,`p`.`customerid`,`c`.`customername`,`p`.`addedby`,`m`.`description`,`pm`.`reference`,`pm`.`id`,`p`.`pointofsaleid`,`pm`.`banked`,`u`.`firstname`,`u`.`middlename`,`u`.`lastname`,`s`.`clientid`, `p`.`branchid`;


-- 2. Update spgetsalessummarybyuser to accept $branchid and filter by it
DELIMITER $$
CREATE OR REPLACE PROCEDURE pos.spgetsalessummarybyuser(IN `$branchid` INT, IN `$startdate` DATETIME, IN `$enddate` DATETIME, IN `$posname` VARCHAR(100), IN `$userid` INT)
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
END$$
DELIMITER ;


-- 3. Update spgetsalessummarybycustomer to accept $branchid and filter by it
DELIMITER $$
CREATE OR REPLACE PROCEDURE pos.spgetsalessummarybycustomer(IN `$branchid` INT, IN `$startdate` DATETIME, IN `$enddate` DATETIME, IN `$posname` VARCHAR(100), IN `$userid` INT)
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
END$$
DELIMITER ;


-- 4. Update sp_getproductpurchasessummary to accept $branchid and filter by it
DELIMITER $$
CREATE OR REPLACE PROCEDURE pos.sp_getproductpurchasessummary(IN `$branchid` INT, IN `$startdate` DATE, IN `$enddate` DATE)
BEGIN
	SELECT p.`itemcode`,`itemname`,AVG(`unitprice`) unitprice, SUM(gd.`quantity`) quantity,SUM(gd.`quantity`*`unitprice`) total
	FROM `products` p, `purchaseorderdetails` pod, `purchaseorders` po, `goodsreceived` g, `goodsreceiveddetails` gd
	WHERE p.`productid`=pod.`itemcode` AND pod.`purchaseorderid`=po.`purchaseorderid` AND gd.`itemcode`=p.`productid` AND g.`grnno`=gd.`grnno` 
	AND gd.`purchaseorderno`=po.`purchaseorderno`
	AND DATE_FORMAT(po.`date`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	AND po.`branchid` = $branchid
	GROUP BY  p.`itemcode`,`itemname`
	ORDER BY itemname;
END$$
DELIMITER ;


-- 5. Update sp_getproductsalessummary to accept $branchid and filter by it
DELIMITER $$
CREATE OR REPLACE PROCEDURE pos.sp_getproductsalessummary(IN `$branchid` INT, IN `$startdate` DATE, IN `$enddate` DATE)
BEGIN
	SELECT p.`itemcode`,`itemname`,unitprice-discount unitprice, SUM(`quantity`) quantity, SUM(`quantity`*(`unitprice`-discount)) total
	FROM `products` p, `possales` s, `possalesdetails` sd
	WHERE p.`productid`=sd.`itemcode` AND sd.`possaleid`=s.`possaleid` 
	AND DATE_FORMAT(s.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	AND IFNULL(s.`deleted`,0)=0
	AND s.`branchid` = $branchid
	GROUP BY p.`itemcode`,`itemname`,unitprice-discount
	ORDER BY `itemname`;
END$$
DELIMITER ;


-- 6. Update sp_gettransferreportbyitems to accept $branchid and filter by it
DELIMITER $$
CREATE OR REPLACE PROCEDURE pos.sp_gettransferreportbyitems(IN `$branchid` INT, IN `$cat` VARCHAR(50), IN `$id` INT, IN `$startdate` DATE, IN `$enddate` DATE)
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
END$$
DELIMITER ;


-- 7. Update sp_getinputoutputvatreport to accept $branchid and filter by it
DELIMITER $$
CREATE OR REPLACE PROCEDURE pos.sp_getinputoutputvatreport(IN `$branchid` INT, IN `$startdate` DATE, IN `$enddate` DATE)
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
		AND s.`branchid` = $branchid
		GROUP BY p.`productid`
		ORDER BY `itemname`;
END$$
DELIMITER ;
