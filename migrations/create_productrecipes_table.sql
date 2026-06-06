-- Migration: Create productrecipes table
CREATE TABLE IF NOT EXISTS `productrecipes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `clientid` INT NOT NULL,
    `productid` INT NOT NULL,
    `recipeitemid` INT NOT NULL,
    `quantity` DECIMAL(10,4) NOT NULL,
    `addedby` INT NOT NULL,
    `dateadded` DATETIME NOT NULL,
    INDEX (`clientid`),
    INDEX (`productid`),
    INDEX (`recipeitemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
