<?php
    require_once("db.php");
    class company extends db{
        public function getCompanies(){
            $sql="CALL spgetcompanies()";
            echo $this->getJSON($sql);
        }

        function getlocaldatabases(){  
            $sql="CALL spgetcompanies()";
            $rst= $this->getcompanydetails($sql);
            return $rst;
        }
    }
?>