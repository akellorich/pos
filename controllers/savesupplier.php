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

?>