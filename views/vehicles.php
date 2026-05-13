<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Dashboard </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Dashboard"; require_once("topbar.php"); ?>
            <div class="container-fluid containergroup">
                <table class="table table-sm table-striped mt-3" id="vehicleslist">
                    <thead>
                        <th>#</th>
                        <th>Reg #</th>
                        <th>Body Type</th>
                        <th>Fuel Type</th>
                        <th>Engine Rating</th>
                        <th>Added By</th>
                        <th>&nbsp;</th><!-- Edit -->
                        <th>&nbsp;</th><!-- Delete -->
                    </thead>
                    <tbody></tbody>
                </table>
                <button class="btn btn-success btn-sm mt-3" id="addnewvehicle"><i class="fas fa-plus-circle fa-lg fa-fw"></i> Add New</button>
            </div>
        </div>
    </section>
    
    <!-- Modal for adding / editing a vehicle  -->
    <div class="modal" tabindex="-1" role="dialog" id="vehicledetailsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Vehicle Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="savevehicleerrors"></div>
                    <input type="hidden" name="vehicleid" id="vehicleid" value="0">
                    <div class="form-group">
                        <label for="regno">Registration Number</label>
                        <input type="text" name="regno" id="regno" class="form-control form-control-sm">
                    </div>

                    <div class="form-group">
                        <label for="bodytype">Body Type</label>
                        <select name="bodytype" id="bodytype" class="form-control form-control-sm"></select>
                    </div>

                    <div class="form-group">
                        <label for="fueltype">Fuel Type</label>
                        <select name="fueltype" id="fueltype" class="form-control form-control-sm"></select>
                    </div>

                    <div class="form-group">
                        <label for="engineratine">Engine Rating (CC)</label>
                        <input type="number" name="engineratiing" id="enginerating" class="form-control form-control-sm">
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savevehicle">Save Vechicle</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/vehicles.js"></script>
</html>