<html>
<head>
    <title>User Logon</title>
    <link href="../css/bootstrap.css"  rel="stylesheet" type="text/css" />
    <link href="../css/custom.css"  rel="stylesheet" type="text/css" />
    <!-- <link href="../css/form_style.css" rel="stylesheet" type="text/css" /> -->
    <link href="../css/jquery-ui-1.10.3.custom.css" rel="stylesheet" type="text/css" />
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
                    <input type="text" id="username" name="username" class="form-control" required>
                    <div class="invalid-feedback">Please provide your username!</div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password"  class="form-control" required>
                    <div class="invalid-feedback">Please provide your pasword!</div>
                <div>
                <br/>
                <div class="form-group">
                    <button type="button" id="logon" name="logon" class="btn btn-success">Logon</button>
                </div>
        </form>
    </div>
    
   <!-- <ul class="form-style-1">
        
        <li>
            <h2>Enter Your Login Credentials</h2>
        </li>
        <div id="errors"></div>
        <li>
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" class="field-long">
        </li>
        
        <li>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password"  class="field-long">
        </li>
        
        <li>
            <input type="button" id="logon" name="logon" Value="Logon">
        </li>
    </ul> 
    -->
</body>
<script type="text/javascript" src="../js/jquery-2.2.4.js"></script>
<script type="text/javascript" src="../js/jquery_ui.js"></script>
<script type="text/javascript" src="../js/bootstrap.js"></script>
<script type="text/javascript" src="../js/login.js"></script>
</html>