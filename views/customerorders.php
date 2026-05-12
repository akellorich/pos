<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <link rel="stylesheet" href="../css/customerorders.css">
    <title> SalesFlow | Orders </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Orders</span>
            <!-- Page Content -->
            <div class="container-fluid">
                <!-- Add tabbed dialogue for Order details, list and settlement -->
                <nav class="nav-justified ">
                    <div class="nav nav-tabs " id="nav-tab" role="tablist">
                        <a class="nav-item nav-link active" id="orderdetails-tab" data-toggle="tab" href="#orderdetails" role="tab" aria-controls="pop1" aria-selected="true">Make Order</a>
                        <a class="nav-item nav-link" id="orderslist-tab" data-toggle="tab" href="#orderslist" role="tab" aria-controls="orderslist" aria-selected="false">Settle Bill</a>
                        <!-- <a class="nav-item nav-link" id="ordersettlement-tab" data-toggle="tab" href="#ordersettlement" role="tab" aria-controls="ordersettlement" aria-selected="false">Settlement</a> -->
                    </div>
                </nav>

                <div class="tab-content text-left" id="nav-tabContent">
                    <!-- Order Details Tab -->
                    <div class="tab-pane fade show active" id="orderdetails" role="tabpanel" aria-labelledby="pop1-tab">
                        <div class="pt-4"></div>
                        <div id="ordernotifications"></div>
                        <div class="flex-container">
                            <div id="orderdetails" class="flex-item-70">
                                <div class="row">
                                    <div class="col form-group">
                                        <label for="outlet">Outlet</label>
                                        <select name="outlet" id="outlet" class="form-control form-control-sm">
                                            <option value="0">&lt;Choose&gt;</option>
                                        </select>
                                    </div>

                                    <div class="col form-group">
                                        <label for="table">Table</label>
                                        <select name="table" id="table" class="form-control form-control-sm">
                                            <option value="0">&lt;Choose&gt;</option>
                                        </select>
                                    </div>

                                    <div class="col form-group">
                                        <label for="customer">Customer</label>
                                        <select name="customer" id="customer" class="form-control form-control-sm">
                                            <option value="0">&lt;Choose&gt;</option>
                                        </select>
                                    </div>

                                    <div class="col form-group">
                                        <label for="orderdate">Order Date</label>
                                        <input type="text" name="orderdate" id="orderdate" class="form-control form-control-sm">
                                    </div>
                                </div>
                            </div>
                            <div id="buttonslist" class="flex-item-30">
                                <button class="btn btn-lg btn-outline-success mr-2" id="switchtoretail"><i class="fal fa-shopping-cart fa-lg fa-fw"></i></button>
                                <button class="btn btn-lg btn-outline-success mr-2" id="lockscreen"><i class="fal fa-lock-alt fa-lg fa-fw"></i></button>
                                <button class="btn btn-lg btn-outline-success mr-2" id="touchscreen"><i class="fal fa-bullseye-pointer fa-lg fa-fw"></i></button>
                                <button class="btn btn-lg btn-outline-success" id="printersettings"><i class="fal fa-sliders-h fa-lg fa-lg"></i></button>
                            </div>  
                        </div>

                        <div class="row">
                            <div class="col">
                                 <div class="form-group">
                                    <label for="itemcode">Item Code or Name</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control form-control-sm" id="searchfield">
                                        <div class="input-group-append">
                                            <button class="btn btn btn-sm btn-outline-success" id="searchproduct"><i class="fal fa-search fa-lg fa-fw"></i></button>
                                        </div>
                                    </div>
                                </div> 

                                <div id="searchresultslist" style="display:none">
                                    <div class="searchproduct-list">
                                        <div class="searchproduct-container">
                                                <ul id="searchproductlist"></ul>
                                        </div>
                                    </div>
                                </div>
                            
                                <div class="scrollabletable mb-2">
                                    <table class="table table-striped table-hover" id="orderitemstable">
                                        <thead>
                                            <th>#</th>
                                            <th>Product Code</th>
                                            <th>Product Name</th>
                                            <!-- <th>Unit of Measure</th> -->
                                            <th>Unit Price</th>
                                            <th>Quantity</th>
                                            <th>Line Total</th>
                                            <th>&nbsp;</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>    
                                
                                <div class="flex-container">
                                    <div class="flex-item-70">
                                        <button class="btn btn-success mr-3" id="savecustomerorder"> <i class="fal fa-save fa-lg fa-fw"></i> Save Order</button>
                                        <button class="btn btn-outline-danger" id="clearbutton"><i class="fal fa-hand-sparkles fa-lg fa-fw"></i> Clear Fields</button>
                                    </div>
                                    <div class="flex-item-30 alert alert-primary total">
                                        <div class='text-right font-weight-bold'>Total: <span id="ordertotal">0.00</span></div>
                                        <!-- <div id="ordertotal">0.00</div> -->
                                    </div>
                                </div>
                                <!-- </div> -->
                            </div>

                            <div class="col col-md-5" style="display:none" id="touchui">
                                <!-- Add Categories -->
                                <div class="row">
                                    <!-- Category List (20%) -->
                                    <div class="col-3 p-3 bg-light category-list">
                                        <div id="categorybuttons"></div>
                                    </div>

                                    <!-- Product List (80%) -->
                                    <div class="col-9 p-3 productlist">
                                        <div class="row" id="productlist">
                                            <!-- Example Product Cards -->
                                            <!-- <div class="col-4 mb-3">
                                                <div class="product-card">
                                                    <img src="../images/noimage.jpg" alt="Product Image">
                                                    <h5>Product 1</h5>
                                                    <p>$10.00</p>
                                                </div>
                                            </div> -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Order List Tab -->
                    <div class="tab-pane fade " id="orderslist" role="tabpanel" aria-labelledby="pop1-tab">
                        <div class="pt-3"></div>
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Filter Options</h5>
                            </div>
                            <div class="card-body">
                                <div id="filternotifications"></div>
                                <div class="row">
                                    <div class="col col-md-1 form-group">
                                        <label for="filterdaterange">Date Range</label>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox"  id="filterdaterange" checked>
                                            <label class="form-check-label" for="filterdaterange">
                                                All dates?
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col from-group">
                                        <label for="filterstartdate">Start Date</label>
                                        <input type="text" name="filterstartdate" id="filterstartdate" class="form-control form-control-sm" disabled autocomplete="off">
                                    </div>
                                    <div class="col form-group">
                                        <label for="filterenddate">End Date</label>
                                        <input type="text" name="filterenddate" id="filterenddate" class="form-control form-control-sm" disabled autocomplete="off">
                                    </div>

                                    <div class="col form-group">
                                        <label for="filterpos">Point of Sale</label>
                                        <select name="filterpos" id="filterpos" class="form-control form-control-sm">
                                            <option value="0">&lt;All&gt;</option>
                                        </select>
                                    </div>

                                    <div class="col form-group">
                                        <label for="filtertable">Table</label>
                                        <select name="filtertable" id="filtertable" class="form-control form-control-sm">
                                            <option value="0">&lt;All&gt;</option>
                                        </select>
                                    </div>

                                    <div class="col form-group">
                                        <label for="filterwaiter">Waiter</label>
                                        <select name="filterwaiter" id="filterwaiter" class="form-control form-control-sm">
                                            <option value="0">&lt;All&gt;</option>
                                        </select>
                                    </div>

                                    <div class="col form-group">
                                        <label for="filterstatus">Status</label>
                                        <div class="input-group">
                                            <select name="filterstatus" id="filterstatus" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="open">Open</option>
                                                <option value="paid">Paid</option>
                                                <option value="cancelled">Cancelled</option>
                                            </select>
                                            <div class="input-group-append">
                                                <button class="btn btn-sm btn-outline-success" id="filterorderslist"><i class="fal fa-sync-alt fa-lg fa-fw"></i></button>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                                <table class="table table-sm table-striped table-hover" id="orderslisttable">
                                    <thead> 
                                        <th><input type="checkbox" name="selectallorders" id="selectallorders"></th>
                                        <th>#</th>
                                        <th>Date</th>
                                        <th>Order #</th>
                                        <th>POS</th>
                                        <th>Customer</th>
                                        <th>Table</th>
                                        <th>Order Amount</th>
                                        <th>Waiter</th>
                                        <th>Status</th>
                                        <th>&nbsp;</th><!-- View Order Details -->
                                        <th>&nbsp;</th><!-- Reprint Bill -->
                                        <th>&nbsp;</th><!-- Reprint KOT -->
                                        <th>&nbsp;</th><!-- Cancel Order -->
                                    </thead>
                                    <tbody></tbody>
                                    <tfoot></tfoot>
                                </table>
                                <button class="btn btn-success mt-3" id="settlebills"><i class="fal fa-wallet fa-fw fa-lg"></i> Settle Selected Bills</button>
                            </div>
                        </div>
                    </div>

                    <!-- Order Settlement Tab -->
                    <!-- <div class="tab-pane fade " id="ordersettlement" role="tabpanel" aria-labelledby="pop1-tab">
                        <div class="pt-3"></div>
                        <p>Order Settlement</p>
                    </div> -->
                </div>   
            </div>
        </div>
    </section>

    

    <!-- Modal for Settling Order and Creating Receipt -->
    <div class="modal fade alert-dismissable fade" id="payments">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <p  class="modal-title" >Please Select Payment Method(s)</p>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>  <!---->
                <div class="modal-body">
                
                    <div class="paymentdetailsnotifications" id="paymentdetailsnotifications">
                       
                    </div>
                    
                    <table class='table table-sm' id="paymentoptions">
                    </table>


                    <div id="totalamount" class="alert alert-info  saleamountsummary d-flex justify-contents-between align-items-center">
                        <span>TOTAL AMOUNT:</span><span id="totalamountpayable" class="pull-right lead font-weight-bold ">0.00</span>
                    </div>
                    <div id="totalpayments" class="alert alert-success  saleamountsummary  d-flex justify-contents-between align-items-center">
                        <span>TOTAL PAID:</span><span id="totalpaid" class="pull-right lead font-weight-bold">0.00</span>
                    </div>
                    <div id="changedetails" class="alert alert-danger  saleamountsummary  d-flex justify-contents-between align-items-center">
                        <span>CHANGE:</span><span id="change" class="pull-right lead font-weight-bold">0.00</span>
                    </div>

                    <!-- <div class="form-check"> -->
                    <!-- <div class="input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <input type="checkbox" id="chkprintlargeformat">
                            </div>
                        </div>
                        <input type="text" class="form-control form-control-sm" value="Print in large format">
                    </div> -->
                        <!-- <label class="form-check-label" for="chkprintlargeformat">Print Large Format Receipt</label> -->
                    <!-- </div> -->
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" id="saveorderpayment" data-dismiss="modal"> <i class="fal fa-print fa-lg fa-fw"></i> Save and Print Receipt</button>
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

    <!-- Modal for Order details -->
    <div class="modal" tabindex="-1" role="dialog" id="orderdetailsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Order Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-sm table-striped table-hover" id="orderdetailstable">
                        <thead>
                            <th>Item Name</th>
                            <th class='text-right'>Quantity</th>
                            <th class='text-right'>Unit Price</th>
                            <th class='text-right'>Total</th>
                        </thead>
                        <tbody></tbody>
                        <tfoot></tfoot>
                    </table>
                </div>
    
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script src="../plugins/jsrsasign-all-min.js"></script>
<script src="../plugins/sign-message.js"></script>
<script src="../js/customerorders.js"></script>
</html>