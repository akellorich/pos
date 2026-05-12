<?php

require_once '../vendor/autoload.php';
require_once "../models/db.php";
$db=new db();

if(isset($_GET['receiptno'])){
    $receiptno=$_GET['receiptno'];
}else{
    $receiptno="";
}
if(isset($_GET['amountpaid'])){
    $amountpaid=$_GET['amountpaid'];
}else{
    $amountpaid=0;
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
    $sql="CALL spgetreceiptdetails('{$receiptno}')";
    $rst=$db->connect()->query($sql);
    $data1=$rst->fetch(PDO::FETCH_ASSOC);

?>

<!DOCTYPE html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=B612+Mono&display=swap" rel="stylesheet">
    <title>Customer Payment Receipt</title>
    <style>
        @media print {
            @page {
                margin: 0 auto; /* important to logo margin */
                sheet-size: 2480px 297mm; /* important to set paper size */
            }
            
            html,body{
                padding:0;
                font-size: 10pt;
                font-family: 'B612 Mono', monospace;
                margin:1.2rem;
            }

            #printContainer {
                width: 100%;
                margin: auto;
                /*padding: 10px;*/
                /*border: 2px dotted #000;*/
                text-align: justify;/**/
            }

            table{
                width:100%;
            }

            .items td{
                border-bottom:1px solid #949494;
            }

           .text-center{text-align: center;}
           .text-right,.number{text-align: right;}
           .text-left{text-align: left;}
        }
    </style>
</head>
<body>
<!-- <h1 id="logo" class="text-center"><img src='images/logo.png' alt='Logo'></h1> -->

<div id='printContainer'>
    <input type="hidden" id="receiptnumber" value="<?php 
        if(isset($_GET['receiptno'])){
            echo $_GET['receiptno'];
        }else{
            echo '';
        }
    ?>">
    <input type="hidden" id="amountpaid" value="
        <?php if(isset($_GET['amountpaid'])){
                echo $_GET['amountpaid'];
            }else{
                echo '';
            }
        ?>">
    <h4 id="companydetails" class="text-center">
        <?=$data['name'];?>
    </h4>
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
   

    <table>

        <tr>
            <td>
                <?=$data1['customername'];?><br/>
                <?='P.O Box '.$data1['postaladdress'];?><br/>
                <?='Mobile: '.$data1['mobile'];?><br/>
            </td>
        
            <td>
                <?='<b>Outlet</b>:  '.$data1['posname'];?><br/>
                <?='<b>Date:</b>    '.$data1['receiptdate'] ;?><br/>
                <?='<b>Receipt #</b>:   '.$data1['receiptno'];?><br/>
            </td>
        </tr>


        <!-- <tr>
            <td>POS: </td>
            <td id='customer'><b><?=$data1['posname'];?></b></td>
        </tr>
        <tr>
            <td>Receipt #: </td>
            <td id='receiptnumber'><b><?=$data1['receiptno'];?></b></td>
        </tr>
        <tr>
            <td>Date: </td>
            <td id='date'><b><?= $data1['receiptdate']; ?><br></b></td>
        </tr>

        <tr>
            <td>Client: </td>
            <td id='customer'><b><?=$data1['customername'];?></b></td>
        </tr> -->

    </table>
    <!-- <p class="text-center"><img src="<?// =base_url() ?>global/site/qr.png" alt="QR-code" class="left"/></p> -->
    <hr>

    <table>
        <tr class="items">
            <td><b>Item Code</b></td>
            <td><b>Item Name</b></td>
            <td class='text-right'><b>Quantity</b></td>
            <td class='text-right'><b>Unit Price</b></td>
            <td class='text-right'><b>Total</b></td>
        </tr>
        <!-- <tr><td colspan="5"><hr></td></tr>
        -->
        <div id="items">
        <?php 
            $servedby=$data1['servedby'];
            $sql="CALL spgetreceiptdetails('{$receiptno}')";
            $rst=$db->connect()->query($sql);
            $data1=$rst->fetchAll(PDO::FETCH_ASSOC);
            $overalltotal=0;
            $item="";
           // print_r($data1);
            foreach($data1 as $dataitem){
                //print_r($dataitem);
                $unitprice=$dataitem['unitprice']-$dataitem['discount'];
                //echo $dataitem['itemcode']." ".$dataitem['itemname']." ".$dataitem['quantity']." ".$unitprice;
                $total=$unitprice*$dataitem['quantity'];
                $overalltotal+=$total;
                $item.="<tr class='items'><td class='text-left'>".$dataitem['itemcode']."</td>";
                $item.="<td class='text-left'>".$dataitem['itemname']."</td>";
                $item.="<td class='text-right'>".$dataitem['quantity']."</td>";
                $item.="<td class='text-right'>".number_format($unitprice,2)."</td>";
                $item.="<td class='text-right'>".number_format($total,2)."</td></tr>";
                // echo "<tr><td class='text-left'>".$dataitem['itemcode']."<td><span class='number'>".$dataitem['quantity']."</span> x <span class='number'>".$unitprice."</span></td></tr>";
                // echo "<tr><td class='text-left' colspan='2'>".$dataitem['itemname']."<td class='text-right'><span class='number'>".$total."</span></td></tr>";
            }

            // $item.="<tr><td colspan='5'><hr></td></tr>";
            $item.="<tr><td colspan='3' class='text-right'><b>TOTAL:</b></td><td colspan='2' class='text-right'>".number_format($overalltotal,2)."</td></tr>";
            $item.="<tr><td colspan='5'>&nbsp</td></tr>";
            $item.="<tr><td colspan='5'>PAYMENT METHODS</td></tr>";

            $item.="<tr class='items'>
                        <td colspan='2'>Payment Mode</td>
                        <td colspan='2'>Reference</td>
                        <td>Amount</td>
                    </tr>";
            
            // $item.="<tr><td colspan='5'><hr></td></tr>";
            // get payments
            $sql="CALL spgetpossalespayments('{$receiptno}')";
            $rst=$db->connect()->query($sql);
            $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
            //print_r($data2);
            $amountpaid=0;
            foreach($data2 as $dataitem){
                $amountpaid+=$dataitem['amount'];
                $item.= "<tr><td class='text-left' colspan='2'>". $dataitem['paymentmethod']."</td><td>".$dataitem['reference']."</td><td class='text-right' colspan='2'><span class='number'>".number_format($dataitem['amount'],2)."</span></td></tr>";
            }

            // $item.="<tr><td colspan='5'><hr></td></tr>";
            // Total paid 
            if($amountpaid==0){
                $amountpaid= $overalltotal;
            }

            $balance= $amountpaid-$overalltotal;
            $item.= "<tr><td class='text-left' colspan='4'>TOTAL: </td><td class='text-right'><span class='number'>".number_format($amountpaid,2)."</span></td></tr>";
            $item.= "<tr class='items'><td class='text-left' colspan='4'>BALANCE: </td><td class='text-right'><span class='number'>".number_format($balance,2)."</span></td></tr>";

            // $item.="<tr ><td colspan='5'>&nbsp</td></tr>";
            // get VAT Analysis
            $item.="<tr><td colspan='5'><b>VAT ANALYSIS</b></td></tr>
                     <tr>
                        <td><b>CODE (%)</b></td>
                        <td class='text-right' colspan='2'><b>VAT</b></td>
                        <td class='text-right' colspan='2'><b>AMOUNT VATABLE</b></td>
                    </tr>";

            // get vat summary
            $sql="CALL spgetreceiptvatanalysis('{$receiptno}')";
            $rst=$db->connect()->query($sql);
            $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
            foreach($data2 as $dataitem){
                $tax=$dataitem['taxrate']*$dataitem['total']/(100+$dataitem['taxrate']);
                $item.="<tr>
                    <td class='text-left'>". $dataitem['abbreviation']." - ".($dataitem['taxrate'])."</td>
                    <td class='text-right' colspan='2'><span class='numeric'>".number_format($tax,2)."</span></td>
                    <td class='text-right' colspan='2'><span class='numeric'>".number_format($dataitem['total'],2)."</span></td> 
                </tr>";
            // echo "<tr><td class='text-left'  colspan='2'>".$dataitem['itemname']."<td class='text-right' colspan='2'><span class='numeric'>".$dataitem['quantity']."</span> x <span class='nondecimal'>".$unitprice."</span></td></tr>";
            }
            // add the footer 

            $item.='<tr>
                <td colspan="5"><hr>Thanks for shopping with us. Please come again. Goods once sold are not returnable.<b>Crate Deposits refundable within 7 Days</b><hr></td>
            </tr>';

            $item.='<tr><td colspan="2">You Were served by:<br>'.$servedby.'</td>';
            $item.='<td colspan="3">Received by: <br>(Name, seal and sign)<br/></td></tr>';

            echo $item;
        ?>
       </div>

    </table>
    <!-- <hr>

    <table>
        <tr>
            <td><b>TOTAL DUE:</b></td>
            <td id='total' class='text-right number'><b><?=$overalltotal?></b></td>
        </tr>
        <tr>
            <td><b>PAID:</b></td>
            <td id='amountpaid' class='text-right number'><b><?=$amountpaid; ?></b></td>
        </tr>
        <tr>
            <td><b>BALANCE:</b></td>
            <td id='balance' class='text-right number'><b><?=$balance; ?></b></td>
        </tr>
        <div id='receiptfooter'>
            <tr>
                <td colspan="3"><hr>Thanks for shopping with us. Please come again. Goods once sold are not returnable.<hr></td>
                <td></td>
            </tr>
        <div>
        <tr>
            <td><b>Served By:</b></td>
            <td id='servedby'><?=$servedby ?></td>
        </tr>

    </table> -->

</div>
</body>
<script type="text/javascript" src="../js/jquery-2.2.4.js"></script>
<script type="text/javascript" src="../js/jquery.number.js"></script>
<script type="text/javascript" src="../js/printreceipt.js"></script>

</html>