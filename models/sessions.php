<?php
    require_once("db.php");

    class session extends db{
        function checksession(){
            $sql="CALL `sp_checksessionid`({$this->clientid})";
            return $this->getData($sql)->rowCount();
        }

        function getactivesession(){
            $sql="CALL `sp_checksessionid`({$this->clientid})";
            return $this->getJSON($sql);
        }

        function activatesession($float){
            $sql="CALL `sp_activatesession`({$this->clientid},{$float},{$this->userid})";
            $this->getData($sql);
            return ["status"=>"success","message"=>"session activated successfully"];
        }

        function closesession(){
            $sql="CALL `sp_closesession`({$this->clientid},{$this->userid})";
            $this->getData($sql);
            return ["status"=>"success","message"=>"session closed successfully"];
        }

        function getsessions(){
            $sql="CALL `sp_getsessions`({$this->clientid})";
            return $this->getJSON($sql);
        }

        function getsessioncollection($sessionid){
            $sql="CALL `sp_getsessioncollectionsummary`({$this->clientid},{$sessionid})";
            return $this->getJSON($sql);
        }
    }

?>