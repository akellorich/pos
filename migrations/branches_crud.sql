DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_getbranches` $$
CREATE PROCEDURE `sp_getbranches`(IN $clientid INT)
BEGIN
    SELECT * FROM branches WHERE clientid = $clientid AND deleted = 0;
END $$

DROP PROCEDURE IF EXISTS `sp_savebranch` $$
CREATE PROCEDURE `sp_savebranch`(
    IN $branchid INT,
    IN $branchname VARCHAR(100),
    IN $location VARCHAR(100),
    IN $clientid INT,
    IN $userid INT
)
BEGIN
    IF $branchid = 0 THEN
        INSERT INTO branches (branchname, location, clientid, addedby, dateadded)
        VALUES ($branchname, $location, $clientid, $userid, NOW());
    ELSE
        UPDATE branches SET 
            branchname = $branchname,
            location = $location,
            lastupdatedby = $userid,
            lastdateupdated = NOW()
        WHERE branchid = $branchid AND clientid = $clientid;
    END IF;
END $$

DROP PROCEDURE IF EXISTS `sp_deletebranch` $$
CREATE PROCEDURE `sp_deletebranch`(IN $branchid INT, IN $userid INT)
BEGIN
    UPDATE branches SET deleted = 1, lastupdatedby = $userid, lastdateupdated = NOW() 
    WHERE branchid = $branchid;
END $$

DROP PROCEDURE IF EXISTS `sp_checkbranch` $$
CREATE PROCEDURE `sp_checkbranch`(IN $branchid INT, IN $branchname VARCHAR(100), IN $clientid INT)
BEGIN
    SELECT branchid FROM branches 
    WHERE branchname = $branchname AND branchid != $branchid AND clientid = $clientid AND deleted = 0;
END $$

DELIMITER ;
