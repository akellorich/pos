<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Stock Taking </title>
    <style>
      /* Responsive customizations for the Stock Taking page */
      @media (max-width: 991.98px) {
          #receiptlist {
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
          #receiptlist {
              padding-left: 4px !important;
              padding-right: 4px !important;
          }
          .card-body {
              padding-left: 8px !important;
              padding-right: 8px !important;
          }
      }
      
      @media (min-width: 992px) {
          #filterCollapse .containergroup.card,
          #receiptlist .containergroup.card {
              height: calc(100vh - 95px) !important;
              display: flex;
              flex-direction: column;
          }
          #filterCollapse .card-body-list,
          #receiptlist .card-body {
              flex: 1;
              overflow-y: auto;
              height: calc(100vh - 135px) !important;
              max-height: none !important;
          }
      }

      .filter-actions {
          display: flex;
          flex-direction: column;
          gap: 10px;
          margin-top: 15px;
      }
      
      .filter-actions button {
          width: 100% !important;
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
      
      /* Responsive DataTable improvements */
      .table-responsive {
          border-radius: 6px;
          overflow: visible !important;
      }

      /* Adjust form controls inside filters for cleaner spacing */
      .form-group {
          margin-bottom: 0.75rem;
      }
      
      .form-group label {
          font-weight: 500;
          color: #495057;
          margin-bottom: 0.25rem;
          font-size: 0.8rem;
      }

      /* Floating Action Button (FAB) styling for mobile/tablet view */
      #mobileAddPurchaseFAB {
          position: fixed !important;
          bottom: 25px !important;
          right: 25px !important;
          width: 48px !important;
          height: 48px !important;
          border-radius: 50% !important;
          background-color: #28a745 !important;
          color: #ffffff !important;
          border: none !important;
          box-shadow: 0 4px 15px rgba(40, 167, 69, 0.4) !important;
          z-index: 2050 !important;
          display: flex !important;
          align-items: center !important;
          justify-content: center !important;
          transition: transform 0.2s ease, box-shadow 0.2s ease !important;
          cursor: pointer !important;
      }

      #mobileAddPurchaseFAB i {
          font-size: 1.2rem !important;
          margin: 0 !important;
      }

      #mobileAddPurchaseFAB:hover {
          transform: scale(1.08) !important;
          box-shadow: 0 6px 20px rgba(40, 167, 69, 0.5) !important;
      }
      
      #mobileAddPurchaseFAB:active {
          transform: scale(0.95) !important;
      }

      @media (min-width: 992px) {
          #mobileAddPurchaseFAB {
              display: none !important;
          }
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Stock Taking"; require_once("topbar.php"); ?>
            <!-- Page Content -->
            <div class="container-fluid">
                <div class="row mt-2">
                    <div class="col-12 col-lg-3 mb-4">
                        <div class="collapse d-lg-block" id="filterCollapse">
                            <div class="containergroup card">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body card-body-list">
                                    <div id="errors"></div>
                                    <div class="check-group">
                                        <input type="checkbox" class="check-control" id="alldates" name="alldates">
                                        <label for="alldates" class="check-label">All Dates</label>
                                    </div>

                                    <div class="form-group">
                                        <label for="startdate">Start Date</label>
                                        <input type="text"  autocomplete="off" id="startdate" name="startdate" class="form-control form-control-sm">
                                    </div>

                                    <div class="form-group">
                                        <label for="enddate">End Date</label>
                                        <input type="text"  autocomplete="off" id="enddate" name="enddate" class="form-control form-control-sm">
                                    </div>

                                    <div class="form-group">
                                        <label for="customer">Customer</label>
                                        <select id="customer" name="customer" class="form-control form-control-sm"></select>
                                    </div>

                                    <div class="form-group">
                                        <label for="postatus">Status</label>
                                        <select id="postatus" name="postatus" class="form-control form-control-sm">
                                            <option value="all">&lt;All&gt;</option>
                                            <option value="pending">Pending</option>
                                            <option value="approved">approved</option>
                                            <option value="delivered">Deelivered</option>
                                            <option value="cancelled">Cancelled</option>
                                        </select>
                                    </div>

                                    <div class="filter-actions">
                                        <button type="button" class="btn btn-secondary btn-sm" id="search" name="search"><i class="fas fa-search fa-fw fa-lg"></i> Filter Orders</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-lg-9" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5>Stock Takes In the System</h5>
                                <!-- Collapse toggle button visible ONLY on mobile/tablet inside the header -->
                                <button class="btn btn-outline-primary btn-xs d-lg-none d-flex align-items-center" 
                                        type="button" 
                                        data-toggle="collapse" 
                                        data-target="#filterCollapse" 
                                        aria-expanded="false" 
                                        aria-controls="filterCollapse"
                                        id="toggleFiltersBtn"
                                        style="border-radius: 4px; font-weight: 500; font-size: 0.75rem; padding: 4px 8px; border: 1px solid #2b5c8f; color: #2b5c8f; background: transparent;">
                                    <i class="fas fa-filter mr-1" style="font-size: 0.8rem;"></i>
                                    <span>Filters</span>
                                </button>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped table-sm" id="ordertable">
                                        <thead class="thead-light" >
                                            <th>Customer Id</th>
                                            <th>Customer Name</th>
                                            <th>Stock Take Date</th>
                                            <th>Items</th>
                                            <th>Date Added</th>
                                            <th>Added By</th>
                                            <th>&nbsp;</th> <!-- Stock take details -->
                                        </thead>

                                        <tbody id="stocktakelist"></tbody>
                                        
                                        <tfoot></tfoot>
                                    </table>
                                </div>
                            
                                <div class="col-md-12 text-center mt-3">
                                    <ul class="pagination pagination-lg pager" id="myPager"></ul>
                                </div>
                                <button type="button" id="addorder" name="addorder" Value="" class="btn btn-success btn-sm d-none d-lg-inline-block"><i class="fas fa-plus-circle fa-fw fa-lg"></i> Add Stock Take</button>
                            </div>
                        </div>
                        <!-- FAB visible on mobile only -->
                        <button id="mobileAddPurchaseFAB" type="button" class="d-lg-none">
                            <i class="fas fa-plus"></i>
                        </button>
                </div>

            </div>
        </div>
    </section>

    <!-- Modal for Stocktake details  -->
    <div class="modal" tabindex="-1" role="dialog" id="stocktakedetailsmodal">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Stock Take Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="stocktakeerrors"></div>
                    <div class="row">
                        <div class="col form-group">
                            <label for="stocktakecustomer">Customer:</label>
                            <select name="stocktakecustomer" id="stocktakecustomer" class="form-control form-control-sm"></select>
                        </div>

                        <div class="col form-group">
                            <label for="stocktakedate">Date:</label>
                            <input type="text" name="stocktakedate" id="stocktakedate" class="form-control form-control-sm">
                        </div>

                        <div class="col form-group">
                            <label for="stocktaketype">Type:</label>
                            <select name="stocktaketype" id="stocktaketype" class="form-control form-control-sm">
                                <option value="original">Original</option>
                                <option value="ammendment">Ammendment</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col form-group">
                            <label for="itemcode">Item code</label>
                            <div class="input-group">
                                <input type="text" class="form-control form-control-sm" placeholder="Item bar code" id="itemcode">
                                <div class="input-group-append">
                                    <button class="btn btn-sm btn-secondary" id="asssearchproduct"><i class="fal fa-search fa-lg fa-fw"></i></button>
                                </div>
                            </div>
                        </div>
                        <div class="col form-group">
                            <label for="itemname">Item Name</label>
                            <input type="text" name="itemname" id="itemname" class="form-control form-control-sm" disabled data-id="" data-itemcode="">
                        </div>

                        <div class="col form-group">
                            <label for="itemcode">Quantity</label>
                            <div class="input-group">
                                <input type="number" class="form-control form-control-sm" placeholder="Stock Quantity" id="stockquantity">
                                <div class="input-group-append">
                                    <button class="btn btn-sm btn-secondary" id="additemquantity"><i class="fal fa-plus fa-lg fa-fw"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="scrollable">
                        <table class="table table-sm table-striped" id="stocktakingtable">
                            <thead>
                                <th>#</th>
                                <th>Item Code</th>
                                <th>Item Name</th>
                                <th>Quantity</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-success btn-sm">Save Changes</button>
                <button type="button" class="btn btn-sm btn-outline-danger" data-dismiss="modal">Close Window</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/stocktaking.js"></script>
</html>
