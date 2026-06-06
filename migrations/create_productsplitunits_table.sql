-- Migration: Create productsplitunits table and stored procedures

CREATE TABLE IF NOT EXISTS `productsplitunits` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `clientid` INT NOT NULL,
    `productid` INT NOT NULL,
    `unitname` VARCHAR(50) NOT NULL,
    `unitsoftotal` DECIMAL(10,4) NOT NULL,
    `unitprice` DECIMAL(10,2) NOT NULL,
    `addedby` INT NOT NULL,
    `dateadded` DATETIME NOT NULL,
    INDEX (`clientid`),
    INDEX (`productid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP PROCEDURE IF EXISTS `spgetproductsplitunits`;
DELIMITER $$
CREATE PROCEDURE `spgetproductsplitunits`(IN $clientid INT, IN $productid INT)
BEGIN
    SELECT psu.`id`, psu.`unitname`, psu.`unitsoftotal`, psu.`unitprice`, DATE_FORMAT(psu.`dateadded`, '%d-%b-%Y %H:%i') AS `dateadded`, u.`username` AS `addedby`, psu.`productid`
    FROM `productsplitunits` psu
    LEFT JOIN `user` u ON psu.`addedby` = u.`userid`
    WHERE psu.`clientid` = $clientid AND psu.`productid` = $productid
    ORDER BY psu.`unitname`;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spsaveproductsplitunit`;
DELIMITER $$
CREATE PROCEDURE `spsaveproductsplitunit`(
    IN $id INT,
    IN $clientid INT,
    IN $productid INT,
    IN $unitname VARCHAR(50),
    IN $unitsoftotal DECIMAL(10,4),
    IN $unitprice DECIMAL(10,2),
    IN $userid INT
)
BEGIN
    IF $id > 0 THEN
        UPDATE `productsplitunits`
        SET `unitname` = $unitname, `unitsoftotal` = $unitsoftotal, `unitprice` = $unitprice, `addedby` = $userid, `dateadded` = NOW()
        WHERE `clientid` = $clientid AND `id` = $id;
    ELSE
        INSERT INTO `productsplitunits` (`clientid`, `productid`, `unitname`, `unitsoftotal`, `unitprice`, `addedby`, `dateadded`)
        VALUES ($clientid, $productid, $unitname, $unitsoftotal, $unitprice, $userid, NOW());
    END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spdeleteproductsplitunit`;
DELIMITER $$
CREATE PROCEDURE `spdeleteproductsplitunit`(IN $clientid INT, IN $id INT)
BEGIN
    DELETE FROM `productsplitunits` WHERE `clientid` = $clientid AND `id` = $id;
END $$
DELIMITER ;
