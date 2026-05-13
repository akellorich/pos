DELIMITER //

DROP PROCEDURE IF EXISTS spsaveuserprivilege //

CREATE PROCEDURE spsaveuserprivilege(
    IN $clientid INT, 
    IN $userid INT, 
    IN $branchid INT, 
    IN $objectid INT, 
    IN $allowed TINYINT, 
    IN $useradding INT
)
BEGIN
    IF NOT EXISTS(SELECT * FROM `userprivileges` WHERE `objectid` = $objectid AND `userid` = $userid AND `branchid` = $branchid) THEN
        INSERT INTO `userprivileges`(`branchid`, `objectid`, `userid`, `allowed`, `dateadded`, `addedby`)
        VALUES($branchid, $objectid, $userid, $allowed, NOW(), $useradding);
    ELSE
        UPDATE `userprivileges` 
        SET `allowed` = $allowed, `lastdateupdated` = NOW(), `lastupdatedby` = $useradding 
        WHERE `objectid` = $objectid AND `userid` = $userid AND `branchid` = $branchid;
    END IF;
END //

DELIMITER ;
