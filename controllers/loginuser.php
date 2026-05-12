<?php 

    require '../models/user.php';
    $user=new User();

    $username=$_GET['username'];
    $password=$_GET['password'];
    
    $result=$user->logUserIn($username,$password);
    
    echo json_encode($result);

?>