DROP PROCEDURE IF EXISTS `spgetinstitutiondetails`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spgetinstitutiondetails`(IN `$clientid` INT)
BEGIN
    SELECT 
        clientid AS id,
        client_name AS name,
        physical_address AS physicaladdress,
        postaladdress,
        landline,
        email,
        phone_number AS mobile,
        pinno,
        autoaddinvoiceduringgrn AS autoinvoicegrn,
        postalcode,
        quotationvalidity,
        tagline,
        website,
        receiptfooter,
        defaultcustomer,
        mainbusinesstype,
        logo,
        town,
        printreceipt,
        sendtovault,
        allow_price_change AS allowpricechange,
        allow_negative_sales_globally AS allownegativesalesglobally
    FROM `clients` 
    WHERE clientid = `$clientid`;
END$$

DELIMITER ;
