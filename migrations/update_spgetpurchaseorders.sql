-- Migration: Update spgetpurchaseorders to join user and purchaseorderdetails tables, calculating order totals, creator's name, and active status
-- 1. Drop the existing procedure
DROP PROCEDURE IF EXISTS `spgetpurchaseorders`;

-- 2. Create the updated procedure
DELIMITER $$

CREATE PROCEDURE `spgetpurchaseorders`(IN $branchid INT)
BEGIN
    SELECT p.*, s.suppliername, d.departmentname,
           IFNULL(CONCAT_WS(' ', u.firstname, u.middlename, u.lastname), 'System') AS addedbyname,
           IFNULL(SUM(pd.quanity * pd.unitprice), 0) AS ordertotal,
           `fn_purchaseorderstatus`(p.purchaseorderid) AS status
    FROM `purchaseorders` p
    JOIN `suppliers` s ON s.supplierid = p.supplierid
    LEFT JOIN `departments` d ON d.id = p.departmentid
    LEFT JOIN `user` u ON u.userid = p.addedby
    LEFT JOIN `purchaseorderdetails` pd ON pd.purchaseorderid = p.purchaseorderid
    WHERE p.branchid = $branchid
    GROUP BY p.purchaseorderid, s.suppliername, d.departmentname, u.firstname, u.middlename, u.lastname
    ORDER BY p.date DESC;
END $$

DELIMITER ;
