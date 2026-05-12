<?php
    require_once('db.php');
    
    class supplier extends db{

        public function checkSupplierName($id,$name){
            $sql="CALL spchecksuppliername({$id},'{$name}')";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()>0){
                return true;
            }else{
                return false;
            }
        }

        public function saveSupplier($supplierid,$suppliername,$physicaladdress,$postaladdress,$mobile ,$email,$creditlimit,$supplierpinno){
            if(!$this->checkSupplierName($supplierid,$suppliername)){
                $sql="CALL spsavesupplier({$supplierid},'{$suppliername}','{$physicaladdress}','{$postaladdress}',{$creditlimit},'{$mobile}' ,
                '{$supplierpinno}','{$email}',{$this->userid})";
                // echo $sql."<br/>";
                $rst=$this->connect()->query($sql);
                echo "success";
            }else{
                echo "exists";
            }
        }

        public function getSupplierDetails($supplierid){
            $sql="CALL spgetsupplierdetails({$supplierid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetch(PDO::FETCH_ASSOC));
        }

        public function deleteSupplier($supplierid){
            $sql="CALL spdeletesupplier({$supplierid},{$_SESSION['userid']})";
            $rst=$this->connect()->query($sql);
            echo "The supplier has been deleted successfully.";
        }

        public function getSuppliers(){
            $sql="CALL spgetsuppliers()";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function savetempinvoicedetails($refno,$grnno){
            $sql="CALL spsavetempsupplierinvoice('{$refno}','{$grnno}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
        }

        public function saveinvoice($refno,$invoiceno,$supplierid, $invoicedate){
            $invoicedate=$this->mySQLDate($invoicedate);
            $sql="CALL spsavesupplierinvoice('{$refno}','{$invoiceno}',{$supplierid},'{$invoicedate}',{$_SESSION['userid']})";
            $rst=$this->connect()->query($sql);
            //echo $sql."<br/>";
            echo "success";
        }

        public function getSupplierInvoices($supplierid,$status,$startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsupplierinvoices({$supplierid},'{$status}','{$startdate}','{$enddate}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getInvoiceGRNDetails($id){
            $sql="CALL spgetinvoicegrns({$id})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));

        }
    }
?>