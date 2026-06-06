$(document).ready(function(){
    var glaccountclass=$("#accountclass"),
        glgroupclass=$("#groupclass"),
        subgroupof=$('#subgroupof')
        grouperrordiv=$("#grouperrors"),
        savegroupbutton=$("#savegroup"),
        groupnamefield=$("#groupname"),
        cashbookaccountfield=$("#cashbookgroup"),
        accountgroup=$("#accountgroup"),
        accountsubgroup=$("#accountsubgroup"),
        saveglaccount=$("#savebutton"),
        accountcodefield=$("#accountcode"),
        accountnamefield=$("#accountname"),
        idfield=$("#id"),
        accounterrordiv=$("#accounterrordiv"),
        clearform=$("#clearbutton")
        chartofaccountslist=$("#chartofaccountslist")
        accordion=$(".myaccordion")

     // get all account classes
    function getClassesOfAccount(){
        var dfd = new $.Deferred()
        $.getJSON(
            "../controllers/glaccountoperations.php",
            {
                getglaccountclasses:true
            },
            function(data){
                var results='<option value=0>&lt;Choose One&gt;</option>',
                    accountclasses='',
                    accordionclasses=''
                   
                for(var i=0;i<data.length;i++){ 
                    accordionid=makeid(5)
                    results+="<option value='"+data[i].id+"'>"+data[i].classname+"</option>"
                    accountclasses+="<div class='accountclass' id='"+data[i].id+"'>"
                    accordionclasses+='<div class="card">'
                    accordionclasses+='<div class="card-header" id="'+data[i].classname+'">'
                    accordionclasses+='<h2 class="mb-0">'
                    accordionclasses+='<button class="d-flex align-items-center btn btn-link collapsed" data-toggle="collapse" data-target="#'+accordionid+'" aria-expanded="false" aria-controls="'+accordionid+'" style="text-decoration: none;">'
                    accordionclasses+='<i class="fas fa-plus mr-2 account-toggle-icon" style="font-size: 14px; width: 18px;"></i>'
                    accordionclasses+='<span class="text-uppercase">'+ data[i].newname+'</span>'
                    accordionclasses+='</button>'       
                    accordionclasses+='</h2>'    
                    accordionclasses+='</div>'   
                    accordionclasses+='<div id="'+accordionid+'" class="collapse" aria-labelledby="'+data[i].classname+'" data-parent="#accordion">'   
                    accordionclasses+='<div class="card-body accountclass" data-id="'+data[i].id+'">'   
                    accordionclasses+=' </div>'
                    accordionclasses+='</div>'    
                    accordionclasses+='</div><!-- closes the card -->'
                }
                
                glaccountclass.html(results)
                glgroupclass.html(results)
                //chartofaccountslist.find(".card-body").html(accountclasses)
                accordion.html(accordionclasses)
                dfd.resolve()
            }
        ) 

        return dfd.promise()
    }

    refreshChartOfAccounts()

    function refreshChartOfAccounts(){
            chartofaccountslist.find(".card-body").html("")
            getClassesOfAccount().done(function(){
            getGLParentGroups(0, '').done(function(){
                getSubGroups().done(function(){
                    getGLAccounts()
                })
            })
        })
    }
   


    // get parent accounts
    glgroupclass.on("change",function(){
        var classid=glgroupclass.val()
        getGLParentGroups(classid, subgroupof)
    })

    glaccountclass.on("change",function(){
        var classid=glaccountclass.val()
        getGLParentGroups(classid, accountgroup,'choose')
    })

    accountgroup.on("change",function(){
        var groupid=accountgroup.val()
        getAccountSubGroup(groupid)
    })

    savegroupbutton.on("click",function(){
        var glclassid=glgroupclass.val(),
            glsubaccountid=subgroupof.val(),
            groupname=groupnamefield.val(),
            cashbookaccount,
            errors=''

            cashbookaccountfield.prop("checked")?cashbookaccount=1:cashbookaccount=0

        if(glclassid==0){
            errors="<p class='alert alert-danger'>Please select the group's Class first</p>"
        }else if(groupname==""){
            errors="<p class='alert alert-danger'>Please provide the group name first</p>"
        }

        if(errors==""){
            grouperrordiv.html("<p class='alert alert-info'>Processing....</p>")
            $.post(
                "../controllers/glaccountoperations.php",
                {   
                   
                    saveglaccountgroup:true, 
                    id:0,
                    accountclass:glclassid,
                    groupname:groupname,
                    subcategoryof:glsubaccountid,
                    cashbookaccount:cashbookaccount
                },
                function(data){
                    if($.trim(data).toString()=="exists"){
                        errors="<p class='alert alert-danger'>GL group name already in use. Please correct and try again</p>"
                    }else  if($.trim(data).toString()=="success"){
                        errors="<p class='alert alert-success'>GL group has been saved successfully.</p>"
                        // clear the form 
                        glgroupclass.val(0)
                        subgroupof.val(0)
                        groupnamefield.val("")
                        refreshChartOfAccounts()
                    }
                    grouperrordiv.html(errors)
                }
            )
        }else{
            grouperrordiv.html(errors)
        }
    })

    function getGLParentGroups(classid, dropdown,option='none'){
        var dfd= new $.Deferred()
        $.getJSON(
            "../controllers/glaccountoperations.php",
            {
                classid:classid,
                getglparentgroups:true
            },
            function(data){
                option=='none'?option='&lt;None&gt;':option='&lt;Choose One&gt;'
                var results="<option value=0>"+option+"</option>",results1=''
                    accountclassdiv=$(".accountclass")

                for (var i=0;i<data.length;i++){
                    if(dropdown==''){
                        results="<div class='parentgroup' id='"+data[i].id+"'><span class='parentgroupname font-weight-bold'>"+data[i].groupname+"</span></div>"
                        //accountclass=$("#chartofaccountslist #card-body #"+data[i].glaccountclass)
                        $(".accountclass").each(function(){
                           // console.log($(this).attr("data-id") +" vs "+data[i].glaccountclass)
                            if($(this).attr("data-id")==data[i].glaccountclass){
                                $(results).appendTo($(this))
                            }
                        })
                    }else{
                        results+="<option value='"+data[i].id+"'>"+data[i].groupname+"</option>"
                    }
                }
                if(dropdown!=''){
                    dropdown.html(results)
                }
                dfd.resolve()
               
            }
        ) 
        
        return dfd.promise()
    }

    saveglaccount.on("click",function(){
        var accountgroupid=accountsubgroup.val(),
            accountcode=accountcodefield.val(),
            accountname=accountnamefield.val(),
            id=idfield.val();

        accounterrordiv.html(""); // clear previous desktop alerts

        if(accountgroupid==0){
            showNotification("info", "Please select/provide the account sub group");
            accountsubgroup.focus();
        }else if(accountcode==""){
            showNotification("info", "Please provide the account code");
            accountcodefield.focus();
        }else if(accountname==""){
            showNotification("info", "Please provide the account name");
            accountnamefield.focus();
        }else{
            // Show processing alert on desktop
            if (window.innerWidth >= 992) {
                accounterrordiv.html(showAlert("processing", "Saving GL account, please wait...", 1));
            }
            
            // save the GL account and display results
            $.post(
                "../controllers/glaccountoperations.php",
                {
                    id:id,
                    groupid:accountgroupid,
                    accountcode:accountcode,
                    accountname:accountname,
                    saveglaccount:true
                },
                function(data){
                    var result=$.trim(data).toString();
                    if(result=="success"){
                        showNotification("success", "The GL account has been saved successfully");
                        // clear the form 
                        accountcodefield.val("");
                        accountnamefield.val("");
                        refreshChartOfAccounts();
                    }else if (result=="account code exists"){
                        showNotification("info", "Sorry, account code provided is already in use");
                    }else if (result=="account name exists"){
                        showNotification("info", "Sorry, account name provided is already in use");
                    }else{
                        showNotification("danger", result);
                    }
                }
            );
        }
    })

    // listen to clearform click event
    clearform.on("click",clearForm)

    function clearForm(){
        glaccountclass.val(0);
        accountgroup.html("<option value=0>&lt;Choose One&gt;</option>");
        accountsubgroup.html("<option value=0>&lt;Choose One&gt;</option>");
        accountcodefield.val("");
        accountnamefield.val("");
        idfield.val(0);
        accounterrordiv.html("");
    }

    function getSubGroups(){
        var dfd =new $.Deferred()
        $.getJSON(
            "../controllers/glaccountoperations.php",
            {
                getsubgroups:true,
                groupid:0
            },
            function(data){
                var results
                for(var i=0;i<data.length;i++){
                    results="<div class='subgroup' id='"+data[i].id+"'><span class='subgroupname font-weight-bold'>"+data[i].groupname+"</span></div>"
                    $(".parentgroup").each(function(){
                        if($(this).prop("id")==data[i].subactegoryof){
                             $(results).appendTo($(this))
                        }
                    })
                }

                dfd.resolve() 
            }
        )

       return dfd.promise()
    }

    function getGLAccounts(){
        var dfd=new $.Deferred()
        $.getJSON(
            "../controllers//glaccountoperations.php",
            {
                getglaccounts:true,
                groupid:0
            },
            function(data){
                var results="", count=0
                for(var i=0;i<data.length;i++){
                    count=count+1
                    results="<div class='glaccount' id='"+data[i].id+"'>"+data[i].accountcode +" - "+data[i].accountname+"</div>"
                    $(".subgroup").each(function(){
                        if($(this).prop("id")==data[i].groupid){
                            $(results).appendTo($(this))
                        }
                    })
                }
                chartofaccountslist.find(".card-footer").html(count+" Account(s) displayed.")
            }
        )
    }

    function makeid(length) {
        var result           = '';
        var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        var charactersLength = characters.length;
        for ( var i = 0; i < length; i++ ) {
           result += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        return result;
     }

     accordion.on("hide.bs.collapse show.bs.collapse", e => {
        $(e.target)
          .prev()
          .find(".account-toggle-icon")
          .toggleClass("fa-minus fa-plus");
      })

      accordion.on("shown.bs.collapse", e => {
        $("html, body").animate(
          {
            scrollTop: $(e.target)
              .prev()
              .offset().top
          },
          400
        );
      })

    accordion.on("click", ".glaccount",function(e){
        e.preventDefault()
        var id=$(this).attr("id")
        $.getJSON(
            "../controllers/glaccountoperations.php",
            {
            getglaccountdetails:true,
            id:id
            },
            function(data){
            var classid=data[0].classid,
                groupid=data[0].parentgroupid,
                subgroupid=data[0].subgroupid

            glaccountclass.val(data[0].classid)
            accountcodefield.val(data[0].accountcode)
            accountnamefield.val(data[0].accountname)
            idfield.val(data[0].id)
            
            // get parent groups
            getGLParentGroups(classid, accountgroup,option='one').done(function(){
                accountgroup.val(groupid)
                // get sub groups
                getAccountSubGroup(groupid).done(function(){
                    console.log(subgroupid)
                    accountsubgroup.val(subgroupid)
                })
            })

            }
        )
    })

    function getAccountSubGroup(groupid){
        var dfd = new $.Deferred()
        $.getJSON(
            "../controllers//glaccountoperations.php",
            {
                groupid:groupid,
                getsubgroups:true
            },
            function(data){
                var results="<option value=0>&lt;Choose One&gt;</option>"
                for (var i=0;i<data.length;i++){
                    results+="<option value='"+data[i].id+"'>"+data[i].groupname+"</option>"
                }
                accountsubgroup.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    function showNotification(type, message) {
        var isMobileOrTablet = window.innerWidth < 992;
        var alertHtml = showAlert(type, message);
        
        if (isMobileOrTablet) {
            var modalId = 'notificationModal';
            var modalHtml = `
            <div class="modal fade" id="${modalId}" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content" style="border-radius: 8px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
                        <div class="modal-body p-4">
                            ${alertHtml}
                            <div class="text-right mt-3" style="margin-top: 15px;">
                                <button type="button" class="btn btn-secondary btn-sm" data-dismiss="modal">OK</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>`;
            $('#' + modalId).remove();
            $('body').append(modalHtml);
            $('#' + modalId).modal('show');
        } else {
            accounterrordiv.html(alertHtml);
        }
    }
        
})