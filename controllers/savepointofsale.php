<?php

    require_once("../models/pointofsale.php");
    $pos=new pointOfSale();
    if(isset($_POST['savepos'])){
        $id=$_POST['id'];
        $posname=$_POST['posname'];
        $pos->savePointOfSale($id,$posname);
    }

?>