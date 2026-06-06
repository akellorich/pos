-- ==========================================
-- Migration: Multi-Tenancy ClientID Auditing & Upgrades
-- Created: 2026-05-29
-- ==========================================

DELIMITER $$

-- 1. Recreate spgetinstitutiondetails to accept clientid and isolate properly
DROP PROCEDURE IF EXISTS `spgetinstitutiondetails`$$
CREATE PROCEDURE `spgetinstitutiondetails`(
    IN $clientid INT
)
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
END$$

-- 2. Recreate sp_getemailconfiguration to accept clientid and isolate properly
DROP PROCEDURE IF EXISTS `sp_getemailconfiguration`$$
CREATE PROCEDURE `sp_getemailconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `emailconfiguration` WHERE `clientid` = $clientid;
END$$

-- 3. Recreate spgetemailconfiguration alias to accept clientid
DROP PROCEDURE IF EXISTS `spgetemailconfiguration`$$
CREATE PROCEDURE `spgetemailconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `emailconfiguration` WHERE `clientid` = $clientid;
END$$

-- 4. Recreate sp_saveemailconfiguration to accept clientid and isolate properly
DROP PROCEDURE IF EXISTS `sp_saveemailconfiguration`$$
CREATE PROCEDURE `sp_saveemailconfiguration`(
    IN $clientid INT,
    IN $emailaddress VARCHAR(100),
    IN $emailpassword VARCHAR(50),
    IN $smtpserver VARCHAR(50),
    IN $smtpport INT,
    IN $usessl BOOLEAN
)
BEGIN
    IF EXISTS(SELECT * FROM `emailconfiguration` WHERE `clientid` = $clientid) THEN
        UPDATE `emailconfiguration` 
        SET `emailaddress` = $emailaddress,
            `password` = $emailpassword,
            `smtpserver` = $smtpserver,
            `smtpport` = $smtpport,
            `usessl` = $usessl
        WHERE `clientid` = $clientid;
    ELSE
        INSERT INTO `emailconfiguration` (`clientid`, `emailaddress`, `password`, `smtpserver`, `smtpport`, `usessl`)
        VALUES ($clientid, $emailaddress, $emailpassword, $smtpserver, $smtpport, $usessl);
    END IF;
END$$

-- 5. Recreate spsaveemailconfiguration alias to accept clientid
DROP PROCEDURE IF EXISTS `spsaveemailconfiguration`$$
CREATE PROCEDURE `spsaveemailconfiguration`(
    IN $clientid INT,
    IN $emailaddress VARCHAR(100),
    IN $emailpassword VARCHAR(50),
    IN $smtpserver VARCHAR(50),
    IN $smtpport INT,
    IN $usessl BOOLEAN
)
BEGIN
    CALL sp_saveemailconfiguration($clientid, $emailaddress, $emailpassword, $smtpserver, $smtpport, $usessl);
END$$

-- 6. Recreate sp_getsmsconfiguration to accept clientid and isolate properly
DROP PROCEDURE IF EXISTS `sp_getsmsconfiguration`$$
CREATE PROCEDURE `sp_getsmsconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `smsconfiguration` WHERE `clientid` = $clientid;
END$$

-- 7. Recreate spgetsmsconfiguration alias to accept clientid
DROP PROCEDURE IF EXISTS `spgetsmsconfiguration`$$
CREATE PROCEDURE `spgetsmsconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `smsconfiguration` WHERE `clientid` = $clientid;
END$$

-- 8. Recreate sp_savesmsconfiguration to accept clientid and isolate properly
DROP PROCEDURE IF EXISTS `sp_savesmsconfiguration`$$
CREATE PROCEDURE `sp_savesmsconfiguration`(
    IN $clientid INT,
    IN $apikey VARCHAR(255),
    IN $senderid VARCHAR(50),
    IN $partnerid VARCHAR(100),
    IN $url VARCHAR(255)
)
BEGIN
    IF EXISTS(SELECT * FROM `smsconfiguration` WHERE `clientid` = $clientid) THEN
        UPDATE `smsconfiguration`
        SET `apikey` = $apikey,
            `senderid` = $senderid,
            `partnerid` = $partnerid,
            `url` = $url
        WHERE `clientid` = $clientid;
    ELSE
        INSERT INTO `smsconfiguration` (`clientid`, `apikey`, `senderid`, `partnerid`, `url`)
        VALUES ($clientid, $apikey, $senderid, $partnerid, $url);
    END IF;
END$$

-- 9. Recreate sp_getwhatsappconfiguration to accept clientid and isolate properly
DROP PROCEDURE IF EXISTS `sp_getwhatsappconfiguration`$$
CREATE PROCEDURE `sp_getwhatsappconfiguration`(
    IN $clientid INT
)
BEGIN
    SELECT * FROM `whatsappconfiguration` WHERE `clientid` = $clientid;
END$$

-- 10. Recreate sp_savewhatsappconfiguration to accept clientid and isolate properly
DROP PROCEDURE IF EXISTS `sp_savewhatsappconfiguration`$$
CREATE PROCEDURE `sp_savewhatsappconfiguration`(
    IN $clientid INT,
    IN $apikey VARCHAR(255),
    IN $phone_number_id VARCHAR(100),
    IN $url VARCHAR(255)
)
BEGIN
    IF EXISTS(SELECT * FROM `whatsappconfiguration` WHERE `clientid` = $clientid) THEN
        UPDATE `whatsappconfiguration`
        SET `apikey` = $apikey,
            `phone_number_id` = $phone_number_id,
            `url` = $url
        WHERE `clientid` = $clientid;
    ELSE
        INSERT INTO `whatsappconfiguration` (`clientid`, `apikey`, `phone_number_id`, `url`)
        VALUES ($clientid, $apikey, $phone_number_id, $url);
    END IF;
END$$

DELIMITER ;
