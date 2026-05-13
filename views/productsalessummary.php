<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Product Sales </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Product Sales"; require_once("topbar.php"); ?>
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

                                <div class="form-group">
                                    <label for="groupby">Group By</label>
                                    <select id="groupby" name="groupby" class="form-control form-control-sm">
                                        <option value="">&lt;No Grouping &gt;</option>
                                        <option value="date">Date</option>
                                        <option value="product">product</option>
                                    </select>
                                </div>
                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search">Generate Report</button>
                            </div>
                        </div>
                    </div>

                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Products Sales Summary Report</h5>
                            </div>

                            <div class="card-body card-body-list">
                                <div id='report'></div>
                                <div class="scrollablefullheight scrollable-y">
                                    <table id="productsalesreport" class="table table-striped table-hover">
                                        <thead></thead>
                                        <tbody></tbody>
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
<script type="text/javascript" src="../js/productsalesummary.js"></script>
<html>