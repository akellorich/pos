DROP PROCEDURE IF EXISTS `spgetproductbycategory`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetproductbycategory`(IN `$clientid` INT, IN `$categoryid` INT, IN `$posid` INT)
BEGIN
    IF `$categoryid` = 0 THEN
        SELECT *, `fn_getitemstorebalance`(productid, `$posid`) AS available_stock 
        FROM `products` 
        WHERE clientid = `$clientid` AND `deleted` = 0 
        ORDER BY `itemname`;
    ELSE
        SELECT *, `fn_getitemstorebalance`(productid, `$posid`) AS available_stock 
        FROM `products` 
        WHERE clientid = `$clientid` AND `categoryid` = `$categoryid` AND `deleted` = 0 
        ORDER BY `itemname`;
    END IF;
END$$

DELIMITER ;
