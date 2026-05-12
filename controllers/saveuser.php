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
        $accountexpires=$_POST['accountexpires'];
        $accountexpireson=$_POST['accountexpireson'];
        $password=$_POST['password'];
        $email=$_POST['email'];
        $mobile=$_POST['mobile'];

        $result=$user->saveUser($id,$username,$firstname,$middlename,$othernames,$password,$email,$mobile,$accountexpires, $accountexpireson,$changepasswordonlogon);
        if($result=="Success"){
            echo "Success";
        }else{
            echo $result;
        }
    }

?>