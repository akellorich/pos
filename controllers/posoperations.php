<?php 
    require_once("../models/pointofsale.php");
    $pos=new pointofsale();

    if(isset($_POST['savepos'])){
        $id=$_POST['id'];
        $posname=$_POST['posname'];
        $postype=$_POST['postype'];
        $printkot=$_POST['printkot'];
        $poscategories=json_decode(stripcslashes($_POST['poscategories']),true);
        $response=$pos->savePointOfSale($id,$posname,$postype,$printkot);
        if($response['status']=="success"){
            $posid=$response['posid'];
            foreach($poscategories as $category){
                $categoryid=$category['categoryid'];
                $status=$category['status'];
                $pos->saveposproductcategory($posid,$categoryid,$status);
            }
        }
        echo json_encode($response);
    }

    if(isset($_GET['getposdetails'])){
        $posid=$_GET['id'];
        $pos->getposdetails($posid);
    }

    if(isset($_POST['deletepos'])){
        $id=$_POST['id'];
        $pos->deletePointOfSale($id);
    }

    if(isset($_POST['saveuseroutlet'])){
        $userid=$_POST['userid'];
        // this will be an array    
        $tableData = stripslashes($_POST['outletid']);
        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);       
        foreach($tableData as $outlet){
            $outletid=$outlet['id'];
            $response=$pos->saveuseroutlet($userid,$outletid);
        }
        echo $response; 
    }

    if(isset($_GET['getuseroutlets'])){
        $userid=$_GET['userid'];
        if($userid==0){
            $userid=$_SESSION['userid'];
        }
        echo $pos->getuseroutlets($userid);
       
    } 

    if(isset($_POST['deleteuseroutlet'])){
         $id=$_POST['id'];
         echo $pos->deleteuseroutlet($id);
    }

    if(isset($_GET['getnonuseroutlets'])){
        $userid=$_GET['userid'];
        echo $pos->getnonuseroutlets($userid);
    }

    if(isset($_GET['getpointsofsale'])){
        echo $pos->getPointOfSales();
    }

    if(isset($_GET['getposproductcategories'])){
        $posid=$_GET['posid'];
        echo $pos->getposproductcategories($posid);
    }

    if(isset($_POST['savetable'])){
        $tableid=$_POST['tableid'];
        $posid=$_POST['posid'];
        $tablename=$_POST['tablename'];
        $response=$pos->savetable($tableid,$posid,$tablename);
        echo json_encode($response);
    }

    if(isset($_GET['getpostables'])){
        $posid=isset($_GET['posid'])?$_GET['posid']:0;
        echo $pos->gettables($posid);
    }

    if(isset($_GET['gettabledetails'])){
        $tableid=$_GET['tableid'];
        echo $pos->gettabledetails($tableid);
    }

    if(isset($_POST['deletetable'])){
        $tableid=$_POST['tableid']  ;
        $response=$pos->deletetable($tableid);
        echo json_encode($response);
    }

   

?>