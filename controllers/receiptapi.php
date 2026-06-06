<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *"); 
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

/*
BRANCH_4B9897BFC26E4B218B63BE9AC9ECBD91
BRANCH_435AEF3355A34E7E9D165F6850CC6C1F
BRANCH_E61CFD7EB6FA450DADF6EA64805FF862
BRANCH_E8E7CA57F8E64F87B72F996DA3445740
BRANCH_1D9A73E685554E91A37DF9AF689A864F
BRANCH_98C6652A3C70456F9DB14280201AB105
BRANCH_5F892B3378B349958EEB2139BF17461E
BRANCH_37D12F18E7C2446ABB102D785F88AD96
BRANCH_5BE6D7FAFDBC4E89A12B3FC7D5398983
*/

require_once("../models/sale.php");
require_once("../models/customer.php");

$_SESSION['dbname']="pos"; //"spzcnhia_pos";
$_SESSION['userid']=1;

$sale = new sale();
$customer = new customer();

// ---- Read Raw JSON Body ----
$inputJSON = file_get_contents("php://input");
$data = json_decode($inputJSON, true);

if (!$data) {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid or missing JSON body"
    ]);
    exit;
}

try {

    /** ===========================
     *  Extract JSON fields
     *  ===========================
     */

    $pos               = $data['pointofsale'];
    $customerid        = $data['customerid'];
    $transactiondate   = $data['transactiondate'];
    $reference         = $data['reference'] ?? "";
    $items             = $data['items'];             // array
    $paymentmethods    = $data['paymentmethods'];    // array
    $walletid          =$data['walletid'] ?? "";

    // Get Institution details
    $sql="CALL `spgetinstitutiondetails`({$sale->clientid})";
    $institution = $sale->getData($sql)->fetch();

    /** ===========================
     *  Generate Temporary Ref No
     *  ===========================
     */
    $refno = $customer->generateid();

    /** ===========================
     *  Save Temporary Sale Items
     *  ===========================
     */

    foreach ($items as $item) {
        $sale->saveTemporarySale(
            $refno,
            $item['itemcode'],
            $item['quantity'],
            $item['unitprice'],
            $item['discount'],
            $item['serialno'] ?? "",
            $item['description'] ?? ""
        );
    }

    /** ===========================
     *  Save Temporary Payment Methods
     *  ===========================
     */
    foreach ($paymentmethods as $pm) {
        if (intval($pm['amount']) > 0) {
            $sale->saveTempPOSSalePayment(
                $refno,
                $pm['modeid'],
                $pm['referenceno'],
                $pm['amount']
            );
        }
    }

    /** ===========================
     *  Save the Sale Permanently
     *  ===========================
     */
    $receiptno = $sale->saveSale(
        $refno,
        $customerid,
        $pos,
        $transactiondate,
        $reference
    );

    /** ===========================
     *  Load Receipt Details
     *  ===========================
     */

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
                "mode"=>$pm['paymentmethod'],
                "amount"=>floatval($pm['amount']),
                "currency"=>"KES"
        ];
        $payments[]= $pm['paymentmethod'];
        $totalamount += floatval($pm['amount']);
    }
    // Push curl request

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
        "payments" =>  $paymentsmodes=[],
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

    curl_close($ch);

    echo $response;

    /** ===========================
     *  Return Response
     *  ===========================
     */
    echo json_encode([
        "status" => "success",
        "receiptno" => $receiptno,
        "header" => $receiptHeader,
        "details" => $receiptDetails,
        "paymentmethods" => $receiptPayments,
        "vatanalysis" => $vatAnalysis,
        "walletid"=>$walletid
    ]);

} catch (Exception $e) {

    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}
?>
