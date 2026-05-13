<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <?php require_once("header.txt") ?>
    <title> SalesFlow | Dashboard </title>
</head>
<body ><!-- style="background-color: #e8e8ea" -->
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Dashboard"; require_once("topbar.php"); ?>
        <!-- Contents of the Page -->
        <div>
            <div class="container-fluid" id="dashboard">
                <div class="row d-flex justify-content-between">
                    <div class="col-md-3 col-sm-12 col-12 badge blue mt-2" id="activecustomers">
                        <div class="image" style="display: inline-block">
                                <i class="fas fa-users"></i>
                        </div>

                        <div class="heading" style="display: inline-block" >
                                ACTIVE CUSTOMERS
                                <p class="subheading" >Within the Last 24 Hours</p>
                        </div>

                        <div class="number" style="display: inline-block" id='activecustomersplaceholder'>
                                0
                        </div>
                    </div>

                    <div class="col-md-3 col-sm-12 col-12  badge green mt-2" id="openreceivables">
                        <div class="image" style="display: inline-block">
                            <i class="fas fa-download"></i>
                        </div>

                        <div class="heading" style="display: inline-block">
                                OPEN RECEIVABLES
                                <p class="subheading">All Current Open Receivables</p>
                        </div>

                        <div class="number" style="display: inline-block" id="openreceivablesplaceholder">
                                0
                        </div>
                    </div>

                    <div class="col-md-3 col-sm-12 col-12  badge red mt-2" id="openpayables">
                        <div class="image" style="display: inline-block">
                            <i class="fas fa-upload"></i>
                        </div>

                        <div class="heading" style="display: inline-block">
                                OPEN PAYABLES
                            <p class="subheading">All Current Open Payables</p>
                        </div>

                        <div class="number" style="display: inline-block" id="openpayablesplaceholder">
                                0
                        </div>
                    </div>

                    <div class="col-md-3 col-sm-12 col-12  badge purple mt-2" id="openorders">
                        <div class="image" style="display: inline-block">
                            <i class="fas fa-file-invoice-dollar"></i>
                        </div>

                        <div class="heading" style="display: inline-block">
                                OPEN ORDERS
                                <p class="subheading">All Supplier Orders Undelivered</p>
                        </div>

                        <div class="number" style="display: inline-block" id="openpurchaseordersplaceholder">
                                0
                        </div>
                    </div>
                </div>
                <!-- Sales By Value -->
                <div class="row">
                    <div class="col col-md-4 col-sm-12 col-12">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Sale By Value</span>
                                <span class="float-right">
                                    <div class="dropdown">
                                        <button class="btn btn-secondary btn-outline-info btn-xs dropdown-toggle" type="button" id="salebyvaluedropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Today
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="salebyvaluedropdown">
                                            <button class="dropdown-item" type="button" id="salesbyvaluetoday">Today</button>
                                            <button class="dropdown-item" type="button" id="salesbyvalueweek">Week</button>
                                            <button class="dropdown-item" type="button" id="salesbyvaluemonth">Month</button>
                                            <button class="dropdown-item" type="button" id="salesbyvalueyear">Year</button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                            <div class="card-body">
                                <canvas id="salesbyvalue"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col col-md-4 col-sm-12 col-12">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Sale By Quantity</span>
                                <span class="float-right">
                                    <div class="dropdown">
                                        <button class="btn btn-secondary btn-outline-info btn-xs dropdown-toggle" type="button" id="salebyquantitydropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Today
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="salebyquantitydropdown">
                                            <button class="dropdown-item" type="button" id="salesbyquantitytoday">Today</button>
                                            <button class="dropdown-item" type="button" id="salesbyquantityweek">Week</button>
                                            <button class="dropdown-item" type="button" id="salesbyquantitymonth">Month</button>
                                            <button class="dropdown-item" type="button" id="salesbyquantityyear">Year</button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                            <div class="card-body">
                                <canvas id="salesbyquantity"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col col-md-4 col-sm-12 col-12">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Sale By Payment Mode</span>
                                <span class="float-right">
                                    <div class="dropdown">
                                        <button class="btn btn-secondary btn-outline-info btn-xs dropdown-toggle" type="button" id="salebypaymentmodedropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Today
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="salebypaymentmodedropdown">
                                            <button class="dropdown-item" type="button" id="salesbypaymentmodetoday">Today</button>
                                            <button class="dropdown-item" type="button" id="salesbypaymentmodeweek">Week</button>
                                            <button class="dropdown-item" type="button" id="salesbypaymentmodemonth">Month</button>
                                            <button class="dropdown-item" type="button" id="salesbypaymentmodeyear">Year</button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                            <div class="card-body">
                            <canvas id="salesbypaymentmode"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Sales By Discount Customer Outlet Salesperson -->
                <div class="row">
                    <div class="col col-md-4 col-sm-12 col-12">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Customer Sales</span>
                                <span class="float-right">
                                    <div class="dropdown">
                                        <button class="btn btn-secondary btn-outline-info btn-xs dropdown-toggle" type="button" id="salebycustomerdropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Today
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="salebycustomerdropdown">
                                            <button class="dropdown-item" type="button" id="salesbycustomervaluetoday">Today</button>
                                            <button class="dropdown-item" type="button" id="salesbycustomervalueweek">Week</button>
                                            <button class="dropdown-item" type="button" id="salesbycustomervaluemonth">Month</button>
                                            <button class="dropdown-item" type="button" id="salesbycustomervalueyear">Year</button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                            <div class="card-body">
                                <canvas id="salesbycustomervalue"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col col-md-4 col-sm-12 col-12">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Customer Count</span>
                                <span class="float-right">
                                    <div class="dropdown">
                                        <button class="btn btn-secondary btn-outline-info btn-xs dropdown-toggle" type="button" id="salebycustomercountdropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Today
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="salebycustomercountdropdown">
                                            <button class="dropdown-item" type="button" id="salebycustomercounttoday">Today</button>
                                            <button class="dropdown-item" type="button" id="salebycustomercountweek">Week</button>
                                            <button class="dropdown-item" type="button" id="salebycustomercountmonth">Month</button>
                                            <button class="dropdown-item" type="button" id="salebycustomercountyear">Year</button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                            <div class="card-body">
                                <canvas id="salesbycustomercount"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col col-md-4 col-sm-12 col-12">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Sale By Outlet</span>
                                <span class="float-right">
                                    <div class="dropdown">
                                        <button class="btn btn-secondary btn-outline-info btn-xs dropdown-toggle" type="button" id="salebyoutletdropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Today
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="salebyoutletdropdown">
                                            <button class="dropdown-item" type="button" id="salebyoutlettoday">Today</button>
                                            <button class="dropdown-item" type="button" id="salebyoutletweek">Week</button>
                                            <button class="dropdown-item" type="button" id="salebyoutletmonth">Month</button>
                                            <button class="dropdown-item" type="button" id="salebyoutletyear">Year</button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                            <div class="card-body">
                                <canvas id="salesbyoutlet"></canvas>
                            </div>
                        </div>
                    </div>
                </div> 

                <div class="row">
                    <div class="col col-md-4 col-sm-12 col-12">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Sale By Salesman</span>
                                <span class="float-right">
                                    <div class="dropdown">
                                        <button class="btn btn-secondary btn-outline-info btn-xs dropdown-toggle" type="button" id="salebysalesmandropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Today
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="salebysalesmandropdown">
                                            <button class="dropdown-item" type="button" id="salesbysalesmantoday">Today</button>
                                            <button class="dropdown-item" type="button" id="salesbysalesmanweek">Week</button>
                                            <button class="dropdown-item" type="button" id="salesbysalesmanmonth">Month</button>
                                            <button class="dropdown-item" type="button" id="salesbysalesmanyear">Year</button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                            <div class="card-body">
                                <canvas id="salesbysalesperson"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col col-md-4 col-sm-12 col-12">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Best Selling Product</span>
                                <span class="float-right">
                                    <div class="dropdown">
                                        <button class="btn btn-secondary btn-outline-info btn-xs dropdown-toggle" type="button" id="bestsellingproductdropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Today
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="bestsellingproductdropdown">
                                            <button class="dropdown-item" type="button" id="bestsellingproducttoday">Today</button>
                                            <button class="dropdown-item" type="button" id="bestsellingproductweek">Week</button>
                                            <button class="dropdown-item" type="button" id="bestsellingproductmonth">Month</button>
                                            <button class="dropdown-item" type="button" id="bestsellingproductyear">Year</button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                            <div class="card-body">
                                <div id="bestsellingproduct"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-md-4 col-sm-12 col-12">
                        <div class="card sales">
                            <div class="card-header">
                                <span class="text-left font-weight-bold">Best Selling Category</span>
                                <span class="float-right">
                                    <div class="dropdown">
                                        <button class="btn btn-secondary btn-outline-info btn-xs dropdown-toggle" type="button" id="bestsellingcategorydropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Today
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="bestsellingcategorydropdown">
                                            <button class="dropdown-item" type="button" id="bestsellingcategorytoday">Today</button>
                                            <button class="dropdown-item" type="button" id="bestsellingcategoryweek">Week</button>
                                            <button class="dropdown-item" type="button" id="bestsellingcategorymonth">Month</button>
                                            <button class="dropdown-item" type="button" id="bestsellingcategoryyear">Year</button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                            <div class="card-body">
                                <div id="bestsellingcategory"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>   
        </div>
    </section>
</body>
<?php require_once("footer.txt") ?> 
<!-- Add chart.js from cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.bundle.js" integrity="sha256-qSIshlknROr4J8GMHRlW3fGKrPki733tLq+qeMCR05Q=" crossorigin="anonymous"></script>
<!-- <script src="../js/chartjsplugin.js"></script> -->
<script src="../js/main.js"></script>
</html>