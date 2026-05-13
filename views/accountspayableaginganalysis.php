<!DOCTYPE html>
<html lang="en" dir="ltr">
    <head>
        <?php require_once("header.txt") ?> 
        <title> SalesFlow | Payables Aging Analysis </title>
        <style>
            .alert-success .btn-danger {
                float: left;  
            }

            .alert-success span {
                line-height: 34px;
            }

            .alert-success > div:after {
                clear: both;
                content: '';
                display: table;
            }
            .btn-danger{
                margin-right:1rem;
                margin-left:-0.5rem;
            }
        </style>
    </head>
    <body>
        <?php require_once("sidebar.html") ?>
        <section class="home-section">
            <?php $pagename = "Payables Aging Analysis"; require_once("topbar.php"); ?>
                <div class="container-fluid mt-2"> 
                    <div class="row">
                        <div class="col col-md-2" id="filteroptions">
                            <div class="card containergroup">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body">
                                    <div id="errors"></div>
                                    <div class="form-group">
                                        <label for="startdate">AP Analysis As At</label>
                                        <input type="text" id="startdate" autocomplete="off" name="startdate" class="form-control form-control-sm">
                                    </div>
                                    <button type="button" class="btn btn-secondary btn-sm" id="search" name="search">Generate Report</button>  
                                </div>
                            </div>
                        </div>

                        <div class="col" id="receiptlist">
                                <div class="card containergroup">
                                    <div class="card-header">
                                        <h5>
                                            <span class="text-left font-weight-bold">Accounts Payable Aging Analysis</span>
                                            <span class="float-right">
                                                <a class='btn btn-danger btn-xs' data-toggle='collapse' href='#filteroptions' role='button' aria-expanded='false' aria-controls='filteroptions'><i class="far fa-eye-slash"></i></a>
                                            </span> 
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div id='report'></div>
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
    <script type="text/javascript" src="../js/accountspayableaginganalysis.js"></script>
<html>