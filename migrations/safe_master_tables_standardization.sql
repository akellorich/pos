-- Safe re-application of master table standardization
-- Using $ prefix for procedure variables as requested

DELIMITER //

DROP PROCEDURE IF EXISTS AddForeignKeySafe //

CREATE PROCEDURE AddForeignKeySafe(
    IN $table_name VARCHAR(100),
    IN $constraint_name VARCHAR(100),
    IN $column_name VARCHAR(100),
    IN $ref_table VARCHAR(100),
    IN $ref_column VARCHAR(100)
)
BEGIN
    -- Check if constraint already exists
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.REFERENTIAL_CONSTRAINTS 
        WHERE CONSTRAINT_SCHEMA = DATABASE() 
        AND CONSTRAINT_NAME = $constraint_name
    ) THEN
        SET @s = CONCAT('ALTER TABLE ', $table_name, ' ADD CONSTRAINT ', $constraint_name, 
                       ' FOREIGN KEY (', $column_name, ') REFERENCES ', $ref_table, '(', $ref_column, ')');
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //

DELIMITER ;

-- Primary Master Tables
CALL AddForeignKeySafe('customers', 'fk_customers_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('products', 'fk_products_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('categories', 'fk_categories_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('glaccounts', 'fk_glaccounts_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('suppliers', 'fk_suppliers_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('taxtypes', 'fk_taxtypes_clients', 'clientid', 'clients', 'clientid');

-- Support Master Tables
CALL AddForeignKeySafe('departments', 'fk_departments_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('warehouses', 'fk_warehouses_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('fleetvehicles', 'fk_fleetvehicles_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('unitsofmeasure', 'fk_unitsofmeasure_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('zones', 'fk_zones_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('roles', 'fk_roles_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('currencies', 'fk_currencies_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('glaccountgroups', 'fk_glaccountgroups_clients', 'clientid', 'clients', 'clientid');
CALL AddForeignKeySafe('glaccountclasses', 'fk_glaccountclasses_clients', 'clientid', 'clients', 'clientid');

DROP PROCEDURE IF EXISTS AddForeignKeySafe;
