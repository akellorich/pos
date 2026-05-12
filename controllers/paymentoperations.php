<?php 
    require_once("../models/payment.php");
    $payment=new payment();
    if(isset($_POST['savepayment'])){
        $pos=$_POST['pos'];
        $supplier=$_POST['supplier'];
        $paymentmode=$_POST['paymentmode'];
        $cashbookaccount=$_POST['cashbookaccount'];
        $reference=$_POST['reference'];
        $voucherno=$_POST['voucherno'];
        $generatevoucherno=$_POST['generatevoucherno'];
        $voucherdate=$_POST['voucherdate'];
        $id=$_POST['id'];
        $pettycash=isset($_POST['pettycash'])?1:0;
        //$invoicenumber=$_POST['invoiceno'];
        $tableData = stripslashes($_POST['TableData']);
        // generate reference no
        $refno=generate_random_no();
        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);
        $craterefund=isset($_POST['craterefund'])?1:0;
        // save temporary
        foreach($tableData as $paymentitem){
            $itemcode=$paymentitem['invoicenumber'];
            $description=$paymentitem['description'];
            $quantity=$paymentitem['quantity'];
            $unitprice=$paymentitem['unitprice'];
            $accountcharged=$paymentitem['accountcharged']; 
            $invoicenumber=$paymentitem['invoicenumber'];
            $payment->savetemppaymentvoucherdetails($refno,$itemcode,$description,$quantity,$unitprice,$accountcharged,$invoicenumber);
        }
        // permanent save
        $payment->savepaymentvoucher($refno,$id,$voucherdate,$voucherno,$pos,$supplier,$paymentmode,$cashbookaccount,$reference,$generatevoucherno,$pettycash,$craterefund);
    }else if(isset($_GET['getpaymentvouchers'])){
        $supplierid=$_GET['supplierid'];
        $posid=$_GET['posid'];
        $stat=$_GET['stat'];
        $paymentmode=$_GET['paymentmode'];
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $pettycashvoucher=isset($_GET['pettycashvouchers'])?$_GET['pettycashvouchers']:0;
        $payment->getpaymentvouchers($supplierid,$posid, $stat,$paymentmode, $startdate,$enddate,$pettycashvoucher);
    } else if(isset($_GET['getvoucherdetails'])){
        $id=$_GET['id'];
        if($id!=""){
             $payment->getVoucherDetails($id);
        }
    }else if(isset($_GET['getvoucheritems'])){
        $id=$_GET['id'];
        $payment->getVoucherItems($id);
    }else if(isset($_POST['approvepaymentvoucher'])){
        $id=$_POST['id'];
        $payment->approvePaymentVoucher($id);
    }else if(isset($_POST['cancelpaymentvoucher'])){
        $id=$_POST['id'];
        $reason=$_POST['reason'];
        $payment->deletePaymentVoucher($id,$reason);
    }else if(isset($_GET['getvoucherstatus'])){
        $id=$_GET['id'];
        $payment->getPaymentVoucherStatus($id);
    }

?>