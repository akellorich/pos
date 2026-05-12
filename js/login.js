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
                    var result=data.toString()
                    if(result=="Success"){
                        window.location.href="views/main.php"
                    }else if (result=="Change password"){
                        window.location.href="views/changepassword.php"
                    }else{
                        errors="<div class='alert alert-danger' role='alert'>"+result+"</div>"
                        errordiv.html("")
                        $(errors).appendTo(errordiv)
                    }
                } 
            )
        }

        return false;
    })
    
  
})