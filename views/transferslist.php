<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=B612+Mono&display=swap" rel="stylesheet">
    <title> SalesFlow | Transfers </title>
    <style>
      /* Responsive customizations for the Transfers List page */
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
      
      /* Make filter buttons wrap and look premium on all screens */
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
      
      #transferdetails td a {
          color: #34495e;
          transition: color 0.2s ease;
          text-decoration: none !important;
      }
      
      #transferdetails td a:hover {
          color: #2b5c8f;
          text-decoration: none !important;
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

      /* Custom Styles for Actions & Details Toggle */
      .dropdown-menu .dropdown-item {
          color: #1a202c !important;
          font-weight: 500 !important;
      }
      .dropdown-menu .dropdown-item:hover {
          color: #000000 !important;
          background-color: #f1f5f9 !important;
      }
      .dropdown-menu .dropdown-item i {
          font-size: 0.74rem !important;
      }
      .detail-row td {
          border-top: none !important;
      }

      /* Floating Action Button (FAB) styling for mobile/tablet view */
      #mobileAddTransferFAB {
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

      #mobileAddTransferFAB i {
          font-size: 1.2rem !important;
          margin: 0 !important;
      }

      #mobileAddTransferFAB:hover {
          transform: scale(1.08) !important;
          box-shadow: 0 6px 20px rgba(40, 167, 69, 0.5) !important;
      }
      
      #mobileAddTransferFAB:active {
          transform: scale(0.95) !important;
      }

      @media (min-width: 992px) {
          #mobileAddTransferFAB {
              display: none !important;
          }
      }
    </style>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <?php $pagename = "Transfers"; require_once("topbar.php"); ?>
        <div class="container-fluid">
            <div class="row mt-2" >
                <div class="col-12 col-lg-3 mb-4">
                    <!-- Collapsible wrapper: collapsed on mobile/tablet, visible block on desktop -->
                    <div class="collapse d-lg-block" id="filterCollapse">
                        <div class="containergroup card">
                            <div class="card-header">
                                <h5>Filter Options</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div class="form-group">
                                    <label for="source">Source</label>
                                    <select name="source" id="source" class="form-control form-control-sm">
                                        <option value="all">&lt;All&gt;</option>
                                        <option value="warehouse">Warehouse</option>
                                        <option value="outlet">Outlet</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="sourcename">Source Name:</label>
                                    <select name="sourcename" id="sourcename" class="form-control form-control-sm">
                                        <option value="all">&lt;All&gt;</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="destination">Destination</label>
                                    <select name="destination" id="destination" class="form-control form-control-sm">
                                        <option value="all">&lt;All&gt;</option>
                                        <option value="warehouse">Warehouse</option>
                                        <option value="outlet">Outlet</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="destinationname">Destination Name:</label>
                                    <select name="destinationname" id="destinationname" class="form-control form-control-sm">
                                        <option value="all">&lt;All&gt;</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <input type="checkbox" name="alldates" id="alldates">All Dates 
                                </div>

                                <div class="form-group">
                                    <label for="startdate" id="startdatelabel">Start Date</label>
                                    <input type="text" name="startdate" id="startdate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group">
                                    <label for="enddate" id="enddatelabel">End Date</label>
                                    <input type="text" name="enddate" id="enddate" class="form-control form-control-sm">
                                </div>

                                <div class="filter-actions">
                                    <button class="btn btn-secondary btn-sm" id="findtransfers"><i class="fas fa-search fa-sm"></i> Find Transfers</button>
                                    <button class="btn btn-success btn-sm" id="newtransfer"><i class="fas fa-plus-circle fa-sm"></i> Add New</button>
                                </div>
                            </div>
                        </div>
                    </div> <!-- Closing #filterCollapse wrapper -->
                </div>
                <div class="col-12 col-lg-9" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5>Transfers Done</h5>
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
                                <table class="table table-sm table-striped table-hover mb-0" id="transferdetails">
                                    <thead>
                                        <th style="width: 20px;"></th>
                                        <th>#</th>
                                        <th>Reference #</th>
                                        <th class="d-none d-sm-table-cell">Date</th>
                                        <th class="d-none d-md-table-cell">Source</th>
                                        <th class="d-none d-md-table-cell">Destination</th>
                                        <th class="d-none d-lg-table-cell">User</th>
                                        <th class="text-center" style="width: 100px;">Action</th>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Floating Action Button for adding a new transfer (visible ONLY on mobile/tablet) -->
    <button type="button" class="btn btn-success d-lg-none" id="mobileAddTransferFAB" title="Add Transfer">
        <i class="fal fa-plus"></i>
    </button>

    <script>
        $(document).ready(function() {
            $('#mobileAddTransferFAB').on('click', function() {
                $('#newtransfer').trigger('click');
            });
        });
    </script>
  </section>
   
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/transferslist.js"></script>
</html>