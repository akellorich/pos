$(document).ready(function(){
    var loginbutton=$("#logon"),
        usernamefield=$("#username"),
        passwordfield=$("#password"),
        errordiv=$("#errors"),
        errors=""

    loginbutton.on("click",function(){
      
        username=usernamefield.val()
        password=passwordfield.val()
        if(username==="" || password===""){
            errors="<div class='alert alert-warning'  role='alert'>Please provide both username and password first</div>"
            errordiv.html("")
            $(errors).appendTo(errordiv)
        }else{
            $.getJSON(
                "controllers/loginuser.php",
                {
                    username:username,
                    password:password
                },
                function(data){
                    if(data.status == "success" || data.status == "Success"){
                        if(!data.hassession){
                            alert("Welcome! Note: You do not have an active session open. You will need to open one to make sales.");
                        }
                        window.location.href="views/main.php"
                    }else if (data.status == "change password"){
                        window.location.href="views/changepassword.php"
                    }else{
                        var result = data.status || data;
                        errors="<div class='alert alert-danger' role='alert'>"+result+"</div>"
                        errordiv.html("")
                        $(errors).appendTo(errordiv)
                    }
                } 
            )
        }

    })
    
    // Forgot password handlers
    var forgotLink = $("#forgot-password-link"),
        modal = $("#forgotPasswordModal"),
        modalAlerts = $("#modal-alerts"),
        sendOtpBtn = $("#send-otp-btn"),
        resetPasswordBtn = $("#reset-password-btn"),
        otpSpinner = $("#otp-spinner"),
        resetSpinner = $("#reset-spinner"),
        otpRequestStep = $("#otp-request-step"),
        otpResetStep = $("#otp-reset-step"),
        backToStep1 = $("#back-to-step1");

    forgotLink.on("click", function(e) {
        e.preventDefault();
        modalAlerts.html("");
        otpRequestStep.removeClass("d-none").show();
        otpResetStep.addClass("d-none").hide();
        $("#reset-username-email").val("");
        $("#reset-otp").val("");
        $("#reset-new-password").val("");
        modal.modal("show");
    });

    sendOtpBtn.on("click", function() {
        var usernameOrEmail = $("#reset-username-email").val().trim();
        if (usernameOrEmail === "") {
            modalAlerts.html("<div class='alert alert-warning'>Please enter your username or email address.</div>");
            return;
        }

        modalAlerts.html("");
        sendOtpBtn.prop("disabled", true);
        otpSpinner.removeClass("d-none");

        $.ajax({
            url: "controllers/send_reset_otp.php",
            type: "POST",
            data: { username_or_email: usernameOrEmail },
            dataType: "json",
            success: function(response) {
                sendOtpBtn.prop("disabled", false);
                otpSpinner.addClass("d-none");

                if (response.status === "success") {
                    modalAlerts.html("<div class='alert alert-success'>" + response.message + "</div>");
                    
                    // Smooth transition to step 2
                    setTimeout(function() {
                        otpRequestStep.fadeOut(300, function() {
                            otpRequestStep.addClass("d-none");
                            modalAlerts.html("");
                            otpResetStep.removeClass("d-none").fadeIn(300);
                        });
                    }, 1500);
                } else {
                    modalAlerts.html("<div class='alert alert-danger'>" + response.message + "</div>");
                }
            },
            error: function() {
                sendOtpBtn.prop("disabled", false);
                otpSpinner.addClass("d-none");
                modalAlerts.html("<div class='alert alert-danger'>An error occurred. Please try again later.</div>");
            }
        });
    });

    resetPasswordBtn.on("click", function() {
        var otp = $("#reset-otp").val().trim();
        var newPassword = $("#reset-new-password").val();

        if (otp === "") {
            modalAlerts.html("<div class='alert alert-warning'>Please enter the 6-digit OTP.</div>");
            return;
        }
        if (newPassword === "") {
            modalAlerts.html("<div class='alert alert-warning'>Please enter your new password.</div>");
            return;
        }
        if (newPassword.length < 4) {
            modalAlerts.html("<div class='alert alert-warning'>Password must be at least 4 characters long.</div>");
            return;
        }

        modalAlerts.html("");
        resetPasswordBtn.prop("disabled", true);
        resetSpinner.removeClass("d-none");

        $.ajax({
            url: "controllers/reset_password_with_otp.php",
            type: "POST",
            data: { otp: otp, new_password: newPassword },
            dataType: "json",
            success: function(response) {
                resetPasswordBtn.prop("disabled", false);
                resetSpinner.addClass("d-none");

                if (response.status === "success") {
                    modalAlerts.html("<div class='alert alert-success'>" + response.message + "</div>");
                    setTimeout(function() {
                        modal.modal("hide");
                    }, 3000);
                } else {
                    modalAlerts.html("<div class='alert alert-danger'>" + response.message + "</div>");
                }
            },
            error: function() {
                resetPasswordBtn.prop("disabled", false);
                resetSpinner.addClass("d-none");
                modalAlerts.html("<div class='alert alert-danger'>An error occurred. Please try again.</div>");
            }
        });
    });

    backToStep1.on("click", function(e) {
        e.preventDefault();
        modalAlerts.html("");
        otpResetStep.fadeOut(300, function() {
            otpResetStep.addClass("d-none");
            otpRequestStep.removeClass("d-none").fadeIn(300);
        });
    });
})