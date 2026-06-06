-- Migration: Update spgetreceiptdetails to group items by itemcode and sum quantities
DROP PROCEDURE IF EXISTS `spgetreceiptdetails`;
DELIMITER $$
CREATE PROCEDURE `spgetreceiptdetails`(IN $clientid INT, IN $branchid INT, IN $receiptno VARCHAR(50))
BEGIN
    SELECT 
        s.*, 
        sd.*, 
        p.itemname, 
        p.itemcode, -- Explicitly selected to override sd.itemcode (productid) in PHP associative array
        SUM(sd.quantity) AS quantity, -- Override sd.quantity with aggregated quantity
        c.customername, 
        (SELECT GROUP_CONCAT(DISTINCT pm.description SEPARATOR ', ') 
         FROM possalespayments pay 
         JOIN paymentmethods pm ON pm.id = pay.paymentmode 
         WHERE pay.possaleid = s.possaleid
         AND pm.clientid = $clientid
        ) AS paymentmode, 
        CONCAT_WS(' ', u.firstname, u.lastname) AS servedby, 
        pos.posname AS posname
    FROM `possales` s
    JOIN `possalesdetails` sd ON s.possaleid = sd.possaleid
    JOIN `products` p ON p.productid = sd.itemcode
    JOIN `customers` c ON c.customerid = s.customerid
    JOIN `user` u ON u.userid = s.addedby
    JOIN `pointsofsale` pos ON pos.posid = s.pointofsaleid
    WHERE s.branchid = $branchid 
    AND s.receiptno = $receiptno
    GROUP BY sd.itemcode;
END $$
DELIMITER ;
