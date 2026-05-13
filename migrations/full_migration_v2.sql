-- FULL MIGRATION SCRIPT FOR MULTI-TENANT ARCHITECTURE
-- Generated: 2026-05-13 05:07:44

/* 1. TABLE UPDATES */

/* 2. VIEW RECREATION */
DROP VIEW IF EXISTS vwsalessummary2;
CREATE VIEW vwsalessummary2 AS select p.branchid, p.receiptdate AS transactiondate,pm.id AS id,p.receiptno AS receiptno,m.description AS paymentmode,pm.reference AS paymentmodereference,s.posname AS pointofsale,p.customerid AS customerid,c.customername AS customername,p.addedby AS userid,pm.amount AS receipttotal,sum(pd.quantity) AS quantity,p.pointofsaleid AS posid,coalesce(pm.banked,0) AS banked,u.firstname AS userfullname,u.username AS username from pointsofsale s join possales p on(p.pointofsaleid = s.posid) join possalesdetails pd on(p.possaleid = pd.possaleid) join user u on(p.addedby = u.userid) join customers c on(p.customerid = c.customerid) join possalespayments pm on(p.possaleid = pm.possaleid) join paymentmethods m on(pm.paymentmode = m.id) where coalesce(p.deleted,0) = 0 group by p.branchid, p.receiptdate,p.receiptno,u.username,u.userid,s.posname,p.customerid,c.customername,p.addedby,m.description,pm.reference,pm.id,p.pointofsaleid,pm.banked,u.firstname;

/* 3. STORED PROCEDURE REFRESH */
DELIMITER $$

DROP PROCEDURE IF EXISTS `emaillist` $$
CREATE PROCEDURE `emaillist`()
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
    END $$

DROP PROCEDURE IF EXISTS `import_data` $$
CREATE PROCEDURE `import_data`()
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
END $$

DROP PROCEDURE IF EXISTS `import_data_campari` $$
CREATE PROCEDURE `import_data_campari`()
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
END $$

DROP PROCEDURE IF EXISTS `import_payables` $$
CREATE PROCEDURE `import_payables`()
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
	
    END $$

DROP PROCEDURE IF EXISTS `import_receivables` $$
CREATE PROCEDURE `import_receivables`()
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
    END $$

DROP PROCEDURE IF EXISTS `savetemppurchaseorderdetails` $$
CREATE PROCEDURE `savetemppurchaseorderdetails`(`$refno` VARCHAR(50), `$itemcode` VARCHAR(50), `$quantity` NUMERIC, `$unitprice` NUMERIC)
BEGIN
	DECLARE $itemid INT;
	SET $itemid=(SELECT `productid` FROM `products` WHERE `itemcode`=$itemcode);
	INSERT INTO `temppurchaseorder` (`refno`,`itemcode`,`quantity`,`unitprice`)
	VALUES($refno,$itemid,$quantity,$unitprice);
    END $$

DROP PROCEDURE IF EXISTS `spapprovepaymentvoucher` $$
CREATE PROCEDURE `spapprovepaymentvoucher`(`$id` INT, `$userid` INT)
BEGIN
	DECLARE $cashbookaccount INT;
	START TRANSACTION;
		
		SET $cashbookaccount=(SELECT `cashbookaccount` FROM `paymentvouchers` WHERE `id`=$id);
		-- update payment voucher status
		UPDATE `paymentvouchers` SET `status`='Approved', `lastmodifiedby`=$userid, `lastmodifieddate`=NOW() WHERE `id`=$id;
		-- insert the transaction into the GL
		-- begin with vrediting the cashbook account
		INSERT INTO `gltransactions` (`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		SELECT `referenceno`,  v.dateadded,`cashbookaccount`,NULL,CONCAT('Payment of voucher #',`voucherno`),0,SUM(quantity*unitprice),$userid
		FROM `paymentvouchers` v, `paymentvoucherdetails` vd WHERE v.`id`=vd.`voucherid` AND v.`id`=$id;
		-- post the debit entries
		INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		SELECT `referenceno`, v.dateadded,`accountcharged`,$cashbookaccount,`description`,quantity*unitprice,0,$userid
		FROM `paymentvouchers` v, `paymentvoucherdetails` vd WHERE v.`id`=vd.`voucherid` AND v.`id`=$id;
	COMMIT;
    END $$

DROP PROCEDURE IF EXISTS `spapprovepurchaseorder` $$
CREATE PROCEDURE `spapprovepurchaseorder`(`$id` NUMERIC, `$userid` NUMERIC)
BEGIN
	UPDATE `purchaseorders` SET `status`='Approved', `lastmodifiedon`=NOW(),`lastmodifiedby`=$userid WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spcancelpaymentvoucher` $$
CREATE PROCEDURE `spcancelpaymentvoucher`(`$id` INT, `$reason` VARCHAR(500), `$userid` INT)
BEGIN
	UPDATE `paymentvouchers` SET `status`='Cancelled', `reasoncancelled`=$reason, `lastmodifiedby`=$userid, `lastmodifieddate`=NOW()
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spcancelpossale` $$
CREATE PROCEDURE `spcancelpossale`(`$receiptno` VARCHAR(50), `$userid` INT, `$reason` VARCHAR(100))
BEGIN
	UPDATE `possales` SET `deleted`=1, `deletedon`=NOW(), `deletedby`=$userid, reason=$reason WHERE `receiptno`=$receiptno;
    END $$

DROP PROCEDURE IF EXISTS `spcancelpurchaseorder` $$
CREATE PROCEDURE `spcancelpurchaseorder`(`$id` NUMERIC, `$userid` NUMERIC, `$reason` VARCHAR(100))
BEGIN
	UPDATE `purchaseorders` SET `status`='Cancelled', `reasoncancelled`=$reason, `lastmodifiedon`=NOW(),`lastmodifiedby`=$userid
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spchangeuserpassword` $$
CREATE PROCEDURE `spchangeuserpassword`(IN $clientid INT, IN $userid INT, IN $userpassword VARCHAR(100),
    IN $salt VARCHAR(50),
    IN $changepasswordonlogon TINYINT
)
BEGIN
    UPDATE `user` 
    SET `password` = $userpassword, 
        `salt` = $salt,
        `changepasswordonlogon` = $changepasswordonlogon 
    WHERE clientid = $clientid AND userid = $userid;
END $$

DROP PROCEDURE IF EXISTS `spcheckcategory` $$
CREATE PROCEDURE `spcheckcategory`(IN $clientid INT, IN $id INT, IN $field VARCHAR(50), IN $value VARCHAR(50))
BEGIN
    IF $field = 'categoryname' THEN
        SELECT * FROM `categories` WHERE clientid = $clientid AND `categoryid` <> $id AND `categoryname` = $value;
    ELSEIF $field = 'prefix' THEN
        SELECT * FROM `categories` WHERE clientid = $clientid AND `categoryid` <> $id AND `prefix` = $value;
    END IF;
END $$

DROP PROCEDURE IF EXISTS `spcheckcrateadditionreference` $$
CREATE PROCEDURE `spcheckcrateadditionreference`(`$reference` VARCHAR(50))
BEGIN
	SELECT * FROM `cratesinventory` WHERE `reference`=$reference;
    END $$

DROP PROCEDURE IF EXISTS `spcheckcustomerdocuments` $$
CREATE PROCEDURE `spcheckcustomerdocuments`(`$id` INT, `$document` VARCHAR(50), `$docno` VARCHAR(50))
BEGIN
	IF $document='pin' THEN
		SELECT * FROM `customers` WHERE `customerid`<>$id AND `pinno`=$docno;
	ELSEIF $document='id' THEN
		SELECT * FROM `customers` WHERE `customerid`<>$id AND `idno`=$docno;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spcheckcustomername` $$
CREATE PROCEDURE `spcheckcustomername`(IN $clientid INT, IN $id INT, IN $name VARCHAR(50))
BEGIN
    SELECT * FROM `customers` WHERE clientid = $clientid AND `customerid` <> $id AND `customername` = $name;
END $$

DROP PROCEDURE IF EXISTS `spcheckglaccount` $$
CREATE PROCEDURE `spcheckglaccount`(`$id` INT, `$searchvariable` VARCHAR(50))
BEGIN
	SELECT * FROM `glaccounts` 
	WHERE `id`<>$id AND (`accountcode`=$searchvariable OR `accountname`=$searchvariable);
    END $$

DROP PROCEDURE IF EXISTS `spcheckglaccountgroup` $$
CREATE PROCEDURE `spcheckglaccountgroup`(`$id` INT, `$groupname` VARCHAR(50))
BEGIN
	SELECT * FROM `glaccountgroups` WHERE `id`<>$id AND `groupname`=$groupname;
    END $$

DROP PROCEDURE IF EXISTS `spcheckjournalrefereceno` $$
CREATE PROCEDURE `spcheckjournalrefereceno`(`$referenceno` VARCHAR(50))
BEGIN
	SELECT * FROM `journals` WHERE `referenceno`=$referenceno;
    END $$

DROP PROCEDURE IF EXISTS `spcheckmpesatransactioncode` $$
CREATE PROCEDURE `spcheckmpesatransactioncode`(`$refno` VARCHAR(50))
BEGIN
	SELECT * FROM `mpesaconfirmation` WHERE `reference`=$refno;
    END $$

DROP PROCEDURE IF EXISTS `spcheckpaymentmodereference` $$
CREATE PROCEDURE `spcheckpaymentmodereference`(`$paymentmodeid` INT, `$reference` VARCHAR(50))
BEGIN
	SET @checkreference=(SELECT `requiresref` FROM `paymentmethods` WHERE `id`=$paymentmodeid);
	
	IF @checkreference=1 THEN
		SELECT * FROM `customerpayments` WHERE `paymentmethodid`=$paymentmodeid AND `reference`=$reference;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spcheckpaymentvoucherno` $$
CREATE PROCEDURE `spcheckpaymentvoucherno`(`$id` INT, `$voucherno` VARCHAR(50))
BEGIN
	SELECT * FROM `paymentvouchers` WHERE `id`<>$id AND `voucherno`=$voucherno;
    END $$

DROP PROCEDURE IF EXISTS `spcheckposname` $$
CREATE PROCEDURE `spcheckposname`(`$id` NUMERIC, `$posname` VARCHAR(50))
BEGIN
	SELECT * FROM `pointsofsale` WHERE `id`<>$id AND `posname`=$posname;
    END $$

DROP PROCEDURE IF EXISTS `spcheckproduct` $$
CREATE PROCEDURE `spcheckproduct`(IN $clientid INT, IN $id NUMERIC, IN $valuetocheck VARCHAR(50), IN $category VARCHAR(50))
BEGIN
    IF $category='code' THEN
        SELECT * FROM `products` WHERE clientid = $clientid AND `productid` <> $id AND `itemcode` = $valuetocheck;
    ELSE
        SELECT * FROM `products` WHERE clientid = $clientid AND `productid` <> $id AND `itemname` = $valuetocheck;
    END IF;
END $$

DROP PROCEDURE IF EXISTS `spcheckreferenceno` $$
CREATE PROCEDURE `spcheckreferenceno`(IN $branchid INT, IN $modeid INT, IN $reference VARCHAR(50))
BEGIN
    SELECT * FROM `possalespayments` WHERE branchid = $branchid AND `paymentmode` = $modeid AND `reference` = $reference;
END $$

DROP PROCEDURE IF EXISTS `spcheckrole` $$
CREATE PROCEDURE `spcheckrole`(`$roleid` INT, `$rolename` VARCHAR(50))
BEGIN
	SELECT * 
	FROM `roles` 
	WHERE `roleid`<>$roleid AND `rolename`=$rolename;
    END $$

DROP PROCEDURE IF EXISTS `spchecksupplierdeliverynotenumber` $$
CREATE PROCEDURE `spchecksupplierdeliverynotenumber`(IN $branchid INT, IN $supplierid INT, IN $deliverynoteno VARCHAR(50))
BEGIN
    SELECT * FROM `goodsreceived` WHERE branchid = $branchid AND `supplierid` = $supplierid AND `deliverynono` = $deliverynoteno;
END $$

DROP PROCEDURE IF EXISTS `spchecksuppliername` $$
CREATE PROCEDURE `spchecksuppliername`(`$supplierid` NUMERIC, `$suppliername` VARCHAR(50))
BEGIN
	SELECT * FROM `suppliers` WHERE `supplierid`<>$supplierid AND `suppliername`=$suppliername;
    END $$

DROP PROCEDURE IF EXISTS `spcheckuser` $$
CREATE PROCEDURE `spcheckuser`(`$clientid` INT, `$checkfield` VARCHAR(50), `$checkvalue` VARCHAR(50))
BEGIN
	IF $checkfield='username' THEN 
		SELECT * FROM `user` WHERE `id`<>$clientid AND `username`=$checkvalue;
	ELSEIF $checkfield='email' THEN 
		SELECT * FROM `user` WHERE `id`<>$clientid AND `email`=$checkvalue;
	ELSEIF $checkfield='mobile' THEN 
		SELECT * FROM `user` WHERE `id`<>$clientid AND `mobile`=$checkvalue;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spdeletecategory` $$
CREATE PROCEDURE `spdeletecategory`(IN $clientid INT, IN $id INT, IN $userid INT)
BEGIN
    UPDATE `categories` SET `deleted` = 1, `lastmodifiedon` = NOW(), `lastmodifiedby` = $userid
    WHERE clientid = $clientid AND `categoryid` = $id;
END $$

DROP PROCEDURE IF EXISTS `spdeletecustomer` $$
CREATE PROCEDURE `spdeletecustomer`(IN $clientid INT, IN $customerid INT, IN $userid INT)
BEGIN
    UPDATE `customers` SET deleted = 1, lastmodifiedon = NOW(), lastmodifiedby = $userid
    WHERE clientid = $clientid AND customerid = $customerid;
END $$

DROP PROCEDURE IF EXISTS `spdeletecustomerdiscount` $$
CREATE PROCEDURE `spdeletecustomerdiscount`(`$id` NUMERIC, `$userid` INT)
BEGIN
	UPDATE `customerdiscountsettings` SET `deleted`=1, `lastmodifiedby`=$userid, `lastmodifiedon`=NOW()
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spdeleteglaccount` $$
CREATE PROCEDURE `spdeleteglaccount`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `glaccounts` SET `deleted`=1, `lastdateupdated`=NOW(), `lastupdatedby`=$clientid WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spdeleteglgroup` $$
CREATE PROCEDURE `spdeleteglgroup`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `glaccountgroups` SET `deleted`=1,`lastupdatedby`=$clientid,`lastdateupdated`=NOW() WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spdeleteheldsale` $$
CREATE PROCEDURE `spdeleteheldsale`(`$id` INT)
BEGIN
	START TRANSACTION;
		DELETE FROM `heldsalesdetails` WHERE `heldsaleid`=$id;
		DELETE FROM `heldsales` WHERE `id`=$id;
	COMMIT;
    END $$

DROP PROCEDURE IF EXISTS `spdeleteoutlet` $$
CREATE PROCEDURE `spdeleteoutlet`(`$id` INT, `$userid` INT)
BEGIN
	UPDATE `useroutlets` SET deleted=1, `lastdatemodified`=NOW(),`lastmodifiedby`=$userid
	WHERE id=$id;
    END $$

DROP PROCEDURE IF EXISTS `spdeletepos` $$
CREATE PROCEDURE `spdeletepos`(`$posid` NUMERIC, `$clientid` NUMERIC)
BEGIN
	UPDATE `pointsofsale` SET `deleted`=1, `lastdatemodified`=NOW(), `lastmodifiedby`=$clientid WHERE `id`=$posid;
    END $$

DROP PROCEDURE IF EXISTS `spdeleteproduct` $$
CREATE PROCEDURE `spdeleteproduct`(IN $clientid INT, IN $productid INT, IN $userid INT)
BEGIN
    UPDATE `products` SET `deleted` = 1, `lastmodifiedon` = NOW(), `lastmodifiedby` = $userid 
    WHERE clientid = $clientid AND `productid` = $productid;
END $$

DROP PROCEDURE IF EXISTS `spdeleterole` $$
CREATE PROCEDURE `spdeleterole`(`$roleid` INT, `$clientid` INT)
BEGIN
	UPDATE `roles` 
	SET `deleted`=1, `deletedby`=$clientid, `lastdatemodified`=NOW(), `lastmodifiedby`=$clientid
	WHERE `roleid`=$roleid;
    END $$

DROP PROCEDURE IF EXISTS `spdeletesupplier` $$
CREATE PROCEDURE `spdeletesupplier`(`$supplierid` NUMERIC, `$clientid` NUMERIC)
BEGIN
	UPDATE `suppliers` SET `deleted`=1, `lastdatemodified`=NOW(),`lastmodifiedby`=$clientid WHERE `supplierid`=$supplierid;
    END $$

DROP PROCEDURE IF EXISTS `spdeletesupplierproduct` $$
CREATE PROCEDURE `spdeletesupplierproduct`(`$id` INT, `$userid` INT)
BEGIN
	UPDATE `supplierproducts` SET `deleted`=1, `lastmodifiedby`=$userid, `lastmodifieddate`=NOW()
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spdeleteuser` $$
CREATE PROCEDURE `spdeleteuser`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `user` SET `accountactive`=0,`lastmodifiedon`=NOW(),`lastmodifiedby`=$clientid, `reasoninactive`='Account deleted'
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spdisableuseraccount` $$
CREATE PROCEDURE `spdisableuseraccount`(`$id` INT, `$reason` VARCHAR(500), `$clientid` INT)
BEGIN
	UPDATE `user` SET `accountactive`=0,`reasoninactive`=$reason,`lastmodifiedby`=$clientid,`lastmodifiedon`=NOW()
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spenableuseraccount` $$
CREATE PROCEDURE `spenableuseraccount`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `user` SET `accountactive`=1, `lastmodifiedon`=NOW(),`lastmodifiedby`=$clientid
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spfilterproductsalesbymonth` $$
CREATE PROCEDURE `spfilterproductsalesbymonth`(`$startdate` VARCHAR(50), `$enddate` VARCHAR(50), `$productname` VARCHAR(50))
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
    END $$

DROP PROCEDURE IF EXISTS `spfilterproductsbyname` $$
CREATE PROCEDURE `spfilterproductsbyname`(IN $clientid INT, IN $name VARCHAR(50), IN $posid INT)
BEGIN
    SELECT * FROM `products` 
    WHERE clientid = $clientid AND `itemname` LIKE CONCAT('%', $name, '%') AND `deleted` = 0 
    ORDER BY `itemname` LIMIT 20;
END $$

DROP PROCEDURE IF EXISTS `spfilterquotations` $$
CREATE PROCEDURE `spfilterquotations`(`$customerid` INT, `$startdate` DATE, `$enddate` DATE, `$quotestatus` VARCHAR(50))
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
    END $$

DROP PROCEDURE IF EXISTS `spfilterstocktransfer` $$
CREATE PROCEDURE `spfilterstocktransfer`(`$source` VARCHAR(50), `$sourceid` INT, `$destination` VARCHAR(50), `$destinationid` INT, `$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	IF $source='all' THEN
		IF $destination='all' THEN
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			ORDER BY dateadded;
		ELSEIF $destination='outlet' THEN
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			AND destinationid=$destinationid AND destinationtype='pos' 
			ORDER BY dateadded;
		ELSE
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			AND destinationid=$destinationid AND destinationtype='warehouse'
			ORDER BY dateadded;
		END IF;
	ELSE
		IF $destination='all' THEN
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			AND sourceid=$sourceid
			ORDER BY dateadded;
		ELSEIF $destination='outlet' THEN 
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			AND sourceid=$sourceid AND destinationid=$destinationid AND destinationtype='pos'
			ORDER BY dateadded;
		ELSE
			SELECT * FROM vwstocktransfers WHERE  `dateadded` BETWEEN $startdate AND $enddate
			AND sourceid=$sourceid AND destinationid=$destinationid AND destinationtype='warehouse'
			ORDER BY dateadded;
		END IF;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetaccountspayableaginganalysis` $$
CREATE PROCEDURE `spgetaccountspayableaginganalysis`(`$basedate` DATETIME)
BEGIN
	SET @basedate=$basedate;
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	
	SELECT  IFNULL(suppliername,'TOTAL') AS suppliername,SUM(amountoverdue) AS `total`,
		SUM(IF(`range`='1',amountoverdue,0)) AS `thirty`,  
		SUM(IF(`range`='31',amountoverdue,0)) AS `sixty`,
		SUM(IF(`range`='61',amountoverdue,0)) AS `ninenty` ,
		SUM(IF(`range`='91',amountoverdue,0)) AS `onetwenty` ,
		SUM(IF(`range`='120+',amountoverdue,0)) AS `aboveonetwenty` 
	FROM (SELECT i.id AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,
	CASE 
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 1 AND 30 THEN '1' 
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 31 AND 60 THEN '31'
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 61 AND 90 THEN '61'
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 91 AND 120 THEN '91'
		WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d'))>=120 THEN '120+' 
	END `range`,
	SUM(`quantity`*`unitprice`) -
	IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
	WHERE v.`id`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno` AND DATE_FORMAT(v.`date`,'%Y-%m-%d')<=@basedate),0) AS amountoverdue
	FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
	WHERE i.`id`=id.`invoiceid` AND s.`supplierid`=i.`supplierid` 
	AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
	GROUP BY i.id ,s.`supplierid`,suppliername,`invoiceno`,`status`,DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d'))
	ORDER BY `invoicedate` DESC, `invoiceno`) AS tab1
	GROUP BY suppliername
	WITH ROLLUP;
    END $$

DROP PROCEDURE IF EXISTS `spgetaccountsreceivableaginganalysis` $$
CREATE PROCEDURE `spgetaccountsreceivableaginganalysis`(`$basedate` DATETIME)
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
	WHERE p.`id`=pd.`possaleid` AND pp.`possaleid`=p.`id` AND pp.`paymentmode`=4  AND c.`customerid`=p.`customerid`-- AND p.`customerid`=$customerid  
	AND  pp.amount - IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`id`),0)>0
	AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d')>=@cutoffdate
	GROUP BY c.`customerid`,p.id,c.`customername`) AS tab1
	GROUP BY customername
	WITH ROLLUP;
    END $$

DROP PROCEDURE IF EXISTS `spgetallusers` $$
CREATE PROCEDURE `spgetallusers`(IN $clientid INT)
BEGIN
    SELECT u.*, IFNULL(CONCAT(a.firstname,' ',a.middlename,' ',a.lastname),'System') AS addedbyname 
    FROM `user` u  LEFT OUTER JOIN `user` a ON u.addedby=a.userid
    WHERE u.clientid = $clientid
    ORDER BY u.`firstname`,u.`middlename`,u.`lastname`;
END $$

DROP PROCEDURE IF EXISTS `spgetavailableproductserialnumbers` $$
CREATE PROCEDURE `spgetavailableproductserialnumbers`(`$itemid` INT)
BEGIN
	SELECT `serialno` FROM `goodsreceiveddetails` g
	WHERE `serialno` NOT IN(SELECT `serialno` FROM `possalesdetails` WHERE `itemcode`=$itemid)
	AND `itemcode`=$itemid
	ORDER BY `serialno`;
    END $$

DROP PROCEDURE IF EXISTS `spgetbalancesheet` $$
CREATE PROCEDURE `spgetbalancesheet`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	
	SET @startdate=$startdate,@enddate=$enddate;
	SELECT 'PROFIT' `accountcode`,CASE WHEN SUM(`debit`-`credit`)>0 THEN 'Profit Before Tax' ELSE 'Loss Before Tax' END `accountname`,'Financed By' classname,
	'Profit / Loss'`groupname`,SUM(`credit`-`debit`) AS `total`
	FROM `glaccounts` g, `gltransactions` t, `glaccountgroups` p, `glaccountclasses` c
	WHERE g.`id`=t.`glaccount` AND p.`id`=g.`groupid` AND p.`glaccountclass`=c.`id` 
	AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	AND classname IN('Income','Expense')
		
	UNION 
	SELECT `accountcode`,`accountname`,classname,
	`groupname`,ABS(SUM(`debit`-`credit`)) AS `total`
	FROM `glaccounts` g, `gltransactions` t, `glaccountgroups` p, `glaccountclasses` c
	WHERE g.`id`=t.`glaccount` AND p.`id`=g.`groupid` AND p.`glaccountclass`=c.`id` 
	AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	AND classname NOT IN('Income','Expense')
	GROUP BY `accountcode`,`accountname` , `groupname`
	ORDER BY classname ,`accountcode`;
	
    END $$

DROP PROCEDURE IF EXISTS `spgetbestcustomer` $$
CREATE PROCEDURE `spgetbestcustomer`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SELECT customername, SUM(receipttotal) total 
	FROM `vwsalessummary`
	WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
	GROUP BY customername
	ORDER BY SUM(receipttotal) DESC 
	LIMIT 5;
    END $$

DROP PROCEDURE IF EXISTS `spgetbestpos` $$
CREATE PROCEDURE `spgetbestpos`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SELECT pointofsale, SUM(receipttotal) AS total 
	FROM `vwsalessummary` 
	WHERE transactiondate BETWEEN $startdate AND $enddate
	GROUP BY pointofsale
	ORDER BY SUM(receipttotal) DESC
	LIMIT 5;
    END $$

DROP PROCEDURE IF EXISTS `spgetbestproduct` $$
CREATE PROCEDURE `spgetbestproduct`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SELECT p.`itemcode`,`itemname`, SUM(quantity) sold FROM `products` p, `possales` s, `possalesdetails` sd
	WHERE `productid`=sd.itemcode AND s.`id`=sd.`possaleid` AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d')  BETWEEN $startdate AND $enddate
	GROUP BY p.`itemcode`,`itemname`
	ORDER BY SUM(quantity) DESC
	LIMIT 5;
    END $$

DROP PROCEDURE IF EXISTS `spgetbestsellingcategory` $$
CREATE PROCEDURE `spgetbestsellingcategory`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
	SELECT `categoryname`,SUM(s.`quantity`) quantity,AVG(s.`unitprice`) unitprice
	FROM `categories` c,`products` p,`possales` o,`possalesdetails` s
	WHERE c.`categoryid`=p.`categoryid` AND p.`productid`=s.`itemcode` AND s.`possaleid`=o.possaleid
	AND o.branchid = $branchid AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	GROUP BY `categoryname`
	ORDER BY SUM(quantity) DESC 
	LIMIT 5;
END $$

DROP PROCEDURE IF EXISTS `spgetbestsellingproducts` $$
CREATE PROCEDURE `spgetbestsellingproducts`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $userid INT)
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
END $$

DROP PROCEDURE IF EXISTS `spgetbundleitems` $$
CREATE PROCEDURE `spgetbundleitems`()
BEGIN
	SELECT * FROM products WHERE bundleitem=1 AND IFNULL(deleted,0)=0
	ORDER BY `itemname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetcashbookaccounts` $$
CREATE PROCEDURE `spgetcashbookaccounts`()
BEGIN
	SELECT g.`id`,`accountcode`,`accountname`, `groupname` FROM `glaccounts` g, `glaccountgroups` p
	WHERE p.`id`=g.`groupid` AND p.`cashbookaccount`=1 ORDER BY `accountname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetcategories` $$
CREATE PROCEDURE `spgetcategories`(IN $clientid INT)
BEGIN
    SELECT * FROM `categories` WHERE clientid = $clientid AND `deleted` = 0 ORDER BY `categoryname`;
END $$

DROP PROCEDURE IF EXISTS `spgetcategorydetails` $$
CREATE PROCEDURE `spgetcategorydetails`(IN $clientid INT, IN $id INT)
BEGIN
    SELECT * FROM `categories` WHERE clientid = $clientid AND `categoryid` = $id;
END $$

DROP PROCEDURE IF EXISTS `spgetcrateadditionparameters` $$
CREATE PROCEDURE `spgetcrateadditionparameters`()
BEGIN
	SELECT p.*,(SELECT `buyingprice` FROM `products` WHERE productid=p.productid) AS price
	FROM `cratesinventorysettings` p;
    END $$

DROP PROCEDURE IF EXISTS `spgetcrateinventorysettings` $$
CREATE PROCEDURE `spgetcrateinventorysettings`()
BEGIN
	SELECT s.*,IFNULL((SELECT `buyingprice` FROM `products` WHERE productid=s.productid),0) AS price
	FROM `cratesinventorysettings` s;
    END $$

DROP PROCEDURE IF EXISTS `spgetcreditnotevalue` $$
CREATE PROCEDURE `spgetcreditnotevalue`(`$creditnotenumber` VARCHAR(50))
BEGIN
	SELECT `noteno`,`dateadded`,SUM(`quantity`*`unitprice`) AS creditnotetotal
	FROM `creditnotes` c, `creditnotedetails` cd
	WHERE c.`id`=cd.`noteid` AND `noteno`=$creditnotenumber;
    END $$

DROP PROCEDURE IF EXISTS `spgetcustomeraginganalysis` $$
CREATE PROCEDURE `spgetcustomeraginganalysis`(`$customerid` INT, `$basedate` DATETIME)
BEGIN
	SET @basedate=$basedate,@customerid=$customerid;
	
	SELECT `cutoffdate` INTO @cutoffdate FROM `startingparameters`;
	SET @cutoffdate=IFNULL(@cutoffdate,'2022-01-01');
	
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
    END $$

DROP PROCEDURE IF EXISTS `spgetcustomercategories` $$
CREATE PROCEDURE `spgetcustomercategories`(IN $clientid INT)
BEGIN
    SELECT * FROM `customercategories` WHERE clientid = $clientid AND `deleted` = 0 ORDER BY `categoryname`;
END $$

DROP PROCEDURE IF EXISTS `spgetcustomercreditnotes` $$
CREATE PROCEDURE `spgetcustomercreditnotes`(`$customerid` NUMERIC)
BEGIN
	SELECT `noteno` AS creditnotenumber FROM `creditnotes` WHERE `customerid`=$customerid AND `used`=0
	ORDER BY `noteno`;
    END $$

DROP PROCEDURE IF EXISTS `spgetcustomerdetails` $$
CREATE PROCEDURE `spgetcustomerdetails`(IN $clientid INT, IN $customerid INT)
BEGIN
    SELECT * FROM `customers` WHERE clientid = $clientid AND customerid = $customerid;
END $$

DROP PROCEDURE IF EXISTS `spgetcustomerdiscountsettings` $$
CREATE PROCEDURE `spgetcustomerdiscountsettings`(`$customerid` INT)
BEGIN
	SELECT c.`id`,`itemcode`,`itemname`,`sellingprice`, `discount`,`percentage`,`expirydate` FROM `products` p, `customerdiscountsettings` c
	WHERE c.`productid`=p.`productid` AND `customerid`=$customerid AND c.`deleted`=0 ORDER BY `itemname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetcustomeropenreceivables` $$
CREATE PROCEDURE `spgetcustomeropenreceivables`(`$customerid` INT)
BEGIN
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	SELECT p.`id`,`customerid`,`receiptdate` AS transactiondate, SUM(`quantity`*(`unitprice`-IFNULL(discount,0))) AS total,IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails`
	WHERE `possaleid`=p.`id`),0) AS paid,SUM(`quantity`*(`unitprice`-IFNULL(discount,0))) -
	IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`id`),0) AS balance
	FROM `possales` p, `possalesdetails` pd, `possalespayments` pp
	WHERE p.`id`=pd.`possaleid` AND pp.`possaleid`=p.`id` AND pp.`paymentmode`=4 AND p.`customerid`=$customerid  
	AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d')>=@cutoffdate
	GROUP BY p.`id`,`customerid`,`receiptdate`
	HAVING SUM(`quantity`*(`unitprice`-IFNULL(discount,0))) - IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`id`),0) >0
	ORDER BY `receiptdate`, p.`id`;
    END $$

DROP PROCEDURE IF EXISTS `spgetcustomerreceiptdetails` $$
CREATE PROCEDURE `spgetcustomerreceiptdetails`(`$receiptno` VARCHAR(50))
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
	'Customer amount overpaid'  AS narration, `credit` AS amount
	FROM `customerreceipts` c, `customersuspenseaccount` cr, `paymentmethods` p, `user` u, `customers` m
	WHERE c.`receiptno`=cr.`referenceno` AND c.`customerid`=m.customerid AND c.`addedby`=u.`id` AND c.`modeofpayment`=p.`id`
	AND c.`receiptno`=$receiptno;
    END $$

DROP PROCEDURE IF EXISTS `spgetcustomers` $$
CREATE PROCEDURE `spgetcustomers`(IN $clientid INT, IN $posid INT, IN $regularcustomers TINYINT, IN $onetimecustomers TINYINT)
BEGIN
    SELECT * FROM `customers` 
    WHERE clientid = $clientid AND `deleted` = 0
    AND (($regularcustomers = 1 AND onetimecustomer = 0) OR ($onetimecustomers = 1 AND onetimecustomer = 1))
    ORDER BY customername;
END $$

DROP PROCEDURE IF EXISTS `spgetcustomerstatement` $$
CREATE PROCEDURE `spgetcustomerstatement`(`$customerid` INT, `$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SET @startdate=$startdate,@enddate=$enddate;
	SET @customerid=$customerid;
	
	SELECT CASE WHEN DATE_FORMAT(`cutoffdate`,'%Y-%m-%d')>@startdate THEN DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') ELSE @startdate END
	INTO @startdate FROM `startingparameters`;
	
	SELECT customerid,customername,physicaladdress,postaladdress,mobile,email, DATE_FORMAT(`date`,'%d-%b-%Y') `date`,`narration`,reference, invoiceamount,invoicepayment,
	IFNULL((SELECT SUM(invoiceamount)-SUM(invoicepayment) FROM vwcustomerstomerstatement v WHERE v.customerid=s.customerid AND  DATE_FORMAT(`date`,'%Y-%m-%d')<=@startdate),0) AS `openingbalance`,
	IFNULL((SELECT SUM(invoiceamount)-SUM(invoicepayment) FROM vwcustomerstomerstatement v WHERE v.customerid=s.customerid AND  DATE_FORMAT(`date`,'%Y-%m-%d')<=@enddate),0) AS `closingbalance`,
	IFNULL((SELECT SUM(invoiceamount) FROM vwcustomerstomerstatement v WHERE v.customerid=s.customerid AND  DATE_FORMAT(`date`,'%Y-%m-%d') BETWEEN @startdate AND @enddate),0) AS `invoices`,
	IFNULL((SELECT SUM(invoicepayment) FROM vwcustomerstomerstatement v WHERE v.customerid=s.customerid AND  DATE_FORMAT(`date`,'%Y-%m-%d') BETWEEN @startdate AND @enddate),0) AS `payments`
	
	FROM vwcustomerstomerstatement s
	WHERE `customerid`=@customerid AND DATE_FORMAT(`date`,'%Y-%m-%d')  BETWEEN @startdate AND @enddate
	ORDER BY  DATE_FORMAT(`date`,'%Y-%m-%d'), `order`;
	
    END $$

DROP PROCEDURE IF EXISTS `spgetcustomerunbankedreceipts` $$
CREATE PROCEDURE `spgetcustomerunbankedreceipts`(`$startdate` DATETIME, `$enddate` DATETIME, `$paymentmethod` INT)
BEGIN
	IF $paymentmethod=0 THEN 
		SELECT id,DATE_FORMAT(`date`,'%d-%b-%Y') AS `date`, customername,posname,description,receiptno,reference,amount,addedby
		FROM vwcustomerreceipts WHERE DATE BETWEEN $startdate AND $enddate AND banked=0
		ORDER BY receiptno;
	ELSE
		SELECT id,DATE_FORMAT(`date`,'%d-%b-%Y') AS `date`, customername,posname,description,receiptno,reference,amount,addedby
		FROM vwcustomerreceipts WHERE DATE BETWEEN $startdate AND $enddate AND banked=0 AND paymentmodeid=$paymentmethod
		ORDER BY receiptno;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetcustomesuspenseaccountstatement` $$
CREATE PROCEDURE `spgetcustomesuspenseaccountstatement`(`$customerid` INT, `$startdate` DATE, `$enddate` DATE)
BEGIN
	SELECT DATE_FORMAT($startdate,'%d-%b-%Y') `date`,''  `referenceno`,'Opening balance' `narration`,
	CASE WHEN SUM(IFNULL(credit,0)-IFNULL(debit,0))>0 THEN credit ELSE 0 END credit, 
	CASE WHEN SUM(IFNULL(credit,0)-IFNULL(debit,0))<0 THEN credit ELSE 0 END debit,'' AS addedby
	FROM `customersuspenseaccount` WHERE  DATE_FORMAT(`transactiondate`,'%Y-%m-%d') < $startdate AND  `customerid`=$customerid
	
	UNION
	
	SELECT * FROM (SELECT DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`,`referenceno`,`narration`,`credit`,`debit`, CONCAT(`firstname`,' ',`lastname`) addedby
	FROM `customersuspenseaccount` c, `user` u
	WHERE c.`addedby`=u.`id` AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND c.`customerid`=$customerid
	ORDER BY `transactiondate`, `referenceno`) AS a;
    END $$

DROP PROCEDURE IF EXISTS `spgetdashboardheaders` $$
CREATE PROCEDURE `spgetdashboardheaders`(IN $branchid INT, IN $date DATETIME)
BEGIN
	SELECT 
	(SELECT SUM(amount) FROM `vwsalessummary2` WHERE branchid = $branchid AND DATE_FORMAT(transactiondate,'%Y-%m-%d') = $date) AS today_sales,
	(SELECT COUNT(DISTINCT receiptno) FROM `vwsalessummary2` WHERE branchid = $branchid AND DATE_FORMAT(transactiondate,'%Y-%m-%d') = $date) AS today_customers,
	(SELECT SUM(amount) FROM `vwsalessummary2` WHERE branchid = $branchid AND DATE_FORMAT(transactiondate,'%Y-%m') = DATE_FORMAT($date,'%Y-%m')) AS month_sales,
	(SELECT COUNT(DISTINCT receiptno) FROM `vwsalessummary2` WHERE branchid = $branchid AND DATE_FORMAT(transactiondate,'%Y-%m') = DATE_FORMAT($date,'%Y-%m')) AS month_customers;
END $$

DROP PROCEDURE IF EXISTS `spgetdashboardsummary` $$
CREATE PROCEDURE `spgetdashboardsummary`(`$startdate` DATETIME, `$enddate` DATETIME)
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
	
    END $$

DROP PROCEDURE IF EXISTS `spgetdiscountreport` $$
CREATE PROCEDURE `spgetdiscountreport`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	/*SET @startdate=date_format($startdate,'%d-%m-%Y');
	SET @enddate=date_format($enddate,'%d-%m-%Y');*/
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
	
    END $$

DROP PROCEDURE IF EXISTS `spgetemailconfiguration` $$
CREATE PROCEDURE `spgetemailconfiguration`()
BEGIN
	SELECT * FROM `emailconfiguration`;
    END $$

DROP PROCEDURE IF EXISTS `spgetglaccountclasses` $$
CREATE PROCEDURE `spgetglaccountclasses`()
BEGIN
	SELECT `id`,`classname`,REPLACE(CONCAT(`classname`, CASE WHEN RIGHT(`classname`,1)='y' THEN 'ies' ELSE 's' END),'y','') AS newname 
	FROM glaccountclasses ORDER BY `classname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetglaccountdetails` $$
CREATE PROCEDURE `spgetglaccountdetails`(`$id` INT)
BEGIN
	SELECT a.* , g.id AS subgroupid, gg.`id` AS parentgroupid, c.`id` AS classid 
	FROM `glaccounts` a, `glaccountgroups` g, `glaccountgroups` gg, `glaccountclasses` c 
	WHERE  a.`groupid`=g.id AND g.`subactegoryof`=gg.id AND g.`glaccountclass`=c.id  AND a.`id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spgetglaccounts` $$
CREATE PROCEDURE `spgetglaccounts`(IN $clientid INT)
BEGIN
    SELECT * FROM `glaccounts` WHERE clientid = $clientid AND `deleted` = 0 ORDER BY `accountname`;
END $$

DROP PROCEDURE IF EXISTS `spgetglgroups` $$
CREATE PROCEDURE `spgetglgroups`(`$category` INT)
BEGIN
	IF $category=0 THEN
		SELECT * FROM `glaccountgroups` ORDER BY `groupname`;
	ELSE
		SELECT * FROM `glaccountgroups` WHERE `glaccountclass`=$category
		ORDER BY `groupname`;
	END IF ;
    END $$

DROP PROCEDURE IF EXISTS `spgetglstatement` $$
CREATE PROCEDURE `spgetglstatement`(`$startdate` DATETIME, `$enddate` DATETIME, `$accountid` INT)
BEGIN
    
	SET @startdate=$startdate,@enddate=$enddate,@accountid=$accountid;
	SET @openingbalancedate=DATE_SUB(@startdate, INTERVAL 1 DAY );
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	
	SELECT `accountcode`,`accountname`,`classname`, DATE_FORMAT(`transactiondate`,'%d-%b-%Y') AS `transactiondate`,`referenceno`, `narration`, `debit`,`credit`,
	CONCAT(`firstname`,' ',`middlename`) AS `addedby` ,
	IFNULL((SELECT SUM(IFNULL(`debit`,0)-IFNULL(`credit`,0)) FROM `gltransactions` WHERE `glaccount`=a.id AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @cutoffdate AND @openingbalancedate),0) `openingbalance`,
	IFNULL((SELECT SUM(IFNULL(`debit`,0)) FROM `gltransactions` WHERE `glaccount`=a.id AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate),0) `debits`,
	IFNULL((SELECT SUM(IFNULL(`credit`,0)) FROM `gltransactions` WHERE `glaccount`=a.id AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate),0) `credits` ,
	IFNULL((SELECT SUM(IFNULL(`debit`,0)-IFNULL(`credit`,0)) FROM `gltransactions` WHERE `glaccount`=a.id  AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @cutoffdate AND @enddate),0) AS `closingbalance`
	FROM `glaccounts` a, `glaccountgroups` g, `glaccountclasses` c, `user` u, `gltransactions` t
	WHERE a.`groupid`=g.`id` AND g.`glaccountclass`=c.id  AND a.`id`=t.`glaccount` AND t.`addedby`=u.`id`
	AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate AND a.`id`=@accountid
	ORDER BY `transactiondate`;
    END $$

DROP PROCEDURE IF EXISTS `spgetglsubgroups` $$
CREATE PROCEDURE `spgetglsubgroups`(`$groupid` INT)
BEGIN
	IF $groupid=0 THEN
		SELECT * FROM `glaccountgroups` WHERE `subactegoryof`<>0 ORDER BY `groupname`;
	ELSE
		SELECT * FROM `glaccountgroups` WHERE `subactegoryof`=$groupid ORDER BY `groupname`;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetgrnitemdetails` $$
CREATE PROCEDURE `spgetgrnitemdetails`(`$grnno` VARCHAR(50), `$productid` INT)
BEGIN
	SELECT p.productid,p.`itemcode`, `itemname`,gd.`quantity`,od.`unitprice`,`serialno`
	FROM  goodsreceived g,`goodsreceiveddetails` gd, `products` p, `purchaseorders` o, `purchaseorderdetails` od
	WHERE g.grnno=gd.grnno AND gd.`itemcode`=p.productid AND o.`id`=od.`purchaseorderid` AND od.`itemcode`=p.productid 
	AND gd.`purchaseorderno`=o.`purchaseorderno` AND p.productid=$productid AND (gd.grnno=$grnno OR g.invoiceno=$grnno);
    END $$

DROP PROCEDURE IF EXISTS `spgetgrnproducts` $$
CREATE PROCEDURE `spgetgrnproducts`(`$grnno` VARCHAR(50))
BEGIN
	SELECT DISTINCT gd.`itemcode` AS productid, p.`itemcode`,`itemname` 
	FROM `goodsreceiveddetails` gd,`products` p, `goodsreceived` g
	WHERE  g.grnno=gd.grnno AND gd.itemcode=p.productid 
	AND (gd.`grnno`=$grnno OR g.`invoiceno`=$grnno) -- AND IFNULL(s.deleted,0)=0
	ORDER BY `itemname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetheldsaledetails` $$
CREATE PROCEDURE `spgetheldsaledetails`(`$id` INT)
BEGIN
	SELECT `itemcode`, `itemname`, `quantity`,`unitprice`,`discount`,
	`fn_getitemstorebalance`(p.productid ,posid)itembalance 
	FROM `heldsalesdetails` hd, `products` p, `heldsales` h
	WHERE h.`id`=hd.`heldsaleid` AND p.`productid`=hd.`productid` AND `heldsaleid`=$id
	ORDER BY `itemname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetheldsaleheader` $$
CREATE PROCEDURE `spgetheldsaleheader`(`$id` INT)
BEGIN
	SELECT `customerid`,`posid` FROM `heldsales` WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spgetheldsales` $$
CREATE PROCEDURE `spgetheldsales`(`$userid` INT)
BEGIN
	SELECT h.`id`,`dateheld`,`customername`,`posname`
	FROM `heldsales` h, `customers` c, `pointsofsale` s

	WHERE h.`customerid`=c.`customerid` AND h.`posid`=s.`id` 
	AND h.`addedby`=$userid ORDER BY h.`id` DESC;
    END $$

DROP PROCEDURE IF EXISTS `spgetinsertedcustomer` $$
CREATE PROCEDURE `spgetinsertedcustomer`()
BEGIN
	SELECT MAX(customerid)AS customerid FROM `customers` ;
    END $$

DROP PROCEDURE IF EXISTS `spgetinstitutiondetails` $$
CREATE PROCEDURE `spgetinstitutiondetails`(IN $clientid INT)
BEGIN
    SELECT * FROM institution WHERE clientid = $clientid;
END $$

DROP PROCEDURE IF EXISTS `spgetinvoicegrns` $$
CREATE PROCEDURE `spgetinvoicegrns`(`$id` INT)
BEGIN
	DECLARE $suppliercontrolaccount INT;
	SET $suppliercontrolaccount=(SELECT id FROM `glaccounts` WHERE `accountcode`=(SELECT `account` FROM `glaccountsettings` WHERE `description`='Suppliers Control Account'));
	SELECT p.`itemcode`,description,SUM(`quantity`) quantity,AVG(`unitprice`) unitprice,$suppliercontrolaccount AS accountcharged 
	FROM `supplierinvoicedetails` id, `products` p WHERE p.`productid`=id.`itemcode` AND `invoiceid`=$id
	GROUP BY p.`itemcode`,description;
    END $$

DROP PROCEDURE IF EXISTS `spgetitemstatement` $$
CREATE PROCEDURE `spgetitemstatement`(`$itemcode` VARCHAR(50), `$startdate` DATE, `$enddate` DATE)
BEGIN
	DECLARE $productid INT ;
	
	SET @startdate=$startdate;
	SELECT CASE WHEN `cutoffdate`>=@startdate THEN cutoffdate ELSE $startdate END INTO @startdate FROM `startingparameters`;
	SET @enddate=$enddate;
	SET @balancedate=DATE_SUB(@startdate, INTERVAL 1 DAY);
	SET @itemcode=$itemcode;
	
	SELECT `productid` INTO $productid 
	FROM `products` WHERE `itemcode`=$itemcode;
	
	-- get opening balance
	SELECT `productid`,`itemcode`,`itemname`,'Opening balance' description,NULL AS reference, DATE_FORMAT(@balancedate,'%d-%b-%Y') AS `date`,0 AS `sortkey`,NULL AS stockin, NULL AS stockout,fn_getitemstockbalance(productid,@balancedate) openingbalance, @balancedate AS unmodifieddate
	FROM `products` WHERE itemcode=@itemcode
	
	UNION
	
	-- get reconcilled balances
	SELECT productid,itemcode,itemname,'Reconciled balance','<None>' reference,DATE_FORMAT(`reconciliationdate`,'%Y-%b-%d') `date`,1 sortkey,quantity stockin, NULL `stockout`,NULL openingbalance,`reconciliationdate` unmodifieddate
	FROM `stockreconciledbalance` s
	JOIN `stockreconciledbalancedetails` sd ON sd.`reconciliationid`=s.`id` 
	JOIN products p ON p.productid=sd.itemid 
	WHERE `itemid`=$productid AND DATE_FORMAT(`reconciliationdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	
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
	WHERE p.itemcode=@itemcode AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND s.deleted=0
	GROUP BY  productid, p.itemcode,`itemname`, DATE_FORMAT(`receiptdate`,'%d-%b-%Y'), receiptno
	ORDER BY unmodifieddate,sortkey;
    END $$

DROP PROCEDURE IF EXISTS `spgetmasterstocksheet` $$
CREATE PROCEDURE `spgetmasterstocksheet`(`$enddate` DATE)
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
    END $$

DROP PROCEDURE IF EXISTS `spgetmpesac2bparameters` $$
CREATE PROCEDURE `spgetmpesac2bparameters`()
BEGIN
	SELECT c2burl,c2bshortcode,c2bmsisdn FROM mpesaconfiguration;
    END $$

DROP PROCEDURE IF EXISTS `spgetmpesaconfiguration` $$
CREATE PROCEDURE `spgetmpesaconfiguration`()
BEGIN
	SELECT * FROM `mpesaconfiguration`;
    END $$

DROP PROCEDURE IF EXISTS `spgetmpesatransaction` $$
CREATE PROCEDURE `spgetmpesatransaction`(`$amount` INT, `$reference` VARCHAR(50))
BEGIN
	IF $reference='' THEN
		SELECT * FROM `mpesaconfirmation` WHERE `amount`=$amount AND DATE_FORMAT(`date`,'%Y-%m-%d')=DATE_FORMAT(NOW(),'%Y-%m-%d') AND IFNULL(`used`,0)=0;
	ELSE
		SELECT * FROM `mpesaconfirmation` WHERE `reference`=$reference AND IFNULL(`used`,0)=0;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetnonuseroutlets` $$
CREATE PROCEDURE `spgetnonuseroutlets`(`$clientid` INT)
BEGIN
	SELECT *
	FROM  `pointsofsale` s  
	WHERE id NOT IN(SELECT `outletid` FROM `useroutlets` WHERE `userid`=$clientid AND IFNULL(`deleted`,0)=0)
	AND IFNULL(s.deleted,0)=0
	ORDER BY posname;
    END $$

DROP PROCEDURE IF EXISTS `spgetnonuserroles` $$
CREATE PROCEDURE `spgetnonuserroles`(`$clientid` INT)
BEGIN
	SELECT * FROM `roles` 
	WHERE roleid NOT IN(SELECT `roleid` FROM `roleusers` WHERE `userid`=$clientid)
	ORDER BY rolename;
    END $$

DROP PROCEDURE IF EXISTS `spgetobjectdetails` $$
CREATE PROCEDURE `spgetobjectdetails`(`$objectid` INT)
BEGIN
	SELECT * FROM `objects` WHERE `id`=$objectid;
    END $$

DROP PROCEDURE IF EXISTS `spgetobjects` $$
CREATE PROCEDURE `spgetobjects`(IN $clientid INT, IN $module VARCHAR(50))
BEGIN
    IF $module='' OR $module IS NULL THEN
        SELECT `id`,`description`,`module` FROM `objects` WHERE clientid = $clientid ORDER BY `description`;
    ELSE
        SELECT `id`,`description`,`module` FROM `objects` WHERE clientid = $clientid AND `module` = $module ORDER BY `description`;
    END IF;
END $$

DROP PROCEDURE IF EXISTS `spgetparentgroups` $$
CREATE PROCEDURE `spgetparentgroups`(`$classid` INT)
BEGIN
	IF $classid=0 THEN
		SELECT * FROM `glaccountgroups`WHERE IFNULL(`subactegoryof`,0)=0 ORDER BY `groupname`;
	ELSE
		SELECT * FROM `glaccountgroups`WHERE IFNULL(`subactegoryof`,0)=0  AND `glaccountclass`=$classid ORDER BY `groupname`;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetpaymentmethods` $$
CREATE PROCEDURE `spgetpaymentmethods`(IN $branchid INT)
BEGIN
    SELECT * FROM paymentmethods WHERE branchid = $branchid;
END $$

DROP PROCEDURE IF EXISTS `spgetpaymentmethodsummary` $$
CREATE PROCEDURE `spgetpaymentmethodsummary`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SELECT paymentmode, SUM(receipttotal) AS total FROM `vwsalessummary`
	WHERE transactiondate BETWEEN $startdate AND $enddate
	GROUP BY paymentmode  
	ORDER BY SUM(receipttotal) DESC;
    END $$

DROP PROCEDURE IF EXISTS `spgetpaymentvoucher` $$
CREATE PROCEDURE `spgetpaymentvoucher`(`$id` VARCHAR(50))
BEGIN
	SELECT `suppliername`,`physicaladdress`,`postaladdress`,s.`mobile`,s.`email`, v.`voucherno`,DATE_FORMAT(v.`date`,'%d-%b-%Y') AS voucherdate, `invoicenumber`,p.`description` AS paymentmethod,`referenceno`,
	`itemcode`,vd.`description`,`quantity`,`unitprice`, CONCAT(`firstname`, ' ',`middlename`,' ',`lastname`) AS preparedby, o.`posname`
	FROM `paymentvouchers` v, `paymentvoucherdetails` vd, `paymentmethods` p, `suppliers` s, `user` u, `pointsofsale` o
	WHERE v.`id`=vd.`voucherid` AND v.`paymentmode`=p.id AND v.`supplier`=s.supplierid AND v.`addedby`=u.id AND  o.id=v.`pos` 
	AND v.`voucherno`=$id; -- v.`id`=$id;
	
    END $$

DROP PROCEDURE IF EXISTS `spgetpaymentvoucherdetails` $$
CREATE PROCEDURE `spgetpaymentvoucherdetails`(`$id` VARCHAR(50))
BEGIN
	SELECT p.id,`voucherno`, DATE_FORMAT(`date`,'%d-%b-%Y')`date`,`dateadded`,`addedby`,`paymentmode`,`pos`,`supplier`,`invoicenumber`,`cashbookaccount`,`referenceno`,`status`,`lastmodifiedby`,`lastmodifieddate` 
	FROM `paymentvouchers` p, paymentvoucherdetails pd  
	WHERE p.`id`=pd.`voucherid` AND voucherno=$id;
    END $$

DROP PROCEDURE IF EXISTS `spgetpaymentvouchers` $$
CREATE PROCEDURE `spgetpaymentvouchers`(`$supplierid` INT, `$posid` INT, `$stat` VARCHAR(50), `$paymentmode` INT, `$startdate` DATETIME, `$enddate` DATETIME, `$pettycashvoucher` BOOLEAN)
BEGIN
	IF $pettycashvoucher=0 THEN 
		-- Get payment vouchers 
		IF $supplierid=0 THEN 
			BEGIN
				IF $posid=0 THEN 
					BEGIN
						IF $stat='all' THEN 
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers`  WHERE voucherdate BETWEEN $startdate AND $enddate  AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						ELSE
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers`  WHERE voucherdate BETWEEN $startdate AND $enddate AND `status`=$stat  AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `status`=$stat  AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						END IF;
					END;
				ELSE
					BEGIN
						IF $stat='all' THEN 
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `posid`=$posid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `posid`=$posid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						ELSE
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `status`=$stat  AND `posid`=$posid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `status`=$stat AND `posid`=$posid AND `pettycashvoucher`=0 
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						END IF;
					END;
				END IF;
			END;
		ELSE
			BEGIN
				IF $posid=0 THEN 
					BEGIN
						IF $stat='all' THEN 
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `supplierid`=$supplierid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `supplierid`=$supplierid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						ELSE
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `status`=$stat  AND `supplierid`=$supplierid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `status`=$stat  AND `supplierid`=$supplierid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						END IF;
					END;
				ELSE
					BEGIN
						IF $stat='all' THEN 
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `posid`=$posid  AND `supplierid`=$supplierid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `posid`=$posid  AND `supplierid`=$supplierid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						ELSE
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `status`=$stat  AND `posid`=$posid  AND `supplierid`=$supplierid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `status`=$stat AND `posid`=$posid  AND `supplierid`=$supplierid AND `pettycashvoucher`=0
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						END IF;
					END;
				END IF;
			END;
		END IF;
	ELSE
		-- get pettycash vouchers
		IF $supplierid=0 THEN 
			BEGIN
				IF $posid=0 THEN 
					BEGIN
						IF $stat='all' THEN 
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						ELSE
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `status`=$stat  AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `status`=$stat  AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						END IF;
					END;
				ELSE
					BEGIN
						IF $stat='all' THEN 
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `posid`=$posid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `posid`=$posid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						ELSE
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `status`=$stat  AND `posid`=$posid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `status`=$stat AND `posid`=$posid  AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						END IF;
					END;
				END IF;
			END;
		ELSE
			BEGIN
				IF $posid=0 THEN 
					BEGIN
						IF $stat='all' THEN 
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers`  WHERE voucherdate BETWEEN $startdate AND $enddate AND `supplierid`=$supplierid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers`  WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `supplierid`=$supplierid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						ELSE
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `status`=$stat  AND `supplierid`=$supplierid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `status`=$stat  AND `supplierid`=$supplierid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						END IF;
					END;
				ELSE
					BEGIN
						IF $stat='all' THEN 
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `posid`=$posid  AND `supplierid`=$supplierid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers`  WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `posid`=$posid  AND `supplierid`=$supplierid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						ELSE
							BEGIN
								IF $paymentmode=0 THEN
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers` WHERE voucherdate BETWEEN $startdate AND $enddate AND `status`=$stat  AND `posid`=$posid  AND `supplierid`=$supplierid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								ELSE
									SELECT voucherid,pettycashvoucher,voucherno,DATE_FORMAT(voucherdate,'%d-%b-%Y') voucherdate,paymentmodeid,paymentmodedescription,posid,posname,
									supplierid,suppliername,invoicenumber,cashbookaccountid,accountcode,accountname,referenceno,`status`,vouchertotal,userid,username 
									FROM `vwpaymentvouchers`  WHERE voucherdate BETWEEN $startdate AND $enddate AND paymentmodeid=$paymentmode  AND `status`=$stat AND `posid`=$posid  AND `supplierid`=$supplierid AND `pettycashvoucher`=1
									ORDER BY voucherno,voucherdate;
								END IF;
							END;
						END IF;
					END;
				END IF;
			END;
		END IF;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetpaymentvoucherstatus` $$
CREATE PROCEDURE `spgetpaymentvoucherstatus`(`$id` INT)
BEGIN
	SELECT `status` FROM `paymentvouchers` WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spgetpoitemsundelivered` $$
CREATE PROCEDURE `spgetpoitemsundelivered`(`$purchaseorderid` VARCHAR(50))
BEGIN
	SELECT p.`purchaseorderno`, pd.`itemcode`,`itemname`,`unitprice`,`quanity` AS ordered,IFNULL(r.serializable,0) `serializable`,
	`quanity`-IFNULL((SELECT SUM(quantity) FROM `goodsreceiveddetails` WHERE `purchaseorderno`=p.`purchaseorderno` AND `itemcode`=pd.itemcode),0) AS undelivered
	FROM `purchaseorders` p, `purchaseorderdetails` pd, `products` r
	WHERE p.`id`=pd.`purchaseorderid` AND pd.`itemcode`=r.productid 
	AND p.`purchaseorderno`=$purchaseorderid
	AND `quanity`-IFNULL((SELECT SUM(quantity) FROM `goodsreceiveddetails` WHERE `purchaseorderno`=p.`purchaseorderno` AND `itemcode`=pd.itemcode),0) >0 ;
    END $$

DROP PROCEDURE IF EXISTS `spgetpos` $$
CREATE PROCEDURE `spgetpos`(IN $clientid INT)
BEGIN
    SELECT * FROM `pointsofsale` WHERE clientid = $clientid AND `deleted` = 0 ORDER BY `description`;
END $$

DROP PROCEDURE IF EXISTS `spgetposdetails` $$
CREATE PROCEDURE `spgetposdetails`(`$id` NUMERIC)
BEGIN
	SELECT * FROM `pointsofsale` WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spgetposreceipts` $$
CREATE PROCEDURE `spgetposreceipts`(`$startdate` DATETIME, `$enddate` DATETIME, `$posid` INT, `$modeofpay` INT)
BEGIN
	DECLARE modeofpayname VARCHAR(50) DEFAULT "";
	IF $modeofpay>0 THEN
		SET modeofpayname=(SELECT `description` FROM `paymentmethods` WHERE `id`=$modeofpay);
	END IF;
	
	IF $posid=0 THEN 
		IF $modeofpay=0 THEN
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
		ELSE
			SELECT s.`id`,`posname` ,`receiptno` , DATE_FORMAT(`receiptdate`,'%d-%b-%Y') AS `date`,`customername`,
			GROUP_CONCAT(DISTINCT m.description ORDER BY m.description) AS description, 
			GROUP_CONCAT( DISTINCT CASE WHEN p.`reference`='' THEN ' - ' ELSE p.reference END) reference, 
			CASE WHEN s.`deleted`=0 THEN 'Valid' ELSE 'Cancelled' END AS `status`,
			SUM(p.amount) AS `amount`,(SELECT CONCAT (`firstname`,' ',`middlename`) FROM `user` u WHERE u.id=s.`addedby`) AS `addedby`
			FROM `possales` s,`customers` c, `pointsofsale` o, `possalespayments` p, `paymentmethods` m
			WHERE s.`customerid`=c.`customerid` AND s.`pointofsaleid`=o.`id` AND p.`possaleid`=s.`id` AND m.`id`=p.`paymentmode`
			AND DATE_FORMAT(`s`.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY  s.id,`receiptno`
			HAVING description LIKE CONCAT('%',modeofpayname,'%')
			ORDER BY s.id DESC;
		END IF;
	ELSE	
	
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
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetposreceiptsforbanking` $$
CREATE PROCEDURE `spgetposreceiptsforbanking`(`$startdate` DATETIME, `$enddate` DATETIME, `$posid` INT, `$modeofpay` INT)
BEGIN
	DECLARE $modeofpayname VARCHAR(50) DEFAULT "";
	IF $modeofpay>0 THEN
		SET $modeofpayname=(SELECT `description` FROM `paymentmethods` WHERE `id`=$modeofpay);
	END IF;
	
	IF $posid=0 THEN
		BEGIN
			IF $modeofpay=0 THEN
				SELECT id,pointofsale AS posname, receiptno,DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`, paymentmode AS `description`, paymentmodereference reference, receipttotal amount, 
				userfullname `addedby`, customername
				FROM `vwsalessummary` WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND banked=0
				ORDER BY DATE_FORMAT(`transactiondate`,'%d-%b-%Y') , receiptno;
			ELSE
				SELECT id,pointofsale AS posname, receiptno,DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`, paymentmode AS `description`, paymentmodereference reference, receipttotal amount, 
				userfullname `addedby`, customername
				FROM `vwsalessummary` WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND paymentmode=$modeofpayname AND banked=0
				ORDER BY DATE_FORMAT(`transactiondate`,'%d-%b-%Y') , receiptno;
			END IF;
		END;
	ELSE
		BEGIN
			IF $modeofpay=0 THEN
				SELECT id,pointofsale AS posname, receiptno,DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`, paymentmode AS `description`, paymentmodereference reference, receipttotal amount, 
				userfullname `addedby`, customername
				FROM `vwsalessummary` WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND posid=$posid AND banked=0
				ORDER BY DATE_FORMAT(`transactiondate`,'%d-%b-%Y') , receiptno;
			ELSE
				SELECT id,pointofsale AS posname, receiptno,DATE_FORMAT(`transactiondate`,'%d-%b-%Y') `date`, paymentmode AS `description`, paymentmodereference reference, receipttotal amount, 
				userfullname `addedby`, customername
				FROM `vwsalessummary` WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND paymentmode=$modeofpayname  AND posid=$posid AND banked=0
				ORDER BY DATE_FORMAT(`transactiondate`,'%d-%b-%Y') , receiptno;
			END IF;
		END;
	END IF;
		
    END $$

DROP PROCEDURE IF EXISTS `spgetpossalespayments` $$
CREATE PROCEDURE `spgetpossalespayments`(`$receiptno` VARCHAR(50))
BEGIN
	SELECT `description` AS paymentmethod, 
	CASE WHEN p.`reference`='' THEN '-' ELSE p.`reference` END AS reference,`amount` 
	FROM `possalespayments` p, `paymentmethods` m, `possales` ps
	WHERE ps.`id`=p.`possaleid` AND p.`paymentmode`=m.`id` AND `receiptno`=$receiptno;
    END $$

DROP PROCEDURE IF EXISTS `spgetposstockbalanceasatdate` $$
CREATE PROCEDURE `spgetposstockbalanceasatdate`(`$asatdate` DATETIME, `$posid` INT)
BEGIN	
	
	SET @startdate= (SELECT DATE_SUB($asatdate, INTERVAL 1 DAY));
	SET @basedate=DATE(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters`),NOW())); 
	-- This is the cut off date 
	SELECT `itemcode`,`itemname`,`buyingprice`,`sellingprice`, 
	
	-- Compute opening Balance
	/*-- Transfers In $IFNULL((SELECT SUM(`quantity`) FROM `stocktransfer` s, `stocktransferdetails` sd WHERE s.`id`=sd.`transferid` AND `destinationtype`='pos' AND `destinationid`=$posid AND 
	DATE(`dateadded`) between @basedate and @startdate AND sd.`itemcode`=p.`productid`),0) -
	-- Less Transfers Out $IFNULL((SELECT SUM(`quantity`) FROM `stocktransfer` s, `stocktransferdetails` sd WHERE s.`id`=sd.`transferid` AND `sourcetype`='pos' AND `sourceid`=$posid AND 
	DATE(`dateadded`) between @basedate AND @startdate AND sd.`itemcode`=p.`productid`),0) -
	-- Less Sales 
	IFNULL((SELECT SUM(quantity) FROM `possales` s,`possalesdetails` sd WHERE s.`id`=sd.`possaleid` AND
	DATE(`receiptdate`) between @basedate AND @startdate
	AND s.`pointofsaleid`=$posid AND s.deleted=0 AND sd.`itemcode`=p.`productid` and ifnull(`deleted`,0)=0),0) +
	-- Add Reconciled balance 
	ifnull((select sum(quantity) from `stockreconciledbalance` sb join `stockreconciledbalancedetails` sd on sd.`reconciliationid`=sb.`id`
	and `itemid`=p.productid and date(`reconciliationdate`)<=$asatdate and `category`='outlet' and `posid`=$posid),0)
	AS `openingbalance`,*/
	`fn_getitemstorebalanceasat`(productid,$posid,@startdate) openingbalance,
	
	-- Compute Day's Transfers and Sales
	IFNULL((SELECT SUM(`quantity`) FROM `stocktransfer` s, `stocktransferdetails` sd WHERE s.`id`=sd.`transferid` AND `destinationtype`='pos' AND `destinationid`=$posid AND 
	DATE(`dateadded`)>=@basedate AND DATE(`dateadded`)=$asatdate AND sd.`itemcode`=p.`productid`),0) AS transfersin,
	IFNULL((SELECT SUM(`quantity`) FROM `stocktransfer` s, `stocktransferdetails` sd WHERE s.`id`=sd.`transferid` AND `sourcetype`='pos' AND `sourceid`=$posid AND 
	DATE(`dateadded`)>=@basedate AND DATE(`dateadded`)=$asatdate AND sd.`itemcode`=p.`productid`),0) AS transfersout,
	
	-- Compute Days Sales
	IFNULL((SELECT SUM(quantity) FROM `possales` s,`possalesdetails` sd WHERE s.`id`=sd.`possaleid` AND 
	DATE(`receiptdate`)>=@basedate AND DATE(`receiptdate`)=$asatdate
	AND s.`pointofsaleid`=$posid AND s.deleted=0 AND sd.`itemcode`=p.`productid` AND IFNULL(`deleted`,0)=0),0) AS sales
	
	FROM `categories` c, `products` p
	WHERE p.`categoryid`=c.`categoryid` 
	
	ORDER BY itemname, p.itemcode;
    END $$

DROP PROCEDURE IF EXISTS `spgetproductbycategory` $$
CREATE PROCEDURE `spgetproductbycategory`(IN $clientid INT, IN $categoryid INT)
BEGIN
    SELECT * FROM `products` WHERE clientid = $clientid AND `categoryid` = $categoryid AND `deleted` = 0 ORDER BY `itemname`;
END $$

DROP PROCEDURE IF EXISTS `spgetproductdetails` $$
CREATE PROCEDURE `spgetproductdetails`(IN $clientid INT, IN $productcode VARCHAR(50), IN $customerid INT, IN $storeid INT)
BEGIN
    SELECT * FROM `products` WHERE clientid = $clientid AND (`itemcode` = $productcode OR `itemname` = $productcode) AND `deleted` = 0;
END $$

DROP PROCEDURE IF EXISTS `spgetproductdiscountmatrix` $$
CREATE PROCEDURE `spgetproductdiscountmatrix`(`$itemcode` VARCHAR(50))
BEGIN
	SELECT c.`id` AS customercategoryid, `description` AS customercategory, `percentage`,`value` 
	FROM `customerpricematrix` m,`customercategories` c, `products` p
	WHERE c.`id`=m.`customercategoryid` AND p.`productid`=m.`itemid` AND p.`itemcode`=$itemcode;
    END $$

DROP PROCEDURE IF EXISTS `spgetprofitabilityreport` $$
CREATE PROCEDURE `spgetprofitabilityreport`(`$startdate` VARCHAR(50), `$enddate` VARCHAR(50), `$posid` INT)
BEGIN
	IF $posid=0 THEN 
		SELECT m.`itemcode`,`itemname`, FORMAT(`buyingprice`,2) AS `Buying Price`, FORMAT(AVG(`unitprice`),2) AS sellingprice, FORMAT(SUM(`quantity`),2) AS unitssold, 
		FORMAT(SUM(`buyingprice`*`quantity`),2) AS  `Total Purchases`, FORMAT(SUM((`unitprice`-IFNULL(discount,0))* `quantity`),2) AS  `Total Sales`,
		FORMAT((SUM((`unitprice`-IFNULL(discount,0))*`quantity`))- (`buyingprice`*SUM(`quantity`)),2) AS Margin
		FROM `products` m, `possales` p, `possalesdetails` pd
		WHERE m.`productid`=pd.`itemcode` AND pd.`possaleid`=p.`id` AND DATE_FORMAT(p.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
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
		;
	ELSE
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
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetprofitandlossaccount` $$
CREATE PROCEDURE `spgetprofitandlossaccount`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SET @startdate=$startdate,@enddate=$enddate;
	SELECT `accountcode`,`accountname`,classname,
	ABS(SUM(`debit`-`credit`)) AS `total`
	FROM `glaccounts` g, `gltransactions` t, `glaccountgroups` p, `glaccountclasses` c
	WHERE g.`id`=t.`glaccount` AND p.`id`=g.`groupid` AND p.`glaccountclass`=c.`id` 
	AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	AND classname IN('Income','Expense')
	GROUP BY `accountcode`,`accountname` 
	ORDER BY classname DESC,`accountcode`;
    END $$

DROP PROCEDURE IF EXISTS `spgetprofitandlossaccountdetails` $$
CREATE PROCEDURE `spgetprofitandlossaccountdetails`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
    
	SET @startdate=DATE_FORMAT($startdate,'%Y-%m-%d');
	SET @enddate=DATE_FORMAT($enddate,'%Y-%m-%d');
	SELECT `classname`,`accountcode`,`accountname`,SUM(IFNULL(debit,0)-IFNULL(credit,0)) AS amount
	FROM `glaccounts` g,`gltransactions` t, `glaccountgroups` r,`glaccountclasses` c
	WHERE g.`groupid`=r.`id` AND r.`glaccountclass`=c.`id` AND c.classname IN('Expense','Income')
	AND g.`accountcode` NOT IN(SELECT account FROM `glaccountsettings`) 
	AND t.`glaccount`=g.`id`
	AND DATE_FORMAT(transactiondate,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	GROUP BY  `classname`,`accountcode`,`accountname`;
	
    END $$

DROP PROCEDURE IF EXISTS `spgetprofitandlossaccountheader` $$
CREATE PROCEDURE `spgetprofitandlossaccountheader`(IN `$startdate` DATETIME, IN `$enddate` DATETIME)
BEGIN
    -- Trim date inputs to ensure no time portion
    SET @startdate = DATE($startdate);
    SET @enddate = DATE($enddate);

    -- Get Sales and COGS account IDs using JOINs
    SELECT g.id INTO @salesaccount
    FROM glaccounts g
    JOIN glaccountsettings s ON g.accountcode = s.account
    WHERE s.description = 'Sales'
    LIMIT 1;

    SELECT g.id INTO @stockaccount
    FROM glaccounts g
    JOIN glaccountsettings s ON g.accountcode = s.account
    WHERE s.description = 'Cost of Goods Sold'
    LIMIT 1;

    -- Cutoff date for stock
    SELECT DATE(cutoffdate) INTO @cutoffdate FROM startingparameters;

    -- Sales amount
    SELECT SUM(pd.quantity * pd.unitprice) INTO @salesamount
    FROM possales p
    JOIN possalesdetails pd ON p.id = pd.possaleid
    WHERE p.receiptdate BETWEEN @startdate AND @enddate
      AND IFNULL(p.deleted, 0) = 0;

    -- Purchases
    SELECT SUM(gd.quantity * pd.unitprice) INTO @purchases
    FROM goodsreceived g
    JOIN goodsreceiveddetails gd ON g.grnno = gd.grnno
    JOIN purchaseorders po ON gd.purchaseorderno = po.purchaseorderno
    JOIN purchaseorderdetails pd ON po.id = pd.purchaseorderid AND gd.itemcode = pd.itemcode
    WHERE g.datereceived BETWEEN @startdate AND @enddate;

    -- Get last reconciliation before start date
    SELECT id, DATE(reconciliationdate) INTO @reconciliationid, @reconciliationdate
    FROM stockreconciledbalance
    WHERE reconciliationdate < @startdate
    ORDER BY reconciliationdate DESC
    LIMIT 1;

    -- Tentative start = one day before range
    SET @tentativestartdate = DATE_SUB(@startdate, INTERVAL 1 DAY);

    -- Opening stock from last reconciliation
    SELECT SUM(sb.quantity * sb.unitprice) INTO @openingstock
    FROM stockreconciledbalancedetails sb
    JOIN stockreconciledbalance s ON sb.reconciliationid = s.id
    WHERE s.id = @reconciliationid;

    -- Purchases since reconciliation
    SELECT SUM(gd.quantity * p.buyingprice) INTO @purchasessincelastreconciliation
    FROM goodsreceiveddetails gd
    JOIN products p ON gd.itemcode = p.productid
    WHERE gd.grnno IN (
        SELECT grnno FROM goodsreceived
        WHERE datereceived BETWEEN @reconciliationdate AND @tentativestartdate
    );

    -- Sales since reconciliation
    SELECT SUM(pd.quantity * r.buyingprice) INTO @salessincelastreconciliation
    FROM possales p
    JOIN possalesdetails pd ON p.id = pd.possaleid
    JOIN products r ON pd.itemcode = r.productid
    WHERE p.receiptdate BETWEEN @reconciliationdate AND @tentativestartdate
      AND IFNULL(p.deleted, 0) = 0;

    -- Adjust opening stock
    SET @openingstock = IFNULL(@openingstock, 0) 
                        + IFNULL(@purchasessincelastreconciliation, 0) 
                        - IFNULL(@salessincelastreconciliation, 0);

    -- Purchases since start
    SELECT SUM(gd.quantity * p.buyingprice) INTO @purchasessincestartdate
    FROM goodsreceiveddetails gd
    JOIN products p ON gd.itemcode = p.productid
    WHERE gd.grnno IN (
        SELECT grnno FROM goodsreceived
        WHERE datereceived BETWEEN @startdate AND @enddate
    );

    -- Sales since start
    SELECT SUM(pd.quantity * r.buyingprice) INTO @salessincestartdate
    FROM possales p
    JOIN possalesdetails pd ON p.id = pd.possaleid
    JOIN products r ON pd.itemcode = r.productid
    WHERE p.receiptdate BETWEEN @startdate AND @enddate
      AND IFNULL(p.deleted, 0) = 0;

    -- Compute closing stock
    SET @closingstock = IFNULL(@openingstock, 0) 
                        + IFNULL(@purchasessincestartdate, 0) 
                        - IFNULL(@salessincestartdate, 0);

    -- Final result
    SELECT  
        ROUND(IFNULL(@salesamount, 0), 2) AS sales, 
	ROUND(IFNULL(@openingstock, 0), 2) AS openingstock,
	ROUND(IFNULL(@purchases, 0), 2) AS purchases, 
	ROUND(IFNULL(@closingstock, 0), 2) AS closingstock;
END $$

DROP PROCEDURE IF EXISTS `spgetpropertydocumenttemplates` $$
CREATE PROCEDURE `spgetpropertydocumenttemplates`()
BEGIN
	SELECT * FROM `propertydocumenttemplates` ORDER BY `description`;
    END $$

DROP PROCEDURE IF EXISTS `spgetpurchaseorderdetails` $$
CREATE PROCEDURE `spgetpurchaseorderdetails`(`$id` NUMERIC)
BEGIN
    
	SELECT p.departmentid,p.`purchaseorderno`,p.`date`,p.`supplierid`,p.`expecteddate`,`fn_purchaseorderstatus`($id)`status`,
	p.`terms`, pd.`itemcode` AS itemid, pd.`quanity`,pd.`unitprice`, i.`itemcode`,`itemname`
	FROM `purchaseorders` p, `purchaseorderdetails` pd, `products` i
	WHERE p.`id`=pd.`purchaseorderid` AND pd.`itemcode`=i.`productid` AND p.id=$id;
	
    END $$

DROP PROCEDURE IF EXISTS `spgetpurchaseorders` $$
CREATE PROCEDURE `spgetpurchaseorders`(IN $branchid INT)
BEGIN
    SELECT p.*, s.suppliername, d.departmentname 
    FROM `purchaseorders` p
    JOIN `suppliers` s ON s.supplierid = p.supplierid
    LEFT JOIN `departments` d ON d.id = p.departmentid
    WHERE p.branchid = $branchid
    ORDER BY p.date DESC;
END $$

DROP PROCEDURE IF EXISTS `spgetquotationterms` $$
CREATE PROCEDURE `spgetquotationterms`()
BEGIN
	SELECT * FROM `quotationterms`
	ORDER BY `termname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetreceiptdetails` $$
CREATE PROCEDURE `spgetreceiptdetails`(IN $branchid INT, IN $receiptno VARCHAR(50))
BEGIN
    SELECT s.*, sd.*, p.itemname, c.customername, m.description as paymentmode, u.firstname as servedby, pos.description as posname
    FROM `possales` s
    JOIN `possalesdetails` sd ON s.id = sd.possaleid
    JOIN `products` p ON p.productid = sd.itemcode
    JOIN `customers` c ON c.customerid = s.customerid
    JOIN `paymentmethods` m ON m.id = (SELECT paymentmode FROM possalespayments WHERE possaleid = s.id LIMIT 1)
    JOIN `user` u ON u.userid = s.addedby
    JOIN `pointsofsale` pos ON pos.id = s.pointofsaleid
    WHERE s.branchid = $branchid AND s.receiptno = $receiptno;
END $$

DROP PROCEDURE IF EXISTS `spgetreceiptitems` $$
CREATE PROCEDURE `spgetreceiptitems`(`$receiptno` VARCHAR(50))
BEGIN
	SELECT DISTINCT sd.`itemcode` AS productid, p.`itemcode`,
	TRIM(CONCAT(`itemname` ,' ', CASE WHEN `description`!='' THEN `description` ELSE '' END)) itemname
	FROM `possalesdetails` sd,`products` p, `possales` s
	WHERE sd.itemcode=p.productid AND s.`id`=sd.`possaleid` AND s.`receiptno`=$receiptno AND IFNULL(s.deleted,0)=0
	ORDER BY `itemname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetreceiptitemsdetails` $$
CREATE PROCEDURE `spgetreceiptitemsdetails`(`$receiptno` VARCHAR(50), `$productid` INT)
BEGIN
	SELECT p.productid,p.`itemcode`, `itemname`,`quantity`,`unitprice`,`serialno`
	FROM `possales` s, `possalesdetails` sd, `products` p
	WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid 
	AND p.productid=$productid AND s.receiptno=$receiptno;
    END $$

DROP PROCEDURE IF EXISTS `spgetreceiptvatanalysis` $$
CREATE PROCEDURE `spgetreceiptvatanalysis`(`$receiptnumber` VARCHAR(50))
BEGIN
	SELECT `abbreviation`,pd.`taxrate`,SUM(quantity*unitprice) AS total,SUM(quantity*unitprice)*pd.`taxrate`/100 AS vat
	FROM `possalesdetails` pd, `possales` p, `taxtypes` t
	WHERE pd.`possaleid`=p.`id` AND pd.`taxtypeid`=t.`id` AND p.`receiptno`=$receiptnumber
	GROUP BY `abbreviation`,pd.`taxrate`
	ORDER BY pd.`taxrate`;
    END $$

DROP PROCEDURE IF EXISTS `spgetreturninwards` $$
CREATE PROCEDURE `spgetreturninwards`(`$startdate` DATE, `$enddate` DATE)
BEGIN
	SELECT r.id, DATE_FORMAT(r.`dateadded`,'%d-%b-%Y') dateadded, s.receiptno,p.itemcode,itemname,r.serialno,r.quantity,
	sd.unitprice,r.quantity*sd.unitprice total, refno, IFNULL(collected,0) collected
	FROM `possales` s, `possalesdetails` sd, `products` p, `returninwards` r
	WHERE s.`id`=sd.`possaleid` AND sd.`itemcode`=p.productid AND p.productid=r.`productid` AND r.`possaleid`=s.id
	AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	ORDER BY r.`dateadded`;
    END $$

DROP PROCEDURE IF EXISTS `spgetreturninwardsdetails` $$
CREATE PROCEDURE `spgetreturninwardsdetails`(`$refno` VARCHAR(50))
BEGIN
	SELECT itemcode, itemname, serialno,quantity,narration
	FROM `returninwards` ri, products p
	WHERE p.`productid`=ri.`productid` AND `refno`=$refno
	ORDER BY itemname;
    END $$

DROP PROCEDURE IF EXISTS `spgetreturninwardsheader` $$
CREATE PROCEDURE `spgetreturninwardsheader`(`$refno` VARCHAR(50))
BEGIN
	SELECT ri.id,c.customerid, customername, receiptno,DATE_FORMAT(ri.`dateadded`,'%d-%b-%Y') dateadded,refno, CONCAT(firstname,' ',lastname) username
	FROM returninwards ri, `possales` p, customers c, `user` u
	WHERE ri.`possaleid`=p.`id` AND p.`customerid`=c.`customerid` 
	AND ri.refno=$refno AND u.id=ri.addedby;
    END $$

DROP PROCEDURE IF EXISTS `spgetreturninwardssummary` $$
CREATE PROCEDURE `spgetreturninwardssummary`(`$asatdate` DATE)
BEGIN
	SELECT itemcode,itemname, SUM(quantity) quantity,serialno,narration,DATE_FORMAT(ro.dateadded,'%d-%b-%Y') dateadded,refno
	FROM `returninwards` ro, products p
	WHERE ro.productid=p.productid AND DATE_FORMAT(ro.`dateadded`,'%Y-%m%-%d') <=$asatdate 
	AND IFNULL(`collected`,0)=0
	GROUP BY itemcode,itemname,serialno,narration, refno
	ORDER BY itemname;
    END $$

DROP PROCEDURE IF EXISTS `spgetreturnoutwards` $$
CREATE PROCEDURE `spgetreturnoutwards`(`$startdate` DATE, `$enddate` DATE)
BEGIN
	SELECT r.id, DATE_FORMAT(r.`dateadded`,'%d-%b-%Y') dateadded, s.grnno,p.itemcode,itemname,r.serialno,r.quantity,
	od.unitprice  unitprice,r.quantity*od.`unitprice` total,r.refno, IFNULL(r.delivered,0) delivered
	FROM `goodsreceived` s, `goodsreceiveddetails` sd, `products` p, `returnoutwards` r,
	purchaseorders o, purchaseorderdetails od
	WHERE o.`id`=od.`purchaseorderid` AND sd.`purchaseorderno`=o.`purchaseorderno` AND od.`itemcode`=r.`productid`
	AND s.`grnno`=sd.`grnno` AND sd.`itemcode`=p.productid AND p.productid=r.`productid` AND r.`grnid`=s.id
	AND DATE_FORMAT(r.`dateadded`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	ORDER BY r.`dateadded`;
    END $$

DROP PROCEDURE IF EXISTS `spgetreturnoutwardsdetails` $$
CREATE PROCEDURE `spgetreturnoutwardsdetails`(`$refno` VARCHAR(50))
BEGIN
	SELECT itemcode, itemname, serialno,quantity,narration
	FROM `returnoutwards` ro, products p
	WHERE p.`productid`=ro.`productid` AND `refno`=$refno
	ORDER BY itemname;
    END $$

DROP PROCEDURE IF EXISTS `spgetreturnoutwardsheader` $$
CREATE PROCEDURE `spgetreturnoutwardsheader`(`$refno` VARCHAR(50))
BEGIN
	SELECT ro.id,g.supplierid, suppliername, invoiceno,DATE_FORMAT(ro.`dateadded`,'%d-%b-%Y') dateadded,refno, CONCAT(firstname,' ',lastname) username
	FROM returnoutwards ro, goodsreceived  g, suppliers s, USER u
	WHERE ro.`grnid`=g.`id` AND s.`supplierid`=g.`supplierid` 
	AND ro.refno=$refno AND u.id=ro.addedby;
    END $$

DROP PROCEDURE IF EXISTS `spgetreturnoutwardssummary` $$
CREATE PROCEDURE `spgetreturnoutwardssummary`(`$asatdate` DATE)
BEGIN
	SELECT itemcode,itemname, SUM(quantity) quantity,serialno,narration,DATE_FORMAT(ro.dateadded,'%d-%b-%Y') dateadded,refno
	FROM `returnoutwards` ro, products p
	WHERE ro.productid=p.productid AND DATE_FORMAT(ro.`dateadded`,'%Y-%m%-%d') <=$asatdate 
	AND `delivered`=0
	GROUP BY itemcode,itemname,serialno,narration, refno
	ORDER BY itemname;
    END $$

DROP PROCEDURE IF EXISTS `spgetroledetails` $$
CREATE PROCEDURE `spgetroledetails`(`$roleid` INT)
BEGIN
	SELECT * FROM `roles` WHERE `roleid`=$roleid;
    END $$

DROP PROCEDURE IF EXISTS `spgetroleprivileges` $$
CREATE PROCEDURE `spgetroleprivileges`(`$roleid` INT)
BEGIN
	SELECT * FROM `roleprivileges` WHERE `roleid`=$roleid;
    END $$

DROP PROCEDURE IF EXISTS `spgetroles` $$
CREATE PROCEDURE `spgetroles`(IN $clientid INT)
BEGIN
    SELECT * FROM `roles` WHERE clientid = $clientid AND `deleted` = 0 ORDER BY `rolename`;
END $$

DROP PROCEDURE IF EXISTS `spgetrolesforuserassignment` $$
CREATE PROCEDURE `spgetrolesforuserassignment`()
BEGIN
	SELECT `roleid`,`rolename` FROM `roles` ORDER BY `rolename`;
    END $$

DROP PROCEDURE IF EXISTS `spgetroleusers` $$
CREATE PROCEDURE `spgetroleusers`(`$roleid` INT)
BEGIN
	SELECT r.`userid`, `username`,`firstname`,`middlename`,`lastname` FROM `roleusers` r, `user` u
	WHERE r.`userid`=u.`id` AND `roleid`=$roleid
	ORDER BY `firstname`,`middlename`,`lastname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetsalebycustomervalue` $$
CREATE PROCEDURE `spgetsalebycustomervalue`(`$startdate` DATETIME, `$enddate` DATETIME, `$daterange` VARCHAR(50))
BEGIN
	IF $daterange='Day' THEN
		SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,
		IFNULL(SUM(IF(customername='WALKIN CUSTOMER',receipttotal,NULL)),0) AS walkin,
		IFNULL(SUM(IF(customername<>'WALKIN CUSTOMER',receipttotal,NULL)),0) AS regular
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
    END $$

DROP PROCEDURE IF EXISTS `spgetsalesbycustomercount` $$
CREATE PROCEDURE `spgetsalesbycustomercount`(`$startdate` DATETIME, `$enddate` DATETIME, `$daterange` VARCHAR(50))
BEGIN
	IF $daterange='Day' THEN
		SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`, 
		COUNT(IF(customername='WALKIN CUSTOMER',id,NULL)) AS `walkin`, 
		COUNT(IF(customername<>'WALKIN CUSTOMER',id,NULL)) AS `Regular` 
		FROM `vwsalessummary2` v
		WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
		GROUP BY DATE_FORMAT(transactiondate,'%H') 
		ORDER BY v.transactiondate;
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
    END $$

DROP PROCEDURE IF EXISTS `spgetsalesbyoutlet` $$
CREATE PROCEDURE `spgetsalesbyoutlet`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SELECT pointofsale,SUM(receipttotal) AS total 
	FROM `vwsalessummary2` 
	WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	GROUP BY pointofsale
	ORDER BY SUM(receipttotal) DESC;
    END $$

DROP PROCEDURE IF EXISTS `spgetsalesbypaymentmode` $$
CREATE PROCEDURE `spgetsalesbypaymentmode`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $userid INT)
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
END $$

DROP PROCEDURE IF EXISTS `spgetsalesbypaymentmode2` $$
CREATE PROCEDURE `spgetsalesbypaymentmode2`(`$startdate` DATETIME, `$enddate` DATETIME, `$userid` INT)
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
    END $$

DROP PROCEDURE IF EXISTS `spgetsalesbyquantity` $$
CREATE PROCEDURE `spgetsalesbyquantity`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50), IN $userid INT)
BEGIN
	IF $userid=0 THEN
		IF $daterange='Day' THEN
			SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%H') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Week' THEN
			SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%a')
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Month' THEN
			SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%d') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Year' THEN
			SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%b')
			ORDER BY v.transactiondate;
		END IF;
	ELSE
		IF $daterange='Day' THEN
			SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid
			GROUP BY DATE_FORMAT(transactiondate,'%H') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Week' THEN
			SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid
			GROUP BY DATE_FORMAT(transactiondate,'%a')
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Month' THEN
			SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid
			GROUP BY DATE_FORMAT(transactiondate,'%d') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Year' THEN
			SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,SUM(quantity) AS quantity
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid
			GROUP BY DATE_FORMAT(transactiondate,'%b')
			ORDER BY v.transactiondate;
		END IF;
	END IF;
END $$

DROP PROCEDURE IF EXISTS `spgetsalesbysalesperson` $$
CREATE PROCEDURE `spgetsalesbysalesperson`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SELECT userfullname,SUM(receipttotal) AS total 
	FROM `vwsalessummary2` 
	WHERE DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	GROUP BY userfullname
	ORDER BY SUM(receipttotal);
    END $$

DROP PROCEDURE IF EXISTS `spgetsalessettings` $$
CREATE PROCEDURE `spgetsalessettings`(IN $branchid INT)
BEGIN
    SELECT * FROM salessettings WHERE branchid = $branchid;
END $$

DROP PROCEDURE IF EXISTS `spgetsalessummarybycustomer` $$
CREATE PROCEDURE `spgetsalessummarybycustomer`(`$startdate` DATETIME, `$enddate` DATETIME, `$posname` VARCHAR(100), `$userid` INT)
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
			WHERE transactiondate BETWEEN $startdate AND $enddate
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
			WHERE transactiondate BETWEEN $startdate AND $enddate AND userid=$userid
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
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname
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
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname AND userid=$userid
			GROUP BY transactiondate, pointofsale, customername
			ORDER BY transactiondate DESC;
		END IF;
	END  IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetsalessummarybyuser` $$
CREATE PROCEDURE `spgetsalessummarybyuser`(`$startdate` DATETIME, `$enddate` DATETIME, `$posname` VARCHAR(100), `$userid` INT)
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
			WHERE transactiondate BETWEEN $startdate AND $enddate
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
			WHERE transactiondate BETWEEN $startdate AND $enddate AND userid=$userid
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
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname
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
			WHERE transactiondate BETWEEN $startdate AND $enddate AND pointofsale=$posname AND userid=$userid
			GROUP BY transactiondate, pointofsale, userfullname
			ORDER BY transactiondate DESC;
		END IF;
	END  IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetsalestrend` $$
CREATE PROCEDURE `spgetsalestrend`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME, IN $daterange VARCHAR(50), IN $userid INT)
BEGIN
	IF $userid=0 THEN 
		IF $daterange='Day' THEN
			SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%H') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Week' THEN
			SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%a')
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Month' THEN
			SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%d') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Year' THEN
			SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			GROUP BY DATE_FORMAT(transactiondate,'%b')
			ORDER BY v.transactiondate;
		END IF;
	ELSE
		IF $daterange='Day' THEN
			SELECT DATE_FORMAT(transactiondate,'%H') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid 
			GROUP BY DATE_FORMAT(transactiondate,'%H') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Week' THEN
			SELECT DATE_FORMAT(transactiondate,'%a') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid 
			GROUP BY DATE_FORMAT(transactiondate,'%a')
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Month' THEN
			SELECT DATE_FORMAT(transactiondate,'%d') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid 
			GROUP BY DATE_FORMAT(transactiondate,'%d') 
			ORDER BY v.transactiondate;
		ELSEIF $daterange='Year' THEN
			SELECT DATE_FORMAT(transactiondate,'%b') AS `transactiondate`,SUM(receipttotal) AS amount
			FROM `vwsalessummary2` v WHERE branchid = $branchid AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
			AND userid=$userid 
			GROUP BY DATE_FORMAT(transactiondate,'%b')
			ORDER BY v.transactiondate;
		END IF;
	END IF;
END $$

DROP PROCEDURE IF EXISTS `spgetsmsconfiguration` $$
CREATE PROCEDURE `spgetsmsconfiguration`()
BEGIN
	SELECT * FROM `smsconfiguration`;
    END $$

DROP PROCEDURE IF EXISTS `spgetstocksheet` $$
CREATE PROCEDURE `spgetstocksheet`(`$asat` DATE)
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

END $$

DROP PROCEDURE IF EXISTS `spgetstocktransferbalance` $$
CREATE PROCEDURE `spgetstocktransferbalance`(`$sourcetype` VARCHAR(50), `$sourceid` INT, `$itemcode` VARCHAR(50))
BEGIN
	IF $sourcetype='warehouse' THEN 
		-- select * from `vwwarehouseitembalances` where warehouseid=$sourceid and itemcode=$itemcode;
		SELECT 
		`p`.`itemcode` AS `itemcode`,
		`p`.`itemname` AS `itemname`,
		`p`.`productid` AS `productid`,
		`p`.`unitofmeasure` AS `unitofmeasure`,
		`p`.`buyingprice` AS `buyingprice`,
		`p`.`sellingprice` AS `sellingprice`,
		`p`.`serializable` AS `serializable`,
		`fn_getwarehousestockbalance`(productid,$sourceid,CURDATE()) unitsreceived, 0 AS issued

		FROM products p WHERE itemcode=$itemcode;
	ELSE
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
		  IFNULL((SELECT SUM(`quantity`)
		  FROM `stockreconciledbalancedetails` rd
		  JOIN `stockreconciledbalance` r ON r.`id`=rd.`reconciliationid`
		  WHERE `itemid`=p.productid AND DATE(`reconciliationdate`) BETWEEN IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters`),'2001-01-01') AND CURRENT_TIMESTAMP()
		  AND posid=$sourceid),0)
		  AS `unitsreceived`,
		  
		  IFNULL(SUM(IF(`t`.`sourceid` = `s`.`id` AND `t`.`sourcetype` = 'pos' AND `td`.`itemcode` = `p`.`productid`,`td`.`quantity`,0)),0) +
		  -- Add sales
		  IFNULL((SELECT SUM(quantity) FROM `possales` ps 
			JOIN `possalesdetails` pd ON  pd.`possaleid`=ps.`id`
			WHERE  pd.itemcode=p.productid AND `receiptdate`>=IFNULL((SELECT `startingparameters`.`cutoffdate` FROM `startingparameters`),CURRENT_TIMESTAMP())
			AND ps.`deleted`=0
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
		    AND s.id=$sourceid AND p.itemcode=$itemcode;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetstocktransferdetails` $$
CREATE PROCEDURE `spgetstocktransferdetails`(`$referenceno` VARCHAR(50))
BEGIN
	DECLARE $id INT;
	SET $id=(SELECT id FROM `stocktransfer` WHERE `referenceno`=$referenceno);
	SELECT p.`itemcode`,`itemname`,SUM(`quantity`)quantity,`unitprice`, `serialno` 
	FROM `stocktransferdetails` t,`products` p
	WHERE t.`itemcode`=p.`productid` AND `transferid`=$id
	GROUP BY  p.`itemcode`,`itemname`,`unitprice`, `serialno` 
	ORDER BY `itemname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetstocktransferheader` $$
CREATE PROCEDURE `spgetstocktransferheader`(`$referenceno` VARCHAR(50))
BEGIN
	SELECT * FROM `vwstocktransfers` 
	WHERE referenceno=$referenceno;
    END $$

DROP PROCEDURE IF EXISTS `spgetsupplieraginganalysis` $$
CREATE PROCEDURE `spgetsupplieraginganalysis`(`$basedate` DATETIME, `$supplierid` INT)
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
	WHERE i.`id`=id.`invoiceid` AND s.`supplierid`=i.`supplierid`  AND s.`supplierid`=@supplierid
	AND DATE_FORMAT(i.invoicedate,'%Y-%m-%d') BETWEEN @cutoffdate AND @basedate
	GROUP BY i.id ,s.`supplierid`,suppliername,`invoiceno`,`status`,DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d'))
	ORDER BY `invoicedate` DESC, `invoiceno`) AS tab1
	GROUP BY suppliername;
    END $$

DROP PROCEDURE IF EXISTS `spgetsupplierdetails` $$
CREATE PROCEDURE `spgetsupplierdetails`(`$supplierid` NUMERIC)
BEGIN
	SELECT * FROM `suppliers` WHERE `supplierid`=$supplierid;
    END $$

DROP PROCEDURE IF EXISTS `spgetsupplierinvoices` $$
CREATE PROCEDURE `spgetsupplierinvoices`(`$supplierid` INT, `$invoicestatus` VARCHAR(50), `$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	SET @accountdescription='Suppliers Control Account';
	SET @accountcode=(SELECT `account` FROM `glaccountsettings` WHERE `description`=@accountdescription);
	
	SET @accountid=(SELECT `id` FROM `glaccounts` WHERE `accountcode`=@accountcode);
	SET @accountname=(SELECT `accountname` FROM `glaccounts` WHERE `accountcode`=@accountcode);
	
	IF $supplierid=0 THEN
		BEGIN
			IF $invoicestatus='<All>' THEN
				SELECT @accountid AS accountcharged,@accountname AS accountname, i.id AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,DATE_FORMAT(`invoicedate`,'%d-%b-%Y') invoicedate,SUM(`quantity`*`unitprice`) AS invoiceamount,`status`,
				IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
				WHERE v.`id`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno`),0) AS amountpaid
				FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
				WHERE i.`id`=id.`invoiceid` AND s.`supplierid`=i.`supplierid` AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
				AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
				GROUP BY i.id ,s.`supplierid`,suppliername,`invoiceno`,`status`, DATE_FORMAT(`invoicedate`,'%d-%b-%Y')
				ORDER BY DATE_FORMAT(`invoicedate`,'%d-%b-%Y') ;
			ELSE
				SELECT  @accountid AS accountcharged,@accountname AS accountname,i.id AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,DATE_FORMAT(`invoicedate`,'%d-%b-%Y') invoicedate,SUM(`quantity`*`unitprice`) AS invoiceamount,`status`,
				IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
				WHERE v.`id`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno`),0) AS amountpaid
				FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
				WHERE i.`id`=id.`invoiceid` AND s.`supplierid`=i.`supplierid` AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
				AND `status`=$invoicestatus AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
				GROUP BY i.id ,s.`supplierid`,suppliername,`invoiceno`,`status`, DATE_FORMAT(`invoicedate`,'%d-%b-%Y')
				ORDER BY DATE_FORMAT(`invoicedate`,'%d-%b-%Y') ;
			END IF;
		END;
	ELSE
		BEGIN
			IF $invoicestatus='<All>' THEN
				SELECT  @accountid AS accountcharged,@accountname AS accountname,i.id AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,DATE_FORMAT(`invoicedate`,'%d-%b-%Y') invoicedate,SUM(`quantity`*`unitprice`) AS invoiceamount,`status`,
				IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
				WHERE v.`id`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno`),0) AS amountpaid
				FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
				WHERE i.`id`=id.`invoiceid` AND s.`supplierid`=i.`supplierid` AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
				AND s.supplierid=$supplierid AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
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
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetsupplierpendingorders` $$
CREATE PROCEDURE `spgetsupplierpendingorders`(`$supplierid` VARCHAR(50))
BEGIN
	SET @cutoffdate=IFNULL((SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`),'01-Jan-2001');
	SELECT DISTINCT `purchaseorderno` FROM `purchaseorders` p,`purchaseorderdetails` pd  
	WHERE p.`id`=pd.`purchaseorderid` AND `supplierid`=$supplierid -- and p.`status`='Pending' 
	AND DATE_FORMAT(`date`,'%Y-%m-%d')>=@cutoffdate
	GROUP BY pd.`itemcode`, `purchaseorderno`
	HAVING SUM(`quanity`)>IFNULL((SELECT SUM(`quantity`) FROM `goodsreceived` g, `goodsreceiveddetails` gd
	WHERE g.`grnno`=gd.`grnno` AND gd.`itemcode`=pd.`itemcode` AND gd.purchaseorderno=p.purchaseorderno),0)
	
	ORDER BY `purchaseorderno`;
    END $$

DROP PROCEDURE IF EXISTS `spgetsupplierproducts` $$
CREATE PROCEDURE `spgetsupplierproducts`(`$supplierid` INT)
BEGIN
	SELECT s.`id` , s.`productid`,`itemcode`,`itemname`,s.`dateadded`, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) AS addedbyuser
	FROM `products` p, `supplierproducts` s, `user` u
	WHERE p.`productid`=s.`productid` AND  p.addedby=u.`id` AND s.`supplierid`=$supplierid AND s.`deleted`=0
	ORDER BY `itemname`;
    END $$

DROP PROCEDURE IF EXISTS `spgetsuppliers` $$
CREATE PROCEDURE `spgetsuppliers`(IN $clientid INT)
BEGIN
    SELECT * FROM `suppliers` WHERE clientid = $clientid AND `deleted` = 0 ORDER BY `suppliername`;
END $$

DROP PROCEDURE IF EXISTS `spgetsupplierstatement` $$
CREATE PROCEDURE `spgetsupplierstatement`(`$supplierid` INT, `$startdate` DATETIME, `$enddate` DATETIME)
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
	
    END $$

DROP PROCEDURE IF EXISTS `spgetsystemmodules` $$
CREATE PROCEDURE `spgetsystemmodules`(IN $clientid INT)
BEGIN
    SELECT DISTINCT `module` FROM `objects` 
    WHERE clientid = $clientid AND `module` IS NOT NULL 
    ORDER BY `module`;
END $$

DROP PROCEDURE IF EXISTS `spgettaxtypes` $$
CREATE PROCEDURE `spgettaxtypes`(IN $clientid INT)
BEGIN
    SELECT * FROM `taxtypes` WHERE clientid = $clientid;
END $$

DROP PROCEDURE IF EXISTS `spgettodaysdate` $$
CREATE PROCEDURE `spgettodaysdate`(IN $branchid INT)
BEGIN
    SELECT DATE_FORMAT(NOW(),'%Y-%m-%d') AS today;
END $$

DROP PROCEDURE IF EXISTS `spgettrialbalance` $$
CREATE PROCEDURE `spgettrialbalance`(`$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SET @startdate=$startdate,@enddate=$enddate;
	SELECT IFNULL(CONCAT(accountcode,' - ',accountname),'TOTAL') accountname, 
		SUM(IF(`total`>0,`total`,0)) AS debit,
		SUM(IF(`total`<0,ABS(`total`),0)) AS credit FROM
	(SELECT `accountcode`,`accountname`,
	SUM(`debit`-`credit`) AS `total`
	FROM `glaccounts` g, `gltransactions` t
	WHERE g.`id`=t.`glaccount`  AND DATE_FORMAT(`transactiondate`,'%Y-%m-%d') BETWEEN @startdate AND @enddate
	GROUP BY `accountcode`,`accountname` ORDER BY `accountcode` ) tab1
	GROUP BY accountname
	WITH ROLLUP;
    END $$

DROP PROCEDURE IF EXISTS `spgetuninvoicedgrns` $$
CREATE PROCEDURE `spgetuninvoicedgrns`(`$supplierid` INT, `$startdate` DATETIME, `$enddate` DATETIME)
BEGIN
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	IF $supplierid=0 THEN 
		SELECT g.`id`, g.`grnno`,`deliverynono`, DATE_FORMAT(`datereceived`,'%d-%b-%Y') `datereceived`,SUM(gd.`quantity`*pd.unitprice) AS `ordertotal`
		FROM `goodsreceived` g, `goodsreceiveddetails` gd, `purchaseorders` p, `purchaseorderdetails` pd
		WHERE g.`grnno`=gd.`grnno` AND gd.`purchaseorderno`=p.`purchaseorderno` AND p.`id`=pd.`purchaseorderid`  AND gd.itemcode=pd.itemcode AND IFNULL(invoiced,0)=0
		AND g.`deliverynono` NOT LIKE 'Opening Balance%' AND DATE_FORMAT(`datereceived`,'%Y-%m-%d') BETWEEN $startdate AND $enddate 
		AND  DATE_FORMAT(`datereceived`,'%Y-%m-%d')>=@cutoffdate
		GROUP BY  `id`, `grnno`,`deliverynono`,DATE_FORMAT(`datereceived`,'%d-%b-%Y')
		ORDER BY DATE_FORMAT(`datereceived`,'%d-%b-%Y'),  g.`grnno`;
	ELSE
		SELECT g.`id`, g.`grnno`,`deliverynono` ,DATE_FORMAT(`datereceived`,'%d-%b-%Y') `datereceived`,SUM(gd.`quantity`*pd.unitprice) AS `ordertotal`
		FROM `goodsreceived` g, `goodsreceiveddetails` gd, `purchaseorders` p, `purchaseorderdetails` pd
		WHERE g.`grnno`=gd.`grnno` AND gd.`purchaseorderno`=p.`purchaseorderno` AND p.`id`=pd.`purchaseorderid`  AND gd.itemcode=pd.itemcode AND IFNULL(invoiced,0)=0
		AND g.`deliverynono` NOT LIKE 'Opening Balance%' AND DATE_FORMAT(`datereceived`,'%Y-%m-%d') BETWEEN $startdate AND $enddate AND g.`supplierid`=$supplierid  
		AND DATE_FORMAT(`datereceived`,'%Y-%m-%d')>=@cutoffdate		
		GROUP BY  `id`, `grnno`,`deliverynono`,DATE_FORMAT(`datereceived`,'%d-%b-%Y')
		ORDER BY DATE_FORMAT(`datereceived`,'%d-%b-%Y'),  g.`grnno`;	
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spgetuserbyid` $$
CREATE PROCEDURE `spgetuserbyid`(`$clientid` INT)
BEGIN
	SELECT * FROM `user` WHERE `id`=$clientid;
    END $$

DROP PROCEDURE IF EXISTS `spgetuserdetails` $$
CREATE PROCEDURE `spgetuserdetails`(IN $username VARCHAR(50))
BEGIN
    SELECT * FROM user WHERE username = $username;
END $$

DROP PROCEDURE IF EXISTS `spgetusernamefromuserid` $$
CREATE PROCEDURE `spgetusernamefromuserid`(`$clientid` INT)
BEGIN
	SELECT * FROM `user` WHERE `id`=$clientid;
    END $$

DROP PROCEDURE IF EXISTS `spgetuseroutlets` $$
CREATE PROCEDURE `spgetuseroutlets`(`$clientid` INT)
BEGIN
	SELECT o.*,`posname`
	FROM `useroutlets` o, `pointsofsale` s  
	WHERE o.`userid`=$clientid AND s.`id`=o.outletid AND IFNULL(o.deleted,0)=0
	ORDER BY posname;
    END $$

DROP PROCEDURE IF EXISTS `spgetuserprivileges` $$
CREATE PROCEDURE `spgetuserprivileges`(`$userid` INT)
BEGIN
	SELECT * FROM `userprivileges` WHERE userid=$userid;
    END $$

DROP PROCEDURE IF EXISTS `spgetuserroles` $$
CREATE PROCEDURE `spgetuserroles`(`$clientid` INT)
BEGIN
	SELECT r.* FROM `roles` r, `roleusers` u
	WHERE r.`roleid`=u.`roleid` AND `userid`=$clientid
	AND IFNULL(u.`deleted`,0)=0
	ORDER BY `rolename`;
    END $$

DROP PROCEDURE IF EXISTS `spgetvoucheritems` $$
CREATE PROCEDURE `spgetvoucheritems`(`$id` VARCHAR(50))
BEGIN
	SELECT vd.*,`accountname` FROM `paymentvoucherdetails` vd, `paymentvouchers` v, `glaccounts` g 
	WHERE  v.id=vd.`voucherid` AND g.`id`=`accountcharged` AND v.`voucherno`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spgetwarehouses` $$
CREATE PROCEDURE `spgetwarehouses`(IN $clientid INT)
BEGIN
    SELECT * FROM `warehouses` WHERE clientid = $clientid ORDER BY `description`;
END $$

DROP PROCEDURE IF EXISTS `spgteunitsofmeasure` $$
CREATE PROCEDURE `spgteunitsofmeasure`(IN $clientid INT)
BEGIN
    SELECT * FROM `unitsofmeasure` WHERE clientid = $clientid ORDER BY `description`;
END $$

DROP PROCEDURE IF EXISTS `sppostbanking` $$
CREATE PROCEDURE `sppostbanking`(`$refno` VARCHAR(50), `$cashbookaccount` INT, `$narration` VARCHAR(50), `$reference` VARCHAR(50), `$postas` VARCHAR(50), `$userid` INT, `$receiptbanked` VARCHAR(50))
BEGIN
	DECLARE $salesaccount INT;
	DECLARE $transactiondate DATETIME;
	DECLARE $debtorscontrolaccount INT;
	SET $transactiondate=NOW();
	
	SET $salesaccount=(SELECT id FROM glaccounts WHERE accountcode =(SELECT`account` FROM `glaccountsettings` WHERE description='Sales'));
	SET $debtorscontrolaccount=(SELECT id FROM glaccounts WHERE accountcode =(SELECT`account` FROM `glaccountsettings` WHERE description='Debtors Control Account'));
	-- select $salesaccount;
	START TRANSACTION;
		-- post to sales or debtors control account individual transactions
		IF $receiptbanked!='pos' THEN
			SET $salesaccount=$debtorscontrolaccount;
		END IF;
		
		INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		SELECT $reference, $transactiondate,$salesaccount, $cashbookaccount ,
			CONCAT('Banking of receipt # ',`receiptno`, ' of reference #',`reference`,' issued to ',`customername`,' (',$narration,')'),
		0,`amount`,$userid FROM `tempbanking` WHERE `refno`=$refno;
		
		-- post to the cashbbook account
		IF $postas='single' THEN		
			INSERT INTO `gltransactions` (`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
			SELECT $reference, $transactiondate,$cashbookaccount,$salesaccount, CONCAT('Banking of receipt # ',`receiptno`, ' of reference #',`reference`,' issued to ',`customername`,' (',$narration,')'),amount,0,$userid 
			FROM `tempbanking` WHERE `refno`=$refno; 
		ELSE
			INSERT INTO `gltransactions` (`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
			SELECT $reference, $transactiondate,$cashbookaccount,$salesaccount, $narration,SUM(amount),0,$userid 
			FROM `tempbanking` WHERE `refno`=$refno GROUP BY `refno`; 
		END IF;
		-- update all receipts
		IF $receiptbanked='pos' THEN 
			UPDATE `possalespayments` p, `tempbanking` b  
			SET p.`banked`=1,p.`bankingreference`=$reference 
			WHERE b.`id`=p.id;
		ELSE
			UPDATE `customerreceipts` p, `tempbanking` b 
			SET `banked`=1,`bankingrefno`=$reference
			WHERE b.`id`=p.id;
		END IF;
		-- remove temp data 
		DELETE FROM  `tempbanking` WHERE `refno`=$refno;
	COMMIT;
	
    END $$

DROP PROCEDURE IF EXISTS `spsaceglgroupname` $$
CREATE PROCEDURE `spsaceglgroupname`(`$id` INT, `$glaccountclass` INT, `$groupname` VARCHAR(50), `$subcategoryof` INT, `$cashbookaccount` INT, `$clientid` INT)
BEGIN
	IF $id=0 THEN
		INSERT INTO `glaccountgroups`(`groupname`,`subactegoryof`,`dateadded`,`addedby`,`deleted`,`cashbookaccount`,`glaccountclass`)
		VALUES($groupname,$subcategoryof,NOW(),$clientid,0,$cashbookaccount,$glaccountclass);
	ELSE
		UPDATE `glaccountgroups` SET `groupname`=$groupname,`subactegoryof`=$subcategoryof,`cashbookaccount`=$cashbookaccouont,
		`glaccountclass`=$glaccountclass,`lastupdatedby`=$clientid, `lastdateupdated`=NOW()
		WHERE id=$id;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spsavecategory` $$
CREATE PROCEDURE `spsavecategory`(IN $clientid INT, IN $id INT, IN $name VARCHAR(50),
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
END $$

DROP PROCEDURE IF EXISTS `spsavecrateaddition` $$
CREATE PROCEDURE `spsavecrateaddition`(`$productid` INT, `$quantity` NUMERIC(18, $2), `$unitprice` NUMERIC(18,2), `$narration` VARCHAR(1000), `$reference` VARCHAR(50), `$userid` INT)
BEGIN
	INSERT INTO `cratesinventory`(`productid`,`quantity`,`unitprice`,`dateadded`,`narration`,`reference`,`addedby`)
	VALUES($productid,$quantity,$unitprice,NOW(),$narration,$reference,$userid);
    END $$

DROP PROCEDURE IF EXISTS `spsavecrateinventorysettings` $$
CREATE PROCEDURE `spsavecrateinventorysettings`(`$productid` INT, `$supplierid` INT, `$glaccountid` INT, `$costcenter` INT, `$paymentmode` INT, `$paymentaccount` INT)
BEGIN
	IF NOT EXISTS(SELECT * FROM `cratesinventorysettings`) THEN
		INSERT INTO `cratesinventorysettings`(`productid`,`supplierid`,`glaccountid`,`costcenterid`,`paymentmode`,`paymentaccount`)
		VALUES($productid,$supplierid,$glaccountid,$costcenter,$paymentmode,$paymentaccount);
	ELSE
		UPDATE `cratesinventorysettings` SET `productid`=$productid,`supplierid`=$supplierid, `glaccountid`=$glaccountid,
		`costcenterid`=$costcenter,`paymentmode`=$paymentmode,`paymentaccount`=$paymentaccount;
	END IF;
	
    END $$

DROP PROCEDURE IF EXISTS `spsavecreditnote` $$
CREATE PROCEDURE `spsavecreditnote`(`$refno` VARCHAR(50), `$customerid` NUMERIC, `$userid` NUMERIC)
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
    END $$

DROP PROCEDURE IF EXISTS `spsavecustomer` $$
CREATE PROCEDURE `spsavecustomer`(IN $clientid INT, IN $customerid INT, IN $customername VARCHAR(100),
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
        INSERT INTO `customers` (
            clientid, customername, tradingname, physicaladdress, postaladdress, mobile, email,
            creditlimit, creditterm, dateadded, addedby, deleted, categoryid, pointofsaleid,
            onetimecustomer, pinno, idno, subzoneid
        ) VALUES (
            clientid, $customername, $tradingname, $physicaladdress, $postaladdress, $mobile, $email,
            $creditlimit, $creditterm, NOW(), $userid, 0, $category, $posid,
            $onetimecustomer, $pinno, $idno, $subzoneid
        );
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
END $$

DROP PROCEDURE IF EXISTS `spsavecustomerdiscountsettings` $$
CREATE PROCEDURE `spsavecustomerdiscountsettings`(`$id` NUMERIC, `$customerid` NUMERIC, `$productid` NUMERIC, `$discount` NUMERIC, `$percentage` BIT, `$userid` NUMERIC, `$expirydate` DATETIME)
BEGIN
	IF $id=0 THEN
		INSERT INTO `customerdiscountsettings`(`customerid`,`productid`,`discount`,`percentage`,`dateadded`,`addedby`,`deleted`,`expirydate`)
		VALUES($customerid,$productid,$discount,$percentage,NOW(),$userid,0,$expirydate);
	ELSE	
		UPDATE `customerdiscountsettings` SET `customerid`=$customerid,`productid`=$productid,`discount`=$discount,`percentage`=$percentage,
		`lastmodifiedby`=$userid,`lastmodifiedon`=NOW(), `expirydate`=$expirydate
		WHERE `id`=$id;
	
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spsavecustomerreceipt` $$
CREATE PROCEDURE `spsavecustomerreceipt`(`$refno` VARCHAR(50), `$customerid` INT, `$modeofpayment` INT, `$referenceno` VARCHAR(50), `$userid` INT, `$overpay` NUMERIC)
BEGIN
	DECLARE $receiptno VARCHAR(50);
	DECLARE $receiptid NUMERIC;
	-- generate code
	SET $receiptno=`spgeneratecustomerreceiptno`();
	START TRANSACTION;
		-- save receipt
		INSERT INTO `customerreceipts`(`receiptno`,`receiptdate`,`addedby`,`modeofpayment`,`referenceno`,`deleted`, `customerid`)
		VALUES($receiptno,NOW(),$userid,$modeofpayment,$referenceno,0,$customerid);
		-- get the ID generated
		SET $receiptid=(SELECT MAX(`id`) FROM `customerreceipts`);
		-- save receipt details
		INSERT INTO `customerreceiptdetails` (`receiptid`,`possaleid`,`amount`)
		SELECT $receiptid, `possaleid`,`amount` FROM `tempcustomerreceiptdetails` WHERE `refno`=$refno;
		-- Add overpaid amount to suspense account if any
		IF $overpay>0 THEN 
			INSERT INTO `customersuspenseaccount`(`customerid`,`transactiondate`,`referenceno`,`credit`,`addedby`,`narration`)
			VALUES($customerid,NOW(),$receiptno,$overpay,$userid,'Customer amount overpaid');
		END IF;
		-- Increment receipt number 
		UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Customer Receipt';
		-- delete temp receipt details
		DELETE FROM `tempcustomerreceiptdetails` WHERE  `refno`=$refno;
		-- return receipt number
		SELECT  $receiptno  AS receiptno;
	COMMIT;
    END $$

DROP PROCEDURE IF EXISTS `spsaveemailconfiguration` $$
CREATE PROCEDURE `spsaveemailconfiguration`(`$emailaddress` VARCHAR(100), `$emailpassword` VARCHAR(50), `$smtpserver` VARCHAR(50), `$smtpport` INT, `$usessl` BOOLEAN)
BEGIN
	IF NOT EXISTS(SELECT * FROM `emailconfiguration`) THEN
		INSERT INTO `emailconfiguration`(`emailaddress`,`password`,`smtpserver`,`usessl`,`smtpport`)
		VALUES($emailaddress,$emailpassword,$smtpserver,$usessl,$smtpport);
	ELSE
		UPDATE `emailconfiguration` 
		SET `emailaddress`=$emailaddress,`password`=$emailpassword,`smtpserver`=$smtpserver,`usessl`=$usessl,`smtpport`=$smtpport;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spsaveglaccount` $$
CREATE PROCEDURE `spsaveglaccount`(`$id` INT, `$groupid` INT, `$accountcode` VARCHAR(50), `$accountname` VARCHAR(50), `$clientid` INT)
BEGIN
	IF $id=0 THEN 
		INSERT INTO `glaccounts`(`groupid`,`accountcode`,`accountname`,`dateadded`,`addedby`,`deleted`)
		VALUES($groupid,$accountcode,$accountname,NOW(),$clientid,0);
	ELSE
		UPDATE `glaccounts` SET `groupid`=$groupid, `accountcode`=$accountcode,`accountname`=$accountname, `lastdateupdated`=NOW(),`lastupdatedby`=$clientid
		WHERE `id`=$id;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spsaveglgroupname` $$
CREATE PROCEDURE `spsaveglgroupname`(`$id` INT, `$glaccountclass` INT, `$groupname` VARCHAR(50), `$subcategoryof` INT, `$cashbookaccount` INT, `$clientid` INT)
BEGIN
	IF $id=0 THEN
		INSERT INTO `glaccountgroups`(`groupname`,`subactegoryof`,`dateadded`,`addedby`,`deleted`,`cashbookaccount`,`glaccountclass`)
		VALUES($groupname,$subcategoryof,NOW(),$clientid,0,$cashbookaccount,$glaccountclass);
	ELSE
		UPDATE `glaccountgroups` SET `groupname`=$groupname,`subactegoryof`=$subcategoryof,`cashbookaccount`=$cashbookaccouont,
		`glaccountclass`=$glaccountclass,`lastupdatedby`=$clientid, `lastdateupdated`=NOW()
		WHERE id=$id;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spsavegltransaction` $$
CREATE PROCEDURE `spsavegltransaction`(`$refno` VARCHAR(50), `$transactiondate` DATETIME, `$referenceno` VARCHAR(50), `$userid` INT)
BEGIN
	INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
	SELECT $referenceno,$transactiondate, `glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,$userid FROM `tempgltransaction` WHERE `refno`=$refno;
	DELETE FROM `tempgltransaction` WHERE `refno`=$refno;
    END $$

DROP PROCEDURE IF EXISTS `spsavegoodsreceived` $$
CREATE PROCEDURE `spsavegoodsreceived`(IN $branchid INT, IN $refno VARCHAR(50),
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
        SELECT $branchid, DATE_FORMAT(NOW(),'%Y-%m-%d'), tg.`itemcode`, p.id, tg.`quantity`,
            CASE WHEN `taxinclusive` = 1 THEN (100 / (100 + p.taxrate)) * pd.unitprice ELSE pd.unitprice END,
            p.taxrate, p.taxid
        FROM `tempgoodsreceived` tg 
        JOIN `purchaseorders` p ON p.branchid = $branchid AND p.`purchaseorderno` = tg.`purchaseorderno`
        JOIN `purchaseorderdetails` pd ON pd.branchid = $branchid AND pd.`purchaseorderid` = p.`id`
        WHERE tg.branchid = $branchid AND tg.`refno` = $refno AND pd.itemcode = tg.itemcode;
        
        
        UPDATE `serials` SET `currentno` = `currentno` + 1 WHERE branchid = $branchid AND `documenttype` = 'Goods Received Note';
        
        
        DELETE FROM `tempgoodsreceived` WHERE branchid = $branchid AND `refno` = $refno;
        
        SELECT v_grnno AS grnno;
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS `spsaveheldsale` $$
CREATE PROCEDURE `spsaveheldsale`(`$refno` VARCHAR(50), `$customerid` INT, `$posid` INT, `$userid` INT)
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
    END $$

DROP PROCEDURE IF EXISTS `spsavejournaltransaction` $$
CREATE PROCEDURE `spsavejournaltransaction`(`$refno` VARCHAR(50), `$referenceno` VARCHAR(50), `$description` VARCHAR(100), `$userid` INT, `$addtoledger` BIT)
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
    END $$

DROP PROCEDURE IF EXISTS `spsavempesac2bparameters` $$
CREATE PROCEDURE `spsavempesac2bparameters`(`$url` VARCHAR(500), `$shortcode` VARCHAR(50), `$msisdn` VARCHAR(50))
BEGIN
	UPDATE `mpesaconfiguration` SET c2burl=$url,c2bshortcode=$shortcode,c2bmsisdn=$msisdn;
    END $$

DROP PROCEDURE IF EXISTS `spsavempesaconfiguration` $$
CREATE PROCEDURE `spsavempesaconfiguration`(`$consumerkey` VARCHAR(100), `$consumersecret` VARCHAR(100), `$validationurl` VARCHAR(500), `$confirmationurl` VARCHAR(500), `$paybillnumber` VARCHAR(10))
BEGIN
	IF NOT EXISTS(SELECT * FROM `mpesaconfiguration`) THEN
		INSERT INTO `mpesaconfiguration`(`consumerkey`,`consumersecret`,`validationurl`,`confirmationurl`,`paybillnumber`)
		VALUES($consumerkey,$consumersecret,$validationurl,$confirmationurl,$paybillnumber);
	ELSE
		UPDATE `mpesaconfiguration` SET `consumerkey`=$consumerkey,`consumersecret`=$consumersecret,`validationurl`=$validationurl,
		`confirmationurl`=$confirmationurl,`paybillnumber`=$paybillnumber;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spsavempesaconfirmation` $$
CREATE PROCEDURE `spsavempesaconfirmation`(`$reference` VARCHAR(50), `$transactiondate` DATETIME, `$amount` NUMERIC(18,2), `$sendermobile` VARCHAR(50), `$sendername` VARCHAR(50))
BEGIN
	INSERT INTO `mpesaconfirmation`(`date`,`reference`,`amount`,`sendermobile`,`sendername`)
	VALUES($transactiondate,$reference,$amount,$sendermobile,$sendername);
    END $$

DROP PROCEDURE IF EXISTS `spsavepaymentvoucher` $$
CREATE PROCEDURE `spsavepaymentvoucher`(`$refno` VARCHAR(50), `$id` INT, `$voucherdate` DATETIME, `$voucherno` VARCHAR(50), `$pos` INT, `$supplier` INT, `$paymentmode` INT, `$cashbookaccount` INT, `$reference` VARCHAR(50), `$generatevoucherno` INT, `$userid` INT, `$pettycash` BOOLEAN, `$craterefund` BOOLEAN)
BEGIN
	DECLARE $productid INT;	
	DECLARE $narration VARCHAR(1000);
	SET $pettycash = IFNULL($pettycash,0);
	SET $craterefund=IFNULL($craterefund,0);
	-- declare $id int;
	
	
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
				-- update invoice as used
				-- update `supplierinvoice` set `status`='Paid' where `supplierid`=$supplier and `invoiceno`=$invoicenumber;
				
				-- insert voucher details
				INSERT INTO `paymentvouchers`(`voucherno`,`date`,`addedby`,`paymentmode`,`pos`,`supplier`,`cashbookaccount`,`referenceno`,`status`,`dateadded`,`pettycashvoucher`)
				VALUES($voucherno,$voucherdate,$userid,$paymentmode,$pos,$supplier,$cashbookaccount,$reference,'Pending',NOW(),$pettycash);
			
				SET $id=(SELECT MAX(id) FROM `paymentvouchers`);
				
				-- insert voucher items
				INSERT INTO `paymentvoucherdetails`(`voucherid`,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber`)
				SELECT $id,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber` FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
				
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
				`cashbookaccount`=$cashbookaccount,`referenceno`=$reference,`lastmodifiedby`=$userid,`lastmodifieddate`=NOW()
				WHERE `id`=$id;
				-- add vouchers items
				INSERT INTO `paymentvoucherdetails`(`voucherid`,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber`)
				SELECT $id,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber` FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
				-- remove temporary data
				DELETE FROM `temppaymentvoucherdetails` WHERE `refno`=$refno;
			COMMIT;
		END;
	END IF;
	
    END $$

DROP PROCEDURE IF EXISTS `spsavepos` $$
CREATE PROCEDURE `spsavepos`(`$id` NUMERIC, `$posname` VARCHAR(50), `$postype` VARCHAR(50), `$printkitchenorders` BOOL, `$clientid` NUMERIC)
BEGIN
	IF $id=0 THEN 
		INSERT INTO `pointsofsale`(`posname`,`postype`,`printkitchenorders`,`dateadded`,`addedby`,`deleted`)
		VALUES($posname,$postype,$printkitchenorders,NOW(),$clientid,0);
		SELECT MAX(`id`) INTO $id  FROM `pointsofsale`;
	ELSE
		UPDATE `pointsofsale` 
		SET `posname`=$posname, `postype`=$postype,`printkitchenorders`=$printkitchenorders,
		`lastdatemodified`=NOW(), `lastmodifiedby`=$clientid
		WHERE id=$id;
	END IF;
	SELECT $id AS posid;
    END $$

DROP PROCEDURE IF EXISTS `spsavepossale` $$
CREATE PROCEDURE `spsavepossale`(IN $branchid INT, IN $refno VARCHAR(50),
    IN $customerid INT,
    IN $posid INT,
    IN $transactiondate DATETIME,
    IN $reference VARCHAR(50),
    IN $userid INT
)
BEGIN
    DECLARE v_receiptno VARCHAR(50);
    DECLARE v_id INT;
    DECLARE v_customername VARCHAR(100);
    DECLARE v_finished INT DEFAULT 0;
    DECLARE v_tempproductid INT;
    DECLARE v_tempquantity DECIMAL(18,2);
    DECLARE v_tempunitprice DECIMAL(18,2);
    DECLARE v_tempdiscount DECIMAL(18,2);
    DECLARE v_tempserialno VARCHAR(100);
    DECLARE v_temptaxid INT;
    DECLARE v_temptaxrate DECIMAL(18,2);
    DECLARE v_tempdescription VARCHAR(250);
    DECLARE v_stockmovementid INT;
    DECLARE v_purchasebalance DECIMAL(18,2);
    DECLARE v_fifoquantity DECIMAL(18,2);
    
    DECLARE cur_products CURSOR FOR 
        SELECT itemcode, quantity, unitprice, discount, serialno, 1 as taxid, 0 as taxrate, description 
        FROM tempsale WHERE branchid = $branchid AND refno = $refno;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;

    START TRANSACTION;
        
        SET v_receiptno = (SELECT spgeneratecustomerreceiptno($branchid));
        SET v_customername = (SELECT customername FROM customers WHERE branchid = $branchid AND customerid = $customerid);

        
        INSERT INTO possales (branchid, receiptno, customerid, pointofsaleid, receiptdate, reference, addedby, deleted)
        VALUES ($branchid, v_receiptno, $customerid, $posid, $transactiondate, $reference, $userid, 0);
        
        SET v_id = LAST_INSERT_ID();

        
        INSERT INTO possalesdetails (branchid, possaleid, itemcode, quantity, unitprice, discount, serialno, description)
        SELECT $branchid, v_id, itemcode, quantity, unitprice, discount, serialno, description
        FROM tempsale WHERE branchid = $branchid AND refno = $refno;

        
        INSERT INTO possalespayments (branchid, possaleid, paymentmode, reference, amount)
        SELECT $branchid, v_id, paymentmode, reference, amount
        FROM temppossalespayment WHERE branchid = $branchid AND refno = $refno;

        
        UPDATE serials SET currentno = currentno + 1 WHERE branchid = $branchid AND documenttype = 'Customer Receipt';

        
        OPEN cur_products;
        loop_products: LOOP
            FETCH cur_products INTO v_tempproductid, v_tempquantity, v_tempunitprice, v_tempdiscount, v_tempserialno, v_temptaxid, v_temptaxrate, v_tempdescription;
            IF v_finished = 1 THEN LEAVE loop_products; END IF;

            WHILE v_tempquantity > 0 DO
                SET v_stockmovementid = NULL;
                SET v_purchasebalance = 0;

                
                SELECT s.stockmovementid, (s.purchasequantity - IFNULL(SUM(sd.salesquantity), 0)) as available
                INTO v_stockmovementid, v_purchasebalance
                FROM stockmovement s
                LEFT JOIN stockmovementsalesdetails sd ON s.stockmovementid = sd.stockmovementid
                WHERE s.branchid = $branchid AND s.productid = v_tempproductid
                GROUP BY s.stockmovementid
                HAVING available > 0
                ORDER BY s.stockmovementid ASC LIMIT 1;

                IF v_stockmovementid IS NULL THEN
                    SET v_tempquantity = 0; 
                ELSE
                    IF v_purchasebalance > v_tempquantity THEN
                        SET v_fifoquantity = v_tempquantity;
                        SET v_tempquantity = 0;
                    ELSE
                        SET v_fifoquantity = v_purchasebalance;
                        SET v_tempquantity = v_tempquantity - v_purchasebalance;
                    END IF;

                    INSERT INTO stockmovementsalesdetails (branchid, stockmovementid, possaleid, salesquantity, sellingprice)
                    VALUES ($branchid, v_stockmovementid, v_id, v_fifoquantity, v_tempunitprice - v_tempdiscount);
                END IF;
            END WHILE;
        END LOOP loop_products;
        CLOSE cur_products;

        
        DELETE FROM tempsale WHERE branchid = $branchid AND refno = $refno;
        DELETE FROM temppossalespayment WHERE branchid = $branchid AND refno = $refno;

        
        SELECT v_receiptno AS receiptno;
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS `spsaveprivileges` $$
CREATE PROCEDURE `spsaveprivileges`(`$id` INT, `$category` VARCHAR(50), `$refno` VARCHAR(50), `$clientid` INT)
BEGIN
	START TRANSACTION;
		IF $category='user' THEN 
			BEGIN
				-- delete all privileges
				DELETE FROM `userprivileges` WHERE `userid`=$id;
				-- add the ones from the temp table
				INSERT INTO `userprivileges` (`userid`,`objectid`,`allowed`,`addedby`,`lastupdatedby`,`lastdateupdated`)
				SELECT $id,`objectid`,`valid`,$clientid,$clientid,NOW() FROM `tempprivilege` WHERE `refno`=$refno;
			END;
		ELSE
			BEGIN
				-- delete all role privileges
				DELETE FROM `roleprivileges` WHERE `roleid`=$id;
				-- add new ones from the temp table
				INSERT INTO `roleprivileges`(`roleid`,`objectid`,`allowed`,`dateadded`,`addedby`)
				SELECT $id,`objectid`,`valid`,NOW(),$clientid FROM `tempprivilege` WHERE `refno`=$refno; 
			END;
		END IF;
		-- Remove temporary data
		DELETE FROM `tempprivilege` WHERE `refno`=$refno;
	COMMIT;
    END $$

DROP PROCEDURE IF EXISTS `spsaveproduct` $$
CREATE PROCEDURE `spsaveproduct`(IN $clientid INT, IN $id NUMERIC, IN $itemcode VARCHAR(50),
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
    IN $allowreturnexchange BOOL
)
BEGIN
    IF $id=0 THEN 
        IF $generateitemcode=1 THEN
            SET $itemcode=(SELECT fngenerateproductcode(clientid, $categoryid));
            UPDATE `categories` SET `currentno`=`currentno`+1 WHERE clientid = $clientid AND `categoryid`=$categoryid;
        END IF;
        INSERT INTO `products`(
            clientid, `itemcode`, `itemname`, `unitofmeasure`, `buyingprice`, `sellingprice`, `categoryid`, `dateadded`, `addedby`, `deleted`, `reorderlevel`, `serializable`,
            `bundleitem`, `taxtypeid`, `length`, `width`, `height`, `allownegativesales`, `saleby`, `bundledproduct`, `allowreturnexchange`
        ) VALUES (
            clientid, $itemcode, $itemname, $uom, $buyingprice, $sellingprice, $categoryid, NOW(), $userid, 0, $reorderlevel, $canserialize,
            $bundleitem, $taxtypeid, $itemlength, $itemwidth, $itemheight, $allownegativesales, $saleby, $bundleproduct, $allowreturnexchange
        );
    ELSE
        UPDATE `products` SET 
            `itemcode`=$itemcode, `itemname`=$itemname, `unitofmeasure`=$uom, `buyingprice`=$buyingprice, `sellingprice`=$sellingprice,
            `categoryid`=$categoryid, `reorderlevel`=$reorderlevel, `lastmodifiedon`=NOW(), `lastmodifiedby`=$userid, `serializable`=$canserialize, 
            `bundleitem`=$bundleitem, `taxtypeid`=$taxtypeid, `length`=$itemlength, `width`=$itemwidth, `height`=$itemheight, `allownegativesales`=$allownegativesales,
            `saleby`=$saleby, `bundledproduct`=$bundleproduct, `allowreturnexchange`=$allowreturnexchange
        WHERE clientid = $clientid AND `productid`=$id;
    END IF;
END $$

DROP PROCEDURE IF EXISTS `spsavepurchaseorder` $$
CREATE PROCEDURE `spsavepurchaseorder`(IN $branchid INT, IN $id NUMERIC, IN $refno VARCHAR(50),
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
            WHERE branchid = $branchid AND `id` = $id;
            
            INSERT INTO `purchaseorderdetails`(branchid, `purchaseorderid`, `itemcode`, `quanity`, `unitprice`, `taxable`, `taxinclusive`)
            SELECT $branchid, $id, `itemcode`, `quantity`, `unitprice`, `taxable`, `taxinclusive` 
            FROM `temppurchaseorder` WHERE branchid = $branchid AND `refno` = $refno;
            
            DELETE FROM `temppurchaseorder` WHERE branchid = $branchid AND `refno` = $refno;
            
            SET v_purchaseorderno = (SELECT `purchaseorderno` FROM `purchaseorders` WHERE branchid = $branchid AND `id` = $id);
        COMMIT;
    END IF;
    
    SELECT v_purchaseorderno AS purchaseorderno;
END $$

DROP PROCEDURE IF EXISTS `spsavereturninwards` $$
CREATE PROCEDURE `spsavereturninwards`(`$refno` VARCHAR(50), `$receiptno` VARCHAR(50), `$userid` INT, `$narration` VARCHAR(1000))
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
    END $$

DROP PROCEDURE IF EXISTS `spsavereturninwardscollection` $$
CREATE PROCEDURE `spsavereturninwardscollection`(`$id` INT, `$collectedby` VARCHAR(50), `$userid` INT)
BEGIN
	UPDATE `returninwards` 
	SET `collected`=1,`collectedby`=$collectedby,`datecollected`=NOW(),`issuedby`=$userid
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spsavereturnoutwards` $$
CREATE PROCEDURE `spsavereturnoutwards`(`$refno` VARCHAR(50), `$grnno` VARCHAR(50), `$narration` VARCHAR(1000), `$userid` INT)
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
	
    END $$

DROP PROCEDURE IF EXISTS `spsavereturnoutwardsreturn` $$
CREATE PROCEDURE `spsavereturnoutwardsreturn`(`$id` INT, `$userid` INT)
BEGIN
	UPDATE `returnoutwards` 
	SET `delivered`=1,`datedelivered`=NOW(), `receivedby`=$userid
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `spsaverole` $$
CREATE PROCEDURE `spsaverole`(`$roleid` INT, `$rolename` VARCHAR(50), `$roledescription` VARCHAR(50), `$clientid` INT)
BEGIN
	IF $roleid=0 THEN
		INSERT INTO `roles` (`rolename`,`roledescription`,`deleted`,`addedby`,`dateadded`)
		VALUES($rolename,$roledescription,0,$clientid,NOW());
		SET $roleid=(SELECT MAX(`roleid`) `roleid` FROM `roles`);
	ELSE
		UPDATE `roles` SET `rolename`=$rolename,`roledescription`=$roledescription, `lastdatemodified`=NOW(), `lastmodifiedby`=$clientid
		WHERE `roleid`=$roleid;
	END IF;
	SELECT $roleid AS `roleid`;
    END $$

DROP PROCEDURE IF EXISTS `spsaveroleusers` $$
CREATE PROCEDURE `spsaveroleusers`(`$userid` INT, `$roleid` INT, `$addedby` INT)
BEGIN
	IF NOT EXISTS (SELECT * FROM `roleusers` WHERE `roleid`=$roleid AND `userid`=$userid AND IFNULL(`deleted`,0)=0) THEN
		INSERT INTO `roleusers`(`roleid`,`userid`,`dateadded`,`addedby`)
		VALUES($roleid,$userid,NOW(),$addedby);
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spsavesmslog` $$
CREATE PROCEDURE `spsavesmslog`(`$mobileno` VARCHAR(50), `$customerid` VARCHAR(50), `$message` VARCHAR(1000), `$messageid` VARCHAR(50), `$messagestatus` VARCHAR(50))
BEGIN
		INSERT INTO `smslog`(`mobileno`,`customerid`,`message`,`messageid`,`status`,`datesent`)
		VALUES($mobileno,$customerid,$message,$messageid,$messagestatus,NOW());
	END $$

DROP PROCEDURE IF EXISTS `spsavestockreconciledbalance` $$
CREATE PROCEDURE `spsavestockreconciledbalance`(IN `$refno` VARCHAR(50), IN `$narration` VARCHAR(50), IN `$posid` INT, IN `$category` VARCHAR(50), IN `$userid` INT)
BEGIN
	START TRANSACTION;
		SET @reconciliationdate= CURDATE();
		SET @basedate=DATE_ADD(@reconciliationdate, INTERVAL -1 DAY);
		-- Insert reconciliation header
		INSERT INTO `stockreconciledbalance`(`reconciliationdate`,`userid`,`narration`,`posid`,`category`)
		VALUES(@reconciliationdate,$userid,$narration,$posid,$category);
		-- Get the Inserted Id
		SET @id=(SELECT MAX(id) FROM `stockreconciledbalance`);
		
		-- Insert the reconciliation details
		IF $category='outlet' THEN 				
			INSERT INTO `stockreconciledbalancedetails` (`reconciliationid`,`itemid`,`quantity`,`unitprice`)
			SELECT @id, `itemid`,
				CASE /*when `fn_getitemstorebalance`(itemid,$posid)<0 then
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
    END $$

DROP PROCEDURE IF EXISTS `spsavestocktransfer` $$
CREATE PROCEDURE `spsavestocktransfer`(`$refno` VARCHAR(50), `$sourcetype` VARCHAR(50), `$sourceid` NUMERIC, `$destinationtype` VARCHAR(50), `$destinationid` NUMERIC, `$userid` NUMERIC, `$issuedto` INT, `$storecontroller` INT)
BEGIN
	DECLARE $transferrefno VARCHAR(50);
	DECLARE $id NUMERIC;
	
	START TRANSACTION;
		-- generate reference number
		SET $transferrefno=`fngeneratestocktransaferno`();
		-- save transfer header details
		INSERT INTO `stocktransfer`(`referenceno`,`sourcetype`,`sourceid`,`destinationtype`,`destinationid`,`addedby`,`dateadded`,`issuedto`,`storecontroller`)
		VALUES($transferrefno,$sourcetype,$sourceid,$destinationtype,$destinationid,$userid,NOW(),$issuedto,$storecontroller);
		-- get the mpost recently inserted id
		SET $id=(SELECT MAX(`id`) FROM `stocktransfer`);
		-- save transfer items details
		INSERT INTO `stocktransferdetails`(`transferid`,`itemcode`,`quantity`,`unitprice`,`serialno`)
		SELECT $id,`itemcode`,SUM(`quantity`) AS quantity,`unitprice`,`serialno` 
		FROM `tempstocktransfer` WHERE `refno`=$refno 
		GROUP BY $id,`itemcode`,`unitprice`,`serialno`;
		-- increment counter
		UPDATE `serials` SET `currentno`=`currentno`+1 WHERE `documenttype`='Stock Transfer';
		-- delete temporary data
		DELETE FROM `tempstocktransfer` WHERE `refno`=$refno;
		-- return reference number generated
		SELECT  $transferrefno AS transfercode;		
	COMMIT;
    END $$

DROP PROCEDURE IF EXISTS `spsavesupplier` $$
CREATE PROCEDURE `spsavesupplier`(`$supplierid` INT, `$suppliername` VARCHAR(50), `$physicaladdress` VARCHAR(100), `$postaladdress` VARCHAR(100), `$creditlimit` NUMERIC, `$mobile` VARCHAR(50), `$email` VARCHAR(50), `$supplierpinno` VARCHAR(50), `$clientid` NUMERIC)
BEGIN
	IF $supplierid=0 THEN 
		INSERT INTO `suppliers`(`suppliername`,`physicaladdress`,`postaladdress`,`creditlimit`,`mobile`,`email`,`dateadded`,`addedby`,`deleted`,`supplierpinno`)
		VALUES($suppliername,$physicaladdress,$postaladdress,$creditlimit,$mobile,$email,NOW(),$clientid,0,$supplierpinno);
	ELSE
		UPDATE `suppliers` SET `suppliername`=$suppliername,`physicaladdress`=$physicaladdress,`postaladdress`=$postaladdress,`creditlimit`=$creditlimit,
		`mobile`=$mobile,`email`=$email, `lastdatemodified`=NOW(), `lastmodifiedby`=$clientid,`supplierpinno`=$supplierpinno
		WHERE `supplierid`=$supplierid;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spsavesupplierinvoice` $$
CREATE PROCEDURE `spsavesupplierinvoice`(`$refno` VARCHAR(50), `$invoiceno` VARCHAR(50), `$supplierid` INT, `$invoicedate` DATETIME, `$userid` INT)
BEGIN
	DECLARE $id INT;
	DECLARE $inventoryaccount INT;
	DECLARE $suppliercontrolaccount INT;
	DECLARE $suppliername VARCHAR(100);
	DECLARE $description VARCHAR(1000);
	DECLARE $total NUMERIC(10,2);
	
	START TRANSACTION;
		
		SET $suppliername=(SELECT `suppliername` FROM `suppliers` WHERE `supplierid`=$supplierid);
		
		SET $description=CONCAT('Invoice #',$invoiceno,' received from ',$suppliername);
		
		-- select concat('The refno is:' ,$refno) as refno;
		
		
		SET $total=(SELECT SUM(g.`quantity`* pod.`unitprice`) FROM `tempsupplierinvoice` t, `products` p,
		`goodsreceiveddetails` g, `purchaseorders` po, `purchaseorderdetails` pod
		WHERE g.`grnno`=t.`grnno` AND g.`itemcode`=p.`productid` AND g.`purchaseorderno`=po.`purchaseorderno` AND po.`id`=pod.`purchaseorderid`
		AND p.productid=pod.itemcode AND t.refno=$refno);
		
		SET $suppliercontrolaccount=(SELECT `id` FROM `glaccounts` WHERE `accountcode`=(SELECT `account` FROM `glaccountsettings` WHERE `description`='Suppliers Control Account'));
		
		SET $inventoryaccount=(SELECT `id` FROM `glaccounts` WHERE `accountcode`=(SELECT `account` FROM `glaccountsettings` WHERE `description`='Cost of Goods Sold'));
		-- select concat('Total for invoice #',$invoiceno, ' is ',$total);
		-- save the invoice
		INSERT INTO `supplierinvoice`(`supplierid`,`invoiceno`,`invoicedate`,`addedby`,`dateadded`)
		VALUES($supplierid,$invoiceno,$invoicedate,$userid,NOW());
		-- get invoice id
		SET $id=(SELECT MAX(`id`) FROM `supplierinvoice`); -- LAST_INSERT_ID('supplierinvoice');-- 
		-- add invoice details
		INSERT INTO `supplierinvoicedetails`(`invoiceid`,`referenceno`,`itemcode`,`description`,`quantity`,`unitprice`)
		SELECT $id,g.`grnno`,g.`itemcode`, p.`itemname`, g.`quantity`, pod.`unitprice` FROM `tempsupplierinvoice` t, `products` p,
		`goodsreceiveddetails` g, `purchaseorders` po, `purchaseorderdetails` pod
		WHERE g.`grnno`=t.`grnno` AND g.`itemcode`=p.`productid` AND g.`purchaseorderno`=po.`purchaseorderno` AND po.`id`=pod.`purchaseorderid`
		AND p.productid=pod.itemcode AND t.refno=$refno;
		-- update grn used
		UPDATE `goodsreceived` SET `invoiced`=1, `invoiceno`=$id, `status`='Invoiced' WHERE `grnno` IN(SELECT grnno FROM `tempsupplierinvoice` WHERE `refno`=$refno);
		-- post gl entries
		-- Credit suppliers control account
		INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		VALUES($invoiceno,NOW(),$suppliercontrolaccount, $inventoryaccount, $description,0,$total,$userid) ;
		-- Debit Inventory
		INSERT INTO `gltransactions`(`referenceno`,`transactiondate`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`,`addedby`)
		VALUES($invoiceno,NOW(), $inventoryaccount,$suppliercontrolaccount, $description,$total,0,$userid) ;
		-- delete temp data
		DELETE FROM `tempsupplierinvoice` WHERE `refno`=$refno;
	COMMIT;
    END $$

DROP PROCEDURE IF EXISTS `spsavesupplierproduct` $$
CREATE PROCEDURE `spsavesupplierproduct`(`$supplierid` INT, `$productid` INT, `$userid` INT)
BEGIN
	IF NOT EXISTS(SELECT * FROM `supplierproducts` WHERE `supplierid`=$supplierid AND `productid`=$productid AND `deleted`=0) THEN 
		INSERT INTO `supplierproducts`(`supplierid`,`productid`,`addedby`,`dateadded`,`deleted`)
		VALUES($supplierid,$productid,$userid,NOW(),0);
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `spsavetempbanking` $$
CREATE PROCEDURE `spsavetempbanking`(`$refno` VARCHAR(50), `$receiptno` VARCHAR(50), `$reference` VARCHAR(50), `$amount` DECIMAL(10,2), `$customername` VARCHAR(50), `$id` INT)
BEGIN
	INSERT INTO `tempbanking`(`refno`,`receiptno`,`reference`,`amount`,`customername`,`id`)
	VALUES($refno,$receiptno,$reference,$amount,$customername,$id);
    END $$

DROP PROCEDURE IF EXISTS `spsavetempcreditnotedetails` $$
CREATE PROCEDURE `spsavetempcreditnotedetails`(`$refno` VARCHAR(50), `$itemcode` VARCHAR(50), `$quantity` NUMERIC, `$unitprice` NUMERIC)
BEGIN
	DECLARE $itemid INT;
	SET $itemid=(SELECT `productid` FROM `products` WHERE `itemcode`=$itemcode);
	INSERT INTO `tempcreditnote`(`refno`,`itemcode`,`quantity`,`unitprice`)
	VALUES($refno,$itemid,$quantity,$unitprice);
    END $$

DROP PROCEDURE IF EXISTS `spsavetempcustomerinvoice` $$
CREATE PROCEDURE `spsavetempcustomerinvoice`(`$refno` VARCHAR(50), `$grnno` VARCHAR(50))
BEGIN
	INSERT INTO `tempcustomerinvoice`(`refno`,`grnno`)
	VALUES($refno,$grnno);
    END $$

DROP PROCEDURE IF EXISTS `spsavetempgltransaction` $$
CREATE PROCEDURE `spsavetempgltransaction`(`$refno` VARCHAR(50), `$glaccount` INT, `$glcontraaccount` INT, `$narration` VARCHAR(500), `$debit` FLOAT, `$credit` FLOAT)
BEGIN
	INSERT INTO `tempgltransaction`(`refno`,`glaccount`,`glcontraaccount`,`narration`,`debit`,`credit`)
	VALUES($refno,$glaccount,@contraaccount,$narration,$debit,$credit);
    END $$

DROP PROCEDURE IF EXISTS `spsavetempgoodsreceived` $$
CREATE PROCEDURE `spsavetempgoodsreceived`(IN $branchid INT, IN $refno VARCHAR(50),
    IN $pono VARCHAR(50),
    IN $itemcode VARCHAR(50),
    IN $quantity DECIMAL(18,2),
    IN $serialno VARCHAR(100)
)
BEGIN
    INSERT INTO `tempgoodsreceived` (branchid, `refno`, `purchaseorderno`, `itemcode`, `quantity`, `serialno`)
    VALUES ($branchid, $refno, $pono, $itemcode, $quantity, $serialno);
END $$

DROP PROCEDURE IF EXISTS `spsavetempjournaldetails` $$
CREATE PROCEDURE `spsavetempjournaldetails`(`$refno` VARCHAR(50), `$glaccount` INT, `$narration` VARCHAR(100), `$debit` FLOAT, `$credit` FLOAT)
BEGIN
	INSERT INTO `tempjournaldetails`(`refno`,`glaccount`,`narration`,`debit`,`credit`)
	VALUES($refno,$glaccount,$narration,$debit,$credit);
    END $$

DROP PROCEDURE IF EXISTS `spsavetemppossalepayment` $$
CREATE PROCEDURE `spsavetemppossalepayment`(`$refno` VARCHAR(50), `$paymentmode` INT, `$referenceno` VARCHAR(50), `$amount` DECIMAL(18,2))
BEGIN	
	INSERT INTO `temppossalespayment`(`refno`,`paymentmodeid`,`reference`,`amount`)
	VALUES($refno,$paymentmode,$referenceno,$amount);
    END $$

DROP PROCEDURE IF EXISTS `spsavetemppricematrix` $$
CREATE PROCEDURE `spsavetemppricematrix`(`$refno` VARCHAR(50), `$catid` NUMERIC, `$percentage` BIT, `$val` NUMERIC)
BEGIN
	INSERT INTO `temppricematrix`(`refno`,`catid`,`percentage`,`value`)
	VALUES($refno,$catid,$percentage,$val);
    END $$

DROP PROCEDURE IF EXISTS `spsavetempprivilege` $$
CREATE PROCEDURE `spsavetempprivilege`(`$refno` VARCHAR(50), `$id` INT, `$objectid` INT, `$valid` BIT)
BEGIN
	INSERT INTO `tempprivilege`(`refno`,`id`,`objectid`,`valid`)
	VALUES($refno,$id,$objectid,$valid);
    END $$

DROP PROCEDURE IF EXISTS `spsavetemppurchaseorderitem` $$
CREATE PROCEDURE `spsavetemppurchaseorderitem`(IN $branchid INT, IN $refno VARCHAR(50),
    IN $itemcode VARCHAR(50),
    IN $quantity DECIMAL(18,2),
    IN $unitprice DECIMAL(18,2),
    IN $taxable BOOL,
    IN $taxinclusive BOOL
)
BEGIN
    INSERT INTO `temppurchaseorder` (branchid, `refno`, `itemcode`, `quantity`, `unitprice`, `taxable`, `taxinclusive`)
    VALUES ($branchid, $refno, $itemcode, $quantity, $unitprice, $taxable, $taxinclusive);
END $$

DROP PROCEDURE IF EXISTS `spsavetempreconcilebalancedetails` $$
CREATE PROCEDURE `spsavetempreconcilebalancedetails`(`$refno` VARCHAR(50), `$itemid` INT, `$quantity` NUMERIC(18,2), `$unitprice` NUMERIC(18,2))
BEGIN
	INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
	VALUES($refno,$itemid,$quantity,$unitprice);
    END $$

DROP PROCEDURE IF EXISTS `spsavetempreturns` $$
CREATE PROCEDURE `spsavetempreturns`(`$refno` VARCHAR(50), `$productid` VARCHAR(50), `$serialno` VARCHAR(50), `$quantity` NUMERIC(18,2))
BEGIN
	INSERT INTO `tempreturns`(`refno`,`productid`,`quantity`,`serialno`)
	VALUES($refno,$productid,$quantity,$serialno);
    END $$

DROP PROCEDURE IF EXISTS `spsavetempsale` $$
CREATE PROCEDURE `spsavetempsale`(IN $branchid INT, IN $refno VARCHAR(50),
    IN $itemcode VARCHAR(50),
    IN $quantity DECIMAL(18,2),
    IN $unitprice DECIMAL(18,2),
    IN $discount DECIMAL(18,2),
    IN $serialno VARCHAR(100),
    IN $description VARCHAR(250)
)
BEGIN
    INSERT INTO `tempsale` (branchid, `refno`, `itemcode`, `quantity`, `unitprice`, `discount`, `serialno`, `description`)
    VALUES ($branchid, $refno, $itemcode, $quantity, $unitprice, $discount, $serialno, $description);
END $$

DROP PROCEDURE IF EXISTS `spsavetempstocktransfer` $$
CREATE PROCEDURE `spsavetempstocktransfer`(`$refno` VARCHAR(50), `$itemcode` VARCHAR(50), `$unitprice` NUMERIC(10,2), `$quantity` NUMERIC(10,2), `$serialno` VARCHAR(50))
BEGIN
	DECLARE $itemid INT;
	SET $itemid=(SELECT `productid` FROM `products` WHERE `itemcode`=$itemcode);
	INSERT INTO `tempstocktransfer`(`refno`,`itemcode`,`quantity`,`unitprice`,`serialno`)
	VALUES($refno,$itemid,$quantity,$unitprice,$serialno);
    END $$

DROP PROCEDURE IF EXISTS `spsavetempsupplierinvoice` $$
CREATE PROCEDURE `spsavetempsupplierinvoice`(`$refno` VARCHAR(50), `$grnno` VARCHAR(50))
BEGIN
	INSERT INTO `tempsupplierinvoice`(`refno`,`grnno`)
	VALUES($refno,$grnno);
    END $$

DROP PROCEDURE IF EXISTS `spsavetepmpaymentvoucherdetails` $$
CREATE PROCEDURE `spsavetepmpaymentvoucherdetails`(`$refno` VARCHAR(50), `$itemcode` VARCHAR(50), `$description` VARCHAR(500), `$quantity` DECIMAL(10,3), `$unitprice` DECIMAL(10,2), `$accountcharged` INT, `$invoicenumber` VARCHAR(50))
BEGIN
	INSERT INTO `temppaymentvoucherdetails`(`refno`,`itemcode`,`description`,`quantity`,`unitprice`,`accountcharged`,`invoicenumber`)
	VALUES($refno,$itemcode,$description,$quantity,$unitprice,$accountcharged,$invoicenumber);
    END $$

DROP PROCEDURE IF EXISTS `spsaveuser` $$
CREATE PROCEDURE `spsaveuser`(`$clientid` INT, `$userpassword` VARCHAR(50), `$systemadmin` BIT, `$username` VARCHAR(50), `$firstname` VARCHAR(50), `$middlename` VARCHAR(50), `$lastname` VARCHAR(50), `$email` VARCHAR(50), `$mobile` VARCHAR(50), `$changepasswordonlogon` BIT, `$accountactive` BIT, `$addedby` INT)
BEGIN
	IF $clientid=0 THEN 
		-- begin
			INSERT INTO `user`(`username`,`password`,`firstname`,`middlename`,`lastname`,`email`,`mobile`,`changepasswordonlogon`,`accountactive`,`addedby`,`dateadded`,systemadmin)
			VALUES($username,$userpassword,$firstname,$middlename,$lastname,$email,$mobile,$changepasswordonlogon,$accountactive,$addedby,NOW(),$systemadmin);
			SET $clientid=(SELECT MAX(`id`) FROM `user`);
		-- end
	ELSE
		UPDATE `user` SET `username`=$username,`firstname`=$firstname,`middlename`=$middlename,`lastname`=$lastname,`email`=email,`mobile`=$mobile,
		`changepasswordonlogon`=$changepasswordonlogon,/*`accountactive`=$accountactive,*/`systemadmin`=$systemadmin,`lastmodifiedby`=$addedby,`lastmodifiedon`=NOW()
		WHERE `id`=$clientid;
	END IF;
	
	SELECT $clientid AS `userid`;
	
    END $$

DROP PROCEDURE IF EXISTS `spsaveuseroutlet` $$
CREATE PROCEDURE `spsaveuseroutlet`(`$userid` INT, `$outletid` INT, `$addedby` INT)
BEGIN
	
	IF NOT EXISTS(SELECT * FROM `useroutlets` WHERE `userid`=$userid AND `outletid`=$outletid) THEN
		INSERT INTO `useroutlets`(`userid`,`outletid`,`dateadded`,`addedby`,`deleted`)
		VALUES($userid,$outletid,NOW(),$addedby,0);
	ELSE
		UPDATE `useroutlets` SET `deleted`=0,`lastdatemodified`=NOW(),`lastmodifiedby`=$addedby
		WHERE `userid`=$userid AND `outletid`=$outletid;
	END IF;
	
    END $$

DROP PROCEDURE IF EXISTS `spsaveuserprivilege` $$
CREATE PROCEDURE `spsaveuserprivilege`(`$userid` INT, `$objectid` INT, `$allowed` BIT, `$useradding` INT)
BEGIN
	IF NOT EXISTS(SELECT * FROM `userprivileges` WHERE `objectid`=$objectid AND `userid`=$userid) THEN
		INSERT INTO `userprivileges`(`objectid`,`userid`,`allowed`,`dateadded`,`addedby`)
		VALUES($objectid,$userid,$allowed,NOW(),$useradding);
	ELSE
		UPDATE `userprivileges` SET `allowed`=$allowed, `lastdateupdated`=NOW(),`lastupdatedby`=$useradding 
		WHERE `objectid`=$objectid AND `userid`=$userid;
	END IF ;
		
    END $$

DROP PROCEDURE IF EXISTS `sptempsavecustomerreceiptdetails` $$
CREATE PROCEDURE `sptempsavecustomerreceiptdetails`(`$refno` VARCHAR(50), `$possaleid` NUMERIC, `$amount` NUMERIC)
BEGIN
	INSERT INTO `tempcustomerreceiptdetails`(`refno`,`possaleid`,`amount`)
	VALUES($refno,$possaleid,$amount);
    END $$

DROP PROCEDURE IF EXISTS `spvalidateuserprivilege` $$
CREATE PROCEDURE `spvalidateuserprivilege`(`$clientid` INT, `$objectid` INT)
BEGIN
	DECLARE $admin INT;
	DECLARE $valid INT DEFAULT 0;
	SET $admin=(SELECT systemadmin FROM `user` WHERE `id`=$clientid);
	IF $admin=1 THEN
		SET $valid=1;
	ELSE
		SET $valid=IFNULL((SELECT `allowed` FROM `userprivileges` WHERE `userid`=$clientid AND `objectid`=$objectid),0);
	END IF;
	
	SELECT $valid AS `allowed`;
	
    END $$

DROP PROCEDURE IF EXISTS `sp_activatesession` $$
CREATE PROCEDURE `sp_activatesession`(`$sessionfloat` DECIMAL(18, $2), `$userid` INT)
BEGIN
		INSERT INTO  `sessions`(`starttime`,`addedby`,`dateadded`,`floatamount`)
		VALUES(NOW(),$userid,DATE_FORMAT(NOW(),'%Y-%m-%d'),$sessionfloat);
		
		SELECT MAX(`sessionid`) sessionid 
		FROM `sessions`;
	END $$

DROP PROCEDURE IF EXISTS `sp_approvepurchaseorder` $$
CREATE PROCEDURE `sp_approvepurchaseorder`(`$pono` VARCHAR(50), `$approvallevelid` INT, `$userid` INT, `$narration` VARCHAR(500))
BEGIN
    
	SET @poid=(SELECT id FROM `purchaseorders` WHERE `purchaseorderno`=$pono);
	
	INSERT INTO `purchaseorderapproval`(`poid`,`approvallevelid`,`approvaluser`,`approvaldate`,`narration`)
	VALUES(@poid,$approvallevelid,$userid,NOW(),$narration);
	
    END $$

DROP PROCEDURE IF EXISTS `sp_cancelcustomerorder` $$
CREATE PROCEDURE `sp_cancelcustomerorder`(`$orderid` INT, `$reason` VARCHAR(1000), `$userid` INT)
BEGIN
		UPDATE `customerorders`
		SET `status`='Cancelled',`datecancelled`=NOW(),`reasoncancelled`=$reason
		WHERE `orderid`=$orderid;
	END $$

DROP PROCEDURE IF EXISTS `sp_checkcustomercontact` $$
CREATE PROCEDURE `sp_checkcustomercontact`(`$id` INT, `$customerid` INT, `$contactname` VARCHAR(50))
BEGIN
	SELECT * 
	FROM `customercontacts` 
	WHERE `id`!=$id AND `customerid`=$customerid AND `contactname`=$contactname;
    END $$

DROP PROCEDURE IF EXISTS `sp_checkdepartment` $$
CREATE PROCEDURE `sp_checkdepartment`(`$id` INT, `$departmentname` VARCHAR(50))
BEGIN
	SELECT * FROM departments  WHERE `departmentname`=$departmentname AND `id`<>$id;
    END $$

DROP PROCEDURE IF EXISTS `sp_checkfleetvehicleregno` $$
CREATE PROCEDURE `sp_checkfleetvehicleregno`(`$vehicleid` INT, `$regno` VARCHAR(50))
BEGIN
	SELECT * FROM `fleetvehicles` WHERE `vehicleid`<>$vehicleid AND `regno`=$regno;
END $$

DROP PROCEDURE IF EXISTS `sp_checkrawmaterial` $$
CREATE PROCEDURE `sp_checkrawmaterial`(`$id` INT, `$materialname` VARCHAR(50))
BEGIN
	SELECT * FROM `rawmaterials` 
	WHERE `materialid`<>$id AND `materialname`=$materialname;
    END $$

DROP PROCEDURE IF EXISTS `sp_checksessionid` $$
CREATE PROCEDURE `sp_checksessionid`()
BEGIN
		SELECT * FROM `sessions` WHERE `status`='active';
	END $$

DROP PROCEDURE IF EXISTS `sp_checktable` $$
CREATE PROCEDURE `sp_checktable`(`$tableid` INT, `$posid` INT, `$tablename` VARCHAR(50))
BEGIN
		SELECT * 
		FROM `tables`
		WHERE `tableid`!=$tableid AND `posid`=$posid AND `tablename`=$tablename AND `deleted`=0;
	END $$

DROP PROCEDURE IF EXISTS `sp_checkuserprivilegewithcode` $$
CREATE PROCEDURE `sp_checkuserprivilegewithcode`(`$clientid` INT, `$objectcode` VARCHAR(50))
BEGIN
		-- Check if system administrator
		IF EXISTS(SELECT * FROM `user` WHERE `id`=$clientid AND `systemadmin`=1) THEN 
			SELECT 1 allowed;
		-- Check if user has a role that was assined the privilege
		ELSEIF EXISTS(SELECT * FROM `roleprivileges` r 
			JOIN `objects` b ON b.`id`=r.`objectid`
			JOIN `roleusers` ru ON ru.`roleid`=r.`roleid` 
			WHERE ru.userid=$clientid AND `allowed`=1 AND b.code=$objectcode) THEN 
				SELECT 1 allowed;
		-- Check if user has privileges directly
		ELSEIF EXISTS(SELECT * FROM `userprivileges` p 
			JOIN `objects` o ON o.`id`=p.`objectid`
			WHERE p.`userid`=$clientid AND o.`code`=$objectcode AND `allowed`=1) THEN 
				SELECT 1 allowed;
		-- User does not have the privileges
		ELSE
			SELECT 0 allowed;
		END IF;	
	END $$

DROP PROCEDURE IF EXISTS `sp_checkzone` $$
CREATE PROCEDURE `sp_checkzone`(`$id` INT, `$zonename` VARCHAR(50))
BEGIN
	SELECT * FROM `zones` WHERE `id`<>$id AND `zonename`=$zonename;
    END $$

DROP PROCEDURE IF EXISTS `sp_closesession` $$
CREATE PROCEDURE `sp_closesession`(`$userid` INT)
BEGIN
		UPDATE `sessions`
		SET `status`='closed',`closedby`=$userid, `dateclosed`=NOW()
		WHERE `status`='active';
	END $$

DROP PROCEDURE IF EXISTS `sp_deletecustomercontact` $$
CREATE PROCEDURE `sp_deletecustomercontact`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `customercontacts` 
	SET `deleted`=1, `datedeleted`=NOW(), `deletedby`=$clientid
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `sp_deletedepartment` $$
CREATE PROCEDURE `sp_deletedepartment`(`$id` INT)
BEGIN
	UPDATE `departments` SET deleted=1 WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `sp_deleterawmaterial` $$
CREATE PROCEDURE `sp_deleterawmaterial`(`$materialid` INT, `$clientid` INT)
BEGIN
	UPDATE `rawmaterials` 
	SET `deleted`=1,`datedeleted`=NOW(),`deletedby`=$clientid
	WHERE `materialid`=$materialid;
    END $$

DROP PROCEDURE IF EXISTS `sp_deletetable` $$
CREATE PROCEDURE `sp_deletetable`(`$tableid` INT, `$userid` INT)
BEGIN
		UPDATE `tables`
		SET `deleted`=1,`deletedby`=$userid, `datedeleted`=NOW()
		WHERE `tableid`=$tableid;
	END $$

DROP PROCEDURE IF EXISTS `sp_deletezone` $$
CREATE PROCEDURE `sp_deletezone`(`$id` INT, `$clientid` INT)
BEGIN
	UPDATE `zones` SET `deleted`=1,`datedeleted`=NOW(),`deletedby`=$clientid
	WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `sp_filtercustomerorders` $$
CREATE PROCEDURE `sp_filtercustomerorders`(`$customerid` INT, `$tableid` INT, `$posid` INT, `$waiterid` INT, `$startdate` DATE, `$enddate` DATE, `$orderstatus` VARCHAR(50))
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
	END $$

DROP PROCEDURE IF EXISTS `sp_filterfleetrequisitions` $$
CREATE PROCEDURE `sp_filterfleetrequisitions`(`$supplierid` INT, `$costcenterid` INT, `$vehicleid` INT, `$startdate` DATE, `$enddate` DATE)
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
    END $$

DROP PROCEDURE IF EXISTS `sp_filtergoodsreceivednotes` $$
CREATE PROCEDURE `sp_filtergoodsreceivednotes`(`$supplierid` INT, `$startdate` DATE, `$enddate` DATE, `$grnno` VARCHAR(50), `$deliverynoteno` VARCHAR(50))
BEGIN
	IF $supplierid=0 THEN
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
		g.grnno LIKE CONCAT('%',$grnno,'%') AND deliverynono LIKE CONCAT('%',$deliverynoteno,'%')
		GROUP BY g.`id`, `warehouseid`, w.`description`,s.`supplierid`,`suppliername`,g.`grnno`
		ORDER BY g.grnno DESC;
	ELSE
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
		g.grnno LIKE CONCAT('%',$grnno,'%') AND deliverynono LIKE CONCAT('%',$deliverynoteno,'%') AND supplierid=$supplierid
		GROUP BY g.`id`, `warehouseid`, w.`description`,s.`supplierid`,`suppliername`,g.`grnno`
		ORDER BY g.grnno DESC; 
	END IF;
	
    END $$

DROP PROCEDURE IF EXISTS `sp_filterspoilage` $$
CREATE PROCEDURE `sp_filterspoilage`(`$startdate` DATE, `$enddate` DATE, `$categoryid` INT, `$productid` INT)
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
    END $$

DROP PROCEDURE IF EXISTS `sp_fleetapprovefuelrequisition` $$
CREATE PROCEDURE `sp_fleetapprovefuelrequisition`(`$id` INT, `$userid` INT)
BEGIN
	UPDATE `fleetfuelrequisition` SET `approvedby`=$userid, `dateapproved`=NOW()
	WHERE `id`=$id;
END $$

DROP PROCEDURE IF EXISTS `sp_getcontactscategories` $$
CREATE PROCEDURE `sp_getcontactscategories`()
BEGIN
	SELECT * 
	FROM `contactscategories` 
	ORDER BY `description`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getcratesummary` $$
CREATE PROCEDURE `sp_getcratesummary`(`$enddate` DATE)
BEGIN
	SET @productid=(SELECT productid FROM `cratesinventorysettings`);
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
		IFNULL((SELECT SUM(quantity) FROM `cratesinventory` WHERE `narration`='Crate deposit refund' AND DATE_FORMAT(`dateadded`,'%Y-%m-%d')=@enddate),0)
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
	FROM products p	WHERE p.productid=@productid; -- ORDER BY itemname;
    END $$

DROP PROCEDURE IF EXISTS `sp_getcurrencies` $$
CREATE PROCEDURE `sp_getcurrencies`(IN $clientid INT)
BEGIN
    SELECT * FROM `currencies` WHERE clientid = $clientid;
END $$

DROP PROCEDURE IF EXISTS `sp_getcustomercontacts` $$
CREATE PROCEDURE `sp_getcustomercontacts`(`$customerid` INT)
BEGIN
	SELECT c.*, t.description categoryname, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname
	FROM `user` u, `customercontacts` c, `contactscategories` t
	WHERE c.`categoryid`=t.`id` AND c.`addedby`=u.`id` AND IFNULL(c.deleted,0)=0
	AND `customerid`=$customerid
	ORDER BY contactname;
    END $$

DROP PROCEDURE IF EXISTS `sp_getcustomerorderdetails` $$
CREATE PROCEDURE `sp_getcustomerorderdetails`(`$orderno` VARCHAR(50))
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
		
	END $$

DROP PROCEDURE IF EXISTS `sp_getdefaultterms` $$
CREATE PROCEDURE `sp_getdefaultterms`(IN $branchid INT)
BEGIN
    SELECT * FROM `defaultterms` WHERE branchid = $branchid;
END $$

DROP PROCEDURE IF EXISTS `sp_getdepartmentdetails` $$
CREATE PROCEDURE `sp_getdepartmentdetails`(`$id` INT)
BEGIN
	SELECT * FROM `departments` WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `sp_getdepartments` $$
CREATE PROCEDURE `sp_getdepartments`(IN $clientid INT)
BEGIN
    SELECT * FROM `departments` WHERE clientid = $clientid AND deleted = 0;
END $$

DROP PROCEDURE IF EXISTS `sp_getemailconfiguration` $$
CREATE PROCEDURE `sp_getemailconfiguration`()
BEGIN
	SELECT * FROM `emailconfiguration`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getfleetbodytypes` $$
CREATE PROCEDURE `sp_getfleetbodytypes`()
BEGIN
	SELECT * FROM `fleetbodytypes` WHERE IFNULL(deleted,0)=0
	ORDER BY description;
    END $$

DROP PROCEDURE IF EXISTS `sp_getfleetfueltypes` $$
CREATE PROCEDURE `sp_getfleetfueltypes`()
BEGIN
	SELECT * FROM `fleetfueltypes` WHERE IFNULL(deleted,0)=0
	ORDER BY description;
    END $$

DROP PROCEDURE IF EXISTS `sp_getfleetrequisitiondetails` $$
CREATE PROCEDURE `sp_getfleetrequisitiondetails`(`$id` INT)
BEGIN
	SELECT * FROM `fleetfuelrequisition` WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `sp_getfleetrequisitionheaderdetails` $$
CREATE PROCEDURE `sp_getfleetrequisitionheaderdetails`(`$requisitionno` VARCHAR(50))
BEGIN
		SELECT `requisitionno`, DATE_FORMAT(r.`dateadded`,'%d-%b-%Y') requisitiondate, `regno`, `odoreading`, `posname`, s.`suppliername`,s.postalcode,s.town,
		s.`physicaladdress`,s.`postaladdress`,s.`email`,CONCAT(u.`firstname`,' ',u.`middlename`,' ',u.`lastname`) AS preparedby,
		`quantity`,`unitprice`,t.`description` AS fueltype,
		CONCAT(a.`firstname`,' ',a.`middlename`,' ',a.`lastname`) AS approvedby,
		CONCAT(q.`firstname`,' ',q.`middlename`,' ',q.`lastname`) AS requestedby
		FROM  `fleetfuelrequisition` r, `pointsofsale` p, `suppliers` s, `fleetvehicles` v, `user` u, `fleetfueltypes` t, `user` a, `user` q
		WHERE r.`supplierid`=s.supplierid AND r.`costcenterid`=p.id AND  r.`vehicleid`=v.vehicleid AND r.addedby=u.id
		AND r.approvedby=a.id AND r.requestedby=q.id AND t.`id`=v.`fueltypeid` AND r.requisitionno=$requisitionno;
	END $$

DROP PROCEDURE IF EXISTS `sp_getfleetvehicles` $$
CREATE PROCEDURE `sp_getfleetvehicles`()
BEGIN
	SELECT v.*, f.description AS fueltype, b.description AS bodytype , CONCAT(firstname,' ',lastname) addedbyname
	FROM `fleetvehicles` v, `fleetfueltypes` f, `fleetbodytypes` b, `user` u
	WHERE   v.`fueltypeid`=f.id AND v.`bodytypeid`=b.id AND v.addedby=u.id
	AND IFNULL(v.`deleted`,0)=0
	ORDER BY `regno`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getgrndetails` $$
CREATE PROCEDURE `sp_getgrndetails`(`$grnno` VARCHAR(50))
BEGIN
		SELECT p.`purchaseorderno`,r.itemcode, r.itemname, r.unitofmeasure,gd.quantity, pd.unitprice, gd.quantity*pd.unitprice linetotal
		FROM `goodsreceiveddetails` gd
		INNER JOIN `purchaseorders` p ON p.`purchaseorderno`=gd.`purchaseorderno`
		INNER JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid`=p.`id`
		INNER JOIN `products` r ON r.`productid`=gd.`itemcode` AND r.productid=pd.`itemcode`
		WHERE gd.grnno=$grnno;
	END $$

DROP PROCEDURE IF EXISTS `sp_getgrnheader` $$
CREATE PROCEDURE `sp_getgrnheader`(`$grnno` VARCHAR(100))
BEGIN
		SELECT w.description AS warehousename,suppliername, `physicaladdress`,`postaladdress`,s.`postalcode`,s.`town`,s.`mobile`,s.`email`,
		`grnno`,DATE_FORMAT(`datereceived`,'%d-%b-%Y %H:%i') datereceived, `deliverynono`,
		CONCAT(r.firstname,' ',r.middlename,' ',r.lastname) receivedbyname
		FROM `goodsreceived` g
		JOIN `suppliers` s ON s.`supplierid`=g.`supplierid`
		JOIN `user` r ON r.`id`=g.`receivedby`
		JOIN `warehouses` w ON w.`id`=g.warehouseid
		WHERE g.`grnno`=$grnno;
	END $$

DROP PROCEDURE IF EXISTS `sp_getgrnheaderdetails` $$
CREATE PROCEDURE `sp_getgrnheaderdetails`(`$grnno` VARCHAR(50))
BEGIN
	
		SELECT  `grnno`,DATE_FORMAT(`datereceived`,'%d-%b-%Y') datereceived,CONCAT(r.firstname,' ', r.middlename,' ', r.lastname) receivedby,
		CONCAT(i.firstname,' ', i.middlename,' ', i.lastname) inspectedby,deliveredby,`deliverynono`,`narration`,
		'' projectname, '' materialusecase, s.`suppliername`,s.`physicaladdress`,s.`postaladdress`,s.`mobile`,s.`email`
		FROM `goodsreceived` m, `suppliers` s, `user` r, `user` i
		WHERE m.`supplierid`=s.`supplierid` AND m.`receivedby`=r.`id` AND m.`inspectedby`=i.id AND grnno=$grnno;
	
    END $$

DROP PROCEDURE IF EXISTS `sp_getgrnitems` $$
CREATE PROCEDURE `sp_getgrnitems`(`$grnno` VARCHAR(50))
BEGIN
	SELECT `productid`,m.`itemcode`, m.itemname,m.unitofmeasure uom, SUM(rd.quantity) quantity, -- `fn_getgrnitemserialnumbers`($grnno,rd.materialid) 
	'' serialnos, p.purchaseorderno pono, pd.unitprice,deliveredby
	FROM `products` m
	INNER JOIN `goodsreceiveddetails` rd ON rd.itemcode=m.`productid`
	INNER JOIN `goodsreceived` r ON  r.`grnno` =rd.`grnno`
	INNER JOIN `purchaseorders`  p ON p.`purchaseorderno`=rd.`purchaseorderno`
	INNER JOIN `purchaseorderdetails` pd ON pd.`purchaseorderid`=p.`id`
	WHERE r.grnno=$grnno AND rd.itemcode=pd.itemcode
	GROUP BY  m.`itemcode`, m.`itemname`, unitofmeasure
	ORDER BY m.itemname  ;
    END $$

DROP PROCEDURE IF EXISTS `sp_getinputoutputvat` $$
CREATE PROCEDURE `sp_getinputoutputvat`(`$startdate` DATE, `$enddate` DATE)
BEGIN
		SELECT itemcode, itemname,SUM(quantity) quantitysold
		FROM `products` p
		JOIN `possalesdetails` sd ON sd.`itemcode`=p.productid 
		JOIN `possales` s ON s.id=sd.`possaleid`
		WHERE DATE_FORMAT(s.`receiptdate`,'%Y-%m%-%d') BETWEEN $startdate AND $enddate
		GROUP BY itemcode;
	END $$

DROP PROCEDURE IF EXISTS `sp_getinputoutputvatreport` $$
CREATE PROCEDURE `sp_getinputoutputvatreport`(`$startdate` DATE, `$enddate` DATE)
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
	END $$

DROP PROCEDURE IF EXISTS `sp_getitemstorebalance` $$
CREATE PROCEDURE `sp_getitemstorebalance`(`$productid` INT, `$storeid` INT)
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
	END $$

DROP PROCEDURE IF EXISTS `sp_getmaterialrequestapprovallevels` $$
CREATE PROCEDURE `sp_getmaterialrequestapprovallevels`()
BEGIN
	SELECT * 
	FROM `materialrequestapprovallevels` 
	ORDER BY `hierarchy`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getmaterialrequestdetails` $$
CREATE PROCEDURE `sp_getmaterialrequestdetails`(`$requisitionno` VARCHAR(50))
BEGIN
		SELECT m.*, p.id AS projectid FROM `materialrequest` m, `projectactivities` a, projects p 
		WHERE m.`activityid`=a.`id` AND a.`projectid`=p.`id` AND `requisitionno`=$requisitionno;
	END $$

DROP PROCEDURE IF EXISTS `sp_getmaterialrequisitiondetails` $$
CREATE PROCEDURE `sp_getmaterialrequisitiondetails`(`$requisitionno` VARCHAR(50))
BEGIN
	SELECT m.*, p.id AS projectid FROM `materialrequest` m, `projectactivities` a, projects p 
	WHERE m.`activityid`=a.`id` AND a.`projectid`=p.`id` AND `requisitionno`=$requisitionno;
    END $$

DROP PROCEDURE IF EXISTS `sp_getmaterialrequisitionitems` $$
CREATE PROCEDURE `sp_getmaterialrequisitionitems`(`$requisitionid` INT)
BEGIN
	SELECT m.`id`,`itemcode`,m.`description` AS itemname, IFNULL(`narration`,'') narration,u.`description` AS uom, `quantity`,`unitprice`
	FROM `materialrequestdetails` mr, `materialdetails` m, `materialunitsofmeasure` u
	WHERE m.`id`=mr.materialid AND m.`unitofmeasureid`=u.`id` AND `materialrequestid`=$requisitionid
	ORDER BY m.description;
    END $$

DROP PROCEDURE IF EXISTS `sp_getorderstotal` $$
CREATE PROCEDURE `sp_getorderstotal`(`$refno` VARCHAR(50))
BEGIN
		SELECT SUM(quantity*unitprice) orderstotal
		FROM `customerorderdetails`
		WHERE `orderid` IN(SELECT `orderid` FROM `temporderstosettle` WHERE `refno`=$refno);
		
		DELETE FROM `temporderstosettle` 
		WHERE `refno`=$refno;
	END $$

DROP PROCEDURE IF EXISTS `sp_getpapergrammage` $$
CREATE PROCEDURE `sp_getpapergrammage`(IN $branchid INT)
BEGIN
    SELECT * FROM `papergrammage` WHERE branchid = $branchid;
END $$

DROP PROCEDURE IF EXISTS `sp_getparentzones` $$
CREATE PROCEDURE `sp_getparentzones`()
BEGIN
	SELECT z.id,z.zonename,z.parent,z.dateadded,COUNT(c.customerid) customers, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) addedbyname 
	FROM `zones` z
	INNER JOIN `user` u ON z.`addedby`=u.id
	LEFT OUTER JOIN `zones` zy ON zy.`parent`=z.id
	LEFT OUTER JOIN `customers` c ON c.subzoneid=z.id
	WHERE z.`parent`=0 AND IFNULL(z.`deleted`,0)=0
	GROUP BY z.id,z.zonename,z.parent,z.dateadded
	ORDER BY `zonename`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getpodetails` $$
CREATE PROCEDURE `sp_getpodetails`(`$pono` VARCHAR(50))
BEGIN
		SELECT r.itemcode, itemname, unitofmeasure,
		SUM(quanity) quantity, unitprice, SUM(quanity)*unitprice AS linetotal
		FROM `purchaseorderdetails` pd
		JOIN `purchaseorders` p ON p.`id`=pd.`purchaseorderid`
		JOIN `products` r ON r.`productid`=pd.`itemcode`
		WHERE `purchaseorderno`=$pono
		GROUP BY r.itemcode
		ORDER BY `itemname`;
	END $$

DROP PROCEDURE IF EXISTS `sp_getpoheader` $$
CREATE PROCEDURE `sp_getpoheader`(`$pono` VARCHAR(50))
BEGIN
		SELECT `purchaseorderno`, `date`, suppliername, 
		CONCAT('P.O Box', `postaladdress`,', ',`postalcode` ,' ',`town`) supplieraddress,
		CONCAT(firstname,' ',middlename,' ',lastname) username
		FROM `purchaseorders` p
		JOIN `suppliers` s ON s.supplierid=p.supplierid
		JOIN `user` u ON u.`id`=p.`addedby`
		WHERE p.`purchaseorderno`=$pono;
		
	END $$

DROP PROCEDURE IF EXISTS `sp_getpoheaderdetails` $$
CREATE PROCEDURE `sp_getpoheaderdetails`(`$pono` VARCHAR(50))
BEGIN
	SELECT `suppliername`,`physicaladdress`,`postaladdress`,`town`,`postalcode`,s.mobile,s.email AS supplieremail,
	DATE_FORMAT(`date`,'%d-%b-%Y') orderdate,`purchaseorderno` orderno, 
	DATE_FORMAT(IFNULL(`expecteddate`,DATE_ADD(p.date, INTERVAL 7 DAY)),'%d-%b-%Y') expecteddate,`currencyname`,`terms`,
	CONCAT(firstname,' ',middlename,' ',lastname) preparedby
	FROM `purchaseorders` p, `currencies` c, suppliers s, `user` u
	WHERE p.`currencyid`=c.`id`  AND p.supplierid=s.supplierid AND u.id=p.addedby AND `purchaseorderno`=$pono;
	
    END $$

DROP PROCEDURE IF EXISTS `sp_getpoidfrompono` $$
CREATE PROCEDURE `sp_getpoidfrompono`(`$pono` VARCHAR(50))
BEGIN
	SELECT `id` poid 
	FROM `purchaseorders` 
	WHERE `purchaseorderno`=$pono;
    END $$

DROP PROCEDURE IF EXISTS `sp_getpoitems` $$
CREATE PROCEDURE `sp_getpoitems`(`$pono` VARCHAR(50))
BEGIN
	
	SELECT  i.`itemcode`,i.productid AS itemid, i.itemname, unitofmeasure uom, 
	pd.`quanity` quantity,pd.`unitprice`,pd.`taxinclusive`,a.`taxrate`, p.`taxid`, pd.quanity*pd.unitprice AS total,`taxname`
	FROM `purchaseorders` p, `purchaseorderdetails` pd, `products` i,`taxtypes` a
	WHERE p.`id`=pd.`purchaseorderid` AND pd.`itemcode`=i.`productid` AND p.`taxid`=a.id AND `purchaseorderno`=$pono
	ORDER BY itemname;
    END $$

DROP PROCEDURE IF EXISTS `sp_getposproductcategories` $$
CREATE PROCEDURE `sp_getposproductcategories`(`$posid` INT)
BEGIN
		SELECT `categoryid`,`categoryname`,
		(SELECT `poscategoryid` FROM `posproductcategories` WHERE `productcategoryid`=categoryid AND `posid`=$posid AND deleted=0) poscategoryid
		FROM `categories`
		ORDER BY `categoryname`; 
	END $$

DROP PROCEDURE IF EXISTS `sp_getposproductsbalancepivot` $$
CREATE PROCEDURE `sp_getposproductsbalancepivot`(`$startdate` DATE, `$enddate` DATE, `$posid` INT)
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
	END $$

DROP PROCEDURE IF EXISTS `sp_getproductpurchasessummary` $$
CREATE PROCEDURE `sp_getproductpurchasessummary`(`$startdate` DATE, `$enddate` DATE)
BEGIN
    
	SELECT p.`itemcode`,`itemname`,AVG(`unitprice`) unitprice, SUM(gd.`quantity`) quantity,SUM(gd.`quantity`*`unitprice`) total
	FROM `products` p, `purchaseorderdetails` pod, `purchaseorders` po, `goodsreceived` g, `goodsreceiveddetails` gd
	WHERE p.`productid`=pod.`itemcode` AND pod.`purchaseorderid`=po.`id` AND gd.`itemcode`=p.`productid` AND g.`grnno`=gd.`grnno` 
	AND gd.`purchaseorderno`=po.`purchaseorderno`
	AND DATE_FORMAT(po.`date`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	GROUP BY  p.`itemcode`,`itemname`
	ORDER BY itemname;
	
    END $$

DROP PROCEDURE IF EXISTS `sp_getproductsalessummary` $$
CREATE PROCEDURE `sp_getproductsalessummary`(`$startdate` DATE, `$enddate` DATE)
BEGIN
	SELECT p.`itemcode`,`itemname`,unitprice-discount unitprice, SUM(`quantity`) quantity, SUM(`quantity`*(`unitprice`-discount)) total
	FROM `products` p, `possales` s, `possalesdetails` sd
	WHERE p.`productid`=sd.`itemcode` AND sd.`possaleid`=s.`id` 
	AND DATE_FORMAT(s.`receiptdate`,'%Y-%m-%d') BETWEEN $startdate AND $enddate
	AND IFNULL(s.`deleted`,0)=0
	GROUP BY p.`itemcode`,`itemname`,unitprice-discount
	ORDER BY `itemname`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getpurchaseorderapprovallevelname` $$
CREATE PROCEDURE `sp_getpurchaseorderapprovallevelname`(`$hierarchy` INT)
BEGIN
	SELECT `description` FROM `purchaseorderapprovallevels` WHERE `hierarchy`=$hierarchy;
    END $$

DROP PROCEDURE IF EXISTS `sp_getpurchaseorderapprovallevels` $$
CREATE PROCEDURE `sp_getpurchaseorderapprovallevels`()
BEGIN
	SELECT * 
	FROM `purchaseorderapprovallevels` 
	ORDER BY `hierarchy`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getpurchaseorderapprovallevelstatus` $$
CREATE PROCEDURE `sp_getpurchaseorderapprovallevelstatus`(`$purchaseorderno` VARCHAR(50))
BEGIN
	SET @id=(SELECT id FROM `purchaseorders` WHERE `purchaseorderno`=$purchaseorderno);
	SELECT `id`,`description`,
	CASE WHEN EXISTS (SELECT * FROM `purchaseorderapproval` WHERE `poid`=@id AND `approvallevelid`=m.id) THEN 'Approved'  ELSE 'Pending' END `status`
	FROM `purchaseorderapprovallevels` m
	ORDER BY `hierarchy`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getpurchaseorderapprovalusers` $$
CREATE PROCEDURE `sp_getpurchaseorderapprovalusers`(`$purchaseorderno` VARCHAR(50), `$approvallevel` INT)
BEGIN
	SET @departmentid=(SELECT`departmentid` FROM `purchaseorders` WHERE `purchaseorderno`=$purchaseorderno);
	SELECT u.* FROM `user` u,`purchaseorderapprovalusers` a, `purchaseorderapprovallevels` l
	WHERE a.`userid`=u.`id` AND  a.`approvallevelid`=l.`id` AND l.`hierarchy`=$approvallevel AND a.`departmentid`=@departmentid;
    END $$

DROP PROCEDURE IF EXISTS `sp_getpurchaseorderapprovers` $$
CREATE PROCEDURE `sp_getpurchaseorderapprovers`(`$pono` VARCHAR(50))
BEGIN
	SELECT `description`,`hierarchy`,CONCAT(`firstname`,' ',`middlename`,' ',`lastname`)approvedby,signature,
	DATE_FORMAT(a.`approvaldate`,'%d-%b-%Y') approvaldate
	FROM `purchaseorderapproval` a,`purchaseorderapprovallevels` l, `user` u,  `purchaseorders` p
	WHERE a.`poid`=p.`id` AND a.`approvaluser`=u.id AND a.`approvallevelid`=l.`id` AND purchaseorderno=$pono
	ORDER BY `hierarchy`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getpurchaseordercurrentstatus` $$
CREATE PROCEDURE `sp_getpurchaseordercurrentstatus`(`$purchaseorderno` VARCHAR(50))
BEGIN
	SET @id=(SELECT id FROM `purchaseorders` WHERE `purchaseorderno`=$purchaseorderno);
	SELECT `fn_purchaseorderstatus`(@id) `status`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getpurchaseordernextapprovallevel` $$
CREATE PROCEDURE `sp_getpurchaseordernextapprovallevel`(`$purchaseorderno` VARCHAR(50))
BEGIN
	SET @purchaseorderid=(SELECT id FROM `purchaseorders` WHERE `purchaseorderno`=$purchaseorderno);
	SELECT a.`id`,`description`,`hierarchy`,IFNULL(s.`id`,0)`approved`
	FROM `purchaseorderapprovallevels` a
	LEFT OUTER JOIN `purchaseorderapproval` s
	ON a.`id`=s.`approvallevelid` AND `poid`=@purchaseorderid
	WHERE IFNULL(s.`id`,0)=0
	ORDER BY `hierarchy`
	LIMIT 1;
    END $$

DROP PROCEDURE IF EXISTS `sp_getquotationapprovers` $$
CREATE PROCEDURE `sp_getquotationapprovers`(`$quoteno` VARCHAR(50))
BEGIN
	SELECT `description`,`hierarchy`,CONCAT(`firstname`,' ',`middlename`,' ',`lastname`)approvedby,signature,
	DATE_FORMAT(a.`approvaldate`,'%d-%b-%Y') approvaldate
	FROM `quotationapproval` a,`quotationapprovallevels` l, `user` u,  `quotation` q
	WHERE a.`quoteid`=q.`id` AND a.`userid`=u.id AND a.`approvallevelid`=l.`id` AND quoteno=$quoteno
	ORDER BY `hierarchy`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getquotationdetails` $$
CREATE PROCEDURE `sp_getquotationdetails`(`$quotationno` VARCHAR(50))
BEGIN
	SELECT `quoteno`,DATE_FORMAT(`quotedate`,'%d-%b-%Y')quotedate,DATE_FORMAT(`expirydate`,'%d-%b-%Y')expirydate, 
	`customername`,CONCAT('P.O Box ',c.`postaladdress`) address, c.`mobile`,c.`email`,`terms`,
	`itemid`,`itemcode`,`itemname`,`quantity`,`unitprice`, CONCAT(`firstname`,' ',`middlename`,' ',`lastname`) servedby
	FROM `quotation` q, `quotationdetails` qd, `products` p, `customers` c, `user` u
	WHERE q.`id`=qd.`quoteid` AND q.`customerid`=c.`customerid` AND qd.`itemid`=p.`productid` AND u.id=q.addedby
	AND quoteno=$quotationno; 
    END $$

DROP PROCEDURE IF EXISTS `sp_getquotationheaderdetails` $$
CREATE PROCEDURE `sp_getquotationheaderdetails`(`$quoteno` VARCHAR(50))
BEGIN
	SELECT `customername`,`physicaladdress`,`postaladdress`,`town`,`postalcode`,c.`mobile`,c.`email`,`quoteno`,DATE_FORMAT(`quotedate`,'%d-%b-%Y') quotedate,
	DATE_FORMAT(DATE_ADD(`quotedate`, INTERVAL 7 DAY),'%d-%b-%Y') expirydate, terms,CONCAT(firstname,' ',middlename,' ',lastname) preparedby
	FROM `quotation` q, `customers` c, `user` u
	WHERE q.`customerid`=c.`customerid` AND q.`addedby`=u.id AND `quoteno`=$quoteno;
    END $$

DROP PROCEDURE IF EXISTS `sp_getquotationitems` $$
CREATE PROCEDURE `sp_getquotationitems`(`$quoteno` VARCHAR(50))
BEGIN
	SELECT `itemcode`,`itemname`,`unitofmeasure` uom,`quantity`,`unitprice`,
	CASE WHEN category='general' THEN `description` ELSE CONCAT(FORMAT(qd.`length`,0),' X ',FORMAT(qd.`width`,0),' X ',FORMAT(qd.`height`,0)) END description,
	`quantity`*`unitprice` total,'VAT' taxname,16 taxrate
	FROM `quotation` q, `quotationdetails` qd, `products`p
	WHERE q.`id`=qd.`quoteid` AND qd.`itemid`=p.`productid` AND `quoteno`=$quoteno
	ORDER BY `itemname`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getrawmaterialcategories` $$
CREATE PROCEDURE `sp_getrawmaterialcategories`()
BEGIN
	SELECT * 
	FROM `rawmaterialcategories` 
	ORDER BY `categoryname`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getrawmaterialdetails` $$
CREATE PROCEDURE `sp_getrawmaterialdetails`(`$materialid` INT)
BEGIN
	SELECT * 
	FROM `rawmaterials` 
	WHERE `materialid`=$materialid;
    END $$

DROP PROCEDURE IF EXISTS `sp_getrawmaterials` $$
CREATE PROCEDURE `sp_getrawmaterials`()
BEGIN
	SELECT * FROM `rawmaterials` 
	WHERE IFNULL(`deleted`,0)=0
	ORDER BY `materialname`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getrequisitionapprovallevelname` $$
CREATE PROCEDURE `sp_getrequisitionapprovallevelname`(`$hierarchy` INT)
BEGIN
	SELECT `description` FROM `materialrequestapprovallevels` WHERE `hierarchy`=$hierarchy;
    END $$

DROP PROCEDURE IF EXISTS `sp_getrequisitionapprovallevelstatus` $$
CREATE PROCEDURE `sp_getrequisitionapprovallevelstatus`(`$requisitionno` VARCHAR(50))
BEGIN
	SET @id=(SELECT id FROM `materialrequest` WHERE `requisitionno`=$requisitionno);
	SELECT `id`,`description`,
	CASE WHEN EXISTS (SELECT * FROM `materialrequestapproval` WHERE `materialrequestid`=@id AND `approvallevelid`=m.id) THEN 'Approved'  ELSE 'Pending' END `status`
	FROM `materialrequestapprovallevels` m
	ORDER BY `hierarchy`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getrequisitionapprovalusers` $$
CREATE PROCEDURE `sp_getrequisitionapprovalusers`(`$requisitionno` VARCHAR(50), `$approvallevel` INT)
BEGIN
	SET @departmentid=(SELECT`departmentid` FROM `materialrequest` WHERE `requisitionno`=$requisitionno);
	SELECT u.* FROM `user` u,`materialrequestapprovalusers` a, `materialrequestapprovallevels` l
	WHERE a.`userid`=u.`id` AND  a.`approvallevelid`=l.`id` AND l.`hierarchy`=$approvallevel AND a.`departmentid`=@departmentid;
    END $$

DROP PROCEDURE IF EXISTS `sp_getrequisitioncurrentstatus` $$
CREATE PROCEDURE `sp_getrequisitioncurrentstatus`(`$requisitionno` VARCHAR(50))
BEGIN
	SET @id=(SELECT id FROM `materialrequest` WHERE `requisitionno`=$requisitionno);
	SELECT `fn_requisitionstatus`(@id) `status`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getrequisitiondefaultnonpurchasesupplier` $$
CREATE PROCEDURE `sp_getrequisitiondefaultnonpurchasesupplier`()
BEGIN
	SELECT `defaultnonpurchasesupplier` 
	FROM `materialrequisitionsettings`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getrequisitionnextapprovallevel` $$
CREATE PROCEDURE `sp_getrequisitionnextapprovallevel`(`$requisitionno` VARCHAR(50))
BEGIN
	SET @requisitionid=(SELECT id FROM `materialrequest` WHERE `requisitionno`=$requisitionno);
	SELECT a.`id`,`description`,`hierarchy`,IFNULL(s.`id`,0)`approved`
	FROM `materialrequestapprovallevels` a
	LEFT OUTER JOIN `materialrequestapproval` s
	ON a.`id`=s.`approvallevelid` AND `materialrequestid`=@requisitionid
	WHERE IFNULL(s.`id`,0)=0
	ORDER BY `hierarchy`
	LIMIT 1;
    END $$

DROP PROCEDURE IF EXISTS `sp_getreturnableproducts` $$
CREATE PROCEDURE `sp_getreturnableproducts`()
BEGIN
		SELECT * FROM `products`
		WHERE `allowreturnexchange`=1
		ORDER BY `itemname`;
	END $$

DROP PROCEDURE IF EXISTS `sp_getsessioncollectionsummary` $$
CREATE PROCEDURE `sp_getsessioncollectionsummary`(`$sessionid` INT)
BEGIN
		SELECT 'Float' paymentmode, floatamount amount FROM `sessions`
		WHERE `sessionid`=$sessionid
		
		UNION
		
		SELECT `description` paymentmode, SUM(amount) amount
		FROM `possales` s 
		JOIN `possalespayments` m ON m.`possaleid`=s.`id`
		JOIN `paymentmethods` t ON t.`id`=m.`paymentmode`
		WHERE `sessionid`=$sessionid AND s.`deleted`=0
		GROUP BY paymentmode;
		
	END $$

DROP PROCEDURE IF EXISTS `sp_getsessions` $$
CREATE PROCEDURE `sp_getsessions`()
BEGIN
		SELECT s.*, CONCAT(o.firstname,' ',o.middlename,' ',o.lastname)openedby,
		IFNULL(CONCAT(c.firstname,' ',c.middlename,' ',c.lastname),'-')closedby
		FROM `sessions` s
		JOIN `user` o ON o.`id`=s.`addedby`
		LEFT OUTER JOIN `user` c ON c.id=s.`closedby`
		ORDER BY `sessionid` DESC;
	END $$

DROP PROCEDURE IF EXISTS `sp_getspoilagecategory` $$
CREATE PROCEDURE `sp_getspoilagecategory`()
BEGIN
	SELECT * FROM `spoilagecategory`
	ORDER BY `categoryname`;
    END $$

DROP PROCEDURE IF EXISTS `sp_getsubzones` $$
CREATE PROCEDURE `sp_getsubzones`(`$clientid` INT)
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
    END $$

DROP PROCEDURE IF EXISTS `sp_gettabledetails` $$
CREATE PROCEDURE `sp_gettabledetails`(`$tableid` INT)
BEGIN
		SELECT * FROM `tables`
		WHERE `tableid`=$tableid;
	END $$

DROP PROCEDURE IF EXISTS `sp_gettables` $$
CREATE PROCEDURE `sp_gettables`(`$posid` INT)
BEGIN
		IF $posid=0 THEN 
			SELECT t.*, posname,CONCAT(firstname,' ',middlename,' ',lastname) addedbyname
			FROM `tables` t 
			JOIN `pointsofsale` p ON p.`id`=t.posid
			JOIN `user` u ON u.id=t.addedby
			WHERE t.deleted=0
			ORDER BY posname,tablename;
		ELSE
			SELECT t.*, posname,CONCAT(firstname,' ',middlename,' ',lastname) addedbyname
			FROM `tables` t 
			JOIN `pointsofsale` p ON p.`id`=t.posid
			JOIN `user` u ON u.id=t.addedby
			WHERE t.deleted=0 AND t.posid=$posid
			ORDER BY tablename;
		
		END IF;
	END $$

DROP PROCEDURE IF EXISTS `sp_gettaxdetails` $$
CREATE PROCEDURE `sp_gettaxdetails`(IN $clientid INT, IN $taxid INT)
BEGIN
    SELECT * FROM `taxtypes` WHERE clientid = $clientid AND id = $taxid;
END $$

DROP PROCEDURE IF EXISTS `sp_gettransferreportbyitems` $$
CREATE PROCEDURE `sp_gettransferreportbyitems`(`$cat` VARCHAR(50), `$id` INT, `$startdate` DATE, `$enddate` DATE)
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
	ORDER BY p.itemname;
	
    END $$

DROP PROCEDURE IF EXISTS `sp_getunissuedepartmentrequisitions` $$
CREATE PROCEDURE `sp_getunissuedepartmentrequisitions`(`$departmentid` INT)
BEGIN
	SELECT DISTINCT requisitionid,requisitionno FROM `vw_requisitionitembalances` WHERE departmentid=$departmentid
	ORDER BY requisitionno;
    END $$

DROP PROCEDURE IF EXISTS `sp_getunissuedrequisitionitems` $$
CREATE PROCEDURE `sp_getunissuedrequisitionitems`(`$requisitionid` INT)
BEGIN
	SELECT * 
	FROM `vw_requisitionitembalances` WHERE requisitionid=$requisitionid
	ORDER BY itemname;
    END $$

DROP PROCEDURE IF EXISTS `sp_getuserpurchaseorderapprovalprivileges` $$
CREATE PROCEDURE `sp_getuserpurchaseorderapprovalprivileges`(`$userid` INT)
BEGIN
	SELECT * 
	FROM `purchaseorderapprovalusers` 
	WHERE `userid`=$userid AND IFNULL(valid,0)=1;
    END $$

DROP PROCEDURE IF EXISTS `sp_getuserrequisitionapprovalprivileges` $$
CREATE PROCEDURE `sp_getuserrequisitionapprovalprivileges`(`$userid` INT)
BEGIN
	SELECT * 
	FROM `materialrequestapprovalusers` 
	WHERE `userid`=$userid AND IFNULL(valid,0)=1;
    END $$

DROP PROCEDURE IF EXISTS `sp_getuserswithprivilege` $$
CREATE PROCEDURE `sp_getuserswithprivilege`(`$objectid` INT)
BEGIN
	SELECT * FROM `user` WHERE id IN(SELECT userid FROM `userprivileges` WHERE `objectid`=$objectid AND `allowed`=1)
	OR id IN(SELECT `userid` FROM `roleusers`  r, `roleprivileges` p WHERE r.`roleid`=p.`roleid` AND p.`objectid`=$objectid AND `allowed`=1);
	
    END $$

DROP PROCEDURE IF EXISTS `sp_getwarehousestocksummaryasat` $$
CREATE PROCEDURE `sp_getwarehousestocksummaryasat`(`$warehouseid` INT, `$asat` DATE)
BEGIN
		SET @openingbalancedate=DATE_ADD($asat, INTERVAL -1 DAY);
		SET @basedate=DATE(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters`),CURDATE())); 
		
		SELECT p.itemcode,itemname,buyingprice,sellingprice,
		`fn_getwarehousestockbalance`(productid,$warehouseid,@openingbalancedate) openingbalance,
		-- Purchases
		IFNULL(
			(SELECT SUM(quantity) FROM goodsreceived g JOIN  goodsreceiveddetails gd ON gd.grnno=g.grnno 
		WHERE gd.itemcode=p.productid AND DATE(datereceived)=$asat AND warehouseid=$warehouseid),0) +
		-- Add Transfers in $IFNULL((SELECT SUM(`quantity`) FROM `stocktransfer` s JOIN `stocktransferdetails` sd ON sd.`transferid`=s.id AND sd.`itemcode`=productid 
		WHERE  `destinationtype`='warehouse' AND `destinationid`=$warehouseid AND DATE(`dateadded`)=$asat),0) received,
		-- Generate Issues
		IFNULL((SELECT SUM(`quantity`) FROM `stocktransfer` s JOIN `stocktransferdetails` sd ON sd.`transferid`=s.id AND sd.`itemcode`=productid 
		WHERE  `sourcetype`='warehouse' AND `sourceid`=$warehouseid AND DATE(`dateadded`)=$asat),0) issued
		FROM `products` p 
		GROUP BY p.productid
		ORDER BY itemname;
	END $$

DROP PROCEDURE IF EXISTS `sp_getwarehousingproductsbalancepivot` $$
CREATE PROCEDURE `sp_getwarehousingproductsbalancepivot`(`$startdate` DATE, `$enddate` DATE, `$warehouseid` INT)
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
	END $$

DROP PROCEDURE IF EXISTS `sp_getzonedetails` $$
CREATE PROCEDURE `sp_getzonedetails`(`$id` INT)
BEGIN
	SELECT * FROM `zones` WHERE `id`=$id;
    END $$

DROP PROCEDURE IF EXISTS `sp_getzonesandsubzones` $$
CREATE PROCEDURE `sp_getzonesandsubzones`()
BEGIN
	SELECT s.id subzoneid,s.zonename subzonename, p.zonename zonename, p.id zoneid
	FROM `zones` s, `zones` p
	WHERE s.`parent`=p.id  AND IFNULL(s.`deleted`,0)=0
	ORDER BY zonename,subzonename;
    END $$

DROP PROCEDURE IF EXISTS `sp_refundproducts` $$
CREATE PROCEDURE `sp_refundproducts`(`$receiptno` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci, `$reason` VARCHAR(1000), `$refno` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci, `$userid` INT)
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
	END $$

DROP PROCEDURE IF EXISTS `sp_resetuserpin` $$
CREATE PROCEDURE `sp_resetuserpin`(`$clientid` INT, `$pin` VARCHAR(100), `$salt` VARCHAR(50))
BEGIN
		UPDATE `user`
		SET `pin`=$pin, `pinsalt`=$salt
		WHERE id=$clientid;
	END $$

DROP PROCEDURE IF EXISTS `sp_savecustomercontact` $$
CREATE PROCEDURE `sp_savecustomercontact`(`$id` INT, `$customerid` INT, `$categoryid` INT, `$contactname` VARCHAR(100), `$mobile` VARCHAR(100), `$email` VARCHAR(100), `$clientid` INT)
BEGIN
	IF $id=0 THEN 
		INSERT INTO `customercontacts`(`customerid`,`categoryid`,`contactname`,`mobile`,`email`,`dateadded`,`addedby`)
		VALUES($customerid,$categoryid,$contactname,$mobile,$email,NOW(),$clientid);
	ELSE
		UPDATE `customercontacts` 
		SET `categoryid`=$categoryid, `contactname`=$contactname, `mobile`=$mobile, `email`=$email,`customerid`=$customerid
		WHERE `id`=$id;	 
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `sp_savecustomerorder` $$
CREATE PROCEDURE `sp_savecustomerorder`(`$refno` VARCHAR(50), `$posid` INT, `$customerid` INT, `$tableid` INT, `$userid` INT)
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
	END $$

DROP PROCEDURE IF EXISTS `sp_savedepartment` $$
CREATE PROCEDURE `sp_savedepartment`(`$id` INT, `$departmentname` VARCHAR(50), `$clientid` INT, `$hodid` INT)
BEGIN
	IF $id=0 THEN 
		INSERT INTO `departments`(`departmentname`,`dateadded`,`addedby`, `hodid`)
		VALUES($departmentname,NOW(),$clientid,$hodid);
	ELSE
		UPDATE `departments` 
		SET `departmentname`=$departmentname , `hodid`=$hodid
		WHERE `id`=$id;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `sp_saveemailconfiguration` $$
CREATE PROCEDURE `sp_saveemailconfiguration`(`$emailaddress` VARCHAR(100), `$emailpassword` VARCHAR(50), `$smtpserver` VARCHAR(50), `$smtpport` INT, `$usessl` BOOLEAN)
BEGIN
	IF NOT EXISTS(SELECT * FROM `emailconfiguration`) THEN
		INSERT INTO `emailconfiguration`(`emailaddress`,`password`,`smtpserver`,`usessl`,`smtpport`)
		VALUES($emailaddress,$emailpassword,$smtpserver,$usessl,$smtpport);
	ELSE
		UPDATE `emailconfiguration` 
		SET `emailaddress`=$emailaddress,`password`=$emailpassword,`smtpserver`=$smtpserver,`usessl`=$usessl,`smtpport`=$smtpport;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `sp_savefleetfuelrequisition` $$
CREATE PROCEDURE `sp_savefleetfuelrequisition`(`$id` INT, `$supplierid` INT, `$costcenterid` INT, `$vehicleid` INT, `$requestedby` INT, `$approvedby` INT, `$quantity` DECIMAL(18, $2), `$unitprice` DECIMAL(18,2), `$odoreading` INT, `$userid` INT)
BEGIN
	IF $id=0 THEN 
		-- Generate the Requisition number
		SET @requisitionno=fn_generaterequisitionno();
		START TRANSACTION;
			INSERT INTO `fleetfuelrequisition`(`vehicleid`,`requisitionno`,`odoreading`,`costcenterid`,`supplierid`,`quantity`,`unitprice`,`dateadded`,`addedby`,`approvedby`,`requestedby`)
			VALUES($vehicleid,@requisitionno,$odoreading,$costcenterid,$supplierid,$quantity,$unitprice,NOW(),$userid,$approvedby,$requestedby);
			-- Increment requisition number counter generator
			UPDATE serials SET currentno=currentno+1 WHERE `documenttype`='Requisition Number';
		COMMIT;
	ELSE	
		UPDATE `fleetfuelrequisition` SET `vehicleid`=$vehicleid, `odoreading`=$odoreading, `costcenterid`=$costcenterid, `supplierid`=$supplierid,
		`quantity`=$quantity,`unitprice`=$unitprice,`requestedby`=$requestedby, `approvedby`=$approvedby
		WHERE `id`=$id;
		SET @requisitionno=(SELECT `requisitionno` FROM `fleetfuelrequisition` WHERE `id`=$id);
	END IF;
	SELECT @requisitionno AS requisitionno;
    END $$

DROP PROCEDURE IF EXISTS `sp_savefleetvehicle` $$
CREATE PROCEDURE `sp_savefleetvehicle`(`$vehicleid` INT, `$regno` VARCHAR(50), `$bodytypeid` INT, `$fueltypeid` INT, `$enginerating` INT, `$clientid` INT)
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
	
    END $$

DROP PROCEDURE IF EXISTS `sp_saveinstitutiondetails` $$
CREATE PROCEDURE `sp_saveinstitutiondetails`(IN $clientid INT, IN $companyname VARCHAR(50),
    IN $physicaladdress VARCHAR(100),
    IN $postaladdress VARCHAR(100),
    IN $landline VARCHAR(50),
    IN $email VARCHAR(50),
    IN $mobile VARCHAR(50),
    IN $pinno VARCHAR(50),
    IN $autoinvoicegrn TINYINT,
    IN $postalcode VARCHAR(50),
    IN $tagline VARCHAR(1000),
    IN $website VARCHAR(100),
    IN $receiptfooter VARCHAR(4000),
    IN $defaultcustomer INT,
    IN $mainbusinesstype VARCHAR(50),
    IN $logo VARCHAR(1000),
    IN $town VARCHAR(50)
)
BEGIN
    IF EXISTS (SELECT * FROM institution WHERE $clientid = clientid) THEN
        UPDATE institution SET
            name = $companyname,
            physicaladdress = $physicaladdress,
            postaladdress = $postaladdress,
            landline = $landline,
            email = $email,
            mobile = $mobile,
            pinno = $pinno,
            autoaddinvoiceduringgrn = $autoinvoicegrn,
            postalcode = $postalcode,
            tagline = $tagline,
            website = $website,
            receiptfooter = $receiptfooter,
            defaultcustomerid = $defaultcustomer,
            mainbusinesstype = $mainbusinesstype,
            logo = $logo,
            town = $town
        WHERE clientid = $clientid;
    ELSE
        INSERT INTO institution (
            clientid, name, physicaladdress, postaladdress, landline, email, mobile, pinno,
            autoaddinvoiceduringgrn, postalcode, tagline, website, receiptfooter,
            defaultcustomerid, mainbusinesstype, logo, town
        ) VALUES (
            clientid, $companyname, $physicaladdress, $postaladdress, $landline, $email, $mobile, $pinno,
            $autoinvoicegrn, $postalcode, $tagline, $website, $receiptfooter,
            $defaultcustomer, $mainbusinesstype, $logo, $town
        );
    END IF;
END $$

DROP PROCEDURE IF EXISTS `sp_savematerialrequisition` $$
CREATE PROCEDURE `sp_savematerialrequisition`(`$id` INT, `$refno` VARCHAR(50), `$materialusecase` INT, `$reference` VARCHAR(50), `$narration` VARCHAR(5000), `$scope` VARCHAR(50), `$supplierid` INT, `$activityid` INT, `$departmentid` INT, `$userid` INT, `$purchaserequisition` BOOL)
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
    END $$

DROP PROCEDURE IF EXISTS `sp_savematerialsreceived` $$
CREATE PROCEDURE `sp_savematerialsreceived`(`$refno` VARCHAR(50), `$source` VARCHAR(50), `$reference` VARCHAR(50), `$userid` INT, `$inspectedby` INT, `$materialusecaseid` INT, `$projectid` INT, `$deliveredby` VARCHAR(50), `$sourceid` INT, `$warehouseid` INT)
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
    END $$

DROP PROCEDURE IF EXISTS `sp_saveposproductcategory` $$
CREATE PROCEDURE `sp_saveposproductcategory`(`$posid` INT, `$productcategoryid` INT, `$categorystatus` BOOL, `$userid` INT)
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
	END $$

DROP PROCEDURE IF EXISTS `sp_savepurchaseorderprivilege` $$
CREATE PROCEDURE `sp_savepurchaseorderprivilege`(`$userid` INT, `$approvallevelid` INT, `$departmentid` INT, `$valid` BOOLEAN, `$addedby` INT)
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
		
    END $$

DROP PROCEDURE IF EXISTS `sp_savequotation` $$
CREATE PROCEDURE `sp_savequotation`(`$id` INT, `$refno` VARCHAR(50), `$customerid` INT, `$terms` VARCHAR(1000), `$category` VARCHAR(50), `$userid` INT)
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
    END $$

DROP PROCEDURE IF EXISTS `sp_saverawmaterial` $$
CREATE PROCEDURE `sp_saverawmaterial`(`$materialid` INT, `$categoryid` INT, `$materialname` VARCHAR(50), `$uom` VARCHAR(50), `$physicalproduct` BOOL, `$unitprice` DECIMAL(18,2), `$itemcode` VARCHAR(50), `$generateitemcode` BOOL, `$clientid` INT)
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
    END $$

DROP PROCEDURE IF EXISTS `sp_saverequisitionprivilege` $$
CREATE PROCEDURE `sp_saverequisitionprivilege`(`$userid` INT, `$approvallevelid` INT, `$departmentid` INT, `$valid` BOOLEAN, `$addedby` INT)
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
		
    END $$

DROP PROCEDURE IF EXISTS `sp_savereturns` $$
CREATE PROCEDURE `sp_savereturns`(`$outletid` INT, `$warehouseid` INT, `$paymentmodeid` INT, `$reference` VARCHAR(100), `$jsondata` JSON, `$returneditems` JSON, `$userid` INT)
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
		
	END $$

DROP PROCEDURE IF EXISTS `sp_savespoilage` $$
CREATE PROCEDURE `sp_savespoilage`(`$id` INT, `$categoryid` INT, `$productid` INT, `$quantity` NUMERIC(18, $2), `$narration` VARCHAR(1000), `$storecategory` VARCHAR(50), `$storeid` INT, `$userid` INT)
BEGIN
	IF $id=0 THEN
		INSERT INTO `spoilage`(`categoryid`,`productid`,`quantity`,`narration`,`storecategory`,`storeid`,`dateadded`,`addedby`)
		VALUES($categoryid,$productid,$quantity,$narration,$storecategory,$storeid,NOW(),$userid);
	ELSE
		UPDATE `spoilage` SET `categoryid`=$categoryid,`productid`=$productid,`quantity`=$quantity,`narration`=$narration,
		`storecategory`=$storecategory,`storeid`=$storeid
		WHERE `id`=$id;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `sp_savetable` $$
CREATE PROCEDURE `sp_savetable`(`$tableid` INT, `$posid` INT, `$tablename` VARCHAR(50), `$userid` INT)
BEGIN
		IF $tableid=0 THEN 
			INSERT INTO `tables`(`posid`,`tablename`,`dateadded`,`addedby`)
			VALUES($posid,$tablename,NOW(),$userid);
		ELSE
			UPDATE `tables`
			SET `tablename`=$tablename, `posid`=$posid
			WHERE `tableid`=$tableid;
		END IF;
	END $$

DROP PROCEDURE IF EXISTS `sp_savetempcustomerorderdetail` $$
CREATE PROCEDURE `sp_savetempcustomerorderdetail`(`$refno` VARCHAR(50), `$productid` INT, `$quantity` DECIMAL(5,2), `$unitprice` DECIMAL(7,2))
BEGIN
		INSERT INTO `temcustomerorderdetails`(`refno`,`productid`,`quantity`,`unitprice`)
		VALUES($refno,$productid,$quantity,$unitprice);
	END $$

DROP PROCEDURE IF EXISTS `sp_savetemporderstosettle` $$
CREATE PROCEDURE `sp_savetemporderstosettle`(`$refno` VARCHAR(50), `$orderid` INT)
BEGIN
		INSERT INTO `temporderstosettle`(`refno`,`orderid`)
		VALUES($refno,$orderid);
	END $$

DROP PROCEDURE IF EXISTS `sp_savetempquotation` $$
CREATE PROCEDURE `sp_savetempquotation`(`$refno` VARCHAR(50), `$itemid` INT, `$description` VARCHAR(500), `$quantity` DECIMAL(18,2), `$unitprice` DECIMAL(18,2), `$ilength` DECIMAL(18,2), `$width` DECIMAL(18,2), `$height` DECIMAL(18,2), `$gsm` DECIMAL(18,2), `$weight` DECIMAL(18,4), `$plies` DECIMAL(18,2), `$jointallowance` DECIMAL(18,2), `$trimallowance` DECIMAL(18,2), `$profitmargin` DECIMAL(18,2), `$printing` DECIMAL(18,2), `$freight` DECIMAL(18,2), `$waste` DECIMAL(18,2), `$flutefactor` DECIMAL(18,2))
BEGIN
	INSERT INTO `tempquotationdetails`(`refno`,`itemid`,`quantity`,`unitprice`,`description`,`length`,`width`,`height`,`gsm`,
		`weight`,`plies`,`jointallowance`,`trimallowance`,`profitmargin`,`printing`,`freight`,`waste`,`flutefactor`)
	VALUES($refno,$itemid,$quantity,$unitprice,$description,$ilength,$width,$height,$gsm,$weight,$plies,$jointallowance,
		$trimallowance,$profitmargin,$printing,$freight,$waste,$flutefactor);
    END $$

DROP PROCEDURE IF EXISTS `sp_savetemprefundedproducts` $$
CREATE PROCEDURE `sp_savetemprefundedproducts`(`$refno` VARCHAR(50), `$itemcode` VARCHAR(50), `$quantity` DECIMAL(18,2))
BEGIN
		DECLARE $productid INT;
		
		SELECT productid 
		INTO $productid FROM `products` 
		WHERE `itemcode`=$itemcode;
		
		INSERT INTO `temprefundedproducts`(`refno`,`itemcode`,`quantity`)
		VALUES($refno,$productid,$quantity);
	END $$

DROP PROCEDURE IF EXISTS `sp_saveuser` $$
CREATE PROCEDURE `sp_saveuser`(IN $clientid INT, IN $userid INT, IN $userpassword VARCHAR(100),
    IN $salt VARCHAR(50),
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
            clientid, username, password, salt, firstname, middlename, lastname, email, mobile, 
            changepasswordonlogon, accountactive, addedby, dateadded, systemadmin, pin, pinsalt
        ) VALUES (
            clientid, $username, $userpassword, $salt, $firstname, $middlename, $lastname, $email, $mobile, 
            $changepasswordonlogon, $accountactive, $addedby, NOW(), $systemadmin, $pin, $pinsalt
        );
        SET $userid = LAST_INSERT_ID();
    ELSE
        UPDATE `user` SET 
            username = $username, 
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
        WHERE clientid = $clientid AND userid = $userid;
    END IF;
    
    SELECT $userid AS userid;
END $$

DROP PROCEDURE IF EXISTS `sp_saveuserprofilephoto` $$
CREATE PROCEDURE `sp_saveuserprofilephoto`(`$clientid` INT, `$documentname` VARCHAR(1000))
BEGIN
	UPDATE `user` SET `profilephoto`=$documentname WHERE `id`=$clientid;
    END $$

DROP PROCEDURE IF EXISTS `sp_saveusersignature` $$
CREATE PROCEDURE `sp_saveusersignature`(`$clientid` INT, `$documentname` VARCHAR(1000))
BEGIN
	UPDATE `user` SET `signature`=$documentname WHERE `id`=$clientid;
    END $$

DROP PROCEDURE IF EXISTS `sp_savezone` $$
CREATE PROCEDURE `sp_savezone`(`$id` INT, `$zonename` VARCHAR(50), `$clientid` INT, `$clientid` INT)
BEGIN
	IF $id=0 THEN
		INSERT INTO `zones`(`zonename`,`dateadded`,`addedby`,`deleted`,`parent`)
		VALUES($zonename,NOW(),$clientid,0,$clientid);
	ELSE	
		UPDATE `zones` SET `zonename`=$zonename, `parent`=$clientid WHERE `id`=$id;
	END IF;
    END $$

DROP PROCEDURE IF EXISTS `sp_settleorderpayments` $$
CREATE PROCEDURE `sp_settleorderpayments`(`$refno` VARCHAR(50), `$userid` INT)
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
		
	END $$

DROP PROCEDURE IF EXISTS `sp_subzones` $$
CREATE PROCEDURE `sp_subzones`(`$clientid` INT)
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
    END $$

DROP PROCEDURE IF EXISTS `sp_validatepurchaseorderapproval` $$
CREATE PROCEDURE `sp_validatepurchaseorderapproval`(`$clientid` INT, `$approvallevel` INT, `$departmentid` INT)
BEGIN
	DECLARE $admin INT DEFAULT 0;
	DECLARE $valid INT DEFAULT 0;
	SET $admin=(SELECT systemadmin FROM `user` WHERE `id`=$clientid);
	IF $admin=1 THEN
		SET $valid=1;
	ELSE
		IF $approvallevel=0 THEN 
			IF EXISTS(SELECT `valid` FROM `purchaseorderapprovalusers` WHERE `userid`=$clientid AND departmentid=$departmentid AND valid=1) THEN
				SET $valid=1;
			END IF;
		ELSE
			SET $valid=IFNULL((SELECT `valid` FROM `purchaseorderapprovalusers` WHERE `userid`=$clientid AND departmentid=$departmentid AND `approvallevelid`=$approvallevel AND valid=1),0);
		END IF;
	END IF;
	
	SELECT $valid AS `allowed`;
    END $$

DROP PROCEDURE IF EXISTS `sp_validaterequisitionapproval` $$
CREATE PROCEDURE `sp_validaterequisitionapproval`(`$clientid` INT, `$approvallevel` INT, `$departmentid` INT)
BEGIN
	DECLARE $admin INT DEFAULT 0;
	DECLARE $valid INT DEFAULT 0;
	SET $admin=(SELECT systemadmin FROM `user` WHERE `id`=$clientid);
	IF $admin=1 THEN
		SET $valid=1;
	ELSE
		IF $approvallevel=0 THEN 
			IF EXISTS(SELECT `valid` FROM `materialrequestapprovalusers` WHERE `userid`=$clientid AND departmentid=$departmentid AND valid=1) THEN
				SET $valid=1;
			END IF;
		ELSE
			SET $valid=IFNULL((SELECT `valid` FROM `materialrequestapprovalusers` WHERE `userid`=$clientid AND departmentid=$departmentid AND `approvallevelid`=$approvallevel AND valid=1),0);
		END IF;
	END IF;
	
	SELECT $valid AS `allowed`;
	
	
	
    END $$

DROP PROCEDURE IF EXISTS `sp_validateuserprivilege` $$
CREATE PROCEDURE `sp_validateuserprivilege`(`$clientid` INT, `$objectid` INT)
BEGIN
	DECLARE $admin INT;
	DECLARE $valid INT DEFAULT 0;
	SET $admin=(SELECT systemadmin FROM `user` WHERE `id`=$clientid);
	IF $admin=1 THEN
		SET $valid=1;
	ELSE
		SET $valid=IFNULL((SELECT `allowed` FROM `userprivileges` WHERE `userid`=$clientid AND `objectid`=$objectid),0);
	END IF;
	
	SELECT $valid AS `allowed`;
	
    END $$

DELIMITER ;



