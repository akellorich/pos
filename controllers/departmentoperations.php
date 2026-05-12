<?php

    require_once("../models/department.php");
    $department=new department();

    if(isset($_POST['savedepartment'])){
        $departmentname=$_POST['departmentname'];
        $id=$_POST['id'];
        $hodid=$_POST['hodid'];
        echo $department->savedepartment($id,$departmentname,$hodid);
    }

    if(isset($_GET['getdepartments'])){
        echo $department->getdepartments();
    }

    if(isset($_GET['getdepartmentdetails'])){
        $id=$_GET['id'];
        echo $department->getdepartmentdetails($id);
    }

    if(isset($_POST['deletedepartment'])){
        $id=$_POST['id'];
        echo $department->deletedepartment($id);
    }

?>