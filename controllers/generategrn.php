<?php


require_once dirname(__DIR__,1) . '/vendor/autoload.php';
require_once("../models/db.php");
require_once("../models/mail.php");

$mail=new mail();
$db=new db();

$grnno=$_GET['grnno'];

// get institutional details
$sql="CALL spgetinstitutiondetails({$db->clientid})";
$rst=$db->getData($sql)->fetch();

$sql="CALL sp_getgrnheaderdetails({$db->branchid},'{$grnno}')";
$rst2=$db->getData($sql)->fetch();

$sourcename=$rst2['suppliername'];
$preparedby=$rst2['receivedby'];

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
                   
                </td>
                <td width="30%" style="text-align: right;">
                   
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
$data.="<h3 style='text-align:center;padding-top:100px;'  >GOODS RECEIVED NOTE</h3>";
    $data.="<table width='100%' style='border: 0.1mm solid #888888; padding:10px; margin-bottom:5px;'>
            <tr>
                <td width='50%'><span style='font-size: 8pt; color: #555555;'>Supplier Details:</span><br />". $rst2['suppliername']. "<br />".$rst2['physicaladdress'] ."<br />P.O Box ". $rst2['postaladdress']."<br/>Tel: ".$rst2['mobile']."</td>
                <td width='50%' style='text-align:right;'><span style='font-size: 8pt; color: #555555;'>GRN Details:</span><br />Date Received: ". $rst2['datereceived']."<br />Delivery Note #: <strong> ".strtoupper($rst2['deliverynono'])." </strong></td>
            </tr>
        </table>";
$narration=$rst2['narration'];
$email=$rst2['email'];

// get po items
$sql="CALL sp_getgrnitems({$db->branchid},'{$grnno}')";
$rst=$db->getData($sql);
    $data.="<table  width='100%' cellpadding='3' cellspacing='0' class='items' style='overflow:wrap'>
                <thead>
                    <tr>
                        <td style='text-align:left;' class='border-bottom'>#</td>
                        <td style='text-align:left;' class='border-bottom'>Item Code</td>
                        <td style='text-align:left;' class='border-bottom'>Item Name</td>
                        <td style='text-align:left;' class='border-bottom'>UoM</td>
                        <td style='text-align:right;' class='border-bottom'>Qty</td>
                        <td style='text-align:right;' class='border-bottom'>Price</td>
                        <td style='text-align:right;' class='border-bottom'>Total</td>
                        <td class='border-bottom'>PO #</td>
                    </tr>
                </thead>
                <tbody>";
// variables for holding total and taxes
$rw=1;
while($row=$rst->fetch()){

    $formatted_quantity = (float)$row['quantity'] == (int)$row['quantity'] ? number_format($row['quantity'], 0) : number_format($row['quantity'], 2);
    $formatted_price = number_format($row['unitprice'], 2);
    $formatted_total = number_format($row['quantity'] * $row['unitprice'], 2);

    $data.="<tr ><td width='5%' class='border-bottom'>".$rw."</td>";
    $data.="<td width='11.5%' class='border-bottom'>".$row['itemcode']."</td>";
    $itemname=$row['serialnos']==""?$row['itemname']:$row['itemname']." [".$row['serialnos']."]";
    $data.="<td width='40%' class='border-bottom'>".$itemname."</td>";
    $data.="<td  width='7.5%' class='border-bottom'>".$row['uom']."</td>";
    $data.="<td  width='10%' style='text-align:right' class='border-bottom'>".$formatted_quantity."</td>";
    $data.="<td  width='10%' style='text-align:right' class='border-bottom'>".$formatted_price."</td>";
    $data.="<td  width='10%' style='text-align:right' class='border-bottom'>".$formatted_total."</td>";
    //$data.="<td  width='15%' class='border-bottom'>".$row['serialnos']."</td>";
    $data.="<td  width='11%' class='border-bottom'>".$row['pono']."</td></tr>";

    $rw++;
}
$data.="</tbody></table>";

// add terms
$data.="<h4>Narration</h4>";
$data.="<p>".$narration."</p><br/><br/>";

// place the approval level headings
$data.="<table width='100%'><tr><td>&nbsp;</td>";
$data.="<td>Received By:</td>";
$data.="<td>Inspected By:</td>";
$data.="<td>Delivered By:</td>";
$data.="<td>Security:</td></tr>";

$data.="<tr><td width='10%'>Name:</td><td width='22.5%'>".$rst2['receivedby']."</td>";
$data.="<td width='22.5%'>".$rst2['inspectedby']."</td>";
$data.="<td width='22.5%'>".$rst2['deliveredby']."</td>";
$data.="<td width='22.5%'>___________________________</td></tr>";

$data.="<tr><td>Date: </td><td>".$rst2['datereceived']."</td>";
$data.="<td>".$rst2['datereceived']."</td>";
$data.="<td>".$rst2['datereceived']."</td>";
$data.="<td>".$rst2['datereceived']."</td></tr>";

// leave some space for the signature
$data.="<tr><td colspan='3'></tr><tr><td>Sign:</td><td>___________________________</td>";
$data.="<td>___________________________</td>";
$data.="<td>___________________________</td>";
$data.="<td>___________________________</td></tr>";
$data.="</table>";

$data.="<br/>";
$data.='</body></html>';

// replace all strings in suppliers name with an underscore
$documentname= preg_replace('/\s+/', '_', $sourcename)."_".$grnno.".pdf";

//echo $data;
$mpdf = new \Mpdf\Mpdf();
// add page number
//  echo $data;
//$mpdf->shrink_tables_to_fit=0;
$mpdf->WriteHTML($data);
$mpdf->Output();

?>