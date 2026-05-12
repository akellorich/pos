$(document).ready(function(){

    const userdetailstab=$("#userdetails"),
        roledetailstab=$("#roledetails"),
        userprivileges=$("#userprivileges"),
        roleprivileges=$("#roleprivileges"),  
        userslist=$("#userslist"),
        userroleslist=$("#userroleslist"),
        useridfield=$("#userid"),
        usernamefield=$("#username"),
        passwordfield=$("#password"),
        confirmpasswordfiel=$("#confirmpassword"),
        firstnamefield=$("#firstname"),
        middlenamefield=$("#middlename"),
        lastnamefield=$("#lastname"),
        emailfield=$("#email"),
        mobilefield=$("#mobile"),
        changestatusbutton=$("#changestatusbutton"),
        systemadminbutton=$("#systemadmin"),
        changepasswordonlogonbutton=$("#changepasswordonlogon"),
        accountactivefield=$("#accountactive"),
        saveuserbutton=$("#saveuser"),
        errordiv=$("#errordiv"),
        clearuserbutton=$("#clearuser"),
        rolesdropdown=$("#roles"),
        roleusers=$("#roleusers"),
        saverolebutton=$("#saverole"),
        roleidfield=$("#roleid"),
        rolenamefield=$("#rolename"),
        roledescriptionfield=$("#roledescription"),
        roleerrors=$("#roleerrors"),
        adduserrole=$("#adduserrole"),
        addroleuser=$("#addroleuser"),
        usernonroles=$("#usernonroles"),
        userroleerrors=$("#userroleerrors"),
        saveuserrole=$("#saveuserrole"),
        filterprivileges=$("#filterprivileges"),
        filterroleprivileges=$("#filterroleprivileges"),
        selectalluserprivileges=$("#selectalluserprivileges"),
        selectallroleprivileges=$("#selectallroleprivileges"),
        resetpasswordbutton=$("#changepasswordbutton"),
        nonuseroutlets=$("#usernonoutlets"),
        saveuseroutlet=$("#saveuseroutlet"),
        useroutleterror=$("#useroutleterrors"),
        userouletlist=$("#useroutletslist"),
        pinfield=$("#pin"),
        confirmpinfield=$("#confirmpin"),
        resetuserpinbutton=$("#resetpinbutton"),
        pinresetmodal=$("#pinresetmodal"),
        saveresetuserpinbutton=$("#saveresetuserpin"),
        resetpinnotifications=$("#resetpinnotifications"),
        newpinfield=$("#userresetpin"),
        inputfield=$("input"),
        selectfield=$("select")

    inputfield.on("input",()=>{
        errordiv.html("")
        resetpinnotifications.html("")
        localusernotifications.html("")
    })

    selectfield.on("change",()=>{
        inputfield.trigger("input")
    })

    // get system modules
    getSystemModules()
    // set logged in user
    setLoggedInUserName()
    // hide roles tab details by default
    roledetailstab.hide()
    //get all users
    getUsers()
    // get existing roles
    getRoles()
    // get all objects
    $.getJSON(
        "../controllers/useroperations.php",
        {
            getobjects:true
        },
        function(data){
            var results="<div class='card containergroup mt-2 mb-2'><div class='card-header'><h5>Privileges</h5></div><div class='card-body scrollableprivilege'><table class='table table-sm table-borderless'>"
            for(var i=0;i<data.length;i++){
                results+="<tr data-module='"+data[i].module+"'><td><input type='checkbox' id='"+data[i].id+"' class='checkoption'>&nbsp;&nbsp;"
                results+=data[i].description+"</td></tr>"
            }
            results+="</table> </div> </div>"
            userprivileges.html(results)
            roleprivileges.html(results)
        }
    )

    $('#nav-tab a').click(function (link) {
        selection=link.currentTarget.innerText
        if (selection=="Users"){
            userdetailstab.show()
            roledetailstab.hide()
        }else{
            userdetailstab.hide()
            roledetailstab.show() 
        }
    })

    userslist.on("change",function(){
        var userid=userslist.val()
        errordiv.html("")
        // get users details
        $.getJSON(
            "../controllers/useroperations.php",
            {
                getusersdetails:true,
                userid:userid
            },
            function(data){
                useridfield.val(data[0].id)
                usernamefield.val(data[0].username)
                firstnamefield.val(data[0].firstname)
                middlenamefield.val(data[0].middlename)
                lastnamefield.val(data[0].lastname)
                mobilefield.val(data[0].mobile)
                emailfield.val(data[0].email)
                passwordfield.prop("disabled",true)
                confirmpasswordfiel.prop("disabled",true)
                pinfield.prop("disabled",true)
                confirmpinfield.prop("disabled",true)
                
                // load signature preview 
                if(data[0].signature!=""){
                    signaturepreview.prop("src",data[0].signature)
                }
                // check status and change the caption od change status button as approriate
                if(data[0].accountactive==1){
                    changestatusbutton.html( "Disable User" )
                    accountactivefield.val(1)
                }else{
                    changestatusbutton.html( "Enable User" )
                    accountactivefield.val(0)
                }
                if(data[0].systemadmin==1){
                    systemadminbutton.prop("checked",true)
                }else{
                    systemadminbutton.prop("checked",false)
                }
                if(data[0].changepaswordonlogon==1){
                    changepasswordonlogonbutton.prop("checked",true)
                }else{
                    changepasswordonlogonbutton.prop("checked",false)
                }
            }
        )
        // get user roles
        if(userid!=""){
            $.getJSON(
                "../controllers/useroperations.php",
                {
                    getuserroles:true,
                    userid:userid
                },
                function(data){
                    if(data.length>0){
                        var userroles="<table class='table table-sm'>"
                        for(var i=0;i<data.length;i++){
                            userroles+="<tr class='clickable-row' id='"+data[i].roleid+"'>"
                            userroles+="<td>"+data[i].rolename+"</td>"
                            userroles+="<td class='text-align-right'><a href='javascript void(0)' class='deleteuserrole text-danger' data-id='"+data[i].roleid+"'><span><i class='fas fa-trash-alt fa-lg'></i></span></a></td></tr>"
                        }
                        userroles+="<table>"
                    }else{
                        userroles="<div class='alert alert-info' role='alert'><i class='fas fa-info-circle fa-lg'></i> User assigned to no Role(s).</div>"
                    }
                
                userroleslist.html(userroles)
                }
            )
        }
        // get user non-outlets
        if(userid!=""){
            $.getJSON(
                "../controllers/posoperations.php",
                {
                    getnonuseroutlets:true,
                    userid:userid
                },
                function(data){
                    var results=''
                    for(var i=0;i<data.length;i++){
                        results+="<input type='checkbox' class='"+data[i].id+" useroutlettoadd' id='"+data[i].id+"'>&nbsp;"+data[i].posname+"<br/>"
                    }
                    nonuseroutlets.html(results)
                }
            )
        }
        
        // get user outlets 
        if(userid!=""){
            getuseroutlets(userid)
        }
       
        // get users privileges
        $.getJSON(
            "../controllers/useroperations.php",
            {
                userid:userid,
                getuserprivileges:true
            },
            function(data){
                //remove all checks based on class 
                $(".checkoption").prop("checked",false)
                for(var i=0;i<data.length;i++){
                    // locate the object on the list
                    if(data[i].allowed==1){
                        //$("#"+data[i].objectid).prop("checked",true)
                        $("#userprivileges").find(".checkoption").each(function(){
                            if($(this).prop("id")==data[i].objectid){
                                $(this).prop("checked",true)
                                //data.push({id: id, valid:1})
                            }
                        })
                    }
                }
            }
        )
    })

    saveuserbutton.on("click",function(){
        // check for blank fields
        const userid=useridfield.val(),
            username=sanitizestring(usernamefield.val()),
            password=passwordfield.val().replace("'","''"),
            pin=pinfield.val().replace("'","''"),
            confirmpin=confirmpinfield.val().replace("'","''"),
            confirmpassword=confirmpasswordfiel.val().replace("'","''"),
            firstname=sanitizestring(firstnamefield.val()),
            middlename=sanitizestring(middlenamefield.val()),
            lastname=sanitizestring(lastnamefield.val()),
            mobile=sanitizestring(mobilefield.val()),
            email=sanitizestring(emailfield.val()),
            systemadmin=systemadminbutton.prop("checked")?1:0,
            accountactive=accountactivefield.val()==1?1:0,
            changepasswordonlogon=changepasswordonlogonbutton.prop("checked")?1:0

        let errors='',data=[]
        if(username==""){
            errors="Please provide a <strong>USERNAME</strong>"
            usernamefield.focus()
        }else if(firstname==""){
            errors="Please provide <strong>FIRST NAME</strong></p>"
            firstnamefield.focus()
        }else if(middlename==""){
            errors="Please provide <strong>MIDDLE NAME</strong></p>"
            middlenamefield.focus()
        }else if (password=="" && !passwordfield.prop("disabled")){
            errors="Please provide a <strong>PASSWORD</strong></p>"
            passwordfield.focus()
        }else if(pin=="" && !pinfield.prop("disabled")){
            errors="Please provide <strong> PIN</strong>"
            pinfield.focus()
        }else if(email==""){
            errors="Please provide <strong>EMAIL ADDRESS</strong></p>"
            emailfield.focus()
        }else if(mobile==""){
            errors="Please provide <strong>MOBILE NUMBER</strong></p>"
            mobilefield.focus()
        }else if(password!=confirmpassword && !passwordfield.prop("disabled")){ 
            // check if password entries match
            errors="<strong>PASSWORD</strong> entries do not match</p>"
        }else if(pin!==confirmpin && !pinfield.prop("disabled")){
            errors="<strong>PIN</strong> entries do not match"
        }

        /* get the privileges set */
        $("#userprivileges").find(".checkoption").each(function(){
            if($(this).prop("checked")){
                id=$(this).prop("id")
                data.push({id: id, valid:1})
            }
        })
        
        userroleerrors
        TableData=JSON.stringify(data)

        if(errors==""){ 
            // save the user  
            errordiv.html("<p class='alert alert-info'>Processing...</p>")
           $.post(
               "../controllers/useroperations.php",
               {
                   saveuser:true,
                   userid:userid,
                   username:username,
                   password:password,
                   firstname:firstname,
                   middlename:middlename, 
                   lastname:lastname,
                   email:email,
                   mobile:mobile,
                   systemadmin:systemadmin,
                   changepasswordonlogon: changepasswordonlogon,
                   accountactive:accountactive,
                   pin:pin,
                   TableData:TableData
               },
               function(data){
                   data=$.trim(data)
                   if(data=="Success"){
                    errors="<div class='alert alert-success font-weight-bold' role='alert'><i class='far fa-check-circle fa-lg'></i> User has been saved sucessfully.</div>"
                        //errors="<p class='alert alert-success'>The User has been saved successfully.</p>"
                        // clear the form
                        clearUserForm()
                        // refresh the list
                        getUsers()
                   }else{
                    errors="<div class='alert alert-danger font-weight-bold' role='alert'><i class='far fa-times-circle fa-lg'></i> "+data+"</div>"
                   }
                   errordiv.html(errors)
               }
           )
        }else{
            errors="<div class='alert alert-info' role='alert'><i class='fas fa-info-circle fa-lg'></i> "+errors+"</div>"
            errordiv.html(errors)
        }
    })
    
    clearuserbutton.on("click", clearUserForm)
    
    function clearUserForm(){
        useridfield.val(0)
        usernamefield.val("")
        passwordfield.val("")
        confirmpasswordfiel.val("")
        firstnamefield.val("")
        middlenamefield.val("")
        lastnamefield.val("")
        mobilefield.val("")
        emailfield.val("")
        systemadminbutton.prop("checked",0)
        accountactivefield.val(1)
        changepasswordonlogonbutton.prop("checked",1)
        // reset all issued privileges
        $(".checkoption").prop("checked",false)
        passwordfield.prop("disabled",false)
        confirmpasswordfiel.prop("disabled",false)
        usernamefield.focus()
    }

    function getUsers(){
        // get users list
        $.getJSON(
            "../controllers/useroperations.php",
            {
                getuserslist:true
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for(var i=0;i<data.length;i++){
                    results+="<option value='"+data[i].id+"'>"+data[i].firstname+" "+data[i].middlename+" "+data[i].lastname+"</option>"
                }
                userslist.html(results)
            }
        )
    }

    // listen to change event of any text box
    $("input").on("input",function(){
        errordiv.html("")
        roleerrors.html("")
    })

    function getRoles(){
        $.getJSON(
            "../controllers/useroperations.php",
            {
                getroles:true
            },
            function(data){
                if(data.length>0){
                    var results="<label for='rolelist'>Rolename:</label><select name='roleslist' id='roleslist' class='form-control form-control-sm'><option value=''>&lt;Choose One&gt;</option>"
                    for(var i=0;i<data.length;i++){
                        results+="<option value='"+data[i].roleid+"'>"+data[i].rolename+"</option>"
                    }
                    results+='</select>'
                }else{
                    results="<div class='alert alert-info' role='alert'><i class='fas fa-info-circle fa-lg'></i> No roles defined currently.</div>"
                }
                rolesdropdown.html(results) 
            }
        )
    }

    // listen to click event of roles dop down
    $("body").on("click",'#roleslist',function(){
        //console.log("clicked")
        var roleid=$(this).val()
        if(roleid!=""){
            $.getJSON(
                "../controllers/useroperations.php",
                {
                    getroleusers:true,
                    roleid:roleid
                },
                function(data){
                    if(data.length>0){
                        var results="<p class='font-weight-bold'>Users in the Role:</p><table class='table table-sm'>"
                        for(var i=0;i<data.length;i++){
                            results+="<tr><td id='"+data[i].userid+"'>"+data[i].firstname+" "+data[i].middlename+" "+data[i].lastname+"</td>"
                            results+="<td><a href='javascript void(0)' class='deleteroleuser text-danger'><span><i class='fas fa-trash-alt fa-lg'></i></span></a></td></tr>"
                        }
                        results+="</table>"
                    }else{
                        results="<div class='alert alert-info' role='alert'><i class='fas fa-info-circle fa-lg'></i>&nbsp;&nbsp;Currently no users in the role.</div>"
                    }
                    roleusers.html(results)
                }
            )

            // get role details for editing
            $.getJSON(
                "../controllers/useroperations.php",
                {
                    getroledetails:true,
                    roleid:roleid
                },
                function(data){
                    roleidfield.val(data[0].roleid)
                    rolenamefield.val(data[0].rolename)
                    roledescriptionfield.val(data[0].roledescription)
                }
            )

            // get role privileges
            $.getJSON(
                "../controllers/useroperations.php",
                {
                    getroleprivileges:true,
                    roleid:roleid
                },
                function(data){
                    $("#roleprivileges").find(".checkoption").prop("checked",false)
                    for (var i=0;i<data.length;i++){
                        $("#roleprivileges").find(".checkoption").each(function(){
                            //console.log($(this).prop("id"))
                            if($(this).prop("id")==data[i].objectid){
                               // console.log("Match Found!")
                               if(data[i].allowed==1){
                                   $(this).prop("checked",true)
                               }
                            }
                        })
                    }
                }
            )
        }
    })

    saverolebutton.on("click",function(){
        var roleid=roleidfield.val(),
            rolename=rolenamefield.val(),
            roledescription=roledescriptionfield.val(),
            errors='',
            data=[],
            results
        // check blank fields
        if(rolename==""){
            errors="Please provide <strong>ROLE NAME</strong>"
            rolenamefield.focus()
        }else if(roledescription==""){
            errors="Please provide <strong>ROLE DESCRIPTION</strong>"
            roledescriptionfield.focus()
        }
        if(errors==""){
            // generate selected privileges
            $("#roleprivileges").find(".checkoption").each(function(){
                if($(this).prop("checked")){
                    id=$(this).prop("id")
                    data.push({id: id, valid:1})
                }
            })
            TableData=JSON.stringify(data)
            $.post(
                "../controllers/useroperations.php",
                {
                    saverole:true,
                    rolename:rolename,
                    roledescription:roledescription,
                    roleid:roleid,
                    TableData:TableData
                },
                function(data){
                    data=$.trim(data)
                    if(data==="Success"){
                        results="<div class='alert alert-info' role='alert'><i class='fas fa-check-circle fa-lg'></i> Role has been saved successfully.</div>"
                        // refresh list
                        // clear form
                    }else{
                        results="<div class='alert alert-info' role='alert'><i class='fas fa-times-circle fa-lg'></i> "+data+"</div>"
                    }
                     roleerrors.html(results)
                }
            )
        }else{
            errors="<div class='alert alert-danger' role='alert'><i class='fas fa-exclamation-triangle fa-lg'></i> "+errors+"</div>"
            roleerrors.html(errors)
        }
    })

    adduserrole.on("click",function(){
        // get all roles not belonging to the user
        userid=useridfield.val()
        $.getJSON(
            "../controllers/useroperations.php",
            {
                getusernonroles:true,
                userid:userid
            },
            function(data){
                var results=''
                for(var i=0;i<data.length;i++){
                    results+="<input type='checkbox' class='"+data[i].roleid+" usersrolestoadd'>&nbsp;"+data[i].rolename+"<br/>"
                }
              //console.log(results)
                usernonroles.html(results)
            }
        )
        // hidel all errors and notitications
        userroleerrors.html("")
    })

    saveuserrole.on("click",function(){
        data=[]
        $(".usersrolestoadd").each(function(){
            var roleid,userid=useridfield.val()
            if($(this).prop("checked")){
                roleid=$(this).prop('class').split(' ')[0]
                data.push({roleid: roleid})
            }
        })
        //console.log(data)
        if(data.length>0){
            TableData=JSON.stringify(data)
            $.post(
                "../controllers/useroperations.php",
                {
                    saveuserroles:true,
                    userid:userid,
                    TableData:TableData
                },
                function(data){
                    // check if successful
                    data=$.trim(data)
                    if(data=="success"){
                        results="<div class='alert alert-info' role='alert'><i class='fas fa-check-circle fa-lg'></i> Role(s) added to the user successfully.</div>"
                    }else{
                        results="<div class='alert alert-danger' role='alert'><i class='fas fa-times-circle fa-lg'></i> "+data+"</div>"
                    }
                    userroleerrors.html(results)
                }
            )
        }else{
            results="<div class='alert alert-danger' role='alert'><i class='fas fa-exclamation-triangle fa-lg'></i> Please select a <strong>ROLE</strong> first.</div>"
            userroleerrors.html(results)
        }
    })

    userroleslist.on("click",".deleteuserrole",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id')
        var parent = $(this).parent("td").parent("tr")
        var itemname=parent.find("td").eq(0).text()
        var userid=useridfield.val()
        bootbox.dialog({
            title: "Confirm Role Removal!",
            message: "Remove <strong>"+itemname+"</strong> role from the user?",
            buttons: {
                success: {
                    label: "No, Keep",
                    className: "btn-success",
                    callback: function() {
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Yes, Remove",
                    className: "btn-danger",
                    callback: function() {
                        //console.log(parent)
                        $.post(
                            "../controllers/useroperations.php",
                            {
                                userid:userid,
                                roleid:id,
                                removeuserrole:true
                            },
                            function(data){

                            }
                        )
                        parent.remove()
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    function getSystemModules(){
        var results="<label class='btn btn-secondary btn-sm active  privilegefilter' data-id='all'><input type='radio' name='options'>All Privileges</label>"
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getsystemmodules:true
            },
            function(data){
                for(var i=0;i<data.length;i++){
                    results+="<label class='btn btn-secondary btn-sm privilegefilter' data-id='"+data[i].module+"'><input type='radio' name='options'><span class='text-capitalize'>"+data[i].module+"</span></label>"
                }
                filterprivileges.html(results)
                filterroleprivileges.html(results)
            }
        )
    }
    
    //listen to filter user privileges
    filterprivileges.on("click",".privilegefilter",function(){
        var module=$(this).attr("data-id")
        filterprivileges.find(".privilegefilter").removeClass("active")
        // make the selected button active
        $(this).addClass("active")
        //console.log(module)
        userprivileges.find("tr").each(function(){
            if(module=="all"){
                // show the row
                $(this).show()
            }else{
                //console.log($(this).attr("data-module"))
                if($(this).attr("data-module")==module){
                    // show the module
                    $(this).show()
                }else{
                    // hide the module
                    $(this).hide()
                }
            }
        })
    })

    // listen to filter role privileges
    filterroleprivileges.on("click",".privilegefilter",function(){
        var module=$(this).attr("data-id")
        filterroleprivileges.find(".privilegefilter").removeClass("active")
        // make the selected button active
        $(this).addClass("active")
        //console.log(module)
        roleprivileges.find("tr").each(function(){
            if(module=="all"){
                // show the row
                $(this).show()
            }else{
                //console.log($(this).attr("data-module"))
                if($(this).attr("data-module")==module){
                    // show the module
                    $(this).show()
                }else{
                    // hide the module
                    $(this).hide()
                }
            }
        })
    })
    
    // select or diselect all user privileges
    selectalluserprivileges.on("click",function(){
        //console.log(selectalluserprivileges.prop("checked"))
        userprivileges.find("tr").each(function(){
            if($(this).is(":visible")){
                if(selectalluserprivileges.prop("checked")){
                    $(this).find("input:checkbox:first").prop("checked",true)
                }else{
                    $(this).find("input:checkbox:first").prop("checked",false)
                }
            }
        })
    })

    //listen to select or deselect all role privileges
    selectallroleprivileges.on("click",function(){
        //console.log(selectalluserprivileges.prop("checked"))
        roleprivileges.find("tr").each(function(){
            if($(this).is(":visible")){
                if(selectallroleprivileges.prop("checked")){
                    $(this).find("input:checkbox:first").prop("checked",true)
                }else{
                    $(this).find("input:checkbox:first").prop("checked",false)
                }
            }
        })
    })

    // listen to enable or Disable user account button
    changestatusbutton.on("click",function(){
        var activity="", userid=userslist.val()
        // check if a user is selected
        if(userid!=""){
            if(changestatusbutton.html()=="Disable Account"){
                activity="disable"
                // show dialog box to confirm disable
                bootbox.prompt({
                    title: "Why do you want to disable the account?", 
                    centerVertical: true,
                    callback: function(result){ 
                        //console.log(result); 
                        $.post(
                            "../controllers/useroperations.php",
                            {
                                changeaccountstatus:true,
                                activity:activity,
                                id:userid,
                                reason:result
                            },
                            function(data){
                                data=$.trim(data)
                                if(data=="success"){
                                    results="<div class='alert alert-success' role='alert'><i class='fas fa-check-circle fa-lg'></i> User's account has been <strong>Disabled</strong> successfully.</div>"
                                }else{
                                    results="<div class='alert alert-danger' role='alert'><i class='fas fa-times-circle fa-lg'></i> "+data+"</div>"
                                }
                                errordiv.html(results)
                                // clear the form
                                clearUserForm()
                                userslist.val("")
                            }
                        )
                    }
                })
            }else{
                activity="enable"
                $.post(
                    "../controllers/useroperations.php",
                    {
                        changeaccountstatus:true,
                        activity:activity,
                        id:userid,
                        reason:""
                    },
                    function(data){
                        data=$.trim(data)
                        if(data=="success"){
                            results="<div class='alert alert-success' role='alert'><i class='fas fa-check-circle fa-lg'></i> User's account has ben <strong>Enabled</strong> successfully.</div>"
                        }else{
                            results="<div class='alert alert-danger' role='alert'><i class='fas fa-times-circle fa-lg'></i> "+data+"</div>"
                        }
                        errordiv.html(results)
                        // clear the form
                        clearUserForm()
                        userslist.val("")
                    }
                )
            }
        }else{
            // prompt to select user
            results="<div class='alert alert-info' role='alert'><i class='fas fa-info-circle fa-lg'></i> Please select a User first.</div>"
            errordiv.html(results)
        }
    })

    // listen to reset password button
    resetpasswordbutton.on("click",function(){
        userid=userslist.val()
        bootbox.prompt({
            title: "Please type a RESET password", 
            centerVertical: true,
            inputType: 'password',
            callback: function(result){ 
                if(result){
                    if(result==""){
                        errordiv.html(showAlert("info","Please provide a password"))
                    }else{
                        $.post(
                            "../controllers/useroperations.php",
                            {
                                resetuserpassword:true,
                                password:result,
                                id:userid
                            },
                            function(data){
                                data=$.trim(data)
                                if(data=="success"){
                                    results="User's password has been <strong>RESET</strong> successfully."
                                    errordiv.html(showAlert("success",results))
                                }else{
                                    errordiv.html(showAlert("danger",`Sorry an error occured ${data}`))
                                }
                                // clear the form
                                clearUserForm()
                                userslist.val("")
                            }
                        )
                    }
                }
            }
        })
    })

    saveuseroutlet.on("click",function(){
        var outlets=[]
        $(".useroutlettoadd").each(function(){
            if($(this).prop("checked")){
                outlets.push({id:$(this).attr("id")})
            }
        })
        if(outlets.length==0){
            errors="<div class='alert alert-info' role='alert'><i class='fas fa-info-circle fa-lg'></i> Please select at least an Outlet.</div>"
            useroutleterror.html(errors)
        }else{
            // save the outlets
            var ouletsadded=JSON.stringify(outlets),
            userid=useridfield.val()
            // update the outlets list
            $.post(
                "../controllers/posoperations.php",
                {
                    saveuseroutlet:true,
                    userid:userid,
                    outletid:ouletsadded
                },
                function(data){
                    data=$.trim(data)
                    if(data=="success"){
                        results="<div class='alert alert-success' role='alert'><i class='fas fa-check-circle fa-lg'></i> Outlet successfully assigend to the user.</div>"
                    }else{
                        results="<div class='alert alert-danger' role='alert'><i class='fas fa-times-circle fa-lg'></i> "+data+"</div>"
                    }
                    useroutleterror.html(results)
                }
            )
        }
    })

    function getuseroutlets(userid){
        $.getJSON(
            "../controllers/posoperations.php",
            {
                getuseroutlets:true,
                userid:userid
            },
            function(data){
                var results=""  
                if(data.length>0){
                    var results="<table class='table table-sm'>"
                    for(var i=0;i<data.length;i++){
                        results+="<tr><td id='"+data[i].id+"'>"+data[i].posname+"</td>"
                        results+="<td class='text-align-right'><a href='javascript void(0)' class='deleteuseroutlet text-danger' data-id="+data[i].id+"><span><i class='fas fa-trash-alt fa-lg'></i></span></a></td></tr>"
                    }
                    results+="</table>"
                }else{
                    results="<div class='alert alert-info' role='alert'><i class='fas fa-info-circle fa-lg'></i>&nbsp;&nbsp;Currently no outlets assigned.</div>"
                }
                userouletlist.html(results)
            }
        )
    }

    userouletlist.on("click",".deleteuseroutlet",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id')
        var parent = $(this).parent("td").parent("tr")
        var itemname=parent.find("td").eq(0).text()
        //var userid=useridfield.val()
        bootbox.dialog({
            title: "Confirm Outlet Removal!",
            message: "Remove <strong>"+itemname+"</strong> outlet from the user?",
            buttons: {
                success: {
                    label: "No, Keep",
                    className: "btn-success",
                    callback: function() {
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Yes, Remove",
                    className: "btn-danger",
                    callback: function() {
                        //console.log(parent)
                        $.post(
                            "../controllers/posoperations.php",
                            {
                                id:id,
                                deleteuseroutlet:true
                            },
                            function(data){
                                data=$.trim(data)
                                // refresh users outlets
                                if(data=="success"){
                                    results="<div class='alert alert-success' role='alert'><i class='fas fa-check-circle fa-lg'></i> Outlet <strong>"+itemname+"</strong> has been removed from the user successfully.</div>"
                                }else{
                                    results="<div class='alert alert-danger' role='alert'><i class='fas fa-times-circle fa-lg'></i> "+data+"</div>"
                                }
                                errordiv.html(results)
                                userid=useridfield.val()
                                getuseroutlets(userid)
                            }
                        )
                        parent.remove()
                        $('.bootbox').modal('hide');

                    }
                }
            }
        })
    })

    const specialpermissionsmodal=$("#specialpermissionsmodal"),
        specialpermissionsbutton=$("#specialpermissions"),
        requisitionprivilegestable=$("#requisitionprivilegestable"),
        purchaseorderprivilegestable=$("#purchaseorderprivilegestable"),
        saveuserspecialprivileges=$("#saveuserspecialprivileges"),
        loadsignaturebutton=$("#signaturedocument"),
        signaturepreview=$("#signaturepreview"),
        attachmenterror=$("#attachmenterror")

    // show special permissions
    specialpermissionsbutton.on("click",function(){
        // get requisition privileges
        userid=userslist.val()
        if(userid!=0){
            populaterequsitionprivileges()
            populatepurchaseorderprivileges()
            specialpermissionsmodal.modal("show")
            errordiv.html("")
        }else{
            // display errors
            errordiv.html(showAlert("info","Please select a user first"))
            userslist.focus()
        } 
    })

    function populaterequsitionprivileges(){ 
        var results="<thead><th>&nbsp;</th>",
        // Array to hold requisition privileges that will be iterated through each department 
        columns=[],
        userid=userslist.val()
        // get the requisition privileges
        $.getJSON(
            "../controllers/rawmaterialsoperations.php",
            {
                getrequisitionapprovallevel:true
            },
            function(data){
               for(var i=0;i<data.length;i++){
                   results+=`<th data-id='${data[i].id}' class='text-center'>${data[i].description}</th>`
                   columns.push(data[i].id)
               }
               results+='</thead>'
            }
        ).then( function(){
            // get departments
            results+='<tbody><tr><td>&nbsp;</td>'
            
            // add check boxes that select approval level for all departments below it
            for(i=0;i<columns.length;i++){
                results+=`<td align="center"><input type='checkbox' class='selectalldepartments' data-id=${columns[i]}>` 
            }
            results+='</tr>'

            $.getJSON(
                "../controllers/departmentoperations.php",
                {
                    getdepartments:true
                },
                function(data){
                    for(var i=0;i<data.length;i++){
                        results+=  `<tr><td data-id='${data[i].id}'>${data[i].departmentname}</td>`
                        // add checkboxes for all requisition privileges 
                        for(j=0;j<columns.length;j++){
                            results+=`<td  align="center"><input type='checkbox' class='requisitionprivilege' data-departmentid=${data[i].id} data-approvallevelid=${columns[j]}></td>`
                        }
                        results+=`</tr>`
                    }
                    results+=`</tbody>`
                    requisitionprivilegestable.html(results)
                }
            ).then( function(){
                // get set user privileges
                $.getJSON(
                    "../controllers/useroperations.php",
                    {
                        getuserrequisitionapprovalprivileges:true,
                        userid
                    },
                    function(data){
                        for(var i=0;i<data.length;i++){
                            // loop through checkboxes and match department and privilegeid to check the box if privilege is applicable
                            requisitionprivilegestable.find("input.requisitionprivilege").each(function(){
                                var $this=$(this),
                                    departmentid=$this.attr("data-departmentid"),
                                    approvallevelid=$this.attr("data-approvallevelid")
                                if(departmentid==data[i].departmentid && approvallevelid==data[i].approvallevelid){
                                    $this.prop("checked",true)
                                }
                            })
                        }
                    }
                )
            })
        })
    }

    // check and uncheck all departments when a select all checkbox for a privilege is clicked
    requisitionprivilegestable.on("click",".selectalldepartments",function(){
        var $this=$(this),
            id=$this.attr("data-id")
        if($this.prop("checked")){
            requisitionprivilegestable.find("input").each(function(){
                if($(this).attr("data-approvallevelid")==id){
                    $(this).prop("checked",true)
                }
            })
        }else{
            requisitionprivilegestable.find("input").each(function(){
                if($(this).attr("data-approvallevelid")==id){
                    $(this).prop("checked",false)
                }
            })  
        }
    })

    // save user requisition privileges
    saveuserspecialprivileges.on("click",function(){
        userid=userslist.val()
        // check active tab
        var id=$("#specialprivileges-tab .active").prop("id")
        if(id=="pop1-requisitions" || id=="pop2-purchaseorders") {
            privileges=[],
            poprivileges=[],
            notifications="",
            requisitionprivilegestable.find("input.requisitionprivilege").each(function(){
                var $this=$(this),
                    departmentid=$this.attr("data-departmentid"),
                    approvallevelid=$this.attr("data-approvallevelid"),
                    valid=$(this).prop("checked")?1:0
                privileges.push({"departmentid":departmentid,"approvallevelid":approvallevelid,"valid":valid})
            })

            purchaseorderprivilegestable.find("input.purchaseorderprivilege").each(function(){
                var $this=$(this),
                    departmentid=$this.attr("data-departmentid"),
                    approvallevelid=$this.attr("data-approvallevelid"),
                    valid=$(this).prop("checked")?1:0
                poprivileges.push({"departmentid":departmentid,"approvallevelid":approvallevelid,"valid":valid})
            })

            privileges=JSON.stringify(privileges)
            poprivileges=JSON.stringify(poprivileges)

            $.post(
                "../controllers/useroperations.php",
                {
                    saverequisitionprivilege:true,
                    userid,
                    privileges,
                    poprivileges
                },
                function(data){
                    data=$.trim(data)
                    if(data=="success"){
                        notifications="The privileges have been saved successfully."
                        errordiv.html(showAlert("success",notifications))
                        // hide this modal
                        specialpermissionsmodal.modal("hide")
                    }else{
                        notifications=`Sorry an error occured. ${data}`
                        errordiv.html(showAlert("danger",notifications,1))
                    }
                }
            )
        }else{
            // upload signature
            var fd = new FormData(),
                files = $('#signaturedocument')[0].files[0],
                userid=useridfield.val(),
                errors="",
                results=""
            if(typeof files === 'undefined'){
                errors="Please select signature file to upload first"
            }
            if(errors==""){
                fd.append('userid',userid)
                fd.append('file',files);
                fd.append('uploadsignature','true');

                attachmenterror.html(showAlert("processing", "Uploading Signature. Please Wait ...",1))
                $.ajax({
                    url:  "../controllers/useroperations.php",
                    type: 'post',
                    data: fd,
                    contentType: false,
                    processData: false,
                    success: function(response){
                        if(response =="success"){
                            attachmenterror.html(showAlert("success","Signature uploaded successfully"))
                            // refresh the attachments list
                            $('#signaturefile').val("")
                        }else{
                            results=`Sorry an error occured. ${response}`
                            attachmenterror.html(showAlert("danger",results))
                        }
                    }
                })
            }else{
                attachmenterror.html(showAlert("info",errors))
            }
        }
    })

    // Purchase Order Special Permissions 

    function populatepurchaseorderprivileges(){ 
        var results="<thead><th>&nbsp;</th>",
        // Array to hold requisition privileges that will be iterated through each department 
        columns=[],
        userid=userslist.val()
        // get the purchaseorder privileges
        $.getJSON(
            "../controllers/rawmaterialsoperations.php",
            {
                getpurchaseorderapprovallevel:true
            },
            function(data){
               for(var i=0;i<data.length;i++){
                   results+=`<th data-id='${data[i].id}' class='text-center'>${data[i].description}</th>`
                   columns.push(data[i].id)
               }
               results+='</thead>'
            }
        ).then( function(){
            // get departments
            results+='<tbody><tr><td>&nbsp;</td>'
            
            // add check boxes that select approval level for all departments below it
            for(i=0;i<columns.length;i++){
                results+=`<td align="center"><input type='checkbox' class='selectalldepartments' data-id=${columns[i]}>` 
            }
            results+='</tr>'

            $.getJSON(
                "../controllers/departmentoperations.php",
                {
                    getdepartments:true
                },
                function(data){
                    for(var i=0;i<data.length;i++){
                        results+=  `<tr><td data-id='${data[i].id}'>${data[i].departmentname}</td>`
                        // add checkboxes for all purchaseorder privileges 
                        for(j=0;j<columns.length;j++){
                            results+=`<td  align="center"><input type='checkbox' class='purchaseorderprivilege' data-departmentid=${data[i].id} data-approvallevelid=${columns[j]}></td>`
                        }
                        results+=`</tr>`
                    }
                    results+=`</tbody>`
                    purchaseorderprivilegestable.html(results)
                }
            ).then( function(){
                // get set user privileges
                $.getJSON(
                    "../controllers/useroperations.php",
                    {
                        getuserpurchaseorderapprovalprivileges:true,
                        userid
                    },
                    function(data){
                        for(var i=0;i<data.length;i++){
                            // loop through checkboxes and match department and privilegeid to check the box if privilege is applicable
                            purchaseorderprivilegestable.find("input.purchaseorderprivilege").each(function(){
                                var $this=$(this),
                                    departmentid=$this.attr("data-departmentid"),
                                    approvallevelid=$this.attr("data-approvallevelid")
                                if(departmentid==data[i].departmentid && approvallevelid==data[i].approvallevelid){
                                    $this.prop("checked",true)
                                }
                            })
                        }
                    }
                )
            })
        })
    }

    // check and uncheck all departments when a select all checkbox for a privilege is clicked
    purchaseorderprivilegestable.on("click",".selectalldepartments",function(){
        var $this=$(this),
            id=$this.attr("data-id")
        if($this.prop("checked")){
            purchaseorderprivilegestable.find("input").each(function(){
                if($(this).attr("data-approvallevelid")==id){
                    $(this).prop("checked",true)
                }
            })
        }else{
            purchaseorderprivilegestable.find("input").each(function(){
                if($(this).attr("data-approvallevelid")==id){
                    $(this).prop("checked",false)
                }
            })  
        }
    })

     // preview the signature when a new file is selected
     loadsignaturebutton.on("change",function(){
        if (this.files && this.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                signaturepreview.attr('src', e.target.result);
            }
            reader.readAsDataURL(this.files[0]);
        }
    })

    // reset user pin
    resetuserpinbutton.on("click",()=>{
        const userid=userslist.val()
        if(userid==""){
            errordiv.html(showAlert("info","Please select a user first"))
            userslist.focus()
        }else{
            pinresetmodal.modal("show")
        }
    })

    saveresetuserpinbutton.on("click",function(){
        const pin=sanitizestring(newpinfield.val()),
            userid=userslist.val()
        let errors=""

        if(pin==""){
            errors="Please provide New PIN"
            newpinfield.focus()
            resetpinnotifications.html(showAlert("info",errors))
        }else{
            resetpinnotifications.html(showAlert("processing","Resetting PIN. Please wait ...",1))
            $.post(
                "../controllers/useroperations.php",
                {
                    resetuserpin:true,
                    userid,
                    pin
                },
                (data)=>{
                    if(isJSON(data)){
                        data=JSON.parse(data)
                        if(data.status=="success"){
                            pinresetmodal.modal("hide")
                            errordiv.html(showAlert("success",`User's PIN reset successfully`))
                        }
                    }else{
                        resetpinnotifications.html(showAlert("danger",`Sorry an error occured ${data}`))
                    }
                }
            )
        }
    })

    // Manage Local users
    const localuserdetailsmodal=$("#localuserdetailsmodal"),
        addlocaluserbutton=$("#addlocaluser"),
        selectlocaluserfield=$("#localusername"),
        selectlocaluserdatabase=$("#defaultdatabase"),
        localusernotifications=$("#localusernotifications"),
        savelocaluserbutton=$("#savelocaluser"),
        localuserslist=$("#localuserslist")

    // get existing local users
    getlocalusers()

    addlocaluserbutton.on("click",()=>{

        localusernotifications.html("")
        localuserdetailsmodal.modal("show")
        getdatabases(selectlocaluserdatabase)

        // get system users
        $.getJSON(
            "../controllers/useroperations.php",
        {
            getuserslist:true
        },
        function(data){
            let results
            results="<option value=''>&lt;Choose&gt;</option>"
            data.forEach((data)=>{
                results+=`<option value='${data.username}'>${data.firstname} ${data.middlename} ${data.lastname}</option>`
            })
            selectlocaluserfield.html(results)
        })
    })

    function getdatabases(obj,option='choose'){
        const databases = JSON.parse(localStorage.getItem('databases')) || []   
        let  results="<option value=''>&lt;Choose&gt;</option >"
        databases.forEach(({outletname,database})=>{
            results+=`<option value='${database}'>${outletname}</option>`
        })
        obj.html(results)

    }

    // Save local user
    savelocaluserbutton.on("click",()=>{
        const username=selectlocaluserfield.val(),
            defaultdatabase=selectlocaluserdatabase.val()
        let errors=""
        if(username==""){
            errors="Please select a user from the list first"
        }else if(defaultdatabase==""){
            errors="Please select user branch first"
        }

        if(errors==""){            
            const user={"username":username,"company":defaultdatabase}
            //  get locally stored users
            const users = JSON.parse(localStorage.getItem('users')) || []            
            if(users.length==0){
                // add user to the list
                users.push(user)
                localStorage.setItem('users', JSON.stringify(users));
            }else{
                // check if user exits
                const user1=users.find((user)=>user.username==username)
                // add user to the list
                if(user1==undefined || user1.length==0 ){
                    users.push(user)
                    // Save the updated array back to local storage
                    localStorage.setItem('users', JSON.stringify(users));
                }
            }
            localusernotifications.html(showAlert("success",`User saved successfully in the local machine`))
            // refresh list
            getlocalusers()
        }else{
            localusernotifications.html(showAlert("info",errors))
        }
    })

    function getlocalusers(){
        const users=JSON.parse(localStorage.getItem('users')) || []  
        let results="<table class='table table-sm'>"
        if(users.length>0){
            users.forEach((user)=>{
                results+=`<tr id='${user.username}'><td >${titleCase(user.username)}</td>`
                results+=`<td>${user.company}</td>`
                results+=`<td class='text-align-right'><a href='#' class='deletelocaluser text-danger'><i class='fas fa-trash-alt fa-lg'></i></a></td></tr>`
            })
            results+="</table>"
            localuserslist.html(results)
        }else{
            results=showAlert("info",`No users currently saved locally`)
        }
    }

    localuserslist.on("click",".deletelocaluser",function(){
        const row=$(this).closest("tr"),
            userid=row.attr("id"),
            username=row.find("td").eq(0).text()
        // confirm with bootbox
        bootbox.dialog({
            title: "Confirm user deletion!",
            message: `Permanently delete user <strong>${username}</strong> from local storage?`,
            buttons: {
                success: {
                    label: "No, Keep",
                    className: "btn-success btn-sm",
                    callback: function() {
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Yes, Remove",
                    className: "btn-danger btn-sm",
                    callback: function() {
                        //console.log(parent)
                        const users=JSON.parse(localStorage.getItem('users')),
                        newusers=users.filter(user=>user.username!==userid),
                        undeletedusers=[]
                        newusers.forEach(({username,company})=>{
                            undeletedusers.push({"username":username,"company":company})
                        })
                        // update the local storage
                        localStorage.setItem('users',JSON.stringify(undeletedusers))
                        // refresh the list
                        getlocalusers()
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })
})