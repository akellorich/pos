<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Stock List </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Stock List"; require_once("topbar.php"); ?>
            <div class="container-fluid mt-2"> 
                <div class="row">
                    <div class="col col-md-2" id="filteroptions">
                        <div class="containergroup card">
                            <div class="card-header">
                                <h5>Filter Options</h5>
                            </div>
                            <div class="card-body">
                                <div id="errors"></div>
                                <div class="form-group">
                                    <label for="startdate">Stock List As At</label>
                                    <input type="text" id="startdate" name="startdate" autocomplete="off" class="form-control form-control-sm">
                                </div>
                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search">Generate Report</button>
                            </div>
                        </div>     
                    </div>

                    <div class="col" id="receiptlist">
                        <div class="containergroup card">
                            <div class="card-header">
                                <h5>
                                <span class="text-left font-weight-bold">Stocklist Report</span>
                                <span class="float-right">
                                    <a class='btn btn-danger btn-xs' data-toggle='collapse' href='#filteroptions' role='button' aria-expanded='false' aria-controls='filteroptions'><i class="far fa-eye-slash fa-lg fa-fw"></i></a>
                                </span> 
                                </h5>
                            </div>
                            <div class="card-body card-body-list">
                                <!-- <div id="report"></div> -->
                                <table id="stocklistreport" class="table table-sm table-striped table-hover">
                                    <thead></thead>
                                    <tbody></tbody>
                                    <tfoot></tfoot>
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
<script type="text/javascript" src="../js/stocklistreport.js"></script>
<html>