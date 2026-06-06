-- Standardize supplier procedures for multi-tenancy
DELIMITER //

DROP PROCEDURE IF EXISTS spchecksuppliername //
CREATE PROCEDURE spchecksuppliername(
    IN $clientid INT,
    IN $supplierid INT,
    IN $suppliername VARCHAR(50)
)
BEGIN
    SELECT * FROM suppliers 
    WHERE clientid = $clientid 
    AND supplierid <> $supplierid 
    AND suppliername = $suppliername;
END //

DROP PROCEDURE IF EXISTS spsavesupplier //
CREATE PROCEDURE spsavesupplier(
    IN $clientid INT,
    IN $supplierid INT,
    IN $suppliername VARCHAR(50),
    IN $physicaladdress VARCHAR(100),
    IN $postaladdress VARCHAR(100),
    IN $creditlimit DECIMAL(10,2),
    IN $mobile VARCHAR(50),
    IN $supplierpinno VARCHAR(50),
    IN $email VARCHAR(50),
    IN $userid INT
)
BEGIN
    IF $supplierid = 0 THEN
        INSERT INTO suppliers (
            clientid, suppliername, physicaladdress, postaladdress, 
            creditlimit, mobile, email, dateadded, addedby, supplierpinno
        ) VALUES (
            $clientid, $suppliername, $physicaladdress, $postaladdress, 
            $creditlimit, $mobile, $email, NOW(), $userid, $supplierpinno
        );
    ELSE
        UPDATE suppliers SET
            suppliername = $suppliername,
            physicaladdress = $physicaladdress,
            postaladdress = $postaladdress,
            creditlimit = $creditlimit,
            mobile = $mobile,
            email = $email,
            supplierpinno = $supplierpinno,
            lastdatemodified = NOW(),
            lastmodifiedby = $userid
        WHERE clientid = $clientid AND supplierid = $supplierid;
    END IF;
END //

DROP PROCEDURE IF EXISTS spgetsupplierdetails //
CREATE PROCEDURE spgetsupplierdetails(
    IN $clientid INT,
    IN $supplierid INT
)
BEGIN
    SELECT * FROM suppliers 
    WHERE clientid = $clientid AND supplierid = $supplierid;
END //

DROP PROCEDURE IF EXISTS spdeletesupplier //
CREATE PROCEDURE spdeletesupplier(
    IN $clientid INT,
    IN $supplierid INT,
    IN $userid INT
)
BEGIN
    UPDATE suppliers SET 
        deleted = 1,
        lastdatemodified = NOW(),
        lastmodifiedby = $userid
    WHERE clientid = $clientid AND supplierid = $supplierid;
END //

DROP PROCEDURE IF EXISTS spgetsupplierinvoices //
CREATE PROCEDURE spgetsupplierinvoices(
    IN $clientid INT,
    IN $supplierid INT,
    IN $status VARCHAR(50),
    IN $startdate DATETIME,
    IN $enddate DATETIME
)
BEGIN
    DECLARE $accountid INT;
    DECLARE $accountname VARCHAR(100);
    
    SET $accountid = (SELECT `id` FROM `glaccounts` WHERE `clientid` = $clientid AND `accountcode` = (SELECT `account` FROM `glaccountsettings` WHERE `clientid` = $clientid AND `description` = 'Suppliers Control Account'));
    SET $accountname = (SELECT `accountname` FROM `glaccounts` WHERE `clientid` = $clientid AND `accountcode` = (SELECT `account` FROM `glaccountsettings` WHERE `clientid` = $clientid AND `description` = 'Suppliers Control Account'));

    SELECT $accountid AS accountcharged, $accountname AS accountname, 
           i.supplierinvoiceid AS invoiceid, s.`supplierid`, s.suppliername, i.`invoiceno`, 
           DATE_FORMAT(i.`invoicedate`,'%d-%b-%Y') AS invoicedate, 
           SUM(id.`quantity` * id.`unitprice`) AS invoiceamount, i.`status`,
           IFNULL((SELECT SUM(vd.`quantity` * vd.`unitprice`) 
                   FROM `paymentvouchers` v
                   INNER JOIN `paymentvoucherdetails` vd ON v.`id` = vd.`voucherid` AND v.clientid = vd.clientid
                   WHERE v.clientid = $clientid AND v.`supplier` = s.supplierid AND vd.`invoicenumber` = i.invoiceno), 0) AS amountpaid
    FROM `supplierinvoice` i
    INNER JOIN `supplierinvoicedetails` id ON i.`supplierinvoiceid` = id.`invoiceid` AND i.clientid = id.clientid
    INNER JOIN `suppliers` s ON s.`supplierid` = i.`supplierid` AND s.clientid = i.clientid
    WHERE i.clientid = $clientid
      AND ($supplierid = 0 OR i.supplierid = $supplierid)
      AND ($status = '<All>' OR $status = 'All' OR i.status = $status)
      AND DATE_FORMAT(i.invoicedate,'%Y-%m-%d') BETWEEN DATE_FORMAT($startdate,'%Y-%m-%d') AND DATE_FORMAT($enddate,'%Y-%m-%d')
    GROUP BY i.supplierinvoiceid, s.`supplierid`, s.suppliername, i.`invoiceno`, i.`status`, i.`invoicedate`
    ORDER BY i.`invoicedate` DESC;
END //

DROP PROCEDURE IF EXISTS spgetinvoicegrns //
CREATE PROCEDURE spgetinvoicegrns(
    IN $clientid INT,
    IN $invoiceid INT
)
BEGIN
    DECLARE $suppliercontrolaccount INT;
    SET $suppliercontrolaccount = (SELECT id FROM `glaccounts` WHERE `clientid` = $clientid AND `accountcode` = (SELECT `account` FROM `glaccountsettings` WHERE `clientid` = $clientid AND `description` = 'Suppliers Control Account'));
    
    SELECT p.`itemcode`, id.`description`, SUM(id.`quantity`) AS quantity, AVG(id.`unitprice`) AS unitprice, $suppliercontrolaccount AS accountcharged 
    FROM `supplierinvoicedetails` id
    INNER JOIN `products` p ON p.`productid` = id.`itemcode` AND p.clientid = id.clientid
    WHERE id.clientid = $clientid AND id.`invoiceid` = $invoiceid
    GROUP BY p.`itemcode`, id.`description`;
END //

DELIMITER ;
