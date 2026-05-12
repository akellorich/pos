<?php
    require_once("db.php");

    class department extends db{
        public function checkdepartment($id,$departmentname){
            $sql="CALL `sp_checkdepartment`({$this->clientid},{$id},'{$departmentname}')";
            return $this->getData($sql)->rowCount()?true:false;
        }

        public function savedepartment($id,$departmentname,$hodid){
            if($this->checkdepartment($id,$departmentname)){
                return "exists";
            }else{
                $sql="CALL `sp_savedepartment`({$this->clientid},{$id},'{$departmentname}',{$_SESSION['userid']},{$hodid})";
                $this->getData($sql);
                return "success";
            }
        }

        public function getdepartments(){
            $sql="CALL `sp_getdepartments`({$this->clientid})";
            return $this->getJSON($sql);
        }

        public function getdepartmentdetails($id){
            $sql="CALL `sp_getdepartmentdetails`({$this->clientid},{$id})";
            return $this->getJSON($sql);
        }

        public function deletedepartment($id){
            $sql="CALL `sp_deletedepartment`({$this->clientid},{$id})";
            $this->getData($sql);
            return "success";

        }
    }

?>