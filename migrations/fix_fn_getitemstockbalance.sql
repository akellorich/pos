-- SQL migration to correct join keys in fn_getitemstockbalance function

DELIMITER $$
CREATE OR REPLACE FUNCTION pos.fn_getitemstockbalance(`$productid` INT, `$asatdate` DATE) RETURNS decimal(18,2)
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
END$$
DELIMITER ;
