-- Migration: Add allow_price_change and allow_negative_sales_globally columns to clients table
-- Date: 2026-06-02

-- 1. ADD COLUMNS IF THEY DO NOT EXIST
-- Since ALTER TABLE with IF NOT EXISTS is not standard in older MySQL, we handle this gracefully or in the executor script.
-- For standard SQL runner, we assume they are not there:
ALTER TABLE `clients` ADD COLUMN `allow_price_change` TINYINT(1) DEFAULT 0;
ALTER TABLE `clients` ADD COLUMN `allow_negative_sales_globally` TINYINT(1) DEFAULT 0;

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
        town,
        allow_price_change AS allowpricechange,
        allow_negative_sales_globally AS allownegativesalesglobally
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
    IN $town VARCHAR(50),
    IN $allowpricechange TINYINT(1),
    IN $allownegativesalesglobally TINYINT(1)
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
        town = $town,
        allow_price_change = $allowpricechange,
        allow_negative_sales_globally = $allownegativesalesglobally
    WHERE clientid = $clientid;
END //

DELIMITER ;
