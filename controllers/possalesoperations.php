<?php
    require_once("../models/sale.php");
    require_once("../models/customer.php");

    $sale=new sale();
    $customer=new customer();

    if(isset($_POST['savesale'])){
        //$paymentmode=$_POST['paymentmethod'];
        //$referenceno=$_POST['referenceno'];
        $pos=$_POST['pointofsale'];
        $customerid=$_POST['customerid'];
        $transactiondate=$_POST['transactiondate'];
        $reference=isset($_POST['reference'])?$_POST['reference']:'';
        
        // Get Institution details for settings
        $sql="CALL `spgetinstitutiondetails`({$sale->clientid})";
        $institution = $sale->getData($sql)->fetch();

        $sendtovault = isset($_POST['sendtovault']) ? $_POST['sendtovault'] : $institution['sendtovault'];
        $printreceipt = $institution['printreceipt'];
        $walletid=isset($_POST['walletid'])?$_POST['walletid']:"";
        $change=isset($_POST['change'])?$_POST['change']:0;
       // echo "Change amount:".$change;  
        // echo "Send to vault :".$sendtovault;
        // echo "Wallet id:".$walletid;
        $tableData = stripcslashes($_POST['TableData']);

        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);
        // generate reference no
        $refno=$customer->generateid();//$customer->generateid();
        
        // save temporary
        foreach($tableData as $saleitem){

            $itemcode=$saleitem['itemcode'];
            $quantity=$saleitem['quantity'];
            $unitprice=$saleitem['unitprice'];
            $discount=$saleitem['discount']; 
            $serialno=$saleitem['serialno'];
            $description=isset($saleitem['description'])?$saleitem['description']:'';
            $sale->saveTemporarySale($refno,$itemcode,$quantity,$unitprice,$discount,$serialno,$description);

        }

        // save temporary payment methods
        $paymentmethods = stripcslashes($_POST['paymentmethods']);

        // Decode the JSON array
        $paymentmethods = json_decode($paymentmethods,TRUE);

        // save temporary
        foreach($paymentmethods as $paymentmethod){

            $paymentmode=$paymentmethod['modeid'];
            $reference=$paymentmethod['referenceno'];
            $amount=$paymentmethod['amount'];
            if($amount!="" && intval($amount)>0){
                $sale->saveTempPOSSalePayment($refno,$paymentmode,$reference,$amount);
            }
        }

        // save permanently
        $receiptno=$sale->saveSale($refno,$customerid,$pos,$transactiondate,$reference);

        if($sendtovault==1){
            // Institution details already fetched above

            $receiptHeader   = $sale->getreceiptheader($receiptno);
            $receiptDetails  = $sale->getreceiptdetails($receiptno);
            $receiptPayments = $sale->getreceiptpaymentmethods($receiptno);
            $vatAnalysis     = $sale->getreceiptvatanalysis($receiptno);

            $items=[];
            foreach(json_decode($receiptDetails,true) as $detail){
                $items[]= [
                    "name" => $detail['itemname'],
                    "quantity" => intval($detail['quantity']),
                    "unitPrice" => floatval($detail['unitprice']),
                    "totalPrice" => floatval($detail['quantity'] * $detail['unitprice']),
                    "taxGroup" => $detail['taxrate'] 
                ];
            }

            $taxinfo=[];
            $totaltax=0;
            foreach(json_decode($vatAnalysis,true) as $vat){
                $tax=$vat['taxrate']*$vat['total']/(100+$vat['taxrate']);
                $totaltax +=$tax;
                $taxinfo[]= [
                    "taxType" =>$vat['abbreviation'],
                    "taxRate" => $vat['taxrate'],
                    "amount" => floatval($vat['total']),
                    "taxAmount" => floatval($tax)
                ];
            }

            $paymentsmodes=[];
            $payments=[];
            $totalamount=0;
            foreach(json_decode($receiptPayments,true) as $pm){
                $paymentsmodes[]= [
                        "mode"=>strtoupper($pm['paymentmethod']),
                        "amount"=>floatval($pm['amount']),
                        "currency"=>"KES",
                        "sourceIdentifier" => "",
                        "displayLabel"=> "",
                        "change" => $change
                ];
                $payments[]= $pm['paymentmethod'];
                $totalamount += floatval($pm['amount']);
            }
            // Push curl request
            // print_r($items);
            // print_r($paymentsmodes);
            // print_r($payments);
            // print_r($taxinfo);
           
            $url = "https://engine.receipters.com/api/receipt/processor/pos";
            // $today=date("c");
            $data = [
                "apiKey" => "BRANCH_4B9897BFC26E4B218B63BE9AC9ECBD91",
                "phoneNumber" => $walletid,
                "receiptNo" => $receiptno,
                "currency" => "KES",
                "buyerPin" => "0",
                "clientName" => "DIRECT CLIENT",
                "store" => [
                    "name" =>$institution['name'],
                    "vatNo" =>$institution['pinno'],
                    "pinNo" =>$institution['pinno'],
                    "phoneNumber" =>$institution['mobile'],
                    "email" => $institution['email']
                ],
                "date" => date("c"),
                "items" =>$items,
                "amount" => $totalamount,
                "subTotal" => $totalamount - $totaltax,
                "taxInfo" => $taxinfo,
                "payments" =>  $paymentsmodes,
                "paymentModes" => $payments,

                // Need to be extractred after ETIMS integration
                "taxInvoiceDetails" => [
                    "cus" => "KRAMW019202206040628",
                    "cuin" => "0190406280000000008",
                    "qrCode" => "some-qr-string"
                ],

                "posSoftware" => "Fusion POS"
            ];

            $payload = json_encode($data);
            // echo "Payload:".$payload;
            $ch = curl_init($url);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_POST => true,
                CURLOPT_HTTPHEADER => [
                    "Content-Type: application/json"
                ],
                CURLOPT_POSTFIELDS => $payload
            ]);

            $response = curl_exec($ch);

            if(curl_errno($ch)){
                echo "cURL Error: " . curl_error($ch);
            }

            // echo $response;
            curl_close($ch);
        }
        header('Content-Type: application/json');
        $response = [
            "status" => "success",
            "receiptno" => $receiptno,
            "printreceipt" => $printreceipt
        ];
        echo json_encode($response);
        exit;
    }

    if(isset($_POST['checkpaymentmodereference'])){
        $modeid=$_POST['modeid'];
        $referenceno=$_POST['referenceno'];
        echo $sale->checkRefNo($modeid,$referenceno);
    }

    if(isset($_GET['usersalessummary'])){
        $userid=$_GET['userid'];
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $posname=$_GET['posname'];
        $userid=$_GET['userid'];
        $sale->getUserSalesSummary($startdate,$enddate,$posname,$userid);
    }

    if(isset($_GET['customersalessummary'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $posname=$_GET['posname'];
        $userid=$_GET['userid'];
        $sale->getCustomerSalesSummary($startdate,$enddate,$posname,$userid);
    }

    if(isset($_GET['getpossales'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $posid=$_GET['posid'];
        $paymentmode=$_GET['paymentmode'];
        $sale->getPOSSales($startdate,$enddate,$posid,$paymentmode);
    }

    if(isset($_POST['cancelreceipt'])){
        $receiptno=$_POST['receiptno'];
        $reason=$_POST['reason'];
        $url = "http://engine.receipters.com/api/receipts/void";
        // $today=date("c");
        $data = [
            "receiptNo" => $receiptno,
            "vatNo" => "A006556318W",
            "voidReason" =>$reason
        ];

        $payload = json_encode($data);

        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_HTTPHEADER => [
                "Content-Type: application/json"
            ],
            CURLOPT_POSTFIELDS => $payload
        ]);

        $response = curl_exec($ch);

        if(curl_errno($ch)){
            echo "cURL Error: " . curl_error($ch);
        }

        // echo $response;
        curl_close($ch);
        echo $sale->cancelPOSSale($receiptno,$reason);
    }

    if(isset($_POST['holdsale'])){
        $posid=$_POST['pointofsale'];
        $customerid=$_POST['customerid'];
        // temporary save
        // Unescape the string values in the JSON array
        $tableData = stripcslashes($_POST['TableData']);
        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);
        // generate reference no
        $refno=$customer->generateid();
        
        // save temporary
        foreach($tableData as $saleitem){
           $itemcode=$saleitem['itemcode'];
           $quantity=$saleitem['quantity'];
           $unitprice=$saleitem['unitprice'];
           $discount=$saleitem['discount']; 
           $serialno=$saleitem['serialno'];
           $description=$saleitem['description'];
           $sale->saveTemporarySale($refno,$itemcode,$quantity,$unitprice,$discount,$serialno,$description);
        }
        // save permanently
        $sale->holdSale($refno,$customerid,$posid);
    }
    if(isset($_GET['getheldsales'])){
        $sale->getHeldSales();
    }
    if(isset($_GET['getheldsaleheader'])){
        $id=$_GET['id'];
        $sale->getHeldSaleHeader($id);
    }
    if(isset($_GET['getheldsaledetails'])){
        $id=$_GET['id'];
        $sale->getHeldsaleDetails($id);
    }
    if(isset($_POST['deleteheldsale'])){
        $id=$_POST['id'];
        $sale->deleteHeldSale($id);
    }
    if(isset($_POST['savebanking'])){
        $refno=$customer->generateid();
        $cashbookaccount=$_POST['cashbookaccount'];
        $narration=$_POST['narration'];
        $reference=$_POST['reference'];
        $postas=$_POST['postas'];
        $receiptbanked=$_POST['receiptbanked'];
        $tableData = stripcslashes($_POST['TableData']);
        // Decode the JSON array
        $tableData = json_decode($tableData,TRUE);

        foreach($tableData as $bankingreceipt){
            $receiptno=$bankingreceipt['receiptno'];
            $reference1=$bankingreceipt['reference'];
            $amount=$bankingreceipt['amount'];
            $customername=$bankingreceipt['customername']; 
            $id=$bankingreceipt['id'];
            $sale->savetempbanking($refno, $receiptno,$reference1,$amount,$customername,$id);
         }

         $sale->savebanking($refno ,$cashbookaccount, $narration,$reference,$postas,$receiptbanked);
    }
    
    if(isset($_GET['operation'])){
        $startdate=$_GET['startdate'];
        $enddate=$_GET['enddate'];
        $posid=$_GET['posid'];
        $paymentmode=$_GET['paymentmode'];
        if($_GET['operation']=='getposreceiptsforbanking'){
            $sale->getPOSReceiptsForBanking($startdate,$enddate,$posid,$paymentmode);
        }else if($_GET['operation']=='getposcustomerreceiptsforbanking'){
             echo $customer->getCustomerUnbankedReceipts($paymentmode,$startdate,$enddate);
        }
    }
    if(isset($_GET['getreceiptitems'])){
        $receiptno=$_GET['receiptno'];
        echo $sale->getreceiptitems($receiptno);
    }
    if(isset($_GET['getreceiptitemdetails'])){
        $receiptno=$_GET['receiptno'];
        $productid=$_GET['productid'];
        echo $sale->getreceiptitemdetails($receiptno,$productid);
    }
   
    if(isset($_GET['getmpesatransaction'])){
        $amount=$_GET['amount'];
        $reference=isset($_GET['$referenceno'])?$_GET['$referenceno']:'';
        echo $sale->getmpesapayment($amount,$reference);
    }

    if(isset($_POST['printreceipt'])){
        $receiptno=$_POST['receiptno'];
        echo $sale->printreceipt($receiptno);
    }

    if(isset($_GET['getpossalereceipt'])){
        $receiptno=$_GET['receiptno'];
        echo $sale->getpossalereceipt($receiptno);
    }


    if(isset($_GET['getreceiptheader'])){
        echo $sale->getreceiptheader();
    }

    if(isset($_GET['getreceiptdetails'])){
        $receiptno=$_GET['receiptno'];
        echo $sale->getreceiptdetails($receiptno);
    }

    if(isset($_GET['getreceiptpaymentmethods'])){
        $receiptno=$_GET['receiptno'];
        echo $sale->getreceiptpaymentmethods($receiptno);
    }

    if(isset($_GET['getreceiptvatanalysis'])){
        $receiptno=$_GET['receiptno'];
        echo $sale->getreceiptvatanalysis($receiptno);
    }

     if(isset($_POST['completerefund'])){
        $receiptno=$_POST['receiptno'];
        $reason=$_POST['reason'];
        $products=json_decode(stripcslashes($_POST['items']),true);
        $refno=generate_random_no(20);
        // temp save the refund products in the database and return the receipt number to be printed in the refund receipt
        foreach($products as $product){
            $itemcode=$product['itemcode'];
            $quantity=$product['quantity'];
            $sale->savetemprefundproduct($refno,$itemcode,$quantity);
        }

        $finalresponse=$sale->refundproducts($refno,$receiptno,$reason,$products);
        // Send refund request to receipt engine 
       
        $url = "http://engine.receipters.com/api/receipts/void";
        // $today=date("c");
        $data = [
            "receiptNo" => $receiptno,
            "vatNo" => "A006556318W",
            "voidReason" =>$reason
        ];

        $payload = json_encode($data);
        
        // Get new receipt no
        $receiptno=$finalresponse['receiptno'];
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_HTTPHEADER => [
                "Content-Type: application/json"
            ],
            CURLOPT_POSTFIELDS => $payload
        ]);

        $response = curl_exec($ch);

        // Send new receipt
        $sql="CALL `spgetinstitutiondetails`({$sale->clientid})";
        $institution = $sale->getData($sql)->fetch();

        $receiptHeader   = $sale->getreceiptheader($receiptno);
        $receiptDetails  = $sale->getreceiptdetails($receiptno);
        $receiptPayments = $sale->getreceiptpaymentmethods($receiptno);
        $vatAnalysis     = $sale->getreceiptvatanalysis($receiptno);

        $items=[];
        foreach(json_decode($receiptDetails,true) as $detail){
            $items[]= [
                "name" => $detail['itemname'],
                "quantity" => intval($detail['quantity']),
                "unitPrice" => floatval($detail['unitprice']),
                "totalPrice" => floatval($detail['quantity'] * $detail['unitprice']),
                "taxGroup" => $detail['taxrate'] 
            ];
        }

        $taxinfo=[];
        $totaltax=0;
        foreach(json_decode($vatAnalysis,true) as $vat){
            $tax=$vat['taxrate']*$vat['total']/(100+$vat['taxrate']);
            $totaltax +=$tax;
            $taxinfo[]= [
                "taxType" =>$vat['abbreviation'],
                "taxRate" => $vat['taxrate'],
                "amount" => floatval($vat['total']),
                "taxAmount" => floatval($tax)
            ];
        }

        $paymentsmodes=[];
        $payments=[];
        $totalamount=0;
        foreach(json_decode($receiptPayments,true) as $pm){
            $paymentsmodes[]= [
                    "mode"=>strtoupper($pm['paymentmethod']),
                    "amount"=>floatval($pm['amount']),
                    "currency"=>"KES",
                    "sourceIdentifier" => "",
                    "displayLabel"=> "",
                    "change" => 0
            ];
            $payments[]= $pm['paymentmethod'];
            $totalamount += floatval($pm['amount']);
        }
        // Push curl request
        // print_r($items);
        // print_r($paymentsmodes);
        // print_r($payments);
        // print_r($taxinfo);
        
        $url = "https://engine.receipters.com/api/receipt/processor/pos";
        // $today=date("c");
        $data = [
            "apiKey" => "BRANCH_4B9897BFC26E4B218B63BE9AC9ECBD91",
            "phoneNumber" => "+254743000000",
            "receiptNo" => $receiptno,
            "currency" => "KES",
            "buyerPin" => "0",
            "clientName" => "DIRECT CLIENT",
            "store" => [
                "name" =>$institution['name'],
                "vatNo" =>$institution['pinno'],
                "pinNo" =>$institution['pinno'],
                "phoneNumber" =>$institution['mobile'],
                "email" => $institution['email']
            ],
            "date" => date("c"),
            "items" =>$items,
            "amount" => $totalamount,
            "subTotal" => $totalamount - $totaltax,
            "taxInfo" => $taxinfo,
            "payments" =>  $paymentsmodes,
            "paymentModes" => $payments,

            // Need to be extractred after ETIMS integration
            "taxInvoiceDetails" => [
                "cus" => "KRAMW019202206040628",
                "cuin" => "0190406280000000008",
                "qrCode" => "some-qr-string"
            ],

            "posSoftware" => "Fusion POS"
        ];

        $payload = json_encode($data);
        // echo "Payload:".$payload;
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_HTTPHEADER => [
                "Content-Type: application/json"
            ],
            CURLOPT_POSTFIELDS => $payload
        ]);

        $response = curl_exec($ch);

        // if(curl_errno($ch)){
        //     echo "cURL Error: " . curl_error($ch);
        // }

        // echo $response;
        curl_close($ch);

        echo json_encode($finalresponse);
    }
?>
