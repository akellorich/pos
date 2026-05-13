<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Sales </title>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <?php $pagename = "Sales"; require_once("topbar.php"); ?>
        <div class="container-fluid">
            <!-- <div class="lead text-center mt-1 mb-1">Make POS Sale</div> -->
            <div class="row mt-2">
                <div class="col col col-md-3">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Step 1 - POS Sale Settings</h5>
                        </div>
                        <div class="card-body card-body-list">
                            <div class="form-group">
                                <label for="pointofsale">Point of Sale:</label>
                                <select name="pointofsale" id="pointofsale"  class="form-control form-control-sm"></select>
                            </div>
                            <div class="form-group">
                                <label for="customer">Customer:</label>
                                <select name="customer" id="customer"  class="form-control form-control-sm"></select>
                            </div>
                            <button type="button" id="addcustomer" name="addcustomer" class="btn btn-success btn-sm w-100 mt-2"><i class="fas fa-user-plus fa-lg fa-fw"></i> Add Customer</button>
                            <button type="button" id="addpayments" name="addpayments" class="btn btn-success btn-sm w-100 mt-2"><i class="fas fa-coins fa-lg fa-fw"></i> Payment</button>
                            <button type="button" id="clear" name="clear" class="btn btn-danger btn-sm w-100 mt-2"><i class="fas fa-eraser fa-lg fa-fw"></i> Clear Form</button>
                            <button type="button" id="hold" name="hold" class="btn btn-secondary btn-sm w-100 mt-2"><i class="far fa-pause-circle fa-lg fa-fw"></i> Hold Sale</button>
                            <button type="button" id="retrieve" name="retrieve" class="btn btn-secondary btn-sm w-100 mt-2"><i class="fas fa-download fa-lg fa-fw"></i> Retrieve Held</button>
                        </div>
                    </div>
                </div>
                <div class="col" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Step 2 - Select Items Sold</h5>
                        </div>
                        <div class="card-body card-body-list">
                            <div id="errors"class="mt-2"></div>
                            <div class="form-group">
                                <label for="itemcode">Item Code:</label>
                                <input type="text" name="itemcode" id="itemcode"  class="form-control form-control-sm" placeholder="Enter item code or name">
                                <div id="searchproducts"></div>
                            </div>
                            <div class="scrollable mb-3">
                                <table  id="salesitems" name="salesitems" class="table table-striped table-sm">
                                <thead class="thead-light">
                                    <tr>
                                        <th>Item Code</th>
                                        <th>Item Name</th>
                                        <th>Unit Price</th>
                                        <th>Discount</th>
                                        <th>Ext. Price</th>
                                        <th>Stock Quantity</th>
                                        <th>Quantity</th>
                                        <th>Serial #</th>
                                        <th>Line Total</th>
                                        <th>&nbsp;</th>
                                    </tr>
                                </thead>
                                <tbody id="salesitemsdetails"></tbody>
                                <tfoot>   
                                    <tr></tr>
                                </tfoot>
                                </table>
                            </div>
                            <div class="row">
                                <div class="col col-md-9">
                                    <button class="btn btn-sm btn-success" id="addbundleitems"><i class="fas fa-plus-circle fa-lg fa-fw"></i> Add Bundle Items</button>
                                </div> 
                                <div class="col col-md-3">
                                    <p id="overalltotal" class=" text-right alert alert-warning font-weight-bold">Overall Total: <span id="overalltotalamount">0.00</span></p>
                                </div>
                            </div>
                        </div>
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
        <div class="modal-dialog">
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


                    <div id="totalamount" class="alert alert-info font-weight-bold saleamountsummary">
                        <span>TOTAL AMOUNT:</span><span id="totalamountpayable" class="pull-right lead font-weight-bold">0.00</span>
                    </div>
                    <div id="totalpayments" class="alert alert-success font-weight-bold saleamountsummary">
                        <span>TOTAL PAID:</span><span id="totalpaid" class="pull-right lead font-weight-bold">0.00</span>
                    </div>
                    <div id="changedetails" class="alert alert-danger font-weight-bold saleamountsummary">
                        <span>CHANGE:</span><span id="change" class="pull-right lead font-weight-bold">0.00</span>
                    </div>

                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="chkprintlargeformat">
                        <label class="form-check-label" for="chkprintlargeformat">Print Large Format Receipt</label>
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" id="save" data-dismiss="modal">Save Sale</button>
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
                            <option value="">&lt;Choose&gt;</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm">Save Changes</button>
                    <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/makesales.js"></script>
</html>