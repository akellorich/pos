<?php
    require_once("db.php");
    class company extends db{
        public function getCompanies(){
            $sql="CALL spgetcompanies({$this->branchid})";
            echo $this->getJSON($sql);
        }

        function getlocaldatabases(){  
            $sql="CALL spgetcompanies({$this->branchid})";
            $rst= $this->getcompanydetails($sql);
            return $rst;
        }
    }
?>