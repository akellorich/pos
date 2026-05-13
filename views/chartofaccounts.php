<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Chart of Accounts </title>
   </head>
<body>
    <?php require_once("sidebar.html") ?>

    <section class="home-section">
        <?php $pagename = "Chart of Accounts"; require_once("topbar.php"); ?>
            <div class="container-fluid ">
                <div class="row">
                    <div class="col-md-3" id="chartofaccountslist">
                        <button class="btn btn-success btn-sm  w-100 mb-1 mt-3" data-toggle='modal' data-target='#glgroups'><i class="fas fa-plus-circle fa-lg fa-fw"></i> Add GL group</button>
                        <button class="btn btn-danger btn-sm  w-100 mb-1"><i class="fas fa-minus-circle fa-lg fa-fw"></i> Delete GL Account</button>
                        <div id="accordion" class="myaccordion" id="myaccordion">
                        </div>
                    </div>

                
                    <div class="col containergroup" id="chartofaccountsdetail">
                        <div class="card mt-3">
                            <div class="card-header">
                                <h5>Account Details</h5>
                            </div>

                            <div class="card-body">
                                <input type="hidden" id="id" name="id" value="0">
                                <div id="accounterrordiv" class="accounterrordiv"></div>
                                <div class="form-group">
                                    <label for="accountclass">Account Class</label>
                                    <select name="accountclass" id="accountclass" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="accountgroup">Parent Group</label>
                                    <select name="accountgroup" id="accountgroup" class="form-control form-control-sm"></select>
                                </div>

                                <div class="from-group">
                                    <label for="subgroupname">Subgroup</label>
                                    <select name="accountsubgroup" id="accountsubgroup" class="form-control form-control-sm"></select>
                                </div>

                                <div class="form-group">
                                    <label for="accountcode">Account Code</label>
                                    <input type="text" id="accountcode" name="accountcode" class='form-control form-control-sm'>
                                </div>

                                <div class="form-group">
                                    <label for="accountname">Account Name</label>
                                    <input type="text" id="accountname" name="accountname" class="form-control form-control-sm">
                                </div>

                                <button class='btn btn-success btn-sm ' id="savebutton"><i class="fas fa-save fa-lg fa-fw"></i> Save GL Account</button>
                                <button class="btn btn-danger btn-sm " id="clearbutton"><i class="fas fa-eraser fa-lg fa-fw"></i> Clear Form</button>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="card mt-3">
                            <div class="card-body">
                                GL Account Summary
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        
    </section>
    
    <div class="modal fade alert-dismissable fade" id="glgroups">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h6>GL Group Details</h6>
                </div>
                <div class="modal-body">
                    <div id="grouperrors"></div>
                    <div class="form-group">
                        <label for="glgroupclass">Group Class</label>
                        <select name="groupclass" id="groupclass" class="form-control form-control-sm"></select>
                    </div>
                    <div class="form-group">
                        <label for="subgroupof">Sub Group Of</label>
                        <select name="subgroupof" id="subgroupof" class='form-control form-control-sm'></select>
                    </div>
                    <div class="from-group">
                        <label for="groupname">GL Parent Group Name</label>
                        <input type="text" id="groupname" name="groupname" class='form-control form-control-sm'>
                    </div>

                    <div class="form-check">
                        <input type="checkbox" id="cashbookgroup" name="cashbookgroup" class="form-check-input">
                        <label for="cashbookgroup" class="form-check-label">Cashbook Group</label>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm " id="savegroup"><i class="fas fa-save fa-lg fa-fw"></i> Save GL Group</button>
                    <button type="button" class="btn btn-danger btn-sm " id="close" data-dismiss="modal"><i class="fas fa-times-circle fa-lg fa-fw"></i> Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<?php require_once("footer.txt") ?>
<script src="../js/chartofaccounts.js"></script>
</html>