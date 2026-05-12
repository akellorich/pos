-- Migration Script: Implement Global clientid fields
-- This script adds client_id to all major tables and creates the clients master table.

-- 1. Create Clients Table
CREATE TABLE IF NOT EXISTS `clients` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `client_name` VARCHAR(100) NOT NULL,
  `subdomain` VARCHAR(50) UNIQUE,
  `status` ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Add client_id to core tables
-- Master Data
ALTER TABLE `categories` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `products` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `customers` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `suppliers` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `user` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `pointsofsale` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `zones` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;

-- Transactions
ALTER TABLE `possales` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `possalesdetails` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `gltransactions` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `journals` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `stockmovement` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `purchaseorders` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;
ALTER TABLE `goodsreceived` ADD COLUMN `client_id` INT DEFAULT 1 AFTER `id`;

-- Indexing for performance
CREATE INDEX idx_client_category ON `categories`(`client_id`);
CREATE INDEX idx_client_product ON `products`(`client_id`);
CREATE INDEX idx_client_customer ON `customers`(`client_id`);
CREATE INDEX idx_client_sale ON `possales`(`client_id`);
