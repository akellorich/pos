<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Receive Items </title>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <div class="home-content">
        <i class='bx bx-menu' ></i>
        <span class="text">Receive Items</span>
        <div class="container-fluid">
            <div class="row mt-2">
                <div class="col col-md-3">
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
                            
                            <div class="form-group" id="invoicefields">
                                <label for="invoicenumber">Invoice Number</label>
                                <input type="text" name="invoicenumber" id="invoicenumber" class="form-control form-control-sm">
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

                            <button id="save" name="save"  class="btn btn-success btn-sm mt-2 mr-2"><i class="fal fa-save fa-lg fa-fw"></i> Save Received Goods</button>
                            <button id="clear" name="clear"  class="btn btn-danger btn-sm mt-2"><i class="fal fa-hand-sparkles fa-lg fa-fw"></i> Clear Form </button>
                        </div>
                    </div>
                    <!-- <input type="button" id="gotomain" name="gotomain" value="Main Menu" class="btn btn-primary btn-sm w-100">-->
                </div> 

                <div class="col" id="receiptlist">
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Step 2 - Provide Items Received</h5>
                        </div>
                        <div class="card-body card-body-list scrollable-y">
                            <div id="errors"></div>
                            <table  id="receiveditems" name="receiveditems" class="table table-striped table-sm">
                                <thead class="thead-light">
                                    <tr>
                                        <th>Purchase Order #</th>
                                        <th>Item Code</th>
                                        <th>Item Name</th>
                                        <th>Qty Ordered</th>
                                        <th>Unit Price</th>
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
                            <!-- <div class="row">
                                <div class="col col-md-9">
                                    &nbsp;
                                </div>
                                <div class="col">
                                    
                                </div>
                            </div> -->
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