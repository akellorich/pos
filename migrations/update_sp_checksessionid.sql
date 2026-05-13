DELIMITER //

DROP PROCEDURE IF EXISTS sp_checksessionid //

CREATE PROCEDURE sp_checksessionid(IN $clientid INT)
BEGIN
    SELECT s.* FROM `sessions` s
    INNER JOIN `branches` b ON s.branchid = b.branchid
    WHERE b.clientid = $clientid 
    AND s.status = 'active';
END //

DELIMITER ;
