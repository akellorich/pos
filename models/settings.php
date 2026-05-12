<?php
    require_once('db.php');
    class settings extends db{

        function getUnitsOfMeasure(){
            $sql="CALL spgteunitsofmeasure({$this->clientid},)";
            //$rst=$this->connect()->query($sql);
            //return json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        function getPaymentMethods(){
            $sql="CALL spgetpaymentmethods({$this->clientid},)";
            $rst=$this->getData($sql);
            // echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            $_page = array();
            foreach ($rst as $i => $status) {
                $requireseref=($status['requiresrefno']?1:0);
                $_page[] = array(
                    'id' => $status['id'],
                    'description' => $status['description'],
                    'image' => 'data:image/jpeg;base64,'.base64_encode($status['image']),
                    'requiresrefno' =>$requireseref, // $status['requiresrefno']
                    'supplierslist'=>$status['supplierslist'],
                    'default'=> $status['default'],
                );
            }
            //header ("Content-type: application/json");
            return json_encode($_page);
        }

        function getInstitutionDetails(){
            $sql="CALL spgetinstitutiondetails({$this->clientid},)";
            // $rst=$this->connect()->query($sql);
            // echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        function getPrivileges($module){
            $sql="CALL spgetobjects({$this->clientid},'{$module}')";
            // $rst=$this->connect()->query($sql);
            // echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        function getTodaysDate(){
            $sql="CALL spgettodaysdate({$this->clientid},)";
            // $rst=$this->connect()->query($sql);
            // echo json_encode($rst->fetch(PDO::FETCH_ASSOC)); 
            return $this->getJSON($sql);
        }

        function getSalesSettings(){
            $sql="CALL spgetsalessettings({$this->clientid},)";
            // $rst=$this->connect()->query($sql);
            // echo json_encode($rst->fetch(PDO::FETCH_ASSOC));
            return $this->getJSON($sql);
        }

        function getSystemModules(){
            $sql="CALL spgetsystemmodules({$this->clientid},)";
            return $this->getJSON($sql);
        }

        function savecrateinventorysettings($productid,$customerid,$glaccountid,$costcenter,$paymentcenter,$paymentaccount){
            $sql="CALL spsavecrateinventorysettings({$this->clientid},{$productid},{$customerid},{$glaccountid},{$costcenter},{$paymentcenter},{$paymentaccount})";
            $this->getData($sql);
            return "success";
        }

        function getcrateinventorysettings(){
            $sql="CALL spgetcrateinventorysettings({$this->clientid},)";
            return $this->getJSON($sql);
        }

        function getcrateadditionparameters(){
            $sql="CALL spgetcrateadditionparameters({$this->clientid},)";
            return $this->getJSON($sql);
        }

        function savecrateaddition($productid,$quantity,$unitprice,$narration,$reference){
            if(!$this->checkcrateadditionreference($reference)){
                $sql="CALL spsavecrateaddition({$this->clientid},{$productid},{$quantity},{$unitprice},'{$narration}','{$reference}',{$_SESSION['userid']})";
                $this->getData($sql);
                return "success";
            }else{
                return "exists";
            }
        }

        function checkcrateadditionreference($reference){
            $sql="CALL spcheckcrateadditionreference({$this->clientid},'{$reference}')";
            return $this->getData($sql)->rowCount()?true:false;
        }

        function gettaxtypes(){
            $sql="CALL `spgettaxtypes`()";
            return $this->getJSON($sql);
        }

        function getcurrencies(){
            $sql="CALL `sp_getcurrencies`()";
            return $this->getJSON($sql);
        }

        function getdepartments(){
            $sql="CALL sp_getdepartments({$this->clientid},)";
            return $this->getJSON($sql);
        }

        function gettaxdetails($taxid){
            $sql="CALL `sp_gettaxdetails`({$taxid})";
            return $this->getJSON($sql);
        }

        function getpapergrammage(){
            $sql="CALL `sp_getpapergrammage`()";
            return $this->getJSON($sql);
        }

        function getdefaultterms(){
            $sql="CALL `sp_getdefaultterms`()";
            return $this->getJSON($sql);
        }

        function saveinstitutiondetails($companyname,$physicaladdress,$postaladdress,$landline,$email,$mobile,$pinno,
        $autoinvoicegrn,$postalcode,$tagline,$website,$receiptfooter,$defaultcustomer,$mainbusinesstype,$logo,$town){
            $sql="CALL `sp_saveinstitutiondetails`('{$companyname}','{$physicaladdress}','{$postaladdress}','{$landline}','{$email}','{$mobile}','{$pinno}',
           {$autoinvoicegrn},'{$postalcode}','{$tagline}','{$website}','{$receiptfooter}',{$defaultcustomer},'{$mainbusinesstype}','{$logo}','{$town}')";
           $this->getData($sql);
           return ["status"=>"success","message"=>"institution details save dsuccessfully"];
        }

        function getwarehouses(){
            $sql="CALL spgetwarehouses({$this->clientid},)";
            return $this->getJSON($sql);
        }
    }
?>