-- Redo the first set of master table standardization to use clientid with foreign keys
-- Dropping the previously added branchid columns for these master tables
ALTER TABLE customers DROP COLUMN branchid;
ALTER TABLE products DROP COLUMN branchid;
ALTER TABLE categories DROP COLUMN branchid;
ALTER TABLE glaccounts DROP COLUMN branchid;
ALTER TABLE suppliers DROP COLUMN branchid;
ALTER TABLE taxtypes DROP COLUMN branchid;

-- Ensure clientid has a foreign key to clients table
ALTER TABLE customers ADD CONSTRAINT fk_customers_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE products ADD CONSTRAINT fk_products_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE categories ADD CONSTRAINT fk_categories_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE glaccounts ADD CONSTRAINT fk_glaccounts_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE suppliers ADD CONSTRAINT fk_suppliers_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);
ALTER TABLE taxtypes ADD CONSTRAINT fk_taxtypes_clients FOREIGN KEY (clientid) REFERENCES clients(clientid);

-- Ensure indexes on clientid
CREATE INDEX idx_customers_client ON customers(clientid);
CREATE INDEX idx_products_client ON products(clientid);
CREATE INDEX idx_categories_client ON categories(clientid);
CREATE INDEX idx_glaccounts_client ON glaccounts(clientid);
CREATE INDEX idx_suppliers_client ON suppliers(clientid);
CREATE INDEX idx_taxtypes_client ON taxtypes(clientid);

-- Update spsavepossale to use clientid for customer retrieval
DELIMITER //

DROP PROCEDURE IF EXISTS spsavepossale //

CREATE PROCEDURE spsavepossale(IN $branchid INT, IN $refno VARCHAR(50),
    IN $customerid INT,
    IN $posid INT,
    IN $transactiondate DATETIME,
    IN $reference VARCHAR(50),
    IN $userid INT
)
BEGIN
    DECLARE v_receiptno VARCHAR(50);
    DECLARE v_id INT;
    DECLARE v_customername VARCHAR(100);
    DECLARE v_clientid INT;
    DECLARE v_finished INT DEFAULT 0;
    DECLARE v_tempproductid INT;
    DECLARE v_tempquantity DECIMAL(18,2);
    DECLARE v_tempunitprice DECIMAL(18,2);
    DECLARE v_tempdiscount DECIMAL(18,2);
    DECLARE v_tempserialno VARCHAR(100);
    DECLARE v_temptaxid INT;
    DECLARE v_temptaxrate DECIMAL(18,2);
    DECLARE v_tempdescription VARCHAR(250);
    DECLARE v_stockmovementid INT;
    DECLARE v_purchasebalance DECIMAL(18,2);
    DECLARE v_fifoquantity DECIMAL(18,2);
    
    DECLARE cur_products CURSOR FOR 
        SELECT itemcode, quantity, unitprice, discount, serialno, 1 as taxid, 0 as taxrate, description 
        FROM tempsale WHERE branchid = $branchid AND refno = $refno;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;

    -- Get clientid for the branch
    SELECT clientid INTO v_clientid FROM branches WHERE branchid = $branchid;

    START TRANSACTION;
        
        SET v_receiptno = (SELECT spgeneratecustomerreceiptno($branchid));
        -- Use clientid for customers as they are client-wide master data
        SET v_customername = (SELECT customername FROM customers WHERE clientid = v_clientid AND customerid = $customerid);

        INSERT INTO possales (branchid, receiptno, customerid, pointofsaleid, receiptdate, reference, addedby, deleted)
        VALUES ($branchid, v_receiptno, $customerid, $posid, $transactiondate, $reference, $userid, 0);
        
        SET v_id = LAST_INSERT_ID();

        INSERT INTO possalesdetails (branchid, possaleid, itemcode, quantity, unitprice, discount, serialno, description)
        SELECT $branchid, v_id, itemcode, quantity, unitprice, discount, serialno, description
        FROM tempsale WHERE branchid = $branchid AND refno = $refno;

        INSERT INTO possalespayments (branchid, possaleid, paymentmode, reference, amount)
        SELECT $branchid, v_id, paymentmode, reference, amount
        FROM temppossalespayment WHERE branchid = $branchid AND refno = $refno;

        UPDATE serials SET currentno = currentno + 1 WHERE branchid = $branchid AND documenttype = 'Customer Receipt';

        OPEN cur_products;
        loop_products: LOOP
            FETCH cur_products INTO v_tempproductid, v_tempquantity, v_tempunitprice, v_tempdiscount, v_tempserialno, v_temptaxid, v_temptaxrate, v_tempdescription;
            IF v_finished = 1 THEN LEAVE loop_products; END IF;

            WHILE v_tempquantity > 0 DO
                SET v_stockmovementid = NULL;
                SET v_purchasebalance = 0;

                SELECT s.stockmovementid, (s.purchasequantity - IFNULL(SUM(sd.salesquantity), 0)) as available
                INTO v_stockmovementid, v_purchasebalance
                FROM stockmovement s
                LEFT JOIN stockmovementsalesdetails sd ON s.stockmovementid = sd.stockmovementid
                WHERE s.branchid = $branchid AND s.productid = v_tempproductid
                GROUP BY s.stockmovementid
                HAVING available > 0
                ORDER BY s.stockmovementid ASC LIMIT 1;

                IF v_stockmovementid IS NULL THEN
                    SET v_tempquantity = 0; 
                ELSE
                    IF v_purchasebalance > v_tempquantity THEN
                        SET v_fifoquantity = v_tempquantity;
                        SET v_tempquantity = 0;
                    ELSE
                        SET v_fifoquantity = v_purchasebalance;
                        SET v_tempquantity = v_tempquantity - v_purchasebalance;
                    END IF;

                    INSERT INTO stockmovementsalesdetails (branchid, stockmovementid, possaleid, salesquantity, sellingprice)
                    VALUES ($branchid, v_stockmovementid, v_id, v_fifoquantity, v_tempunitprice - v_tempdiscount);
                END IF;
            END WHILE;
        END LOOP loop_products;
        CLOSE cur_products;

        DELETE FROM tempsale WHERE branchid = $branchid AND refno = $refno;
        DELETE FROM temppossalespayment WHERE branchid = $branchid AND refno = $refno;

        SELECT v_receiptno AS receiptno;
    COMMIT;
END //

DELIMITER ;
