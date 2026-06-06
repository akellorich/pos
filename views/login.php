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
                <div class="form-group d-flex justify-content-between align-items-center">
                    <button type="button" id="logon" name="logon" class="btn btn-success">Logon</button>
                    <a href="#" id="forgot-password-link" style="font-size: 14px; text-decoration: none; color: #28a745; font-weight: 500; transition: color 0.2s ease-in-out;">Forgot Password?</a>
                </div>
        </form>
    </div>
    
    <!-- Forgot Password Modal -->
    <div class="modal fade" id="forgotPasswordModal" tabindex="-1" role="dialog" aria-labelledby="forgotPasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content" style="border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.15); border: none;">
                <div class="modal-header" style="background: linear-gradient(135deg, #28a745, #20c997); color: white; border-top-left-radius: 12px; border-top-right-radius: 12px; padding: 20px; border-bottom: none;">
                    <h5 class="modal-title font-weight-bold" id="forgotPasswordModalLabel" style="font-size: 1.25rem;">
                        Reset Your Password
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close" style="opacity: 0.8; font-size: 1.5rem; outline: none;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="padding: 30px;">
                    <div id="modal-alerts"></div>
                    
                    <!-- Step 1: Request OTP -->
                    <div id="otp-request-step">
                        <p class="text-muted mb-4" style="font-size: 14px;">Enter your username or email address below, and we will send you a One-Time Password (OTP) to reset your password.</p>
                        <div class="form-group">
                            <label for="reset-username-email" class="font-weight-bold text-dark" style="font-size: 13px;">Username or Email Address</label>
                            <input type="text" id="reset-username-email" class="form-control" placeholder="Enter username or email..." style="border-radius: 8px; padding: 12px 15px; border: 1px solid #ced4da; font-size: 14px;" required>
                        </div>
                        <button type="button" id="send-otp-btn" class="btn btn-success btn-block" style="border-radius: 8px; padding: 12px; font-weight: 600; font-size: 15px; background-color: #28a745; border-color: #28a745; margin-top: 20px; transition: all 0.2s;">
                            <span class="spinner-border spinner-border-sm mr-2 d-none" role="status" aria-hidden="true" id="otp-spinner"></span>Send Reset OTP
                        </button>
                    </div>

                    <!-- Step 2: Reset Password -->
                    <div id="otp-reset-step" class="d-none">
                        <p class="text-muted mb-4" style="font-size: 14px;">Please enter the 6-digit OTP sent to your email and choose a new password.</p>
                        <div class="form-group">
                            <label for="reset-otp" class="font-weight-bold text-dark" style="font-size: 13px;">One-Time Password (OTP)</label>
                            <input type="text" id="reset-otp" class="form-control" placeholder="Enter 6-digit OTP" maxlength="6" style="border-radius: 8px; padding: 12px 15px; font-size: 16px; text-align: center; font-weight: bold; letter-spacing: 5px; border: 1px solid #ced4da;" required>
                        </div>
                        <div class="form-group">
                            <label for="reset-new-password" class="font-weight-bold text-dark" style="font-size: 13px;">New Password</label>
                            <input type="password" id="reset-new-password" class="form-control" placeholder="Enter new password (min. 4 chars)..." style="border-radius: 8px; padding: 12px 15px; border: 1px solid #ced4da; font-size: 14px;" required>
                        </div>
                        <button type="button" id="reset-password-btn" class="btn btn-success btn-block" style="border-radius: 8px; padding: 12px; font-weight: 600; font-size: 15px; background-color: #28a745; border-color: #28a745; margin-top: 25px; transition: all 0.2s;">
                            <span class="spinner-border spinner-border-sm mr-2 d-none" role="status" aria-hidden="true" id="reset-spinner"></span>Update Password
                        </button>
                        <div class="text-center mt-3">
                            <a href="#" id="back-to-step1" style="font-size: 13px; text-decoration: none; color: #6c757d; font-weight: 500;">Back to Request OTP</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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