-- Create table productpricehistory if it does not exist
CREATE TABLE IF NOT EXISTS `productpricehistory` (
    `priceid` INT AUTO_INCREMENT PRIMARY KEY,
    `productid` INT NOT NULL,
    `price` DECIMAL(18,2) NOT NULL,
    `addedby` INT NOT NULL,
    `dateadded` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Truncate existing price history to start with a clean reconstruction
TRUNCATE TABLE `productpricehistory`;

-- Populate the productpricehistory table with historical selling prices
INSERT INTO `productpricehistory` (`productid`, `price`, `addedby`, `dateadded`)
SELECT 
    productid, 
    price, 
    MIN(addedby) AS addedby, 
    MIN(dateadded) AS dateadded
FROM (
    -- 1. Extract the baseline/initial prices of products from the products table
    SELECT 
        `productid`, 
        `sellingprice` AS price, 
        COALESCE(`addedby`, 1) AS addedby, 
        COALESCE(`dateadded`, NOW()) AS dateadded
    FROM `products`
    WHERE `sellingprice` IS NOT NULL
    
    UNION ALL
    
    -- 2. Extract historical price points from actual sales records in possalesdetails
    SELECT 
        sd.`itemcode` AS productid, 
        sd.`unitprice` AS price, 
        COALESCE(s.`addedby`, 1) AS addedby, 
        s.`receiptdate` AS dateadded
    FROM `possalesdetails` sd
    JOIN `possales` s ON sd.`possaleid` = s.`possaleid`
    WHERE s.`deleted` = 0 AND sd.`unitprice` IS NOT NULL
) AS combined_history
GROUP BY productid, price
ORDER BY productid, dateadded;
