-- Migration: Update spfilterproductsbyname to include categoryname, addedbyname, and wholesaleprice
-- 1. Drop the existing procedure
DROP PROCEDURE IF EXISTS `spfilterproductsbyname`;

-- 2. Create the updated procedure with LEFT JOINs and multi-tenant scoping
DELIMITER $$

CREATE PROCEDURE `spfilterproductsbyname`(IN $clientid INT, IN $name VARCHAR(50), IN $posid INT)
BEGIN
    IF $posid = 0 THEN 
        SELECT p.*, 
               c.`categoryname`, 
               IFNULL(CONCAT(u.`firstname`, ' ', u.`middlename`, ' ', u.`lastname`), 'System') AS addedbyname,
               p.`sellingprice` - IFNULL((
                   SELECT CASE WHEN cs.`percentage` = 1 THEN (cs.`value` / 100) * p.`sellingprice` ELSE cs.`value` END 
                   FROM `customerpricematrix` cs
                   WHERE cs.`customercategoryid` = 2 AND cs.`itemid` = p.`productid`
               ), 0) wholesaleprice,
               fn_getitemstorebalanceasat(p.productid, $posid, CURDATE()) AS available_stock
        FROM `products` p
        LEFT JOIN `categories` c ON p.`categoryid` = c.`categoryid` AND p.`clientid` = c.`clientid`
        LEFT JOIN `user` u ON p.`addedby` = u.`userid` AND p.`clientid` = u.`clientid`
        WHERE p.`clientid` = $clientid 
          AND p.`itemname` LIKE CONCAT('%', $name, '%') 
          AND p.`deleted` = 0
        ORDER BY p.`itemname`;
    ELSE
        SELECT p.*, 
               c.`categoryname`, 
               IFNULL(CONCAT(u.`firstname`, ' ', u.`middlename`, ' ', u.`lastname`), 'System') AS addedbyname,
               p.`sellingprice` - IFNULL((
                   SELECT CASE WHEN cs.`percentage` = 1 THEN (cs.`value` / 100) * p.`sellingprice` ELSE cs.`value` END 
                   FROM `customerpricematrix` cs
                   WHERE cs.`customercategoryid` = 2 AND cs.`itemid` = p.`productid`
               ), 0) wholesaleprice,
               fn_getitemstorebalanceasat(p.productid, $posid, CURDATE()) AS available_stock
        FROM `products` p
        LEFT JOIN `categories` c ON p.`categoryid` = c.`categoryid` AND p.`clientid` = c.`clientid`
        LEFT JOIN `user` u ON p.`addedby` = u.`userid` AND p.`clientid` = u.`clientid`
        WHERE p.`clientid` = $clientid 
          AND p.`itemname` LIKE CONCAT('%', $name, '%') 
          AND p.`deleted` = 0
          AND c.`categoryid` IN (
              SELECT `productcategoryid` 
              FROM `posproductcategories` 
              WHERE `posid` = $posid AND `deleted` = 0
          )
        ORDER BY p.`itemname`;
    END IF;
END $$

DELIMITER ;
