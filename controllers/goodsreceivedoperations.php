<?php
    require_once("../models/goodsreceived.php");
    $received=new goodsreceived();

    if(isset($_POST['savegoodsreceived'])){

        $warehouse=$_POST['warehouse'];
        $supplier=$_POST['supplier'];
        $deliverynoteno=$_POST['deliverynotenumber'];
        $savecustomerinvoice=$_POST['savecustomerinvoice'];
        $invoiceno=$_POST['invoiceno'];
        $inspectedby=$_POST['inspectedby'];
        $tableData = stripcslashes($_POST['TableData']);
        $transferitems=$_POST['transferitems'];
        $transferpos=$_POST['transferpos'];
       
        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);
        // generate reference no
        $refno=$received->generateid();

        // save temporary
        foreach($tableData as $saleitem){
            $itemcode=$saleitem['itemcode'];
            $quantity=$saleitem['unitsreceived'];
            $purchaseorderno=$saleitem['purchaseorderno'];
            $serialno=$saleitem['serialno'];
            $received->saveTempGoodsReceived($refno,$purchaseorderno,$itemcode,$quantity,$serialno);
        }

        // save permanently
        $grnno=$received->saveGoodsReceived($refno,$warehouse,$supplier,$deliverynoteno,$savecustomerinvoice,$invoiceno,$inspectedby,$transferitems,$transferpos);
        echo $grnno;
    }
    if(isset($_GET['getgrnproducts'])){
        $grnno=$_GET['grnno'];
        echo $received->getgrnproducts($grnno);
    }
    if(isset($_GET['getgrnitemdetails'])){
        $grnno=$_GET['grnno'];
        $productid=$_GET['productid'];
        echo $received->getgrnitemdetails($grnno,$productid);
    }
?>