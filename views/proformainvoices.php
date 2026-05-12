<!DOCTYPE html>
<html lang="en" dir="ltr">
    <head>
        <?php require_once("header.txt") ?> 
        <title> SalesFlow | Proforma Invoices </title>
    </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Proforma Invoices</span>
            <div class="container-fluid containergroup">
                <div class="row">
                    <div class="col col-md-3">
                        <div class="card filteroptions mt-2">
                            <div class="card-header">
                                <h6>Filter Options</h6>
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
                            
                                <button class="btn btn-success btn-sm " id="addnewquotationbutton"><i class="fal fa-plus-circle fa-lg fa-fw"></i> Add Proforma Invoice</button>

                            </div>
                        </div>
                    </div>
                    
                    <div class="col">
                        <div class="card mt-2" id="receiptlist">
                            <div class="card-header">
                                <h6>Proforma Invoices in the System</h6>
                            </div>
                            <div class="card-body card-body-list scrollable-y">
                                <div id="purchaseordererrors"></div>
                                <div id="quotationslist">
                                    <table class="table table-sm table-striped" id="quotationslist">
                                        <thead>
                                            <th>#</th>
                                            <th>Date</th>
                                            <th>Invoice #</th>
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
    
    <!-- Modal for approving purchaseorders  -->
    <!-- <div class="modal" tabindex="-1" role="dialog" id="approvepurchaseordermodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Approve Purchase Order As ...</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="approvallevels">

                    </div>
                    <div class="form-group">
                        <label for="approvalnarration">Approval Remarks:</label>
                        <textarea name="approvalnarration" id="approvalnarration" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="approvepurchaseorderbtn">Approve</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div> -->

    <!-- Modal for Rejecting purchaseorders  -->
    <!-- <div class="modal" tabindex="-1" role="dialog" id="rejectpurchaseordermodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Reject Purchase Order As ...</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="rejecterrors"></div>
                    <div id="rejectionlevels">

                    </div>
                    <div class="form-group">
                        <label for="rejectionnarration">Rejection Remarks:</label>
                        <textarea name="rejectionnarration" id="rejectionnarration" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="rejectpurchaseorderbtn">Reject</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div> -->

    <!-- Modal for Adding an new quotation  -->
    <div class="modal" tabindex="-1" role="dialog" id="addnewquotationmodal">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Add Proforma Invoice</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
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
                            <label for="newquoteitem">Item</label>
                            <input type="text" name="newquoteitem" id="newquoteitem" class="form-control form-control-sm">
                            <div id="searchproducts" style="z-index:1000; position: fixed;"></div>
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
                       <tbody>

                       </tbody>
                       
                   </table>
                   
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savequotation">Save Proforma Invoice</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</body> 
<!-- Add footer  -->
<?php require_once("footer.txt")?>
<script src="../js/proformainvoices.js"></script>
</html>