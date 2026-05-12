<?php
    require_once("db.php");

    class zone extends db{

        function checkzone($id,$zonename){
            $sql="CALL `sp_checkzone`({$this->clientid},{$id},'{$zonename}')";
            return $this->getData($sql)->rowCount();
        }

        function savezone($id,$zonename,$parent){
            if($this->checkzone($id,$zonename)){
                return "exists";
            }else{
                $sql="CALL `sp_savezone`({$this->clientid},{$id},'{$zonename}',{$parent},{$_SESSION['userid']})";
                $this->getData($sql);
                return "success";
            }
        }

        function deletezone($id){
            $sql="CALL `sp_deletezone`({$this->clientid},{$id},{$_SESSION['userid']})";
            $this->getData($sql);
            return "success";
        }

        function getparentzones(){
            $sql="CALL `sp_getparentzones`({$this->clientid})";
            return $this->getJSON($sql);
        }

        function getsubzones($parent){
            $sql="CALL `sp_getsubzones`({$this->clientid},{$parent})";
            return $this->getJSON($sql);
        }

        function getzonedetails($id){
            $sql="CALL `sp_getzonedetails`({$this->clientid},{$id})";
            return $this->getJSON($sql);
        }

        function getzonesandsubzones(){
            $sql="CALL `sp_getzonesandsubzones`({$this->clientid})";
            return $this->getJSON($sql);
        }
    }
?>