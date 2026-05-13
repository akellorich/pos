-- Add branchid as primary key and auto increment (ignore error if already exists)
-- Since we can't do IF NOT EXISTS for ADD COLUMN easily, we check first or wrap in a procedure,
-- but for now we assume the previous column add might have succeeded.
-- If branchid exists, this line will fail, but the rest will proceed if run individually.

-- Drop existing constraints to avoid "Duplicate key" error
ALTER TABLE branches DROP FOREIGN KEY IF EXISTS fk_branch_client;
ALTER TABLE branches DROP FOREIGN KEY IF EXISTS fk_branches_clients;

-- Ensure clientid relates with clients table
ALTER TABLE branches MODIFY COLUMN clientid INT(11) NOT NULL;

-- Add unified foreign key constraint
ALTER TABLE branches ADD CONSTRAINT fk_branches_clients 
FOREIGN KEY (clientid) REFERENCES clients(clientid) 
ON DELETE CASCADE ON UPDATE CASCADE;
