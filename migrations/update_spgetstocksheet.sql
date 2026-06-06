DROP PROCEDURE IF EXISTS `spgetstocksheet`;

DELIMITER $$

CREATE PROCEDURE `spgetstocksheet`(IN `$asat` DATE)
BEGIN
    SET @asat = `$asat`;
    SET @cutoffdate = DATE(IFNULL((SELECT `stockcutoffdate` FROM `startingparameters`), NOW()));
    SET @startdate = CONCAT(@cutoffdate, ' 00:00:00');
    SET @enddate = CONCAT(@asat, ' 23:59:59');

    SET @sql_dynamic = (
        SELECT GROUP_CONCAT(
            CONCAT('ROUND(SUM(IF(storename = ''', `posname`, ''', units, 0)), 2) AS `', `posname`, '`')
        )
        FROM `vwstores`
    );

    SET @sql = CONCAT(
        'WITH item_movements AS (
            SELECT c.categoryname, p.itemcode AS itemcode, p.itemname, p.buyingprice, p.sellingprice,
                   w.description AS storename,
                   SUM(
                       IFNULL(gr.qty, 0) + IFNULL(st_in.qty, 0) - IFNULL(st_out.qty, 0) + IFNULL(recon.qty, 0)
                   ) AS units
            FROM categories c
            JOIN products p ON p.categoryid = c.categoryid
            JOIN warehouses w
            LEFT JOIN (
                SELECT gd.itemcode, g.warehouseid, SUM(gd.quantity) AS qty
                FROM goodsreceiveddetails gd
                JOIN goodsreceived g ON g.grnno = gd.grnno
                WHERE g.datereceived BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY gd.itemcode, g.warehouseid
            ) gr ON gr.itemcode = p.productid AND gr.warehouseid = w.id
            LEFT JOIN (
                SELECT sd.itemcode, s.destinationid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.stocktransferid = sd.transferid
                WHERE s.destinationtype = ''warehouse''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.destinationid
            ) st_in ON st_in.itemcode = p.productid AND st_in.destinationid = w.id
            LEFT JOIN (
                SELECT sd.itemcode, s.sourceid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.stocktransferid = sd.transferid
                WHERE s.sourcetype = ''warehouse''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.sourceid
            ) st_out ON st_out.itemcode = p.productid AND st_out.sourceid = w.id
            LEFT JOIN (
                SELECT sd.itemid, s.posid, SUM(sd.quantity) AS qty
                FROM stockreconciledbalancedetails sd
                JOIN stockreconciledbalance s ON s.stockreconciledbalanceid = sd.reconciliationid
                WHERE s.category = ''warehouse''
                  AND s.reconciliationdate BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemid, s.posid
            ) recon ON recon.itemid = p.productid AND recon.posid = w.id
            GROUP BY c.categoryname, p.itemcode, p.itemname, p.buyingprice, p.sellingprice, w.description

            UNION ALL

            SELECT c.categoryname, p.itemcode AS itemcode, p.itemname, p.buyingprice, p.sellingprice,
                   ps1.posname AS storename,
                   SUM(
                       IFNULL(stp_in.qty, 0) - IFNULL(stp_out.qty, 0) - IFNULL(sales.qty, 0) + IFNULL(recon.qty, 0)
                   ) AS units
            FROM categories c
            JOIN products p ON p.categoryid = c.categoryid
            JOIN pointsofsale ps1
            LEFT JOIN (
                SELECT sd.itemcode, s.destinationid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.stocktransferid = sd.transferid
                WHERE s.destinationtype = ''pos''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.destinationid
            ) stp_in ON stp_in.itemcode = p.productid AND stp_in.destinationid = ps1.posid
            LEFT JOIN (
                SELECT sd.itemcode, s.sourceid, SUM(sd.quantity) AS qty
                FROM stocktransferdetails sd
                JOIN stocktransfer s ON s.stocktransferid = sd.transferid
                WHERE s.sourcetype = ''pos''
                  AND s.dateadded BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemcode, s.sourceid
            ) stp_out ON stp_out.itemcode = p.productid AND stp_out.sourceid = ps1.posid
            LEFT JOIN (
                SELECT pd.itemcode, ps.pointofsaleid, SUM(pd.quantity) AS qty
                FROM possalesdetails pd
                JOIN possales ps ON pd.possaleid = ps.possaleid
                WHERE IFNULL(ps.deleted, 0) = 0
                  AND ps.receiptdate BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY pd.itemcode, ps.pointofsaleid
            ) sales ON sales.itemcode = p.productid AND sales.pointofsaleid = ps1.posid
            LEFT JOIN (
                SELECT sd.itemid, s.posid, SUM(sd.quantity) AS qty
                FROM stockreconciledbalancedetails sd
                JOIN stockreconciledbalance s ON s.stockreconciledbalanceid = sd.reconciliationid
                WHERE s.category = ''outlet''
                  AND s.reconciliationdate BETWEEN ''', @startdate, ''' AND ''', @enddate, '''
                GROUP BY sd.itemid, s.posid
            ) recon ON recon.itemid = p.productid AND recon.posid = ps1.posid
            GROUP BY c.categoryname, p.itemcode, p.itemname, p.buyingprice, p.sellingprice, ps1.posname
        )
        SELECT categoryname, itemcode, itemname, ', @sql_dynamic, ',
               ROUND(SUM(units), 2) AS `Total Quantity`,
               ROUND(SUM(units * buyingprice), 2) AS `Total Purchase`,
               ROUND(SUM(units * sellingprice), 2) AS `Total Selling`
        FROM item_movements
        GROUP BY categoryname, itemcode, itemname, buyingprice, sellingprice'
    );

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;
