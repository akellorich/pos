DELIMITER //

DROP PROCEDURE IF EXISTS spvalidateuserprivilege //

CREATE PROCEDURE spvalidateuserprivilege(IN $branchid INT, IN $userid INT, IN $objectid INT)
BEGIN
    DECLARE $admin INT;
    DECLARE $valid INT DEFAULT 0;
    
    -- Check if user is a system admin (Admin usually bypasses individual privilege checks)
    SELECT systemadmin INTO $admin FROM `user` WHERE `userid` = $userid;
    
    IF $admin = 1 THEN
        SET $valid = 1;
    ELSE
        -- Check specific privilege for user and branch
        SELECT IFNULL(MAX(allowed), 0) INTO $valid 
        FROM `userprivileges` 
        WHERE `userid` = $userid 
        AND `branchid` = $branchid 
        AND `objectid` = $objectid;
    END IF;
    
    SELECT $valid AS `allowed`;
END //

DELIMITER ;
