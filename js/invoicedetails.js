$(document).ready(function(){
    var supplierslist=$("#supplier"),
        startdatefield=$("#startdate"),
        enddatefield=$("#enddate"),
        alldates=$("#alldates"),
        invoicedate=$("#invoicedate"),
        filterbutton=$("#searchgrn"),
        errordiv=$("#errors"),
        uninvoicedgrns=$("#uninvoicedgrns"),
        allgrn=$("#allgrn"),
        totalfield=$("#invoicetotal"),
        savebutton=$("#saveinvoice"),
        invoicenofield=$("#invoiceno"),
        invoicedatefield=$("#invoicedate")
       
    alldates.prop("checked",true)
    startdatefield.prop("disabled",true)
    enddatefield.prop("disabled",true)

    startdatefield.flatpickr({
        maxDate: new Date(),
        dateFormat: 'd-M-Y'
    });
    enddatefield.flatpickr({
        maxDate: new Date(),
        dateFormat: 'd-M-Y'
    });
    invoicedate.flatpickr({
        maxDate: new Date(),
        dateFormat: 'd-M-Y',
        defaultDate: new Date()
    });

    getSuppliers(supplierslist,'choose')
    

    alldates.on("click",function(){
        if(alldates.prop("checked")){
            startdatefield.prop("disabled",true)
            enddatefield.prop("disabled",true)
        }else{
            startdatefield.prop("disabled",false)
            enddatefield.prop("disabled",false)
        }
    })

    filterbutton.on("click",function(){
        var errors=''
        supplierid=supplierslist.val()
        if(supplierid==""){
            errors="Please select a supplier first"
            supplierslist.focus()
        }else if(alldates.prop("checked")){
            startdate='01-Jan-2019'
            enddate='31-Dec-2100'
        }else{
            if(startdatefield.val()=="" || enddatefield.val()=="" ){
                errors="Please provide both start and end dates"
            }else{
                startdate=startdatefield.val()
                enddate=enddatefield.val()
            }
        }

        if(errors==''){
            errordiv.html(showAlert("info", "Processing. Please wait ..."))
            $.getJSON(
                "../controllers/grnoperations.php",
                {
                    getuninvoicedgrn:true,
                    startdate:startdate,
                    enddate:enddate,
                    supplierid:supplierid
                },
                function(data){
                    var results=''
                    for(var i=0;i<data.length;i++){
                        results+="<tr><td><input type='checkbox' id='"+data[i].id+"' class='grn'></td>"
                        results+="<td class='d-none d-md-table-cell'>"+parseInt(i+1)+"</td>"
                        results+="<td>"+data[i].grnno+"</td>"
                        results+="<td>"+data[i].deliverynono+"</td>"
                        results+="<td class='d-none d-md-table-cell'>"+data[i].datereceived+"</td>"
                        results+="<td class='text-right'>"+$.number(data[i].ordertotal,0)+"</td></tr>"
                    }
                    uninvoicedgrns.html(results)
                    errordiv.html("")
                }
            ) 
        }else{
            errordiv.html(showAlert("warning", errors))
        }
    })

    allgrn.on("click",function(){
        if(allgrn.prop("checked")){
            $(".grn").each(function(){
                $(this).prop("checked",true)
            })
        }else{
            $(".grn").each(function(){
                $(this).prop("checked",false)
            })
        }
        computeTotals()
    })

    function computeTotals(){
        var total=0
        $(".grn").each(function(){
            if($(this).prop("checked")){
                parent=$(this).parent("td").parent("tr")
                amount=parent.find("td").eq(5).text()
                amount=amount.replace(/,/g, '') 
                total+=parseFloat(amount)
            }
        }) 
        totalfield.val($.number(total))
    }
   
    uninvoicedgrns.on("click",".grn",function(){
        computeTotals()
        allgrn.prop("checked",false)
    })

    savebutton.on("click",function(){
        //console.log("save button clicked")
        var data = [], supplierid, invoiceno, invoicedate, errors=""
        supplierid=supplierslist.val()
        invoiceno=$.trim(invoicenofield.val())
        invoicedate=invoicedatefield.val()
        //console.log("supplier id: " +supplierid)
        // Check for Blank Fields
        if(supplierid==0){
            errors="Please select supplier first"
        }else if(invoiceno==""){
            errors="Please provide invoice number first"
        }else if(invoicedate==""){
            errors="Please select invoice date first"
        }
        //console.log(errors)
        if(errors==""){
            //saverror.find("card-body").html("<p>Processing ...</p>")
            $(".grn").each(function(){
                if($(this).prop("checked")){
                    parent=$(this).parent("td").parent("tr")
                    id=parent.prop("id")
                    grnno=parent.find("td").eq(2).text()
                    data.push({grnno: grnno})
                }
            })
            TableData=JSON.stringify(data)
            console.log(TableData)
            $.post(
                "../controllers/supplieroperations.php",
                {
                    savesupplierinvoice:true,
                    TableData:TableData,
                    supplierid:supplierid,
                    invoiceno:invoiceno,
                    invoicedate:invoicedate
                },
                function(data){
                    var results=$.trim(data.toString())
                    if(results=="success"){
                        errordiv.html(showAlert("success", "The Invoice has been saved successfully."))
                        clearForm()
                    }else{
                        errordiv.html(showAlert("danger", "Sorry. An error occurred: " + results))
                    }
                }
            )
        }else{
            errordiv.html(showAlert("warning", errors))
        }
            
    })
   
    function clearForm(){
        supplierslist.val("")
        invoicenofield.val("")
        invoicedatefield.val("")
        uninvoicedgrns.html("<tr><td colspan='6' class='text-center text-muted py-4'>No records listed. Select supplier and apply filters.</td></tr>")
        totalfield.val("0.00")
        allgrn.prop("checked", false)
    }

    $("#clear").on("click", function(){
        clearForm()
    })
})