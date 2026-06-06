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
                if(quantitytransferred > stockquantity || stockquantity <= 0 || quantitytransferred <= 0 || isNaN(quantitytransferred)){
                    invalidstocktransfer=true
                    $this.addClass("text-danger font-weight-bold")
                    $this.find("td").addClass("text-danger")
                }else{
                    $this.removeClass("text-danger font-weight-bold")
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
                errors="Quantity transferred is invalid or exceeds available stock for all highlighted entries."
            }else if(missingitems){
                errors="Please add <strong>Serial Numbers</strong> for all entries highlighted."
            }
        }
        // console.log(TableData)
        if(errors==""){
             // save the transfer
             var TableData;
             TableData = JSON.stringify(TableData) 
             
             const isMobileOrTablet = window.innerWidth < 992;
             if (isMobileOrTablet) {
                 $("#transfer-modal-progress").show();
                 $("#transfer-modal-result").hide();
                 $("#transferprogressmodal").modal("show");
             }
             
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
                        if (isMobileOrTablet) {
                            $("#transfer-result-icon").attr("class", "fal fa-check-circle fa-5x text-success");
                            $("#transfer-result-title").text("Transfer Successful!");
                            $("#transfer-result-message").html(errors);
                            $("#transfer-result-btn").attr("class", "btn btn-success px-4 py-2 font-weight-bold btn-modal-action");
                            $("#transfer-modal-progress").hide();
                            $("#transfer-modal-result").show();
                        } else {
                            errordiv.html(showAlert("success",errors))
                        }
                        // clear the form
                        clearForm()
                        // print the stock transfer form 
                        url="../printstocktransfer.php?referenceno="+data
                        window.open(url, '_blank');
                    }else{
                        errors=`An error Occured!"${data}`
                        if (isMobileOrTablet) {
                            $("#transfer-result-icon").attr("class", "fal fa-exclamation-circle fa-5x text-danger");
                            $("#transfer-result-title").text("Save Failed!");
                            $("#transfer-result-message").html(errors);
                            $("#transfer-result-btn").attr("class", "btn btn-danger px-4 py-2 font-weight-bold btn-modal-action");
                            $("#transfer-modal-progress").hide();
                            $("#transfer-modal-result").show();
                        } else {
                            errordiv.html(showAlert("danger",errors))
                        }
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

    function getProduct(itemcodeParam){
        var sourcetype=sourcefield.val(),
            sourceid=sourcelist.val(),
            itemcode=itemcodeParam || itemcodefield.val()
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
                    unitsreceived = parseFloat(data[0].unitsreceived) || 0,
                    issued = parseFloat(data[0].issued) || 0,
                    stockquantity=unitsreceived-issued,
                    randomno=randomId(),
                    rowClass = stockquantity <= 0 ? 'text-danger font-weight-bold' : ''
                    results=`<tr class='${rowClass}' data-id='${randomno}' data-itemcode='${data[0].itemcode}' data-productid='${data[0].productid}' data-serializable='${data[0].serializable}' data-serial-nos=''><td>${data[0].itemcode}</td>`
                    results+=`<td>${data[0].itemname}</td>`
                    results+=`<td>${stockquantity}</td>`
                    results+=`<td>${data[0].buyingprice}</td>`
                    results+=`<td class='quantity' contenteditable='true'>1</td>`
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
                    searchresults.html("")
                    if(data.length>0){
                        var results="<div class='searchresults-container'>"
                        results+="<ul class='searchresults list-unstyled mb-0'>"
                        
                        // Select All row
                        results+=`<li class='d-flex align-items-center py-2 px-3 border-bottom' style='cursor: pointer;'>`
                        results+=`<input type='checkbox' class='mr-2 select-all-chk' id='chk_all'>`
                        results+=`<label for='chk_all' class='mb-0 text-dark font-weight-bold' style='cursor:pointer; flex: 1; font-size: 0.78rem;'>All</label>`
                        results+=`</li>`
                        
                        for(i=0;i<data.length;i++){
                            results+=`<li class='d-flex align-items-center py-2 px-3 border-bottom' style='cursor: pointer;'>`
                            results+=`<input type='checkbox' class='mr-2 select-product-chk' id='chk_${data[i].itemcode}' data-itemcode='${data[i].itemcode}'>`
                            results+=`<label for='chk_${data[i].itemcode}' class='mb-0 text-dark font-weight-normal' style='cursor:pointer; flex: 1; font-size: 0.78rem;'>${data[i].itemname}</label>`
                            results+=`</li>`
                        }
                        results+="</ul>"
                        // Beautiful Apply Button Footer with primary background class
                        results+="<div class='p-2 border-top bg-light text-left pl-3'><button type='button' class='btn btn-primary btn-xs px-4 apply-selected-products' style='font-weight: 500; font-size: 0.8rem;'><i class='fal fa-check-circle mr-1' style='font-size: 0.76rem;'></i> Apply</button></div>"
                        results+="</div>"
                        
                        $(results).appendTo(searchresults)
                        searchresults.show()
                        
                        // Initial state sync for "All" checkbox
                        updateSelectAllState();
                    } 
                }
            )
        } else {
            searchresults.hide()
        }
    })

    // Listen to changes on the product checkboxes (to sync "All" checkbox)
    searchresults.on("change", ".select-product-chk", function(e) {
        updateSelectAllState();
    });

    // Listen to changes on the "All" checkbox
    searchresults.on("change", ".select-all-chk", function() {
        var isChecked = $(this).is(":checked");
        
        if(sourcelist.val()==""){
            errors="Please select the source of transfer"
            errordiv.html(showAlert("info",errors))
            $(this).prop("checked", false);
            return;
        }

        searchresults.find(".select-product-chk").each(function() {
            $(this).prop("checked", isChecked);
        });
    });

    // Listen to applying selected multiple products via the Apply button at the bottom
    searchresults.on("click", ".apply-selected-products", function(e){
        e.preventDefault();
        e.stopPropagation();
        
        if(sourcelist.val()==""){
            errors="Please select the source of transfer"
            errordiv.html(showAlert("info",errors))
            searchresults.hide();
            return;
        }

        var checkedChks = searchresults.find(".select-product-chk:checked");

        // Add checked items that are not in the table
        checkedChks.each(function() {
            var itemcode = $(this).attr("data-itemcode");
            var exists = false;
            transferitemsdetails.find("tr").each(function() {
                if ($(this).attr("data-itemcode") == itemcode) {
                    exists = true;
                }
            });
            if (!exists) {
                getProduct(itemcode);
            }
        });

        // Recalculate grand totals
        overalltotal.val($.number(performTotal()));

        searchresults.hide();
        itemcodefield.val("");
    });

    // Allow clicking the entire list item row to toggle checkbox
    searchresults.on("click", "li", function(e) {
        if ($(e.target).is("input") || $(e.target).is("label")) {
            return;
        }
        var $chk = $(this).find("input[type='checkbox']");
        $chk.prop("checked", !$chk.prop("checked")).trigger("change");
    });

    // Helper to dynamically update "All" checkbox state
    function updateSelectAllState() {
        var totalChks = searchresults.find(".select-product-chk").length;
        var checkedChks = searchresults.find(".select-product-chk:checked").length;
        
        if (totalChks > 0 && totalChks === checkedChks) {
            searchresults.find(".select-all-chk").prop("checked", true);
        } else {
            searchresults.find(".select-all-chk").prop("checked", false);
        }
    }

    // Dismiss search dropdown when clicking outside
    $(document).on("click", function(e) {
        if (!$(e.target).closest("#searchproducts").length && !$(e.target).closest("#itemcode").length) {
            searchresults.hide();
        }
    });

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

     // listen to input/keyup/blur on quantity to recalculate line total and overall total on the fly
     transferitemsdetails.on("blur keydown input", ".quantity", function(e){
         var $td = $(this),
             parent = $td.parent("tr"),
             unitprice = parseFloat(parent.find("td").eq(3).text().replace(/,/g, "")) || 0,
             stockquantity = parseFloat(parent.find("td").eq(2).text().replace(/,/g, "")) || 0;

         // If Enter key is pressed, prevent default newline and blur the element
         if (e.type === "keydown" && e.which === 13) {
             e.preventDefault();
             $td.blur();
             return;
         }

         var rawVal = $td.text().trim();
         var quantity = parseFloat(rawVal);

         if (isNaN(quantity) || quantity < 0) {
             quantity = 0;
         }

         // On blur, sanitize the text if it is invalid/empty
         if (e.type === "blur") {
             if (rawVal === "" || isNaN(quantity) || quantity <= 0) {
                 quantity = 1;
                 $td.text("1");
             }
         }

         var linetotal = quantity * unitprice;
         parent.find("td").eq(6).text(linetotal.toFixed(2));
         overalltotal.val($.number(performTotal()));

         // Dynamically check stock balance validation on edit
         if (quantity > stockquantity || stockquantity <= 0 || quantity <= 0) {
             parent.addClass("text-danger font-weight-bold");
             parent.find("td").addClass("text-danger");
         } else {
             parent.removeClass("text-danger font-weight-bold");
             parent.find("td").removeClass("text-danger");
         }
     });

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