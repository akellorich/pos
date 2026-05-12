<?php
    require_once("db.php");
    require_once("mail.php");
    $mail=new mail();

    class rawmaterial extends db{
        function getcategories(){
            $sql="CALL `sp_getrawmaterialcategories`()";
            return $this->getJSON($sql);
        }

        function checkrawmaterial($materialid,$materialname){
            $sql="CALL `sp_checkrawmaterial`({$materialid},'{$materialname}')";
            return $this->getData($sql)->rowCount();
        }

        function saverawmaterial($materialid,$categoryid,$materialname,$uom,$physicalproduct, $unitprice,$itemcode,$generateitemcode){
            if($this->checkrawmaterial($materialid,$materialname)){
                return "exists";
            }else{
                $sql="CALL `sp_saverawmaterial`({$materialid},{$categoryid},'{$materialname}','{$uom}',{$physicalproduct},{$unitprice},'{$itemcode}',
                {$generateitemcode},{$this->userid})";
                $this->getData($sql);
                return "success";
            }
        }

        function getrawmaterials(){
            $sql="CALL `sp_getrawmaterials`()";
            return $this->getJSON($sql);
        }

        function getrawmaterialdetails($materialid){
            $sql="CALL `sp_getrawmaterialdetails`({$materialid})";
            return $this->getJSON($sql);
        }

        function deleterawmaterial($materialid){
            $sql="CALL `sp_deleterawmaterial`({$materialid},{$this->userid})";
            $this->getData($sql);
            return "success";
        }

        function savetempmaterialsreceiptdetails($refno,$itemid,$quantity,$unitprice,$serialno,$poid,$tagno){
            $sql="CALL `sp_savetempmaterialreceiptdetails`('{$refno}',{$itemid},{$quantity},{$unitprice},'{$serialno}',{$poid},'{$tagno}')";
            //echo $sql."<br/>";
            $this->getData($sql);
            return "success";
        }

        function savematerialreceipt($refno,$source,$sourceid,$deliverynoteno,$inspectedby,$receivedby,$materialusecaseid,$projectid,$warehouseid){
            // check if delivery note number is in use
            if($this->checkdeliverynoteno($source,$sourceid,$deliverynoteno)){
                return "exists";
            }else{
                $sql="CALL `sp_savematerialsreceived`('{$refno}','{$source}','{$deliverynoteno}',{$this->userid},{$inspectedby},{$materialusecaseid},{$projectid},'{$receivedby}',{$sourceid},{$warehouseid})";
                return $this->getData($sql)->fetch()['grnno'];
            }
           
        }

        function savetempmaterialsissueddetail($refno,$itemid,$serialno,$quantity){
            $sql="CALL `sp_savetempmaterialissueddetail`('{$refno}',{$itemid},'{$serialno}',{$quantity})";
            $this->getData($sql);
            return "success";
        }
        
        function savematerialsissued($refno,$receivedby,$materialrequestid,$narration,$warehouseid,$issuetotype,$issuetoname){
            $sql="CALL `sp_savematerialissue`('{$refno}',{$this->userid},{$receivedby},{$materialrequestid},'{$narration}',{$warehouseid},'{$issuetotype}','{$issuetoname}')";
            return $this->getData($sql)->fetch()['sinno'];
        }
        
        function checkmaterialrequisitionreference($id,$reference){
            $sql="CALL `sp_checkmaterialrequestreference`({$id},'{$reference}')";
            return $this->getData($sql)->rowCount()?true:false;
        }

        function savetempmaterialrequisitiondetails($refno,$itemid,$quantity,$unitprice,$narration){
            $sql="CALL `sp_savetempmaterialrequestdetails`('{$refno}',{$itemid},{$quantity},{$unitprice},'{$narration}')" ;
            $this->getData($sql);
            return "success";
        }

        function savematerialrequisition($id,$refno,$materialusecase,$reference,$narration,$scope,$supplierid,$activityid,$departmentid,$purchaserequisition,$siteid){
            if($this->checkmaterialrequisitionreference($id,$reference)){
                return "exists";
            }else{
                $sql="CALL `sp_savematerialrequisition`({$id},'{$refno}',{$materialusecase},'{$reference}','{$narration}','{$scope}',{$supplierid},{$activityid},{$departmentid},{$this->userid},{$purchaserequisition},{$siteid})";
                //echo $sql."<br/>";
                $requisitionno= $this->getData($sql)->fetch()['requisitionno'];
                return $requisitionno;
            }
        }

        function getrequisitionapprovallevels(){
            $sql="CALL sp_getmaterialrequestapprovallevels()";
            return $this->getJSON($sql);
        }

        function getrequisitionapprovalusers($requisitionno,$level){
            $sql="CALL `sp_getrequisitionapprovalusers`('{$requisitionno}',{$level})";
            return $this->getData($sql);
        }

        function getrequisitionapprovallevelname($hierarchy){
            $sql="CALL `sp_getrequisitionapprovallevelname`({$hierarchy})";
            return $this->getData($sql)->fetch()['description'];
        }

        function filterrequisitions($startdate,$enddate,$departmentid,$supplierid,$usecaseid,$requisitionstatus,$requisitionno){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `sp_filterrequisitions`('{$startdate}','{$enddate}',{$departmentid},{$supplierid},{$usecaseid},'{$requisitionstatus}','{$requisitionno}')";
            //echo $sql."<br>";
            return $this->getJSON($sql);
        }

        function requisitionapprovalstatus($requisitionno){
            $sql="CALL sp_getrequisitionapprovallevelstatus('{$requisitionno}')";
            return $this->getJSON($sql);
        }

        function approverequisition($requisitionno,$approvallevelid,$narration){
            $sql="CALL `sp_approverequisition`('{$requisitionno}',{$approvallevelid},{$this->userid},'{$narration}')";
            //echo $sql;
            $this->getData($sql);
            return "success";
        }

        function getrequisitionnextapprovallevel($requisitionno){
            $sql="CALL sp_getrequisitionnextapprovallevel('{$requisitionno}')";
            return $this->getData($sql)->fetch()['hierarchy'];
        }

        function getrequisitioncurrentstatus($requisitionno){
            $sql="CALL `sp_getrequisitioncurrentstatus`('{$requisitionno}')";
            return $this->getData($sql)->fetch()['status'];
        }

        function getdepartmentpendingporequisitions($departmentid){
            $sql="CALL sp_getdepartmentpopendingrequisitions({$departmentid})";
            return $this->getJSON($sql);
        }

        function getdepartmentpendingpopurchaserequisitions($departmentid){
            $sql="CALL `sp_getdepartmentpopendingpurchaserequisitions`({$departmentid})";
            return $this->getJSON($sql);
        }

        function getrequisitionitems($requisitionno){
            $sql="CALL `sp_getrequisitionitems`('{$requisitionno}')";
            return $this->getJSON($sql);
        }

        function getpurchaseorderapprovallevels(){
            $sql="CALL sp_getpurchaseorderapprovallevels()";
            return $this->getJSON($sql);
        }

        function getpurchaseorderapprovalusers($purchaseorderno,$level){
            $sql="CALL `sp_getpurchaseorderapprovalusers`('{$purchaseorderno}',{$level})";
            return $this->getData($sql);
        }

        function getpurchaseorderapprovallevelname($hierarchy){
            $sql="CALL `sp_getpurchaseorderapprovallevelname`({$hierarchy})";
            return $this->getData($sql)->fetch()['description'];
        }

        function purchaseorderapprovalstatus($purchaseorderno){
            $sql="CALL sp_getpurchaseorderapprovallevelstatus('{$purchaseorderno}')";
            return $this->getJSON($sql);
        }

        function approvepurchaseorder($purchaseorderno,$approvallevelid,$narration){
            $sql="CALL `sp_approvepurchaseorder`('{$purchaseorderno}',{$approvallevelid},{$this->userid},'{$narration}')";
            //echo $sql;
            $this->getData($sql);
            return "success";
        }

        function getpurchaseordernextapprovallevel($purchaseorderno){
            $sql="CALL sp_getpurchaseordernextapprovallevel('{$purchaseorderno}')";
            return $this->getData($sql)->fetch()['hierarchy'];
        }

        function getpurchaseordercurrentstatus($purchaseorderno){
            $sql="CALL `sp_getpurchaseordercurrentstatus`('{$purchaseorderno}')";
            return $this->getData($sql)->fetch()['status'];
        }

        function filtergoodsreceivednotes($supplierid,$startdate,$enddate,$grnno,$deliverynoteno){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `sp_filtergoodsreceivednotes`({$supplierid},'{$startdate}','{$enddate}','{$grnno}','{$deliverynoteno}')";
            return $this->getJSON($sql);
        }

        function getdepartmentunissuedrequisitions($departmentid){
            $sql="CALL `sp_getunissuedepartmentrequisitions`({$departmentid})";
            return $this->getJSON($sql);
        }

        function getunissuedrequisitionitems($requisitionid){
            $sql="CALL `sp_getunissuedrequisitionitems`({$requisitionid})";
            return $this->getJSON($sql);
        }

        function checkmaterialserialnoforissuing($materialid,$serialno){
            $sql="CALL `sp_checkmaterialserialnoforissuing`({$materialid},'{$serialno}')";
            //echo $sql."<br/>";
            $rst=$this->getData($sql);
            if($rst->rowCount()){
                $row=$rst->fetch();
                if ($row['issued']==0){
                    return "available";
                }else{
                    return "issued";
                }
            }else{
                return "absent";
            }
        }

        function filterstoreissuenote($departmentid,$materialusecaseid,$startdate,$enddate,$sinno,$requisitionno){
            $sql="CALL `sp_filtersin`({$departmentid},{$materialusecaseid},'{$startdate}','{$enddate}','{$sinno}','{$requisitionno}')";
            return $this->getJSON($sql);
        }

        function checkRequisitionApprovalPrivilege($approvallevel,$requisitionno){
            $userid=$this->userid;
            $departmentid=$this->getrequisitiondepartment($requisitionno);
            $sql="CALL sp_validaterequisitionapproval({$userid},{$approvallevel},{$departmentid})";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()){
                echo $rst->fetch()['allowed']==1?1:0;
            }else{
                echo 0;
            }
        }

        function checkPurchaseOrderApprovalPrivilege($approvallevel,$pono){
            $userid=$this->userid;
            $departmentid=$this->getpurchaseorderdepartment($pono);
            $sql="CALL sp_validatepurchaseorderapproval({$userid},{$approvallevel},{$departmentid})";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()){
                echo $rst->fetch()['allowed']==1?1:0;
            }else{
                echo 0;
            }
        }

        function getmaterialrequestdetails($requisitionno){
            $sql="CALL sp_getmaterialrequisitiondetails('{$requisitionno}')";
            return $this->getJSON($sql);
        }

        function getmaterialrequisitionitems($requisitionid){
            $sql="CALL `sp_getmaterialrequisitionitems`({$requisitionid})";
            return $this->getJSON($sql);
        }

        function getpurchaseorderdetails($pono){
            $sql="CALL `sp_getpurchaseorderdetails`('{$pono}')";
            return $this->getJSON($sql);
        }

        function getpurchaseorderitems($pono){
            $sql="CALL `sp_getpoitems`('{$pono}')";
            return $this->getJSON($sql);
        }

        public function getpurchaseorderdepartment($pono){
            $poid=$this->getpoidfrompono($pono);
            $sql="CALL `spgetpurchaseorderdetails`('{$poid}')";
            return $this->getData($sql)->fetch()['departmentid'];
        }

        public function getpoidfrompono($pono){
            $sql="CALL `sp_getpoidfrompono`('{$pono}') ";
            return $this->getData($sql)->fetch()['poid'];
        }

    }
?>