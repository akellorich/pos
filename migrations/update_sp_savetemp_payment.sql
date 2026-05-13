DELIMITER //

DROP PROCEDURE IF EXISTS spsavetemppossalepayment //

CREATE PROCEDURE spsavetemppossalepayment(
    IN $branchid INT,
    IN $refno VARCHAR(50), 
    IN $paymentmode INT, 
    IN $referenceno VARCHAR(50), 
    IN $amount DECIMAL(18,2)
)
BEGIN	
    INSERT INTO `temppossalespayment`(`branchid`, `refno`, `paymentmodeid`, `reference`, `amount`)
    VALUES($branchid, $refno, $paymentmode, $referenceno, $amount);
END //

DELIMITER ;
