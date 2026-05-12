<?php

    require_once('../models/sale.php');
    $receipt= new sale();
    $receiptno=$_GET['receiptno'];
    $receipt->generateReceipt($receiptno);

?>