<?php
    require_once("db.php");

    class session extends db{
        function checksession(){
            $sql="CALL `sp_checksessionid`()";
            return $this->getData($sql)->rowCount();
        }

        function getactivesession(){
            $sql="CALL `sp_checksessionid`()";
            return $this->getJSON($sql);
        }

        function activatesession($float){
            $sql="CALL `sp_activatesession`({$float},{$this->userid})";
            $this->getData($sql);
            return ["status"=>"success","message"=>"session activated successfully"];
        }

        function closesession(){
            $sql="CALL `sp_closesession`({$this->userid})";
            $this->getData($sql);
            return ["status"=>"success","message"=>"session closed successfully"];
        }

        function getsessions(){
            $sql="CALL `sp_getsessions`()";
            return $this->getJSON($sql);
        }

        function getsessioncollection($sessionid){
            $sql="CALL `sp_getsessioncollectionsummary`({$sessionid})";
            return $this->getJSON($sql);
        }
    }

?>