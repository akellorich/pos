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
        $autoinvoicegrn,$postalcode,$tagline,$website,$receiptfooter,$defaultcustomer,$mainbusinesstype,$logo,$town);
        echo json_encode($response);
    }

    if(isset($_GET['getwarehouses'])){
        echo $setting->getwarehouses();
    }

    if(isset($_GET['getloginuisettings'])){
        echo $setting->getloginuisettings();
    }   
?>