<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Spoilage </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Spoilage"; require_once("topbar.php"); ?>
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
                                    <label for="category">Category</label>
                                    <select id="category" name="category" class="form-control form-control-sm"></select>
                                </div>

                                    <div class="form-group">
                                    <label for="product">Product</label>
                                    <select id="product" name="product" class="form-control form-control-sm"></select>
                                </div>

                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search"><i class="fas fa-search fa-fw fa-lg"></i> Filter Orders</button>
                                <button type="button" class="btn btn-success btn-sm" id="addnew" name="addnew"><i class="fas fa-plus-circle fa-fw fa-lg"></i> Add New</button>
                            </div>
                        </div>
                    </div>
                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Spoilages in the System</h5>
                            </div>
                            <div class="card-body card-body-list scrollable-y">
                                <table class="table table-striped table-sm" id="spoilagelist">
                                    <thead class="thead-light" >
                                        <th>#</th>
                                        <th>Category</th>
                                        <th>Product</th>
                                        <th>Quantity</th>
                                        <th>Narration</th>
                                        <th>Date Added</th>
                                        <th>Added By</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                    </thead>

                                    <tbody></tbody>
                                    
                                    <tfoot></tfoot>
                                </table>
                            
                                <div class="col-md-12 text-center">
                                <ul class="pagination pagination-lg pager" id="myPager"></ul>
                            </div>
                            <!-- <button type="button" id="addorder" name="addorder" Value="" class="btn btn-success btn-sm"><i class="fas fa-plus-circle fa-fw fa-lg"></i> Add Order</button> -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>  
        
    </div>
    <!-- Modal for adding a new spoilage  -->
    <div class="modal" tabindex="-1" role="dialog" id="spoilagedetailsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Spoilage Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="notifications"></div>
                    <!-- Added category for store and store selection -->
                    <div class="form-group">
                        <label for="storecategory">Store Category</label>
                        <select name="storecategory" id="storecategory" class="form-control form-control-sm">
                            <option value="">&lt;Choose&gt;</option>
                            <option value="warehouse">Warehouse</option>
                            <option value="outlet">Outlet</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="storeid">Store</label>
                        <select name="storeid" id="storeid" class="form-control form-control-sm">
                            <option value="">&lt;Choose&gt;</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="detailscategory">Item Category</label>
                        <select name="detailscategory" id="detailscategory" class="form-control form-control-sm"></select>
                    </div>
                    <div class="form-group">
                        <label for="detailsproduct">Product</label>
                        <select name="detailsprpduct" id="detailsproduct" class="form-control form-control-sm"></select>
                    </div>
                    <div class="form-group">
                        <label for="detailsquantity">Quantity</label>
                        <input type="number" name="detailsquantity" id="detailsquantity" class="form-control form-control-sm">
                    </div>
                    <div class="form-group">
                        <label for="detailsnarration">Narration</label>
                        <textarea name="detailsnarration" id="detailsnarrattion" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savespoilage">Save spoilage</button>
                    <button type="button" class="btn btn-secondary btn-sm" id="clearform">Clear Fields</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/spoilage.js"></script>
</html>