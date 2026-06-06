<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Invoices </title>
    <style>
      /* Layout structure for Invoice Details page: desktop vs mobile */
      @media (min-width: 992px) {
          .invoice-grid-layout {
              display: grid !important;
              grid-template-columns: 380px 1fr !important;
              grid-template-rows: auto 1fr !important;
              column-gap: 16px !important;
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
          .step-2-wrapper {
              grid-column: 2 !important;
              grid-row: 1 / span 2 !important;
          }
          .scrollable-y {
              height: calc(100vh - 160px) !important;
              overflow-y: auto !important;
          }
      }

      @media (max-width: 991.98px) {
          .invoice-grid-layout {
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
          .scrollable-y {
              max-height: 400px !important;
              overflow-y: auto !important;
          }
          .action-buttons-container {
               position: fixed !important;
               bottom: 0 !important;
               left: 0 !important;
               right: 0 !important;
               background-color: #ffffff !important;
               padding: 12px 16px !important;
               box-shadow: 0 -4px 10px rgba(0, 0, 0, 0.08) !important;
               z-index: 1030 !important;
               display: flex !important;
               gap: 10px !important;
               margin: 0 !important;
          }
          .action-buttons-container button {
               flex: 1 !important;
               width: auto !important;
               margin: 0 !important;
               padding: 8px 12px !important;
               font-size: 0.9rem !important;
          }
          .home-section {
               padding-bottom: 70px !important;
          }
      }

      /* Card aesthetics styling to make it feel premium */
      .containergroup.card {
          border: none !important;
          border-radius: 8px !important;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
          background: #ffffff !important;
          margin-bottom: 0 !important;
      }

      .card-header {
          background-color: #f8f9fa !important;
          border-bottom: 1px solid rgba(0, 0, 0, 0.08) !important;
          padding: 12px 16px 20px 16px !important;
      }

      .card-header h5 {
          margin: 0 !important;
          font-size: 0.85rem !important;
          font-weight: 600 !important;
          color: #2b3e50 !important;
      }

      .card-body {
          padding: 16px !important;
      }
      
      .table-responsive {
          border-radius: 6px !important;
          border: 1px solid #e9ecef !important;
      }

      .checkbox-group input[type="checkbox"] {
          width: 16px;
          height: 16px;
          vertical-align: middle;
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Invoices"; require_once("topbar.php"); ?>
        <div class="container-fluid invoice mt-2">
            <div class="invoice-grid-layout">
                <!-- Step 1 - Filter Options -->
                <div class="step-1-wrapper">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Step 1 - Filter Options</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label for="supplier">Supplier</label>
                                <select name="supplier" id="supplier" class='form-control form-control-sm'></select>
                            </div>
                            <div class="row">
                                <div class="col">
                                    <div class="checkbox-group mb-2">
                                        <input type="checkbox" autocomplete="off" name="alldates" id="alldates" class="mr-1"> All Dates
                                    </div>
                                </div>
                            </div>
                        
                            <div class="row">
                                <div class="col">
                                    <label for="startdate">Start Date</label>
                                    <input type="text" autocomplete="off" id="startdate" name="startdate" class='form-control form-control-sm'>
                                </div>
                                <div class="col">
                                    <label for="enddate">End Date</label>
                                    <input type="text" autocomplete="off" id="enddate" name="enddate" class='form-control form-control-sm'>
                                </div>
                            </div>
                            <div class="row mt-3">
                                <div class="col">
                                    <button class='btn btn-dark btn-sm btn-block' id="searchgrn"><i class="fas fa-search fa-fw fa-sm mr-1"></i> Filter GRNs</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 3 - Invoice Details -->
                <div class="step-3-wrapper">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Step 3 - Invoice Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label for="invoicedate">Invoice Date</label>
                                <input type="text" autocomplete="off" id="invoicedate" name="invoicedate" class="form-control form-control-sm">
                            </div>
                            <div class="form-group">
                                <label for="invoiceno">Invoice #</label>
                                <input type="text" autocomplete="off" id="invoiceno" class='form-control form-control-sm'>
                            </div>
                            <div class="form-group">
                                <label for="invoicetotal">Invoice Amount</label>
                                <input type="text" autocomplete="off" id="invoicetotal" disabled class='form-control form-control-sm text-right lead font-weight-bold' value="0.00">
                            </div>

                            <div class="d-flex justify-content-between mt-3 action-buttons-container">
                                <button class='btn btn-success btn-sm w-50 mr-2' id="saveinvoice"><i class="fas fa-save fa-fw fa-sm mr-1"></i> Save Invoice</button>
                                <button class='btn btn-outline-danger btn-sm w-50' id="clear"><i class="fas fa-eraser fa-fw fa-sm mr-1"></i> Clear Form</button>
                            </div>
                        </div>
                    </div>
                </div> 
            
                <!-- Step 2 - Uninvoiced Goods Received Notes -->
                <div class="step-2-wrapper" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Step 2 - Uninvoiced Goods Received Notes</h5>
                        </div>
                        <div class='card-body card-body-list scrollable-y'>
                            <div id="errors" class="errors"></div>
                        
                            <div class="table-responsive">
                                <table class="table table-striped table-sm mb-0">
                                    <thead class="thead-light">
                                        <tr>
                                            <th style="width: 40px;"><input type='checkbox' id='allgrn'></th>
                                            <th style="width: 40px;" class="d-none d-md-table-cell">#</th>
                                            <th>GRN Number</th>
                                            <th>Delivery Note Number</th>
                                            <th class="d-none d-md-table-cell">Date Received</th>
                                            <th class="text-right">Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody id="uninvoicedgrns">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">No records listed. Select supplier and apply filters.</td>
                                        </tr>
                                    </tbody>
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
<script src="../js/invoicedetails.js?v=<?php echo time(); ?>"></script>
</html>