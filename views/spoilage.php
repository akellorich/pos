<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Spoilage </title>
    <style>
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

      .dropdown-menu {
          z-index: 1050 !important;
      }
      
      #spoilagelist td a {
          color: #34495e;
          transition: color 0.2s ease;
      }
      
      #spoilagelist td a:hover {
          color: #2b5c8f;
      }
      
      #spoilagelist td span i {
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

      /* Premium DataTable improvements */
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
          padding: 8px 16px !important;
          line-height: 1.3 !important;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          box-shadow: 0 2px 4px rgba(0,0,0,0.05);
          transition: all 0.2s ease;
          margin: 0 !important;
      }

      .dt-buttons-container .btn:hover {
          transform: translateY(-1px);
          box-shadow: 0 4px 6px rgba(0,0,0,0.08);
      }

      @media (min-width: 576px) {
          .dt-buttons-container .btn {
              padding: 6px 12px !important;
              line-height: 1.2 !important;
              font-size: 0.72rem !important;
          }
          
          .dt-buttons-container .btn i {
              font-size: 0.75rem !important;
              margin-right: 4px !important;
          }
      }

      .dt-controls-container {
          display: flex;
          flex-direction: row !important;
          justify-content: space-between !important;
          align-items: center !important;
          gap: 8px;
          margin-bottom: 15px;
          flex-wrap: nowrap !important;
      }

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

      @media (max-width: 575.98px) {
          .dt-buttons-container .btn {
              padding: 4px 8px !important;
              font-size: 0.7rem !important;
              border-radius: 4px !important;
          }
          
          .dt-buttons-container .btn i {
              font-size: 0.8rem !important;
              margin-right: 5px !important;
          }
      }

      /* Floating Action Button (FAB) styling for mobile/tablet view */
      #mobileAddSpoilageFAB {
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

      #mobileAddSpoilageFAB i {
          font-size: 1.2rem !important;
          margin: 0 !important;
      }

      #mobileAddSpoilageFAB:hover {
          transform: scale(1.08) !important;
          box-shadow: 0 6px 20px rgba(40, 167, 69, 0.5) !important;
      }
      
      #mobileAddSpoilageFAB:active {
          transform: scale(0.95) !important;
      }

      @media (min-width: 992px) {
          #mobileAddSpoilageFAB {
              display: none !important;
          }
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Spoilage"; require_once("topbar.php"); ?>
        <div class="container-fluid">
                <div class="row mt-2">
                    <div class="col-12 col-lg-3 mb-4">
                        <div class="collapse d-lg-block" id="filterCollapse">
                            <div class="card containergroup filteroptions">
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
                                    <label for="category">Category</label>
                                    <select id="category" name="category" class="form-control form-control-sm"></select>
                                </div>

                                    <div class="form-group">
                                    <label for="product">Product</label>
                                    <select id="product" name="product" class="form-control form-control-sm"></select>
                                </div>

                                <div class="filter-actions">
                                    <button type="button" class="btn btn-secondary btn-sm w-100" id="search" name="search"><i class="fal fa-search fa-fw fa-lg"></i> Filter Spoilages</button>
                                    <button type="button" class="btn btn-success btn-sm w-100 d-none d-lg-block" id="addnew" name="addnew"><i class="fal fa-plus-circle fa-fw fa-lg"></i> Add Spoilage</button>
                                </div>
                            </div>
                        </div>
                        </div>
                    </div>
                    <div class="col-12 col-lg-9" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5>Spoilages in the System</h5>
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
                                    <table class="table table-striped table-sm" id="spoilagelist">
                                        <thead class="thead-light" >
                                            <th class="d-none d-md-table-cell">#</th>
                                            <th>Category</th>
                                            <th>Product</th>
                                            <th>Quantity</th>
                                            <th class="d-none d-md-table-cell">Narration</th>
                                            <th class="d-none d-md-table-cell">Date Added</th>
                                            <th class="d-none d-md-table-cell">Added By</th>
                                            <th class="text-center">Action</th>
                                        </thead>

                                    <tbody></tbody>
                                    
                                    <tfoot></tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <button id="mobileAddSpoilageFAB" type="button" class="d-lg-none">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            </div>
        </div>
    </section>  
        
    </div>
    <!-- Modal for adding a new spoilage  -->
    <div class="modal" tabindex="-1" role="dialog" id="spoilagedetailsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Spoilage Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="notifications"></div>
                    <!-- Added category for store and store selection -->
                    <div class="form-group">
                        <label for="storecategory">Store Category</label>
                        <select name="storecategory" id="storecategory" class="form-control form-control-sm">
                            <option value="">&lt;Choose&gt;</option>
                            <option value="warehouse">Warehouse</option>
                            <option value="outlet">Outlet</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="storeid">Store</label>
                        <select name="storeid" id="storeid" class="form-control form-control-sm">
                            <option value="">&lt;Choose&gt;</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="detailscategory">Item Category</label>
                        <select name="detailscategory" id="detailscategory" class="form-control form-control-sm"></select>
                    </div>
                    <div class="form-group">
                        <label for="detailsproduct">Product</label>
                        <select name="detailsprpduct" id="detailsproduct" class="form-control form-control-sm"></select>
                    </div>
                    <div class="form-group">
                        <label for="detailsquantity">Quantity</label>
                        <input type="number" name="detailsquantity" id="detailsquantity" class="form-control form-control-sm">
                    </div>
                    <div class="form-group">
                        <label for="detailsnarration">Narration</label>
                        <textarea name="detailsnarration" id="detailsnarrattion" class="form-control form-control-sm"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savespoilage">Save spoilage</button>
                    <button type="button" class="btn btn-secondary btn-sm" id="clearform">Clear Fields</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/spoilage.js"></script>
</html>