<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Sales Summary </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Sales Summary"; require_once("topbar.php"); ?>
            <div class="container-fluid mt-2">
                <div class="row">
                    <div class="col col-md-3">
                        <div class="containergroup card">
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
                                    <label for="pos">Point of Sale</label>
                                    <select id="pos" name="pos" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="user">User</label>
                                    <select id="user" name="user" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="groupby">Group By</label>
                                    <select id="groupby" name="groupby" class="form-control form-control-sm">
                                        <option value="user">User</option>
                                        <option value="date">Date</option>
                                        <option value="pos">Point of Sale</option>
                                        <option value="customer">Customer</option>
                                    </select>
                                </div>
                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search">Generate Report</button>
                            </div>
                        </div>
                    </div>
                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                            <h5>Sales Summary Report</h5> 
                            </div>
                            <div class="card-body">
                                    <table class="table table-stripped table-sm" id="resultslist">
                                    <tbody>
                                        <tr><td colspan="5">No results filtered yet</td></tr>
                                    </tbody>
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
<script type="text/javascript" src="../js/dailysalesreport.js"></script>
<html>