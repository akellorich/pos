-- Redo master table standardization to use clientid with foreign keys
-- Dropping the previously added branchid columns for these specific tables
ALTER TABLE departments DROP COLUMN branchid;
ALTER TABLE warehouses DROP COLUMN branchid;
ALTER TABLE fleetvehicles DROP COLUMN branchid;
ALTER TABLE unitsofmeasure DROP COLUMN branchid;
ALTER TABLE zones DROP COLUMN branchid;
ALTER TABLE roles DROP COLUMN branchid;
ALTER TABLE currencies DROP COLUMN branchid;
ALTER TABLE glaccountgroups DROP COLUMN branchid;
ALTER TABLE glaccountclasses DROP COLUMN branchid;

-- Ensure clientid has a foreign key to clients table
ALTER TABLE departments ADD CONSTRAINT fk_departments_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE warehouses ADD CONSTRAINT fk_warehouses_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE fleetvehicles ADD CONSTRAINT fk_fleetvehicles_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE unitsofmeasure ADD CONSTRAINT fk_unitsofmeasure_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE zones ADD CONSTRAINT fk_zones_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE roles ADD CONSTRAINT fk_roles_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE currencies ADD CONSTRAINT fk_currencies_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE glaccountgroups ADD CONSTRAINT fk_glaccountgroups_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE glaccountclasses ADD CONSTRAINT fk_glaccountclasses_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);

-- Ensure indexes on clientid
CREATE INDEX idx_departments_client ON departments(clientid);
CREATE INDEX idx_warehouses_client ON warehouses(clientid);
CREATE INDEX idx_fleetvehicles_client ON fleetvehicles(clientid);
CREATE INDEX idx_unitsofmeasure_client ON unitsofmeasure(clientid);
CREATE INDEX idx_zones_client ON zones(clientid);
CREATE INDEX idx_roles_client ON roles(clientid);
CREATE INDEX idx_currencies_client ON currencies(clientid);
CREATE INDEX idx_glaccountgroups_client ON glaccountgroups(clientid);
CREATE INDEX idx_glaccountclasses_client ON glaccountclasses(clientid);
