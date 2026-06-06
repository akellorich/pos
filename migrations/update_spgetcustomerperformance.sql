-- Standardize spgetcustomerperformance for multi-tenant branch reporting
DROP PROCEDURE IF EXISTS spgetcustomerperformance;
DELIMITER //
CREATE PROCEDURE `spgetcustomerperformance`(IN $branchid INT, IN $startdate DATETIME, IN $enddate DATETIME)
BEGIN
    DECLARE $total_revenue DECIMAL(18,2);
    
    -- Calculate total revenue for the period and branch once
    SELECT IFNULL(SUM(receipttotal), 0) INTO $total_revenue 
    FROM vwsalessummary2 
    WHERE branchid = $branchid 
    AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate);

    -- Return performance by customer
    IF $total_revenue > 0 THEN
        SELECT 
            customername as name,
            CASE 
                WHEN customername = 'WALKIN CUSTOMER' THEN 'Retail'
                ELSE 'Regular Account' 
            END as type,
            SUM(receipttotal) as revenue,
            ROUND((SUM(receipttotal) / $total_revenue) * 100, 1) as share,
            CASE 
                WHEN customername = 'WALKIN CUSTOMER' THEN 'shopping_cart'
                ELSE 'person' 
            END as icon
        FROM vwsalessummary2
        WHERE branchid = $branchid
        AND DATE(transactiondate) BETWEEN DATE($startdate) AND DATE($enddate)
        GROUP BY customername
        ORDER BY revenue DESC
        LIMIT 10;
    ELSE
        -- Return empty result set if no revenue to avoid division by zero
        SELECT NULL as name, NULL as type, NULL as revenue, NULL as share, NULL as icon LIMIT 0;
    END IF;
END //
DELIMITER ;
