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

    let errors=""

    itemcodefield.keypress(function(event){	
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            // check if supplier has been selected
            if(supplierslist.val()!=""){
               getProduct()
            }else{
                errors="Please select a supplier first"
                errordiv.html(showAlert("info",errors))
            }
            
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
                quantity=$this.find("td").eq(5).text()
                unitprice=$this.find("td").eq(2).text()
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

    function getItemsTotal(){
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
                        for(i=0;i<data.length;i++){
                            results+="<li id='"+data[i].itemcode+"'>"+data[i].itemname+"</li>"
                        }
                        results+="</ul>"
                        // console.log(results)
                        $(results).appendTo(searchresults)
                        searchresults.show()
                    }  else{

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
        itemcodefield.val("")
        itemcodefield.focus()
    })

    function getProduct(){
         // display progress
         errordiv.html(showAlert("info","Processing. Please wait ...",1))
        //  errors="<p class='alert alert-info'> Fetching product. Please wait ...</p>"
        //  $(errors).appendTo(errordiv)
         var productdetails=""

         $.getJSON(
             "../controllers/productoperations.php",
             {
                getproductdetails:true,
                productcode:itemcodefield.val(),
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
                     productdetails+="<td class='unitprice'>"+data[0].buyingprice+"</td>"
                     productdetails+="<td>0.00</td>"
                     productdetails+="<td>"+data[0].buyingprice+"</td>"
                     productdetails+="<td class='quantity'>1</td>"
                     productdetails+="<td class='linetotal'>"+data[0].buyingprice+"</td>"
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
                        overalltotal.html(getItemsTotal())
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    function clearForm(){
        purchaseitems.find("tbody").html("")
        overalltotal.html(0.00)
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

    // listen to change quantity event
    purchaseitems.on("click",".quantity",function(e){
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
                     parent.find("td").eq(5).text(result)
                     parent.find("td").eq(6).text(linetotal)
                     overalltotal.html(getItemsTotal())
                 } 
             }
         });
     })

     purchaseitems.on("click",".unitprice",function(e){
        // console.log($(this).html())
         var parent = $(this).parent("tr");
         bootbox.prompt({
             title:"Enter New Price",
             size: 'small',
             message: "Enter Price required",
             inputType: 'number',
             callback: function (result) {
                 if(parseFloat(result)>=0){
                     var quantity= parent.find("td").eq(5).text(),
                         linetotal=parseFloat(result*quantity)
                     parent.find("td").eq(2).text(result)
                     parent.find("td").eq(6).text(linetotal)
                     parent.find("td").eq(4).text(result)
                     overalltotal.html(getItemsTotal())
                 } 
             }
         });
     })

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
