-- Update clients table with receipt and vault options
ALTER TABLE clients ADD COLUMN sendtovault TINYINT(1) DEFAULT 0;
ALTER TABLE clients MODIFY COLUMN printreceipt TINYINT(4) DEFAULT 1;

-- Seed existing clients
UPDATE clients SET printreceipt = 1, sendtovault = 0;

-- Update spgetinstitutiondetails to include new columns
DELIMITER //

DROP PROCEDURE IF EXISTS spgetinstitutiondetails //

CREATE PROCEDURE spgetinstitutiondetails(IN $clientid INT)
BEGIN
    SELECT 
        client_name AS name,
        physical_address AS physicaladdress,
        postaladdress,
        landline,
        email,
        phone_number AS mobile,
        pinno,
        autoaddinvoiceduringgrn,
        postalcode,
        tagline,
        website,
        receiptfooter,
        defaultcustomer,
        mainbusinesstype,
        logo,
        town,
        showwaiterlogin,
        printreceipt,
        sendtovault
    FROM clients 
    WHERE clientid = $clientid;
END //

DELIMITER ;
