-- Fix supplier statement view and underlying tables for multi-tenancy
-- 1. Standardize tables with clientid and correct primary keys
ALTER TABLE supplierinvoice ADD COLUMN clientid INT DEFAULT 1 AFTER supplierinvoiceid, ADD INDEX (clientid);
ALTER TABLE supplierinvoicedetails ADD COLUMN clientid INT DEFAULT 1 AFTER id, ADD INDEX (clientid);
ALTER TABLE paymentvouchers ADD COLUMN clientid INT DEFAULT 1 AFTER paymentvoucherid, ADD INDEX (clientid);
ALTER TABLE paymentvoucherdetails ADD COLUMN clientid INT DEFAULT 1 AFTER id, ADD INDEX (clientid);

-- 2. Re-create the view with corrected column names and clientid support
DROP VIEW IF EXISTS vwsupplierstatement;
CREATE VIEW vwsupplierstatement AS 
SELECT 
    s.clientid,
    s.supplierid,
    s.suppliername,
    s.physicaladdress,
    s.postaladdress,
    s.mobile,
    s.email,
    si.invoicedate,
    si.invoiceno AS reference,
    'Invoice received' AS narrative,
    SUM(sid.quantity * sid.unitprice) AS invoiceamount,
    0 AS invoicepayment,
    0 AS `order` 
FROM suppliers s 
JOIN supplierinvoice si ON s.supplierid = si.supplierid AND s.clientid = si.clientid
JOIN supplierinvoicedetails sid ON si.supplierinvoiceid = sid.invoiceid AND si.clientid = sid.clientid
WHERE si.status <> 'Cancelled'
GROUP BY s.clientid, s.supplierid, s.suppliername, s.physicaladdress, s.postaladdress, s.mobile, s.email, si.invoicedate, si.invoiceno

UNION ALL

SELECT 
    s.clientid,
    s.supplierid,
    s.suppliername,
    s.physicaladdress,
    s.postaladdress,
    s.mobile,
    s.email,
    p.date AS invoicedate,
    p.voucherno AS reference,
    CONCAT('Payment issued via reference #', p.referenceno) AS narrative,
    0 AS invoiceamount,
    SUM(pd.quantity * pd.unitprice) AS invoicepayment,
    1 AS `order` 
FROM suppliers s 
JOIN paymentvouchers p ON s.supplierid = p.supplier AND s.clientid = p.clientid
JOIN paymentvoucherdetails pd ON p.paymentvoucherid = pd.voucherid AND p.clientid = pd.clientid
WHERE p.status <> 'Cancelled'
GROUP BY s.clientid, s.supplierid, s.suppliername, s.physicaladdress, s.postaladdress, s.mobile, s.email, p.date, p.voucherno, p.referenceno;

-- 3. Update the function for opening balance
DELIMITER //

DROP FUNCTION IF EXISTS fngetsupplieropeningbalance //
CREATE FUNCTION fngetsupplieropeningbalance(
    $clientid INT,
    $supplierid INT, 
    $startdate DATETIME
) RETURNS DECIMAL(18,2)
DETERMINISTIC
BEGIN
    DECLARE $openingbalance DECIMAL(18,2);
    DECLARE $cutoffdate DATETIME;
    
    SET $cutoffdate = DATE_FORMAT(IFNULL((SELECT cutoffdate FROM startingparameters WHERE clientid = $clientid), NOW()), '%Y-%m-%d');
    
    IF $cutoffdate > $startdate THEN
        SET $startdate = $cutoffdate;
    END IF;
    
    SET $startdate = DATE_SUB($startdate, INTERVAL 1 DAY);
    
    SET $openingbalance = (SELECT SUM(invoiceamount - invoicepayment) FROM vwsupplierstatement o 
    WHERE o.clientid = $clientid AND o.supplierid = $supplierid AND DATE_FORMAT(invoicedate, '%Y-%m-%d') BETWEEN $cutoffdate AND $startdate);
    
    RETURN IFNULL($openingbalance, 0);
END //

-- 4. Update the procedure to accept clientid
DROP PROCEDURE IF EXISTS spgetsupplierstatement //
CREATE PROCEDURE spgetsupplierstatement(
    IN $clientid INT,
    IN $supplierid INT, 
    IN $startdate DATETIME, 
    IN $enddate DATETIME
)
BEGIN
    SET @cutoffdate = DATE_FORMAT(IFNULL((SELECT cutoffdate FROM startingparameters WHERE clientid = $clientid), NOW()), '%Y-%m-%d');
    
    IF $startdate < @cutoffdate THEN 
        SET $startdate = @cutoffdate;
    END IF;
    
    SET @openingbalancedate = DATE_SUB($startdate, INTERVAL 1 DAY);
    
    SELECT 
        s.supplierid, s.suppliername, s.physicaladdress, s.postaladdress, s.mobile, s.email,
        DATE_FORMAT(v.invoicedate, '%d-%b-%Y') AS `date`, 
        fngetsupplieropeningbalance($clientid, $supplierid, $startdate) AS openingbalance,
        IFNULL((SELECT SUM(invoiceamount) FROM vwsupplierstatement o WHERE o.clientid = $clientid AND o.supplierid = $supplierid AND DATE_FORMAT(invoicedate, '%Y-%m-%d') BETWEEN $startdate AND $enddate), 0) AS invoices,
        IFNULL((SELECT SUM(invoicepayment) FROM vwsupplierstatement o WHERE o.clientid = $clientid AND o.supplierid = $supplierid AND DATE_FORMAT(invoicedate, '%Y-%m-%d') BETWEEN $startdate AND $enddate), 0) AS payments,
        v.reference, v.narrative, IFNULL(v.invoiceamount, 0) AS invoiceamount, IFNULL(v.invoicepayment, 0) AS invoicepayment, IFNULL(v.`order`, 0) AS `order`
    FROM suppliers s
    LEFT JOIN vwsupplierstatement v ON s.supplierid = v.supplierid AND s.clientid = v.clientid 
        AND DATE_FORMAT(v.invoicedate, '%Y-%m-%d') BETWEEN $startdate AND $enddate
    WHERE s.clientid = $clientid 
    AND s.supplierid = $supplierid
    ORDER BY v.invoicedate, v.`order`;
END //

DROP PROCEDURE IF EXISTS spgetsupplieraginganalysis //
CREATE PROCEDURE spgetsupplieraginganalysis(
    IN $clientid INT,
    IN $basedate DATETIME, 
    IN $supplierid INT
)
BEGIN
    SET @cutoffdate = (SELECT DATE_FORMAT(cutoffdate, '%Y-%m-%d') FROM startingparameters WHERE clientid = $clientid);
    IF @cutoffdate IS NULL THEN SET @cutoffdate = '2000-01-01'; END IF;
    
    SELECT 
        SUM(IF(`range` = '1', amountoverdue, 0)) AS `thirty`,  
        SUM(IF(`range` = '31', amountoverdue, 0)) AS `sixty`,
        SUM(IF(`range` = '61', amountoverdue, 0)) AS `ninenty`,
        SUM(IF(`range` = '91', amountoverdue, 0)) AS `onetwenty`,
        SUM(IF(`range` = '120+', amountoverdue, 0)) AS `aboveonetwenty`,
        SUM(amountoverdue) AS `total`
    FROM (
        SELECT 
            i.supplierinvoiceid AS invoiceid, 
            s.supplierid, 
            s.suppliername, 
            i.invoiceno,
            CASE 
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) <= 30 THEN '1' 
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) BETWEEN 31 AND 60 THEN '31'
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) BETWEEN 61 AND 90 THEN '61'
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) BETWEEN 91 AND 120 THEN '91'
                WHEN DATEDIFF($basedate, DATE_FORMAT(i.invoicedate, '%Y-%m-%d')) > 120 THEN '120+' 
            END AS `range`,
            SUM(id.quantity * id.unitprice) -
            IFNULL((
                SELECT SUM(vd.quantity * vd.unitprice) 
                FROM paymentvouchers v 
                JOIN paymentvoucherdetails vd ON v.paymentvoucherid = vd.voucherid
                WHERE v.clientid = $clientid 
                AND v.supplier = s.supplierid 
                AND vd.invoicenumber = i.invoiceno 
                AND DATE_FORMAT(v.date, '%Y-%m-%d') BETWEEN @cutoffdate AND $basedate
            ), 0) AS amountoverdue
        FROM supplierinvoice i
        JOIN supplierinvoicedetails id ON i.supplierinvoiceid = id.invoiceid
        JOIN suppliers s ON s.supplierid = i.supplierid
        WHERE i.clientid = $clientid 
        AND s.clientid = $clientid
        AND s.supplierid = $supplierid
        AND i.status <> 'Cancelled'
        AND DATE_FORMAT(i.invoicedate, '%Y-%m-%d') BETWEEN @cutoffdate AND $basedate
        GROUP BY i.supplierinvoiceid, s.supplierid, s.suppliername, i.invoiceno, i.invoicedate
    ) AS tab1
    GROUP BY suppliername;
END //

DELIMITER ;
