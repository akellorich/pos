<?php
require_once("../models/glaccount.php");

$glaccount=new glaccount();

if(isset($_GET['getglaccountclasses'])){
    $glaccount->getglaccountclasses();
}else if(isset($_GET['getglaccountgroups'])){
    $classid=$_GET['classid'];
    $glaccount->getglgroups($category);
}else if(isset($_GET['getglaccounts'])){
    $groupid=$_GET['groupid'];
    $glaccount->getglaccounts($groupid);
}else if(isset($_POST['saveglaccountgroup'])){
    $id=$_POST['id'];
    $glaccountclass=$_POST['accountclass'];
    $groupname=$_POST['groupname'];
    $subcategoryof=$_POST['subcategoryof'];
    $cashbookaccount=$_POST['cashbookaccount'];
    $glaccount->saveglgroup($id,$glaccountclass,$groupname,$subcategoryof,$cashbookaccount);
}else if(isset($_POST['saveglaccount'])){
    $id=$_POST['id'];
    $groupid=$_POST['groupid'];
    $accountcode=$_POST['accountcode'];
    $accountname=$_POST['accountname'];
    $glaccount->saveglaccount($id,$groupid,$accountcode,$accountname);
}else if(isset($_POST['deleteglgroup'])){
    $id=$_POST['id'];
    $glaccount->deleteglgroup($id);
}else if(isset($_POST['deleteglaccount'])){
    $id=$_POST['id'];
    $glaccount->deleteglaccount($id);
}else if(isset($_GET['getglparentgroups'])){
    $classid=$_GET['classid'];
    $glaccount->getglparentgroups($classid);
}else if (isset($_GET['getsubgroups'])){
    $groupid=$_GET['groupid'];
    $glaccount->getsubgroups($groupid);
}else if(isset($_GET['getcashbookaccounts'])){
    $glaccount->getCashBookAccounts();
}else if(isset($_GET['getglaccountdetails'])){
    $id =$_GET['id'];
    $glaccount->getGLAccountDetails($id);
}
?>