<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Input / Output VAT Report </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Input / Output VAT Report"; require_once("topbar.php"); ?>
            <!-- Page Content -->
            <div class="container-fluid mt-3">
            <div class="row">
                    <div class="col col-md-3 ">
                        <div class="card containergroup card-body-list">
                            <div class="card-header">
                                <h5>Filter Options</h5>
                            </div>
                            <div class="card-body">
                                <!-- <div id="errors"></div> -->
                                <div class="form-check mb-4">
                                    <input type="checkbox" class="form-check-input" id="selectalldates" checked>
                                    <label class="form-check-label" for="selectalldates">All Dates</label>
                                </div>
                                <div class="form-group">
                                    <label for="startdate">Start Date</label>
                                    <input type="text" id="startdate" name="startdate" autocomplete="off" class="form-control form-control-sm" disabled>
                                </div>

                                <div class="form-group">
                                    <label for="enddate">End Date</label>
                                    <input type="text" id="enddate" name="enddate" autocomplete="off" class="form-control form-control-sm" disabled>
                                </div>

                                <!-- <div class="form-group">
                                    <label for="pos">Point of Sale</label>
                                    <select id="pos" name="pos" class="form-control form-control-sm"></select>
                                </div> -->

                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search"><i class="fal fa-sync fa-fw fa-lg"></i> Generate Report</button>
                            </div>
                        </div>   
                    </div>

                    <div class="col">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Input / Output VAT Report</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div id="reportnotifications"></div>
                                <!-- <div class="scrollablefullheight scrollable-y"> -->
                                <table class="table table-stripped table-sm" id="inputoutputvatreporttable">
                                    <thead>
                                        <th>#</th>
                                        <th>Item Code</th>
                                        <th>Item Name</th>
                                        <th>Quantity</th>
                                        <th>Total Purchase</th>
                                        <th>Input VAT</th>
                                        <th>Total Sales</th>
                                        <th>Output VAT</th>
                                        <th>VAT Difference</th>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                                <!-- </div> -->
                                
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?>
<script src="../js/inputoutputvatreport.js"></script>
</html>