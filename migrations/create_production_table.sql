-- Migration: Create productions table and stored procedures with soft delete

CREATE TABLE IF NOT EXISTS `productions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `clientid` INT NOT NULL,
    `productiondate` DATE NOT NULL,
    `productid` INT NOT NULL,
    `quantity` DECIMAL(12,4) NOT NULL,
    `warehouseid` INT NOT NULL,
    `addedby` INT NOT NULL,
    `dateadded` DATETIME NOT NULL,
    `deleted` TINYINT(1) NOT NULL DEFAULT 0,
    `lastupdatedby` INT DEFAULT NULL,
    `lastdateupdated` DATETIME DEFAULT NULL,
    INDEX (`clientid`),
    INDEX (`productid`),
    INDEX (`warehouseid`),
    INDEX (`productiondate`),
    INDEX (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ensure columns exist if table was already created in earlier migration step
ALTER TABLE `productions` ADD COLUMN IF NOT EXISTS `deleted` TINYINT(1) NOT NULL DEFAULT 0;
ALTER TABLE `productions` ADD COLUMN IF NOT EXISTS `lastupdatedby` INT DEFAULT NULL;
ALTER TABLE `productions` ADD COLUMN IF NOT EXISTS `lastdateupdated` DATETIME DEFAULT NULL;

DROP PROCEDURE IF EXISTS `spgetproductions`;
DELIMITER $$
CREATE PROCEDURE `spgetproductions`(
    IN $clientid INT,
    IN $alldates INT,
    IN $startdate DATE,
    IN $enddate DATE,
    IN $warehouseid INT,
    IN $productid INT
)
BEGIN
    SELECT pr.`id`, DATE_FORMAT(pr.`productiondate`, '%d-%b-%Y') AS `productiondate_fmt`, pr.`productiondate`, pr.`productid`, pr.`quantity`, pr.`warehouseid`, DATE_FORMAT(pr.`dateadded`, '%d-%b-%Y %H:%i') AS `dateadded_fmt`,
           p.`itemname`, p.`itemcode`, p.`uom`, w.`warehousename`, u.`username` AS `addedby`
    FROM `productions` pr
    INNER JOIN `products` p ON pr.`productid` = p.`productid`
    INNER JOIN `warehouses` w ON pr.`warehouseid` = w.`warehouseid`
    INNER JOIN `users` u ON pr.`addedby` = u.`userid`
    WHERE pr.`clientid` = $clientid
      AND pr.`deleted` = 0
      AND ($alldates = 1 OR (pr.`productiondate` BETWEEN $startdate AND $enddate))
      AND ($warehouseid = 0 OR pr.`warehouseid` = $warehouseid)
      AND ($productid = 0 OR pr.`productid` = $productid)
    ORDER BY pr.`productiondate` DESC, pr.`id` DESC;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spsaveproduction`;
DELIMITER $$
CREATE PROCEDURE `spsaveproduction`(
    IN $id INT,
    IN $clientid INT,
    IN $productiondate DATE,
    IN $productid INT,
    IN $quantity DECIMAL(12,4),
    IN $warehouseid INT,
    IN $userid INT
)
BEGIN
    IF $id > 0 THEN
        UPDATE `productions`
        SET `productiondate` = $productiondate, `productid` = $productid, `quantity` = $quantity, `warehouseid` = $warehouseid, `lastupdatedby` = $userid, `lastdateupdated` = NOW()
        WHERE `clientid` = $clientid AND `id` = $id;
    ELSE
        INSERT INTO `productions` (`clientid`, `productiondate`, `productid`, `quantity`, `warehouseid`, `addedby`, `dateadded`)
        VALUES ($clientid, $productiondate, $productid, $quantity, $warehouseid, $userid, NOW());
    END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spdeleteproduction`;
DELIMITER $$
CREATE PROCEDURE `spdeleteproduction`(
    IN $clientid INT,
    IN $id INT,
    IN $userid INT
)
BEGIN
    UPDATE `productions`
    SET `deleted` = 1, `lastupdatedby` = $userid, `lastdateupdated` = NOW()
    WHERE `clientid` = $clientid AND `id` = $id;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `spgetproductswithrecipes`;
DELIMITER $$
CREATE PROCEDURE `spgetproductswithrecipes`(IN $clientid INT)
BEGIN
    SELECT DISTINCT p.`productid`, p.`itemname`, p.`itemcode`, p.`uom`
    FROM `products` p
    INNER JOIN `productrecipes` pr ON p.`productid` = pr.`productid`
    WHERE p.`clientid` = $clientid AND p.`deleted` = 0
    ORDER BY p.`itemname` ASC;
END $$
DELIMITER ;

