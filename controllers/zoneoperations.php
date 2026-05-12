<?php
    require_once("../models/zone.php");

    $zone=new zone();

    if(isset($_POST['savezone'])){
        $id=$_POST['id'];
        $zonename=$_POST['zonename'];
        $parent=$_POST['parent'];
        echo $zone-> savezone($id,$zonename,$parent);
    }

    if(isset($_GET['getparentzones'])){
        echo $zone->getparentzones();
    }

    if(isset($_GET['getsubzones'])){
        $parent=isset($_GET['parent'])?$_GET['parent']:0;
        echo $zone->getsubzones($parent);
    }

    if(isset($_GET['getzonedetails'])){
        $id=$_GET['id'];
        echo $zone->getzonedetails($id);
    }

    if(isset($_POST['deletezone'])){
        $id=$_GET['id'];
        echo $zone->deletezone($id);
    }

    if(isset($_GET['getzonesandsubzones'])){
        echo $zone->getzonesandsubzones();
    }
?>