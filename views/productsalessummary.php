<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Product Sales </title>
    <style>
      /* Responsive customizations for the Product Sales Summary page */
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
          /* Reduce spacing between filter and report sections */
          .row.mt-2 > .col-lg-3,
          .row.mt-2 > .col-lg-9 {
              padding-left: 6px !important;
              padding-right: 6px !important;
          }
          .row.mt-2 {
              margin-left: -6px !important;
              margin-right: -6px !important;
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
    </style>
  </head>
 <body>
     <?php require_once("sidebar.html") ?>
     <section class="home-section">
         <?php $pagename = "Product Sales"; require_once("topbar.php"); ?>
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
                                         <input type="text" id="startdate" autocomplete="off" name="startdate" class="form-control form-control-sm">
                                     </div>
 
                                     <div class="form-group">
                                         <label for="enddate">End Date</label>
                                         <input type="text" id="enddate" autocomplete="off" name="enddate" class="form-control form-control-sm">
                                     </div>
 
                                     <div class="form-group">
                                         <label for="product">Product</label>
                                         <select id="product" name="product" class="form-control form-control-sm"></select>
                                     </div>
 
                                     <div class="form-group">
                                         <label for="groupby">Group By</label>
                                         <select id="groupby" name="groupby" class="form-control form-control-sm">
                                             <option value="">&lt;No Grouping &gt;</option>
                                             <option value="date">Date</option>
                                             <option value="product">product</option>
                                         </select>
                                     </div>
                                     
                                     <div class="filter-actions">
                                         <button type="button" class="btn btn-secondary btn-sm" id="search" name="search"><i class="fal fa-sync fa-sm mr-1"></i>Generate Report</button>
                                     </div>
                                 </div>
                             </div>
                         </div>
                     </div>
 
                     <div class="col-12 col-lg-9" id="receiptlist">
                         <div class="card containergroup">
                             <div class="card-header d-flex justify-content-between align-items-center">
                                 <h5>Products Sales Summary Report</h5>
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
                                 <div id='report'></div>
                                 <div class="table-responsive">
                                     <table id="productsalesreport" class="table table-striped table-hover table-sm">
                                         <thead></thead>
                                         <tbody></tbody>
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
 <script type="text/javascript" src="../js/productsalesummary.js"></script>
 </html>