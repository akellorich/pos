<?php

require_once("db.php");
require_once("../fpdf181/fpdf.php");

class customer extends db{

    function checkCustomerName($id,$name){
        $sql="CALL spcheckcustomername({$id},'{$name}')";
        //$rst=$this->connect()->query($sql);
        return $this->getData($sql)->rowCount()>0? true:false;
    }

    function checkcustomerdocuments($customerid,$document,$docno){
        $sql="CALL `spcheckcustomerdocuments`({$customerid},'{$document}','{$docno}')";
        return $this->getData($sql)->rowCount()?true:false;
    }

    // function saveCustomer($customerid,$customername,$physicaladdress,$postaladdress,$mobile ,$email,$creditlimit,$category,$posid,$onetimecustomer,$pinno,$idno,$subzoneid){
    //     if(!$this->checkCustomerName($customerid,$customername)){
    //         // check if either PIN or ID number exists
    //         if($this->checkcustomerdocuments($customerid,'pin',$pinno)){
    //             return "pin exists";
    //         }else if($this->checkcustomerdocuments($customerid,'id',$idno)){
    //             return "id exists";
    //         }else{
    //             $sql="CALL spsavecustomer({$customerid},'{$customername}','{$physicaladdress}','{$postaladdress}','{$mobile}' ,'{$email}',{$creditlimit},{$_SESSION['userid']},{$category},{$posid},{$onetimecustomer},'{$pinno}','{$idno}',{$subzoneid})";
    //             echo $sql;
    //             $this->getData($sql);
    //             return  "success";
    //         }
    //     }else{
    //         return "name exists";
    //     }
    // }

    function saveCustomer($customerid,$customername,$tradingname,$physicaladdress,$postaladdress,$mobile ,$email,$creditlimit,$creditterm,$category,$posid,$onetimecustomer,$pinno,$idno,$subzoneid){
        if(!$this->checkCustomerName($customerid,$customername)){
            // check if either PIN or ID number exists
            // if($this->checkcustomerdocuments($customerid,'pin',$pinno)){
            //     return "pin exists";
            // }else if($this->checkcustomerdocuments($customerid,'id',$idno)){
            //     return "id exists";
            // }else{
            $sql="CALL spsavecustomer({$customerid},'{$customername}','{$tradingname}','{$physicaladdress}','{$postaladdress}','{$mobile}' ,'{$email}',{$creditlimit},{$creditterm},{$_SESSION['userid']},{$category},{$posid},{$onetimecustomer},'{$pinno}','{$idno}',{$subzoneid})";
            // echo $sql;
            $this->getData($sql);
            return  "success";
            // }
        }else{
            return "name exists";
        }
    }

    function getCustomerDetails($customerid){
        $sql="CALL spgetcustomerdetails({$customerid})";
        //$rst=$this->connect()->query($sql);
        //echo json_encode($rst->fetch(PDO::FETCH_ASSOC));
        return $this->getJSON($sql);
    }


    function deleteCustomer($customerid){
        $sql="CALL spdeletecustomer({$customerid},{$_SESSION['userid']})";
        $this->getData($sql);
        return "success";
    }

    function getCustomers($posid,$regularcustomers,$onetimecustomers){
        $sql="CALL spgetcustomers({$posid},{$regularcustomers},{$onetimecustomers})";
        //$rst=$this->connect()->query($sql);
        // echo $sql."<br/>";
        return $this->getJSON($sql);// json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
    }

    function getCustomerCategories(){
        $sql="CALL spgetcustomercategories()";
        //$rst=$this->connect()->query($sql);
        return $this->getJSON($sql);// json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
    }

    function saveCustomerDiscountDetails($id,$customerid,$productid,$discount,$percentage,$expirydate){
        $expirydate=$this->mySQLDate($expirydate);
        $sql="CALL spsavecustomerdiscountsettings({$id} ,{$customerid},{$productid},{$discount},{$percentage},{$_SESSION['userid']},'{$expirydate}')";
        //echo $sql."</br>";
        $this->getData($sql);
        echo "success";
    }

    function getCustomerDiscountSettings($customerid){
        $sql="CALL spgetcustomerdiscountsettings({$customerid})";
        //$rst=$this->connect()->query($sql);
        //echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        return $this->getJSON($sql);
    }

    function deleteCustomerDiscount($id){
        $sql="CALL spdeletecustomerdiscount({$id},{$_SESSION['userid']})";
        $this->GetData($sql);
        echo "The customer discount has been deleted successfully.";
    }

    function saveTempCustomerReceipt($refno, $possaleid,$amount){
        if($amount!=""){
            $sql="CALL sptempsavecustomerreceiptdetails('{$refno}',{$possaleid},{$amount})";
            //echo $sql."<br/>";
            $this->GetData($sql);
        }  
    }

    function saveCustomerReceipt($refno,$customerid,$paymentmode,$referenceno,$overpay){
        $sql="CALL spsavecustomerreceipt('{$refno}',{$customerid}, {$paymentmode},'{$referenceno}',{$_SESSION['userid']},{$overpay})";
        //echo $sql."<br/>";
        $rst=$this->getData($sql);
        if($rst->rowCount()>0){
            $data=$rst->fetch(PDO::FETCH_ASSOC);
            return $data['receiptno'];
            // generate receipt
            //$this->generateReceipt($data['receiptno']);
         }
       // $data=$rst->fetchAll(PDO::FETCH_ASSOC);
       // echo var_dump($data);
       // return $data['receiptno'];
    }

    function getCustomerOpenReceivables($customerid){
        $sql="CALL spgetcustomeropenreceivables({$customerid})";
        //$rst=$this->connect()->query($sql);
        //echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        return $this->getJSON($sql);
    }

    function generateReceipt($receiptno){
        $sql="CALL spgetinstitutiondetails()";
            $rst=$this->GetData($sql);
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
            $sql="CALL spgetcustomerreceiptdetails('{$receiptno}')";
            $rst=$this->getData($sql);
            $data=$rst->fetch(PDO::FETCH_ASSOC);
            //fetch the first row 
            $servedby=$data['servedby'];
            $pdf->Cell(139,5,"Transaction Date: ".$data['receiptdate'],0,1);
            $pdf->Cell(139,5,"Receipt No: ".$data['receiptno'],0,1);
            $pdf->Cell(139,5,"Customer Name:    ".$data['customername'],0,1);
            $pdf->Cell(139,5,"Payment Mode: ".$data['paymentmode'],0,1);
            $pdf->Cell(139,5,"Reference #:    ". $data['referenceno'],0,1);
            //print a blank line
            $pdf->Cell(70,5,"",0,1);
            // place item headers
            $pdf->Cell(70,5,"Narration",0);
            $pdf->Cell(89,5,"Amount",0,1, "R");
             //print a blank line
             $pdf->Cell(70,5,$lines,0,1);
            // fetch all items in the receipt
            $sql="CALL spgetcustomerreceiptdetails('{$receiptno}')";
            $rst=$this->getData($sql);
            $data=$rst->fetchAll(PDO::FETCH_ASSOC);
            $overalltotal=0;
            foreach($data as $dataitem){
                // print_r($dataitem);
                // $unitprice=$dataitem['unitprice']-$dataitem['discount'];
                //echo $dataitem['itemcode']." ".$dataitem['itemname']." ".$dataitem['quantity']." ".$unitprice;
                $total=$dataitem['amount'];
                $overalltotal+=$total;
                $pdf->Cell(70,5,$dataitem['narration'],0);
                //$pdf->Cell(90,5,$dataitem['quantity']." X ".$unitprice,0,1,"R");
                //$pdf->Cell(139,5,$dataitem['itemname'],0);
                $pdf->Cell(90,5,$total,0,1,"R");
            }
            //print a blank line
            $pdf->Cell(70,5,$lines,0,1);
            $pdf->Cell(159,5,"TOTAL:    ".$overalltotal,0,1,'R');
            //print a blank line
            $pdf->Cell(70,5,$lines,0,1);
            $pdf->Cell(139,5,"Served By:    ".$servedby,0,1);
            $pdf->Output();
    }

    function getCustomerUnbankedReceipts($paymentmode,$startdate,$enddate){
        $startdate=$this->mySQLDate($startdate);
        $enddate=$this->mySQLDate($enddate);
        $sql="CALL spgetcustomerunbankedreceipts('{$startdate}','{$enddate}',{$paymentmode})";
        return $this->getJSON($sql);
    }

    function getinsertedcustomer(){
        $sql="CALL `spgetinsertedcustomer`()";
        return $this->getJSON($sql);
    }

    function getsuspenseaccountstatement($customerid,$startdate,$enddate){
        $startdate=$this->mySQLDate($startdate);
        $enddate=$this->mySQLDate($enddate);
        $sql="CALL spgetcustomesuspenseaccountstatement({$customerid},'{$startdate}','{$enddate}')";
        return $this->getJSON($sql);
    }

    function checkcustomercontact($id,$customerid,$contactname){
        $sql="CALL `sp_checkcustomercontact`({$id},{$customerid},'{$contactname}')";
        return $this->getData($sql)->rowCount();
    }

    function savecustomercontact($id,$customerid,$categoryid,$contactname,$mobile,$email){
        if($this->checkcustomercontact($id,$customerid,$contactname)){
            return "exists";
        }else{
            $sql="CALL `sp_savecustomercontact`({$id},{$customerid},{$categoryid},'{$contactname}','{$mobile}','{$email}',{$_SESSION['userid']})";
            $this->getData($sql);
            return "success";
        }
    }

    function deletecustomercontact($id){
        $sql="CALL `sp_deletecustomercontact`({$id},{$_SESSION['userid']})";
        $this->getData($sql);
        return "success";
    }

    function getcustomercontacts($customerid){
        $sql="CALL `sp_getcustomercontacts`({$customerid})";
        return $this->getJSON($sql);
    }

    function getcontactcategories(){
        $sql="CALL `sp_getcontactscategories`()";
        return $this->getJSON($sql);
    }
}

?>
