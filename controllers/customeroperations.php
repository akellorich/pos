<?php
    require_once("../models/customer.php");
    $customer=new customer();

    if(isset($_GET['getcustomercategories'])){
        echo $customer->getCustomerCategories();
    }

    if(isset($_GET['getcustomerdetails'])){
        $customerid=$_GET['customerid'];
        echo $customer-> getCustomerDetails($customerid);
    }

    if(isset($_POST['deletecustomer'])){
        $customerid=$_POST['customerid'];
        echo $customer->deleteCustomer($customerid);
    }

    if(isset($_POST['savecustomerdiscount'])){
        $id=$_POST['id'];
        $customerid=$_POST['customerid'];
        $productid=$_POST['productid'];
        $discount=$_POST['discount'];
        $percentage=$_POST['percentage'];
        $expirydate=$_POST['expirydate'];
        echo $customer->saveCustomerDiscountDetails($id,$customerid,$productid,$discount,$percentage,$expirydate);
    }

    if(isset($_GET['getcustomerdiscounts'])){
        $customerid=$_GET['customerid'];
        echo $customer->getCustomerDiscountSettings($customerid);
    }

    if(isset($_POST['deletecustomerdiscount'])){
        $id=$_POST['id'];
        echo $customer->deleteCustomerDiscount($id);
    }

    if(isset($_POST['savereceipt'])){
        // generate reference no
        $refno=generate_random_no();

        // get  receipt parameters parameters
        $tableData = stripcslashes($_POST['TableData']);
        $customerid=$_POST['customerid'];
        $paymentmode=$_POST['modeofpayment'];
        $referenceno=$_POST['referenceno'];
        $overpay=$_POST['overpay'];
        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);

        // save temporary
        foreach($tableData as $saleitem){
            $possaleid=$saleitem['possaleid'];
            $amount=$saleitem['amount'];
            $customer->saveTempCustomerReceipt($refno, $possaleid,$amount);        
        }

        // save permanently
        $receiptno=$customer->saveCustomerReceipt($refno,$customerid,$paymentmode,$referenceno,$overpay);
        // generate refno
        echo $receiptno;
    
        // print receipt

    }

    if(isset($_GET['getopenreceivables'])){
        $customerid=$_GET['customerid'];
        echo $customer->getCustomerOpenReceivables($customerid);
    }

    if(isset($_GET['generatecustomerreceipt'])){
        $receiptno=$_GET['receiptno'];
        echo $customer->generateReceipt($receiptno);
    }

    // if(isset($_POST['savecustomer'])){
    //     $customerid=$_POST['id'];
    //     $customername=$_POST['customername'];
    //     $physicaladdress=$_POST['physicaladdress'];
    //     $postaladdress=$_POST['postaladdress'];
    //     $mobile=$_POST['mobile'];
    //     $email=$_POST['email'];
    //     $creditlimit=$_POST['creditlimit'];
    //     $category=$_POST['category'];
    //     $posid=$_POST['posid'];
    //     $onetimecustomer=$_POST['onetimecustomer'];
    //     $pinno=$_POST['pinno'];
    //     $idno=$_POST['idno'];
    //     $subzoneid=$_POST['subzoneid'];
    //     echo $customer->saveCustomer($customerid,$customername,$physicaladdress,$postaladdress,
    //         $mobile ,$email,$creditlimit,$category,$posid,$onetimecustomer,$pinno,$idno,$subzoneid);
    // }

    if(isset($_POST['savecustomer'])){
        $customerid=$_POST['id'];
        $customername=$_POST['customername'];
        $tradingname=$_POST['tradingname'];
        $physicaladdress=$_POST['physicaladdress'];
        $postaladdress=$_POST['postaladdress'];
        $mobile=$_POST['mobile'];
        $email=$_POST['email'];
        $creditlimit=$_POST['creditlimit'];
        $creditterm=$_POST['creditterm'];
        $category=$_POST['category'];
        $posid=$_POST['posid'];
        $onetimecustomer=$_POST['onetimecustomer'];
        $pinno=$_POST['pinno'];
        $idno=$_POST['idno'];
        $subzoneid=$_POST['subzoneid'];
        echo $customer->saveCustomer($customerid,$customername,$tradingname,$physicaladdress,$postaladdress,$mobile ,$email,$creditlimit,$creditterm,
            $category,$posid,$onetimecustomer,$pinno,$idno,$subzoneid);
    }
    
    if(isset($_GET['getcustomers'])){
        $posid=!(isset($_GET['posid']))?0:$_GET['posid'];
        $regularcustomers=!(isset($_GET['regularcustomers']))?0:$_GET['regularcustomers'];
        $onetimecustomers=!(isset($_GET['onetimecustomers']))?0:$_GET['onetimecustomers'];
        echo $customer->getCustomers($posid,$regularcustomers,$onetimecustomers);
    }

    if(isset($_GET['getinsertedcustomer'])){
        echo $customer->getinsertedcustomer();
    }

    if(isset($_GET['getcustomersuspenseaccount'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $customerid=$_GET['customerid'];
        echo $customer->getsuspenseaccountstatement($customerid,$startdate,$enddate);
    }

    if(isset($_POST['savecustomercontact'])){
        $id=$_POST['id'];
        $customerid=$_POST['customerid'];
        $categoryid=$_POST['categoryid'];
        $contactname=$_POST['contactname'];
        $idno=$_POST['idno'];
        $mobile=$_POST['mobile'];
        $email=$_POST['email'];
        $consentsigned=$_POST['consentsigned'];
        echo $customer->savecustomercontact($id,$customerid,$categoryid,$contactname,$idno,$mobile,$email,$consentsigned);
    }

    if(isset($_POST['deletecustomercontact'])){
        $id=$_POST['id'];
        echo $customer->deletecustomercontact($id);
    }

    if(isset($_GET['getcustomercontacts'])){
        $customerid=$_GET['customerid'];
        echo $customer->getcustomercontacts($customerid);
    }

    if(isset($_GET['getcontactcategories'])){
        echo $customer->getcontactcategories();
    }
?>