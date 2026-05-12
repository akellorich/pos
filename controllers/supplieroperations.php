<?php 

    require_once("../models/supplier.php");
    $supplier=new supplier();

    if(isset($_POST['savesupplier'])){
        $id=$_POST['id'];
        $suppliername=$_POST['suppliername'];
        $physicaladdress=$_POST['physicaladdress'];
        $postaladdress=$_POST['postaladdress'];
        $mobile=$_POST['mobile'];
        $email=$_POST['email'];
        $creditlimit=$_POST['creditlimit'];
        $supplierpinno=$_POST['supplierpinno'];
        $supplier-> saveSupplier($id,$suppliername,$physicaladdress,$postaladdress,$mobile ,$email,$creditlimit,$supplierpinno);
    }
    if(isset($_GET['getsupplierdetails'])){
        $supplierid=$_GET['supplierid'];
        $supplier->getSupplierDetails($supplierid);
    }
    if(isset($_POST['deletesupplier'])){
        $supplierid=$_POST['supplierid'];
        $supplier-> deleteSupplier($supplierid);
    }
    if(isset($_POST['savesupplierinvoice'])){
        $supplierid=$_POST['supplierid'];
        $invoiceno=$_POST['invoiceno'];
        $invoicedate=$_POST['invoicedate'];
        $tableData = stripcslashes($_POST['TableData']);
        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);
        // generate reference no
        $refno=generate_random_no();

        // save temporary
        foreach($tableData as $grn){
            $grnno=$grn['grnno'];
            $supplier->savetempinvoicedetails($refno,$grnno);
        }
        // permanent save
        $supplier->saveinvoice($refno,$invoiceno,$supplierid, $invoicedate);
    }
    if(isset($_GET['getsupplierinvoices'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $supplierid=$_GET['supplierid'];
        $status=$_GET['status'];
        $supplier->getSupplierInvoices($supplierid,$status,$startdate,$enddate);
    }
    if(isset($_GET['getinvoicegrndetails'])){
        $id=$_GET['id'];
        $supplier->getInvoiceGRNDetails($id);
    }

?>