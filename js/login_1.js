$(document).ready(function () {
    var usernamefield = $("#inputEmail"),
        passwordfield = $('#inputPassword'),
        loginbutton = $("#loginbutton"),
        errordiv = $("#errordiv")
    loginbutton.on("click", function () {
        //console.log("Logon button clicked")
        var username = usernamefield.val(),
            password = passwordfield.val()
        errors = ""
        if (username == "") {
            errors = "<p class='alert alert-secondary alert-sm'>Please provide username</p>"
        } else if (password == "") {
            errors = "<p class='alert alert-secondary alert-sm'>Please provide password</p>"
        }
        //console.log(errors)
        if (errors == "") {
            $.post(
                "controllers/useroperations.php",
                {
                    loginuser: true,
                    username: username,
                    password: password
                },
                function (data) {
                    data = $.trim(data)
                    //console.log(data)
                    if (data == "success") {
                        window.location.href = "views/main.php"
                    } else if (data == "change password") {
                        window.location.href = "views/changepassword.php"
                    } else if (data == "account inactive") {
                        errors = "<div class='alert alert-info font-weight-bold' role='alert'><i class='fas fa-info-circle'></i> Account disabled.</div>"
                    } else if (data == "invalid credentials") {
                        errors = "<div class='alert alert-danger font-weight-bold' role='alert'><i class='fas fa-exclamation-triangle'> </i> Invalid credentials.</div>"
                    }
                    if (errors != "") {
                        errordiv.html(errors)
                    }
                }
            )
        } else {
            errordiv.html(errors)
        }
    })

    usernamefield.on("input", function () {
        errordiv.html("")
    })

    passwordfield.on("input", function () {
        errordiv.html("")
    })
})