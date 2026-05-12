<?php
    require_once("../models/settings.php");
    $settings=new settings();
    $paymentmethods= new settings();
    echo $paymentmethods->getPaymentMethods();
?>