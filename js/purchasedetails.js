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
        categoryfield=$("#purchasetype")

    let errors=""

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
            const itemcode=row.find("td").eq(0).text()
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
            let value = $(this).text().replace(",","");
            // add only if the value is number
            if(!isNaN(value) && value.length != 0) {
                sum += Number(value);
            }
        })
        return sum.toFixed(2);
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

    // listen to the click event of search term when clicked
    searchresults.on("click","li",function(){
        const itemcode=$(this).attr("id")
        itemcodefield.val(itemcode)
        getProduct()
        searchresults.hide()
        // searchresults.addClass("mt-5")
        itemcodefield.val("")
        itemcodefield.focus()
    })

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

    function getProduct(){
        // display progress
        const itemcode=itemcodefield.val()
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
                }else{
                    errordiv.html("")
                    productdetails+="<tr><td>"+data[0].itemcode+"</td>"
                    productdetails+="<td>"+data[0].itemname+"</td>"
                    productdetails+="<td class='unitprice'>"+data[0].buyingprice+"</td>"
                    productdetails+="<td><input type='checkbox' checked class='taxable'></td>"
                    productdetails+="<td><input type='checkbox' checked class='taxinclusive'></td>"
                    //  productdetails+="<td>0.00</td>"
                    //  productdetails+="<td>"+data[0].buyingprice+"</td>"
                    productdetails+="<td class='quantity text-align-right'>1</td>"
                    productdetails+="<td class='linetotal text-align-right'>"+data[0].buyingprice+"</td>"
                    productdetails+="<td class='totaltax text-align-right'>0.00</td>"
                    productdetails+="<td class='totalitem text-align-right'>0.00</td>"
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
                        overalltotal.val(getItemsTotal())
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

    // listen to change quantity event
    purchaseitems.on("click",".quantity",function(e){
        // console.log($(this).html())
         const parent = $(this).parent("tr");
         bootbox.prompt({
             title:"Enter New Quantity",
             size: 'small',
             message: "Enter quantity required",
             inputType: 'number',
             callback: function (result) {
                 if(parseFloat(result)>0){
                    //  var unitprice= parent.find("td").eq(4).text(),
                    //      linetotal=parseFloat(result*unitprice)
                     parent.find("td").eq(5).text(result)
                    //  parent.find("td").eq(6).text(linetotal)
                     computetaxes()
                    //  overalltotal.val(getItemsTotal())
                 } 
             }
         });
     })

     purchaseitems.on("click",".unitprice",function(e){
        // console.log($(this).html())
         const parent = $(this).parent("tr");
         bootbox.prompt({
             title:"Enter New Price",
             size: 'small',
             message: "Enter Price required",
             inputType: 'number',
             callback: function (result) {
                 if(parseFloat(result)>=0){
                    parent.find("td").eq(2).text(result)
                    computetaxes()
                    //  const quantity= parent.find("td").eq(5).text(),
                    //      linetotal=parseFloat(result*quantity)
                    //  parent.find("td").eq(2).text(result)
                    //  parent.find("td").eq(6).text(linetotal)
                    //  parent.find("td").eq(4).text(result)
                    //  overalltotal.val(getItemsTotal())
                 } 
             }
         });
     })

     let purchaseid=0
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
            //    console.log(data)
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
                    let  productdetails=''
                    for(let i=0;i<data.length;i++){
                        // productdetails+="<tr><td>"+data[i].itemcode+"</td>"
                        // productdetails+="<td>"+data[i].itemname+"</td>"
                        // productdetails+="<td>"+data[i].unitprice+"</td>"
                        // productdetails+="<td>0.00</td>"
                        // productdetails+="<td class='unitprice'>"+data[i].unitprice+"</td>"
                        // productdetails+="<td class='quantity'>"+data[i].quanity+"</td>"
                        // productdetails+="<td class='linetotal'>"+parseFloat(data[i].unitprice*data[i].quanity)+"</td>"
                        // productdetails+="<td><a href='#' class='delete' data-id='"+randomId()+"'><span><i class='fas fa-trash fa-sm' id='"+data[0].itemcode+"' name='"+data[0].itemcode+"'></i></span></a></td></tr>"
                        
                        // display overall total
                        productdetails+="<tr><td>"+data[i].itemcode+"</td>"
                        productdetails+="<td>"+data[i].itemname+"</td>"
                        productdetails+="<td class='unitprice'>"+data[i].unitprice+"</td>"
                        productdetails+="<td><input type='checkbox' checked class='taxable'></td>"
                        productdetails+="<td><input type='checkbox' checked class='taxinclusive'></td>"
                        //  productdetails+="<td>0.00</td>"
                        //  productdetails+="<td>"+data[0].unitprice+"</td>"
                        productdetails+="<td class='quantity text-align-right'>"+data[i].quanity+"</td>"
                        productdetails+="<td class='linetotal text-align-right'>"+data[i].unitprice+"</td>"
                        productdetails+="<td class='totaltax text-align-right'>0.00</td>"
                        productdetails+="<td class='totalitem text-align-right'>"+parseFloat(data[i].unitprice*data[i].quanity)+"</td>"
                        productdetails+="<td class='text-align-center'><a href='#' class='delete' data-id='"+randomId()+"'><span><i class='fas fa-trash fa-sm' id='"+data[i].itemcode+"' name='"+data[i].itemcode+"'></i></span></a></td></tr>"
                    } 
                    purchaseitems.find("tbody").html(productdetails)
                    overalltotal.val(getItemsTotal())   
                }
           }
        ) 
    }

    $('input').on('input',function(){
        errordiv.html("")
    })

    supplierslist.on("change",function(){
        errordiv.html("")
    })

    const currencyfield=$("#currency")
    const exchangeratefield=$("#exchangerate")
    const departmentlist=$("#department")
    const taxtypefield=$("#taxtype")
    const applytaxrate=$("#taxrate")
    let taxrate=0

    getdepartments(departmentlist,'choose')
    getscurrencies(currencyfield, 'choose')
    gettaxtypes(taxtypefield,'choose')

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
        let tax=0
        purchaseitems.find("tr").each(function(){
            const row=$(this)
            const taxable=row.find(".taxable")
            const unitprice=row.find(".unitprice").text().replace(",","")
            const quantity=row.find(".quantity").text().replace(",","")
            let totalprice=unitprice*quantity
            let tax=0
            if(taxable.prop("checked")){
                const taxinclusive=row.find(".taxinclusive")
                if(taxinclusive.prop("checked")){
                    totalprice=(((100)/(100+Number(taxrate)))*totalprice).toFixed(2) 
                }
                row.find(".linetotal").text(totalprice)
                tax=((taxrate/100)*totalprice ).toFixed(2)
            }
            // console.log(tax)
            row.find(".totaltax").text(tax)
            row.find(".totalitem").text(Number(totalprice)+Number(tax))
            overalltotal.val(getItemsTotal())
        })
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
