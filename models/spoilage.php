<?php
    require_once("db.php");

    class spoilage extends db{

        public function getspoilagecategories(){
            $sql="CALL `sp_getspoilagecategory`({$this->clientid})";
            return $this->getJSON($sql);
        }

        public function savespoilage($id,$categoryid,$productid,$quantity,$narration,$storecategory,$storeid){
            $sql="CALL `sp_savespoilage`({$this->clientid},{$id},{$categoryid},{$productid},{$quantity},'{$narration}','{$storecategory}',{$storeid},{$_SESSION['userid']})";
            $this->getData($sql);
            return "success";
        }

        public function filterspoilage($startdate,$enddate,$categoryid,$productid){
            $startdate=$this->mySQLDate($startdate);
            $enddate=$this->mySQLDate($enddate);
            $sql="CALL `sp_filterspoilage`({$this->clientid},'{$startdate}','{$enddate}',{$categoryid},{$productid})";
            // echo $sql."<br/>";
            return $this->getJSON($sql);
        }
    }

?>