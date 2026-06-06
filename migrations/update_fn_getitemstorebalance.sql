DROP FUNCTION IF EXISTS `fn_getitemstorebalance`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_getitemstorebalance`(`$productid` INT, `$storeid` INT) RETURNS decimal(18,0)
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
	
    END$$

DELIMITER ;
