import os
import re

sql_files = [
    r"c:\xampp\htdocs\pos\migrations\sps.sql",
    r"c:\xampp\htdocs\pos\migrations\database.sql",
    r"c:\xampp\htdocs\pos\migrations\database_sps_functions.sql",
    r"c:\xampp\htdocs\pos\migrations\db_sps_and_functions.sql",
    r"c:\xampp\htdocs\pos\migrations\updated_sps_functions.sql",
    r"c:\xampp\htdocs\pos\migrations\full_migration.sql",
    r"c:\xampp\htdocs\pos\migrations\full_migration_v2.sql"
]

new_def_payable = """CREATE PROCEDURE `spgetaccountspayableaginganalysis`($branchid INT, $basedate DATETIME)
BEGIN
	SET @basedate=$basedate;
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	
	SELECT  IFNULL(suppliername,'TOTAL') AS suppliername,SUM(amountoverdue) AS `total`,
		SUM(IF(`range`='1',amountoverdue,0)) AS `thirty`,  
		SUM(IF(`range`='31',amountoverdue,0)) AS `sixty`,
		SUM(IF(`range`='61',amountoverdue,0)) AS `ninenty` ,
		SUM(IF(`range`='91',amountoverdue,0)) AS `onetwenty` ,
		SUM(IF(`range`='120+',amountoverdue,0)) AS `aboveonetwenty` 
	FROM (
		SELECT i.supplierinvoiceid AS invoiceid,s.`supplierid`,suppliername,`invoiceno`,
		CASE 
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 1 AND 30 THEN '1' 
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 31 AND 60 THEN '31'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 61 AND 90 THEN '61'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d')) BETWEEN 91 AND 120 THEN '91'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d'))>=120 THEN '120+' 
		END AS `range`,
		SUM(`quantity`*`unitprice`) -
		IFNULL((SELECT SUM(`quantity`*`unitprice`) FROM `paymentvouchers` v, `paymentvoucherdetails` vd 
		WHERE v.`paymentvoucherid`=vd.`voucherid` AND `supplier`=s.supplierid AND `invoicenumber`=`invoiceno` 
		AND v.branchid = $branchid AND DATE_FORMAT(v.`date`,'%Y-%m-%d')<=@basedate),0) AS amountoverdue
		FROM `supplierinvoice` i,`supplierinvoicedetails` id, `suppliers` s
		WHERE i.`supplierinvoiceid`=id.`invoiceid` AND s.`supplierid`=i.`supplierid` 
		AND i.branchid = $branchid
		AND DATE_FORMAT(`invoicedate`,'%Y-%m-%d')>=@cutoffdate
		GROUP BY i.supplierinvoiceid ,s.`supplierid`,suppliername,`invoiceno`,`status`,DATEDIFF(@basedate,DATE_FORMAT(`invoicedate`,'%Y-%m-%d'))
		ORDER BY `invoicedate` DESC, `invoiceno`
	) AS tab1
	GROUP BY suppliername
	WITH ROLLUP;
END"""

new_def_receivable = """CREATE PROCEDURE `spgetaccountsreceivableaginganalysis`($branchid INT, $basedate DATETIME)
BEGIN
	SET @cutoffdate=(SELECT DATE_FORMAT(`cutoffdate`,'%Y-%m-%d') FROM `startingparameters`);
	SET @basedate=$basedate;
	SELECT IFNULL(customername,'TOTAL') AS `customername`, 
		SUM(`balance`) AS `total`,
		SUM(IF(`range`='thirty',`balance`,0)) AS `thirty` ,
		SUM(IF(`range`='sixty',`balance`,0)) AS `sixty` ,
		SUM(IF(`range`='ninety',`balance`,0)) AS `ninety` ,
		SUM(IF(`range`='onetwenty',`balance`,0)) AS `onetwenty` ,
		SUM(IF(`range`='aboveonetwenty',`balance`,0)) AS `aboveonetwenty` 
	FROM(
		SELECT c.`customerid`, p.possaleid AS id,c.`customername`,
		CASE 
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d'))<=30 THEN 'thirty' 
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d')) BETWEEN 31 AND 60 THEN 'sixty'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d')) BETWEEN 61 AND 90 THEN 'ninety'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d')) BETWEEN 91 AND 120 THEN 'onetwenty'
			WHEN DATEDIFF(@basedate,DATE_FORMAT(`receiptdate`,'%Y-%m-%d'))>120 THEN 'aboveonetwenty' 
		END AS `range`,
		pp.amount -
		IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`possaleid`),0) AS balance
		FROM `possales` p, `possalesdetails` pd, `possalespayments` pp, `customers` c
		WHERE p.`possaleid`=pd.`possaleid` AND pp.`possaleid`=p.`possaleid` AND pp.`paymentmode`=4 AND c.`customerid`=p.`customerid`
		AND p.branchid = $branchid
		AND pp.amount - IFNULL((SELECT SUM(`amount`) FROM `customerreceiptdetails` WHERE `possaleid`=p.`possaleid`),0)>0
		AND DATE_FORMAT(`receiptdate`,'%Y-%m-%d')>=@cutoffdate
		GROUP BY c.`customerid`,p.possaleid,c.`customername`
	) AS tab1
	GROUP BY customername
	WITH ROLLUP;
END"""

for file_path in sql_files:
    if os.path.exists(file_path):
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
        
        new_content = content
        
        # Replace payable
        pattern_payable = re.compile(r'CREATE\s+(?:DEFINER=`[^`]+`@`[^`]+`|)\s*PROCEDURE\s+`?spgetaccountspayableaginganalysis`?[^B]+BEGIN.*?END', re.DOTALL | re.IGNORECASE)
        match_payable = re.search(pattern_payable, new_content)
        if match_payable:
            new_content = new_content.replace(match_payable.group(0), new_def_payable)
            print(f"Replaced payable inside {os.path.basename(file_path)}")
            
        # Replace receivable
        pattern_receivable = re.compile(r'CREATE\s+(?:DEFINER=`[^`]+`@`[^`]+`|)\s*PROCEDURE\s+`?spgetaccountsreceivableaginganalysis`?[^B]+BEGIN.*?END', re.DOTALL | re.IGNORECASE)
        match_receivable = re.search(pattern_receivable, new_content)
        if match_receivable:
            new_content = new_content.replace(match_receivable.group(0), new_def_receivable)
            print(f"Replaced receivable inside {os.path.basename(file_path)}")
            
        if new_content != content:
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(new_content)
    else:
        print(f"File not found: {file_path}")
