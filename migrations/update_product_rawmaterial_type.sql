-- Migration: Add product options and update spsaveproduct
-- 1. Safely add columns if they do not exist
DROP PROCEDURE IF EXISTS add_product_columns;
DELIMITER $$
CREATE PROCEDURE add_product_columns()
BEGIN
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'products' AND column_name = 'itemtype') THEN
        ALTER TABLE `products` ADD COLUMN `itemtype` VARCHAR(50) DEFAULT 'product';
    END IF;
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'products' AND column_name = 'disallowpurchasing') THEN
        ALTER TABLE `products` ADD COLUMN `disallowpurchasing` TINYINT(1) DEFAULT 0;
    END IF;
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'products' AND column_name = 'disallowreceipt') THEN
        ALTER TABLE `products` ADD COLUMN `disallowreceipt` TINYINT(1) DEFAULT 0;
    END IF;
    IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'products' AND column_name = 'disallowsale') THEN
        ALTER TABLE `products` ADD COLUMN `disallowsale` TINYINT(1) DEFAULT 0;
    END IF;
END $$
DELIMITER ;
CALL add_product_columns();
DROP PROCEDURE IF EXISTS add_product_columns;

-- 2. Drop and recreate the updated spsaveproduct stored procedure
DROP PROCEDURE IF EXISTS `spsaveproduct`;
DELIMITER $$
CREATE PROCEDURE `spsaveproduct`(
    IN $clientid INT, 
    IN $id NUMERIC, 
    IN $itemcode VARCHAR(50),
    IN $itemname VARCHAR(50),
    IN $categoryid NUMERIC,
    IN $uom VARCHAR(50),
    IN $buyingprice DECIMAL(18,2),
    IN $sellingprice DECIMAL(18,2),
    IN $reorderlevel NUMERIC,
    IN $userid NUMERIC,
    IN $refno VARCHAR(50),
    IN $generateitemcode BOOL,
    IN $canserialize BOOL,
    IN $bundleitem BOOLEAN,
    IN $taxtypeid INT,
    IN $itemlength DECIMAL(18,2),
    IN $itemwidth DECIMAL(18,2),
    IN $itemheight DECIMAL(18,2),
    IN $allownegativesales BOOL,
    IN $saleby VARCHAR(50),
    IN $bundleproduct INT,
    IN $allowreturnexchange BOOL,
    IN $rawmaterial BOOL,
    IN $itemtype VARCHAR(50),
    IN $disallowpurchasing BOOL,
    IN $disallowreceipt BOOL,
    IN $disallowsale BOOL
)
BEGIN
    IF $id=0 THEN 
        IF $generateitemcode=1 THEN
            SET $itemcode=(SELECT fngenerateproductcode(clientid, $categoryid));
            UPDATE `categories` SET `currentno`=`currentno`+1 WHERE clientid = $clientid AND `categoryid`=$categoryid;
        END IF;
        INSERT INTO `products`(
            clientid, `itemcode`, `itemname`, `unitofmeasure`, `buyingprice`, `sellingprice`, `categoryid`, `dateadded`, `addedby`, `deleted`, `reorderlevel`, `serializable`,
            `bundleitem`, `taxtypeid`, `length`, `width`, `height`, `allownegativesales`, `saleby`, `bundledproduct`, `allowreturnexchange`,
            `rawmaterial`, `itemtype`, `disallowpurchasing`, `disallowreceipt`, `disallowsale`
        ) VALUES (
            $clientid, $itemcode, $itemname, $uom, $buyingprice, $sellingprice, $categoryid, NOW(), $userid, 0, $reorderlevel, $canserialize,
            $bundleitem, $taxtypeid, $itemlength, $itemwidth, $itemheight, $allownegativesales, $saleby, $bundleproduct, $allowreturnexchange,
            $rawmaterial, $itemtype, $disallowpurchasing, $disallowreceipt, $disallowsale
        );
    ELSE
        UPDATE `products` SET 
            `itemcode`=$itemcode, `itemname`=$itemname, `unitofmeasure`=$uom, `buyingprice`=$buyingprice, `sellingprice`=$sellingprice,
            `categoryid`=$categoryid, `reorderlevel`=$reorderlevel, `lastmodifiedon`=NOW(), `lastmodifiedby`=$userid, `serializable`=$canserialize, 
            `bundleitem`=$bundleitem, `taxtypeid`=$taxtypeid, `length`=$itemlength, `width`=$itemwidth, `height`=$itemheight, `allownegativesales`=$allownegativesales,
            `saleby`=$saleby, `bundledproduct`=$bundleproduct, `allowreturnexchange`=$allowreturnexchange,
            `rawmaterial`=$rawmaterial, `itemtype`=$itemtype, `disallowpurchasing`=$disallowpurchasing, `disallowreceipt`=$disallowreceipt, `disallowsale`=$disallowsale
        WHERE clientid = $clientid AND `productid`=$id;
    END IF;
END $$
DELIMITER ;
