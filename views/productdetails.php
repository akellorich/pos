<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Products </title>
    <style>
        /* Responsive card group styling for consistency */
        .containergroup.card {
            border: none;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            min-height: calc(100vh - 150px);
        }
        .card-header {
            background: #f8f9fa;
            border-bottom: 1px solid #eef2f6;
            padding: 15px 20px;
        }
        .card-header h5 {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
        }
        /* Scrollable Tab Container styling */
        .tabs-scroll-container .nav-tabs {
            scrollbar-width: none; /* Firefox */
            border-bottom: 2px solid #dee2e6 !important;
            padding-bottom: 2px !important;
        }
        .tabs-scroll-container .nav-tabs::-webkit-scrollbar {
            display: none; /* Safari and Chrome */
        }
        .tabs-scroll-container .nav-item.nav-link {
            border: none !important;
            border-bottom: 3px solid transparent !important;
            border-radius: 0 !important;
            margin-right: 2px;
            font-size: 0.82rem;
            font-weight: 500;
            color: #495057;
            padding: 10px 16px;
            transition: all 0.2s ease;
        }
        .tabs-scroll-container .nav-item.nav-link.active {
            background-color: transparent !important;
            border-bottom: 3px solid #dd0000 !important;
            font-weight: bold !important;
            color: #dd0000 !important;
        }
        .tab-scroll-btn {
            border: none !important;
            transition: all 0.2s ease;
            box-shadow: none !important;
            background: rgba(255,255,255,0.9) !important;
            color: #888 !important;
            width: 24px !important;
        }
        .tab-scroll-btn i {
            font-size: 0.7rem !important;
        }
        .tab-scroll-btn:hover {
            background-color: #f1f3f5 !important;
            color: #dd0000 !important;
        }
        @media (max-width: 768px) {
            .card-header h5 {
                font-size: 0.95rem !important;
            }
            .container-fluid {
                padding-left: 0 !important;
                padding-right: 0 !important;
            }
            .containergroup.card {
                border-radius: 0 !important;
                margin-left: 0 !important;
                margin-right: 0 !important;
                border: none !important;
                box-shadow: none !important;
                min-height: auto !important;
            }
            .card-body {
                padding-left: 10px !important;
                padding-right: 10px !important;
            }
            /* Stack columns on mobile */
            .row > .col,
            .row > .col-md-3,
            .row > .col-md-9,
            .row > .form-group {
                flex: 0 0 100% !important;
                max-width: 100% !important;
                width: 100% !important;
                margin-bottom: 12px;
            }
            /* Display two items per row where there are toggles */
            .row > .col.toggle-column,
            .row > .col-md-3.toggle-column,
            .row > .col-md-9.toggle-column,
            .row > .form-group.toggle-column {
                flex: 0 0 50% !important;
                max-width: 50% !important;
                width: 50% !important;
                margin-bottom: 12px;
            }
            /* Display Bundle items in 3-column row on mobile */
            .row > .col.bundle-row-col,
            .row > .col-md-3.bundle-row-col,
            .row > .col-md-9.bundle-row-col,
            .row > .form-group.bundle-row-col {
                flex: 0 0 33.333333% !important;
                max-width: 33.333333% !important;
                width: 33.333333% !important;
                margin-bottom: 12px;
            }
            /* Display dimensions L, W, H side-by-side on mobile */
            .row > .col.dimension-field,
            .row > .col-md-3.dimension-field,
            .row > .col-md-9.dimension-field,
            .row > .form-group.dimension-field {
                flex: 0 0 33.333333% !important;
                max-width: 33.333333% !important;
                width: 33.333333% !important;
                margin-bottom: 12px;
            }
        }

        /* Custom Switch Toggle styling */
        .switch-wrapper {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            padding-top: 5px;
        }
        .custom-switch-toggle {
            position: relative;
            display: inline-block;
            width: 38px;
            height: 20px;
        }
        .custom-switch-toggle input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .custom-switch-toggle .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ced4da;
            transition: .3s ease;
            border-radius: 20px;
        }
        .custom-switch-toggle .slider:before {
            position: absolute;
            content: "";
            height: 14px;
            width: 14px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .3s ease;
            border-radius: 50%;
            box-shadow: 0 1px 3px rgba(0,0,0,0.15);
        }
        .custom-switch-toggle input:checked + .slider {
            background-color: #28a745 !important; /* Premium green */
        }
        .custom-switch-toggle input:checked + .slider:before {
            transform: translateX(18px);
        }
        /* Style adjustments when disabled */
        .custom-switch-toggle input:disabled + .slider {
            background-color: #e9ecef !important;
            cursor: not-allowed;
        }
        .custom-switch-toggle input:disabled + .slider:before {
            background-color: #adb5bd;
        }
    </style>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <?php $pagename = "Products"; require_once("topbar.php"); ?>
        <div class="container-fluid">
            <!-- <p class="lead text-center mt-3">Enter Product Details</p> -->
            <!-- Tabbed Menu with Left/Right Scroll Chevrons -->
            <div class="tabs-scroll-container position-relative mb-3">
                <button type="button" class="tab-scroll-btn tab-scroll-left btn btn-light btn-sm position-absolute d-flex align-items-center justify-content-center" style="left: 0; top: 0; bottom: 0; width: 24px; z-index: 10; border-radius: 4px 0 0 4px; border: 1px solid #dee2e6; border-right: none; background: #f8f9fa;">
                    <i class="fal fa-chevron-left"></i>
                </button>
                <div class="nav nav-tabs flex-nowrap" id="nav-tab" role="tablist" style="overflow-x: auto; scroll-behavior: smooth; -webkit-overflow-scrolling: touch; padding-left: 26px; padding-right: 26px; border-bottom: 1px solid #dee2e6; white-space: nowrap;">
                    <a class="nav-item nav-link active" id="productdetails-tab" data-toggle="tab" href="#productdetails" role="tab" aria-controls="pop1" aria-selected="true" style="display: inline-block; float: none;">Details</a>
                    <a class="nav-item nav-link" id="productoptions-tab" data-toggle="tab" href="#productoptions" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">Options</a>
                    <a class="nav-item nav-link" id="productrecipe-tab" data-toggle="tab" href="#productrecipe" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">Recipe</a>
                    <a class="nav-item nav-link" id="bulksplit-tab" data-toggle="tab" href="#bulksplit" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">Bulk Split</a>
                    <a class="nav-item nav-link" id="productdiscount-tab" data-toggle="tab" href="#productdiscount" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">Discounts</a>
                    <a class="nav-item nav-link" id="producthistory-tab" data-toggle="tab" href="#producthistory" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">History</a>
                </div>
                <button type="button" class="tab-scroll-btn tab-scroll-right btn btn-light btn-sm position-absolute d-flex align-items-center justify-content-center" style="right: 0; top: 0; bottom: 0; width: 24px; z-index: 10; border-radius: 0 4px 4px 0; border: 1px solid #dee2e6; border-left: none; background: #f8f9fa;">
                    <i class="fal fa-chevron-right"></i>
                </button>
            </div>

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
                                    <label for="" class="d-none d-md-block">&nbsp;</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text">
                                                <input type="checkbox" id="usedimensions">
                                            </div>
                                        </div>
                                        <input type="text" class="form-control form-control-sm" value="Use dimensions">
                                    </div>
                                </div>
                                <div class="col form-group dimension-field">
                                    <label for="length">Length</label>
                                    <input type="number" name="length" id="length" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group dimension-field">
                                    <label for="width">Width</label>
                                    <input type="number" name="width" id="width" class="form-control form-control-sm">
                                </div>
                                <div class="col form-group dimension-field">
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
                                    <label for="itemtype">Item Type</label>
                                    <select name="itemtype" id="itemtype" class="form-control form-control-sm">
                                        <option value="product">Product</option>
                                        <option value="service">Service</option>
                                    </select>
                                </div>

                            </div>

                             <div class="row">
                                 <div class="col bundle-row-col">
                                    <div class="form-group">
                                        <label for="bundleitem">Bundle Item</label>
                                        <select name="bundleitem" id="bundleitem" class="form-control form-control-sm">
                                                <option value="0">No</option>
                                                <option value="1">Yes</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col bundle-row-col">
                                    <div class="form-group">
                                        <label for="bundleproduct">Bundle Product</label>
                                        <select name="bundleproduct" id="bundleproduct" class="form-control form-control-sm"></select>
                                    </div>
                                </div>

                                <div class="col form-group bundle-row-col">
                                    <label for="allowreturnexchange">Allow Exchange (Returns)</label>
                                    <select name="allowreturnexchange" id="allowreturnexchange" class="form-control form-control-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>

                                <div class="col d-none d-md-block"></div>

                            </div>

                            <div class="row">
                                <div class="col form-group">
                                    <label for="rawmaterial">Is Raw Material</label>
                                    <select name="rawmaterial" id="rawmaterial" class="form-control form-control-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>

                                <div class="col form-group">
                                    <label for="allownegativesales">Allow Negative Sales</label>
                                    <select name="allownegativesales" id="allownegativesales" class="form-control form-ocntrol-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>

                                <div class="col form-group">
                                    <label for="disallowpurchasing">Disallow Purchasing</label>
                                    <select name="disallowpurchasing" id="disallowpurchasing" class="form-control form-control-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>

                                <div class="col form-group">
                                    <label for="disallowreceipt">Disallow Receipt</label>
                                    <select name="disallowreceipt" id="disallowreceipt" class="form-control form-control-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col form-group">
                                    <label for="disallowsale">Disallow Sale</label>
                                    <select name="disallowsale" id="disallowsale" class="form-control form-control-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>

                                <div class="col form-group">
                                    <label for="supportsadditionalbarcodes">Supports Additional Barcodes</label>
                                    <select name="supportsadditionalbarcodes" id="supportsadditionalbarcodes" class="form-control form-control-sm">
                                        <option value="0">No</option>
                                        <option value="1">Yes</option>
                                    </select>
                                </div>

                                <div class="col form-group barcode-variant-field barcode-variant-col">
                                    <label for="variantbarcode">Variant Barcode</label>
                                    <input type="text" name="variantbarcode" id="variantbarcode" class="form-control form-control-sm">
                                </div>

                                <div class="col form-group barcode-variant-field barcode-variant-col">
                                    <label for="variantitemname">Variant Item Name</label>
                                    <input type="text" name="variantitemname" id="variantitemname" class="form-control form-control-sm">
                                </div>
                            </div>
                            <table class="table table-sm table-striped table-hover mb-3 barcode-variant-field">
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
                            <div id="recipenotifications"></div>
                            <div class="row">
                                <div class="col form-group position-relative">
                                    <label for="recipeitemcode">Item Code</label>
                                    <input type="text" name="recipeitemcode" id="recipeitemcode" class="form-control form-control-sm" autocomplete="off">
                                    <div id="searchrecipeproducts" style="display: none; position: absolute; left: 15px; right: 15px; background: white; border: 1px solid #ced4da; border-radius: 4px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); z-index: 99999; max-height: 200px; overflow-y: auto;"></div>
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
                                        <div class="input-group-append">
                                            <button id="addrecipeitem" class="btn btn-sm btn-success"><i class="fal fa-save fa-lg fa-fw"></i> Save</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <table id="productrecipetable" class="table table-sm table-striped table-hover">
                                <thead>
                                    <th>#</th>
                                    <th>Item Code</th>
                                    <th>Name</th>
                                    <th>UoM</th>
                                    <th>Quantity</th>
                                    <th>Unit Price</th>
                                    <th>Total</th>
                                    <th class="text-center">Actions</th>
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
                            <div id="bulksplitnotifications"></div>
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
                            <div class="pt-3"></div>
                            <table id="productsplitunitstable" class="table table-striped table-sm table-hover">
                                <thead>
                                    <th>#</th>
                                    <th>Unit Name</th>
                                    <th>Units of Total</th>
                                    <th>Unit Price</th>
                                    <th>Date Added</th>
                                    <th>Added By</th>
                                    <th class="text-center">Actions</th>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Product History Tab -->
                <div class="tab-pane fade" id="producthistory" role="tabpanel" aria-labelledby="pop1-tab">
                    <div class="pt-3"></div>
                    <!-- Sub-Tabbed Menu with Left/Right Scroll Chevrons -->
                    <div class="tabs-scroll-container position-relative mb-3">
                        <button type="button" class="tab-scroll-btn subtab-scroll-left btn btn-light btn-sm position-absolute d-flex align-items-center justify-content-center" style="left: 0; top: 0; bottom: 0; width: 24px; z-index: 10; border-radius: 4px 0 0 4px; border: 1px solid #dee2e6; border-right: none; background: #f8f9fa;">
                            <i class="fal fa-chevron-left"></i>
                        </button>
                        <div class="nav nav-tabs flex-nowrap" id="subnav-tab" role="tablist" style="overflow-x: auto; scroll-behavior: smooth; -webkit-overflow-scrolling: touch; padding-left: 26px; padding-right: 26px; border-bottom: 1px solid #dee2e6; white-space: nowrap;">
                            <a class="nav-item nav-link active" id="movementsummary-tab" data-toggle="tab" href="#movementsummary" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">Movement Summary</a>
                            <a class="nav-item nav-link " id="pricinghistory-tab" data-toggle="tab" href="#pricinghistory" role="tab" aria-controls="pop1" aria-selected="true" style="display: inline-block; float: none;">Pricing</a>
                            <a class="nav-item nav-link" id="purchases-tab" data-toggle="tab" href="#purchasehistory" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">Purchases</a>
                            <a class="nav-item nav-link" id="saleshistory-tab" data-toggle="tab" href="#saleshistory" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">Sales</a>
                            <a class="nav-item nav-link" id="transfershistory-tab" data-toggle="tab" href="#transfershistory" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">Transfers</a>
                            <a class="nav-item nav-link" id="spoilagehistory-tab" data-toggle="tab" href="#spoilagehistory" role="tab" aria-controls="pop2" aria-selected="false" style="display: inline-block; float: none;">Spoilage</a>
                        </div>
                        <button type="button" class="tab-scroll-btn subtab-scroll-right btn btn-light btn-sm position-absolute d-flex align-items-center justify-content-center" style="right: 0; top: 0; bottom: 0; width: 24px; z-index: 10; border-radius: 0 4px 4px 0; border: 1px solid #dee2e6; border-left: none; background: #f8f9fa;">
                            <i class="fal fa-chevron-right"></i>
                        </button>
                    </div>

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
                                            <select name="filterproductmovementdaterange" id="filterproductmovementdaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterproductmovementstartdate">Start Date</label>
                                            <input type="text" name="filterproductmovementstartdate" id="filterproductmovementstartdate" class="form-control form-control-sm">
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
                                    <div class="table-responsive">
                                        <table id="productmovementtable" class="table table-sm table-striped table-hover">
                                            <thead>
                                                <th>#</th>
                                                <th>Date</th>
                                                <th>Narration</th>
                                                <th>Reference</th>
                                                <th class="text-right">Stockin</th>
                                                <th class="text-right">Stockout</th>
                                                <th class="text-right">Balance</th>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
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
                                            <label for="filterpricinghistorydaterange">Date Range</label>
                                            <select name="filterpricinghistorydaterange" id="filterpricinghistorydaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterpricinghistorystartdate">Start Date</label>
                                            <input type="text" name="filterpricinghistorystartdate" id="filterpricinghistorystartdate" class="form-control form-control-sm">
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterpricinghistoryenddate">End Date</label>
                                            <div class="input-group">
                                                <input type="text" name="filterpricinghistoryenddate" id="filterpricinghistoryenddate" class="form-control form-control-sm">
                                                <div class="input-group-append">
                                                    <button type="button" class="btn btn-sm btn-success" id="filterpricinghistory"><i class="fal fa-search fa-lg fa-fw"></i> Filter</button>
                                                </div>
                                            </div>  
                                        </div> 
                                        <div class="col"></div>
                                    </div>
                                    <div class="table-responsive">
                                        <table id="productpricingtable" class="table table-sm table-striped table-hover">
                                            <thead>
                                                <th>#</th>
                                                <th>Date</th>
                                                <th class="text-right">Buying</th>
                                                <th class="text-right">Selling</th>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
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
                                            <select name="filterpurchasehistorydaterange" id="filterpurchasehistorydaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterpurchasehistorystartdate">Start Date</label>
                                            <input type="text" name="filterpurchasehistorystartdate" id="filterpurchasehistorystartdate" class="form-control form-control-sm">
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
                                    <div class="table-responsive">
                                        <table id="productpurchasetable" class="table table-sm table-striped table-hover">
                                            <thead>
                                                <th>#</th>
                                                <th>Date</th>
                                                <th>Supplier</th>
                                                <th>PO #</th>
                                                <th>invoice #</th>
                                                <th>Delivery Date</th>
                                                <th class="text-right">Quantity</th>
                                                <th class="text-right">Unit Price</th>
                                                <th class="text-right">Total</th>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
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
                                            <select name="filtersaleshistorydaterange" id="filtersaleshistorydaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filtersaleshistorystartdate">Start Date</label>
                                            <input type="text" name="filtersaleshistorystartdate" id="filtersaleshistorystartdate" class="form-control form-control-sm">
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
                                    <div class="table-responsive">
                                        <table id="productsalestable" class="table table-sm table-striped table-hover">
                                            <thead>
                                                <th>#</th>
                                                <th>Date</th>
                                                <th>Customer</th>
                                                <th>Receipt #</th>
                                                <th class="text-right">Quantity</th>
                                                <th class="text-right">Unit Price</th>
                                                <th class="text-right">Total</th>
                                                <th>Transacted By</th>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
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
                                            <select name="filtertransferhistorydaterange" id="filtertransferhistorydaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filtertransferhistorystartdate">Start Date</label>
                                            <input type="text" name="filtertransferhistorystartdate" id="filtertransferhistorystartdate" class="form-control form-control-sm">
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
                                    <div class="table-responsive">
                                        <table id="producttransferstable" class="table table-sm table-striped table-hover">
                                            <thead>
                                                <th>#</th>
                                                <th>Date</th>
                                                <th>Narration</th>
                                                <th>Reference</th>
                                                <th class="text-right">Stockin</th>
                                                <th class="text-right">Stockout</th>
                                                <th class="text-right">Balance</th>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
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
                                            <select name="filterspoilagehistorydaterange" id="filterspoilagehistorydaterange" class="form-control form-control-sm">
                                                <option value="0">&lt;All&gt;</option>
                                                <option value="week">This Week</option>
                                                <option value="month">This Month</option>
                                                <option value="year">Year</option>
                                                <option value="specify">Specify</option>
                                            </select>
                                        </div>
                                        <div class="col form-group">
                                            <label for="filterspoilagehistorystartdate">Start Date</label>
                                            <input type="text" name="filterspoilagehistorystartdate" id="filterspoilagehistorystartdate" class="form-control form-control-sm">
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
                                    <div class="table-responsive">
                                        <table id="productspoilagetable" class="table table-sm table-striped table-hover">
                                            <thead>
                                                <th>#</th>
                                                <th>Date</th>
                                                <th>Type</th>
                                                <th class="text-right">Quantity</th>
                                                <th class="text-right">Unit Price</th>
                                                <th class="text-right">Total</th>
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
    </div>
    
  </section>
   
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/productdetails.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    // Main Tab Scroll
    $('.tab-scroll-left').click(function() {
        var container = $('#nav-tab');
        container.animate({ scrollLeft: container.scrollLeft() - 150 }, 200);
    });
    $('.tab-scroll-right').click(function() {
        var container = $('#nav-tab');
        container.animate({ scrollLeft: container.scrollLeft() + 150 }, 200);
    });

    // Sub Tab Scroll
    $('.subtab-scroll-left').click(function() {
        var container = $('#subnav-tab');
        container.animate({ scrollLeft: container.scrollLeft() - 150 }, 200);
    });
    $('.subtab-scroll-right').click(function() {
        var container = $('#subnav-tab');
        container.animate({ scrollLeft: container.scrollLeft() + 150 }, 200);
    });

    // Auto-scroll to show active tab on page load
    setTimeout(function() {
        var activeTab = $('#nav-tab .active');
        if (activeTab.length) {
            var container = $('#nav-tab');
            var scrollPos = activeTab.position().left + container.scrollLeft() - (container.width() / 2) + (activeTab.width() / 2);
            container.scrollLeft(scrollPos);
        }
    }, 100);
});
</script>
</html>