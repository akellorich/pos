DELIMITER $$

USE `pos`$$

DROP PROCEDURE IF EXISTS `spgetdashboardheaders`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetdashboardheaders`(IN $branchid INT, IN $date DATE)
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM customers WHERE clientid = (SELECT clientid FROM branches WHERE branchid = $branchid) AND deleted = 0) AS activecustomers,
        (SELECT IFNULL(SUM(invoiceamount - invoicepayment), 0) FROM vwcustomerstomerstatement WHERE branchid = $branchid) AS openreceivables,
        (SELECT IFNULL(SUM(invoiceamount - settled), 0) FROM vwopenpayables WHERE branchid = $branchid) AS openpayables,
        (SELECT COUNT(DISTINCT purchaseorderno) FROM vwopenorders WHERE branchid = $branchid) AS openorders;
END$$

DELIMITER ;
