$(document).ready(function(){
    var poslist=$("#pointofsale"),
        customerlist=$("#customer"),
        itemcodefield=$("#itemcode"),
        errordiv=$("#errors"),
        errors="",
        salesitems=$("#salesitems"),
        overalltotal=$("#overalltotalamount"),
        paymentmethodslist=$("#paymentmethod"),
        amountpaidfield=$("#amountpaid"),
        balancefield=$("#balanceamount"),
        referencenofield=$("#refno"),
        savebutton=$("#save"),
        clearbutton=$("#clear"),
        mainmenu=$("#gotomain"),
        searchresults=$("#searchproducts"),
        creditnotelist=$("#creditnote"),
        creditnotevalue=$("#creditnotevalue")
        paymentmodetext=$("#paymentmodetext"),
        paymentmodevalue=$("#paymentmodevalue"),
        totalpayments=$("#totalpaymentsvalue"),
        salesitemsdetails=$("#salesitemsdetails"),
        holdsale=$("#hold"),
        retrieveheldsale=$("#retrieve"),
        heldsaleslist=$("#heldsalesdetails"),
        paymentoptions=$("#paymentoptions"),
        addpayments=$("#addpayments"),
        paymentsmodal=$("#payments"),
        totalamountpayable=$("#totalamountpayable"),
        totalpaid=$("#totalpaid"),
        change=$("#change"),
        paymenterror=$("#paymenterror"),
        changeprices=false,
        heldsalesmodal=$("#heldsales"),
        serialnumbersmodal=$("#serialsmodal"),
        serialdetailsquanity=$("#serialquantity"),
        serialdetailsname=$("#serialitemname"),
        serialdetailsid=$("#serialitemid"),
        serialnumbersdropdownlist=$("#serialnumbers"),
        addserialnumberstolistbutton=$("#saveserialnumbers"),
        serialnumberslist=$("#serialstable"),
        serialserrors=$("#serialserrors"),
        serialstotal=$("#serialstotals"),
        updateserialsbutton=$("#updateserials"),
        bundleitemsmodal=$("#bundleitemsmodal"),
        addbundleitembutton=$("#addbundleitems"),
        donebundlebuttons=$("#savebundleitems"),
        customermodal=$("#newcustomermodal"),
        addcustomerbutton=$("#addcustomer"),
        customercategorylist=$("#customercategory"),
        customernamefield=$("#customername"),
        idnumberfield=$("#idnumber"),
        pinnumberfield=$("#pinnumber"),
        mobilefield=$("#mobilenumber"),
        emailaddressfield=$("#emailaddress"),
        savecustomerbutton=$("#savecustomer"),
        customererrordiv=$("#customerdetailserrors")
        mpesaconfirmationmodal=$("#mpesaconfirmationmodal"),
        addmpesatransactionbutton=$("#addmpesatransaction")

    const printlargeformat=$("#chkprintlargeformat")
    getactivesession()

    // check if there is an active session
    function getactivesession(){
        $.getJSON(
            "../controllers/sessionoperations.php",
            {
                getactivesession:true
            },
            (data)=>{
                console.log(data.length)
                if(data.length==0){
                    errordiv.html(showAlert("danger",`Sorry, no active sessions open. Contact your manager to open a Session`))
                    $(".btn").prop("disabled",true)
                    $("select").prop("disabled",true)
                    $("input").prop("disabled",true)
                }
            }
        )
    }
    // get customer categories
    getcategories()
    //get customers
    getcustomers()

    // check if allowed to change prices when we makes sales 
    $.getJSON(
        "../controllers/settingoperations.php",
        {
            getsalessettings:true
        },
        function(data){
            changeprices=data[0].changeitemprices==1?true:false
        }
    )

    // get points of sale
    $.getJSON(
        "../controllers/posoperations.php",
        {
            getpointsofsale:true
        },
        function(data){
            var results="<option value=''>&lt;Choose One&gt;</option>"
                for (var i = 0; i < data.length; i++) {
                    results+="<option value='"+data[i].id+"'>"+data[i].posname+"</option>"
                } 
                $(results).appendTo(poslist)
        }
    )

    function getcustomers(){
        var dfd= new $.Deferred()
        $.getJSON(
            "../controllers/customeroperations.php",
            {
                getcustomers:true,
                regularcustomers:1,
                onetimecustomers:1
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for (var i = 0; i < data.length; i++) {
                    results+="<option value='"+data[i].customerid+"'>"+data[i].customername+"</option>"
                } 
                $(results).appendTo(customerlist)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    // get payment methods
    $.getJSON(
        "../controllers/settingoperations.php",
        {
            getpaymentmethods:true
        },
        function(data){
            // var results="<option value=''>&lt;Choose One&gt;</option>"
            var results="<thead><tr class='d-flex'><th class='col-3' scope='row'>Pay Mode</th><th class='col-4'>Amount Paid</th><th class='col-5'>Reference #</th></tr></thead><tbody>"
            for (var i = 0; i < data.length; i++) {
                // results+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
                // <!-- <td><img src='"+data[i].image+"' class='thumbnail'></td> -->
                //results+=""
                results+="<tr class='d-flex'><td class='col-3' scope='row'>"+data[i].description+"</td>"
                results+="<td class='col-4'><div class='form-group'><input type='number' id='"+data[i].id+"' class='amount form-control form-control-sm "+data[i].description+"'></td></div>"
                // check if requires suppliers drop down
                if(data[i].supplierslist==1){
                    results+=`<td class='col-5'><div class='form-group'><select id='${data[i].id}_ref' class='form-control form-control-sm customerslist'></select></td>`
                }else{
                    if(data[i].requiresrefno==1) {
                        results+="<td class='col-5'><div class='form-group'><input type='text' id='"+data[i].id+"_ref' class='reference form-control form-control-sm'></div></td></tr>"  
                    }else{ 
                        results+="<td class='col-5'><div class='form-group'><input type='text' id='"+data[i].id+"_ref' class='form-control form-control-sm' disabled></td></tr>" 
                    }
                }
               
            } 
            results+="</tbody>"
           // console.log(results)
            $(results).appendTo(paymentoptions) //.appendTo(paymentmethodslist)
            //console.log(results)
        }
    )

   itemcodefield.keypress(function(event){	
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            if(customerlist.val()==""){
                errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> Please select a customer first</p>"
                errordiv.html(errors)
            }else if(poslist.val==""){
                errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> Please select an outlet / POS first</p>"
                errordiv.html(errors)
            }else{
                errordiv.html(errors)
                getProduct()
            }
        } 
    })   
        
    itemcodefield.on("keyup",function(){
        var name=itemcodefield.val()
        if(name.length>2){
            $.getJSON(    
                "../controllers/productoperations.php",
                {
                    filterproductbyname:1,
                    name:name
                },
                function(data){
                    var results="<ul class='searchresults'>"
                    searchresults.html("")
                    if(data.length>0){
                        for(i=0;i<data.length;i++){
                            results+="<li id='"+data[i].itemcode+"'>"+data[i].itemname+"</li>"
                        }
                        results+="</ul>"
                        // console.log(results)
                        $(results).appendTo(searchresults)
                        searchresults.show()
                        searchresults.addClass("mt-5")
                    }  else{

                    }
                }
            )
        }
    })
        
    // listen to the click event of search term when clicked
    searchresults.on("click","li",function(){
        var itemcode=''
        itemcode=$(this).attr("id")
        itemcodefield.val(itemcode)
        
        if(customerlist.val()==""){
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> Please select a customer first</p>"
            errordiv.html(errors)
            customerlist.focus()
        }else if(poslist.val==""){
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> Please select an outlet / POS first</p>"
            errordiv.html(errors)
            poslist.focus()
        }else{
            getProduct()
        }     
        searchresults.hide()
    })

    savebutton.on("click",function(){
        // disable the button
        savebutton.prop("disabled",true)
        var TableData=[],
            pointofsale=poslist.val(),
            customerid=customerlist.val(),
            tbody = $("#salesitems tbody"),
            errors="",
            // process all the items 
            itemslist=[],
            missingitems=false
        salesitems.find("tbody tr").each(function(){
            var $this=$(this),
                itemcode=$this.find("td").eq(0).text(),
                unitprice=$this.find("td").eq(2).text(),
                discount=$this.find("td").eq(3).text(),
                quantity=$this.find("td").eq(6).text(),
                serialno=""

            if($this.attr("data-serializable")==1){
                if($this.attr("data-serial-nos")!=""){
                    itemslist=$this.attr("data-serial-nos").split(",")
                    for(var i=0;i<itemslist.length;i++){
                        serialno=itemslist[i]
                        TableData.push({"itemcode":itemcode,"unitprice":unitprice, "discount":discount,"quantity":quantity,"serialno":serialno})
                    }
                    $this.removeClass("text-danger")
                }else{
                    $this.addClass("text-danger")
                    missingitems=true
                }  
            }else{
                TableData.push({"itemcode":itemcode,"unitprice":unitprice, "discount":discount,"quantity":quantity,"serialno":""})
            }
        })

        //console.log(missingitems)
        // check blank fields
        if(pointofsale==""){
            errors="Please select a <strong>Point of Sale</strong>"
        }
        else if(customerid==""){
            errors="Please select a <strong>Customer</strong>"
        }

        // check whether they are items added on the list

        if (tbody.children().length == 0) {
            errors="Please add at least an Item in the list"
        }else if(missingitems){
            errors="Please provide <strong>Serial Numbers</strong> for all highlighted entries."  
        }
        
        // check if amount paid is sufficient
        amountpaid=computeAmountPaid()
        // compute change
        total=getItemsTotal()
        //console.log(tota)
        changeamount=parseFloat(amountpaid-total)
        if(changeamount<0){
            errors="Sorry, insufficient amount provided"
            paymenterror.html(showAlert("info",errors))
        }else{
            paymenterror.html("")
        }
        
        // check if payment methods have been provided and whether reference numbers have been used
        $(".amount").each(function() {
            var paymentmethodid=$(this).attr("id"),
                refno="#"+paymentmethodid+"_ref"
                referenceno=$(refno).val()
            // check amount
            if($(this).val()!=""){
                if(paymentmethodid!=1 || paymentmethodid!=4){
                    $.post(
                        "../controllers/possalesoperations.php",
                        {
                            checkpaymentmodereference:true,
                            modeid:paymentmethodid,
                            referenceno:referenceno
                        },
                        function(data){
                            str=$.trim(data)
                            if(str==true){
                                errors="Invalid reference number"
                            }
                        }
                    )
                }
            }
        })
       
        if(errors==""){
            TableData = JSON.stringify(TableData) 
            paymentMethods=JSON.stringify(formatPaymentMethods())
            $.post(                
                "../controllers/possalesoperations.php",
                {
                    savesale:"POST",
                    TableData: TableData,
                    customerid:customerid,
                    pointofsale:pointofsale,
                    paymentmethods:paymentMethods,
                    referenceno:referenceno,
                    creditnoteno:creditnotelist.val()
                },
                function(data){
                    // generate receipt
                    try {
                        let response = JSON.parse(data);
                        if(response.status == "success" || response.receiptno){
                            let str = response.receiptno;
                            let printreceipt = response.printreceipt;

                            if(printreceipt == 1) {
                                let url = printlargeformat.prop("checked") ? "../controllers/printcustomerreceipt.php" : "../printreceipt.php"
                                url += "?receiptno=" + str;
                                window.open(url, '_blank');
                            }
                            
                            errordiv.html("")
                            clearForm()
                            errors = "Sale finalized successfully! <br/> Receipt Number: <strong>" + str + "</strong>"
                            errordiv.html(showAlert("success", errors))
                        } else {
                            errordiv.html(showAlert("warning", data.toString()))
                        }
                    } catch(e) {
                        errordiv.html(showAlert("warning", data.toString()))
                    }
                    // hide payment details
                    paymentsmodal.modal("hide")
                    // re-enable save button
                    savebutton.prop("disabled",false)
                }
            )
        }else{
            errordiv.html(showAlert("info",errors))
            paymentsmodal.modal("hide")
            // re-enable save button
            savebutton.prop("disabled",false)
        }
    })
    
    clearbutton.on("click",function(){
       clearForm()
    })

    function computeCustomerBalance(){
        totalamount=overalltotal.text()
        amountpaid=amountpaidfield.val()
        if(!isNaN(totalamount) && totalamount.length != 0 && !isNaN(totalamount) && amountpaid.length != 0) {
            balance=amountpaid-totalamount
            balancefield.html(balance)
        }
    }

    mainmenu.on("click",function(){
        window.location.href="main.php"
    })

    function getProduct(){
        // display progress
        errordiv.html("")
        errors="Fetching product details. Please wait ..."
        errordiv.html(showAlert("processing",errors,1))
        let productdetails=""
        const storeid=poslist.val()

        $.getJSON(
            "../controllers/productoperations.php",
            {   
                getproductdetails:true,
                productcode:itemcodefield.val(),
                customerid:customerlist.val(),
                storeid
            },
            function(data){
                // check if JSON returned a blank object
                if (Object.keys(data).length===0){
                    errors="No product with similar code found"
                    errordiv.html(showAlert("info",errors))
                }else{
                    errordiv.html("")
                    // check if there are quantities in stock for the item
                    if(Number(data[0].itembalance)<=0){
                        errors=`<strong>${data[0].itemname}</strong> has <strong>${data[0].itembalance}</strong> quantities in stock hence can't be sold.`
                        errordiv.html(showAlert("info",errors))
                    }else{
                        let sellingprice=data[0].sellingprice,
                            randomno=randomId()
                        productdetails+=`<tr class='clickable-row' data-id='${randomno}' data-productid='${data[0].productid}' data-serializable='${data[0].serializable}' data-serial-nos=''><td>${data[0].itemcode}</td>`
                        productdetails+=`<td>${data[0].itemname}</td>`
                        productdetails+=`<td class='price'>${data[0].sellingprice}</td>`
                        productdetails+=`<td>${data[0].discount}</td>`
                        productdetails+=`<td >${sellingprice}</td>`
                        productdetails+=`<td >${data[0].itembalance}</td>`
                        productdetails+=`<td class='quantity'>1</td>`
                        // Add serial number button if item is serializable
                        productdetails+=data[0].serializable==1?`<td><button class='btn btn-xs btn-primary addserials' data-id='${randomno}' data-name='${data[0].itemname}'><span><i class='fas fa-plus-circle fa-sm'></i> Add serials numbers</span></button></td>`:`<td>&nbsp</td>`
                        productdetails+=`<td class='linetotal'>${sellingprice}</td>`
                        productdetails+=`<td><a href='javascript void(0)' class='deletedata' data-id='${randomId()}'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>`
                        //productdetails+="<td><button id='"+data[0].itemcode+"'  class='btn btn-danger btn-sm deleteitem' data-toggle='modal' data-target='#confirmdelete'>Remove</button></td></tr>"
                        /**/
                        $(productdetails).appendTo(salesitems.find("tbody"))
                        // display overall total
                        let total=getItemsTotal()
                        overalltotal.html($.number(total,2))
                        totalamountpayable.html($.number(total,2))
                        itemcodefield.val("")
                        itemcodefield.focus()
                        // compute totals and balance
                        computeTotalAmountPaid()
                    }
                    
                } 
            }
        )
    }
   
    // calculate totals
    function getItemsTotal(){
        var sum = 0;
        // iterate through each td based on class and add the values
        $(".linetotal").each(function() {
            var value = $(this).text();
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += parseFloat(value);
            }
        })
        return sum;
    }

    // get customer credit notes
    customerlist.on("change",function(){
        if(customerlist.val()!=""){
            $.getJSON(
                "../controllers/creditnoteoperations.php",
                {
                    getcustomercreditnotes:"post",
                    customerid: customerlist.val()
                },

                function(data){
                    var results="<option value=''>&lt;None&gt;"
                    for(i=0;i<data.length;i++){
                        results+="<option value='"+data[i].creditnotenumber+"'>"+data[i].creditnotenumber
                    }
                    creditnotelist.html(creditnotelist)
                    // $(results).appendTo()
                }
            )
        }
    })

    // get the credit note value
    creditnotelist.on("change",function(){
        if(creditnotelist.val()!=""){
            $.getJSON(
                "../controllers/creditnoteoperations.php",
                {
                    getcreditnotetotal:"post",
                    creditnotenumber:creditnotelist.val()
                },
                function(data){
                    creditnotevalue.html(data[0].creditnotetotal)
                    computeTotalAmountPaid()
                }
            )
        }
    })
    
    // listen to payment methods list
    paymentmethodslist.on("change",function(){
        paymentmodetext.html(paymentmethodslist.children(':selected').text())
        amountpaidfield.val()==""?paymentmodevalue.html("0.00"):paymentmodevalue.html(amountpaidfield.val())
        computeTotalAmountPaid()
    })

    // function that computes total amount paid 
    function computeTotalAmountPaid(){
        var credittotal=parseFloat(creditnotevalue.html()),
            paymentmodetotal=parseFloat(amountpaidfield.val())
            overalltotalamount=parseFloat(overalltotal.html())
        if(!isNaN(credittotal) && credittotal.length != 0 && !isNaN(paymentmodetotal) && paymentmodetotal.length != 0){
            totalpaid=credittotal+paymentmodetotal
            totalpayments.html(totalpaid)
            computeCustomerBalance()
            // compute balance 
            if(!isNaN(overalltotalamount) && overalltotalamount.length != 0){
                var balance =totalpaid-overalltotalamount
                balancefield.html(balance)
            }
        }
    }

    amountpaidfield.on("keyup",function(){
        amountpaidfield.val()==""?paymentmodevalue.html("0.00"):paymentmodevalue.html(amountpaidfield.val())
        computeTotalAmountPaid()
    })

    function clearForm(){
         // clear selects and input fields
         $("select").val("")
         $('input[type="text"]').val("")
         // clear table entries
         $('#salesitemsdetails').html("")
         //clear total and balance
        // balancefield.text("0.00")
        overalltotal.html("0.00")
        $('.amount').val("")
        $(".reference").val("")
        totalpaid.html("0.00")
        change.html("0.00")
        totalamountpayable.html("0.00")
         //creditnotevalue.html("0.00")
        // paymentmodevalue.html("0.00")
         //totalpayments.html("0.00")
    }

    salesitemsdetails.on("click",".deletedata",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(1).text()
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to remove <strong>"+itemname+"</strong> from the list?",
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
                        parent.remove()
                        overalltotal.html($.number(getItemsTotal(),2))
                        totalamountpayable.html($.number(getItemsTotal(),2))
                        computeTotalAmountPaid()
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    // listen to change quantity
    salesitemsdetails.on("click",".quantity",function(e){
       // console.log($(this).html())
        const parent = $(this).parent("tr");
        bootbox.prompt({
            title:"Enter New Quantity",
            size: 'small',
            message: "Enter quantity required",
            inputType: 'number',
            callback: function (result) {
                if(Number(result)>0){
                    // check if quantity in stock exeeds quantity to be sold
                    const unitprice= parent.find("td").eq(4).text(),
                        linetotal=Number(result*unitprice),
                        stockquantity=Number(parent.find("td").eq(5).text())
                    if(stockquantity>Number(result)){
                        parent.find("td").eq(6).text(result)
                        parent.find("td").eq(8).text(linetotal)
                        overalltotal.html($.number(getItemsTotal(),2))
                        totalamountpayable.html($.number(getItemsTotal(),2))
                        computeTotalAmountPaid()
                    }else{
                        errors="Quantity to be sold exceeds stock quantity"
                        errordiv.html(showAlert("info",errors))
                    }  
                } 
            }
        })
    })

    // listen to unitp price amount column
    salesitemsdetails.on("click",".price",function(e){
        // check if edit is allowed
        //console.log(changeprices)
        if(changeprices){
            // console.log($(this).html())
         var parent = $(this).parent("tr");
         bootbox.prompt({
             title:"Enter New Price",
             size: 'small',
             message: "Enter new Price",
             inputType: 'number',
             callback: function (result) {
                 if(parseFloat(result)>0){
                     // quantity is on the 5th col
                     var quantity= parent.find("td").eq(6).text(),
                         linetotal=parseFloat(result*quantity)
                     // unitprice is coulmn number 2 and extended price is col 4
                     parent.find("td").eq(2).text(result)
                     parent.find("td").eq(4).text(result)
                     parent.find("td").eq(7).text(linetotal)
                     overalltotal.html($.number(getItemsTotal(),2))
                     totalamountpayable.html($.number(getItemsTotal(),2))
                     computeTotalAmountPaid()
                 } 
             }
         });
        }
     })

    // hold a sale
    holdsale.on("click",function(){
        var TableData,
                pointofsale=poslist.val(),
                customerid=customerlist.val(),
                paymentmethod=paymentmethodslist.val(),
                referenceno=referencenofield.val()
                amount=amountpaidfield.val()
        errors=""
        // check blank fields
        if(pointofsale==""){
            errors="Please select a <strong>Point of Sale</strong>"
        }
        else if(customerid==""){
            errors="Please select a <strong>Customer</strong>"
        }
        else if(paymentmethod==""){
            errors="Please select a <strong>Payment Method</strong>"
        }else{
            if(paymentmethodslist.find('option:selected').text()!="Cash"){
                if(referenceno==""){
                    errors="Please provide "+paymentmethodslist.find('option:selected').text()+" <strong>Reference Number</strong>"
                }
            }
        }
       
        if(errors==""){
            TableData=[];
            salesitems.find("tbody tr").each(function(){
                var $this=$(this),
                    itemcode=$this.find("td").eq(0).text(),
                    description=$this.find("td").eq(1).text(),
                    unitprice=$this.find("td").eq(4).text(),
                    discount=$this.find("td").eq(3).text(),
                    quantity=$this.find("td").eq(6).text(),
                    serialno=$this.find("td").eq(6).text()
    
                if($this.attr("data-serializable")==1){
                    if($this.attr("data-serial-nos")!=""){
                        itemslist=$this.attr("data-serial-nos").split(",")
                        for(var i=0;i<itemslist.length;i++){
                            serialno=itemslist[i]
                            TableData.push({"itemcode":itemcode,"description":description,"unitprice":unitprice, "discount":discount,"quantity":quantity,"serialno":serialno})
                        }
                    }  
                }else{
                    TableData.push({"itemcode":itemcode,"description":description,"unitprice":unitprice, "discount":discount,"quantity":quantity,"serialno":""})
                }
            })
            // check that at least an item has been added to the list
            if(TableData.length>0){
                TableData=JSON.stringify(TableData)
                $.post(                
                    "../controllers/possalesoperations.php",
                    {
                        holdsale:"POST",
                        TableData: TableData,
                        customerid:customerid,
                        pointofsale:pointofsale,
                    },
                    function(data){
                        // generate receipt
                        str=$.trim(data.toString())
                        if(str=="Sale has been held succesfully"){
                            clearForm() 
                            errordiv.html(showAlert("success",str))
                            //errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i></span> "+str+"</p>"
                        }else{
                            errordiv.html(showAlert("danger",str))
                            //errors="<p  class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i></span> "+str+"</p>"
                        } 
                    }
                )
            }else{
                errordiv.html(showAlert("info","Please add at least an item in the list first"))
            }   
        }else{
            errordiv.html(showAlert("info",errors))
        }
    })

    retrieveheldsale.on("click",function(){
      $.getJSON(
          "../controllers/possalesoperations.php",
          {
            getheldsales:"true"
          },
            function(data){
                var results="<table class='table table-striped table-sm'>"
                results+="<thead><tr><th>Date</th>"
                results+="<th>Customer</th>"
                results+="<th>POS</th>"
                results+="<th>&nbsp;</th></tr></thead><tbody>"
                console.log(data.length)
                if(data.length==0){
                    results+="<tr><td colspan='4'> Currently no held sales found on your user account.</td></tr>"
                }else{
                    for(var i=0;i<data.length;i++){
                        results+="<tr><td>"+data[i].dateheld+"</td>"
                        results+="<td>"+data[i].customername+"</td>"
                        results+="<td>"+data[i].posname+"</td>"
                        results+="<td><a href='javascript void(0)' data-dismiss='modal' class='usedata' data-id='"+data[i].id+"'><span><i class='fas fa-plus-circle fa-lg mt-1'></i></span></a></td></tr>"
                    } 
                }
                
                results+="</tbody></table>"
                heldsaleslist.find(".modal-body").html(results)
                //console.log(results)
                heldsalesmodal.modal("show")
                // display the modal
            }
      ) 
    })

    //listen to retrieve item selection
    heldsaleslist.on("click",".usedata",function(e){
        e.preventDefault()
        var id = $(this).attr('data-id')
        // get held sales
        getHeldSaleHeader(id).done(
            getHeldSalesDetails(id).done(function(){
                // delete the held sale
                $.post(
                    "../controllers/possalesoperations.php",
                    {
                        deleteheldsale:true,
                        id:id
                    },
                    function(data){
                        str=$.trim(data.toString())
                        //console.log(str)
                    }
                )
            })
        )
        // get held sales details
    })

    function getHeldSaleHeader(id){
        var dfd= new $.Deferred()
        $.getJSON(
            "../controllers/possalesoperations.php",
            {
                id:id,
                getheldsaleheader:true
            },
            function(data){
                poslist.val(data[0].posid)
                customerlist.val(data[0].customerid)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    function getHeldSalesDetails(id){
        var dfd= new $.Deferred()
        $.getJSON(
            "../controllers/possalesoperations.php",
            {
                id:id,
                getheldsaledetails:true
            },
            function(data){
                var results=""
                for(var i=0;i<data.length;i++){
                    results+=`<tr class='clickable-row'><td>${data[i].itemcode}</td>`
                    results+=`<td>${data[i].itemname}</td>`
                    // results+="<td>"+data[i].description+"</td>"
                    results+=`<td>${Number(data[i].unitprice)+Number(data[i].discount)}</td>`
                    results+=`<td>${data[i].discount}</td>`
                    results+=`<td>${data[i].unitprice}</td>`
                    results+=`<td class='quantity'>${data[i].quantity}</td>`
                    results+=`<td>&nbsp;</td>`
                    // results+="<td>"+data[i].serialno+"</td>"
                    results+=`<td class='linetotal'>${Number(data[i].quantity*data[i].unitprice)}</td>`
                    results+=`<td><a href='javascript void(0)' class='deletedata' data-id='${randomId()}'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>`
                }
                salesitems.find("tbody").html(results)
                // display overall total
                var total=getItemsTotal()
                overalltotal.html($.number(total,2))
                totalamountpayable.html($.number(total,2))
                // compute totals and balance
                computeTotalAmountPaid()
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    paymentoptions.on("keyup",".amount", function(){
        amountpaid=computeAmountPaid()
        totalpaid.html($.number(amountpaid,2))
        // compute change
        total=getItemsTotal()
        //console.log(tota)
        changeamount=parseFloat(amountpaid-total)
        //console.log(changeamount)
        change.html($.number(changeamount,2))
        paymenterror.html("")
        errordiv.html("")
    })

    function computeAmountPaid(){
        var sum=0
        $(".amount").each(function() {
            var value = $(this).val();
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += parseFloat(value);
            }
        })
        return sum;
    }

    // format payment methods for JSON
    function formatPaymentMethods()
    {
        var i=0
        var TableData = new Array();

        $('.amount').each(function(){
            var id=$(this).attr('id'),
                amount=$(this).val()
                referenceno=$("#"+id+"_ref").val()

            if($(this).hasClass('Cash')){
                // check if no cash has been provided
               // console.log('Cash reached')
                if($(this).val()==""){
                    $(this).val(0)
                }
                
                amountpaid=computeAmountPaid()
                total=getItemsTotal()
                changeamount=parseFloat(amountpaid-total)
                //console.log(changeamount)
                if(parseFloat(changeamount)>0){
                    amount=amount-changeamount
                }
            }

            TableData[i]={
                "modeid" : id,
                "amount" :amount,
                "referenceno" : referenceno
            }  
            i+=1   
        })
        // TableData.shift() 
        // console.log(TableData)
        return TableData
    }

    // clear error display on input change
    $('input').on('input', function() {
        errordiv.html("")
    });

    customerlist.on("change",function(){
        errordiv.html("")
    })

    poslist.on("change",function(){
        errordiv.html("")
    })

    // show add serial number modal
    salesitems.on("click",".addserials",function(){
        
        var $this=$(this), 
            parent=$this.parent("td").parent("tr"),
            quantity=parent.find("td").eq(6).text(),
            productid=parent.attr("data-productid"),
            itemname=parent.find("td").eq(1).text(),
            results=""
        // hide errors and notification from the main window
        errordiv.html("")

        serialdetailsquanity.val(quantity)
        serialdetailsname.val(itemname)
        serialdetailsid.val(productid)
        serialserrors.html("")
        // check if serial numbers are existing and edit
        existingserialno=parent.attr("data-serial-nos")
        //console.log(existingserialno)
        if(existingserialno!=""){
            serialnos=existingserialno.split(",")
            if(serialnos.length>0){
                for(var i=0;i<serialnos.length;i++){
                    results+=`<tr><td>${Number(i+1)}</td>`
                    results+=`<td>${serialnos[i]}</td>`
                    results+=`<td><a href='javascript void(0)' class='deletedata' ><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>` // Delete icon
                }
            }else{
                results+=`<tr><td>1</td>`
                results+=`<td>${existingserialno}</td>`
                results+=`<td><a href='javascript void(0)' class='deletedata' ><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>`
            }   
        }else{
            results=""
        }
        serialnumberslist.html(results)
        // compute summaries list
        computeserialsadded()

        // get existing serial numbers for the item selected that haven't been sold yet
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getexistingproductserialnumbers:true,
                productid
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for(var i=0;i<data.length;i++){
                    results+=`<option value='${data[i].serialno}'>${data[i].serialno}</option>`
                }
                serialnumbersdropdownlist.html(results)
            }
        )
        //show the modal
        serialnumbersmodal.modal("show")
    })


    // add serial numbers to list
    addserialnumberstolistbutton.on("click",function(){
        var serialno=serialnumbersdropdownlist.val(),
            results="",
            message=""
            rows=serialnumberslist.find("tbody tr").length
            serialserrors.html("")
        if(serialno!=""){
            results=`<tr><td>${Number(rows+1)}</td>`
            results+=`<td>${serialno}</td>`
            // add edit and delete buttons
            //results+=`<td><a href='javascript void(0)' class='editdata'><span><i class='fas fa-edit fa-sm mt-2'></i></span></a></td>` // Edit icon
            results+=`<td><a href='javascript void(0)' class='deletedata' ><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>` // Delete icon
            $(results).appendTo(serialnumberslist) 
            // remove from the drop down list
            $("#serialnumbers option[value='"+serialno+"']").remove()
            message="The serial number has been added successfully."
            serialserrors.html(showAlert("success",message))
            serialnumbersdropdownlist.val("")
            serialnumbersdropdownlist.focus()
            computeserialsadded()
        }else{
            message="Please select a serial number from the dropdown list first"
            serialserrors.html(showAlert("info",message))
            serialnumbersdropdownlist.focus()
        }
    })

    function computeserialsadded(){
        var quantity=Number(serialdetailsquanity.val()),
            added=Number(serialnumberslist.find("tbody tr").length)
            message=""
        if(added<quantity){
            message=`<span class='alert alert-info'>${added} of ${quantity} serial numbers added</span>`
        }else if(added==quantity){
            message=`<span class='alert alert-success'>${added} of ${quantity} serial numbers added</span>`
        }else{
            message=`<span class='alert alert-danger'>${added} of ${quantity} serials numbers added</span>`
        }
        serialstotal.html(message)
    }
    
    // listen to edit and delete buttons
    serialnumberslist.on("click",".deletedata",function(e){
        e.preventDefault()
        serialserrors.html("")
        var $this=$(this),
            parent=$this.parent("td").parent("tr"),
            serialno=parent.find("td:eq(1)").text()
        // confirm dialog
        bootbox.dialog({
            // title: "Confirm Item Removal!",
            message: "Confirm removal of serial number <strong>"+serialno+"</strong> from the list?",
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
                        parent.remove()
                        // add it back to the list

                        // refresh summary
                        computeserialsadded()
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    // update serials button clicked - Populate data-id of row similar to productid here
    updateserialsbutton.on("click",function(){
        var id=serialdetailsid.val(),
            serialnos=[],
            quantity=Number(serialdetailsquanity.val()),
            added=Number(serialnumberslist.find("tbody tr").length),
            message=""
        
        serialserrors.html(showAlert(""))
        if(added!=quantity){
            message=`${added} of ${quantity} serial numbers added. Correct then try again`
            serialserrors.html(showAlert("info",message))
        }else{
            serialnumberslist.find("tbody tr").each(function(){
                serialnos.push($(this).find("td").eq(1).text())
            })

            // check that the quantity added is the same as the no of serial numbers added

            salesitems.find("tr").each(function(){
                var $this=$(this)
                if($this.attr("data-productid")==id){
                    $this.attr("data-serial-nos",serialnos)
                    // remove highlight if it was added during validation
                    $this.removeClass("text-danger")
                    // change the colour of the add serial number button
                    $this.find("td").eq(6).find("button").addClass("btn-success")
                    $this.find("td").eq(6).find("button").html(`<i class="fas fa-edit fa-sm fa-fw"></i> Edit serial numbers`)
                    serialnumbersmodal.modal("hide")
                    serialserrors.html("")
                }
            })
        } 
    })

    serialnumbersdropdownlist.on("change",function(){
        serialserrors.html("")
    })

    // listen to add payments button click
    addpayments.on("click",function(){
        //  validate fields
        var pointofsale=poslist.val(),
            customerid=customerlist.val(),
            tbody = $("#salesitems tbody"),
            errors="",
        // process all the items 
        missingitems=false
        salesitems.find("tbody tr").each(function(){
            var $this=$(this)

            if($this.attr("data-serializable")==1){
                if($this.attr("data-serial-nos")!=""){
                    $this.removeClass("text-danger")
                }else{
                    $this.addClass("text-danger")
                    missingitems=true
                }  
            }
        })

        // check blank fields
        if(pointofsale==""){
            errors="Please select a <strong>Point of Sale</strong>"
        }
        else if(customerid==""){
            errors="Please select a <strong>Customer</strong>"
        }

        // check whether they are items added on the list

        if (tbody.children().length == 0) {
            errors="Please add at least an Item in the list"
            itemcodefield.focus()
        }else if(missingitems){
            errors="Please provide <strong>Serial Numbers</strong> for all highlighted entries."  
        }
        
        // check if payment methods have been provided and whether reference numbers have been used
        $(".amount").each(function() {
            var paymentmethodid=$(this).attr("id"),
                refno="#"+paymentmethodid+"_ref"
                referenceno=$(refno).val()
            // check amount
            if($(this).val()!=""){
                if(paymentmethodid!=1 || paymentmethodid!=4){
                    $.post(
                        "../controllers/possalesoperations.php",
                        {
                            checkpaymentmodereference:true,
                            modeid:paymentmethodid,
                            referenceno:referenceno
                        },
                        function(data){
                            str=$.trim(data)
                            if(str==true){
                                $(this).addClass("is-invalid")
                                errors="Invalid reference number"
                            }else{
                                $(this).removeClass("is-invalid")
                            }
                        }
                    )
                }
            }
        })

        // show payments page if there is no error
        if(errors==""){
             paymentsmodal.modal("show")
        }else{
            errordiv.html(showAlert("info",errors))
        }  
    })

    // show modal for adding bundle items
    addbundleitembutton.on("click",function(){
        // get bundle items
        bundleitemsmodal.find(".modal-body").html(showAlert("processing","Getting bundle items. Please wait ..."))
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getbundleitems:true
            },
            function(data){
                var results="<div class='card containergroup mt-2 mb-2'><!--<div class='card-header'><h5>Privileges</h5></div>--><div class='card-body scrollableprivilege'><table class='table table-sm table-borderless'>"
                //for(var i=0;i<data.length;i++){
                    //var results="<div class='card containergroup mt-2 mb-2'><div class='card-header'><h5>Bundle Items</h5></div><div class='card-body scrollableprivilege'><table class='table table-sm table-borderless'>"
                for(var i=0;i<data.length;i++){
                    results+=`<tr data-itemcode='${data[i].itemcode}' data-unitprice="${data[i].sellingprice}" data-itemname="${data[i].itemname}"><td><input type='checkbox' id='${data[i].itemcode}' class='checkoption'>&nbsp;&nbsp;`
                    results+=data[i].itemname+"</td></tr>"
                }
                results+="</table> </div> </div>"
                bundleitemsmodal.find(".modal-body").html(results)
                //}
            }
        )
        bundleitemsmodal.modal("show")
    })

    donebundlebuttons.on("click",function(){
        var productdetails=''
        bundleitemsmodal.find(".checkoption").each(function(){
            var $this=$(this),
                parent=$this.parent("td").parent("tr"),
                randomno=randomId()
            if($(this).prop("checked")){
                itemcode=parent.attr("data-itemcode")
                itemname=parent.attr("data-itemname")
                sellingprice=parent.attr("data-unitprice")
                //productid=parent.attr("data-productid")
                // populate the items on the list
                productdetails+=`<tr class='clickable-row' data-id='${randomno}' data-productid='0' data-serializable='0' data-serial-nos=''><td>${itemcode}</td>`
                productdetails+=`<td>${itemname}</td>`
                productdetails+=`<td class='price'>${sellingprice}</td>`
                productdetails+=`<td>0</td>`
                productdetails+=`<td >${sellingprice}</td>`
                productdetails+=`<td class='quantity'>1</td>`
                // Add serial number button if item is serializable
                productdetails+=`<td>&nbsp</td>`
                productdetails+=`<td class='linetotal'>${sellingprice}</td>`
                productdetails+=`<td><a href='javascript void(0)' class='deletedata' data-id='${randomId()}'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>` 
            }
        })

        $(productdetails).appendTo(salesitems.find("tbody"))
        // display overall total
        var total=getItemsTotal()
        overalltotal.html($.number(total,2))
        totalamountpayable.html($.number(total,2))
        // compute totals and balance
        computeTotalAmountPaid()
        // hide the modal
        bundleitemsmodal.modal("hide")
        itemcodefield.val("")
        itemcodefield.focus()
    })

    // show add customer modal
    addcustomerbutton.on("click",function(){
        customermodal.modal("show")
    })

    // get customer categories
    function getcategories(){
        $.getJSON(
            "../controllers/customeroperations.php",
            {
                getcustomercategories:true
            },
            function(data){
                var results=''
                for(var i=0;i<data.length;i++){
                    var selected=data[i].default==1?"selected":""
                    results+=`<option value='${data[i].id}' ${selected}>${data[i].description}</option>`
                }
                customercategorylist.html(results)
            }
        )
    }

    // save the customer
    savecustomerbutton.on("click",function(){
        var categoryid=customercategorylist.val(),
            customername=customernamefield.val(),
            idnumber=idnumberfield.val(),
            pinnumber=pinnumberfield.val(),
            mobile=mobilefield.val(),
            emailaddress=emailaddressfield.val(),
            errors=""
        // check for blank fields
        if(customername==""){
            errors="Please provide the customers name"
            customernamefield.focus()
        }else if(idnumber==""){
            errors="Please provide the ID number"
            idnumberfield.focus()
        }else if(pinnumber==""){
            errors="Please provide PIN number"
            pinnumberfield.focus()
        }else if(mobile==""){
            errors="Please provide Mobile number"
            mobilefield.focus()
        }

        if(errors==""){
            // save the customer
            $.post(
                "../controllers/customeroperations.php",
                {
                    savecustomer:true,
                    id:0,  
                    customername,
                    physicaladdress:"",
                    postaladdress:"",
                    mobile,
                    email:emailaddress,
                    creditlimit:0,
                    category:categoryid,
                    posid:0,
                    onetimecustomer:1,
                    pinno:pinnumber,
                    idno:idnumber
                },
                function(data){
                    data=$.trim(data)
                    if(data=="success"){
                        errors="The customer has been added successfully."
                        // Refresh customers list and selected the last inserted customer
                        getcustomers().done(function(){
                            $.getJSON(
                                "../controllers/customeroperations.php",
                                {
                                    getinsertedcustomer:true
                                },
                                function(data){
                                    customerlist.val(data[0].customerid)
                                }
                            )
                        })
                        // select the customer
                        customererrordiv.html(showAlert("success",errors))
                    }else if(data=="name exists"){
                        errors="Sorry, customer's name exists in the system."
                        customernamefield.focus()
                        customererrordiv.html(showAlert("info",errors))
                    }else if(data=="id exists"){
                        errors="Sorry, customer's ID number exists in the system"
                        customererrordiv.html(showAlert("info",errors))
                        idnumberfield.focus()
                    }else if(data=="pin exists"){
                        errors="Sorry, the customer's PIN exists in the system"
                        pinnumberfield.focus()
                        customererrordiv.html(showAlert("info",errors))
                    }else{
                        errors=`Sorry an error occured ${data}`
                        customererrordiv.html(showAlert("danger",errors))
                    }
                }
            )
        }else{
            // display error message
            customererrordiv.html(showAlert("info",errors))
        }
    })

    // get a list of all the customers when drop down gets focus
    paymentoptions.on("focusin",".customerslist",function(){
        // get the current selected customer
        var customerid=customerlist.val()
        console.log(customerid)
        $.getJSON(
            "../controllers/customeroperations.php",
            {
                getcustomers:true,
                regularcustomers:1,
                onetimecustomers:0
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for (var i = 0; i < data.length; i++) {
                    results+=`<option value='${data[i].customerid}' ${data[i].customerid==customerid ? 'selected': ''}>${toTitleCase(data[i].customername)}</option>`
                } 
                //console.log(results)
                $(".customerslist").html(results)
            }
        )
    })

    paymentoptions.on("keypress",".amount",function(e){
        var keycode = (e.keyCode ? e.keyCode : e.which),
            errors=""
        if(keycode == '13' && $(this).attr("id")==2){
            //console.log($(this))
            var amount=$(this).val()
            // get the mpesa transaction based on the amount
            $.getJSON(
                "../controllers/possalesoperations.php",
                {
                    getmpesatransaction:true,
                    amount
                },
                function(data){
                    if(data.length>0){
                        // Show dialogue with mpesa payment details
                        var results=`<table class='table table-striped table-sm'><thead><th>&nbsp;</th><th>Name</th><th>Amount</th><th>Reference</th><th>Date</th></thead><tbody>`
                        for(var i=0;i<data.length;i++){
                            results+=`<tr><td><input type='radio' name="mpesatransaction" id='${data[i].reference}' class='mt-1' value='${data[i].reference}' checked></td>`
                            results+=`<td>${data[i].sendername}</td>`
                            results+=`<td>${data[i].amount}</td>`
                            results+=`<td>${data[i].reference}</td>`
                            results+=`<td>${data[i].date}</td></tr>`
                        }
                        results+=`</tbody></table>`
                        mpesaconfirmationmodal.find(".modal-body").html(results)
                        // hidepayments modal
                        paymentsmodal.modal("hide")
                        // show mpesa payments modal
                        mpesaconfirmationmodal.modal("show")
                    }else{
                        // show dialog that the transaction reference was not found
                        errors="Sorry, no pending transaction with similar amount found."
                        mpesaconfirmationmodal.find(".modal-body").html(showAlert("info",errors))
                        // hidepayments modal
                        paymentsmodal.modal("hide")
                        // show mpesa payments modal
                        mpesaconfirmationmodal.modal("show")
                    }
                }
            )
        }
    })

    // add mpesa transaction to the list
    addmpesatransactionbutton.on("click",function(){
        // find the row with mpesa
        var reference=mpesaconfirmationmodal.find(".modal-body input[name=mpesatransaction]:checked").val(),
            mpesareferencefield=$("#2_ref")
            mpesareferencefield.prop("disabled",true)
        //console.log(mpesareferencefield)
        // show mpesa payments modal
        mpesareferencefield.val(reference)
        paymentsmodal.modal("show")
        mpesaconfirmationmodal.modal("hide")
    })

    const printer = new WebBluetoothReceiptPrinter(),
        // notifications=$("#notifications"),
        connectprinter=$('#connectprinter')
        // printreceipt=$("#printReceipt")
    let printerstatus="notconnected"

    connectprinter.on('click', async () => {
        // notifications.html("Connecting. Please wait ...")
        try {
            await printer.connect();
            // notifications.html('Printer connected successfully!')
            printerstatus="connected"
            connectprinter.html("<i class='fal fa-print-slash fa-lg fa-fw'></i> Disconnect Printer")
        } catch (error) {
            // notifications.html(`Error connecting to printer: ${error}`)
        }
    })

    function printereceipt(receiptno){
        // else{
            // get company details
            let overalltotal=0
            try {
                let encoder = new ReceiptPrinterEncoder()
                // get receipt details 
                $.getJSON(
                    "../../controllers/possalesoperations.php",
                    {
                        getreceiptheader:true
                    },
                    (data)=>{
                        data=data[0]
                        const companydetails=`
                            ${data.name}
                            ${data.physicaladdress}
                            P.O Box ${data.postaladdress}
                            Tel: ${data.landline}
                            Email: ${data.email}
                            PIN #: ${data.pinno}
                            OFFICIAL RECEIPT
                        `
                        // get receipt details
                        const receiptfooter=data.receiptfooter 
                        // define table collumns
                        const itemssold=[
                                {width:16, align:'left'},
                                {width:15, align:'right'}
                            ],
                            paymentmethods=[
                                {width:9, align:'left'},  // mode name
                                {width:9, align:'right'}, // ref number
                                {width:13, align:'right'}  ],
                            vatanalysis=[
                                {width:7, align:'left'},  // code
                                {width:7, align:'right'}, // rate
                                {width:17, align:'right'}  // vat amount
                            ],

                            // to hold array of vales extracted
                            itemssolddetails=[],
                            paymentmethodsdetails=[],
                            vatanalysisdetails=[]

                        itemssolddetails.push(['Item','Value'])
                        paymentmethodsdetails.push(['Mode','Reference','Amount'])
                        vatanalysisdetails.push(['Code','Rate','VAT'])

                        $.getJSON(
                            "../../controllers/possalesoperations.php",
                            {
                                getreceiptdetails:true,
                                receiptno
                            },
                            (data)=>{
                                data1=data[0]
                                const receiptdetails=`
                                    Receipt #: ${data1.receiptno}
                                    Date: ${data1.receiptdate}
                                    Outlet: ${data1.posname}
                                    Customer: ${data1.customername}
                                `
                                const servedby=data1.servedby
                            
                                // Add table heading
                                data.forEach((item,i)=>{
                                    itemssolddetails.push([`${i+1}. ${item.itemcode}`,($.number(item.quantity*(item.unitprice-item.discount))).toString()])
                                    itemssolddetails.push([item.itemname,`${item.quantity} x ${$.number(item.unitprice-item.discount).toString()}`])

                                    overalltotal+=item.quantity*(item.unitprice-item.discount)
                                })
                                // Add items total
                                itemssolddetails.push(["TOTAL:",$.number(overalltotal).toString()])
                                // Get payment methods
                                $.getJSON(
                                    "../../controllers/possalesoperations.php",
                                    {
                                        getreceiptpaymentmethods:true,
                                        receiptno
                                    },
                                    (data)=>{
                                        data.forEach((paymentmethod,i)=>{
                                            paymentmethodsdetails.push([paymentmethod.paymentmethod,paymentmethod.reference,$.number(paymentmethod.amount).toString()])
                                        })

                                        $.getJSON(
                                            "../../controllers/possalesoperations.php",
                                            {
                                                getreceiptvatanalysis:true,
                                                receiptno
                                            },
                                            (data)=>{
                                                data.forEach((vat,i)=>{
                                                    vatanalysisdetails.push([vat.abbreviation,vat.taxrate,$.number(vat.vat)])
                                                })
                                            
                                                data=encoder
                                                    .initialize()
                                                    .align('left')
                                                    .line(companydetails)
                                                    .align('left')
                                                    .line(receiptdetails)
                                                    .line("-------------------------------")
                                                    .line("ITEMS PURCHASED")
                                                    .line("-------------------------------")
                                                    // add table for purchased items
                                                    .table(itemssold,itemssolddetails)
                                                    .line("===============================")
                                                    .line("PAYMENT METHODS")
                                                    .line("-------------------------------")
                                                    .table(paymentmethods,paymentmethodsdetails)
                                                    .line("===============================")
                                                    .line("VAT ANALYSIS")
                                                    .line("-------------------------------")
                                                    .table(vatanalysis,vatanalysisdetails)
                                                    .line("-------------------------------")
                                                    .line(`Served By: ${servedby}`)
                                                    .line("-------------------------------")
                                                    // .text(mydata)
                                                    .newline()
                                                    .align('left')
                                                    .line(receiptfooter) 
                                                    .newline(2)
                                                    .align('center')
                                                    .qrcode(receiptno)
                                                    .newline(3)
                                                    .encode();
                                                    printer.print(data);
                                            }
                                        )
                                    }
                                )
                            }
                        )
                    } 
                )
            } catch (error) {
                console.error('Error printing receipt:', error)
            }
        // }
    }

})

