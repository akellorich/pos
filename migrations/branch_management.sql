-- Migration Script: Standardize Schema and Implement Branch Support (Comprehensive Cleanup)
-- Standard: Primary Key = {entity}id, Discriminator = branchid (no underscore)

-- 1. Create Branches Table
CREATE TABLE IF NOT EXISTS `branches` (
  `branchid` INT AUTO_INCREMENT PRIMARY KEY,
  `clientid` INT NOT NULL,
  `branch_name` VARCHAR(100) NOT NULL,
  `branch_code` VARCHAR(20),
  `location` VARCHAR(100),
  `phone_number` VARCHAR(20),
  `email` VARCHAR(100),
  `is_main` TINYINT(1) DEFAULT 0,
  `status` ENUM('active', 'inactive') DEFAULT 'active',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_branch_client` FOREIGN KEY (`clientid`) REFERENCES `clients`(`clientid`) ON DELETE CASCADE
);

-- 2. Initialize Default Branches
INSERT INTO `branches` (clientid, branch_name, is_main, status)
SELECT clientid, CONCAT(client_name, ' - Head Office'), 1, 'active' 
FROM clients 
WHERE clientid NOT IN (SELECT DISTINCT clientid FROM branches);

-- 3. Standardize and Transition Tables (Drop Client Columns)

-- User
ALTER TABLE `user` CHANGE COLUMN `id` `userid` INT AUTO_INCREMENT;
UPDATE `user` t JOIN `branches` b ON t.client_id = b.clientid SET t.branchid = b.branchid WHERE b.is_main = 1;
ALTER TABLE `user` DROP COLUMN `client_id`;

-- Categories
-- Already categoryid and branchid in database.sql

-- Products
-- Already productid and branchid in database.sql

-- Points of Sale
ALTER TABLE `pointsofsale` CHANGE COLUMN `id` `posid` INT AUTO_INCREMENT;
ALTER TABLE `pointsofsale` ADD COLUMN `branchid` INT AFTER `posid`;
UPDATE `pointsofsale` t JOIN `branches` b ON t.client_id = b.clientid SET t.branchid = b.branchid WHERE b.is_main = 1;
ALTER TABLE `pointsofsale` DROP COLUMN `client_id`;

-- POS Sales
ALTER TABLE `possales` CHANGE COLUMN `id` `possaleid` INT AUTO_INCREMENT;
UPDATE `possales` t JOIN `branches` b ON t.client_id = b.clientid SET t.branchid = b.branchid WHERE b.is_main = 1;
ALTER TABLE `possales` DROP COLUMN `client_id`;

-- POS Sales Details (Drop client_id)
ALTER TABLE `possalesdetails` CHANGE COLUMN `id` `id` INT AUTO_INCREMENT; -- Keep generic id for details or use possaledetailid?
ALTER TABLE `possalesdetails` DROP COLUMN `client_id`;

-- GL Transactions
ALTER TABLE `gltransactions` CHANGE COLUMN `id` `transactionid` INT AUTO_INCREMENT;
ALTER TABLE `gltransactions` ADD COLUMN `branchid` INT AFTER `transactionid`;
UPDATE `gltransactions` t JOIN `branches` b ON t.client_id = b.clientid SET t.branchid = b.branchid WHERE b.is_main = 1;
ALTER TABLE `gltransactions` DROP COLUMN `client_id`;

-- Goods Received
ALTER TABLE `goodsreceived` CHANGE COLUMN `id` `goodsreceivedid` INT AUTO_INCREMENT;
ALTER TABLE `goodsreceived` ADD COLUMN `branchid` INT AFTER `goodsreceivedid`;
UPDATE `goodsreceived` t JOIN `branches` b ON t.client_id = b.clientid SET t.branchid = b.branchid WHERE b.is_main = 1;
ALTER TABLE `goodsreceived` DROP COLUMN `client_id`;

-- Goods Received Details (Drop client_id if exists)
-- ALTER TABLE `goodsreceiveddetails` DROP COLUMN `client_id`;

-- Journals
ALTER TABLE `journals` CHANGE COLUMN `id` `journalid` INT AUTO_INCREMENT;
ALTER TABLE `journals` ADD COLUMN `branchid` INT AFTER `journalid`;
UPDATE `journals` t JOIN `branches` b ON t.client_id = b.clientid SET t.branchid = b.branchid WHERE b.is_main = 1;
ALTER TABLE `journals` DROP COLUMN `client_id`;

-- Purchase Orders
ALTER TABLE `purchaseorders` CHANGE COLUMN `id` `purchaseorderid` INT AUTO_INCREMENT;
ALTER TABLE `purchaseorders` ADD COLUMN `branchid` INT AFTER `purchaseorderid`;
UPDATE `purchaseorders` t JOIN `branches` b ON t.client_id = b.clientid SET t.branchid = b.branchid WHERE b.is_main = 1;
ALTER TABLE `purchaseorders` DROP COLUMN `client_id`;

-- Stock Movement
ALTER TABLE `stockmovement` CHANGE COLUMN `id` `stockmovementid` INT AUTO_INCREMENT;
ALTER TABLE `stockmovement` ADD COLUMN `branchid` INT AFTER `stockmovementid`;
UPDATE `stockmovement` t JOIN `branches` b ON t.client_id = b.clientid SET t.branchid = b.branchid WHERE b.is_main = 1;
ALTER TABLE `stockmovement` DROP COLUMN `client_id`;

-- Zones
ALTER TABLE `zones` CHANGE COLUMN `id` `zoneid` INT AUTO_INCREMENT;
ALTER TABLE `zones` ADD COLUMN `branchid` INT AFTER `zoneid`;
UPDATE `zones` t JOIN `branches` b ON t.client_id = b.clientid SET t.branchid = b.branchid WHERE b.is_main = 1;
ALTER TABLE `zones` DROP COLUMN `client_id`;

-- Supplier Invoice
ALTER TABLE `supplierinvoice` CHANGE COLUMN `id` `supplierinvoiceid` INT AUTO_INCREMENT;
ALTER TABLE `supplierinvoice` ADD COLUMN `branchid` INT AFTER `supplierinvoiceid`;

-- Payment Vouchers
ALTER TABLE `paymentvouchers` CHANGE COLUMN `id` `paymentvoucherid` INT AUTO_INCREMENT;
ALTER TABLE `paymentvouchers` ADD COLUMN `branchid` INT AFTER `paymentvoucherid`;

-- Stock Transfer
ALTER TABLE `stocktransfer` CHANGE COLUMN `id` `stocktransferid` INT AUTO_INCREMENT;
ALTER TABLE `stocktransfer` ADD COLUMN `branchid` INT AFTER `stocktransferid`;

-- Stock Reconciled Balance
ALTER TABLE `stockreconciledbalance` CHANGE COLUMN `id` `stockreconciledbalanceid` INT AUTO_INCREMENT;
ALTER TABLE `stockreconciledbalance` ADD COLUMN `branchid` INT AFTER `stockreconciledbalanceid`;

-- Customer Receipts
ALTER TABLE `customerreceipts` CHANGE COLUMN `id` `customerreceiptid` INT AUTO_INCREMENT;
ALTER TABLE `customerreceipts` ADD COLUMN `branchid` INT AFTER `customerreceiptid`;

-- Held Sales
ALTER TABLE `heldsales` CHANGE COLUMN `id` `heldsalesid` INT AUTO_INCREMENT;
ALTER TABLE `heldsales` ADD COLUMN `branchid` INT AFTER `heldsalesid`;

-- Link Tables Cleanup
ALTER TABLE `useroutlets` CHANGE COLUMN `id` `useroutletid` INT AUTO_INCREMENT;
-- ALTER TABLE `useroutlets` DROP COLUMN `clientid`;
ALTER TABLE `userprivileges` CHANGE COLUMN `id` `userprivilegeid` INT AUTO_INCREMENT;
ALTER TABLE `roleusers` CHANGE COLUMN `id` `roleuserid` INT AUTO_INCREMENT;
ALTER TABLE `cratesinventory` CHANGE COLUMN `id` `cratesinventoryid` INT AUTO_INCREMENT;
ALTER TABLE `tables` CHANGE COLUMN `tableid` `tableid` INT AUTO_INCREMENT; -- Ensure PK
