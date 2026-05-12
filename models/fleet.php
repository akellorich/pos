<?php
    require_once ('db.php');

    class fleet extends db{

        public function checkvehicleregno($id,$regno){
            $sql="CALL `sp_checkfleetvehicleregno`($id,'{$regno}')";
            return $this->getData($sql)->rowCount();
        }

        public function getvehiclebodytypes(){
            $sql="CALL sp_getfleetbodytypes()";
            return $this->getJSON($sql);
        }

        public function getvehiclefueltypes(){
            $sql="CALL sp_getfleetfueltypes()";
            return $this->getJSON($sql);
        }

        public function getvehicles(){
            $sql="CALL sp_getfleetvehicles()";
            return $this->getJSON($sql);
        }

        public function savevehicle($vehicleid,$regno,$bodytypeid, $fueltypeid, $enginerating){
            if(!$this->checkvehicleregno($vehicleid,$regno)){
                $sql="CALL `sp_savefleetvehicle`({$vehicleid},'{$regno}',{$bodytypeid},{$fueltypeid},{$enginerating},{$_SESSION['userid']})";
                return $this->getData($sql)->fetch()['vehicleid'];
            }else{
                return "exists";
            } 
        }

        public function savefuelrequisition($id,$supplierid,$costcenterid,$vehicleid,$requestedby,$approvedby,$quantity,$unitprice,$odoreading){
            $sql="CALL `sp_savefleetfuelrequisition`({$id},{$supplierid},{$costcenterid},{$vehicleid},{$requestedby},{$approvedby},{$quantity},{$unitprice},'{$odoreading}',{$_SESSION['userid']})";
            return $this->getData($sql)->fetch()['requisitionno'];
        }

        public function filterfleetrequisitions($supplierid,$costcenterid,$vehicleid,$startdate,$enddate){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `sp_filterfleetrequisitions`({$supplierid},{$costcenterid},{$vehicleid},'{$startdate}','{$enddate}')";
            return $this->getJSON($sql);
        }

        public function getrequisitiondetails($id){
            $sql="CALL `sp_getfleetrequisitiondetails`({$id})";
            return $this->getJSON($sql);
        }
        public function approverequisition($id){
            $sql="CALL `sp_fleetapprovefuelrequisition`({$id},{$_SESSION['userid']})";
            $this->getData($sql);
            return "success";
        }
    }

?>