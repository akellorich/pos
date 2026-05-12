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
                    accordionclasses+='<button class="d-flex align-items-center justify-content-between btn btn-link collapsed" data-toggle="collapse" data-target="#'+accordionid+'" aria-expanded="false" aria-controls="'+accordionid+'">'
                    accordionclasses+='<span class="text-uppercase">'+ data[i].newname+'</span>'
                    accordionclasses+='<span class="fa-stack fa-sm">'        
                    accordionclasses+='<i class="fas fa-circle fa-stack-2x"></i>'            
                    accordionclasses+='<i class="fas fa-plus fa-stack-1x fa-inverse"></i>'            
                    accordionclasses+='</span>'       
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
            id=idfield.val(),
            errors=""
        if(accountgroupid==0){
            errors="<p class='alert alert-danger'>Please provide the account sub group</p>"
        }else if(accountcode==""){
            errors="<p class='alert alert-danger'>Please provide the account code</p>" 
        }else if(accountname==""){
            errors="<p class='alert alert-danger'>Please provide the account name</p>"
        }else{
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
                    result=$.trim(data).toString()
                    //console.log(result)
                    if(result=="success"){
                        errors="<p class='alert alert-success'>The GL account has been saved successfully</p>"
                        // clear the form 
                        accountcodefield.val("")
                        accountnamefield.val("")
                        refreshChartOfAccounts()
                    }else if (result=="account code exists"){
                        errors="<p class='alert alert-warning'>Sorry, <strong>account code</strong> provided is already in use</p>"
                    }else if (result=="account name exists"){
                        errors="<p class='alert alert-warning'>Sorry, <strong>account name</strong> provided is already in use</p>"
                    }else{
                        // display any other error resturned
                        errors="<p class='alert alert-danger'>"+result+"</p>"
                    }
                    accounterrordiv.html(errors)
                }
            )
        }
        accounterrordiv.html(errors)
    })

    // listen to clearform click event
    clearform.on("click",clearForm)

    function clearForm(){
        accountsubgroup.val(0),
        accountcodefield.val(""),
        accountnamefield.val(0),
        idfield.val(0)
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
          .find("i:last-child")
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
        
})