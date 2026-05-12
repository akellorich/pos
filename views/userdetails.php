<html>
<head>
    <title>User Details</title>
    <?php require_once("header.txt") ?>
<head>
<body>
    <?php require_once("navigation.txt") ?>
    <div  class="container-fluid">
        <ul class="nav nav-tabs mt-3" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" data-toggle="tab" href="#userdetails" role="tab">User Details</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="tab" href="#privileges" role="tab">Privileges</a>
            </li>

            <li class="nav-item">
                <a class="nav-link" data-toggle="tab" href="#roles" role="tab">Roles</a>
            </li>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
            <div class="tab-pane active" id="userdetails" role="tabpanel">
                <input type="hidden" id="userid" name="userid" value="<?php 
                    if(isset($_GET['userid'])){
                        echo $_GET['userid'];
                    }else{
                        echo 0;
                    }
                ?>">
    
                <div id="errors"></div>
                <div class="row mt-3 mb-3">
                    <div class="col">
                        <div class="form-group">
                            <label for="username">Username:</label>
                            <input type="text" id="username" name="username" class="form-control">
                        </div>
                    </div>

                    <div class="col">
                        <div class="form-group">
                            <label for="firstname">First Name:</label>
                            <input type="text" id="firstname" name="firstname"  class="form-control">
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label for="middlename">Middle Name:</label>
                            <input type="text" id="middlename" name="middlename"  class="form-control">
                            </div>
                        </div>
                
                    <div class="col">
                        <div class="form-group">
                            <label for="othernames">Last Name:</label>
                            <input type="text" id="othernames" name="othernames"  class="form-control">
                        </div>
                    </div>

                </div>
                    
                <div class="row">
                    <div class="col">
                        <div class="form-group">
                            <label for="password">Password:</label>
                            <input type="password" id="password" name="password"  class="form-control">
                        </div>
                    </div>
                
                    <div class="col">
                        <div class="form-group">
                            <label for="password_1">Confirm Password:</label>
                            <input type="password" id="password_1" name="password_1"  class="form-control">
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="text" id="email" name="email"  class="form-control">
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label for="mobile">Mobile:</label>
                            <input type="text" id="mobile" name="mobile"  class="form-control">
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col">
                        <div class="form-check">
                            <input type="checkbox" id="changepassword" name="changepassword" class="form-check-input">
                            <label for="changepassword" class="form-check-label">Change Current Password</label>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-check">
                            <input type="checkbox" id="changepasswordonlogon" name="changepasswordonlogon" class="form-check-input">
                            <label for="changepasswordonlogon" class="form-check-label">Change  Password On Logon</label>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-check">
                            <input type="checkbox" id="accountexpires" name="accountexpires" class="form-check-input">
                            <label for="accountexpires" class="form-check-label">Account expires</label>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-group">
                            <label for="accountexpirydate">Expiry Date:</label>
                            <input type="text" id="accountexpirydate" name="accountexpirydate"  class="form-control">
                        </div>
                    </div>

                </div>
                <input type="button" id="save" name="save" Value="Save User" class="btn btn-success mb-2">
                <input type="button" id="clear" name="clear" Value="Clear Fields" class="btn btn-danger mb-2">
            </div>            
            <div class="tab-pane" id="privileges" role="tabpanel">
                <div id="errors1" class="mt-3"></div>
                <div class="privileges" id="privilegeitems">
               
                </div>
                <input type="button" id="selectall" name="selectall" Value="Select All" class="btn btn-secondary">
                <input type="button" id="saveprivileges" name="saveprivileges" Value="Apply Privileges" class="btn btn-success">
            </div>
            
            <div class="tab-pane" id="roles" role="tabpanel">
            
            </div>
        </div> 
    </div> 
</body>
<?php require_once("footer.txt") ?>
<script type="text/javascript" src="../js/userdetails.js"></script>
</html>