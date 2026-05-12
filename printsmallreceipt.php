<?php

    // require_once __DIR__ . '/vendor/autoload.php';

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
    <link rel="stylesheet" href="../css/print.min.css" >
    <title>Customer Payment Receipt</title>
    <style>

        .text-center{text-align: center;}
        .text-right{text-align: right;}
        .text-left{text-align: left;}

        td.item,
        th,
        tr.item,
        table {
            font-size: 1rem;
            border-top: 1px solid black;
            border-collapse: collapse;
        }

        td.description,
        th.description {
            width: 219px;
            max-width: 219px;
            text-align:left;
        }

        td.quantity,
        th.quantity {
            width: 50px;
            max-width: 50px;
            word-break: break-all;
            text-align:right;
        }

        td.price,
        th.price {
            width: 60px;
            max-width: 60px;
            word-break: break-all;
            text-align:right;
        }

        td.pricedescription{
            width:70%;
            word-break: break-all;
            text-align:left;
        }

        .centered {
            text-align: center;
            align-content: center;
        }

        .ticket {
            width: 210px;
            max-width: 210px;
        }

        img {
            max-width: inherit;
            width: inherit;
        }

        @media print {
            *{
                font-family: 'Times New Roman';
                font-size: 0.8rem;
                
            }
            .hidden-print,
            .hidden-print * {
                display: none !important;
            }
        }
    </style>
</head>

<body>
    <div id="printreceipt" class="ticket">
        <!-- <img src="../../images/logo.png" alt="Logo"> -->
        <p class="centered">
            <?=$data['name'] ?>
            <!-- <br/><?=$data['physicaladdress'];?>
            <br/><?='P.O Box '.$data['postaladdress'];?>
            <br/><?=$data['landline'];?> -->
            <br/><?=$data['email'];?>
            <br/><?=$data['pinno'];?>

            <br/>Receipt #:<?=$data1['receiptno'];?>
            <br/>Date: <?=$data1['receiptdate'];?>
            <br/>Customer:<?=$data1['customername'];?>
        </p>

        <table>
            <thead>
                <tr>
                    <th class="description" colspan="2">ITEMS</th>
                </tr>
            </thead>
            <tbody>

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

                        echo "
                        <tr class='item'>
                            <td colspan='2' class='description item'>".$dataitem['itemname']."</td>
                        </tr>
                        <tr>
                            <td  class='pricedescription'><span class='numeric'>".$dataitem['quantity']."</span> x <span class='nondecimal'>".$unitprice."</span></td>
                            <td class='price'><span class='nondecimal text-right'>".$total."</span></td>
                        </tr>
                        ";

                        
                    }
                    if($amountpaid==0){
                        $amountpaid= $overalltotal;
                    }
                ?>  
                
                <tr class='item'>
                    <td class="item description">TOTAL</td>
                    <td class="item price text-right"><span class='nondecimal'><?=$overalltotal ?></span></td>
                </tr>

                <tr>
                    <th class="description" colspan="2">PAYMENT DETAILS</th>
                </tr>
                
                <?php
                    $sql="CALL spgetpossalespayments('{$receiptno}')";
                    $rst=$db->connect()->query($sql);
                    $data2=$rst->fetchAll(PDO::FETCH_ASSOC);
                    $amountpaid=0;
                    foreach($data2 as $dataitem){
                        $amountpaid+=$dataitem['amount'];
                        // echo "<tr><td class='text-left'>". $dataitem['paymentmethod']."<td class='text-center'>".$dataitem['reference']." </td><td class='text-right'><span class='nondecimal'>".$dataitem['amount']."</span></td></tr>";
                        echo "
                        <tr class='item'>
                            <td class='item description'>".$dataitem['paymentmethod']."</td>
                            <td class='item price text-right'> <span class='nondecimal'>".$dataitem['amount']."</span></td>
                        </tr>";
                    }   

                    echo "
                        <tr>
                            <td colspan='32'><hr></td>
                        </tr>
                        <tr>
                            <td class='text-left'>TOTAL PAID:</td>
                            <td class='text-right'><span class='nondecimal'>".$amountpaid."</span></td>
                        </tr>";
                    $balance=$amountpaid-$overalltotal;
                ?>
                <tr>
                    <td>BALANCE:</td>
                    <td id='balance' class='text-right'><span class='nondecimal'><?=$balance; ?></span></td>
                </tr>
            </tbody>
        </table>
        <p class="centered">
            <span id="notes">
                Thank you for shopping with us
            </span>
        <br>Served by: <?=$servedby ?></p>
    </div>

</body>
<script type="text/javascript" src="js/jquery-2.2.4.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.number.js"></script>
<script src="js/print.min.js"></script>

<script type="text/javascript">
$(document).ready(function(){
   
    // format all number fields
    const numericfields = $(".numeric")
    numericfields.each(function(){
        if(parseFloat($(this).text())){
            $(this).text($.number($(this).text(),2))
        }
    })

    const nondecimalfields=$(".nondecimal")
    nondecimalfields.each(function(){
        if(parseFloat($(this).text())){
            $(this).text($.number($(this).text()))
        }
    })

    printJS({ 
        printable: 'printreceipt', 
        type: 'html', 
        width:219,
        css:"mobi/views/receipt58mm.css"
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
            }
        )
       window.close();
    };

    setTimeout(function(){
        $(window).on('mousemove', window.onafterprint);
    }, 1);/**/

})
</script>
</html>