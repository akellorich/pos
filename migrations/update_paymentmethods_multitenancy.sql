-- 1. Ensure clientid exists in paymentmethods (already done but safe to repeat or refine)
-- ALTER TABLE paymentmethods ADD COLUMN IF NOT EXISTS clientid INT DEFAULT 1 AFTER id;

-- 2. Update all SPs that retrieve or reference paymentmethods to be client-aware

DELIMITER //

-- Update spgetpaymentmethods
DROP PROCEDURE IF EXISTS spgetpaymentmethods //
CREATE PROCEDURE spgetpaymentmethods(IN $clientid INT, IN $branchid INT)
BEGIN
    SELECT * 
    FROM paymentmethods 
    WHERE clientid = $clientid 
    AND branchid = $branchid 
    AND `show` = 1;
END //

-- Update spgetreceiptdetails to use clientid scoping (implied via joins)
DROP PROCEDURE IF EXISTS spgetreceiptdetails //
CREATE PROCEDURE spgetreceiptdetails(IN $clientid INT, IN $branchid INT, IN $receiptno VARCHAR(50))
BEGIN
    SELECT 
        s.*, 
        sd.*, 
        p.itemname, 
        c.customername, 
        m.description AS paymentmode, 
        u.firstname AS servedby, 
        pos.posname AS posname
    FROM `possales` s
    JOIN `possalesdetails` sd ON s.possaleid = sd.possaleid
    JOIN `products` p ON p.productid = sd.itemcode
    JOIN `customers` c ON c.customerid = s.customerid
    JOIN `possalespayments` sp ON sp.possaleid = s.possaleid
    JOIN `paymentmethods` m ON m.id = sp.paymentmode
    JOIN `user` u ON u.userid = s.addedby
    JOIN `pointsofsale` pos ON pos.posid = s.pointofsaleid
    WHERE s.branchid = $branchid 
    AND s.receiptno = $receiptno
    AND m.clientid = $clientid;
END //

DELIMITER ;

-- 3. Update Views to include clientid
DROP VIEW IF EXISTS vwsalessummary;
CREATE VIEW vwsalessummary AS 
SELECT 
    DATE_FORMAT(p.receiptdate, '%Y-%m-%d') AS transactiondate,
    pm.id AS id,
    p.receiptno AS receiptno,
    m.description AS paymentmode,
    pm.reference AS paymentmodereference,
    s.posname AS pointofsale,
    p.customerid AS customerid,
    c.customername AS customername,
    p.addedby AS userid,
    pm.amount AS receipttotal,
    p.pointofsaleid AS posid,
    IFNULL(pm.banked, 0) AS banked,
    CONCAT(u.firstname, ' ', u.middlename, ' ', u.lastname) AS userfullname,
    u.username AS username,
    s.clientid -- Added clientid
FROM pointsofsale s
JOIN possales p ON p.pointofsaleid = s.posid
JOIN possalesdetails pd ON p.possaleid = pd.possaleid
JOIN user u ON p.addedby = u.userid
JOIN customers c ON p.customerid = c.customerid
JOIN paymentmethods m ON m.clientid = s.clientid -- Added clientid join
JOIN possalespayments pm ON p.possaleid = pm.possaleid AND pm.paymentmode = m.id
WHERE IFNULL(p.deleted, 0) = 0
GROUP BY 
    p.receiptdate, p.receiptno, u.username, u.userid, s.posname, 
    p.customerid, c.customername, p.addedby, m.description, 
    pm.reference, pm.id, p.pointofsaleid, pm.banked, 
    u.firstname, u.middlename, u.lastname, s.clientid;
