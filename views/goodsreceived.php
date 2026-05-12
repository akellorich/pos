<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Purchase Receipts</title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Purchase Receipts</span>
            <div class="container-fluid">
                <div class="row">
                    <div class="col col-md-3">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Filter options</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div id="errors"></div>

                                <div class="form-group">
                                    <label for="sourcename"><span id="sourcelabel">Supplier</span> Name</label>
                                    <select name="sourcename" id="sourcename" class="form-control form-control-sm"></select>
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
                                    <label for="grnno">GRN Number</label>
                                    <input type="text" name="grnno" id="grnno" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="deliveryno">Delivery Number</label>
                                    <input type="text" name="deliveryno" id="deliveryno" class="form-control form-control-sm">
                                </div>

                                <button class="btn btn-secondary btn-sm" id="filtergrn"><i class="fal fa-filter fa-lg"></i> Filter GRNs</button>
                                <button class="btn btn-sm btn-success" id="addnewgrn"><i class="fal fa-plus-circle fa-lg"></i> Add New GRN</button>
                            </div>
                        </div>
                    </div>

                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Goods Received in the system</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <table class="table table-sm table-striped" id="grnlist">
                                    <thead>
                                        <th>#</th>
                                        <th>GRN Number</th>
                                        <th>Delivery Note #</th>
                                        <th>Date</th>
                                        <th>Warehouse</th>
                                        <th>Supplier Name</th>
                                        <th>Received By</th>
                                        <th>Inspected By</th>
                                        <th>GRN Value</th>
                                        <th>&nbsp;</th><!-- View Items in the GRN -->
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>  
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/goodsreceived.js"></script>
</html>
