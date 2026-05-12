$(document).ready(function(){
    const  supplierslist=$("#supplier"),
        warehouseslist=$("#warehouse"),
        purchaseorderlist=$("#purchaseordernumber"),
        addpoitems=$("#addpurchaseorder"),
        errordiv=$("#errors"),
        pendingorders=$("#receiveditems"),
        overalltotal=$("#overalltotal"),
        savebutton=$("#save"),
        deliverynotefield=$("#deliverynotenumber"),
        mainmenubutton=$("#gotomain"),
        clearform=$("#clear"),
        invoicenumberfield=$("#invoicenumber"),
        invoicefields=$("#invoicefields"),
        serialsmodal=$("#serialsmodal"),
        serialitemname=$("#serialitemname"),
        serialquantity=$("#serialquantity"),
        addserialnumberstolistbutton=$("#saveserialnumbers"),
        serialnumberinputfield=$("#serialnumbers"),
        serialstable=$("#serialstable"),
        serialserrors=$("#serialserrors"),
        serialssummary=$("#serialstotals"),
        saveserials=$("#updateserials"),
        serialidfield=$("#serialitemid"),
        inspectedbylist=$("#inspectedby"),
        transfertopos=$("#transferitemsto"),
        transferreceiveditems=$("#transferreceiveditems")

    let errors=""
    // check if auto adding invoice is set to tru in the db and show the field
    checkautoaddinvoice()
    getPointsOfSale(transfertopos,'choose')
    getsystemusers(inspectedbylist,'choose')

    // get suppliers
    $.getJSON(
        "../controllers/getsuppliers.php",
        function(data){
            var results="<option value=''>&lt;Choose One&gt;</option>"
            for(i=0;i<data.length;i++){
                results+="<option value='"+data[i].supplierid+"'>"+data[i].suppliername+"</option>"
            }
            $(results).appendTo(supplierslist)
        }
    )
    
    // getwarehouses
    $.getJSON(
        "../controllers/warehouseoperations.php",
        {
            getwarehouses:"GET"
        },

        function(data){
            var results="<option value=''>&lt;Choose One&gt;</option>"
            for(i=0;i<data.length;i++){
                results+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
            }
            $(results).appendTo(warehouseslist)
        }
    )

    supplierslist.on("change",function(){
        supplierid=supplierslist.val()
        $.getJSON(
            "../controllers/purchaseorderoperations.php",
            {
                supplierid: supplierid,
                getsupplierpendingorders:"GET"
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                purchaseorderlist.find("option").remove()
                for(i=0;i<data.length;i++){
                    results+="<option value='"+data[i].purchaseorderno+"'>"+data[i].purchaseorderno+"</option>"
                }
                $(results).appendTo(purchaseorderlist)
            }
        )
    })

    addpoitems.on("click",function(){
        var errors=""
        purchaseorderno=purchaseorderlist.val()
        if(purchaseorderno!=""){
            $.getJSON(
                "../controllers/purchaseorderoperations.php",
                {
                    purchaseorderno:purchaseorderno,
                    getpopendingitems:"GET"  
                },
                function(data){
                errordiv.html("")
                var results="",
                    total=0
                    for(i=0;i<data.length;i++){
                        var randomno=randomId()
                        total=data[i].undelivered*data[i].unitprice
                        results+=`<tr data-id='${randomno}' data-serial-nos='' data-serializable='${data[i].serializable}'><td>${data[i].purchaseorderno}</td>`
                        results+=`<td>${data[i].itemcode}</td>`
                        results+=`<td>${data[i].itemname}</td>`
                        results+=`<td>${data[i].ordered}</td>`
                        results+=`<td>${data[i].unitprice}</td>`
                        results+=`<td class='quantity'>${data[i].undelivered}</td>`
                        data[i].serializable==1?results+=`<td><button class='btn btn-xs btn-primary addserials' data-id='${randomno}' data-name='${data[i].itemname}'><span><i class='fas fa-plus-circle fa-sm'></i> Add serials numbers</span></button></td>`:results+=`<td>&nbsp</td>`
                        results+=`<td class='linetotal'>${total}</td>`
                        results+=`<td><a href='javascript void(0)' class='delete' data-id='${randomId()}'><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>`
                    }
                    $(results).appendTo(pendingorders)
                    //console.log($results)
                    // remove the item from the list of orders pending
                    $("#purchaseordernumber option[value='"+purchaseorderno+"']").remove()
                    overalltotal.html(getItemsTotal())
                   // console.log(getItemsTotal())
                }
            )
        }else{
            errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> Please select <strong> Purchase order number</strong></p>"
            errordiv.html(errors) 
            purchaseorderlist.focus()
        }
    })

    savebutton.on("click",function(){
        // disable save button
        savebutton.prop("disabled",true)
        let errors='',
            warehouse=warehouseslist.val(),
            supplierid=supplierslist.val(),
            deliverynoteno=deliverynotefield.val(),
            TableData=[],
            pono,itemcode,unitereceived,
            missingserials=false,
            serialslist=[],
            invoiceno=invoicenumberfield.val(),
            autoaddcustomerinvoice=0,
            inspectedby=inspectedbylist.val(),
            transferitems=transferreceiveditems.val(),
            transferpos=transfertopos.val()
           
        // check if there are any items in the list that are serializable yet serials haven't been provided
        pendingorders.find("tr").each(function(){
            $this=$(this)
            if($this.attr("data-serializable")==1){
                if($this.attr("data-serial-nos")==""){
                    missingserials=true
                    $this.addClass("text-danger")
                }else{
                    $this.removeClass("text-danger")
                }
            }
        })

        // prapare received items parameters to be sent to the server
        $("#receiveditemsdetails tr").each(function(){
            $this=$(this) 
            pono=$this.find('td:eq(0)').text()
            itemcode=$this.find('td:eq(1)').text()
            unitsreceived= $this.find('td:eq(5)').text()
            if($this.attr("data-serializable")==1){
                if($this.attr("data-serial-nos")!=""){
                    serialslist=$this.attr("data-serial-nos").split(",")
                    for(var i=0;i<serialslist.length;i++){
                        TableData.push({"purchaseorderno":pono, "itemcode":itemcode,"unitsreceived":1,"serialno":serialslist[i]})
                    }
                }
            }else{
                TableData.push({"purchaseorderno":pono, "itemcode":itemcode,"unitsreceived":unitsreceived,"serialno":""})
            }
        })

        // check for blank fields
        if(warehouse==""){
            errors="Please select a Warehouse."
            warehouseslist.focus()
        }
        else if(supplierid==""){
            errors="Please select a Supplier."
            supplierslist.focus()
       
        }else if(missingserials){
            errors="Please provide <strong>Serial Numbers</strong> for items highlighted in the list."
        }
        else if(TableData.length==0){
            errors="Please add at least a product to receive."
        } else if(inspectedby==""){
            errors="Please select person who inspected the items"
        }else if(transferitems==1 && transferpos==""){
            errors="Please select destination POS to transfer the items"
            transfertopos.focus()
        }else if(transferitems==0){
            transferpos=0
        }else {
            // check if invoice field is hidden
            if(!invoicefields.is(':hidden')){
                // check if the invoice number was provided
                autoaddcustomerinvoice=1
                if(invoiceno==""){
                    errors="Please provide invoice number"
                    invoicenumberfield.focus()
                }
            }else{
                autoaddcustomerinvoice=0
                invoiceno=""
            }
        }

        //console.log(TableData.length)
        if(errors==""){
            errordiv.html(showAlert("processing","Processing. Please wait ...",1))
            TableData = JSON.stringify(TableData)
            //console.log(TableData)            
            // save the goods received
            $.post(
                "../controllers/goodsreceivedoperations.php",
                {
                    savegoodsreceived:"POST",
                    warehouse:warehouse,
                    supplier:supplierid,
                    inspectedby:inspectedby,
                    deliverynotenumber:deliverynoteno,
                    TableData:TableData,
                    savecustomerinvoice:autoaddcustomerinvoice,
                    invoiceno:invoiceno,
                    transferitems,
                    transferpos
                },
                function(data){                  
                    //console.log(data.length)
                    data=$.trim(data)
                    if(data.length==7){                       
                        errors=`Goods received successfully, GRN # is: <strong>${data}</strong>` 
                        errordiv.html(showAlert("success",errors))
                        clearForm()
                    }else if(data=="exists"){
                        errors="The <strong>Delivery Note Number</strong> is already in use in the system."
                        errordiv.html(showAlert("info",errors))
                        deliverynotefield.focus()
                    }else{
                         errors=`Sorry, an error occured. ${data}`
                        errordiv.html(showAlert("danger",errors))
                    }
                    // re-enable save button
                    savebutton.prop("disabled",false)
                }
            )
            // generate GRN received
        }else{
            errordiv.html(showAlert("info",errors))
            // re-enable save button
            savebutton.prop("disabled",false)
        }
    })

    function getItemsTotal(){
        var sum = 0;
        // iterate through each td based on class and add the values
        $(".linetotal").each(function() {
            var value = $(this).text()
            value=value.replace(",","")
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += parseFloat(value);
            }
        })
        return $.number(sum,2);
    }

    mainmenubutton.on("click",function(){
        window.location.href="main.php"
    })

    clearform.on("click",function(){
        clearForm()
    })

    // listen to delete button click

    pendingorders.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(2).text()
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to remove <strong>"+itemname+"</strong> from the list?",
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
                        overalltotal.html(getItemsTotal())
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

     // listen to change quantity
    pendingorders.on("click",".quantity",function(e){
        // console.log($(this).html())
         var parent = $(this).parent("tr");
         bootbox.prompt({
             title:"Enter New Quantity",
             size: 'small',
             message: "Enter quantity required",
             inputType: 'number',
             callback: function (result) {
                 if(parseFloat(result)>0){
                     var unitprice= parent.find("td").eq(4).text(),
                         linetotal=parseFloat(result*unitprice)
                     parent.find("td").eq(5).text($.number(result,2))
                     parent.find("td").eq(7).text($.number(linetotal,2))
                     //console.log(getItemsTotal())
                     overalltotal.html(getItemsTotal())
                 } 
             }
         });
     })

     function clearForm(){
        $("select").val("")
        $("input[type='text'").val("")
        $("#receiveditems").find("tbody").html("")
        overalltotal.html("0.00")
     }

     // hide the error div when an input is changed
     supplierslist.on("change",function(){
        errordiv.html("")
     })

     warehouseslist.on("change",function(){
        errordiv.html("")
     })

     $("input").on("input",function(){
        errordiv.html("")
     })

     purchaseorderlist.on("change",function(){
        errordiv.html("")
     })

    function checkautoaddinvoice(){
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getinstitutiondetails:true
            },
            function(data){
                return data[0].autoaddinvoiceduringgrn==1?invoicefields.show():invoicefields.hide();
            }
        )
    }

    // open serials modal
    pendingorders.on("click",".addserials",function(){
        var $this=$(this), 
            parent=$this.parent("td").parent("tr")
            quantity=parent.find("td").eq(5).text()
            itemcode=$this.attr("data-id"),
            itemname=$this.attr("data-name")
            serialitemname.val(itemname)
            serialquantity.val(quantity)
            serialidfield.val(itemcode)
        // remove all existing entries
        serialstable.find("tbody").html("")
        // check if there are serials already added and populate to the list 
        if(parent.attr("data-serial-nos")!=""){
            var serials=parent.attr("data-serial-nos").split(","),
                results=""
            for(var i=0;i<serials.length;i++){
                results+=`<tr><td>${Number(i+1)}</td>`
                results+=`<td>${serials[i]}</td>`
                results+=`<td><a href='javascript void(0)' class='editdata'><span><i class='fas fa-edit fa-sm mt-2'></i></span></a></td>` // Edit icon
                results+=`<td><a href='javascript void(0)' class='deletedata' ><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>` // Delete icon
            }

            $(results).appendTo(serialstable.find("tbody"))
            // perform total vs added computations
            serialssummarycount()
        }
        serialsmodal.modal("show")
    })

    addserialnumberstolistbutton.on("click",function(){
        addserialnumbers()
    })

    // hide any error or nofifications when serials input field has changes
    serialnumberinputfield.on("input",function(){
        serialserrors.html("")
    })

    // allow editing of the serial number
    serialstable.on("click",".editdata",function(e){
        e.preventDefault()
        $this=$(this)
        parent=$this.parent("td").parent("tr")
        serialno=parent.find("td").eq(1).text()
        serialnumberinputfield.val(serialno)
        parent.remove()
        // refresh summary
        serialssummarycount()
    })

    // allow removal of the serial numbers
    serialstable.on("click",".deletedata",function(e){
        e.preventDefault()
        var $this=$(this)
        parent=$this.parent("td").parent("tr")
        itemname=parent.find("td").eq(1).text()
        // confirm removal
        bootbox.dialog({
            // title: "Confirm Item Removal!",
            message: "Confirm removal of serial number <strong>"+itemname+"</strong> from the list?",
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
                        // refresh summary
                        serialssummarycount()
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    // compute serials summary
    function serialssummarycount(){
        var total=serialquantity.val(),
            added=serialstable.find("tbody").find("tr").length,
            percentage=0,
            results=""
            //total=(total).toFixed(0)
            percentage=((added/total)*100).toFixed(0)
        if(added>total){
            results=`<span class='alert alert-danger'> Added ${added} of ${Number(total).toFixed(0)} (${percentage}%) serial numbers</span>`  
        }else if(added==total){
            results=`<span class='alert alert-success'> Added ${added} of ${Number(total).toFixed(0)} (${percentage}%) serial numbers</span>` 
        }else{
            results=`<span class='alert alert-info'> Added ${added} of ${Number(total).toFixed(0)} (${percentage}%) serial numbers</span>` 
        }
        
        serialssummary.html(results)

        // renumber the columns if need be
        var i=0
        serialstable.find("tbody tr").each(function(){
            $this=$(this)
            i++
            $this.find("td").eq(0).text(i)
        })
    }

    // listen to enter key on the serialnumberinputfield
    serialnumberinputfield.on("keyup",function(e){
        if(e.which==13){
            addserialnumbers()
        }
    })

    function addserialnumbers(){
        var serialnumbers=serialnumberinputfield.val(),
            results="",
            errors="",
            existingserials=[],
            addedserials=[]
        
        // get the current row number in the table
        row=serialstable.find("tbody").find("tr").length
        if(serialnumbers!=""){
            serials=serialnumbers.split(",")
            // remove any duplicates fromm the array
            serials=uniqueArrayValues(serials)
            // get already added serials
            serialstable.find("tbody tr").each(function(){
                $this=$(this)
                addedserials.push($this.find("td").eq(1).text())
            })

            serialstable.find("tbody")
            if(serials.length>0){
                for(var i=0;i<serials.length;i++){
                    // check whether the serial number has already been added to the list
                    if(addedserials.includes(serials[i])){
                        existingserials.push(serials[i])
                    }else{
                        results+=`<tr><td>${Number(row+1)}</td>`
                        results+=`<td>${serials[i]}</td>`
                        results+=`<td><a href='javascript void(0)' class='editdata'><span><i class='fas fa-edit fa-sm mt-2'></i></span></a></td>` // Edit icon
                        results+=`<td><a href='javascript void(0)' class='deletedata' ><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>` // Delete icon
                        row++
                    }
                }
            }else{
                if(addedserials.includes(sserialnumbers)){
                    existingserials.push(serialnumbers)
                }
                results+=`<tr><td>${Number(row+1)}</td>`
                results+=`<td>${serialnumbers}</td>`
                results+=`<td><a href='javascript void(0)' class='editdata'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td>` // Edit icon
                results+=`<td><a href='javascript void(0)' class='deletedata' ><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>` // Delete icon  
                //row++
            }
            
            if(results!=""){
                $(results).appendTo(serialstable.find("tbody"))
                serialnumberinputfield.val("")
                serialnumberinputfield.focus()
                // perform total vs added computations
                serialssummarycount()
            }
            // show notification for items not added if any
            if(existingserials.length>0){
                errors=`Sorry the following serials already added to the list: ${existingserials.join()}`
                serialserrors.html(showAlert("warning",errors))
            }
            

        }else{
            errors="Please provide a serial number first"
            serialserrors.html(showAlert("info",errors))
            serialnumberinputfield.focus()
        }
    }

    saveserials.on("click",function(){
        // check if serial numbers added exceed the required
        var serials=[],
            total=serialquantity.val(),
            added=serialstable.find("tbody").find("tr").length,
            randomno=serialidfield.val()
        if(Number(added)!==Number(total)){
            errors=`You added ${added} of ${Number(total).toFixed(0)} required serial numbers. Please add correctly then try again`
            serialserrors.html(showAlert("info",errors))
        }else{
            serialstable.find("tbody tr").each(function(){
                $this=$(this)
                serials.push($this.find("td").eq(1).text())
            })
            pendingorders.find("tbody tr").each(function(){
                $this=$(this)
                if($this.attr("data-id")==randomno){
                    $this.attr("data-serial-nos",serials)
                    // change the add serials button to green
                    $this.find("td").eq(6).find("button").addClass("btn-success")
                    $this.find("td").eq(6).find("button").html(`<i class="fas fa-edit fa-sm fa-fw"></i> Edit serial numbers`)
                   // $this.find(".addserial").addClass("btn-success")
                }
                // hide the modal
                serialsmodal.modal("hide")
            })
        }
    })

    // Remove all duplicates in an array
    function uniqueArrayValues(arr) {
        var a = [];
        for (var i=0, l=arr.length; i<l; i++)
            if (a.indexOf(arr[i]) === -1 && arr[i] !== '')
                a.push(arr[i]);
        return a;
    }

    transferreceiveditems.on("click",function(){
        const status=$(this).val()==1?true:false
        transfertopos.prop("disabled",!status)
    })
})