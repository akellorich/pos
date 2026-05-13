$(document).ready(function(){
   // alert("jquery is running")
    $("#accountexpirydate").datepicker({dateFormat: 'dd-M-yy'})
    
    var savebutton=$("#save"),
        idfield=$("#userid"),
        usernamefield=$("#username"),
        firstnamefield=$("#firstname"),
        middlenamefield=$("#middlename"),
        othernamesfield=$("#othernames"),
        passwordfield=$("#password"),
        password1field=$("#password_1"),
        mobilefield=$("#mobile"),
        emailfield=$('#email'),
        accoutexpiresfield=$("#accountexpires"),
        accountexpiresdatefield=$("#accountexpirydate"),
        profilephoto_input=$("#profilephoto"),
        profile_preview=$("#profile_preview")
        accountexpires=0,
        accountexpirydate='',
        errors='',
        errordiv=$("#errors"),
        errordiv1=$("#errors1"),
        changepasswordonlogonfield=$("#changepasswordonlogon"),
        clearbutton=$("#clear"),
        privileges=$("#privilegeitems"),
        selectall=$("#selectall"),
        saveprivileges=$("#saveprivileges")
    // get privileges
    getPrivileges('')
    
    // profile photo preview
    profilephoto_input.on("change", function(){
        const file = this.files[0];
        if (file) {
            let reader = new FileReader();
            reader.onload = function(event){
                profile_preview.attr('src', event.target.result);
            }
            reader.readAsDataURL(file);
        }
    });

    savebutton.on("click",function(){
        errors=''
        // validate blank fields
        if(usernamefield.val()=="") {
            errors="<p class='alert alert-danger'>Please provide <strong>Username</strong></p>"
        }else if(firstnamefield.val()=="") {
            errors="<p class='alert alert-danger'>Please provide <strong>Firstname</strong></p>"
        }else if(middlenamefield.val()=="") {
            errors="<p class='alert alert-danger'>Please provide <strong>Middlename</strong></p>"
        }else if(passwordfield.val()==""){
           errors="<p class='alert alert-danger'>Please provide <strong>Password</strong></p>" 
        }else if(mobilefield.val()=="") {
           errors="<p class='alert alert-danger'>Please provide <strong>Mobile number</strong></p>"  
        } else if(emailfield.val()=="") {
            errors="<p class='alert alert-danger'>Please provide <strong>Email</strong></p>"
        }  

        // check account expiry
        if(!accoutexpiresfield.prop('checked')){
            accountexpires=0
            acountexpirydate='2100-01-01'
        }else{
            accountexpires=1
            if (accountexpiresdatefield.val()!=""){
                acountexpirydate=accountexpiresdatefield.val()
            }else{
                errors="<p class='alert alert-danger'>Please provide <strong>Account expiry date</strong></p>"
            }
        }
        
        // check if pasword change on logon has been selected
        if(changepasswordonlogonfield.prop("checked")){
            changepasswordonlogon=1
        }else{
            changepasswordonlogon=0
        }

        // check if passwords compare
        if(passwordfield.val()!=password1field.val()){
            errors="<p class='alert alert-danger'><strong>Password entries do not match</strong></p>"
        }
        
        //console.log(errors)

        if (errors!=""){
            errordiv.html(errors)
        }else{
            // save the user   
            errordiv.html("<p class='alert alert-info'>Saving user. Please wait ...</p>")
            
            var formData = new FormData();
            formData.append('id', idfield.val());
            formData.append('username', usernamefield.val());
            formData.append('firstname', firstnamefield.val());
            formData.append('middlename', middlenamefield.val());
            formData.append('othernames', othernamesfield.val());
            formData.append('password', passwordfield.val());
            formData.append('changepassswordonlogon', changepasswordonlogon);
            formData.append('accountexpires', accountexpires);
            formData.append('accountexpireson', acountexpirydate);
            formData.append('email', emailfield.val());
            formData.append('mobile', mobilefield.val());
            formData.append('saveuser', 'POST');
            
            if(profilephoto_input[0].files.length > 0){
                formData.append('profilephoto', profilephoto_input[0].files[0]);
            }

            $.ajax({
                url: "../controllers/saveuser.php",
                type: "POST",
                data: formData,
                contentType: false,
                processData: false,
                success: function(data){
                    if($.trim(data.toString())=="Success"){
                        errors="<div class='alert alert-success'>The User has been saved in the system successfully<button type='button' class='close' data-dismiss='alert'>&times;</button></div>"
                        // clear the form
                        clearForm()
                    }else{
                        errors="<div class='alert alert-danger'>"+data+"<button type='button' class='close' data-dismiss='alert'>&times;</button></div>"
                    }                        
                    errordiv.html(errors)
                }
            });
        }
    })

    // check if we are on edit mode
    if(idfield.val()>0){
        $.getJSON(
           "../controllers/useroperations.php",
           {
               getuserdetails:true,
               userid:idfield.val()
           },
           function(data){
                usernamefield.val(data[0].username)
                firstnamefield.val(data[0].firstname)
                middlenamefield.val(data[0].middlename)
                othernamesfield.val(data[0].lastname)
                //data.password=passwordfield.val(),
                accountexpiresdatefield.val(data[0].accountexpireson)
                //data.password=passwordfield.val(),
                emailfield.val(data[0].email)
                mobilefield.val(data[0].mobile)
                if(data[0].profilephoto && data[0].profilephoto != ''){
                    profile_preview.attr('src', '../images/user_profiles/' + data[0].profilephoto)
                }else{
                    profile_preview.attr('src', '../images/blankavatar.jpg')
                }
           }
        )
    }
    
    // function to clear the form
    function clearForm(){
        idfield.val("0")
        usernamefield.val("")
        firstnamefield.val("")
        middlenamefield.val("")
        othernamesfield.val("")
        passwordfield.val("")
        password1field.val("")
        emailfield.val("")
        mobilefield.val("") 
        profile_preview.attr('src', '../images/blankavatar.jpg')
        profilephoto_input.val('')
        usernamefield.focus()
    }

    clearbutton.on("click",clearForm)

    function getPrivileges($module){
        deferred= new $.Deferred()
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getprivileges:"GET",
                module:$module
            },
            function(data){
                var results='<div class="row">'
                results+='<div class="col-md-6">'
                results+='<div class="card" style="margin:10px 0">'
                results+='<ul class="list-group list-group-flush scrollableprivilege">'                       
                for(var i=0;i<data.length;i++){
                    results+='<li class="list-group-item">'
                    results+=data[i].description
                    results+='<label class="checkbox">'
                    results+='<input type="checkbox" name="privileges[]" class="privilege" id='+data[i].id+' value="'+data[i].id+'"/>'
                    results+='<span class="default"></span>'    
                    results+='</label>'       
                    results+='</li>'   
                }

                results+='</ul>'
                results+='</div>'
                results+='</div>'
                results+='</div>'
                //console.log(results)
                privileges.html(results)
                deferred.resolve()
                return deferred.promise()
            }
        )
    }

    selectall.on("click",function(){
        if(selectall.prop('value')=="Select All"){
            $(".privilege").prop('checked', true)
            selectall.prop('value','Unselect All')
        }else{
            $(".privilege").prop('checked', false)
            selectall.prop('value','Select All')
        }
    })

    function getSetPrivileges(){
        var privileges=""
        $('.privilege').each(function(i){
            // assign a variable to the object
            // console.log($(this))
			checkbox=$(this)
			objectid=checkbox.attr("id")
			if(checkbox.prop('checked')){
				valid=1
			}else{					
				valid=0
			}
			newprivilege=objectid+"::"+valid
			privileges==''?privileges=newprivilege:privileges+=","+newprivilege
        })
        return privileges
    }

    saveprivileges.on("click",function(){
        $.post(
            "../controllers/useroperations.php",
            {
                saveuserprivileges:true,
                userid:idfield.val(),
                privileges:JSON.stringify(getSetPrivileges())
            },
            function(data){
                str=$.trim(data.toString())
                if(str=="Success"){
                    errors="<p class='alert alert-success'>User privileges updated successfully</p>"
                }else{
                    errors="<p class='alert alert-danger'>"+str+"</p>"
                }
                errordiv1.html(errors)
            }
        )
    })
})