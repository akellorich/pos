<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Outlet Stock Summary </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Outlet Stock Summary"; require_once("topbar.php"); ?>
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
                                    <label for="startdate">As At Date</label>
                                    <input type="text" id="asatdate" name="asatdate" autocomplete="off" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="category">Category</label>
                                    <select name="category" id="category" class="form-control form-control-sm">
                                        <option value="outlet">Outlet</option>
                                        <option value="warehouse">Warehouse</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="pos">Point of Sale</label>
                                    <select id="pos" name="pos" class="form-control form-control-sm"></select>
                                </div>

                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search">Generate Report</button>
                            </div>
                        </div>   
                    </div>

                    <div class="col" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>POS Stock Summary Report</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div id="report"></div>
                                <div class="scrollablefullheight scrollable-y">
                                    <table class="table table-stripped table-sm" id="posstocklistreport">
                                        <thead></thead>
                                            <tbody> </tbody>
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
<script type="text/javascript" src="../js/posstocksummary.js"></script>
<html>