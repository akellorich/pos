<html>
<head>
    <title>Test Printer</title>
    <meta name="viewport" content="initial-scale=1, maximum-scale=1">
    <link href="../css/jquery-ui.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/jquery.mobile-1.4.5.css" >
    <link rel="stylesheet" href="../css/customicons.css" >
    <link rel="stylesheet" href="../../css/bootstrap.css" >
    <link rel="stylesheet" href="../../css/all.css" >
    <link rel="stylesheet" href="../../css/print.min.css" >
    <link href="https://fonts.googleapis.com/css2?family=B612+Mono&display=swap" rel="stylesheet">
    
    <style>

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

    <div id="printerdetails" data-role="page">
        <div data-role="header">
            <button id="home" data-role="Button" data-icon="home" data-iconpos="notext">Home</button>
            <h1>Test Device Printer</h1>
        </div>

        <div data-role="content">
            <div class="ui-grid-b ui-responsive">
                <div class="ui-block"><a href="#" data-role="button" id="testprinter"><i class="fal fa-print fa-lg fa-fw"></i> Print Test Page</a></div>
            </div>
        </div>

        <div id="printtest" class="ticket">
            <!-- <img src="../../images/logo.png" alt="Logo"> -->
            <p class="centered">
                RECEIPT EXAMPLE
                <br>Address line 1
                <br>Address line 2
            </p>
            <table>
                <thead>
                    <tr>
                        <th class="description" colspan="2">ITEMS</th>
                    </tr>
                </thead>
                <tbody>
                    
                    <tr class='item'>
                        <td colspan="2" class="description item">Captain Morgan Gold 750</td>
                    </tr>
                    <tr>
                        <td  class='pricedescription'>2 x 1,800</td>
                        <td class='price'>3,600</td>
                    </tr>

                    <tr class='item'>
                        <td colspan="2" class="description item">Gilbey's Gin 250</td>
                    </tr>
                    <tr>
                        <td  class='pricedescription'>2 x 700</td>
                        <td class='price'>1,400</td>
                    </tr>

                    <tr class='item'>
                        <td colspan="2" class="description item">Chrome Vodka Lime 250</td>
                    </tr>
                    <tr>
                        <td  class='pricedescription'>1x 180</td>
                        <td class='price'>180</td>
                    </tr>

                    <tr class='item'>
                        <!-- <td class="quantity"></td> -->
                        <td class="item description">TOTAL</td>
                        <td class="item price">5,180</td>
                    </tr>

                    <tr>
                        <th class="description" colspan="2">PAYMENT DETAILS</th>
                    </tr>

                    <tr class='item'>
                        <!-- <td class="quantity"></td> -->
                        <td class="item description">Cash</td>
                        <td class="item price">5,180</td>
                    </tr>

                </tbody>
            </table>
            <p class="centered">Thanks for your purchase!
            <br>akellorich@gmail.com</p>
        </div>
    </div>
</body>

<script src="../js/jquery-1.12.5.js"></script>
<script src="../js/jquery.mobile-1.4.5.js"></script>
<script src="../../js/print.min.js"></script>
<script src="../js/printer.js"></script>
</html>