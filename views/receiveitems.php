<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Receive Items </title>
    <style>
      /* Mobile and Tablet optimization rules */
      @media (max-width: 991.98px) {
          .home-section {
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
          
          /* Span TOTAL warning and Action buttons across both columns */
          .col-12.col-lg-3 .card-body-list p.lead,
          .col-12.col-lg-3 .card-body-list .step1-actions {
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
      
      
      @media (min-width: 992px) {
          .col-lg-3 .containergroup,
          #receiptlist .containergroup {
              height: calc(100vh - 95px) !important;
              display: flex;
              flex-direction: column;
          }
          .col-lg-3 .card-body-list,
          #receiptlist .card-body {
              flex: 1;
              overflow-y: auto;
              height: calc(100vh - 135px) !important;
              max-height: none !important;
              padding-bottom: 15px !important;
          }
          .step1-actions {
              display: flex;
              flex-direction: column;
              gap: 8px;
              margin-top: 15px;
          }
          .step1-actions button {
              width: 100% !important;
              display: block;
              margin: 0 !important;
          }
      }
    </style>
  </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <?php $pagename = "Receive Items"; require_once("topbar.php"); ?>
        <div class="container-fluid">
            <div class="row mt-2">
                <div class="col-12 col-lg-3 mb-4">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Step 1 - GRN Settings</h5>
                        </div>
                        <div class="card-body card-body-list">
                            <div class="form-group">
                                 <label for="warehouse">Recipient Warehouse:</label>
                                <select name="warehouse" id="warehouse"  class="form-control form-control-sm"></select>
                            </div>
                            <div class="form-group">
                                 <label for="deliverynotenumber" class="">Delivery Note Number:</label>
                                <input type="text" name="deliverynotenumber" id="deliverynotenumber"  class="form-control form-control-sm"> 
                            </div>
                            <div class="form-group">
                                <label for="supplier" class="">Supplier:</label>
                                <select name="supplier" id="supplier"  class="form-control form-control-sm"></select>
                            </div>
                            <div class="form-group">
                                <label for="purchaseordernumber">Purchase Order #:</label>
                                <div class="input-group mb-3">
                                    <select name="purchaseordernumber" id="purchaseordernumber"  class="form-control form-control-sm"></select>
                                    <div class="input-group-append">
                                    <button id="addpurchaseorder" name="addpurchaseorder"  class="btn btn-secondary btn-sm"><i class="fal fa-plus-circle fa-lg"></i> Add Items</button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="inspectedby">Inspected By</label>
                                <select name="inspectedby" id="inspectedby" class="form-control form-control-sm"></select>
                            </div>
                            
                            <div class="form-group" id="invoicefields" style="position: relative;">
                                <label for="invoicenumber">Invoice Number</label>
                                <input type="text" name="invoicenumber" id="invoicenumber" class="form-control form-control-sm" style="padding-right: 25px;">
                                <i class="fal fa-copy text-muted" id="copy-delivery-note" title="Copy Delivery Note to Invoice Number" style="position: absolute; right: 10px; bottom: 9px; cursor: pointer; font-size: 13px;"></i>
                            </div>

                            <div class="form-group">
                                <label for="tarnsferreceiveditems">Transfer Received Items</label>
                                <select name="transferreceiveditems" id="transferreceiveditems" class="form-control form-control-sm">
                                    <option value="0">No</option>
                                    <option value="1">Yes</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="transferitemsto">Transfer Items To</label>
                                <select name="transferitemsto" id="transferitemsto" class="form-control form-control-sm" disabled>
                                    <option value="">&lt;Choose&gt;</option>
                                </select>
                            </div>
                            <p class='lead text-right alert alert-warning'>TOTAL: <span id="overalltotal">0.00</span></p>

                            <div class="step1-actions">
                                <button id="save" name="save"  class="btn btn-success btn-sm mt-2 mr-2"><i class="fal fa-save fa-lg fa-fw"></i> Save Goods</button>
                                <button id="clear" name="clear"  class="btn btn-outline-danger btn-sm mt-2"><i class="fal fa-hand-sparkles fa-lg fa-fw"></i> Clear Form</button>
                            </div>
                        </div>
                    </div>
                </div> 

                <div class="col-12 col-lg-9" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Step 2 - Provide Items Received</h5>
                        </div>
                        <div class="card-body card-body-list scrollable-y">
                            <div id="errors"></div>
                            <div class="table-responsive">
                                <table  id="receiveditems" name="receiveditems" class="table table-striped table-sm">
                                    <thead class="thead-light">
                                        <tr>
                                            <th class="d-none d-lg-table-cell">Purchase Order #</th>
                                            <th>Item Code</th>
                                            <th>Item Name</th>
                                            <th class="d-none d-md-table-cell">Qty Ordered</th>
                                            <th class="d-none d-md-table-cell">Unit Price</th>
                                            <th>Qty Received</th>
                                            <th>Serial #</th>
                                            <th>Line Total</th>
                                            <th>&nbsp;</th>
                                        </tr>
                                    </thead>
                                    <tbody id="receiveditemsdetails" class="scrollable"></tbody>
                                    <tfoot>
                                            
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal" tabindex="-1" role="dialog" id="serialsmodal">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Add Serial Numbers</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="serialserrors"></div>
                    <input type="hidden" name="serialitemid" value="" id="serialitemid">
                    <div class="row">
                        <div class="col col-md-9">
                            <div class="form-group">
                                <label for="serialitemname" class="text-muted">Item Name:</label>
                                <input type="text" name="serialitemname" id="serialitemname" class="form-control form-control-sm" disabled>
                            </div>   
                        </div>

                        <div class="col">
                            <div class="form-group">
                                <label for="serialquantity" class="text-muted">Quantity:</label>
                                <input type="text" name="serialquantity" id="serialquantity" class="form-control form-control-sm" disabled>
                            </div>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col">
                            <label for="serialnumbers">Serial Numbers: <span class="small text-muted"> Add multiple serial numbers separating by comma</span></label>
                            <div class="input-group mb-3">                            
                                <input type="text" id="serialnumbers" class="form-control from-control-sm" placeholder="" aria-label="Add multiple serials separated by comma" aria-describedby="basic-addon2">
                                <div class="input-group-append">
                                    <button class="btn btn-secondary btn-sm" type="button" id="saveserialnumbers"><i class="fas fa-plus-circle fa-lg fa-fw"></i></button>
                                </div>
                            </div>
                            
                        </div>
                    </div>
                    <table class="table table-sm table-striped" id="serialstable">
                        <thead>
                            <th>#</th>
                            <th>Serial Number</th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <span id="serialstotals"></span>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="updateserials"> <i class="fas fa-save fa-lg fa-fw"></i> Save Serials</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fas fa-times-circle  fa-lg fa-fw"></i> Close</button>
                </div>

            </div>
        </div>
    </div>
  </section>
   
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/receiveitems.js"></script>
</html>