$(document).ready(function(){
    const  idfield=$("#id"),
            suppliernamefield=$("#suppliername"),
            physicaladdressfield=$("#physicaladdress"),
            postaladdressfield=$("#postaladdress"),
            emailfield=$("#email"),
            mobilefield=$("#mobile"),
            creditlimitfield=$("#creditlimit"),
            savebutton=$("#savesupplier"),
            errordiv=$("#errors"), 
            gotolist=$("#goback");
    
    let errors = "";
    
    const   categorylist=$("#productcategory"),
            productslist=$("#productname-checkboxes"),
            saveproducts=$("#supplierproductsform"),
            errordiv1=$("#errorsproduct"),
            supplieridfield=$("#supplierid"),
            supplierproducts=$("#supplierproducts"),
            supplierproductslist=$("#productslist"),
            errordiv2=$("#errorproductlist"),
            addinvoicebutton=$("#addinvoice"),
            startdatefield=$("#startdate"),
            enddatefield=$("#enddate"),
            alldates=$("#alldates"),
            filterbutton=$("#filterbutton"),
            statusfield=$("#status"),
            invoicelist=$("#supplierinvoices"),
            errorinvoices=$("#errorinvoices"),
            supplierstatement=$("#supplierstatement"),
            supplieraging=$("#supplieraging"),
            statementerrors=$("#statementerrors"),
            supplierslist=$("#supplierslist"),
            inputfield=$("input"),
            supplierpinfield=$("#supplierpin")

    alldates.prop("checked",true)
    startdatefield.flatpickr({
        dateFormat: "d-M-Y"
    })
    enddatefield.flatpickr({
        dateFormat: "d-M-Y"
    })

    const threeMonthsAgo = new Date();
    threeMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3);

    statementstartdate=$("#statementstartdate")
    statementenddate=$("#statementenddate")
    statementstartdate.flatpickr({dateFormat: 'd-M-Y', maxDate: 'today', defaultDate: threeMonthsAgo})
    statementenddate.flatpickr({dateFormat: 'd-M-Y', maxDate: 'today', defaultDate: 'today'})

    generatestatement=$("#generatestatement")

    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)
    // get all suppliers
    getsuppliers()
    function getsuppliers(){
        $.getJSON(
            "../controllers/getsuppliers.php",
            function(data){
                var results=""
                for(var i=0;i<data.length;i++){
                    results+="<option value='"+data[i].supplierid+"'>"+data[i].suppliername+"</option>"
                }
                supplierslist.html(results)
            }
        )
    }

    alldates.on("click",function(){
        if(alldates.prop("checked")){
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
        }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
        }
    })

    $("input, select").on("input change",()=>{
        errordiv.html("")
        errordiv1.html("")
        errordiv2.html("")
    })
    
    // filter supplier statement
    generatestatement.on("click",function(){
        console.log("clicked")
        var errors="", results=""
        if(statementstartdate.val()==""){
            errors="<p class='alert alert-danger'>Please select start date</p>"
        }else if(statementenddate.val()==""){
            errors="<p class='alert alert-danger'>Please select end date</p>"
        }else{
            startdate=statementstartdate.val()
            enddate=statementenddate.val()
        }
        if(errors==""){
            var results=""
            // get supplier statement
            supplieraging.html("")
            supplierstatement.html("")
            getSupplierStatement().done(function(){
                // get supplier aging analysis
                $.getJSON(
                    "../controllers/reportoperations.php",
                    {
                        getsupplieraginganalysis:true,
                        basedate:enddate,
                        supplierid:idfield.val()
                    },
                    function(data){
                        results="<p class='alert alert-secondary font-weight-bold'>Aging Analysis</p>"
                        results+="<table class='table table-sm'><thead><th class='text-right'>Current</th><th class='text-right'>31-60</th><th class='text-right'>61-90</th><th class='text-right'>91-120</th><th class='text-right'>120+</th><th class='text-right'>TOTAL</th></thead><tbody>"
                        results+="<tr><td class='text-right'>"+$.number(data[0].thirty,2)+"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].sixty,2)+"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].ninenty,2)+"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].onetwenty,2)+"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].aboveonetwenty,2)+"</td>"
                        results+="<td class='text-right'>"+$.number(data[0].total,2)+"</td></tr></tbody></table>"
                        console.log(results)
                        supplieraging.html(results)
                    } 
                )
                statementerrors.html("") 
            })
        }else{
            statementerrors.html(errors)
        }
    })

    function getSupplierStatement(){
        var dfd= new $.Deferred(),
            results=""
            
        $.getJSON(
            "../controllers/reportoperations.php",
            {
                getsupplierstatement:true,
                startdate:startdate,
                enddate:enddate,
                supplierid:idfield.val()

            },
            function(data){
                var closingbalance=parseFloat(data[0].openingbalance)+parseFloat(data[0].invoices)-parseFloat(data[0].payments),
                    runningbalance=parseFloat(data[0].openingbalance)

                results+="<table class='table table-sm'><tr><td>Account #: <span class='font-weight-bold'> "+data[0].supplierid+"</span></td>"
                results+="<td class='text-right'>Opening Balance: <span class='font-weight-bold'> "+$.number(data[0].openingbalance,2)+"</span></td></tr>"
                results+="<tr><td>Name: <span class='font-weight-bold'> "+data[0].suppliername+"</span></td>"
                results+="<td class='text-right'>Invoices: <span class='font-weight-bold'> "+$.number(data[0].invoices,2)+"</span></td></tr>"
                results+="<tr><td>Address: <span class='font-weight-bold'> "+data[0].physicaladdress+" - "+data[0].postaladdress+"</span></td>"
                results+="<td class='text-right'>Payments: <span class='font-weight-bold'> "+$.number(data[0].payments,2)+"</span></td></tr>"
                results+="<tr><td>Mobile: <span class='font-weight-bold'> "+data[0].mobile+"</span> Email: <span class='font-weight-bold'>"+data[0].email+"</span></td>"
                results+="<td class='text-right'>Closing Balance: <span class='font-weight-bold'> "+$.number(closingbalance,2)+"</span></td></tr></table>"

                results+="<table class='table table-sm table-striped'><thead><th>Date</th><th>Reference</th><th>Narrative</th><th class='text-right'>Invoice</th><th class='text-right'>Payment</th><th class='text-right'>Balance</th></thead><tbody>"
                for(var i=0;i<data.length;i++){
                    if(data[i].reference == null) continue;
                    runningbalance+=parseFloat(data[i].invoiceamount)-parseFloat(data[i].invoicepayment)
                    results+="<tr><td>"+data[i].date+"</td>"
                    results+="<td>"+data[i].reference+"</td>"
                    results+="<td>"+data[i].narrative+"</td>"
                    results+="<td class='text-right'>"+$.number(data[i].invoiceamount,2)+"</td>"
                    results+="<td class='text-right'>"+$.number(data[i].invoicepayment,2)+"</td>"
                    results+="<td class='text-right'>"+$.number(runningbalance,2)+"</td></tr>"
                }
                supplierstatement.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }
    // get all product categories
    getProductCategories(categorylist, "all").done(function(){
        getFilterProducts().done(function(){
            // apply bootstrap select plugin format
            /*productslist.multiselect({
                nonSelectText: 'Select Product(s)',
                includeSelectAllOption: true,
                //enableFiltering: true,
                //enableCaseInsensitiveFiltering: true,
                filterPlaceholder: 'Search for product...',
                buttonWidth:'470px'
            })*/
        })
    })
    
    // get existing supplier products
    //getSupplierProducts()
    // listen to save button click event
    savebutton.on("click",function(){
        // check for blank fields

        var id=idfield.val(),
            suppliername=suppliernamefield.val(),
            physicaladdress=physicaladdressfield.val(),
            postaladdress=postaladdressfield.val(),
            email=emailfield.val(),
            mobile=mobilefield.val(),
            creditlimit=creditlimitfield.val(),
            supplierpinno=supplierpinfield.val(),
            errors=""
        if(suppliername==""){
            errors+="Please provide Supplier name"
            suppliernamefield.focus()
        }  
        else if(physicaladdress==""){
            errors+="Please Physical address"
            physicaladdressfield.focus()
        }
        else if(email==""){
            errors+="Please provide Email address"
            emailfield.focus()
        }
        else if(mobile==""){
            errors+="Please provide Mobile number"
            mobilefield.focus()
        }
        else if(creditlimit==""){
            errors+="Please provide Credit limit"
            creditlimitfield.focus()
        }else if(supplierpinno==""){
            errors="Please provide supplier KRA PIN number"
            supplierpinfield.focus()
        }
        // save the supplier
        if(errors==""){
            $.post(
                "../controllers/savesupplier.php",
                {
                    savesupplier:true,
                    id:id,
                    suppliername:suppliername,
                    physicaladdress:physicaladdress,
                    postaladdress:postaladdress,
                    mobile:mobile,
                    email:email,
                    creditlimit:creditlimit,
                    supplierpinno
                },
                function(data){
                    errordiv.html("")
                    data=data.trim()
                    if(data=="success"){
                        // errors="<div class='text-success'><i class='fas fa-check-circle fa-lg fa-fw'></i></span> "+data.toString()+"</div"
                        errordiv.html(showAlert("success","The supplier has been saved succesfully"))
                        // refresh suppliers list
                        getsuppliers()
                    }else if(data=="exists"){
                        errordiv.html(showAlert("info","Supplier already exists in the system"))
                    }else{
                        errordiv.html(showAlert("info",`Sorry an error occured ${data}`,1))
                    }
                }
            )
        }else{
            // errors="<p class='text-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> "+errors+"</p>"
            errordiv.html(showAlert("info",errors))
            //$(errors).appendTo(errordiv)
        }
    })

    gotolist.on("click",function(){
        //console.log("clicked")
        window.location.href="supplierlist.php"
    })

    // filter product by category
    categorylist.on("change",function(){
        productslist.find("input[type='checkbox']").prop("checked",false)
        getFilterProducts().done(function(){
            //productslist.multiselect('rebuild')
            //productslist.multiselect('refresh')   
        })
    })

    function getFilterProducts(){
        var deferred=new $.Deferred()
        $.getJSON(
            "../controllers/productoperations.php",
            {   
                getproductbycategory:true,
                categoryid:categorylist.val()
            },
            function(data){
                var results=""
                if(data.length > 0) {
                    for(var i=0;i<data.length;i++){
                        results += `
                            <div class="custom-control custom-checkbox mb-1">
                                <input type="checkbox" name="productname[]" class="custom-control-input" id="prod_${data[i].productid}" value="${data[i].productid}">
                                <label class="custom-control-label small" for="prod_${data[i].productid}">${data[i].itemname}</label>
                            </div>`;
                    }
                } else {
                    results = "<p class='text-muted small mb-0'>No products found in this category.</p>";
                }
                productslist.html(results)
                deferred.resolve()
            }
        )
        return deferred.promise()
    }

    saveproducts.on("submit",function(e){
        e.preventDefault()
        //console.log("submitting")
        var form_data=$(this).serialize()
        supplierid=supplieridfield.val()
        if(supplierid==0){
            errordiv1.html(showAlert("info", "Please save the supplier first."))
        }else{
            if(productslist.find("input[type='checkbox']:checked").length == 0){
                errordiv1.html(showAlert("info", "Please select at least one product"))
            }else{
                errordiv1.html(showAlert("info", "Processing ...", 1))
                $.ajax({
                    url:"../controllers/productoperations.php",
                    method:"POST",
                    data:form_data,
                    success: function(data){
                        var results=$.trim(data.toString())
                        if(results=="success"){
                            errordiv1.html(showAlert("success", "Supplier's product(s) saved successfully"))
                            // reset fields
                            productslist.find("input[type='checkbox']").prop("checked",false)
                            // refresh list
                            getSupplierProducts()
                        }else{
                            errordiv1.html(showAlert("info", results))
                        }
                    }
                })  
            }
        }
    })

    function getSupplierProducts(){
        var supplierid=supplieridfield.val()
        errordiv2.html("")
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getsupplierproducts:true,
                supplierid:supplierid
            },
            function(data){
                var results=""
                for(var i=0;i<data.length;i++){
                    results+="<tr><td>"+parseInt(i+1)+"</td>"
                    results+="<td>"+data[i].itemcode+"</td>"
                    results+="<td>"+data[i].itemname+"</td>"
                    results+="<td>"+data[i].dateadded+"</td>"
                    results+="<td>"+data[i].addedbyuser+"</td>"
                    results+="<td><a href='javascript void(0)' class='delete' data-id="+data[i].id+"><span><i class='fas fa-trash-alt fa-sm'></span></i></a></td>" 
                    results+="</tr>"
                }
                supplierproductslist.html(results)
                supplierproducts.DataTable()
            }
        )
    }

    // listen to delete icon clicked event
    // listen to delete button
    supplierproductslist.on("click",".delete",function(e){
        errordiv2.html("")
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(2).text()
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to DELETE <strong>"+itemname+"</strong>?",
            buttons: {
                success: {
                    label: "No, Keep",
                    className: "btn-success",
                    callback: function() {
                        // parent.remove()
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Yes, Remove",
                    className: "btn-danger",
                    callback: function() {
                        //console.log(parent)
                        $.post(
                            "../controllers/productoperations.php",
                            {
                                deletesupplierproduct:true,
                                id:id
                            },
                            function(data){
                                if($.trim(data.toString())=="The product has been deleted successfully."){
                                    errors="<p class='alert alert-success'>"+data.toString()+"</p>"
                                    parent.remove()
                                }else{
                                    errors="<p class='alert alert-danger'>"+data.toString()+"</p>"
                                }
                                errordiv2.html(errors)
                            }
                        )
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    addinvoicebutton.on("click",function(){
        //console.log("Add Invoice clicked!")
        window.location.href="invoicedetails.php"
    })

    filterbutton.on("click",function(){
        supplierid=idfield.val()
        status=statusfield.val(),
        errors=""

        if(alldates.prop("checked")){
            startdate='01-Jan-2019'
            enddate='31-Dec-2100'
        }else{
           if(startdatefield.val()==""){
               errors="<p class='alert alert-danger'>Please select start date</p>"
           }else{
               startdate=startdatefield.val()
           }
           if(enddatefield.val()==""){
               errors="<p class='alert alert-danger'>Please select end date</p>"
           }else{
               enddate=enddatefield.val()
           }
        }
        if(errors==""){
            errorinvoices.html("")
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
                    var results=""
                    for(var i=0;i<data.length;i++){
                        results+="<tr><td>"+parseInt(i+1)+"</td>"
                        results+="<td>"+data[i].invoiceno+"</td>"
                        results+="<td>"+data[i].invoicedate+"</td>"
                        results+="<td>"+$.number(data[i].invoiceamount)+"</td>"
                        results+="<td>"+$.number(data[i].amountpaid)+"</td>"
                        results+="<td>"+$.number(parseFloat(data[i].invoiceamount-data[i].amountpaid))+"</td>"
                        results+="<td>"+data[i].status+"</td>"
                        results+="<td><a href='javascript void(0)' class='deletedata' data-id='"+randomId()+"'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>"
                    }
                    invoicelist.find("tbody").html(results)
                }
            )
        }else{
            errorinvoices.html(errors)
        }
    })

    supplierslist.on("click","option",function(){
        var id=$(this).attr("value")
        // console.log(id)
        $.getJSON(
            "../controllers/supplieroperations.php",
            {
                getsupplierdetails:true,
                supplierid:id
            },
            function(data){
                idfield.val(data.supplierid)
                supplieridfield.val(data.supplierid)
                suppliernamefield.val( data.suppliername),
                physicaladdressfield.val( data.physicaladdress)
                postaladdressfield.val(data.postaladdress)
                emailfield.val( data.email)
                mobilefield.val(data.mobile)
                creditlimitfield.val( data.creditlimit)
                supplierpinfield.val(data.supplierpinno)
            }
        )
        // get supplier products
        getSupplierProducts()
    })
})