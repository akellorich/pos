DELIMITER //

DROP PROCEDURE IF EXISTS spgetuseroutlets //

CREATE PROCEDURE spgetuseroutlets(IN $branchid INT, IN $userid INT)
BEGIN
    SELECT o.*, s.posname
    FROM useroutlets o
    JOIN pointsofsale s ON s.id = o.outletid
    WHERE s.branchid = $branchid 
    AND o.userid = $userid 
    AND IFNULL(o.deleted, 0) = 0
    ORDER BY s.posname;
END //

DELIMITER ;
