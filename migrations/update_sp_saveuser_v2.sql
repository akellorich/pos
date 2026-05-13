DROP PROCEDURE IF EXISTS sp_saveuser;
DELIMITER //
CREATE PROCEDURE sp_saveuser(
    IN $clientid INT,
    IN $defaultbranchid INT,
    IN $userid INT, 
    IN $userpassword VARCHAR(100),
    IN $salt VARCHAR(50),
    IN $profilephoto VARCHAR(255),
    IN $systemadmin TINYINT,
    IN $username VARCHAR(50),
    IN $firstname VARCHAR(50),
    IN $middlename VARCHAR(50),
    IN $lastname VARCHAR(50),
    IN $email VARCHAR(50),
    IN $mobile VARCHAR(50),
    IN $changepasswordonlogon TINYINT,
    IN $accountactive TINYINT,
    IN $pin VARCHAR(100),
    IN $pinsalt VARCHAR(50),
    IN $addedby INT
)
BEGIN
    IF $userid = 0 THEN 
        INSERT INTO `user`(
            clientid, defaultbranchid, username, password, salt, profilephoto, firstname, middlename, lastname, email, mobile, 
            changepasswordonlogon, accountactive, addedby, dateadded, systemadmin, pin, pinsalt
        ) VALUES (
            $clientid, $defaultbranchid, $username, $userpassword, $salt, $profilephoto, $firstname, $middlename, $lastname, $email, $mobile, 
            $changepasswordonlogon, $accountactive, $addedby, NOW(), $systemadmin, $pin, $pinsalt
        );
        SET $userid = LAST_INSERT_ID();
    ELSE
        UPDATE `user` SET 
            defaultbranchid = $defaultbranchid,
            username = $username, 
            profilephoto = CASE WHEN $profilephoto IS NOT NULL AND $profilephoto != '' THEN $profilephoto ELSE profilephoto END,
            firstname = $firstname, 
            middlename = $middlename, 
            lastname = $lastname, 
            email = $email, 
            mobile = $mobile,
            changepasswordonlogon = $changepasswordonlogon, 
            accountactive = $accountactive,
            systemadmin = $systemadmin, 
            lastmodifiedby = $addedby, 
            lastmodifiedon = NOW(),
            pin = $pin,
            pinsalt = $pinsalt
        WHERE userid = $userid;
    END IF;
    
    SELECT $userid AS userid;
END //
DELIMITER ;
