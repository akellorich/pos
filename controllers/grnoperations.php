<?php
    require_once("../models/goodsreceived.php");
    $grn=new goodsreceived;

    if(isset($_GET['getuninvoicedgrn'])){
        $supplierid=$_GET['supplierid'];
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $grn->getuninvoicedgrn($supplierid,$startdate,$enddate);
    }
?>