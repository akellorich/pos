<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Management Dashboard </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Management Dashboard"; require_once("topbar.php"); ?>
            <div class="container-fluid mb-2" id="dashboard">
                <div class="filteroptions row mt-2">
                    <div class="col col-md-4 ml-0">
                        <div class="form-group">
                            <label for="daterage" class="text-color-black">Date Range</label>
                            <select name="daterange" id="daterange" class="form-control form-control-sm">
                                <option value="today">Today</option>
                                <option value="week">Week</option>
                                <option value="month">Month</option>
                                <option value="year">Year</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="col">
                        <div class="form-group">
                            <label for="generatereport">&nbsp;</label>
                            <button class="btn btn-sm btn-secondary d-block" id="generatereport" name="generatereport"><i class="fas fa-chart-line fa-lg fa-fw"></i> Generate Report</button>
                        </div>
                    </div>
                    
                    
                </div>
                <!-- Sales By Payment Mode -->
                <div class="row">
                    <div class="col">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Sales</span>
                                
                            </div>
                            <div class="card-body scrollable-y">
                                <table class="table table-sm table-striped">
                                    <thead>
                                        <th>#</th>
                                        <th>Payment Mode</th>
                                        <th class='text-right'>Amount</th>
                                    </thead>
                                    <tbody id="salesreport"></tbody>
                                </table>
                            
                            </div>
                        </div>
                    </div>

                    <div class="col">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Stock</span>
                            
                            </div>
                            <div class="card-body">
                                <!-- <canvas id="salesbyquantity"></canvas> -->
                                <table class="table table-sm">
                                    <tbody id="stockreport"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Crates</span>
                            
                            </div>
                            <div class="card-body">
                            <!-- <canvas id="salesbypaymentmode"></canvas> -->
                            <table class="table table-sm">
                                <tbody id="cratesummary"></tbody>
                            </table>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Sales By Discount Customer Outlet Salesperson -->
                <div class="row">
                    <div class="col">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Gross Profit</span>
                                
                            </div>
                            <div class="card-body">
                                <!-- <canvas id="salesbycustomervalue"></canvas> -->
                                <table class="table table-sm">
                                    <tbody id="grossprofit">

                                    </tbody>
                                </table>
                                <!-- <span id="grossprofit" class="lead text-align-center mt-3 m-5 font-weight-bold"></span> -->
                            </div>
                        </div>
                    </div>

                    <div class="col">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Creditors</span>
                            
                            </div>
                            <div class="card-body scrollable-y">
                                <!-- <canvas id="salesbycustomercount"></canvas> -->
                                <table class="table table-sm table-striped">
                                    <thead>
                                        <th>#</th>
                                        <th>Supplier Name</th>
                                        <th class='text-right'>Outstanding Balance</th>
                                    </thead>
                                    <tbody id="suppliersreport"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Debtors</span>
                            </div>
                            <div class="card-body scrollable-y">
                                <!-- <canvas id="salesbyoutlet"></canvas> -->
                                <table class="table table-sm table-striped  ">
                                    <thead>
                                        <th>#</th>
                                        <th>Customer Name</th>
                                        <th class='text-right'>Outstanding Balance</th>
                                    </thead>
                                    <tbody id="customersreport"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div> 

                <div class="row">
                    <div class="col">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Expenses</span>
                            
                            </div>
                            <div class="card-body  scrollable-y">
                                <!-- <canvas id="salesbysalesperson"></canvas> -->
                                <table class="table table-sm table-striped">
                                    <thead>
                                        <th>#</th>
                                        <th>Account</th>
                                        <th class='text-right'>Amount</th>
                                    </thead>
                                    <tbody id="expensesreport"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Bankings</span>
                            
                            </div>
                            <div class="card-body scrollable-y">
                                <!-- <div id="bestsellingproduct"></div> -->
                                <table class="table table-sm table-striped ">
                                    <thead>
                                        <th>#</th>
                                        <th>Account</th>
                                        <th class='text-right'>Amount Banked</th>
                                    </thead>
                                    <tbody id="bankingsreport"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Spoilage</span>
                                
                            </div>
                            <div class="card-body scrollable-y">
                                <table class="table table-sm table-striped">
                                    <thead>
                                        <th>#</th>
                                        <th>Category</th>
                                        <th>Product</th>
                                        <th>Quantity</th>
                                    </thead>
                                    <tbody id="spoilagereport"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>   
        </div>
    </section>

</body>
<?php require_once("footer.txt") ?>
<script src="../js/managementdashboard.js"></script>
</html>