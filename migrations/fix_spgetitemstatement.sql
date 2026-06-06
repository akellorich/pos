-- SQL script to correct join columns in spgetitemstatement and fix SQLSTATE[42S22] errors

DELIMITER $$
CREATE OR REPLACE PROCEDURE pos.spgetitemstatement(
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
END$$
DELIMITER ;
