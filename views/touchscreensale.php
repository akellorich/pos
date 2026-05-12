<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <link rel="stylesheet" href="../css/customerorders.css">
    <title> SalesFlow | Sales </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Sales</span>
            <div class="container-fluid">
                <div class="row">
                    <div class="col"> 
                        <div class="d-flex justify-content-between mb-3">
                            <div class="btn-group btn-group-toggle" data-toggle="buttons">
                                <label class='btn btn-secondary btn-sm active' id='cashsale'>
                                    <input type='radio' name='options'><span class='text-capitalize'>Cash Sale</span>
                                </label>
                                <label class='btn btn-secondary btn-sm' id='quotation'>
                                    <input type='radio' name='options'><span class='text-capitalize'>Quotation</span>
                                </label>
                                <label class='btn btn-secondary btn-sm' id='cashsale'>
                                    <input type='radio' name='options'><span class='text-capitalize'>Proforma Invoice</span>
                                </label>
                            </div>
                                
                            <div id="showhidetouchscreen">
                                <button class="btn btn-outline-success mr-2" id="switchtorestaurant"><i class="fal fa-concierge-bell fa-lg fa-fw"></i></button>
                                <button class="btn btn-outline-success mr-2" id="locksystem"><i class="fal fa-lock-alt fa-lg fa-fw"></i></button>
                                <button class="btn btn-outline-success mr-2" id="printersettings"><i class="fal fa-sliders-h fa-lg fa-fw"></i></button>
                                <button class="btn btn-outline-danger" id="touchscreendisplay"><i class="fal fa-eye-slash fa-lg fa-fw"></i></button>
                            </div>
                        </div>
                       
                        <div id="errors"></div>
                        <div class="row">
                            <div class="form-group col">
                                <label for="outlet">Outlet:</label>
                                <select name="outlet" id="outlet" class="form-control form-control-sm"></select>
                            </div>

                            <div class="form-group col">
                                <label for="customer">Customer:</label>
                                <select name="customer" id="customer" class="form-control form-control-sm"></select>
                            </div>

                            <div class="col form-group">
                                <label for="reference">LPO #</label>
                                <input type="text" name="reference" id="reference" class="form-control form-control-sm">
                            </div>

                            <div class="col col-md-3 form-group">
                                <label for="transactiondate">Transaction Date</label>
                                <input type="text" name="transactiondate" id="transactiondate" class="form-control form-control-sm" disabled autocomplete="off">
                            </div>
                        </div>

                        <div class="row mt-2">
                            <div class="col">
                                <div class="form-group">
                                    <label for="itemcode">Item Code:</label>
                                    <div class="input-group">
                                        <input type="text" name="itemcode" id="itemcode"  class="form-control form-control-sm"> 
                                        <div class="input-group-append">
                                            <button class="btn btn-sm btn-outline-success" id="searchproduct"><i class="fal fa-search fa-lg fa-fw"></i></button>
                                        </div>
                                    </div>
                                    
                                </div>

                                <!-- <div id="searchproducts"></div> -->
                                <div id="searchresultslist" style="display:none">
                                    <div class="searchproduct-list">
                                        <div class="searchproduct-container">
                                                <ul id="searchproductlist"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="scrollable scrollable-medium mb-2">
                            <table class="table table-sm table-striped" id="salesitemsdetails">
                                <thead>
                                    <th>Item Code</th>
                                    <th>Item Name</th>
                                    <th>Description</th>
                                    <th>Unit Price</th>
                                    <th>Discount</th>
                                    <th>Ext Price</th>
                                    <th>Stock Quantity</th>
                                    <th>Quantity</th>
                                    <th>Serial #</th>
                                    <th>Total</th>
                                    <th>&nbsp;</th> <!-- remove product -->
                                </thead>
                                <tbody></tbody>
                                <tfoot><tr></tr></tfoot>
                            </table>
                        </div>
                        
                        <!-- <div class="row">
                            <div class="col col-md-6">
                            </div> 
                        </div> -->
                        
                        <div class="d-flex justify-content-between col-md-12" id="buttonslist">
                            <div id="buttonslist" class="mr-4">
                                <button class="btn btn-success  mr-2" id="addpayments"><i class="fal fa-save fa-lg fa-fw"></i> Receive Payment <br/> <small>(F3)</small></button>
                                <button class="btn btn-outline-success btn-sm  mr-2" id="addcustomer"><i class="fal fa-users-medical fa-lg fa-fw"></i> Add New Customer</button>
                                <button class="btn btn-outline-danger btn-sm  mr-2" id="clear"><i class="fal fa-hand-sparkles fa-lg fa-fw"></i> Clear Form</button>
                                <button class="btn btn-outline-secondary btn-sm  mr-2" id="hold"><i class="fal fa-pause-circle fa-lg fa-fw"></i> Hold Sale</button>
                                <button class="btn btn-outline-secondary btn-sm mr-2" id="retrieve"><i class="fal fa-download fa-lg fa-fw"></i> Retrieve Sale</button>
                                <button class="btn btn-outline-secondary btn-sm" id="addbundleitems"><i class="fal fa-plus-circle fa-lg fa-fw"></i> Bundle Items</button>
                            </div>

                              <div >
                                <p id="overalltotal" class="lead text-right alert alert-primary font-weight-bold">Total: <span id="overalltotalamount" class='lead font-weight-bold'>0.00</span></p>
                            </div>
                        </div>
                    </div>

                    <div class="col" id="touchscreenui" style="display:none">
                        <div class="row">
                            <div class="col col-md-3" id="categories"></div>
                            <div class="col" id="products"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Modal for checking and adding mpesa transaction -->
    <div class="modal fade alert-dismissable fade" id="mpesaconfirmationmodal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h6  class="modal-title" >Select MPESA transaction ...</h6>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>  
                <div class="modal-body">
                
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="addmpesatransaction"><i class="fas fa-check-circle fa-lg fa-fw"></i> Ok</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fas fa-times-circle fa-lg fa-fw"></i> Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- End of mpesa Modal  -->
    <div class="modal fade alert-dismissable fade" id="heldsales">
        <div class="modal-dialog">
            <div class="modal-content" id="heldsalesdetails">
                <div class="modal-header">
                    <h6  class="modal-title" >Pick Held Sale to Restore</h6>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                
                </div>
            
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-sm" id="closeheldsales" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for Adding a new one time customer  -->
    <div class="modal alert-dismissable fade" id="newcustomermodal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Customer Details</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="customerdetailserrors"></div>
                    <div class="row">
                        <div class="col">
                            <div class="form-group">
                                <label for="customercategory">Category:</label>
                                <select name="customercategory" id="customercategory" class="form-control form-control-sm"></select>
                            </div>   
                        </div>

                        <div class="col">
                            <div class="form-group">
                                <label for="customername">Customer Name:</label>
                                <input type="text" name="customername" id="customername" class="form-control form-control-sm" autocomplete="false">
                            </div>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="form-group">
                                <label for="idnumber">ID Number:</label>
                                <input type="text" name="idnumber" id="idnumber" class="form-control form-control-sm" autocomplete="nope">
                            </div>   
                        </div>

                        <div class="col">
                            <div class="form-group">
                                <label for="pinnumber">PIN Number:</label>
                                <input type="text" name="pinnumber" id="pinnumber" class="form-control form-control-sm" autocomplete="nope">
                            </div>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="form-group">
                                <label for="mobilenumber">Mobile:</label>
                                <input type="text" name="mobilenumber" id="mobilenumber" class="form-control form-control-sm" autocomplete="nope">
                            </div>   
                        </div>

                        <div class="col">
                            <div class="form-group">
                                <label for="emailaddress">Email Address:</label>
                                <input type="text" name="emailaddress" id="emailaddress" class="form-control form-control-sm" autocomplete="nope">
                            </div>
                        </div>

                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savecustomer"> <i class="fas fa-save fa-lg fa-fw"></i> Save Customer</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fas fa-times-circle  fa-lg fa-fw"></i> Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for adding budle items -->
    <div class="modal fade alert-dismissable fade" id="bundleitemsmodal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h6  class="modal-title" >Please Select Bundle Items ...</h6>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>  
                <div class="modal-body">
                
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savebundleitems"><i class="fas fa-check-circle fa-lg fa-fw"></i> Done</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fas fa-times-circle fa-lg fa-fw"></i> Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for payment details -->
    <div class="modal fade alert-dismissable fade" id="payments">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <p  class="modal-title" >Please Select Payment Method(s)</p>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>  <!---->
                <div class="modal-body">
                
                    <div class="paymenterror" id="paymenterror">
                       
                    </div>
                    
                    <table class='table table-sm' id="paymentoptions">
                    </table>


                    <div id="totalamount" class="alert alert-info font-weight-bold saleamountsummary d-flex justify-contents-between align-items-center">
                        <span>TOTAL AMOUNT:</span><span id="totalamountpayable" class="pull-right lead font-weight-bold">0.00</span>
                    </div>
                    <div id="totalpayments" class="alert alert-success font-weight-bold saleamountsummary  d-flex justify-contents-between align-items-center">
                        <span>TOTAL PAID:</span><span id="totalpaid" class="pull-right lead font-weight-bold">0.00</span>
                    </div>
                    <div id="changedetails" class="alert alert-danger font-weight-bold saleamountsummary  d-flex justify-contents-between align-items-center">
                        <span>CHANGE:</span><span id="change" class="pull-right lead font-weight-bold">0.00</span>
                    </div>

                    <!-- <div class="form-check"> -->
                    <div class="row">
                        <div class="col">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="checkbox" id="chkprintreceipt">
                                    </div>
                                </div>
                                <input type="text" class="form-control form-control-sm" value="Print Receipt">
                            </div>
                        </div>

                        <div class="col">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="checkbox" id="chkprintlargeformat">
                                    </div>
                                </div>
                                <input type="text" class="form-control form-control-sm" value="Print in large format">
                            </div>
                        </div>
                    </div>

                    <div class="row mt-2">
                        <div class="col form-group">
                            <!-- <label for="sendtovault">Send to Vault?</label> -->
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="checkbox" id="sendtovault">
                                    </div>
                                </div>
                                <input type="text" class="form-control form-control-sm" value="Send to Vault?">
                            </div> 
                        </div>

                        <div class="col form-group">
                            <!-- <label for="walletid">Wallet ID / Mobile Number</label> -->
                            <input type="text" name="walletid" id="walletid" class="form-control form-control-sm" placeholder="Wallet ID or Mobile #">
                        </div>
                    </div>
                    
                        <!-- <label class="form-check-label" for="chkprintlargeformat">Print Large Format Receipt</label> -->
                    <!-- </div> -->
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success w-100" id="save" data-dismiss="modal"> <i class="fal fa-save fa-lg fa-fw"></i> Save Payment <br><small>(F4)</small></button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for Printer Settings -->
    <div class="modal" tabindex="-1" role="dialog" id="printersettingsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Printer Settings</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="printernotifications"></div>
                    <div class="form-group">
                        <label for="deviceid">Device ID</label>
                        <input type="text" name="deviceid" id="deviceid" class="form-control form-control-sm" disabled>
                    </div>
                    <div class="form-group">
                        <label for="printerconnection">Printer Connection</label>
                        <select name="printerconnection" id="printerconnection" class="form-control form-control-sm">
                            <option value="usb">USB</option>
                            <option value="bluetooth">Bluetooth</option>
                            <option value="wifi">Wi-Fi</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="printername">Printer Name</label>
                        <select name="printername" id="printername" class="form-control form-control-sm">
                            <!-- <option value="">&lt;Choose&gt;</option> -->
                            <option value="0x4843">POS-80</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="saveprinterconfig"><i class="fal fa-save fa-lg fa-fw"></i> Save Changes</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" id="testprinter"><i class="fal fa-print fa-lg fa-fw"></i> Test Printer</button>
                    <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal">Close <i class="fal fa-times fa-lg fa-fw"></i></button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Serial numbers Modal -->
    <div class="modal" tabindex="-1" role="dialog" id="serialsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title">Add Serial Numbers</h6>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div id="serialserrors"></div>
                <input type="hidden" name="serialitemid" value="" id="serialitemid">
                <div class="row">
                    <div class="col col-md-9">
                        <div class="form-group">
                            <label for="serialitemname" class="text-muted">Item Name:</label>
                            <input type="text" name="serialitemname" id="serialitemname" class="form-control form-control-sm" disabled>
                        </div>   
                    </div>

                    <div class="col">
                        <div class="form-group">
                            <label for="serialquantity" class="text-muted">Quantity:</label>
                            <input type="text" name="serialquantity" id="serialquantity" class="form-control form-control-sm" disabled>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col">
                        <label for="serialnumbers">Serial Number:</label>
                        <div class="input-group mb-3">                            
                            <select id="serialnumbers" class="form-control from-control-sm"  aria-describedby="basic-addon2"></select>
                            <div class="input-group-append">
                                <button class="btn btn-secondary btn-sm" type="button" id="saveserialnumbers"><i class="fas fa-plus-circle fa-lg fa-fw"></i></button>
                            </div>
                        </div>
                        
                    </div>
                </div>
                <table class="table table-sm table-striped" id="serialstable">
                    <thead>
                        <th>#</th>
                        <th>Serial Number</th>
                        <th>&nbsp;</th>
                    </thead>
                    <tbody></tbody>
                </table>
                <span id="serialstotals"></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success btn-sm" id="updateserials"> <i class="fas fa-check-circle fa-lg fa-fw"></i> Done</button>
                <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fas fa-times-circle  fa-lg fa-fw"></i> Close</button>
            </div>
        </div>
    </div>

    
</body>
<?php require_once("footer.txt") ?>
<script src="../plugins/receiptprinter/receipt-printer-encoder.umd.js"></script>
<script src="../plugins/receiptprinter/webbluetooth-receipt-printer.umd.js"></script>
<script src="../plugins/receiptprinter/webusb-receipt-printer.umd.js"></script>
<script src="../js/touchscreensale.js"></script>
</html>