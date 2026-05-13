DELIMITER //

DROP PROCEDURE IF EXISTS spgetcustomercategories //

CREATE PROCEDURE spgetcustomercategories(IN $clientid INT)
BEGIN
    SELECT 
        id, 
        description AS categoryname,
        `default`
    FROM customercategories 
    WHERE clientid = $clientid 
    ORDER BY description;
END //

DELIMITER ;
