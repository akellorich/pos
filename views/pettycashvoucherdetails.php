<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Pettycash </title>
    <style>
      /* Layout structure for Petty Cash Voucher Details page: desktop vs mobile */
      @media (min-width: 992px) {
          .pettycash-grid-layout {
              display: grid !important;
              grid-template-columns: 380px 1fr !important;
              column-gap: 10px !important;
              row-gap: 12px !important;
              align-items: stretch !important;
          }
          .parameters-wrapper {
              grid-column: 1 !important;
          }
          .details-wrapper {
              grid-column: 2 !important;
          }
          .equal-height-card {
              height: calc(100vh - 90px) !important;
              margin-bottom: 0 !important;
          }
      }

      @media (max-width: 991.98px) {
          body {
              padding-bottom: 70px !important; /* Make room for the mobile sticky footer */
          }
          .pettycash-grid-layout {
              display: flex !important;
              flex-direction: column !important;
              gap: 16px !important;
          }
          .parameters-wrapper {
              order: 1 !important;
          }
          .details-wrapper {
              order: 2 !important;
          }
      }

      /* Card aesthetics styling to make it feel premium */
      .containergroup.card {
          border: none !important;
          border-radius: 8px !important;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
          background: #ffffff !important;
          margin-bottom: 0 !important;
          display: flex !important;
          flex-direction: column !important;
      }

      .card-header {
          background-color: #f8f9fa !important;
          border-bottom: 1px solid rgba(0, 0, 0, 0.08) !important;
          padding: 12px 16px 20px 16px !important;
          flex-shrink: 0 !important;
      }

      .card-header h5 {
          margin: 0 !important;
          font-size: 0.85rem !important;
          font-weight: 600 !important;
          color: #2b3e50 !important;
      }

      .containergroup.card .card-body {
          flex: 1 1 auto !important;
          overflow-y: auto !important;
          padding: 16px !important;
      }
      
      .table-responsive {
          border-radius: 6px !important;
          border: 1px solid #e9ecef !important;
      }

      /* Sticky footer for mobile/tablet */
      .sticky-footer {
          position: fixed !important;
          bottom: 0 !important;
          left: 0 !important;
          width: 100% !important;
          background: #ffffff !important;
          border-top: 1px solid rgba(0, 0, 0, 0.1) !important;
          box-shadow: 0 -4px 10px rgba(0, 0, 0, 0.08) !important;
          z-index: 1020 !important;
      }
      .btn-mobile-icon {
          height: 36px !important;
          border-radius: 4px !important;
          display: inline-flex !important;
          align-items: center !important;
          justify-content: center !important;
          padding: 0 16px !important;
      }
      .btn-mobile-icon i {
          font-size: 1.05rem !important;
      }
      .dropdown-toggle::after {
          display: none !important;
      }
      .dropdown-toggle i {
          font-size: 0.8rem !important;
      }
      .dropdown-item i {
          font-size: inherit !important;
          vertical-align: middle !important;
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Pettycash"; require_once("topbar.php"); ?>
        <div class="container-fluid mt-2">
            <div class="pettycash-grid-layout">
                <!-- Step 1 -- Voucher Parameters -->
                <div class="parameters-wrapper">
                    <div class="containergroup card equal-height-card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5>Step 1 -- Voucher Parameters</h5>
                            <button class="btn btn-sm btn-link d-lg-none text-dark p-0" id="toggle-step1">
                                <i class="fas fa-chevron-up" style="font-size: 0.65rem !important;"></i>
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label for="voucherno">Voucher Number:</label>
                                <div class="row align-items-center">
                                    <div class="col-8">
                                        <input type="text" autocomplete='off' name="voucherno" id="voucherno" class="form-control form-control-sm">
                                    </div>
                                    <div class="col-4 pl-0">
                                        <div class="checkbox-group">
                                            <input type="checkbox" name="autogenerate" id="autogenerate" class="mr-1"> Generate
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="voucherdate">Voucher Date:</label>
                                <input type="text" autocomplete='off' name="voucherdate" id="voucherdate" class="form-control form-control-sm">
                            </div>
                            <div class="form-group">
                                <label for="costcenter">Cost Center</label>
                                <select name="costcenter" id="costcenter" class="form-control form-control-sm"></select>
                            </div>
                            <div class="form-group">
                                <label for="supplier">Supplier:</label>
                                <select name="supplier" id="supplier" class="form-control form-control-sm"></select>
                            </div>
                            <div class="form-group">
                                <label for="paymentmode">Payment Mode:</label>
                                <select name="paymentmode" id="paymentmode" class="form-control form-control-sm"></select>
                            </div>
                            <div class="form-group">
                                <label for="referenceno">Reference Number</label>
                                <input type="text" name="referencenumber" id="referencenumber" class="form-control form-control-sm">
                            </div>
                            <div class="form-group">
                                <label for="payfrom">Pay From:</label>
                                <select name="payfrom" id="payfrom" class="form-control form-control-sm"></select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 2 -- Voucher Details -->
                <div class="details-wrapper" id="receiptlist">
                    <div class="card containergroup equal-height-card">
                        <div class="card-header">
                            <h5>Step 2 -- Voucher Details</h5>
                        </div>
                        <div class="card-body">
                            <div id="errors"></div>
                            <input type="hidden" name="idfield" id="idfield" value="0">
                            <div class="form-row">
                                <div class="col-12 col-sm-6 col-md-2 form-group">
                                    <label for="reference">Reference</label>
                                    <input type="text" autocomplete='off' name="reference" id="reference" class="form-control form-control-sm">
                                </div>
                                <div class="col-12 col-sm-6 col-md form-group">
                                    <label for="narration">Narration</label>
                                    <input type="text" autocomplete='off' name="narration" id="narration" class="form-control form-control-sm">
                                </div>
                                <div class="col-12 col-sm-6 col-md-3 form-group">
                                    <label for="accountcharged">Account Charged</label>
                                    <select name="accountcharged" id="accountcharged" class="form-control form-control-sm"></select>
                                </div>
                                <div class="col-12 col-sm-6 col-md-2 form-group">
                                    <label for="amount">Amount</label>
                                    <input type="number" autocomplete='off' name="amount" id="amount" class="form-control form-control-sm">
                                </div>
                                <div class="col-12 col-md-auto form-group d-flex align-items-end">
                                    <button class="btn btn-secondary btn-sm btn-block" id="additem" style="height: calc(1.5em + .5rem + 2px);"><i class="fas fa-plus-circle fa-fw fa-sm mr-1"></i> Add</button>
                                </div>
                            </div>
                            
                            <div class="table-responsive mt-3">
                                <table class="table table-sm table-striped mb-0" id="itemslist">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>#</th>
                                            <th class="d-none d-md-table-cell">Reference</th>
                                            <th>Narration</th>
                                            <th class="d-none d-md-table-cell">Account Charged</th>
                                            <th class="text-right">Amount</th>
                                            <th style="width: 50px;" class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">No items added to this voucher yet.</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- Desktop Footer inside the card container as a card footer to prevent overflow -->
                        <div class="card-footer bg-white border-top-0 d-none d-lg-block pb-3 pt-0">
                            <div class="row align-items-center">
                                <div class="col-12 col-md-7 d-flex">
                                    <button class="btn btn-sm btn-success mr-2 px-4" id="savevoucher"><i class="fas fa-save fa-fw fa-sm mr-1"></i> Save Voucher</button>
                                    <button class="btn btn-outline-danger btn-sm px-4" id="clearvoucher"><i class="fas fa-eraser fa-fw fa-sm mr-1"></i> Clear</button>
                                </div>
                                <div class="col-12 col-md-5">
                                    <div class="text-secondary text-right lead font-weight-bold">Total: <span id="totalfield" class="text-dark">0.00</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mobile/Tablet Sticky Footer View -->
        <div class="sticky-footer d-lg-none">
            <div class="d-flex align-items-center justify-content-between w-100 px-3 py-2">
                <div class="d-flex">
                    <button class="btn btn-success btn-mobile-icon mr-2" id="savevoucher-mobile" title="Save Voucher">
                        <i class="fas fa-save"></i>
                    </button>
                    <button class="btn btn-outline-danger btn-mobile-icon" id="clearvoucher-mobile" title="Clear">
                        <i class="fas fa-eraser"></i>
                    </button>
                </div>
                <div class="font-weight-bold text-dark mb-0" style="font-size: 0.95rem;">
                    Total: <span id="totalfield-mobile">0.00</span>
                </div>
            </div>
        </div>
    </section>

</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/pettycashvoucherdetails.js?v=<?php echo time(); ?>"></script>
</html>