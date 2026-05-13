DELIMITER //

-- Update sp_checksessionid to use branchid
DROP PROCEDURE IF EXISTS sp_checksessionid //

CREATE PROCEDURE sp_checksessionid(IN $branchid INT)
BEGIN
    SELECT * FROM `sessions` 
    WHERE `branchid` = $branchid 
    AND `status` = 'active';
END //

-- Create/Update sp_activatesession
DROP PROCEDURE IF EXISTS sp_activatesession //

CREATE PROCEDURE sp_activatesession(IN $branchid INT, IN $floatamount DECIMAL(18,2), IN $userid INT)
BEGIN
    INSERT INTO `sessions` (`branchid`, `floatamount`, `addedby`, `status`, `starttime`, `dateadded`)
    VALUES ($branchid, $floatamount, $userid, 'active', NOW(), NOW());
END //

-- Update sp_closesession
DROP PROCEDURE IF EXISTS sp_closesession //

CREATE PROCEDURE sp_closesession(IN $branchid INT, IN $userid INT)
BEGIN
    UPDATE `sessions`
    SET `status` = 'closed', `closedby` = $userid, `dateclosed` = NOW(), `endtime` = NOW()
    WHERE `branchid` = $branchid AND `status` = 'active';
END //

-- Update sp_getsessions
DROP PROCEDURE IF EXISTS sp_getsessions //

CREATE PROCEDURE sp_getsessions(IN $branchid INT)
BEGIN
    SELECT s.*, 
           CONCAT(o.firstname, ' ', o.middlename, ' ', o.lastname) AS openedby,
           IFNULL(CONCAT(c.firstname, ' ', c.middlename, ' ', c.lastname), '-') AS closedby
    FROM `sessions` s
    LEFT JOIN `user` o ON o.`userid` = s.`addedby`
    LEFT JOIN `user` c ON c.`userid` = s.`closedby`
    WHERE s.`branchid` = $branchid
    ORDER BY s.`sessionid` DESC;
END //

-- Update sp_getsessioncollectionsummary
DROP PROCEDURE IF EXISTS sp_getsessioncollectionsummary //

CREATE PROCEDURE sp_getsessioncollectionsummary(IN $branchid INT, IN $sessionid INT)
BEGIN
    -- Basic summary for now, can be expanded based on transaction tables
    SELECT * FROM `sessions` WHERE `branchid` = $branchid AND `sessionid` = $sessionid;
END //

DELIMITER ;
