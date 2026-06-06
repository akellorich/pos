-- Migration: Update spgetpoitemsundelivered to include disallowreceipt flag
DROP PROCEDURE IF EXISTS `spgetpoitemsundelivered`;
DELIMITER $$
CREATE PROCEDURE `spgetpoitemsundelivered`(IN `$purchaseorderid` VARCHAR(50))
BEGIN
    SELECT p.`purchaseorderno`, pd.`itemcode`, r.`itemname`, pd.`unitprice`, pd.`quanity` AS ordered, IFNULL(r.serializable,0) `serializable`,
    pd.`quanity`-IFNULL((SELECT SUM(quantity) FROM `goodsreceiveddetails` WHERE `purchaseorderno`=p.`purchaseorderno` AND `itemcode`=pd.itemcode),0) AS undelivered,
    IFNULL(r.disallowreceipt,0) `disallowreceipt`
    FROM `purchaseorders` p, `purchaseorderdetails` pd, `products` r
    WHERE p.`id`=pd.`purchaseorderid` AND pd.`itemcode`=r.productid 
    AND p.`purchaseorderno`=$purchaseorderid
    AND pd.`quanity`-IFNULL((SELECT SUM(quantity) FROM `goodsreceiveddetails` WHERE `purchaseorderno`=p.`purchaseorderno` AND `itemcode`=pd.itemcode),0) >0 ;
END $$
DELIMITER ;
