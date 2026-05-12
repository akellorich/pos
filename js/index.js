 
 $(document).ready(()=>{
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

    const companylist=$("#usercompany"),
        waitercompanieslist=$("#waitercompanies"),
        loginbutton=$("#userlogin"),
        loginnotifications=$("#userloginnotifications"),
        usernamefield=$("#userusername"),
        passwordfield=$("#userpassword"),
        remembermefield=$("#rememberMe"),
        inputfield=$("input"),
        selectfield=$("#"),
        waiterslist=$("#waiterslist"),
        loginwithpinbutton=$("#loginwithpin"),
        waiterloginnotifications=$("#waiterloginnotifications"),
        waiterloginform=$("#waiter-login-tab"),
        logofield=$("#companylogo")

    getloginuisettings().done((data)=>{
        console.log("Login UI Settings: ", data) 
        // load logo
        logofield.attr("src",data.logo)
        if(data.showwaiterlogin==1){
            waiterloginform.show()
        }else{
            waiterloginform.hide()
        }
    })
   
    inputfield.on("input",()=>{
        loginnotifications.html("")
        waiterloginnotifications.html("")
    })

    selectfield.on("change",()=>{
        inputfield.trigger("input")
    })

    getcompanies().done(()=>{
        const users = JSON.parse(localStorage.getItem('users')) || []
        let results="<option value=''>&lt;Choose&gt;</option>"

        users.forEach((user)=>{
            results+=`<option value='${user.username}'>${user.username}</option>`
        })
        waiterslist.html(results)
    })

    // get all existing local users
    function getcompanies(){
        const dfd=$.Deferred()
         // load all the databases locally
        const database=[] 
        // const databases = JSON.parse(localStorage.getItem('databases')) || [];
         
        $.getJSON(
            "controllers/getcompanydetails.php",
            function(data){
                var results='<option value="">&lt;Choose One&gt;</option>'
                data.forEach((company)=>{
                    results+="<option value='"+company.database+"'>"+company.outletname+"</option>"
                    database.push({"outletname":company.outletname,"database":company.database})
                   
                })

                localStorage.setItem('databases', JSON.stringify(database));
    
                companylist.html(results)
                waitercompanieslist.html(results)
                dfd.resolve()
            }
        ) 
        return dfd.promise()
    }


    // get users comnpany
    waiterslist.on("change",function(){
        const username=$(this).val()
        const users = JSON.parse(localStorage.getItem('users')) || []
        const user=users.filter((user)=>user.username==username)
        if(user.length>0){
            waitercompanieslist.val(user[0].company)
            pinField.focus()
        }else{
            waitercompanieslist.val("")
        }
        
    })

    loginbutton.on("click",(e)=>{
        e.preventDefault()
        const username=sanitizestring(usernamefield.val()),
            password=passwordfield.val().replace("'","''"),
            companyid=companylist.val()
        let errors=""
        // check for blank fields
        if(username==""){
            errors="Please provide your username"
            usernamefield.focus()
        }else if(password==""){
            errors="Please provide your password"
            passwordfield.focus()
        }else if(companyid==""){
            errors="Please select your branch"
            companylist.focus()
        }

        if(errors==""){
            loginnotifications.html(showAlert("processing","Logging you in. Please wait ...",1))
            $.getJSON(
                "controllers/useroperations.php",
                {
                    loginuser:true,
                    username:username,
                    password:password,
                    company:companyid
                },
                function(data){
                    // data=$.trim(data)
                    //console.log(data)
                    if (data.status=="success"){
                        // remember the user
                        if(remembermefield.prop("checked")){                           
                            const user={"username":username,"company":companyid}
                            const users = JSON.parse(localStorage.getItem('users')) || [];
                            if(users.length==0){
                                users.push(user)
                                localStorage.setItem('users', JSON.stringify(users));
                            }else{
                               
                                const user1=users.find((user)=>user.username==username)
                              
                                if(user1==undefined || user1.length==0 ){
                                    users.push(user)
                                    // Save the updated array back to local storage
                                    localStorage.setItem('users', JSON.stringify(users));
                                }
                            }
                        } 
                        window.location.href="views/dashboard_v2.php"
                    }else if (data.status=="change password"){
                        window.location.href="views/changepassword.php"
                    }else if(data.status=="account inactive"){
                        errors=" Account disabled. Contact System Admin"
                        loginnotifications.html(showAlert("info",errors))
                    }else if(data.status=="invalid credentials"){
                        errors="Invalid username or password"
                        loginnotifications.html(showAlert("info",errors))
                    }else{
                        errordiv.html(`Sorry an error occured ${data}`)
                    }
                }
            )
        }else{
            loginnotifications.html(showAlert("info",errors)) 
        }
    })

    pinField.addEventListener("keydown",function(e){
        if(e.key==="Enter"){
            loginwithpinbutton.trigger("click")
        }
    })

    loginwithpinbutton.on("click",function(e){
        e.preventDefault()
        console.log("Waiter Login Clicked")
        const username=waiterslist.val(),
            company=waitercompanieslist.val(),
            pin=pinField.value
        let errors=""

        // check for blank fields
        if(username==""){
            errors="Please select your username"
            waiterslist.focus()
        }else if(company==""){
            errors="Please select your branch"
            waitercompanieslist.focus()
        }else if(pin==""){
            errors="Please provide your PIN"
            pinField.focus()
        }

        if(errors==""){
            $.getJSON(
                "controllers/useroperations.php",
                {
                    loginuserbypin:true,
                    username,
                    pin,
                    company
                },
                (data)=>{
                    // data=data[0]
                    if (data.status=="success"){
                        window.location.href="views/touchscreensale_v2.php"
                    }else if (data.status=="change password"){
                        window.location.href="views/changepassword.php"
                    }else if(data.status=="account inactive"){
                        errors=" Account disabled. Contact System Admin"
                        waiterloginnotifications.html(showAlert("info",errors))
                    }else if(data.status=="invalid credentials"){
                        errors="Invalid username or password"
                        waiterloginnotifications.html(showAlert("info",errors))
                    }else{
                        waiterloginnotifications.html(showAlert("danger",`Sorry an error occured ${data}`))
                    }
                }
            )
        }else{
            waiterloginnotifications.html(showAlert("info",errors))
        }
    })
 })
 
