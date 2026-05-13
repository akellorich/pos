<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Customers </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Customers"; require_once("topbar.php"); ?>
            <!-- Page Content -->
            <div class="container-fluid">
                <div class="row mt-2">
                <!-- Filter Options -->
                <div class="col col-md-3">
                    <!-- <div class="card-body"> -->
                    <div class="row filters">
                        <div class="col">
                            <a href="#" id="addcustomer" class="btn btn-success btn-sm w-100 text-left"><i class="fas fa-user-plus fa-lg"></i>  Add Customer</a>
                            <a href="#" id="filtercustomer" class="btn btn-secondary btn-sm w-100 mt-1 text-left" data-toggle="modal" data-target="#filtercustomers"><i class="fas fa-search-plus fa-lg"></i>  Filter Customers</a>
                            <!-- <a href="#" id="cancelfilter" class="btn btn-danger btn-sm w-100 mt-1 text-left"><i class="fas fa-search-minus fa-lg"></i>  Cancel Filters</a> -->
                            <a href="#" id="deletecustomer" class="btn btn-danger btn-sm w-100 mt-1 text-left"><i class="fas fa-user-times fa-lg"></i>  Delete Customer</a>
                        </div>
                    </div>
                    <div class="row filterresults">
                        <div class="col">
                            <select name="customerslist" id="customerslist" multiple class="form-control form-control-sm list-big mt-2"></select>
                        </div>
                    </div>
                    <div class="d-flex flex-row filtercheckboxes mt-2">
                        <div class="check-group mr-3">
                            <input type="checkbox" name="regularcustomerscheckbox" id="regularcustomerscheckbox">
                            <label for="regularcustomerscheckbox" class="check-label">Regular</label>
                        </div>

                        <div class="check-group">
                            <input type="checkbox" name="onetimecustomerscheckbox" id="onetimecustomerscheckbox">
                            <label for="onetimecustomerscheckbox" class="check-label">One-time</label>
                        </div>
                    </div>
                </div>

                <!-- Details Section -->
                <div class="col" id="receiptlist">
                    <div class="containergroup card">
                        <div class="card-body">
                            <ul class="nav nav-tabs mt-1" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" data-toggle="tab" href="#info" role="tab">Biodata</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#discount" role="tab">Discounts</a>
                            </li>

                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#payment" role="tab">Payment</a>
                            </li>

                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#statement" role="tab">Statement</a>
                            </li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div class="tab-pane active" id="info" role="tabpanel">
                                <div id="errors" class="mt-2"></div>
                                <div class="card containergroup mb-2">
                                    <div class="card-header">
                                        <h5>Customer Details</h5>
                                    </div>
                                    <div class="card-body">
                                        <input type="hidden" id="id" name="id" value="0">
                                        <div class="row mt-2">
                                            <div class="col">
                                                <div class="form-group">
                                                    <label for="category">Customer Category:</label>
                                                    <select id="category" name="category"  class="form-control form-control-sm"></select>
                                                </div>
                                            </div>

                                            <div class="col form-group">
                                                <label for="mainzone">Main Zone</label>
                                                <select name="mainzone" id="mainzone" class="form-control form-control-sm"></select>
                                            </div>

                                            <div class="col form-group">
                                                <label for="subzone">Sub Zone</label>
                                                <div class="input-group">
                                                <select name="subzone" id="subzone" class="form-control form-control-sm"></select>
                                                    <div class="input-group-append">
                                                        <button class="btn btn-sm btn-secondary" id="searchzones"><i class="fal fa-search fa-lg fa-fw"></i></button>
                                                    </div>
                                                </div>
                                            
                                            </div>

                                            <div class="col form-group">
                                                <label for="pos">Home Outlet:</label>
                                                <select id="pos" name="pos"  class="form-control form-control-sm"></select>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col form-group"> 
                                                <label for="customernames">Customer Name:</label>
                                                <input type="text"   autocomplete="off" id="customername" name="customername" data-id=""  class="form-control form-control-sm">
                                            </div>

                                            <div class="col form-group"> 
                                                <label for="customertradingname">Trading Name:</label>
                                                <div class="input-group">
                                                <input type="text"   autocomplete="off" id="customertradingname" name="customertradingname"  class="form-control form-control-sm">
                                                    <div class="input-group-append">
                                                        <button class="btn btn-sm btn-secondary" id="copycustomername"><i class="fal fa-copy fa-lg fa-fw"></i></button>
                                                    </div>
                                                </div>
                                            
                                            </div>

                                            <div class="col col-md-3 form-group">
                                                <label for="idno">ID Number:</label>
                                                <input type="text" name="idno" id="idno" class="form-control form-control-sm">
                                            </div>

                                            <div class="col col-md-3 form-group">
                                                <label for="pinno">PIN Number:</label>
                                                <input type="text" name="pinno" id="pinno" class="form-control form-control-sm">
                                            </div>

                                        </div>
                                        <div class="row">                                                                           
                                            <div class="col form-group">
                                                <label for="physicaladdress">Physical Address:</label>
                                                <input type="text"   autocomplete="off" id="physicaladdress" name="physicaladdress"  class="form-control form-control-sm">
                                            </div>

                                            <div class="col form-group">
                                                <label for="postaladdress">Postal Address:</label>
                                                <input type="text"   autocomplete="off" id="postaladdress" name="postaladdress"  class="form-control form-control-sm">
                                            </div>

                                            <div class="col form-group">
                                                <label for="email">Email:</label>
                                                <input type="text"   autocomplete="off" id="email" name="email"  class="form-control form-control-sm">
                                            </div>

                                            <div class="col form-group">
                                                <label for="mobile">Mobile:</label>
                                                <input type="text"   autocomplete="off" id="mobile" name="mobile"  class="form-control form-control-sm">
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col col-md-3">
                                                <div class="form-group">
                                                    <label for="onetimecustomer">One-time Customer:</label>
                                                    <select name="onetimecusomer" id="onetimecustomer" class="form-control form-control-sm">
                                                        <option value="0">No</option>
                                                        <option value="1">Yes</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col">
                                                <div class="form-group">
                                                    <label for="openingbalance">Opening Balance</label>
                                                    <input type="text" name="openingbalance" id="openingbalance" class="form-control form-control-sm">
                                                </div>
                                            </div>
                                            <div class="col form-group">
                                                <label for="creditlimit">Credit Limit:</label>
                                                <input type="text"   autocomplete="off" id="creditlimit" name="creditlimit"  class="form-control form-control-sm">
                                            </div>
                                            <div class="col">
                                                <label for="creditterms">Credit Terms</label>
                                                <select name="creditterms" id="creditterms" class="form-control form-control-sm">
                                                    <option value="">&lt;Choose&gt;</option>
                                                    <option value="0">0</option>
                                                    <option value="15">15</option>
                                                    <option value="30">30</option>
                                                    <option value="45">45</option>
                                                    <option value="60">60</option>
                                                    <option value="75">75</option>
                                                    <option value="90">90</option>
                                                </select>
                                            </div>  
                                        </div>
                                    </div>
                                </div>
                                <div class="card containergroup mb-2">
                                    <div class="card-header">
                                        <h5>Customer Contacts</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col form-group">
                                                <label for="contactcategory">Category</label>
                                                <select name="contactcategory" id="contactcategory" class="form-control form-control-sm"></select>
                                            </div>
                                            <div class="col form-group">
                                                <label for="contactname">Contact Name</label>
                                                <input type="text" name="contactname" id="contactname" class="form-control form-control-sm">
                                            </div>
                                            <div class="col form-group">
                                                <label for="contactemail">Email</label>
                                                <input type="email" name="contactemail" id="contactemail" class="form-control form-control-sm">
                                            </div>
                                            <div class="col form-group">
                                                <label for="contactmobile">Mobile</label>
                                                <div class="input-group">
                                                <input type="number" name="contactmobile" id="contactmobile" class="form-control form-control-sm">
                                                    <div class="input-group-append">
                                                        <button class="btn btn-sm btn-secondary" id="addcustomercontact"><i class="fal fa-plus fa-lg fa-fw"></i></button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <table class="table table-sm table-striped" id="customercontactslist">
                                            <thead>
                                                <th>#</th>
                                                <th>Category</th>
                                                <th>Names</th>
                                                <th>Mobile</th>
                                                <th>Email</th>
                                                <th>&nbsp;</th>
                                                <th>&nbsp;</th>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                                <button id="savecustomer" name="savecustomer" class="btn btn-sm btn-success"><i class="fas fa-save fa-lg fa-fw"></i> Save Customer</button>
                            </div>
                                
                            <div class="tab-pane" id="discount" role="tabpanel">
                                <div id="errors2" class="mt-2"></div>
                                <table class="table table-striped table-sm mt-3" id="discounttable">
                                    <thead class="thead-light">
                                        <th>#</th>
                                        <th>Product Code</th>
                                        <th>Product Name</th>
                                        <th>Selling Price</th>
                                        <th>Discount</th>
                                        <th>Percentage</th>
                                        <th>Expires</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                    </thead>
                                    <tbody id="discountlist"></tbody>
                                    <tfoot></tfoot>
                                </table>
                                <button id="adddiscount" name="adddiscount" class="btn btn-sm btn-success mt-3" data-toggle='modal' data-target='#discountdetails'><i class="fas fa-plus-circle fa-lg fa-fw"></i> Add Discount</button>
                            </div>

                            <div class="tab-pane" id="payment" role="tabpanel">
                                <p class="lead mt-3 text-center">Open Receivables</p>
                                <div id="errors3" class="mt-2"></div>
                                <table class="table table-striped table-sm mt-3" id="openreceivables">
                                    <thead class="thead-light">
                                        <th>#</th>
                                        <th>Reference #</th>
                                        <th>Date</th>
                                        <th>Invoice Amount</th>
                                        <th>Paid</th>
                                        <th>Balance</th>
                                        <th>Amount to Pay</th>
                                    </thead>
                                    <tbody id="openreceivablelist"></tbody>
                                    <tfoot></tfoot>
                                </table>
                                <div class="row mt-2">
                                    <div class="col">
                                        <div class="form-group">
                                            <label for="modeofpayment">Mode of Payment</label>
                                            <select name="modeofpayment" id="modeofpayment" class="form-control form-control-sm"></select>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="form-group">
                                            <label for="referenceno">Reference Number</label>
                                            <input type="text"  autocomplete="off" name="referenceno" id="referenceno" class="form-control form-control-sm">
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="form-group">
                                            <label for="amountpaid">Amount Paid</label>
                                            <input type="text"   autocomplete="off" name="amountpaid" id="amountpaid" class="form-control form-control-sm">
                                        </div>
                                    </div>

                                    <div class="col">
                                        <div class="form-group">
                                            <label for="overpay">Overpay</label>
                                            <input type="text"   autocomplete="off" name="overpay" id="overpay" class="form-control form-control-sm">
                                        </div>
                                    </div> 

                                    <div class="col">
                                        <div class="form-group">
                                            
                                        </div>
                                    </div>
                                </div>
                                <button id="distribute" name="distribute" value="" class="btn btn-sm btn-secondary mt-3"><i class="fas fa-share-alt-square fa-lg fa-fw"></i> Auto Distribute</button>
                                <button id="postpayment" name="postpayment" value="" class="btn btn-sm btn-success mt-3"><i class="fas fa-coins fa-lg fa-fw"></i> Post Payment</button>
                                <button id="clear" name="clear"  class='btn btn-danger mt-3 btn-sm'><i class="fas fa-eraser fa-fw fa-lg"></i> Clear Form</button>
                            </div>

                            <div class="tab-pane" id="statement" role="tabpanel"> 
                                <div id="statementerrors" class="mt-2"></div>
                                <div class="row mt-2">
                                    <div class="col  col-md-3">
                                        <div class="form-group">
                                            <label for="startdate">Start Date</label>
                                            <input type="text"   autocomplete="off" id="startdate" name="startdate" class="form-control form-control-sm">
                                        </div>
                                    </div>
                                    <div class="col col-md-3">
                                        <div class="form-group">
                                            <label for="enddate">End Date</label>
                                            <input type="text"   autocomplete="off" id="enddate" name="enddate" class="form-control form-control-sm">
                                        </div>
                                    </div>
                                    <div class="col col-md-3">
                                        <div class="form-group">
                                            <label for="statementtype">Statement Type</label>
                                            <select name="statementtype" id="statementtype" class="form-control form-control-sm">
                                                <option value="normal">Normal</option>
                                                <option value="suspense">Suspense Account</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col col-md-2">
                                        <div class="form-group">
                                            <label for="generatereport">&nbsp;</label>
                                            <button class="btn btn-sm btn-secondary d-block" id="generatereport" name="generatereport"><i class="fas fa-chart-line fa-lg fa-fw"></i> Generate Report</button>
                                        </div>
                                    </div>
                                </div>
                                
                                <div id='report'></div>
                                <div id='customeraging'></div>
                                    
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    

    <!-- Modal for Discount Details  -->
    <div class="modal fade alert-dismissable fade" id="discountdetails">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h6  class="modal-title" >Select Discount Item</h6>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="errorsdiscount" id="errorsdiscount"></div>
                <input type="hidden" id="discountid" value="0">
                <input type="hidden" id="productid">
                    <div class="form-group">
                        <label for="itemcode">Item Code:</label>
                        <input type="text"   autocomplete="off" id="itemcode" class="form-control form-control-sm">
                        <div id="searchproducts"></div>
                    </div>

                    <div class="form-group">
                        <label for="itemname">Item Name:</label>
                        <input type="text"   autocomplete="off" id="itemname" class="form-control form-control-sm">
                    </div>

                    <div class="form-group">
                        <label for="sellingprice">Selling price:</label>
                        <input type="text"   autocomplete="off" id="sellingprice" class="form-control form-control-sm">
                    </div>
                    <div class="form-group">
                        <label for="expirydate">Expiry Date:</label>
                        <input type="text"   autocomplete="off" id="expirydate" class="form-control form-control-sm">
                    </div>

                    <div class="form-group">
                        <label for="discount">Discount Value:</label>
                        <input type="text"   autocomplete="off" id="discountvalue" class="form-control form-control-sm">
                    </div>

                    <div class="form-check">
                        <input type="checkbox" id="percentage" name="percentage" class="form-check-input">
                        <label for="percentage"   autocomplete="off" class="form-check-label">Discount is a percentage</label>
                    </div>

                </div>
            
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-success" id="savediscount"><i class="fas fa-save fa-lg fa-fw"></i> Save Discount</button>
                    <button type="button" class="btn btn-sm btn-danger" id="canceldiscount" data-dismiss="modal"><i class="fas fa-times-circle fa-lg fa-fw"></i> Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for zone and subzones  -->
    <div class="modal" tabindex="-1" role="dialog" id="zonedetailsmodal">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Filter Zone or Subzone</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table tabl-sm table-striped" id="zonesdetailstable">
                        <thead>
                            <th>#</th>
                            <th>Zone</th>
                            <th>Subzone</th>
                            <th>&nbsp;</th>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/customerdetails.js"></script>
</html>