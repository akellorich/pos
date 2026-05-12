$(document).ready(function(){
    var vouchernofield=$("#voucherno"),
        voucherdatefield=$("#voucherdate"),
        costcenterfield=$("#costcenter"),
        supplierfield=$("#supplier"),
        paymentmodefield=$("#paymentmode"),
        payfromfield=$("#payfrom"),
        autogenerate=$("#autogenerate"),
        accountchargedfield=$("#accountcharged"),
        addbutton=$("#additem"),
        itemslist=$("#itemslist"),
        referencefield=$("#reference"),
        narrationfield=$("#narration"),
        amountfield=$("#amount"),
        errorsdiv=$("#errors"),
        totalfield=$("#totalfield"),
        savevoucherbutton=$("#savevoucher"),
        generatevouchernofield=$("#autogenerate"),
        idfield=$("#idfield"),
        paymentmodereferencefield=$("#referencenumber"),
        clearbutton=$("#clearvoucher")

    autogenerate.prop("checked",true)
    vouchernofield.prop("disabled",true)
    // totalfield.html("12345.00")
    // set the datepicker field
    voucherdatefield.datepicker({maxDate: new Date(),dateFormat: 'dd-M-yy'})
    //$.datepicker.setDefaults({})


    // get voucher parameters
    getDropdownListValues().done(function(){
        if(urlParam("id")!=""){
            // get voucher details
            id=urlParam("id")
            $.getJSON(
                "../controllers/paymentoperations.php",
                {
                    getvoucherdetails:true,
                    id:id
                }, function(data){
                    // check if status is pending to allow the operation
                    if(data[0].status=='Pending'){
                         // populate fields
                        idfield.val(data[0].id)
                        vouchernofield.val(data[0].voucherno)
                        supplierfield.val(data[0].supplier)
                        costcenterfield.val(data[0].pos)
                        //invoicenofield.val(data[0].invoicenumber)
                        paymentmodefield.val(data[0].paymentmode)
                        payfromfield.val(data[0].cashbookaccount)
                        paymentmodereferencefield.val(data[0].referenceno)
                        voucherdatefield.val(data[0].date)
                        // get voucher items
                        $.getJSON(
                            "../controllers/paymentoperations.php",
                            {
                                getvoucheritems:true,
                                id:id
                            },function(data){
                                var linetotal,results
                                
                                for(var i=0;i<data.length;i++){
                                    linetotal=parseFloat(data[0].quantity)*parseFloat(data[0].unitprice)
                                    //console.log(linetotal)
                                    results+="<tr><td>"+parseFloat(i+1)+"</td><td>"+data[i].itemcode+"</td><td>"+data[i].description+"</td><td data-id='"+data[0].accountcharged+"'>"+data[0].accountname+"</td><td class='numericfield linetotal'>"+$.number(linetotal,2)+"</td>"
                                    // add edit and delete buttons
                                    results+="<td><a href='javascript void(0)' class='editdata' data-id='"+randomId()+"'><span><i class='fas fa-edit fa-sm mt-1'></i></span></a></td>"
                                    results+="<td><a href='javascript void(0)' class='deletedata' data-id='"+randomId()+"'><span><i class='fas fa-trash-alt fa-sm mt-1'></i></span></a></td></tr>"
                                
                                }
                                itemslist.find("tbody").html(results)
                                // perform totals
                                totalfield.html($.number(performTotal()))
                            }
                        )
                    }else{
                        bootbox.alert("Sorry! The Payment voucher's status is not Pending thus non-editable");
                    } 
                }
            )
            
        }
    })

    function getDropdownListValues(){
        var dfd= new $.Deferred()
        getPointsOfSale(costcenterfield,'one')
        getPaymentModes(paymentmodefield,'one')
        getSuppliers(supplierfield,'one')
        getCashbookAccounts(payfromfield,option='one')
        getGLAccounts(accountchargedfield,0,option='one')
        dfd.resolve()
        return dfd.promise()
    }

    // add items on the list
    addbutton.on("click",function(){
        // check for blank fields
        var reference=referencefield.val(),
            narration=narrationfield.val(),
            amount=amountfield.val(),
            accountcharged=accountchargedfield.val(),
            accountchargedname=accountchargedfield.find("option:selected").html()
            errors="",
            item="", total=0
        if(reference==""){
            errors="Please provide reference first"
            referencefield.focus()
        }else if(narration==""){
            errors="Please provide narration first"
            narrationfield.focus()
        }else if(accountcharged==""){
            errors="Please select account charged first"
            accountchargedfield.focus()
        }else if(amount==""){
            errors="Please provide amount first"
            amountfield.focus()
        }
        if(errors==""){
            errorsdiv.html("")
            itemdetails=itemslist.find("tbody")
            listitems=itemdetails.children().length
            itemcount=parseFloat(listitems)+1
            item="<tr><td>"+itemcount+"</td>"
            item+="<td>"+reference+"</td>"
            item+="<td>"+narration+"</td>"
            item+="<td data-id='"+accountcharged+"'>"+accountchargedname+"</td>"
            item+="<td class='linetotal'>"+$.number(amount,2)+"</td>"
            item+="<td><a href='javascript void(0)' class='editdata' data-id='"+randomId()+"'><span><i class='fas fa-edit fa-sm mt-1'></i></span></a></td>"
            item+="<td><a href='javascript void(0)' class='deletedata' data-id='"+randomId()+"'><span><i class='fas fa-trash-alt fa-sm mt-1'></i></span></a></td></tr>"
            $(item).appendTo(itemdetails)
            // perform totals
            //console.log($.number(performTotal()))
            // empty the fields
            clearItems()
            //total=$.number(performTotal())
            //console.log(total)
            totalfield.html($.number(performTotal()))
            //console.log(totalfield.html())

        }else{
            errors="<div class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> "+errors+"</div>"
            errorsdiv.html(errors)
        }
    })
    
    function performTotal(){
        var sum = 0;
        // iterate through each td based on class and add the values
        $(".linetotal").each(function() {
            var value = $(this).text();
            value=value.replace(",","")
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += parseFloat(value);
            }
        })
        //console.log(sum)
        return sum;
    }

    function clearItems(){
        referencefield.val("")
        narrationfield.val("")
        accountchargedfield.val("")
        amountfield.val("")
        referencefield.focus()
        totalfield.html("0.00")
        
    }

    function clearvoucherparameters(){
        vouchernofield.val("")
        voucherdatefield.val("")
        costcenterfield.val("")
        supplierfield.val("")
        paymentmodefield.val("")
        payfromfield.val("")
        paymentmodereferencefield.val("")
        
    }

    function  clearForm(){
        clearItems()  
        clearvoucherparameters()
        itemslist.find("tbody").html("")
    }
    // empty errors on any input field change
    $("input").on("input",function(){
        errorsdiv.html("")
    })

    // listen to edit data
    itemslist.on("click",".editdata",function(e){
        e.preventDefault()
        var parent = $(this).parent("td").parent("tr")
        var reference=parent.find("td").eq(1).text(),
            narration=parent.find("td").eq(2).text(),
            accountcharged=parent.find("td").eq(3).attr("data-id")//eq(2).text(),
            amount=parent.find("td").eq(4).text()
            amount=amount.replace(",","")
           
        // add the data to edit buttons
        referencefield.val(reference)
        narrationfield.val(narration)
        accountchargedfield.val(accountcharged)
        amountfield.val(amount)
        
        parent.remove()
        // recompute totals
        totalfield.html($.number(performTotal()))
    })

    itemslist.on("click",".deletedata",function(e){
        var parent=$(this).parent("td").parent("tr")
        var description= parent.find("td").eq(2).text()

        e.preventDefault();
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Confirm removal of <strong>"+description+"</strong> ?",
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
                        parent.remove()
                        totalfield.html($.number(performTotal()))
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    savevoucherbutton.on("click",function(){
        // disable save button
        savevoucherbutton.prop("disabled",true)
        var voucherno=vouchernofield.val(),
            voucherdate=voucherdatefield.val(),
            costcenter=costcenterfield.val(),
            supplier=supplierfield.val(),
            paymentmode=paymentmodefield.val(),
            payfrom=payfromfield.val(),
            generatevoucherno=generatevouchernofield.prop("checked")?1:0,
            errors="",
            voucheritems=itemslist.find("tbody").children().length,
            data=[],
            id=idfield.val(),
            paymentmodereference=paymentmodereferencefield.val()
        //console.log("save clicked")
        if(voucherno=="" && generatevoucherno==0){
            errors="Please provide voucher number"
            vouchernofield.focus()
        }else if(voucherdate==""){
            errors="Please select voucher date"
            voucherdatefield.focus()
        }else if(costcenter==""){
            errors="Please select cost center"
            costcenterfield.focus()
        }else if(supplier==""){
            errors="Please select a supplier"
            supplierfield.focus()
        }else if(paymentmode==""){
            errors="Please select a payment mode"
            paymentmodefield.focus()
        }else if(paymentmodereference==""){
            errors="Please provide payment mode reference number"
            paymentmodereferencefield.focus()
        }
        else if(payfrom==""){
            errors="Please select account paying from"
            payfromfield.focus()
        }else if(voucheritems==0){
            errors="Please enter at least an item in the voucher."
        }

        if(errors==""){
            // get voucher items
            itemslist.find("tbody").find("tr").each(function(){
                var ths=$(this)
                reference=ths.find("td").eq(1).text(),
                narration=ths.find("td").eq(2).text(),
                accountcharged=ths.find("td").eq(3).attr("data-id")//eq(2).text(),
                amount=ths.find("td").eq(4).text()
                amount=amount.replace(",","")
                data.push({invoicenumber:reference,description:narration,quantity:1,accountcharged:accountcharged,unitprice:amount})
            })
            // save the data
            TableData = JSON.stringify(data) 
            //console.log(TableData)
            $.post(
                "../controllers/paymentoperations.php",
                {
                    savepayment:true,
                    TableData: TableData,
                    pos:costcenter,
                    supplier:supplier,
                    paymentmode:paymentmode,
                    cashbookaccount:payfrom,
                    reference:paymentmodereference,
                    voucherno:voucherno,
                    generatevoucherno:generatevoucherno,
                    voucherdate:voucherdate,
                    pettycash:1,
                    id:id/*,
                    invoiceno:invoiceno*/

                },function(data){
                    result=$.trim(data.toString())
                    if(result.length==7){
                        errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i> The Payment has been saved successfully. Voucher # : <strong>"+result+"</strong></p>"
                        // clear form
                        clearForm()
                        totalfield.html("0.00")
                        //print the voucher
                        var url ="../printpaymentvoucher.php?voucherid="+result
                        var win = window.open(url, '_blank')
                    }else if(result=='voucher number exists'){
                        errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> Sorry, the voucher number is already in use.</p>"
                    }else{
                        errors="<p class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i> "+result+"</p>"
                    }
                    // re-enable save button
                    savevoucherbutton.prop("disabled",false)
                    errorsdiv.html(errors)
                }
            )
        }else{
            errors="<div class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> "+errors+"</div>"
            errorsdiv.html(errors)
            // re-enable save button
            savevoucherbutton.prop("disabled",false)
        }
    })

    clearbutton.on("click",function(){
        clearForm()
    })
})