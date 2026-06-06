<?php
    require_once("../models/settings.php");
    $setting=new settings();
    if(isset($_GET['getinstitutiondetails'])){
        echo $setting->getInstitutionDetails();
    }
    
    if(isset($_GET['getprivileges'])){
        if(isset($_GET['module'])){
            $module=$_GET['module'];
        }else{
            $module="";
        }
        echo $setting->getPrivileges($module);
    }

    if(isset($_GET['gettodaysdate'])){
        $setting->getTodaysDate();
    }

    if(isset($_GET['getsalessettings'])){
        echo $setting->getSalesSettings();
    }

    if(isset($_GET['getsystemmodules'])){
        echo $setting->getSystemModules();
    }

    if(isset($_POST['savecrateinventorysettings'])){
        $productid=$_POST['productid'];
        $supplierid=$_POST['supplierid'];
        $glaccountid=$_POST['glaccountid'];
        $costcenter=$_POST['costcenter'];
        $paymentmode=$_POST['paymentmode'];
        $paymentaccount=$_POST['cashbookaccount'];
        echo $setting->savecrateinventorysettings($productid,$supplierid,$glaccountid,$costcenter,$paymentmode,$paymentaccount);
    }

    if(isset($_GET['getcrateinventorysettings'])){
        echo $setting->getcrateinventorysettings();
    }

    if(isset($_GET['getcrateadditionparameters'])){
        echo $setting->getcrateadditionparameters();
    }

    if(isset($_POST['savecrateaddition'])){
        $productid=$_POST['productid'];
        $quantity=$_POST['quantity'];
        $unitprice=$_POST['unitprice'];
        $narration=$_POST['narration'];
        $reference=$_POST['reference'];
        echo $setting->savecrateaddition($productid,$quantity,$unitprice,$narration,$reference);
    }

    if(isset($_GET['getpaymentmethods'])){
        echo $setting->getPaymentMethods();
    }

    if(isset($_GET['getunistofmeasure'])){
        echo $setting->getUnitsOfMeasure();
    }
    
    if(isset($_GET['gettaxtypes'])){
        echo $setting->gettaxtypes();
    }

    if(isset($_GET['getcurrencies'])){
        echo $setting->getcurrencies();
    }

    if(isset($_GET['getdepartments'])){
        echo $setting->getdepartments();
    }

    if(isset($_GET['gettaxdetails'])){
        $taxid=$_GET['taxid'];
        echo $setting->gettaxdetails($taxid);
    }

    if(isset($_GET['getpapergrammage'])){
        echo $setting->getpapergrammage();
    }

    if(isset($_GET['getdefaultterms'])){
        echo $setting->getdefaultterms();
    }
    if(isset($_POST['saveinstitutiondetails'])){
        $companyname=$_POST['companyname'];
        $physicaladdress=$_POST['physicaladdress'];
        $postaladdress=$_POST['postaladdress'];
        $landline=$_POST['landline'];
        $email=$_POST['emailaddress'];
        $mobile=$_POST['mobile'];
        $pinno=$_POST['pinno'];
        $autoinvoicegrn=$_POST['autoinvoicegrn'];
        $postalcode=$_POST['postalcode'];
        $tagline=$_POST['tagline'];
        $website=$_POST['website'];
        $receiptfooter=$_POST['receiptfooter'];
        $defaultcustomer=$_POST['defaultcustomer'];
        $mainbusinesstype=$_POST['mainbusinesstype'];
        $town=$_POST['town'];
        $allowpricechange=isset($_POST['allowpricechange'])?$_POST['allowpricechange']:0;
        $allownegativesalesglobally=isset($_POST['allownegativesalesglobally'])?$_POST['allownegativesalesglobally']:0;
        
        // check if logo is uploaded
        if(isset($_FILES['logo']['tmp_name'])){
            $tempname=$_FILES['logo']['tmp_name'];
            $extension=pathinfo($_FILES['logo']['name'], PATHINFO_EXTENSION);
            $logo="../logos/".generate_random_no(10).'_logo.'.$extension;
            move_uploaded_file($tempname,$logo);
        }else{
            $logo=$_POST['savedlogo'];
        }

        $response=$setting->saveinstitutiondetails($companyname,$physicaladdress,$postaladdress,$landline,$email,$mobile,$pinno,
        $autoinvoicegrn,$postalcode,$tagline,$website,$receiptfooter,$defaultcustomer,$mainbusinesstype,$logo,$town,
        $allowpricechange,$allownegativesalesglobally);
        echo json_encode($response);
    }

    if(isset($_GET['getwarehouses'])){
        echo $setting->getwarehouses();
    }

    if(isset($_GET['getloginuisettings'])){
        echo $setting->getloginuisettings();
    }   
    if(isset($_GET['getbranches'])){
        echo $setting->getBranches();
    }

    if(isset($_POST['savebranch'])){
        $branchid = $_POST['branchid'];
        $branchname = $_POST['branchname'];
        $location = $_POST['location'];
        echo $setting->saveBranch($branchid, $branchname, $location);
    }

    if(isset($_POST['deletebranch'])){
        $branchid = $_POST['branchid'];
        echo $setting->deleteBranch($branchid);
    }

    if(isset($_GET['checkbranch'])){
        $branchid = $_GET['branchid'];
        $branchname = $_GET['branchname'];
        echo $setting->checkBranch($branchid, $branchname);
    }

    if(isset($_GET['getcountries'])){
        echo $setting->getCountries();
    }

    if(isset($_POST['savecountry'])){
        $countryid = $_POST['countryid'];
        $countryname = $_POST['countryname'];
        $countrycode = $_POST['countrycode'];
        $currency = $_POST['currency'];
        $currencysymbol = $_POST['currencysymbol'];
        $dialingcode = $_POST['dialingcode'];
        $isdefault = $_POST['isdefault'];
        echo $setting->saveCountry($countryid, $countryname, $countrycode, $currency, $currencysymbol, $dialingcode, $isdefault);
    }

    if(isset($_POST['deletecountry'])){
        $countryid = $_POST['countryid'];
        echo $setting->deleteCountry($countryid);
    }

    if(isset($_POST['update_session_branch'])){
        session_start();
        $branchid = $_POST['branchid'];
        $_SESSION['branchid'] = $branchid;
        
        // Also update branch name in session
        require_once("../models/db.php");
        $db = new db();
        $branch_sql = "CALL sp_getbranchdetails($branchid)";
        $branch_rst = $db->connect()->query($branch_sql);
        if($branch_rst->rowCount()){
            $branch_row = $branch_rst->fetch();
            $_SESSION['branchname'] = $branch_row['branchname'];
        }
        
        echo "success";
    }
?>