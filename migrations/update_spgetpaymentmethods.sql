DELIMITER //

DROP PROCEDURE IF EXISTS spgetpaymentmethods //

CREATE PROCEDURE spgetpaymentmethods(IN $branchid INT)
BEGIN
    SELECT * 
    FROM paymentmethods 
    WHERE branchid = $branchid 
    AND `show` = 1;
END //

DELIMITER ;
