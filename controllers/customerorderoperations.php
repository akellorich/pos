<?php
    require_once("../models/customerorders.php");
    require_once("../models/sale.php");
    

    $order=new customerorders();
    $sale=new sale();

    if(isset($_POST['savecustomerorder'])){
        $refno=generate_random_no(20);
        $posid=$_POST['posid'];
        $customerid=$_POST['customerid'];
        $tableid=$_POST['tableid'];
        $orderitems=json_decode(stripcslashes($_POST['orderitems']),true);

        foreach($orderitems as $orderitem){
            $productid=$orderitem['productid'];
            $quantity=$orderitem['quantity'];
            $unitprice=$orderitem['unitprice'];
            $order->savetempcustomerorder($refno,$productid,$quantity,$unitprice);
        }

        $response=$order->savecustomerorder($refno,$posid,$customerid,$tableid);
        echo json_encode($response);
    }

    if(isset($_GET['getcustomerorderdetails'])){
        $orderno=$_GET['orderno'];
        echo $order->getcustomerorder($orderno);
    }

    if(isset($_GET['filtercustomerorders'])){
        $customerid=isset($_GET['customerid'])?$_GET['customerid']:0;
        $tableid=$_GET['tableid'];
        $posid=$_GET['posid'];
        $waiterid=$_GET['waiterid'];
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $orderstatus=$_GET['orderstatus'];
        echo $order->filtercustomerorders($customerid,$tableid,$posid,$waiterid,$startdate,$enddate,$orderstatus);
    }

    if(isset($_POST['getorderstotal'])){
        $orders=json_decode(stripcslashes($_POST['orders']),true);
        $refno=generate_random_no();
        foreach($orders as $orderid){
            $order->savetemporderstosettle($refno,$orderid);
        }
        echo $order->getorderstotal($refno);
    }

    if(isset($_POST['settlecustomeroders'])){

        $orders=json_decode(stripcslashes($_POST['orders']),true);
        $paymentmethods=json_decode(stripcslashes($_POST['payments']),true);
        $refno=generate_random_no();

        foreach($paymentmethods as $paymentmethod){
            $paymentmode=$paymentmethod['modeid'];
            $reference=$paymentmethod['referenceno'];
            $amount=$paymentmethod['amount'];
            $sale->saveTempPOSSalePayment($refno,$paymentmode,$reference,$amount);
        }

        foreach($orders as $orderid){
            $order->savetemporderstosettle($refno,$orderid);
        }

        $response=$order->settlecustomerorders($refno);

        echo json_encode($response);
    }

    if(isset($_GET['getreceiptheader'])){
        echo $sale-> getreceiptheader();
    }

    if(isset($_POST['cancelcustomerorder'])){
        $orderid=$_POST['orderid'];
        $reason=$_POST['reason'];
        $response=$order->cancelcustomerorder($orderid,$reason);
        echo json_encode($response);
    }
?>