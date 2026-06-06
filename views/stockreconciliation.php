<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Stock Adjustment </title>
     <style>
       /* Responsive customizations for the Stock Reconciliation page */
       @media (max-width: 991.98px) {
           #step2-container {
               margin-left: 0 !important;
               padding-left: 15px !important;
               padding-right: 15px !important;
           }
           .card-body-list {
               height: auto !important;
               max-height: 450px;
               overflow-y: auto;
           }
       }

       /* Reduce paddings and margins of container-fluid on mobile view */
       @media (max-width: 767.98px) {
           .container-fluid {
               padding-left: 8px !important;
               padding-right: 8px !important;
           }
           .row.mt-2 {
               margin-left: -4px !important;
               margin-right: -4px !important;
           }
           .col-12 {
               padding-left: 4px !important;
               padding-right: 4px !important;
           }
           #step2-container {
               padding-left: 4px !important;
               padding-right: 4px !important;
           }
           .card-body {
               padding-left: 8px !important;
               padding-right: 8px !important;
           }
       }

       @media (min-width: 992px) {
           #step1-container .containergroup.card,
           #step2-container .containergroup.card {
               height: calc(100vh - 95px) !important;
               display: flex;
               flex-direction: column;
           }
           #step1-container .card-body-list {
               flex: 1;
               overflow-y: auto;
               height: calc(100vh - 135px) !important;
               max-height: none !important;
           }
           #step2-container .card-body-list {
               display: flex;
               flex-direction: column;
               flex: 1;
               overflow: hidden;
               height: calc(100vh - 135px) !important;
               max-height: none !important;
               padding-bottom: 15px !important;
           }
           #tableWrapper {
               flex: 1;
               overflow-y: auto;
               margin-bottom: 15px !important;
           }
       }

       @media (max-width: 991.98px) {
           #tableWrapper {
               max-height: 300px !important;
               overflow-y: auto;
           }
       }

       /* Elevate the looks of the card shadows and headers */
       .containergroup.card {
           border: none;
           border-radius: 8px;
           box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
           transition: transform 0.2s ease, box-shadow 0.2s ease;
           background: #ffffff;
       }
       
       .containergroup.card:hover {
           box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
       }
       
       .containergroup .card-header {
           background-color: #f8f9fa;
           border-bottom: 1px solid rgba(0, 0, 0, 0.05);
           border-top-left-radius: 8px;
           border-top-right-radius: 8px;
           display: flex;
           align-items: center;
           height: 40px !important;
           padding: 10px 15px !important;
       }
       
       .containergroup .card-header h5 {
            margin-bottom: 0;
            font-size: 0.95rem;
            color: #2b5c8f;
        }

        #searchproducts {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            width: 100%;
            background: #ffffff;
            border: 1px solid rgba(0, 0, 0, 0.15);
            border-radius: 4px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            z-index: 2000;
            max-height: 250px;
            overflow-y: auto;
            display: none;
        }

        ul.searchresults {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        ul.searchresults li {
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            border-bottom: 1px solid #f1f1f1;
            transition: background-color 0.2s ease;
            color: #333333;
        }

        ul.searchresults li:hover {
            background-color: #eef5fc !important;
            color: #2b5c8f !important;
        }

        ul.searchresults li input[type="checkbox"] {
            cursor: pointer;
            width: 16px;
            height: 16px;
            margin: 0;
        }

        ul.searchresults li.select-all-row {
            border-bottom: 2px solid #e0e0e0;
            background-color: #fafafa;
        }

        ul.searchresults li.select-all-row:hover {
            background-color: #f0f0f0 !important;
            color: #333333 !important;
        }

        #selectAllSearchItems {
            cursor: pointer;
            width: 16px;
            height: 16px;
            margin: 0;
        }

        #load-all-items {
            transition: color 0.15s ease-in-out;
        }

        #load-all-items:hover {
            color: #007bff !important;
        }

        /* Sticky Fixed Footer on Mobile & Tablet */
        @media (max-width: 991px) {
            #reconciliation-footer {
                position: fixed;
                bottom: 0;
                left: 260px;
                right: 0;
                background-color: #ffffff;
                box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.15);
                padding: 10px 15px;
                z-index: 1030;
                margin: 0 !important;
                transition: left 0.5s ease;
                display: flex !important;
                flex-direction: row !important;
                align-items: center !important;
                justify-content: space-between !important;
                flex-wrap: nowrap !important;
            }
            
            #reconciliation-footer > .col-12 {
                flex: 0 0 auto !important;
                width: auto !important;
                max-width: none !important;
                margin: 0 !important;
                padding: 0 !important;
            }
            
            #reconciliation-footer .btn {
                margin-top: 0 !important;
                margin-right: 4px !important;
                margin-left: 0 !important;
                margin-bottom: 0 !important;
            }
            
            #reconciliation-footer .btn:last-child {
                margin-right: 0;
            }

            #reconciliation-footer .alert {
                padding: 6px 12px !important;
                margin-top: 0 !important;
                margin-bottom: 0 !important;
                white-space: nowrap;
            }
            
            /* Shift left when sidebar is closed */
            .sidebar.close1 ~ .home-section #reconciliation-footer {
                left: 78px;
            }
            
            /* Extra bottom padding to ensure table scrolled elements aren't blocked */
            #step2-container {
                margin-bottom: 75px !important;
            }
        }

        @media (max-width: 768px) {
            #reconciliation-footer {
                left: 0 !important;
            }
        }

        /* Centered alert modal styles */
        .alert-modal-centered .modal-dialog {
            max-width: 450px !important;
            margin: 1.75rem auto;
            display: flex;
            align-items: center;
            min-height: calc(100% - 3.5rem);
        }
        
        @media (max-width: 575px) {
            .alert-modal-centered .modal-dialog {
                max-width: 90% !important;
                margin: 1.75rem auto;
            }
        }

        .alert-modal-centered .modal-content {
            border: none !important;
            background: transparent !important;
            box-shadow: none !important;
        }

        .alert-modal-centered .modal-body {
            padding: 30px 20px 5px 20px !important;
            background: #ffffff;
            border-top-left-radius: 6px;
            border-top-right-radius: 6px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.25);
        }
        .alert-modal-centered .modal-body .alert {
            margin-bottom: 0 !important;
            margin-top: 15px !important;
            padding-top: 15px !important;
            padding-bottom: 15px !important;
        }
        
        .alert-modal-centered .close {
            position: absolute;
            top: 12px;
            right: 15px;
            z-index: 1050;
        }
        
        .alert-modal-centered .modal-footer {
            background-color: #ffffff;
            border-top: none;
            padding: 10px 20px 10px 20px !important;
            justify-content: center !important;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.25);
            margin-top: -2px;
            border-bottom-left-radius: 6px;
            border-bottom-right-radius: 6px;
        }
      </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Stock Adjustment"; require_once("topbar.php"); ?>
            <!-- Page Content -->
            <div class="container-fluid">
                <input type="hidden" id="id" name="id" value="0">
                <!-- <p class="lead text-center mt-2 mb-2">Stocklist Reconciliation</p> -->
                <div class="row mt-2">
                    <div class="col-12 col-lg-3 mb-4 pr-lg-1" id="step1-container">  
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Step 1 - Reconciliation Parameters</h5>
                            </div>
                            
                            <div class="card-body card-body-list">
                            <div class="col form-group">
                                <label for="category">Category</label>
                                <select name="category" id="category" class="form-control form-control-sm">
                                    <option value="outlet">Outlet</option>
                                    <option value="warehouse">Warehouse</option>
                                </select>
                            </div>
                                <div class="col form-group">
                                    <label for="posname">Outlet Name</label>
                                    <select id="posname" class="form-control form-control-sm">
                                        <option value="">&lt;Choose&gt;</option>
                                    </select>
                                </div>
                                <div class="col form-group">
                                    <label for="narrative">Reconcile Narrative:</label>
                                    <textarea name="narrative" id="narrative" class="form-control form-control-sm"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>   

                    <div class="col-12 col-lg-9 mb-4 pl-lg-1" id="step2-container">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Step 2 - Select Items to Reconcile</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div id="errors" class="mt-2"></div>     
                                <div class="form-group" style="position: relative;">
                                    <label for="itemcode">Item Code:</label>
                                    <div style="position: relative;">
                                        <input type="text" name="itemcode" id="itemcode" class="form-control form-control-sm" style="padding-right: 30px;" autocomplete="off">
                                        <span id="load-all-items" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #6c757d; z-index: 10;" title="Load all inventory items">
                                            <i class="fas fa-download fa-xs"></i>
                                        </span>
                                    </div>
                                    <div id="searchproducts"></div>
                                </div>

                                <div id="tableWrapper" class="table-responsive mb-2">
                                    <table id="purchaseitems" name="purchaseitems" class="table table-striped table-sm table-hover nowrap" style="width: 100%;">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Item Code</th>
                                                <th>Item Name</th>
                                                <th class="text-right d-none d-md-table-cell">Unit Price</th>
                                                <th class="text-right d-none d-md-table-cell">Discount</th>
                                                <th class="text-right d-none d-md-table-cell">Ext. Price</th>
                                                <th class="text-right">Quantity</th>
                                                <th class="text-right d-none d-md-table-cell">Line Total</th>
                                                <th>&nbsp;</th>
                                            </tr>
                                        </thead>
                                        <tbody id="purchaseitemsdetails"></tbody>
                                        <tfoot>  
                                        </tfoot>
                                    </table>
                                </div>
                                <div class="row" id="reconciliation-footer">
                                    <div class="col-12 col-md-9">
                                        <button type="button" id="save" name="save" class="btn btn-success btn-sm mt-2" title="Save Reconciliation"><i class="fas fa-save fa-fw fa-lg"></i> <span class="d-none d-sm-inline">Save Reconciliation</span></button>
                                        <button type="button" id="clear" name="clear" class="btn btn-danger btn-sm mt-2" title="Clear Form"><i class="fas fa-eraser fa-fw fa-lg"></i> <span class="d-none d-sm-inline">Clear Form</span></button>
                                        <button type="button" id="reset-all" name="reset-all" class="btn btn-secondary btn-sm mt-2" title="Reset All"><i class="fas fa-history fa-fw fa-lg"></i> <span class="d-none d-sm-inline">Reset All</span></button>
                                    </div>
                                    <div class="col-12 col-md-3 mt-2 mt-md-0">
                                        <p class="text-right font-weight-bold alert alert-info mb-0">TOTAL: 
                                            <span id="overalltotal">
                                                0.00
                                            </span>
                                        </p>
                                    </div>
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
<script type="text/javascript" src="../js/stockreconciliation.js"></script>
</html>
