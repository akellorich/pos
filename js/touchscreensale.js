$(document).ready(() => {
    // hide touchscreen by default
    // check default business type and switch sales windows as appropriate
    const urlParams = getUrlParams()
    // console.log(urlParams)
    if (!urlParams.switch) {
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getinstitutiondetails: true
            },
            (data) => {
                if (data[0].mainbusinesstype == 'restaurant') {
                    window.location.href = "customerorders.php"
                }
            }
        )
    }

    const customerlist = $("#customer")
    const poslist = $("#outlet")
    // const itemcodefield=$("#itemcode")
    const categories = $("#categories")
    const products = $("#products")
    const errordiv = $("#errors")
    const salesitemsdetails = $("#salesitemsdetails")
    const inputcontrol = $("input")
    const selectcontrol = $("select")
    const overalltotal = $("#overalltotalamount")
    const searchresults = $("#searchproducts"),
        creditnotelist = $("#creditnote"),
        creditnotevalue = $("#creditnotevalue"),
        transactiondatefield = $("#transactiondate"),
        locksystembutton = $("#locksystem"),
        itemcodefield = $("#itemcode"),
        searchproductbutton = $("#searchproduct"),
        searchresultslist = $("#searchresultslist"),
        searchproductslist = $("#searchproductlist"),
        lponofield = $("#reference")

    let changeprices = false
    window.allowpricechange = false
    window.allownegativesalesglobally = false

    getactivesession()
    getcategories()

    // Enable or disable change date vased on user privilege

    locksystembutton.on("click", () => {
        window.location.href = "../index.html"
    })

    setDatePicker(transactiondatefield)
    transactiondatefield.val(todaysDate())

    // console.log(validateuserprivilege(52).done((isvalid)=>{
    //     isvalid
    // }))

    validateuserprivilege(52).done((isvalid) => {
        transactiondatefield.prop("disabled", !isvalid)
    })

    // check if there is an active session
    function getactivesession() {
        $.getJSON(
            "../controllers/sessionoperations.php",
            {
                getactivesession: true
            },
            (data) => {
                // console.log(data.length)
                if (data.length == 0) {
                    errordiv.html(showAlert("danger", `Sorry, no active sessions open. Contact your manager to open a Session`))
                    $(".btn").prop("disabled", true)
                    $("select").prop("disabled", true)
                    $("input").prop("disabled", true)
                    // $("table").prop("disabled",true)
                }
            }
        )
    }

    // Set Focus to Itemcode field
    itemcodefield.focus()

    const paymentmethodslist = $("#paymentmethod"),
        amountpaidfield = $("#amountpaid"),
        balancefield = $("#balanceamount"),
        referencenofield = $("#refno"),
        savebutton = $("#save"),
        clearbutton = $("#clear"),
        paymentmodetext = $("#paymentmodetext"),
        paymentmodevalue = $("#paymentmodevalue"),
        totalpayments = $("#totalpaymentsvalue"),
        holdsale = $("#hold"),
        retrieveheldsale = $("#retrieve"),
        heldsaleslist = $("#heldsalesdetails"),
        paymentoptions = $("#paymentoptions"),
        addpayments = $("#addpayments"),
        paymentsmodal = $("#payments"),
        confirmdialog = $("#confirm-dialog")

    paymentsmodal.on('hidden.bs.modal', function () {
        $("#itemcode").focus();
    });
    totalamountpayable = $("#totalamountpayable"),
        totalpaid = $("#totalpaid"),
        change = $("#change"),
        paymenterror = $("#paymenterror"),
        heldsalesmodal = $("#heldsales"),
        serialnumbersmodal = $("#serialsmodal"),
        serialdetailsquanity = $("#serialquantity"),
        serialdetailsname = $("#serialitemname"),
        serialdetailsid = $("#serialitemid"),
        serialnumbersdropdownlist = $("#serialnumbers"),
        addserialnumberstolistbutton = $("#saveserialnumbers"),
        serialnumberslist = $("#serialstable"),
        serialserrors = $("#serialserrors"),
        serialstotal = $("#serialstotals"),
        updateserialsbutton = $("#updateserials"),
        bundleitemsmodal = $("#bundleitemsmodal"),
        addbundleitembutton = $("#addbundleitems"),
        donebundlebuttons = $("#savebundleitems"),
        customermodal = $("#newcustomermodal"),
        addcustomerbutton = $("#addcustomer"),
        customercategorylist = $("#customercategory"),
        customernamefield = $("#customername"),
        idnumberfield = $("#idnumber"),
        pinnumberfield = $("#pinnumber"),
        mobilefield = $("#mobilenumber"),
        emailaddressfield = $("#emailaddress"),
        savecustomerbutton = $("#savecustomer"),
        customererrordiv = $("#customerdetailserrors"),
        mpesaconfirmationmodal = $("#mpesaconfirmationmodal"),
        addmpesatransactionbutton = $("#addmpesatransaction"),
        printlargeformat = $("#chkprintlargeformat"),
        printreceiptfield = $("#chkprintreceipt"),
        sendtovaultfield = $("#sendtovault"),
        walletidfield = $("#walletid")

    inputcontrol.on("input", () => {
        errordiv.html("")
        printernotifications.html("")
    })

    selectcontrol.on("change", () => {
        inputcontrol.trigger("input")
    })

    sendtovaultfield.on("click", function () {
        if (sendtovaultfield.prop("checked")) {
            walletidfield.focus()
        }
    })

    getInstitutionDetails().done((data) => {
        // console.log(data)
        printreceiptfield.prop("checked", data.printreceipt == 1 ? true : false)
        window.allowpricechange = data.allowpricechange == 1;
        window.allownegativesalesglobally = data.allownegativesalesglobally == 1;
        
        const isTouchscreenV2 = window.location.pathname.includes('touchscreensale_v2');
        if (isTouchscreenV2 && window.allowpricechange) {
            changeprices = true;
        }
    })

    // get customer categories
    function getcategories() {
        $.getJSON(
            "../controllers/customeroperations.php",
            {
                getcustomercategories: true
            },
            function (data) {
                var results = ''
                for (var i = 0; i < data.length; i++) {
                    var selected = data[i].default == 1 ? "selected" : ""
                    results += `<option value='${data[i].id}' ${selected}>${data[i].categoryname || data[i].description}</option>`
                }
                customercategorylist.html(results)
            }
        )
    }

    getCustomers(customerlist, 'choose').done(() => {
        // get system default customer
        customerlist.val(defaultcustomerid)
    })

    getPointsOfSale(poslist, 'choose')
    getproductcategories()

    function renderProductCard(product) {
        let stock = parseFloat(product.available_stock) || 0;
        let stockDisplay = stock;
        let stockClass = "";

        if (stock <= 0) {
            stockDisplay = "OUT OF STOCK";
            stockClass = "stock-danger";
        }

        return `
            <button class='pos-product-card' data-id='${product.productid}' data-code='${product.itemcode}'>
               <span class="stock-pill ${stockClass}">${stockDisplay}</span>
               <span class="product-name">${product.itemname}</span>
               <span class="product-price">${product.sellingprice}</span>
            </button>`;
    }

    function getproductcategories() {
        $.getJSON(
            "../controllers/getcategories.php",
            (data) => {
                data = data.filter(category => category.rawmaterialcategory == 0)
                let results = '<button class="category-btn active" data-id="all">ALL</button>'
                data.forEach(category => {
                    results += `<button class='category-btn' data-id='${category.categoryid}'>${category.categoryname}</button>`
                })
                categories.html(results)
                // Load all products initially
                categories.find('button[data-id="all"]').trigger('click')
            }
        )
    }

    categories.on("click", "button", function (e) {
        const categoryid = $(this).attr("data-id")
        const posid = poslist.val()

        if (posid == "") {
            products.html("")
            categories.find("button").removeClass("active")
            if (e.originalEvent) {
                errordiv.html(showAlert("info", "Please select outlet first"))
                poslist.focus()
            }
            return
        }

        categories.find("button").removeClass("active")
        $(this).addClass("active")

        const params = {
            getproductbycategory: true,
            categoryid: categoryid === 'all' ? 0 : categoryid,
            posid: posid
        }

        $.getJSON(
            "../controllers/productoperations.php",
            params,
            (data) => {
                let results = ''
                data.forEach(product => {
                    results += renderProductCard(product);
                })
                products.html(results)
            }
        )
    })

    poslist.on("change", function () {
        const activeCategory = categories.find("button.active");
        if (activeCategory.length > 0) {
            activeCategory.trigger("click");
        } else {
            categories.find('button[data-id="all"]').trigger('click');
        }
    })

    // get product details
    products.on("click", ".pos-product-card", function () {
        $this = $(this)
        // check if outlet is selected
        if (poslist.val() == "") {
            errors = "Please select outlet first"
            errordiv.html(showAlert("info", errors))
            poslist.focus()
        } else if (customerlist.val() == "") {
            errors = "Please select customer first"
            errordiv.html(showAlert("info", errors))
            customerlist.focus()
        } else {
            const productcode = $this.attr("data-code")
            getproduct(productcode)
        }
    })

    function getproduct(productcode) {
        const customerid = customerlist.val()
        const storeid = poslist.val()
        $.getJSON(
            "../controllers/productoperations.php",
            {
                getproductdetails: true,
                productcode,
                customerid,
                storeid
            },
            function (data) {
                // check if JSON returned a blank object
                let productdetails = ''
                if (Object.keys(data).length === 0) {
                    errors = "No product with similar code found"
                    errordiv.html(showAlert("info", errors))
                } else if (data[0].disallowsale == 1) {
                    errors = `Selling is disallowed for <strong>${data[0].itemname}</strong>.`
                    errordiv.html(showAlert("danger", errors))
                } else {
                    errordiv.html("")
                    // check if there are quantities in stock for the item
                    if (Number(data[0].itembalance) <= 0 && Number(data[0].allownegativesales) == 0 && !window.allownegativesalesglobally) {
                        errors = `<strong>${data[0].itemname}</strong> has <strong>${data[0].itembalance}</strong> quantities in stock hence can't be sold.`
                        errordiv.html(showAlert("danger", errors))
                    } else {
                        let sellingprice = data[0].sellingprice,
                            randomno = randomId()
                        let discountValue = 0;
                        let discountLabel = `Discount: 0.00`;
                        const baseUom = data[0].unitofmeasure || "Piece";
                        $.getJSON(
                            "../controllers/productoperations.php",
                            {
                                getproductsplitunits: true,
                                productid: data[0].productid
                            },
                            function (splitUnits) {
                                let uomHtml = '';
                                if (splitUnits && splitUnits.length > 0) {
                                    uomHtml = `<select class='uom-select form-control input-sm' style='padding: 2px 6px; height: 28px; font-size: 11px; border-radius: 6px; width: 100%; border: 1px solid var(--border-color); color: var(--text-main); font-weight: 600; outline: none; background: white;'>`;
                                    uomHtml += `<option value='${baseUom}' data-price='${data[0].sellingprice}'>${baseUom} (KES ${data[0].sellingprice})</option>`;
                                    splitUnits.forEach(function (unit) {
                                        uomHtml += `<option value='${unit.unitname}' data-price='${unit.unitprice}'>${unit.unitname} (KES ${unit.unitprice})</option>`;
                                    });
                                    uomHtml += `</select>`;
                                } else {
                                    uomHtml = `<span class='badge badge-default' style='font-size: 11px; font-weight: 600; padding: 4px 8px; color: #475569; background: #f1f5f9; border-radius: 6px;'>${baseUom}</span>`;
                                }

                                const isTouchscreenV2 = window.location.pathname.includes('touchscreensale_v2');
                                const isSoldByValue = isTouchscreenV2 && data[0].saleby === 'value';

                                let rowClass = 'clickable-row';
                                let priceHtml = '';
                                let qtyHtml = '';

                                if (isSoldByValue) {
                                    rowClass += ' sold-by-value';
                                    priceHtml = `<div class='qty-pill price-pill'>
                                        <button class='qty-btn btn-minus' data-id='${randomno}'>−</button>
                                        <span class='qty-val-price price-val'>${sellingprice}</span>
                                        <button class='qty-btn btn-plus' data-id='${randomno}'>+</button>
                                    </div>`;
                                    qtyHtml = `<span class='qty-val linetotal-qty'>1.00</span>`;
                                } else {
                                    rowClass += ' sold-by-quantity';
                                    priceHtml = data[0].sellingprice;
                                    qtyHtml = `<div class='qty-pill'>
                                        <button class='qty-btn btn-minus' data-id='${randomno}'>−</button>
                                        <span class='qty-val linetotal-qty'>1</span>
                                        <button class='qty-btn btn-plus' data-id='${randomno}'>+</button>
                                    </div>`;
                                }

                                let productdetails = '';
                                productdetails += `<tr class='${rowClass}' data-id='${randomno}' data-productid='${data[0].productid}' data-serializable='${data[0].serializable}' data-serial-nos='' data-allownegativesales=${data[0].allownegativesales} data-buyingprice='${data[0].buyingprice || 0}' data-saleby='${data[0].saleby || "quantity"}' data-baseprice='${data[0].sellingprice}'><td>${data[0].itemcode}</td>`
                                productdetails += `<td class='cart-item-info'>
                                    <div class='item-name'>${data[0].itemname}</div>
                                    <div class='item-barcode'>${data[0].itemcode}</div>
                                    <div class='item-discount'>${discountLabel}</div>
                                </td>`
                                productdetails += `<td class='description'></td>`
                                productdetails += `<td class='price'>${priceHtml}</td>`
                                productdetails += `<td class='discount-val'>${discountValue}</td>`
                                productdetails += `<td>${sellingprice}</td>`
                                productdetails += `<td>${data[0].itembalance}</td>`
                                productdetails += `<td class='quantity'>${qtyHtml}</td>`
                                productdetails += data[0].serializable == 1 ? `<td><button class='btn btn-xs btn-primary addserials' data-id='${randomno}' data-name='${data[0].itemname}'><span><i class='fas fa-plus-circle fa-sm'></i> Add serials numbers</span></button></td>` : `<td>&nbsp</td>`
                                productdetails += `<td class='linetotal'>${$.number(sellingprice, 2)}</td>`
                                productdetails += `<td class='cart-item-delete'><a href='javascript:void(0)' class='deletedata' data-id='${randomId()}'><i class='material-symbols-outlined'>close</i></a></td>`
                                productdetails += `<td class='cart-item-uom'>${uomHtml}</td></tr>`

                                $(productdetails).appendTo(salesitemsdetails.find("tbody"))
                                validateRowBuyingPrice(salesitemsdetails.find("tbody tr").last())
                                let total = getItemsTotal()
                                overalltotal.html($.number(total, 2))
                                totalamountpayable.html($.number(total, 2))
                                computeTotalAmountPaid()
                            }
                        );
                    }
                }
            }
        )
    }

    // Quantity adjustment logic
    salesitemsdetails.on("click", ".btn-plus, .btn-minus", function (e) {
        e.preventDefault();
        e.stopPropagation();
        const $btn = $(this);
        const $row = $btn.closest("tr");
        const isSoldByValue = $row.attr("data-saleby") === "value";

        if (isSoldByValue) {
            const $priceSpan = $row.find(".price-val");
            let currentPrice = parseFloat($priceSpan.text()) || 0;
            if ($btn.hasClass("btn-plus")) {
                currentPrice++;
            } else {
                if (currentPrice > 1) {
                    currentPrice--;
                }
            }
            updateValueSoldProduct($row, currentPrice);
            return;
        }

        const $qtySpan = $row.find(".qty-val");
        const $totalTd = $row.find(".linetotal");
        const price = parseFloat($row.find(".price").text());
        const stock = parseFloat($row.find("td").eq(6).text());
        const allowNegative = $row.attr("data-allownegativesales") == "1";

        let currentQty = parseInt($qtySpan.text());

        if ($btn.hasClass("btn-plus")) {
            if (currentQty < stock || allowNegative || window.allownegativesalesglobally) {
                currentQty++;
            } else {
                errordiv.html(showAlert("warning", "Insufficient stock available"));
            }
        } else {
            if (currentQty > 1) {
                currentQty--;
            }
        }

        $qtySpan.text(currentQty);
        const newTotal = currentQty * price;
        $totalTd.text($.number(newTotal, 2));

        // Update overall totals
        const total = getItemsTotal();
        overalltotal.html($.number(total, 2));
        totalamountpayable.html($.number(total, 2));
    });

    salesitemsdetails.on("change", ".uom-select", function () {
        const $select = $(this);
        const $row = $select.closest("tr");
        const $totalTd = $row.find(".linetotal");
        const selectedOption = $select.find("option:selected");
        const newPrice = parseFloat(selectedOption.attr("data-price"));

        const isSoldByValue = $row.attr("data-saleby") === "value";
        if (isSoldByValue) {
            $row.attr("data-baseprice", newPrice);
            $row.find("td").eq(5).text(newPrice);
            
            // Set value inside price pill to newPrice
            $row.find(".price-val").text(newPrice.toFixed(2));
            
            // Recalculate quantity: value / baseprice = 1.00
            $row.find(".linetotal-qty").text("1.00");
            $totalTd.text($.number(newPrice, 2));
        } else {
            const $qtySpan = $row.find(".qty-val");
            $row.find(".price").text(newPrice);
            $row.find("td").eq(5).text(newPrice);

            const currentQty = parseInt($qtySpan.text());
            const newTotal = currentQty * newPrice;
            $totalTd.text($.number(newTotal, 2));
        }

        validateRowBuyingPrice($row);

        const total = getItemsTotal();
        overalltotal.html($.number(total, 2));
        totalamountpayable.html($.number(total, 2));
        computeTotalAmountPaid();
    });

    function getItemsTotal() {
        var sum = 0;
        // iterate through each td based on class and add the values
        $(".linetotal").each(function () {
            var value = $(this).text().replace("KES ", "").replace(/,/g, "");
            // add only if the value is number
            if (!isNaN(value) && value.length != 0) {
                sum += parseFloat(value);
            }
        })
        return sum;
    }

    function computeTotalAmountPaid() {
        var credittotal = parseFloat(creditnotevalue.html()),
            paymentmodetotal = parseFloat(amountpaidfield.val())
        overalltotalamount = parseFloat(overalltotal.html())
        if (!isNaN(credittotal) && credittotal.length != 0 && !isNaN(paymentmodetotal) && paymentmodetotal.length != 0) {
            totalpaid = credittotal + paymentmodetotal
            totalpayments.html(totalpaid)
            computeCustomerBalance()
            // compute balance 
            if (!isNaN(overalltotalamount) && overalltotalamount.length != 0) {
                var balance = totalpaid - overalltotalamount
                balancefield.html(balance)
            }
        }
    }

    salesitemsdetails.on("click", ".deletedata", function (e) {
        e.preventDefault();
        var parent = $(this).closest("tr");
        var id = $(this).attr('data-id');
        var itemname = parent.find(".item-name").text();
        bootbox.dialog({
            // title: "Confirm Item Removal!",
            message: "<div style='padding-top: 30px; padding-bottom: 5px; font-size: 15px;'>Are you sure you want to remove <span style='font-weight: 600;'>" + itemname + "</span> from the list?</div>",
            buttons: {
                success: {
                    label: "No, Keep",
                    className: "btn-success btn-sm",
                    callback: function () {
                        $('.bootbox').modal('hide');
                    }
                },
                danger: {
                    label: "Yes, Remove",
                    className: "btn-danger btn-sm",
                    callback: function () {
                        parent.remove()
                        overalltotal.html($.number(getItemsTotal(), 2))
                        computeTotalAmountPaid()
                        $('.bootbox').modal('hide')
                        totalamountpayable.html($.number(getItemsTotal(), 2))
                    }
                }
            }
        })
    })

    amountpaidfield.on("keyup", function () {
        amountpaidfield.val() == "" ? paymentmodevalue.html("0.00") : paymentmodevalue.html(amountpaidfield.val())
        computeTotalAmountPaid()
    })

    $.getJSON(
        "../controllers/settingoperations.php",
        {
            getsalessettings: true
        },
        function (data) {
            changeprices = data[0].changeitemprices == 1 ? true : false
        }
    )

    function getpaymentmethods() {
        const dfd = $.Deferred()
        $.getJSON(
            "../controllers/settingoperations.php",
            {
                getpaymentmethods: true
            },
            function (data) {
                var results = ""
                const currentCustomerVal = customerlist.val();
                const currentCustomerText = customerlist.find("option:selected").text();

                for (var i = 0; i < data.length; i++) {
                    const desc = data[i].description.toUpperCase();
                    const isMpesa = desc.includes('MPESA');
                    const isCredit = desc.includes('CREDIT');

                    let refContent = "";
                    if (isCredit) {
                        refContent = `
                        <div class="payment-input-wrapper">
                            <span class="material-symbols-outlined icon">person</span>
                            <select id="${data[i].id}_ref" class="payment-input ref-input customerslist has-one-action">
                                <option value="${currentCustomerVal}">${currentCustomerText}</option>
                            </select>
                            <div class="btn-actions">
                                <button type="button" class="input-action-btn authenticate">
                                    <span class="material-symbols-outlined">fingerprint</span>
                                    <span class="btn-text">AUTH</span>
                                </button>
                            </div>
                        </div>`;
                    } else if (isMpesa) {
                        refContent = `
                        <div class="payment-input-wrapper">
                            <span class="material-symbols-outlined icon">smartphone</span>
                            <input type="text" id="${data[i].id}_ref" class="payment-input ref-input reference has-actions" placeholder="07... ">
                            <div class="btn-actions">
                                <button type="button" class="input-action-btn"><span class="material-symbols-outlined" style="color: #10b981;">rocket_launch</span></button>
                                <button type="button" class="input-action-btn"><span class="material-symbols-outlined" style="color: #10b981;">sync</span></button>
                            </div>
                        </div>`;
                    } else {
                        const icon = 'tag';
                        const placeholder = 'Optional';
                        refContent = `
                        <div class="payment-input-wrapper">
                            <span class="material-symbols-outlined icon">${icon}</span>
                            <input type="text" id="${data[i].id}_ref" class="payment-input ref-input reference" placeholder="${placeholder}" ${data[i].requiresrefno == 1 ? '' : 'disabled'}>
                        </div>`;
                    }

                    results += `
                    <div class="payment-row">
                        <div class="payment-method-name">${data[i].description}</div>
                        <div class="input-container">
                            <span class="input-label">Amount</span>
                            <div class="payment-input-wrapper">
                                <span class="prefix"></span>
                                <input type="number" id="${data[i].id}" class="payment-input amount-input amount ${data[i].description} has-one-action" data-default="${data[i].default}" placeholder="0.00">
                                <div class="btn-actions">
                                    <button type="button" class="input-action-btn paste-total" title="Paste Remaining">
                                        <span class="material-symbols-outlined">content_paste</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="input-container">
                            <span class="input-label">${isMpesa ? 'Mobile No.' : (isCredit ? 'CHOOSE ASSOCIATE' : 'Reference No.')}</span>
                            ${refContent}
                        </div>
                    </div>`;
                }
                paymentoptions.html(results)
                dfd.resolve()
            }
        )
        return dfd.promise()
    }


    savebutton.on("click", function () {
        // disable the button
        savebutton.prop("disabled", true)
        const
            pointofsale = poslist.val(),
            customerid = customerlist.val(),
            tbody = $("#salesitemsdetails tbody"),
            itemslist = [],
            missingitems = false,
            transactiondate = sanitizestring(transactiondatefield.val()),
            reference = sanitizestring(lponofield.val()),
            sendtovault = sendtovaultfield.prop("checked") ? 1 : 0,
            walletid = walletidfield.val()

        let errors = "", TableData = []
        // process all the items 
        var hasBelowBuyingPrice = false

        salesitemsdetails.find("tbody tr").each(function () {
            const $this = $(this),
                itemcode = $this.attr("data-productid"),
                description = $.trim($this.find(".item-name").text()),
                unitprice = $.trim($this.find("td").eq(5).text()),
                discount = $.trim($this.find("td").eq(4).text()),
                quantity = $.trim($this.find(".qty-val").text()),
                serialno = ""

            if (!validateRowBuyingPrice($this)) {
                hasBelowBuyingPrice = true;
            }

            const uomSelect = $this.find(".uom-select");
            const uom = uomSelect.length > 0 ? uomSelect.val() : $.trim($this.find(".cart-item-uom").text());

            if ($this.attr("data-serializable") == 1) {
                if ($this.attr("data-serial-nos") != "") {
                    itemslist = $this.attr("data-serial-nos").split(",")
                    for (var i = 0; i < itemslist.length; i++) {
                        serialno = itemslist[i]
                        TableData.push({ "itemcode": itemcode, "unitprice": unitprice, "discount": discount, "quantity": quantity, "serialno": serialno, "description": description, "uom": uom })
                    }
                    if (!hasBelowBuyingPrice) $this.removeClass("text-danger")
                } else {
                    $this.addClass("text-danger")
                    missingitems = true
                }
            } else {
                TableData.push({ "itemcode": itemcode, "unitprice": unitprice, "discount": discount, "quantity": quantity, "serialno": "", "description": description, "uom": uom })
            }
        })

        //console.log(missingitems)
        // check blank fields
        if (pointofsale == "") {
            errors = "Please select a <strong>Point of Sale</strong>"
        } else if (customerid == "") {
            errors = "Please select a <strong>Customer</strong>"
        } else if (transactiondate == "") {
            errors = "Please select <strong>Transaction Date</strong>"
        } else if (hasBelowBuyingPrice) {
            errors = "Some products are priced <strong>below their buying price</strong>. Please correct highlighted entries."
        }

        // check whether they are items added on the list

        if (tbody.children().length == 0) {
            errors = "Please add at least an Item in the list"
        } else if (missingitems) {
            errors = "Please provide <strong>Serial Numbers</strong> for all highlighted entries."
        }

        // check if amount paid is sufficient
        amountpaid = computeAmountPaid()
        // compute change
        total = getItemsTotal()
        //console.log(tota)
        changeamount = parseFloat(amountpaid - total)
        if (changeamount < 0) {
            errors = "Sorry, insufficient amount provided"
            paymenterror.html(showAlert("info", errors))
        } else if (sendtovault == 1 && walletid == "") {
            errors = "Please provide wallet id"
            walletidfield.focus()
        } else {
            paymenterror.html("")
        }

        // check if payment methods have been provided and whether reference numbers have been used
        $(".amount").each(function () {
            var paymentmethodid = $(this).attr("id"),
                refno = "#" + paymentmethodid + "_ref"
            referenceno = $(refno).val()
            // check amount
            if ($(this).val() != "") {
                if (paymentmethodid != 1 || paymentmethodid != 4) {
                    $.post(
                        "../controllers/possalesoperations.php",
                        {
                            checkpaymentmodereference: true,
                            modeid: paymentmethodid,
                            referenceno: referenceno
                        },
                        function (data) {
                            str = $.trim(data)
                            if (str == true) {
                                errors = "Invalid reference number"
                            }
                        }
                    )
                }
            }
        })

        if (errors == "") {
            paymenterror.html(showAlert("processing", "Processing. Please wait ...", 1))
            TableData = JSON.stringify(TableData)
            paymentMethods = JSON.stringify(formatPaymentMethods())
            $.post(
                "../controllers/possalesoperations.php",
                {
                    savesale: true,
                    TableData: TableData,
                    customerid: customerid,
                    pointofsale: pointofsale,
                    paymentmethods: paymentMethods,
                    referenceno: referenceno,
                    creditnoteno: creditnotelist.val(),
                    transactiondate,
                    reference,
                    sendtovault,
                    walletid,
                    change: changeamount
                },
                function (data) {
                    // generate receipt
                    try {
                        let response;
                        if (typeof data === 'object') {
                            response = data;
                        } else if (isJSON(data)) {
                            response = JSON.parse(data);
                        }

                        if (response && (response.status == "success" || response.receiptno)) {
                            let str = response.receiptno;
                            let printreceipt = response.printreceipt;

                             if (printreceipt == 1 || printreceiptfield.prop("checked") == true) {
                                 printReceipt(str)
                             }

                            errordiv.html("")
                            paymenterror.html("")
                            clearForm()
                            errors = "Sale finalized successfully! <br/> Receipt Number: <strong>" + str + "</strong>"
                            errordiv.html(showAlert("success", errors))
                            itemcodefield.focus()
                            $("#itemcode").focus()
                            // hide payment details
                            paymentsmodal.modal("hide")
                        } else {
                            paymenterror.html(showAlert("warning", typeof data === 'object' ? JSON.stringify(data) : data.toString()))
                        }

                    } catch (e) {
                        paymenterror.html(showAlert("warning", typeof data === 'object' ? JSON.stringify(data) : data.toString()))
                    }
                    // re-enable save button
                    savebutton.prop("disabled", false)
                }
            )
        } else {
            paymenterror.html(showAlert("info", errors))
            paymentsmodal.modal("show")
            // re-enable save button
            savebutton.prop("disabled", false)
        }
    })

clearbutton.on("click", function () {
    clearForm()
})

function computeCustomerBalance() {
    totalamount = overalltotal.text()
    amountpaid = amountpaidfield.val()
    if (!isNaN(totalamount) && totalamount.length != 0 && !isNaN(totalamount) && amountpaid.length != 0) {
        balance = amountpaid - totalamount
        balancefield.html(balance)
    }
}

creditnotelist.on("change", function () {
    if (creditnotelist.val() != "") {
        $.getJSON(
            "../controllers/creditnoteoperations.php",
            {
                getcreditnotetotal: "post",
                creditnotenumber: creditnotelist.val()
            },
            function (data) {
                creditnotevalue.html(data[0].creditnotetotal)
                computeTotalAmountPaid()
            }
        )
    }
})

function computeAmountPaid() {
    var sum = 0
    $("input.amount").each(function () {
        var value = $(this).val();
        // add only if the value is number
        if (!isNaN(value) && value.length != 0) {
            sum += parseFloat(value);
        }
    })
    return sum;
}

// format payment methods for JSON
function formatPaymentMethods() {
    var i = 0
    var TableData = new Array();

    $('input.amount').each(function () {
        var id = $(this).attr('id'),
            amount = $(this).val()
        referenceno = $("#" + id + "_ref").val()

        if ($(this).hasClass('Cash')) {
            // check if no cash has been provided
            // console.log('Cash reached')
            if ($(this).val() == "") {
                $(this).val(0)
            }

            amountpaid = computeAmountPaid()
            total = getItemsTotal()
            changeamount = parseFloat(amountpaid - total)
            //console.log(changeamount)
            if (parseFloat(changeamount) > 0) {
                amount = amount - changeamount
            }
        }

        TableData[i] = {
            "modeid": id,
            "amount": amount,
            "referenceno": referenceno
        }
        i += 1
    })
    // TableData.shift() 
    // console.log(TableData)
    return TableData
}

salesitemsdetails.on("click", ".addserials", function () {

    var $this = $(this),
        parent = $this.parent("td").parent("tr"),
        quantity = parent.find("td").eq(7).text(),
        productid = parent.attr("data-productid"),
        itemname = parent.find("td").eq(2).text(),
        results = ""
    // hide errors and notification from the main window
    errordiv.html("")

    serialdetailsquanity.val(quantity)
    serialdetailsname.val(itemname)
    serialdetailsid.val(productid)
    serialserrors.html("")
    // check if serial numbers are existing and edit
    existingserialno = parent.attr("data-serial-nos")
    //console.log(existingserialno)
    if (existingserialno != "") {
        serialnos = existingserialno.split(",")
        if (serialnos.length > 0) {
            for (var i = 0; i < serialnos.length; i++) {
                results += `<tr><td>${Number(i + 1)}</td>`
                results += `<td>${serialnos[i]}</td>`
                results += `<td><a href='javascript void(0)' class='deletedata' ><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>` // Delete icon
            }
        } else {
            results += `<tr><td>1</td>`
            results += `<td>${existingserialno}</td>`
            results += `<td><a href='javascript void(0)' class='deletedata' ><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>`
        }
    } else {
        results = ""
    }
    serialnumberslist.html(results)
    // compute summaries list
    computeserialsadded()

    // get existing serial numbers for the item selected that haven't been sold yet
    $.getJSON(
        "../controllers/productoperations.php",
        {
            getexistingproductserialnumbers: true,
            productid
        },
        function (data) {
            var results = "<option value=''>&lt;Choose One&gt;</option>"
            for (var i = 0; i < data.length; i++) {
                results += `<option value='${data[i].serialno}'>${data[i].serialno}</option>`
            }
            serialnumbersdropdownlist.html(results)
        }
    )
    //show the modal
    serialnumbersmodal.modal("show")
})


// add serial numbers to list
addserialnumberstolistbutton.on("click", function () {
    var serialno = serialnumbersdropdownlist.val(),
        results = "",
        message = ""
    rows = serialnumberslist.find("tbody tr").length
    serialserrors.html("")
    if (serialno != "") {
        results = `<tr><td>${Number(rows + 1)}</td>`
        results += `<td>${serialno}</td>`
        // add edit and delete buttons
        //results+=`<td><a href='javascript void(0)' class='editdata'><span><i class='fas fa-edit fa-sm mt-2'></i></span></a></td>` // Edit icon
        results += `<td><a href='javascript void(0)' class='deletedata' ><span><i class='fas fa-trash-alt fa-sm mt-2'></i></span></a></td></tr>` // Delete icon
        $(results).appendTo(serialnumberslist)
        // remove from the drop down list
        $("#serialnumbers option[value='" + serialno + "']").remove()
        message = "The serial number has been added successfully."
        serialserrors.html(showAlert("success", message))
        serialnumbersdropdownlist.val("")
        serialnumbersdropdownlist.focus()
        computeserialsadded()
    } else {
        message = "Please select a serial number from the dropdown list first"
        serialserrors.html(showAlert("info", message))
        serialnumbersdropdownlist.focus()
    }
})

function computeserialsadded() {
    var quantity = Number(serialdetailsquanity.val()),
        added = Number(serialnumberslist.find("tbody tr").length)
    message = ""
    if (added < quantity) {
        message = `<span class='alert alert-info'>${added} of ${quantity} serial numbers added</span>`
    } else if (added == quantity) {
        message = `<span class='alert alert-success'>${added} of ${quantity} serial numbers added</span>`
    } else {
        message = `<span class='alert alert-danger'>${added} of ${quantity} serials numbers added</span>`
    }
    serialstotal.html(message)
}

// listen to edit and delete buttons
serialnumberslist.on("click", ".deletedata", function (e) {
    e.preventDefault()
    serialserrors.html("")
    var $this = $(this),
        parent = $this.parent("td").parent("tr"),
        serialno = parent.find("td:eq(1)").text()
    // confirm dialog
    bootbox.dialog({
        // title: "Confirm Item Removal!",
        message: "Confirm removal of serial number <strong>" + serialno + "</strong> from the list?",
        buttons: {
            success: {
                label: "No, Keep",
                className: "btn-success btn-sm",
                callback: function () {
                    $('.bootbox').modal('hide');
                }
            },
            danger: {
                label: "Yes, Remove",
                className: "btn-danger btn-sm",
                callback: function () {
                    parent.remove()
                    // refresh summary
                    computeserialsadded()
                    $('.bootbox').modal('hide');
                }
            }
        }
    })
})

// update serials button clicked - Populate data-id of row similar to productid here
updateserialsbutton.on("click", function () {
    var id = serialdetailsid.val(),
        serialnos = [],
        quantity = Number(serialdetailsquanity.val()),
        added = Number(serialnumberslist.find("tbody tr").length),
        message = ""

    serialserrors.html(showAlert(""))
    if (added != quantity) {
        message = `${added} of ${quantity} serial numbers added. Correct then try again`
        serialserrors.html(showAlert("info", message))
    } else {
        serialnumberslist.find("tbody tr").each(function () {
            serialnos.push($(this).find("td").eq(1).text())
        })

        // check that the quantity added is the same as the no of serial numbers added

        salesitemsdetails.find("tr").each(function () {
            var $this = $(this)
            if ($this.attr("data-productid") == id) {
                $this.attr("data-serial-nos", serialnos)
                // remove highlight if it was added during validation
                $this.removeClass("text-danger")
                // change the colour of the add serial number button
                $this.find("td").eq(7).find("button").addClass("btn-success")
                $this.find("td").eq(7).find("button").html(`<i class="fas fa-edit fa-sm fa-fw"></i> Edit serial numbers`)
                serialnumbersmodal.modal("hide")
                serialserrors.html("")
            }
        })
    }
})

serialnumbersdropdownlist.on("change", function () {
    serialserrors.html("")
})

// listen to add payments button click
addpayments.on("click", function () {
    //  validate fields
    var pointofsale = poslist.val(),
        customerid = customerlist.val(),
        tbody = $("#salesitemsdetails tbody"),
        errors = "",
        // process all the items 
        missingitems = false,
        hasBelowBuyingPrice = false

    salesitemsdetails.find("tbody tr").each(function () {
        var $this = $(this)

        if (!validateRowBuyingPrice($this)) {
            hasBelowBuyingPrice = true;
        }

        if ($this.attr("data-serializable") == 1) {
            if ($this.attr("data-serial-nos") != "") {
                if (!hasBelowBuyingPrice) $this.removeClass("text-danger")
            } else {
                $this.addClass("text-danger")
                missingitems = true
            }
        }
    })

    // check blank fields
    if (pointofsale == "") {
        errors = "Please select a <strong>Point of Sale</strong>"
    }
    else if (customerid == "") {
        errors = "Please select a <strong>Customer</strong>"
    } else if (hasBelowBuyingPrice) {
        errors = "Some products are priced <strong>below their buying price</strong>. Please correct highlighted entries."
    }

    // check whether they are items added on the list

    if (tbody.children().length == 0) {
        errors = "Please add at least an Item in the list"
        itemcodefield.focus()
    } else if (missingitems) {
        errors = "Please provide <strong>Serial Numbers</strong> for all highlighted entries."
    }

    // check if payment methods have been provided and whether reference numbers have been used
    $(".amount").each(function () {
        var paymentmethodid = $(this).attr("id"),
            refno = "#" + paymentmethodid + "_ref"
        referenceno = $(refno).val()
        // check amount
        if ($(this).val() != "") {
            if (paymentmethodid != 1 || paymentmethodid != 4) {
                $.post(
                    "../controllers/possalesoperations.php",
                    {
                        checkpaymentmodereference: true,
                        modeid: paymentmethodid,
                        referenceno: referenceno
                    },
                    function (data) {
                        str = $.trim(data)
                        if (str == true) {
                            $(this).addClass("is-invalid")
                            errors = "Invalid reference number"
                        } else {
                            $(this).removeClass("is-invalid")
                        }
                    }
                )
            }
        }
    })

    // show payments page if there is no error
    if (errors == "") {
        paymentsmodal.modal("show")

    } else {
        errordiv.html(showAlert("info", errors))
    }
})

// Handle background blurring on modal display
paymentsmodal.on("show.bs.modal", function () {
    $(".home-section, .sidebar").addClass("modal-blur");
});

paymentsmodal.on("hide.bs.modal", function () {
    $(".home-section, .sidebar").removeClass("modal-blur");
});

// Get payments methods and focus on the default one
paymentsmodal.on("shown.bs.modal", function () {
    totalamountpayable.html(overalltotal.html())
    getpaymentmethods().done(function () {
        $('input[data-default="1"]').trigger('focus')
        // Update customer ID display
        $('.customer-id-display').text(customerlist.val() ? '#' + customerlist.val() + '-CUST' : '#---');
    })
})

// Real-time calculation for redesigned modal
$(document).on("keyup change", ".amount", function () {
    const totalPayable = parseFloat(totalamountpayable.text().replace(/,/g, '')) || 0;
    const totalCollected = computeAmountPaid();
    const dueChange = totalCollected - totalPayable;

    totalpaid.text($.number(totalCollected, 2));
    change.text($.number(dueChange, 2));

    const changeCard = $('.summary-card.due');
    if (dueChange >= 0) {
        changeCard.css('background', '#10b981'); // Green for change
        changeCard.find('.label').text('CHANGE');
    } else {
        changeCard.css('background', '#fb7185'); // DESIGN RED for due
        changeCard.find('.label').text('DUE');
    }
});

$(document).on("click", ".paste-total", function () {
    const totalPayable = parseFloat(totalamountpayable.text().replace(/,/g, '')) || 0;
    const $input = $(this).closest(".payment-input-wrapper").find(".amount-input");

    // Calculate remaining amount to reach totalPayable
    let otherPayments = 0;
    $(".amount").not($input).each(function () {
        otherPayments += parseFloat($(this).val()) || 0;
    });

    const remaining = totalPayable - otherPayments;
    $input.val(Math.max(0, remaining).toFixed(0)).trigger("change");
});

// show modal for adding bundle items
addbundleitembutton.on("click", function () {
    // get bundle items
    bundleitemsmodal.find(".modal-body").html(showAlert("processing", "Getting bundle items. Please wait ..."))
    $.getJSON(
        "../controllers/productoperations.php",
        {
            getbundleitems: true
        },
        function (data) {
            var results = "<div class='card containergroup mt-2 mb-2'><!--<div class='card-header'><h5>Privileges</h5></div>--><div class='card-body scrollableprivilege'><table class='table table-sm table-borderless'>"
            //for(var i=0;i<data.length;i++){
            //var results="<div class='card containergroup mt-2 mb-2'><div class='card-header'><h5>Bundle Items</h5></div><div class='card-body scrollableprivilege'><table class='table table-sm table-borderless'>"
            for (var i = 0; i < data.length; i++) {
                results += `<tr data-itemcode='${data[i].itemcode}' data-unitprice="${data[i].sellingprice}" data-itemname="${data[i].itemname}" data-allownegativesales=${data[i].allownegativesales}><td><input type='checkbox' id='${data[i].itemcode}' class='checkoption'>&nbsp;&nbsp;`
                results += data[i].itemname + "</td></tr>"
            }
            results += "</table> </div> </div>"
            bundleitemsmodal.find(".modal-body").html(results)
            //}
        }
    )
    bundleitemsmodal.modal("show")
})

donebundlebuttons.on("click", function () {
    var productdetails = ''
    bundleitemsmodal.find(".checkoption").each(function () {
        var $this = $(this),
            parent = $this.parent("td").parent("tr"),
            randomno = randomId()
        if ($(this).prop("checked")) {
            itemcode = parent.attr("data-itemcode")
            itemname = parent.attr("data-itemname")
            sellingprice = parent.attr("data-unitprice")
            allownegativesales = parent.attr("data-allownegativesales")
            //productid=parent.attr("data-productid")
            // populate the items on the list
            productdetails += `<tr class='clickable-row' data-id='${randomno}' data-productid='0' data-serializable='0' data-serial-nos='' data-allownegativesales='${allownegativesales}'><td>${itemcode}</td>`
            productdetails += `<td>${itemname}</td>`
            productdetails += `<td class='price'>${sellingprice}</td>`
            productdetails += `<td>0</td>`
            productdetails += `<td >${sellingprice}</td>`
            productdetails += `<td class='quantity'>1</td>`
            // Add serial number button if item is serializable
            productdetails += `<td>&nbsp</td>`
            productdetails += `<td class='linetotal'>${sellingprice}</td>`
            productdetails += `<td><a href='javascript void(0)' class='deletedata' data-id='${randomId()}'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>`
        }
    })

    $(productdetails).appendTo(salesitemsdetails.find("tbody"))
    // display overall total
    var total = getItemsTotal()
    overalltotal.html($.number(total, 2))
    totalamountpayable.html($.number(total, 2))
    // compute totals and balance
    computeTotalAmountPaid()
    // hide the modal
    bundleitemsmodal.modal("hide")

})

// show add customer modal
addcustomerbutton.on("click", function () {
    customermodal.modal("show")
})

// save the customer
savecustomerbutton.on("click", function () {
    var categoryid = customercategorylist.val(),
        customername = customernamefield.val(),
        idnumber = idnumberfield.val(),
        pinnumber = pinnumberfield.val(),
        mobile = mobilefield.val(),
        emailaddress = emailaddressfield.val(),
        errors = ""
    // check for blank fields
    if (customername == "") {
        errors = "Please provide the customers name"
        customernamefield.focus()
    } else if (idnumber == "") {
        errors = "Please provide the ID number"
        idnumberfield.focus()
    } else if (pinnumber == "") {
        errors = "Please provide PIN number"
        pinnumberfield.focus()
    } else if (mobile == "") {
        errors = "Please provide Mobile number"
        mobilefield.focus()
    }

    if (errors == "") {
        // save the customer
        $.post(
            "../controllers/customeroperations.php",
            {
                savecustomer: true,
                id: 0,
                customername,
                physicaladdress: "",
                postaladdress: "",
                mobile,
                email: emailaddress,
                creditlimit: 0,
                category: categoryid,
                posid: 0,
                onetimecustomer: 1,
                pinno: pinnumber,
                idno: idnumber
            },
            function (data) {
                data = $.trim(data)
                if (data == "success") {
                    errors = "The customer has been added successfully."
                    // Refresh customers list and selected the last inserted customer
                    getcustomers().done(function () {
                        $.getJSON(
                            "../controllers/customeroperations.php",
                            {
                                getinsertedcustomer: true
                            },
                            function (data) {
                                customerlist.val(data[0].customerid)
                            }
                        )
                    })
                    // select the customer
                    customererrordiv.html(showAlert("success", errors))
                } else if (data == "name exists") {
                    errors = "Sorry, customer's name exists in the system."
                    customernamefield.focus()
                    customererrordiv.html(showAlert("info", errors))
                } else if (data == "id exists") {
                    errors = "Sorry, customer's ID number exists in the system"
                    customererrordiv.html(showAlert("info", errors))
                    idnumberfield.focus()
                } else if (data == "pin exists") {
                    errors = "Sorry, the customer's PIN exists in the system"
                    pinnumberfield.focus()
                    customererrordiv.html(showAlert("info", errors))
                } else {
                    errors = `Sorry an error occured ${data}`
                    customererrordiv.html(showAlert("danger", errors))
                }
            }
        )
    } else {
        // display error message
        customererrordiv.html(showAlert("info", errors))
    }
})

// get a list of all the customers when drop down gets focus
paymentoptions.on("focusin", ".customerslist", function () {
    // get the current selected customer
    // console.log("focusin in")
    let customerid = customerlist.val()
    // console.log(customerid)
    $.getJSON(
        "../controllers/customeroperations.php",
        {
            getcustomers: true,
            regularcustomers: 1,
            onetimecustomers: 0
        },
        function (data) {
            var results = "<option value=''>&lt;Choose One&gt;</option>"
            for (var i = 0; i < data.length; i++) {
                results += `<option value='${data[i].customerid}' ${data[i].customerid == customerid ? 'selected' : ''}>${toTitleCase(data[i].customername)}</option>`
            }
            //console.log(results)
            $(".customerslist").html(results)
        }
    )
})

paymentoptions.on("keypress", ".amount", function (e) {
    var keycode = (e.keyCode ? e.keyCode : e.which),
        errors = ""
    if (keycode == '13' && $(this).attr("id") == 2) {
        //console.log($(this))
        var amount = $(this).val()
        // get the mpesa transaction based on the amount
        $.getJSON(
            "../controllers/possalesoperations.php",
            {
                getmpesatransaction: true,
                amount
            },
            function (data) {
                if (data.length > 0) {
                    // Show dialogue with mpesa payment details
                    var results = `<table class='table table-striped table-sm'><thead><th>&nbsp;</th><th>Name</th><th>Amount</th><th>Reference</th><th>Date</th></thead><tbody>`
                    for (var i = 0; i < data.length; i++) {
                        results += `<tr><td><input type='radio' name="mpesatransaction" id='${data[i].reference}' class='mt-1' value='${data[i].reference}' checked></td>`
                        results += `<td>${data[i].sendername}</td>`
                        results += `<td>${data[i].amount}</td>`
                        results += `<td>${data[i].reference}</td>`
                        results += `<td>${data[i].date}</td></tr>`
                    }
                    results += `</tbody></table>`
                    mpesaconfirmationmodal.find(".modal-body").html(results)
                    // hidepayments modal
                    paymentsmodal.modal("hide")
                    // show mpesa payments modal
                    mpesaconfirmationmodal.modal("show")
                } else {
                    // show dialog that the transaction reference was not found
                    errors = "Sorry, no pending transaction with similar amount found."
                    mpesaconfirmationmodal.find(".modal-body").html(showAlert("info", errors))
                    // hidepayments modal
                    paymentsmodal.modal("hide")
                    // show mpesa payments modal
                    mpesaconfirmationmodal.modal("show")
                }
            }
        )
    }
})

// add mpesa transaction to the list
addmpesatransactionbutton.on("click", function () {
    // find the row with mpesa
    var reference = mpesaconfirmationmodal.find(".modal-body input[name=mpesatransaction]:checked").val(),
        mpesareferencefield = $("#2_ref")
    mpesareferencefield.prop("disabled", true)
    //console.log(mpesareferencefield)
    // show mpesa payments modal
    mpesareferencefield.val(reference)
    paymentsmodal.modal("show")
    mpesaconfirmationmodal.modal("hide")
})



// hold a sale
holdsale.on("click", function () {
    var TableData,
        pointofsale = poslist.val(),
        customerid = customerlist.val(),
        paymentmethod = paymentmethodslist.val(),
        referenceno = referencenofield.val()
    amount = amountpaidfield.val()
    errors = ""
    // check blank fields
    if (pointofsale == "") {
        errors = "Please select a <strong>Point of Sale</strong>"
    }
    else if (customerid == "") {
        errors = "Please select a <strong>Customer</strong>"
    }
    else if (paymentmethod == "") {
        errors = "Please select a <strong>Payment Method</strong>"
    } else {
        if (paymentmethodslist.find('option:selected').text() != "Cash") {
            if (referenceno == "") {
                errors = "Please provide " + paymentmethodslist.find('option:selected').text() + " <strong>Reference Number</strong>"
            }
        }
    }

    if (errors == "") {
        TableData = [];
        salesitemsdetails.find("tbody tr").each(function () {
            var $this = $(this),
                itemcode = $.trim($this.find("td").eq(0).text()),
                description = $.trim($this.find(".item-name").text()),
                unitprice = $.trim($this.find("td").eq(5).text()),
                discount = $.trim($this.find("td").eq(4).text()),
                quantity = $.trim($this.find(".qty-val").text()),
                serialno = ""

            const uomSelect = $this.find(".uom-select");
            const uom = uomSelect.length > 0 ? uomSelect.val() : $.trim($this.find(".cart-item-uom").text());

            if ($this.attr("data-serializable") == 1) {
                if ($this.attr("data-serial-nos") != "") {
                    itemslist = $this.attr("data-serial-nos").split(",")
                    for (var i = 0; i < itemslist.length; i++) {
                        serialno = itemslist[i]
                        TableData.push({ "itemcode": itemcode, "description": description, "unitprice": unitprice, "discount": discount, "quantity": quantity, "serialno": serialno, "uom": uom })
                    }
                }
            } else {
                TableData.push({ "itemcode": itemcode, "description": description, "unitprice": unitprice, "discount": discount, "quantity": quantity, "serialno": "", "uom": uom })
            }
        })
        // check that at least an item has been added to the list
        if (TableData.length > 0) {
            TableData = JSON.stringify(TableData)
            $.post(
                "../controllers/possalesoperations.php",
                {
                    holdsale: "POST",
                    TableData: TableData,
                    customerid: customerid,
                    pointofsale: pointofsale,
                },
                function (data) {
                    // generate receipt
                    str = $.trim(data.toString())
                    if (str == "Sale has been held succesfully") {
                        clearForm()
                        errordiv.html(showAlert("success", str))
                        //errors="<p class='alert alert-success'><i class='fas fa-check-circle fa-lg fa-fw'></i></span> "+str+"</p>"
                    } else {
                        errordiv.html(showAlert("danger", str))
                        //errors="<p  class='alert alert-danger'><i class='fas fa-times-circle fa-lg fa-fw'></i></span> "+str+"</p>"
                    }
                }
            )
        } else {
            errordiv.html(showAlert("info", "Please add at least an item in the list first"))
        }
    } else {
        errordiv.html(showAlert("info", errors))
    }
})

retrieveheldsale.on("click", function () {
    errordiv.html("")
    $.getJSON(
        "../controllers/possalesoperations.php",
        {
            getheldsales: "true"
        },
        function (data) {
            var results = "<table class='table table-striped table-sm'>"
            results += "<thead><tr><th>Date</th>"
            results += "<th>Customer</th>"
            results += "<th>POS</th>"
            results += "<th>&nbsp;</th></tr></thead><tbody>"
            console.log(data.length)
            if (data.length == 0) {
                results += "<tr><td colspan='4'> Currently no held sales found on your user account.</td></tr>"
            } else {
                for (var i = 0; i < data.length; i++) {
                    results += "<tr><td>" + data[i].dateheld + "</td>"
                    results += "<td>" + data[i].customername + "</td>"
                    results += "<td>" + data[i].posname + "</td>"
                    results += "<td><a href='javascript void(0)' data-dismiss='modal' class='usedata' data-id='" + data[i].id + "'><span><i class='fas fa-plus-circle fa-lg mt-1'></i></span></a></td></tr>"
                }
            }

            results += "</tbody></table>"
            heldsaleslist.find(".modal-body").html(results)
            //console.log(results)
            heldsalesmodal.modal("show")
            // display the modal
        }
    )
})

//listen to retrieve item selection
heldsaleslist.on("click", ".usedata", function (e) {
    e.preventDefault()
    errordiv.html("")
    var id = $(this).attr('data-id')
    // get held sales
    getHeldSaleHeader(id).done(
        getHeldSalesDetails(id).done(function () {
            // delete the held sale
            $.post(
                "../controllers/possalesoperations.php",
                {
                    deleteheldsale: true,
                    id: id
                },
                function (data) {
                    str = $.trim(data.toString())
                    //console.log(str)
                }
            )
        })
    )
    // get held sales details
})

function getHeldSaleHeader(id) {
    var dfd = new $.Deferred()
    $.getJSON(
        "../controllers/possalesoperations.php",
        {
            id: id,
            getheldsaleheader: true
        },
        function (data) {
            poslist.val(data[0].posid)
            customerlist.val(data[0].customerid)
            dfd.resolve()
        }
    )
    return dfd.promise()
}

function getHeldSalesDetails(id) {
    var dfd = new $.Deferred()
    $.getJSON(
        "../controllers/possalesoperations.php",
        {
            id: id,
            getheldsaledetails: true
        },
        function (data) {
            var results = ""
            for (var i = 0; i < data.length; i++) {
                results += `<tr class='clickable-row'><td>${data[i].itemcode}</td>`
                results += `<td>${data[i].itemname}</td>`
                // results+="<td>"+data[i].description+"</td>"
                results += `<td>${Number(data[i].unitprice) + Number(data[i].discount)}</td>`
                results += `<td>${data[i].discount}</td>`
                results += `<td>${data[i].unitprice}</td>`
                results += `<td>${data[i].itembalance}</td>`
                results += `<td class='quantity'>${data[i].quantity}</td>`
                results += `<td>&nbsp;</td>`
                // results+="<td>"+data[i].serialno+"</td>"
                results += `<td class='linetotal'>${Number(data[i].quantity * data[i].unitprice)}</td>`
                results += `<td><a href='javascript void(0)' class='deletedata' data-id='${randomId()}'><span><i class='fas fa-trash-alt fa-sm'></i></span></a></td></tr>`
            }
            salesitemsdetails.find("tbody").html(results)
            // display overall total
            var total = getItemsTotal()
            overalltotal.html($.number(total, 2))
            totalamountpayable.html($.number(total, 2))
            // compute totals and balance
            computeTotalAmountPaid()
            dfd.resolve()
        }
    )
    return dfd.promise()
}

paymentoptions.on("keyup", ".amount", function () {
    amountpaid = computeAmountPaid()
    totalpaid.html($.number(amountpaid, 2))
    // compute change
    total = getItemsTotal()
    //console.log(tota)
    changeamount = parseFloat(amountpaid - total)
    //console.log(changeamount)
    change.html($.number(changeamount, 2))
    paymenterror.html("")
    errordiv.html("")
})

function clearForm() {
    // clear selects and input fields
    // $("select").val("")
    $('input[type="text"]').val("")
    // clear table entries
    $('#salesitemsdetails').find("tbody").html("")
    //clear total and balance
    // balancefield.text("0.00")
    overalltotal.html("0.00")
    $('.amount').val("")
    $(".reference").val("")
    totalpaid.html("0.00")
    change.html("0.00")
    totalamountpayable.html("0.00")
    //creditnotevalue.html("0.00")
    // paymentmodevalue.html("0.00")
    //totalpayments.html("0.00")
    transactiondatefield.val(todaysDate())
    $("#itemcode").focus()
}

itemcodefield.keypress(function (event) {
    const keycode = (event.keyCode ? event.keyCode : event.which),
        posid = poslist.val()
    let errors = ""

    if (posid == "") {
        errors = "Please select outlet first"
        errordiv.html(showAlert("info", errors))
        poslist.val("").focus()
    } else if (keycode == '13') {
        clearTimeout(searchTimeout); // Cancel pending name search to avoid flickering results
        const productcode = $(this).val().trim()
        if (productcode !== "") {
            if (customerlist.val() == "") {
                errors = "Please select a customer first"
                errordiv.html(showAlert("info", errors))
            } else if (poslist.val() == "") {
                errors = "Please select an outlet / POS first"
                errordiv.html(showAlert("info", errors))
            } else {
                errordiv.html("")
                getproduct(productcode)
                itemcodefield.val("").focus()
            }
        }
    }
})

// itemcodefield.on("keyup",function(){
//     const name=itemcodefield.val(),
//         posid=poslist.val()
//     if(name.length>2){
//         $.getJSON(    
//             "../controllers/productoperations.php",
//             {
//                 filterproductbyname:1,
//                 name:name,
//                 posid
//             },
//             function(data){
//                 let results="<ul class='searchresults'>"
//                 searchresults.html("")
//                 if(data.length>0){
//                     for(i=0;i<data.length;i++){
//                         results+="<li id='"+data[i].itemcode+"'>"+data[i].itemname+"</li>"
//                     }
//                     results+="</ul>"
//                     // console.log(results)
//                     $(results).appendTo(searchresults)
//                     searchresults.show()
//                     // searchresults.addClass("mt-5")
//                 } 
//             }
//         )
//     }
// })

// listen to the click event of search term when clicked
searchresults.on("click", "li", function () {
    var itemcode = ''
    itemcode = $(this).attr("id")
    itemcodefield.val(itemcode)

    if (customerlist.val() == "") {
        errors = "Please select a customer first"
        errordiv.html(showAlert("info", errors))
        customerlist.focus()
    } else if (poslist.val == "") {
        errors = "Please select an Outlet / POS first"
        errordiv.html(showAlert("info", errors))
        poslist.focus()
    } else {
        getproduct(itemcode)
        itemcodefield.val("")
        itemcodefield.focus()
    }
    searchresults.hide()
})

// listen to change quantity
salesitemsdetails.on("click", ".qty-val", function (e) {
    errordiv.html("")
    const $qtyVal = $(this),
        parent = $qtyVal.closest("tr"),
        allownegativesales = parent.data("allownegativesales")

    const isSoldByValue = parent.attr("data-saleby") === "value";
    if (isSoldByValue) {
        const $priceVal = parent.find(".price-val");
        $priceVal.attr("contenteditable", "true");
        $priceVal.focus();
        document.execCommand('selectAll', false, null);
        return;
    }

    bootbox.prompt({
        title: "Enter New Quantity",
        size: 'small',
        message: "Enter quantity required",
        inputType: 'number',
        callback: function (result) {
            if (Number(result) > 0) {
                const unitprice = parent.find("td").eq(5).text(),
                    linetotal = Number(result * unitprice),
                    stockquantity = Number(parent.find("td").eq(6).text())
                if (stockquantity >= Number(result) || Number(allownegativesales) == 1 || window.allownegativesalesglobally) {
                    $qtyVal.text(result)
                    parent.find("td").eq(9).text(linetotal)
                    overalltotal.html($.number(getItemsTotal(), 2))
                    totalamountpayable.html($.number(getItemsTotal(), 2))
                    computeTotalAmountPaid()
                } else {
                    errors = "Quantity to be sold exceeds stock quantity"
                    errordiv.html(showAlert("danger", errors))
                }
            }
        }
    })
})

// listen to price click for sold by value items
salesitemsdetails.on("click", ".price-val", function (e) {
    errordiv.html("")
    const $cell = $(this);
    if ($cell.attr("contenteditable") !== "true") {
        $cell.attr("contenteditable", "true");
        $cell.focus();
        
        // Select all text in contenteditable cell
        document.execCommand('selectAll', false, null);
    }
});

// listen for contenteditable editing events on .price-val (sold by value)
salesitemsdetails.on("focusout keydown input", ".price-val", function (e) {
    const $cell = $(this);
    const $row = $cell.closest("tr");
    
    if (e.type === "keydown") {
        if (e.key === "Enter") {
            e.preventDefault();
            $cell.blur();
        }
        return;
    }
    
    // Extract the entered value/price
    let rawVal = $cell.text().replace(/,/g, '').trim();
    let newPrice = parseFloat(rawVal) || 0;
    
    const basePrice = parseFloat($row.attr("data-baseprice")) || 0;
    if (basePrice <= 0) return;
    
    // Calculate new quantity: newPrice / basePrice
    const newQty = newPrice / basePrice;
    
    // Update the quantity display
    $row.find(".linetotal-qty").text(newQty.toFixed(2));
    
    // Update the linetotal (index 9)
    $row.find(".linetotal").text($.number(newPrice, 2));
    
    // Validate buying price floor and highlight if below
    validateRowBuyingPrice($row);
    
    // Update overall cart totals
    const total = getItemsTotal();
    overalltotal.html($.number(total, 2));
    totalamountpayable.html($.number(total, 2));
    computeTotalAmountPaid();

    // If the active element is NOT this cell anymore (on focusout), format the price value nicely
    if (e.type === "focusout") {
        $cell.removeAttr("contenteditable");
        $cell.text(newPrice.toFixed(2));
    }
});

// listen to unit price amount or line total column clicks
salesitemsdetails.on("click", ".price, .linetotal", function (e) {
    errordiv.html("")
    const isTouchscreenV2 = window.location.pathname.includes('touchscreensale_v2');
    
    console.log("--- Price Click Triggered ---");
    console.log("isTouchscreenV2:", isTouchscreenV2);
    console.log("changeprices flag:", changeprices);
    console.log("window.allowpricechange:", window.allowpricechange);
    console.log("window.allow_price_change:", window.allow_price_change);
    console.log("Selected Row for editing:", $(this).closest("tr"));

    const $cell = $(this);
    const $row = $cell.closest("tr");
    const isSoldByValue = $row.attr("data-saleby") === "value";
    if (isSoldByValue) {
        return;
    }

    if (changeprices || (isTouchscreenV2 && window.allowpricechange) || (isTouchscreenV2 && window.allow_price_change)) {
        if ($cell.attr("contenteditable") !== "true") {
            const currentUnitPrice = parseFloat($row.find("td").eq(5).text()) || 0;
            
            // If they click on .linetotal, show the raw unit price inside it temporarily for editing
            if ($cell.hasClass("linetotal")) {
                $cell.text(currentUnitPrice);
            }
            
            $cell.attr("contenteditable", "true");
            $cell.focus();
            
            // Select all text in contenteditable cell
            document.execCommand('selectAll', false, null);
        }
    }
});

// listen for contenteditable editing events on .price and .linetotal columns
salesitemsdetails.on("focusout keydown input", ".price, .linetotal", function (e) {
    const $cell = $(this);
    const $row = $cell.closest("tr");
    const isSoldByValue = $row.attr("data-saleby") === "value";
    if (isSoldByValue) {
        return;
    }
    
    if (e.type === "keydown") {
        if (e.key === "Enter") {
            e.preventDefault();
            $cell.blur();
        }
        return;
    }
    
    // Extract the entered price
    let rawVal = $cell.text().replace(/,/g, '').trim();
    let newUnitPrice = parseFloat(rawVal) || 0;
    
    // Update unitprice column (td index 5) and price column (td index 3)
    $row.find("td").eq(3).text(newUnitPrice);
    $row.find("td").eq(5).text(newUnitPrice);
    
    // Recalculate extended total (linetotal)
    const quantity = parseFloat($row.find(".qty-val").text()) || 0;
    const linetotal = newUnitPrice * quantity;
    
    // If the active element is NOT this cell anymore (on focusout), format the linetotal back nicely
    if (e.type === "focusout") {
        $cell.removeAttr("contenteditable");
        $row.find("td").eq(3).text(newUnitPrice.toFixed(2));
        $row.find("td").eq(5).text(newUnitPrice.toFixed(2));
        $row.find(".linetotal").text($.number(linetotal, 2));
    } else {
        // During input editing, update the other cell if we are editing .price
        if ($cell.hasClass("price")) {
            $row.find(".linetotal").text($.number(linetotal, 2));
        }
    }
    
    // Validate buying price floor and highlight if below
    validateRowBuyingPrice($row);
    
    // Update overall cart totals
    overalltotal.html($.number(getItemsTotal(), 2));
    totalamountpayable.html($.number(getItemsTotal(), 2));
    computeTotalAmountPaid();
});

const touchscreendisplay = $("#touchscreendisplay")
const touchscreenui = $("#touchscreenui")
const buttonslist = $("#buttonslist")

touchscreendisplay.on("click", function () {
    $this = $(this)
    const icon = $this.find("i")
    if ($this.hasClass('btn-outline-danger')) {
        touchscreenui.hide()
    } else {
        touchscreenui.show()
    }
    // replace icon
    icon.toggleClass('fa-eye')
    icon.toggleClass('fa-eye-slash')
    // repolace class
    $this.toggleClass('btn-outline-danger')
    $this.toggleClass('btn-outline-success')
    // toggle half screen collumn for buttonslist
    buttonslist.toggleClass("col-md-6")
})

touchscreendisplay.trigger("click")

// get a list of all the customers when drop down gets focus
paymentoptions.on("focusin", ".customerslist", function () {
    // get the current selected customer
    var customerid = customerlist.val()
    // console.log(customerid)
    $.getJSON(
        "../controllers/customeroperations.php",
        {
            getcustomers: true,
            regularcustomers: 1,
            onetimecustomers: 0
        },
        function (data) {
            var results = "<option value=''>&lt;Choose One&gt;</option>"
            for (var i = 0; i < data.length; i++) {
                results += `<option value='${data[i].customerid}' ${data[i].customerid == customerid ? 'selected' : ''}>${toTitleCase(data[i].customername)}</option>`
            }
            //console.log(results)
            $(".customerslist").html(results)
        }
    )
})

// add description
salesitemsdetails.on("click", ".description", function () {
    $this = $(this)
    bootbox.prompt({
        title: 'Provide description',
        centerVertical: true,
        size: "small",
        buttons: {
            confirm: {
                label: 'Add Description',
                className: 'btn-success btn-sm pull-left'
            },
            cancel: {
                label: 'Cancel',
                className: 'btn-outline-danger btn-sm pull-right'
            }
        },
        callback: function (result) {
            console.log(result)
            if (result) {
                $this.text(result)
            }
        }
    });
})

const printersettingsbutton = $("#printersettings"),
    printersettingsmodal = $("#printersettingsmodal"),
    deviceidcontrol = $("#deviceid"),
    printerconnectioncontrol = $("#printerconnection"),
    printernamecontrol = $("#printername"),
    saveprinterconfigbutton = $("#saveprinterconfig"),
    printernotifications = $("#printernotifications"),
    testprinterbutton = $("#testprinter")

let deviceID, settings

deviceID = getOrCreateDeviceID()
settings = loadSettings(deviceID)

if (settings) {
    printerconnectioncontrol.val(settings[0].connection)
    printername = settings[0].name
    printernamecontrol.html(`<option='${settings[0].name}'>${settings[0].name}</option>`)
}

printersettingsbutton.on("click", () => {
    getsystemprinters().done(() => {
        deviceID = getOrCreateDeviceID()
        settings = loadSettings(deviceID)

        deviceidcontrol.val(deviceID)
        if (settings) {
            // console.log('Loaded settings:', settings);
            // Apply settings to the application
            printerconnectioncontrol.val(settings[0].connection)
            printernamecontrol.val(settings[0].name)
            testprinterbutton.prop("disabled", false)
        } else {
            // deviceidcontrol.val("Device ID not configured")
            errordiv.html(showAlert("info", `Receipt printer not yet configured. Please complete this process first`, 1))
            printerconnectioncontrol.val("")
            printernamecontrol.val("")
            testprinterbutton.prop("disabled", true)
        }
        printersettingsmodal.modal('show')
    })

})

//  load printers installed on the system
function getsystemprinters() {
    let dfd = $.Deferred();
    connecttoprinter().then(() => {
        qz.printers.find().then((printers) => {
            let results = printers.map(printer => `<option value='${printer}'>${printer}</option>`).join('');
            printernamecontrol.html(results);
            dfd.resolve();
        }).catch(err => {
            console.error("Error fetching printers:", err);
            dfd.reject(err)
        })
    })

    return dfd.promise();
}

saveprinterconfigbutton.on("click", function () {
    const printersettings = [],
        connection = printerconnectioncontrol.val(),
        selectedPrinterName = printernamecontrol.val()

    let errors = ""

    if (connection == "" || connection == undefined) {
        errors = "Please select printer connection mode"
        printerconnectioncontrol.focus()
    } else if (selectedPrinterName == "" || selectedPrinterName == undefined) {
        errors = "Please select printer name"
        printernamecontrol.focus()
    }

    if (errors == "") {
        printernotifications.html(showAlert("processing", "Processing. Please wait ...", 1))
        printername = selectedPrinterName; // Update global variable in functions.js in memory
        printersettings.push({ "connection": connection, "name": selectedPrinterName })
        saveSettings(deviceID, printersettings)
        printernotifications.html(showAlert("success", `Printer configuration saved successfully`))
        testprinterbutton.prop("disabled", false)
    } else {
        printernotifications.html(showAlert("info", errors))
    }
})

printernamecontrol.on("change", function() {
    if ($(this).val()) {
        testprinterbutton.prop("disabled", false);
    } else {
        testprinterbutton.prop("disabled", true);
    }
});

testprinterbutton.on("click", function () {
    const selectedPrinter = printernamecontrol.val();
    if (!selectedPrinter) {
        printernotifications.html(showAlert("danger", "Please select a printer to test first", 1));
        return;
    }
    
    printernotifications.html(showAlert("processing", "Sending test page to printer...", 1));
    
    connecttoprinter().then(async () => {
        try {
            // Find the selected printer and create its config dynamically
            const printer = await qz.printers.find(selectedPrinter);
            const testConfig = qz.configs.create(printer);
            
            // Build the test print data using the exact same ESC/POS encoder principle
            const encoder = new ESCPOSEncoder();
            const data = encoder
                .initialize()
                .align('center')
                .feed(1)
                .text("================================")
                .feed()
                .text("      PRINTER TEST PAGE         ")
                .feed()
                .text("================================")
                .feed()
                .align('left')
                .text("Printer Connection: Successful")
                .feed()
                .text("Selected Printer: " + selectedPrinter)
                .feed()
                .text("Timestamp: " + new Date().toLocaleString())
                .feed()
                .line("-")
                .feed()
                .text("UPPERCASE LETTERS:")
                .feed()
                .text("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
                .feed(1)
                .text("lowercase letters:")
                .feed()
                .text("abcdefghijklmnopqrstuvwxyz")
                .feed(1)
                .text("NUMBERS:")
                .feed()
                .text("0123456789")
                .feed(1)
                .text("SPECIAL CHARACTERS:")
                .feed()
                .text("!@#$%^&*()_+-=[]{}|;':\",./<>?")
                .feed(1)
                .line("-")
                .feed()
                .align('center')
                .text("SAMPLE BARCODE:")
                .feed()
                .barcode("TEST123456")
                .feed(2)
                .text("Thank you for using our POS!")
                .feed(2)
                .cut()
                .encode();
                
            await qz.print(testConfig, data);
            printernotifications.html(showAlert("success", "Test print sent successfully!", 1));
        } catch (err) {
            console.error("Test print failed:", err);
            printernotifications.html(showAlert("danger", "Test print failed: " + (err.message || err), 1));
        }
    }).catch(err => {
        console.error("Failed to connect to printer:", err);
        printernotifications.html(showAlert("danger", "Failed to connect to printer: " + (err.message || err), 1));
    });
});

async function getReceiptData(url, receiptno) {
    const operations = [
        fetchData(url, { getreceiptheader: true }),
        fetchData(url, { getreceiptdetails: true, receiptno: receiptno }),
        fetchData(url, { getreceiptpaymentmethods: true, receiptno: receiptno }),
        fetchData(url, { getreceiptvatanalysis: true, receiptno: receiptno }),
    ];

    // Wait for all promises to resolve
    const [receiptHeader, receiptDetails, paymentMethods, vatAnalysis] = await Promise.all(operations);

    // Return an object containing the variables
    return { receiptHeader, receiptDetails, paymentMethods, vatAnalysis };
}

function printReceipt(receiptno) {
    if (printreceiptfield.prop("checked") == true) {
        connecttoprinter().then(() => {
            const encoder = new ESCPOSEncoder();
            getReceiptData('../controllers/possalesoperations.php', receiptno)
                .then(({ receiptHeader, receiptDetails, paymentMethods, vatAnalysis }) => {

                    const header = receiptHeader[0],
                        receiptheader = receiptDetails[0],
                        solditems = [],
                        paymentmodes = [],
                        vatanalysis = [],
                        receiptfooter = (header.receiptfooter).split("<br>")

                    // Helper to format: dd-mmm-yyyy hh:mm AM/PM (e.g. 25-May-2026 02:13 PM)
                    const formatReceiptDateTime = (dateStr) => {
                        if (!dateStr) return '';
                        const parts = dateStr.split(' ');
                        if (parts.length >= 2) {
                            const datePart = parts[0];
                            const timeParts = parts[1].split(':');
                            if (timeParts.length >= 2) {
                                let hours = parseInt(timeParts[0], 10);
                                const minutes = timeParts[1];
                                const ampm = hours >= 12 ? 'PM' : 'AM';
                                hours = hours % 12;
                                hours = hours ? hours : 12;
                                return `${datePart} ${String(hours).padStart(2, '0')}:${minutes} ${ampm}`;
                            }
                        }
                        return dateStr;
                    };

                    const formattedDate = formatReceiptDateTime(receiptheader.receiptdate);

                    let receipttotal = 0
                    // populate sold items
                    receiptDetails.forEach((item, i) => {
                        const uomStr = item.uom ? ` ${item.uom}` : '';
                        solditems.push([`${i + 1}. ${item.itemcode}`, ($.number(item.quantity * (item.unitprice - item.discount))).toString()])
                        solditems.push([item.itemname, `${item.quantity}${uomStr} x ${$.number(item.unitprice - item.discount).toString()}`])
                        receipttotal += item.quantity * (item.unitprice - item.discount)
                    })

                    paymentMethods.forEach((paymentmode) => {
                        paymentmodes.push([paymentmode.paymentmethod, paymentmode.reference, $.number(paymentmode.amount).toString()])
                    })

                    vatAnalysis.forEach((vat) => {
                        const taxRateLabel = parseFloat(vat.taxrate) + "%";
                        vatanalysis.push([vat.abbreviation, taxRateLabel, $.number(vat.vat, 2)])
                    })

                    receipttotal = $.number(receipttotal, 2).toString()

                    const data = encoder
                        .initialize()
                        .align('center')
                        .text(header.name)
                        .feed()
                        .text(header.physicaladdress)
                        .feed()
                        .text('P.O BOX ' + header.postaladdress)
                        .feed()
                        .text('TEL: ' + header.landline)
                        .feed()
                        .text('Email: ' + header.email)
                        .feed()
                        .text('PIN: ' + header.pinno)
                        .feed()
                        .text('OFFICIAL RECEIPT')
                        .feed()
                        .barcode(receiptno)
                        .feed()
                        .align('left')
                        .text('Date: ' + formattedDate)
                        .feed()
                        .text('Outlet: ' + receiptheader.posname)
                        .feed()
                        .text('Customer: ' + receiptheader.customername)
                        .feed()
                        .line("-")
                        .align('left') // Align table to the left
                        .tableRow(['ITEM', 'TOTAL'], ['left', 'right']) // Header
                        .line("-")
                        .tableRows(solditems, ['left', 'right'])
                        .line("-")
                        .tableRow(['TOTAL', receipttotal], ['left', 'right']) // Row 3
                        .line("=")
                        .feed()
                        .text("PAYMENT METHODS")
                        .feed()
                        .line("-")
                        .tableRow(['MODE', 'REF #', 'AMOUNT'], ['left', 'left', 'right'])
                        .line("-")
                        .tableRows(paymentmodes, ['left', 'left', 'right'])
                        .line("-")
                        .feed()
                        .text("VAT ANALYSIS")
                        .feed()
                        .line("-")
                        .tableRow(['CODE', 'RATE', 'AMOUNT'], ['left', 'right', 'right'])
                        .line("-")
                        .tableRows(vatanalysis, ['left', 'right', 'right'])
                        .line("-")
                        .align('left')
                        .multiplelines(receiptfooter)
                        .line("-")
                        .text('Served By: ' + receiptheader.servedby)
                        .newline(2)
                        .cut()
                        .encode()
                    qz.print(config, data);
                })
                .catch(error => {
                    console.error('Error fetching receipt data:', error);
                });
        })
    }
}

const switchtorestaurantbutton = $("#switchtorestaurant")
switchtorestaurantbutton.on("click", () => {
    window.location.href = "customerorders.php"
})

searchproductbutton.on("click", () => {
    const productname = sanitizestring(itemcodefield.val()),
        posid = poslist.val()
    errordiv.html(showAlert("processing", "Processing. Please wait ...", 1))
    if (posid !== "") {
        $.getJSON(
            "../controllers/productoperations.php",
            {
                filterproductbyname: 1,
                name: productname,
                posid
            },
            function (data) {
                let results = ""
                searchproductslist.html("")
                if (data.length > 0) {
                    data.forEach((product) => {
                        results += `<li class='searchproduct-card' data-itemcode=${product.itemcode}>
                                <div class="searchproduct-info">
                                    <div class="searchproduct-category">${product.categoryname}</div>
                                    <div class="searchproduct-name">${product.itemname}</div>
                                </div>
                                <div class="searchproduct-price">${$.number(product.sellingprice, 2)}</div>
                            </li>`
                    })
                    // console.log(results)
                    searchproductslist.html(results)
                    searchresultslist.show()
                    errordiv.html("")
                } else {
                    searchresultslist.hide()
                    errordiv.html("")
                }
            }
        )
    } else {
        errordiv.html(showAlert("info", `Please select <strong>Outlet</strong> first`))
        poslist.focus()
    }
})

let searchTimeout = null;
itemcodefield.on("input", function (e) {
    const query = $(this).val()
    clearTimeout(searchTimeout);

    // Immediately clear previous search results on typing
    if (query.length > 0) {
        products.html("");
        searchresultslist.hide();
        searchproductslist.html("");
        errordiv.html("");
    }

    if (query.length >= 2) {
        searchTimeout = setTimeout(function () {
            // Select ALL category button visually
            categories.find('button').removeClass('active');
            categories.find('button[data-id="all"]').addClass('active');

            // Filter products in the main grid using the design-accurate cards
            $.getJSON(
                "../controllers/productoperations.php",
                {
                    filterproductbyname: 1,
                    name: query,
                    posid: poslist.val()
                },
                function (data) {
                    let results = ""
                    if (data.length > 0) {
                        data.forEach((product) => {
                            results += renderProductCard(product);
                        })
                        products.html(results)
                        errordiv.html(""); // Clear any previous alerts
                    } else {
                        errordiv.html(showAlert("info", 'No products found matching "' + query + '"'));
                    }
                    searchresultslist.hide() // Ensure dropdown is hidden
                }
            )
        }, 1000);
    } else if (query.length === 0) {
        // Reset to "ALL" category view
        categories.find('button[data-id="all"]').trigger('click');
    }
})

searchproductslist.on("click", "li", function () {
    const itemcode = $(this).data("itemcode")
    getproduct(itemcode)
    searchresultslist.hide()
    itemcodefield.val("").focus()
})

// Listen to Key combination press
$(document).on('keydown', function (e) {
    // Check if Ctrl + P is pressed
    // e.ctrlKey && e.key.toLowerCase() === 'p'
    if (e.key === 'F3' || e.keyCode === 114) {
        e.preventDefault() // Prevent the print dialog
        addpayments.trigger("click")
    } else if (e.key === 'F4' || e.keyCode === 115) {
        e.preventDefault()
        savebutton.trigger("click")
    }
})

function validateRowBuyingPrice($row) {
    const isTouchscreenV2 = window.location.pathname.includes('touchscreensale_v2');
    if (!isTouchscreenV2) return true;

    const buyingPrice = parseFloat($row.attr("data-buyingprice")) || 0;
    const priceText = $row.find("td").eq(5).text() || $row.find(".price").text() || "0";
    const currentPrice = parseFloat(priceText.replace(/,/g, '').trim()) || 0;

    if (currentPrice < buyingPrice) {
        $row.addClass("text-danger font-weight-bold").css("background-color", "#fef2f2");
        $row.find("td").addClass("text-danger");
        return false;
    } else {
        $row.removeClass("text-danger font-weight-bold").css("background-color", "");
        $row.find("td").removeClass("text-danger");
        return true;
    }
}

function updateValueSoldProduct($row, newPrice) {
    const basePrice = parseFloat($row.attr("data-baseprice")) || 0;
    if (basePrice <= 0) return;
    
    // Calculate new quantity: newPrice / basePrice
    const newQty = newPrice / basePrice;
    
    // Update the price display inside the price pill
    $row.find(".price-val").text(newPrice.toFixed(2));
    
    // Update the quantity display
    $row.find(".linetotal-qty").text(newQty.toFixed(2));
    
    // Update the linetotal (index 9)
    $row.find(".linetotal").text($.number(newPrice, 2));
    
    // Validate buying price floor and highlight if below
    validateRowBuyingPrice($row);
    
    // Update overall cart totals
    const total = getItemsTotal();
    overalltotal.html($.number(total, 2));
    totalamountpayable.html($.number(total, 2));
    computeTotalAmountPaid();
}

})

