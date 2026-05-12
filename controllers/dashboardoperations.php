<?php
    require_once("../models/sale.php");
    $dashboarditem= new sale();
    if(isset($_GET['getdashboardsummary'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $dashboarditem->getDashboardSummary($startdate,$enddate);
    }
    
    if(isset($_GET['getpaymentssummary'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $dashboarditem->getPaymentMethodsSummary($startdate,$enddate);
    }

    if(isset($_GET['gettopncustomers'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $dashboarditem->getTopNCustomers($startdate,$enddate);
    }
    
    if(isset($_GET['gettopnproducts'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $dashboarditem->getTopNProducts($startdate,$enddate);
    }

    if(isset($_GET['gettopnpos'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $dashboarditem->getTopNPOS($startdate,$enddate);
    }
?>