DELIMITER //

-- Update spgetpaymentmethodsummary
DROP PROCEDURE IF EXISTS spgetpaymentmethodsummary //
CREATE PROCEDURE spgetpaymentmethodsummary(IN $clientid INT, IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
    SELECT 
        paymentmode, 
        SUM(receipttotal) AS total 
    FROM `vwsalessummary`
    WHERE transactiondate BETWEEN $startdate AND $enddate
    AND clientid = $clientid
    GROUP BY paymentmode  
    ORDER BY SUM(receipttotal) DESC;
END //

DELIMITER ;
