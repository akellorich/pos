<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Production </title>
    <style>
      /* Responsive customizations for the Production page */
      @media (max-width: 991.98px) {
          #productionlist {
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
          #productionlist {
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
      
      @media (min-width: 576px) {
          .filter-actions {
              flex-direction: row;
          }
          .filter-actions button {
              flex: 1;
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
      
      /* DataTable UIs and Autocomplete suggestion styles */
      .table-responsive {
          border-radius: 6px;
          overflow: visible !important;
      }
      
      #productiontable td a {
          color: #34495e;
          transition: color 0.2s ease;
      }
      
      #productiontable td a:hover {
          color: #2b5c8f;
      }
      
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
      #mobileAddProductionFAB {
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

      #mobileAddProductionFAB i {
          font-size: 1.2rem !important;
          margin: 0 !important;
      }

      #mobileAddProductionFAB:hover {
          transform: scale(1.08) !important;
          box-shadow: 0 6px 20px rgba(40, 167, 69, 0.5) !important;
      }

      @media (min-width: 992px) {
          #mobileAddProductionFAB {
              display: none !important;
          }
      }
      
      /* Suggestions box overlay */
      .searchresults-container {
          position: absolute;
          left: 15px;
          right: 15px;
          background: white;
          border: 1px solid #ced4da;
          border-radius: 4px;
          box-shadow: 0 4px 8px rgba(0,0,0,0.1);
          z-index: 1050;
          max-height: 200px;
          overflow-y: auto;
      }
    </style>
  </head>
  <body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
      <?php $pagename = "Production"; require_once("topbar.php"); ?>
      <div class="container-fluid">
          <div class="row mt-2">
              <!-- Filter Section -->
              <div class="col-12 col-lg-3 mb-4">
                  <div class="collapse d-lg-block" id="filterCollapse">
                      <div class="containergroup card">
                          <div class="card-header">
                              <h5>Filter Options</h5>
                          </div>
                          <div class="card-body card-body-list">
                              <div id="filtererrors"></div>
                              <div class="check-group mb-2">
                                  <input type="checkbox" class="check-control" id="alldates" name="alldates">
                                  <label for="alldates" class="check-label">All Dates</label>
                              </div>

                              <div class="form-group">
                                  <label for="startdate">Start Date</label>
                                  <input type="text" autocomplete="off" id="startdate" name="startdate" class="form-control form-control-sm">
                              </div>

                              <div class="form-group">
                                  <label for="enddate">End Date</label>
                                  <input type="text" autocomplete="off" id="enddate" name="enddate" class="form-control form-control-sm">
                              </div>

                              <div class="form-group">
                                  <label for="filterwarehouse">Warehouse</label>
                                  <select name="filterwarehouse" id="filterwarehouse" class="form-control form-control-sm"></select>
                              </div>

                              <div class="form-group">
                                  <label for="filterproduct">Product</label>
                                  <select name="filterproduct" id="filterproduct" class="form-control form-control-sm"></select>
                              </div>

                              <div class="filter-actions">
                                  <button type="button" class="btn btn-secondary btn-sm" id="btnfilter"><i class="fal fa-search fa-fw fa-lg"></i> Filter</button>
                                  <button type="button" id="btnaddproduction" class="btn btn-success btn-sm"><i class="fal fa-plus-circle fa-fw fa-lg"></i> Add Production</button>
                              </div>
                          </div>
                      </div>
                  </div>
              </div>

              <!-- List Section -->
              <div class="col-12 col-lg-9" id="productionlist">
                  <div class="card containergroup">
                      <div class="card-header d-flex justify-content-between align-items-center">
                          <h5>Production Records</h5>
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
                          <div id="productionlistnotifications"></div>
                          <div class="table-responsive">
                              <table class="table table-striped table-sm table-hover" id="productiontable">
                                  <thead class="thead-light">
                                      <th>#</th>
                                      <th>Production Date</th>
                                      <th>Item Code</th>
                                      <th>Item Name</th>
                                      <th>Quantity</th>
                                      <th>UoM</th>
                                      <th>Warehouse</th>
                                      <th>Date Added</th>
                                      <th>Added By</th>
                                      <th class="text-center">Action</th>
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

    <!-- Modal for Adding/Editing Production -->
    <div class="modal fade" tabindex="-1" role="dialog" id="productionmodal">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="modaltitle">Add Production Record</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="modalnotifications"></div>
                    <input type="hidden" id="productionid" value="0">
                    
                    <div class="form-group">
                        <label for="productiondate">Production Date</label>
                        <input type="text" autocomplete="off" id="productiondate" name="productiondate" class="form-control form-control-sm">
                    </div>

                    <div class="form-group">
                        <label for="modalproduct">Product</label>
                        <select name="modalproduct" id="modalproduct" class="form-control form-control-sm"></select>
                    </div>

                    <div class="row">
                        <div class="col form-group">
                            <label for="quantity">Quantity Produced</label>
                            <input type="number" step="any" id="quantity" name="quantity" class="form-control form-control-sm">
                        </div>
                        <div class="col form-group">
                            <label for="uom">Unit of Measure (UoM)</label>
                            <input type="text" id="uom" class="form-control form-control-sm" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="warehouse">Warehouse (Receiving)</label>
                        <select name="warehouse" id="warehouse" class="form-control form-control-sm"></select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="btnsaveproduction"><i class="fal fa-save fa-fw fa-lg"></i> Save Record</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Floating Action Button for mobile -->
    <button type="button" class="btn btn-success d-lg-none" id="mobileAddProductionFAB" title="Add Production">
        <i class="fal fa-plus"></i>
    </button>
  </body>
  <?php require_once("footer.txt") ?>
  <script type="text/javascript" src="../js/production.js"></script>
</html>
