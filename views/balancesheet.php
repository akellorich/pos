<!DOCTYPE html>
<html lang="en" dir="ltr">
    <head>
        <?php require_once("header.txt") ?> 
        <title> SalesFlow | Balancesheet </title>
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
            <div class="home-content">
                <i class='bx bx-menu' ></i>
                <span class="text">Balancesheet</span>
                <div class="container-fluid mt-2">
                    <div class="row">
                        <div class="col col-md-3" id="filteroptions">
                            <div class="containergroup card">
                                <div class="card-header">
                                    <h5>Filter Options</h5>
                                </div>
                                <div class="card-body">
                                    <div id="errors"></div>
                                    <div class="form-group">
                                        <label for="startdate">Start Date</label>
                                        <input type="text" id="startdate" name="startdate" autocomplete="off" class="form-control form-control-sm">
                                    </div>
                                    <div class="form-group">
                                        <label for="enddate">End Date</label>
                                        <input type="text" id="enddate" name="enddate" autocomplete="off" class="form-control form-control-sm">
                                    </div>
                                    <button type="button" class="btn btn-secondary btn-sm" id="generate" name="generate">Generate Report</button>
                                </div>
                            </div>
                        </div>

                        <div class="col" id="receiptlist">
                            <div class="containergroup card">
                                <div class="card-header">
                                    <h5>Balancesheet</h5>
                                </div>
                                <div class="card-body">
                                    <div id='report'></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </body>
    <?php require_once("footer.txt") ?>
    <script type="text/javascript" src="../js/balancesheet.js"></script>
<html>