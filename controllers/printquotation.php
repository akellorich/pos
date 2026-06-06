<?php


require_once dirname(__DIR__,1) . '/vendor/autoload.php';
require_once("../models/db.php");
require_once("../models/mail.php");

$mail=new mail();
$db=new db();

$quoteno=$_GET['quoteno'];

// get institutional details
$sql="CALL spgetinstitutiondetails({$db->clientid})";
$rst=$db->getData($sql)->fetch();

$sql="CALL sp_getquotationheaderdetails('{$quoteno}')";
$rst2=$db->getData($sql)->fetch();

$customername=$rst2['customername'];
$preparedby=$rst2['preparedby'];

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
                    <!-- Order No.<br /><span style="font-weight: bold; font-size: 12pt;">'.$quoteno.'</span> -->
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
$data.="<h3 style='text-align:center; padding-top:100px;' >QUOTATION</h3>";

$data.="<table width='100%' style='border: 0.1mm solid #888888; padding:10px; margin-bottom:5px;'><tr><td width='50%'>". $rst2['customername']. "<br />".$rst2['physicaladdress'] ."<br />P.O Box ". $rst2['postaladdress'] ." ".$rst2['postalcode']. "<br/>" .$rst2['town']."<br/>Mobile: ".$rst2['mobile']."</td>";
$data.="<td width='50%' style='text-align:right;'>Quote Number: ".$quoteno."<br/>Quote Date: ". $rst2['quotedate']."<br />Expiry Date: ". $rst2['expirydate']."</td></tr></table>";


//$terms= preg_replace("/\r\n|\r|\n/", '<br/>', $rst2['terms']);
$terms=nl2br($rst2['terms']);
$email=$rst2['email'];

// get po items
$sql="CALL sp_getquotationitems('{$quoteno}')";
$rst=$db->getData($sql);

// create a heading for the table containing items
$data.="<table  width='100%' cellpadding='3' cellspacing='0' class='items'>
    <thead>
        <tr>
            <td style='text-align:left;' class='border-bottom'>Item Code</td>
            <td style='text-align:left;' class='border-bottom'>Item Name</td>
            <td style='text-align:left;' class='border-bottom'>Description</td>
            <!-- <td style='text-align:left;' class='border-bottom'>UoM</td>
            <td style='text-align:right;' class='border-bottom'>Quantity</td>-->
            <td style='text-align:right;' class='border-bottom'>Unit Price</td>
            <!-- <td style='text-align:right;' class='border-bottom'>Total</td> -->
        </tr>
    </thead>
    <tbody>";

// variables for holding total and taxes
$total=0;
$taxes=0;

while($row=$rst->fetch()){
    $taxname=$row['taxname'];
    $data.="<tr ><td width='12.5%' class='border-bottom'>".$row['itemcode']."</td>";
    $data.="<td width='30%' class='border-bottom'>".$row['itemname']."</td>";
    $data.="<td width='30%' class='border-bottom'>".$row['description']."</td>";
    // $data.="<td width='10%' class='border-bottom'>".$row['uom']."</td>";
    // $data.="<td width='10%' style='text-align:right' class='border-bottom'>".number_format($row['quantity'],2)."</td>";
    $data.="<td width='15%' style='text-align:right' class='border-bottom'>".number_format($row['unitprice'],2)."</td></tr>";
    // $data.="<td width='15%' style='text-align:right' class='border-bottom'>".number_format($row['total'],2)."</td></tr>";
    $total+=$row['total'];
    $taxes+=$row['total']*$row['taxrate']/100;
}
// add summaries for the payments 
$sumtotal=$total+$taxes;
// $data.="<tr class='totals'><td colspan='6' style='text-align:right'>TOTAL :</td><td style='text-align:right'>". number_format($total,2) ."</td></tr>";
// $data.="<tr><td colspan='6' style='text-align:right'>".$taxname." :</td><td style='text-align:right'>". number_format($taxes,2) ."</td></tr>";
// $data.="<tr><td colspan='6' style='text-align:right'>SUM TOTAL:</td><td style='text-align:right'>". number_format($sumtotal,2) ."</td></tr>";
$data.="</tbody></table>";

// add terms
$data.="<h4>Terms and Conditions</h4>";
$data.="<p>".$terms."</p>";

// add approved by heading 
$data.="<h4>Approved By:</h4>";
// add signatories
$sql="CALL sp_getquotationapprovers('{$quoteno}')";
$rst=$db->getData($sql);

// create arrays to hold required fields
$approvername=array();
$approverlevel=array();
$approverdate=array();
$approversignature=array();

$i=0;
while($row=$rst->fetch()){
   array_push($approverlevel,$row['description']);
   array_push($approvername,$row['approvedby']);
   array_push($approverdate,$row['approvaldate']);
   array_push($approversignature,$row['signature']);
   $i++;
}

// place the approval level headings
$data.="<table width='100%'><tr><td>&nbsp;</td>";
for($j=0;$j<$i;$j++){
    $data.="<td>".$approverlevel[$j]."</td>";
}
$data.="</tr>";

// add approval users names
$data.="<tr><td>Name:</td>";
for($j=0;$j<$i;$j++){
    $data.="<td>".$approvername[$j]."</td>";
}
$data.="</tr>";

// add approval date 
$data.="<tr><td>Date:</td>";
for($j=0;$j<$i;$j++){
    $data.="<td>".$approverdate[$j]."</td>";
}
$data.="</tr>";

// add approval signature 
$data.="<tr cellpadding='5'><td>Signature:</td>";
for($j=0;$j<$i;$j++){
    //$data.="<td>".$approverdate[$j]."</td>";
    $data.="<td><img src='".$approversignature[$j]."' height:50px width=100px></td>";
}
$data.="</tr>";
$data.="</table>";

$data.='</body></html>';

// replace all strings in customers name with an underscore
$documentname= preg_replace('/\s+/', '_', $customername)."_".$quoteno.".pdf";

//echo $data;
$mpdf = new \Mpdf\Mpdf();
// add page number
// echo $data;
$mpdf->WriteHTML($data);
$mpdf->Output();
// $pdf=$mpdf->Output("","S");

// // compose email body parameters
// $subject="Purchase order for supply of goods/services";
// $message="Hello ".$customername."<br/><br/>Please arrange for the delivery of goods/services as detailed in the attached purchase order number <strong>".$quoteno."</strong> herein attached.<br/><br/>";
// $message.="Feel free to contact us in case there is need for any clarifications<br/><br/>";
// $message.="Kind regards.<br/><br/>".$_SESSION['username'];
// echo $mail->sendEmail($email,$subject,$message,$_SESSION['username'],'',$pdf,$documentname);
/**/
?>