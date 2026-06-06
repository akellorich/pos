<?php

    require_once("db.php");

    class purchaseorder extends db{

        public function saveTempPurchaseOrderItem($refno,$itemcode,$quantity,$unitprice,$taxable,$taxinclusive){
            // If the itemcode is not numeric (e.g. alphanumeric barcode 'BR00002'), perform a fallback database lookup to get the correct productid
            if (!is_numeric($itemcode) && !empty($itemcode)) {
                $pdo = $this->connect();
                $stmt = $pdo->prepare("SELECT productid FROM `products` WHERE `itemcode` = ? AND `clientid` = ?");
                $stmt->execute([$itemcode, $this->clientid]);
                $foundId = $stmt->fetchColumn();
                if ($foundId !== false) {
                    $itemcode = $foundId;
                }
            }
            $sql="CALL spsavetemppurchaseorderitem({$this->branchid},'{$refno}','{$itemcode}',{$quantity},{$unitprice},{$taxable},{$taxinclusive})";
            // echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            //echo "The item has been added to the temporary data successfully";
        }

        public function savePurchaseOrder($id,$refno,$supplierid,$terms,$departmentid,$category,$currencyid,$exchangerate,$taxid,$taxrate){
            $sql="CALL spsavepurchaseorder({$this->branchid},{$id},'{$refno}',{$supplierid},'{$terms}','{$category}',{$currencyid},{$exchangerate},{$departmentid},
            {$taxid},{$taxrate},{$this->userid})";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetch(PDO::FETCH_ASSOC);
            return $data['purchaseorderno'];
        }

        public function getPurchaseOrders(){
           $sql="CALL spgetpurchaseorders({$this->branchid})";
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
            $sql="CALL spgetsupplierpendingorders({$this->branchid},'{$supplierid}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getPOUndeliveredItems($purchaseordernumber){
            $sql="CALL spgetpoitemsundelivered({$this->branchid},'{$purchaseordernumber}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getPurchaseOrderDetails($id){
            $sql="CALL spgetpurchaseorderdetails({$this->branchid},{$id})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }
    }
?>