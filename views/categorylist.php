<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Product Categories </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Product Categories</span>
            <!-- Page Content -->
            <div class="container-fluid">
                <p class="lead text-center mt-2">Categories In The System</p>
                <div id="errors"></div>
                <table class="table table-striped table-sm display nowrap" id="categorytable">
                    <thead class="thead-light">
                        <th>#</th>
                        <th>Description</th>
                        <th>Prefix</th>
                        <th>Current No</th>
                        <th>Date Added</th>
                        <th>Added By</th>
                        <th>&nbsp;</th>
                        <th>&nbsp;</th>
                    </thead> 

                    <tbody id="categorylist"></tbody>            
                    <tfoot></tfoot>
                </table>
            
                <div class="col-md-12 text-center">
                    <ul class="pagination pagination-lg pager" id="myPager"></ul>
                </div>
                <button id="addcategory" name="addcategory" class='btn btn-success btn-sm'><i class="fal fa-plus fa-lg fa-fw"></i> Add Category</button>
                <!-- <button id="goback" name="goback" class='btn btn-primary btn-sm'><i class="fal fa-bars fa-lg fa-fw"></i> Main Menu</button> -->
            </div>

            <!-- Modal for creating or modifying category details   -->
            <div class="modal" tabindex="-1" role="dialog" id="categorydetailsmodal">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Category Details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                    <div id="categorydetailserrors"></div>
                    <div class="form-group">
                        <input type="hidden" name="categoryid" id="categoryid" value="0" >
                        <label for="categoryname">Category Name:</label>
                        <input type="text" name="categoryname" id="categoryname" class="form-control form-control-sm">
                    </div>
                    <div class="form-group">
                        <label for="prefix">Prefix</label>
                        <input type="text" name="prefix" id="prefix" class="form-control form-control-sm">
                    </div>

                    <div class="form-group">
                        <label for="currentno">Current No</label>
                        <input type="number" name="currentno" id="currentno" class="form-control form-control-sm">
                    </div>
                    
                    <div class="check-group">
                        <input type="checkbox" name="continousadd" id="continousadd">
                        <label for="continousadd" class="check-label">Continous Add ?</label>
                    </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary btn-sm" id="savecategory">Save Category</button>
                        <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Close</button>
                    </div>
                    </div>
                </div>
            </div>

        </div>

    </section>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/categorylist.js"></script>
</html>
