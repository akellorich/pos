DELIMITER //

-- Update spgetpos
DROP PROCEDURE IF EXISTS spgetpos //

CREATE PROCEDURE spgetpos(IN $branchid INT)
BEGIN
    SELECT 
        p.*,
        p.posid AS id,
        p.posname AS description,
        CONCAT_WS(' ', u.firstname, u.middlename, u.lastname) AS addedbyname
    FROM pointsofsale p
    LEFT JOIN `user` u ON p.addedby = u.userid
    WHERE p.branchid = $branchid AND p.deleted = 0 
    ORDER BY p.posname;
END //

-- Update spgetposdetails
DROP PROCEDURE IF EXISTS spgetposdetails //

CREATE PROCEDURE spgetposdetails(IN $branchid INT, IN $posid INT)
BEGIN
    SELECT *, posid AS id FROM pointsofsale WHERE branchid = $branchid AND posid = $posid;
END //

-- Update spsavepos
DROP PROCEDURE IF EXISTS spsavepos //

CREATE PROCEDURE spsavepos(
    IN $branchid INT,
    IN $posid INT, 
    IN $posname VARCHAR(50), 
    IN $postype VARCHAR(50), 
    IN $printkitchenorders TINYINT,
    IN $userid INT
)
BEGIN
    IF $posid = 0 THEN 
        INSERT INTO pointsofsale (branchid, posname, postype, printkitchenorders, dateadded, addedby, deleted)
        VALUES ($branchid, $posname, $postype, $printkitchenorders, NOW(), $userid, 0);
        SET $posid = LAST_INSERT_ID();
    ELSE
        UPDATE pointsofsale 
        SET posname = $posname, postype = $postype, printkitchenorders = $printkitchenorders,
            lastdatemodified = NOW(), lastmodifiedby = $userid
        WHERE branchid = $branchid AND posid = $posid;
    END IF;
    SELECT $posid AS posid;
END //

-- Update spdeletepos
DROP PROCEDURE IF EXISTS spdeletepos //

CREATE PROCEDURE spdeletepos(IN $branchid INT, IN $posid INT, IN $userid INT)
BEGIN
    UPDATE pointsofsale 
    SET deleted = 1, lastdatemodified = NOW(), lastmodifiedby = $userid
    WHERE branchid = $branchid AND posid = $posid;
END //

-- Update spcheckposname
DROP PROCEDURE IF EXISTS spcheckposname //

CREATE PROCEDURE spcheckposname(IN $branchid INT, IN $posid INT, IN $posname VARCHAR(50))
BEGIN
    SELECT * FROM pointsofsale 
    WHERE branchid = $branchid AND posid <> $posid AND posname = $posname AND deleted = 0;
END //

DELIMITER ;
