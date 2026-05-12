<?php 
    require_once("../models/db.php");
    $db=new db();

    $receiptno=$_GET['receiptno'];

    // get institutional details
    $sql="CALL spgetinstitutiondetails()";
    $rst=$db->getData($sql)->fetch();

    $sql="CALL spgetreceiptdetails('{$receiptno}')";
    $rst2=$db->getData($sql)->fetchAll();

    $customername=$rst2[0]['customername'];
    $preparedby=$rst2[0]['servedby'];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice / Delivery Note</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 15px;
            color: #333;
            background-color: white;
            font-size: 12px;
        }
        
        @media print {
            body {
                padding: 0;
                font-size: 11px;
            }
        }
        
        .header-container {
            display: flex;
            margin-bottom: 15px;
            border-bottom: 1px solid #333;
            padding-bottom: 10px;
        }
        
        .logo-placeholder {
            /* width: 100px; */
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden; /* Ensures the image doesn't overflow */
            margin-right: 20px;
        }

        .logo-placeholder img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* Makes the image cover the container while maintaining aspect ratio */
            object-position: center; /* Centers the image */
        }
        
        .company-details {
            flex: 1;
            text-align: center;
        }
        
        .business-name {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 3px;
        }
        
        .document-title {
            font-size: 14px;
            margin-top: 10px;
            font-weight: bold;
        }
        
        .details-container {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            gap: 15px;
        }
        
        .customer-details, .receipt-details {
            width: 48%;
            padding: 8px;
            border: 1px solid #333;
            border-radius: 3px;
            font-size: 11px;
        }
        
        .section-title {
            font-weight: bold;
            border-bottom: 1px solid #333;
            margin-bottom: 8px;
            padding-bottom: 3px;
            font-size: 11px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
            font-size: 11px;
        }
        
        th, td {
            border: 1px solid #ddd;
            padding: 4px 6px;
            text-align: left;
        }
        
        th {
            background-color: #f2f2f2;
            padding: 5px 6px;
        }
        
        .total-row {
            font-weight: bold;
            background-color: #f2f2f2;
        }
        
        .payment-methods, .tax-summary, .remarks-section {
            margin-bottom: 15px;
        }
        
        .tax-summary table, .payment-methods table {
            margin-bottom: 0;
        }
        
        .received-by-container {
            border: 1px solid #ddd;
            padding: 10px;
            margin-top: 15px;
            border-radius: 3px;
        }
        
        .received-by-title {
            font-weight: bold;
            margin-bottom: 10px;
            text-align: center;
            font-size: 11px;
        }
        
        .received-by-fields {
            display: flex;
            justify-content: space-between;
        }
        
        .received-by-column {
            width: 32%;
            text-align: center;
        }
        
        .received-by-label {
            font-weight: bold;
            margin-bottom: 3px;
            font-size: 11px;
        }
        
        .received-by-input {
            border-bottom: 1px solid #333;
            height: 20px;
            margin-top: 3px;
        }
        
        .remarks-section {
            border: 1px solid #ddd;
            padding: 8px;
            margin-bottom: 15px;
            font-size: 11px;
        }
        
        .remarks-content {
            min-height: 40px;
            /* border-bottom: 1px solid #333; */
        }
        
        .served-by {
            /* text-align: right; */
            margin-top: 20px;
            padding-top: 5px;
            /* border-top: 1px solid #333; */
            font-size: 11px;
        }
        
        .served-by-label {
            font-weight: bold;
        }

        .text-right{
            text-align: right;
        }
    </style>
</head>
<body>
    <div class="header-container">
        <div class="logo-placeholder"><img src="../images/logo.jpg" alt="Logo"></div>
        <div class="company-details">
            <div class="business-name"><?=$rst['name']?></div>
            <div><?=$rst['physicaladdress']?></div>
            <div><?=$rst['postaladdress']?></div>
            <div>Telephone: <?=$rst['mobile']?></div>
            <div>Email: <?=$rst['email']?> | PIN No: <?=$rst['pinno']?></div>
            <div class="document-title">INVOICE / DELIVERY NOTE</div>
        </div>
    </div>
    <div class="details-container">
        <div class="customer-details">
            <div class="section-title">CUSTOMER DETAILS</div>
            <div>Name: <span id="customer-name"><?=$rst2[0]['customername']?></span></div>
            <div>Address: <span id="customer-address"><?=$rst2[0]['postaladdress'].' '.$rst2[0]['postalcode'].' '.$rst2[0]['town']?></span></div>
            <div>PIN No: <span id="customer-pin"><?=$rst2[0]['pinno']?></span></div>
        </div>
        
        <div class="receipt-details">
            <div class="section-title">INVOICE DETAILS</div>
            <div>Invoice No: <span id="receipt-no"><?=$receiptno?></span></div>
            <div>Invoice Date: <span id="receipt-name"><?=$rst2[0]['receiptdate']?></span></div>
            <div>POS Name: <span id="pos-name"><?=$rst2[0]['posname']?></span></div>
            <div>LPO #: <span id="pos-reference"><?=$rst2[0]['reference']?></span></div>
        </div>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>Item Code</th>
                <th>Description</th>
                <th class='text-right'>Qty</th>
                <th class='text-right'>Unit Price</th>
                <th class='text-right'>Total</th>
            </tr>
        </thead>
        <tbody>
            <?php
                $total=0;
                $taxes=0;
                $overalltotal=0;
                // print_r($rst2);
                foreach($rst2 as $row){
                    // print_r($row); 
                    $unitprice=$row['unitprice']-$row['discount'];
                    $tax=$unitprice*$row['taxrate']/100;
                    $unitprice-=$tax;
                    // echo $row['itemcode']." ".$row['itemname']." ".$row['quantity']." ".$unitprice." ".$tax;
                    $total=$unitprice*$row['quantity'];
                    $overalltotal+=$total;
            ?>
                    <tr>
                        <td><?=$row['itemcode']?></td>
                        <td><?=$row['itemname']?></td>
                        <td class='text-right'><?=number_format($row['quantity'],2)?></td>
                        <td class='text-right'><?=number_format($unitprice,2)?></td>
                        <td class='text-right'><?=number_format($total,2)?></td>
                    </tr>
            <?php
                }
                $sumtotal=$overalltotal;
            ?>

            <tr class="total-row">
                <td colspan="4" style="text-align: right;">TOTAL:</td>
                <td class='text-right'><?=number_format($sumtotal,2)?></td>
            </tr>
        </tbody>
    </table>
    
    <!-- <div class="payment-methods">
        <div class="section-title">PAYMENT SUMMARY</div>
        <table>
            <thead>
                <tr>
                    <th>Mode</th>
                    <th>Reference No</th>
                    <th class='text-right'>Amount</th>
                </tr>
            </thead>
            <tbody>
                <?php
                    // get payment details
                    $sql="CALL spgetpossalespayments('{$receiptno}')";
                    $rst=$db->connect()->query($sql);
                    $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
                    //print_r($data2);
                    $amountpaid=0;
                    foreach($data2 as $dataitem){
                        $amountpaid+=$dataitem['amount'];
                ?>
                        <tr>
                            <td><?= $dataitem['paymentmethod']?></td>
                            <td><?= $dataitem['reference']?></td>
                            <td class='text-right'><?= number_format($dataitem['amount'],2)?></td>
                        </tr>
                <?php
                    }
                ?>
            </tbody>
        </table>
    </div> -->
    
    <div class="tax-summary">
        <div class="section-title">TAX SUMMARY</div>
        <table>
            <thead>
                <tr>
                    <th>Tax Code</th>
                    <th class='text-right'>Rate</th>
                    <th class="text-right">Items Amount</th>
                    <th class='text-right'>Tax Amount</th>
                    <th class='text-right'>Total Amount</th>
                </tr>
            </thead>
            <tbody>
            <?php
                    $sql="CALL spgetreceiptvatanalysis('{$receiptno}')";
                    $rst=$db->connect()->query($sql);
                    $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
                    $totalitems=0;
                    $totaltax=0;
                    $totalamount=0;
                    foreach($data2 as $dataitem){
                        $tax=$dataitem['taxrate']*$dataitem['total']/(100);
                        $itemstotal=$dataitem['total']-$tax;
                        $totalitems+=$itemstotal;
                        $totaltax+=$tax;
                        $totalamount+=$dataitem['total'];
                ?>
                        <tr>
                            <td><?=$dataitem['abbreviation']?></td>
                            <td class='text-right'><?=$dataitem['taxrate']?></td>
                            <td class='text-right'><?=number_format($itemstotal,2)?></td>
                            <td class='text-right'><?=number_format($tax,2)?></td>
                            <td class='text-right'><?=number_format($dataitem['total'],2)?></td> 
                        </tr>
                <?php
                    }
                ?>
                <tr>
                        <td colspan='2'>TOTAL</td>
                        <td class='text-right'><?=number_format($totalitems,2)?></td>
                        <td class='text-right'><?=number_format($totaltax,2)?></td>
                        <td class='text-right'><?=number_format($totalamount,2)?></td>
                </tr>
            </tbody>
        </table>
    </div>
    
    <!-- <div> -->
        <div class="section-title">REMARKS</div>
    <!-- </div> -->
    <div class="remarks-section">
        <div class="remarks-content">
            <p>Thanks for shopping with us. Goods once sold are not refundable or exchangeable. Please come again</p>
        </div>
    </div>
    
    <div class="section-title">RECEIVED BY</div>
    <div class="received-by-container">
        <!-- <div class="received-by-title">RECEIVED BY</div> -->
        <div class="received-by-fields">
            <div class="received-by-column">
                <div class="received-by-label">Name</div>
                <div class="received-by-input"></div>
            </div>
            <div class="received-by-column">
                <div class="received-by-label">Date</div>
                <div class="received-by-input"></div>
            </div>
            <div class="received-by-column">
                <div class="received-by-label">Signature</div>
                <div class="received-by-input"></div>
            </div>
        </div>
    </div>
    
    <div class="served-by">
        <span class="served-by-label">Served By:</span> <?=$preparedby?>
    </div>
</body>
<script src="../js/jquery-2.2.4.js"></script>
<script>

    // close window after printing 
    window.onafterprint = function(e){
        $(window).off('mousemove', window.onafterprint);
        // mark receipt as printed
        receiptno=$("#receiptnumber").val()
        $.post(
            "/controllers/possalesoperations.php",
            {
                printreceipt:true,
                receiptno
            },
            (data)=>{
                // do nothing
            }
        )
       window.close();
       // console.log('Print Dialog Closed..');
    };

     // show printer dialog
    window.print();

    setTimeout(function(){
        $(window).on('mousemove', window.onafterprint);
    }, 1);

</script>
</html>