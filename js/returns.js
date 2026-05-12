$(document).ready(()=>{
    const outletfield=$("#outletid"),
        warehousefield=$("#warehouseid"),
        paymentmethodfield=$("#paymentmethod"),
        referencefield=$("#reference"),
        itemstable=$("#itemstable"),
        notifications=$("#notifications"),
        totalfield=$("#overalltotal"),
        savereturnbutton=$("#savereturns"),
        inputfield=$("input"),
        selectfield=$("select")
    
    // get oulets
    getPointsOfSale(outletfield,'choose')
    // get warehouses
    getwarehouses(warehousefield,'choose')
    // get paymentmethods
    getPaymentModes(paymentmethodfield,'choose')

    inputfield.on("input",()=>{
        notifications.html("")
        returnableitemsnotifications.html("")
    })

    selectfield.on("change",()=>{
        inputfield.trigger("input")
    })

    // Listen to Change event of 
    outletfield.on("change",function(){
        const posid=$(this).val()
        if(posid==""){
            itemstable.find("tbody tr").remove()
        }else{
            notifications.html(showAlert("processing",`Processing. Please wait ...`,1))
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    posstocksummary:true,
                    asatdate:todaysDate(),
                    posid
                }
            ).done((data)=>{
                let results=''
                data= data.map(item => ({
                    ...item,
                    closingbalance:(parseFloat(item.openingbalance)+parseFloat(item.transfersin)-parseFloat(item.transfersout)-parseFloat(item.sales)).toFixed(2)
                }))

                data=data.filter(item=>parseFloat(item.closingbalance)>0)
                data.forEach((item,i)=>{
                    results+=`<tr data-itemid='${item.productid}'><td>${$.number(i+1)}</td>`
                    results+=`<td>${item.itemcode}</td>`
                    results+=`<td>${item.itemname}</td>`
                    results+=`<td>${item.sellingprice}</td>`
                    results+=`<td>${item.closingbalance}</td>`
                    results+=`<td class='return' contentEditable=true>&nbsp;</td>`
                    results+=`<td class='sales'>0</td>`
                    results+=`<td class='totalsale'>0</td>`
                    results+=`<td>&nbsp;</td></tr>`
                })
                itemstable.find("tbody").html(results)
                notifications.html("")

            }).fail((response,status,error)=>{
                notifications.html(showAlert("danger",`Sorry an error occured ${response.responseText}`))
            })
        }
    })

    // Listen to content editable field
    itemstable.on('keydown', 'td[contenteditable="true"]', function (e) {
        let val = $(this).text();
        // Allow only numbers with optional single decimal point and max 2 decimal places
        val = val.replace(/[^0-9.]/g, ''); // remove non-numeric except dot
        val = val.replace(/^([^\.]*\.)|\./g, '$1'); // keep only first dot
        val = val.replace(/(\.\d{2})\d+$/, '$1'); // limit to 2 decimal places

        $(this).text(val);
        placeCaretAtEnd(this); 

        if (e.key === 'Enter') {
            e.preventDefault(); // Prevent inserting a newline
            cell= $(this)
            const returnedquantity =cell.text().trim(),
                parent=cell.closest("tr"),
                currentrow=parent.find("td"),
                unitprice=currentrow.eq(3).text().replaceAll(",",""),
                stockquantity=currentrow.eq(4).text().replaceAll(",",""),
                sales =stockquantity-returnedquantity

            // quantity sold
            currentrow.eq(6).text(sales)
            // total sales
            currentrow.eq(7).text($.number(sales*unitprice,2))
           
            // Move to the next editable cell if any
            let $next = cell.closest('td').nextAll('[contenteditable="true"]').first()
            if ($next.length) {
                $next.focus() 
            }else{
                // Blur
                cell.blur();
            }   
            performoveralltotal()
        }
    })

    // Listen to paste
    itemstable.on('paste', 'td[contenteditable="true"]', function (e) {
        e.preventDefault();
        let text = (e.originalEvent || e).clipboardData.getData('text/plain');  
        // Sanitize paste input
        text = text.replace(/[^0-9.]/g, '').replace(/^([^\.]*\.)|\./g, '$1').replace(/(\.\d{2})\d+$/, '$1');
        document.execCommand('insertText', false, text);
    })

    function performoveralltotal(){
        let total=0
        // console.log(itemstable.find("tbody tr td:eq(7)").length)
        itemstable.find("tbody tr").each(function(){
            // console.log(parseFloat($(this).text().replaceAll(",","")))
            total+=parseFloat($(this).find("td:eq(7)").text().replaceAll(",",""))
        })
        totalfield.val($.number(total,2))
    }

    savereturnbutton.on("click",()=>{
        const outletid=outletfield.val(),
            warehouseid=warehousefield.val(),
            paymentmodeid=paymentmethodfield.val(),
            reference=sanitizestring(referencefield.val())
        let products=[],errors="", invalidreturn=false,
            returneditems=[]

        itemstable.find("tbody tr").each(function(){
            const row=$(this),
                productid=row.data("itemid"),
                col=row.find("td"),
                itemcode=col.eq(1).text(),
                unitprice=col.eq(3).text(),
                stockquantity=col.eq(4).text(),
                unitssold=col.eq(6).text(),
                unitsreturned=col.eq(5).text().trim()
            // console.log(unitsreturned)
            if(unitsreturned=="" || (Number(stockquantity)>0 && Number(unitsreturned)>stockquantity)){
                invalidreturn=true
                row.find("td").addClass("text-danger")
            }else {
                row.find("td").removeClass("text-danger")  
                if(stockquantity!=0){ 
                    products.push({"productid":productid,"itemcode":itemcode,"unitssold":unitssold,"unitsreturned":unitsreturned,"unitprice":unitprice})
                }else{
                    returneditems.push({"productid":productid,"itemcode":itemcode,"unitssold":0,"unitsreturned":unitsreturned,"unitprice":unitprice})
                }
            }           
        }) 
        // check for blank fields
        if(outletid==""){
            errors="Please select outlet first"
            outletfield.focus()
        }else if(warehouseid==""){
            errors="Please select warehouse first"
            warehousefield.focus()
        }else if(paymentmodeid==""){
            errors="Please select payment mode first"
            paymentmethodfield.focus()
        }else if(reference==""){
            errors="Please provide payment reference number first"
            referencefield.focus()
        }else if(products.length==0 && returneditems.length==0){
            errors="No products avaialble for returns"
        }else if(invalidreturn==true){
            errors="Please provide returned quantities or check units returned do not exceed quantity issued for highlighted entries"
        }

        if(errors==""){
            products=JSON.stringify(products)
            returneditems=JSON.stringify(returneditems)
            $.post(
                "../controllers/returnoperations.php",
                {
                    saveposreturns:true,
                    outletid,
                    warehouseid,
                    paymentmodeid,
                    reference,
                    products,
                    returneditems
                },
                (data)=>{
                    if(isJSON(data)){
                        data=JSON.parse(data)
                        notifications.html(showAlert("success",`Return received successfully, Receipt #:<strong> ${data.receiptno}</strong>, Transfer #: <strong>${data.transferno}</strong>`))
                        clearreturnsform()
                    }else{
                        notifications.html(showAlert("danger",`Sorry an error occured ${data}`))
                    }
                }
            )
        }else{
            notifications.html(showAlert("info",errors))
        }
    })

    function clearreturnsform(){
        outletfield.val("")
        warehousefield.val("")
        paymentmethodfield.val("")
        referencefield.val("")
        itemstable.find("tbody tr").remove()
    }

    const returnableitemstable=$("#returnableitemstable"),
        returnableitemsmodal=$("#allowablereturnitemsmodal"),
        addnewreturnableitembutton=$("#additems"),
        returnableitemsnotifications=$("#returnableitemsnotifications"),
        savereturnableitemsbutton=$("#savereturnableitems")

    addnewreturnableitembutton.on("click",()=>{
        returnableitemsmodal.modal('show')
        // get returnable items
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getreturnableproducts:true
            }
        ).done((data)=>{
            let results=""
            data.forEach(product=>{
                results+=`<tr data-productid=${product.productid}>`
                results+=`<td><input type='checkbox' id=${product.productid}></td>`
                results+=`<td>${product.itemcode}</td>`
                results+=`<td>${product.itemname}</td>`
                results+=`<td>${$.number(product.sellingprice,2)}</td>`
                results+=`<td contenteditable=true class='quantity'></td>`
                results+=`<td class='total'>0</td></tr>`
            })
            returnableitemstable.find("tbody").html(results)
        }).fail((response,status,error)=>{
            returnableitemsnotifications.html(showAlert("danger",`Sorry an error occured ${response.responseText}`))
        })

    })

    function placeCaretAtEnd(el) {
        const range = document.createRange();
        const sel = window.getSelection();
        range.selectNodeContents(el);
        range.collapse(false);
        sel.removeAllRanges();
        sel.addRange(range);
    }

    returnableitemstable.on("keydown",'td[contenteditable="true"]',function(e){
        // console.log("Key Pressed")
        returnableitemsnotifications.html("")
        let val = $(this).text();
        // Allow only numbers with optional single decimal point and max 2 decimal places
        val = val.replace(/[^0-9.]/g, ''); // remove non-numeric except dot
        val = val.replace(/^([^\.]*\.)|\./g, '$1'); // keep only first dot
        val = val.replace(/(\.\d{2})\d+$/, '$1'); // limit to 2 decimal places

        $(this).text(val);
        placeCaretAtEnd(this); 

        if (e.key === 'Enter') {
            e.preventDefault(); // Prevent inserting a newline
            cell= $(this)
            const quantity =cell.text().replaceAll(",","").trim(),
                parent=cell.closest("tr"),
                currentrow=parent.find("td"),
                unitprice=currentrow.eq(3).text().replaceAll(",",""),
                returntotal =unitprice*quantity

            currentrow.eq(5).text($.number(returntotal,2))
            cell.closest("tr").find("td").removeClass("text-danger")
            // Move to the next editable cell if any
            let $next = cell.closest('td').nextAll('[contenteditable="true"]').first()
            if ($next.length) {
                $next.focus() 
            }else{
                // Blur
                cell.blur();
            }   
        }
    })

    savereturnableitemsbutton.on("click",()=>{
        if(returnableitemstable.find("tbody input[type='checkbox']:checked").length>0){
            let results="", currentrow=itemstable.find("tbody tr").length+1, invalidquantity=false
            returnableitemstable.find("tbody input[type='checkbox']:checked").each(function(){
                const checkbox=$(this),
                    parent=checkbox.closest("tr"),
                    itemid=checkbox.attr("id"),
                    col=parent.find("td"),
                    itemcode=col.eq(1).text(),
                    itemname=col.eq(2).text(),
                    unitprice=col.eq(3).text(),
                    quantity=col.eq(4).text(),
                    total=col.eq(5).text().replaceAll(",","")

                if (Number(quantity)<=0){
                    invalidquantity=true
                    parent.find("td").addClass("text-danger")
                }else{
                    parent.find("td").removeClass("text-danger") 
                    results+=`<tr data-itemid='${itemid}'><td>${$.number(currentrow)}</td>`
                    results+=`<td>${itemcode}</td>`
                    results+=`<td>${itemname}</td>`
                    results+=`<td>${unitprice}</td>`
                    results+=`<td>0</td>`
                    results+=`<td class='return'>${quantity}</td>`
                    results+=`<td class='sales'>0</td>`
                    results+=`<td class='totalsale'>${$.number(-1*total,2)}</td>`
                    results+=`<td><a href="#" class='deleteitem'><i class='fal fa-trash fa-lg fa-fw text-danger'></i></a></td></tr>`
                    currentrow++
                } 
            })
            
            if(invalidquantity==true){
                returnableitemsnotifications.html(showAlert("info","Please provide quantity for all highlighted entries"))
            }else{                
                // Recompute Totals
                $(results).appendTo(itemstable.find("tbody"))
                performoveralltotal()
                returnableitemsmodal.modal("hide")
            }  
        }else{
            returnableitemsnotifications.html(showAlert("info",`Please select at least an item from the list`))
        }
    })

    itemstable.on("click",".deleteitem",function(e){
        e.preventDefault()
        const row=$(this).closest("tr")
        row.remove()
        performoveralltotal()
    })

})