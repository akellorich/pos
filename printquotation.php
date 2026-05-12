<?php

require_once __DIR__ . '/vendor/autoload.php';
require_once "models/db.php";
$db=new db();

if(isset($_GET['quotationno'])){
    $quotationno=$_GET['quotationno'];
}

$mpdf = new \Mpdf\Mpdf();
//$mpdf->WriteHTML('<h1>Hello world!</h1>');
//$mpdf->Output();
function index()
{
    // boost the memory limit if it's low ;)
    ini_set('memory_limit', '256M');
    // load library
    $this->load->library('pdf');
    $pdf = $this->pdf->load();
    // retrieve data from model or just static date
    $data['title'] = "items";
    $pdf->allow_charset_conversion=true;  // Set by default to TRUE
    $pdf->charset_in='UTF-8';
 //   $pdf->SetDirectionality('rtl'); // Set lang direction for rtl lang
    $pdf->autoLangToFont = true;
    $html = $this->load->view('content/mpdf', $data, true);
    // render the view into HTML
    $pdf->WriteHTML($html);
    // write the HTML into the PDF
    $output = 'posquotation' . date('Y_m_d_H_i_s') . '_.pdf';
    $pdf->Output("$output", 'I');
    // save to file because we can exit();
}
    // get institution details
    $sql="CALL spgetinstitutiondetails()";
    $rst=$db->connect()->query($sql);
    $data=$rst->fetch(PDO::FETCH_ASSOC);
   
    // get receipt details
    $sql="CALL sp_getquotationdetails('{$quotationno}')";
    $rst=$db->connect()->query($sql);
    $data1=$rst->fetch(PDO::FETCH_ASSOC);

?>

<!DOCTYPE html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=B612+Mono&display=swap" rel="stylesheet">
    <title>Customer Quotation Receipt</title>
   
    <style>
        @media print {
            @page {
                margin: 0 auto; /* important to logo margin */
                sheet-size: 340px 250mm; /* important to set paper size */
            }
            
            html,body{
                margin:0;
                padding:0;
                /*font-size: 13pt;*/ 
                -webkit-print-color-adjust: exact;
            }

            #printContainer {
                width: 290px;
                margin: auto;
                margin-top:50px;
                /*padding: 10px;*/
                /*border: 2px dotted #000;*/
                text-align: justify;
            }

            #companydetails{
                font-size:1rem;
                font-weight:bolder;
                padding-top:50px;
            }
           .text-center{text-align: center;}
           .text-right{text-align: right;}
           .text-left{text-align: left;}
           .indent{
               padding-left: 10px;
                width:80%;
            }
        }

        html,body{
            font-size: 11pt;
            font-family: 'B612 Mono', monospace;
        }

        .caps{
            text-transform: uppercase;
        }
    </style>
</head>
<body>
<!-- <h1 id="logo" class="text-center"><img src='images/logo.png' alt='Logo'></h1> -->

<div id='printContainer'>
    
    <div id="companydetails" class="text-center caps">
        <?=$data['name'];?>
        </div>
    <div class="text-center">
        <?=$data['physicaladdress'];?>
    </div>
    <div class="text-center">P.O Box 
        <?=$data['postaladdress'];?>
    </div>
    <div class="text-center">Tel: 
        <?=$data['landline'];?>
    </div>
    <div class="text-center">
        <?=$data['email'];?>
    </div>
    <div class="text-center caps">PIN NUMBER: 
        <?=$data['pinno'];?>
    </div>
   <p class='text-center'>CUSTOMER QUOTATION</p>
   <hr>
    <table>

        <tr>
            <td>Quote #: </td>
            <td id='customer'><b><?=$data1['quoteno'];?></b></td>
        </tr>

        <tr>
            <td>Date: </td>
            <td id='receiptnumber'><b><?=$data1['quotedate'];?></b></td>
        </tr>

        <tr>
            <td>Client: </td>
            <td id='customer'><b><?=$data1['customername'];?></b></td>
        </tr>
        
        <tr>
            <td>Terms: </td>
            <td id='date'><b><?= $data1['terms']; ?><br></b></td>
        </tr>

    </table>
   
   <hr>
    <!-- <img src="/images/copy.jpg" class="background" alt=""> -->
    <table id="itemdetails">
        <tr>
            <td colspan='2'><b>Item</b></td>
            <td class='text-right'><b>Quantity/Price</b></td>
        </tr>
        <tr><td colspan="3"><hr></td></tr>
       
        <div id="items">
        <?php 
            $servedby=$data1['servedby'];
            $sql="CALL sp_getquotationdetails('{$quotationno}')";
            $rst=$db->connect()->query($sql);
            $data1=$rst->fetchAll(PDO::FETCH_ASSOC);
            $overalltotal=0;
            $amountpaid=0;

            foreach($data1 as $dataitem){
                $unitprice=$dataitem['unitprice'];
                $total=$unitprice*$dataitem['quantity'];
                $overalltotal+=$total;
                echo "<tr><td class='text-left'>". $dataitem['itemcode']."<td class='text-right' colspan='2'><span class='nondecimal'>".($total)."</span></td></tr>";
                echo "<tr><td class='text-left indent'  colspan='2'>".$dataitem['itemname']."<td class='text-right' colspan='2'><span class='numeric'>".$dataitem['quantity']."</span> x <span class='nondecimal'>".$unitprice."</span></td></tr>";
            }
            if($amountpaid==0){
                $amountpaid= $overalltotal;
            }
        ?>  
       </div>
    </table>

    <hr>

    <table>
        <tr>
            <td colspan='2'><b>TOTAL:</b></td>
            <td id='total' class='text-right'><b><span class='nondecimal'><?=$overalltotal?></span></b></td>
        </tr>
        <!-- <tr><td colspan='3'><hr></td></tr>
        <tr><td colspan='3'><b>PAYMENT METHODS</b><hr></td></tr> -->
        <?php
            // // get payment methods
            // $sql="CALL spgetpossalespayments('{$receiptno}')";
            // $rst=$db->connect()->query($sql);
            // $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
            // $amountpaid=0;
            // foreach($data2 as $dataitem){
            //     $amountpaid+=$dataitem['amount'];
            //     echo "<tr><td class='text-left'>". $dataitem['paymentmethod']."<td class='text-center'>".$dataitem['reference']." </td><td class='text-right'><span class='nondecimal'>".$dataitem['amount']."</span></td></tr>";
            // }    
            // echo "<tr><td colspan='3'><hr></td></tr><tr><td class='text-left' colspan='2'><b>TOTAL PAID:</b></td><td class='text-right'><b><span class='nondecimal'>".$amountpaid."</span></b></td></tr>";
            // $balance=$amountpaid-$overalltotal;
        ?>
        <!-- <tr>
            <td><b>BALANCE:</b></td>
            <td id='balance' class='text-right' colspan='2'><b><span class='numeric'><?=$balance; ?></span></b></td>
        </tr>

        <tr><td colspan='3'><hr></td></tr>
        <tr><td colspan='3'><b>VAT ANALYSIS</b><hr></td></tr>
        <tr>
            <td><b>CODE (%)</b></td>
            <td class='text-right'><b>AMOUNT</b></td>
            <td class='text-right'><b>VAT</b></td>
        </tr>
        <tr><td colspan="4"><hr></td></tr> -->

        <?php
        // get vat summary
        // $sql="CALL spgetreceiptvatanalysis('{$receiptno}')";
        // $rst=$db->connect()->query($sql);
        // $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
        // foreach($data2 as $dataitem){
        //     $tax=$dataitem['taxrate']*$dataitem['total']/(100+$dataitem['taxrate']);
        //     echo "<tr><td class='text-left'>". $dataitem['abbreviation']." - ".($dataitem['taxrate'])."</td><td class='text-right'><span class='numeric'>".(number_format($dataitem['total']))."</span></td><td class='text-right'><span class='numeric'>".number_format($tax,2)."</span></td></tr>";
        //     // echo "<tr><td class='text-left'  colspan='2'>".$dataitem['itemname']."<td class='text-right' colspan='2'><span class='numeric'>".$dataitem['quantity']."</span> x <span class='nondecimal'>".$unitprice."</span></td></tr>";
        // }
        ?>
       
        <div id='receiptfooter'>
            <tr>
                <td colspan="3"><hr>Thanks for shopping with us. Please come again.<hr></td>
                <td></td>
            </tr>
        <div>
        <tr>
            <td><b>Served By:</b></td>
            <td id='servedby' colspan='2'><?=$servedby ?></td>
        </tr>

    </table>
    <hr>

</div>
</body>
<script type="text/javascript" src="js/jquery-2.2.4.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.number.js"></script>
<script type="text/javascript">
$(document).ready(function(){
   
    // format all number fields
    var numericfields = $(".numeric")
    numericfields.each(function(){
        if(parseFloat($(this).text())){
            $(this).text($.number($(this).text(),2))
        }
    })

    var nondecimalfields=$(".nondecimal")
    nondecimalfields.each(function(){
        if(parseFloat($(this).text())){
            $(this).text($.number($(this).text()))
        }
    })
    // close window after printing 
    window.onafterprint = function(e){
        $(window).off('mousemove', window.onafterprint);
        window.close();
    };

     // show printer dialog
    window.print();

    setTimeout(function(){
        $(window).on('mousemove', window.onafterprint);
    }, 1);/**/
})
</script>
</html>