-- Further standardize master tables with branchid
ALTER TABLE departments ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE warehouses ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE fleetvehicles ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE unitsofmeasure ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE zones ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE roles ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE currencies ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE glaccountgroups ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;
ALTER TABLE glaccountclasses ADD COLUMN branchid INT DEFAULT 1 AFTER clientid;

-- Seed existing data with branchid 1
UPDATE departments SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE warehouses SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE fleetvehicles SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE unitsofmeasure SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE zones SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE roles SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE currencies SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE glaccountgroups SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;
UPDATE glaccountclasses SET branchid = 1 WHERE branchid IS NULL OR branchid = 0;

-- Ensure indexes for performance
CREATE INDEX idx_departments_branch ON departments(branchid);
CREATE INDEX idx_warehouses_branch ON warehouses(branchid);
CREATE INDEX idx_fleetvehicles_branch ON fleetvehicles(branchid);
CREATE INDEX idx_unitsofmeasure_branch ON unitsofmeasure(branchid);
CREATE INDEX idx_zones_branch ON zones(branchid);
CREATE INDEX idx_roles_branch ON roles(branchid);
CREATE INDEX idx_currencies_branch ON currencies(branchid);
CREATE INDEX idx_glaccountgroups_branch ON glaccountgroups(branchid);
CREATE INDEX idx_glaccountclasses_branch ON glaccountclasses(branchid);
