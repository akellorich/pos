$(document).ready(()=>{
    const   quotationmodal=$("#addnewquotationmodal"),
            addnewquotationbutton=$("#addnewquotationbutton"),
            startdatefield=$("#startdate"),
            enddatefield=$("#enddate"),
            alldates=$("#alldates"),
            searchcustomerslist=$("#customer"),
            addquotationcustomerslist=$("#newquotecustomer"),
            quotationtermsfield=$("#newquoteterms"),
            itemidfield=$("#newquoteitem"),
            errordiv=$("#errordiv"),
            soughtproduct={
                productid:'',
                itemcode:'',
                itemname:'',
                unitprice:''
            },
            searchresults=$("#searchproducts"),
            unitpricefield=$("#newquoteunitprice"),
            quantityfield=$("#newquotequantity"),
            descriptionfield=$("#newquotedescription"),
            additemtolistbutton=$("#additemtolist"),
            quotationitemslist=$("#quotationitems"),
            savequotationbutton=$("#savequotation"),
            inputfields=$("input"),
            selectfields=$("select"),
            filterquotationsbutton=$("#filterquotationsbutton"),
            errordiv1=$("#errordiv1"),
            quotationslist=$("#quotationslist"),
            quotationstatusfield=$("#status")

    // set up date pickers
    startdatefield.datepicker({dateFormat: 'dd-M-yy'})
    enddatefield.datepicker({dateFormat: 'dd-M-yy'})
    
    // get customers 
    getCustomers (searchcustomerslist,'all')
    getCustomers (addquotationcustomerslist,'choose')
    
    // preset all date controls
    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)
    
    alldates.on("click",function(){
       if(alldates.prop("checked")) {
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
       }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
       }
    })

    // get quotation terms
    $.getJSON(
        "../controllers/quotationoperations.php",
        {
            getquotationterms:true
        },
        (data)=>{
            // let results=`<option value=''>&lt;Choose One&gt;</option>`
            let results=`<option value=''>100 percent on order</option>`
            data.forEach((term)=>{
                results+=`<option value=${term.id}>${term.termname}</option>`
            })
            quotationtermsfield.html(results)
        }
    )

    // show add new quotation modal
    addnewquotationbutton.on("click",()=>{
        quotationmodal.modal("show")
    })

    // search product by product code on enter key press
    itemidfield.on("keypress",(event)=>{
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            if(addquotationcustomerslist.val()==""){
                errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i></span> Please select a customer first</p>"
                errordiv.html(errors)
            }else{
                errordiv.html(errors)
                productcode=itemidfield.val()
                customerid=addquotationcustomerslist.val()
                getProduct(productcode,customerid)
            }
        } 
    })
    
    // search product by name
    itemidfield.on("keyup",()=>{
        let name=itemidfield.val()
        if(name.length>2){
            $.getJSON(    
                "../controllers/productoperations.php",
                {
                    filterproductbyname:1,
                    name:name
                },
                function(data){
                    let results="<ul class='searchresults'>"
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

    // function to search for a product
    function getProduct(productcode,customerid){
        // display progress
        errordiv.html("")
        errors="Fetching product details. Please wait ..."
        errordiv.html(showAlert("processing",errors,1))
    
        $.getJSON(
            "../controllers/productoperations.php",
            {   
                getproductdetails:true,
                productcode,
                customerid
            },
            function(data){
                // check if JSON returned a blank object
                if (Object.keys(data).length===0){
                    errors="No product with similar code found"
                    errordiv.html(showAlert("info",errors))
                }else{
                    errordiv.html("")
                    const sellingprice=data[0].sellingprice-data[0].discount
                    soughtproduct.itemcode=data[0].itemcode
                    soughtproduct.itemname=data[0].itemname
                    soughtproduct.productid=data[0].productid
                    soughtproduct.unitprice=sellingprice
                    itemidfield.val(data[0].itemcode)
                    unitpricefield.val(sellingprice)
                    quantityfield.val(1)
                    descriptionfield.focus()
                } 
            }
        )
    }

       // listen to the click event of search term when clicked
       searchresults.on("click","li",function(){
        const customerid=addquotationcustomerslist.val()
        const productcode=$(this).attr("id")
        
        if(customerid==""){
            errors="Please select a customer first"
            errordiv.html(showAlert("info",errors))
            addquotationcustomerslist.focus()
        }else{
            getProduct(productcode,customerid)
        }     
        searchresults.hide()
    })

    // add item to list
    additemtolistbutton.on("click",()=>{
        let description=descriptionfield.val(),
            unitprice=unitpricefield.val(),
            quantity=quantityfield.val()
            errors=""
        // check for blank fields
        if(soughtproduct.productid==""){
            errors="Please select a product first"
            itemidfield.focus()
        }else if(Number(unitpricefield)<0){
            errors="Please provide correct unit price"
            unitpricefield.focus()
        }else if(Number(quantity)<0){
            errors="Please provide correct quantity"
            quantityfield.focus()
        }
        if(errors==""){
            // add the item to the list
            let rows=quotationitemslist.find("tbody tr").length
            let item=`<tr data-productid='${soughtproduct.productid}'><td>${rows+1}</td>`
            item+=`<td>${soughtproduct.itemcode}</td>`
            item+=`<td>${soughtproduct.itemname}</td>`
            item+=`<td>${description}</td>`
            item+=`<td>${quantity}</td>`
            item+=`<td>${unitprice}</td>`
            item+=`<td>${quantity*unitprice}</td>`
            item+=`<td><a href='javascript void(0)' class='deletequotationitem'><span><i class='fal fa-trash-alt fa-lg'></i></span></a></td></tr>`
            $(item).appendTo(quotationitemslist.find("tbody"))
            
            // reset the sought product and items specific form fields
         
            soughtproduct.productid=""
            soughtproduct.itemcode=""
            soughtproduct.itemname=""
            soughtproduct.unitprice=0

            itemidfield.val("")
            descriptionfield.val("")
            quantityfield.val("")
            unitpricefield.val("")
            itemidfield.focus()
        }else{
            errordiv.html(showAlert("info",errors))
        }
    })

    // listen to remove quotation item
    quotationitemslist.on("click",".deletequotationitem",function(e){
        e.preventDefault()
        let parent = $(this).parent("td").parent("tr"),
            itemname=parent.find("td").eq(2).text()
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
                        parent.remove()
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    // save quotation
    savequotationbutton.on("click",()=>{
        let quotationitems=[],productid,description,quantity,unitprice, 
            customerid=addquotationcustomerslist.val(), 
            quotationterms=$("#newquoteterms option:selected").text(),
            errors="", notification=""

        quotationitemslist.find("tbody tr").each(function(){
            $this=$(this)
            productid=$this.attr("data-productid")
            description=$this.find("td").eq(3).text()
            quantity=$this.find("td").eq(4).text()
            unitprice=$this.find("td").eq(5).text()
            quotationitems.push({"productid":productid,"description":description,"quantity":quantity,"unitprice":unitprice})
        })

        // check for blank fields
        if(customerid==""){
            errors="Please select customer first"
            addquotationcustomerslist.focus()
        }else if(quotationterms==""){
            errors="Please select the quotation terms first"
            quotationtermsfield.focus()
        }else if(quotationitems.length==0){
            errors="Please add at least an item in the quotation"
        }

        if(errors==""){
            // save the quotation
            quotationitems=JSON.stringify(quotationitems)
            // console.log(quotationitems)
            console.log(quotationterms)
            $.post(
                "../controllers/quotationoperations.php",
                {
                    savequotation:true,
                    id:0,
                    customerid,
                    quotationterms,
                    quotationitems
                },
                (data)=>{
                    data=data.trim()
                    if(data.length==7){
                        notification=`The quotation was saved successfully. Quote Number is <strong>${data}</strong>`
                        errordiv.html(showAlert("success",notification))
                        // clear the form
                        clearform()
                    }else{
                        errors=`Sorry an error occured ${data}`
                        errordiv.html(showAlert("danger",errors))
                    }
                }
            )
        }else{
            // display the errors
            errordiv.html(showAlert("info",errors))
        }
    })

    // hide errors and notifications
    inputfields.on("input",()=>{
        errordiv.html("")
    })

    selectfields.on("change",()=>{
        errordiv.html("")
    })

    function clearform(){
        inputfields.val("")
        selectfields.val("")
        addquotationcustomerslist.focus()
    }

    filterquotationsbutton.on("click",()=>{
        let startdate,enddate, errors="", quotestatus, customerid
        errordiv1.html("")
        if(alldates.prop('checked')){
            startdate='01-Jan-2000'
            enddate='31-dec-2100'
        }else{
            // check if dates have been provided
            if(startdatefield.val()==""){
                errors="<p class='alert alert-danger'>Please provide start date </p>"
            }else if(enddatefield.val()==""){
                errors="<p class='alert alert-danger'>Please provide end date </p>"
            }else{
                startdate=startdatefield.val()
                enddate=enddatefield.val()
            }
        }
        if(errors==""){
            errordiv1.html("")
            customerid=searchcustomerslist.val()
            quotestatus=quotationstatusfield.val()
            $.getJSON(
                "../controllers/quotationoperations.php",
                {
                    filterquotations:"GET",
                    startdate,
                    enddate,
                    quotestatus,
                    customerid
                },
                (data)=>{
                    // console.log(data)
                    let results=`
                        <table class="table table-sm table-striped" id="quotationslist">
                            <thead>
                                <th>#</th>
                                <th>Date</th>
                                <th>Quote #</th>
                                <th>Customer</th>
                                <th>Value</th>
                                <th>Status</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                            </thead>
                            <tbody>`

                    for(let i=0;i<data.length;i++){
                        results+=`<tr><td>${parseInt(i+1)}</td>`
                        results+=`<td>${data[i].quotationdate}</td>`
                        results+=`<td>${data[i].quoteno}</td>`
                        results+=`<td>${data[i].customername}</td>`
                        results+=`<td>${data[i].quotetotal}</td>`
                        results+=`<td>${data[i].status}</td>`
                        results+=`<td><a href='javascript void(0)' class='view' data-id="${data[i].quoteno}"'><span><i class='fal fa-eye fa-lg' ></i></span></a></td>`
                        results+=`<td><a href='../printquotation.php?quotationno=${data[i].quoteno}' target='_blank' class='printquotation' data-quotationno="${data[i].quotationno}"><span><i class='fal fa-print fa-lg' ></i></span></a></td>`
                        results+=`<td><a href='javascript void(0)' class='delete validation' data-id="${data[i].quoteno}" id='48'><span><i class='fas fa-trash-alt fa-sm'></span></i></a></td>` 
                    }
                    results+='</tbody></table>'
                    quotationslist.html(results)
                    $("#possaleslist").DataTable({
                        dom: 'Bfrtip',
                        lengthChange: false,
                        buttons: [
                            'pageLength','excel', 'pdf', 'print'
                        ]
                    })
                    errordiv1.html("")   
                }
            )
        }else{
            errordiv1.html(errors)
        }
    })

    quotationslist.on("click",".view",function(e){
        e.preventDefault()
        // view quotation details
    })
})