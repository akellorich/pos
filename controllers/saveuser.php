<?php 

    require_once('../models/user.php');
    $user=new User();
    
    if(isset($_POST['saveuser'])){
        $id=$_POST['id'];
        $username=$_POST['username'];
        $firstname=$_POST['firstname'];
        $middlename=$_POST['middlename'];
        $othernames=$_POST['othernames'];
        $password=$_POST['password'];
        $changepasswordonlogon=$_POST['changepassswordonlogon'];
        $accountexpires=isset($_POST['accountexpires']) ? $_POST['accountexpires'] : 0;
        $accountexpireson=isset($_POST['accountexpireson']) ? $_POST['accountexpireson'] : '';
        $email=$_POST['email'];
        $mobile=$_POST['mobile'];
        $systemadmin=isset($_POST['systemadmin']) ? $_POST['systemadmin'] : 0;
        $accountactive=isset($_POST['accountactive']) ? $_POST['accountactive'] : 1;
        $pin=isset($_POST['pin']) ? $_POST['pin'] : '';
        $defaultbranchid=isset($_POST['defaultbranchid']) ? $_POST['defaultbranchid'] : 1;

        $profilephoto = '';
        if(isset($_FILES['profilephoto']) && $_FILES['profilephoto']['error'] == 0){
            $filename = time() . '_' . $_FILES['profilephoto']['name'];
            $target_dir = "../images/user_profiles/";
            $target_file = $target_dir . $filename;
            if(move_uploaded_file($_FILES['profilephoto']['tmp_name'], $target_file)){
                $profilephoto = $filename;
            }
        }

        $result=$user->saveUser($id,$username,$password,$firstname,$middlename,$othernames,$mobile,$email,$systemadmin,$accountactive,$changepasswordonlogon,$pin,'',$profilephoto,$defaultbranchid);
        if(is_numeric($result) || $result=="Success"){
            if(isset($_POST['TableData'])){
                $newuserid = is_numeric($result) ? $result : $id;
                $tableData = json_decode(stripcslashes($_POST['TableData']), TRUE);
                if(is_array($tableData)){
                    foreach($tableData as $userprivilege){
                        $objectid=$userprivilege['id'];
                        $valid=$userprivilege['valid'];
                        $user->saveUserPrivilege($newuserid,$objectid,$valid,$defaultbranchid);
                    }
                }
            }
            echo "Success";
        }else{
            echo $result;
        }
    }

?>