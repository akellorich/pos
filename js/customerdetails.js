$(document).ready(function(){
    const idfield=$("#id"),
        customernamefield=$("#customername"),
        physicaladdressfield=$("#physicaladdress"),
        postaladdressfield=$("#postaladdress"),
        mobilefield=$("#mobile"),
        emailfield=$("#email"),
        creditlimitfield=$("#creditlimit"),
        savebutton=$("#savecustomer"),
        errordiv=$("#errors"),
        errors="",
        gotolist=$("#gotolist"),
        categorylist=$("#category"),
        poslist=$("#pos"),
        itemcodefield=$("#itemcode"),
        itemnamefield=$("#itemname"),
        selingpricefield=$("#sellingprice"),
        discountvaluefield=$("#discountvalue"),
        searchresults=$("#searchproducts"),
        savediscount=$("#savediscount"),
        expirydatefield=$("#expirydate"),
        errordiv1=$("#errorsdiscount"),
        discountidfield=$("#discountid"),
        productidfield=$("#productid"),
        discountlist=$("#discountlist"),
        errordiv2=$("#errors2"),
        errordiv3=$("#errors3"),
        errordiv4=$("#errors4"),
        paymentmethodslist=$("#modeofpayment"),
        postpayment=$("#postpayment"),
        openreceivablestable=$("#openreceivables"),
        openreceivanbleslist=$("#openreceivablelist"),
        autodistribute=$("#distribute"),
        overpayfield=$("#overpay"),
        amountpaidfield=$("#amountpaid"),
        clearbutton=$("#clear"),
        startdatefield=$('#startdate'),
        enddatefield=$("#enddate"),
        generatereport=$("#generatereport"),
        statementerrors=$("#statementerrors"),
        customersstatement=$("#report"),
        customeraging=$("#customeraging"),
        customerslist=$("#customerslist"),
        idnofield=$("#idno"),
        pinnofield=$("#pinno"),
        onetimecustomerfield=$("#onetimecustomer"),
        onetimecustomerscheckbox=$("#onetimecustomerscheckbox"),
        regularcustomerscheckbox=$("#regularcustomerscheckbox"),
        addcustomerbutton=$("#addcustomer"),
        inputfields=$("input"),
        selectfields=$("select"),
        statementtypefield=$("#statementtype"),
        customertradingnamefield=$("#customertradingname"),
        credittermsfield=$("#creditterms")
        
    let customerid;

    startdatefield.datepicker({dateFormat: 'dd-M-yy', maxDate: new Date()})
    enddatefield.datepicker({dateFormat: 'dd-M-yy', maxDate: new Date()})
    expirydatefield.datepicker({dateFormat: 'dd-M-yy',minDate: new Date(),maxDate: '31-Dec-2030' })
    
    const mainzonecontrol=$("#mainzone")
    const subzonecontrol=$("#subzone")
    const contactcategorycontrol=$("#contactcategory")
    const contactnamecontrol=$("#contactname")
    const contactemailcontrol=$("#contactemail")
    const contactmobilecontrol=$("#contactmobile")
    const addcontactcontrol=$("#addcustomercontact")
    const customercontactslist=$("#customercontactslist")

    getparentzones()
    getcontactcategories()
    subzonecontrol.html(`<option value=''>&lt;Choose&gt;</option>`)

    addcontactcontrol.click(()=>{
        const categoryid=contactcategorycontrol.val(),
        contactname=contactnamecontrol.val(),
        email=contactemailcontrol.val(),
        mobile=contactmobilecontrol.val(),
        id=0
        let errors=''
        // check for blank fields
        if(categoryid==""){
            errors="Please select contact category"
        }else if(contactname==""){
            errors="Please enter contact name"
        }else if(mobile==""){
            errors="Please enter contact mobile"
        }
        if(errors==""){
            $.post(
                "../controllers/customeroperations.php",
                {
                    savecustomercontact:true,
                    id,
                    contactname,
                    mobile,
                    email,
                    categoryid,
                    customerid
                },
                (data)=>{
                    if(data=="success"){
                        errordiv.html(showAlert("success","Customer contact saved successfully"))
                        // refresh the list
                        getcustomercontacts(customerid)
                    }else if(errors=="exists"){
                        errordiv.html(showAlert("info","Customer contact already exists"))
                    }else{
                        errordiv.html(showAlert("danger",`Sorry an error occured ${data}`))
                    }   
                }
            )
        }else{
            errordiv.html(showAlert("info",errors))
        }
    })

    function getcustomercontacts(customerid){
        customercontactslist.find("body").html("")
        $.getJSON(
            "../controllers/customeroperations.php",
            {
                getcustomercontacts:true,
                customerid
            },
            (data)=>{
                let results=''
                data.forEach((contact,index)=>{
                    results+=`<tr data-id=${contact.id}><td>${Number(index+1)}</td>`
                    results+=`<td>${contact.categoryname}</td>`
                    results+=`<td>${contact.contactname}</td>`
                    results+=`<td>${contact.mobile}</td>`
                    results+=`<td>${contact.email}</td>`
                    // add action buttons
                    results+="<td><a href='#' class='edit'><span><i class='fal fa-edit fa-lg'></i></span></a></td>"
                    results+="<td><a href='#' class='delete'><span><i class='fal fa-trash-alt fa-lg'></span></i></a></td></tr>" 
                })
                customercontactslist.find("tbody").html(results)
            }
        )
    }

    function getcontactcategories(){
        $.getJSON(
            "../controllers/customeroperations.php",
            {
                getcontactcategories:true
            },
            (data)=>{
                let results=`<option value=''>&lt;Choose&gt;</option>`
                data.forEach((category)=>{
                    results+=`<option value='${category.id}'>${category.description}</option>`
                })
                contactcategorycontrol.html(results)
            }
        )
    }
    // get parent zones
    function getparentzones(){
        $.getJSON(
            "../controllers/zoneoperations.php",
            {
                getparentzones:true
            },
            (data)=>{
                let results=`<option value=''>&lt;Choose&gt;</option>`
                data.forEach((zone)=>{
                    results+=`<option value='${zone.id}'>${zone.zonename}</option>`
                })
                mainzonecontrol.html(results)
            }
        )
    }

    function getsubzones(parent){
        const dfd=$.Deferred()
        $.getJSON(
            "../controllers/zoneoperations.php",
            {
                getsubzones:true,
                parent
            },
            (data)=>{
                let results=`<option value=''>&lt;Choose&gt;</option>`
                data.forEach((zone)=>{
                    results+=`<option value='${zone.id}'>${zone.zonename}</option>`
                })
                subzonecontrol.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    mainzonecontrol.change(function(){
        parent=$(this).val()
        if(parent!==""){
            getsubzones(parent)  
        }
    })
    // disable the overpay field
    overpayfield.prop("disabled",true)
    
    inputfields.on("input",()=>{
        errordiv.html("")
    })

    selectfields.on("change",()=>{
        errordiv.html("")
    })

    // clear fields to add a new customer
    addcustomerbutton.on("click",()=>{
        clearCustomerdetails()
    })

    // check regular customers by default
    regularcustomerscheckbox.prop("checked",true)
    // get parameters 
    getparameters()
    // Get existing customers 
    getCustomers()
    
    // listen to checkbox clicks
    onetimecustomerscheckbox.on("change", ()=>{
        getCustomers()
    })

    regularcustomerscheckbox.on("change",()=>{
        getCustomers()
    })

    
    generatereport.on("click",function(){
        var startdate=startdatefield.val(),
            enddate=enddatefield.val(),
            customerid=idfield.val(),
            statementtype=statementtypefield.val(),
            results="",
            runningbalance=0,
            errors=""
        // check for blank fields
        if(startdate==""){
            errors="Please select start date"
        }else if(enddate==""){
            errors="Please select end date"
        }
        if(errors==''){
            // get the customer statement
            statementerrors.html(showAlert("processing","Processing please wait ...", 1))
            if(statementtype=="normal"){
                $.getJSON(
                    "../controllers/reportoperations.php",
                    {
                        getcustomerstatement:true,
                        startdate:startdate,
                        enddate:enddate,
                        customerid:customerid
                    },
                    function(data){
                        if(data.length<1){
                            results="Sorry, there are no records for the specified period"
                            customersstatement.html(showAlert("info", results))
                        }else{
                            results="<table class='table table-sm'><tr><td>Account #: <span class='font-weight-bold'>"+data[0].customerid+"</span></td>"
                            results+="<td class='text-right'>Opening Balance: <span class='font-weight-bold'>"+$.number(data[0].openingbalance,2)+"</span></td></tr>"
                            results+="<td>Name: <span class='font-weight-bold'>"+data[0].customername+"</span></td>"
                            results+="<td class='text-right'>Invoices: <span class='font-weight-bold'>"+$.number(data[0].invoices,2)+"</span></td></tr>"
                            results+="<tr><td>Address: <span class='font-weight-bold'>"+data[0].physicaladdress+", "+data[0].postaladdress+"</span></td>"
                            results+="<td class='text-right'>Payments: <span class='font-weight-bold'>"+$.number(data[0].payments,2)+"</span></td></tr>"
                            results+="<tr><td>Mobile: <span class='font-weight-bold'>"+data[0].mobile+"</span> Email: <span class='font-weight-bold'>"+data[0].email+"</span></td>"
                            results+="<td class='text-right'>Closing Balance: <span class='font-weight-bold'>"+$.number(data[0].closingbalance,2)+"</span></td></tr>"
                            results+="</table>"
                            
                            results+="<table class='table table-striped table-sm'><thead><th>Date</th><th>Reference</th><th>Narrative</th><th class='text-right'>Invoice</th><th class='text-right'>Payment</th><th class='text-right'>Balance</th><thead><tbody>"
                            runningbalance=parseFloat(data[0].openingbalance)

                            for(var i=0;i<data.length;i++){
                                runningbalance+=parseFloat(data[i].invoiceamount)-parseFloat(data[i].invoicepayment)
                                results+="<tr><td>"+data[i].date+"</td>"
                                results+="<td>"+data[i].reference+"</td>"
                                results+="<td>"+data[i].narration+"</td>"
                                results+="<td class='text-right'>"+$.number(data[i].invoiceamount,2)+"</td>"
                                results+="<td class='text-right'>"+$.number(data[i].invoicepayment,2)+"</td>"
                                results+="<td class='text-right'>"+$.number(runningbalance,2)+"</td></tr>"
                            }
                            results+="</tbody></table>"
                            customersstatement.html(results)
                        }
                        
                        statementerrors.html("")
                    }
                )
                // get customer aging analysis
                $.getJSON(
                    "../controllers/reportoperations.php",
                    {
                        getcustomeraginganalysis:true,
                        basedate:enddate,
                        customerid:customerid
                    },
                    function(data){
                        var results="<div class='card mt-2'><div class='card-header'><h5> Customer Aging Analysis</h5></div><div class='card-body'><table class='table table-sm'><thead><th class='text-right'>&lt;= 30</th><th class='text-right'>31-60</th><th class='text-right'>61-90</th><th class='text-right'>91-120</th><th class='text-right'>120+</th><th class='text-right'>TOTAL</th></thead>"
                        results+="<tbody><tr><td class='text-right'>"+$.number(data[0].thirty,2) +"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].sixty,2) +"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].ninety,2) +"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].onetwenty,2) +"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].aboveonetwenty,2) +"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].total,2) +"</td></tr></tbody></table>"
                        results+="</div></div>"
                        customeraging.html(results)
                    }
                )
            }else{
                // generate the customers suspense account statement
                $.getJSON(
                    "../controllers/customeroperations.php",
                    {
                        getcustomersuspenseaccount:true,
                        customerid,
                        startdate,
                        enddate
                    },
                    function(data){
                        var results=`<table class='table table-sm table-striped'><thead><th>Date</th><th>Reference #</th><th>Narration</th><th>Debit</th><th>Credit</th><th>Balance</th><th>Added By</th><thead><tbody>`,
                            runningbalance=0
                        for(var i=0;i<data.length;i++){
                            runningbalance+=Number(data[i].credit)-Number(data[i].debit)
                            results+=`<tr><td>${data[i].date}</td>`
                            results+=`<td>${data[i].referenceno}</td>`
                            results+=`<td>${data[i].narration}</td>`
                            results+=`<td>${$.number(data[i].debit,2)}</td>`
                            results+=`<td>${$.number(data[i].credit,2)}</td>`
                            results+=`<td>${$.number(runningbalance,2)}</td>`
                            results+=`<td>${data[i].addedby}</td></tr>`  
                        }
                        results+=`</tbody>`
                        results+=`</table>`
                        customersstatement.html(results)
                        customeraging.html("")
                        statementerrors.html("")
                    }
                )
            } 
        }else{
            //errors="<p class='text-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> "+errors+"</p>"
            statementerrors.html(showAlert("info",errors))
        }
    })   

    function getparameters(){
        var deferred = new $.Deferred()
        // get customer categories
        $.getJSON(
            "../controllers/customeroperations.php",
            {
                getcustomercategories:"GET"
            },
            function (data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for(i=0;i<data.length;i++){
                    results+="<option value='"+data[i].id+"'>"+(data[i].categoryname || data[i].description)+"</option>"
                }
                categorylist.html(results)
            }
        )
        // get points of sales
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
                    poslist.html(results)
            }
        )
        // get payment methods
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getpaymentmethods:true
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for (var i = 0; i < data.length; i++) {
                    results+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
                } 
                paymentmethodslist.html(results)
            }
        )
        deferred.resolve()
        return deferred.promise()
    }

    // savebutton.on("click",function(){
    //     // check for blank fields
    //     const id=idfield.val(),
    //         customername=customernamefield.val(),
    //         physicaladdress=physicaladdressfield.val(),
    //         postaladdress=postaladdressfield.val(),
    //         mobile=mobilefield.val(),
    //         email=emailfield.val(),
    //         creditlimit=creditlimitfield.val(),
    //         category=categorylist.val(),
    //         posid=poslist.val(),
    //         idno=idnofield.val(),
    //         pinno=pinnofield.val(),
    //         onetimecustomer=onetimecustomerfield.val(),
    //         mainzone=mainzonecontrol.val(),
    //         subzoneid=subzonecontrol.val()

    //    let errors=""
      
    //     if(category==""){
    //         errors="Please select Customer category"
    //         categorylist.focus()
    //     }else if(mainzone==""){
    //         errors="Please select customer Main Zone"
    //         mainzonecontrol.focus()
    //     }else if(subzoneid==""){
    //         errors="Please select customer Subzone"
    //         subzonecontrol.focus()
    //     }else if (posid==""){
    //         errors="Please select point of sale"
    //         poslist.focus()
    //     }
    //     else if(customername==""){
    //         errors="Please provide customer name"
    //         customernamefield.focus()
    //     }else if (creditlimit==""){
    //         errors="Please provide credit limit"
    //         creditlimitfield.focus()
    //     }
    //     else if (physicaladdress==""){
    //         errors="Please provide physcal address"
    //         physicaladdressfield.focus()
    //     }else if(email==""){
    //         errors="Please provide email address"
    //         emailfield.focus()
    //     }
    //     else if(mobile==""){
    //         errors="Please provide mobile number"
    //         mobilefield.focus()
    //     }else if(idno==""){
    //         errors="Please provide ID number"
    //         idnofield.focus()
    //     }else if(pinno==""){
    //         errors="Please provide PIN number"
    //         pinnofield.focus()
    //     }

    //     if(errors==""){
    //         $.post(
    //             "../controllers/customeroperations.php",
    //             {
    //                 savecustomer:"POST",
    //                 id,
    //                 customername,
    //                 physicaladdress,
    //                 postaladdress,
    //                 mobile,
    //                 email,
    //                 creditlimit,
    //                 category,
    //                 posid,
    //                 idno,
    //                 pinno,
    //                 onetimecustomer,
    //                 subzoneid
    //             },
    //             function(data){
    //                 data=$.trim(data)
    //                 if(data=="success"){
    //                     errors="The customer has been saved successfully."
    //                     errordiv.html(showAlert("success",errors))
    //                 } else if(data=="name exists"){
    //                     errors="The customer name already exists in the system"
    //                     errordiv.html(showAlert("info",errors))
    //                 }else if(data=="id exists"){
    //                     errors="The customer's ID number already exists in the system"
    //                     errordiv.html(showAlert("info",errors))
    //                 }else if(data=="pin exists"){
    //                     errors="The customer's PIN number already exists in the system"
    //                     errordiv.html(showAlert("info",errors))
    //                 }else{
    //                     errors=`Sorry an error occured ${data}`
    //                     errordiv.html(showAlert("danger",errors))
    //                 }
    //             }
    //         )
    //     }else{
    //         errordiv.html(showAlert("info",errors))
    //     }
    //     // save the customer
    // })

    savebutton.on("click",function(){
        // check for blank fields
        const id=idfield.val(),
            customername=customernamefield.val(),
            physicaladdress=physicaladdressfield.val(),
            postaladdress=postaladdressfield.val(),
            mobile=mobilefield.val(),
            email=emailfield.val(),
            creditlimit=creditlimitfield.val(),
            category=categorylist.val(),
            posid=poslist.val(),
            idno=idnofield.val(),
            pinno=pinnofield.val(),
            onetimecustomer=onetimecustomerfield.val(),
            subzoneid=subzonecontrol.val(),
            tradingname=customertradingnamefield.val(),
            creditterm=credittermsfield.val()
        let errors=""
      
        if(category==""){
            errors="Please select Customer category"
            categorylist.focus()
        }else if (posid==""){
            errors="Please select point of sale"
            poslist.focus()
        }
        else if(customername==""){
            errors="Please provide customer name"
            customernamefield.focus()
        }else if(tradingname==""){
            errors="Please provide trading name"
            customertradingnamefield.focus()
        // }else if (physicaladdress==""){
        //     errors="Please provide physcal address"
        //     physicaladdressfield.focus()
        // }else if(email==""){
        //     errors="Please provide email address"
        //     emailfield.focus()
        }
        else if(mobile==""){
            errors="Please provide mobile number"
            mobilefield.focus()
        // }else if(idno==""){
        //     errors="Please provide ID number"
        //     idnofield.focus()
        // }else if(pinno==""){
        //     errors="Please provide PIN number"
        //     pinnofield.focus()
        }else if (creditlimit==""){
            errors="Please provide credit limit"
            creditlimitfield.focus()
        }else if(creditterm==""){
            errors="Please select credit terms"
            credittermsfield.focus()
        }

        if(errors==""){
            $.post(
                "../controllers/customeroperations.php",
                {
                    savecustomer:"POST",
                    id,
                    customername,
                    physicaladdress,
                    postaladdress,
                    mobile,
                    email,
                    creditlimit,
                    category,
                    posid,
                    idno,
                    pinno,
                    onetimecustomer,
                    subzoneid,
                    tradingname,
                    creditterm
                },
                function(data){
                    data=$.trim(data)
                    if(data=="success"){
                        errors="The customer has been saved successfully."
                        errordiv.html(showAlert("success",errors))
                    } else if(data=="name exists"){
                        errors="The customer name already exists in the system"
                        errordiv.html(showAlert("info",errors))
                    }else if(data=="id exists"){
                        errors="The customer's ID number already exists in the system"
                        errordiv.html(showAlert("info",errors))
                    }else if(data=="pin exists"){
                        errors="The customer's PIN number already exists in the system"
                        errordiv.html(showAlert("info",errors))
                    }else{
                        errors=`Sorry an error occured ${data}`
                        errordiv.html(showAlert("danger",errors))
                    }
                }
            )
        }else{
            errordiv.html(showAlert("info",errors))
        }
        // save the customer
    })


    gotolist.on("click",function(){
        window.location.href="customerslist.php"
    })

    function getProduct(itemcode){
        errordiv.html("")
        errors="Fetching product details. Please wait ..."
        errordiv1.html(showAlert("processing",errors,1))
        var productdetails=""

        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproductdetails:true,
                productcode:itemcodefield.val(),
                customerid:idfield.val()
            },
            function(data){
                itemcodefield.val("")
                itemnamefield.val(""),
                selingpricefield.val("")
                // check if JSON returned a blank object
                if (Object.keys(data).length===0){
                    errors="No product with similar code found"
                    errordiv1.html(showAlert("info",errors))
                }else{
                    errordiv1.html("")
                    itemcodefield.val(data[0].itemcode)
                    itemnamefield.val(data[0].itemname),
                    selingpricefield.val(data[0].sellingprice)
                    productidfield.val(data[0].productid)
                    discountvaluefield.focus()
                   
                } 
            }
        )
    }

    // listen to itemcode field enter key event
    itemcodefield.keypress(function(event){	
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            errordiv.html(errors)
            getProduct()
        } 
    })  
    
    // search product by name
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
        getProduct()
        searchresults.hide()
    })

    // save customer discount
    savediscount.on("click",function(){
        errors=""
        var itemcode=productidfield.val(),
            discount=discountvaluefield.val(),
            expirydate=expirydatefield.val()
            customerid=idfield.val()
            percentage=0,
            id=discountidfield.val()
            //console.log("Discount: "+discountvaluefield.val())
            $('#percentage').prop('checked')?percentage=1:percentage=0
            // check for blank fields
            if(itemcode==""){
                errors="Please provide itemcode"
            }else if(parseFloat(discount)==0){
                errors="Please provide discount value"
            }else if(expirydate==""){
                errors="Please provide discount expiry date"
            }

            if(errors!=""){
                errordiv1.html(showAlert("info",errors))
            }else{
                // post the data 
                errors="Processing. Please wait .."
                errordiv1.html(showAlert("processing",errors,1))
                $.post(
                    "../controllers/customeroperations.php",
                    {
                        savecustomerdiscount:true,
                        id:id,
                        customerid:customerid,
                        productid:itemcode,
                        expirydate:expirydate,
                        percentage:percentage,
                        discount:discount
                    },
                    function(data){
                        data=$.trim(data)
                        if($.trim(data)=="success"){
                            errors="The customer's discount has been saved successfully."
                            errordiv1.html(showAlert("success", errors))
                            // refresh the list
                            $.getJSON(
                                "../controllers/customeroperations.php",
                                {
                                    getcustomerdiscounts:true,
                                    customerid:customerid
                                },
                                function(data){
                                    displayDiscount(data)
                                }
                            )
                        }else{
                            errordiv1.html(showAlert("danger", data))
                        }
                    }
                )
            }
    })

    function displayDiscount(data){
        var results=""
        for(var i=0;i<data.length;i++){
            results+="<tr><td>"+parseInt(i+1)+"</td>"
            results+="<td>"+data[i].itemcode+"</td>"
            results+="<td>"+data[i].itemname+"</td>"
            results+="<td>"+data[i].sellingprice+"</td>"
            results+="<td>"+data[i].discount+"</td>"
            results+="<td>"+data[i].percentage+"</td>"
            results+="<td>"+data[i].expirydate+"</td>"
            results+="<td><a href='#' data-id="+data[i].id+"'><span><i class='fas fa-edit fa-sm'></i></span></a></td>"
            results+="<td><a href='javascript void(0)' data-id='"+data[i].id+"' class='delete'><span><i class='fas fa-trash-alt fa-sm'></span></i></a></td>" 
        }
        discountlist.html(results)
    }

    // listen to discount delete event
    discountlist.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(2).text()
        errordiv2.html("")
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to DELETE discount for <strong>"+itemname+"?</strong>",
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
                        errordiv2.html(showAlert("processing","Processing. Please wait...",1))
                        $.post(
                            "../controllers/customeroperations.php",
                            {
                                deletecustomerdiscount:true,
                                id:id
                            },
                            function(data){
                                data=$.trim(data)
                                if(data=="success"){
                                    errors="The customer discount has been deleted successfully."
                                    errordiv2.html(showAlert("success",errors))
                                    parent.remove()
                                }else{
                                    errordiv2.html(showAlert("danger",data))
                                }
                            }
                        )
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    // convert table data into an array to push to PHP
    function storeTblValues()
    {
        var TableData = new Array();

        $('#openreceivables tr').each(function(row, tr){
            TableData[row]={
                "possaleid" : $(tr).find('td:eq(1)').text(),
                "amount" :$(tr).find('td:eq(6)').text()
            }    
        }); 
        TableData.shift()  // first row will be empty - so remove
        //TableData.pop()
        return TableData
    }
    
    // listen to save customer receipt
    postpayment.on("click",function(){
        var customerid=idfield.val(),
            modeofpayment=$("#modeofpayment").val(),
            referenceno=$("#referenceno").val(),
            overpay=overpayfield.val(),
            errors=''
        // check for blank fields
        if(customerid==0){
            errors="Please choose a customer first."
        }else if(modeofpayment==0){
            errors="Please choose a mode of payment."
        }else if(referenceno==""){
            errors="Please provide a reference number for the payment."
        }
        if(errors!=''){
           // errors="<p class='alert alert-info'><span><i class='fas fa-info-circle fa-lg fa-fw'></i></span>"+errors+"</p>"
            errordiv3.html(showAlert("info",errors))
        }else{
            // save the payment
            errordiv3.html(showAlert("processing","Processing. Please wait ...",1))
            var TableData
            TableData = JSON.stringify(storeTblValues()) 
            $.post(
                "../controllers/customeroperations.php",
                {
                    savereceipt:"POST",
                    customerid:customerid,
                    modeofpayment:modeofpayment,
                    referenceno:referenceno,
                    TableData:TableData,
                    overpay:overpay
                },
                function(data){
                    data=$.trim(data)
                    //console.log(str)
                    //console.log(str.length)
                    if(data.length==8){
                        errors=`The Payment has been completed successfully. Receipt #:<strong>"${data}"</strong>`
                        errordiv3.html(showAlert("success",errors)) 
                        // print receipt
                        var url="../controllers/customeroperations.php?generatecustomerreceipt=true&receiptno="+data
                        //var win = 
                        window.open(url, '_blank')
                        // clear window
                        clearForm()
                    }else{ 
                        errordiv3.html(showAlert("danger",data))
                        //errors="<p class='alert alert-danger'><span><i class='fas fa-times-circle fa-lg fa-fw'></i></span> "+str+"</p>"
                    } 
                }
            )
        }
    })

    autodistribute.on("click",function(){
        overpayfield.val("0")
        amountpaid=Number(amountpaidfield.val())
        if(Number(amountpaid)>0){
            var balance=0
            // auto distribute the amount if excess is available send to customers suspense account
            errordiv3.html("")
            $('#openreceivablelist tr').each(function(row, tr){
                //console.log(tr)
                balance=Number($(tr).find('td:eq(5)').text())
                //console.log(balance)
                if(amountpaid>0){
                    if(balance<=amountpaid){
                        $(tr).find('td:eq(6)').text(balance)
                        amountpaid-=Number(balance)
                    }else{
                        $(tr).find('td:eq(6)').text(amountpaid)
                        amountpaid=0
                    }
                }  
            })
            // check for any overpayment
            overpayfield.val(amountpaid)
        }else{
            errors="Please provide amount paid first" 
            errordiv3.html(showAlert("info",errors))
        }
    })
    
    clearbutton.on("click",function(){
        clearForm()
    })

    function clearForm(){
        openreceivanbleslist.html("")
        $("#modeofpayment").val(""),
        $("#referenceno").val(""),
        overpayfield.val("")
        amountpaidfield.val("")
    }

    // listen to customer list click
    customerslist.on("click","option",function(){
        let id=$(this).attr("value")
        //console.log(id)
        errordiv.html("")
        idfield.val(id)
        customerid=id
        getparameters().done(function(){
            if(idfield.val()>0){
                // get customers details
                $.getJSON(
                    "../controllers/customeroperations.php",
                    {
                        getcustomerdetails:true,
                        customerid
                    },
                    function(data){
                        customernamefield.val(data[0].customername)
                        customertradingnamefield.val(data[0].tradingname)
                        physicaladdressfield.val(data[0].physicaladdress)
                        postaladdressfield.val( data[0].postaladdress)
                        mobilefield.val( data[0].mobile)
                        emailfield.val( data[0].email)
                        creditlimitfield.val(data[0].creditlimit)
                        categorylist.val(data[0].catid)
                        poslist.val(data[0].posid)
                        onetimecustomerfield.val(data[0].onetimecustomer)
                        pinnofield.val(data[0].pinno)
                        idnofield.val(data[0].idno)
                        credittermsfield.val(data[0].creditterm)
                        // get main and sub zones
                        mainzonecontrol.val(data[0].mainzone)
                        getsubzones(data[0].mainzone).done(()=>{
                            subzonecontrol.val(data[0].subzoneid)
                        })
                    }
                )
                // get discounts 
                $.getJSON(
                    "../controllers/customeroperations.php",
                    {
                        getcustomerdiscounts:true,
                        customerid:idfield.val()
                    },
                    function(data){
                        displayDiscount(data)
                    }
                )
                
                // get open receivables
                $.getJSON(
                    "../controllers/customeroperations.php",
                    {
                        getopenreceivables:true,
                        customerid
                    },
                    function(data){
                        var results=""
                        for(var i=0;i<data.length;i++){
                            results+="<tr><td>"+parseInt(i+1)+"</td>"
                            results+="<td>"+data[i].id+"</td>"
                            results+="<td>"+data[i].transactiondate+"</td>"
                            results+="<td>"+data[i].total+"</td>"
                            results+="<td>"+data[i].paid+"</td>"
                            results+="<td>"+data[i].balance+"</td><td></td></tr>"
                        }
                        console.log(results)
                        if(results!=""){
                            openreceivanbleslist.html(results)
                        }else{
                            openreceivanbleslist.html("<tr><td colspan='7'>Sorry! No Open receivables for the customer</td></tr>")
                        }
                    
                    }
                )

                // get customer contacts
                getcustomercontacts(customerid)
            }
        })
    })

    function getCustomers(){
        let posid=0,
            regularcustomers=regularcustomerscheckbox.is(":checked")?1:0,
            onetimecustomers=onetimecustomerscheckbox.is(":checked")?1:0
        // clear the list
        customerslist.html("")
        if(regularcustomers>0 || onetimecustomers>0){
             // get existing customers
             $.getJSON(
                "../controllers/customeroperations.php",
                {
                    getcustomers:true,
                    posid,
                    regularcustomers,
                    onetimecustomers
                },
                function(data){
                        var results="",
                        // total records
                        totalrecords=data.length
                    for(var i=0;i<data.length;i++){
                        results+="<option value='"+data[i].customerid+"'>"+data[i].customername+"</option>"
                    }
                    customerslist.html(results)
                }
            )   
        }
    }

    function clearCustomerdetails(){
        idfield.val(0)
        customernamefield.val("")
        customertradingnamefield.val("")
        physicaladdressfield.val("")
        postaladdressfield.val("")
        mobilefield.val("")
        emailfield.val("")
        creditlimitfield.val("")
        categorylist.val("")
        poslist.val("")
        onetimecustomerfield.val("")
        pinnofield.val("")
        idnofield.val("")
        categorylist.focus()
        mainzonecontrol.val("")
        subzonecontrol.val("")
        customercontactslist.find("tbody tr").remove()
    }

    // search customer zone
    const zonedetailsmodal=$("#zonedetailsmodal")
    const searchzonesbutton=$("#searchzones")
    const zonesdetailstable=$("#zonesdetailstable")

    // get zone and subzonedetails for table
    getzonesandsubzonesfortable()

    function  getzonesandsubzonesfortable(){
       $.getJSON(
            "../controllers/zoneoperations.php",
            {
                getzonesandsubzones:true
            },
            (data)=>{
                let results=''
                data.forEach((zone,i)=>{
                    results+=`<tr data-zoneid=${zone.zoneid} data-subzoneid=${zone.subzoneid}><td>${Number(i+1)}</td>`
                    results+=`<td>${zone.zonename}</td>`
                    results+=`<td>${zone.subzonename}</td>`
                    results+="<td><a href='#' class='use'><span><i class='fal fa-map-marker-check fa-lg mt-1'></span></i></a></td></tr>" 
                })
                zonesdetailstable.find("tbody").html(results)
                // make a datatable
                zonesdetailstable.DataTable()
            }
       ) 
    }

    searchzonesbutton.on("click",()=>{
        zonedetailsmodal.modal("show")
    })

    zonesdetailstable.on("click",".use",function(e){
        const parent=$(this).closest("tr")
        const zoneid=parent.attr("data-zoneid")
        const subzoneid=parent.attr("data-subzoneid")

        mainzonecontrol.val(zoneid)

        getsubzones(zoneid).done(()=>{
            subzonecontrol.val(subzoneid)
        })

        zonedetailsmodal.modal("hide")
    })

    // copy customer name to trading name
    const copycustomernamebutton=$("#copycustomername")
    
    copycustomernamebutton.on("click",function(){
       customertradingnamefield.val(customernamefield.val()) 
    })

    // edit and delete customer contacts
    customercontactslist.on("click",".edit",function(){

    })

    customercontactslist.on("click",".delete",function(){

    })
})