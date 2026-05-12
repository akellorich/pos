$(document).ready(function(){
   const  categorylist=$("#category"),
        uomlist=$("#uom"),
        savebutton=$("#saveproduct"),
        itemcodefield=$("#itemcode"),
        itemnamefield=$("#itemname"),
        buyingpricefield=$("#buyingprice"),
        selliingpricefield=$("#sellingprice"),
        reorderlevelfield=$("#reorderlevel"),
        idfield=$("#id"),
        errordiv=$("#errors"),
        errors="",
        goback=$("#backtolist"),
        discountlist=$("#customerdiscounts"),
        discountselectlist=$("#discountselectlist"),
        adddiscountbutton=$("#discountbutton"),
        discountvalue=$("#value"),
        discountpercentage=$("#percentage"),
        discountdetails=$("#customerdiscountdetails"),
        generatecode=$("#generatecode"),
        inputfields=$("input"),
        selectfields=$("#select"),
        serializablefield=$("#serializable"),
        bundleitemfield=$("#bundleitem"),
        taxtypefield=$("#taxtype"),
        lengthfield=$("#length"),
        widthfield=$("#width"),
        heightfield=$("#height"),
        usedimensionfield=$("#usedimensions"),
        allownegativesalesfield=$("#allownegativesales"),
        salebyfield=$("#saleby"),
        bundleproductfield=$("#bundleproduct"),
        allowreturnexchangefield=$("#allowreturnexchange")

    lengthfield.prop("disabled",true)
    widthfield.prop("disabled",true)
    heightfield.prop("disabled",true)
    bundleproductfield.prop("disabled",true)
    allowreturnexchangefield.prop("disabled",true)

    lengthfield.val("0")
    widthfield.val("0")
    heightfield.val("0")  

    inputfields.on("input",()=>{
        errordiv.html("")
    })

    selectfields.on("change",()=>{
        errordiv.html("")  
    })

    usedimensionfield.on("click",function(){
        const state=$(this).prop("checked")
            lengthfield.prop("disabled",!state)
            widthfield.prop("disabled",!state)
            heightfield.prop("disabled",!state)
        if(state){
           lengthfield.val("")
            widthfield.val("")
            heightfield.val("")  
        }else{
            lengthfield.val("0")
            widthfield.val("0")
            heightfield.val("0")  
        }
    })

    function getproductcategories(){
        var dfd=new $.Deferred()
        $.getJSON(
            "../controllers/categoryoperations.php",
            {
                getcategories:true
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for (var i = 0; i < data.length; i++) {
                    results+="<option value='"+data[i].categoryid+"'>"+data[i].categoryname+"</option>"
                } 
                $(results).appendTo(categorylist)
                 dfd.resolve()
            } 
        )
        return dfd.promise()
    }

    function getunitsofmeasure(){
        var dfd=new $.Deferred()
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getunistofmeasure:true
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for (var i = 0; i < data.length; i++) {
                    results+="<option value='"+data[i].description+"'>"+data[i].description+"</option>" 
                } 
                $(results).appendTo(uomlist) 
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    function getcustomercategories(){
        var dfd=new $.Deferred()
        $.getJSON(
            "../controllers/customeroperations.php",
            {
                getcustomercategories:"GET"
            },
            function(data){
                var results1="<option value=''>&lt;Choose One&gt;</option>"
                for(i=0;i<data.length;i++){
                    results1+="<option value='"+data[i].id+"'>"+data[i].description+"</option>"
                }
                // console.log(results1)
                $(results1).appendTo(discountselectlist)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }
    // get products
    getallproducts(bundleproductfield,'choose')

    // get product categories
    getproductcategories().done(function(){
        // get units of measure
        getunitsofmeasure().done(function(){
                // get customer categories to add discount
            getcustomercategories().done(function(){
                // get tax types
                gettaxtypes().done(function(){
                    getProductDetails()
                })
            })
        })
    }) 
    // listen to save button
    savebutton.on("click",function(){
        // check for blank fields
        const id=idfield.val(),
            categoryid=categorylist.val(),
            itemcode=itemcodefield.val(),
            itemname=itemnamefield.val(),
            unitofmeasure=uomlist.val(),
            buyingprice=buyingpricefield.val(),
            sellingprice=selliingpricefield.val(),
            reorderlevel=reorderlevelfield.val(),
            generateitemcode=generatecode.val(),
            serializable=serializablefield.val(),
            bundleitem=bundleitemfield.val(),
            taxtype=taxtypefield.val(),
            length=lengthfield.val(),
            height=heightfield.val(),
            width=widthfield.val(),
            usedimensions=usedimensionfield.prop("checked")?true:false,
            allownegativesales=allownegativesalesfield.val(),
            saleby=salebyfield.val(),
            bundleproduct=bundleitem==0?0:bundleproductfield.val(),
            allowreturnexchange=bundleitem==0?0:allowreturnexchangefield.val()

        let errors=""
        // Check for blank fields
        if (categoryid==""){
            errors="Category for the product"
            categorylist.focus()
        }
        else if(itemcode=="" && generateitemcode==0){
            errors="Item Code for the product"
            itemcodefield.focus()
        }
        else if(itemname==""){
            errors="Item Name for the product"
            itemnamefield.focus()
        }else if(usedimensions){
            if(Number(length)<0){
                errors="Please enter item length"
                lengthfield.focus()
            }else if(Number(width)<0){
                errors="Please enter item width"
                widthfield.focus()
            }else if(Number(height)<0){
                errors="Please enter height"
                heightfield.focus()
            }
        }
        else if(unitofmeasure==""){
            errors="Unit of Measure for the product"
            uomlist.focus()
        }else if(taxtype==""){
            errors="Please select tax type"
            taxtypefield.focus()
        }
        else if(buyingprice==""){
            errors="Buying Price for the product"
            buyingpricefield.focus()
        }
        else if(sellingprice==""){
            errors="Item Code for the product"
            selliingpricefield.focus()
        }
        else if(reorderlevel==""){
            errors="Reorder Level for the product"
            reorderlevelfield.focus()
        }else if(bundleproduct=="" && bundleitem==1){
            errors="Please select bundle product"
            bundleproductfield.focus()
        }

        if(errors!=""){
            errordiv.html(showAlert("info",errors))
        }else{
            // post the data to the server
            errordiv.html("")
            var TableData;
            TableData = JSON.stringify(storeTblValues())
            $("<p>Processing please wait ...</p>").appendTo(errordiv)
            $.post(
                "../controllers/productoperations.php",
                {
                    saveproduct:"POST",
                    generatecode:generateitemcode,
                    uom:unitofmeasure,
                    id,
                    categoryid,
                    itemcode,
                    itemname,
                    buyingprice,
                    sellingprice,
                    reorderlevel,
                    TableData,
                    serializable,
                    bundleitem,
                    taxtype,
                    length,
                    width,
                    height,
                    allownegativesales,
                    saleby,
                    bundleproduct,
                    allowreturnexchange
                },
                function(data){
                    data=$.trim(data)
                    if(data=="success"){
                        errors="The product has been saved to the system successfully"
                        errordiv.html(showAlert("success",errors))
                        // clear fields for new entry
                        clearform()
                    }else if(data=="code exists"){
                        errors="The item is code already in use in the system."
                        errordiv.html(showAlert("info",errors))
                        itemcodefield.focus()
                    }else if(data=="name exists"){
                        errors="The item name is already in use in the system"
                        errordiv.html(showAlert("info",errors))
                        itemnamefield.focus()
                    }else{
                        errors=`Sorry an error occured. ${data}`
                        errordiv.html(showAlert("danger",errors))
                    }
                }
            )
        }
    })

    goback.on("click",function(){
        window.location.href="productslist.php"
    })

    // listen to add discount button
    adddiscountbutton.on("click",function(){
        // check for blank fields
        var errors=""
        if(discountselectlist.val==""|| discountvalue.val()==""){
            errors= "Please add a discount first"
            errordiv.html(showAlert("info",errors))
        }else{
            // add to the list
            var id=discountselectlist.val(),
                name=discountselectlist.children(':selected').text(),
                value= discountvalue.val(),
                percentage=0
                percentage=discountpercentage.val()
                item="<tr><td>"+id+"</td><td>"+name+"</td><td>"+percentage+"</td><td>"+value+"</td>"
                item+="<td><a href='javascript void(0)' class='deletedata' data-id='"+randomId()+"'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>"
                $(item).appendTo(discountlist.find("tbody"))
            // clear fields
            discountselectlist.val("")
            discountvalue.val("")
        }
        
    })

    // generate array for setting the price matrix
    function storeTblValues()
    {
        var TableData = new Array();

        discountlist.find("tr").each(function(row, tr){
            TableData[row]={
                "catid" : $(tr).find('td:eq(0)').text(),
                "percentage" :$(tr).find('td:eq(2)').text(),
                "value" : $(tr).find('td:eq(3)').text()
            }    
        }); 
        TableData.shift()  // first row will be empty - so remove
        //TableData.pop()
        return TableData
    }

    // check if we are on edit mode and fetch details
    function getProductDetails(){
        var deferred= new $.Deferred()
        if(itemcodefield.val()!=""){
            // get product details
            $.getJSON(
                "../controllers/productoperations.php",
                {
                    getproductdetails:true,
                    productcode:itemcodefield.val(),
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
                        // populate the fields
                        idfield.val(data[0].productid)
                        categorylist.val(data[0].categoryid)
                        itemcodefield.val(data[0].itemcode)
                        itemnamefield.val(data[0].itemname)
                        uomlist.val(data[0].unitofmeasure)
                        buyingpricefield.val(data[0].buyingprice)
                        selliingpricefield.val(data[0].sellingprice)
                        reorderlevelfield.val(data[0].reorderlevel)
                        serializablefield.val(data[0].serializable)
                        bundleitemfield.val(data[0].bundleitem)
                        taxtypefield.val(data[0].taxtypeid)
                        lengthfield.val(data[0].length)
                        heightfield.val(data[0].height)
                        widthfield.val(data[0].width)
                        allownegativesalesfield.val(data[0].allownegativesales)
                        salebyfield.val(data[0].saleby) 
                        bundleproductfield.val(data[0].bundleproduct)
                        allowreturnexchangefield.val(data[0].allowreturnexchange)
                        
                        if(data[0].bundleitem==1){
                           bundleproductfield.prop("disabled",false)
                           allowreturnexchangefield.prop("disabled",false)
                        }else{
                            bundleproductfield.prop("disabled",true)
                            allowreturnexchangefield.prop("disabled",true)
                        }

                        if(lengthfield.val()==0 && widthfield.val()==0 && heightfield.val()==0){
                            usedimensionfield.prop("checked",false)
                            lengthfield.prop("disabled",true)
                            heightfield.prop("disabled",true)
                            widthfield.prop("disabled",true)
                        }else{
                            lengthfield.prop("disabled",false)
                            heightfield.prop("disabled",false)
                            widthfield.prop("disabled",false)
                        }
                    } 
                }
            )
            // get customer's discount matrix
            $.getJSON(
                "../controllers/productoperations.php",
                {
                    itemcode:itemcodefield.val(),
                    getdiscountmatrix:true
                },
                function(data){
                    var results="",
                        percentage=''
                    for(var i=0;i<data.length;i++){
                        //parseInt(data[i].percentage)===0?percentage='No':percentage='Yes'
                        results+="<tr><td>"+data[i].customercategoryid+"</td>"
                        results+="<td>"+data[i].customercategory+"</td>"
                        results+="<td>"+data[i].percentage+"</td>"
                        results+="<td>"+data[i].value+"</td>"
                        results+="<td><a href='javascript void(0)' class='deletedata' data-id='"+randomId()+"'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>"
                    }
                    $(results).appendTo(discountlist)
                }
            )
        }
        return deferred.promise()
    }

    // listen to remove dsicount option
    discountdetails.on("click",".deletedata",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).parent("td").parent("tr");
        var itemname=parent.find("td").eq(1).text()
        bootbox.dialog({
           // title: "Confirm Item Removal!",
            message: "Are you sure you want to remove discount for <strong>"+itemname+"s</strong>?",
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
                        parent.remove()                        
                        $('.bootbox').modal('hide');
                    }
                }
            }
        })
    })

    generatecode.on("click",function(){
        generatecode.val()==1?itemcodefield.prop("disabled",true):itemcodefield.prop("disabled",false)
    })

    function clearform(){
        idfield.val("0")
        categorylist.val("")
        itemcodefield.val("")
        itemnamefield.val("")
        uomlist.val("")
        buyingpricefield.val("")
        selliingpricefield.val("")
        reorderlevelfield.val("")
        generatecode.val(0),
        serializablefield.val("0")
        discountlist.find("tbody").html("")
        taxtypefield.val("")
        categorylist.focus()
    }

    function gettaxtypes(){
        var dfd=new $.Deferred()
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                gettaxtypes:true
            },
            function(data){
                var results="<option value=''>&lt;Choose One&gt;</option>"
                for(var i=0;i<data.length;i++){
                    results+=`<option value='${data[i].id}'>${data[i].taxname}</option>`
                }
                taxtypefield.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }

    bundleitemfield.on("change",function(){
        const status=$(this).val()
        if(status==1){
            bundleproductfield.prop("disabled",false)
            allowreturnexchangefield.prop("disabled",false)
        }else{
            bundleproductfield.prop("disabled",true)
            allowreturnexchangefield.prop("disabled",true)
        }
    })
})