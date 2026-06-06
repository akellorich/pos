-- Standardize customercontacts table and procedures
-- 1. Table Schema Update
ALTER TABLE customercontacts 
    CHANGE id customercontactid INT AUTO_INCREMENT,
    ADD COLUMN idno VARCHAR(20) AFTER contactname,
    ADD COLUMN idpath VARCHAR(255) AFTER email,
    ADD COLUMN consentsigned TINYINT(1) DEFAULT 0 AFTER idpath;

-- 2. Stored Procedures
DELIMITER //

DROP PROCEDURE IF EXISTS spgetcustomercontacts //
CREATE PROCEDURE spgetcustomercontacts(IN $clientid INT, IN $customerid INT)
BEGIN
    SELECT 
        cc.*,
        cat.description AS categoryname
    FROM customercontacts cc
    LEFT JOIN contactscategories cat ON cc.categoryid = cat.id
    WHERE cc.clientid = $clientid 
    AND cc.customerid = $customerid 
    AND cc.deleted = 0;
END //

DROP PROCEDURE IF EXISTS spsavecustomercontact //
CREATE PROCEDURE spsavecustomercontact(
    IN $clientid INT,
    IN $customercontactid INT,
    IN $customerid INT,
    IN $categoryid INT,
    IN $contactname VARCHAR(100),
    IN $idno VARCHAR(20),
    IN $mobile VARCHAR(40),
    IN $email VARCHAR(50),
    IN $consentsigned TINYINT,
    IN $addedby INT
)
BEGIN
    IF $customercontactid = 0 THEN
        INSERT INTO customercontacts (
            clientid, customerid, categoryid, contactname, idno, mobile, email, consentsigned, addedby, dateadded
        ) VALUES (
            $clientid, $customerid, $categoryid, $contactname, $idno, $mobile, $email, $consentsigned, $addedby, NOW()
        );
    ELSE
        UPDATE customercontacts SET
            categoryid = $categoryid,
            contactname = $contactname,
            idno = $idno,
            mobile = $mobile,
            email = $email,
            consentsigned = $consentsigned
        WHERE customercontactid = $customercontactid AND clientid = $clientid;
    END IF;
END //

DROP PROCEDURE IF EXISTS spdeletecustomercontact //
CREATE PROCEDURE spdeletecustomercontact(
    IN $clientid INT,
    IN $customercontactid INT,
    IN $deletedby INT
)
BEGIN
    UPDATE customercontacts SET
        deleted = 1,
        datedeleted = NOW(),
        deletedby = $deletedby
    WHERE customercontactid = $customercontactid AND clientid = $clientid;
END //

DROP PROCEDURE IF EXISTS spgetcontactscategories //
CREATE PROCEDURE spgetcontactscategories(IN $clientid INT)
BEGIN
    SELECT * FROM contactscategories WHERE clientid = $clientid;
END //

DELIMITER ;
