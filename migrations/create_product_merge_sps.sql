DELIMITER $$

DROP PROCEDURE IF EXISTS `spcheckproducttransactions`$$

CREATE PROCEDURE `spcheckproducttransactions`(
    IN $clientid INT,
    IN $productid INT
)
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE cnt INT DEFAULT 0;
    
    -- Check possalesdetails
    SELECT COUNT(*) INTO cnt FROM possalesdetails WHERE itemcode = $productid;
    SET total = total + cnt;
    
    -- Check goodsreceiveddetails
    SELECT COUNT(*) INTO cnt FROM goodsreceiveddetails WHERE itemcode = $productid;
    SET total = total + cnt;
    
    -- Check stocktransferdetails
    SELECT COUNT(*) INTO cnt FROM stocktransferdetails WHERE itemcode = $productid;
    SET total = total + cnt;
    
    -- Check stockreconciledbalancedetails
    SELECT COUNT(*) INTO cnt FROM stockreconciledbalancedetails WHERE itemid = $productid;
    SET total = total + cnt;
    
    -- Check spoilage
    SELECT COUNT(*) INTO cnt FROM spoilage WHERE productid = $productid;
    SET total = total + cnt;
    
    -- Check purchaseorderdetails
    SELECT COUNT(*) INTO cnt FROM purchaseorderdetails WHERE itemcode = $productid;
    SET total = total + cnt;
    
    -- Check heldsalesdetails
    SELECT COUNT(*) INTO cnt FROM heldsalesdetails WHERE productid = $productid;
    SET total = total + cnt;
    
    -- Check cratesinventory
    SELECT COUNT(*) INTO cnt FROM cratesinventory WHERE productid = $productid;
    SET total = total + cnt;
    
    -- Check stockmovement
    SELECT COUNT(*) INTO cnt FROM stockmovement WHERE productid = $productid;
    SET total = total + cnt;
    
    SELECT total AS total_transactions;
END$$

DROP PROCEDURE IF EXISTS `spmergeanddeleteproduct`$$

CREATE PROCEDURE `spmergeanddeleteproduct`(
    IN $clientid INT,
    IN $source_id INT,
    IN $target_id INT,
    IN $userid INT
)
BEGIN
    START TRANSACTION;
    
    -- 1. Update all transaction tables referencing the product
    UPDATE possalesdetails SET itemcode = $target_id WHERE itemcode = $source_id;
    UPDATE goodsreceiveddetails SET itemcode = $target_id WHERE itemcode = $source_id;
    UPDATE stocktransferdetails SET itemcode = $target_id WHERE itemcode = $source_id;
    UPDATE stockreconciledbalancedetails SET itemid = $target_id WHERE itemid = $source_id;
    UPDATE spoilage SET productid = $target_id WHERE productid = $source_id;
    UPDATE purchaseorderdetails SET itemcode = $target_id WHERE itemcode = $source_id;
    UPDATE heldsalesdetails SET productid = $target_id WHERE productid = $source_id;
    UPDATE cratesinventory SET productid = $target_id WHERE productid = $source_id;
    UPDATE stockmovement SET productid = $target_id WHERE productid = $source_id;
    
    -- 2. Update metadata/relationship tables
    UPDATE productpricehistory SET productid = $target_id WHERE productid = $source_id;
    UPDATE productsplitunits SET productid = $target_id WHERE productid = $source_id;
    UPDATE productrecipes SET productid = $target_id WHERE productid = $source_id;
    UPDATE productrecipes SET recipeitemid = $target_id WHERE recipeitemid = $source_id;
    UPDATE supplierproducts SET productid = $target_id WHERE productid = $source_id;
    UPDATE tempstocktransfer SET itemcode = $target_id WHERE itemcode = $source_id;
    UPDATE tempstockreconcilebalancedetails SET itemid = $target_id WHERE itemid = $source_id;
    
    -- 3. Mark the source product as deleted
    UPDATE products SET deleted = 1, lastmodifiedon = NOW(), lastmodifiedby = $userid 
    WHERE clientid = $clientid AND productid = $source_id;
    
    COMMIT;
END$$

DELIMITER ;
