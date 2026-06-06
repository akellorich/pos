<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Purchases </title>
    <style>
      /* Responsive customizations for the Purchase List page */
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
      
      /* DataTable responsiveness and action icon design */
      .table-responsive {
          border-radius: 6px;
          overflow: visible !important;
      }
      
      .dropdown-menu {
          z-index: 1050 !important;
      }
      
      #orderlist td a {
          color: #34495e;
          transition: color 0.2s ease;
      }
      
      #orderlist td a:hover {
          color: #2b5c8f;
      }
      
      #orderlist td span i {
          font-size: 1.1rem;
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

      /* Responsive DataTable improvements */
      .dt-buttons-container {
          display: flex;
          flex-wrap: wrap;
          gap: 8px;
          margin-bottom: 15px;
      }

      .dt-buttons-container .dt-buttons {
          display: flex;
          flex-wrap: wrap;
          gap: 8px;
          width: 100%;
      }

      .dt-buttons-container .btn {
          border-radius: 6px;
          font-weight: 500;
          padding: 8px 16px !important; /* Increased padding for default/mobile views */
          line-height: 1.3 !important;   /* Comfortably increased height */
          display: inline-flex;
          align-items: center;
          justify-content: center;
          box-shadow: 0 2px 4px rgba(0,0,0,0.05);
          transition: all 0.2s ease;
          margin: 0 !important; /* Override DataTable default margin */
      }

      .dt-buttons-container .btn:hover {
          transform: translateY(-1px);
          box-shadow: 0 4px 6px rgba(0,0,0,0.08);
      }

      /* On tablet and desktop views, comfortably proportion button heights and icon sizes */
      @media (min-width: 576px) {
          .dt-buttons-container .btn {
              padding: 6px 12px !important; /* Comfortably increased padding on larger viewports */
              line-height: 1.2 !important;  /* Balanced line-height */
              font-size: 0.72rem !important; /* Refined font size */
          }
          
          .dt-buttons-container .btn i {
              font-size: 0.75rem !important; /* Slightly increased icon size on tablet & desktop */
              margin-right: 4px !important;
          }
      }

      .dt-controls-container {
          display: flex;
          flex-direction: row !important; /* Always display length-menu and search on the same row */
          justify-content: space-between !important;
          align-items: center !important;
          gap: 8px;
          margin-bottom: 15px;
          flex-wrap: nowrap !important;
      }

      /* Compact inputs on mobile view to prevent row wrapping */
      @media (max-width: 575.98px) {
          .dataTables_wrapper .dataTables_filter input {
              width: 100px !important;
              padding: 4px 8px !important;
              font-size: 0.78rem !important;
          }
          .dataTables_wrapper .dataTables_length select {
              padding: 4px 24px 4px 8px !important;
              font-size: 0.78rem !important;
              min-width: 65px !important;
          }
          .dataTables_wrapper .dataTables_length,
          .dataTables_wrapper .dataTables_filter {
              font-size: 0.78rem !important;
          }
      }

      /* Premium DataTable overrides */
      .dataTables_wrapper .dataTables_length select {
          border: 1px solid #ced4da;
          border-radius: 6px;
          padding: 4px 24px 4px 8px !important;
          outline: none;
          min-width: 65px !important;
      }

      .dataTables_wrapper .dataTables_filter input {
          border: 1px solid #ced4da;
          border-radius: 6px;
          padding: 6px 12px;
          outline: none;
          margin-left: 8px;
          transition: border-color 0.2s ease;
      }

      .dataTables_wrapper .dataTables_filter input:focus {
          border-color: #2b5c8f;
      }

      #toggleFiltersBtn {
          transition: all 0.3s ease;
      }
      
      #toggleFiltersBtn:hover {
          transform: translateY(-1px);
          box-shadow: 0 6px 12px rgba(43, 92, 143, 0.25);
      }

      /* Mobile styles for DataTable buttons */
      @media (max-width: 575.98px) {
          .dt-buttons-container .btn {
              padding: 4px 8px !important;
              font-size: 0.7rem !important;
              border-radius: 4px !important;
          }
          
          /* Shrunk icon sizes for all individual export buttons globally */
          .dt-buttons-container .btn i {
              font-size: 0.8rem !important; /* Slightly increased mobile icon size */
              margin-right: 5px !important;
          }
      }

      /* Floating Action Button (FAB) styling for mobile/tablet view */
      #mobileAddPurchaseFAB {
          position: fixed !important;
          bottom: 25px !important;
          right: 25px !important;
          width: 48px !important; /* Slightly smaller width */
          height: 48px !important; /* Slightly smaller height */
          border-radius: 50% !important;
          background-color: #28a745 !important; /* Premium filled success color */
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
          font-size: 1.2rem !important; /* Slightly smaller icon size */
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
    <?php $pagename = "Purchases"; require_once("topbar.php"); ?>
        <div class="container-fluid">
            <div class="row mt-2">
                <div class="col-12 col-lg-3 mb-4">
                    <!-- Collapsible wrapper: collapsed on mobile/tablet, visible block on desktop -->
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
                                <label for="filterdepartment">Department</label>
                                <select name="filterdepartment" id="filterdepartment" class="form-control form-control-sm"></select>
                            </div>

                            <div class="form-group">
                                <label for="potype">Purchase Type</label>
                                <select name="purchasetype" id="purchasetype" class="form-control form-control-sm">
                                    <option value="0">&lt;All&gt;</option>
                                    <option value="product">Product</option>
                                    <option value="rawmaterial">Raw Material</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="filtgercurrency">Currency</label>
                                <select name="filtercurrency" id="filtercurrency" class="form-control form-control-sm"></select>
                            </div>

                            <div class="form-group">
                                <label for="supplier">Supplier</label>
                                <select id="supplier" name="supplier" class="form-control form-control-sm"></select>
                            </div>

                            <div class="form-group">
                                <label for="postatus">Purchase Order Status</label>
                                <select id="postatus" name="postatus" class="form-control form-control-sm">
                                    <option value="all">&lt;All&gt;</option>
                                    <option value="pending">Pending</option>
                                    <option value="approved">approved</option>
                                    <option value="delivered">Deelivered</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                            </div>

                            <div class="filter-actions">
                                <button type="button" class="btn btn-secondary btn-sm" id="search" name="search"><i class="fal fa-search fa-fw fa-lg"></i> Filter Orders</button>
                                <button type="button" id="addorder" name="addorder" class="btn btn-success btn-sm"><i class="fal fa-plus-circle fa-fw fa-lg"></i> Add Order</button>
                            </div>
                        </div>
                    </div>
                    </div> <!-- Closing #filterCollapse wrapper -->
                </div>
                <div class="col-12 col-lg-9" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5>Purchases in the system</h5>
                            <!-- Collapse toggle button visible ONLY on mobile/tablet inside the header -->
                            <button class="btn btn-outline-primary btn-xs d-lg-none d-flex align-items-center" 
                                    type="button" 
                                    data-toggle="collapse" 
                                    data-target="#filterCollapse" 
                                    aria-expanded="false" 
                                    aria-controls="filterCollapse"
                                    id="toggleFiltersBtn"
                                    style="border-radius: 4px; font-weight: 500; font-size: 0.75rem; padding: 4px 8px; border: 1px solid #2b5c8f; color: #2b5c8f; background: transparent;">
                                <i class="fal fa-filter mr-1" style="font-size: 0.8rem;"></i>
                                <span>Filters</span>
                            </button>
                        </div>
                        <div class="card-body">
                            <div id="purchaseordererrors"></div>
                            <div class="table-responsive">
                                <table class="table table-striped table-sm" id="orderlist">
                                    <thead class="thead-light" >
                                        <th>#</th>
                                        <th>Order No</th>
                                        <th>Supplier</th>
                                        <th>Order Total</th>
                                        <th>Status</th>
                                        <th class="d-none d-md-table-cell">Date Added</th>
                                        <th class="d-none d-md-table-cell">Added By</th>
                                        <th class="text-center">Action</th>
                                    </thead>
                                    <tbody ></tbody>
                                </table>
                            </div>
                        
                            <div class="col-md-12 text-center">
                            <ul class="pagination pagination-lg pager" id="myPager"></ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
  </section>
  <!-- Modal for approving purchaseorders  -->
  <div class="modal" tabindex="-1" role="dialog" id="approvepurchaseordermodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Approve Purchase Order As ...</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="approvallevels">

                    </div>
                    <div class="form-group">
                        <label for="approvalnarration">Approval Remarks:</label>
                        <textarea name="approvalnarration" id="approvalnarration" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="approvepurchaseorderbtn">Approve</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for Rejecting purchaseorders  -->
    <div class="modal" tabindex="-1" role="dialog" id="rejectpurchaseordermodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Reject Purchase Order As ...</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="rejecterrors"></div>
                    <div id="rejectionlevels">

                    </div>
                    <div class="form-group">
                        <label for="rejectionnarration">Rejection Remarks:</label>
                        <textarea name="rejectionnarration" id="rejectionnarration" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="rejectpurchaseorderbtn">Reject</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/purchaseslist.js"></script>
  <!-- Floating Action Button for adding a new purchase (visible ONLY on mobile/tablet) -->
  <button type="button" class="btn btn-success d-lg-none" id="mobileAddPurchaseFAB" title="Add Purchase">
      <i class="fal fa-plus"></i>
  </button>

  <script>
      $(document).ready(function() {
          $('#mobileAddPurchaseFAB').on('click', function() {
              $('#addorder').trigger('click');
          });
      });
  </script>
</html>