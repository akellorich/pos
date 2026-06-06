<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Products </title>
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
        #productstable thead th {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
            padding: 10px 8px;
            border-bottom: 2px solid #dee2e6;
        }
        #productstable tbody td {
            font-size: 0.78rem;
            padding: 8px 8px;
            vertical-align: middle;
        }
        @media (max-width: 576px) {
            #productstable thead th {
                font-size: 0.65rem !important;
                padding: 6px 4px !important;
            }
            #productstable tbody td {
                font-size: 0.72rem !important;
                padding: 6px 4px !important;
            }
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
            white-space: nowrap;
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
        #btnDownloadTemplate:hover {
            background-color: rgba(0, 123, 255, 0.08) !important;
            color: #0056b3 !important;
        }
        #btnDownloadTemplate:hover i {
            color: #0056b3 !important;
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
        
        /* 90% Height Bulk Import Modal styling */
        #importModal {
            z-index: 2050 !important;
        }
        #importModal.show {
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
        }
        #importModal .modal-dialog {
            max-width: 95%;
            width: 95%;
            height: 90vh;
            margin: 0 !important;
        }
        #importModal .modal-content {
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .modal-backdrop {
            z-index: 2040 !important;
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            background-color: rgba(0, 0, 0, 0.4) !important;
        }
        body.modal-open .sidebar {
            filter: blur(4px);
            pointer-events: none;
        }
        #importModal .modal-body {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 0;
        }
        #importModal .modal-body > .row {
            flex: 1;
            display: flex;
            min-height: 0;
        }
        #importModal .modal-body > .row > .col-md-5 {
            height: 100%;
            overflow-y: auto;
        }
        #importModal .modal-body > .row > .col-md-7 {
            height: 100%;
            display: flex;
            flex-direction: column;
            min-height: 0;
        }
        #previewTableContainer {
            flex: 1;
            min-height: 0;
            overflow: auto !important;
        }
        #previewEmptyState {
            flex: 1;
            min-height: 0;
        }
    </style>
   </head>
 <body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <?php $pagename = "Products"; require_once("topbar.php"); ?>
        <div class="container-fluid mt-3">
            <div class="containergroup card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 font-weight-bold text-dark"><i class="fal fa-boxes mr-2 text-primary" style="font-size: 1rem;"></i>Products In The System</h5>
                </div>
                <div class="card-body">
                    <div id="errors"></div>
                    <div class="table-responsive">
                        <table class="table table-striped table-sm table-hover w-100" id="productstable">
                            <thead class="thead-light">
                                <th>#</th>
                                <th class="d-none d-lg-table-cell">Category Name</th>
                                <th>Item Code</th>
                                <th>Item Name</th>
                                <th class="d-none d-md-table-cell">Buying Price</th>
                                <th>Retail Price</th>
                                <th class="d-none d-md-table-cell">Wholesale Price</th>
                                <th class="d-none d-lg-table-cell">Date Added</th>
                                <th class="d-none d-lg-table-cell">Added By</th>
                                <th class="text-right" style="width: 100px; padding-right: 20px;">Actions</th>
                            </thead>
                            <tbody id="productlist"></tbody>
                            <tfoot></tfoot>
                        </table>            
                    </div>
                    <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                        <div></div>
                        <div class="d-flex align-items-center">
                            <!-- Split Dropdown for Import -->
                            <div class="btn-group mr-2">
                                <button type="button" class="btn btn-outline-success btn-sm" id="btnImportProducts" style="font-size: 0.76rem; font-weight: 500; padding: 6px 14px;">
                                    <i class="fal fa-file-import mr-1" style="font-size: 0.75rem;"></i> Import Products
                                </button>
                                <button type="button" class="btn btn-outline-success btn-sm dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="padding-left: 8px; padding-right: 8px;">
                                    <span class="sr-only">Toggle Dropdown</span>
                                </button>
                                <div class="dropdown-menu dropdown-menu-right">
                                    <a class="dropdown-item" href="#" id="btnDownloadTemplate" style="font-size: 0.8rem; padding: 6px 16px;">
                                        <i class="fal fa-file-download mr-2 text-primary" style="font-size: 0.8rem;"></i> Download Template
                                    </a>
                                </div>
                            </div>
                            
                            <button id="addproduct" name="addproduct" class="btn btn-success btn-sm" style="font-size: 0.76rem; font-weight: 500; padding: 6px 14px;">
                                <i class="fal fa-plus mr-1" style="font-size: 0.7rem;"></i> Add New Product
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Floating Action Button for Mobile/Tablet -->
        <button id="addproduct_fab" class="btn btn-success rounded-circle shadow-lg d-lg-none" style="position: fixed; bottom: 20px; right: 15px; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; z-index: 1050; border: none; box-shadow: 0 4px 15px rgba(40,167,69,0.4) !important;">
            <i class="fal fa-plus text-white" style="font-size: 0.9rem;"></i>
        </button>

        <!-- Import Modal -->
        <div class="modal fade" id="importModal" tabindex="-1" role="dialog" aria-labelledby="importModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
                <div class="modal-content" style="border-radius: 12px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
                    <div class="modal-header bg-light" style="border-bottom: 1px solid #eef2f6; border-top-left-radius: 12px; border-top-right-radius: 12px; padding: 16px 24px;">
                        <h5 class="modal-title font-weight-bold text-dark d-flex align-items-center" id="importModalLabel">
                            <i class="fal fa-file-import text-primary mr-2" style="font-size: 1.25rem;"></i> Bulk Product Import
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="outline: none;">
                            <span aria-hidden="true" style="font-size: 1.5rem; color: #aaa;">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" style="padding: 24px;">
                        <!-- Step 1: File Selection and Options -->
                        <div class="row">
                            <!-- Left Column: Settings -->
                            <div class="col-md-5 border-right">
                                <h6 class="font-weight-bold text-secondary mb-3 d-flex align-items-center">
                                    <i class="fal fa-cog mr-2"></i> Import Parameters
                                </h6>
                                
                                <div class="form-group mb-4">
                                    <label class="font-weight-bold text-dark mb-1">Select Excel / CSV File:</label>
                                    <div class="custom-file">
                                        <input type="file" class="custom-file-input" id="importExcelFile" accept=".xlsx, .xls, .csv">
                                        <label class="custom-file-label" for="importExcelFile" style="font-size: 0.8rem; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">Choose file...</label>
                                    </div>
                                </div>

                                <div class="form-group mb-4">
                                    <label class="font-weight-bold text-dark mb-1">Category Assignment:</label>
                                    <div class="custom-control custom-radio mb-2">
                                        <input type="radio" id="catModeDynamic" name="categoryMode" class="custom-control-input" value="dynamic" checked>
                                        <label class="custom-control-label" for="catModeDynamic" style="font-size: 0.82rem;">Create categories from Excel sheet dynamically</label>
                                    </div>
                                    <div class="custom-control custom-radio mb-2">
                                        <input type="radio" id="catModeSpecific" name="categoryMode" class="custom-control-input" value="specific">
                                        <label class="custom-control-label" for="catModeSpecific" style="font-size: 0.82rem;">Assign all items to a specific category</label>
                                    </div>
                                    <select id="importCategorySelect" class="form-control form-control-sm mt-2" style="display: none;">
                                        <option value="">&lt;Select Category&gt;</option>
                                    </select>
                                </div>

                                <div class="form-group mb-4">
                                    <label class="font-weight-bold text-dark mb-1">Duplicate Verification & Codes:</label>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="chkCheckExists" checked>
                                        <label class="custom-control-label" for="chkCheckExists" style="font-size: 0.82rem;">Check if product exists (by Code or Name)</label>
                                    </div>
                                    <div class="custom-control custom-checkbox mb-2">
                                        <input type="checkbox" class="custom-control-input" id="chkGenerateCode">
                                        <label class="custom-control-label" for="chkGenerateCode" style="font-size: 0.82rem;">Auto-generate item code for all products</label>
                                    </div>
                                </div>

                                <div class="form-group mb-3">
                                    <label class="font-weight-bold text-dark mb-1">Stock Opening Balance:</label>
                                    <div class="custom-control custom-checkbox mb-3">
                                        <input type="checkbox" class="custom-control-input" id="chkImportOpeningBalance">
                                        <label class="custom-control-label" for="chkImportOpeningBalance" style="font-size: 0.82rem; font-weight: 600;">Import opening stock balance</label>
                                    </div>
                                    
                                    <!-- Opening Balance Sub-Section -->
                                    <div id="openingBalanceSection" class="p-3 bg-light rounded" style="display: none; border: 1px dashed #dee2e6;">
                                        <div class="form-group mb-2">
                                            <label class="small font-weight-bold text-dark mb-1">Stock Category:</label>
                                            <select id="importBalanceCategory" class="form-control form-control-sm">
                                                <option value="outlet">Outlet / POS</option>
                                                <option value="warehouse">Warehouse</option>
                                            </select>
                                        </div>
                                        <div class="form-group mb-2">
                                            <label class="small font-weight-bold text-dark mb-1">Store/Location Name:</label>
                                            <select id="importBalanceLocation" class="form-control form-control-sm">
                                                <option value="">&lt;Choose Location&gt;</option>
                                            </select>
                                        </div>
                                        <div class="custom-control custom-checkbox mt-2">
                                            <input type="checkbox" class="custom-control-input" id="chkAutoReconcile" checked>
                                            <label class="custom-control-label small" for="chkAutoReconcile">Auto-reconcile stock (updates balances instantly)</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Right Column: Preview Table -->
                            <div class="col-md-7 d-flex flex-column">
                                <h6 class="font-weight-bold text-secondary mb-3 d-flex align-items-center justify-content-between">
                                    <span><i class="fal fa-eye mr-2"></i> Sheet Preview</span>
                                    <span class="badge badge-info px-2 py-1" id="previewRowCount" style="font-size: 0.72rem;">0 rows loaded</span>
                                </h6>
                                
                                <div class="flex-grow-1 border rounded d-flex align-items-center justify-content-center bg-light" id="previewEmptyState" style="min-height: 250px;">
                                    <div class="text-center text-muted p-4">
                                        <i class="fal fa-file-excel fa-3x mb-3 text-secondary" style="font-size: 3rem;"></i>
                                        <p class="mb-0 small">Choose an Excel/CSV file to load the data preview here.</p>
                                    </div>
                                </div>
                                
                                <div class="flex-grow-1 table-responsive border rounded" id="previewTableContainer" style="display: none;">
                                    <table class="table table-sm table-striped table-hover mb-0 w-100" id="previewTable" style="font-size: 0.76rem; min-width: 800px;">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>#</th>
                                                <th>Code</th>
                                                <th>Item Name</th>
                                                <th>Category</th>
                                                <th>UOM</th>
                                                <th class="text-right">Buy Price</th>
                                                <th class="text-right">Retail Price</th>
                                                <th class="text-right">Op. Bal</th>
                                                <th class="text-center" style="width: 70px;">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody id="previewTableBody"></tbody>
                                    </table>
                                </div>
                                
                                <!-- Progress info / logs inside modal -->
                                <div id="importProgressContainer" class="mt-3" style="display: none;">
                                    <div class="progress mb-2" style="height: 8px; border-radius: 4px;">
                                        <div id="importProgressBar" class="progress-bar progress-bar-striped progress-bar-animated bg-success" role="progressbar" style="width: 0%"></div>
                                    </div>
                                    <div class="d-flex justify-content-between small text-muted">
                                        <span id="importStatusText">Processing...</span>
                                        <span id="importProgressPercent">0%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light" style="border-top: 1px solid #eef2f6; border-bottom-left-radius: 12px; border-bottom-right-radius: 12px; padding: 16px 24px;">
                        <button type="button" class="btn btn-success btn-sm d-flex align-items-center" id="btnDoImport" disabled style="font-size: 0.82rem;">
                            <i class="fal fa-file-import mr-1" style="font-size: 0.82rem;"></i> Start Import
                        </button>
                        <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal" style="font-size: 0.82rem;">
                            <i class="fal fa-times mr-1" style="font-size: 0.82rem;"></i> Cancel
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
  </section>
 </body>
 <?php require_once("footer.txt") ?>
 <script type="text/javascript" src="../js/productlist.js"></script>
</html>