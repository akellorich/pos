DELIMITER //

DROP PROCEDURE IF EXISTS spgetcustomers //

CREATE PROCEDURE spgetcustomers(IN $clientid INT, IN $posid INT, IN $regularcustomers TINYINT, IN $onetimecustomers TINYINT)
BEGIN
    DECLARE $defaultcustomerid INT;
    
    -- Get default customer ID from clients table (column is named defaultcustomer)
    SELECT defaultcustomer INTO $defaultcustomerid FROM clients WHERE clientid = $clientid;
    
    SELECT 
        $defaultcustomerid AS defaultcustomerid,
        c.* 
    FROM customers c
    WHERE c.clientid = $clientid AND c.deleted = 0
    AND (($regularcustomers = 1 AND c.onetimecustomer = 0) OR ($onetimecustomers = 1 AND c.onetimecustomer = 1))
    ORDER BY c.customername;
END //

DELIMITER ;
