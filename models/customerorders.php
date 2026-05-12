<?php
    require_once("db.php");
    class customerorders extends db{

        function savetempcustomerorder($refno,$productid,$quantity,$unitprice){
            $sql="CALL `sp_savetempcustomerorderdetail`('{$refno}',{$productid},{$quantity},{$unitprice})";
            $this->getData($sql);
            return ["status"=>"success","message"=>"temporary customer order saved successfully"];
        }

        function savecustomerorder($refno,$posid,$customerid,$tableid){
            $sql="CALL `sp_savecustomerorder`('{$refno}',{$posid},{$customerid},{$tableid},{$this->userid})";
            $orderno=$this->getData($sql)->fetch()['orderno'];
            return ["status"=>"success","message"=>"customer order saved successfully","orderno"=>$orderno];
        }

        function getcustomerorder($orderno){
            $sql="CALL `sp_getcustomerorderdetails`('{$orderno}')";
            return $this->getJSON($sql);
        }

        function filtercustomerorders($customerid,$tableid,$posid,$waiterid,$startdate,$enddate,$orderstatus){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `sp_filtercustomerorders`({$customerid},{$tableid},{$posid},{$waiterid},'{$startdate}','{$enddate}','{$orderstatus}')";
            return $this->getJSON($sql);
        }

        function savetemporderstosettle($refno,$orderid){
            $sql="CALL `sp_savetemporderstosettle`('{$refno}',{$orderid})";
            $this->getData($sql);
        }

        function getorderstotal($refno){
            $sql="CALL `sp_getorderstotal`('{$refno}')";
            return $this->getJSON($sql);
        }

        function settlecustomerorders($refno){
            $sql="CALL `sp_settleorderpayments`('{$refno}',{$this->userid})";
            $receiptno=$this->getData($sql)->fetch()['receiptno'];  
            return ["status"=>"success","message"=>"customer orders settled successfully","receiptno"=>$receiptno];
        }

        function cancelcustomerorder($orderid,$reason){
            $sql="CALL `sp_cancelcustomerorder`({$orderid},'{$reason}',{$this->userid})";
            $this->getData($sql);
            return ["status"=>"success","message"=>"customer order cancelled successfully"];
        }
    }

?>