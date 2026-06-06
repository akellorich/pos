$(document).ready(function(){
    // Element Selectors
    const masterSearch = $("#master-search"),
        customerListBox = $("#customer-list-box"),
        cbRegular = $("#cb-regular"),
        cbOneTime = $("#cb-onetime"),
        detailsView = $("#details-view");

    let allCustomers = [];
    let selectedCustomerId = null;

    // Tab Navigation Logic
    $(".mgmt-tab").on("click", function() {
        const tabId = $(this).data("tab");
        
        // Update Tabs
        $(".mgmt-tab").removeClass("active");
        $(this).addClass("active");
        
        // Update Panes
        $(".tab-pane").addClass("d-none");
        $(`#pane-${tabId}`).removeClass("d-none");

        // Toggle Save Button & Sticky Footer Visibility
        if (tabId === 'biodata') {
            $("#btn-save-customer").css("visibility", "visible");
            $(".mobile-sticky-footer").show();
        } else {
            $("#btn-save-customer").css("visibility", "hidden");
            $(".mobile-sticky-footer").hide();
        }
    });

    // Save Customer Click Handler (Unified for Desktop and Mobile)
    $(document).on("click", "#btn-save-customer, #btn-save-customer-mobile", function() {
        const id = $("#customer-id-val").val() || 0,
            customername = $.trim($("#customer-name").val()),
            tradingname = $.trim($("#customer-trading-name").val()),
            idno = $.trim($("#customer-id-no").val()),
            pinno = $.trim($("#customer-pin-no").val()),
            physicaladdress = $.trim($("#customer-physical-address").val()),
            postaladdress = $.trim($("#customer-postal-address").val()),
            mobile = $.trim($("#customer-mobile").val()),
            email = $.trim($("#customer-email").val()),
            category = $("#sel-category").val(),
            posid = $("#sel-outlet").val(),
            onetimecustomer = $("#customer-onetime").is(":checked") ? 1 : 0,
            subzoneid = $("#sel-subzone").val() || "",
            creditlimit = $.trim($("#customer-credit-limit").val()).replace(/,/g, ""),
            creditterm = $("#customer-credit-terms").val();

        let errors = "";
        let errorField = null;

        if (category === "") {
            errors = "Please select Customer category";
            errorField = $("#sel-category");
        } else if (posid === "") {
            errors = "Please select point of sale";
            errorField = $("#sel-outlet");
        } else if (customername === "") {
            errors = "Please provide customer name";
            errorField = $("#customer-name");
        } else if (tradingname === "") {
            errors = "Please provide trading name";
            errorField = $("#customer-trading-name");
        } else if (idno === "") {
            errors = "Please provide ID number";
            errorField = $("#customer-id-no");
        } else if (pinno === "") {
            errors = "Please provide PIN number";
            errorField = $("#customer-pin-no");
        } else if (mobile === "") {
            errors = "Please provide mobile number";
            errorField = $("#customer-mobile");
        } else if (creditlimit === "") {
            errors = "Please provide credit limit";
            errorField = $("#customer-credit-limit");
        } else if (creditterm === "" || creditterm === null) {
            errors = "Please select credit terms";
            errorField = $("#customer-credit-terms");
        }

        const isMobileOrTablet = window.innerWidth < 992;

        if (errors !== "") {
            if (isMobileOrTablet) {
                // Show Mobile Modal (using showAlert() look-and-feel info with icon)
                let alertHtml = '<div class="alert alert-info alert-white rounded text-left" style="margin-bottom: 0;">';
                alertHtml += '<div class="icon"><i class="fa fa-info-circle"></i></div>';
                alertHtml += '<div class="alert-title" style="margin-bottom: 5px;"><strong>Information!</strong></div>';
                alertHtml += '<div class="alert-message">' + errors + '</div></div>';
                
                $("#customer-modal-progress").hide();
                $("#customer-modal-alert-container").html(alertHtml);
                $("#customer-result-btn").removeClass("btn-success btn-danger").addClass("btn-info");
                $("#customer-modal-result").show();
                $("#customer-notification-modal").modal("show");

                // Place focus on the field with error after modal is dismissed
                $("#customer-notification-modal").one("hidden.bs.modal", function() {
                    if (errorField) {
                        errorField.focus();
                    }
                });
            } else {
                // Show Desktop Card (using info styled border & icon)
                $("#desktop-notification-card").css("border-left-color", "#3b82f6").slideDown(200);
                $("#desktop-notification-icon").text("info").css("color", "#3b82f6");
                $("#desktop-notification-title").text("Validation Information");
                $("#desktop-notification-msg").text(errors);
                
                // Focus the error field immediately on desktop
                if (errorField) {
                    errorField.focus();
                }
            }
            return;
        }

        // Show Processing state
        if (isMobileOrTablet) {
            $("#customer-modal-progress").show();
            $("#customer-modal-result").hide();
            $("#customer-notification-modal").modal("show");
        } else {
            $("#desktop-notification-card").css("border-left-color", "#3b82f6").slideDown(200);
            $("#desktop-notification-icon").text("sync").css("color", "#3b82f6");
            $("#desktop-notification-title").text("Processing...");
            $("#desktop-notification-msg").html('<div class="d-flex align-items-center" style="gap: 8px;"><div class="spinner-border spinner-border-sm text-primary" role="status"></div> <span>Please wait while we process the customer record...</span></div>');
        }

        // Send POST request to save customer
        $.post("../controllers/customeroperations.php", {
            savecustomer: "POST",
            id: id,
            customername: customername,
            tradingname: tradingname,
            physicaladdress: physicaladdress,
            postaladdress: postaladdress,
            mobile: mobile,
            email: email,
            creditlimit: creditlimit,
            creditterm: creditterm,
            category: category,
            posid: posid,
            onetimecustomer: onetimecustomer,
            pinno: pinno,
            idno: idno,
            subzoneid: subzoneid
        }, function(data) {
            data = $.trim(data);
            let displayTitle = "";
            let displayMsg = "";
            let isSuccessStatus = false;

            if (data === "success") {
                isSuccessStatus = true;
                displayTitle = "Saved Successfully!";
                displayMsg = "The customer records have been saved successfully to the system.";
                // Reload customer list
                loadCustomers();
                // Select and highlight newly saved customer
                if (id == 0) {
                    clearCustomerScreenForNewEntry();
                } else {
                    selectCustomer(id);
                }
            } else if (data === "name exists") {
                displayTitle = "Duplicate Customer Name";
                displayMsg = "The customer name already exists in the system. Please try a different name.";
            } else if (data === "id exists") {
                displayTitle = "Duplicate ID Number";
                displayMsg = "The customer's ID number already exists in the system.";
            } else if (data === "pin exists") {
                displayTitle = "Duplicate PIN Number";
                displayMsg = "The customer's PIN number already exists in the system.";
            } else {
                displayTitle = "Save Error";
                displayMsg = "Sorry, an unexpected error occurred: " + data;
            }

             if (isMobileOrTablet) {
                // Update and show Result State in Modal (using showAlert() look-and-feel alert boxes with icon)
                let alertHtml = '';
                if (isSuccessStatus) {
                    alertHtml = '<div class="alert alert-success alert-white rounded text-left" style="margin-bottom: 0;">';
                    alertHtml += '<div class="icon"><i class="fas fa-check-circle"></i></div>';
                    alertHtml += '<div class="alert-title" style="margin-bottom: 5px;"><strong>Success!</strong></div>';
                    alertHtml += '<div class="alert-message">' + displayMsg + '</div></div>';
                    $("#customer-result-btn").removeClass("btn-info btn-danger").addClass("btn-success");
                } else {
                    alertHtml = '<div class="alert alert-danger alert-white rounded text-left" style="margin-bottom: 0;">';
                    alertHtml += '<div class="icon"><i class="fa fa-times-circle"></i></div>';
                    alertHtml += '<div class="alert-title" style="margin-bottom: 5px;"><strong>Danger!</strong></div>';
                    alertHtml += '<div class="alert-message">' + displayMsg + '</div></div>';
                    $("#customer-result-btn").removeClass("btn-info btn-success").addClass("btn-danger");
                }
                
                $("#customer-modal-progress").hide();
                $("#customer-modal-alert-container").html(alertHtml);
                $("#customer-modal-result").show();
            } else {
                // Update and show Desktop Card
                if (isSuccessStatus) {
                    $("#desktop-notification-card").css("border-left-color", "#10b981");
                    $("#desktop-notification-icon").text("check_circle").css("color", "#10b981");
                } else {
                    $("#desktop-notification-card").css("border-left-color", "#ef4444");
                    $("#desktop-notification-icon").text("cancel").css("color", "#ef4444");
                }
                $("#desktop-notification-title").text(displayTitle);
                $("#desktop-notification-msg").text(displayMsg);
            }
        });
    });

    // Clear Customer Form Click Handler (Mobile Sticky Footer)
    $(document).on("click", "#btn-clear-customer-mobile", function() {
        clearCustomerScreenForNewEntry();
    });

    // Action Menu Logic (for Associated Contacts)
    $(document).on("click", ".action-trigger", function(e) {
        e.stopPropagation();
        $(".action-popup").hide();
        $(this).siblings(".action-popup").toggle();
    });

    $(document).on("click", function() {
        $(".action-popup").hide();
    });

    // Initialize
    init();

    // Initialize Datepickers for Statement Tab
    const threeMonthsAgo = new Date();
    threeMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3);

    $("#statement-start-date").flatpickr({
        dateFormat: "d-M-Y",
        maxDate: "today",
        defaultDate: threeMonthsAgo
    });

    $("#statement-end-date").flatpickr({
        dateFormat: "d-M-Y",
        maxDate: "today",
        defaultDate: "today"
    });

    // --- CORE CUSTOMER LOGIC ---
    const customerslist = $(".customer-list-sidebar");
    
    // Sidebar Search functionality
    const sidebar_search = $("#sidebar-customer-search");
    sidebar_search.on("input", function() {
        const term = $(this).val().toLowerCase();
        $(".customer-item").each(function() {
            const name = $(this).find("h6").text().toLowerCase();
            const email = $(this).find("p").text().toLowerCase();
            if (name.includes(term) || email.includes(term)) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });

    // Customer Selection from Sidebar
    customerslist.on("click", ".customer-item", function() {
        const id = $(this).data("id") || 0; 
        if (!id) return;

        $(".customer-item").removeClass("active");
        $(this).addClass("active");

        loadCustomerFullProfile(id);
    });

    function loadCustomerFullProfile(id) {
        $.getJSON("../controllers/customeroperations.php", { getcustomerdetails: true, customerid: id }, function(data) {
            if (data && data.length > 0) {
                const customer = data[0];
                
                // 1. Update Profile Header
                $(".profile-info-main h2").text(customer.customername);
                $(".profile-info-main p").text(customer.email || 'No email provided');
                $(".customer-status-badge").text(customer.onetimecustomer == 1 ? 'One-Time' : 'Regular');
                
                // 2. Populate Biodata Tab Fields
                $("#customer-name").val(customer.customername);
                $("#customer-trading-name").val(customer.tradingname);
                $("#customer-email").val(customer.email);
                $("#customer-mobile").val(customer.mobile);
                $("#customer-physical-address").val(customer.physicaladdress);
                $("#customer-postal-address").val(customer.postaladdress);
                $("#customer-credit-limit").val(customer.creditlimit);
                $("#customer-id-no").val(customer.idno);
                $("#customer-pin-no").val(customer.pinno);
                
                // 3. Update Hidden ID
                $("#customer-id-val").val(customer.customerid);

                // 4. Load related data
                loadCustomerDiscounts(customer.customerid);
                loadCustomerReceivables(customer.customerid);
                loadCustomerContacts(customer.customerid);
            }
        });
    }



    // --- STATEMENT GENERATION ---
    $(".btn-generate").on("click", function() {
        const startdate = $("#statement-start-date").val();
        const enddate = $("#statement-end-date").val();
        const customerid = $("#customer-id-val").val();
        const type = $("#statement-type").val();
        
        if (!customerid) {
            alert("Please select a customer first");
            return;
        }

        if (type === "normal") {
            // Load Normal Statement
            $.getJSON("../controllers/reportoperations.php", { getcustomerstatement: true, startdate, enddate, customerid }, function(data) {
                let rows = "";
                if (data && data.length > 0) {
                    const first = data[0];
                    // 1. Update Statement Header Info
                    $("#st-account-no").text("Account #" + (first.customerno || first.customerid));
                    $("#st-customer-name").text(first.customername);

                    $("#st-contact-person").html(`<span class="material-symbols-outlined" style="font-size: 16px; color: #94a3b8;">person</span> ${first.primarycontact || '---'}`);

                    $("#st-billing-address").html(`
                        <div style="font-weight: 500; color: #1e293b;">${first.physicaladdress || 'No physical address'}</div>
                        <div style="font-size: 12px; color: #64748b;">${first.postaladdress || 'No postal address'}</div>
                    `);

                    const displayMobile = first.contactmobile || first.mobile || '---';
                    const displayEmail = first.contactemail || first.email || '---';

                    $("#st-contact-mobile").html(`<span class="material-symbols-outlined" style="font-size: 16px; color: #94a3b8;">call</span> ${displayMobile}`);
                    $("#st-contact-email").html(`<span class="material-symbols-outlined" style="font-size: 16px; color: #94a3b8;">alternate_email</span> ${displayEmail}`);

                    // 2. Update Balance Summary Card
                    $("#st-opening-bal").text($.number(first.openingbalance, 2));
                    $("#st-total-invoices").text($.number(first.invoices, 2));
                    $("#st-total-payments").text(`(${$.number(first.payments, 2)})`);
                    $("#st-closing-bal").text($.number(first.closingbalance, 2));

                    // 3. Render Transaction Table
                    let runningBal = parseFloat(first.openingbalance);
                    data.forEach(item => {
                        runningBal += parseFloat(item.invoiceamount) - parseFloat(item.invoicepayment);
                        rows += `
                            <tr>
                                <td>${item.date}</td>
                                <td style="font-weight: 500; color: #1e293b;">${item.reference}</td>
                                <td>${item.narration}</td>
                                <td class="text-right">${parseFloat(item.invoiceamount) > 0 ? $.number(item.invoiceamount, 2) : '-'}</td>
                                <td class="text-right" style="color: #10b981;">${parseFloat(item.invoicepayment) > 0 ? '(' + $.number(item.invoicepayment, 2) + ')' : '-'}</td>
                                <td class="text-right" style="font-weight: 500; color: #1e293b;">${$.number(runningBal, 2)}</td>
                            </tr>`;
                    });
                } else {
                    rows = '<tr><td colspan="6" class="text-center py-4">No transactions found for this period</td></tr>';
                    // Reset summary on no data
                    $("#st-opening-bal, #st-total-invoices, #st-total-payments, #st-closing-bal").text("0.00");
                }
                $("#statement-history-body").html(rows);
            });

            // Load Aging Analysis
            $.getJSON("../controllers/reportoperations.php", { getcustomeraginganalysis: true, basedate: enddate, customerid }, function(data) {
                if (data && data.length > 0) {
                    const aging = data[0];
                    $(".aging-card:eq(0) .aging-val").text($.number(aging.thirty, 2));
                    $(".aging-card:eq(1) .aging-val").text($.number(aging.sixty, 2));
                    $(".aging-card:eq(2) .aging-val").text($.number(aging.ninety, 2));
                    $(".aging-card:eq(3) .aging-val").text($.number(aging.onetwenty, 2));
                    $(".aging-card:eq(4) .aging-val").text($.number(aging.aboveonetwenty, 2));
                    $(".aging-card.total .aging-val").text($.number(aging.total, 2));
                }
            });
        } else {
            // Load Suspense Account
            $.getJSON("../controllers/customeroperations.php", { getcustomersuspenseaccount: true, customerid, startdate, enddate }, function(data) {
                let rows = "";
                let runningBal = 0;
                if (data && data.length > 0) {
                    data.forEach(item => {
                        runningBal += parseFloat(item.credit) - parseFloat(item.debit);
                        rows += `
                            <tr>
                                <td>${item.date}</td>
                                <td style="font-weight: 500; color: #1e293b;">${item.referenceno}</td>
                                <td>${item.narration}</td>
                                <td class="text-right">${$.number(item.debit, 2)}</td>
                                <td class="text-right" style="color: #10b981;">${$.number(item.credit, 2)}</td>
                                <td class="text-right" style="font-weight: 500; color: #1e293b;">${$.number(runningBal, 2)}</td>
                            </tr>`;
                    });
                } else {
                    rows = '<tr><td colspan="6" class="text-center py-4">No suspense records found</td></tr>';
                }
                $("#statement-history-body").html(rows);
            });
        }
    });

    // --- PAYMENT POSTING ---
    $("#btn-auto-distribute").on("click", function() {
        let amount = parseFloat($("#payment-amount-paid").val()) || 0;
        if (amount <= 0) {
            alert("Please enter an amount paid first");
            return;
        }

        $("#receivables-list tr").each(function() {
            const bal = parseFloat($(this).find(".bal-cell").text().replace(/,/g, '')) || 0;
            const editable = $(this).find(".amt-pay-editable");
            
            if (amount > 0) {
                if (bal <= amount) {
                    editable.text(bal);
                    amount -= bal;
                } else {
                    editable.text(amount);
                    amount = 0;
                }
            } else {
                editable.text(0);
            }
        });
        
        $("#payment-overpay").val(amount.toFixed(2));
        calculatePaymentTotal();
    });

    $("#btn-post-payment").on("click", function() {
        const customerid = $("#customer-id-val").val();
        const mode = $("#payment-mode").val(); // I'll need to check the select ID in HTML
        const ref = $("#payment-ref").val();
        const overpay = $("#payment-overpay").val();
        
        if (!customerid || !ref) {
            alert("Please provide customer and reference number");
            return;
        }

        // Collect Table Data
        let TableData = [];
        $("#receivables-list tr").each(function() {
            const payVal = parseFloat($(this).find(".amt-pay-editable").text()) || 0;
            if (payVal > 0) {
                TableData.push({
                    "possaleid": $(this).find("td:eq(0)").text(),
                    "amount": payVal
                });
            }
        });

        if (TableData.length === 0 && parseFloat(overpay) <= 0) {
            alert("Please distribute some payment amount");
            return;
        }

        $.post("../controllers/customeroperations.php", {
            savereceipt: "POST",
            customerid,
            modeofpayment: mode,
            referenceno: ref,
            TableData: JSON.stringify(TableData),
            overpay
        }, function(data) {
            data = $.trim(data);
            if (data.length === 8) {
                alert("Payment posted successfully. Receipt #: " + data);
                // Optionally print receipt here
                loadCustomerReceivables(customerid); // Refresh
            } else {
                alert("Error: " + data);
            }
        });
    });

    function init() {
        loadCustomers();
        loadParameters();
        loadContactCategories();
        updateHeaderStats(null); // Reset scorecard on load
        
        // Initialize Discount Table
        const discountTable = $("#discount-table").DataTable({
            dom: 'tr<"d-flex justify-content-between align-items-center border-top"ip>',
            pageLength: 10,
            language: {
                paginate: {
                    previous: '<span><span class="material-symbols-outlined" style="font-size: 20px;">chevron_left</span></span>',
                    next: '<span><span class="material-symbols-outlined" style="font-size: 20px;">chevron_right</span></span>'
                },
                info: "Showing _START_ to _END_ of _TOTAL_ discounts"
            }
        });

        // Sync Search
        $("#discount-search").on("keyup", function() {
            discountTable.search($(this).val()).draw();
        });

        // Add Discount Modal Logic
        const discountModal = $("#add-discount-modal");
        
        $(document).on("click", "#create-discount-btn", function() {
            discountModal.addClass("show");
            $("body").css("overflow", "hidden");
        });

        $(document).on("click", "#close-discount-modal, #discard-discount-link", function(e) {
            e.preventDefault();
            $("#add-discount-modal").removeClass("show");
            $("body").css("overflow", "auto");
        });

        // Toggle Logic
        $(document).on("change", "#is-percentage-toggle", function() {
            const isPerc = $(this).is(":checked");
            const text = isPerc ? "Discount is a percentage" : "Discount is a fixed amount";
            const sub = isPerc ? "Switch off to apply fixed amount discount" : "Switch on to apply percentage discount";
            
            $(".toggle-text-new h6").text(text);
            $(".toggle-text-new p").text(sub);
            $(".toggle-icon-box span").text(isPerc ? "percent" : "payments");
        });

        // Expiry Picker (Flatpickr)
        $("#discount-expiry-picker").flatpickr({
            dateFormat: "d-M-Y", // dd-MMM-yyyy
            minDate: "today"
        });

        // Payment Tab Logic
        $(document).on("input", ".amt-pay-editable", function() {
            calculatePaymentTotal();
        });

        $(document).on("input", "#payment-amount-paid", function() {
            calculateOverpayment();
        });

        $(document).on("click", "#btn-auto-distribute", function() {
            autoDistributePayment();
        });

        $(document).on("click", "#btn-clear-payment", function() {
            clearPaymentForm();
        });

        // Receipt Toggle Buttons Logic
        $(document).on("click", ".btn-receipt-toggle", function() {
            $(this).toggleClass("active");
        });

        function clearPaymentForm() {
            $(".amt-pay-editable").text(0);
            $("#payment-amount-paid").val(0);
            $("#payment-ref").val("");
            calculatePaymentTotal();
        }
    }

    function calculatePaymentTotal() {
        let totalPaid = 0;
        let totalBalance = 0;
        let totalToPay = 0;
        
        $("#receivables-list tr").each(function() {
            totalPaid += parseFloat($(this).find("td:eq(4)").text().replace(/,/g, '')) || 0;
            totalBalance += parseFloat($(this).find(".bal-cell").text().replace(/,/g, '')) || 0;
            totalToPay += parseFloat($(this).find(".amt-pay-editable").text().replace(/,/g, '')) || 0;
        });

        // Summary alignment: 
        // id="total-balance-summary-val" is now in the Balance column spot
        // id="total-to-pay-display" is now in the Amount to Pay column spot
        $("#total-balance-summary-val").text($.number(totalBalance, 2));
        $("#total-to-pay-display").text($.number(totalToPay, 2));
        
        calculateOverpayment();
    }

    function calculateOverpayment() {
        const amountPaid = parseFloat($("#payment-amount-paid").val()) || 0;
        let totalToPay = 0;
        $(".amt-pay-editable").each(function() {
            totalToPay += parseFloat($(this).text().replace(/,/g, '')) || 0;
        });
        
        const overpay = Math.max(0, amountPaid - totalToPay);
        $("#payment-overpay").val($.number(overpay, 2));
    }

    function autoDistributePayment() {
        let amountRemaining = parseFloat($("#payment-amount-paid").val()) || 0;
        
        $("#receivables-list tr").each(function() {
            const balance = parseFloat($(this).find(".bal-cell").text().replace(/,/g, '')) || 0;
            const allocation = Math.min(balance, amountRemaining);
            $(this).find(".amt-pay-editable").text(allocation);
            amountRemaining -= allocation;
        });
        
        calculatePaymentTotal();
    }

    // Receivables Dynamic Rendering
    window.renderReceivables = function(data) {
        let html = "";
        if (!data || data.length === 0) {
            $("#receivables-list").html('<tr><td colspan="7" class="text-center py-4 text-muted">No open receivables found</td></tr>');
            calculatePaymentTotal();
            return;
        }
        
        data.forEach((item, index) => {
            const balance = parseFloat(item.balance) || 0;
            html += `
                <tr data-id="${item.possaleid}">
                    <td>${index + 1}</td>
                    <td class="ref-cell">${item.receiptno || '-'}</td>
                    <td>${item.transactiondate}</td>
                    <td class="text-right">${$.number(item.total, 2)}</td>
                    <td class="text-right">${$.number(item.paid, 2)}</td>
                    <td class="bal-cell text-right font-weight-bold" style="color: #ba1a1a;">${$.number(balance, 2)}</td>
                    <td class="text-right">
                        <div class="amt-pay-editable" contenteditable="true">0</div>
                    </td>
                </tr>
            `;
        });
        
        $("#receivables-list").html(html);
        calculatePaymentTotal();
    };

    // Mock Fetch for Receivables
    window.loadCustomerReceivables = function(customerid) {
        if (!customerid || customerid == 0) return;
        $.getJSON("../controllers/customeroperations.php", { getopenreceivables: true, customerid: customerid }, function(data) {
            renderReceivables(data);
        });
    };

    function loadParameters() {
        // Load Categories
        $.getJSON("../controllers/customeroperations.php", { getcustomercategories: "GET" }, function(data) {
            let html = '<option value="">Choose One</option>';
            data.forEach(item => {
                html += `<option value="${item.id}">${item.categoryname || item.description}</option>`;
            });
            $("#sel-category").html(html);
        });

        // Load Outlets
        $.getJSON("../controllers/posoperations.php", { getpointsofsale: true }, function(data) {
            let html = '<option value="">Choose One</option>';
            data.forEach(item => {
                html += `<option value="${item.id}">${item.posname}</option>`;
            });
            $("#sel-outlet").html(html);
        });

        // Load Main Zones
        $.getJSON("../controllers/zoneoperations.php", { getparentzones: true }, function(data) {
            let html = '<option value="">Choose One</option>';
            data.forEach(item => {
                html += `<option value="${item.id}">${item.zonename}</option>`;
            });
            $("#sel-mainzone").html(html);
        });
    }

    $("#sel-mainzone").on("change", function() {
        loadSubZones($(this).val());
    });

    function loadSubZones(parentId, selectedId = null) {
        if (!parentId) {
            $("#sel-subzone").html('<option value="">Choose One</option>');
            return;
        }
        
        return $.getJSON("../controllers/zoneoperations.php", { getsubzones: true, parent: parentId }, function(data) {
            let html = '<option value="">Choose One</option>';
            data.forEach(item => {
                html += `<option value="${item.id}">${item.zonename}</option>`;
            });
            $("#sel-subzone").html(html);
            if (selectedId) $("#sel-subzone").val(selectedId);
        });
    }

    function loadCustomers() {
        customerListBox.html('<div class="text-center py-5"><div class="spinner-border spinner-border-sm text-primary"></div></div>');
        
        const regular = cbRegular.is(":checked") ? 1 : 0;
        const onetime = cbOneTime.is(":checked") ? 1 : 0;

        $.getJSON("../controllers/customeroperations.php", {
            getcustomers: true,
            regularcustomers: regular,
            onetimecustomers: onetime
        }, function(data) {
            allCustomers = data;
            renderCustomerList(allCustomers);
        });
    }

    function renderCustomerList(data) {
        let html = "";
        if (data.length === 0) {
            html = '<div class="text-center py-5 text-muted small">No customers found</div>';
        } else {
            data.forEach(customer => {
                const initials = customer.customername.split(' ').map(n => n[0]).join('').substring(0,2).toUpperCase();
                const isSelected = selectedCustomerId == customer.customerid ? 'selected' : '';
                html += `
                    <div class="customer-row ${isSelected}" data-id="${customer.customerid}">
                        <div class="row-avatar">${initials}</div>
                        <div class="row-info">
                            <h6>${customer.customername}</h6>
                            <p>ID: ${customer.customerno}</p>
                        </div>
                    </div>
                `;
            });
        }
        customerListBox.html(html);
    }

    // Filter and Search
    masterSearch.on("input", performFilter);
    cbRegular.on("change", loadCustomers);
    cbOneTime.on("change", loadCustomers);

    function performFilter() {
        const query = masterSearch.val().toLowerCase();
        const filtered = allCustomers.filter(c => 
            c.customername.toLowerCase().includes(query) || 
            (c.customerno && c.customerno.toLowerCase().includes(query))
        );
        renderCustomerList(filtered);
    }

    // Selection
    customerListBox.on("click", ".customer-row", function() {
        $(".customer-row").removeClass("selected");
        $(this).addClass("selected");
        selectedCustomerId = $(this).data("id");
        selectCustomer(selectedCustomerId);
    });

    // Add Customer Button Click
    $(document).on("click", "#add-btn", function() {
        clearCustomerScreenForNewEntry();
        // Switch to Biodata tab automatically for seamless data entry
        $(".mgmt-tab[data-tab='biodata']").trigger("click");
        // Focus the customer name input
        $("#customer-name").focus();
    });

    function clearCustomerScreenForNewEntry() {
        selectedCustomerId = null;
        $(".customer-row").removeClass("selected");

        // 1. Reset the scorecard / header-card stats
        updateHeaderStats(null);
        
        // 2. Clear all customer entry form fields (Biodata tab)
        $("#customer-id-val").val("0");
        $("#customer-name").val("");
        $("#customer-trading-name").val("");
        $("#customer-id-no").val("");
        $("#customer-pin-no").val("");
        $("#customer-physical-address").val("");
        $("#customer-postal-address").val("");
        $("#customer-mobile").val("");
        $("#customer-email").val("");
        
        // Reset selections
        $("#sel-category").val("");
        $("#sel-outlet").val("");
        $("#sel-mainzone").val("");
        $("#sel-subzone").html('<option value="">Choose One</option>').val("");
        
        // Reset credit fields
        $("#customer-credit-limit").val("50,000.00");
        $("#customer-opening-balance").val("0.00");
        $("#customer-credit-terms").val("0");
        $("#customer-onetime").prop("checked", false);
        
        // 3. Clear associated contacts list
        renderCustomerContacts([]);
        
        // 4. Clear associated discounts table
        const table = $("#discount-table").DataTable();
        table.clear().draw();
        
        // Clear discount stats
        $("#ds-total-val").text("0.00");
        $("#ds-active-count").text("00");
        $("#ds-expiring-count").text("00");
    }

    function selectCustomer(customerid) {
        // Show loading state in header stats
        $("#h-name").text("Loading...");
        
        // Handle mock selection differently if needed, but for now we try to fetch
        $.getJSON("../controllers/customeroperations.php", {
            getcustomerdetails: true,
            customerid: customerid
        }, function(data) {
            if (data.length>0) {
                const c = data[0];                
                updateHeaderStats(c);
                renderCustomerMainDetails(c);
                loadCustomerReceivables(customerid);
                loadCustomerContacts(customerid);
                loadCustomerDiscounts(customerid);
            } else {
                // Handle mock data selection
                const mock = allCustomers.find(c => c.customerid == customerid);
                if (mock) {
                    updateHeaderStats({
                        customerid: mock.customerid,
                        customername: mock.customername,
                        idno: mock.idno,
                        openingbalance: 50000,
                        creditlimit: 200000,
                        creditterm: 30
                    });
                    loadCustomerDiscounts(customerid);
                }
            }
        });
    }

    function updateHeaderStats(c) {
        if (!c) {
            $("#h-name").text("---");
            $("#h-id").text("ID: ---");
            $("#h-outstanding").text("0");
            $("#h-limit").text("0");
            $("#h-available").text("0");
            $("#h-progress").css("width", "0%");
            $("#h-terms").text("--- Terms");
            $("#h-last-pay-amount").text("0");
            $("#h-last-pay-date").text("");
            $("#last-payment-mode").text("-");
            $("#h-oldest-amount").text("0");
            $("#h-oldest-ref").text("---");
            $("#h-oldest-days").text("-");
            $("#managersname").text("-");
            $("#h-pending").text("0 Pending");
            return;
        }
        // Basic Info
        $("#h-name").text(c.customername);
        $("#h-id").text("ID: " + (c.customerno || 'CUST-'+c.customerid.toString().padStart(4, '0')));
        
        // Outstanding & Credit (formatted as 50K etc)
        const formatStat = (val) => {
            if (val >= 1000) return (val/1000).toFixed(0) + 'K';
            return $.number(val, 0);
        };

        const outstanding = parseFloat(c.openingbalance || 0);
        const limit = parseFloat(c.creditlimit || 0);
        const available = Math.max(0, limit - outstanding);
        const progress = limit > 0 ? (available / limit) * 100 : 0;

        $("#h-outstanding").text(formatStat(outstanding));
        $("#h-limit").text(formatStat(limit));
        $("#h-available").text(formatStat(available));
        $("#h-progress").css("width", progress + "%");
        $("#h-terms").text("Net " + (c.creditterm || 30) + " Terms");

        // Latest Payment & Oldest Charge (Reset to dynamic if possible)
        $.getJSON("../controllers/reportoperations.php", {
            getcustomerstatement: true,
            customerid: c.customerid,
            startdate: moment().subtract(6, 'months').format('D-MMM-YYYY'),
            enddate: moment().format('D-MMM-YYYY')
        }, function(statement) {
            if (statement && statement.length > 0) {
                const payments = statement.filter(s => parseFloat(s.invoicepayment) > 0);
                if (payments.length > 0) {
                    const latest = payments[0];
                    $("#h-last-pay-amount").text($.number(latest.invoicepayment, 0));
                    $("#h-last-pay-date").text(moment(latest.date, "DD-MMM-YYYY").format("MMM D"));
                }
                const invoices = statement.filter(s => parseFloat(s.invoiceamount) > 0);
                if (invoices.length > 0) {
                    const oldest = invoices[invoices.length - 1];
                    $("#h-oldest-amount").text($.number(oldest.invoiceamount, 0));
                    $("#h-oldest-ref").text(oldest.reference);
                }
            }
        });
    }

    function renderCustomerMainDetails(c) {
        // Populate inputs in Biodata Pane using proper IDs
        $("#customer-id-val").val(c.customerid);
        $("#customer-name").val(c.customername);
        $("#customer-trading-name").val(c.tradingname || c.customername);
        $("#customer-id-no").val(c.idno || '');
        $("#customer-pin-no").val(c.pinno || '');
        $("#customer-physical-address").val(c.physicaladdress || '');
        $("#customer-postal-address").val(c.postaladdress || '');
        $("#customer-mobile").val(c.mobile || '');
        $("#customer-email").val(c.email || '');

        // Set Selectors
        $("#sel-category").val(c.catid || "");
        $("#sel-outlet").val(c.posid || "");

        // Handle Zones
        $("#sel-mainzone").val(c.mainzone || "");
        loadSubZones(c.mainzone, c.subzoneid);
        
        // Update Financial Fields
        $("#customer-credit-limit").val($.number(c.creditlimit, 2));
        $("#customer-opening-balance").val($.number(c.openingbalance, 2));
        console.log(c.creditterm)
        $("#customer-credit-terms").val(c.creditterm || "0");
        $("#customer-onetime").prop("checked", c.onetimecustomer == 1);
    }

    // Sidebar Toggle (Mobile & Desktop)
    $("#menu-toggle").on("click", function() {
        if (window.innerWidth <= 992) {
            $(".sidebar").addClass("active");
            $("#sidebar-overlay").addClass("active");
        } else {
            $(".sidebar").toggleClass("close1");
        }
    });

    // Close mobile sidebar on overlay click
    $("#sidebar-overlay").on("click", function() {
        $(".sidebar").removeClass("active");
        $(this).removeClass("active");
    });

    // --- CONTACT MANAGEMENT ---
    let currentEditingContactId = 0;

    function loadContactCategories() {
        $.getJSON("../controllers/customeroperations.php", { getcontactcategories: true }, function(data) {
            let options = '<option value="">Choose One</option>';
            data.forEach(cat => {
                options += `<option value="${cat.id}">${cat.description}</option>`;
            });
            $("#contact-category-sel").html(options);
        });
    }

    function loadCustomerContacts(customerid) {
        if (!customerid || customerid == 0) return;
        $.getJSON("../controllers/customeroperations.php", { getcustomercontacts: true, customerid: customerid }, function(data) {
            renderCustomerContacts(data);
        });
    }

    function renderCustomerContacts(contacts) {
        const body = $("#customer-contacts-body");
        body.empty();
        if (!contacts || contacts.length === 0) {
            body.append('<tr><td colspan="8" class="text-center py-4 text-muted small">No associated contacts found</td></tr>');
            return;
        }

        contacts.forEach(c => {
            const row = `
                <tr data-id="${c.customercontactid}">
                    <td><span class="badge-cat" style="background: #E0EEFF; color: #0056D2;">${c.categoryname || 'General'}</span></td>
                    <td class="font-weight-bold">${c.contactname}</td>
                    <td>${c.idno || '-'}</td>
                    <td>${c.mobile || '-'}</td>
                    <td>${c.email || '-'}</td>
                    <td><span class="material-symbols-outlined" style="color: ${c.idpath ? '#0056D2' : '#cbd5e1'};">description</span></td>
                    <td><span class="material-symbols-outlined" style="color: ${c.consentsigned == 1 ? '#0056D2' : '#cbd5e1'}; font-variation-settings: 'FILL' ${c.consentsigned == 1 ? 1 : 0};">check_circle</span></td>
                    <td class="text-right position-relative">
                        <button class="btn btn-light btn-sm action-trigger">
                            <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                        </button>
                        <div class="action-popup">
                            <div class="action-item edit-contact"><span class="material-symbols-outlined">edit</span> Edit</div>
                            <div class="action-item delete-contact text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                        </div>
                    </td>
                </tr>
            `;
            body.append(row);
        });
    }

    $("#add-contact-btn").on("click", function() {
        const customerid = $("#customer-id-val").val();
        if (!customerid || customerid == 0) {
            alert("Please select a customer first.");
            return;
        }

        const categoryid = $("#contact-category-sel").val();
        const contactname = $("#contact-name-in").val();
        const idno = $("#contact-idno-in").val();
        const mobile = $("#contact-mobile-in").val();
        const email = $("#contact-email-in").val();

        if (!contactname) {
            alert("Please enter contact name.");
            return;
        }

        $.post("../controllers/customeroperations.php", {
            savecustomercontact: true,
            id: currentEditingContactId,
            customerid: customerid,
            categoryid: categoryid,
            contactname: contactname,
            idno: idno,
            mobile: mobile,
            email: email,
            consentsigned: 0 // Default for now
        }, function(res) {
            if (res.trim() === "success") {
                clearContactForm();
                loadCustomerContacts(customerid);
            } else {
                alert("Error: " + res);
            }
        });
    });

    function clearContactForm() {
        currentEditingContactId = 0;
        $("#contact-category-sel").val("");
        $("#contact-name-in").val("");
        $("#contact-idno-in").val("");
        $("#contact-mobile-in").val("");
        $("#contact-email-in").val("");
        $("#add-contact-btn span").text("add");
    }

    $(document).on("click", ".delete-contact", function() {
        if (!confirm("Are you sure you want to delete this contact?")) return;
        const row = $(this).closest("tr");
        const id = row.data("id");
        const customerid = $("#customer-id-val").val();

        $.post("../controllers/customeroperations.php", {
            deletecustomercontact: true,
            id: id
        }, function(res) {
            if (res.trim() === "success") {
                loadCustomerContacts(customerid);
            } else {
                alert("Error: " + res);
            }
        });
    });

    $(document).on("click", ".edit-contact", function() {
        const row = $(this).closest("tr");
        const id = row.data("id");
        currentEditingContactId = id;

        // Fetch details from row or server (row is easier if all data is there)
        // Since we render all fields, we can pull from row
        const catName = row.find("td:eq(0)").text();
        const name = row.find("td:eq(1)").text();
        const idno = row.find("td:eq(2)").text();
        const mobile = row.find("td:eq(3)").text();
        const email = row.find("td:eq(4)").text();

        // Match category name to ID
        const catId = $("#contact-category-sel option").filter(function() {
            return $(this).text() === catName;
        }).val();

        $("#contact-category-sel").val(catId);
        $("#contact-name-in").val(name);
        $("#contact-idno-in").val(idno === '-' ? '' : idno);
        $("#contact-mobile-in").val(mobile === '-' ? '' : mobile);
        $("#contact-email-in").val(email === '-' ? '' : email);
        
        $("#add-contact-btn span").text("save");
        $("#contact-name-in").focus();
    });

    function loadCustomerDiscounts(customerid) {
        if (!customerid || customerid == 0) return;
        $.getJSON("../controllers/customeroperations.php", { getcustomerdiscounts: true, customerid: customerid }, function(data) {
            renderDiscounts(data);
        });
    }

    function renderDiscounts(discounts) {
        const table = $("#discount-table").DataTable();
        table.clear();

        let totalVal = 0;
        let activeCount = 0;
        let expiringCount = 0;
        const now = moment();
        const soon = moment().add(48, 'hours');

        if (discounts && discounts.length > 0) {
            discounts.forEach(d => {
                const expiry = moment(d.expirydate);
                const isPerc = parseInt(d.percentage) === 1;
                const discountDisplay = isPerc ? d.discount + '%' : $.number(d.discount, 2);
                const finalPrice = isPerc ? (d.sellingprice * (1 - d.discount/100)) : (d.sellingprice - d.discount);
                const isActive = expiry.isAfter(now);
                const isExpiringSoon = isActive && expiry.isBefore(soon);

                if (isActive) activeCount++;
                if (isExpiringSoon) expiringCount++;
                totalVal += parseFloat(d.discount) || 0;

                table.row.add([
                    d.itemcode,
                    d.itemname,
                    $.number(d.sellingprice, 2),
                    discountDisplay,
                    isPerc ? 'Percentage' : 'Flat',
                    $.number(finalPrice, 2),
                    expiry.format('MMM DD, YYYY'),
                    `<span class="badge-status ${isActive ? 'status-active' : 'status-expiring'}">${isActive ? 'Active' : 'Expired'}</span>`,
                    `<td class="text-right position-relative">
                        <button class="btn btn-light btn-sm action-trigger">
                            <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                        </button>
                        <div class="action-popup">
                            <div class="action-item edit-discount" data-id="${d.id}"><span class="material-symbols-outlined">edit</span> Edit</div>
                            <div class="action-item delete-discount text-danger" data-id="${d.id}"><span class="material-symbols-outlined">delete</span> Delete</div>
                        </div>
                    </td>`
                ]);
            });
        }
        table.draw();

        // Update Stats
        $("#ds-total-val").text($.number(totalVal, 2));
        $("#ds-active-count").text(activeCount.toString().padStart(2, '0'));
        $("#ds-expiring-count").text(expiringCount.toString().padStart(2, '0'));
    }

    // Copy Customer Name to Trading Name Click Handler
    $(document).on("click", "#btn-copy-name-to-trading", function(e) {
        e.stopPropagation();
        const customerName = $.trim($("#customer-name").val());
        if (customerName !== "") {
            $("#customer-trading-name").val(customerName);
            
            // Micro-animation indicator
            const $icon = $(this);
            $icon.text("check").css("color", "#10b981");
            setTimeout(function() {
                $icon.text("content_copy").css("color", "#94a3b8");
            }, 1000);
        }
    });
});

