<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Purchases </title>
    <style>
      /* Make step 1 actions stack and take 100% parent width on desktop */
      .step1-actions {
          display: flex;
          flex-direction: column;
          gap: 10px;
          margin-top: 15px;
      }
      
      .step1-actions button {
          width: 100% !important;
          margin: 0 !important;
      }

      @media (max-width: 991.98px) {
          .container-fluid {
              padding-left: 8px !important;
              padding-right: 8px !important;
          }
          .row.mt-2, .row.mt-1 {
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
              margin-left: 0 !important; /* Fix misalignment by overriding custom.css margin-left: -25px */
          }
          .card-body, .card-body-list {
              padding-left: 16px !important;
              padding-right: 16px !important;
              height: auto !important; /* Remove bottom empty space on mobile/tablet views */
              max-height: none !important;
              min-height: 0 !important;
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
              width: 160px !important; /* Reduce width of buttons */
              flex: none !important;   /* Avoid full-width stretching */
              margin: 0 !important;
              padding: 6px 14px !important; /* Slightly shrunk padding for lower height */
              height: 36px !important;      /* Slightly reduced height */
              font-size: 0.82rem !important; /* Refined font size */
              border-radius: 6px !important;
              display: inline-flex !important;
              align-items: center !important;
              justify-content: center !important;
              font-weight: 500 !important;
          }
      }

      /* On tablet viewports where sidebar is collapsed, offset left edge of the fixed footer by 78px */
      @media (min-width: 768px) and (max-width: 991.98px) {
          .step1-actions {
              left: 78px !important;
          }
      }

      /* Display 2 items per row in Step 1 on tablet view specifically */
      @media (min-width: 576px) and (max-width: 991.98px) {
          .col-12.col-lg-3 .card-body-list {
              display: grid !important;
              grid-template-columns: repeat(2, 1fr) !important;
              gap: 12px 16px !important;
          }
          
          .col-12.col-lg-3 .card-body-list .form-group {
              margin-bottom: 0 !important;
          }
          
          /* Span Terms textarea and Action buttons across both columns */
          .col-12.col-lg-3 .card-body-list .form-group:nth-child(6), /* Terms textarea */
          .col-12.col-lg-3 .card-body-list .step1-actions {          /* Button actions container */
              grid-column: span 2 !important;
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
    </style>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <?php $pagename = "Purchases"; require_once("topbar.php"); ?>
        <div class="container-fluid">
            <input type="hidden" id="id" name="id" value="0">
            <!-- <p class="lead text-center mt-2 mb-2">Product Purchases</p> -->
            <div class="row mt-1">
                <div class="col-12 col-lg-3 mb-4">
                    <div class="containergroup card">
                        <div class="card-header">
                            <h5>Step 1 - Purchase Order Set Up</h5>
                        </div>
                        <div class="card-body card-body-list">
                            <div class="form-group">
                                <label for="purchasetype">Purchase Type</label>
                                <select name="purchasetype" id="purchasetype" class="form-control form-control-sm">
                                    <option value="product">Product</option>
                                    <option value="rawmaterial">Raw Material</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="department">Department</label>
                                <select name="departments" id="department" class="form-control form-control-sm"></select>
                            </div>
                            <div class="form-group">
                                <label for="supplier">Supplier:</label>
                                <select name="supplier" id="supplier"  class="form-control form-control-sm"></select>
                            </div>   
                            <div class="form-group">
                                <label for="currency">Currency</label>
                                <select name="currency" id="currency" class="form-control form-control-sm"></select>
                            </div> 
                            <div class="form-group">
                                <label for="exchangerate">Exchange Rate</label>
                                <input type="number" name="exchangerate" id="exchangerate" class="form-control form-control-sm">
                            </div>
                            <div class="form-group">
                                <label for="terms">Purchase Order Terms:</label>
                                <textarea  name="terms" id="terms"  row="6" class="form-control form-control-sm"></textarea>
                            </div>
                            <div class="step1-actions mt-2">
                                <button type="button" id="save" name="save" class="btn btn-success btn-sm mr-2"><i class="fal fa-save fa-fw fa-lg"></i>  Save Purchase</button>
                                <button type="button" id="clear" name="clear"  class="btn btn-outline-danger btn-sm"><i class="fal fa-hand-sparkles fa-fw fa-lg"></i> Clear Form</button> 
                            </div>
                        </div>
                    </div>
                </div>   

                <div class="col-12 col-lg-9" id="receiptlist">
                    <div class="containergroup card">
                        <div class="card-header">
                            <h5>Step 2 - Add Purchase Items</h5>
                        </div>
                        <div class="card-body card-body-list">
                            <div id="errors" class="mt-2"></div>  
                            <div class="row">
                                <div class="col-12 col-md-7 mb-3">
                                    <div class="form-group">
                                        <label for="itemcode">Item Code:</label>
                                        <input type="text" name="itemcode" id="itemcode"  class="form-control form-control-sm" autocomplete="off" placeholder="Search Item ...">
                                    </div>
                                    <div id="searchproducts"></div>
                                </div>
                                <div class="col-12 col-sm-6 col-md-3 mb-3">
                                    <label for="taxtype">Tax Type</label>
                                        <div class="input-group">
                                        <select id="taxtype" class="form-control form-control-sm"></select>
                                        <div class="input-group-append">
                                            <button class="btn btn-sm btn-secondary" id="applytaxrate"><i class="fal fa-copy fa-lg"></i></button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-sm-6 col-md-2 mb-3">
                                    <div class="form-group">
                                        <label for="">TOTAL:</label>
                                        <input type="text" name="overalltotal" id="overalltotal" class="form-control form-control-sm text-right font-weight-bold" value="0.00" disabled>
                                    </div>
                                </div>
                            </div>   
                           
                            <div class="scrollable-big table-responsive">
                                <table id="purchaseitems" name="purchaseitems" class="table table-striped table-sm">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Item Code</th>
                                            <th>Item Name</th>
                                            <th class="d-none d-lg-table-cell">Unit Price</th>
                                            <th class="d-none d-lg-table-cell">Taxable</th>
                                            <th class="d-none d-lg-table-cell">Tax Inc</th>
                                            <th class='text-align-right'>Quantity</th> 
                                            <th class='text-align-right'>Total Price</th>
                                            <th class='d-none d-lg-table-cell text-align-right'>Tax Amount</th>
                                            <th class='d-none d-lg-table-cell text-align-right'>Line Total</th>
                                            <th class='text-align-center'>&nbsp;</th>
                                        </tr>
                                    </thead>
                                    <tbody id="purchaseitemsdetails"></tbody>
                                    <tfoot>  
                                    </tfoot>
                                </table>
                            </div>
                            <!-- <div class="row">
                                <div class="col col-md-9">&nbsp;</div>
                                <div class="col">
                                    <p class="text-right font-weight-bold alert alert-info">TOTAL: 
                                        <span id="overalltotal">
                                            0.00
                                        </span>
                                    </p>
                                </div>
                            </div> -->
                        </div>
                    </div>
                </div> 
            </div>
        </div> 
    </div>
  </section>  
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/purchasedetails.js"></script>
</html>