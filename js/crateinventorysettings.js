$(document).ready(function(){
    var productdropdown=$("#product"),
        supplierdropdown=$("#supplier"),
        glaccountdropdown=$("#glaccount"),
        costcenterdropdown=$("#costcenter"),
        paymentmodedropdown=$("#paymentmethod"),
        cashbookaccountdropdown=$("#cashbookaccount")
        savebutton=$("#save"),
        errordiv=$("#errors")
        getProductsList().done(function(){
            getSuppliersList().done(function(){
                getGLAccounts().done(function(){
                    getOutlets().done(function(){
                        getCashBookAccounts().done(function(){
                            getPaymentMethods().done(function(){
                                // get settings if available and update controls selections
                                $.getJSON(
                                    "../controllers/settingoperations.php",
                                    {
                                        getcrateinventorysettings:true
                                    },
                                    function(data){
                                        if(data.length>0){
                                            productdropdown.val(data[0].productid)
                                            supplierdropdown.val(data[0].supplierid)
                                            glaccountdropdown.val(data[0].glaccountid)
                                            costcenterdropdown.val(data[0].costcenterid)
                                            paymentmodedropdown.val(data[0].paymentmode)
                                            cashbookaccountdropdown.val(data[0].paymentaccount)
                                        }
                                    }
                                )
                            })
                        })
                    })
                })
            })
        })

    function getProductsList(){
        var dfd= $.Deferred()
        $.getJSON(
            "../controllers/productoperations.php",
                {
                    filterproductbyname:1,
                    name:""
                },
                function(data){
                    var results="<option value=''>&lt;Choose One&gt;</option>"
                    for(var i=0;i<data.length;i++){
                        results+="<option value='"+data[i].productid+"'>"+data[i].itemname+"</option>"
                    }
                    productdropdown.html(results)
                    dfd.resolve()
                }
        )
        return dfd.promise()
    }

    function getSuppliersList(){
        var dfd= $.Deferred()
        $.getJSON(
            "../controllers/getsuppliers.php",
                function(data){
                    var results="<option value=''>&lt;Choose One&gt;</option>"
                    for(var i=0;i<data.length;i++){
                        results+="<option value='"+data[i].supplierid+"'>"+data[i].suppliername+"</option>"
                    }
                    supplierdropdown.html(results)
                    dfd.resolve()
                }
        )
        return dfd.promise()
    }

    function getGLAccounts(){
        var dfd= $.Deferred()
        $.getJSON(
            "../controllers/glaccountoperations.php",
                {
                    getglaccounts:true,
                    groupid:0
                },
                function(data){
                    var results="<option value=''>&lt;Choose One&gt;</option>"
                    for(var i=0;i<data.length;i++){
                        results+="<option value='"+data[i].id+"'>"+data[i].accountname+"</option>"
                    }
                    glaccountdropdown.html(results)
                    dfd.resolve()
                }
        )
        return dfd.promise()
    }

    // get cash book accounts

    savebutton.on("click",function(){
        var productid=productdropdown.val(),
            supplierid=supplierdropdown.val(),
            glaccountid=glaccountdropdown.val(),
            costcenter=costcenterdropdown.val(),
            paymentmode=paymentmodedropdown.val(),
            cashbookaccount=cashbookaccountdropdown.val()
            errors=""
        // check for blank fields
        if(productid==""){
            errors="Please select product first"
            productdropdown.focus()
        }else if(supplierid==""){
            errors="Please select Customer first"
            supplierdropdown.focus()
        }else if(glaccountid==""){
            errors="Please select GL account first"
            glaccountdropdown.focus()
        }else if(costcenter==""){
            errors="Please select refund Cost Center"
            costcenterdropdown.focus()
        }else if(paymentmode==""){
            errors="Please select Refund Payment Mode" 
            paymentmodedropdown.focus()
        }else if(cashbookaccount==""){
            errors="Please select Refund Cash Book Account"
            cashbookaccountdropdown.focus()
        }
       
        if (errors==""){
            errors="<p class='alert alert-info'><i class='fas fa-shipping-fast fa-lg fa-fw'></i></span> Processing. Please wait ... </p>"
            errordiv.html(errors)
            $.post(
                "../controllers/settingoperations.php",
                {
                    savecrateinventorysettings:true,
                    productid:productid,
                    supplierid:supplierid,
                    glaccountid:glaccountid,
                    costcenter:costcenter,
                    paymentmode:paymentmode,
                    cashbookaccount:cashbookaccount
                },
                function(data){
                    str=$.trim(data)
                    console.log(typeof(str))
                    console.log(str)
                    if(str=="success"){
                        errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i> Crate settings saved successfully</p>"
                        errordiv.html(errors)
                        // clear form
                        clearForm()
                    }else{
                        errors="<p  class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i></span> "+str+"</p>"
                        errordiv.html(errors)
                    }
                }
            )
           
        }else{
            errors="<p  class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> "+errors+"</p>"
            errordiv.html(errors)
        }
    })

    function clearForm(){
        productdropdown.val("")
        supplierdropdown.val("")
        glaccountdropdown.val("")
    }

    function getOutlets(){
        dfd=new $.Deferred()
        $.getJSON(
            "../controllers/getpointsofsale.php",
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for(i=0;i<data.length;i++){
                    results+="<option value='"+data[i].id+"'>"+data[i].posname+"</option>"
                }
                costcenterdropdown.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    function getCashBookAccounts(){
        dfd=new $.Deferred()
        $.getJSON(
            "../controllers/glaccountoperations.php",
            {
                getcashbookaccounts:true
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for(i=0;i<data.length;i++){
                    results+="<option value='"+data[i].id+"'>"+data[i].accountname+"</option>"
                }
                cashbookaccountdropdown.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    function getPaymentMethods(){
        dfd=new $.Deferred()
        $.getJSON(
            "../controllers/getpaymentmethods.php",
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for(i=0;i<data.length;i++){
                    results+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
                }
                paymentmodedropdown.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }
})