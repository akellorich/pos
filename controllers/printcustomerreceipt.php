<?php


require_once dirname(__DIR__,1) . '/vendor/autoload.php';
require_once("../models/db.php");
require_once("../models/mail.php");

$mail=new mail();
$db=new db();

$receiptno=$_GET['receiptno'];

// get institutional details
$sql="CALL spgetinstitutiondetails()";
$rst=$db->getData($sql)->fetch();

$sql="CALL spgetreceiptdetails('{$receiptno}')";
$rst2=$db->getData($sql)->fetch();

$customername=$rst2['customername'];
$preparedby=$rst2['servedby'];

$data='
    <html>
    <head>
        <style>
            body {/*font-family: sans-serif;*/
                font-size: 10pt;
            }
            p {	margin: 0pt; }
            table.items {
                margin-top:10px;
                border: 0.1mm solid #000000;
            }
            td { vertical-align: top; }
            .items td {
                border-left: 0.1mm solid #000000;
                border-right: 0.1mm solid #000000;
            }
            table thead td { background-color: #EEEEEE;
                text-align: center;
                border: 0.1mm solid #000000;
                font-variant: small-caps;
            }
            .items td.blanktotal {
                background-color: #EEEEEE;
                border: 0.1mm solid #000000;
                background-color: #FFFFFF;
                border: 0mm none #000000;
                border-top: 0.1mm solid #000000;
                border-right: 0.1mm solid #000000;
            }
            .items td.totals {
                text-align: right;
                border: 0.1mm solid #000000;
            }
            .items td.cost {
                text-align: "." center;
            }

            #pagefooter{
                border-top: 1px solid #000000; 
                font-size: 9pt; 
                padding-top: 3mm; 
                display:flex;
            }

            .totals td{
                border-top: 1px solid #000000; 
            }
           
            .logo{
                height:100px;
                width:300px;
                margin-top:-17px;
            }

            .header-table tr td{
                border-bottom:2px solid #2E3192;
                color:#2E3192;
            }
            
        </style>
    </head>
    <body>

    <!--mpdf
    <htmlpageheader name="myheader">
        <table width="100%" class="header-table" cellspacing="0">
            <tr>
                <td width="69%"><img class="logo" src="../images/logo.jpg"><br/>
                    '.$rst['tagline'].' | P.O Box '.$rst['postaladdress'].
                '</td>
                <td width="1%" style="color:#0000BB; ">
                    <!-- <span style="font-weight: bold; font-size: 14pt;">'.$rst['name'].'</span><br />-->
                </td>
                <td width="30%" style="text-align: right;">
                    <!-- Order No.<br /><span style="font-weight: bold; font-size: 12pt;">'.$receiptno.'</span> -->
                    <br/>
                    <span style="font-family:dejavusanscondensed;">&#9742;</span> '.$rst['mobile'].'<br />'.$rst['website'].'<br/>'.$rst['email'].'<br/>'.$rst['physicaladdress'].'<br />
                </td>
            </tr>
        </table>
       
    </htmlpageheader> 
   
    <htmlpagefooter name="myfooter"> 
        <div  id="pagefooter" style="display: block;" >
            <div style="float:left; width:80%">
                Prepared By: '.$preparedby.'
            </div>

            <div style="float:right; text-align:right">
                Page {PAGENO} of {nb}
            </div>
        </div> 
    </htmlpagefooter>
    <sethtmlpageheader name="myheader" value="on" show-this-page="1" />
    <sethtmlpagefooter name="myfooter" value="on" />
    mpdf-->

';

// document heading
$data.="<h3 style='text-align:center; padding-top:100px;' >CUSTOMER RECEIPT / INVOICE</h3>";

$data.="<table width='100%' style='border: 0.1mm solid #888888; padding:10px; margin-bottom:5px;'><tr><td width='50%'>". $rst2['customername']. "<br />".$rst2['physicaladdress'] ."<br />P.O Box ". $rst2['postaladdress'] ." ".$rst2['postalcode']. "<br/>" .$rst2['town']. "</td>";
$data.="<td width='50%' style='text-align:right;'>Receipt Number: ".$receiptno."<br/>Transaction Date: ". $rst2['receiptdate']."<br />Outlet: ". $rst2['posname']."</td></tr></table>";


//$terms= preg_replace("/\r\n|\r|\n/", '<br/>', $rst2['terms']);
// $terms=nl2br($rst2['terms']);
$email=$rst2['email'];

// get po items
// $sql="CALL sp_getquotationitems('{$receiptno}')";
$rst=$db->getData($sql);

// create a heading for the table containing items
$data.="<table  width='100%' cellpadding='3' cellspacing='0' class='items'>
    <thead>
        <tr>
            <td style='text-align:left;' class='border-bottom'>Item Code</td>
            <td style='text-align:left;' class='border-bottom'>Item Name</td>
            <td style='text-align:right;' class='border-bottom'>Quantity</td>
            <td style='text-align:right;' class='border-bottom'>Unit Price</td>
            <td style='text-align:right;' class='border-bottom'>Total</td>
        </tr>
    </thead>
    <tbody>";

// variables for holding total and taxes
$total=0;
$taxes=0;
while($row=$rst->fetch()){
    $unitprice=$row['unitprice']-$row['discount'];
    //echo $row['itemcode']." ".$row['itemname']." ".$row['quantity']." ".$unitprice;
    $total=$unitprice*$row['quantity'];
    $overalltotal+=$total;
    $data.="<tr ><td width='15%' class='border-bottom'>".$row['itemcode']."</td>";
    $data.="<td width='45%' class='border-bottom'>".$row['itemname']."</td>";
    $data.="<td width='10%' style='text-align:right' class='border-bottom'>".number_format($row['quantity'],2)."</td>";
    $data.="<td width='15%' style='text-align:right' class='border-bottom'>".number_format($unitprice,2)."</td>";
    $data.="<td width='15%' style='text-align:right' class='border-bottom'>".number_format($total,2)."</td></tr>";
}
// add summaries for the payments 
$sumtotal=$overalltotal;//+$taxes;
$data.="<tr class='totals'><td colspan='4' style='text-align:right'>TOTAL :</td><td style='text-align:right'>". number_format($total,2) ."</td></tr>";
// $data.="<tr><td colspan='6' style='text-align:right'>".$taxname." :</td><td style='text-align:right'>". number_format($taxes,2) ."</td></tr>";
$data.="<tr><td colspan='4' style='text-align:right'>SUM TOTAL:</td><td style='text-align:right'>". number_format($sumtotal,2) ."</td></tr>";
$data.="</tbody></table>";

// Add payment methods

// // add terms
$data.="<h4>PAYMENT METHODS</h4>";
$data.="<table  width='100%' cellpadding='3' cellspacing='0' class='items'>
    <thead>
        <tr>
            <td style='text-align:left;' class='border-bottom'>Payment Mode</td>
            <td style='text-align:left;' class='border-bottom'>Reference</td>
            <td style='text-align:right;' class='border-bottom'>Amount</td>
        </tr>
    </thead>
    <tbody>";

$sql="CALL spgetpossalespayments('{$receiptno}')";
$rst=$db->connect()->query($sql);
$data2=$rst->fetchAll(PDO::FETCH_ASSOC);
//print_r($data2);
$amountpaid=0;
foreach($data2 as $dataitem){
    $amountpaid+=$dataitem['amount'];
    $data.= "
        <tr>
            <td class='border-bottom' style='text-align:left;'>". $dataitem['paymentmethod']."</td>
            <td class='border-bottom'>".$dataitem['reference']."</td>
            <td class='border-bottom' style='text-align:right;' ><span class='number'>".number_format($dataitem['amount'],2)."</span></td>
        </tr>";
}

// $item.="<tr><td colspan='5'><hr></td></tr>";
// Total paid 
if($amountpaid==0){
    $amountpaid= $overalltotal;
}

$balance= $amountpaid-$overalltotal;
$data.= "<tr><td style='text-align:left;' colspan='2'>TOTAL: </td><td style='text-align:right;'><span class='number'>".number_format($amountpaid,2)."</span></td></tr>";
$data.= "<tr class='items'><td style='text-align:left;' colspan='2'>BALANCE: </td><td style='text-align:right;'><span class='number'>".number_format($balance,2)."</span></td></tr>";
$data.="</tbody></table>";

$data.="<h4>TAX ANALYSIS</h4>";
$data.="<table  width='100%' cellpadding='3' cellspacing='0' class='items'>
    <thead>
        <tr>
            <td style='text-align:left;' class='border-bottom'>Tax Name (%)</td>
            <td style='text-align:left;' class='border-bottom'>Tax Value</td>
            <td style='text-align:right;' class='border-bottom'>Taxable Amount</td>
        </tr>
    </thead>
    <tbody>";

$sql="CALL spgetreceiptvatanalysis('{$receiptno}')";
$rst=$db->connect()->query($sql);
$data2=$rst->fetchAll(PDO::FETCH_ASSOC);
foreach($data2 as $dataitem){
    $tax=$dataitem['taxrate']*$dataitem['total']/(100+$dataitem['taxrate']);
    $data.="<tr>
        <td style='text-align:left;'>". $dataitem['abbreviation']." - ".($dataitem['taxrate'])."</td>
        <td style='text-align:right;' ><span class='numeric'>".number_format($tax,2)."</span></td>
        <td style='text-align:right;' ><span class='numeric'>".number_format($dataitem['total'],2)."</span></td> 
    </tr>";
// echo "<tr><td class='text-left'  colspan='2'>".$dataitem['itemname']."<td class='text-right' colspan='2'><span class='numeric'>".$dataitem['quantity']."</span> x <span class='nondecimal'>".$unitprice."</span></td></tr>";
}
$data.="</tbody></table>";
// $data.="<h4>Terms and Conditions</h4>";
// $data.="<p>".$terms."</p>";

// // add approved by heading 
// $data.="<h4>Approved By:</h4>";
// // add signatories
// $sql="CALL sp_getquotationapprovers('{$receiptno}')";
// $rst=$db->getData($sql);

// // create arrays to hold required fields
// $approvername=array();
// $approverlevel=array();
// $approverdate=array();
// $approversignature=array();

// $i=0;
// while($row=$rst->fetch()){
//    array_push($approverlevel,$row['description']);
//    array_push($approvername,$row['approvedby']);
//    array_push($approverdate,$row['approvaldate']);
//    array_push($approversignature,$row['signature']);
//    $i++;
// }

// // place the approval level headings
// $data.="<table width='100%'><tr><td>&nbsp;</td>";
// for($j=0;$j<$i;$j++){
//     $data.="<td>".$approverlevel[$j]."</td>";
// }
// $data.="</tr>";

// // add approval users names
// $data.="<tr><td>Name:</td>";
// for($j=0;$j<$i;$j++){
//     $data.="<td>".$approvername[$j]."</td>";
// }
// $data.="</tr>";

// // add approval date 
// $data.="<tr><td>Date:</td>";
// for($j=0;$j<$i;$j++){
//     $data.="<td>".$approverdate[$j]."</td>";
// }
// $data.="</tr>";

// // add approval signature 
// $data.="<tr cellpadding='5'><td>Signature:</td>";
// for($j=0;$j<$i;$j++){
//     //$data.="<td>".$approverdate[$j]."</td>";
//     $data.="<td><img src='".$approversignature[$j]."' height:50px width=100px></td>";
// }
// $data.="</tr>";
// $data.="</table>";

$data.='</body></html>';

// replace all strings in customers name with an underscore
$documentname= preg_replace('/\s+/', '_', $customername)."_".$receiptno.".pdf";

//echo $data;
$mpdf = new \Mpdf\Mpdf();
// add page number
// echo $data;
$mpdf->WriteHTML($data);
$mpdf->Output();
// $pdf=$mpdf->Output("","S");

// // compose email body parameters
// $subject="Purchase order for supply of goods/services";
// $message="Hello ".$customername."<br/><br/>Please arrange for the delivery of goods/services as detailed in the attached purchase order number <strong>".$receiptno."</strong> herein attached.<br/><br/>";
// $message.="Feel free to contact us in case there is need for any clarifications<br/><br/>";
// $message.="Kind regards.<br/><br/>".$_SESSION['username'];
// echo $mail->sendEmail($email,$subject,$message,$_SESSION['username'],'',$pdf,$documentname);
/**/
?>