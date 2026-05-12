<?php

    require_once("db.php");

    class purchaseorder extends db{

        public function saveTempPurchaseOrderItem($refno,$itemcode,$quantity,$unitprice,$taxable,$taxinclusive){
            $sql="CALL spsavetemppurchaseorderitem({$this->clientid},'{$refno}','{$itemcode}',{$quantity},{$unitprice},{$taxable},{$taxinclusive})";
            // echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            //echo "The item has been added to the temporary data successfully";
        }

        public function savePurchaseOrder($id,$refno,$supplierid,$terms,$departmentid,$category,$currencyid,$exchangerate,$taxid,$taxrate){
            $sql="CALL spsavepurchaseorder({$this->clientid},{$id},'{$refno}',{$supplierid},'{$terms}','{$category}',{$currencyid},{$exchangerate},{$departmentid},
            {$taxid},{$taxrate},{$this->userid})";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetch(PDO::FETCH_ASSOC);
            return $data['purchaseorderno'];
        }

        public function getPurchaseOrders(){
           $sql="CALL spgetpurchaseorders({$this->clientid})";
           $rst=$this->connect()->query($sql);
           echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function cancelPurchaseOrder($id,$reason){
            $sql="spcancelpurchaseorder ({$id},{$this->userid},'{$reason}'";
            $rst=$this->connect()->query($sql);
            echo "The purchase order has been cancelled successfully";
        }

        public function approvePurchaseOrder(){
            $sql="spapprovepurchaseorder({$id},{$this->userid})";
            $rst=$this->connect()->query($sql);
            echo "The purchase order has been cancelled successfully.";
        }

        public function getSupplierPendingOrders($supplierid){
            $sql="CALL spgetsupplierpendingorders({$this->clientid},'{$supplierid}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getPOUndeliveredItems($purchaseordernumber){
            $sql="CALL spgetpoitemsundelivered({$this->clientid},'{$purchaseordernumber}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getPurchaseOrderDetails($id){
            $sql="CALL spgetpurchaseorderdetails({$this->clientid},{$id})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }
    }
?>