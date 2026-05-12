-- Migration Script: Implement Global clientid fields
-- Using $ prefix for Stored Procedure parameters as requested.
-- Naming: Use 'clientid' instead of 'client_id'.
-- Logic: Exclude detail and temp tables from multi-tenancy columns (they inherit via parents).

-- 1. Create Packages Table (Subscription Tiers)
DROP TABLE IF EXISTS `clients`; -- Drop child first due to FK
DROP TABLE IF EXISTS `packages`;

CREATE TABLE `packages` (
  `packageid` INT AUTO_INCREMENT PRIMARY KEY,
  `package_name` VARCHAR(50) NOT NULL,
  `price` DECIMAL(18,2) NOT NULL,
  `description` TEXT,
  `max_users` INT DEFAULT 5,
  `max_outlets` INT DEFAULT 1,
  `status` ENUM('active', 'inactive') DEFAULT 'active',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create Clients Table with extended details
CREATE TABLE `clients` (
  `clientid` INT AUTO_INCREMENT PRIMARY KEY,
  `client_name` VARCHAR(100) NOT NULL,
  `subdomain` VARCHAR(50) UNIQUE,
  `packageid` INT,
  `contact_person` VARCHAR(100),
  `phone_number` VARCHAR(20),
  `email` VARCHAR(100),
  `physical_address` TEXT,
  `city` VARCHAR(50),
  `country` VARCHAR(50),
  `due_date` DATE,
  `status` ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_client_package` FOREIGN KEY (`packageid`) REFERENCES `packages`(`packageid`)
);

-- Insert Default Packages
INSERT INTO `packages` (`package_name`, `price`, `description`) VALUES 
('Basic', 5000.00, 'Single outlet, up to 5 users'),
('Standard', 15000.00, 'Up to 3 outlets, up to 15 users'),
('Premium', 35000.00, 'Unlimited outlets, unlimited users');

-- 2. Add clientid to Master & Header tables
-- Master Data
ALTER TABLE `categories` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `categoryid`;
ALTER TABLE `products` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `productid`;
ALTER TABLE `customers` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `customerid`;
ALTER TABLE `suppliers` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `supplierid`;
ALTER TABLE `user` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `userid`;
ALTER TABLE `pointsofsale` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `posid`;
ALTER TABLE `zones` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `zoneid`;

-- Transactions (Header Tables Only)
ALTER TABLE `possales` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `possaleid`;
ALTER TABLE `gltransactions` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `transactionid`;
ALTER TABLE `journals` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `journalid`;
ALTER TABLE `stockmovement` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `stockmovementid`;
ALTER TABLE `purchaseorders` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `purchaseorderid`;
ALTER TABLE `goodsreceived` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `goodsreceivedid`;
ALTER TABLE `supplierinvoice` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `supplierinvoiceid`;
ALTER TABLE `paymentvouchers` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `paymentvoucherid`;
ALTER TABLE `stocktransfer` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `stocktransferid`;
ALTER TABLE `stockreconciledbalance` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `stockreconciledbalanceid`;
ALTER TABLE `customerreceipts` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `customerreceiptid`;
ALTER TABLE `heldsales` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `heldsalesid`;

-- System & Settings
ALTER TABLE `useroutlets` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `userprivileges` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `roleusers` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `tables` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `tableid`;
ALTER TABLE `cratesinventory` ADD COLUMN `clientid` INT DEFAULT 1 AFTER `id`;

-- Indexing for performance
CREATE INDEX idx_client_category ON `categories`(`clientid`);
CREATE INDEX idx_client_product ON `products`(`clientid`);
CREATE INDEX idx_client_customer ON `customers`(`clientid`);
CREATE INDEX idx_client_sale ON `possales`(`clientid`);

-- Example SP Refactor with $ prefix:
/*
CREATE PROCEDURE spsaveproduct(
  IN $clientid INT,
  IN $productid INT,
  IN $itemcode VARCHAR(50)
)
BEGIN
  IF $productid = 0 THEN
    INSERT INTO products (clientid, itemcode) VALUES ($clientid, $itemcode);
  ELSE
    UPDATE products SET itemcode = $itemcode WHERE productid = $productid AND clientid = $clientid;
  END IF;
END;
*/