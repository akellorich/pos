<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Stock Adjustment </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Stock Adjustment"; require_once("topbar.php"); ?>
            <!-- Page Content -->
            <div class="container-fluid">
                <input type="hidden" id="id" name="id" value="0">
                <!-- <p class="lead text-center mt-2 mb-2">Stocklist Reconciliation</p> -->
                <div class="row mt-2">
                    <div class="col col-md-3">  
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Step 1 - Reconcilliation Parameters</h5>
                            </div>
                            
                            <div class="card-body card-body-list">
                            <div class="col form-group">
                                <label for="category">Category</label>
                                <select name="category" id="category" class="form-control form-control-sm">
                                    <option value="outlet">Outlet</option>
                                    <option value="warehouse">Warehouse</option>
                                </select>
                            </div>
                                <div class="col form-group">
                                    <label for="posname">Outlet  Name</label>
                                    <select id="posname" class="form-control form-control-sm">
                                        <option value="">&lt;Choose&gt;</option>
                                    </select>
                                </div>
                                <div class="col form-group">
                                    <label for="narrative">Reconcile Narrative:</label>
                                    <textarea  name="narrative" id="narrative"  class="form-control form-control-sm"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>   

                    <div class="col">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Step 2 - Select Items to Reconcile</h5>
                            </div>
                            <div class="card-body card-body-list">
                                <div id="errors" class="mt-2"></div>     
                                <div class="form-group">
                                    <label for="itemcode">Item Code:</label>
                                    <input type="text" name="itemcode" id="itemcode"  class="form-control form-control-sm">
                                    <div id="searchproducts"></div>
                                </div>

                                <div class="scrollable mb-2">
                                    <table id="purchaseitems" name="purchaseitems" class="table table-striped table-sm">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Item Code</th>
                                                <th>Item Name</th>
                                                <th>Unit Price</th>
                                                <th>Discount</th>
                                                <th>Ext. Price</th>
                                                <th>Quantity</th>
                                                <th>Line Total</th>
                                                <th>&nbsp;</th>
                                            </tr>
                                        </thead>
                                        <tbody id="purchaseitemsdetails"></tbody>
                                        <tfoot>  
                                        </tfoot>
                                    </table>
                                </div>
                                <div class="row">
                                    <div class="col col-md-9">
                                        <button type="button" id="save" name="save" class="btn btn-success btn-sm  mt-2"><i class="fas fa-save fa-fw fa-lg"></i>  Save Reconciliation</button>
                                        <button type="button" id="clear" name="clear"  class="btn btn-danger btn-sm mt-2"><i class="fas fa-eraser fa-fw fa-lg"></i> Clear Form</button>
                                    </div>
                                    <div class="col">
                                        <p class="text-right font-weight-bold alert alert-info">TOTAL: 
                                            <span id="overalltotal">
                                                0.00
                                            </span>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> 
                </div>
            </div>  
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/stockreconciliation.js"></script>
</html>
