<?php

require_once __DIR__ . '/vendor/autoload.php';
require_once "models/db.php";
$db=new db();

if(isset($_GET['voucherid'])){
    $id=$_GET['voucherid'];
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
    $output = 'possalereceipt' . date('Y_m_d_H_i_s') . '_.pdf';
    $pdf->Output("$output", 'I');
    // save to file because we can exit();
}
    // get institution details
    $sql="CALL spgetinstitutiondetails()";
    $rst=$db->connect()->query($sql);
    $data=$rst->fetch(PDO::FETCH_ASSOC);
   
    // get receipt details
    $sql="CALL spgetpaymentvoucher('{$id}')";
    $rst=$db->connect()->query($sql);
    $data1=$rst->fetch(PDO::FETCH_ASSOC);

?>

<!DOCTYPE html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <title>Customer Payment Receipt</title>
    <link href="https://fonts.googleapis.com/css?family=VT323" rel="stylesheet">

    <style>
        @media all {
            @page {
                margin: 0 auto; /* important to logo margin */
                 sheet-size: 900px 250mm; /**/ /* important to set paper size */
            }
            
            html,body{
                margin:0;
                padding:0
            }
            #printContainer {
                width: 900px;
                margin: auto;
                padding: 50px;/**/
                /*border: 2px dotted #000;*/
                text-align: justify;
            }

            #companydetails{
                font-size:2rem;
                font-weight:bold
            }
           .text-center{text-align: center;}
           .text-right{text-align: right;}
           .text-left{text-align: left;}
           .indent{
               padding-left: 10px;
                width:80%;
            }

            table{
                width:100%;
            }

            #companydetails{
                font-size: 1rem;
                text-transform: uppercase;
            }
        }
    </style>
</head>
<body>
<!-- <h1 id="logo" class="text-center"><img src='images/logo.png' alt='Logo'></h1> -->

<div id='printContainer'>
      
    <div id="companydetails" class="text-center">
        <?=$data['name'];?>
    </div>
    <div class="text-center">
        <?=$data['physicaladdress'];?>
    </div>
    <div class="text-center">Box 
        <?=$data['postaladdress'];?>
    </div>
    <div class="text-center">Tel: 
        <?=$data['landline'];?>
    </div>
    <div class="text-center">
        <?=$data['email'];?>
    </div>
    <div class="text-center">PIN NUMBER: 
        <?=$data['pinno'];?>
    </div><br/>
    <div class="text-center"><b>PAYMENT VOUCHER </b></div><br/>
   
    <table>
        <tr>
            <td>PAID TO: </td>
            <td>VOUCHER DETAILS: </td>
        </tr>
        <tr>
            <td id='suppliername'><b><?=$data1['suppliername'];?></b></td>
            <td id='vouchernumber'>Voucher #: <b><?=$data1['voucherno'];?></b></td>
        </tr>
        <tr>
            <td id='physicaladdress'><b><?=$data1['physicaladdress'];?></b></td>
            <td id='voucherdate'>Date: <b><?=$data1['voucherdate'];?></b></td>
        </tr>
        <tr>
            <td id='postaladdress'><b><?= $data1['postaladdress']; ?><br></b></td>
            <td id='invoicenumber'>Invoice #: <b><?=$data1['invoicenumber'];?></b></td>
        </tr>

        <tr>
            <td id='email'><b><?=$data1['email'];?></b></td>
            <td id='paymentmode'>Payment Mode: <b><?=$data1['paymentmethod'];?>&nbsp;&nbsp;&nbsp;&nbsp;</b>Reference #: <b><?=$data1['referenceno']; ?></b></td>
        </tr>
    </table>
   
   <hr>
    <table>
        <tr>
            <td><b>Code</b></td>
            <td><b>Description</b></td>
            <td class='text-right'><b>Quantity</b></td>
            <td class='text-right'><b>Unit Price</b></td>
            <td class='text-right'><b>Line Total</b></td>
        </tr>
        <tr><td colspan="5"><hr></td></tr>
       
        <div id="items">
        <?php 
            $servedby=$data1['preparedby'];
            $sql="CALL spgetpaymentvoucher('{$id}')";
            $rst=$db->connect()->query($sql);
            $data1=$rst->fetchAll(PDO::FETCH_ASSOC);
            $overalltotal=0;

            foreach($data1 as $dataitem){
                $unitprice=$dataitem['unitprice']; // -$dataitem['discount'];
                $total=$dataitem['unitprice']*$dataitem['quantity'];
                $overalltotal+=$total;
                echo "<tr><td class='text-left'>". $dataitem['itemcode']."</td><td>".$dataitem['description']."</td><td class='text-right'><span class='numeric '>".$dataitem['quantity']."</span></td><td class='text-right'><span class='numeric'>".$dataitem['unitprice']."</td><td class='text-right'><span class='numeric'>".$total."</td></tr>";
                // echo "<tr><td class='text-left indent'  colspan='2'>".$dataitem['itemname']."<td class='text-right'><span class='numeric'>".$total."</span></td></tr>";
            }
        ?>
    
       </div>

    </table>
    <hr>

    <table>
        <tr>
            <td colspan='4'><b>TOTAL :</b></td>
            <td id='total' class='text-right'><b><span class='numeric'><?=$overalltotal?></span></b></td>
        </tr>
        <tr><td colspan='5'><hr></td></tr>

        <tr>
            <td>&nbsp;</td>
            <td><b>Prepared By:</b></td>
            <td><b>Approved By:</b></td>
            <td><b>Collected By:</b></td>
        </tr>
        <tr><td>&nbsp;</td></tr>
      
        <tr>
            <td>NAME: </td>
            <td id='servedby'><?=$servedby ?></td>
            <td id='approvedby' >__________________________</td>
            <td id='collectedby'>__________________________</td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr></tr>
        <tr>
            <td>DATE:   </td>
            <td>__________________________</td>
            <td>__________________________</td>
            <td>__________________________</td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr></tr>
        <tr>
            <td>SIGNATURE: </td>
            <td>__________________________</td>
            <td>__________________________</td>
            <td>__________________________</td>
        </tr>
    </table>


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
            $(this).text($.number($(this).text()))
        }
    })

    // close window after printing 
    window.onafterprint = function(e){
        $(window).off('mousemove', window.onafterprint);
        window.close();
        console.log('Print Dialog Closed..');
    };

     // show printer dialog
    window.print();

    setTimeout(function(){
        $(window).on('mousemove', window.onafterprint);
    }, 1);
})
</script>
</html>