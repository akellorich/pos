<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Purchase Receipts</title>
    <style>
      /* Mobile and tablet view enhancements */
      @media (max-width: 991.98px) {
          .container-fluid {
              padding-left: 8px !important;
              padding-right: 8px !important;
          }
          .row.mt-2, .row.mt-1, .row {
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
              margin-left: 0 !important;
          }
          .card-body {
              padding-left: 8px !important;
              padding-right: 8px !important;
          }
          .card-body-list {
              height: auto !important;
              max-height: none !important;
              min-height: 0 !important;
          }
          
          /* Table overrides for touch responsiveness */
          .table-responsive {
              border: none !important;
          }
      }
      
      /* Global container adjustments to push sections closer to edges */
      .container-fluid {
          padding-left: 8px !important;
          padding-right: 8px !important;
      }
      .row {
          margin-left: -4px !important;
          margin-right: -4px !important;
      }
      .col-12, .col-lg-3, .col-lg-9 {
          padding-left: 4px !important;
          padding-right: 4px !important;
      }
      
      /* Apply top margin for the two sections */
      #filterCollapse .containergroup, 
      #receiptlist .containergroup {
          margin-top: 15px !important;
      }
      
      @media (min-width: 992px) {
          .col-lg-3 {
              padding-left: 0 !important;
              padding-right: 15px !important;
          }
          #receiptlist {
              padding-left: 15px !important;
              padding-right: 0 !important;
          }
          #filterCollapse .containergroup,
          #receiptlist .containergroup {
              height: calc(100vh - 110px) !important;
              display: flex;
              flex-direction: column;
          }
          #filterCollapse .card-body-list,
          #receiptlist .card-body {
              flex: 1;
              overflow-y: auto;
              height: calc(100vh - 150px) !important;
              max-height: none !important;
          }
      }
      
      /* Space filter actions nicely on separate lines */
      .filter-actions {
          display: flex;
          flex-direction: column;
          gap: 8px;
          margin-top: 15px;
      }
      .filter-actions button {
          width: 100%;
          display: block;
          margin: 0 !important;
      }
      
      /* Elevate the looks of the card shadows and headers */
      .containergroup.card, .containergroup {
          border: none !important;
          border-radius: 8px !important;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
          transition: transform 0.2s ease, box-shadow 0.2s ease;
          background: #ffffff;
      }
      
      .containergroup .card-header {
          background-color: #f8f9fa !important;
          border-bottom: 1px solid rgba(0, 0, 0, 0.05) !important;
          border-top-left-radius: 8px !important;
          border-top-right-radius: 8px !important;
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

      /* Hover micro-animation for FAB */
      #mobileAddGrnFAB:hover {
          transform: scale(1.1);
          background-color: #218838 !important;
      }
      #mobileAddGrnFAB:active {
          transform: scale(0.95);
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Purchase Receipts"; require_once("topbar.php"); ?>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12 col-lg-3 mb-4">
                        <!-- Collapsible wrapper: collapsed on mobile/tablet, visible block on desktop -->
                        <div class="collapse d-lg-block" id="filterCollapse">
                            <div class="card containergroup">
                                <div class="card-header">
                                    <h5>Filter options</h5>
                                </div>
                                <div class="card-body card-body-list">
                                    <div id="errors"></div>

                                    <div class="form-group">
                                        <label for="sourcename"><span id="sourcelabel">Supplier</span> Name</label>
                                        <select name="sourcename" id="sourcename" class="form-control form-control-sm"></select>
                                    </div>

                                    <div class="form-group form-check">
                                        <input type="checkbox" name="alldates" id="alldates" class="form-check-input">
                                        <label for="alldates" class="check-label">All Date</label>
                                    </div>

                                    <div class="form-group">
                                        <label for="startdate"><span id="startdatelabel">Start date</span></label>
                                        <input type="text" name="startdate" id="startdate" class="form-control form-control-sm">
                                    </div>

                                    <div class="form-group">
                                        <label for="enddate"><span id="enddatelabel">End date</span></label>
                                        <input type="text" name="enddate" id="enddate" class="form-control form-control-sm">
                                    </div>

                                    <div class="form-group">
                                        <label for="grnno">GRN Number</label>
                                        <input type="text" name="grnno" id="grnno" class="form-control form-control-sm">
                                    </div>

                                    <div class="form-group">
                                        <label for="deliveryno">Delivery Number</label>
                                        <input type="text" name="deliveryno" id="deliveryno" class="form-control form-control-sm">
                                    </div>

                                    <div class="filter-actions">
                                        <button class="btn btn-secondary btn-sm" id="filtergrn"><i class="fal fa-filter fa-lg"></i> Filter GRNs</button>
                                        <button class="btn btn-sm btn-success" id="addnewgrn"><i class="fal fa-plus-circle fa-lg"></i> Add New GRN</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-lg-9" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5>Goods Received in the system</h5>
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
                            <div class="card-body card-body-list table-responsive">
                                <table class="table table-sm table-striped" id="grnlist">
                                    <thead>
                                        <th>#</th>
                                        <th>GRN Number</th>
                                        <th class="d-none d-lg-table-cell">Delivery Note #</th>
                                        <th>Date</th>
                                        <th class="d-none d-lg-table-cell">Warehouse</th>
                                        <th>Supplier Name</th>
                                        <th class="d-none d-lg-table-cell">Received By</th>
                                        <th class="d-none d-lg-table-cell">Inspected By</th>
                                        <th>GRN Value</th>
                                        <th>&nbsp;</th><!-- View Items in the GRN -->
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

    <!-- Fixed Floating Action Button (FAB) for mobile/tablet to trigger 'Add New GRN' -->
    <button id="mobileAddGrnFAB" class="d-lg-none btn btn-success" style="position: fixed; bottom: 25px; right: 20px; width: 48px; height: 48px; border-radius: 50%; z-index: 2050; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 10px rgba(40, 167, 69, 0.4); border: none; transition: transform 0.2s ease, background-color 0.2s ease;">
        <i class="fal fa-plus fa-lg" style="color: #ffffff;"></i>
    </button>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/goodsreceived.js"></script>
</html>
