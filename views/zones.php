<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Zones </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Zones"; require_once("topbar.php"); ?>
            <div class="container-fluid">
                <p  class="lead text-center mt-3">Zones In The System</p>
                <div id="errors"></div>
                <table class="table table-striped table-sm" id="zoneslist">
                    <thead class="thead-light">
                        <th>#</th>
                        <th>Zone Name</th>
                        <th>Customers</th>
                        <th>Date Added</th>
                        <th>Added By</th>
                        <th>&nbsp;</th>
                        <th>&nbsp;</th>
                    </thead>
                    <tbody></tbody>
                    <tfoot></tfoot>
                </table>

                <button id="addzone" name="addzone" class='btn btn-success btn-sm mb-3'><i class="fas fa-plus-circle fa-lg"></i> Add Zone</button>
                <button id="goback" name="goback" class='btn btn-primary btn-sm mb-3'><i class="fas fa-bars fa-lg"></i> Main Menu</button>
            </div>
        </div>
        
    </section>
   
    <!-- Modal for zone details  -->
    <div class="modal" tabindex="-1" role="dialog" id="zonedetailsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Zone Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="zonenotifications"></div>
                    <input type="hidden" name="zoneid" id="zoneid" value="0">
                    <div class="form-group">
                        <label for="zonecategory">Category</label>
                        <select name="zonecategory" id="zonecategory" class="form-control form-control-sm">
                            <option value="">&lt;Choose&gt;</option>
                            <option value="mainzone">Main Zone</option>
                            <option value="subzone">Sub Zone</option>
                        </select>
                    </div>
                    <div class="form-group" id="zoneparentgroup" style="display:none">
                        <label for="zoneparent">Parent Zone</label>
                        <select name="parentzone" id="parentzone" class="form-control form-control-sm"></select>
                    </div>
                    <div class="form-group">
                        <label for="zonename">Zone Name</label>
                        <input type="text" name="zonename" id="zonename" class="form-control form-control-sm">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savezone">Save changes</button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/zones.js"></script>
</html>