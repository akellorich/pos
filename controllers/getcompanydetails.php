<?php
    require_once("../models/companies.php");
    unset($_SESSION['dbname']);
    $company=new company;
    $company->getCompanies();

    if(isset($_get['getdatabases'])){
       echo $company->getlocaldatabases();
    }
?>
