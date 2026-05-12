$(document).ready(function(){
    var costcenterlist=$("#costcenter"),
        supplierlist=$("#supplier"),
        paymentmodelist=$("#paymentmode"),
        cashbookaccounts=$("#paidfrom"),
        accountchargedlist=$("#accountcharged"),
        addtolistbutton=$("#addtolist"),
        itemcodefield=$("#itemcode"),
        descriptionfield=$("#description"),
        quantityfield=$("#quantity"),
        unitpricefield=$("#unitprice"),
        accountchargedfield=$("#accountcharged"),
        errordiv=$("#errors"),
        paymentdetails=$("#paymentdetails"),
        totalfield=$("#total"),
        autogeneratevoucher=$("#generatevoucherno"),
        vouchernofield=$("#vouchernumber"),
        savebutton=$("#save"),
        clearbutton=$("#clear"),
        datefield=$("#date"),
        generatevouchernofield=$("#generatevoucherno"),
        referencefield=$("#referencenumber"),
        invoicenofield=$("#invoicenumber"),
        idfield=$("#id"),
        supplierinvoicelist=$("#supplierinvoices"),
        addinvoicestolistbutton=$("#addinvoicestolist")
    autogeneratevoucher.prop("checked",true)
    vouchernofield.prop("disabled",true)
    datefield.datepicker({maxDate: new Date()})

    $.datepicker.setDefaults({
        dateFormat: 'dd-M-yy'
    });

    function getDropdownListValues(){
        var dfd= new $.Deferred()
        getPointsOfSale(costcenterlist,'one')
        getPaymentModes(paymentmodelist,'one')
        getSuppliers(supplierlist,'one')
        getCashbookAccounts(cashbookaccounts,option='one')
        getGLAccounts(accountchargedlist,0,option='one')
        dfd.resolve()
        return dfd.promise()
    }
   
    // check if we are on edit mode
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
                        supplierlist.val(data[0].supplier)
                        costcenterlist.val(data[0].pos)
                        invoicenofield.val(data[0].invoicenumber)
                        paymentmodelist.val(data[0].paymentmode)
                        cashbookaccounts.val(data[0].cashbookaccount)
                        referencefield.val(data[0].referenceno)
                        datefield.val(data[0].date)
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
                                    results+="<tr><td>"+data[i].itemcode+"</td><td>"+data[i].description+"</td><td data-id='"+data[i].accountcharged+"'>"+data[i].accountname+"</td><td class='numericfield invoiceamount'>"+$.number(data[i].unitprice,2)+"</td><td class='numericfield invoicebalance'>"+$.number(data[i].unitprice,2)+"</td><td class='numericfield amountpaid linetotal'>"+$.number(data[i].unitprice,2)+"</td>"
                                    // add edit and delete buttons
                                    // results+="<td><a href='javascript void(0)' class='editdata' data-id='"+randomId()+"'><span><i class='fas fa-edit fa-sm'></i></span></a></td>"
                                    results+="<td><a href='javascript void(0)' class='deletedata' data-id='"+randomId()+"'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>"
                                
                                }
                                paymentdetails.find("tbody").html(results)
                                // perform totals
                                performTotals()
                                totalfield.html($.number(getItemsTotal()))
                            }
                        )
                    }else{
                        bootbox.alert("Sorry! The Payment voucher's status is not Pending thus non-editable");
                    } 
                }
            )
            
        }
    })

    autogeneratevoucher.on("click",function(){
        //console.log(autogeneratevoucher.prop("checked"))
        if(autogeneratevoucher.prop("checked")){
            vouchernofield.prop("disabled",true)
        }else{
            vouchernofield.prop("disabled",false)
        }
    })

    addtolistbutton.on("click",function(){
        var supplierid=supplierlist.val()
        if(supplierid==""){
            bootbox.alert({
                message: "Please select a supplier first!",
                size: 'small'
            })
        }else{
            //show modal
            $("#supplierinvoicesmodal").modal('show')
            getSupplierInvoices(supplierid)
        }
      
    })

    function clearForm(){
        clearPaymentDetails()
        paymentdetails.find("tbody").html("")
        datefield.val("")
        totalfield.html("0.00")
        invoicenofield.val("")
        referencefield.val("")
        costcenterlist.val("")
        paymentmodelist.val("")
        supplierlist.val("")
        cashbookaccounts.val("")
        accountchargedlist.val("")
        vouchernofield.val("")
        vouchernofield.prop("disabled",true)
        generatevouchernofield.prop("checked",true)
    }

    function clearPaymentDetails(){
        itemcodefield.val("")
        descriptionfield.val("")
        quantityfield.val("")
        unitpricefield.val("")
        accountchargedfield.val("")
    }

    function getItemsTotal(){
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
        return sum;
    }

    // payment details listen to delete click event
    paymentdetails.on("click",".deletedata",function(e){
        e.preventDefault()
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(1).text()
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to DELETE <strong>"+itemname+"</strong>?",
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
                        parent.remove()
                        // recompute totals
                        totalfield.html($.number(getItemsTotal()))
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    /*paymentdetails.on("click",".editdata",function(e){
        e.preventDefault()
        var parent = $(this).parent("td").parent("tr")

        var itemcode=parent.find("td").eq(0).text(),
            description=parent.find("td").eq(1).text(),
            quantity=parent.find("td").eq(2).text(),
            unitprice=parent.find("td").eq(3).text(),
            accountcharged=parent.find("td").eq(4).attr("data-id")
            unitprice=unitprice.replace(",","")
            quantity=quantity.replace(",","")
            // add the data to edit buttons
            itemcodefield.val(itemcode)
            descriptionfield.val(description)
            quantityfield.val(quantity)
            unitpricefield.val(unitprice)
            accountchargedfield.val(accountcharged)
            
            parent.remove()
            // recompute totals
            totalfield.html($.number(getItemsTotal()))
    })*/

    //listen to save button click event
    savebutton.on("click",function(){
        // disable save button
        savebutton.prop("disabled",true)
        // check blank fields
        var voucherdate,voucherno,generatevoucherno,pos,supplier,paymentmode,reference,invoiceno,cashbookaccount,TableData,id, errors=''
            voucherdate=datefield.val()
            voucherno=vouchernofield.val()
            generatevouchernofield.prop("checked")?generatevoucherno=1:generatevoucherno=0
            pos=costcenterlist.val()
            supplier=supplierlist.val()
            paymentmode=paymentmodelist.val()
            reference=referencefield.val()
            //invoiceno=$("#invoicenumber option:selected" ).text()
            cashbookaccount=cashbookaccounts.val()
            id=idfield.val()

        // check if the table is empty
        var tbody = $("#paymentdetails tbody");
        if (tbody.children().length == 0) {
            errors="Please add at least an Item in the list"
        }

        if(voucherdate==''){
            errors="Please provide voucher date"
        }else if( !generatevouchernofield.prop("checked") && voucherno=='' ){
            errors="Please provide voucher number"
        }else if(pos==""){
            errors="Please select the Cost Center"
        }else if(supplier==''){
            errors="Please select supplier"
        }else if(paymentmode==''){
            errors="Please select payment mode"
        }else if(cashbookaccount==''){
            errors="Please select account being paid from"
        }/*else if(invoiceno==''){
            errors="<p class='alert alert-warning'>Please provide invoice number</p>"
        }*/
        //console.log(errors)
        if(errors!=''){
            errors="<div class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> "+errors+"</div>"
            errordiv.html(errors)
            // re-enable save button
            savebutton.prop("disabled",false)
        }else{
             // save the voucher
            data = []
            paymentdetails.find("tbody tr").each(function(){
                var ths=$(this),
                    quantity=1,        
                    invoiceno=ths.find("td").eq(0).text(),
                    description=ths.find("td").eq(1).text(),
                    accountcharged =ths.find("td").eq(2).attr("data-id")
                    unitprice= ths.find("td").eq(5).text()
                    unitprice=unitprice.replace(",","")   
                data.push({invoicenumber:invoiceno,description:description,quantity:quantity,unitprice:unitprice,accountcharged:accountcharged})
            })

            data=JSON.stringify(data)
            //console.log(TableData)
            $.post(
                "../controllers/paymentoperations.php",
                {
                    savepayment:true,
                    TableData: data,
                    pos:pos,
                    supplier:supplier,
                    paymentmode:paymentmode,
                    cashbookaccount:cashbookaccount,
                    reference:reference,
                    voucherno:voucherno,
                    generatevoucherno:generatevoucherno,
                    voucherdate:voucherdate,
                    id:id/*,
                    invoiceno:invoiceno*/

                },function(data){
                    result=$.trim(data.toString())
                    if(result.length==7){
                        errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i> The Payment has been saved successfully. Voucher # : <strong>"+result+"</strong></p>"
                        // clear form
                        clearForm()
                        performTotals()
                        //print the invoice
                        var url ="../printpaymentvoucher.php?voucherid="+result
                        var win = window.open(url, '_blank')
                        
                    }else if(result=='voucher number exists'){
                        errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> Sorry, the voucher number is already in use.</p>"
                    }else{
                        errors="<p class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i> "+result+"</p>"
                    }
                    errordiv.html(errors)

                    // re-enable save button
                    savebutton.prop("disabled",false)
                }
            )
        }   
       
    })

    function storeTblValues()
    {
        var TableData = new Array(),
            quantity=0, 
            unitprice=0
        $('#paymentdetails tr').each(function(row, tr){
            quantity=1//$(tr).find('td:eq(2)').text()
            unitprice= $(tr).find('td:eq(5)').text()
            //quantity=quantity.replace(",","")
            unitprice=unitprice.replace(",","")
            TableData[row]={
                "invoicenumber" : $(tr).find('td:eq(0)').text(),
                "description" : $(tr).find('td:eq(1)').text(),
                "quantity" :quantity,
                "unitprice" :unitprice,
                "accountcharged" : $(tr).find('td:eq(2)').attr("data-id")
            }    
        }); 
        TableData.shift()  // first row will be empty - so remove
        TableData.pop() // remove the last row too
        return TableData
    }

    clearbutton.on("click",function(){
        bootbox.dialog({
             message: "Are you sure you want to <strong>CLEAR</strong> the form ?",
             buttons: {
                 success: {
                     label: "No",
                     className: "btn-success",
                     callback: function() {
                         $('.bootbox').modal('hide');
                     }
                 },
                 danger: {
                     label: "Yes",
                     className: "btn-danger",
                     callback: function() {
                        clearForm()
                        errordiv.html("")
                        $('.bootbox').modal('hide');
                     }
                 }
             }
         })
    })

   /* supplierlist.on("change",function(){
        supplierid=supplierlist.val()
        //console.log(supplierid)
        if(supplierid!=0){
            $.getJSON(
                "../controllers/supplieroperations.php",
                {
                    getsupplierinvoices:true,
                    startdate:'01-Jan-2019',
                    enddate:'31-Dec-2100',
                    status:'Pending',
                    supplierid:supplierid
                },
                function(data){
                    //console.log(data)
                    var results="<option value=''>&lt;Choose One&gt;</option>"
                    for(var i=0;i<data.length;i++){
                        results+="<option value='"+data[i].invoiceid+"'>"+data[i].invoiceno+"</option>"
                    }
                    invoicenofield.html(results)
                }
            )
        }
    })*/

  /*  invoicenofield.on("change",function(){
        var id=invoicenofield.val()
        if(invoicenofield.val()!=""){
            $.getJSON(
                "../controllers/supplieroperations.php",
                {
                    getinvoicegrndetails:true,
                    id:id
                },
                function(data){
                    var results="", linetotal=0
                    for(var i=0;i<data.length;i++){
                        linetotal=parseFloat(data[i].quantity)*parseFloat(data[i].unitprice)
                        results+="<tr><td>"+data[i].itemcode+"</td><td>"+data[i].description+"</td><td class='numericfield'>"+$.number(data[i].quantity,2)+"</td><td class='numericfield'>"+$.number(data[i].unitprice,2)+"</td><td>"+data[i].accountcharged+"</td><td class='numericfield linetotal'>"+$.number(linetotal,2)+"</td>"
                        // add edit and delete buttons
                        results+="<td><a href='javascript void(0)' class='editdata' data-id='"+randomId()+"'><span><i class='fas fa-edit fa-sm'></i></span></a></td>"
                        results+="<td><a href='javascript void(0)' class='deletedata' data-id='"+randomId()+"'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>"
                    }
                    paymentdetails.find("tbody").html(results)
                    // perform totals
                    totalfield.html($.number(getItemsTotal()))
                }
            )
        }
    })*/

    function getSupplierInvoices(supplierid){
        var startdate='01-Jan-2019',
            enddate="31-dec-2100",
            status='<All>',
            balance=0
        $.getJSON(
            "../controllers/supplieroperations.php",
            {
                getsupplierinvoices:true,
                startdate:startdate,
                enddate:enddate,
                status:status,
                supplierid:supplierid
            },
            function(data){
                var results="",
                    added=0
                for(var i=0;i<data.length;i++){
                    balance=parseFloat(data[i].invoiceamount-data[i].amountpaid)
                    if(balance>0){
                        results+="<tr data-accountcharged='"+data[i].accountcharged+"' data-accountname='"+data[i].accountname+"'><td><input type='checkbox' class='invoice' id='"+data[i].invoiceno+"'></td>"
                        results+="<td>"+data[i].invoiceno+"</td>"
                        results+="<td>"+data[i].invoicedate+"</td>"
                        results+="<td class='text-right'>"+$.number(data[i].invoiceamount)+"</td>"
                        results+="<td class='text-right'>"+$.number(data[i].amountpaid)+"</td>"
                        results+="<td class='text-right'>"+$.number(balance)+"</td></tr>"
                    }
                }
                supplierinvoicelist.html(results)
            }
        )
    }

    addinvoicestolistbutton.on("click",function(){
        var results="", added=0
        $(".invoice").each(function(){
            if($(this).prop("checked")){
                var parent=$(this).parent("td").parent("tr")
                var invoiceno,invoiceamount,added=0,invoicebalance, accountcharged,accountname
                invoiceno=parent.find("td").eq(1).text()
                invoiceamount=parent.find("td").eq(3).text()
                invoicepaid=parent.find("td").eq(4).text()
                invoicebalance=parent.find("td").eq(5).text()
                accountcharged=parent.attr("data-accountcharged")
                accountname=parent.attr("data-accountname")
                // check that the item has not been added to the list already
                paymentdetails.find(".invoice").each(function(){
                    //console.log($(this).prop("id") +" :: "+invoiceno)
                    if($(this).prop("id")==invoiceno){
                        added=1
                    }
                })

                if(added==0){
                    results+="<tr><td class='invoice' id='"+invoiceno+"'>"+invoiceno+"</td>"
                    results+="<td>Payment towards invoice #"+invoiceno+"</td>"
                    results+="<td data-id='"+accountcharged+"'>"+accountname+"</td>"
                    results+="<td class='invoiceamount'>"+invoiceamount+"</td>"
                    results+="<td class='invoicebalance'>"+invoicebalance+"</td>"
                    results+="<td class='amountpaid'>"+invoicebalance+"</td>"
                    results+="<td><a href='javascript void(0)' class='removeinvoice'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>"
                }
            }
        })
        $(results).appendTo(paymentdetails)
        // perform totals
        performTotals()
        // hide modal
        $("#supplierinvoicesmodal").modal('hide')
    })

    function performTotals(){
        var invoiceamounttotal=0,invoicebalancetotal=0,amountpaidtotal=0
        
        $(".invoiceamount").each(function(){
            var value=$(this).html().replace(',', '')
            if(!isNaN(value) && value.length != 0) {
                invoiceamounttotal += parseFloat(value);
            }
        })

        $(".invoicebalance").each(function(){
            var value=$(this).html().replace(',', '')
            if(!isNaN(value) && value.length != 0) {
                invoicebalancetotal += parseFloat(value);
            }
        })

        $(".amountpaid").each(function(){
            var value=$(this).html().replace(',', '')
            if(!isNaN(value) && value.length != 0) {
                amountpaidtotal += parseFloat(value);
            }
        })

        $("#invoicetotal").html($.number(invoiceamounttotal))
        $("#balancetotal").html($.number(invoicebalancetotal))
        $("#total").html($.number(amountpaidtotal))
    }

    //listen to remove invoice from the list
    paymentdetails.on("click",".removeinvoice",function(e){
        var parent=$(this).parent("td").parent("tr")
        var invoiceno= parent.find("td").eq(0).text()

        e.preventDefault();
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to remove invoice # <strong>"+invoiceno+"</strong> from the list?",
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
                        performTotals()
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    paymentdetails.on('click',".amountpaid",function(){
        var parent = $(this).parent("tr");
         bootbox.prompt({
             title:"Change Amount",
             size: 'small',
             message: "Enter amount to settle.",
             inputType: 'number',
             callback: function (result) {
                 if(parseFloat(result)>0){
                     // quantity is on the 5th col
                     var quantity= 1//parent.find("td").eq(5).text(),
                         linetotal=parseFloat(result*quantity)
                     // unitprice is coulmn number 2 and extended price is col 4
                     parent.find("td").eq(5).text(linetotal)
                     performTotals()
                     //computeTotalAmountPaid()
                 } 
             }
         });
    })
})