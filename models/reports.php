<?php
    require_once("db.php");

    class report extends db{
        function getProductSalesSummary($startdate,$enddate,$product){
            $startdate= $this->mySQLDate($startdate);
            $enddate= $this->mySQLDate($enddate);
            $sql="CALL spfilterproductsalesbymonth({$this->clientid},'{$startdate}','{$enddate}','{$product}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getProfitabilityReport($startdate,$enddate,$posid){
            $startdate= $this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetprofitabilityreport({$this->clientid},'{$startdate}','{$enddate}','{$posid}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getPOSStockSummary($posid,$asatdate){
            $asatdate= $this->mySQLDate($asatdate);
            $sql="CALL spgetposstockbalanceasatdate({$this->clientid},'{$asatdate}',{$posid})";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getStockSheet($asatdate){
            $asatdate= $this->mySQLDate($asatdate);
            $sql="CALL spgetstocksheet({$this->clientid},'{$asatdate}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getGLStatement($startdate,$enddate,$accountid){
            $startdate=$this->mySQLdate($startdate);
            $enddate=$this->mySQLdate($enddate);
            $sql="CALL spgetglstatement({$this->clientid},'{$startdate}','{$enddate}',{$accountid})";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getAccountsPayableAging($basedate){
            $basedate=$this->mySQLDate($basedate);
            $sql="CALL spgetaccountspayableaginganalysis({$this->clientid},'{$basedate}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getAccountsReceivableAgingAnlysis($basedate){
            $basedate=$this->mySQLDate($basedate);
            $sql="CALL spgetaccountsreceivableaginganalysis({$this->clientid},'{$basedate}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getCustomerStatement($customerid,$startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL  spgetcustomerstatement ({$customerid},'{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getCustomerAgingAnalysis($customerid,$basedate){
            $basedate=$this->mySQLDate($basedate);
            $sql="CALL   spgetcustomeraginganalysis ({$customerid},'{$basedate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getSupplierStatement($supplierid,$startdate,$enddate){
            $startdate=$this->mySQlDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsupplierstatement ($supplierid,'{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getSupplierAgingAnalysis($basedate,$supplierid){
            $basedate=$this->mySQLDate($basedate);
            $sql="CALL spgetsupplieraginganalysis({$this->clientid},'{$basedate}',{$supplierid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getTrialBalance($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgettrialbalance({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getProfitAndLossAccount($startdate,$enddate){
            $startdate=$this->mySQLdate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetprofitandlossaccount({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getBalanceSheet($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetbalancesheet({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getsalestrend($startdate,$enddate,$range,$userid){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalestrend({$this->clientid},'{$startdate}','{$enddate}','{$range}',{$userid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getsalesbyquantity($startdate,$enddate,$range,$userid){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalesbyquantity({$this->clientid},'{$startdate}','{$enddate}','{$range}',{$userid})";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getsalesbypaymentmode($startdate,$enddate,$userid){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalesbypaymentmode({$this->clientid},'{$startdate}','{$enddate}',{$userid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getsalesbycustomercount($startdate,$enddate,$range){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalesbycustomercount({$this->clientid},'{$startdate}','{$enddate}','{$range}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getsalesbyoutlet($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalesbyoutlet({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getsalesbysalesperson($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalesbysalesperson({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getbestsellingproduct($startdate,$enddate,$userid){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetbestsellingproducts({$this->clientid},'{$startdate}','{$enddate}',{$userid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getbestsellingcategory($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetbestsellingcategory({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getsalesbycustomervalue($startdate,$enddate,$daterange){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalebycustomervalue({$this->clientid},'{$startdate}','{$enddate}','{$daterange}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getdashboardheader($date){
            $date=$this->mySQLDate($date);
            $sql="CALL spgetdashboardheaders({$this->clientid},'{$date}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function gettransfers($source,$sourceid,$destination,$destinationid,$startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `spfilterstocktransfer`('{$source}',{$sourceid},'{$destination}',{$destinationid},'{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getexpandedsalesbypaymentmethod($startdate,$enddate,$userid){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalesbypaymentmode2({$this->clientid},'{$startdate}','{$enddate}',{$userid})";
            echo $this->getJSON($sql);
        }

        function getprofitandlossaccountheaders($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetprofitandlossaccountheader({$this->clientid},'{$startdate}','{$enddate}')";
            echo $this->getJSON($sql);
        }

        function getprofitandlossaccountdetails($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetprofitandlossaccountdetails({$this->clientid},'{$startdate}','{$enddate}')";
            echo $this->getJSON($sql);
        }

        function getdiscountreport($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->MySQLDate($enddate);
            $sql="CALL spgetdiscountreport({$this->clientid},'{$startdate}','{$enddate}')";
            echo $this->getJSON($sql);
        }

        function getmasterstocksheet($enddate){           
            $enddate=$this->MySQLDate($enddate);
            $sql="CALL spgetmasterstocksheet({$this->clientid},'{$enddate}')";
            echo $this->getJSON($sql);
        }

        function getreturnoutwardssummary($asatdate){
            $asatdate=$this->mySQLDate($asatdate);
            $sql="CALL spgetreturnoutwardssummary({$this->clientid},'{$asatdate}')";
            return $this->getJSON($sql);
        }

        function getreturninwardssummary($asatdate){
            $asatdate=$this->mySQLDate($asatdate);
            $sql="CALL spgetreturninwardssummary({$this->clientid},'{$asatdate}')";
            return $this->getJSON($sql);
        }

        function getproductsalessummaryreport($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL sp_getproductsalessummary({$this->clientid},'{$startdate}','{$enddate}')";
            return $this->getJSON($sql);
        }

        function getproductpurchasessummaryreport($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL sp_getproductpurchasessummary({$this->clientid},'{$startdate}','{$enddate}')";
            return $this->getJSON($sql);
        }

        function gettransferitemsreport($cat,$id,$startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `sp_gettransferreportbyitems`('{$cat}',{$id},'{$startdate}','{$enddate}')";
            return $this->getJSON($sql);
        }

        function getinputoutputvatreport($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL sp_getinputoutputvatreport({$this->clientid},'{$startdate}','{$enddate}')";
            return $this->getJSON($sql);
        }
    }
?>