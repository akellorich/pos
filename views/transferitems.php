<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Stock Transfer </title>
    <style>
      /* Mobile & Tablet Responsive Optimizations */
      @media (max-width: 991.98px) {
          .home-section {
              padding-left: 0 !important;
              padding-right: 0 !important;
          }
          .container-fluid {
              padding-left: 15px !important;
              padding-right: 15px !important;
          }
          .col-12 {
              padding-left: 15px !important;
              padding-right: 15px !important;
          }
          #receiptlist {
              padding-left: 15px !important;
              padding-right: 15px !important;
              margin-left: 0 !important;
          }
          .card {
              margin-bottom: 12px !important;
              border-radius: 8px !important;
              border: 1px solid #e2e8f0 !important;
              box-shadow: 0 1px 3px rgba(0,0,0,0.02) !important;
          }
          .card-body {
              padding: 15px !important;
          }
          /* Eliminate hardcoded height and remove white space below Step 1 */
          .card-body-list {
              height: auto !important;
              min-height: 0 !important;
              max-height: none !important;
              overflow-y: visible !important;
          }
      }

      @media (min-width: 992px) {
          /* Step 1 and Step 2 height matching */
          .col-12.col-lg-3 .containergroup.card,
          #receiptlist.col-12.col-lg-9 .containergroup.card {
              height: calc(100vh - 95px) !important;
              display: flex;
              flex-direction: column;
          }
          
          /* Step 1 card body */
          .col-12.col-lg-3 .card-body-list {
              flex: 1;
              overflow-y: auto;
              height: calc(100vh - 135px) !important;
              max-height: none !important;
          }
          
          /* Step 2 card body */
          #receiptlist.col-12.col-lg-9 .card-body {
              flex: 1;
              display: flex;
              flex-direction: column;
              height: calc(100vh - 135px) !important;
              max-height: none !important;
              overflow: hidden; /* Hide outer overflow */
          }
          
          /* Step 2 table wrapper */
          .card-body-list-withheader {
              flex: 1;
              overflow-y: auto !important;
              overflow-x: auto !important;
              margin-bottom: 15px; /* Leave some padding bottom */
              border: 1px solid #e2e8f0;
              border-radius: 6px;
          }
      }

      /* Reduce paddings and margins of container-fluid on mobile view (< 768px) */
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
              padding: 10px !important;
          }
      }

      /* Make table scrollable on mobile */
      .card-body-list-withheader {
          overflow-x: auto !important;
          -webkit-overflow-scrolling: touch;
      }
      
      #transferreditems {
          min-width: 750px;
      }
      
      /* Premium button designs */
      .containergroup.card {
          border: none;
          border-radius: 8px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
          background: #ffffff;
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
          font-size: 0.82rem;
          font-weight: 600;
          color: #2b5c8f;
      }

      .step1-actions {
          display: flex !important;
          flex-direction: column !important;
          gap: 10px !important;
          margin-top: 15px !important;
      }
      
      .step1-actions button {
          width: 100% !important;
          margin: 0 !important;
      }

      #searchproducts {
          position: absolute;
          z-index: 1050;
          background: #ffffff;
          width: 100%;
          max-height: 250px;
          overflow-y: auto;
          box-shadow: 0 10px 25px rgba(0,0,0,0.15);
          border-radius: 8px;
          border: 1px solid #e2e8f0;
          margin-top: 2px;
          display: none;
      }
      
      .searchresults-container {
          padding: 0 !important;
      }
      
      .searchresults-container li {
          transition: background-color 0.15s ease;
          border-bottom: 1px solid #f1f5f9 !important;
      }
      
      .searchresults-container li:hover {
          background-color: #f1f5f9 !important;
      }
      
      .select-product-chk, .select-all-chk {
          width: 14px;
          height: 14px;
          cursor: pointer;
          accent-color: #007bff;
      }

      /* Premium styles for contenteditable quantity field */
      td.quantity[contenteditable="true"] {
          background-color: #f8fafc;
          border: 1px dashed #cbd5e1;
          border-radius: 4px;
          padding: 6px 10px !important;
          cursor: text;
          transition: all 0.15s ease-in-out;
          outline: none;
          font-weight: 600;
          color: #1e293b;
          text-align: center;
      }
      td.quantity[contenteditable="true"]:hover {
          background-color: #f1f5f9;
          border-color: #94a3b8;
      }
      td.quantity[contenteditable="true"]:focus {
          background-color: #ffffff;
          border: 1px solid #3b82f6;
          box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
      }
    </style>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Stock Transfer"; require_once("topbar.php"); ?>
            <div class="container-fluid">
                <!-- <p class="lead fornt-weight-bold text-center mt-3 font-weight-bold">Stock Movement Details</p> -->
                <div class="row mt-2">
                    <div class="col-12 col-lg-3 mb-4">
                        <div class="card containergroup"> <!---->
                            <div class="card-header">
                                <h5>Step 1 - Select Source/Destination:</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div class="form-group">
                                    <label for="source">Source:</label>
                                    <select name="source" id="source"  class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="sourceitem">Source Location:</label>
                                    <select name="sourceitem" id="sourceitem"  class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="destination">Destination:</label>
                                    <select name="destination" id="destination"  class="form-control form-control-sm"></select>
                                </div>
                                <div class="form-group">
                                    <label for="destinationitem">Destination Location:</label>
                                    <select name="destinationitem" id="destinationitem"  class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="issuedto">Issued To</label>
                                    <select name="issuedto" id="issuedto" class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="storecontroller">Store Controller</label>
                                    <select name="storecontroller" id="storecontroller" class="form-control form-control-sm">
                                        <option value="">&lt;Choose One&gt;</option>
                                    </select>
                                </div>
                                <div class="step1-actions mt-2">
                                    <button type="button" id="save" name="save" class="btn btn-success btn-sm"><i class="fal fa-save fa-fw fa-lg"></i> Save Transfer</button>
                                    <button type="button" id="clear" name="clear" class="btn btn-outline-danger btn-sm"><i class="fal fa-hand-sparkles fa-fw fa-lg"></i> Clear Form</button>
                                </div>
                            </div>
                        </div>  
                    </div>

                    <div class="col-12 col-lg-9 mb-5" id="receiptlist">
                        <div class="card containergroup"> <!---->
                            <div class="card-header">
                                <h5>Step 2 - Add items to transfer</h5>
                            </div>
                            <div class="card-body">
                                <div id="errors"></div>
                                <div class="row">
                                    <div class="col col-md-9">
                                        <div class="form-group">
                                            <label for="itemcode">Item Code:</label>
                                            <input type="text" name="itemcode" id="itemcode"  class="form-control form-control-sm" autocomplete="off" placeholder="Search item ..."> 
                                        </div>
                                        <div id="searchproducts"></div>
                                    </div>
                                    <div class="col">
                                        <div class="form-group">
                                            <label for="overalltotal" class="text-right">Total:</label>
                                            <input type="text" name="overalltotal" id="overalltotal"  class="form-control form-control-sm lead font-weight-bold text-right" disabled value='0.00'> 
                                        </div>
                                        <!-- <p  class="alert alert-info total text-right  font-weight-bold">TOTAL: <span id="overalltotal">0.00</span></p> -->
                                    </div>
                                </div>

                                <!-- <div class="mb-3 mr-1 ml-2"> -->
                                    <div class="card-body-list-withheader">
                                            <table  id="transferreditems" name="transferreditems" class="table table-striped table-sm">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th>Item Code</th>
                                                    <th>Item Name</th>
                                                    <th>Quantity in Stock</th>
                                                    <th>Unit Price</th>
                                                    <th>Quantity Transferred</th>
                                                    <th>Serial #</th>
                                                    <th>Line Total</th>
                                                    <th>&nbsp;</th> <!--  -->
                                                </tr>
                                            </thead>
                                            <tbody id="transferreditemsdetails"></tbody>
                                        </table>
                                    </div>
                                    
                                <!-- </div> -->
                            </div>
                        </div> <!----> 
                    </div>
                </div>
            </div> 
        </div>
    </section>
    <!-- Add Serial numbers Modal -->
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
                        <label for="serialnumbers">Serial Number:</label>
                        <div class="input-group mb-3">                            
                            <select id="serialnumbers" class="form-control from-control-sm"  aria-describedby="basic-addon2"></select>
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
                    </thead>
                    <tbody></tbody>
                </table>
                <span id="serialstotals"></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success btn-sm" id="updateserials"> <i class="fal fa-check-circle fa-lg fa-fw"></i> Done</button>
                <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fal fa-times-circle  fa-lg fa-fw"></i> Close</button>
            </div>
            </div>
        </div>
    </div>

    <!-- Transfer Progress & Notification Modal -->
    <div class="modal fade" tabindex="-1" role="dialog" id="transferprogressmodal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content shadow-lg border-0" style="border-radius: 16px; overflow: hidden; background: #ffffff;">
                <div class="modal-body text-center p-5">
                    <!-- Progress State -->
                    <div id="transfer-modal-progress">
                        <div class="spinner-border text-primary mb-4" role="status" style="width: 4rem; height: 4rem; border-width: 0.35em;">
                            <span class="sr-only">Saving...</span>
                        </div>
                        <h4 class="font-weight-bold text-dark">Saving Stock Transfer</h4>
                        <p class="text-muted mb-0">Please wait while we process and secure your stock transfer details.</p>
                    </div>
                    
                    <!-- Result State (Initially Hidden) -->
                    <div id="transfer-modal-result" style="display: none;">
                        <div class="result-icon-wrapper mb-4">
                            <i id="transfer-result-icon" class="fal fa-check-circle fa-5x text-success" style="transition: all 0.3s ease;"></i>
                        </div>
                        <h4 id="transfer-result-title" class="font-weight-bold text-dark mb-3">Transfer Successful!</h4>
                        <div id="transfer-result-message" class="text-muted mb-4 px-3" style="font-size: 1.05rem; line-height: 1.6;"></div>
                        <div class="d-flex justify-content-center">
                            <button type="button" id="transfer-result-btn" class="btn btn-primary px-4 py-2 font-weight-bold btn-modal-action" data-dismiss="modal" style="border-radius: 8px; font-size: 1rem;">OK</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/transferitems.js?v=<?php echo time(); ?>"></script>
</html>