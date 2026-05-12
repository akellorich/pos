$(document).ready(function(){
    $.ajaxSetup({ cache: false })	
    var companylist=$("#unit")
    var logon=$("#logon")
    var notices=$("#notices")
    var notice=""
    var errordiv=$("#logonerrormessages")
    var errorsanchor=$("#errors")
    var closebutton=$("#okbutton")
    //var unitoptions=$("#unitoptions")
    var usernamefield=$("#username")
    var passwordfield=$("#password")
    
    // show full year under copyright field
    const yearfield=$("#year")
    date= new Date()
    yearfield.html(date.getFullYear())

    // start by all fields being blank
    usernamefield.val("")
    passwordfield.val("")

    // get companies
    $.getJSON(
        "../controllers/getcompanydetails.php",
        function(data){
            var results='<option value="">&lt;Choose One&gt;</option>'
            for(var i=0;i<data.length;i++){
                results+="<option value='"+data[i].database+"'>"+data[i].outletname+"</option>"
            }
            companylist.html(results)
            //refresh company list to reflect the items
            companylist.selectmenu("refresh", true)
            //console.log(results)
        }
    ) 

    // count items in the company drop down and hide if it's only one
    //console.log($('#unit option').size())
    /*if($('#unit option').size()==1){
        // hide the option
        unitoptions.hide()
    }else{
        // add choose one and set its value as the current
            $("<option value=''>&lt;Choose One&gt;</option>").appendTo(unit)
            unit.val("")
    }
    */
    logon.on("click",function(){
        var username=usernamefield.val()
        var password=passwordfield.val()
        var databasename=companylist.val()
        
        if(username!="" && password!="" && databasename!=""){	
            $.post(
                "../controllers/useroperations.php",
                {
                    loginuser:true,
                    username:username,
                    password:password,
                    company:databasename
                },
                function(data){
                    // data=$.trim(data)
                    //console.log(data)
                    if(isJSON(data)){
                        data=JSON.parse(data)
                        console.log(data)
                        if (data.status=="success"){
                            window.location.href="views/main.php"
                        }else if (data.status=="change password"){
                            window.location.href="views/main.php"//"views/changepassword.php"
                        }else if(data.status=="account inactive"){
                            notice="<p>Account disabled. Contact System Administrator</p>"
                            displayMessage(notice)
                        // errors="<div class='alert alert-info font-weight-bold' role='alert'><i class='fas fa-info-circle'></i> Account disabled.</div>"
                        }else if(data.status=="invalid credentials"){
                            notice="<p>Incorrect Username or Password</p>"
                            displayMessage(notice)
                            //errors="<div class='alert alert-danger font-weight-bold' role='alert'><i class='fas fa-exclamation-triangle'> </i> Invalid credentials.</div>"
                        }
                    }else{
                        notice="<p>Unexpected error occurred. Please try again later.</p>"
                    }
                    
                    /*if(errors!=""){
                       
                    }*/
                }
            )
            //notice="<p>Processing request. Please wait<p>"
            // remove current notices
            //notices.find("p").remove()
            // append new one showing progress
            //$(notice).appendTo(notices)				
           /* var url="process.php?request=logon&username="+username+"&password="+password+"&databasename="+databasename
            //console.log(url)
            $.getJSON(url,function(data){
                notice=data.toString()
                //alert(notice)
                console.log(notice)
                if(notice==="success"){
                    window.location.href="main.php"
                }else{
                    notice="<p>"+notice+"</p>"
                    errordiv.find("p").remove()
                    //$(notice).appendTo(notices)
                    //errordiv.val()
                    $(notice).appendTo(errordiv)
                    // trigger anchor click event to display the error
                    errorsanchor.click()
                }
            })*/
        }else{
            //alert("error occured")
            notice="<p>Please provide <strong>Username</strong>, <strong>Password</strong> and <strong>Company</strong>.</p>"
            errordiv.find("p").remove()
            $(notice).appendTo(errordiv)
            errorsanchor.click()
            //console.log(errorsanchor.attr("href"))
        }
    })

    function displayMessage(message){
        notice="<p>"+message+"</p>"
        errordiv.find("p").remove()
        $(notice).appendTo(errordiv)
        // trigger anchor click event to display the error
        errorsanchor.click()
    }

    closebutton.on("click",function(){
        window.history.back()
    })

})