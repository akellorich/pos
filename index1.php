<?php session_start(); ?>
<html>
<head>
    <title>User Logon</title>
    <link href="css/all.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="css/jquery-ui-1.10.3.custom.css" rel="stylesheet" type="text/css" /> <!---->
    <link href="css/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="css/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css" />
    <link href="css/custom.css" rel="stylesheet" type="text/css" />
<head>
<body>
    <div class="container-fluid">
        <form action="" class=" loginform needs-validation" novalidate>
                <header>
                    <h4>Enter Login Credentials</h4>
                </header>
                <div id="errors" ></div>
                <div class="form-group">
                    <label for="username">Username:</label>
                    <div class="input-prepend">
                        <i class="fa fa-user fa-lg fa-fw"  aria-hidden="true"></i>
                        <input type="text" id="username" name="username" class="form-control" required>
                    </div>
                    <div class="invalid-feedback">Please provide your username!</div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password:</label>
                    <div class="input-prepend">
                       <i class="fa fa-lock fa-lg fa-fw" aria-hidden="true"></i>
                       <!-- <i class="fas fa-lock"></i> -->
                        <input type="password" id="password" name="password"  class="form-control"  required>
                    </div>
                    <div class="invalid-feedback">Please provide your pasword!</div>
                <div>
                <br/>
                <div class="form-group">
                    <button type="button" id="logon" name="logon" class="btn btn-success">Logon</button>
                </div>
        </form>
    </div>
</body>
<script type="text/javascript" src="js/jquery-2.2.4.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery_ui.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="js/dataTables.bootstrap4.min.js"></script>
<script type="text/javascript" src="js/bootbox.min.js"></script>
<script type="text/javascript" src="js/login.js"></script>
</html>