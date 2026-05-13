DELIMITER //

DROP PROCEDURE IF EXISTS spgetpos //

CREATE PROCEDURE spgetpos(IN $branchid INT)
BEGIN
    SELECT 
        p.*,
        p.posid AS id,
        p.posname AS description,
        u.username AS addedbyname
    FROM pointsofsale p
    LEFT JOIN user u ON p.addedby = u.userid
    WHERE p.branchid = $branchid AND p.deleted = 0 
    ORDER BY p.posname;
END //

DELIMITER ;
