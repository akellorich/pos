-- Update vwcustomerstomerstatement to include branchid for accurate dashboard reporting
-- This view is used to calculate Open Receivables
DROP VIEW IF EXISTS vwcustomerstomerstatement;
CREATE VIEW `vwcustomerstomerstatement` AS 
-- Invoices (Credit Sales)
select 
    p.`branchid` AS `branchid`,
    p.`possaleid` AS `id`,
    c.`customerid` AS `customerid`,
    c.`customername` AS `customername`,
    c.`physicaladdress` AS `physicaladdress`,
    c.`postaladdress` AS `postaladdress`,
    c.`mobile` AS `mobile`,
    c.`email` AS `email`,
    p.`receiptdate` AS `date`,
    'Invoice issued to customer' AS `narration`,
    pm.`reference` AS `reference`,
    pm.`amount` AS `invoiceamount`,
    0 AS `invoicepayment`,
    0 AS `order` 
from `customers` `c` 
join `possales` `p` on `c`.`customerid` = `p`.`customerid`
join `possalespayments` `pm` on `p`.`possaleid` = `pm`.`possaleid`
where `pm`.`paymentmode` = 4 -- Credit
and `p`.`deleted` = 0 
and DATE(p.receiptdate) >= (select DATE(cutoffdate) from startingparameters limit 1)

UNION ALL 

-- Payments
select 
    cr.`branchid` AS `branchid`,
    cr.`customerreceiptid` AS `id`,
    c.`customerid` AS `customerid`,
    c.`customername` AS `customername`,
    c.`physicaladdress` AS `physicaladdress`,
    c.`postaladdress` AS `postaladdress`,
    c.`mobile` AS `mobile`,
    c.`email` AS `email`,
    cr.`receiptdate` AS `date`,
    'Payment received. Thank You' AS `narration`,
    cr.`receiptno` AS `reference`,
    0 AS `invoiceamount`,
    sum(cd.amount) AS `invoicepayment`,
    1 AS `order` 
from `customers` `c` 
join `customerreceipts` `cr` on `c`.`customerid` = `cr`.`customerid`
join `customerreceiptdetails` `cd` on `cr`.`customerreceiptid` = `cd`.`receiptid`
where (cr.deleted is null or cr.deleted = 0)
and DATE(cr.receiptdate) >= (select DATE(cutoffdate) from startingparameters limit 1)
group by cr.branchid, cr.customerreceiptid, c.customerid, cr.receiptdate, cr.receiptno;
