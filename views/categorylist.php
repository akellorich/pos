<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Product Categories </title>
    <style>
        /* Custom card group styling for consistency */
        .containergroup.card {
            border: none;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            min-height: calc(100vh - 95px);
            margin-bottom: 20px;
        }
        .card-header {
            background: #f8f9fa;
            border-bottom: 1px solid #eef2f6;
            padding: 15px 20px;
        }
        .card-header h5 {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
        }
        @media (max-width: 576px) {
            .card-header h5 {
                font-size: 0.92rem !important;
            }
            .card-header h5 i {
                font-size: 0.85rem !important;
            }
        }
        /* Make table header text premium and responsive */
        #categorytable thead th {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
            padding: 10px 8px;
            border-bottom: 2px solid #dee2e6;
        }
        #categorytable tbody td {
            font-size: 0.78rem;
            padding: 8px 8px;
            vertical-align: middle;
        }
        /* Align DataTable Buttons and Search on same row or with beautiful space */
        .dt-buttons-container {
            display: block !important;
            width: 100% !important;
            overflow-x: auto !important;
            white-space: nowrap !important;
            -webkit-overflow-scrolling: touch;
            margin-bottom: 1.2rem !important;
            padding-bottom: 5px !important;
        }
        .dt-buttons {
            display: inline-flex !important;
            flex-wrap: nowrap !important;
            white-space: nowrap !important;
        }
        .dt-buttons .btn {
            display: inline-block !important;
            float: none !important;
            margin-bottom: 0 !important;
            white-space: nowrap !important;
        }
        .dt-controls-container {
            display: flex !important;
            flex-direction: row !important;
            justify-content: space-between !important;
            align-items: center !important;
            flex-wrap: nowrap !important;
            width: 100%;
            margin-bottom: 1.2rem;
            gap: 15px;
        }
        .dataTables_length, .dataTables_filter {
            margin: 0 !important;
        }
        .dataTables_length label, .dataTables_filter label {
            margin: 0 !important;
            display: flex !important;
            align-items: center !important;
            gap: 5px !important;
            font-size: 0.78rem !important;
        }
        .dataTables_length select {
            font-size: 0.78rem !important;
            padding: 2px 24px 2px 8px !important;
            height: auto !important;
            border-radius: 4px !important;
            min-width: 65px !important;
        }
        .dataTables_filter input {
            font-size: 0.78rem !important;
            padding: 4px 10px !important;
            height: auto !important;
            border-radius: 4px !important;
            border: 1px solid #ced4da !important;
            max-width: 120px !important;
        }
        @media (min-width: 576px) {
            .dataTables_filter input {
                max-width: 180px !important;
            }
        }
        .dt-buttons .btn {
            padding: 6px 16px;
            font-size: 0.8rem;
            font-weight: 500;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.04);
            transition: all 0.2s ease;
        }
        .dt-buttons .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
        }
        .dropdown-menu {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 1px solid rgba(0,0,0,0.05);
            border-radius: 8px;
        }
        .dropdown-item {
            transition: background 0.15s ease;
        }
        .dropdown-item:hover {
            background-color: #f8f9fa;
        }
        .dropdown-toggle-nocaret::after {
            display: none !important;
        }
        @media (max-width: 991px) {
            .container-fluid {
                padding-left: 0 !important;
                padding-right: 0 !important;
            }
            .containergroup.card {
                border-radius: 0 !important;
                margin-left: 0 !important;
                margin-right: 0 !important;
                border: none !important;
                box-shadow: none !important;
            }
            .card-body {
                padding-left: 8px !important;
                padding-right: 8px !important;
            }
        }
        @media (max-width: 576px) {
            #categorytable thead th {
                font-size: 0.65rem !important;
                padding: 6px 4px !important;
            }
            #categorytable tbody td {
                font-size: 0.72rem !important;
                padding: 6px 4px !important;
            }
        }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Product Categories"; require_once("topbar.php"); ?>
            <div class="container-fluid mt-3">
                <div class="containergroup card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 font-weight-bold text-dark"><i class="fal fa-tags mr-2 text-primary" style="font-size: 1rem;"></i>Product Categories</h5>
                        <button id="addcategory" name="addcategory" class='btn btn-success btn-sm mr-2 d-none d-lg-inline-block' style='font-size: 0.76rem; font-weight: 500; padding: 4px 10px; margin-right: 6px;'><i class="fal fa-plus mr-1" style="font-size: 0.7rem;"></i> Add Category</button>
                    </div>
                    <div class="card-body">
                        <div id="errors"></div>
                        <div class="table-responsive">
                            <table class="table table-striped table-sm table-hover w-100" id="categorytable">
                                <thead class="thead-light">
                                    <th>#</th>
                                    <th>Description</th>
                                    <th>Prefix</th>
                                    <th>Current No</th>
                                    <th class="d-none d-md-table-cell">Date Added</th>
                                    <th class="d-none d-lg-table-cell">Added By</th>
                                    <th class="text-right" style="width: 100px; padding-right: 20px;">Actions</th>
                                </thead> 
                                <tbody id="categorylist"></tbody>            
                                <tfoot></tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Floating Action Button for Mobile/Tablet -->
            <button id="addcategory_fab" class="btn btn-success rounded-circle shadow-lg d-lg-none" style="position: fixed; bottom: 20px; right: 15px; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; z-index: 1050; border: none; box-shadow: 0 4px 15px rgba(40,167,69,0.4) !important;">
                <i class="fal fa-plus text-white" style="font-size: 0.9rem;"></i>
            </button>

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
                        <button type="button" class="btn btn-success btn-sm" id="savecategory" style="font-weight: 500;"><i class="fal fa-save mr-1" style="font-size: 0.78rem;"></i>Save Category</button>
                        <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal" style="font-weight: 500;"><i class="fal fa-times mr-1" style="font-size: 0.78rem;"></i>Close</button>
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
