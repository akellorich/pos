<?php
    require_once("db.php");
    class goodsreceived extends db{

        public function checkDeliveryNote($supplierid,$deliverynotenumber){
            $sql="CALL spchecksupplierdeliverynotenumber({$this->clientid},{$supplierid},'{$deliverynotenumber}')";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()>0){
                return true;
            }else{
                return false;
            }
        }

        public function saveTempGoodsReceived($refno,$pono,$itemcode,$quantity,$serialno){
            $sql="CALL spsavetempgoodsreceived({$this->clientid},'{$refno}','{$pono}','{$itemcode}',{$quantity},'{$serialno}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
        }

        public function saveGoodsReceived($refno,$warehouseid,$supplierid,$deliverynoteno,$savecustomerinvoice,$invoiceno,$inspectedby,$transferitems,$transferpos){
            if(!$this->checkDeliveryNote($supplierid,$deliverynoteno)){    
                $sql="CALL spsavegoodsreceived({$this->clientid},'{$refno}',{$warehouseid},{$supplierid},'{$deliverynoteno}',{$this->userid},{$savecustomerinvoice},'{$invoiceno}',{$inspectedby},{$transferitems},{$transferpos})";
                //echo $sql."</br/>";
                $rst=$this->connect()->query($sql);
                $data=$rst->fetch();
                echo $data['grnno'];
            }else{
                echo "exists";
            }
        }
        
        public function getuninvoicedgrn($supplierid,$startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetuninvoicedgrns({$this->clientid},{$supplierid},'{$startdate}','{$enddate}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getgrnproducts($grnno){
            $sql="CALL spgetgrnproducts({$this->clientid},'{$grnno}')";
            return $this->getJSON($sql);
        }

        public function getgrnitemdetails($grnno,$productid){
            $sql="CALL `spgetgrnitemdetails`({$this->clientid},'{$grnno}',{$productid})";
            return $this->getJSON($sql);
        }
           

    }
?>