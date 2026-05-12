<html>
<head>
<title>Make a Sale</title>
<meta name="viewport" content="initial-scale=1, maximum-scale=1">
<link href="../css/jquery-ui.css" rel="stylesheet">
<link rel="stylesheet" href="../css/jquery.mobile-1.4.5.css" >
<link rel="stylesheet" href="../../css/all.css" >
<link rel="stylesheet" href="../css/customicons.css" >

</head>
<body>

	<!--  triggered to display errors  -->
	<a id="displaygeneralerrors" href="#generalerrors" data-rel="dialog"></a>
	<!--  triggered to display save results -->
	<a id="displaygeneralnotification" href="#notificationlocation" data-rel="dialog"></a>
	<a id="savedialogdisplay" href="fuellingdetails.php#savedialoglocation" data-rel="dialog"></a>
	
    <div id="salesitemsdetails" data-role="page">
        <div data-role="header">
            <button id="salesdetailsmainmenu" data-role="Button" data-icon="home" data-iconpos="notext">Home</button>
            <h1>Make a Sale</h1>
        </div>

        <div data-role="content">
            <input type="hidden" value="0" name="saleid" id="saleid">
            <div id="outletdiv">
                <label for="outlet">Outlet:</label>
                <select name="outlet" id="outlet"  data-native-menu="false"></select>
            </div>

            <label for="customer">Customer:</label>
            <select name="customer" id="customer" data-native-menu="false">
                <option value="">&lt;Choose One&gt;</option>
            </select>

            <label for="totalsale">Total Sale:</label>
            <input type="text" name="totalsale" id="totalsale"  data-inline="true" value="0.00" readonly="readonly" >
            
            <div class="ui-grid-b ui-responsive">
                <div class="ui-block"><a href="#" data-role="button" id="addproduct"><i class="fal fa-cart-arrow-down fa-lg fa-fw"></i> Add Product</a></div>
                <!-- <button id="addproduct" class="ui-block" data-role="Button"  data-icon="plus" data-iconpos="right" data-inline="true" data-mini="true">Add Item</button> -->
            </div>
            

            <ul data-role="listview" data-inset="true" id="purchaseditems">

            </ul>

            <div class="ui-grid-b ui-responsive">
                <div class="ui-block"><a href="#" data-role="button" id="addpaymentmethod"><i class="fal fa-print fa-lg fa-fw"></i> Proceed to Payment</a></div>
                <!-- <button id="addproduct" class="ui-block" data-role="Button"  data-icon="plus" data-iconpos="right" data-inline="true" data-mini="true">Add Item</button> -->
            </div>

            <!-- <button id="addpaymentmethod" data-role="Button"  data-icon="arrow-r" data-iconpos="right"  data-inline="true">Payment</button> -->
        </div>
    </div>
    
    <div id="productsearch" data-role="page">
        <div data-role="header">
            <button id="backtosales" data-role="Button" data-icon="arrow-l" data-iconpos="notext">Back</button>
            <h1>Search Product</h1>
        </div>
        
        <div data-role="content" id="productlist">
            <ul data-role="listview" data-inset="true" data-filter="true" id="productslisted"  data-filter-placeholder="Search Item...">
            </ul>
        </div>
    </div>
    
    <div  data-role="page" id="itemdetails">
        <div data-role="header" id="itemsdetailsheading">
            <button id="productsearchmenu" data-role="Button" data-icon="arrow-l" data-iconpos="notext">Home</button>
            <h1>Item Details</h1>
        </div>
        
        <div data-role="content">
            <div data-role="fieldcontain">
                <label for="itemcode">Item Code:</label>
                <input type="text" name="itemcode" id="itemcode" value=""  readonly="readonly">
            </div> 
            
            <div data-role="fieldcontain">
                <label for="itemname">Item Name:</label>
                <input type="text" name="itemname" id="itemname" value="" readonly="readonly">
            </div> 

            <div data-role="fieldcontain">
                <label for="discount">Discount:</label>
                <input type="text" name="discount" id="discount" value=""  readonly="readonly" >
            </div> 

            <div data-role="fieldcontain">
                <label for="unitprice">Unit Price:</label>
                <input type="number" name="unitprice" id="unitprice" value=""  readonly="readonly" >
            </div> 
            
            <div data-role="fieldcontain">
                <label for="quantity">Quantity:</label>
                <input type="number" name="quantity" id="quantity" value=""  />
            </div> 

            <div data-role="fieldcontain" id="totalpricefields" style="display:none">
                <label for="totalprice">Total Price:</label>
                <input type="number" name="totalprice" id="totalprice" value=""  />
            </div> 

            <div class="ui-grid-b ui-responsive">
                <div class="ui-block"><a href="#" data-role="button" id="addproducttolist"><i class="fal fa-cart-plus fa-lg fa-fw"></i> Add to Sales List</a></div>
                <!-- <button id="addproduct" class="ui-block" data-role="Button"  data-icon="plus" data-iconpos="right" data-inline="true" data-mini="true">Add Item</button> -->
            </div>

            <!-- <div class="ui-grid-b ui-responsive">
                <div class="ui-block"><a id="addproducttolist" data-role="Button"><i class="fal fa-check-circle fa-lg fa-fw"></i> Add to List</a></div>
            </div> -->
            
        </div>
    </div>
    
    <div  data-role="page" id="generalerrors">
        <div data-role="header" id="errorsheading">
            <h1>Data Entry Error</h1>
        </div>
        
        <div data-role="content">
            <div id="dataentryerror"></div>

            <div style="text-align: center">
                <a href="#" data-role="button"  data-inline="true" id="dialogback" class="close">Close</a>
            </div>
            
        </div>
    </div>
    
    <div  data-role="page" id="notificationlocation">
        <div data-role="header" id="errorsheading">
            <h1>Save Results</h1>
        </div>
        
        <div data-role="content">
            <div id="notificationposition"></div>

            <div style="text-align: center">
                <a href="#" data-role="button"  data-inline="true" id="dialogback1" class="close">Close</a>
            </div>
            
        </div>
    </div>
    
    <div id="savedialoglocation" data-role="page">
        <div data-role="header">
            <h1>Notification</h1>
        </div>
    
        <div data-role="content">
            <div id="savedialogmessage">
            
            </div>
            
            <div style="text-align: center">
                <a href="button" id="closesavedialog"  data-inline="true" data-role="button">Close</a>
            </div>
            
        </div>
    </div>

    <div id="confirmitemremoval" data-role="page" data-dialog="true">
        <div data-role="header">
            <h1>Remove Item</h1>
        </div>
    
        <div data-role="content">
            <div id="removeitemmessage">

            </div>
            
            <div style="text-align: center">
                <a href="button" id="removeitemno"  data-inline="true" data-role="button">No, Keep Item</a>
                <a href="button" id="removeitemyes"  data-inline="true" data-role="button">Yes, Remove</a>    
            </div>
            
        </div>
    </div>

    <div  data-role="page" id="paymentmethods">
        <div data-role="header" id="paymentmethoddetails">
            <button id="paymentmethodsback" data-role="Button" data-icon="arrow-l" data-iconpos="notext">Back</button>
            <h1>Payment Methods</h1>
        </div>
        
        <div data-role="content">
            <div id="paymentmethodslist" class="ui-grid-b">
               
            </div>
            <div id="amounts">
                <div id="amountdue" class="totaltext">
                    Amount Due:     <span class="amountdue">0.00</span>
                </div>

                <div id="amountpaid" class="totaltext">
                    Amount Paid:    <span class="amountpaid">0.00</span>
                </div>

                <div id="balance" class="totaltext">
                   Balance:     <span class="balancedue">0.00</span>
                </div>
            </div>
            <div>
                <div class="ui-grid-b ui-responsive">
                    <div class="ui-block">
                        <a href="#" data-role="button" id="savesale"><i class="fal fa-save fa-lg fa-fw"></i> Save Sale</a>
                        <a href="#" data-role="button" id="connectprinter"><i class="fal fa-print-search fa-lg fa-fw"></i> Connect Printer</a>
                    </div>
                    <!-- <button id="addproduct" class="ui-block" data-role="Button"  data-icon="plus" data-iconpos="right" data-inline="true" data-mini="true">Add Item</button> -->
                </div>

                <!-- <div class="ui-grid-b ui-responsive">
                    <div class="ui-block">
                        <a href="#" data-role="button"  data-inline="true" id="savesale"  class="close"><i class="fal fa-save fa-lg fa-fw"></i> Save Sale</a>
                    </div>
                </div> -->
            </div>
        </div>
    </div>
</body>

<script type="text/javascript" src="../js/jquery-1.12.5.js"></script>
<script src="../js/jquery-ui.js"></script>
<script type="text/javascript" src="../js/jquery.mobile-1.4.5.js"></script>
<script type="text/javascript" src="../../js/jquery.number.js"></script>
<script type="text/javascript" src="../js/functions.js"></script>
<script src="../../plugins/receiptprinter/receipt-printer-encoder.umd.js"></script>
<script src="../../plugins/receiptprinter/webbluetooth-receipt-printer.umd.js"></script>
<script type="text/javascript" src="../js/sales.js"></script>
</html>