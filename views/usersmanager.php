<!DOCTYPE html>
<html lang="en" dir="ltr">
    <head>
        <?php require_once("header.txt") ?> 
        <title> SalesFlow | Users </title>
        <style>
            @media (max-width: 576px) {
                #buttonlist .btn {
                    font-size: 0.65rem !important;
                    padding: 0.15rem 0.3rem !important;
                    letter-spacing: -0.02em;
                }
                #buttonlist {
                    flex-wrap: wrap;
                    gap: 5px;
                }
            }
        </style>
    </head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section">
        <?php $pagename = "Users"; require_once("topbar.php"); ?>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12 col-md-3 mt-1">
                        <section class=" ">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-12 text-center ">
                                        <nav class="nav-justified ">
                                            <div class="nav nav-tabs " id="nav-tab" role="tablist">
                                                <a class="nav-item nav-link active" id="pop1-tab" data-toggle="tab" href="#pop1" role="tab" aria-controls="pop1" aria-selected="true">Users</a>
                                                <a class="nav-item nav-link" id="pop2-tab" data-toggle="tab" href="#pop2" role="tab" aria-controls="pop2" aria-selected="false">Roles</a>
                                                <a class="nav-item nav-link" id="managelocalusers-tab" data-toggle="tab" href="#localusers" role="tab" aria-controls="managelocalusers" aria-selected="false">Local Users</a>
                                            </div>
                                        </nav>
                                        <div class="tab-content text-left" id="nav-tabContent">
                                            <div class="tab-pane fade show active" id="pop1" role="tabpanel" aria-labelledby="pop1-tab">
                                                    <div class="pt-3"></div>
                                                    <div class="form-group">
                                                        <label for="userslist">User</label>
                                                        <select name="userslist" id="userslist" class='form-control form-control-sm mb-2'></select>
                                                        
                                                        <div id="buttonlist" class="d-flex justify-content-around flex-wrap mt-2">
                                                            <button class="btn btn-primary btn-sm mb-1" id="changestatusbutton">Disable User</button>
                                                            <button class="btn btn-primary btn-sm mb-1" id="changepasswordbutton">Reset Password</button>
                                                            <button class="btn btn-primary btn-sm mb-1" id="resetpinbutton">Reset PIN</button>
                                                        </div>
                                                        
                                                        <div id="userroles" class="mt-3">
                                                            <p class='font-weight-bold'>Assigned Roles:</p>
                                                            <div id="userroleslist">
                                                                <div class='alert alert-info' role='alert'><i class='fal fa-info-circle fa-lg'></i> No roles defined currently.</div>
                                                            </div>
                                                        </div>

                                                        <div id="useroutlets" class="mt-2">
                                                            <p class='font-weight-bold'>Assigned Outlets:</p>
                                                            <div id="useroutletslist">
                                                                <div class='alert alert-info' role='alert'><i class='fal fa-info-circle fa-lg'></i> No outlets defined currently.</div>
                                                            </div>
                                                        </div>

                                                        <button class="btn btn-sm btn-danger w-100" id="specialpermissions"><i class="fal fa-tasks fa-lg fa-fw"></i> Special Permissions</button>
                                                    </div>
                                                
                                                </div>
                                            <div class="tab-pane fade" id="pop2" role="tabpanel" aria-labelledby="pop2-tab">
                                                <div class="pt-3"></div>
                                                <div id="roles" class="roles"></div>
                                                <div class="roleusers mt-3" id="roleusers"></div>
                                            </div>
                                            <div class="tab-pane fade" id="localusers" role="tabpanel" aria-labelledby="pop2-tab">
                                                <div class="pt-3"></div>
                                                <!-- <div id="localusers" class="mt-2 mb-3"> -->
                                                    <p class='font-weight-bold'>Local Users:</p>
                                                    <div id="localuserslist">
                                                        <div class='alert alert-info' role='alert'><i class='fal fa-info-circle fa-lg'></i> No local users currently.</div>
                                                    </div>
                                                    <button class="btn btn-sm btn-outline-success" id="addlocaluser"><i class="fal fa-plus fa-lg fa-fw"></i>Add Local User</button>
                                                <!-- </div> -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>
                    
                    <div class="col-12 col-md-9">
                        <div id="userdetails" class="mt-2">
                            <div class="card containergroup">
                                <div class="card-header">
                                    <h5>User Details</h5>
                                </div>
                                <div class="card-body">
                                    <div id="errordiv"></div>
                                    <div class="row">
                                        <div class="col-md-2 text-center border-right">
                                            <div class="form-group">
                                                <label class="font-weight-bold d-block">Profile Photo</label>
                                                <div class="mb-2 mt-2">
                                                    <img id="profile_preview" src="../images/blankavatar.jpg" class="img-thumbnail" style="width: 110px; height: 110px; object-fit: cover; border-radius: 50%;">
                                                </div>
                                                <input type="file" id="profilephoto" name="profilephoto" style="display: none;" accept="image/*">
                                                <button type="button" class="btn btn-xs btn-outline-primary mt-1 py-2" onclick="document.getElementById('profilephoto').click();">Change Photo</button>
                                            </div>
                                        </div>
                                        <div class="col-md-10">
                                            <div class="row"> 
                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <input type="hidden" id="userid" value="0">
                                                        <input type="hidden" id="accountactive" value="0">
                                                        <label for="username">Username:</label>
                                                        <div class="input-group">
                                                            <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-user fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="text" name="username" id="username" class="form-control  form-control-sm"  autocomplete="off">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="firstname">First Name:</label>
                                                        <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-user-tie  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="text" name="firstname" id="firstname" class="form-control  form-control-sm"  autocomplete="off">
                                                        </div> 
                                                    </div>
                                                </div>
                                                
                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="middlename">Middle Name:</label>
                                                        <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-user-tie  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="text" name="middlename" id="middlename" class="form-control  form-control-sm"  autocomplete="off">
                                                        </div>  
                                                    </div>
                                                </div>

                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="lastname">Last Name:</label>
                                                        <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-user-tie  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="text" name="lastname" id="lastname" class="form-control  form-control-sm"  autocomplete="off">
                                                        </div>   
                                                    </div>
                                                </div>

                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="password">Password:</label>
                                                        <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-lock  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="password" name="password" id="password" class="form-control  form-control-sm"  autocomplete="off">
                                                        </div>  
                                                    </div>
                                                </div>

                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="confirmpassword">Confirm Password:</label>
                                                        <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-lock  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="password" name="confirmpassword" id="confirmpassword" class="form-control  form-control-sm"  autocomplete="off">
                                                        </div>
                                                    
                                                    </div>      
                                                </div>
                                                
                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="email">Email:</label>
                                                        <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-at  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="email" name="email" id="email" class="form-control  form-control-sm"  autocomplete="off">
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="mobile">Mobile:</label>
                                                        <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-phone  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="number" name="mobile" id="mobile" class="form-control  form-control-sm"  autocomplete="off"> 
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="defaultbranchid">Default Branch:</label>
                                                        <div class="input-group">
                                                            <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-building  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <select name="defaultbranchid" id="defaultbranchid" class="form-control form-control-sm"></select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="pin">PIN:</label>
                                                        <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-key  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="password" name="pin" id="pin" class="form-control  form-control-sm"  autocomplete="off">
                                                        </div>  
                                                    </div>
                                                </div>

                                                <div class="col-12 col-md-4">
                                                    <div class="form-group">
                                                        <label for="confirmpin">Confirm PIN:</label>
                                                        <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                <span class="input-group-text"><i class="fal fa-key  fa-sm fa-fw"></i></span>
                                                            </div>
                                                            <input type="password" name="confirmpin" id="confirmpin" class="form-control  form-control-sm"  autocomplete="off">
                                                        </div>
                                                    
                                                    </div>      
                                                </div>
                                                <div class="col-12 col-md-4">
                                                    <label for="">&nbsp;</label>
                                                    <div class="d-flex justify-content-between mt-1">
                                                        <div class="check-group">
                                                            <input type="checkbox" class="check-control" id="systemadmin" name="systemadmin">
                                                            <label for="systemadmin" class="check-label">System Admin</label>
                                                        </div>
                                                        <div class="check-group ml-3">
                                                            <input type="checkbox" class="check-control" id="changepasswordonlogon" name="changepasswordonlogon">
                                                            <label for="changepasswordonlogon" class="check-label">Reset password</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col btn-group mt-2 btn-group-toggle" id="filterprivileges" data-toggle="buttons"></div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="privilegebranchid" class="font-weight-bold">Select Branch for Privileges:</label>
                                        <select id="privilegebranchid" class="form-control form-control-sm"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col" id="userprivileges"></div>
                            </div>

                            <div class="row mt-2">
                                <div class="col-12 col-md-6 mb-2">
                                    <div class="check-group">
                                        <input type="checkbox" class="check-control" id="selectalluserprivileges" name="selectalluserprivileges">
                                        <label for="selectalluserprivileges" class="check-label">Select All</label>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6 text-md-right">
                                    <div class="btn-group-sm flex-wrap">
                                        <button class='btn btn-success btn-sm mb-1 mr-1' id='saveuser'><i class="fal fa-save fa-lg"></i> Save User</button>
                                        <button class='btn btn-outline-danger btn-sm mb-1 mr-1' id='clearuser'><i class="fal fa-hand-sparkles fa-lg"></i> Clear</button>
                                        <button class='btn btn-outline-success btn-sm mb-1 mr-1' id='adduserrole' data-toggle='modal' data-target='#userrolesadd'><i class="fal fa-plus-circle fa-lg"></i> Role</button>
                                        <button class='btn btn-outline-success btn-sm mb-1' id='adduseroutlet' data-toggle='modal' data-target='#useroutletsadd'><i class="fal fa-plus-circle fa-lg"></i> Outlet</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="roledetails" class="mt-2">
                        <div class="row">
                            <div class="col">
                                <div class="card containergroup">
                                    <div class="card-header">
                                        <h5>Role Details</h5>
                                    </div>
                                    <div class="card-body">
                                        <div id="roleerrors" class="roleerrors"></div>
                                        <div class="row">
                                            <div class="col-12 col-sm-6">
                                                <div class="control-group">
                                                    <input type="hidden" id="roleid" name="roleid" value="0">
                                                    <label for="rolename">Role Name</label>
                                                    <input type="text" id="rolename" name="rolename" class='form-control form-control-sm'  autocomplete="off">
                                                </div>
                                            </div>
                                            <div class="col-12 col-sm-6">
                                                <div class="control-group">
                                                    <label for="roledescription">Role Description</label>
                                                    <input type="text" id="roledescription" name="roledescription" class='form-control form-control-sm'  autocomplete="off">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col btn-group mt-2 btn-group-toggle" id="filterroleprivileges" data-toggle="buttons">
                            
                            </div>
                        </div>
                        <div class="row">
                            <div class="col" id="roleprivileges" class="mt-2">
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-12 col-md-4 mb-2">
                                <div class="check-group">
                                    <input type="checkbox" class="check-control" id="selectallroleprivileges" name="selectallroleprivileges">
                                    <label for="selectallroleprivileges" class="check-label">Select All</label>
                                </div>
                            </div>
                            <div class="col-12 col-md-8 mb-2 text-md-right">
                                <button class='btn btn-secondary btn-sm mb-1' id="saverole"><i class="fal fa-save fa-lg"> </i> Save Role</button>
                                <button class='btn btn-danger btn-sm mb-1' id='deleterole'><i class="fal fa-times-circle fa-lg"></i> Delete Role</button>
                                <button class='btn btn-info btn-sm mb-1' id='clearrole'><i class="fal fa-eraser fa-lg"></i> Clear Form</button>
                            </div>
                        </div>
                    </div>
                    <div class="modal fade alert-dismissable fade" id="userrolesadd">
                        <div class="modal-dialog">
                            <div class="modal-content" id="heldsalesdetails">
                                <div class="modal-header">
                                    <p  class="modal-title" >Select Role(s)</p>
                                    <button type="button" class="close" data-dismiss="modal">
                                        <span>&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body" id="">
                                    <div id="userroleerrors"></div>
                                    <div id="usernonroles"></div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary btn-sm" id="saveuserrole" >Save Roles</button>
                                    <button type="button" class="btn btn-danger btn-sm" id="cancelsaveuserrole" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal fade alert-dismissable fade" id="useroutletsadd">
                        <div class="modal-dialog">
                            <div class="modal-content" id="heldsalesdetails">
                                <div class="modal-header">
                                    <h6 class="modal-title">Select Outlet(s)</h6>
                                    <button type="button" class="close" data-dismiss="modal">
                                        <span>&times;</span>
                                    </button>
                                </div> <!-- -->
                                <div class="modal-body" id="">
                                    <div id="useroutleterrors"></div>
                                    <div id="usernonoutlets"></div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary btn-sm" id="saveuseroutlet" >Save Outlet(s)</button>
                                    <button type="button" class="btn btn-danger btn-sm" id="cancelsaveuseroutlet" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- Modal for assigning special permissions  -->
    <div class="modal" tabindex="-1" role="dialog" id="specialpermissionsmodal">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                
                <div class="modal-header">
                    <h5 class="modal-title">User's special permission</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                
                <div class="modal-body">
                    <nav class="nav-justified ">
                        <div class="nav nav-tabs " id="specialprivileges-tab" role="tablist">
                            <a class="nav-item nav-link active" id="pop1-requisitions" data-toggle="tab" href="#requisitionprivileges" role="tab" aria-controls="pop1" aria-selected="true">Requisitions</a>
                            <a class="nav-item nav-link" id="pop2-purchaseorders" data-toggle="tab" href="#purchaseorderprivileges" role="tab" aria-controls="pop2" aria-selected="false">Purchase Order</a>
                            <a class="nav-item nav-link" id="pop3-signature" data-toggle="tab" href="#signature" role="tab" aria-controls="pop2" aria-selected="false">Signature</a>
                        </div>
                    </nav>
                
                    <div class="tab-content text-left" id="nav-tabContent"> 
                        <!-- Requisition privileges tab  -->
                        <div class="tab-pane fade show active" id="requisitionprivileges" role="tabpanel" aria-labelledby="pop1-tab">
                            <div class="pt-3"></div>
                            <table class="table table-sm table-striped" id="requisitionprivilegestable"></table>
                        </div>
                        <!-- Purchase Order privileges tab  -->
                        <div class="tab-pane fade" id="purchaseorderprivileges" role="tabpanel" aria-labelledby="pop2-purchaseorders">
                        <div class="pt-3"></div>
                            <table class="table table-sm table-striped" id="purchaseorderprivilegestable"></table>
                        </div>
                        <!-- Signature tab  -->
                        <div class="tab-pane fade" id="signature" role="tabpanel" aria-labelledby="pop3-signature">
                            <div class="pt-3"></div>
                            <div id="attachmenterror"></div>
                            <img src="../images/noimage.jpg" alt="signature" id="signaturepreview" height=150px width=300px>
                            <div class="form-group row">
                                <label for="documentfile" class="col-sm-3 col-form-label">Signature:</label>
                                <div class="col-sm-9">
                                    <input type="file" id="signaturedocument" accept="image/*" name="signaturedocument" class='form-control form-control-sm'>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="saveuserspecialprivileges"><i class="fal fa-save fa-lg fa-fw"></i> Save changes</button>
                    <button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><i class="fal fa-times-circle fa-lg fa-fw"></i> Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal for PIN Reset -->
    <div class="modal" tabindex="-1" role="dialog" id="pinresetmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reset User PIN</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="resetpinnotifications"></div>
                    <div class="form-group">
                        <label for="userresetpin">Enter New PIN</label>
                        <input type="password" name="userresetpin" id="userresetpin" class="form-control form-control-sm">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="saveresetuserpin"><i class="fal fa-save fa-lg fa-fw"></i> Save Changes</button>
                    <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal">Close <i class="fal fa-times fa-lg fa-fw"></i></button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for adding new user local user -->
    <div class="modal" tabindex="-1" role="dialog" id="localuserdetailsmodal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Local User Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="localusernotifications"></div>
                    <div class="form-group">
                        <label for="localusername">Select User</label>
                        <select name="localusername" id="localusername" class="form-control form-control-sm">
                            <option value="">&lt;Choose&gt;</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success btn-sm" id="savelocaluser"><i class="fal fa-save fa-lg fa-fw"></i> Save changes</button>
                    <button type="button" class="btn btn-outline-danger btn-sm" data-dismiss="modal">Close <i class="fal fa-times fa-lg fa-fw"></i></button>
                </div>
            </div>
        </div>
    </div>
</body>


<?php require_once("footer.txt") ?>
<script src="../js/usersmanager.js"></script>
</html>
