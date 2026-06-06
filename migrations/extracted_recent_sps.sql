DELIMITER $$

-- ---------------------------------------------------
-- PROCEDURE: spgetglstatement
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetglstatement`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetglstatement`($branchid INT, $startdate DATETIME, $enddate DATETIME, $accountid INT)
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
END $$

-- ---------------------------------------------------
-- PROCEDURE: spgetbalancesheet
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetbalancesheet`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetbalancesheet`(
            IN $branchid INT,
            IN $startdate DATETIME,
            IN $enddate DATETIME
        )
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
        END $$

-- ---------------------------------------------------
-- PROCEDURE: spgetprofitandlossaccount
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetprofitandlossaccount`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetprofitandlossaccount`(
            IN $branchid INT,
            IN $startdate DATETIME,
            IN $enddate DATETIME
        )
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
        END $$

-- ---------------------------------------------------
-- PROCEDURE: spgetprofitandlossaccountdetails
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetprofitandlossaccountdetails`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetprofitandlossaccountdetails`(
            IN $branchid INT,
            IN $startdate DATETIME,
            IN $enddate DATETIME
        )
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
        END $$

-- ---------------------------------------------------
-- PROCEDURE: spgetprofitandlossaccountheader
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetprofitandlossaccountheader`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetprofitandlossaccountheader`(
            IN $branchid INT,
            IN $startdate DATETIME,
            IN $enddate DATETIME
        )
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
        END $$

-- ---------------------------------------------------
-- PROCEDURE: spgettrialbalance
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgettrialbalance`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgettrialbalance`(
            IN $branchid INT,
            IN $startdate DATETIME,
            IN $enddate DATETIME
        )
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
        END $$

-- ---------------------------------------------------
-- PROCEDURE: spgetaccountspayableaginganalysis
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetaccountspayableaginganalysis`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetaccountspayableaginganalysis`(
            IN $branchid INT,
            IN $basedate DATETIME
        )
BEGIN
            SET @basedate = $basedate;
            SET @cutoffdate = (SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
            
            SELECT IFNULL(suppliername, 'TOTAL') AS suppliername, SUM(amountoverdue) AS `total`,
                SUM(IF(`range`='1', amountoverdue, 0)) AS `thirty`,  
                SUM(IF(`range`='31', amountoverdue, 0)) AS `sixty`,
                SUM(IF(`range`='61', amountoverdue, 0)) AS `ninenty`,
                SUM(IF(`range`='91', amountoverdue, 0)) AS `onetwenty`,
                SUM(IF(`range`='120+', amountoverdue, 0)) AS `aboveonetwenty` 
            FROM (
                SELECT i.supplierinvoiceid AS invoiceid, s.`supplierid`, suppliername, `invoiceno`,
                CASE 
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`invoicedate`, '%Y-%m-%d')) BETWEEN 1 AND 30 THEN '1' 
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`invoicedate`, '%Y-%m-%d')) BETWEEN 31 AND 60 THEN '31'
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`invoicedate`, '%Y-%m-%d')) BETWEEN 61 AND 90 THEN '61'
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`invoicedate`, '%Y-%m-%d')) BETWEEN 91 AND 120 THEN '91'
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`invoicedate`, '%Y-%m-%d')) >= 120 THEN '120+' 
                END AS `range`,
                SUM(`quantity`*`unitprice`) -
                IFNULL((
                    SELECT SUM(`quantity`*`unitprice`) 
                    FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
                    WHERE v.`paymentvoucherid` = vd.`voucherid` 
                      AND `supplier` = s.supplierid 
                      AND `invoicenumber` = `invoiceno` 
                      AND v.branchid = $branchid
                      AND DATE_FORMAT(v.`date`, '%Y-%m-%d') <= @basedate
                ), 0) AS amountoverdue
                FROM `supplierinvoice` i, `supplierinvoicedetails` id, `suppliers` s
                WHERE i.`supplierinvoiceid` = id.`invoiceid` 
                  AND s.`supplierid` = i.`supplierid` 
                  AND i.branchid = $branchid
                  AND DATE_FORMAT(`invoicedate`, '%Y-%m-%d') >= @cutoffdate
                GROUP BY i.supplierinvoiceid, s.`supplierid`, suppliername, `invoiceno`, `status`, DATEDIFF(@basedate, DATE_FORMAT(`invoicedate`, '%Y-%m-%d'))
                ORDER BY `invoicedate` DESC, `invoiceno`
            ) AS tab1
            GROUP BY suppliername
            WITH ROLLUP;
        END $$

-- ---------------------------------------------------
-- PROCEDURE: spgetaccountsreceivableaginganalysis
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetaccountsreceivableaginganalysis`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetaccountsreceivableaginganalysis`(
            IN $branchid INT,
            IN $basedate DATETIME
        )
BEGIN
            SET @cutoffdate = (SELECT DATE_FORMAT(`cutoffdate`, '%Y-%m-%d') FROM `startingparameters`);
            SET @basedate = $basedate;
            
            SELECT IFNULL(customername, 'TOTAL') AS `customername`, 
                SUM(`balance`) AS `total`,
                SUM(IF(`range`='thirty', `balance`, 0)) AS `thirty`,
                SUM(IF(`range`='sixty', `balance`, 0)) AS `sixty`,
                SUM(IF(`range`='ninety', `balance`, 0)) AS `ninety`,
                SUM(IF(`range`='onetwenty', `balance`, 0)) AS `onetwenty`,
                SUM(IF(`range`='aboveonetwenty', `balance`, 0)) AS `aboveonetwenty` 
            FROM (
                SELECT c.`customerid`, p.possaleid AS id, c.`customername`,
                CASE 
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`receiptdate`, '%Y-%m-%d')) <= 30 THEN 'thirty' 
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`receiptdate`, '%Y-%m-%d')) BETWEEN 31 AND 60 THEN 'sixty'
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`receiptdate`, '%Y-%m-%d')) BETWEEN 61 AND 90 THEN 'ninety'
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`receiptdate`, '%Y-%m-%d')) BETWEEN 91 AND 120 THEN 'onetwenty'
                    WHEN DATEDIFF(@basedate, DATE_FORMAT(`receiptdate`, '%Y-%m-%d')) > 120 THEN 'aboveonetwenty' 
                END AS `range`,
                pp.amount -
                IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid` = p.`possaleid`), 0) AS balance
                FROM `possales` p, `possalesdetails` pd, `possalespayments` pp, `customers` c
                WHERE p.`possaleid` = pd.`possaleid` 
                  AND pp.`possaleid` = p.`possaleid` 
                  AND pp.`paymentmode` = 4 
                  AND c.`customerid` = p.`customerid`
                  AND p.branchid = $branchid
                  AND pp.amount - IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid` = p.`possaleid`), 0) > 0
                  AND DATE_FORMAT(`receiptdate`, '%Y-%m-%d') >= @cutoffdate
                GROUP BY c.`customerid`, p.possaleid, c.`customername`
            ) AS tab1
            GROUP BY customername
            WITH ROLLUP;
        END $$

-- ---------------------------------------------------
-- PROCEDURE: spgetposstockbalanceasatdate
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetposstockbalanceasatdate`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetposstockbalanceasatdate`(
            IN $branchid INT,
            IN $asatdate DATETIME,
            IN $posid INT
        )
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
        END $$

-- ---------------------------------------------------
-- PROCEDURE: spgetdiscountreport
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetdiscountreport`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetdiscountreport`(
            IN $branchid INT,
            IN $startdate DATETIME,
            IN $enddate DATETIME
        )
BEGIN
            SET @startdate = $startdate;
            SET @enddate = $enddate;
            
            SELECT * FROM (
                SELECT p.`itemcode` AS `Item Code`, `itemname` AS `Item Name`, FORMAT(`buyingprice`, 0) AS `Buying Price`, FORMAT(`sellingprice`, 0) AS `Selling Price`, FORMAT(SUM(quantity), 2) AS `Units Sold`, 
                FORMAT(SUM(quantity*unitprice), 2) AS `Total Sales`, FORMAT(SUM(discount), 2) AS `Discount`
                FROM `products` p, `possales` s, `possalesdetails` sd
                WHERE p.`productid` = sd.`itemcode` 
                  AND sd.`possaleid` = s.`possaleid`
                  AND s.`branchid` = $branchid
                  AND `receiptdate` BETWEEN @startdate AND @enddate 
                  AND IFNULL(s.deleted, 0) = 0
                GROUP BY p.`itemcode`, `itemname`, `buyingprice`, `sellingprice` 
                ORDER BY itemname
            ) AS q1
            UNION
            SELECT '' AS `Item Code`, 'TOTAL' AS `Item Name`, 0 AS `Buying Price`, 0 AS `Selling Price`, FORMAT(SUM(quantity), 2) AS `Units Sold`, FORMAT(SUM(quantity*unitprice), 2) AS `Total Sales`, FORMAT(SUM(discount), 2) AS `Discount`
            FROM `products` p, `possales` s, `possalesdetails` sd
            WHERE p.`productid` = sd.`itemcode` 
              AND sd.`possaleid` = s.`possaleid` 
              AND IFNULL(s.deleted, 0) = 0
              AND s.`branchid` = $branchid
              AND `receiptdate` BETWEEN @startdate AND @enddate;
        END $$

-- ---------------------------------------------------
-- PROCEDURE: spgetprofitabilityreport
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `spgetprofitabilityreport`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetprofitabilityreport`(
            IN $branchid INT,
            IN $startdate VARCHAR(50),
            IN $enddate VARCHAR(50),
            IN $posid INT
        )
BEGIN
            IF $posid = 0 THEN 
                SELECT m.`itemcode`, `itemname`, FORMAT(`buyingprice`, 2) AS `Buying Price`, FORMAT(AVG(`unitprice`), 2) AS sellingprice, FORMAT(SUM(`quantity`), 2) AS unitssold, 
                FORMAT(SUM(`buyingprice` * `quantity`), 2) AS `Total Purchases`, FORMAT(SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`), 2) AS `Total Sales`,
                FORMAT((SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`)) - (`buyingprice` * SUM(`quantity`)), 2) AS Margin
                FROM `products` m, `possales` p, `possalesdetails` pd
                WHERE m.`productid` = pd.`itemcode` 
                  AND pd.`possaleid` = p.`possaleid` 
                  AND p.`branchid` = $branchid
                  AND DATE_FORMAT(p.`receiptdate`, '%Y-%m-%d') BETWEEN $startdate AND $enddate
                  AND IFNULL(p.`deleted`, 0) = 0
                GROUP BY `itemcode`, `itemname`, `buyingprice`
                UNION 
                SELECT 'TOTAL: ' AS itemcode, '' AS itemname,
                FORMAT(AVG(`buyingprice`), 2) AS `Buying Price`, FORMAT(AVG(`unitprice`), 2) AS sellingprice, FORMAT(SUM(`quantity`), 2) AS unitssold, 
                FORMAT(SUM(`buyingprice` * `quantity`), 2) AS `Total Purchases`, 
                FORMAT(SUM(`quantity` * (`unitprice` - IFNULL(discount, 0))), 2) AS `Total Sales`,
                FORMAT(SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`) - SUM(`buyingprice` * `quantity`), 2) AS Margin
                FROM `products` m, `possales` p, `possalesdetails` pd
                WHERE m.`productid` = pd.`itemcode` 
                  AND pd.`possaleid` = p.`possaleid` 
                  AND p.`branchid` = $branchid
                  AND DATE_FORMAT(p.`receiptdate`, '%Y-%m-%d') BETWEEN $startdate AND $enddate
                  AND IFNULL(p.`deleted`, 0) = 0
                ;
            ELSE
                SELECT m.`itemcode`, `itemname`, FORMAT(`buyingprice`, 2) AS `Buying Price`, FORMAT(AVG(`unitprice`), 2) AS sellingprice, FORMAT(SUM(`quantity`), 2) AS unitssold, 
                FORMAT(SUM(`buyingprice` * `quantity`), 2) AS `Total Purchases`, FORMAT(SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`), 2) AS `Total Sales`,
                FORMAT((SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`)) - (`buyingprice` * SUM(`quantity`)), 2) AS Margin
                FROM `products` m, `possales` p, `possalesdetails` pd
                WHERE m.`productid` = pd.`itemcode` 
                  AND pd.`possaleid` = p.`possaleid` 
                  AND p.`branchid` = $branchid
                  AND DATE_FORMAT(p.`receiptdate`, '%Y-%m-%d') BETWEEN $startdate AND $enddate 
                  AND `pointofsaleid` = $posid
                  AND IFNULL(p.`deleted`, 0) = 0
                GROUP BY `itemcode`, `itemname`, `buyingprice`
                UNION 
                SELECT 'TOTAL: ' AS itemcode, '' AS itemname,
                FORMAT(AVG(`buyingprice`), 2) AS `Buying Price`, FORMAT(AVG(`unitprice`), 2) AS sellingprice, FORMAT(SUM(`quantity`), 2) AS unitssold, 
                FORMAT(SUM(`buyingprice` * `quantity`), 2) AS `Total Purchases`, 
                FORMAT(SUM(`quantity` * (`unitprice` - IFNULL(discount, 0))), 2) AS `Total Sales`,
                FORMAT(SUM((`unitprice` - IFNULL(discount, 0)) * `quantity`) - SUM(`buyingprice` * `quantity`), 2) AS Margin
                FROM `products` m, `possales` p, `possalesdetails` pd
                WHERE m.`productid` = pd.`itemcode` 
                  AND pd.`possaleid` = p.`possaleid` 
                  AND p.`branchid` = $branchid
                  AND DATE_FORMAT(p.`receiptdate`, '%Y-%m-%d') BETWEEN $startdate AND $enddate 
                  AND IFNULL(p.`deleted`, 0) = 0
                  AND `pointofsaleid` = $posid 
                ;
            END IF;
        END $$

-- ---------------------------------------------------
-- PROCEDURE: sp_gettransferreportbyitems
-- ---------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_gettransferreportbyitems`$$



CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gettransferreportbyitems`(
                IN `$branchid` INT, 
                IN `$cat` VARCHAR(50), 
                IN `$id` INT, 
                IN `$startdate` DATE, 
                IN `$enddate` DATE
            )
BEGIN
                SET @type = $cat;
                SET @id = $id;
                SET @startdate = $startdate;
                SET @enddate = $enddate;
                
                SELECT 
                    p.itemcode, 
                    p.itemname, 
                    IF($cat = 'pos', 
                       IFNULL(fn_getitemstorebalanceasat(p.productid, $id, DATE_SUB($startdate, INTERVAL 1 DAY)), 0),
                       IFNULL(fn_warehousestockbalanceasat(p.productid, $id, DATE_SUB($startdate, INTERVAL 1 DAY)), 0)
                    ) AS openingstock,
                    IF($cat = 'pos', 
                       0, 
                       IFNULL((
                           SELECT SUM(gd.quantity)
                           FROM `goodsreceived` g
                           JOIN `goodsreceiveddetails` gd ON gd.`grnno` = g.`grnno`
                           WHERE g.`warehouseid` = $id 
                             AND gd.`itemcode` = p.productid
                             AND DATE(g.`datereceived`) BETWEEN $startdate AND $enddate
                       ), 0)
                    ) AS purchases,
                    IF($cat = 'pos', 
                       IFNULL((
                           SELECT SUM(pd.quantity)
                           FROM `possalesdetails` pd
                           JOIN `possales` ps ON pd.`possaleid` = ps.`possaleid`
                           WHERE ps.`pointofsaleid` = $id 
                             AND pd.`itemcode` = p.productid
                             AND IFNULL(ps.`deleted`, 0) = 0
                             AND DATE(ps.`receiptdate`) BETWEEN $startdate AND $enddate
                       ), 0),
                       0
                    ) AS sold,
                    SUM(CASE WHEN `destinationtype`=@type AND `destinationid`=@id THEN `quantity` ELSE 0 END) AS transferin,
                    SUM(CASE WHEN `sourcetype`=@type AND `sourceid`=@id THEN `quantity` ELSE 0 END) AS transferout
                FROM `stocktransfer` s
                JOIN `stocktransferdetails` sd ON s.`stocktransferid`=sd.`transferid`
                JOIN `products` p ON sd.`itemcode`=p.`productid`
                WHERE DATE_FORMAT(s.`dateadded`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
                  AND s.`branchid` = $branchid
                GROUP BY p.itemcode, p.productid, p.itemname
                ORDER BY p.itemname;
            END $$

DELIMITER ;
