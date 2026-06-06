-- Standardize customer discount procedures
DELIMITER //

DROP PROCEDURE IF EXISTS spgetcustomerdiscountsettings //
CREATE PROCEDURE spgetcustomerdiscountsettings(IN $clientid INT, IN $customerid INT)
BEGIN
    SELECT 
        c.id,
        p.itemcode,
        p.itemname,
        p.sellingprice, 
        c.discount,
        c.percentage,
        c.expirydate 
    FROM products p
    JOIN customerdiscountsettings c ON c.productid = p.productid
    WHERE c.clientid = $clientid 
    AND c.customerid = $customerid 
    AND c.deleted = 0 
    ORDER BY p.itemname;
END //

DROP PROCEDURE IF EXISTS spsavecustomerdiscountsettings //
CREATE PROCEDURE spsavecustomerdiscountsettings(
    IN $clientid INT,
    IN $id INT, 
    IN $customerid INT, 
    IN $productid INT, 
    IN $discount DECIMAL(10,2), 
    IN $percentage TINYINT, 
    IN $userid INT, 
    IN $expirydate DATETIME
)
BEGIN
    IF $id = 0 THEN
        INSERT INTO customerdiscountsettings (
            clientid, customerid, productid, discount, percentage, dateadded, addedby, deleted, expirydate
        ) VALUES (
            $clientid, $customerid, $productid, $discount, $percentage, NOW(), $userid, 0, $expirydate
        );
    ELSE    
        UPDATE customerdiscountsettings SET 
            customerid = $customerid,
            productid = $productid,
            discount = $discount,
            percentage = $percentage,
            lastmodifiedby = $userid,
            lastmodifiedon = NOW(), 
            expirydate = $expirydate
        WHERE id = $id AND clientid = $clientid;
    END IF;
END //

DROP PROCEDURE IF EXISTS spdeletecustomerdiscount //
CREATE PROCEDURE spdeletecustomerdiscount(
    IN $clientid INT,
    IN $id INT,
    IN $userid INT
)
BEGIN
    UPDATE customerdiscountsettings SET
        deleted = 1,
        lastmodifiedby = $userid,
        lastmodifiedon = NOW()
    WHERE id = $id AND clientid = $clientid;
END //

DELIMITER ;
