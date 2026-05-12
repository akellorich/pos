<?php

    require_once("../models/purchaseorder.php");
    
    $purchase=new purchaseorder();

   
    if(isset($_POST['savepurchaseorder'])){

        $id=$_POST['id'];
        $supplierid=$_POST['supplierid'];
        $terms=$_POST['terms'];
        $departmentid=$_POST['departmentid'];
        $category=$_POST['category'];
        $currencyid=$_POST['currencyid'];
        $exchangerate=$_POST['exchangerate'];
        $tableData = stripcslashes($_POST['TableData']);
        $taxid=$_POST['taxid'];
        $taxrate=$_POST['taxrate'];

        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);
        // generate reference no
        $refno=$purchase->generateid();
        
        //echo $tableData;
        // save temporary
        foreach($tableData as $saleitem){
            $itemcode=$saleitem['itemcode'];
            $quantity=$saleitem['quantity'];
            $unitprice=$saleitem['unitprice'];
            $taxable=$saleitem['taxable'];
            $taxinclusive=$saleitem['taxinclusive'];
            $purchase->saveTempPurchaseOrderItem($refno,$itemcode,$quantity,$unitprice,$taxable,$taxinclusive);
        }

        // save permanently
        $purchaseorderno=$purchase->savePurchaseOrder($id,$refno,$supplierid,$terms,$departmentid,$category,$currencyid,$exchangerate,$taxid,$taxrate);
        echo $purchaseorderno;

    }

    if(isset($_GET['getpurchaseorders'])){
        $purchase->getPurchaseOrders();
    }

    if(isset($_GET['getsupplierpendingorders'])){
        $supplierid=$_GET['supplierid'];
        $purchase->getSupplierPendingOrders($supplierid);
    }

    if(isset($_GET['getpopendingitems'])){
        $purchaseorderno=$_GET['purchaseorderno'];
        $purchase->getPOUndeliveredItems( $purchaseorderno);
    }
    if(isset($_GET['getpurchaseorderdetails'])){
        $id=$_GET['id'];
        $purchase->getPurchaseOrderDetails($id);
    }
?>