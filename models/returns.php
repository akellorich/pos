<?php
    require_once("db.php");
    class returns extends db{

        public function savetempreturns($refno,$productid,$serialno,$quantity){
            $sql="CALL `spsavetempreturns`('{$refno}',{$productid},'{$serialno}',{$quantity})";
            $this->getData($sql);
            return "success";
        }

        public function savereturninwards($refno,$receiptno,$narration){
            $sql="CALL `spsavereturninwards`('{$refno}','{$receiptno}',{$_SESSION['userid']},'{$narration}')";
            // return the reference number generated
            $refno=array("referenceno"=>$this->getData($sql)->fetch()['referenceno']);
            return json_encode($refno);
        }

        public function getreturninwards($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `spgetreturninwards`('{$startdate}','{$enddate}')";
            return $this->getJSON($sql);
        }

        public function savereturnoutwards($refno,$grnno,$narration){
            $sql="CALL `spsavereturnoutwards`('{$refno}','{$grnno}','{$narration}',{$_SESSION['userid']})";
            // return the reference number generated
            $refno=array("referenceno"=>$this->getData($sql)->fetch()['referenceno']);
            return json_encode($refno);
        }

        public function getreturnoutwards($startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `spgetreturnoutwards`('{$startdate}','{$enddate}')";
            return $this->getJSON($sql);
        }

        public function savereturninwardscollection($id,$collectedby){
            $sql="CALL `spsavereturninwardscollection`({$id},'{$collectedby}',{$_SESSION['userid']})";
            $this->getData($sql);
            return "success";
        }

        public function savereturnoutwardsreturn($id){
            $sql="CALL `spsavereturnoutwardsreturn`({$id},{$_SESSION['userid']})";
            $this->getData($sql);
            return "success";
        }

        function saveposreturns($outletid,$warehouseid,$paymentmodeid,$reference,$jsondata,$returneditems){
            $sql="CALL `sp_savereturns`({$outletid},{$warehouseid},{$paymentmodeid},'{$reference}','{$jsondata}','{$returneditems}',{$_SESSION['userid']})";
            // echo($sql);
            $rst=$this->getData($sql);
            // Loop through results and return receipt no and store transfer number
            $response=[];
            $response['status']="success";
            do{
                $rowset = $rst->fetch(); 
                // print_r($rowset);
                // echo json_encode($rowset);
                if(is_array($rowset)){
                    if(array_key_exists("receiptno", $rowset)){
                        $response['receiptno']=$rowset['receiptno'];
                    }
                    if(array_key_exists("transfercode",$rowset)){
                        $response['transferno']=$rowset['transfercode'] ;
                    }
                }
                
            } while ($rst->nextRowset());
            return $response;
        }
    }
?>