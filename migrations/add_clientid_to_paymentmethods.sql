-- Add clientid to paymentmethods table
ALTER TABLE paymentmethods ADD COLUMN clientid INT DEFAULT 1 AFTER id;

-- Seed current data to the current client (assuming clientid 1)
UPDATE paymentmethods SET clientid = 1 WHERE clientid IS NULL OR clientid = 0;

-- Update spgetpaymentmethods to use clientid
DELIMITER //

DROP PROCEDURE IF EXISTS spgetpaymentmethods //

CREATE PROCEDURE spgetpaymentmethods(IN $clientid INT, IN $branchid INT)
BEGIN
    SELECT * 
    FROM paymentmethods 
    WHERE clientid = $clientid 
    AND branchid = $branchid 
    AND `show` = 1;
END //

DELIMITER ;
