<?php


// require_once dirname(__DIR__,1) . '/vendor/autoload.php';

require_once __DIR__ . '/vendor/autoload.php';
require_once("models/db.php");
// require_once("../models/mail.php");

// $mail=new mail();
$db=new db();

$requisitionno=$_GET['requisitionno'];

// get institutional details
$sql="CALL spgetinstitutiondetails()";
$rst=$db->getData($sql)->fetch();
$sql="CALL `sp_getfleetrequisitionheaderdetails`('{$requisitionno}')";
$rst2=$db->getData($sql)->fetch();

$suppliername=$rst2['suppliername'];
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
                width:100px;
            }
            
        </style>
    </head>
    <body>

    <!--mpdf
    <htmlpageheader name="myheader">
        <table width="100%" >
            <tr>
                <td width="15%"><img class="logo" src="images/logo.png"></td>
                <td width="35%" style="color:#0000BB; "><span style="font-weight: bold; font-size: 14pt;">'.$rst['name'].'</span><br />'.$rst['physicaladdress'].'<br />P.O Box '.$rst['postaladdress'].'<br /><span style="font-family:dejavusanscondensed;">&#9742;</span> '.$rst['landline'].'<br />'.$rst['email'].'</td>
                <td width="50%" style="text-align: right;">Requisition No.<br /><span style="font-weight: bold; font-size: 12pt;">'.$requisitionno.'</span></td>
            </tr>
        </table>
    </htmlpageheader> 
   
    <htmlpagefooter name="myfooter"> 
        <div  id="pagefooter" >
            <div>
                Prepared By: '.$preparedby.'
            </div>

            <div>
                Page {PAGENO} of {nb}
            </div>
        </div> 
    </htmlpagefooter>
    <sethtmlpageheader name="myheader" value="on" show-this-page="1" />
    <sethtmlpagefooter name="myfooter" value="on" />
    mpdf-->
';

// document heading
$data.="<h3 style='text-align:center; padding-top:100px;'>FUEL REQUISITION</h3>";

$data.="<table width='100%' style='border: 0.1mm solid #888888; padding:10px; margin-bottom:5px;'><tr><td width='50%'>". $rst2['suppliername']. "<br />".$rst2['physicaladdress'] ."<br />P.O Box ". $rst2['postaladdress'] ." ".$rst2['postalcode']. "<br/>" .$rst2['town']. "</td>";
$data.="<td width='50%' style='text-align:right;'>Requisition Date: ". $rst2['requisitiondate']."<br />Vehicle: ". $rst2['regno']." <br/>ODO Meter Reading:". $rst2['odoreading']."<br/>Cost Center: ".$rst2['posname']."</td></tr></table>";

// create a heading for the table containing items
$data.="<table  width='100%' cellpadding='3' cellspacing='0' class='items'>
    <thead><tr>
        <td style='text-align:left;' class='border-bottom'>Product</td>
        <td style='text-align:right;' class='border-bottom'>Quantity</td>
        <td style='text-align:right;' class='border-bottom'>Unit Price</td>
        <td style='text-align:right;' class='border-bottom'>Total</td></tr>
    </thead><tbody>";
$data.="<tr ><td width='40%' class='border-bottom'>".$rst2['fueltype']."</td>";
$data.="<td width='20%' class='border-bottom' style='text-align:right;'>".$rst2['quantity']."</td>";
$data.="<td  width='20%' class='border-bottom' style='text-align:right;'>".$rst2['unitprice']."</td>";
$data.="<td  width='20%' style='text-align:right' class='border-bottom'>".number_format($rst2['quantity']*$rst2['unitprice'],2)."</td></tr>";
$data.="</tbody></table>";

// place the approval level headings
$data.="<h4>APPROVALS:</h4>";
$data.="<table width='100%'><tr><td>&nbsp;</td>";
// for($j=0;$j<$i;$j++){
    $data.="<td>Requested By:</td>";
    $data.="<td>Prepared By:</td>";
    $data.="<td>Approved By:</td>";
// }
$data.="</tr>";

// add approval users names
$data.="<tr><td>Name:</td>";
    $data.="<td>".$rst2['requestedby']."</td>";
    $data.="<td>".$rst2['preparedby']."</td>";
    $data.="<td>".$rst2['approvedby']."</td>";
$data.="</tr>";

// add approval users names
$data.="<tr><td>Date:</td>";
    $data.="<td>".$rst2['requisitiondate']."</td>";
    $data.="<td>".$rst2['requisitiondate']."</td>";
    $data.="<td>".$rst2['requisitiondate']."</td>";
$data.="</tr>";

// add approval date 
$data.="<tr><td colspan=2>&nbsp;</td><tr>";
$data.="<tr><td>Signature:</td>";
    $data.="<td>________________________________</td>";
    $data.="<td>________________________________</td>";
    $data.="<td>________________________________</td>";
$data.="</tr>";
$data.="</table>";
$data.='</body></html>';
// replace all strings in suppliers name with an underscore
$documentname= preg_replace('/\s+/', '_', $suppliername)."_".$requisitionno.".pdf";

// echo $data;
$mpdf = new \Mpdf\Mpdf();
// add page number
//echo $data;
$mpdf->WriteHTML($data);
$mpdf->Output();/**/
// $pdf=$mpdf->Output("","S");

// // compose email body parameters
// $subject="Purchase order for supply of goods/services";
// $message="Hello ".$suppliername."<br/><br/>Please arrange for the delivery of goods/services as detailed in the attached purchase order number <strong>".$pono."</strong> herein attached.<br/><br/>";
// $message.="Feel free to contact us in case there is need for any clarifications<br/><br/>";
// $message.="Kind regards.<br/><br/>".$_SESSION['username'];
// echo $mail->sendEmail($supplieremail,$subject,$message,$_SESSION['username'],'',$pdf,$documentname);
/**/
?>