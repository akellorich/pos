DELIMITER $$

USE `pos`$$

-- Seed Customer Number document type if not exists
INSERT INTO `serials` (`documenttype`, `prefix`, `currentno`, `branchid`)
SELECT 'Customer Number', 'CUST', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM `serials` WHERE `documenttype` = 'Customer Number' AND `branchid` = 1
);$$

-- Create/Recreate fngeneratecustomerno function
DROP FUNCTION IF EXISTS `fngeneratecustomerno`$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fngeneratecustomerno`(p_branchid INT) RETURNS VARCHAR(50) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
    DECLARE v_customerno VARCHAR(50);
    SET v_customerno = (SELECT CONCAT(
        `prefix`,
        CASE CHAR_LENGTH(`currentno`) 
            WHEN 1 THEN '0000'
            WHEN 2 THEN '000'
            WHEN 3 THEN '00'
            WHEN 4 THEN '0'
            ELSE '' 
        END,
        `currentno`) FROM `serials` WHERE branchid = p_branchid AND `documenttype` = 'Customer Number');
    RETURN v_customerno;
END$$

-- Recreate spsavecustomer
DROP PROCEDURE IF EXISTS `spsavecustomer`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spsavecustomer`(
    IN $clientid INT, 
    IN $customerid INT, 
    IN $customername VARCHAR(100),
    IN $tradingname VARCHAR(100),
    IN $physicaladdress VARCHAR(100),
    IN $postaladdress VARCHAR(100),
    IN $mobile VARCHAR(50),
    IN $email VARCHAR(50),
    IN $creditlimit DECIMAL(18,2),
    IN $creditterm INT,
    IN $userid INT,
    IN $category INT,
    IN $posid INT,
    IN $onetimecustomer TINYINT,
    IN $pinno VARCHAR(50),
    IN $idno VARCHAR(50),
    IN $subzoneid INT
)
BEGIN
    IF $customerid = 0 THEN
        BEGIN
            DECLARE v_customerno VARCHAR(50);
            
            -- Ensure Customer Number serial exists for safety
            IF NOT EXISTS (SELECT 1 FROM `serials` WHERE `documenttype` = 'Customer Number' AND `branchid` = 1) THEN
                INSERT INTO `serials` (`documenttype`, `prefix`, `currentno`, `branchid`) VALUES ('Customer Number', 'CUST', 1, 1);
            END IF;
            
            -- Generate customerno using fngeneratecustomerno
            SET v_customerno = fngeneratecustomerno(1);
            
            INSERT INTO `customers` (
                clientid, customername, tradingname, physicaladdress, postaladdress, mobile, email,
                creditlimit, creditterm, dateadded, addedby, deleted, categoryid, pointofsaleid,
                onetimecustomer, pinno, idno, subzoneid, customerno
            ) VALUES (
                $clientid, $customername, $tradingname, $physicaladdress, $postaladdress, $mobile, $email,
                $creditlimit, $creditterm, NOW(), $userid, 0, $category, $posid,
                $onetimecustomer, $pinno, $idno, $subzoneid, v_customerno
            );
            
            -- Increment the counter by 1
            UPDATE `serials` SET `currentno` = `currentno` + 1 WHERE `documenttype` = 'Customer Number' AND `branchid` = 1;
        END;
    ELSE
        UPDATE `customers` SET
            customername = $customername,
            tradingname = $tradingname,
            physicaladdress = $physicaladdress,
            postaladdress = $postaladdress,
            mobile = $mobile,
            email = $email,
            creditlimit = $creditlimit,
            creditterm = $creditterm,
            lastmodifiedon = NOW(),
            lastmodifiedby = $userid,
            categoryid = $category,
            pointofsaleid = $posid,
            onetimecustomer = $onetimecustomer,
            pinno = $pinno,
            idno = $idno,
            subzoneid = $subzoneid
        WHERE clientid = $clientid AND customerid = $customerid;
    END IF;
END$$

DELIMITER ;
