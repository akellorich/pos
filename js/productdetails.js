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
        allowreturnexchangefield=$("#allowreturnexchange"),
        itemtypefield=$("#itemtype"),
        rawmaterialfield=$("#rawmaterial"),
        disallowpurchasingfield=$("#disallowpurchasing"),
        disallowreceiptfield=$("#disallowreceipt"),
        disallowsalefield=$("#disallowsale"),
        supportsadditionalbarcodesfield=$("#supportsadditionalbarcodes")

    // Intercept prop("disabled", ...) calls to keep shadow toggle switches in sync
    const originalProp = $.fn.prop;
    $.fn.prop = function(name, value) {
        if (arguments.length === 2 && name === "disabled") {
            this.each(function() {
                const id = $(this).attr("id");
                if (id) {
                    const toggle = $("#" + id + "-toggle");
                    if (toggle.length) {
                        toggle.prop("disabled", value);
                    }
                }
            });
        }
        return originalProp.apply(this, arguments);
    };

    function convertSelectToToggle(selectId) {
        const select = $("#" + selectId);
        if (!select.length) return;
        
        // Hide the original select
        select.hide();
        
        // Create toggle switch markup
        const checked = select.val() === "1" ? "checked" : "";
        const disabled = select.prop("disabled") ? "disabled" : "";
        
        const toggleHtml = `
            <div class="switch-wrapper">
                <label class="custom-switch-toggle mb-0">
                    <input type="checkbox" id="${selectId}-toggle" ${checked} ${disabled}>
                    <span class="slider"></span>
                </label>
            </div>
        `;
        
        select.after(toggleHtml);
        const toggle = $("#" + selectId + "-toggle");
        
        // Add toggle-column class to the parent column div
        select.closest(".col, [class*='col-']").addClass("toggle-column");
        
        // Sync toggle state to select value
        toggle.on("change", function() {
            const val = $(this).prop("checked") ? "1" : "0";
            select.val(val).trigger("change");
        });
        
        // Sync select value to toggle state
        select.on("change", function() {
            const val = $(this).val();
            toggle.prop("checked", val === "1");
        });
    }

    // Convert Yes/No select elements to modern toggle buttons
    convertSelectToToggle("generatecode");
    convertSelectToToggle("serializable");
    convertSelectToToggle("allownegativesales");
    convertSelectToToggle("bundleitem");
    convertSelectToToggle("allowreturnexchange");
    convertSelectToToggle("rawmaterial");
    convertSelectToToggle("disallowpurchasing");
    convertSelectToToggle("disallowreceipt");
    convertSelectToToggle("disallowsale");
    convertSelectToToggle("supportsadditionalbarcodes");
    convertSelectToToggle("percentage");
    convertSelectToToggle("productoptionmultiselection");

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

    itemtypefield.on("change", function() {
        if ($(this).val() === "service") {
            allownegativesalesfield.val("1");
            disallowpurchasingfield.val("1");
            disallowreceiptfield.val("1");
            disallowsalefield.val("0");
        }
    })

    function toggleDimensionsMobile() {
        if ($(window).width() <= 768) {
            if (usedimensionfield.prop("checked")) {
                $(".dimension-field").show();
            } else {
                $(".dimension-field").hide();
            }
        } else {
            $(".dimension-field").show();
        }
    }
    $(window).on("resize", toggleDimensionsMobile);

    function toggleBarcodeVariantsMobile() {
        if ($(window).width() <= 768) {
            if (supportsadditionalbarcodesfield.val() === "1") {
                $(".barcode-variant-field").show();
            } else {
                $(".barcode-variant-field").hide();
            }
        } else {
            $(".barcode-variant-field").show();
        }
    }
    $(window).on("resize", toggleBarcodeVariantsMobile);
    supportsadditionalbarcodesfield.on("change", toggleBarcodeVariantsMobile);

    usedimensionfield.on("click change", function(){
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
        toggleDimensionsMobile();
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
                    results1+="<option value='"+data[i].id+"'>"+(data[i].categoryname || data[i].description)+"</option>"
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
            allowreturnexchange=bundleitem==0?0:allowreturnexchangefield.val(),
            rawmaterial=rawmaterialfield.val(),
            itemtype=itemtypefield.val(),
            disallowpurchasing=disallowpurchasingfield.val(),
            disallowreceipt=disallowreceiptfield.val(),
            disallowsale=disallowsalefield.val()

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
                    allowreturnexchange,
                    rawmaterial,
                    itemtype,
                    disallowpurchasing,
                    disallowreceipt,
                    disallowsale
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
                        rawmaterialfield.val(data[0].rawmaterial)
                        itemtypefield.val(data[0].itemtype || "product")
                        disallowpurchasingfield.val(data[0].disallowpurchasing)
                        disallowreceiptfield.val(data[0].disallowreceipt)
                        disallowsalefield.val(data[0].disallowsale)
                        supportsadditionalbarcodesfield.val(data[0].supportsadditionalbarcodes || "0")
                        
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
                            usedimensionfield.prop("checked",true)
                            lengthfield.prop("disabled",false)
                            heightfield.prop("disabled",false)
                            widthfield.prop("disabled",false)
                        }
                        toggleDimensionsMobile();
                        toggleBarcodeVariantsMobile();
                        loadProductRecipes(data[0].productid);
                        loadProductSplitUnits(data[0].productid);
                        if (typeof initializeMovementSummaryDates === "function") {
                            initializeMovementSummaryDates();
                        }
                        if (typeof loadActiveHistoryTab === "function") {
                            loadActiveHistoryTab();
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

    generatecode.on("change",function(){
        generatecode.val()==1?itemcodefield.prop("disabled",true):itemcodefield.prop("disabled",false)
    }).trigger("change");

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
        rawmaterialfield.val("0")
        itemtypefield.val("product")
        disallowpurchasingfield.val("0")
        disallowreceiptfield.val("0")
        disallowsalefield.val("0")
        usedimensionfield.prop("checked",false)
        lengthfield.prop("disabled",true).val("0")
        widthfield.prop("disabled",true).val("0")
        heightfield.prop("disabled",true).val("0")
        supportsadditionalbarcodesfield.val("0")
        toggleDimensionsMobile()
        toggleBarcodeVariantsMobile()
        selectedRecipeItemId = null;
        recipeItemCode.val("");
        recipeItemName.val("");
        recipeItemUnitPrice.val("");
        recipeItemMeasuringUnit.val("");
        recipeItemQuantity.val("");
        productRecipeTableBody.html("");
        $("#productrecipetable tfoot").html("");
        activeSplitUnitId = 0;
        splitUnitName.val("");
        splitUnitsOfTotal.val("");
        splitUnitPrice.val("");
        saveBulkBreakBtn.html("<i class='fal fa-save fa-lg fa-fw'></i> Save Split unit");
        splitUnitsTableBody.html("");
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
    
    // Set initial dimension visibility based on view screen width
    toggleDimensionsMobile();
    toggleBarcodeVariantsMobile();

    // --- Product Recipe Management ---
    let selectedRecipeItemId = null;
    const recipeItemCode = $("#recipeitemcode");
    const recipeItemName = $("#recipeitemname");
    const recipeItemUnitPrice = $("#recipeitemunitprice");
    const recipeItemMeasuringUnit = $("#recipeitemmeasuringunit");
    const recipeItemQuantity = $("#recipeitemquantity");
    const searchRecipeProducts = $("#searchrecipeproducts");
    const addRecipeItemBtn = $("#addrecipeitem");
    const productRecipeTableBody = $("#productrecipetable tbody");

    recipeItemCode.on("keyup", function(){
        const name = recipeItemCode.val().trim();
        searchRecipeProducts.html("").hide();
        if(name.length > 1){
            $.getJSON(
                "../controllers/productoperations.php",
                {
                    filterrawproducts: 1,
                    name: name
                },
                function(data){
                    if(data.length > 0){
                        let results = "<ul class='searchresults list-unstyled m-0 p-0'>";
                        for(let i=0; i<data.length; i++){
                            results += `<li class='p-2 border-bottom recipe-search-item' style='cursor:pointer;' ` +
                                       `data-id='${data[i].productid}' ` +
                                       `data-code='${data[i].itemcode}' ` +
                                       `data-name='${data[i].itemname}' ` +
                                       `data-price='${data[i].sellingprice}' ` +
                                       `data-uom='${data[i].uom}'>` +
                                       `<span class='font-weight-bold'>${data[i].itemcode}</span> - ${data[i].itemname}` +
                                       `</li>`;
                        }
                        results += "</ul>";
                        searchRecipeProducts.html(results).show();
                    }
                }
            );
        }
    });

    $(document).on("click", function(e){
        if(!recipeItemCode.is(e.target) && !searchRecipeProducts.is(e.target) && searchRecipeProducts.has(e.target).length === 0){
            searchRecipeProducts.hide();
        }
    });

    searchRecipeProducts.on("click", ".recipe-search-item", function(){
        const $this = $(this);
        selectedRecipeItemId = $this.attr("data-id");
        recipeItemCode.val($this.attr("data-code"));
        recipeItemName.val($this.attr("data-name"));
        recipeItemUnitPrice.val($this.attr("data-price"));
        recipeItemMeasuringUnit.val($this.attr("data-uom"));
        
        searchRecipeProducts.hide();
        recipeItemQuantity.focus();
    });

    let recipeProgressModal = null;
    function showRecipeNotification(type, message) {
        const isTabletOrDesktop = window.innerWidth >= 768;
        const alertHtml = showAlert(type === "processing" ? "info" : type, message);

        if (isTabletOrDesktop) {
            $("#recipenotifications").html("");
            if (type === "processing") {
                if (recipeProgressModal) {
                    recipeProgressModal.find('.bootbox-body').html(alertHtml);
                } else {
                    recipeProgressModal = bootbox.dialog({
                        message: alertHtml,
                        closeButton: false
                    });
                    recipeProgressModal.on('hidden.bs.modal', function () {
                        recipeProgressModal = null;
                    });
                }
            } else {
                if (recipeProgressModal) {
                    recipeProgressModal.find('.bootbox-body').html(alertHtml);
                    let footer = recipeProgressModal.find('.modal-footer');
                    if (footer.length === 0) {
                        footer = $('<div class="modal-footer p-2 justify-content-end" style="border-top: 1px solid #dee2e6;"></div>').appendTo(recipeProgressModal.find('.modal-content'));
                    }
                    footer.html('<button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">OK</button>');
                } else {
                    bootbox.alert({
                        message: alertHtml,
                        buttons: {
                            ok: {
                                label: 'OK',
                                className: 'btn-primary btn-sm'
                            }
                        }
                    });
                }
            }
        } else {
            if (recipeProgressModal) {
                recipeProgressModal.modal('hide');
                recipeProgressModal = null;
            }
            $("#recipenotifications").html(alertHtml);
        }
    }

    addRecipeItemBtn.on("click", function(e){
        e.preventDefault();
        const mainProductId = idfield.val();
        $("#recipenotifications").html("");

        if(mainProductId === "0" || mainProductId === ""){
            showRecipeNotification("info", "Please save the product details first before adding recipe items.");
            return;
        }
        if(!selectedRecipeItemId){
            showRecipeNotification("info", "Please select a valid raw product first.");
            return;
        }
        const qty = parseFloat(recipeItemQuantity.val());
        if(isNaN(qty) || qty <= 0){
            showRecipeNotification("info", "Please enter a valid quantity greater than 0.");
            recipeItemQuantity.focus();
            return;
        }

        showRecipeNotification("processing", "Saving recipe item. Please wait...");

        $.post(
            "../controllers/productoperations.php",
            {
                saveproductrecipe: 1,
                productid: mainProductId,
                recipeitemid: selectedRecipeItemId,
                quantity: qty
            },
            function(data){
                if($.trim(data) === "success"){
                    recipeItemCode.val("");
                    recipeItemName.val("");
                    recipeItemUnitPrice.val("");
                    recipeItemMeasuringUnit.val("");
                    recipeItemQuantity.val("");
                    selectedRecipeItemId = null;
                    
                    showRecipeNotification("success", "Recipe item saved successfully!");
                    loadProductRecipes(mainProductId);
                } else {
                    showRecipeNotification("danger", "Error saving recipe item: " + data);
                }
            }
        ).fail(function(xhr, status, error) {
            showRecipeNotification("danger", "Connection error: " + error);
        });
    });

    function loadProductRecipes(productId){
        if(productId === "0" || productId === "") {
            productRecipeTableBody.html("");
            return;
        }
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproductrecipes: 1,
                productid: productId
            },
            function(data){
                let results = "";
                let grandTotal = 0;
                for(let i=0; i<data.length; i++){
                    const total = parseFloat(data[i].total);
                    grandTotal += total;
                    results += `<tr>` +
                               `<td>${i+1}</td>` +
                               `<td>${data[i].itemcode}</td>` +
                               `<td>${data[i].itemname}</td>` +
                               `<td>${data[i].uom}</td>` +
                               `<td>${data[i].quantity}</td>` +
                               `<td>${$.number(data[i].sellingprice, 2)}</td>` +
                               `<td>${$.number(total, 2)}</td>` +
                               `<td class="text-center">` +
                               `    <div class="dropdown">` +
                               `        <a class="btn btn-sm btn-link text-secondary p-0" href="#" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-size: 1.1rem; text-decoration: none;">` +
                               `            <i class="fal fa-ellipsis-v"></i>` +
                               `        </a>` +
                               `        <div class="dropdown-menu dropdown-menu-right shadow border-0" style="border-radius: 8px; font-size: 0.85rem; z-index: 1050 !important;">` +
                               `            <a class="dropdown-item edit-recipe" href="#" data-id='${data[i].id}' data-code='${data[i].itemcode}' data-name='${data[i].itemname}' data-uom='${data[i].uom}' data-qty='${data[i].quantity}' data-price='${data[i].sellingprice}' data-itemid='${data[i].recipeitemid}'>` +
                               `                <i class="fal fa-edit fa-fw mr-2" style="color: #6c757d; font-size: 0.85rem;"></i> Edit` +
                               `            </a>` +
                               `            <a class="dropdown-item delete-recipe text-danger" href="#" data-id='${data[i].id}'>` +
                               `                <i class="fal fa-trash-alt fa-fw mr-2" style="color: #dc3545; font-size: 0.85rem;"></i> Delete` +
                               `            </a>` +
                               `        </div>` +
                               `    </div>` +
                               `</td>` +
                               `</tr>`;
                }
                productRecipeTableBody.html(results);
                
                $("#productrecipetable tfoot").html(
                    `<tr>` +
                    `<td colspan="6" class="text-right font-weight-bold">Grand Total:</td>` +
                    `<td class="font-weight-bold">${$.number(grandTotal, 2)}</td>` +
                    `<td colspan="1">&nbsp;</td>` +
                    `</tr>`
                );
            }
        );
    }

    productRecipeTableBody.on("click", ".edit-recipe", function(e){
        e.preventDefault();
        const $this = $(this);
        selectedRecipeItemId = $this.attr("data-itemid");
        recipeItemCode.val($this.attr("data-code"));
        recipeItemName.val($this.attr("data-name"));
        recipeItemMeasuringUnit.val($this.attr("data-uom"));
        recipeItemUnitPrice.val($this.attr("data-price"));
        recipeItemQuantity.val($this.attr("data-qty")).focus();
    });

    productRecipeTableBody.on("click", ".delete-recipe", function(e){
        e.preventDefault();
        const id = $(this).attr("data-id");
        bootbox.confirm("Are you sure you want to delete this recipe item?", function(result){
            if(result){
                $.post(
                    "../controllers/productoperations.php",
                    {
                        deleteproductrecipe: 1,
                        recipeid: id
                    },
                    function(data){
                        if($.trim(data) === "success"){
                            loadProductRecipes(idfield.val());
                        } else {
                            bootbox.alert("Error deleting recipe item: " + data);
                        }
                    }
                );
            }
        });
    });

    // Make loadProductRecipes globally accessible if needed when loaded
    window.loadProductRecipes = loadProductRecipes;

    // --- Product Bulk Split Units ---
    let activeSplitUnitId = 0;
    const splitUnitName = $("#spliunitname, #splitunitname");
    const splitUnitsOfTotal = $("#splitunitsoftotal");
    const splitUnitPrice = $("#splitunitprice");
    const saveBulkBreakBtn = $("#savebulkbreak");
    const splitUnitsTableBody = $("#productsplitunitstable tbody");

    let splitProgressModal = null;
    function showSplitNotification(type, message) {
        const isTabletOrDesktop = window.innerWidth >= 768;
        const alertHtml = showAlert(type === "processing" ? "info" : type, message);

        if (isTabletOrDesktop) {
            $("#bulksplitnotifications").html("");
            if (type === "processing") {
                if (splitProgressModal) {
                    splitProgressModal.find('.bootbox-body').html(alertHtml);
                } else {
                    splitProgressModal = bootbox.dialog({
                        message: alertHtml,
                        closeButton: false
                    });
                    splitProgressModal.on('hidden.bs.modal', function () {
                        splitProgressModal = null;
                    });
                }
            } else {
                if (splitProgressModal) {
                    splitProgressModal.find('.bootbox-body').html(alertHtml);
                    let footer = splitProgressModal.find('.modal-footer');
                    if (footer.length === 0) {
                        footer = $('<div class="modal-footer p-2 justify-content-end" style="border-top: 1px solid #dee2e6;"></div>').appendTo(splitProgressModal.find('.modal-content'));
                    }
                    footer.html('<button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">OK</button>');
                } else {
                    bootbox.alert({
                        message: alertHtml,
                        buttons: {
                            ok: {
                                label: 'OK',
                                className: 'btn-primary btn-sm'
                            }
                        }
                    });
                }
            }
        } else {
            if (splitProgressModal) {
                splitProgressModal.modal('hide');
                splitProgressModal = null;
            }
            $("#bulksplitnotifications").html(alertHtml);
        }
    }

    saveBulkBreakBtn.on("click", function(e){
        e.preventDefault();
        const mainProductId = idfield.val();
        $("#bulksplitnotifications").html("");

        if (mainProductId === "0" || mainProductId === "") {
            showSplitNotification("info", "Please save the product details first before adding split units.");
            return;
        }
        const name = splitUnitName.val().trim();
        if (name === "") {
            showSplitNotification("info", "Please enter a valid split UoM name.");
            splitUnitName.focus();
            return;
        }
        const total = parseFloat(splitUnitsOfTotal.val());
        if (isNaN(total) || total <= 0) {
            showSplitNotification("info", "Please enter a valid quantity of total greater than 0.");
            splitUnitsOfTotal.focus();
            return;
        }
        const price = parseFloat(splitUnitPrice.val());
        if (isNaN(price) || price < 0) {
            showSplitNotification("info", "Please enter a valid unit price.");
            splitUnitPrice.focus();
            return;
        }

        showSplitNotification("processing", "Saving split unit. Please wait...");

        $.post(
            "../controllers/productoperations.php",
            {
                saveproductsplitunit: 1,
                id: activeSplitUnitId,
                productid: mainProductId,
                unitname: name,
                unitsoftotal: total,
                unitprice: price
            },
            function(data){
                if ($.trim(data) === "success") {
                    splitUnitName.val("");
                    splitUnitsOfTotal.val("");
                    splitUnitPrice.val("");
                    activeSplitUnitId = 0;
                    saveBulkBreakBtn.html("<i class='fal fa-save fa-lg fa-fw'></i> Save Split unit");
                    
                    showSplitNotification("success", "Split unit saved successfully!");
                    loadProductSplitUnits(mainProductId);
                } else {
                    showSplitNotification("danger", "Error saving split unit: " + data);
                }
            }
        ).fail(function(xhr, status, error) {
            showSplitNotification("danger", "Connection error: " + error);
        });
    });

    function loadProductSplitUnits(productId){
        if(productId === "0" || productId === "") {
            splitUnitsTableBody.html("");
            return;
        }
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproductsplitunits: 1,
                productid: productId
            },
            function(data){
                let results = "";
                for(let i=0; i<data.length; i++){
                    results += `<tr>` +
                               `<td>${i+1}</td>` +
                               `<td>${data[i].unitname}</td>` +
                               `<td>${data[i].unitsoftotal}</td>` +
                               `<td>${$.number(data[i].unitprice, 2)}</td>` +
                               `<td>${data[i].dateadded}</td>` +
                               `<td>${data[i].addedby}</td>` +
                               `<td class="text-center">` +
                               `    <div class="dropdown">` +
                               `        <a class="btn btn-sm btn-link text-secondary p-0" href="#" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-size: 1.1rem; text-decoration: none;">` +
                               `            <i class="fal fa-ellipsis-v"></i>` +
                               `        </a>` +
                               `        <div class="dropdown-menu dropdown-menu-right shadow border-0" style="border-radius: 8px; font-size: 0.85rem; z-index: 1050 !important;">` +
                               `            <a class="dropdown-item edit-split-unit" href="#" data-id='${data[i].id}' data-name='${data[i].unitname}' data-total='${data[i].unitsoftotal}' data-price='${data[i].unitprice}'>` +
                               `                <i class="fal fa-edit fa-fw mr-2" style="color: #6c757d; font-size: 0.85rem;"></i> Edit` +
                               `            </a>` +
                               `            <a class="dropdown-item delete-split-unit text-danger" href="#" data-id='${data[i].id}'>` +
                               `                <i class="fal fa-trash-alt fa-fw mr-2" style="color: #dc3545; font-size: 0.85rem;"></i> Delete` +
                               `            </a>` +
                               `        </div>` +
                               `    </div>` +
                               `</td>` +
                               `</tr>`;
                }
                splitUnitsTableBody.html(results);
            }
        );
    }

    splitUnitsTableBody.on("click", ".edit-split-unit", function(e){
        e.preventDefault();
        const $this = $(this);
        activeSplitUnitId = $this.attr("data-id");
        splitUnitName.val($this.attr("data-name"));
        splitUnitsOfTotal.val($this.attr("data-total"));
        splitUnitPrice.val($this.attr("data-price"));
        saveBulkBreakBtn.html("<i class='fal fa-save fa-lg fa-fw'></i> Update Split unit");
        splitUnitName.focus();
    });

    splitUnitsTableBody.on("click", ".delete-split-unit", function(e){
        e.preventDefault();
        const id = $(this).attr("data-id");
        bootbox.confirm("Are you sure you want to delete this split unit?", function(result){
            if(result){
                $.post(
                    "../controllers/productoperations.php",
                    {
                        deleteproductsplitunit: 1,
                        id: id
                    },
                    function(data){
                        if($.trim(data) === "success"){
                            loadProductSplitUnits(idfield.val());
                        } else {
                            bootbox.alert("Error deleting split unit: " + data);
                        }
                    }
                );
            }
        });
    });

    window.loadProductSplitUnits = loadProductSplitUnits;

    // History Date Filter Initialization and Setup
    function initAllHistoryDatepickers() {
        const ids = [
            "#filterproductmovementstartdate", "#filterproductmovementenddate",
            "#filterpricinghistorystartdate", "#filterpricinghistoryenddate",
            "#filterpurchasehistorystartdate", "#filterpurchasehistoryenddate",
            "#filtersaleshistorystartdate", "#filtersaleshistoryenddate",
            "#filtertransferhistorystartdate", "#filtertransferhistoryenddate",
            "#filterspoilagehistorystartdate", "#filterspoilagehistoryenddate"
        ];
        ids.forEach(id => {
            const $el = $(id);
            if ($el.length && typeof setDatePicker === "function") {
                setDatePicker($el);
            }
        });
    }

    function setupDateRangeChangeListeners() {
        const config = [
            { select: "#filterproductmovementdaterange", start: "#filterproductmovementstartdate", end: "#filterproductmovementenddate" },
            { select: "#filterpricinghistorydaterange", start: "#filterpricinghistorystartdate", end: "#filterpricinghistoryenddate" },
            { select: "#filterpurchasehistorydaterange", start: "#filterpurchasehistorystartdate", end: "#filterpurchasehistoryenddate" },
            { select: "#filtersaleshistorydaterange", start: "#filtersaleshistorystartdate", end: "#filtersaleshistoryenddate" },
            { select: "#filtertransferhistorydaterange", start: "#filtertransferhistorystartdate", end: "#filtertransferhistoryenddate" },
            { select: "#filterspoilagehistorydaterange", start: "#filterspoilagehistorystartdate", end: "#filterspoilagehistoryenddate" }
        ];

        function getFormattedDate(date) {
            const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            const day = date.getDate();
            const month = months[date.getMonth()];
            const year = date.getFullYear();
            return (day < 10 ? '0' + day : day) + '-' + month + '-' + year;
        }

        config.forEach(item => {
            $(item.select).on("change", function() {
                const value = $(this).val();
                const today = new Date();
                let startDate, endDate;

                if (value === "0") {
                    $(item.start).val("").prop("disabled", true);
                    $(item.end).val("").prop("disabled", true);
                } else if (value === "week") {
                    const dayOfWeek = today.getDay();
                    startDate = new Date(today);
                    startDate.setDate(today.getDate() - dayOfWeek);
                    endDate = today;
                    $(item.start).val(getFormattedDate(startDate)).prop("disabled", true);
                    $(item.end).val(getFormattedDate(endDate)).prop("disabled", true);
                } else if (value === "month") {
                    startDate = new Date(today.getFullYear(), today.getMonth(), 1);
                    endDate = today;
                    $(item.start).val(getFormattedDate(startDate)).prop("disabled", true);
                    $(item.end).val(getFormattedDate(endDate)).prop("disabled", true);
                } else if (value === "year") {
                    startDate = new Date(today.getFullYear(), 0, 1);
                    endDate = today;
                    $(item.start).val(getFormattedDate(startDate)).prop("disabled", true);
                    $(item.end).val(getFormattedDate(endDate)).prop("disabled", true);
                } else if (value === "specify") {
                    $(item.start).prop("disabled", false);
                    $(item.end).prop("disabled", false);
                }
            });
        });
    }

    function initializeMovementSummaryDates() {
        const today = new Date();
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(today.getDate() - 30);

        function getFormattedDate(date) {
            const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            const day = date.getDate();
            const month = months[date.getMonth()];
            const year = date.getFullYear();
            return (day < 10 ? '0' + day : day) + '-' + month + '-' + year;
        }

        const formattedToday = getFormattedDate(today);
        const formattedThirtyDaysAgo = getFormattedDate(thirtyDaysAgo);

        const tabs = [
            { start: "#filterproductmovementstartdate", end: "#filterproductmovementenddate", select: "#filterproductmovementdaterange" },
            { start: "#filterpricinghistorystartdate", end: "#filterpricinghistoryenddate", select: "#filterpricinghistorydaterange" },
            { start: "#filterpurchasehistorystartdate", end: "#filterpurchasehistoryenddate", select: "#filterpurchasehistorydaterange" },
            { start: "#filtersaleshistorystartdate", end: "#filtersaleshistoryenddate", select: "#filtersaleshistorydaterange" },
            { start: "#filtertransferhistorystartdate", end: "#filtertransferhistoryenddate", select: "#filtertransferhistorydaterange" },
            { start: "#filterspoilagehistorystartdate", end: "#filterspoilagehistoryenddate", select: "#filterspoilagehistorydaterange" }
        ];

        tabs.forEach(tab => {
            const $start = $(tab.start);
            const $end = $(tab.end);
            const $select = $(tab.select);

            $start.val(formattedThirtyDaysAgo);
            $end.val(formattedToday);
            $select.val("specify");
            $start.prop("disabled", false);
            $end.prop("disabled", false);
        });
    }

    // Loader functions for each tab
    function loadMovementHistory() {
        const productid = $("#id").val();
        const startdate = $("#filterproductmovementstartdate").val();
        const enddate = $("#filterproductmovementenddate").val();
        if (!productid) return;

        const tableObj = $("#productmovementtable");
        tableObj.find("tbody").html('<tr><td colspan="7" class="text-center">Loading...</td></tr>');

        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproducthistory: true,
                tab: 'movement',
                productid: productid,
                startdate: startdate,
                enddate: enddate
            },
            function(data) {
                let results = '';
                if (data.length === 0) {
                    if ($.fn.dataTable.isDataTable(tableObj)) {
                        tableObj.DataTable().clear().destroy();
                    }
                    tableObj.find("tbody").html('<tr><td colspan="7" class="text-center">No movement records found.</td></tr>');
                    return;
                }
                let runningbalance = parseFloat(data[0].openingbalance) || 0;
                data.forEach((item, index) => {
                    results += `<tr>
                        <td>${index + 1}</td>
                        <td>${item.date || ''}</td>
                        <td>${item.description || ''}</td>`;
                    
                    if (index === 0) {
                        results += `<td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>`;
                    } else {
                        const stockin = item.stockin ? parseFloat(item.stockin) : 0;
                        const stockout = item.stockout ? parseFloat(item.stockout) : 0;
                        runningbalance += stockin - stockout;
                        
                        results += `<td>${item.reference || ''}</td>
                                    <td class="text-right">${item.stockin ? $.number(item.stockin) : ''}</td>
                                    <td class="text-right">${item.stockout ? $.number(item.stockout) : ''}</td>`;
                    }
                    
                    results += `<td class="text-right">${$.number(runningbalance)}</td>
                    </tr>`;
                });
                makedatatable(tableObj, results, 15);
            }
        );
    }

    function loadPricingHistory() {
        const productid = $("#id").val();
        const price_type = $("#filterproductpricingtype").val();
        const startdate = $("#filterpricinghistorystartdate").val();
        const enddate = $("#filterpricinghistoryenddate").val();
        if (!productid) return;

        const tableObj = $("#productpricingtable");
        tableObj.find("tbody").html('<tr><td colspan="4" class="text-center">Loading...</td></tr>');

        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproducthistory: true,
                tab: 'pricing',
                productid: productid,
                price_type: price_type,
                startdate: startdate,
                enddate: enddate
            },
            function(data) {
                let results = '';
                if (data.length === 0) {
                    if ($.fn.dataTable.isDataTable(tableObj)) {
                        tableObj.DataTable().clear().destroy();
                    }
                    tableObj.find("tbody").html('<tr><td colspan="4" class="text-center">No pricing history found.</td></tr>');
                    return;
                }
                data.forEach((item, index) => {
                    results += `<tr>
                        <td>${index + 1}</td>
                        <td>${item.date || ''}</td>
                        <td class="text-right">${item.buying ? $.number(item.buying, 2) : ''}</td>
                        <td class="text-right">${item.selling ? $.number(item.selling, 2) : ''}</td>
                    </tr>`;
                });
                makedatatable(tableObj, results, 15);
            }
        );
    }

    function loadPurchaseHistory() {
        const productid = $("#id").val();
        const startdate = $("#filterpurchasehistorystartdate").val();
        const enddate = $("#filterpurchasehistoryenddate").val();
        if (!productid) return;

        const tableObj = $("#productpurchasetable");
        tableObj.find("tbody").html('<tr><td colspan="9" class="text-center">Loading...</td></tr>');

        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproducthistory: true,
                tab: 'purchase',
                productid: productid,
                startdate: startdate,
                enddate: enddate
            },
            function(data) {
                let results = '';
                if (data.length === 0) {
                    if ($.fn.dataTable.isDataTable(tableObj)) {
                        tableObj.DataTable().clear().destroy();
                    }
                    tableObj.find("tbody").html('<tr><td colspan="9" class="text-center">No purchase records found.</td></tr>');
                    return;
                }
                data.forEach((item, index) => {
                    results += `<tr>
                        <td>${index + 1}</td>
                        <td>${item.date || ''}</td>
                        <td>${item.suppliername || ''}</td>
                        <td>${item.purchaseorderno || ''}</td>
                        <td>${item.invoiceno || ''}</td>
                        <td>${item.deliverydate || ''}</td>
                        <td class="text-right">${$.number(item.quantity)}</td>
                        <td class="text-right">${$.number(item.unitprice, 2)}</td>
                        <td class="text-right">${$.number(item.total, 2)}</td>
                    </tr>`;
                });
                makedatatable(tableObj, results, 15);
            }
        );
    }

    function loadSalesHistory() {
        const productid = $("#id").val();
        const startdate = $("#filtersaleshistorystartdate").val();
        const enddate = $("#filtersaleshistoryenddate").val();
        if (!productid) return;

        const tableObj = $("#productsalestable");
        tableObj.find("tbody").html('<tr><td colspan="8" class="text-center">Loading...</td></tr>');

        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproducthistory: true,
                tab: 'sales',
                productid: productid,
                startdate: startdate,
                enddate: enddate
            },
            function(data) {
                let results = '';
                if (data.length === 0) {
                    if ($.fn.dataTable.isDataTable(tableObj)) {
                        tableObj.DataTable().clear().destroy();
                    }
                    tableObj.find("tbody").html('<tr><td colspan="8" class="text-center">No sales records found.</td></tr>');
                    return;
                }
                data.forEach((item, index) => {
                    results += `<tr>
                        <td>${index + 1}</td>
                        <td>${item.date || ''}</td>
                        <td>${item.customername || ''}</td>
                        <td>${item.receiptno || ''}</td>
                        <td class="text-right">${$.number(item.quantity)}</td>
                        <td class="text-right">${$.number(item.unitprice, 2)}</td>
                        <td class="text-right">${$.number(item.total, 2)}</td>
                        <td>${item.transactedby || ''}</td>
                    </tr>`;
                });
                makedatatable(tableObj, results, 15);
            }
        );
    }

    function loadTransfersHistory() {
        const productid = $("#id").val();
        const source_type = $("#filtertransferhistorysource").val();
        const source_id = $("#filtertransactionhistorysourcename").val();
        const dest_type = $("#filtertransferhistorydestination").val();
        const dest_id = $("#filtertransactionhistorydestinationname").val();
        const startdate = $("#filtertransferhistorystartdate").val();
        const enddate = $("#filtertransferhistoryenddate").val();
        if (!productid) return;

        const tableObj = $("#producttransferstable");
        tableObj.find("tbody").html('<tr><td colspan="7" class="text-center">Loading...</td></tr>');

        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproducthistory: true,
                tab: 'transfers',
                productid: productid,
                source_type: source_type,
                source_id: source_id,
                dest_type: dest_type,
                dest_id: dest_id,
                startdate: startdate,
                enddate: enddate
            },
            function(data) {
                let results = '';
                if (data.length === 0) {
                    if ($.fn.dataTable.isDataTable(tableObj)) {
                        tableObj.DataTable().clear().destroy();
                    }
                    tableObj.find("tbody").html('<tr><td colspan="7" class="text-center">No transfer records found.</td></tr>');
                    return;
                }
                let balance = 0;
                data.forEach((item, index) => {
                    const stockin = parseFloat(item.stockin) || 0;
                    const stockout = parseFloat(item.stockout) || 0;
                    balance = balance + stockin - stockout;
                    results += `<tr>
                        <td>${index + 1}</td>
                        <td>${item.date || ''}</td>
                        <td>${item.narration || ''}</td>
                        <td>${item.reference || ''}</td>
                        <td class="text-right">${$.number(stockin)}</td>
                        <td class="text-right">${$.number(stockout)}</td>
                        <td class="text-right">${$.number(balance)}</td>
                    </tr>`;
                });
                makedatatable(tableObj, results, 15);
            }
        );
    }

    function loadSpoilageHistory() {
        const productid = $("#id").val();
        const spoilage_type = $("#filterspoilagehistorytype").val();
        const startdate = $("#filterspoilagehistorystartdate").val();
        const enddate = $("#filterspoilagehistoryenddate").val();
        if (!productid) return;

        const tableObj = $("#productspoilagetable");
        tableObj.find("tbody").html('<tr><td colspan="7" class="text-center">Loading...</td></tr>');

        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproducthistory: true,
                tab: 'spoilage',
                productid: productid,
                spoilage_type: spoilage_type,
                startdate: startdate,
                enddate: enddate
            },
            function(data) {
                let results = '';
                if (data.length === 0) {
                    if ($.fn.dataTable.isDataTable(tableObj)) {
                        tableObj.DataTable().clear().destroy();
                    }
                    tableObj.find("tbody").html('<tr><td colspan="7" class="text-center">No spoilage records found.</td></tr>');
                    return;
                }
                data.forEach((item, index) => {
                    results += `<tr>
                        <td>${index + 1}</td>
                        <td>${item.date || ''}</td>
                        <td>${item.type || ''}</td>
                        <td class="text-right">${$.number(item.quantity)}</td>
                        <td class="text-right">${$.number(item.unitprice, 2)}</td>
                        <td class="text-right">${$.number(item.total, 2)}</td>
                        <td>${item.addedby || ''}</td>
                    </tr>`;
                });
                makedatatable(tableObj, results, 15);
            }
        );
    }

    function loadActiveHistoryTab() {
        // Find which sub-tab is currently active
        const activeSubtab = $("#subnav-tab a.active").attr("id");
        if (activeSubtab === "movementsummary-tab") {
            loadMovementHistory();
        } else if (activeSubtab === "pricinghistory-tab") {
            loadPricingHistory();
        } else if (activeSubtab === "purchases-tab") {
            loadPurchaseHistory();
        } else if (activeSubtab === "saleshistory-tab") {
            loadSalesHistory();
        } else if (activeSubtab === "transfershistory-tab") {
            loadTransfersHistory();
        } else if (activeSubtab === "spoilagehistory-tab") {
            loadSpoilageHistory();
        }
    }

    function loadSpoilageCategories() {
        $.getJSON(
            "../controllers/spoilageoperations.php",
            { getspoilagecategories: true },
            function(data) {
                let options = '<option value="0">&lt;All&gt;</option>';
                data.forEach(item => {
                    options += `<option value="${item.id}">${item.categoryname}</option>`;
                });
                $("#filterspoilagehistorytype").html(options);
            }
        );
    }

    function getWarehousesForTransfers(selectBox) {
        var results = "<option value='0'>&lt;All&gt;</option>";
        $.getJSON(
            "../controllers/warehouseoperations.php",
            { getwarehouses: "GET" },
            function(data) {                   
                for (var i = 0; i < data.length; i++) {
                    results += "<option value='" + data[i].id + "'>" + data[i].description + "</option>";
                }
                selectBox.html(results);
            }
        );
    }

    function getPointsOfSaleForTransfers(selectBox) { 
        var results = "<option value='0'>&lt;All&gt;</option>";
        $.getJSON(
            "../controllers/getpointsofsale.php",
            function(data) {                   
                for (var i = 0; i < data.length; i++) {
                    results += "<option value='" + data[i].id + "'>" + data[i].posname + "</option>";
                }
                selectBox.html(results);
            }
        ); 
    }

    // Dynamic dropdown loaders for transfers
    $("#filtertransferhistorysource").on("change", function() {
        const typename = $(this).val();
        const nameSelect = $("#filtertransactionhistorysourcename");
        if (typename === "warehouse") {
            getWarehousesForTransfers(nameSelect);
        } else if (typename === "outlet") {
            getPointsOfSaleForTransfers(nameSelect);
        } else {
            nameSelect.html("<option value='0'>&lt;All&gt;</option>");
        }
    });

    $("#filtertransferhistorydestination").on("change", function() {
        const typename = $(this).val();
        const nameSelect = $("#filtertransactionhistorydestinationname");
        if (typename === "warehouse") {
            getWarehousesForTransfers(nameSelect);
        } else if (typename === "outlet") {
            getPointsOfSaleForTransfers(nameSelect);
        } else {
            nameSelect.html("<option value='0'>&lt;All&gt;</option>");
        }
    });

    // Bind filter button click events
    $("#filterproductmovement").on("click", loadMovementHistory);
    $("#filterpricinghistory").on("click", loadPricingHistory);
    $("#filterpurchasehistory").on("click", loadPurchaseHistory);
    $("#filtersaleshistory").on("click", loadSalesHistory);
    $("#filtertransferhistory").on("click", loadTransfersHistory);
    $("#filterspoilagehistory").on("click", loadSpoilageHistory);

    // Bind event listeners
    initAllHistoryDatepickers();
    setupDateRangeChangeListeners();
    loadSpoilageCategories();

    // Trigger on tab clicks
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        if (e.target.id === 'producthistory-tab') {
            loadActiveHistoryTab();
        } else if ($(e.target).parent().parent().attr('id') === 'subnav-tab') {
            loadActiveHistoryTab();
        }
    });

    window.initializeMovementSummaryDates = initializeMovementSummaryDates;
    window.loadActiveHistoryTab = loadActiveHistoryTab;
})