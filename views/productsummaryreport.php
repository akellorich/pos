<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Product Summary </title>
    
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Product Summary"; require_once("topbar.php"); ?>
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
                                    <label for="reportname">Report On</label>
                                    <select id="reportname" name="reportname" class="form-control form-control-sm">
                                        <option value="">&lt;Choose&gt;</option>
                                        <option value="purchases">Purchases</option>
                                        <option value="sales">Sales</option>
                                    </select>
                                </div>

                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search">Generate Report</button>
                        </div>
                    </div>
                    </div>

                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Product Summary Report</h5>
                            </div>

                            <div class="card-body">
                                <div id="errors1"></div>
                                <div id='report'>
                                    <table class="table table-sm table-striped" id="reportdetails">
                                        <thead>
                                            <th>#</th>
                                            <th>Product Code</th>
                                            <th>Product Name</th>
                                            <th>Buying Price</th>
                                            <th>Quantity</th>
                                            <th>Total</th>
                                        </thead>                
                                        <tbody ></tbody>
                                        <tfoot></tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>  
            </div>
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/productsummaryreport.js"></script>
<html>
