<?php
    require_once("db.php");
    
    class warehouse extends db{

       public function getWarehouses(){
           $sql="CALL spgetwarehouses({$this->clientid})";
           $rst=$this->connect()->query($sql);
           $data=$rst->fetchAll(PDO::FETCH_ASSOC);
           echo json_encode($data);     
       } 
    }
?>