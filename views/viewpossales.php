<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=B612+Mono&display=swap" rel="stylesheet">
    <title> SalesFlow | Sales Report </title>
    <style>
      /* Mobile and Tablet optimization rules */
      @media (max-width: 991.98px) {
          .home-section {
              padding-left: 0 !important;
              padding-right: 0 !important;
          }
          .container-fluid {
              padding-left: 4px !important;
              padding-right: 4px !important;
              margin-left: 0 !important;
              margin-right: 0 !important;
          }
          .d-flex.flex-column.flex-lg-row {
              gap: 16px !important;
          }
          #step1FilterCollapse, #receiptlist {
              padding-left: 0 !important;
              padding-right: 0 !important;
              margin-left: 0 !important;
              margin-right: 0 !important;
              width: 100% !important;
          }
          #search {
              width: 100% !important;
              height: 38px !important;
              font-size: 0.85rem !important;
              display: inline-flex !important;
              align-items: center !important;
              justify-content: center !important;
          }
          #possaleslist tbody td {
              font-size: 0.74rem !important;
          }
          #possaleslist thead th {
              font-size: 0.76rem !important;
          }
          .card.containergroup .card-body {
              padding-left: 0 !important;
              padding-right: 0 !important;
              margin-left: 0 !important;
              margin-right: 0 !important;
          }
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

      /* Elevate the looks of the card shadows and headers */
      .card.containergroup {
          border: none !important;
          border-radius: 8px !important;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
          transition: transform 0.2s ease, box-shadow 0.2s ease !important;
          background: #ffffff !important;
      }
      
      .card.containergroup:hover {
          box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08) !important;
      }
      
      .card-header {
          background-color: #f8f9fa !important;
          border-bottom: 1px solid rgba(0, 0, 0, 0.05) !important;
          border-top-left-radius: 8px !important;
          border-top-right-radius: 8px !important;
          display: flex !important;
          align-items: center !important;
          height: 40px !important;
          padding: 10px 15px !important;
      }
      
      .card-header h5 {
          margin-bottom: 0 !important;
          font-size: 0.95rem !important;
          color: #2b5c8f !important;
          font-weight: 600 !important;
      }

      /* Responsive Table Wrap */
      .table-responsive {
          border-radius: 6px !important;
          border: 1px solid #e9ecef !important;
          padding: 10px !important;
          background: #ffffff !important;
      }
      
      .table th, .table td {
          vertical-align: middle !important;
      }

      /* Global Card Body spacing adjustments */
      .card.containergroup .card-body {
          padding: 8px !important;
          margin: 0 !important;
      }

      /* Desktop full height split-pane layout rules to prevent content bleeding */
      @media (min-width: 992px) {
          #step1FilterCollapse .card.containergroup,
          #receiptlist .card.containergroup {
              height: calc(100vh - 95px) !important;
              display: flex;
              flex-direction: column;
          }
          #step1FilterCollapse .card-body,
          #receiptlist .card-body {
              flex: 1;
              overflow-y: auto;
              height: calc(100vh - 135px) !important;
              max-height: none !important;
          }
          /* Reduce spacing between filter and receipts sections */
          #step1FilterCollapse {
              margin-right: 12px !important;
          }
      }

      /* Filter Toggle button styling */
      #toggleSidebarBtn {
          border-radius: 6px !important;
          font-weight: 500 !important;
          font-size: 0.82rem !important;
          height: 36px !important;
      }

      /* Custom DataTable styling for buttons, entries and search alignment */
      .dt-buttons-container {
          display: flex !important;
          justify-content: flex-start !important;
          width: 100% !important;
          margin-bottom: 12px !important;
      }
      .dt-buttons {
          display: inline-flex !important;
          flex-direction: row !important;
          flex-wrap: nowrap !important;
          gap: 6px !important;
          overflow-x: auto !important;
          padding-bottom: 2px !important;
          width: 100% !important;
      }
      .dt-buttons .btn {
          margin-right: 0 !important;
          font-size: 0.74rem !important;
          padding: 5px 10px !important;
          white-space: nowrap !important;
          flex: 1 1 auto !important;
          max-width: fit-content !important;
          display: inline-flex !important;
          align-items: center !important;
          justify-content: center !important;
      }
      .dt-controls-container {
          display: flex !important;
          flex-direction: row !important;
          align-items: center !important;
          justify-content: space-between !important;
          flex-wrap: nowrap !important;
          width: 100% !important;
          gap: 12px !important;
          margin-bottom: 12px !important;
      }
      .dataTables_length, .dataTables_filter {
          margin-bottom: 0 !important;
          margin-top: 0 !important;
      }
      .dataTables_length label, .dataTables_filter label {
          margin-bottom: 0 !important;
          display: inline-flex !important;
          align-items: center !important;
          font-size: 0.78rem !important;
          color: #495057 !important;
          gap: 6px !important;
          white-space: nowrap !important;
      }
      .dataTables_length select {
          height: 28px !important;
          padding: 2px 24px 2px 8px !important;
          font-size: 0.78rem !important;
          border-radius: 4px !important;
          border: 1px solid #ced4da !important;
          min-width: 65px !important;
      }
      .dataTables_filter input {
          width: 130px !important;
          height: 28px !important;
          padding: 4px 8px !important;
          font-size: 0.78rem !important;
          border-radius: 4px !important;
          border: 1px solid #ced4da !important;
      }
      @media (max-width: 575.98px) {
          .dt-controls-container {
              gap: 4px !important;
          }
          .dataTables_filter input {
              width: 105px !important;
          }
          #possaleslist tbody td {
              font-size: 0.68rem !important;
          }
          #possaleslist thead th {
              font-size: 0.70rem !important;
          }
      }
      .dropdown-menu {
          z-index: 1060 !important;
          margin-top: 2px !important;
      }
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
    </style>
   </head>
 <body>
     <?php require_once("sidebar.html") ?>
 
     <section class="home-section">
         <?php $pagename = "Sales Report"; require_once("topbar.php"); ?>
             <div class="container-fluid mt-2">   
                
                <div class="d-flex flex-column flex-lg-row">
                    <!-- Filter Options Panel - Collapsed by default on mobile/tablet, visible block on desktop -->
                    <div class="collapse d-lg-block mr-lg-3 mb-4" id="step1FilterCollapse" style="flex: 0 0 280px; min-width: 280px;">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Filter Options</h5>
                            </div>
                            <div class="card-body">
                                    <div id="errors"></div>
                                    <div class="check-group mb-3">
                                        <input type="checkbox" class="check-control" id="alldates" name="alldates">
                                        <label for="alldates" class="check-label font-weight-bold ml-1 text-dark">All Dates</label>
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
                                        <label for="pos">Point of Sale</label>
                                        <select id="pos" name="pos" class="form-control form-control-sm"></select>
                                    </div>

                                    <div class="form-group">
                                        <label for="paymentmode">Payment Mode</label>
                                        <select id="paymentmode" name="paymentmode" class="form-control form-control-sm"></select>
                                    </div>

                                    <button type="button" class="btn btn-secondary btn-sm btn-block" id="search" name="search"><i class="fal fa-sync fa-sm mr-1"></i>Generate Report</button>
                            </div>
                        </div>
                    </div>

                    <!-- Sales List container -->
                    <div class="flex-grow-1" id="receiptlist" style="min-width: 0;">
                        <div class="card containergroup">
                            <div class="card-header d-flex justify-content-between align-items-center w-100">
                                <h5>POS Sales Receipts</h5>
                                <button class="btn btn-primary btn-sm d-lg-none d-inline-flex align-items-center justify-content-center" id="toggleSidebarBtn" type="button" data-toggle="collapse" data-target="#step1FilterCollapse" aria-expanded="false" aria-controls="step1FilterCollapse" style="font-size: 0.72rem !important; padding: 4px 10px !important; height: 26px !important; font-weight: 500 !important; border-radius: 5px !important;">
                                    <i class="fal fa-filter mr-1" style="font-size: 0.7rem !important;"></i> <span>Filters</span>
                                </button>
                            </div>

                            <div class="card-body">
                                <div id="errors1"></div>
                                <div class="table-responsive">
                                    <table class="table table-sm table-striped table-hover mb-0" id="possaleslist">
                                        <thead>
                                            <th style="width: 20px;"></th>
                                            <th>#</th>
                                            <th class="d-none d-lg-table-cell">POS</th>
                                            <th>Receipt#</th>
                                            <th class="d-none d-lg-table-cell">Date</th>
                                            <th>Customer</th>
                                            <th class="d-none d-lg-table-cell">Payment Mode</th>
                                            <th class="d-none d-md-table-cell">Reference#</th>
                                            <th class="text-right">Amount</th>
                                            <th class="d-none d-md-table-cell">Status</th>
                                            <th class="d-none d-lg-table-cell">Added By</th>
                                            <th class="text-center">Action</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="cancelreceiptmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Confirm Receipt Cancellation</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div id="modalerror"></div>
                            <div class="form-group">
                                <input type="hidden" name="receiptid" id="receiptid">
                                <label for="cancelreason">Provide Cancellation Reason</label>
                                <input type="text" name="cancelreason" id="cancelreason" class="form-control form-control-sm">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-success btn-sm"  data-dismiss="modal" id="dontcancel">No, Don't Cancel</button>
                            <button type="button" class="btn btn-danger btn-sm" id="cancelreceipt">Yes, Cancel Receipt</button>
                        </div>
                        </div>
                    </div>
                </div>

                <!-- Modal for Refund -->
                <div class="modal" tabindex="-1" id="refundmodal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Select Refundable Item(s)</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="refundreceiptno" id="refundreceiptno">
                            <div id="refundnotifications"></div>
                            <div class="col form-group">
                                <label for="refundreason">Refund Reason</label>
                                <input type="text" name="refundreason" id="refundreason" class="form-control form-control-sm">
                            </div>

                           <table class="table table-sm table-striped table-hover" id="refunditems">
                                <thead>
                                    <th>#</th>
                                    <td><input type="checkbox" id="selectallrefunds"></td>
                                    <th>Item Name</th>
                                    <th class="text-right">Unit Price</th>
                                    <th class="text-right">Quantity</th>
                                    <th class="text-right">Total</th>
                                </thead>
                                <tbody id="refunditemslist"></tbody>
                           </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success btn-sm" id="completerefund"><i class="fas fa-save fa-lg fa-fw"></i> Complete Refund</button>
                            <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal"><i class="fas fa-times fa-lg fa-fw"></i>  Close</button>   
                        </div>
                        </div>
                    </div>
                </div>

                <!-- Modal for View Receipt Details -->
                <div class="modal fade" tabindex="-1" id="viewreceiptmodal" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" style="max-width: 420px;">
                        <div class="modal-content" style="border-radius: 12px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
                            <div class="modal-header border-0 pb-0">
                                <h5 class="modal-title font-weight-bold text-dark w-100 text-center pt-2" style="font-size: 1.05rem; letter-spacing: 1px;">RECEIPT DETAILS</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="position: absolute; right: 20px; top: 20px; outline: none;">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body px-4 pt-3">
                                <div id="receipt-modal-content" style="font-family: 'B612 Mono', monospace; font-size: 0.8rem; color: #333; line-height: 1.4;">
                                    <!-- Rendered dynamically -->
                                    <div class="text-center py-4">
                                        <i class="fal fa-spinner fa-spin fa-2x text-muted"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer border-0 pt-0 justify-content-center">
                                <button type="button" class="btn btn-success btn-sm px-4" id="modalprintreceipt" style="border-radius: 20px; font-weight: 500;"><i class="fal fa-print mr-2" style="font-size: 0.74rem;"></i>Print Receipt</button>
                                <button type="button" class="btn btn-outline-secondary btn-sm px-4" data-dismiss="modal" style="border-radius: 20px;">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
    </section>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/viewpossales.js"></script>
</html>