<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Requisition Details </title>
    <style>
      /* Responsive customizations for the Requisition Details page */
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
          body {
              padding-bottom: 75px !important;
          }
          .requisition-footer-row {
              position: fixed !important;
              bottom: 0 !important;
              left: 0 !important;
              right: 0 !important;
              background: #ffffff !important;
              border-top: 1px solid rgba(0, 0, 0, 0.08) !important;
              box-shadow: 0 -4px 15px rgba(0, 0, 0, 0.08) !important;
              padding: 10px 15px !important;
              z-index: 2060 !important;
              display: flex !important;
              flex-direction: row !important;
              align-items: center !important;
              justify-content: space-between !important;
              margin: 0 !important;
          }
          .requisition-footer-row > div {
              margin: 0 !important;
              padding: 0 !important;
              width: auto !important;
              flex: none !important;
              max-width: none !important;
          }
          .requisition-footer-row .btn {
              margin: 0 4px 0 0 !important;
              padding: 8px 16px !important;
              font-size: 1.1rem !important;
              border-radius: 6px !important;
              display: inline-flex !important;
              align-items: center !important;
              justify-content: center !important;
              height: 38px !important;
              width: 50px !important;
          }
          .requisition-footer-row .btn i {
              margin: 0 !important;
              font-size: 1.2rem !important;
          }
          .requisition-footer-row .alert {
              margin: 0 !important;
              padding: 8px 12px !important;
              font-size: 0.9rem !important;
              border-radius: 6px !important;
              display: inline-flex !important;
              align-items: center !important;
              height: 38px !important;
          }
      }
      @media (min-width: 768px) and (max-width: 991.98px) {
          .requisition-footer-row {
              left: 78px !important;
          }
      }
      
      /* Reduce paddings and margins of container-fluid on mobile view */
      @media (max-width: 767.98px) {
          .container-fluid {
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
      
      /* Responsive DataTable improvements */
      .table-responsive {
          border-radius: 6px;
          overflow: visible !important;
      }

      /* Adjust form controls inside filters for cleaner spacing */
      .form-group {
          margin-bottom: 0.75rem;
      }
      
      .form-group label {
          font-weight: 500;
          color: #495057;
          margin-bottom: 0.25rem;
          font-size: 0.8rem;
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Requisition Details"; require_once("topbar.php"); ?>
            <div class="container-fluid ">
                <div class="row">
                    <div class="col-12 col-lg-3 mb-4">
                        <div class="collapse show d-lg-block" id="filterCollapse">
<div class="card containergroup filteroptions">
                            <div class="card-header">
                                <h5>Step 1. - Setup</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div class="row" id="reqnodetails" style="display:none">
                                    <div class="col col-md-8">
                                        <div class="form-group">
                                            <label for="requisitionno"><span id="requisitionlabel">Requisition Number</span> </label>
                                            <input type="text" name="requisitionno" id="requisitionno" class="form-control form-control-sm">
                                        </div>
                                    </div>

                                    <div class="col">
                                        <div class="form-group form-check">
                                            <input type="checkbox" name="autogenerate" id="autogenerate" class="form-check-input">
                                            <label for="autogenerate" class="form-check-label">Generate</label>
                                        </div>
                                    </div>
                                </div>
                            
                                <div class="form-group">
                                    <label for="purchaserequisition">Purchase Requisition</label>
                                    <select name="purchaserequisition" id="purchaserequisition" class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                        <option value="1">Yes</option>
                                        <option value="0">No</option>
                                    </select>
                                </div>
                                
                                <div class="form-group mt-2">
                                    <label for="refno">Reference Number</label>
                                    <input type="text" name="refno" id="refno" class="form-control form-control-sm">
                                </div>

                                <div class="form-group" id="supplierfields" style="display:none">
                                    <label for="supplier"><span id="supplierlabel">Supplier</span></label>
                                    <select name="supplier" id="supplier" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="department">Department</label>
                                    <select name="department" id="department" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="requisitionnarration">Narration</label>
                                    <textarea type="text" name="requisitionnarration" id="requisitionnarration" class="form-control form-control-sm"></textarea>
                                </div>
                            </div>
                        </div>
                        </div>
                    </div>

                    <div class="col-12 col-lg-9" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5>Step 2. - Select Requisition Items</h5>
                                <button class="btn btn-outline-primary btn-xs d-lg-none d-flex align-items-center" 
                                        type="button" 
                                        data-toggle="collapse" 
                                        data-target="#filterCollapse" 
                                        aria-expanded="true" 
                                        aria-controls="filterCollapse"
                                        id="toggleFiltersBtn"
                                        style="border-radius: 4px; font-weight: 500; font-size: 0.75rem; padding: 4px 8px; border: 1px solid #2b5c8f; color: #2b5c8f; background: transparent;">
                                    <i class="fas fa-times mr-1" style="font-size: 0.8rem;"></i>
                                    <span>Close</span>
                                </button>
                            </div>
<div class="card-body">
                                <div id="requisitionerrors"></div>
                                <input type="hidden" name="id" value="0" id="id">
                                <div class="row">
                                    <div class="col-12 col-md-4">
                                        <div class="from-group">
                                            <label for="item">Item Name</label>
<input type="text" name="itemname" id="itemname" class="form-control form-control-sm" data-id="0" data-uom="" data-unitprice="" data-itemcode="">
                                            <div id="searchmaterials"></div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-3">
                                        <div class="form-group">
                                            <label for="quantity">Quantity</label>
<input type="number" name="quantity" id="quantity" class="form-control form-control-sm">
                                        </div>
                                    </div>
                                    <div class="col-12 col-md">
                                        <div class="form-group">
                                            <label for="narration">Narration</label>
<div class="input-group">
                                                <input type="text" name="narration" id="narration" class="form-control form-control-sm">
                                                <div class="input-group-append">
                                                    <button class="btn btn-secondary btn-sm d-block" id="additem"><i class="fal fa-plus-circle fa-lg fa-fw"></i> </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                </div>
                                <div class="requisitionmateriallist table-responsive">
                                    <table class="table table-sm table-striped" id="materialslist">
<thead>
                                            <th>#</th>
                                            <th>Item Code</th>
                                            <th>Item Name</th>
                                            <th>Narration</th>
                                            <th>Unit</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Total</th>
                                            <th>&nbsp;</th><!-- Edit -->
                                            <th>&nbsp;</th><!-- Delete -->
                                            <th>&nbsp;</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                                
                                <div class="row requisition-footer-row">
                                    <div class="col col-md-9 mt-2">
                                        <button class="btn btn-sm btn-success mt-2" id="saverequisition" title="Save Changes"><i class="fal fa-save fa-lg fa-fw"></i> <span class="d-none d-lg-inline">Save Changes</span></button>
                                        <button class="btn btn-sm btn-outline-danger mt-2" id="clearfields" title="Clear Fields"><i class="fal fa-hand-sparkles fa-lg fa-fw"></i> <span class="d-none d-lg-inline">Clear Fields</span></button>
                                    </div>
                                    <div  class=" col alert alert-warning mt-2 mr-2 font-weight-bold">
                                        <span>Total:</span><span id="total" class="text-right ml-2">0.00</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <div class="modal" tabindex="-1" role="dialog" id="activitymaterialsummary">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title">Activity Material Summary</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row ml-1 mr-1 text-white text-center activitymaterialsummary">
                        <div class="approved bg-success col">
                            <i class="fas fa-check-circle fa-2x fa-fw mt-1"></i>
                            <br><small>Approved</small>
                            <p class='lead'>0.00</p>
                        </div>

                        <div class="issued bg-secondary col  text-center">
                            <i class="fas fa-people-carry  fa-2x fa-fw mt-1"></i> 
                            <br><small>Issued</small>
                            <p class='lead'>0.00</p>
                        </div>

                        <div class="committed bg-primary col text-center">
                            <i class="fas fa-handshake fa-2x fa-fw mt-1"></i> 
                            <br><small>Committed</small>
                            <p class='lead'>0.00</p>
                        </div>

                        <div class="available bg-danger col text-center">
                            <i class="fas fa-receipt fa-2x fa-fw mt-1"></i>
                            <br><small>Available</small>
                            <p class='lead'>0.00</p>
                        </div>

                        <div class="instock bg-dark col text-center">
                            <i class="fas fa-receipt fa-2x fa-fw mt-1"></i>
                            <br><small>In-stock</small>
                            <p class='lead'>0.00</p>
                        </div>

                    </div>
                   
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/requisitiondetails.js"></script>
</html>
