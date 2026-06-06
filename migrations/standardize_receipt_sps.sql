DELIMITER //

-- Update spgetpossalespayments
DROP PROCEDURE IF EXISTS spgetpossalespayments //
CREATE PROCEDURE spgetpossalespayments(
    IN $clientid INT,
    IN $branchid INT,
    IN $receiptno VARCHAR(50)
)
BEGIN
    SELECT 
        m.`description` AS paymentmethod, 
        CASE WHEN p.`reference`='' THEN '-' ELSE p.`reference` END AS reference,
        p.`amount` 
    FROM `possalespayments` p
    INNER JOIN `paymentmethods` m ON p.`paymentmode` = m.`id`
    INNER JOIN `possales` ps ON ps.`possaleid` = p.`possaleid`
    WHERE ps.`branchid` = $branchid 
    AND ps.`receiptno` = $receiptno
    AND m.`clientid` = $clientid;
END //

-- Update spgetreceiptvatanalysis
DROP PROCEDURE IF EXISTS spgetreceiptvatanalysis //
CREATE PROCEDURE spgetreceiptvatanalysis(
    IN $clientid INT,
    IN $branchid INT,
    IN $receiptno VARCHAR(50)
)
BEGIN
    SELECT 
        t.`abbreviation`,
        IFNULL(pd.`taxrate`, t.`taxrate`) AS taxrate,
        SUM(pd.quantity * (pd.unitprice - pd.discount)) AS total,
        SUM(pd.quantity * (pd.unitprice - pd.discount)) * IFNULL(pd.`taxrate`, t.`taxrate`) / (100 + IFNULL(pd.`taxrate`, t.`taxrate`)) AS vat
    FROM `possalesdetails` pd
    INNER JOIN `possales` p ON pd.`possaleid` = p.`possaleid`
    INNER JOIN `products` prod ON pd.`itemcode` = prod.`productid`
    INNER JOIN `taxtypes` t ON IFNULL(pd.`taxtypeid`, prod.`taxtypeid`) = t.`id`
    WHERE p.`branchid` = $branchid 
    AND p.`receiptno` = $receiptno
    AND t.`clientid` = $clientid
    GROUP BY t.`abbreviation`, taxrate
    ORDER BY taxrate;
END //

DELIMITER ;
