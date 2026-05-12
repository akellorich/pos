<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Stock Taking </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Stock Taking</span>
            <!-- Page Content -->
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
                                    <label for="customer">Customer</label>
                                    <select id="customer" name="customer" class="form-control form-control-sm"></select>
                                </div>

                                    <div class="form-group">
                                    <label for="postatus">Status</label>
                                    <select id="postatus" name="postatus" class="form-control form-control-sm">
                                        <option value="all">&lt;All&gt;</option>
                                        <option value="pending">Pending</option>
                                        <option value="approved">approved</option>
                                        <option value="delivered">Deelivered</option>
                                        <option value="cancelled">Cancelled</option>
                                    </select>
                                </div>

                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search"><i class="fas fa-search fa-fw fa-lg"></i> Filter Orders</button>
                            </div>
                        </div>
                    </div>
                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Stock Takes In the System</h5>
                            </div>
                            <div class="card-body card-body-list scrollable-y">
                                <table class="table table-striped table-sm" id="ordertable">
                                    <thead class="thead-light" >
                                        <th>Customer Id</th>
                                        <th>Customer Name</th>
                                        <th>Stock Take Date</th>
                                        <th>Items</th>
                                        <th>Date Added</th>
                                        <th>Added By</th>
                                        <th>&nbsp;</th> <!-- Stock take details -->
                                    </thead>

                                    <tbody id="stocktakelist"></tbody>
                                    
                                    <tfoot></tfoot>
                                </table>
                            
                                <div class="col-md-12 text-center">
                                <ul class="pagination pagination-lg pager" id="myPager"></ul>
                            </div>
                            <button type="button" id="addorder" name="addorder" Value="" class="btn btn-success btn-sm"><i class="fas fa-plus-circle fa-fw fa-lg"></i> Add Stock Take</button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- Modal for Stocktake details  -->
    <div class="modal" tabindex="-1" role="dialog" id="stocktakedetailsmodal">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Stock Take Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="stocktakeerrors"></div>
                    <div class="row">
                        <div class="col form-group">
                            <label for="stocktakecustomer">Customer:</label>
                            <select name="stocktakecustomer" id="stocktakecustomer" class="form-control form-control-sm"></select>
                        </div>

                        <div class="col form-group">
                            <label for="stocktakedate">Date:</label>
                            <input type="text" name="stocktakedate" id="stocktakedate" class="form-control form-control-sm">
                        </div>

                        <div class="col form-group">
                            <label for="stocktaketype">Type:</label>
                            <select name="stocktaketype" id="stocktaketype" class="form-control form-control-sm">
                                <option value="original">Original</option>
                                <option value="ammendment">Ammendment</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col form-group">
                            <label for="itemcode">Item code</label>
                            <div class="input-group">
                                <input type="text" class="form-control form-control-sm" placeholder="Item bar code" id="itemcode">
                                <div class="input-group-append">
                                    <button class="btn btn-sm btn-secondary" id="asssearchproduct"><i class="fal fa-search fa-lg fa-fw"></i></button>
                                </div>
                            </div>
                        </div>
                        <div class="col form-group">
                            <label for="itemname">Item Name</label>
                            <input type="text" name="itemname" id="itemname" class="form-control form-control-sm" disabled data-id="" data-itemcode="">
                        </div>

                        <div class="col form-group">
                            <label for="itemcode">Quantity</label>
                            <div class="input-group">
                                <input type="number" class="form-control form-control-sm" placeholder="Stock Quantity" id="stockquantity">
                                <div class="input-group-append">
                                    <button class="btn btn-sm btn-secondary" id="additemquantity"><i class="fal fa-plus fa-lg fa-fw"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="scrollable">
                        <table class="table table-sm table-striped" id="stocktakingtable">
                            <thead>
                                <th>#</th>
                                <th>Item Code</th>
                                <th>Item Name</th>
                                <th>Quantity</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-success btn-sm">Save Changes</button>
                <button type="button" class="btn btn-sm btn-outline-danger" data-dismiss="modal">Close Window</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/stocktaking.js"></script>
</html>
