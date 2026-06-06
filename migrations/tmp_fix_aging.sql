DELIMITER //
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
        IFNULL(SUM(IF(`range` = '1', amountoverdue, 0)), 0) AS `thirty`,  
        IFNULL(SUM(IF(`range` = '31', amountoverdue, 0)), 0) AS `sixty`,
        IFNULL(SUM(IF(`range` = '61', amountoverdue, 0)), 0) AS `ninenty`,
        IFNULL(SUM(IF(`range` = '91', amountoverdue, 0)), 0) AS `onetwenty`,
        IFNULL(SUM(IF(`range` = '120+', amountoverdue, 0)), 0) AS `aboveonetwenty`,
        IFNULL(SUM(amountoverdue), 0) AS `total`
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
    ) AS tab1;
END //
DELIMITER ;
