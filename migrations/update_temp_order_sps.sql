DELIMITER //

-- Update sp_savetempcustomerorderdetail
DROP PROCEDURE IF EXISTS sp_savetempcustomerorderdetail //
CREATE PROCEDURE sp_savetempcustomerorderdetail(
    IN $branchid INT,
    IN $refno VARCHAR(50), 
    IN $productid INT, 
    IN $quantity DECIMAL(5,2), 
    IN $unitprice DECIMAL(7,2)
)
BEGIN
    INSERT INTO `temcustomerorderdetails`(`branchid`, `refno`, `productid`, `quantity`, `unitprice`)
    VALUES($branchid, $refno, $productid, $quantity, $unitprice);
END //

-- Update sp_savetemporderstosettle
DROP PROCEDURE IF EXISTS sp_savetemporderstosettle //
CREATE PROCEDURE sp_savetemporderstosettle(
    IN $branchid INT,
    IN $refno VARCHAR(50), 
    IN $orderid INT
)
BEGIN
    INSERT INTO `temporderstosettle`(`branchid`, `refno`, `orderid`)
    VALUES($branchid, $refno, $orderid);
END //

DELIMITER ;
