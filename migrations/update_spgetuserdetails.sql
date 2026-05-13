DELIMITER //

DROP PROCEDURE IF EXISTS spgetuserdetails //

CREATE PROCEDURE spgetuserdetails(IN $username VARCHAR(50))
BEGIN
    SELECT 
        u.*, 
        COALESCE(b.branchname, 'Default Branch') AS branchname 
    FROM user u
    LEFT JOIN branches b ON u.defaultbranchid = b.branchid
    WHERE u.username = $username;
END //

DROP PROCEDURE IF EXISTS sp_getbranchdetails //

CREATE PROCEDURE sp_getbranchdetails(IN $branchid INT)
BEGIN
    SELECT * FROM branches WHERE branchid = $branchid;
END //

DELIMITER ;
