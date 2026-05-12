<?php
    header("Content-Type: application/json");
    require_once('../models/db.php');
    // set the correct database
    $_SESSION['dbname']='distributor';
    
    $db=new db();

    $response = '{"ResultDesc": "Confirmation Received Successfully","ResultCode": 0}';
    // Response from M-PESA Stream
    $mpesaResponse = file_get_contents('php://input');
    // log the response
    $logFile = "../logfiles/mpesaconfirmation.txt";
    
    $jsonMpesaResponse = json_decode($mpesaResponse, true); // We will then use this to save to database
    $accountno=$jsonMpesaResponse['BillRefNumber'];
    $paymentmoderef=$jsonMpesaResponse['TransID'];
    $amount=$jsonMpesaResponse['TransAmount'];
    $paymentdate=$jsonMpesaResponse['TransTime'];
    $mobile=$jsonMpesaResponse['MSISDN'];
    $payeename=$jsonMpesaResponse['FirstName'].' '.$jsonMpesaResponse['MiddleName'].' '.$jsonMpesaResponse['LastName'];
    // check if transaction code has been used previously
    $sql="CALL spcheckmpesatransactioncode('{$paymentmoderef}')";
    $rst=$db->getData($sql);
    if($rst->rowCount()){
        $response = '{"ResultDesc": "The transaction code already exists","ResultCode": 1}' ;
    }else{
        $sql="CALL `spsavempesaconfirmation`('{$paymentmoderef}','{$paymentdate}',{$amount},'{$mobile}','{$payeename}')";
        //$sql="CALL `sp_savempesapayment`('{$accountno}','{$paymentdate}','{$paymentmoderef}',{$amount},'{$mobile}','{$payeename}')";
        $db->getData($sql);
    }

    // write to file
    $log = fopen($logFile, "a");
    fwrite($log, $mpesaResponse);
    fclose($log); 

    echo $response;

    /*
    sample confirmation response
    {
        "TransactionType":"",
        "TransID":"LGR219G3EY",
        "TransTime":"20170727104247",
        "TransAmount":"10.00",
        "BusinessShortCode":"600134",
        "BillRefNumber":"4231",
        "InvoiceNumber":"",
        "OrgAccountBalance":"49197.00",
        "ThirdPartyTransID":"1234567890",
        "MSISDN":"254727709772",
        "FirstName":"John",
        "MiddleName":"Doe",
        "LastName":""
    }
    */
?>
