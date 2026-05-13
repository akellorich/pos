DELIMITER //

DROP PROCEDURE IF EXISTS sp_getposproductcategories //

CREATE PROCEDURE sp_getposproductcategories(IN $branchid INT, IN $posid INT)
BEGIN
    SELECT 
        c.categoryid, 
        c.categoryname,
        pc.poscategoryid
    FROM categories c
    LEFT JOIN posproductcategories pc ON pc.productcategoryid = c.categoryid 
        AND pc.posid = $posid 
        AND pc.deleted = 0
    -- Note: Categories might need branchid filter too if they are branch-specific
    -- For now, we scope the link (posproductcategories) to the branch via the posid
    ORDER BY c.categoryname;
END //

DELIMITER ;
