-- Update sp_checksessionid to check by user
DROP PROCEDURE IF EXISTS sp_checksessionid;
DELIMITER //
CREATE PROCEDURE `sp_checksessionid`(IN $branchid INT, IN $userid INT)
BEGIN
    SELECT * FROM `sessions` 
    WHERE `branchid` = $branchid 
    AND `addedby` = $userid
    AND `status` = 'active';
END //
DELIMITER ;
