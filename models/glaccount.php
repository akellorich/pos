<?php
    require_once("db.php");

    class glaccount extends db{

        public function checkglgroup($id,$groupname){
            $sql="CALL spcheckglaccountgroup({$this->clientid},{$id},'{$groupname}')";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()>0){
                return true;
            }else{
                return false;
            }
        }

        public function saveglgroup($id,$glaccountclass,$groupname,$subcategoryof,$cashbookaccount){
            if($this->checkglgroup($id,$groupname)){
                echo "exists";
            }else{
                 $userid=$_SESSION['userid'];
                $sql="CALL spsaveglgroupname({$this->clientid},{$id},{$glaccountclass},'{$groupname}',{$subcategoryof},{$cashbookaccount},{$userid})";
                //echo $sql.'<br/>';
                $rst=$this->connect()->query($sql);
                echo 'success';
            }
           
        }

        public function getglgroups($category){
            $sql="CALL spgetglgroups({$this->clientid},{$category})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function deleteglgroup($id){
            $sql="CALL spdeleteglgroup({$this->clientid},{$id},{$_SESSION['userid']})";
            $rst=$this->connect()->query($sql);
            echo 'success';
        }

        public function checkglaccountcode($id,$accountcode){
            $sql="CALL spcheckglaccount({$this->clientid},{$id},'{$accountcode}')";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()>0){
                return true;
            }else{
                return false;
            }
        }

        public function checkglaccountname($id,$accountname){
            $sql="CALL spcheckglaccount({$this->clientid},{$id},'{$accountname}')";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()>0){
                return true;
            }else{
                return false;
            }
        }

        public function saveglaccount($id,$groupid,$accountcode,$accountname){
            if( $this->checkglaccountcode($id,$accountcode)){
                echo "account code exists";
            }else if($this->checkglaccountname($id,$accountname)){
                echo "account name exists";
            }else{
                $sql="CALL spsaveglaccount({$this->clientid},{$id},{$groupid},'{$accountcode}','{$accountname}',{$_SESSION['userid']})";
                //echo $sql."<br/>";
                $rst=$this->connect()->query($sql);
                echo 'success';
            }
        }

        public function deleteglaccount($id){
            $sql="CALL spdeleteglaccount({$this->clientid},{$id},{$_SESSION['userid']})";
            $rst=$this->connect()->query($sql);
            echo 'success';
        }

        public function getglaccounts($groupid){
            $sql="CALL spgetglaccounts({$this->clientid},{$groupid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getglaccountclasses(){
            $sql="CALL spgetglaccountclasses({$this->clientid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getglparentgroups($classid){
            $sql="CALL spgetparentgroups({$this->clientid},{$classid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getsubgroups($groupid){
            $sql="CALL spgetglsubgroups({$this->clientid},{$groupid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getCashBookAccounts(){
            $sql="CALL spgetcashbookaccounts({$this->clientid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        public function getGLAccountDetails($id){
            $sql="CALL spgetglaccountdetails({$this->clientid},{$id})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }
    }

?>