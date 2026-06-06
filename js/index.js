
$(document).ready(() => {
    // Show/hide virtual keyboard
    const keyboard = document.getElementById('virtualKeyboard')

    document.getElementById('keyboardIcon').addEventListener('click', function (event) {
        event.preventDefault() // Prevent form submission  
        keyboard.style.display = keyboard.style.display === 'block' ? 'none' : 'block'
    })

    // Add numeric values to the PIN field
    const pinField = document.getElementById('pinField'),
        keyboardButtons = document.querySelectorAll('#virtualKeyboard button')

    keyboardButtons.forEach(button => {
        button.addEventListener('click', function (event) {
            event.preventDefault(); // Prevent form submission
            if (button.textContent === 'C') {
                pinField.value = '' // Clear PIN field
            } else if (button.querySelector('i.fa-arrow-right')) {
                document.getElementById('virtualKeyboard').style.display = 'none'; // Hide keyboard
            } else {
                pinField.value += button.textContent; // Append the clicked number
            }
        })
    })

    const loginbutton = $("#userlogin"),
        loginnotifications = $("#userloginnotifications"),
        usernamefield = $("#userusername"),
        passwordfield = $("#userpassword"),
        remembermefield = $("#rememberMe"),
        inputfield = $("input"),
        waiterslist = $("#waiterslist"),
        loginwithpinbutton = $("#loginwithpin"),
        waiterloginnotifications = $("#waiterloginnotifications"),
        waiterloginform = $("#waiter-login-tab"),
        logofield = $("#companylogo")

    getloginuisettings().done((data) => {
        console.log("Login UI Settings: ", data)
        // load logo
        logofield.attr("src", data.logo)
        if (data.showwaiterlogin == 1) {
            waiterloginform.show()
        } else {
            waiterloginform.hide()
        }
    })

    inputfield.on("input", () => {
        loginnotifications.html("")
        waiterloginnotifications.html("")
    })

    const users = JSON.parse(localStorage.getItem('users')) || []
    let results = "<option value=''>&lt;Choose&gt;</option>"

    users.forEach((user) => {
        results += `<option value='${user.username}'>${user.username}</option>`
    })
    waiterslist.html(results)

    waiterslist.on("change", function () {
        const username = $(this).val()
        pinField.focus()
    })

    loginbutton.on("click", (e) => {
        e.preventDefault()
        const usernameValue = usernamefield.val() || "";
        const passwordValue = passwordfield.val() || "";
        const username = sanitizestring(usernameValue);
        const password = passwordValue.replace("'", "''");

        let errors = ""
        // check for blank fields
        if (username == "") {
            errors = "Please provide your username"
            usernamefield.focus()
        } else if (password == "") {
            errors = "Please provide your password"
            passwordfield.focus()
        }

        console.log("Attempting login with:", { username: username, password: password });
        // console.log("errors: ", errors)
        if (errors == "") {
            // console.log("No error")
            loginnotifications.html(showAlert("processing", "Logging you in. Please wait ...", 1))
            $.getJSON(
                "controllers/useroperations.php",
                {
                    loginuser: true,
                    username: username,
                    password: password
                },
                function (data) {
                    console.log("Login Response: ", data)
                    try {
                        if (typeof data === "string") {
                            data = JSON.parse(data);
                        }

                        if (data.status == "success") {
                            // remember the user
                            if (remembermefield.prop("checked")) {
                                const user = { "username": username }
                                const users = JSON.parse(localStorage.getItem('users')) || [];
                                if (users.length == 0) {
                                    users.push(user)
                                    localStorage.setItem('users', JSON.stringify(users));
                                } else {
                                    const user1 = users.find((user) => user.username == username)
                                    if (user1 == undefined || user1.length == 0) {
                                        users.push(user)
                                        localStorage.setItem('users', JSON.stringify(users));
                                    }
                                }
                            }
                            window.location.href = "views/dashboard_v2.php"
                        } else if (data.status == "change password") {
                            window.location.href = "views/changepassword.php"
                        } else if (data.status == "account inactive") {
                            errors = " Account disabled. Contact System Admin"
                            loginnotifications.html(showAlert("info", errors))
                        } else if (data.status == "invalid credentials") {
                            errors = "Invalid username or password"
                            loginnotifications.html(showAlert("info", errors))
                        } else {
                            loginnotifications.html(showAlert("danger", `Sorry an error occurred: ${data.message || 'Unknown error'}`))
                        }
                    } catch (e) {
                        console.error("Login Parse Error:", e, data);
                        loginnotifications.html(showAlert("danger", "Invalid response from server. Check console for details."))
                    }
                }
            ).fail((jqXHR, textStatus, errorThrown) => {
                console.error("AJAX Error:", textStatus, errorThrown);
                loginnotifications.html(showAlert("danger", "Connection to server failed. Please try again."))
            })
        } else {
            loginnotifications.html(showAlert("info", errors))
        }
    })

    pinField.addEventListener("keydown", function (e) {
        if (e.key === "Enter") {
            loginwithpinbutton.trigger("click")
        }
    })

    loginwithpinbutton.on("click", function (e) {
        e.preventDefault()
        console.log("Waiter Login Clicked")
        const username = waiterslist.val() || "";
        const pin = pinField.value || "";
        let errors = ""

        // check for blank fields
        if (username == "" || username == null) {
            errors = "Please select your username"
            waiterslist.focus()
        } else if (pin == "") {
            errors = "Please provide your PIN"
            pinField.focus()
        }

        console.log("Attempting PIN login with:", { username, pin });

        if (errors == "") {
            $.getJSON(
                "controllers/useroperations.php",
                {
                    loginuserbypin: true,
                    username,
                    pin
                },
                (data) => {
                    try {
                        if (typeof data === "string") {
                            data = JSON.parse(data);
                        }

                        if (data.status == "success") {
                            window.location.href = "views/touchscreensale_v2.php"
                        } else if (data.status == "change password") {
                            window.location.href = "views/changepassword.php"
                        } else if (data.status == "account inactive") {
                            errors = " Account disabled. Contact System Admin"
                            waiterloginnotifications.html(showAlert("info", errors))
                        } else if (data.status == "invalid credentials") {
                            errors = "Invalid username or PIN"
                            waiterloginnotifications.html(showAlert("info", errors))
                        } else {
                            waiterloginnotifications.html(showAlert("danger", `Sorry an error occurred: ${data.message || 'Unknown error'}`))
                        }
                    } catch (e) {
                        console.error("PIN Login Parse Error:", e, data);
                        waiterloginnotifications.html(showAlert("danger", "Invalid response from server."))
                    }
                }
            ).fail((jqXHR, textStatus, errorThrown) => {
                console.error("PIN Login AJAX Error:", textStatus, errorThrown);
                waiterloginnotifications.html(showAlert("danger", "Connection to server failed."))
            })
        } else {
            waiterloginnotifications.html(showAlert("info", errors))
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

