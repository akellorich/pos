-- Standardize Dashboard Headers and Views for Multi-Tenant Branch Reporting
-- This script updates vwopenpayables, vwopenorders and spgetdashboardheaders

-- 1. Update vwopenpayables to include branchid
DROP VIEW IF EXISTS vwopenpayables;
CREATE VIEW `vwopenpayables` AS 
select 
    si.branchid,
    si.supplierid,
    si.invoiceno,
    si.invoicedate,
    si.status,
    SUM(sid.quantity * sid.unitprice) AS invoiceamount,
    IFNULL((
        SELECT SUM(pd.quantity * pd.unitprice) 
        FROM paymentvouchers p 
        JOIN paymentvoucherdetails pd ON p.paymentvoucherid = pd.voucherid 
        WHERE pd.invoicenumber = si.invoiceno 
        AND p.branchid = si.branchid
    ), 0) AS settled 
from supplierinvoice si 
join supplierinvoicedetails sid on si.supplierinvoiceid = sid.invoiceid 
where DATE(si.invoicedate) >= (select DATE(cutoffdate) from startingparameters limit 1)
group by si.branchid, si.supplierid, si.invoiceno, si.invoicedate, si.status
having SUM(sid.quantity * sid.unitprice) > IFNULL((
    SELECT SUM(pd.quantity * pd.unitprice) 
    FROM paymentvouchers p 
    JOIN paymentvoucherdetails pd ON p.paymentvoucherid = pd.voucherid 
    WHERE pd.invoicenumber = si.invoiceno 
    AND p.branchid = si.branchid
), 0);

-- 2. Update vwopenorders to include branchid
DROP VIEW IF EXISTS vwopenorders;
CREATE VIEW `vwopenorders` AS 
select 
    p.branchid,
    p.purchaseorderno,
    p.date,
    p.supplierid,
    pd.itemcode,
    pd.quanity as quantity,
    IFNULL((
        SELECT SUM(gd.quantity) 
        FROM goodsreceived g 
        JOIN goodsreceiveddetails gd ON g.grnno = gd.grnno 
        WHERE gd.itemcode = pd.itemcode 
        AND g.branchid = p.branchid
    ), 0) AS received 
from purchaseorders p 
join purchaseorderdetails pd on p.purchaseorderid = pd.purchaseorderid
where pd.quanity > IFNULL((
    SELECT SUM(gd.quantity) 
    FROM goodsreceived g 
    JOIN goodsreceiveddetails gd ON g.grnno = gd.grnno 
    WHERE gd.itemcode = pd.itemcode 
    AND g.branchid = p.branchid
), 0);

-- 3. Update spgetdashboardheaders to correctly filter by branchid
DROP PROCEDURE IF EXISTS spgetdashboardheaders;
DELIMITER //
CREATE PROCEDURE `spgetdashboardheaders`(IN $branchid INT, IN $date DATE)
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM customers WHERE branchid = $branchid) AS activecustomers,
        (SELECT IFNULL(SUM(invoiceamount - invoicepayment), 0) FROM vwcustomerstomerstatement WHERE branchid = $branchid) AS openreceivables,
        (SELECT IFNULL(SUM(invoiceamount - settled), 0) FROM vwopenpayables WHERE branchid = $branchid) AS openpayables,
        (SELECT COUNT(DISTINCT purchaseorderno) FROM vwopenorders WHERE branchid = $branchid) AS openorders;
END //
DELIMITER ;
