<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Master Stocksheet </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Master Stocksheet"; require_once("topbar.php"); ?>
            <div class="container-fluid mt-2">
                <div class="row">
                    <div class="col col-md-3">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Filter Options</h5>
                            </div>
                            <div class="card-body">
                                <div id="errors"></div>
                                <div class="form-group">
                                    <label for="startdate">As at Date</label>
                                    <input type="text" id="startdate" autocomplete="off" name="startdate" class="form-control form-control-sm">
                                </div>

                            
                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search">Generate Report</button>
                            </div>
                        </div>
                    </div>

                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Master Stocksheet Report</h5>
                            </div>
                            <div class="card-body">
                                <div id='report'></div>
                                <div class="scrollable scrollable-y">
                                    <table class="table table-sm table-striped table-hover" id="masterstocksheetreport">
                                        <thead></thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="card containergroup mt-2">
                            <div class="card-header">
                                <h5>Return Outwards</h5>
                            </div>
                            <div class="card-body">
                                <table class="table table-sm table-striped scrollable-3" id="returnoutwardssummary">
                                    <thead>
                                        <th>#</th>
                                        <th>Date</th>
                                        <th>Item Code</th>
                                        <th>Item Name</th>
                                        <th>Quantity</th>
                                        <th>Serial Number</th>
                                        <th>Reference</th>
                                        <th>Narration</th>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>

                        <div class="card containergroup mt-2">
                            <div class="card-header">
                                <h5>Return Inwards</h5>
                            </div>
                            <div class="card-body">
                                <table class="table table-sm table-striped scrollable-3" id="returninwardssummary">
                                    <thead>
                                        <th>#</th>
                                        <th>Date</th>
                                        <th>Item Code</th>
                                        <th>Item Name</th>
                                        <th>Quantity</th>
                                        <th>Serial Number</th>
                                        <th>Reference</th>
                                        <th>Narration</th>
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
<script type="text/javascript" src="../js/masterstocksheetreport.js"></script>
<html>