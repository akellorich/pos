<?php

    require_once("../models/rawmaterial.php");
    require_once("../models/user.php");

    $rawmaterial=new rawmaterial();
    $user = new User();

    if(isset($_GET['getrawmaterialcategories'])){
        echo $rawmaterial->getcategories();
    }

    if(isset($_POST['saverawmaterial'])){
        $materialid=$_POST['materialid'];
        $categoryid=$_POST['categoryid'];
        $materialname=$_POST['materialname'];
        $uom=$_POST['uom'];
        $physicalproduct=$_POST['physicalproduct'];
        $unitprice=$_POST['unitprice'];
        $itemcode=$_POST['itemcode'];
        $generateitemcode=$_POST['generateitemcode'];
        echo $rawmaterial->saverawmaterial($materialid,$categoryid,$materialname,$uom,$physicalproduct, $unitprice,$itemcode,$generateitemcode);
    }

    if(isset($_GET['getrawmaterials'])){
        echo $rawmaterial->getrawmaterials();
    }

    if(isset($_GET['getrawmaterialdetails'])){
        $materialid=$_GET['materialid'];
        echo $rawmaterial->getrawmaterialdetails($materialid);
    }

    if(isset($_POST['deleterawmaterial'])){
        $materialid=$_POST['materialid'];
        echo $rawmaterial->deleterawmaterial($materialid);
    }

    if(isset($_POST['savematerialrequisition'])){
        $id=$_POST['id'];
        $departmentid=$_POST['departmentid'];
        $scope=$_POST['scopeid'];
        $usecaseid=$_POST['materialuse'];
        $reference=$_POST['refno'];
        $supplierid=$_POST['supplierid'];
        $activityid=$_POST['activityid'];
        $narration=$_POST['narration'];
        $siteid=$_POST['siteid'];
        $materials=json_decode(stripcslashes($_POST['materials']),TRUE);
        $refno=mt_rand(1000,9999);
        $purchaserequisition=isset($_POST['purchaserequisition'])?$_POST['purchaserequisition']:0;

        // post temp material request
        foreach($materials as $materialitem){
            $itemid=$materialitem['itemid'];
            $quantity=$materialitem['quantity'];
            $unitprice=$materialitem['unitprice'];
            $materialnarration=$materialitem['narration'];
            $rawmaterial->savetempmaterialrequisitiondetails($refno,$itemid,$quantity,$unitprice,$materialnarration);
        }

        $requisitionno=$material->savematerialrequisition($id,$refno,$usecaseid,$reference,$narration,$scope,$supplierid,$activityid,$departmentid,$purchaserequisition,$siteid);
        
        if($requisitionno!="exists"){
            $rst=$material->getrequisitionapprovalusers($requisitionno,1);
            $emailaddresses='';
            $approvalusers=[];
            $approvallevelname=$material->getrequisitionapprovallevelname(1); 
            $subject="{$approvallevelname} approval request for requisition number {$requisitionno}";
            while($row=$rst->fetch()){
                //$emailaddresses.= $emailaddresses==''?$row['email']:';'.$row['email'];
                $emailmessage="Hello ".$row['firstname']." ".$row['middlename'].",<br/>Please find requisition number <strong>{$requisitionno}</strong> posted in the system.<br/>You may also review and approve as <strong> {$approvallevelname}</strong> for it to proceed to the next process. <br/>Thank you.<br/>Kind regards,<br/>{$_SESSION['username']}";
                // save notification
                $notification->savenotification($subject,$emailmessage,'Requisition Approval',$row['id']);
                //send an email to approvers
                $mail->sendEmail($row['email'],$subject,$emailmessage,$_SESSION['username']);
            }
        }
        echo $requisitionno;
    }

    if(isset($_GET['getrequisitionapprovallevel'])){
        echo $rawmaterial->getrequisitionapprovallevels();
    }

    if(isset($_GET['filterrequisitions'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $departmentid=$_GET['departmentid'];
        $supplierid=$_GET['supplierid'];
        $usecaseid=$_GET['usecaseid'];
        $requisitionstatus=$_GET['requisitionstatus'];
        $requisitionno=$_GET['requisitionno'];
        echo $rawmaterial->filterrequisitions($startdate,$enddate,$departmentid,$supplierid,$usecaseid,$requisitionstatus,$requisitionno);
    }
    if(isset($_GET['getrequisitionapprovalstatus'])){
        $requisitionno=$_GET['requisitionno'];
        echo $rawmaterial->requisitionapprovalstatus($requisitionno);
    }
    if(isset($_POST['approverequisition'])){
        $requisitionno=$_POST['requisitionno'];
        $approvallevelid=$_POST['approvallevel'];
        $narration=$_POST['narration'];
        $approvalstatus=$material->approverequisition($requisitionno,$approvallevelid,$narration);
        $approvallevelstatus=$material->getrequisitioncurrentstatus($requisitionno);
        if($approvalstatus=="success"){
            // check if requisition fully approved and alert po preparation users
            // echo $approvallevelstatus."<br/>";
            if($approvallevelstatus=="Approved"){
                // check if requisition is for purchase
                if ($material->requisitionforpurchase($requisitionno)){
                    // get po preparation users
                    $rst=$user->getuserswithprivileges(7);
                    
                    $emailaddresses='';
                   
                    while($row=$rst->fetch()){ 
                        $subject="Purchase Order Preparation request for requisition number {$requisitionno}";
                        $emailaddresses=$row['email'];
                        $emailmessage="Hello,".$row['firstname']." ".$row['middlename']."<br/>Please prepare a purchase order for requisition number <strong>{$requisitionno}</strong> already approved in the system.<br/><br/>Thank you.<br/>Kind regards,<br/>{$_SESSION['username']}";
                        $notification->savenotification($subject,$emailmessage,'Purchase Order Preparation',$row['id']); 
                        $mail->sendEmail($emailaddresses,$subject,$emailmessage,$_SESSION['username']);
                    }
                }else{
                    // get po warehouse dispatch users
                    $rst=$user->getuserswithprivileges(26);
                    $emailaddresses='';
                    while($row=$rst->fetch()){
                        $emailaddresses=$row['email'];
                        $subject="Material Issue Request for Requisition # {$requisitionno}";
                        $emailmessage="Hello,".$row['firstname']." ".$row['middlename']."<br/>Please issue materials requested using requisition number <strong>{$requisitionno}</strong> that has been fully approved in the system.<br/><br/>Thank you.<br/>Kind regards,<br/>{$_SESSION['username']}";
                        $notification->savenotification($subject,$emailmessage,'Material Issue',$row['id']); 
                        //send an email to approvers
                        $mail->sendEmail($emailaddresses,$subject,$emailmessage,$_SESSION['username']);
                    }
                }
            }else{
                // get the next approval level and notify the next approval officers
                $nextapprovallevel=$material->getrequisitionnextapprovallevel($requisitionno);
                //$material->emailrequisitionapprovalusers($requisitionno,$nextapprovallevel);
                $rst=$material->getrequisitionapprovalusers($requisitionno,$nextapprovallevel);
                $emailaddresses='';
                while($row=$rst->fetch()){
                    $emailaddresses=$row['email'];
                    $approvallevelname=$material->getrequisitionapprovallevelname($nextapprovallevel);
                    $subject="{$approvallevelname} approval request for requisition number {$requisitionno}";
                    $emailmessage="Hello ".$row['firstname']." ".$row['middlename'].", <br/>Please find requisition number <strong>{$requisitionno}</strong> posted in the system.<br/>You may also review and approve as <strong> {$approvallevelname}</strong> for it to proceed to the next process. <br/>Thank you.<br/>Kind regards,<br/>{$_SESSION['username']}";
                    $notification->savenotification($subject,$emailmessage,'Requisition Approval',$row['id']);
                    //send an email to approvers
                    $mail->sendEmail($emailaddresses,$subject,$emailmessage,$_SESSION['username']);
                }
            }
            echo "success";
        }else{
            echo $approvalstatus;
        }
    }

    if(isset($_GET['getpopendingdepartmentrequisitions'])){
        $departmentid=$_GET['departmentid'];
        echo $rawmaterial->getdepartmentpendingporequisitions($departmentid);
    }

    if(isset($_GET['getrequisitionitems'])){
        $requisitionno=$_GET['requisitionno'];
        echo $rawmaterial->getrequisitionitems($requisitionno);
    }

    if(isset($_GET['getpurchaseorderapprovallevel'])){
        echo $rawmaterial->getpurchaseorderapprovallevels();
    }

    if(isset($_GET['getpurchaseorderapprovalstatus'])){
        $purchaseorderno=$_GET['purchaseorderno'];
        echo $rawmaterial->purchaseorderapprovalstatus($purchaseorderno);
    }

    if(isset($_POST['approvepurchaseorder'])){
        $purchaseorderno=$_POST['purchaseorderno'];
        $approvallevelid=$_POST['approvallevel'];
        $narration=$_POST['narration'];
        $approvalstatus=$rawmaterial->approvepurchaseorder($purchaseorderno,$approvallevelid,$narration);
        $approvallevelstatus=$rawmaterial->getpurchaseordercurrentstatus($purchaseorderno);
        if($approvalstatus=="success"){
            // check if purchaseorder fully approved and alert po preparation users
            // echo $approvallevelstatus."<br/>";
            if($approvallevelstatus=="Approved"){
                // get po preparation users
                $rst=$user->getuserswithprivileges(50);
                $emailaddresses='';
                while($row=$rst->fetch()){
                    $emailaddresses= $row['email'];
                    $subject="Purchase Order Dispatch request for purchaseorder number {$purchaseorderno}";
                    $emailmessage="Hello ".$row['firstname']." ".$row['middlename'].", <br/>Please dispatch purchase order number <strong>{$purchaseorderno}</strong>  to the supplier as it has been fully approved in the system.<br/><br/>Thank you.<br/>Kind regards,<br/>{$_SESSION['username']}";
                    // $notification->savenotification($subject,$emailmessage,'Purchase Order Dispatch',$row['id']);
                    //send an email to approvers
                    $mail->sendEmail($emailaddresses,$subject,$emailmessage,$_SESSION['username']);
                }
            }else{
                // get the next approval level and notify the next approval officers
                $nextapprovallevel=$rawmaterial->getpurchaseordernextapprovallevel($purchaseorderno);
                //$rawmaterial->emailpurchaseorderapprovalusers($purchaseorderno,$nextapprovallevel);
                $rst=$rawmaterial->getpurchaseorderapprovalusers($purchaseorderno,$nextapprovallevel);
                $emailaddresses='';
                while($row=$rst->fetch()){
                    $emailaddresses=$row['email'];
                    $approvallevelname=$rawmaterial->getpurchaseorderapprovallevelname($nextapprovallevel);
                    $subject="{$approvallevelname} approval request for purchaseorder number {$purchaseorderno}";
                    $emailmessage="Hello ".$row['firstname']." ".$row['middlename'].",<br/>Please find purchaseorder number <strong>{$purchaseorderno}</strong> posted in the system.<br/>You may also review and approve as <strong> {$approvallevelname}</strong> for it to proceed to the next process. <br/>Thank you.<br/>Kind regards,<br/>{$_SESSION['username']}";
                    // $notification->savenotification($subject,$emailmessage,'Purchase Order Approval',$row['id']);
                    //send an email to approvers
                    $mail->sendEmail($emailaddresses,$subject,$emailmessage,$_SESSION['username']);
                }
            }
            echo "success";
        }else{
            echo $approvalstatus;
        }
    }
    if(isset($_POST['savegrn'])){

        $refno=mt_rand(10000,99999);
        $source=$_POST['source'];
        $sourceid=$_POST['sourceid'];
        $deliverynoteno=$_POST['deliverynoteno'];
        $inspectedby=$_POST['inspectedby'];
        $deliveredby=$_POST['deliveredby'];
        $materialusecaseid=$source=="Customer"?$_POST['materialusecase']:0;
        $projectid=$source=="Customer"?$_POST['projectid']:0;
        $materialsreceived=json_decode(stripcslashes($_POST['materialsreceived']),TRUE);
        $warehouseid=$_POST['warehouseid'];
        // save temp materials received
        // print_r($materialsreceived);
        foreach($materialsreceived as $materialreceived){
            $itemid=$materialreceived['itemid'];
            $quantity=$materialreceived['quantity'];
            $unitprice=$materialreceived['unitprice'];
            $serialno=$materialreceived['serialno'];
            $poid=$materialreceived['poid'];
            $tagno=$materialreceived['tagno'];
            $rawmaterial->savetempmaterialsreceiptdetails($refno,$itemid,$quantity,$unitprice,$serialno,$poid,$tagno);
        }

        echo $rawmaterial-> savematerialreceipt($refno,$source,$sourceid,$deliverynoteno,$inspectedby,$deliveredby,$materialusecaseid,$projectid,$warehouseid);
    }

    if(isset($_GET['getpoundelievereditems'])){
        $pono=$_GET['pono'];
        echo $rawmaterial->getpoundelivereditems($pono);
    }

    if(isset($_GET['filtergoodsreceived'])){
        // $source=$_GET['source'];
        $supplierid=$_GET['supplierid'];
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $grnno=$_GET['grnno'];
        $deliverynoteno=$_GET['deliverynoteno'];
        echo $rawmaterial->filtergoodsreceivednotes($supplierid,$startdate,$enddate,$grnno,$deliverynoteno);
    }

    if(isset($_GET['getdepartmentunissuedrequisitions'])){
        $departmentid=$_GET['departmentid'];
        echo $rawmaterial->getdepartmentunissuedrequisitions($departmentid);
    }

    if(isset($_GET['getuinissuedrequisitionitems'])){
        $requisitionid=$_GET['requisitionid'];
        echo $rawmaterial->getunissuedrequisitionitems($requisitionid);
    }

    if(isset($_GET['getmaterialserialnoforissuing'])){
        $materialid=$_GET['materialid'];
        $serialno=$_GET['serialno'];
        echo json_encode($rawmaterial-> checkmaterialserialnoforissuing($materialid,$serialno));
    }

    if(isset($_POST['savemarterialissue'])){
        $refno=mt_rand(1000,9999);
        $receivedby=$_POST['receivedby'];
        $materialrequestid=$_POST['materialrequestid'];
        $narration=$_POST['narration'];
        $issueditems=json_decode(stripcslashes($_POST['issueditems']),true);
        $warehouseid=$_POST['warehouseid'];
        $issuetotype=$_POST['issuedtotype'];
        $issuetoname=$_POST['issuedtoname'];
        // save temp material issue details
        foreach ($issueditems as $issueditem){
            $itemid=$issueditem['itemid'];
            $serialno=$issueditem['serialno'];
            $quantity=$issueditem['quantity'];
            $rawmaterial->savetempmaterialsissueddetail($refno,$itemid,$serialno,$quantity);
        }
        echo $rawmaterial->savematerialsissued($refno,$receivedby,$materialrequestid,$narration,$warehouseid,$issuetotype,$issuetoname);
    }

    if(isset($_GET['filterstoreissuenote'])){
        
        $departmentid=$_GET['departmentid'];
        $materialusecaseid=$_GET['materialusecaseid'];
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $sinno=$_GET['sinno'];
        $requisitionno=$_GET['requisitionno'];
        $startdate=$material->mySQLDate($startdate);
        $enddate=$material->mySQLDate($enddate);
        echo $rawmaterial->filterstoreissuenote($departmentid,$materialusecaseid,$startdate,$enddate,$sinno,$requisitionno);
    }

    if(isset($_POST['checkrequisitionapprovallevel'])){
        $requisitionno=$_POST['requisitionno'];
        $approvallevel=isset($_POST['approvallevel'])?$_POST['approvallevel']:0;
        $rawmaterial->checkRequisitionApprovalPrivilege($approvallevel,$requisitionno);
    }

    if(isset($_POST['checkpurchaseorderapprovallevel'])){
        $pono=$_POST['purchaseorderno'];
        $approvallevel=isset($_POST['approvallevel'])?$_POST['approvallevel']:0;
        $rawmaterial->checkPurchaseOrderApprovalPrivilege($approvallevel,$pono);
    }
    if(isset($_GET['getmaterialrequisitiondetails'])){
        $requisitionno=$_GET['requisitionno'];
        echo $rawmaterial->getmaterialrequestdetails($requisitionno);
    }
    if(isset($_GET['getmaterialrequisitionitems'])){
        $requisitionid=$_GET['requisitionid'];
        echo $rawmaterial->getmaterialrequisitionitems($requisitionid);
    }
    if(isset($_GET['getpodetails'])){
        $pono=$_GET['pono'];
        echo $rawmaterial->getpurchaseorderdetails($pono);
    }
    if(isset($_GET['getpoitems'])){
        $pono=$_GET['pono'];
        echo $rawmaterial->getpurchaseorderitems($pono);
    }
?>