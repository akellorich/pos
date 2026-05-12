$(document).ready(function(){

    const sourcefield=$("#source"),
        sourcelist=$("#sourceitem"),
        destinationfield=$("#destination"),
        destinationlist=$("#destinationitem"),
        itemcodefield=$("#itemcode"),
        transferitemsdetails=$("#transferreditemsdetails"),
        overalltotal=$("#overalltotal"),
        errordiv=$("#errors"),
        savebutton=$("#save"),
        clearbutton=$("#clear"),
        searchresults=$("#searchproducts"),
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
        issuedtolist=$("#issuedto"),
        storecontrollerlist=$("#storecontroller")

        getsystemusers(issuedtolist,'choose')
        getsystemusers(storecontrollerlist,'choose')


        let result="<option value=''>&lt;Choose One&gt;</option>"
        result+="<option value='warehouse'>Warehouse</option>"
        result+="<option value='pos'>Point of Sale</option>"

        $(result).appendTo(sourcefield)
        $(result).appendTo(destinationfield)

        sourcefield.on("change",function(){
            sourcelist.html("")
            var opt=sourcefield.val(),
                list=""
            if(opt=="warehouse"){
                list=getWarehouses(sourcelist)
            }else{
                list= getPointsOfsale(sourcelist)
            } 
        })

        destinationfield.on("change",function(){
            destinationlist.html("")
            var opt=destinationfield.val(),
                list=""
            if(opt=="warehouse"){
                getWarehouses(destinationlist)
            }else{
                getPointsOfsale(destinationlist)
            }
        })

        function getWarehouses(selectBox){
            var results="<option value=''>&lt;Choose One&gt;</option>"
            $.getJSON(
                "../controllers/warehouseoperations.php",
                {
                   getwarehouses:"GET"
                },
                function(data){                   
                    for(i=0;i<data.length;i++){
                        results+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
                    }
                    $(results).appendTo(selectBox)
                }
            )
        }

        function getPointsOfsale(selectBox){ 
            var results="<option value=''>&lt;Choose One&gt;</option>"
            $.getJSON(
                "../controllers/getpointsofsale.php",
                function(data){                   
                    for(i=0;i<data.length;i++){
                        results+="<option value='"+data[i].id+"'>"+data[i].posname+"</option>"
                    }
                    $(results).appendTo(selectBox)
                }
            ) 
        }

    // listen to enter keypress for itemcode field
    itemcodefield.keypress(function(event){	
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            if(sourcelist.val()==""){
                errors="Please select the source of transfer"
                errordiv.html(showAlert("info",errors))
            }else{
                errors=""
                errordiv.html("")
                getProduct()
            }
        } 
    })   

    itemcodefield.on("change",function(){
        errordiv.html("") 
    })

    savebutton.on("click",function(){
        // check for blank fields
        var tbody = $("#transferreditems tbody"),
            missingitems=false,
            TableData=[],
            errors="",
            invalidstocktransfer=false
        
        if(sourcelist.val()==""){
            errors="Please select the source location"
        }else if (destinationlist.val()==""){
            errors="Please select the destination location"
        }else if(issuedtolist.val().trim()==""){
            errors="Please select issuing officer"
            issuedtolist.focus()
        }else if(storecontrollerlist.val().trim()==""){
            errors="Please select store controller"
            storecontrollerlist.focus()
        }else if(tbody.children().length == 0){
            errors="Please provide at least an Item to transfer."
        }else {
            transferitemsdetails.find("tr").each(function(){
                const $this=$(this),
                    serializable=$this.attr("data-serializable"),
                    serialnos=$this.attr("data-serial-nos"),
                    serials=serialnos.split(","),
                    stockquantity=Number($this.find("td ").eq(2).text().replace(",","")),
                    quantitytransferred=Number($this.find("td ").eq(4).text().replace(",","")),
                    itemcode=$this.find("td").eq(0).text(),
                    unitprice=$this.find("td").eq(3).text(),
                    quantity=$this.find("td").eq(4).text()
                if(quantitytransferred>stockquantity){
                    invalidstocktransfer=true
                    $this.find("td").addClass("text-danger")
                }else{
                    $this.find("td").removeClass("text-danger")
                }   
                //console.log(serialnos)
                if(serializable==1){
                    if(serialnos==""){
                        missingitems=true
                        $this.addClass("text-danger")
                    }else{
                        if(serials.length>0){
                            for(var i=0;i<serials.length;i++){
                                TableData.push({"itemcode":itemcode,"unitprice":unitprice,"quantity":1,"serialno":serials[i]})
                            }
                        }else{
                            TableData.push({"itemcode":itemcode,"unitprice":unitprice,"quantity":quantity,"serialno":serialnos})    
                        }
                        $this.removeClass("text-danger")
                    }
                }else{
                    TableData.push({"itemcode":itemcode,"unitprice":unitprice,"quantity":quantity,"serialno":""})
                }
            })
            if(invalidstocktransfer){
                errors="Quantity transferred exceed stock quantities for ALL highlighted entries"
            }else if(missingitems){
                errors="Please add <strong>Serial Numbers</strong> for all entries highlighted."
            }
        }
        // console.log(TableData)
        if(errors==""){
             // save the transfer
             var TableData;
             TableData = JSON.stringify(TableData) 
             $.post(
                 "../controllers/productoperations.php",
                 {
                    savetransfer:"post",
                    sourcetype:sourcefield.val(),
                    sourceid:sourcelist.val(),
                    destinationtype:destinationfield.val(),
                    destinationid:destinationlist.val(),
                    issuedto:issuedtolist.val(),
                    storecontroller:storecontrollerlist.val(),
                    TableData:TableData
                 },
                 function(data){
                    data=$.trim(data)
                    if(data.length==7){
                        errors=`The Transfer was completed successfully, Reference #:<span class='font-weight-bold'>${data}</span>`
                        errordiv.html(showAlert("success",errors))
                        // clear the form
                        clearForm()
                        // print the stock transfer form 
                        url="../printstocktransfer.php?referenceno="+data
                        window.open(url, '_blank');
                    }else{
                        errors=`An error Occured!"${data}`
                        errordiv.html(showAlert("danger",errors))
                    }
                 }
             )
             // generate the transfer document
        }else{
            errordiv.html(showAlert("info",errors))  
        }
    })

    clearbutton.on("click",function(){
        clearForm()
    })

    function getProduct(){
        var sourcetype=sourcefield.val(),
            sourceid=sourcelist.val(),
            itemcode=itemcodefield.val()
            errordiv.html("")
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getstocktransferitembalance:"post",
                itemcode:itemcode,
                sourceid:sourceid,
                sourcetype:sourcetype
            },
            function(data){
                // add the data to the table
                var source=$("option:selected", sourcelist).text()
                if(data.length==0){
                    errors="Sorry, no quantities for the product found in <strong>"+source+"</strong>"
                    errordiv.html(showAlert("info",errors)) 
                }else{
                    var results="",
                    stockquantity=data[0].unitsreceived-data[0].issued,
                    randomno=randomId()
                    results=`<tr data-id='${randomno}' data-itemcode='${data[0].itemcode}' data-productid='${data[0].productid}' data-serializable='${data[0].serializable}' data-serial-nos=''><td>${data[0].itemcode}</td>`
                    results+=`<td>${data[0].itemname}</td>`
                    results+=`<td>${stockquantity}</td>`
                    results+=`<td>${data[0].buyingprice}</td>`
                    results+=`<td class='quantity'>1</td>`
                    results+=data[0].serializable==1?`<td><button class='btn btn-xs btn-primary addserials' data-id='${randomno}' data-name='${data[0].itemname}'><span><i class='fas fa-plus-circle fa-sm'></i> Add serials numbers</span></button></td>`:`<td>&nbsp</td>`
                    results+=`<td class='linetotal'>${data[0].buyingprice}</td>`
                    results+=`<td><a href='javascript void(0)' class='delete' data-id='${randomId()}'><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>`
                    $(results).appendTo(transferitemsdetails)
                    // perform total
                    overalltotal.val($.number(performTotal()))
                    itemcodefield.val("")
                }
               
            }
        )
    }

    function performTotal(){
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
    
    
    function storeTblValues()
    {
        var TableData = new Array();

        $('#transferreditems tr').each(function(row, tr){
            TableData[row]={
                "itemcode" : $(tr).find('td:eq(0)').text(),
                "unitprice" :$(tr).find('td:eq(3)').text(),
                "quantity" : $(tr).find('td:eq(4)').text()
            }    
        }); 
        TableData.shift()  // first row will be empty - so remove
        //console.log(TableData)
        return TableData
    }

    function clearForm(){
        $("select").val(""),
        $("#transferreditemsdetails").html("")
        itemcodefield.val("")
        overalltotal.val("0.00")
    }

    itemcodefield.on("keyup",function(){
        var name=itemcodefield.val()
        errordiv.html("")
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

    transferitemsdetails.on("click",".delete",function(e){
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
                        overalltotal.val($.number(performTotal()))
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

     // listen to change quantity
     transferitemsdetails.on("click",".quantity",function(e){
        // console.log($(this).html())
         var parent = $(this).parent("tr");
         bootbox.prompt({
             title:"Enter New Quantity",
             size: 'small',
             message: "Enter quantity required",
             inputType: 'number',
             callback: function (result) {
                 if(parseFloat(result)>0){
                     var unitprice= parent.find("td").eq(3).text(),
                         linetotal=parseFloat(result*unitprice)
                     parent.find("td").eq(4).text(result)
                     parent.find("td").eq(6).text(linetotal)
                     overalltotal.val($.number(performTotal()))
                 } 
             }
         });
     })

     transferitemsdetails.on("click",".addserials",function(){
        var $this=$(this), 
            parent=$this.parent("td").parent("tr"),
            quantity=parent.find("td").eq(4).text(),
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
        }
        serialnumberslist.html(results)
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
        if(added!=quantity){
            message=`${added} of ${quantity} serial numbers added. Correct then try again`
            serialserrors.html(showAlert("info",message))
        }else{
            serialnumberslist.find("tbody tr").each(function(){
                serialnos.push($(this).find("td").eq(1).text())
            })

            // check that the quantity added is the same as the no of serial numbers added

            transferitemsdetails.find("tr").each(function(){
                var $this=$(this)
                if($this.attr("data-productid")==id){
                    $this.attr("data-serial-nos",serialnos)
                    // remove highlight if it was added during validation
                    $this.removeClass("text-danger")
                    // change the colour of the add serial number button
                    $this.find("td").eq(5).find("button").addClass("btn-success")
                    $this.find("td").eq(5).find("button").html(`<i class="fas fa-edit fa-sm fa-fw"></i> Edit serial numbers`)
                    serialnumbersmodal.modal("hide")
                    serialserrors.html("")
                }
            })
        } 
    })

    serialnumbersdropdownlist.on("change",function(){
        serialserrors.html("")
    })
})