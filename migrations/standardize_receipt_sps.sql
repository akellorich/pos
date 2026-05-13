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
        pd.`taxrate`,
        SUM(pd.quantity * pd.unitprice) AS total,
        SUM(pd.quantity * pd.unitprice) * pd.`taxrate` / 100 AS vat
    FROM `possalesdetails` pd
    INNER JOIN `possales` p ON pd.`possaleid` = p.`possaleid`
    INNER JOIN `taxtypes` t ON pd.`taxtypeid` = t.`id`
    WHERE p.`branchid` = $branchid 
    AND p.`receiptno` = $receiptno
    AND t.`clientid` = $clientid
    GROUP BY t.`abbreviation`, pd.`taxrate`
    ORDER BY pd.`taxrate`;
END //

DELIMITER ;
