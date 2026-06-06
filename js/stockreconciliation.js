$(document).ready(function(){
    const idfield=$("#id"),
        savebutton=$("#save"),
        clearbutton=$("#clear"),
        mainmenubutton=$("#gotomain"),
        supplierslist=$("#supplier"),
        itemcodefield=$("#itemcode"),
        purchaseitems=$("#purchaseitems"),
        overalltotal=$("#overalltotal"),
        errordiv=$("#errors"),
        termsfield=$("#narrative"),
        searchresults=$("#searchproducts"),
        posnamelist=$("#posname"),
        categoryfield=$("#category")

    // Intercept errordiv.html to display notifications as modals on mobile/tablet view
    const originalHtml = errordiv.html;
    errordiv.html = function(content) {
        if (!content) {
            return originalHtml.call(errordiv, "");
        }
        
        const $temp = $("<div>").html(content);
        const $alert = $temp.find(".alert");
        
        if ($alert.length > 0) {
            const message = $alert.find(".alert-message").text().trim() || $alert.text().trim();
            const isTransient = message.toLowerCase().includes("processing") || message.toLowerCase().includes("please wait");
            
            if ($(window).width() < 992 && !isTransient) {
                let type = "info";
                let btnClass = "btn-info";
                
                if ($alert.hasClass("alert-success")) {
                    type = "success";
                    btnClass = "btn-success";
                } else if ($alert.hasClass("alert-danger")) {
                    type = "danger";
                    btnClass = "btn-danger";
                } else if ($alert.hasClass("alert-warning")) {
                    type = "warning";
                    btnClass = "btn-warning";
                }
                
                // Get the exact showAlert formatted alert HTML (showing header)
                const modalHtml = showAlert(type, message, 0);
                
                bootbox.dialog({
                    message: modalHtml,
                    centerVertical: true,
                    className: "alert-modal-centered",
                    buttons: {
                        close: {
                            label: '<i class="fas fa-times mr-1" style="font-size: inherit;"></i> Close',
                            className: 'btn-primary btn-sm'
                        }
                    }
                });
                return this;
            }
        }
        return originalHtml.call(errordiv, content);
    };

    let errors=""

    itemcodefield.keypress(function(event){	
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            getProduct();
        } 
    })   
    
    savebutton.on("click",function(){
        // check for blank fields
        const reconcilenarrative=termsfield.val(),
            id=idfield.val(),
            posid=posnamelist.val(),
            category=categoryfield.val()
        let errors=""
        if(posid==""){
            errors="Please select reconciled outlet"
            posnamelist.focus()
        }else if(reconcilenarrative==""){
            errors="Please enter reconcilliation narrative"
            termsfield.focus()
        }if(!errors==""){
            errordiv.html(showAlert("info",errors))
        }else{
            // post the items
            var itemslist=[]
            //console.log(TableData)        
            purchaseitems.find("tbody>tr").each(function(){
                $this=$(this)
                itemid=$this.find("td").eq(0).attr("data-id")
                quantity=$this.find("td").eq(5).text().replace(/,/g, '').trim()
                unitprice=$this.find("td").eq(2).text().replace(/,/g, '').trim()
                itemslist.push({"itemid":itemid,"quantity":quantity,"unitprice":unitprice})
            })
            // check if no item was entered into the list
            
            if(itemslist.length>0){
                itemslistposted=JSON.stringify(itemslist)
                $.post(                
                    "../controllers/productoperations.php",
                    {
                        savestockreconciliation:true,
                        itemslist: itemslistposted,
                        id:id,
                        narration:reconcilenarrative,
                        posid:posid,
                        category
                    },
                function(data){
                    // generate receipt
                        data=$.trim(data) 
                        //console.log(data.toString().length)
                        if(data=="success"){
                            errordiv.html(showAlert("success",`Stock reconcilliation saved successfully.`))
                            // errordiv.html("<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i> Stock reconcilliation saved successfully.</p>")
                            clearForm()
                        }else{
                            // return value stored in msg variable
                            errordiv.html(showAlert("danger",`Sorry an error occured ${data}`))
                        } 
                    }
                )
            }else{
                errordiv.html(showAlert("info","Please enter at least a product in the list"))
                itemcodefield.focus()
            }
        }
    })

    mainmenubutton.on("click",function(){
        window.location.href="main.php"
    })

    function formatNumber(num) {
        let val = parseFloat(num);
        if (isNaN(val)) return "0.00";
        return val.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    function formatQty(num) {
        let val = parseFloat(num);
        if (isNaN(val)) return "0";
        if (val % 1 === 0) {
            return val.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
        } else {
            return val.toLocaleString('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 4 });
        }
    }

    function getItemsTotal(){
        var sum = 0;
        // iterate through each td based on class and add the values
        $(".linetotal").each(function() {
            var value = $(this).text().replace(/,/g, '').trim();
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += parseFloat(value);
            }
        })
        return sum;
    }

    /*function storeTblValues()
    {
        var TableData = new Array();

        $('#purchaseitems tr').each(function(row, tr){
            TableData[row]={
                "itemcode" : $(tr).find('td:eq(0)').text()
                , "unitprice" :$(tr).find('td:eq(2)').text()
                , "discount" : $(tr).find('td:eq(3)').text()
                , "quantity" : $(tr).find('td:eq(5)').text()
            }    
        }); 
        TableData.shift()  // first row will be empty - so remove
        //TableData.pop()
        return TableData
    }*/

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
                        // Find all item codes currently in the table
                        let existingCodes = [];
                        purchaseitems.find("tbody tr").each(function(){
                            existingCodes.push($(this).find("td").eq(0).text().trim());
                        });

                        // Check if all found items are already in the table
                        let allCheckedInTable = true;
                        for(i=0;i<data.length;i++){
                            if(!existingCodes.includes(data[i].itemcode)){
                                allCheckedInTable = false;
                                break;
                            }
                        }

                        // Render Select All row
                        let selectAllChecked = allCheckedInTable ? "checked" : "";
                        results+=`<li class='select-all-row font-weight-bold'>
                            <input type='checkbox' id='selectAllSearchItems' ${selectAllChecked}>
                            <span>Select All</span>
                        </li>`

                        for(i=0;i<data.length;i++){
                            let isChecked = existingCodes.includes(data[i].itemcode) ? "checked" : "";
                            results+=`<li data-code='${data[i].itemcode}'>
                                <input type='checkbox' class='search-item-checkbox' ${isChecked}>
                                <span>${data[i].itemname} (${data[i].itemcode})</span>
                            </li>`
                        }
                        results+="</ul>"
                        
                        // Append the sticky Apply button bar at the bottom of the list
                        results+=`<div class='search-apply-bar p-2 border-top bg-light text-right' style='position: sticky; bottom: 0; z-index: 10;'>
                            <button type='button' id='apply-item' class='btn btn-outline-primary btn-sm'><i class='fas fa-sync fa-fw fa-sm mr-1'></i> Apply</button>
                        </div>`

                        $(results).appendTo(searchresults)
                        searchresults.show()
                    }
                }
            )
        } else {
            searchresults.hide();
        }
    })

    // listen to click events inside search results (just toggle checkboxes)
    searchresults.on("click", "li:not(.select-all-row)", function(e) {
        const $li = $(this);
        const $checkbox = $li.find(".search-item-checkbox");
        
        if (!$(e.target).is(".search-item-checkbox")) {
            $checkbox.prop("checked", !$checkbox.prop("checked"));
        }

        // Update "Select All" checkbox state
        const allItemsCount = searchresults.find(".search-item-checkbox").length;
        const checkedItemsCount = searchresults.find(".search-item-checkbox:checked").length;
        $("#selectAllSearchItems").prop("checked", allItemsCount === checkedItemsCount);

        itemcodefield.focus();
    });

    // click handler for Select All row
    searchresults.on("click", "li.select-all-row", function(e) {
        if (!$(e.target).is("#selectAllSearchItems")) {
            const $cb = $("#selectAllSearchItems");
            $cb.prop("checked", !$cb.prop("checked")).trigger("change");
        }
    });

    // change handler for Select All checkbox
    searchresults.on("change", "#selectAllSearchItems", function() {
        const isChecked = $(this).prop("checked");
        searchresults.find(".search-item-checkbox").prop("checked", isChecked);
    });

    // listen to the Apply button click event (delegated to searchresults)
    searchresults.on("click", "#apply-item", function() {
        const checkedItems = searchresults.find(".search-item-checkbox:checked");
        if (checkedItems.length > 0) {
            checkedItems.each(function() {
                const itemcode = $(this).closest("li").attr("data-code");
                getProduct(itemcode);
            });
        } else {
            const code = itemcodefield.val().trim();
            if (code) {
                getProduct(code);
            }
        }
        searchresults.hide();
        itemcodefield.val("");
        itemcodefield.focus();
    });

    $("#load-all-items").on("click", function() {
        errordiv.html(showAlert("info", "Loading all inventory items. Please wait...", 1));
        
        $.getJSON(
            "../controllers/productoperations.php",
            {
                filterproductbyname: 1,
                name: "",
                posid: posnamelist.val() || 0
            },
            function(data) {
                if (data && data.length > 0) {
                    let existingCodes = [];
                    purchaseitems.find("tbody tr").each(function() {
                        existingCodes.push($(this).find("td").eq(0).text().trim());
                    });
                    
                    let addedCount = 0;
                    let productdetails = "";
                    
                    for (let i = 0; i < data.length; i++) {
                        let item = data[i];
                        if (!existingCodes.includes(item.itemcode)) {
                            productdetails += `<tr><td data-id="${item.productid}">${item.itemcode}</td>`
                            productdetails += "<td>" + item.itemname + "</td>"
                            productdetails += `<td class='text-right unitprice d-none d-md-table-cell'>${formatNumber(item.buyingprice)}</td>`
                            productdetails += `<td class='text-right discount d-none d-md-table-cell'>0.00</td>`
                            productdetails += `<td class='text-right extprice d-none d-md-table-cell'>${formatNumber(item.buyingprice)}</td>`
                            productdetails += `<td class='text-right quantity'>1</td>`
                            productdetails += `<td class='text-right linetotal d-none d-md-table-cell'>${formatNumber(item.buyingprice)}</td>`
                            productdetails += "<td><a href='#' class='delete' data-id='" + randomId() + "'><span><i class='fas fa-trash fa-sm' id='" + item.itemcode + "' name='" + item.itemcode + "'></i></span></a></td></tr>"
                            addedCount++;
                        }
                    }
                    
                    if (addedCount > 0) {
                        $(productdetails).appendTo(purchaseitems.find("tbody"));
                        overalltotal.html(formatNumber(getItemsTotal()));
                        errordiv.html(showAlert("success", `Loaded ${addedCount} new inventory items successfully.`, 1));
                        setTimeout(function() {
                            errordiv.html("");
                        }, 2000);
                    } else {
                        errordiv.html(showAlert("info", "All inventory items are already in the list.", 1));
                        setTimeout(function() {
                            errordiv.html("");
                        }, 2000);
                    }
                } else {
                    errordiv.html(showAlert("danger", "No inventory items found to load."));
                }
            }
        ).fail(function() {
            errordiv.html(showAlert("danger", "An error occurred while loading inventory items."));
        });
    });

    $(document).on("click", function(e) {
        if (!$(e.target).closest("#itemcode, #searchproducts").length) {
            searchresults.hide();
        }
    });

    function getProduct(code){
         var codeToFetch = code || itemcodefield.val();
         if (!codeToFetch) return;

         // Check if already in the table to prevent duplicates
         let exists = false;
         purchaseitems.find("tbody tr").each(function(){
             if ($(this).find("td").eq(0).text().trim() === codeToFetch) {
                 exists = true;
             }
         });
         if (exists) {
             errordiv.html("");
             return;
         }

         // display progress
         errordiv.html(showAlert("info","Processing. Please wait ...",1))
         var productdetails=""

         $.getJSON(
             "../controllers/productoperations.php",
             {
                getproductdetails:true,
                productcode:codeToFetch,
                storeid:0,
                customerid:0
             },
             function(data){
                 // check if JSON returned a blank object
                 if (Object.keys(data).length===0){
                     errordiv.html("")
                     errors="No product with similar code found"
                     errordiv.html(showAlert("info",errors))
                 }else{
                     errordiv.html("")
                     productdetails+=`<tr><td data-id="${data[0].productid}">${data[0].itemcode}</td>`
                     productdetails+="<td>"+data[0].itemname+"</td>"
                     productdetails+=`<td class='text-right unitprice d-none d-md-table-cell'>${formatNumber(data[0].buyingprice)}</td>`
                     productdetails+=`<td class='text-right discount d-none d-md-table-cell'>0.00</td>`
                     productdetails+=`<td class='text-right extprice d-none d-md-table-cell'>${formatNumber(data[0].buyingprice)}</td>`
                     productdetails+=`<td class='text-right quantity'>1</td>`
                     productdetails+=`<td class='text-right linetotal d-none d-md-table-cell'>${formatNumber(data[0].buyingprice)}</td>`
                     productdetails+="<td><a href='#' class='delete' data-id='"+randomId()+"'><span><i class='fas fa-trash fa-sm' id='"+data[0].itemcode+"' name='"+data[0].itemcode+"'></i></span></a></td></tr>"
                     $(productdetails).appendTo(purchaseitems.find("tbody"))
                     // display overall total
                     overalltotal.html(getItemsTotal())
                    errordiv.html("")
                 } 
             }
         )
    }

    // listen to delete data click event
    purchaseitems.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemcode = parent.find("td").eq(0).text().trim();
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
                        parent.remove()
                        // Uncheck in search results checklist if open
                        searchresults.find(`li[data-code='${itemcode}'] .search-item-checkbox`).prop("checked", false);
                        overalltotal.html(getItemsTotal())
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })


    function clearForm(){
        purchaseitems.find("tbody").html("")
        overalltotal.html(formatNumber(0))
        supplierslist.val("")
        termsfield.val("")
        itemcodefield.val("")
        itemcodefield.focus()
        // posnamelist.val("")
    }

    clearbutton.on("click",function(){
        clearForm()
        errordiv.html("")
    })

    $("#reset-all").on("click", function() {
        purchaseitems.find("tbody tr").each(function() {
            const $row = $(this);
            $row.find(".quantity").text("0");
            $row.find(".linetotal").text("0.00");
        });
        overalltotal.html(formatNumber(0));
    });

    // listen to change quantity or unitprice event via contenteditable
    purchaseitems.on("click", ".quantity, .unitprice", function (e) {
        const $cell = $(this);
        if ($cell.attr("contenteditable") !== "true") {
            $cell.attr("contenteditable", "true");
            $cell.focus();
            
            // Select all text in contenteditable cell
            document.execCommand('selectAll', false, null);
        }
    });

    purchaseitems.on("focusout keydown input", ".quantity, .unitprice", function (e) {
        const $cell = $(this);
        const parent = $cell.closest("tr");
        
        if (e.type === "keydown") {
            if (e.key === "Enter") {
                e.preventDefault();
                $cell.blur();
            }
            return;
        }
        
        // Read values safely
        let rawVal = $cell.text().replace(/,/g, '').trim();
        let numericVal = parseFloat(rawVal) || 0;
        
        if ($cell.hasClass("quantity")) {
            const rawUnitPrice = parent.find("td").eq(4).text().replace(/,/g, '').trim();
            const unitprice = parseFloat(rawUnitPrice) || 0;
            const linetotal = numericVal * unitprice;
            
            if (e.type === "focusout") {
                $cell.removeAttr("contenteditable");
                $cell.text(formatQty(numericVal));
                parent.find("td").eq(6).text(formatNumber(linetotal));
            } else {
                parent.find("td").eq(6).text(formatNumber(linetotal));
            }
        } else if ($cell.hasClass("unitprice")) {
            const rawQty = parent.find("td").eq(5).text().replace(/,/g, '').trim();
            const quantity = parseFloat(rawQty) || 0;
            const linetotal = numericVal * quantity;
            
            if (e.type === "focusout") {
                $cell.removeAttr("contenteditable");
                parent.find("td").eq(2).text(formatNumber(numericVal));
                parent.find("td").eq(4).text(formatNumber(numericVal));
                parent.find("td").eq(6).text(formatNumber(linetotal));
            } else {
                parent.find("td").eq(4).text(formatNumber(numericVal));
                parent.find("td").eq(6).text(formatNumber(linetotal));
            }
        }
        
        overalltotal.html(formatNumber(getItemsTotal()));
    });

     /*
     var purchaseid=0
     purchaseid=urlParam("id")
     if(purchaseid>0){
        idfield.val(purchaseid)
        // get purchase order details
       $.getJSON(
           "../controllers/purchaseorderoperations.php",
           {
                getpurchaseorderdetails:true,
                id:idfield.val()
           },
           function(data){
               console.log(data)
                // check if cancelled 
                if(data[0].status=="Cancelled"){
                    bootbox.alert({
                        message: "The Purchase order has been cancelled and cannot be edited",
                        size: 'small'
                    })
                    
                }else if(data[0].status=='Received'){
                    bootbox.alert({
                        message: "The Purchase order has been received and hence cannot be edited",
                        size: 'small'
                    })
                }else{
                    supplierslist.val(data[0].supplierid)
                    termsfield.val(data[0].terms)
                    var  productdetails=''
                    for(var i=0;i<data.length;i++){
                        productdetails+="<tr><td>"+data[i].itemcode+"</td>"
                        productdetails+="<td>"+data[i].itemname+"</td>"
                        productdetails+="<td>"+data[i].unitprice+"</td>"
                        productdetails+="<td>0.00</td>"
                        productdetails+="<td>"+data[i].unitprice+"</td>"
                        productdetails+="<td class='quantity'>"+data[i].quanity+"</td>"
                        productdetails+="<td class='linetotal'>"+parseFloat(data[i].unitprice*data[i].quanity)+"</td>"
                        productdetails+="<td><a href='#' class='delete' data-id='"+randomId()+"'><span><i class='fas fa-trash fa-sm' id='"+data[0].itemcode+"' name='"+data[0].itemcode+"'></i></span></a></td></tr>"
                        purchaseitems.find("tbody").html(productdetails)
                        // display overall total
                        overalltotal.html(getItemsTotal())   
                    }
                }
           }
       ) 
     }
     */

     $('input').on('input',function(){
        errordiv.html("")
     })

     supplierslist.on("change",function(){
        errordiv.html("")
     })

    categoryfield.trigger("change")
    //  get pos
    getPointsOfSale(posnamelist,'choose')

    categoryfield.on("change",()=>{
        const category=categoryfield.val()
        // console.log(category)
        if(category=="outlet"){
            // get points of sale
            getPointsOfSale(posnamelist,'choose')
        }else{
            // get warehouses
            getwarehouses(posnamelist,'choose')
        }
    })
})
