$(document).ready(function(){
    var supplierid, costcenterid, refundaccountid, cashbookaccountid,paymentmodeid,productid
        paymentmodedropdown=$("#paymentmode"),
        paymentaccountdropdown=$("#paymentaccount"),
        unitpricefield=$("#unitprice"),
        quantityfield=$("#quantity"),
        totalfield=$("#total"),
        errorsdiv=$("#errors"),
        referencefield=$("#reference"),
        paymentmodereferencefield=$("#paymentmodereference")
        savebutton=$("#save")
    
    getPaymentModes().done(function(){
        getCashBookAccount().done(function(){
            // get crate inventory settings parameters
            $.getJSON(
                "../controllers/settingoperations.php",
                {
                    getcrateinventorysettings:true
                },
                function(data){
                    errors=""
                    if(data.length>0){
                        productid=data[0].productid
                        supplierid=data[0].supplierid
                        refundaccountid=data[0].glaccountid
                        costcenterid=data[0].costcenterid
                        paymentmodeid=data[0].paymentmode
                        cashbookaccountid=data[0].paymentaccount
                        //set default payment method and cashbook account
                        paymentmodedropdown.val(paymentmodeid)
                        paymentaccountdropdown.val(cashbookaccountid)
                        unitpricefield.val(data[0].price)
                    }else{
                        //disable change button
                        savebutton.prop("disabled",true)
                        errors="<p class='alert alert-info'><i class='fas fa-exclamation-triangle fa-lg fa-fw'></i> Crate Inventory Settings not set.</p>"
                        errordiv.html(errors)
                    }
                }
            )
        })
    })
    
    function getPaymentModes(){
        dfd=new $.Deferred()
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getpaymentmethods:true
            },
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

    function getCashBookAccount(){
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
                paymentaccountdropdown.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    quantityfield.on("keyup",function(){
        var total=0,
            quantity=quantityfield.val(),
            unitprice=unitpricefield.val()
        if(quantity!="" && unitprice!=""){
            total=parseFloat(quantity)*parseFloat(unitprice)
            totalfield.val(total)
        }else{

        }
    })

    savebutton.on("click",function(){
        var data=[],
            reference=referencefield.val(),
            narration="Crate deposit refund",
            accountcharged=refundaccountid,
            unitprice=unitpricefield.val(),
            quantity=quantityfield.val(),
            paymentmodereference=paymentmodereferencefield.val(),
            voucherdate=new Date(),
            voucherdate=formatDate(voucherdate),
            errors=''
          
        data.push({invoicenumber:reference,description:narration,quantity:quantity,accountcharged:accountcharged,unitprice:unitprice})

        // save the data
        TableData = JSON.stringify(data) 
        console.log(TableData)
        // check for blank fields
        if(quantity==""){
            errors="Please enter quantity first"
            quantityfield.focus()
        }else if(reference==""){
            errors="Please enter purchase receipt number"
            referencefield.focus()
        }
        if(errors==""){
            $.post(
                "../controllers/paymentoperations.php",
                {
                    savepayment:true,
                    TableData: TableData,
                    pos:costcenterid,
                    supplier:supplierid,
                    paymentmode:paymentmodeid,
                    cashbookaccount:cashbookaccountid,
                    reference:paymentmodereference,
                    voucherno:"",
                    generatevoucherno:1,
                    voucherdate:voucherdate,
                    pettycash:1,
                    craterefund:1,
                    id:0

                },function(data){
                    result=$.trim(data.toString())
                    if(result.length==7){
                        errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i> Payment saved successfully. Voucher # : <strong>"+result+"</strong></p>"
                        // clear form
                        clearForm()
                        totalfield.html("0.00")
                        //print the voucher
                        var url ="../printpaymentvoucher.php?voucherid="+result
                        var win = window.open(url, '_blank')
                    }else if(result=='voucher number exists'){
                        errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> Sorry, voucher number is already in use.</p>"
                    }else{
                        errors="<p class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i> "+result+"</p>"
                    }
                    errorsdiv.html(errors)
                }
            ) 
        }else{
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> "+errors+"</p>"
            errorsdiv.html(errors)
        }
    })

    function clearForm(){
        referencefield.val("")
        unitprice=unitpricefield.val("")
        quantity=quantityfield.val("")
        paymentmodereferencefield.val("")
        totalfield.val("")
    }
})