-- MIGRATION SCRIPT: institution TO clients
UPDATE `clients` c
JOIN `institution` i ON c.`clientid` = i.`clientid`
SET 
    c.`client_name` = i.`name`,
    c.`physical_address` = i.`physicaladdress`,
    c.`postaladdress` = i.`postaladdress`,
    c.`landline` = i.`landline`,
    c.`email` = i.`email`,
    c.`phone_number` = i.`mobile`,
    c.`pinno` = i.`pinno`,
    c.`autoaddinvoiceduringgrn` = i.`autoaddinvoiceduringgrn`,
    c.`postalcode` = i.`postalcode`,
    c.`quotationvalidity` = i.`quotationvalidity`,
    c.`tagline` = i.`tagline`,
    c.`website` = i.`website`,
    c.`receiptfooter` = i.`receiptfooter`,
    c.`defaultcustomer` = i.`defaultcustomer`,
    c.`mainbusinesstype` = i.`mainbusinesstype`,
    c.`logo` = i.`logo`,
    c.`town` = i.`town`;

-- Optional: If some institution records don't have clientid but should be mapped to the first client
UPDATE `clients` c
CROSS JOIN (SELECT * FROM `institution` LIMIT 1) i
SET 
    c.`client_name` = i.`name`,
    c.`physical_address` = i.`physicaladdress`,
    c.`postaladdress` = i.`postaladdress`,
    c.`landline` = i.`landline`,
    c.`email` = i.`email`,
    c.`phone_number` = i.`mobile`,
    c.`pinno` = i.`pinno`,
    c.`autoaddinvoiceduringgrn` = i.`autoaddinvoiceduringgrn`,
    c.`postalcode` = i.`postalcode`,
    c.`quotationvalidity` = i.`quotationvalidity`,
    c.`tagline` = i.`tagline`,
    c.`website` = i.`website`,
    c.`receiptfooter` = i.`receiptfooter`,
    c.`defaultcustomer` = i.`defaultcustomer`,
    c.`mainbusinesstype` = i.`mainbusinesstype`,
    c.`logo` = i.`logo`,
    c.`town` = i.`town`
WHERE c.`clientid` = 1 AND NOT EXISTS (SELECT 1 FROM `institution` WHERE `clientid` = 1);
