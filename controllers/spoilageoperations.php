<?php
    require_once("../models/spoilage.php");

    $spoilage=new spoilage();

    if(isset($_GET['getspoilagecategories'])){
        echo $spoilage->getspoilagecategories();
    }

    if(isset($_POST['savespoilage'])){
        $id=$_POST['id'];
        $categoryid=$_POST['categoryid'];
        $productid=$_POST['productid'];
        $quantity=$_POST['quantity'];
        $narration=$_POST['narration'];
        $storecategory=$_POST['storecategory'];
        $storeid=$_POST['storeid'];
        echo $spoilage->savespoilage($id,$categoryid,$productid,$quantity,$narration,$storecategory,$storeid);
    }

    if(isset($_GET['filterspoilage'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $categoryid=$_GET['categoryid'];
        $productid=$_GET['productid'];
        echo $spoilage->filterspoilage($startdate,$enddate,$categoryid,$productid);
    }

?>