<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Outlets </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Outlets"; require_once("topbar.php"); ?>
            <div class="container-fluid">
                <p class="lead text-center mt-3">Outlets In The System</p>
                <div id="errors"></div>
                <table class="table table-striped table-sm" id="postable"> 
                    <thead class="thead-light">
                        <th>#</th>
                        <th>Outlet Name</th>
                        <th>Type</th>
                        <th>Print KOT</th>
                        <th>Date Added</th>
                        <th>Added By</th>
                        <th>&nbsp;</th>
                        <th>&nbsp;</th>
                    </thead>
                    <tbody></tbody>                
                    <tfoot></tfoot>
                </table>
                
                <input type="button" id="addpos" name="addpos" Value="Add New Outlet" class="btn btn-success btn-sm">
                <!-- <input type="button" id="goback" name="goback" Value="Main Menu" class="btn btn-primary btn-sm"> -->
            </div>
        </div>
    </section>
    <!-- Modal for POS Details -->
    <div class="modal" tabindex="-1" role="dialog" id="posdetailsmodal">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">POS Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="posdetailsnotification"></div>
                    <input type="hidden" name="posid" id="posid" value="0">
                    
                    <!-- Add Toggle Button -->
                    <div class="toggle-switch">
                        <span>Details</span>
                        <input type="checkbox" name="posdetailstableselection" id="posdetailstableselection" class="toggler" checked>
                        <span>Tables</span>
                    </div>

                    <div id="posdetails">

                        <div class="form-group">
                            <label for="posname">POS Name</label>
                            <input type="text" name="posname" id="posname" class="form-control form-control-sm">
                        </div>

                        <div class="row">
                            <div class="col form-group">
                                <label for="postype">Type</label>
                                <select name="postype" id="postype" class="form-control form-control-sm">
                                    <option value="">&lt;Choose&gt;</option>
                                    <option value="retail">Retail</option>
                                    <option value="restaurant">Restaurant</option>
                                </select>
                            </div>
                            <div class="col form-group">
                                <label for="printkot">Print KOT</label>
                                <select name="printkot" id="printkot" class="form-control form-control-sm">
                                    <option value="">&lt;Choose&gt;</option>
                                    <option value="1">Yes</option>
                                    <option value="0">No</option>
                                </select>
                            </div>
                        </div>
                        <!-- Categories to be sold through the outlet -->
                        <div class="col" id="posproductcategories"></div>  
                    </div>
                    
                    <div id="tabledetails" style="display:none">
                        <div class="form-group">
                            <label for="tablename">Table Name</label>
                            <div class="input-group">
                                <input type="text" name="tablename" id="tablename" class="form-control form-control-sm" data-tableid="0">
                                <div class="input-group-append">
                                    <button class="btn btn-sm btn-success" id="savepostable"><i class="fal fa-save fa-lg fa-fw"></i> Save Table</button>
                                </div>
                            </div>
                        </div>
                        <table class="table table-sm table-striped table-hover" id="postablestable">
                            <thead>
                                <th>#</th>
                                <th>Table Name</th>
                                <th>Date Added</th>
                                <th>Added By</th>
                                <th>&nbsp;</th><!-- Edit -->
                                <th>&nbsp;</th><!-- Delete -->
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>

                
                    
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-success" id="savepos"><i class="fal fa-save fa-lg fa-fw"></i> Save changes</button>
                    <button type="button" class="btn btn-sm btn-outline-danger" data-dismiss="modal">Close <i class="fal fa-times fa-lg fa-fw"></i></button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/poslist.js"></script>
</html>