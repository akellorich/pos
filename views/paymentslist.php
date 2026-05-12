<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Payments </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <div class="home-content">
            <i class='bx bx-menu' ></i>
            <span class="text">Payments</span>
            <div class="container-fluid" id="container-fluid">
                <div class="row">
                    <div class="col col-md-3 mt-2">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Filter Options</h5>
                            </div>
                            <div class="card-body">
                                <div id="errors" class="errors"></div>
                                <div class="form-group">
                                    <label for="supplier">Supplier</label>
                                    <select name="supplier" id="supplier" class="form-control form-control-sm"></select>
                                </div>
                                <div class="form-group">
                                    <label for="costcenter">Cost Center</label>
                                    <select name="costcenter" id="costcenter" class='form-control form-control-sm'></select>
                                </div>
                                <div class="form-group">
                                    <input type="checkbox" name="alldates" id="alldates"> All Dates
                                </div>

                                <div class="row">
                                    <div class="col">
                                        <div class="form-group">
                                            <label for="startdate">Start Date</label>
                                            <input type="text"  autocomplete="off" name="startdate" id="startdate" class='form-control form-control-sm'>
                                        </div>
                                    </div>

                                    <div class="col">
                                        <div class="form-group">
                                            <label for="enddate">End Date</label>
                                            <input type="text"  autocomplete="off" name="enddate" id="enddate" class='form-control form-control-sm'>
                                        </div>
                                    </div>  
                                </div>
                            
                                
                                <div class="form-group">
                                    <label for="status">Status</label>
                                    <select name="status" id="status" class='form-control form-control-sm'>
                                        <option value="all">&lt;All&gt;</option>
                                        <option value="Pending">Pending</option>
                                        <option value="Approved">Approved</option>
                                        <option value="Paid">Paid</option>
                                        <option value="Cancelled">Cancelled</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="paymentmode">Payment Mode</label>
                                    <select name="paymentmode" id="paymentmode" class='form-control form-control-sm'></select>
                                </div>
                                <button class='btn btn-sm btn-dark' id='filterpayments'><i class="fas fa-search fa-fw fa-lg"></i> Filter Payments</button>
                            </div>
                            <div class="card-footer">
                            
                            </div>
                        </div>
                    </div>

                    <div class="col mt-2 mb-2" id="receiptlist">
                        <div class="card containergroup">
                            <div class="card-header">
                                <h5>Payments In The System</h5>
                            </div>
                            <div class="card-body">
                                <div class="resultstable" >
                                    <div class="results1" id="results1"></div>
                                    <table class='table table-striped table-sm mb-2' id="results">
                                        <thead>
                                            <th>#</th>
                                            <th>Payment Date</th>
                                            <th>Voucher #</th>
                                            <th>Supplier</th>
                                            <th>Cost Center</th>
                                            <th>Invoice #</th>
                                            <th>Invoice Total</th>
                                            <th>Payment Mode</th>
                                            <th>Paid Thru'</th>
                                            <th>Reference</th>
                                            <th>Status</th>
                                            <th>&nbsp;</th>
                                            <th>&nbsp;</th>
                                            <th>&nbsp;</th>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td colspan='14'>No payments displayed. Apply filter and try again!</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="mt-2">
                            <button class='btn btn-success btn-sm' id='addnew'><i class="fas fa-plus-circle fa-fw fa-lg"></i> Add New</button>
                            <button class='btn btn-dark btn-sm' id='printlist'><i class="fas fa-print fa-fw fa-lg"></i>Print List</button>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
        
    </section>
    
</body>
<?php require_once("footer.txt") ?>
<script src="../js/paymentslist.js"></script>
</html>