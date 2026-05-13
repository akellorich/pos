<?php
    require_once("db.php");

    class department extends db{
        public function checkdepartment($id,$departmentname){
            $sql="CALL `sp_checkdepartment`({$this->branchid},{$id},'{$departmentname}')";
            return $this->getData($sql)->rowCount()?true:false;
        }

        public function savedepartment($id,$departmentname,$hodid){
            if($this->checkdepartment($id,$departmentname)){
                return "exists";
            }else{
                $sql="CALL `sp_savedepartment`({$this->branchid},{$id},'{$departmentname}',{$_SESSION['userid']},{$hodid})";
                $this->getData($sql);
                return "success";
            }
        }

        public function getdepartments(){
            $sql="CALL `sp_getdepartments`({$this->branchid})";
            return $this->getJSON($sql);
        }

        public function getdepartmentdetails($id){
            $sql="CALL `sp_getdepartmentdetails`({$this->branchid},{$id})";
            return $this->getJSON($sql);
        }

        public function deletedepartment($id){
            $sql="CALL `sp_deletedepartment`({$this->branchid},{$id})";
            $this->getData($sql);
            return "success";

        }
    }

?>