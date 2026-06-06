-- Standardize supplier product procedures for multi-tenancy
DELIMITER //

DROP PROCEDURE IF EXISTS spsavesupplierproduct //
CREATE PROCEDURE spsavesupplierproduct(
    IN $clientid INT,
    IN $supplierid INT,
    IN $productid INT,
    IN $userid INT
)
BEGIN
    IF NOT EXISTS(SELECT * FROM supplierproducts WHERE clientid = $clientid AND supplierid = $supplierid AND productid = $productid AND deleted = 0) THEN 
        INSERT INTO supplierproducts (clientid, supplierid, productid, addedby, dateadded, deleted)
        VALUES ($clientid, $supplierid, $productid, $userid, NOW(), 0);
    END IF;
END //

DROP PROCEDURE IF EXISTS spgetsupplierproducts //
CREATE PROCEDURE spgetsupplierproducts(
    IN $clientid INT,
    IN $supplierid INT
)
BEGIN
    SELECT s.id, s.productid, p.itemcode, p.itemname, s.dateadded, 
           CONCAT(u.firstname, ' ', u.middlename, ' ', u.lastname) AS addedbyuser
    FROM products p
    JOIN supplierproducts s ON p.productid = s.productid
    JOIN user u ON s.addedby = u.userid
    WHERE s.clientid = $clientid 
    AND s.supplierid = $supplierid 
    AND s.deleted = 0
    ORDER BY p.itemname;
END //

DROP PROCEDURE IF EXISTS spdeletesupplierproduct //
CREATE PROCEDURE spdeletesupplierproduct(
    IN $clientid INT,
    IN $id INT,
    IN $userid INT
)
BEGIN
    UPDATE supplierproducts SET 
        deleted = 1, 
        lastmodifiedby = $userid, 
        lastmodifieddate = NOW()
    WHERE clientid = $clientid AND id = $id;
END //

DELIMITER ;
