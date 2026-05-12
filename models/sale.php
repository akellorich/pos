<?php
    require_once("db.php");
    require_once("../fpdf181/fpdf.php");
    class sale extends db{

        public function saveTemporarySale($refno,$itemcode,$quantity,$unitprice,$discount,$serialno,$description){
            $sql="CALL spsavetempsale({$this->clientid},'{$refno}' ,'{$itemcode}' ,{$quantity},{$unitprice},{$discount},'{$serialno}','{$description}')";
            $rst=$this->getData($sql);
            return true;
        }

        public function saveSale($refno,$customerid,$posid,$transactiondate,$reference){
            $transactiondate=$this->mySQLDate($transactiondate);
            $sql="CALL spsavepossale({$this->clientid},'{$refno}',{$customerid},{$posid},'{$transactiondate}','{$reference}',{$_SESSION['userid']})";
            // echo $sql."<br/>";
            $rst=$this->getData($sql);
            if($rst->rowCount()>0){
               $data=$rst->fetch(PDO::FETCH_ASSOC);
               return $data['receiptno'];
               // generate receipt
               //$this->generateReceipt($data['receiptno']);
            }
        }

        public function getSalesDetails(){

        }

        public function checkRefNo($modeid,$reference){
            $sql="CALL spcheckreferenceno({$this->clientid},{$modeid},'{$reference}')";
            $rst=$this->getData($sql);
            if($rst->rowCount()>0){
                return true;
            }else{
                return false;
            }
        }

        public function generateReceipt($receiptno){
            $sql="CALL spgetinstitutiondetails({$this->clientid})";
            $rst=$this->getData($sql);
            $data=$rst->fetch(PDO::FETCH_ASSOC);
            $lines="----------------------------------------------------------------------------------------------------------------";
            $pdf = new FPDF();
            $pdf->AddPage();
            $pdf->SetFont('Arial','',12);
            $pdf->Cell(139,5,$data['name'],0,1,'C');
            $pdf->Cell(139,5,$data['physicaladdress'],0,1,'C');
            $pdf->Cell(139,5,"P.O Box ". $data['postaladdress'],0,1,'C');
            $pdf->Cell(139,5,"Tel: ".$data['landline'],0,1,'C');
            $pdf->Cell(139,5,"Email: ".$data['email'],0,1,'C');
            $pdf->Cell(139,5,"PIN No: ".$data['pinno'],0,1,'C');
            $pdf->Cell(139,5,"OFFICIAL RECEIPT",0,1,'C');
            //print a blank line
            $pdf->Cell(70,5,"",0,1);
            // get receipt details
            $sql="CALL spgetreceiptdetails({$this->clientid},'{$receiptno}')";
            $rst=$this->connect()->query($sql);
            $data=$rst->fetch(PDO::FETCH_ASSOC);
            //fetch the first row 
            $servedby=$data['servedby'];
            $pdf->Cell(139,5,"Transaction Date: ".$data['receiptdate'],0,1);
            $pdf->Cell(139,5,"Receipt No: ".$data['receiptno'],0,1);
            $pdf->Cell(139,5,"POS Name: ".$data['posname'],0,1);
            $pdf->Cell(139,5,"Customer :    ".$data['customername'],0,1);
            $pdf->Cell(139,5,"Payment Mode: ".$data['paymentmode'],0,1);
            $pdf->Cell(139,5,"Reference:    ". $data['reference'],0,1);
            //print a blank line
            $pdf->Cell(70,5,"",0,1);
            // place item headers
            $pdf->Cell(70,5,"Item Code / Name",0);
            $pdf->Cell(89,5,"Qty X Unit Price",0,1, "R");
             //print a blank line
             $pdf->Cell(70,5,$lines,0,1);
            // fetch all items in the receipt
            $sql="CALL spgetreceiptdetails({$this->clientid},'{$receiptno}')";
            $rst=$this->getData($sql);
            $data=$rst->fetchAll(PDO::FETCH_ASSOC);
            $overalltotal=0;
            foreach($data as $dataitem){
                // print_r($dataitem);
                $unitprice=$dataitem['unitprice']-$dataitem['discount'];
                //echo $dataitem['itemcode']." ".$dataitem['itemname']." ".$dataitem['quantity']." ".$unitprice;
                $total=$unitprice*$dataitem['quantity'];
                $overalltotal+=$total;
                $pdf->Cell(70,5,$dataitem['itemcode'],0);
                $pdf->Cell(90,5,$dataitem['quantity']." X ".$unitprice,0,1,"R");
                $pdf->Cell(139,5,$dataitem['itemname'],0);
                $pdf->Cell(20,5,$total,0,1,"R");
            }
            //print a blank line
            $pdf->Cell(70,5,$lines,0,1);
            $pdf->Cell(159,5,"TOTAL:    ".$overalltotal,0,1,'R');
            //print a blank line
            $pdf->Cell(70,5,$lines,0,1);
            $pdf->Cell(139,5,"Served By:    ".$servedby,0,1);
            $pdf->Output();
        }

        public function getUserSalesSummary($startdate,$enddate,$posname,$userid){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalessummarybyuser({$this->clientid},'{$startdate}','{$enddate}','{$posname}',{$userid})";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getPOSSales($startdate,$enddate,$posid,$paymentmode){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetposreceipts({$this->clientid},'{$startdate}','{$enddate}',{$posid},{$paymentmode})";
           // echo $sql."<br/>";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function cancelPOSSale($receiptno,$reason){
            $sql="CALL spcancelpossale({$this->clientid},'{$receiptno}',{$_SESSION['userid']},'{$reason}')";
            $rst=$this->getData($sql);
            echo "The receipt has been deleted successfully";
        }

        public function holdSale($refno,$customerid,$posid){
            $sql="CALL spsaveheldsale({$this->clientid},'{$refno}',{$customerid},{$posid},{$_SESSION['userid']})";
            $rst=$this->getData($sql);
            echo "Sale has been held succesfully";
        }

        public function getHeldSales(){
            $sql="CALL spgetheldsales({$this->clientid},{$_SESSION['userid']})";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getHeldSaleHeader($id){
            $sql="CALL spgetheldsaleheader({$this->clientid},{$id})";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getHeldsaleDetails($id){
            $sql="CALL spgetheldsaledetails({$this->clientid},{$id})";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function deleteHeldSale($id){
            $sql="CALL spdeleteheldsale({$this->clientid},{$id})";
            $rst=$this->getData($sql);
            echo "deleted"; 
        }

        public function saveTempPOSSalePayment($refno,$paymentmode,$reference,$amount){
            $sql="CALL spsavetemppossalepayment({$this->clientid},'{$refno}',{$paymentmode},'{$reference}',{$amount})";
            //echo $sql."<br/>";
            $rst=$this->getData($sql);
            // echo "deleted" ;
        }

        public function getPOSSalesPayments($id){
            $sql="CALL spgetpossalespayments({$this->clientid},{$id})";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getDashboardSummary($startdate,$enddate){
            $sql="CALL spgetdashboardsummary({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getPaymentMethodsSummary($startdate,$enddate){
            $sql="CALL spgetpaymentmethodsummary({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getTopNCustomers($startdate,$enddate){
            $sql="CALL spgetbestcustomer({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getTopNProducts($startdate,$enddate){
            $sql="CALL spgetbestproduct({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getTopNPOS($startdate,$enddate){
            $sql="CALL spgetbestpos({$this->clientid},'{$startdate}','{$enddate}')";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function savetempbanking($refno, $receiptno,$reference,$amount,$customername,$id){
            $sql="CALL spsavetempbanking({$this->clientid},'{$refno}','{$receiptno}','{$reference}',{$amount},'{$customername}',{$id})";
            //echo $sql."<br/>";
            $rst=$this->getData($sql);
        }

        public function savebanking($refno ,$cashbookaccount, $narration,$reference,$postas,$receiptbanked){
            $sql="CALL sppostbanking({$this->clientid},'{$refno}' ,{$cashbookaccount}, '{$narration}','{$reference}','{$postas}',{$_SESSION['userid']},'{$receiptbanked}')";
            //echo $sql."<br/>";
            //echo $sql."<br/>";
            $rst=$this->getData($sql);
            echo "success";
        }

        public function getPOSReceiptsForBanking($startdate,$enddate,$posid,$paymentmode){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetposreceiptsforbanking({$this->clientid},'{$startdate}','{$enddate}',{$posid},{$paymentmode})";
           
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getCustomerSalesSummary($startdate,$enddate,$posname,$userid){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL spgetsalessummarybycustomer({$this->clientid},'{$startdate}','{$enddate}','{$posname}',{$userid})";
            $rst=$this->getData($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getreceiptitems($receiptno){
            $sql="CALL spgetreceiptitems({$this->clientid},'{$receiptno}')";
            return $this->getJSON($sql);
        }

        public function getreceiptitemdetails($receiptno,$productid){
            $sql="CALL `spgetreceiptitemsdetails`({$this->clientid},'{$receiptno}',{$productid})";
            return $this->getJSON($sql);
        }

        public function getmpesapayment($amount,$reference=''){
            $sql="CALL `spgetmpesatransaction`({$this->clientid},{$amount},'{$reference}')";
            //echo $sql;
            return $this->getJSON($sql);
        }

        public function printreceipt($receiptno){
            $sql="CALL `spupdatereceiptasprinted`({$this->clientid},'{$receiptno}')";
            echo $sql."<br/>";
            $this->getData($sql);
            return "success";
        }

        public function getpossalereceipt($receiptno){
            $sql="CALL `spgetpossalereceipt`({$this->clientid},'$receiptno')";
            return $this->getJSOn($sql);
        }

        function getreceiptheader(){
            $sql="CALL spgetinstitutiondetails({$this->clientid})";
            return $this->getJSON($sql);
        }

        function getreceiptdetails($receiptno){
            $sql="CALL spgetreceiptdetails({$this->clientid},'{$receiptno}')";
            return $this->getJSON($sql);
        }

        function getreceiptpaymentmethods($receiptno){
            $sql="CALL spgetpossalespayments({$this->clientid},'{$receiptno}')";
            return $this->getJSON($sql);
        }

        function getreceiptvatanalysis($receiptno){
            $sql="CALL spgetreceiptvatanalysis({$this->clientid},'{$receiptno}')";
            return $this->getJSON($sql);
        }

        function savetemprefundproduct ($refno,$itemcode,$quantity){
            $sql="CALL sp_savetemprefundedproducts({$this->clientid},'{$refno}' ,'{$itemcode}',{$quantity})";
            // echo $sql."<br/>";
            $rst=$this->getData($sql);
            return "success";
        }

        function refundproducts($refno,$receiptno,$reason,$products){
            $sql="CALL sp_refundproducts({$this->clientid},'{$receiptno}','{$reason}','{$refno}',{$_SESSION['userid']})";
            // echo $sql."<br/>";
            $rst=$this->getData($sql);
            if($rst->rowCount()>0){
                $data=$rst->fetch(PDO::FETCH_ASSOC);
                $receiptno=$data['receiptno'];
                return ["status"=>"success","message"=>"Products refunded successfully","receiptno"=>$receiptno];
                // Send notification to receiptors engine
                
            }else{
                return ["status"=>"error","message"=>"Failed to refund products"];
            }
        }
        
    }
?>