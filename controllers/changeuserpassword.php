<?php
    require_once '../models/user.php';

    $id=$_POST['id'];
    $newpassword=$_POST['newpassword'];
    $oldpassword=$_POST['oldpassword'];
    $changepasswordonlogon=$_POST['changepasswordonlogon'];

    $user=new User();

    echo $user->changeUserPassword($id,$oldpassword,$newpassword,$changepasswordonlogon)
?>