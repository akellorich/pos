<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Products </title>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <div class="home-content">
      <i class='bx bx-menu' ></i>
      <span class="text">Products</span>
        <div class="container-fluid">
            <!-- <p class="lead text-center mt-3">Enter Product Details</p> -->
            <!-- Add Nav Tab  -->
            <nav class="nav-justified ">
                <div class="nav nav-tabs " id="nav-tab" role="tablist">
                    <a class="nav-item nav-link active" id="productdetails-tab" data-toggle="tab" href="#productdetails" role="tab" aria-controls="pop1" aria-selected="true">Details</a>
                    <a class="nav-item nav-link" id="productoptions-tab" data-toggle="tab" href="#productoptions" role="tab" aria-controls="pop2" aria-selected="false">Options</a>
                    <a class="nav-item nav-link" id="productrecipe-tab" data-toggle="tab" href="#productrecipe" role="tab" aria-controls="pop2" aria-selected="false">Recipe</a>
                    <a class="nav-item nav-link" id="bulksplit-tab" data-toggle="tab" href="#bulksplit" role="tab" aria-controls="pop2" aria-selected="false">Bulk Split</a>
                    <a class="nav-item nav-link" id="productdiscount-tab" data-toggle="tab" href="#productdiscount" role="tab" aria-controls="pop2" aria-selected="false">Discounts</a>
                    <a class="nav-item nav-link" id="producthistory-tab" data-toggle="tab" href="#producthistory" role="tab" aria-controls="pop2" aria-selected="false">History</a>
                </div>
            </nav>

            <!-- Individual Tabs -->
            <div class="tab-content text-left" id="nav-tabContent">
                <!-- Product details Tab -->
                <div class="tab-pane fade show active" id="productdetails" role="tabpanel" aria-labelledby="pop1-tab">
                    <div class="card containergroup mt-3">
                        <div class="card-header">
                            <h5>Product Details</h5>
                        </div>
                        <div class="card-body">
                            <div id="errors"></div>    
                            <input type="hidden" id="id" name="id" value="0">

                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="category">Category:</label>
                                        <select id="category" name="category" class="form-control form-control-sm"></select>
                                    </div>
                                </div>
                                
                                <div class="col">            
                                    <label for="generatecode" class="check-label">Generate Code</label>
                                    <select id="generatecode" class="form-control form-control-sm">
                                        <option value="0" selected>No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>
                        
                                <div class="col">
                                    <label for="itemcode">Item Code:</label>
                                        <input type="text" id="itemcode" name="itemcode"  class="form-control form-control-sm" value='<?php
                                            if(isset($_GET['itemcode'])){
                                                echo $_GET['itemcode'];
                                        }
                                    ?>'>
                                </div>

                                <div class="col">
                                    <div class="form-group">
                                        <label for="itemname">Item Name:</label>
                                        <input type="text" id="itemname" name="itemname"  class="form-control form-control-sm">
                                    </div>
                                </div>

                            </div>
                            <div class="row">
                                <div class="col form-group">
                                    <label for="">&nbsp;</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text">
                                                <input type="checkbox" id="usedimensions">
                                            </div>
                                        </div>
                                        <input type="text" class="form-control form-control-sm" value="Use dimensions">
                                    </div>
                                </div>
                                <div class="col form-group">
                                    <label for="length">Length</label>
                                    <input type="number" name="length" id="length" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="width">Width</label>
                                    <input type="number" name="width" id="width" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="height">Height</label>
                                    <input type="number" name="height" id="height" class="form-control form-control-sm">
                                </div>
                                
                            </div>
                        
                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="uom">Unit of Measure:</label>
                                        <select id="uom" name="uom" class="form-control form-control-sm"></select>
                                    </div>
                                </div>
                                
                                <div class="col form-group">
                                    <label for="saleby">Sale By</label>
                                    <select name="saleby" id="saleby" class="form-control form-control-sm">
                                        <option value="quantity">Quantity</option>
                                        <option value="value">Value</option>
                                    </select>
                                </div>
                               
                                <div class="col">
                                    <div class="form-group">
                                        <label for="taxtype">Tax Type:</label>
                                        <select name="taxtype" id="taxtype" class="form-control form-control-sm"></select>
                                    </div>
                                </div>

                                <div class="col">
                                    <div class="from-group">
                                        <label for="serializable">Serializable</label>
                                        <select name="serializable" id="serializable" class="form-control form-control-sm">
                                            <option value="0">No</option>
                                            <option value="1">Yes</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="buyingprice">Buying Price:</label>
                                        <input type="number" id="buyingprice" name="buyingprice"  class="form-control form-control-sm">
                                    </div>
                                </div>
                                
                                <div class="col">
                                    <div class="form-group">
                                        <label for="sellingprice">Selling Price:</label>
                                        <input type="number" id="sellingprice" name="sellingprice"  class="form-control form-control-sm">
                                    </div>
                                </div>
                                
                                <div class="col">
                                    <div class="form-group">
                                        <label for="reorderlevel">Reorder Level:</label>
                                        <input type="number" id="reorderlevel" name="reorderlevel"  class="form-control form-control-sm">
                                    </div>
                                </div>

                                <div class="col form-group">
                                    <label for="allownegativesales">Allow Negative Sales</label>
                                    <select name="allownegativesales" id="allownegativesales" class="form-control form-ocntrol-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>

                            </div>

                            <div class="row">
                                 <div class="col">
                                    <div class="form-group">
                                        <label for="bundleitem">Bundle Item</label>
                                        <select name="bundleitem" id="bundleitem" class="form-control form-control-sm">
                                                <option value="0">No</option>
                                                <option value="1">Yes</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col">
                                    <div class="form-group">
                                        <label for="bundleproduct">Bundle Product</label>
                                        <select name="bundleproduct" id="bundleproduct" class="form-control form-control-sm"></select>
                                    </div>
                                </div>

                                <div class="col form-group">
                                    <div class="col form-group">
                                        <label for="allowreturnexchange">Allow Exchange during Returns</label>
                                        <select name="allowreturnexchange" id="allowreturnexchange" class="form-control form-control-sm">
                                            <option value="0">No</option>
                                            <option value="1">Yes</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col"></div>

                            </div>

                            <div class="row">
                                <div class="col form-group">
                                    <label for="supportsadditionalbarcodes">Supports Additional Barcodes</label>
                                    <select name="supportsadditionalbarcodes" id="supportsadditionalbarcodes" class="form-control form-control-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>
                                <div class="col form-group">
                                    <label for="variantbarcode">Variant Barcode</label>
                                    <input type="text" name="variantbarcode" id="variantbarcode" class="form-control form-control-sm">
                                </div>

                                <div class="col form-group">
                                    <label for="variantitemname">Variant Item Name</label>
                                    <input type="text" name="variantitemname" id="variantitemname" class="form-control form-control-sm">
                                </div>

                                <div class="col"></div>
                            </div>
                            <table class="table table-sm table-striped table-hover mb-3">
                                <thead>
                                    <th>#</th>
                                    <th>Barcode</th>
                                    <th>Item Name</th>
                                    <th>Date Added</th>
                                    <th>Added By</th>
                                    <th>&nbsp;</th> <!--Edit  -->
                                    <th>&nbsp;</th> <!-- Delete -->
                                </thead>
                                <tbody></tbody>
                            </table>
                            <button id="saveproduct" name="saveproduct" class="btn btn-success btn-sm mb-2"><i class="fal fa-save fa-lg fa-fw"></i> Save Product</button>
                            <button id="backtolist" name="backtolist"  class='btn btn-primary btn-sm mb-2'><i class="fal fa-bars fa-lg fa-fw"></i> Back To List</button>
                        </div>
                    </div>
                </div>

                <!-- Product Discount Tab -->
                <div class="tab-pane fade" id="productdiscount" role="tabpanel" aria-labelledby="pop1-tab">
                    <div class="pt-3"></div>
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Discount Matrix</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="discountselectlist">Discount Category</label>
                                        <select id="discountselectlist" name="discountselectlist" class="form-control form-control-sm"></select>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="form-group">
                                        <label for="percentage">Percentage</label>
                                        <select id="percentage" class="form-control form-control-sm"> 
                                            <option value="0" selected>No</option>
                                            <option value="1">Yes</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="form-group">
                                        <label for="value">Value</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control form-control-sm" id="value">
                                            <div class="input-group-append">
                                                <button type="button" class="btn btn-success form-control form-control-sm" id="discountbutton"><i class="fal fa-save fa-lg fa-fw"></i> Save</button>
                                            </div>
                                        </div>
                                        
                                    </div>
                                </div>
                                <div class="col"></div>
                            </div>
                                
                            <table  id="customerdiscounts" name="customerdiscounts" class="table table-sm table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Category Id</th>
                                        <th>Category Name</th>
                                        <th>Percentage</th>
                                        <th>Value</th>
                                        <th>&nbsp;</th><!-- Edit -->
                                        <th>&nbsp;</th><!-- Delete -->
                                    </tr>
                                </thead>
                                <tbody id="customerdiscountdetails"></tbody> 
                            </table>
                        </div>
                    </div>
                </div>   

                <!-- Product Options Tab -->
                <div class="tab-pane fade" id="productoptions" role="tabpanel" aria-labelledby="pop1-tab">
                    <div class="pt-3"></div>
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Product Options</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col form-group">
                                    <label for="productoptionname">Option Name</label>
                                    <select name="productoptionname" id="productoptionname" class="form-control form-control-sm">
                                        <option value="0">&lt;New&gt;</option>
                                    </select>
                                </div>
                                <div class="col form-group">
                                    <label for="productoptionmultiselection">Multi-selectible</label>
                                    <select name="productoptionmultiselection" id="productoptionmultiselection" class="form-control form-control-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>
                                <div class="col form-group">
                                    <label for="productoptionvalue">Option Value</label>
                                    
                                    <div class="input-group">
                                        <input type="text" name="productoptionvalue" id="productoptionvalue" class="form-control form-control-sm">
                                        <div class="input-group-append">
                                            <button class="btn btn-sm btn-success" id="saveproductoptions"><i class="fal fa-save fa-lg fa-fw"></i> Save Options</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <table class="table table-sm table-striped table-hover">
                                <thead>
                                    <th>#</th>
                                    <th>Option Name</th>
                                    <th>Multi-select</th>
                                    <th>Option Value</th>
                                    <th>Date Added</th>
                                    <th>Added By</th>
                                    <th>&nbsp;</th><!-- Edit -->
                                    <th>&nbsp;</th><!-- Delete -->
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Product Recipe Tab -->
                <div class="tab-pane fade" id="productrecipe" role="tabpanel" aria-labelledby="pop1-tab">
                    <div class="pt-3"></div>
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Product Recipe Detais</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col form-group">
                                    <label for="recipeitemcode">Item Code</label>
                                    <input type="text" name="recipeitemcode" id="recipeitemcode" class="form-control form-control-sm">
                                </div>

                                <div class="col form-group">
                                    <label for="receipeitemname">Item Name</label>
                                    <input type="text" name="recipeitemname" id="recipeitemname" class="form-control form-control-sm" disabled>
                                </div>

                                <div class="col form-group">
                                    <label for="recipeitemunitprice">Unit Price</label>
                                    <input type="text" name="recipeitemunitprice" id="recipeitemunitprice" class="form-control form-control-sm" disabled>
                                </div>

                                <div class="col form-group">
                                    <label for="recipeitemmeasuringunit">Measure Unit</label>
                                    <input type="text" name="recipeitemmeasuringunit" id="recipeitemmeasuringunit" class="form-control form-control-sm" disabled>
                                </div>

                                <div class="col form-group">
                                    <label for="recipeitemquantity">Quantity</label>
                                    <div class="input-group">
                                        <input type="number" name="recipeitemquantity" id="recipeitemquantity" class="form-control form-control-sm">
                                        <div class="inpt-group-append">
                                            <button id="addrecipeitem" class="btn btn-sm btn-success"><i class="fal fa-save fa-lg fa-fw"></i> Save</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <table class="table table-sm table-striped table-hover">
                                <thead>
                                    <th>#</th>
                                    <th>Item Code</th>
                                    <th>Name</th>
                                    <th>UoM</th>
                                    <th>Quantity</th>
                                    <th>Unit Price</th>
                                    <th>Total</th>
                                    <th>&nbsp;</th><!-- Edit -->
                                    <th>&nbsp;</th><!-- Delete -->
                                </thead>
                                <tbody></tbody>
                                <tfoot></tfoot>
                            </table>
                        </div>
                    </div>
                    
                </div>

                <!-- Bulk split -->
                <div class="tab-pane fade" id="bulksplit" role="tabpanel" aria-labelledby="pop1-tab">
                    <div class="pt-3"></div>
                    <div class="card containergroup">
                        <div class="card-header">
                            <h5>Split Options</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col form-group">
                                    <label for="splitunitname">Unit Name</label>
                                    <input type="text" name="splitunitname" id="spliunitname" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group">
                                    <label for="splitunitsoftotal">Units of Total</label>
                                    <input type="number" name="splitunitsoftotal" id="splitunitsoftotal" class="form-control form-control-sm">
                                </div>

                                <div class="col form-group">
                                    <label for="splitunitprice">Unit Price</label>
                                    <div class="input-group">
                                        <input type="number" name="splitunitprice" id="splitunitprice" class="form-control form-control-sm">
                                        <div class="input-group-append">
                                            <button class="btn btn-sm btn-success" id="savebulkbreak"><i class="fal fa-save fa-lg fa-fw"></i> Save Split unit</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div> 
                        <table class="table table-striped table-sm table-hover">
                            <thead>
                                <th>#</th>
                                <th>Unit Name</th>
                                <th>Units of Total</th>
                                <th>Unit Price</th>
                                <th>Date Added</th>
                                <th>Added By</th>
                                <th>&nbsp;</th><!-- Edit  -->
                                <th>&nbsp;</th><!-- Delete  -->
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>

                <!-- Product History Tab -->
                <div class="tab-pane fade" id="producthistory" role="tabpanel" aria-labelledby="pop1-tab">
                    <div class="pt-3"></div>
                    <nav class="nav-justified ">
                        <div class="nav nav-tabs " id="nav-tab" role="tablist">
                            <a class="nav-item nav-link active" id="movementsummary-tab" data-toggle="tab" href="#movementsummary" role="tab" aria-controls="pop2" aria-selected="false">Movement Summary</a>
                            <a class="nav-item nav-link " id="pricinghistory-tab" data-toggle="tab" href="#pricinghistory" role="tab" aria-controls="pop1" aria-selected="true">Pricing</a>
                            <a class="nav-item nav-link" id="purchases-tab" data-toggle="tab" href="#purchasehistory" role="tab" aria-controls="pop2" aria-selected="false">Purchases</a>
                            <a class="nav-item nav-link" id="saleshistory-tab" data-toggle="tab" href="#saleshistory" role="tab" aria-controls="pop2" aria-selected="false">Sales</a>
                            <a class="nav-item nav-link" id="transfershistory-tab" data-toggle="tab" href="#transfershistory" role="tab" aria-controls="pop2" aria-selected="false">Transfers</a>
                            <a class="nav-item nav-link" id="spoilagehistory-tab" data-toggle="tab" href="#spoilagehistory" role="tab" aria-controls="pop2" aria-selected="false">Spoilage</a>
                        </div>
                    </nav>

                    <div class="tab-content text-left" id="nav-tabContent">
                        <!-- Movement Summary Tab -->
                        <div class="tab-pane fade show active" id="movementsummary" role="tabpanel" aria-labelledby="pop1-tab">
                            <div class="pt-3"></div>
                            <div class="card containergroup">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col"></div>
                                        <div class="col form-group">
                                            <label for="filterproductmovementdaterange">Date Range</label>
                                            <select name="fiterproductdaterange" id="fiterproductdaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterproductmovementstartdate">Start Date</label>
                                            <input type="text" name="fiterproductmovementenddate" id="fiterproductmovementenddate" class="form-control form-control-sm">
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterproductmovementenddate">End Date</label>
                                            <div class="input-group">
                                                <input type="text" name="filterproductmovementenddate" id="filterproductmovementenddate" class="form-control form-control-sm">
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-sm btn-success" id="filterproductmovement"><i class="fal fa-search fa-lg fa-fw"></i> Filter</button>
                                                </div>
                                            </div>  
                                        </div> 
                                        <div class="col"></div>
                                    </div>
                                    <table class="table table-sm table-striped table-hover">
                                        <thead>
                                            <th>#</th>
                                            <th>Date</th>
                                            <th>Narration</th>
                                            <th>Reference</th>
                                            <th>Stockin</th>
                                            <th>Stockout</th>
                                            <th>Balance</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                         <!-- Pricing History Tab -->
                         <div class="tab-pane fade " id="pricinghistory" role="tabpanel" aria-labelledby="pop1-tab">
                            <div class="pt-3"></div>
                            <div class="card containergroup">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col">
                                            <div class="form-group">
                                                <label for="filterproductpricingtype">Price Category</label>
                                                <select name="filterproductpricingtype" id="filterproductpricingtype" class="form-control form-control-sm">
                                                    <option value="0">&lt;All&gt;</option>
                                                    <option value="purchase">Purchase</option>
                                                    <option value="selling">Selling</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterpricinghistotydaterange">Date Range</label>
                                            <select name="fiterproductdaterange" id="fiterproductdaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterpricinghistotystartdate">Start Date</label>
                                            <input type="text" name="fiterpricinghistotyenddate" id="fiterpricinghistotyenddate" class="form-control form-control-sm">
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterpricinghistotyenddate">End Date</label>
                                            <div class="input-group">
                                                <input type="text" name="filterpricinghistotyenddate" id="filterpricinghistotyenddate" class="form-control form-control-sm">
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-sm btn-success" id="filterpricinghistoty"><i class="fal fa-search fa-lg fa-fw"></i> Filter</button>
                                                </div>
                                            </div>  
                                        </div> 
                                        <div class="col"></div>
                                    </div>
                                    <table class="table table-sm table-striped table-hover">
                                        <thead>
                                            <th>#</th>
                                            <th>Date</th>
                                            <th>Buying</th>
                                            <th>Selling</th>
                                            <th>Margin</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                         <!-- Pricing History Tab -->
                         <div class="tab-pane fade " id="purchasehistory" role="tabpanel" aria-labelledby="pop1-tab">
                            <div class="pt-3"></div>
                            <div class="card containergroup">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col"></div>
                                        <div class="col form-group">
                                            <label for="filterpurchasehistorydaterange">Date Range</label>
                                            <select name="fiterproductdaterange" id="fiterproductdaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterpurchasehistorystartdate">Start Date</label>
                                            <input type="text" name="fiterpurchasehistoryenddate" id="fiterpurchasehistoryenddate" class="form-control form-control-sm">
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterpurchasehistoryenddate">End Date</label>
                                            <div class="input-group">
                                                <input type="text" name="filterpurchasehistoryenddate" id="filterpurchasehistoryenddate" class="form-control form-control-sm">
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-sm btn-success" id="filterpurchasehistory"><i class="fal fa-search fa-lg fa-fw"></i> Filter</button>
                                                </div>
                                            </div>  
                                        </div> 
                                        <div class="col"></div>
                                    </div>
                                    <table class="table table-sm table-striped table-hover">
                                        <thead>
                                            <th>#</th>
                                            <th>Date</th>
                                            <th>Supplier</th>
                                            <th>PO #</th>
                                            <th>invoice #</th>
                                            <th>Delivery Date</th>
                                            <th>Quantity</th>
                                            <th>Unit Price</th>
                                            <th>Total</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                         <!-- Sales History Tab -->
                         <div class="tab-pane fade " id="saleshistory" role="tabpanel" aria-labelledby="pop1-tab">
                            <div class="pt-3"></div>
                            <div class="card containergroup">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col"></div>
                                        <div class="col form-group">
                                            <label for="filtersaleshistorydaterange">Date Range</label>
                                            <select name="fiterproductdaterange" id="fiterproductdaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filtersaleshistorystartdate">Start Date</label>
                                            <input type="text" name="fitersaleshistoryenddate" id="fitersaleshistoryenddate" class="form-control form-control-sm">
                                        </div>
                                        <div class="col form-group">
                                            <label for="filtersaleshistoryenddate">End Date</label>
                                            <div class="input-group">
                                                <input type="text" name="filtersaleshistoryenddate" id="filtersaleshistoryenddate" class="form-control form-control-sm">
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-sm btn-success" id="filtersaleshistory"><i class="fal fa-search fa-lg fa-fw"></i> Filter</button>
                                                </div>
                                            </div>  
                                        </div> 
                                        <div class="col"></div>
                                    </div>
                                    <table class="table table-sm table-striped table-hover">
                                        <thead>
                                            <th>#</th>
                                            <th>Date</th>
                                            <th>Customer</th>
                                            <th>Receipt #</th>
                                            <th>Quantity</th>
                                            <th>Unit Price</th>
                                            <th>Total</th>
                                            <th>Transacted By</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                         <!-- Transfers History Tab -->
                         <div class="tab-pane fade " id="transfershistory" role="tabpanel" aria-labelledby="pop1-tab">
                            <div class="pt-3"></div>
                            <div class="card containergroup">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col">
                                            <div class="form-group">
                                                <label for="filtertransferhistorysource">Source</label>
                                                <select name="filtertransferhistorysource" id="filtertransferhistorysource" class="form-control form-control-sm">
                                                    <option value="0">&lt;All&gt;</option>
                                                    <option value="warehouse">Warehouse</option>
                                                    <option value="outlet">Outlet</option>
                                                </select>
                                            </div>
                                        </div>  

                                        <div class="col form-group">
                                            <label for="filtertransactionhistorysourcename">Source Name</label>
                                            <select name="filtertransactionhistorysourcename" id="filtertransactionhistorysourcename" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                            </select>
                                        </div>

                                        <div class="col">
                                            <div class="form-group">
                                                <label for="filtertransferhistorydestination">Destination</label>
                                                <select name="filtertransferhistorydestination" id="filtertransferhistorydestination" class="form-control form-control-sm">
                                                    <option value="0">&lt;All&gt;</option>
                                                    <option value="warehouse">Warehouse</option>
                                                    <option value="outlet">Outlet</option>
                                                </select>
                                            </div>
                                        </div>  

                                        <div class="col form-group">
                                            <label for="filtertransactionhistorydestinationname">destination Name</label>
                                            <select name="filtertransactionhistorydestinationname" id="filtertransactionhistorydestinationname" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                            </select>
                                        </div>
                                        
                                        <div class="col form-group">
                                            <label for="filtertransferhistorydaterange">Date Range</label>
                                            <select name="fiterproductdaterange" id="filtertransferhistorydaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filtertransferhistorystartdate">Start Date</label>
                                            <input type="text" name="fitertransferhistoryenddate" id="fitertransferhistoryenddate" class="form-control form-control-sm">
                                        </div>
                                        <div class="col form-group">
                                            <label for="filtertransferhistoryenddate">End Date</label>
                                            <div class="input-group">
                                                <input type="text" name="filtertransferhistoryenddate" id="filtertransferhistoryenddate" class="form-control form-control-sm">
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-sm btn-success" id="filtertransferhistory"><i class="fal fa-search fa-lg fa-fw"></i></button>
                                                </div>
                                            </div>  
                                        </div> 
                                    </div>
                                    <table class="table table-sm table-striped table-hover">
                                        <thead>
                                            <th>#</th>
                                            <th>Date</th>
                                            <th>Narration</th>
                                            <th>Reference</th>
                                            <th>Stockin</th>
                                            <th>Stockout</th>
                                            <th>Balance</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                         <!-- Spoilage History Tab -->
                         <div class="tab-pane fade " id="spoilagehistory" role="tabpanel" aria-labelledby="pop1-tab">
                            <div class="pt-3"></div>
                            <div class="card containergroup">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col">
                                            <div class="form-group">
                                                <label for="filterspoilagehistorytype">Spoilage Type</label>
                                                <select name="filterspoilagehistorytype" id="filterspoilagehistorytype" class="form-control form-control-sm">
                                                    <option value="0">&lt;All&gt;</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterspoilagehistorydaterange">Date Range</label>
                                            <select name="fiterproductdaterange" id="fiterproductdaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterspoilagehistorystartdate">Start Date</label>
                                            <input type="text" name="fiterspoilagehistoryenddate" id="fiterspoilagehistoryenddate" class="form-control form-control-sm">
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterspoilagehistoryenddate">End Date</label>
                                            <div class="input-group">
                                                <input type="text" name="filterspoilagehistoryenddate" id="filterspoilagehistoryenddate" class="form-control form-control-sm">
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-sm btn-success" id="filterspoilagehistory"><i class="fal fa-search fa-lg fa-fw"></i> Filter</button>
                                                </div>
                                            </div>  
                                        </div> 
                                        <div class="col"></div>
                                    </div>
                                    <table class="table table-sm table-striped table-hover">
                                        <thead>
                                            <th>#</th>
                                            <th>Date</th>
                                            <th>Type</th>
                                            <th>Quantity</th>
                                            <th>Unit Price</th>
                                            <th>Total</th>
                                            <th>Added By</th>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
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
<script type="text/javascript" src="../js/productdetails.js"></script>
</html>