<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Banking </title>
    <style>
      /* Mobile and Tablet optimization rules */
      @media (max-width: 991.98px) {
          .home-section {
              padding-left: 8px !important;
              padding-right: 8px !important;
          }
          .row {
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
              padding-left: 16px !important;
              padding-right: 16px !important;
          }

          body {
              padding-bottom: 75px !important; /* Prevent content overlapping under fixed footer */
          }

          .step1-actions {
              position: fixed !important;
              bottom: 0 !important;
              left: 0 !important;
              right: 0 !important;
              background: #ffffff !important;
              border-top: 1px solid rgba(0, 0, 0, 0.08) !important;
              box-shadow: 0 -4px 15px rgba(0, 0, 0, 0.08) !important;
              padding: 12px 24px !important; /* Spacious right-end padding */
              z-index: 2060 !important; /* Float cleanly above table & FAB */
              display: flex !important;
              flex-direction: row !important;
              justify-content: flex-end !important; /* Align the buttons on the right side of the footer */
              gap: 12px !important;
              margin: 0 !important;
          }

          .step1-actions button {
              flex: none !important;   /* Avoid full-width stretching */
              margin: 0 !important;
              padding: 5px 12px !important; /* Slightly shrunk padding for lower height */
              height: 32px !important;      /* Slightly reduced height */
              font-size: 0.78rem !important; /* Refined font size */
              border-radius: 6px !important;
              display: inline-flex !important;
              align-items: center !important;
              justify-content: center !important;
              font-weight: 500 !important;
          }

          /* Increase the width of the bank selected receipts button */
          #bankreceipts {
              width: 195px !important;
          }
          #clear {
              width: 125px !important;
          }

          .step1-actions button i {
              font-size: 0.88rem !important; /* Prominent icon size */
              margin-right: 6px !important;
          }
      }

      /* Specific font-size scale reduction on mobile viewports */
      @media (max-width: 575.98px) {
          .card-header h5 {
              font-size: 0.85rem !important;
          }
          .form-group label {
              font-size: 0.74rem !important;
          }
          .form-control {
              font-size: 0.76rem !important;
              height: calc(1.5em + 0.5rem + 2px) !important; /* Make inputs slightly more compact */
              padding: 0.25rem 0.5rem !important;
          }
          .table th, .table td {
              font-size: 0.74rem !important;
          }
      }

      /* Compact filters button styles */
      .filter-btn-compact {
          font-size: 0.72rem !important;
          padding: 3px 8px !important;
          height: 26px !important;
          font-weight: 500 !important;
          display: inline-flex !important;
          align-items: center !important;
          justify-content: center !important;
          border-radius: 5px !important;
      }
      .filter-btn-compact i {
          font-size: 0.7rem !important;
          margin-right: 4px !important;
      }

      /* Compact filter receipts button styles */
      #filterreceipts {
          font-size: 0.76rem !important;
          padding: 4px 10px !important;
          height: 30px !important;
          font-weight: 500 !important;
          width: 140px !important; /* Compact reduced width */
      }
      #filterreceipts i {
          font-size: 0.72rem !important;
      }

      /* Global bank receipts button width adjustments */
      #bankreceipts {
          min-width: 180px;
      }

      /* On tablet viewports where sidebar is collapsed, offset left edge of the fixed footer by 78px */
      @media (min-width: 768px) and (max-width: 991.98px) {
          .step1-actions {
              left: 78px !important;
          }
      }

      /* Display 2 items per row in Steps 1 and 4 on tablet view specifically */
      @media (min-width: 576px) and (max-width: 991.98px) {
          .filteroptions .card-body {
              display: grid !important;
              grid-template-columns: repeat(2, 1fr) !important;
              gap: 12px 16px !important;
          }
          .filteroptions .card-body .form-group {
              margin-bottom: 0 !important;
          }
          .filteroptions .card-body .errors,
          .filteroptions .card-body #alldates-group,           /* All dates checkbox container */
          .filteroptions .card-body #filterreceipts-wrapper {  /* Filter receipts wrapper */
              grid-column: span 2 !important;
          }

          .bankingdetails .card-body {
              display: grid !important;
              grid-template-columns: repeat(2, 1fr) !important;
              gap: 12px 16px !important;
          }
          .bankingdetails .card-body .form-group {
              margin-bottom: 0 !important;
          }
      }

      /* Elevate the looks of the card shadows and headers */
      .containergroup.card, .card.filteroptions, .card.summary, .card.bankingdetails, .card.receiptlist {
          border: none;
          border-radius: 8px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
          transition: transform 0.2s ease, box-shadow 0.2s ease;
          background: #ffffff;
      }
      
      .containergroup.card:hover, .card.filteroptions:hover, .card.summary:hover, .card.bankingdetails:hover, .card.receiptlist:hover {
          box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
      }
      
      .card-header {
          background-color: #f8f9fa;
          border-bottom: 1px solid rgba(0, 0, 0, 0.05);
          border-top-left-radius: 8px;
          border-top-right-radius: 8px;
          display: flex;
          align-items: center;
          padding: 12px 16px 20px 16px !important;
      }
      
      .card-header h5 {
          margin-bottom: 0;
          font-size: 0.85rem !important;
          color: #2b5c8f;
          font-weight: 600;
      }

      /* Compact and custom form layouts */
      .form-group label {
          font-weight: 500;
          font-size: 0.8rem;
          color: #555;
          margin-bottom: 4px;
      }

      .btn {
          border-radius: 6px !important;
          font-weight: 500;
      }

      /* Ensure the table doesn't overflow */
      .scrollablefullheight {
          height: calc(100vh - 350px);
          min-height: 250px;
          overflow-y: auto;
          border: 1px solid #e9ecef;
          border-radius: 6px;
          padding: 0;
      }

      /* Progress Modal Backdrop Blur for Mobile & Tablet viewports */
      @media (max-width: 991.98px) {
          .modal-backdrop.show {
              backdrop-filter: blur(6px) !important;
              -webkit-backdrop-filter: blur(6px) !important;
              background-color: rgba(15, 23, 42, 0.4) !important;
          }
          
          .progress-modal-content {
              border: none !important;
              border-radius: 16px !important;
              box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15) !important;
              background: rgba(255, 255, 255, 0.98) !important;
          }
      }

      /* Layout structure for Banking page: desktop vs mobile */
      @media (min-width: 992px) {
          .banking-grid-layout {
              display: grid !important;
              grid-template-columns: 380px 1fr !important;
              grid-template-rows: auto auto auto 1fr !important;
              column-gap: 12px !important;
              row-gap: 12px !important;
              align-items: start !important;
          }
          .step-1-wrapper {
              grid-column: 1 !important;
              grid-row: 1 !important;
          }
          .step-3-wrapper {
              grid-column: 1 !important;
              grid-row: 2 !important;
          }
          .step-4-wrapper {
              grid-column: 1 !important;
              grid-row: 3 !important;
          }
          .step-actions-wrapper {
              grid-column: 1 !important;
              grid-row: 4 !important;
              margin-top: 8px !important;
              display: flex !important;
              justify-content: space-between !important;
              align-items: center !important;
              width: 100% !important;
          }
          .step-2-wrapper {
              grid-column: 2 !important;
              grid-row: 1 / span 4 !important;
          }
          .scrollablefullheight {
              height: calc(100vh - 160px) !important;
          }
      }

      @media (max-width: 991.98px) {
          .banking-grid-layout {
              display: flex !important;
              flex-direction: column !important;
              gap: 16px !important;
          }
          .step-1-wrapper {
              order: 1 !important;
          }
          .step-2-wrapper {
              order: 2 !important;
          }
          .step-3-wrapper {
              order: 3 !important;
          }
          .step-4-wrapper {
              order: 4 !important;
          }
          .step-actions-wrapper {
              order: 5 !important;
          }
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Banking"; require_once("topbar.php"); ?>
            <div class="container-fluid mt-2">
                <div class="banking-grid-layout">
                    <!-- Step 1 Collapsible Filter Options Panel - Collapsed by default on mobile/tablet, visible block on desktop -->
                    <div class="collapse d-lg-block step-1-wrapper" id="step1FilterCollapse">
                        <div class="card filteroptions">
                            <div class="card-header">
                                <h5>Step 1 -- Filter Options</h5>
                            </div>

                            <div class="card-body">
                                <div class="errors" id="errors"></div>
                                <div class="form-group">
                                    <label for="pos">Point of Sale</label>
                                    <select name="pos" id="pos" class='form-control form-control-sm'></select>
                                </div> 

                                <div class="form-group">
                                    <label for="paymentmethod">Payment Method</label>
                                    <select name="paymentmethod" id="paymentmethod" class="form-control form-control-sm"></select>    
                                </div>

                                <div class="form-group d-flex align-items-center" id="alldates-group">
                                    <input type="checkbox" name="alldates" id="alldates" class="mr-2">
                                    <label for="alldates" class="mb-0">All Dates</label>
                                </div>

                                <div class="form-group" id="startdate-group">
                                    <label for="startdate" id="startdatelabel">Start Date</label>
                                    <input type="text" autocomplete="off" name="startdate" id="startdate" class="form-control form-control-sm">
                                </div>

                                <div class="form-group" id="enddate-group">
                                    <label for="enddate" id="enddatelabel">End Date</label>
                                    <input type="text" autocomplete="off" name="enddate" id="enddate" class="form-control form-control-sm">
                                </div>

                                <div class="w-100 d-flex justify-content-end mt-2" id="filterreceipts-wrapper">
                                    <button id="filterreceipts" name="filterreceipts" class="btn btn-secondary btn-sm"><i class="fal fa-filter mr-1"></i> Filter Receipts</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Step 2 Receipt Selector Card -->
                    <div class="step-2-wrapper" id="receiptlist">
                        <div class="card receiptlist">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5>Step 2 -- Select Receipts to Bank</h5> 
                                <button class="btn btn-primary filter-btn-compact d-lg-none" type="button" data-toggle="collapse" data-target="#step1FilterCollapse" aria-expanded="false" aria-controls="step1FilterCollapse" id="toggleSidebarBtn">
                                    <i class="fal fa-filter"></i> <span>Filters</span>
                                </button>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive scrollablefullheight">
                                    <table class="table table-striped table-sm mb-0" id="pendingreceipts">
                                        <thead class="thead-light">
                                            <tr>
                                                <th style="width: 40px;"><input type='checkbox' id='all'></th>
                                                <th style="width: 40px;">#</th>
                                                <th>Date</th>
                                                <th class="d-none d-md-table-cell">Outlet</th>
                                                <th>Customer</th>
                                                <th class="d-none d-sm-table-cell">Receipt #</th>
                                                <th>Payment Mode</th>
                                                <th class="d-none d-md-table-cell">Reference #</th>
                                                <th class="text-right">Amount</th>
                                                <th class="d-none d-lg-table-cell">Added By</th>
                                            </tr>
                                        </thead>
                                        <tbody id="pendingreceiptdetails">
                                            <tr>
                                                <td colspan="10" class="text-center text-muted py-4">
                                                    No Records Listed. Apply filter options first.
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Step 3 Card -->
                    <div class="step-3-wrapper">
                        <div class="card summary" id="summary">
                            <div class="card-header">
                                <h5>Step 3 -- Summarized Receipts</h5>
                            </div>
                            <div class="card-body">
                                <p class="text-muted small mb-0 text-center">No receipts selected</p>
                            </div>
                        </div>
                    </div>

                    <!-- Step 4 Card (Cleaned: no clear/bank buttons inside Step 4 card body) -->
                    <div class="step-4-wrapper">
                        <div class="card bankingdetails">
                            <div class="card-header">
                                <h5>Step 4 -- Banking Details</h5>
                            </div>
                            <div class="card-body">
                                <div class="form-group" id="cashbook-group">
                                    <label for="cashbookaccount">Cashbook Account</label>
                                    <select name="cashbookaccounty" id="cashbookaccount" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group" id="narration-group">
                                    <label for="narration">Narration</label>
                                    <input type="text" autocomplete="off" name="narration" id="narration" class="form-control form-control-sm">
                                </div>

                                <div class="form-group" id="reference-group">
                                    <label for="referenceno">Reference No</label>
                                    <input type="text" autocomplete="off" id="referenceno" name="referenceno" class="form-control form-control-sm">
                                </div>

                                <div class="form-group" id="postas-group">
                                    <label for="postas">Post Receipt(s) As</label>
                                    <select name="postas" id="postas" class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                        <option value="single">Single</option>
                                        <option value="group">Grouped</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Consolidated action footer: Snap to bottom on mobile/tablet, inline on desktop -->
                    <div class="step-actions-wrapper step1-actions mt-3">
                        <button id="bankreceipts" name="bankreceipts" class='btn btn-success btn-sm'><i class="fal fa-save fa-sm mr-1"></i> Bank Selected Receipts</button>
                        <button id="clear" name="clear" class="btn btn-outline-danger btn-sm"><i class="fal fa-hand-sparkles fa-sm mr-1"></i> Clear Form</button>
                    </div>
                </div>
            </div>
    </section>

    <!-- Custom Progress Modal -->
    <div id="progressModal" class="modal fade" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content progress-modal-content">
                <div class="modal-body text-center p-5" id="progressModalBody">
                    <div class="spinner-border text-primary mb-4" role="status" style="width: 3rem; height: 3rem;">
                        <span class="sr-only">Loading...</span>
                    </div>
                    <h4 class="font-weight-bold text-dark mb-2">Processing Banking</h4>
                    <p class="text-muted mb-0">Please wait while we bank the selected receipts and post to the general ledger...</p>
                </div>
            </div>
        </div>
    </div>
    
</body>
<?php require_once("footer.txt") ?>
<script src="../js/banking.js"></script>
</html>