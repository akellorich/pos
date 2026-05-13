<!DOCTYPE html>
<html lang="en" dir="ltr">
    <head>
        <?php require_once("header.txt") ?> 
        <title> SalesFlow | Quotations </title>
    </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Quotations"; require_once("topbar.php"); ?>
            <div class="container-fluid containergroup">
                <div class="row">
                    <div class="col col-md-3">
                        <div class="card filteroptions mt-2">
                            <div class="card-header">
                                <h5>Filter Options</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div id="errordiv1"></div>
                                <div class="form-group">
                                    <label for="customer">Customer</label>
                                    <select name="customer" id="customer" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group form-check">
                                    <input type="checkbox" name="alldates" id="alldates" class="form-check-input">
                                    <label for="alldates" class="form-check-label">All Date</label>
                                </div>

                                <div class="form-group">
                                    <label for="startdate"><span id="startdatelabel">Start date</span></label>
                                    <input type="text" name="startdate" id="startdate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="enddate"><span id="enddatelabel">End date</span></label>
                                    <input type="text" name="enddate" id="enddate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="status">Status</label>
                                    <select name="status" id="status" class="form-control form-control-sm">
                                        <option value="all">&lt;All&gt;</option>
                                        <option value="valid">Valid</option>
                                        <option value="cancelled">Cancelled</option>
                                    </select>
                                </div>
                            
                                <button class="btn btn-sm btn-secondary" id="filterquotationsbutton"><i class="fal fa-filter fa-lg fa-fw"></i> Apply Filter</button>
                            
                                <button class="btn btn-success btn-sm " id="addnewquotationbutton"><i class="fal fa-plus-circle fa-lg fa-fw"></i> Add Quotation</button>

                            </div>
                        </div>
                    </div>
                    
                    <div class="col">
                        <div class="card mt-2" id="receiptlist">
                            <div class="card-header">
                                <h5>Quotations in the System</h5>
                            </div>
                            <div class="card-body card-body-list scrollable-y">
                                <div id="purchaseordererrors"></div>
                                <div id="quotationslist">
                                    <table class="table table-sm table-striped" id="quotationslist">
                                        <thead>
                                            <th>#</th>
                                            <th>Date</th>
                                            <th>Quote #</th>
                                            <th>Category</th>
                                            <th>Customer</th>
                                            <th>Value</th>
                                            <th>Status</th>
                                            <th>&nbsp;</th><!-- Edit -->
                                            <th>&nbsp;</th><!-- Approve -->
                                            <th>&nbsp;</th><!-- Reject -->
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                                
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Modal for Adding an new quotation  -->
    <div class="modal" tabindex="-1" role="dialog" id="addnewquotationmodal">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Add Quotation</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <nav class="nav-justified ">
                        <div class="nav nav-tabs" id="specialprivileges-tab" role="tablist">
                            <a class="nav-item nav-link active" id="pop-general" data-toggle="tab" href="#generalquotation" role="tab" aria-controls="pop1" aria-selected="true">General</a>
                            <a class="nav-item nav-link" id="pop-corrugatedbox" data-toggle="tab" href="#corrugatedboxquotation" role="tab" aria-controls="pop2" aria-selected="false">Corrugated Box</a>
                        </div>
                    </nav>
                    <!-- Tab Content  -->
                    <div class="tab-content text-left" id="nav-tabContent"> 
                        <!-- Requisition privileges tab  -->
                        <div class="tab-pane fade show active" id="generalquotation" role="tabpanel" aria-labelledby="pop1-general">
                            <div class="pt-3"></div>
                            <div id="errordiv"></div>
                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="newquotecustomer">Customer</label>
                                        <select name="" id="newquotecustomer" class="form-control form-control-sm"></select>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="form-group">
                                        <label for="newquoteterms">Terms</label>
                                        <select name="newquoteterms" id="newquoteterms" class="form-control form-control-sm"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col">
                                        <div class="form-group">
                                            <label for="newquoteitem">Item</label>
                                            <input type="text" name="newquoteitem" id="newquoteitem" class="form-control form-control-sm">
                                            <div id="searchproducts" style="z-index:1000;"></div>
                                        </div>
                                        
                                    </div>
                                <div class="col">
                                    <label for="newquotedescription">Description</label>
                                    <input type="text" name="newquotedescription" id="newquotedescription" class="form-control form-control-sm">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col">
                                    <label for="newquotequantity">Quantity</label>
                                    <input type="number" name="newquotequantity" id="newquotequantity" class="form-control form-control-sm">
                                </div>
                                <div class="col">
                                    <label for="newquoteunitprice">Unit Price</label>
                                    <div class="input-group mb-3">
                                            <input type="number" name="newquoteunitprice" id="newquoteunitprice" class="form-control form-control-sm">
                                            <div class="input-group-append">
                                                <button class="btn btn-sm btn-secondary" id="additemtolist"><i class="fas fa-plus-circle fa-lg"></i></button>
                                            </div>
                                        </div>
                                    
                                </div>
                            </div>

                            <table class="table table-sm table-striped mt-2" id="quotationitems">
                                <thead>
                                    <th>#</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Quantity</th>
                                    <th>Unit Price</th>
                                    <th>Total</th>
                                    <th>&nbsp</th> <!-- Delete -->
                                </thead>
                                <tbody></tbody>
                            </table>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-success btn-sm" id="savequotation"><i class="fal fa-save fa-lg fa-fw"></i> Save Quotation</button>
                                <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fal fa-times fa-lg fa-fw"></i> Close</button>
                            </div>
                        </div>
                        <!-- Purchase Order privileges tab  -->
                        <div class="tab-pane fade" id="corrugatedboxquotation" role="tabpanel" aria-labelledby="pop2-corrugatedbox">
                            <div class="pt-3"></div>
                            <div id="corrugatederrors"></div>
                            <div class="row">
                                <div class="col form-group">
                                    <label for="corrugatedcustomer">Customer</label>
                                    <select name="corrugatedcustomer" id="corrugatedcustomer" class="form-control form-control-sm"></select>
                                </div>

                                <div class="col from-group">
                                    <label for="corrrugatedproducts">Item name</label>
                                    <select name="corrrugatedproducts" id="corrrugatedproducts" class="form-control form-control-sm"></select>
                                </div> 
                                <div class="col form-group">
                                    <label for="reelcost">Reel Cost(Per KG)</label>
                                    <input type="number" name="reelcost" id="reelcost" class="form-control form-control-sm">
                                </div>
                                <div class="col ">
                                    <div class="row">
                                        <div class="col form-group">
                                            <label for="gsm">GSM</label>
                                            <select name="gsm" id="gsm" class="form-control form-control-sm"></select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="noofplies">Plies</label>
                                            <select name="noofplies" id="noofplies" class="form-control form-control-sm">
                                                <option value="0">&lt;Choose&gt;</option>
                                                <option value="3">3</option>
                                                <option value="5">5</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                            <div class="row">
                                
                                
                                <div class="col form-group">
                                    <label for="length">Length(mm)</label>
                                    <input type="number" name="length" id="length" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="width">Width(mm)</label>
                                    <input type="number" name="width" id="width" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="height">Height(mm)</label>
                                    <input type="number" name="height" id="height" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="noofunits">Number of Units</label>
                                    <input type="number" name="noofunits" id="noofunits" class="form-control form-control-sm">
                                </div>
                                
                            </div>

                            <div class="row">
                                <div class="col form-group">
                                    <label for="jointallowance">Joint Allowance</label>
                                    <input type="number" name="jointallowance" id="jointallowance" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="trimmingallowance">Trimming Allowance</label>
                                    <input type="number" name="trimmingallowance" id="trimmingallowance" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="flutefactor">Flute Factor</label>
                                    <input type="number" name="flutefactor" id="flutefactor" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="waste">Waste(%)</label>
                                    <input type="number" name="waste" id="waste" class="form-control form-control-sm">
                                </div>
                            </div>
                            <div class="row">
                                 <div class="col form-group">
                                    <label for="profitmargin">Profit Margin</label>
                                    <input type="number" name="profitmargin" id="profitmargin" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="printing">Origination <span class="small">(Printing, dicut etc)</span> </label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text">
                                            <input type="checkbox" id="printingchecked">
                                            </div>
                                        </div>
                                        <input type="number" name="printing" id="printing" class="form-control form-control-sm" value="0" disabled>
                                    </div>
                                   
                                </div>
                                <div class="col form-group">
                                    <label for="freight">Freight</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text">
                                            <input type="checkbox" id="freightchecked">
                                            </div>
                                        </div>
                                        <input type="number" name="freight" id="freight" class="form-control form-control-sm" value="0" disabled>
                                    </div>  
                                </div>
                                <div class="col form-group">
                                    <label for="totalcost">Total Cost</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control form-control-sm font-weight-bold" id="totalcost" disabled value="0.00">
                                        <div class="input-group-append">
                                            <button class="btn btn-sm btn-secondary" id="addcorrugateditem"><i class="fal fa-plus fa-lg fa-fw"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <table class="table table-sm table-striped" id="corrugateditemslist">
                                <thead>
                                    <th>#</th>
                                    <th>Item Name</th>
                                    <th>Dimensions</th>
                                    <th>Unit Weight</th>
                                    <th>Quantity</th>
                                    <th>Total Weight</th>
                                    <th>Total</th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th><!-- Info,Edit and Delete -->
                                </thead>
                                <tbody></tbody>
                            </table>
                            <div class="form-group">
                                <label for="corrugatedterms">Terms and Conditions</label>
                                <textarea name="corrugatedterms" id="corrugatedterms" class="form-control"></textarea>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-success btn-sm" id="savecorrugatedquotation"><i class="fal fa-save fa-lg fa-fw"></i> Save Quotation</button>
                                <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fal fa-times fa-lg fa-fw"></i> Close</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body> 
<!-- Add footer  -->
<?php require_once("footer.txt")?>
<script src="../js/quotations.js"></script>
</html>