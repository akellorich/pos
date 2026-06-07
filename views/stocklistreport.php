<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Stock List </title>
    <style>
      /* Responsive customizations for the Stock List page */
      @media (max-width: 991.98px) {
          #receiptlist {
              margin-left: 0 !important;
              padding-left: 15px !important;
              padding-right: 15px !important;
          }
          #receiptlist .containergroup.card {
              height: calc(100vh - 90px);
              display: flex;
              flex-direction: column;
          }
          .card-body-list {
              flex: 1;
              height: auto !important;
              max-height: none !important;
              overflow-y: auto;
              padding-bottom: 24px !important;
          }
      }

      @media (min-width: 992px) {
          #filteroptions {
              padding-right: 6px !important;
          }
          #receiptlist {
              padding-left: 6px !important;
          }
          #filterCollapse .containergroup.card,
          #receiptlist .containergroup.card {
              height: calc(100vh - 95px) !important;
              display: flex;
              flex-direction: column;
          }
          #filterCollapse .card-body {
              flex: 1;
              overflow-y: auto;
              overflow-x: hidden !important;
              height: calc(100vh - 135px) !important;
              max-height: none !important;
          }
          #receiptlist .card-body-list {
              flex: 1;
              overflow-y: auto;
              height: calc(100vh - 135px) !important;
              max-height: none !important;
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
          overflow-x: auto !important;
          -webkit-overflow-scrolling: touch;
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

      /* Force show entries and search to always stay on the same row */
      .dt-controls-container {
          display: flex !important;
          flex-direction: row !important;
          justify-content: space-between !important;
          align-items: center !important;
          gap: 8px;
          margin-bottom: 15px;
          flex-wrap: nowrap !important;
          width: 100% !important;
      }

      .dataTables_wrapper .dataTables_length,
      .dataTables_wrapper .dataTables_filter {
          display: inline-flex !important;
          align-items: center !important;
          margin: 0 !important;
      }

      /* Force all export buttons onto a single horizontal scrollable row */
      .dt-buttons-container {
          display: flex !important;
          flex-direction: row !important;
          flex-wrap: nowrap !important;
          overflow-x: auto !important;
          gap: 6px !important;
          margin-bottom: 15px !important;
          width: 100% !important;
          padding-bottom: 4px !important;
          scrollbar-width: none; /* Firefox */
      }

      .dt-buttons-container::-webkit-scrollbar {
          display: none; /* Safari/Chrome */
      }

      .dt-buttons-container .dt-buttons {
          display: flex !important;
          flex-direction: row !important;
          flex-wrap: nowrap !important;
          gap: 6px !important;
      }

      .dt-buttons-container .btn {
          white-space: nowrap !important;
          padding: 6px 12px !important;
          font-size: 0.75rem !important;
          border-radius: 6px !important;
          margin: 0 !important;
          display: inline-flex !important;
          align-items: center !important;
          justify-content: center !important;
      }

      /* Reduce table cell and header font size on mobile view slightly */
      @media (max-width: 575.98px) {
          #stocklistreport th,
          #stocklistreport td {
              font-size: 0.72rem !important;
              padding: 6px 8px !important;
          }
          
          .dt-buttons-container .btn {
              padding: 4px 8px !important;
              font-size: 0.68rem !important;
          }
      }

      /* Space between the responsive expand (+) button and the first data column */
      #stocklistreport td.dtr-control,
      #stocklistreport th.dtr-control {
          padding-right: 12px !important;
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Stock List"; require_once("topbar.php"); ?>
            <div class="container-fluid mt-2"> 
                <div class="row">
                    <div class="col-12 col-lg-3 mb-4" id="filteroptions">
                        <div class="collapse d-lg-block" id="filterCollapse">
                            <div class="containergroup card">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body">
                                    <div id="errors"></div>
                                    <div class="row align-items-center">
                                        <div class="col-12 col-md-6 col-lg-12 mb-3">
                                            <div class="form-group mb-0">
                                                <label for="startdate" class="font-weight-bold text-muted" style="font-size: 0.8rem;">Stock List As At</label>
                                                <input type="text" id="startdate" name="startdate" autocomplete="off" class="form-control form-control-sm">
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-6 col-lg-12 mb-3 d-flex align-items-center mt-md-4 mt-lg-0">
                                            <div class="custom-control custom-switch">
                                                <input type="checkbox" class="custom-control-input" id="omit_zero" name="omit_zero" checked style="cursor: pointer;">
                                                <label class="custom-control-label font-weight-bold text-muted" for="omit_zero" style="font-size: 0.8rem; cursor: pointer; user-select: none; padding-left: 5px;">Omit Zero Quantity</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-end mt-2">
                                        <button type="button" class="btn btn-secondary btn-sm" id="search" name="search" style="min-width: 150px; font-weight: 500;">
                                            <i class="fal fa-sync mr-2" style="font-size: 0.78rem;"></i>Generate Report
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>     
                    </div>

                    <div class="col-12 col-lg-9" id="receiptlist">
                        <div class="containergroup card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5>Stocklist Report</h5>
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
                            <div class="card-body card-body-list">
                                <div class="table-responsive">
                                    <table id="stocklistreport" class="table table-sm table-striped table-hover dt-responsive nowrap" style="width: 100%;">
                                        <thead></thead>
                                        <tbody></tbody>
                                        <tfoot></tfoot>
                                    </table> 
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
<script type="text/javascript" src="../js/stocklistreport.js?v=<?php echo time(); ?>"></script>
</html>