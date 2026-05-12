<?php

    require_once("../models/creditnote.php");
    
    $creditnote = new creditnote();

    if(isset($_POST['savecreditnote'])){
        $customerid=$_POST['customerid'];
        $tableData = stripcslashes($_POST['TableData']);
        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);
        // generate reference no
        $refno=generate_random_no();
        // save temporary
        foreach($tableData as $saleitem){
           $itemcode=$saleitem['itemcode'];
           $quantity=$saleitem['quantity'];
           $unitprice=$saleitem['unitprice'];
           // temp save creadit note details
           $creditnote->saveTempCreditNoteDetails($refno,$itemcode,$quantity,$unitprice);
        } 
        // permanent save
        $creditnote->saveCreditNote($refno,$customerid);
        // return json with reference no

    }else if(isset($_GET['getcustomercreditnotes'])) {
        $customerid=$_GET['customerid'];
        $creditnote->getCustomerCreditNotes($customerid);
    }elseif(isset($_GET['getcreditnotetotal'])){
        $creditnotenumber=$_GET['creditnotenumber'];
        $creditnote->getCreditNoteValue($creditnotenumber);
    }

?>