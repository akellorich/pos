-- 1. UPDATE CLIENTS TABLE SCHEMA
ALTER TABLE `clients` 
    ADD COLUMN `postaladdress` VARCHAR(100) DEFAULT NULL AFTER `physical_address`,
    ADD COLUMN `landline` VARCHAR(50) DEFAULT NULL AFTER `phone_number`,
    ADD COLUMN `pinno` VARCHAR(50) DEFAULT NULL AFTER `country`,
    ADD COLUMN `autoaddinvoiceduringgrn` TINYINT(1) DEFAULT 0 AFTER `pinno`,
    ADD COLUMN `postalcode` VARCHAR(50) DEFAULT NULL AFTER `postaladdress`,
    ADD COLUMN `quotationvalidity` INT(11) DEFAULT 30 AFTER `postalcode`,
    ADD COLUMN `tagline` VARCHAR(1000) DEFAULT NULL AFTER `quotationvalidity`,
    ADD COLUMN `website` VARCHAR(100) DEFAULT NULL AFTER `tagline`,
    ADD COLUMN `receiptfooter` VARCHAR(4000) DEFAULT NULL AFTER `website`,
    ADD COLUMN `defaultcustomer` INT(11) DEFAULT NULL AFTER `receiptfooter`,
    ADD COLUMN `mainbusinesstype` VARCHAR(50) DEFAULT NULL AFTER `defaultcustomer`,
    ADD COLUMN `logo` VARCHAR(1000) DEFAULT NULL AFTER `mainbusinesstype`,
    ADD COLUMN `town` VARCHAR(50) DEFAULT NULL AFTER `logo`;

-- 2. UPDATE STORED PROCEDURES
DELIMITER //

DROP PROCEDURE IF EXISTS spgetinstitutiondetails //
CREATE PROCEDURE spgetinstitutiondetails(IN $clientid INT)
BEGIN
    SELECT 
        clientid AS id,
        client_name AS name,
        physical_address AS physicaladdress,
        postaladdress,
        landline,
        email,
        phone_number AS mobile,
        pinno,
        autoaddinvoiceduringgrn AS autoinvoicegrn,
        postalcode,
        quotationvalidity,
        tagline,
        website,
        receiptfooter,
        defaultcustomer,
        mainbusinesstype,
        logo,
        town
    FROM `clients` 
    WHERE clientid = $clientid;
END //

DROP PROCEDURE IF EXISTS sp_saveinstitutiondetails //
CREATE PROCEDURE sp_saveinstitutiondetails(
    IN $clientid INT,
    IN $companyname VARCHAR(100),
    IN $physicaladdress TEXT,
    IN $postaladdress VARCHAR(100),
    IN $landline VARCHAR(50),
    IN $email VARCHAR(100),
    IN $mobile VARCHAR(50),
    IN $pinno VARCHAR(50),
    IN $autoinvoicegrn TINYINT(1),
    IN $postalcode VARCHAR(50),
    IN $tagline VARCHAR(1000),
    IN $website VARCHAR(100),
    IN $receiptfooter VARCHAR(4000),
    IN $defaultcustomer INT,
    IN $mainbusinesstype VARCHAR(50),
    IN $logo VARCHAR(1000),
    IN $town VARCHAR(50)
)
BEGIN
    UPDATE `clients` SET 
        client_name = $companyname,
        physical_address = $physicaladdress,
        postaladdress = $postaladdress,
        landline = $landline,
        email = $email,
        phone_number = $mobile,
        pinno = $pinno,
        autoaddinvoiceduringgrn = $autoinvoicegrn,
        postalcode = $postalcode,
        tagline = $tagline,
        website = $website,
        receiptfooter = $receiptfooter,
        defaultcustomer = $defaultcustomer,
        mainbusinesstype = $mainbusinesstype,
        logo = $logo,
        town = $town
    WHERE clientid = $clientid;
END //

DELIMITER ;
