<?php 

    require_once('db.php');

    class creditnote extends db{

        public function saveTempCreditNoteDetails($refno,$itemcode,$quantity,$unitprice){
            $sql="CALL spsavetempcreditnotedetails ('{$refno}',{$itemcode},{$quantity},{$unitprice})";
            $rst=$this->connect()->query($sql);
        }

        public function saveCreditNote($refno,$customerid){
            $sql="CALL spsavecreditnote ('{$refno}',{$customerid},{$_SESSION['userid']})";
            $rst=$this->connect()->query($sql);
            // return the credit note number generated
            $data =$rst->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($data);
        }

        public function getCreditNoteValue($creditnoNo){
            $sql="CALL spgetcreditnotevalue ('{$creditnoNo}')";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($data);
        }

        public function getCustomerCreditNotes($customerid){
            $sql="CALL spgetcustomercreditnotes ({$customerid})";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($data);
        }

    }

?>