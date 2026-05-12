<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Sales Report </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Sales Report</span>
            <div class="container-fluid mt-2">   
                <div class="row">
                    <div class="col col-md-3">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Filter Options</h5>
                        </div>
                        <div class="card-body">
                                <div id="errors"></div>
                                <div class="check-group">
                                    <input type="checkbox" class="check-control" id="alldates" name="alldates">
                                    <label for="alldates" class="check-label">All Dates</label>
                                </div>

                                <div class="form-group">
                                    <label for="startdate">Start Date</label>
                                    <input type="text" autocomplete="off" id="startdate" name="startdate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="enddate">End Date</label>
                                    <input type="text" autocomplete="off" id="enddate" name="enddate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="pos">Point of Sale</label>
                                    <select id="pos" name="pos" class="form-control form-control-sm"></select>
                                </div>

                                    <div class="form-group">
                                    <label for="paymentmode">Payment Mode</label>
                                    <select id="paymentmode" name="paymentmode" class="form-control form-control-sm">
                                    </select>
                                </div>

                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search">Generate Report</button>
                        </div>
                    </div>
                    </div>

                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>POS Sales Receipts</h5>
                            </div>

                            <div class="card-body">
                                <div id="errors1"></div>
                                <!-- <div id='report'> -->
                                <table class="table table-sm table-striped" id="possaleslist">
                                    <thead>
                                        <th>#</th>
                                        <th>POS</th>
                                        <th>Receipt#</th>
                                        <th>Date</th>
                                        <th>Customer</th>
                                        <th>Payment Mode</th>
                                        <th>Reference#</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Added By</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                                <!-- </div> -->
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="cancelreceiptmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Confirm Receipt Cancellation</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div id="modalerror"></div>
                            <div class="form-group">
                                <input type="hidden" name="receiptid" id="receiptid">
                                <label for="cancelreason">Provide Cancellation Reason</label>
                                <input type="text" name="cancelreason" id="cancelreason" class="form-control form-control-sm">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-success btn-sm"  data-dismiss="modal" id="dontcancel">No, Don't Cancel</button>
                            <button type="button" class="btn btn-danger btn-sm" id="cancelreceipt">Yes, Cancel Receipt</button>
                        </div>
                        </div>
                    </div>
                </div>

                <!-- Modal for Refund -->
                <div class="modal" tabindex="-1" id="refundmodal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Select Refundable Item(s)</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="refundreceiptno" id="refundreceiptno">
                            <div id="refundnotifications"></div>
                            <div class="col form-group">
                                <label for="refundreason">Refund Reason</label>
                                <input type="text" name="refundreason" id="refundreason" class="form-control form-control-sm">
                            </div>

                           <table class="table table-sm table-striped table-hover" id="refunditems">
                                <thead>
                                    <th>#</th>
                                    <td><input type="checkbox" id="selectallrefunds"></td>
                                    <th>Item Name</th>
                                    <th class="text-right">Unit Price</th>
                                    <th class="text-right">Quantity</th>
                                    <th class="text-right">Total</th>
                                </thead>
                                <tbody id="refunditemslist"></tbody>
                           </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success btn-sm" id="completerefund"><i class="fas fa-save fa-lg fa-fw"></i> Complete Refund</button>
                            <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal"><i class="fas fa-times fa-lg fa-fw"></i>  Close</button>   
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
    </section>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/viewpossales.js"></script>
<html>