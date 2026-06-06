-- Migration: Create Stored Procedures for Product Recipes

DROP PROCEDURE IF EXISTS `spfilterrawproducts`;
DELIMITER $$
CREATE PROCEDURE `spfilterrawproducts`(IN $clientid INT, IN $name VARCHAR(100))
BEGIN
    SELECT `productid`, `itemcode`, `itemname`, `buyingprice` AS `sellingprice`, `unitofmeasure` AS `uom` 
    FROM `products` 
    WHERE `clientid` = $clientid AND `deleted` = 0 AND `rawmaterial` = 1 
      AND (`itemname` LIKE CONCAT('%', $name, '%') OR `itemcode` LIKE CONCAT('%', $name, '%')) 
    ORDER BY `itemname` LIMIT 20;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spsaveproductrecipe`;
DELIMITER $$
CREATE PROCEDURE `spsaveproductrecipe`(
    IN $clientid INT,
    IN $productid INT,
    IN $recipeitemid INT,
    IN $quantity DECIMAL(10,4),
    IN $userid INT
)
BEGIN
    IF EXISTS(SELECT 1 FROM `productrecipes` WHERE `clientid` = $clientid AND `productid` = $productid AND `recipeitemid` = $recipeitemid) THEN
        UPDATE `productrecipes` 
        SET `quantity` = $quantity, `addedby` = $userid, `dateadded` = NOW() 
        WHERE `clientid` = $clientid AND `productid` = $productid AND `recipeitemid` = $recipeitemid;
    ELSE
        INSERT INTO `productrecipes` (`clientid`, `productid`, `recipeitemid`, `quantity`, `addedby`, `dateadded`) 
        VALUES ($clientid, $productid, $recipeitemid, $quantity, $userid, NOW());
    END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spgetproductrecipes`;
DELIMITER $$
CREATE PROCEDURE `spgetproductrecipes`(IN $clientid INT, IN $productid INT)
BEGIN
    SELECT pr.`id`, pr.`quantity`, p.`itemcode`, p.`itemname`, p.`unitofmeasure` AS `uom`, p.`buyingprice` AS `sellingprice`, (pr.`quantity` * p.`buyingprice`) AS `total`, pr.`recipeitemid`
    FROM `productrecipes` pr
    INNER JOIN `products` p ON pr.`recipeitemid` = p.`productid`
    WHERE pr.`clientid` = $clientid AND pr.`productid` = $productid
    ORDER BY p.`itemname`;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spdeleteproductrecipe`;
DELIMITER $$
CREATE PROCEDURE `spdeleteproductrecipe`(IN $clientid INT, IN $recipeid INT)
BEGIN
    DELETE FROM `productrecipes` WHERE `clientid` = $clientid AND `id` = $recipeid;
END $$
DELIMITER ;
