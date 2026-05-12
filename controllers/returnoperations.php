<?php
    require_once("../models/returns.php");

    $return=new returns();

    if(isset($_POST['savereturninwards'])){
        $refno=mt_rand(10000,99999);
        $receiptno=$_POST['receiptno'];
        $returneditems=json_decode(stripcslashes($_POST['returneditems']),true);
        $narration=$_POST['narration'];
        // temporarily save the return details
        foreach($returneditems as $returneditem){
            $productid=$returneditem['productid'];
            $quantity=$returneditem['quantity'];
            $serialno=$returneditem['serialno'];
            $return->savetempreturns($refno,$productid,$serialno,$quantity);
        }
        // permanently save the return
        echo $return->savereturninwards($refno,$receiptno,$narration);
    }
    if(isset($_GET['getreturninwards'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        echo $return->getreturninwards($startdate,$enddate);
    }
    if(isset($_POST['savereturnoutwards'])){
        $refno=mt_rand(10000,99999);
        $grnno=$_POST['grnno'];
        $narration=$_POST['narration'];
        $returneditems=json_decode(stripcslashes($_POST['returneditems']),true);
        // temporarily save the return details
        foreach($returneditems as $returneditem){
            $productid=$returneditem['productid'];
            $quantity=$returneditem['quantity'];
            $serialno=$returneditem['serialno'];
            $return->savetempreturns($refno,$productid,$serialno,$quantity);
        }
        // permanently save the return
        echo $return->savereturnoutwards($refno,$grnno,$narration);
    }
    if(isset($_GET['getreturnoutwards'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        echo $return->getreturnoutwards($startdate,$enddate);
    }
    if(isset($_POST['savereturninwardscollection'])){
        $id=$_POST['id'];
        $collectedby=$_POST['collectedby'];
        echo $return->savereturninwardscollection($id,$collectedby);
    }
    if(isset($_POST['savereturnoutwardsreturn'])){
        $id=$_POST['id'];
        echo $return->savereturnoutwardsreturn($id);
    }

    if(isset($_POST['saveposreturns'])){
        $outletid=$_POST['outletid'];
        $warehouseid=$_POST['warehouseid'];
        $paymentmodeid=$_POST['paymentmodeid'];
        $reference=$_POST['reference'];
        $jsondata=$_POST['products'];
        $returneditems=$_POST['returneditems'];
        $response=$return->saveposreturns($outletid,$warehouseid,$paymentmodeid,$reference,$jsondata,$returneditems);
        echo json_encode($response);
    }
    
?>