USE pos;

DROP PROCEDURE IF EXISTS `spsavetempsale`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spsavetempsale`(
    IN $branchid INT, 
    IN $refno VARCHAR(50),
    IN $itemcode VARCHAR(50),
    IN $quantity DECIMAL(18,2),
    IN $unitprice DECIMAL(18,2),
    IN $discount DECIMAL(18,2),
    IN $serialno VARCHAR(100),
    IN $description VARCHAR(250),
    IN $uom VARCHAR(50)
)
BEGIN
    INSERT INTO `tempsale` (branchid, `refno`, `itemcode`, `quantity`, `unitprice`, `discount`, `serialno`, `description`, `uom`)
    VALUES ($branchid, $refno, $itemcode, $quantity, $unitprice, $discount, $serialno, $description, $uom);
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS `spsavepossale`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spsavepossale`(
    IN $branchid INT, 
    IN $refno VARCHAR(50),
    IN $customerid INT,
    IN $posid INT,
    IN $transactiondate DATETIME,
    IN $reference VARCHAR(50),
    IN $userid INT
)
BEGIN
    DECLARE $receiptno VARCHAR(50);
    DECLARE $id INT;
    DECLARE $customername VARCHAR(100);
    DECLARE $clientid INT;
    DECLARE $sessionid INT;
    DECLARE $finished INT DEFAULT 0;
    DECLARE $tempproductid INT;
    DECLARE $tempquantity DECIMAL(18,2);
    DECLARE $tempunitprice DECIMAL(18,2);
    DECLARE $tempdiscount DECIMAL(18,2);
    DECLARE $tempserialno VARCHAR(100);
    DECLARE $temptaxid INT;
    DECLARE $temptaxrate DECIMAL(18,2);
    DECLARE $tempdescription VARCHAR(250);
    DECLARE $stockmovementid INT;
    DECLARE $purchasebalance DECIMAL(18,2);
    DECLARE $fifoquantity DECIMAL(18,2);
    
    DECLARE cur_products CURSOR FOR 
        SELECT itemcode, quantity, unitprice, discount, serialno, 1 as taxid, 0 as taxrate, description 
        FROM tempsale WHERE branchid = $branchid AND refno = $refno;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET $finished = 1;

    SELECT clientid INTO $clientid FROM branches WHERE branchid = $branchid;
    
    SELECT sessionid INTO $sessionid FROM sessions WHERE branchid = $branchid AND addedby = $userid AND status = 'active' LIMIT 1;

    START TRANSACTION;
        SET $receiptno = (SELECT spgeneratecustomerreceiptno($branchid));
        SET $customername = (SELECT customername FROM customers WHERE clientid = $clientid AND customerid = $customerid);

        INSERT INTO possales (branchid, sessionid, receiptno, customerid, pointofsaleid, receiptdate, reference, addedby, deleted)
        VALUES ($branchid, $sessionid, $receiptno, $customerid, $posid, $transactiondate, $reference, $userid, 0);
        
        SET $id = LAST_INSERT_ID();

        INSERT INTO possalesdetails (branchid, possaleid, itemcode, quantity, unitprice, discount, serialno, taxtypeid, taxrate, description, uom)
        SELECT $branchid, $id, itemcode, quantity, unitprice, discount, serialno, taxtypeid, taxrate, description, uom
        FROM tempsale WHERE branchid = $branchid AND refno = $refno;

        INSERT INTO possalespayments (branchid, possaleid, paymentmode, reference, amount)
        SELECT $branchid, $id, paymentmodeid, reference, amount
        FROM temppossalespayment WHERE branchid = $branchid AND refno = $refno;

        UPDATE serials SET currentno = currentno + 1 WHERE branchid = $branchid AND documenttype = 'Customer Receipt';

        OPEN cur_products;
        loop_products: LOOP
            FETCH cur_products INTO $tempproductid, $tempquantity, $tempunitprice, $tempdiscount, $tempserialno, $temptaxid, $temptaxrate, $tempdescription;
            IF $finished = 1 THEN LEAVE loop_products; END IF;

            WHILE $tempquantity > 0 DO
                SET $stockmovementid = NULL;
                SET $purchasebalance = 0;

                SELECT s.stockmovementid, (s.purchasequantity - IFNULL(SUM(sd.salesquantity), 0)) as available
                INTO $stockmovementid, $purchasebalance
                FROM stockmovement s
                LEFT JOIN stockmovementsalesdetails sd ON s.stockmovementid = sd.stockmovementid
                WHERE s.branchid = $branchid AND s.productid = $tempproductid
                GROUP BY s.stockmovementid
                HAVING available > 0
                ORDER BY s.stockmovementid ASC LIMIT 1;

                IF $stockmovementid IS NULL THEN
                    SET $tempquantity = 0; 
                ELSE
                    IF $purchasebalance > $tempquantity THEN
                        SET $fifoquantity = $tempquantity;
                        SET $tempquantity = 0;
                    ELSE
                        SET $fifoquantity = $purchasebalance;
                        SET $tempquantity = $tempquantity - $purchasebalance;
                    END IF;

                    INSERT INTO stockmovementsalesdetails (branchid, stockmovementid, possaleid, salesquantity, sellingprice)
                    VALUES ($branchid, $stockmovementid, $id, $fifoquantity, $tempunitprice - $tempdiscount);
                END IF;
            END WHILE;
        END LOOP loop_products;
        CLOSE cur_products;

        DELETE FROM tempsale WHERE branchid = $branchid AND refno = $refno;
        DELETE FROM temppossalespayment WHERE branchid = $branchid AND refno = $refno;

        SELECT $receiptno AS receiptno;
    COMMIT;
END $$

DELIMITER ;
