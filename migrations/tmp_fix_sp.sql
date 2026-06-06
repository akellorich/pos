DELIMITER //
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
DELIMITER ;
