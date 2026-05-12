<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Returns </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Returns</span>
            <!-- Page Content -->
            <div class="container-fluid">
                <div id="notifications"></div>
                <div class="row">

                    <div class="col form-group">
                        <label for="outletid">Outlet</label>
                        <select name="outletid" id="outletid" class="form-control form-control-sm">
                            <option value="">&lt;Choose&gt;</option>
                        </select>
                    </div>

                    <div class="col form-group">
                        <label for="warehouseid">Warehouse</label>
                        <select name="warehouseid" id="warehouseid" class="form-control form-control-sm">
                            <option value="">&lt;Choose&gt;</option>
                        </select>
                    </div>

                    <div class="col form-group">
                        <label for="paymentmethod">Payment Method</label>
                        <select name="paymentmethod" id="paymentmethod" class="form-control form-control-sm">
                            <option value="">&lt;Choose&gt;</option>
                        </select>
                    </div>

                    <div class="col form-group">
                        <label for="reference">Reference #</label>
                        <input type="text" name="reference" id="reference" class="form-control form-control-sm">
                    </div>

                    <div class="col form-group">
                        <label for="overalltotal" class="font-weight-bold text-right">Overall Total</label>
                        <input type="text" name="overalltotal" id="overalltotal" class="form-control form-control-sm font-weight-bold text-right" disabled value="0.00">
                    </div>
                </div>
                
                <div class="scrollable scrollable-report mb-3">
                    <table class="table table-sm table-striped table-hover" id="itemstable">
                        <thead>
                            <th>#</th>
                            <th>Item Code</th>
                            <th>Name</th>
                            <th>Unit Price</th>
                            <th>Stock Quantity</th>
                            <th>Return</th>
                            <th>Sales</th>
                            <th>Total Sale</th>
                        </thead>
                        <tbody></tbody>
                    </table>
                   
                </div> 

                <div class="d-flex justify-content-between">
                    <button class="btn btn-outline-success btn-sm" id="additems"><i class="fal fa-plus fa-fw fa-lg"></i> Add Items</button>
                    <button class="btn btn-sm btn-success" id="savereturns"><i class="fal fa-save fa-lg fa-fw"></i> Save Returns</button>
                </div>
            </div>
        </div>
    </section>

    <div class="modal" tabindex="-1" role="dialog" id="allowablereturnitemsmodal">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Returnable Items Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="returnableitemsnotifications"></div>
                    <table class="table table-sm table-striped table-hover" id="returnableitemstable">
                        <thead>
                            <th><input type="checkbox" name="selectallreturnableproducts" id="selectreturnableproducts"></th>
                            <th>Item Code</th>
                            <th>Item Name</th>
                            <th>Unit Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savereturnableitems"><i class="fal fa-save fa-lg fa-fw"></i> Save changes</button>
                    <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal"><i class="fal fa-times fa-lg fa-fw"></i> Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script src="../js/returns.js"></script>
</html>