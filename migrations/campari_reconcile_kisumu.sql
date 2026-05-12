SET @userid=5;
-- Warehouse Lavendar
SET @warehouseid=14;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Warehouse POS -Lavender #`,0)quantity,`unitprice` FROM `campari_reconciled_stock_kisumu`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Phoustine
SET @warehouseid=20;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Route 1: Phoustine`,0)quantity,`unitprice` FROM `campari_reconciled_stock_kisumu`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Promotions
SET @warehouseid=25
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`PROMOTIONS`,0)quantity,`unitprice` FROM `campari_reconciled_stock_kisumu`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Town Service
SET @warehouseid=27;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Town Service: Alfred`,0)quantity,`unitprice` FROM `campari_reconciled_stock_kisumu`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);


-- Bondo Warehouse
SET @warehouseid=21;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Bondo Main Warehouse`,0)quantity,`unitprice` FROM `campari_reconciled_stock_kisumu`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);


-- Main Warehouse
SET @warehouseid=1;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Main Warehouse`,0)quantity,`unitprice` FROM `campari_reconciled_stock_kisumu`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'warehouse',@userid);

-- KWAL Warehouse
SET @warehouseid=2;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`KWAL WAREHOUSE`,0)quantity,`unitprice` FROM `campari_reconciled_stock_kisumu`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'warehouse',@userid);
