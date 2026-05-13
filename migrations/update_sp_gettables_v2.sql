DELIMITER //

DROP PROCEDURE IF EXISTS sp_gettables //

CREATE PROCEDURE sp_gettables(IN $branchid INT, IN $posid INT)
BEGIN
    IF $posid = 0 THEN 
        SELECT 
            t.*, 
            t.id AS tableid,
            p.posname, 
            u.username AS addedbyname
        FROM `tables` t 
        JOIN `pointsofsale` p ON p.`posid` = t.posid
        JOIN `user` u ON u.userid = t.addedby
        WHERE t.deleted = 0 AND p.branchid = $branchid
        ORDER BY p.posname, t.tablename;
    ELSE
        SELECT 
            t.*, 
            t.id AS tableid,
            p.posname, 
            u.username AS addedbyname
        FROM `tables` t 
        JOIN `pointsofsale` p ON p.`posid` = t.posid
        JOIN `user` u ON u.userid = t.addedby
        WHERE t.deleted = 0 AND t.posid = $posid AND p.branchid = $branchid
        ORDER BY t.tablename;
    END IF;
END //

DELIMITER ;
