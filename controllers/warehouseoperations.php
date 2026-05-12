<?php
    require_once("../models/warehouse.php");
    $warehouse=new warehouse();
    if(isset($_GET['getwarehouses'])){
        $warehouse->getWarehouses();
    }
?>