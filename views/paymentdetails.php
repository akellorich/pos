<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Supplier Payments </title>
    <style>
      /* Card aesthetics styling to make it feel premium */
      .containergroup.card {
          border: none !important;
          border-radius: 8px !important;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
          background: #ffffff !important;
          margin-bottom: 0.75rem !important;
          display: flex !important;
          flex-direction: column !important;
      }

      .containergroup.card .card-header {
          background-color: #ffffff !important;
          border-bottom: 1px solid rgba(0, 0, 0, 0.08) !important;
          padding: 12px 16px !important;
          height: auto !important;
          flex-shrink: 0 !important;
      }

      .containergroup.card .card-header h5 {
          margin: 0 !important;
          font-size: 1.05rem !important;
          font-weight: 600 !important;
          color: #2b3e50 !important;
          display: flex !important;
          align-items: center !important;
          justify-content: space-between !important;
          width: 100% !important;
      }

      .containergroup.card .card-body {
          flex: 1 1 auto !important;
          overflow-y: auto !important;
          padding: 8px !important;
      }
      
      .table-container {
          border-radius: 6px !important;
          border: 1px solid #e9ecef !important;
          width: 100% !important;
          overflow: hidden !important;
      }

      #paymentdetails {
          width: 100% !important;
      }

      #paymentdetails th {
          background-color: #ebf0f3 !important;
          color: #2b3e50 !important;
          font-weight: 600 !important;
          font-size: 0.85rem !important;
          border-bottom: 2px solid #dee2e6 !important;
          padding-top: 10px !important;
          padding-bottom: 10px !important;
          padding-left: 8px !important;
      }

      #paymentdetails td {
          padding: 8px 8px !important;
          vertical-align: middle !important;
          font-size: 0.85rem !important;
          border-bottom: 1px solid #eef2f5 !important;
      }

      #paymentdetails tbody tr:hover {
          background-color: rgba(0, 0, 0, 0.02) !important;
      }

      table.dataTable.dtr-inline.collapsed > tbody > tr > td.dtr-control,
      table.dataTable.dtr-inline.collapsed > tbody > tr > th.dtr-control {
          padding-left: 20px !important;
      }

      ul.dtr-details {
          padding-left: 4px !important;
          padding-right: 4px !important;
      }

      ul.dtr-details > li {
          padding: 4px 0 !important;
      }

      .form-group label, .form-check-label {
          font-size: 0.8rem !important;
          font-weight: 500 !important;
          color: #4b6584 !important;
          margin-bottom: 4px !important;
      }

      #addtolist {
          display: inline-flex !important;
          align-items: center !important;
          justify-content: center !important;
          padding: 4px 12px !important;
          height: 30px !important;
          font-size: 0.8rem !important;
          font-weight: 500 !important;
          border-radius: 6px !important;
          margin-top: 0px !important;
          margin-bottom: 0px !important;
          transition: all 0.2s ease-in-out !important;
      }

      #addtolist i {
          font-size: 0.9rem !important;
          margin-right: 6px !important;
      }

      .step1-card {
          overflow: hidden !important;
      }
      .step1-card .card-body {
          overflow-x: hidden !important;
      }

      /* Desktop split pane grid layout */
      @media (min-width: 992px) {
          .payment-grid-row {
              display: grid !important;
              grid-template-columns: 280px 1fr !important;
              grid-template-rows: auto 1fr !important;
              grid-template-areas:
                  "step1 step2"
                  "step3 step2" !important;
              gap: 10px !important;
              height: calc(100vh - 130px) !important;
          }
          .step1-card {
              grid-area: step1 !important;
              width: auto !important;
              max-width: none !important;
              flex: none !important;
          }
          .step3-card {
              grid-area: step3 !important;
              width: auto !important;
              max-width: none !important;
              flex: none !important;
              margin-top: 0 !important;
              display: flex !important;
              flex-direction: column !important;
          }
          .step3-card .card-body {
              flex-grow: 1 !important;
              overflow-y: auto !important;
          }
          .step2-card {
              grid-area: step2 !important;
              width: auto !important;
              max-width: none !important;
              flex: none !important;
              height: 100% !important;
              margin-bottom: 0 !important;
              display: flex !important;
              flex-direction: column !important;
          }
          .step2-card .card-body {
              flex-grow: 1 !important;
              overflow-y: auto !important;
          }
      }

      /* Responsive layout and sticky footer */
      @media (max-width: 991.98px) {
          .payment-grid-row {
              display: flex !important;
              flex-direction: column !important;
              gap: 10px !important;
          }
          .step1-card {
              order: 1 !important;
          }
          .step2-card {
              order: 2 !important;
          }
          .step3-card {
              order: 3 !important;
              margin-top: 0 !important;
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
               margin: 0 !important;
               padding: 8px 12px !important;
               font-size: 0.9rem !important;
          }
          .home-section {
               padding-bottom: 70px !important;
          }
          .containergroup.card .card-header h5 {
               font-size: 0.85rem !important;
          }
          #paymentdetails th, #paymentdetails td {
               font-size: 0.75rem !important;
               padding: 6px 6px !important;
          }
          .dataTables_wrapper {
               font-size: 0.75rem !important;
          }
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Supplier Payments"; require_once("topbar.php"); ?>
            <!-- Page Content -->
            <div class="container-fluid mt-2">
                <input type="hidden" name="id" id="id" value="0">
                <div class="row payment-grid-row">
                    <div class="card containergroup step1-card col-12 col-md-3">
                        <div class="card-header">
                            <h5>Step 1 - Voucher Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="vouchernumber">Voucher Number</label>
                                        <input type="text" id='vouchernumber' class='form-control form-control-sm'>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="fom-group groupedcheckbox">
                                        <input type="checkbox" class="form-check-input" id="generatevoucherno">
                                        <label class="form-check-label" for="generatevoucherno">Generate</label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="date">Date</label>
                                <input type="text" id="date" class='form-control form-control-sm'>
                            </div>
                            <div class="form-group">
                                <label for="supplier">Supplier</label>
                                <select name="supplier" id="supplier" class='form-control form-control-sm'></select>
                            </div>
                        </div>
                    </div>
                    <div class="card containergroup step3-card col-12 col-md-3 mt-2">
                        <div class="card-header">
                            <h5>Step 3 - Payment Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label for="costcenter">Cost Center</label>
                                <select name="costcenter" id="costcenter" class='form-control form-control-sm'></select>
                            </div>
                            <div class="form-group">
                                <label for="paymentmode">Payment Mode</label>
                                <select name="paymentmode" id="paymentmode"  class='form-control form-control-sm'></select>
                            </div>
                            <div class="form-group">
                                <label for="paidfrom">Paid From</label>
                                <select name="paidfrom" id="paidfrom"  class='form-control form-control-sm'></select>
                            </div>
                            <div class="form-group">
                                <label for="referencenumber">Reference Number</label>
                                <input type="text" id="referencenumber"  class='form-control form-control-sm'>
                            </div>
                        </div>
                    </div>

                    <div class="containergroup card step2-card col-12 col-md-9 mb-2" id="receiptlist">
                        <div class="card-header">
                            <h5>
                                <span class="font-weight-bold">Step 2 - Invoices to Pay...</span>
                                <!-- <a class='btn btn-danger btn-xs' data-toggle='collapse' href='#filteroptions' role='button' aria-expanded='false' aria-controls='filteroptions'><i class="far fa-eye-slash"></i></a>-->
                                <button class='btn btn-outline-success' id="addtolist"><i class="fas fa-plus-circle fa-fw"></i> Add Invoice(s)</button>
                            </h5>
                        </div>
                        <div class="card-body">
                            <div id="errors" class="mt-2"></div>
                            <div class="table-container p-2 mt-2">
                                <table class='table table-striped table-sm mb-0 nowrap' id="paymentdetails" style="width: 100%;">
                                    <thead>
                                        <th style="width: 20px;"></th>
                                        <th> Invoice Date </th>
                                        <th> Invoice # </th>
                                        <th> Invoice Amount </th>
                                        <th> Narration </th> 
                                        <th> Account Charged </th>
                                        <th> Balance </th>
                                        <th> Pay </th>
                                        <th> &nbsp; </th>
                                    </thead>

                                    <tbody>
                            
                                    </tbody>
                                    <tfoot>
                                        <td colspan="3">
                                            TOTALS:
                                        </td>
                                        <td id="invoicetotal">0.00</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td id="balancetotal">0.00</td>
                                        <td id="total" class="total">0.00</td>
                                        <td>&nbsp;</td>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="action-buttons-container mt-3 mb-2">
                    <button class='btn btn-success btn-sm' id="save"><i class="fas fa-save fa-fw fa-lg"></i> Save Payment</button>
                    <button class='btn btn-danger btn-sm' id="clear"><i class="fas fa-eraser fa-fw fa-lg"></i> Clear Screen</button>
                </div>
            </div>
            <div class="modal fade alert-dismissable fade" id="supplierinvoicesmodal">
                <div class="modal-dialog">
                    <div class="modal-content" id="supplierinvoicedetails">
                        <div class="modal-header">
                            <p  class="modal-title" ><h5>Select Invoices to Pay ...</h5></p>
                            <button type="button" class="close" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div> <!-- -->
                        <div class="modal-body">
                            <table class="table-sm table-striped">
                                <thead>
                                    <th>&nbsp;</th>
                                    <th>Invoice #</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Paid</th>
                                    <th>Balance</th>
                                </thead>
                                <tbody id="supplierinvoices"></tbody>
                            </table>
                        </div>
                    
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success btn-sm" id="addinvoicestolist">Add Invoices</button>
                            <button type="button" class="btn btn-danger btn-sm" id="closecustomerinvoices" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?>
<script src="../js/paymentdetails.js?v=<?php echo time(); ?>"></script>
</html>
