
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Product Statement </title>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <div class="home-content">
        <i class='bx bx-menu' ></i>
        <span class="text">Product Statement</span>
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
                                <input type="text" id="startdate" autocomplete="off" name="startdate" class="form-control form-control-sm">
                            </div>

                            <div class="form-group">
                                <label for="enddate">End Date</label>
                                <input type="text" id="enddate" autocomplete="off" name="enddate" class="form-control form-control-sm">
                            </div>

                            <div class="form-group">
                                <label for="product">Product</label>
                                <select id="product" name="product" class="form-control form-control-sm"></select>
                            </div>

                        
                            <button type="button" class="btn btn-secondary btn-sm" id="search" name="search">Generate Report</button>
                        </div>
                    </div>
                </div>

                <div class="col" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Product Statement Report</h5>
                        </div>

                        <div class="card-body">
                            <div id="errors"></div>
                            <table class="table table-sm table-striped" id='report'>
                                <thead>
                                    <th>#</th>
                                    <th>Date</th>
                                    <th>Description</th>
                                    <th>Reference</th>
                                    <th>Stock-In</th>
                                    <th>Stock-Out</th>
                                    <th>Balance</th>
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
<script type="text/javascript" src="../js/productstatement.js"></script>
<html>