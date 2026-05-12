<?php
    require_once("../models/fleet.php");

    $vehicle=new fleet();

    if(isset($_GET['getfueltypes'])){
        echo $vehicle->getvehiclefueltypes();
    }
    if(isset($_GET['getbodytypes'])){
        echo $vehicle->getvehiclebodytypes();
    }
    if(isset($_GET['getvehicles'])){
        echo $vehicle->getvehicles();
    }
    if(isset($_POST['savevehicle'])){
        $vehicleid=$_POST['vehicleid'];
        $regno=$_POST['regno'];
        $bodytypeid=$_POST['bodytypeid'];
        $fueltypeid=$_POST['fueltypeid'];
        $enginerating=$_POST['enginerating'];
        $vehicleid=$vehicle->savevehicle($vehicleid,$regno,$bodytypeid, $fueltypeid, $enginerating);
        echo is_numeric($vehicleid)?"success":$vehicleid;
    }
    if(isset($_POST['savefuelrequisition'])){
        $id=$_POST['id'];
        $supplierid=$_POST['supplierid'];
        $costcenterid=$_POST['costcenterid'];
        $vehicleid=$_POST['vehicleid'];
        $requestedby=$_POST['requestedby'];
        $approvedby=$_POST['approvalby'];
        $quantity=$_POST['quantity'];
        $unitprice=$_POST['unitprice'];
        $odoreading=$_POST['odoreading'];
        echo $vehicle->savefuelrequisition($id,$supplierid,$costcenterid,$vehicleid,$requestedby,$approvedby,$quantity,$unitprice,$odoreading);
    }

    if(isset($_GET['filterrequisitions'])){
        
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $supplierid=$_GET['supplierid'];
        $costcenterid=$_GET['costcenterid'];
        $vehicleid=$_GET['vehicleid'];

        echo $vehicle->filterfleetrequisitions($supplierid,$costcenterid,$vehicleid,$startdate,$enddate);
    }

    if(isset($_GET['getrequisitiondetails'])){
        $id=$_GET['id'];
        echo $vehicle->getrequisitiondetails($id);
    }

    if(isset($_POST['approverequisition'])){
        $id=$_POST['id'];
        echo $vehicle->approverequisition($id);
    }

    
?>