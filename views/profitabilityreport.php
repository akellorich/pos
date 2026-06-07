<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Profitability Report </title>
    <style>
      /* Responsive customizations for the Profitability Report page */
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
              display: flex !important;
              flex-direction: column !important;
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
          flex-shrink: 0 !important;
      }
      
      .containergroup .card-header h5 {
          margin-bottom: 0;
          font-size: 0.95rem;
          color: #2b5c8f;
      }
      
      /* DataTable responsiveness and action icon design */
      .table-container {
          border-radius: 6px !important;
          border: 1px solid #e9ecef !important;
          width: 100% !important;
          overflow: auto !important;
          margin-top: 10px !important;
          flex-grow: 1 !important;
          padding: 8px !important;
      }
      
      /* Compact inputs on mobile view to prevent row wrapping */
      @media (max-width: 575.98px) {
          .dt-buttons-container .btn {
              padding: 4px 8px !important;
              font-size: 0.68rem !important;
          }
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Profitability Report"; require_once("topbar.php"); ?>
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
                                    <div class="form-group mb-3">
                                        <div class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="alldates" name="alldates" style="cursor: pointer;">
                                            <label class="custom-control-label font-weight-bold text-muted" for="alldates" style="font-size: 0.8rem; cursor: pointer; user-select: none; padding-left: 5px;">All Dates</label>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="startdate" class="font-weight-bold text-muted" style="font-size: 0.8rem;">Start Date</label>
                                        <input type="text" id="startdate" autocomplete="off" name="startdate" class="form-control form-control-sm">
                                    </div>

                                    <div class="form-group">
                                        <label for="enddate" class="font-weight-bold text-muted" style="font-size: 0.8rem;">End Date</label>
                                        <input type="text" id="enddate" autocomplete="off" name="enddate" class="form-control form-control-sm">
                                    </div>

                                    <div class="form-group">
                                        <label for="pos" class="font-weight-bold text-muted" style="font-size: 0.8rem;">Point of Sale</label>
                                        <select id="pos" name="pos" class="form-control form-control-sm"></select>
                                    </div>

                                    <div class="form-group">
                                        <label for="groupby" class="font-weight-bold text-muted" style="font-size: 0.8rem;">Group By</label>
                                        <select id="groupby" name="groupby" class="form-control form-control-sm">
                                            <option value="">&lt;No Grouping &gt;</option>
                                            <option value="date">Date</option>
                                        </select>
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
                                <h5>Profitability Report</h5>
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
                                <div id='report'></div>
                                <div class="table-container">
                                    <table class="table table-sm table-striped table-hover mb-0" id="profitabilityreport">
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
<script type="text/javascript" src="../js/profitabilityreport.js"></script>
<html>