<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Purchases </title>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <?php $pagename = "Purchases"; require_once("topbar.php"); ?>
        <div class="container-fluid">
            <div class="row mt-2">
                <div class="col col-md-3">
                    <div class="containergroup card">
                        <div class="card-header">
                            <h5>Filter Options</h5>
                        </div>
                        <div class="card-body card-body-list">
                            <div id="errors"></div>
                            <div class="check-group">
                                <input type="checkbox" class="check-control" id="alldates" name="alldates">
                                <label for="alldates" class="check-label">All Dates</label>
                            </div>

                            <div class="form-group">
                                <label for="startdate">Start Date</label>
                                <input type="text"  autocomplete="off" id="startdate" name="startdate" class="form-control form-control-sm">
                            </div>

                            <div class="form-group">
                                <label for="enddate">End Date</label>
                                <input type="text"  autocomplete="off" id="enddate" name="enddate" class="form-control form-control-sm">
                            </div>

                            <div class="form-group">
                                <label for="filterdepartment">Department</label>
                                <select name="filterdepartment" id="filterdepartment" class="form-control form-control-sm"></select>
                            </div>

                            <div class="form-group">
                                <label for="potype">Purchase Type</label>
                                <select name="purchasetype" id="purchasetype" class="form-control form-control-sm">
                                    <option value="0">&lt;All&gt;</option>
                                    <option value="product">Product</option>
                                    <option value="rawmaterial">Raw Material</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="filtgercurrency">Currency</label>
                                <select name="filtercurrency" id="filtercurrency" class="form-control form-control-sm"></select>
                            </div>

                            <div class="form-group">
                                <label for="supplier">Supplier</label>
                                <select id="supplier" name="supplier" class="form-control form-control-sm"></select>
                            </div>

                            <div class="form-group">
                                <label for="postatus">Purchase Order Status</label>
                                <select id="postatus" name="postatus" class="form-control form-control-sm">
                                    <option value="all">&lt;All&gt;</option>
                                    <option value="pending">Pending</option>
                                    <option value="approved">approved</option>
                                    <option value="delivered">Deelivered</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                            </div>

                            <button type="button" class="btn btn-secondary btn-sm" id="search" name="search"><i class="fal fa-search fa-fw fa-lg"></i> Filter Orders</button>
                            <button type="button" id="addorder" name="addorder" class="btn btn-success btn-sm"><i class="fal fa-plus-circle fa-fw fa-lg"></i> Add Order</button>
                        </div>
                    </div>
                </div>
                <div class="col" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Purchases in the system</h5>
                        </div>
                        <div class="card-body">
                            <div id="purchaseordererrors"></div>
                            <table class="table table-striped table-sm" id="orderlist">
                                <thead class="thead-light" >
                                    <th>#</th>
                                    <th>Order Id</th>
                                    <th>Order No</th>
                                    <th>Supplier</th>
                                    <th>Order Total</th>
                                    <th>Status</th>
                                    <th>Date Added</th>
                                    <th>Added By</th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th>
                                </thead>
                                <tbody ></tbody>
                            </table>
                        
                            <div class="col-md-12 text-center">
                            <ul class="pagination pagination-lg pager" id="myPager"></ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
  </section>
  <!-- Modal for approving purchaseorders  -->
  <div class="modal" tabindex="-1" role="dialog" id="approvepurchaseordermodal">
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
    </div>

    <!-- Modal for Rejecting purchaseorders  -->
    <div class="modal" tabindex="-1" role="dialog" id="rejectpurchaseordermodal">
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
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/purchaseslist.js"></script>
</html>