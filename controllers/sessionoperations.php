<?php
    require_once("../models/sessions.php");

    $session=new session();

    if(isset($_GET['getactivesession'])){
        echo $session->getactivesession();
    }

    if(isset($_POST['activatesession'])){
        $float=$_POST['float'];
        $response=$session->activatesession($float);
        echo json_encode($response);
    }

    if(isset($_POST['closesession'])){
        $response=$session->closesession();
        echo json_encode($response);
    }

    if(isset($_GET['getsessions'])){
        echo $session->getsessions();
    }

    if(isset($_GET['getsessioncollection'])){
        $sessionid=$_GET['sessionid'];
        echo $session->getsessioncollection($sessionid);
    }

?>