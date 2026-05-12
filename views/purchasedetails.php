<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Purchases </title>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <div class="home-content">
      <i class='bx bx-menu' ></i>
      <span class="text">Purchases</span>
        <div class="container-fluid">
            <input type="hidden" id="id" name="id" value="0">
            <!-- <p class="lead text-center mt-2 mb-2">Product Purchases</p> -->
            <div class="row mt-1">
                <div class="col col-md-3">
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
                            <button type="button" id="save" name="save" class="btn btn-success btn-sm mt-2 mr-2"><i class="fal fa-save fa-fw fa-lg"></i>  Save Purchase</button>
                            <button type="button" id="clear" name="clear"  class="btn btn-danger btn-sm mt-2"><i class="fal fa-hand-sparkles fa-fw fa-lg"></i> Clear Form</button> 
                        </div>
                    </div>
                </div>   

                <div class="col"  id="receiptlist">
                    <div class="containergroup card">
                        <div class="card-header">
                            <h5>Step 2 - Add Purchase Items</h5>
                        </div>
                        <div class="card-body card-body-list">
                            <div id="errors" class="mt-2"></div>  
                            <div class="row">
                                <div class="col col-md-7">
                                    <div class="form-group">
                                        <label for="itemcode">Item Code:</label>
                                        <input type="text" name="itemcode" id="itemcode"  class="form-control form-control-sm">
                                    </div>
                                    <div id="searchproducts"></div>
                                </div>
                                <div class="col col-md-3">
                                    <label for="taxtype">Tax Type</label>
                                        <div class="input-group">
                                        <select id="taxtype" class="form-control form-control-sm"></select>
                                        <div class="input-group-append">
                                            <button class="btn btn-sm btn-secondary" id="applytaxrate"><i class="fal fa-copy fa-lg"></i></button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label for="">TOTAL:</label>
                                        <input type="text" name="overalltotal" id="overalltotal" class="form-control form-control-sm text-right font-weight-bold" value="0.00" disabled>
                                    </div>
                                </div>
                            </div>   
                           
                            <div class="scrollable-big">
                                <table id="purchaseitems" name="purchaseitems" class="table table-striped table-sm">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Item Code</th>
                                            <th>Item Name</th>
                                            <th>Unit Price</th>
                                            <th>Taxable</th>
                                            <th>Tax Inc</th>
                                            <th class='text-align-right'>Quantity</th> 
                                            <th class='text-align-right'>Total Price</th>
                                            <th class='text-align-right'>Tax Amount</th>
                                            <th class='text-align-right'>Line Total</th>
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