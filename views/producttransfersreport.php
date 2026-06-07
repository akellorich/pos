<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Transfers Report </title>
    <style>
      /* Responsive customizations for the Transfers Report page */
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
          /* Reduce spacing between filter and report sections */
          .row.mt-2 > .col-lg-2,
          .row.mt-2 > .col-lg-10 {
              padding-left: 3px !important;
              padding-right: 3px !important;
          }
          .row.mt-2 {
              margin-left: -3px !important;
              margin-right: -3px !important;
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

      /* Premium DataTable controls styling */
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
    </style>
  </head>
  <body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Transfers Report"; require_once("topbar.php"); ?>
        <div class="container-fluid"> 
            <div class="row mt-2">
                <div class="col-12 col-lg-2 mb-4">
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
                                    <input type="text" id="startdate" autocomplete="off" name="startdate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="enddate">End Date</label>
                                    <input type="text" id="enddate" autocomplete="off" name="enddate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="storetype">Store Type:</label>
                                    <select name="storetype" id="storetype" class="form-control form-control-sm">
                                        <option value="">&lt;Choose&gt;</option>
                                        <option value="pos">POS</option>
                                        <option value="warehouse">Warehouse</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="storename">Store Name</label>
                                    <select name="storename" id="storename" class="form-control form-control-sm">
                                        <option value="">&lt;Choose&gt;</option>
                                    </select>
                                </div>
                                
                                <div class="filter-actions">
                                    <button type="button" class="btn btn-secondary btn-sm" id="generatereport" name="generatereport"><i class="fal fa-sync fa-sm mr-1"></i>Generate Report</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-lg-10" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5>Product Transfers Report</h5>
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
                            <div class="table-responsive">
                                <table class="table table-sm table-striped table-hover" id='report'>
                                     <thead>
                                         <th data-priority="8">#</th>
                                         <th data-priority="7">Product Code</th>
                                         <th data-priority="1">Product Name</th>
                                         <th data-priority="2" class="text-right"><span class="d-none d-sm-inline">Opening Balance</span><span class="d-inline d-sm-none">O/B</span></th>
                                         <th data-priority="3" class="text-right"><span class="d-none d-sm-inline">Purchases</span><span class="d-inline d-sm-none">P</span></th>
                                         <th data-priority="4" class="text-right"><span class="d-none d-sm-inline">Transfers In</span><span class="d-inline d-sm-none">In</span></th>
                                         <th data-priority="5" class="text-right"><span class="d-none d-sm-inline">Transfers Out</span><span class="d-inline d-sm-none">Out</span></th>
                                         <th data-priority="6" class="text-right">Balance</th>
                                     </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
  </body>
  <?php require_once("footer.txt") ?>
  <script type="text/javascript" src="../js/producttransfersreport.js"></script>
</html>