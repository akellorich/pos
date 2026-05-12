$(document).ready(function(){
    var oldpasswordfield=$("#oldpassword"),
        newpasswordfield=$("#newpassword"),
        confirmnewpasswordfield=$("#confirmnewpassword"),
        errordiv=$("#errors"),
        changepassword=$("#changepassword"),
        idfield=$("#id"),
        errors=''

    // get logged in user
    $.getJSON("../controllers/getactivesession.php",function(data){
        idfield.val(data.toString())
    })

    changepassword.on("click",function(){
        //check for blank fields
        if(oldpasswordfield.val()=="" || newpasswordfield.val==""){
            errors="<p class='alert alert-danger'>Please provide both Old and New passwords!</p>"
            errordiv.html("")
            $(errors).appendTo(errordiv)
        // check if password entries do not match 
        }else if(newpasswordfield.val()!=confirmnewpasswordfield.val()){
            errors="<p  class='alert alert-danger'>New password entries do not match!</p>" 
            errordiv.html("")
            $(errors).appendTo(errordiv)
        }else{
            $.post(
                    '../controllers/changeuserpassword.php',
                    {
                        id:idfield.val(),
                        newpassword:newpasswordfield.val(),
                        oldpassword:oldpasswordfield.val(),
                        changepasswordonlogon:0
                    },
                    function(data){
                        var result=$.trim(data.toString())
                        if (result=="Success"){
                            //window.location.href="main.php?message=Your password has been changed successfully"
                            errors="<p class='alert alert-success'>Your password has been changed successfully</p>" 
                            errordiv.html(errors)
                            oldpasswordfield.val("")
                            newpasswordfield.val("")
                            confirmnewpasswordfield.val("")
                        }else{
                            errors="<p class='alert alert-danger'>"+data+"</p>" 
                            errordiv.html("")
                            $(errors).appendTo(errordiv)  
                        }
                    }
            )
        }
       

       
        













































        // redirect to the main window
    })

})