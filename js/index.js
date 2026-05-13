
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
})

