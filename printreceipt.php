<?php
require_once __DIR__ . '/vendor/autoload.php';
require_once "models/db.php";
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

    // get institution details

    $generator = new Picqer\Barcode\BarcodeGeneratorPNG();


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
    </div><br/>
    
    <div style="text-align: center; margin-bottom:3px">
        <?php 
            echo '<img src="data:image/png;base64,' . base64_encode($generator->getBarcode($receiptno, $generator::TYPE_CODE_128)) . '">';
            echo "<br/>*".$receiptno.'*';
        ?>
    </div>
   
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
            $sql="CALL spgetreceiptdetails('{$receiptno}')";
            $rst=$db->connect()->query($sql);
            $data1=$rst->fetchAll(PDO::FETCH_ASSOC);
            $overalltotal=0;
            $amountpaid=0;

            foreach($data1 as $dataitem){
                $unitprice=$dataitem['unitprice']-$dataitem['discount'];
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
            <td colspan='2'><b>TOTAL DUE:</b></td>
            <td id='total' class='text-right'><b><span class='nondecimal'><?=$overalltotal?></span></b></td>
        </tr>
        <tr><td colspan='3'><hr></td></tr>
        <tr><td colspan='3'><b>PAYMENT METHODS</b><hr></td></tr>
        <?php
            // get payment methods
            $sql="CALL spgetpossalespayments('{$receiptno}')";
            $rst=$db->connect()->query($sql);
            $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
            $amountpaid=0;
            foreach($data2 as $dataitem){
                $amountpaid+=$dataitem['amount'];
                echo "<tr><td class='text-left'>". $dataitem['paymentmethod']."<td class='text-center'>".$dataitem['reference']." </td><td class='text-right'><span class='nondecimal'>".$dataitem['amount']."</span></td></tr>";
            }    
            echo "<tr><td colspan='3'><hr></td></tr><tr><td class='text-left' colspan='2'><b>TOTAL PAID:</b></td><td class='text-right'><b><span class='nondecimal'>".$amountpaid."</span></b></td></tr>";
            $balance=$amountpaid-$overalltotal;
        ?>
        <tr>
            <td><b>BALANCE:</b></td>
            <td id='balance' class='text-right' colspan='2'><b><span class='numeric'><?=$balance; ?></span></b></td>
        </tr>

        <tr><td colspan='3'><hr></td></tr>
        <tr><td colspan='3'><b>VAT ANALYSIS</b><hr></td></tr>
        <!-- Generate VAT summary -->
        <tr>
            <td><b>CODE (%)</b></td>
            <td class='text-right'><b>AMOUNT</b></td>
            <td class='text-right'><b>VAT</b></td>
        </tr>
        <tr><td colspan="4"><hr></td></tr>
            
        <?php
        // get vat summary
        $sql="CALL spgetreceiptvatanalysis('{$receiptno}')";
        $rst=$db->connect()->query($sql);
        $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
        foreach($data2 as $dataitem){
            $tax=$dataitem['taxrate']*$dataitem['total']/(100+$dataitem['taxrate']);
            echo "<tr><td class='text-left'>". $dataitem['abbreviation']." - ".($dataitem['taxrate'])."</td><td class='text-right'><span class='numeric'>".(number_format($dataitem['total']))."</span></td><td class='text-right'><span class='numeric'>".number_format($tax,2)."</span></td></tr>";
            // echo "<tr><td class='text-left'  colspan='2'>".$dataitem['itemname']."<td class='text-right' colspan='2'><span class='numeric'>".$dataitem['quantity']."</span> x <span class='nondecimal'>".$unitprice."</span></td></tr>";
        }
        ?>
       
        <div id='receiptfooter'>
            <tr>
                <td colspan="3"><hr><strong>MPESA TILL Number: 4653064</strong><br>Thanks for shopping with us. Please come again. Goods once sold are not returnable or refundable.<hr></td>
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
})
</script>
</html>