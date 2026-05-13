-- Add branchid to master tables that were missing it
ALTER TABLE customers ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE products ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE categories ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE glaccounts ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE suppliers ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE taxtypes ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;

-- Seed existing data with branchid 1
UPDATE customers SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE products SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE categories SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE glaccounts SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE suppliers SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE taxtypes SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;

-- Ensure indexes for performance
CREATE INDEX idx_customers_branch ON customers(branchid);
CREATE INDEX idx_products_branch ON products(branchid);
CREATE INDEX idx_categories_branch ON categories(branchid);
CREATE INDEX idx_glaccounts_branch ON glaccounts(branchid);
CREATE INDEX idx_suppliers_branch ON suppliers(branchid);
CREATE INDEX idx_taxtypes_branch ON taxtypes(branchid);
