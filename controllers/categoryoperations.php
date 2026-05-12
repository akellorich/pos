<?php
    require_once("../models/category.php");
    $category=new category();
    
    if(isset($_GET['getcategorydetails'])){
        $id=$_GET['id'];
        $category->getCategoryDetails($id);
    }

    if(isset($_POST['deletecategory'])){
        $categoryid=$_POST['categoryid'];
        $category->deleteCategory($categoryid);
    }

    if(isset($_POST['savecategory'])){
        $id=$_POST['categoryid'];
        $categoryname=$_POST['categoryname'];
        $prefix=$_POST['prefix'];
        $currentno=$_POST['currentno'];
        $response=$category->saveCategory($id,$categoryname,$prefix,$currentno);
        echo json_encode($response);
    }

    if(isset($_GET['getcategories'])){
        echo $category->getCategories();
    }
?>