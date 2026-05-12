
SET @userid=5;
-- Lucky
SET @warehouseid=8;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Lucky`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Joshua
SET @warehouseid=10;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Joshua#`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);


-- Warehouse POS Westend
SET @refno=UCASE(LEFT(UUID(),8));
SET @warehouseid=14;
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Warehousepos1 (Westend)`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- jacob
SET @warehouseid=18;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Jacob#`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Deliveries
SET @warehouseid=20;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Deliveries`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Jacob Jared
SET @warehouseid=21;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Jacob&Jared`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Direcror's Motor Vehicle
SET @warehouseid=22;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Directors" Motor Vehicle`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Jared DL
SET @warehouseid=23;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Jared DL`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Nancy Kwal
SET @warehouseid=24;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Nancy-Kwal`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Kisumu
SET @warehouseid=25;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Kisumu Outlet`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Stephen
SET @warehouseid=26;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Steven#`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Route 2 Terry
SET @warehouseid=28;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Route 2 -Terry`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Dorothy
SET @warehouseid=27;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Dorothy`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Michael
SET @warehouseid=29;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Michael#`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'outlet',@userid);

-- Main Warehouse
SET @warehouseid=1;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`Main Warehouse`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'warehouse',@userid);

-- KWAL Warehouse
SET @warehouseid=2;
SET @refno=UCASE(LEFT(UUID(),8));
INSERT INTO `tempstockreconcilebalancedetails`(`refno`,`itemid`,`quantity`,`unitprice`)
SELECT @refno,`Productid`,IFNULL(`KWAL WAREHOUSE`,0)quantity,`unitprice` FROM `campari_reconciled_stock`;
CALL `spsavestockreconciledbalance`(@refno,'Balance BF as at 01-Apr-2025',@warehouseid,'warehouse',@userid);
