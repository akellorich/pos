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
    <title>Customer Payment Receipt</title>
    <style>
        @media print {
            @page {
                margin: 0 auto; /* important to logo margin */
                sheet-size: 300px 250mm; /* important to set paper size */
            }
            
            html,body{margin:0;padding:0}
            #printContainer {
                width: 250px;
                margin: auto;
                /*padding: 10px;*/
                /*border: 2px dotted #000;*/
                text-align: justify;/**/
            }

            table{
                width:250px;
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
        </tr>

    </table>
    <!-- <p class="text-center"><img src="<?// =base_url() ?>global/site/qr.png" alt="QR-code" class="left"/></p> -->
    <hr>

    <table>
        <tr>
            <td><b>Item</b></td>
            <td class='text-right' colspan="2"><b>Quantity/Price</b></td>
        </tr>
        <tr><td colspan="3"><hr></td></tr>
       
        <div id="items">
        <?php 
            $servedby=$data1['servedby'];
            $sql="CALL spgetreceiptdetails('{$receiptno}')";
            $rst=$db->connect()->query($sql);
            $data1=$rst->fetchAll(PDO::FETCH_ASSOC);
            $overalltotal=0;
           // print_r($data1);
            foreach($data1 as $dataitem){
                //print_r($dataitem);
                $unitprice=$dataitem['unitprice']-$dataitem['discount'];
                //echo $dataitem['itemcode']." ".$dataitem['itemname']." ".$dataitem['quantity']." ".$unitprice;
                $total=$unitprice*$dataitem['quantity'];
                $overalltotal+=$total;
                echo "<tr><td class='text-left' colspan='2'>".$dataitem['itemcode']."<td class='text-right'><span class='number'>".$dataitem['quantity']."</span> x <span class='number'>".$unitprice."</span></td></tr>";
                echo "<tr><td class='text-left' colspan='2'>".$dataitem['itemname']."<td class='text-right'><span class='number'>".$total."</span></td></tr>";
            }

            echo "<tr><td colspan='3'><hr></td></tr>";

            // get payments
            $sql="CALL spgetpossalespayments('{$receiptno}')";
            $rst=$db->connect()->query($sql);
            $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
            //print_r($data2);
            $amountpaid=0;

            foreach($data2 as $dataitem){
                $amountpaid+=$dataitem['amount'];
                echo "<tr><td class='text-left'>". $dataitem['paymentmethod']."</td><td>".$dataitem['reference']."</td><td class='text-right'><span class='number'>".$dataitem['amount']."</span></td></tr>";
            }

            if($amountpaid==0){
                $amountpaid= $overalltotal;
            }
            $balance= $amountpaid-$overalltotal;
        ?>
       </div>

    </table>
    <hr>

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

    </table>

</div>
</body>
<script type="text/javascript" src="../js/jquery-2.2.4.js"></script>
<script type="text/javascript" src="../js/jquery.number.js"></script>
<script type="text/javascript" src="../js/printreceipt.js"></script>

</html>