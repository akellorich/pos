<?php
    require_once("db.php");
    class company extends db{
        public function getCompanies(){
            $sql="CALL spgetcompanies({$this->clientid})";
            echo $this->getJSON($sql);
        }

        function getlocaldatabases(){  
            $sql="CALL spgetcompanies({$this->clientid})";
            $rst= $this->getcompanydetails($sql);
            return $rst;
        }
    }
?>