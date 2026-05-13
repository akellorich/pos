<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Suppliers </title>
   </head>
<body>
  <?php require_once("sidebar.html") ?>

  <section class="home-section">
    <?php $pagename = "Suppliers"; require_once("topbar.php"); ?>
        <div class="container-fluid">     
            <div class="row mt-2">
                <div class="col col-md-3">
                <div class="row filters">
                    <div class="col">
                        <a href="#" id="addsupplier" class="btn btn-success btn-sm w-100 text-left"><i class="fas fa-user-plus fa-lg"></i>  Add Supplier</a>
                        <a href="#" id="filtersupplier" class="btn btn-secondary btn-sm w-100 mt-1 text-left" data-toggle="modal" data-target="#filtersuppliers"><i class="fas fa-search-plus fa-lg"></i>  Filter Suppliers</a>
                        <!-- <a href="#" id="cancelfilter" class="btn btn-danger btn-sm w-100 mt-1 text-left"><i class="fas fa-search-minus fa-lg"></i>  Cancel Filters</a> -->
                        <a href="#" id="deletesupplier" class="btn btn-danger btn-sm w-100 mt-1 text-left"><i class="fas fa-user-times fa-lg"></i>  Delete Supplier</a>
                    </div>
                </div>
                <div class="row filterresults">
                    <div class="col">
                        <select name="supplierslist" id="supplierslist" multiple class="form-control form-control-sm list-big mt-2"></select>
                    </div>
                </div>
                </div>

                <div class="col" id="receiptlist">
                    <div class="containergroup card">
                        <div class="card-body">
                            <ul class="nav nav-tabs mt-1" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" data-toggle="tab" href="#info" role="tab">Supplier Info</a>
                                </li>

                                <li class="nav-item">
                                    <a class="nav-link" data-toggle="tab" href="#products" role="tab">Products</a>
                                </li>

                                <li class="nav-item">
                                    <a class="nav-link" data-toggle="tab" href="#transactions" role="tab">Statement</a>
                                </li>

                                <!-- <li class="nav-item">
                                    <a class="nav-link" data-toggle="tab" href="#invoices" role="tab">Invoices</a>
                                </li>-->

                                
                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content">
                                <div class="tab-pane active" id="info" role="tabpanel">
                                    <input type="hidden" id="id" name="id" value="0">
                                    <!-- <p class="lead text-center mb-2 mt-2">Please Provide Supplier Details</p> -->
                                    <div id="errors" class="mt-2 mb-2" ></div>
                                    <div class="row">
                                        <div class="col">
                                            <div class="form-group">
                                                <label for="suppliernames">Supplier Name:</label>
                                                <input type="text" autocomplete="off" id="suppliername" name="suppliername"  class="form-control form-control-sm">
                                            </div>
                                        </div>

                                        <div class="col">
                                            <div class="form-group">
                                                <label for="physicaladdress">Physical Address:</label>
                                                <input type="text" autocomplete="off" id="physicaladdress" name="physicaladdress"  class="form-control form-control-sm">
                                            </div>
                                        </div>

                                        <div class="col">
                                            <div class="form-group">
                                                <label for="postaladdress">Postal Address:</label>
                                                <input type="text" autocomplete="off"  id="postaladdress" name="postaladdress"  class="form-control form-control-sm">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col">
                                            <div class="form-group">
                                                <label for="email">Email:</label>
                                                <input type="text" autocomplete="off"  id="email" name="email"  class="form-control form-control-sm">
                                            </div>
                                        </div>

                                        <div class="col">
                                            <div class="form-group">
                                                <label for="mobile">Mobile:</label>
                                                <input type="text"  autocomplete="off"  id="mobile" name="mobile"  class="form-control form-control-sm">
                                            </div>
                                        </div>

                                        <div class="col">
                                            <div class="form-group">
                                                <label for="creditlimit">Credit Limit:</label>
                                                <input type="text"  autocomplete="off"  id="creditlimit" name="creditlimit"  class="form-control form-control-sm">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col form-group">
                                            <label for="supplierpin">KRA PIN Number</label>
                                            <input type="text" name="supplierpin" id="supplierpin" class="form-control form-control-sm">
                                        </div>
                                        <div class="col"></div>
                                        <div class="col"></div>
                                    </div>
                                    <button class="btn btn-sm btn-success" id="savesupplier" name="savesupplier"><i class="fal fa-save fa-lg fa-fw"></i> Save supplier</button>
                                    <!-- <input type="button"  Value="Save supplier" class="btn btn-sm btn-success"> -->
                                    <!--<input type="button" id="goback" name="goback" Value="Back to list" class="btn btn-sm btn-secondary"> -->                                                                                                
                                </div>
                                
                                <div class="tab-pane" id="products" role="tabpanel">
                                    <div id="errorproductlist" class="mt-2 mb-2"></div>
                                    <table class="table table-striped table-sm mt-3" id="supplierproducts">
                                        <thead class="thead-light">
                                            <th>#</th>
                                            <th>Product Code</th>
                                            <th>Product Name</th>
                                            <th>Date Added</th>
                                            <th>Added By</th>
                                            <th>&nbsp;</th>
                                        </thead>
                                        <tbody id="productslist"></tbody>
                                        <tfoot></tfoot>
                                    </table>
                                    <button id="addproduct" name="addproduct"  class="btn btn-sm btn-success mt-3" data-toggle='modal' data-target='#productdetails'> Add Product(s)</button>
                                </div>

                                <!-- <div class="tab-pane" id="invoices" role="tabpanel">
                                    <div class="row mt-2">
                                        <div class="col">
                                            <div class="row">
                                                <div class="col col-md-2">
                                                    <div class="form-group">
                                                    <label for="alldates">&nbsp;</label>
                                                        <div class="form-check">
                                                            <label class="form-check-label">
                                                                <input type="checkbox" class="form-check-input d-block" name="alldates" id="alldates" >All Dates
                                                            </label>
                                                        </div>
                                                    </div>
                                                    
                                                </div>
                                                <div class="col">
                                                    <div class="form-group">
                                                        <label for="startdate">Start Date</label>
                                                        <input type="text"  autocomplete="off"  id="startdate" class="form-control form-control-sm">
                                                    </div>
                                                </div>
                                                <div class="col">
                                                    <div class="form-group">
                                                        <label for="enddate">End Date</label>
                                                        <input type="text"  autocomplete="off"  id="enddate" class="form-control form-control-sm">
                                                    </div>
                                                </div>
                                                <div class="col">
                                                    <div class="form-group">
                                                        <label for="status">Status</label>
                                                        <select id="status" class="form-control form-control-sm">
                                                            <option value='<All>'>&lt;All&gt;</option>
                                                            <option value='Pending'>Pending</option>
                                                            <option value='Partially Paid'>Partially Paid</option>
                                                            <option value='Fully Paid'>Fully Paid</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col col-md-2">
                                                    <div class="form-group">
                                                        <label for="filterbutton">&nbsp;</label>
                                                        <button class='btn btn-dark btn-sm d-block' id="filterbutton" name="filterbutton">Filter Invoices</button>
                                                    </div>
                                                </div>
                                                <div class="col col-md-2">
                                                    <div class="form-group">
                                                        <label for="">&nbsp;</label>
                                                        <input type="button" id="addinvoice" name="addinvoice" value="Add New Invoice" class="btn btn-sm btn-success btn-sm d-block">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col" id="receiptlist"> 
                                        <div id="errorinvoices" class="mt-2 mb-2"></div>
                                        <table class="table table-striped table-sm mt-2" id="supplierinvoices">
                                            <thead class="thead-light">
                                                <th>#</th>
                                                <th>Invoice #</th>
                                                <th>Date Added</th>
                                                <th>Invoice Amount</th>
                                                <th>Paid</th>
                                                <th>Balance</th>
                                                <th>Status</th>
                                                <th>&nbsp;</th>
                                            </thead>
                                            <tbody id="invoiceslist"></tbody>
                                            <tfoot></tfoot>
                                        </table>
                                    </div>
                                </div> -->

                                <div class="tab-pane" id="transactions" role="tabpanel">
                                    <div class="row mt-2">
                                        <div class="col">
                                            <div class="form-group">
                                                <label for="statementstartdate">Start Date</label>
                                                <input type="text"  autocomplete="off"  id="statementstartdate" name="statementstartdate" class="form-control form-control-sm">
                                            </div>
                                        </div>
                                        <div class="col">
                                            <div class="form-group">
                                                <label for="statementenddate">End Date</label>
                                                <input type="text"  autocomplete="off"  id="statementenddate" name="statementenddate" class="form-control form-control-sm">
                                            </div>
                                        </div>
                                        <div class="col">
                                            <div class="form-group">
                                                <label for="">&nbsp;</label>
                                                <button type="button" class="btn btn-sm btn-secondary d-block" id="generatestatement" name="generatestatement">Generate Statement</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id='supplierstatement'></div>
                                <div id='supplieraging' class="mt-2"></div> 
                            </div>
                        </div>
                    </div>
                </div>
            </div>   
            
            <div class="modal fade alert-dismissable fade" id="productdetails">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form method="POST" id="supplierproductsform" name="supplierproductsform">
                            <div class="modal-header">
                                <p  class="modal-title">Select supplier Products</p>
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="errorsproduct" id="errorsproduct"></div>
                                <input type="hidden" name="savesupplierproducts" id="savesupplierproducts" value="true">
                                <input type="hidden" id="supplierid" name="supplierid" value="0">
                                <div class="form-group">
                                    <label for="productcategory">Category</label>
                                    <select name="productcategory" id="productcategory" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="productname">Product(s)</label>
                                    <select name="productname[]" id="productname" multiple class="form-control form-control-sm "></select>
                                </div>

                            </div>
                        
                            <div class="modal-footer">
                                <input type="submit" class="btn btn-sm btn-success" id="saveproduct" name="savesupplierproducts" value="Save Product(s)">
                                <button type="button" class="btn btn-sm btn-danger" id="cancelprocust" data-dismiss="modal">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
  </section>
    
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/supplierdetails.js"></script>
</html>