<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Production Receipts </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Production Receipts</span>
            <div class="container-fluid containergroup">
                <div class="card filteroptions mt-2">
                    <div class="card-header">
                        <h6>Filter Options</h6>
                    </div>
                    <div class="card-body card-body-list">
                        <div id="errordiv1"></div>
                        <div class="row">
                            <div class="col form-group">
                                <label for="alldates">Date Range</label>   
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <input type="checkbox" name="alldates" id="alldates"  > 
                                        </div>
                                    </div>
                                    <input type="text" class="form-control form-control-sm" value="All Dates">
                                </div>
                                
                            </div>

                            <div class="col form-group">
                                <label for="startdate"><span id="startdatelabel">Start date</span></label>
                                <input type="text" name="startdate" id="startdate" class="form-control form-control-sm">
                            </div>

                            <div class="col form-group">
                                <label for="enddate"><span id="enddatelabel">End date</span></label>
                                <input type="text" name="enddate" id="enddate" class="form-control form-control-sm">
                            </div>

                            <div class="col form-group">
                                <label for="filterproduct">Product</label>
                                <div class="input-group">
                                    <select name="filterproduct" id="filterproduct" class="form-control form-control-sm"></select>
                                    <div class="input-group-append">
                                        <button class="btn btn-success btn-sm" type="button"><i class="fal fa-filter fa-lg fa-fw"></i> Filter</button>
                                    </div>
                                </div>

                            </div>

                        </div>
                        <table class="table table-sm table-striped" id="productionreceiptlist">
                            <thead>
                                <th>#</th>
                                <th>Date</th>
                                <th>Delivery #</th>
                                <th>Received By</th>
                                <th>Item</th>
                                <th>Quantity</th>
                                <th>Narration</th>
                                <th>&nbsp;</th><!-- Edit -->
                                <th>&nbsp;</th><!-- Approve -->
                                <th>&nbsp;</th><!-- Reject -->
                            </thead>
                            <tbody></tbody>
                        </table>
                        <button class="btn btn-success btn-sm mt-3 " id="addnewreceiptbutton"><i class="fal fa-plus-circle fa-lg fa-fw"></i> Receive Item</button>
                    </div>
                </div>
            </div>   
        </div>
    </section>
    <!-- receive new production product modal  -->
    <div class="modal" tabindex="-1" role="dialog" id="productionreceiptmodal">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Receive Production Item</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col form-group">
                            <label for="receiptproduct">Product</label>
                            <select name="receiptproduct" id="receiptproduct" class="form-control form-control-sm">
                                <option value="">&lt;Choose&gt;</option>
                            </select>
                        </div>
                        <div class="col form-group">
                            <label for="receiptquantity">Received Quantity</label>
                            <input type="number" name="receiptquantity" id="receiptquantity" class="form-control form-control-sm">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col form-group">
                            <label for="">Delivery #</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="checkbox" id="generatedeliveryno">
                                    </div>
                                </div>
                                <input type="text" class="form-control form-control-sm" value="Auto Generate">
                            </div>
                        </div>
                        <div class="col form-group">
                            <label for="">Delivery Number:</label>
                            <input type="text" name="deliverynumber" id="deliverynumber" class="form-control form-control-sm">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col from-group">
                            <label for="receiptnarration">Narration</label>
                            <textarea name="receiptnarration" id="receiptnarration" class="form-control form-control-sm"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm"><i class="fal fa-save fa-lg fa-fw"></i> Save received item</button>
                    <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal"><i class="fal fa-times fa-fw fa-lg"></i> Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/productionreceipts.js"></script>
</html>