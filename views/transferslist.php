<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Transfers </title>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <div class="home-content">
        <i class='bx bx-menu' ></i>
        <span class="text">Transfers</span>
        <div class="container-fluid containergroup">
            <div class="row mt-2" >
                <div class="col col-md-3">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Filter Options</h5>
                        </div>
                        <div class="card-body card-body-list">
                            <div class="form-group">
                                <label for="source">Source</label>
                                <select name="source" id="source" class="form-control form-control-sm">
                                    <option value="all">&lt;All&gt;</option>
                                    <option value="warehouse">Warehouse</option>
                                    <option value="outlet">Outlet</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="sourcename">Source Name:</label>
                                <select name="sourcename" id="sourcename" class="form-control form-control-sm">
                                    <option value="all">&lt;All&gt;</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="destination">Destination</label>
                                <select name="destination" id="destination" class="form-control form-control-sm">
                                    <option value="all">&lt;All&gt;</option>
                                    <option value="warehouse">Warehouse</option>
                                    <option value="outlet">Outlet</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="destinationname">Destination Name:</label>
                                <select name="destinationname" id="destinationname" class="form-control form-control-sm">
                                    <option value="all">&lt;All&gt;</option>
                                </select>
                            </div>
                            
                            
                            <div class="form-group">
                                <input type="checkbox" name="alldates" id="alldates">All Dates 
                            </div>

                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="startdate" id="startdatelabel">Start Date</label>
                                        <input type="text" name="startdate" id="startdate" class="form-control form-control-sm">
                                    </div>
                                </div>

                                <div class="col">
                                    <div class="form-group">
                                        <label for="enddate" id="enddatelabel">End Date</label>
                                        <input type="text" name="enddate" id="enddate" class="form-control form-control-sm">
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-secondary btn-sm" id="findtransfers"><i class="fas fa-search fa-sm"></i> Find Transfers</button>
                            <button class="btn btn-success btn-sm" id="newtransfer"><i class="fas fa-plus-circle fa-sm"></i> Add New</button>
                        </div>
                    </div>
                </div>
                <div class="col" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Transfers Done</h5>
                        </div>
                        <div class="card-body card-body-list scrollable-y">
                            <table  class="table table-sm table-striped" id="transferdetails">
                                <thead>
                                    <th>#</th>
                                    <th>Reference #</th>
                                    <th>Date</th>
                                    <th>Source</th>
                                    <th>Destination</th>
                                    <th>User</th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th>
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
<script type="text/javascript" src="../js/transferslist.js"></script>
</html>