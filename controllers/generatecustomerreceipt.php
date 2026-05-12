<?php 
    require_once("../models/customer.php");
    $customer=new customer();
    $receiptno=$_GET['receiptno'];
    $customer->generateReceipt($receiptno)
?>