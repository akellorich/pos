<?php
    require_once('db.php');
    
    class User extends db{

        public function generateSalt($length = 30) {
            return bin2hex(random_bytes($length / 2));
        }

        function checkUser($userid,$field,$searchvalue){ 
            $sql="CALL spcheckuser({$this->clientid},{$userid},'{$field}','{$searchvalue}')";
            $rst=$this->getData($sql);   
            if($rst->rowCount()){
                return true;
            }else{
                return false;
            }         
        }

        function saveUser($userid,$username,$password,$firstname,$middlename,$lastname,$mobile,$email,$systemadmin,$accountactive,$changepasswordonlogon,$pin,$pinsalt,$profilephoto='',$defaultbranchid=1){
            // check username
            if($this->checkUser($userid,'username',$username)){
                return "Sorry, the username is already in use.";
            }else if ($this->checkUser($userid,'email',$email)){
               //check email 
                return "Sorry, the email address is already in use.";
            }else if ($this->checkUser($userid,'mobile',$mobile)){
                // check mobile
                return "Sorry, the mobile phone number is already in use.";
            }else{
                // Generate salt for password
                $salt = $this->generateSalt();
                $password = hash('sha256', $password . $salt);

                // hash the pin
                $pin=hash('SHA256',$pin.$pinsalt);
                // blank is for salt
                $sql="CALL sp_saveuser({$this->clientid},{$defaultbranchid},{$userid},'{$password}','{$salt}','{$profilephoto}',{$systemadmin},'{$username}','{$firstname}','{$middlename}','{$lastname}','{$email}','{$mobile}',
                {$changepasswordonlogon},{$accountactive},'{$pin}','{$pinsalt}',{$this->userid})";
                //echo $sql."<br/>";
                $rst=$this->getData($sql);   
                //echo $sql."<br/>";
                $row=$rst->fetch(PDO::FETCH_ASSOC);
                return $row['userid'];
            }
        }
    
        function getUserNameFromId($id){
            $sql="CALL spgetuserbyid ({$id})";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()){
                $row=$rst->fetch();
                return $row['username'];
            }else{
                return '';
            }
        }

        function validateLoginDetails($username,$password){
           $sql="CALL spgetuserdetails ('{$username}')";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()>0){
                while ($row = $rst->fetch()) {
                    if($row['password'] === hash('sha256', $password . $row['salt'])){
                        return "ok";
                    }else{
                        return "invalid password";
                    }
                }
            }else{
                return "invalid username";
            }
		}
        

        function checkUserAccount($id,$username){
           $sql="CALL spcheckuser ({$id},'{$username}')";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()){
                return true;
            }else{
                return false;
            }
        }

        function disableUserAccount($id,$reason){
            $sql="CALL spdisableuseraccount ({$id},'{$reason}',{$this->userid})";
            $rst=$this->connect()->query($sql);
            return "success";
        }

        function enableUserAccount($id){
            $sql="CALL spenableuseraccount ({$id},{$this->userid})";
            $rst=$this->connect()->query($sql);
            return "success";
        }

        function changeUserPassword($id,$oldpassword,$newpassword,$changepasswordonlogon){
            $username=$this->getUserNameFromId($id);
            // echo $this->validateLoginDetails($username,$password);
            if($this->validateLoginDetails($username,$oldpassword)=="ok"){
                $salt = $this->generateSalt();
                $newpassword = hash('sha256', $newpassword . $salt);
                $sql="CALL spchangeuserpassword ({$this->clientid},{$id},'{$newpassword}','{$salt}',{$changepasswordonlogon})";
                $rst=$this->connect()->query($sql);
                return "Success";
            }else{
                return "Invalid Old Password, Correct and try again";
            } 
        }

        function logUserIn($username,$password){
            $sql="CALL spgetuserdetails('{$username}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()){
                $row = $rst->fetch();
                // echo md5($password);
                if($row['password'] === hash('sha256', $password . $row['salt'])){
                    if($row['accountactive']==true){
                        if($row['changepasswordonlogon']==true){
                            $this->userid=$row['userid'];
                            $_SESSION['userid']=$row['userid'];
                            $_SESSION['clientid']=$row['clientid'];
                            return ["status"=>"change password"];
                            $_SESSION['username']=$row['firstname'].' '.$row['middlename'];
                            $_SESSION['userfirstname']=$row['firstname'];
                            $_SESSION['userothernames']=$row['middlename'].' '.$row['lastname'];
                            $_SESSION['systemadmin']=$row['systemadmin'];
                            $_SESSION['userimage']='../../images/blankavatar.jpg';   
                        }else{
                            $this->userid=$row['userid'];
                            $_SESSION['userid']=$row['userid'];
                            $_SESSION['clientid']=$row['clientid'];
                            $branchid = isset($row['defaultbranchid']) ? $row['defaultbranchid'] : 1;
                            $_SESSION['branchid']=$branchid;
                            $_SESSION['branchname'] = isset($row['branchname']) ? $row['branchname'] : "Default Branch";

                            $_SESSION['username']=$row['firstname'].' '.$row['middlename'];
                            $_SESSION['userfirstname']=$row['firstname'];
                            $_SESSION['userothernames']=$row['middlename'].' '.$row['lastname'];
                            $_SESSION['systemadmin']=$row['systemadmin'];
                            $_SESSION['userimage']='../../images/blankavatar.jpg';
                            return ["status"=>"success"];
                        }  
                    }else{
                        return ["status"=>"account inactive"];
                    } 
                }else{
                    return ["status"=>"invalid credentials"];
                }
            }else{
                return ["status"=>"invalid credentials"];
            }
        }

        function logUserOut(){
            session_destroy();
        }

        function getUsers(){
            $sql="CALL spgetallusers({$this->clientid})";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function getUserDetails($userid){
            $username=$this->getUserNameFromId($userid);
            $sql="CALL spgetuserdetails('{$username}')";
            $rst=$this->connect()->query($sql);
            echo json_encode($rst->fetchAll(PDO::FETCH_ASSOC));
        }

        function deleteUser($userid){
            $sql="CALL spdeleteuser ({$userid},{$this->userid})";
            $rst=$this->connect()->query($sql);
            echo "The user has been deleted successfully.";
        }

        function getLoggedInUserName(){
            return json_encode(isset($_SESSION['username'])?$_SESSION['username']:""); 
        }

        function getloggedinUserId(){
            $response=isset($_SESSION['userid'])
                ?["status"=>"loggedin","userid"=>$_SESSION['userid'],"firstname"=>$_SESSION['userfirstname'],
                "systemadmin"=>$_SESSION['systemadmin'],"othernames"=>$_SESSION['userothernames']]
                :["status"=>"notloggedin"];
            return json_encode($response); 
        }
        
        function logoffUser(){
            session_unset();
        }

        function saveUserPrivilege($userid,$object,$valid,$branchid=null){
            $branchid = (!empty($branchid)) ? $branchid : $this->branchid;
            $sql="CALL spsaveuserprivilege ({$this->clientid},{$userid},{$branchid},{$object},{$valid},{$this->userid})";
            $rst=$this->connect()->query($sql); 
        }

        function checkUserPrivilege($objectid,$branchid=null){
            $userid=$this->userid;
            $branchid = (!empty($branchid)) ? $branchid : $this->branchid;
            $sql="CALL spvalidateuserprivilege({$branchid},{$userid},{$objectid})";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()){
                $row=$rst->fetch();
                if ($row['allowed']==1){
                    echo 1;
                }else{
                    echo 0;
                }
            }else{
                echo 0;
            }
        }

        function getUsersList(){
            $sql="CALL spgetallusers({$this->clientid})";
            return $this->getJSON($sql);
        }

        function getUserRoles($userid){
            $sql="CALL spgetuserroles({$userid})";
            return $this->getJSON($sql);
        }

        function getObjects($moduleid){
            $sql="CALL spgetobjects({$this->clientid},'{$moduleid}')";
            return $this->getJSON($sql);
        }

        function getRoles(){
            $sql="CALL spgetroles({$this->clientid})";
            echo $this->getJSON($sql);
        }

        function getRoleUsers($roleid){
            $sql="CALL spgetroleusers({$this->clientid},{$roleid})";
            echo $this->getJSON($sql);
        }

        function getRoleDetails($roleid){
            $sql="CALL spgetroledetails({$this->clientid},{$roleid})";
            echo $this->getJSON($sql);
        }

        function getRolesForAssignment(){
            $sql="CALL spgetrolesforuserassignment({$this->clientid})";
            echo $this->addUserToRolegetJSON($sql);

        }

        function getRolePrivileges($roleid){
            $sql="CALL spgetroleprivileges({$this->clientid},{$roleid})";
            echo $this->getJSON($sql);
        }

        function getUserNonRoles($userid){
            $sql="CALL spgetnonuserroles({$this->clientid},{$userid})";
            echo $this->getJSON($sql);
        }

        function removeUserRole($userid,$roleid){
            $sql="CALL spremoveuserrole({$this->clientid},{$userid},{$roleid},{$this->userid})";
            return $this->getData($sql);
        }

        function  getUserPrivileges($userid, $branchid = null){
            $branchid = (!empty($branchid)) ? $branchid : $this->branchid;
            $sql="CALL spgetuserprivileges({$this->clientid},{$userid},{$branchid})";
            return $this->getJSON($sql);
        }

         function getUsernameFromUserId($userid){
            $sql="CALL spgetusernamefromuserid({$userid})";
            //echo $sql."<br/>";
            $rst=$this->getData($sql);
            if($rst->rowCount()){
                $row=$rst->fetch();
                return $row['username'];
            }else{
                return '';
            }
        }

        function saveTempPrivileges($refno,$id,$objectid,$valid){
            // id is either userid or role id
            $sql="CALL spsavetempprivilege({$this->clientid},'{$refno}',{$id},{$objectid},{$valid})";
            $rst=$this->getData($sql);
            if($rst){
                return 'success';
            }
        }

        function checkRole($roleid,$rolename){
            $sql="CALL spcheckrole({$this->clientid},{$roleid},'{$rolename}')";
            $rst=$this->getData($sql);
            if($rst->rowCount()){
                return true;
            }else{
                return false;
            }     
        }

        function savePrivileges($refno,$userid,$category){
            // category is either user or role
            $sql="CALL spsaveprivileges({$this->clientid},{$userid},'{$category}','{$refno}',{$this->userid})";
            //echo $sql."<br/>";
            $rst=$this->getData($sql);
            return "Success";
        }
        
        function saveRole($roleid,$rolename,$roledescription){
            if($this-> checkRole($roleid,$rolename)){
                return "Sorry, the role is already in use within the system.";
            }else{
                 $sql="CALL spsaverole({$this->clientid},{$roleid},'{$rolename}','{$roledescription}',{$this->userid})";
                 //echo $sql;
                 $rst=$this->getData($sql);
                 //if($rst->rowCount()){
                 $row=$rst->fetch(PDO::FETCH_ASSOC);
                 return $row['roleid'];
            }
        } 

        function resetUserPassword($userid,$newpassword){
            $salt = $this->generateSalt();
            $newpassword = hash('sha256', $newpassword . $salt);
            $sql="CALL spchangeuserpassword ({$this->clientid},{$userid},'{$newpassword}','{$salt}',0)";
            $rst=$this->connect()->query($sql);
            return "success";
        }

        function addUserToRole($userid,$roleid){
            $sql="CALL spsaveroleusers({$this->clientid},{$userid},{$roleid},{$this->userid})";
            //echo $sql."<br/>";
            $rst=$this->getData($sql);
            if($rst){
                return "success";
            }
        }

        function saverequisitionprivilege($userid,$approvallevelid,$departmentid,$valid){
            // echo $_SESSION['userid'];
            $sql="CALL sp_saverequisitionprivilege({$userid},{$approvallevelid},{$departmentid},{$valid},{$this->userid})";
            // echo $sql."<br/>";
            $this->getData($sql);
            return "success";
        }

        function getuserrequisitionapprovalprivileges($userid){
            $sql="CALL `sp_getuserrequisitionapprovalprivileges`({$userid})";
            return $this->getJSON($sql);
        }

        function getuserswithprivileges($objectid){
            $sql="CALL sp_getuserswithprivilege($objectid)";
            return $this->getData($sql);
        }

        function savepurchaseorderprivilege($userid,$approvallevelid,$departmentid,$valid){
            $sql="CALL sp_savepurchaseorderprivilege({$userid},{$approvallevelid},{$departmentid},{$valid},{$this->userid})";
            $this->getData($sql);
            return "success";
        }

        function getuserpurchaseorderapprovalprivileges($userid){
            $sql="CALL `sp_getuserpurchaseorderapprovalprivileges`({$userid})";
            return $this->getJSON($sql);
        }

        function saveusersignature($userid,$documentname){
            $sql="CALL `sp_saveusersignature`({$userid},'{$documentname}')";
            $this->getData($sql);
            return "success";
        }

        function saveuserprofilephoto($userid,$documentname){
            $sql="CALL sp_saveuserprofilephoto({$this->clientid},{$userid},'{$documentname}')";
            $this->getData($sql);
            return "success";
        }

        function resetuserpin($userid,$pin,$pinsalt){
            $pin=hash('SHA256',$pin.$pinsalt);
            $sql="CALL `sp_resetuserpin`({$userid},'{$pin}','{$pinsalt}')";
            $this->getData($sql);
            return ["status"=>"success","message"=>"user PIN reset successfully"];
        }

        function loginuserbypin($username,$pin){
            $sql="CALL spgetuserdetails ('{$username}')";
            //echo $sql."<br/>";
            $rst=$this->connect()->query($sql);
            if($rst->rowCount()){
                $row = $rst->fetch();
                if($row['pin'] === hash('SHA256',$pin.$row['pinsalt'])){
                    if($row['accountactive']==true){
                        if($row['changepasswordonlogon']==true){
                            $this->userid=$row['userid'];
                            $_SESSION['userid']=$row['userid'];
                            $_SESSION['clientid']=$row['clientid'];
                            return ["status"=>"change password"];
                            $_SESSION['username']=$row['firstname'].' '.$row['middlename'];
                            $_SESSION['userfirstname']=$row['firstname'];
                            $_SESSION['userothernames']=$row['middlename'].' '.$row['lastname'];
                            $_SESSION['systemadmin']=$row['systemadmin'];
                            $_SESSION['userimage']='../../images/blankavatar.jpg';   
                        }else{
                            $this->userid=$row['userid'];
                            $_SESSION['userid']=$row['userid'];
                            $_SESSION['clientid']=$row['clientid'];
                            $branchid = isset($row['defaultbranchid']) ? $row['defaultbranchid'] : 1;
                            $_SESSION['branchid']=$branchid;
                            $_SESSION['branchname'] = isset($row['branchname']) ? $row['branchname'] : "Default Branch";

                            $_SESSION['username']=$row['firstname'].' '.$row['middlename'];
                            $_SESSION['userfirstname']=$row['firstname'];
                            $_SESSION['userothernames']=$row['middlename'].' '.$row['lastname'];
                            $_SESSION['systemadmin']=$row['systemadmin'];
                            $_SESSION['userimage']='../../images/blankavatar.jpg';
                            
                            // Check for active session
                            $sql_session = "CALL `sp_checksessionid`({$branchid}, {$row['userid']})";
                            $rst_session = $this->connect()->query($sql_session);
                            $has_session = $rst_session->rowCount() > 0;
                            
                            return ["status"=>"success", "hassession" => $has_session];
                        }  
                    }else{
                        return ["status"=>"account inactive"];
                    } 
                }else{
                    return ["status"=>"invalid credentials"];
                }
            }else{
                return ["status"=>"invalid credentials"];
            }
        }

        function checkuserprivilegewithcode($code){
            $userid=$this->userid;
            $sql="CALL `sp_checkuserprivilegewithcode`({$this->clientid},{$userid},'{$code}')";
            return ["status"=>$this->getData($sql)->fetch()['allowed']==1?true:false];
        }
    }
?>