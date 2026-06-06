<?php
    require_once("../models/production.php");
    $production = new production();

    if (isset($_GET['getproductions'])) {
        $alldates = $_GET['alldates'];
        $startdate = $_GET['startdate'];
        $enddate = $_GET['enddate'];
        $warehouseid = $_GET['warehouseid'];
        $productid = $_GET['productid'];
        echo $production->getProductions($alldates, $startdate, $enddate, $warehouseid, $productid);
    }

    if (isset($_GET['getproductswithrecipes'])) {
        echo $production->getProductsWithRecipes();
    }

    if (isset($_POST['saveproduction'])) {
        $id = $_POST['id'];
        $productiondate = $_POST['productiondate'];
        $productid = $_POST['productid'];
        $quantity = $_POST['quantity'];
        $warehouseid = $_POST['warehouseid'];
        echo $production->saveProduction($id, $productiondate, $productid, $quantity, $warehouseid);
    }

    if (isset($_POST['deleteproduction'])) {
        $id = $_POST['id'];
        echo $production->deleteProduction($id);
    }
?>
