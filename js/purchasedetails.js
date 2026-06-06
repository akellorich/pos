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
        termsfield=$("#terms"), 
        searchresults=$("#searchproducts"),
        categoryfield=$("#purchasetype"),
        currencyfield=$("#currency"),
        exchangeratefield=$("#exchangerate"),
        departmentlist=$("#department"),
        taxtypefield=$("#taxtype"),
        applytaxrate=$("#taxrate")

    let errors=""
    let taxrate=0

    // get suppliers
    const supplierPromise = $.getJSON(
        "../controllers/getsuppliers.php",
        function(data){
            var results="<option value=''>&lt;Choose One&gt;</option>"
            for(i=0;i<data.length;i++){
                results+="<option value='"+data[i].supplierid+"'>"+data[i].suppliername+"</option>"
            }
            $(results).appendTo(supplierslist)
        }    
    )

    const deptPromise = getdepartments(departmentlist,'choose')
    const currencyPromise = getscurrencies(currencyfield, 'choose')
    const taxPromise = gettaxtypes(taxtypefield,'choose')

    getdefaultpoterms()
    
    itemcodefield.keypress(function(event){	
        const keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            // check if supplier has been selected
            if(supplierslist.val()!=""){
               getProduct()
            }else{
                errors="<p class='alert alert-info'><i class='fas fa-info-circle fa-lg fa-fw'></i> Please select a supplier first</p>"
                errordiv.html(errors)
            }
            
        } 
    })   
    
    savebutton.on("click",function(){
        // disable save button
        savebutton.prop("disabled",true)
        // check for blank fields
        const supplierid=supplierslist.val(),
            id=idfield.val(),
            departmentid=departmentlist.val(),
            currencyid=currencyfield.val(),
            exchangerate=exchangeratefield.val(),
            terms=termsfield.val(),
            taxid=taxtypefield.val(),
            category=categoryfield.val()

        let errors=""

        errordiv.html("")    
        // re-enable save button
        savebutton.prop("disabled",false)

        let items=[]
        let notification=''

        purchaseitems.find("tbody tr").each(function(){
            row=$(this)
            const itemcode=row.attr("data-productid")
            const unitprice=row.find(".unitprice").text().replace(",","") 
            const quantity=row.find(".quantity").text().replace(",","") 
            const taxable=row.find(".taxable").prop("checked")?1:0
            const taxinclusive=row.find(".taxinclusive").prop("checked")?1:0
            items.push({"itemcode":itemcode,"unitprice":unitprice,"quantity":quantity,"taxable":taxable,"taxinclusive":taxinclusive})
        })

        if(supplierid==""){
            errors="Please select the Supplier"
            supplierslist.focus()
            // errordiv.html(errors)
        }else if(departmentid==""){
            errors="Please select department"
            departmentlist.focus()
        }else if(currencyid==""){
            errors="Please select currency"
            currencyfield.focus()
        }else if(Number(exchangerate)<=0){
            errors="Please enter correct exchage rate"
            exchangeratefield.focus()
        }else if(taxid==""){
            errors="Please select applicable tax"
            taxtypefield.focus()
        }else if(items.length<=0){
            errors="Please add at least an item first"
        }
        
        if(errors==""){
            // post the items
            items=JSON.stringify(items)         
            $.post(                
                "../controllers/purchaseorderoperations.php",
                {
                    savepurchaseorder:true,
                    TableData: items,
                    supplierid,
                    id,
                    terms,
                    departmentid,
                    category,
                    currencyid,
                    exchangerate,
                    taxid,
                    taxrate
                },
               function(data){
                   // generate receipt
                    data=$.trim(data) 
                    // re-enable save button
                    savebutton.prop("disabled",false)
                    if(data.length<12){
                        notification=`Transaction completed successfully. Purchase Order Number is : <strong>"${data.toString()}"</strong>`
                        errordiv.html(showAlert("success",notification))
                        clearForm()
                    }else{
                        notification=`Sorry an error occured ${data}`
                        errordiv.html(showAlert("danger",notification))
                    } 
                }
            )
        }else{
            errordiv.html(showAlert("info",errors))
        }
    })

    mainmenubutton.on("click",function(){
        window.location.href="main.php"
    })

    function getItemsTotal(){
        let sum = 0;
        // iterate through each td based on class and add the values
        $(".totalitem").each(function() {
            let value = $(this).text().replace(/,/g,"");
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += Number(value);
            }
        })
        return sum;
    }

    function storeTblValues()
    {
        let TableData = new Array();

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
    }

    itemcodefield.on("keyup",function(){
        const name=itemcodefield.val()
        if(name.length>2){
            $.getJSON(    
                "../controllers/productoperations.php",
                {
                    filterproductbyname:1,
                    name:name
                },
                function(data){
                    let results="<div class='searchresults-container' style='background: white; border: 1px solid #cbd5e1; border-radius: 6px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); overflow: hidden;'>"
                    results+="<ul class='searchresults' style='list-style: none; margin: 0; padding: 0; max-height: 250px; overflow-y: auto;'>"
                    searchresults.html("")
                    if(data.length>0){
                        for(i=0;i<data.length;i++){
                            results+=`<li class='search-item-row' id='${data[i].itemcode}' style='display: flex; align-items: center; gap: 8px; padding: 6px 12px; cursor: pointer; border-bottom: 1px solid #f1f5f9;'>`
                            results+=`<input type='checkbox' class='select-product-chk' data-itemcode='${data[i].itemcode}' style='cursor: pointer; width: 16px; height: 16px;'>`
                            results+=`<span style='flex-grow: 1; font-size: 13px; color: #334155;'>${data[i].itemname}</span>`
                            results+=`</li>`
                        }
                        results+="</ul>"
                        results+="<div style='padding: 8px 12px; border-top: 1px solid #e2e8f0; display: flex; justify-content: flex-end; gap: 8px; background: #f8fafc;'>"
                        results+="<button type='button' class='btn btn-xs btn-outline-danger' id='cancel-search-selection' style='padding: 2px 8px; font-size: 11px;'>Cancel</button>"
                        results+="<button type='button' class='btn btn-xs btn-success' id='add-selected-search-items' style='padding: 2px 8px; font-size: 11px;'><i class='fas fa-plus-circle'></i> Add Selected</button>"
                        results+="</div>"
                        results+="</div>"
                        
                        $(results).appendTo(searchresults)
                        searchresults.show()
                    } 
                }
            )
        }
    })

    // Toggle checkbox on clicking the search row itself (excluding checkbox clicks to avoid double toggling)
    searchresults.on("click", ".search-item-row", function(e) {
        if (!$(e.target).is("input[type='checkbox']")) {
            const $chk = $(this).find(".select-product-chk");
            $chk.prop("checked", !$chk.prop("checked"));
        }
    });

    // Add selected items to list
    searchresults.on("click", "#add-selected-search-items", function(e) {
        e.stopPropagation();
        const selectedCodes = [];
        searchresults.find(".select-product-chk:checked").each(function() {
            selectedCodes.push($(this).attr("data-itemcode"));
        });
        
        if (selectedCodes.length === 0) {
            bootbox.alert({
                message: "Please check at least one item to add.",
                size: 'small'
            });
            return;
        }
        
        // Loop through and load each product
        selectedCodes.forEach(function(itemcode) {
            getProduct(itemcode);
        });
        
        searchresults.hide();
        itemcodefield.val("");
        itemcodefield.focus();
    });

    // Cancel selection
    searchresults.on("click", "#cancel-search-selection", function(e) {
        e.stopPropagation();
        searchresults.hide();
        itemcodefield.val("");
        itemcodefield.focus();
    });

    function itemCodeExists(itemcode) {
        let exists = false;
        purchaseitems.find("tbody tr").each(function () {
            let firstTdText = $(this).find("td:first").text().trim(); // Get first <td> text
            if (firstTdText === itemcode) {
                exists = true;
                return false; // Break the loop if found
            }
        });
        return exists;
    }

    function getProduct(specifiedItemCode){
        // display progress
        const itemcode = specifiedItemCode || itemcodefield.val();
        errordiv.html("")
        if(itemCodeExists(itemcode)){
            errordiv.html(showAlert("info",`Item already added to the list`))
        }else{
            let productdetails=""
            errordiv.html(showAlert("processing","Processing. Please wait ...",1))
            $.getJSON(
                "../controllers/productoperations.php",
                {
                    getproductdetails:true,
                    productcode:itemcode
                },
                function(data){
                // check if JSON returned a blank object
                if (Object.keys(data).length===0){
                    errordiv.html("")
                    errors="No product with similar code found"
                    errordiv.html(showAlert("info",errors))
                    $(errors).appendTo(errordiv)
                }else if(data[0].disallowpurchasing == 1){
                    errordiv.html("")
                    errors="Purchasing is disallowed for this item: " + data[0].itemname
                    errordiv.html(showAlert("danger",errors))
                }else{
                    errordiv.html("")
                    productdetails+="<tr data-productid='"+data[0].productid+"'><td>"+data[0].itemcode+"</td>"
                    productdetails+="<td>"+data[0].itemname+"</td>"
                    productdetails+="<td class='unitprice d-none d-lg-table-cell'>"+data[0].buyingprice+"</td>"
                    productdetails+="<td class='d-none d-lg-table-cell'><input type='checkbox' checked class='taxable'></td>"
                    productdetails+="<td class='d-none d-lg-table-cell'><input type='checkbox' checked class='taxinclusive'></td>"
                    //  productdetails+="<td>0.00</td>"
                    //  productdetails+="<td>"+data[0].buyingprice+"</td>"
                    productdetails+="<td class='quantity text-align-right'>1</td>"
                    productdetails+="<td class='linetotal text-align-right'>"+data[0].buyingprice+"</td>"
                    productdetails+="<td class='totaltax text-align-right d-none d-lg-table-cell'>0.00</td>"
                    productdetails+="<td class='totalitem text-align-right d-none d-lg-table-cell'>0.00</td>"
                    productdetails+="<td class='text-align-center'><a href='#' class='delete' data-id='"+randomId()+"'><span><i class='fas fa-trash fa-sm' id='"+data[0].itemcode+"' name='"+data[0].itemcode+"'></i></span></a></td></tr>"
                    $(productdetails).appendTo(purchaseitems.find("tbody"))
                    // display overall total
                    computetaxes()
                    //  overalltotal.val(getItemsTotal())
                    errordiv.html("")
                } 
            })
        }
    }

    // listen to delete data click event
    purchaseitems.on("click",".delete",function(e){
        e.preventDefault();
        const id = $(this).attr('data-id');
        const parent = $(this).parent("td").parent("tr");
        const itemname=parent.find("td").eq(1).text()
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
                        overalltotal.val($.number(getItemsTotal(), 2))
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    function clearForm(){
        purchaseitems.find("tbody").html("")
        overalltotal.val(0.00)
        supplierslist.val("")
        termsfield.val("")
        itemcodefield.val("")
        itemcodefield.focus()
    }

    clearbutton.on("click",function(){
        clearForm()
        errordiv.html("")
    })

    // Listen to quantity and unit price clicks to make them contenteditable
    purchaseitems.on("click", ".quantity, .unitprice", function (e) {
        const $cell = $(this);
        // Only trigger edit if not already editing
        if ($cell.attr("contenteditable") !== "true") {
            $cell.attr("contenteditable", "true");
            $cell.focus();
            
            // Select all text in contenteditable cell
            document.execCommand('selectAll', false, null);
        }
    });

    // Listen for keydown, input, and focusout events on .quantity and .unitprice
    purchaseitems.on("focusout keydown input", ".quantity, .unitprice", function (e) {
        const $cell = $(this);
        const $row = $cell.closest("tr");
        
        if (e.type === "keydown") {
            if (e.key === "Enter") {
                e.preventDefault();
                $cell.blur();
            }
            return;
        }
        
        // On blur (focusout), strip contenteditable, sanitize input, and update
        if (e.type === "focusout") {
            $cell.removeAttr("contenteditable");
            
            let rawVal = $cell.text().replace(/,/g, '').trim();
            let parsedVal = parseFloat(rawVal) || 0;
            
            if ($cell.hasClass("quantity")) {
                if (parsedVal <= 0) parsedVal = 1; // Enforce minimum quantity of 1
                $cell.text($.number(parsedVal, 2));
            } else if ($cell.hasClass("unitprice")) {
                if (parsedVal < 0) parsedVal = 0; // Enforce non-negative unit price
                $cell.text($.number(parsedVal, 2));
            }
            
            computetaxes();
        } else if (e.type === "input") {
            // Keep dynamic updates running during input typing without modifying the active caret
            computetaxes();
        }
    });

      let purchaseid=0
      purchaseid=urlParam("id")
      if(purchaseid>0){
         idfield.val(purchaseid)
         
         // Wait for all dynamic dropdowns to be fully loaded first
         $.when(supplierPromise, deptPromise, currencyPromise, taxPromise).done(function() {
             // get purchase order details
             $.getJSON(
                 "../controllers/purchaseorderoperations.php",
                 {
                      getpurchaseorderdetails:true,
                      id:idfield.val()
                 },
                 function(data){
                      if (!data || data.length === 0) return;
                      
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
                          // Populate Step 1 fields
                          supplierslist.val(data[0].supplierid)
                          departmentlist.val(data[0].departmentid)
                          categoryfield.val(data[0].category)
                          currencyfield.val(data[0].currencyid)
                          exchangeratefield.val(data[0].exchangerate)
                          taxtypefield.val(data[0].taxid)
                          termsfield.val(data[0].terms)
                          
                          if(data[0].currencyid != 1){
                              exchangeratefield.prop("disabled", false)
                          }else{
                              exchangeratefield.prop("disabled", true)
                          }
                          
                          let productdetails=''
                          for(let i=0;i<data.length;i++){
                              if (data[i].itemid && data[i].itemid > 0) {
                                  productdetails+="<tr data-productid='"+data[i].itemid+"'><td>"+data[i].itemcode+"</td>"
                                  productdetails+="<td>"+data[i].itemname+"</td>"
                                  productdetails+="<td class='unitprice d-none d-lg-table-cell'>"+data[i].unitprice+"</td>"
                                  productdetails+="<td class='d-none d-lg-table-cell'><input type='checkbox' checked class='taxable'></td>"
                                  productdetails+="<td class='d-none d-lg-table-cell'><input type='checkbox' checked class='taxinclusive'></td>"
                                  productdetails+="<td class='quantity text-align-right'>"+data[i].quanity+"</td>"
                                  productdetails+="<td class='linetotal text-align-right'>"+data[i].unitprice+"</td>"
                                  productdetails+="<td class='totaltax text-align-right d-none d-lg-table-cell'>0.00</td>"
                                  productdetails+="<td class='totalitem text-align-right d-none d-lg-table-cell'>"+parseFloat(data[i].unitprice*data[i].quanity)+"</td>"
                                  productdetails+="<td class='text-align-center'><a href='#' class='delete' data-id='"+randomId()+"'><span><i class='fas fa-trash fa-sm' id='"+data[i].itemcode+"' name='"+data[i].itemcode+"'></i></span></a></td></tr>"
                              }
                          } 
                          purchaseitems.find("tbody").html(productdetails)
                          overalltotal.val($.number(getItemsTotal(), 2))   
                      }
                 }
             )
         })
      }

    $('input').on('input',function(){
        errordiv.html("")
    })

    supplierslist.on("change",function(){
        errordiv.html("")
    })



    exchangeratefield.prop("disabled",true)
    exchangeratefield.val(1)

    currencyfield.on("change",function(){
        $this=$(this)
        if($this.attr("data-default")==1){
            exchangeratefield.prop("disabled",true)
            exchangeratefield.val(1)
        }else{
            exchangeratefield.prop("disabled",false)
            exchangeratefield.val("")
        }
    })

    taxtypefield.on("change",function(){
        taxid=$(this).val()
        if(taxid==""){
            taxrate=0
        }else{
            $.getJSON(
                "../controllers/settingoperations.php",
                {
                    gettaxdetails:true,
                    taxid
                },
                (data)=>{
                    taxrate=data[0].taxrate
                    // recompute all taxes 
                    computetaxes()
                }
            ) 
        }
    })

    // compute taxes
    function computetaxes(){
        purchaseitems.find("tbody tr").each(function(){
            const row=$(this)
            const taxable=row.find(".taxable")
            const unitprice = parseFloat(row.find(".unitprice").text().replace(/,/g,"")) || 0
            const quantity = parseFloat(row.find(".quantity").text().replace(/,/g,"")) || 0
            let totalprice = unitprice * quantity
            let tax = 0
            if(taxable.prop("checked")){
                const taxinclusive=row.find(".taxinclusive")
                if(taxinclusive.prop("checked")){
                    totalprice = (((100)/(100+Number(taxrate)))*totalprice)
                }
                tax = ((taxrate/100)*totalprice)
            }
            
            // Render formatted with thousands separators only if not focused to avoid caret/cursor jumping while typing
            if (!row.find(".unitprice").is(":focus")) {
                row.find(".unitprice").text($.number(unitprice, 2))
            }
            if (!row.find(".quantity").is(":focus")) {
                row.find(".quantity").text($.number(quantity, 2))
            }
            row.find(".linetotal").text($.number(totalprice, 2))
            row.find(".totaltax").text($.number(tax, 2))
            row.find(".totalitem").text($.number(totalprice + tax, 2))
        })
        overalltotal.val($.number(getItemsTotal(), 2))
    }

    purchaseitems.on("click",":checkbox",function(){
        computetaxes()
    })

    function getdefaultpoterms(){
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getdefaultterms:true
            },
            (data)=>{
                data=data[0]
                termsfield.val(data.purchaseorder)
            }
        )
    }
})
