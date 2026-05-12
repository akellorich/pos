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

        // Toggle Save Button Visibility
        if (tabId === 'biodata') {
            $("#btn-save-customer").css("visibility", "visible");
        } else {
            $("#btn-save-customer").css("visibility", "hidden");
        }
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
    $(".statement-datepicker").datepicker({
        dateFormat: "dd-M-yy",
        maxDate: 0,
        changeMonth: true,
        changeYear: true
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
                $("#customer-id-val").val(customer.id);

                // 4. Load related data
                loadCustomerDiscounts(customer.id);
                loadCustomerReceivables(customer.id);
            }
        });
    }

    function loadCustomerDiscounts(id) {
        $.getJSON("../controllers/customeroperations.php", { getcustomerdiscounts: true, customerid: id }, function(data) {
            let rows = "";
            if (data && data.length > 0) {
                data.forEach((d, idx) => {
                    const typeClass = d.percentage == 1 ? 'type-pill percentage' : 'type-pill';
                    const typeLabel = d.percentage == 1 ? 'Percentage' : 'Flat';
                    
                    rows += `
                        <tr>
                            <td style="color: #64748b; font-size: 11px;">${d.itemcode}</td>
                            <td>
                                <div style="font-weight: 500; color: #1e293b;">${d.itemname}</div>
                            </td>
                            <td style="color: #64748b;">${d.sellingprice}</td>
                            <td style="color: #dc2626; font-weight: 500;">${d.discount}</td>
                            <td><span class="${typeClass}">${typeLabel}</span></td>
                            <td style="font-weight: 500;">${parseFloat(d.sellingprice - d.discount).toFixed(2)}</td>
                            <td style="color: #475569;">${d.expirydate}</td>
                            <td><span class="badge-status status-active">Active</span></td>
                            <td class="text-right">
                                <button class="btn btn-light btn-sm delete-discount" data-id="${d.id}">
                                    <span class="material-symbols-outlined" style="font-size: 18px; color: #dc2626;">delete</span>
                                </button>
                            </td>
                        </tr>`;
                });
            } else {
                rows = `<tr><td colspan="9" class="text-center py-4 text-muted">No active discounts found for this customer</td></tr>`;
            }
            $("#discount-table tbody").html(rows);
        });
    }

    function loadCustomerReceivables(id) {
        $.getJSON("../controllers/customeroperations.php", { getopenreceivables: true, customerid: id }, function(data) {
            let rows = "";
            let totalBal = 0;
            if (data && data.length > 0) {
                data.forEach((r) => {
                    totalBal += parseFloat(r.balance);
                    rows += `
                        <tr>
                            <td>${r.id}</td>
                            <td class="ref-cell">${r.id}</td>
                            <td>${r.transactiondate}</td>
                            <td class="text-right">${r.total}</td>
                            <td class="text-right">${r.paid}</td>
                            <td class="bal-cell text-right">${r.balance}</td>
                            <td class="text-right">
                                <div class="amt-pay-editable" contenteditable="true">0</div>
                            </td>
                        </tr>`;
                });
            } else {
                rows = `<tr><td colspan="7" class="text-center py-4 text-muted">No open receivables found</td></tr>`;
            }
            $("#receivables-list").html(rows);
            $("#total-balance-summary-val").text(totalBal.toLocaleString(undefined, {minimumFractionDigits: 2}));
            calculatePaymentTotal();
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
                    let runningBal = parseFloat(data[0].openingbalance);
                    data.forEach(item => {
                        runningBal += parseFloat(item.invoiceamount) - parseFloat(item.invoicepayment);
                        rows += `
                            <tr>
                                <td>${item.date}</td>
                                <td style="font-weight: 500; color: #1e293b;">${item.reference}</td>
                                <td>${item.narration}</td>
                                <td class="text-right">${parseFloat(item.invoiceamount).toLocaleString(undefined, {minimumFractionDigits: 2})}</td>
                                <td class="text-right" style="color: #10b981;">${parseFloat(item.invoicepayment).toLocaleString(undefined, {minimumFractionDigits: 2})}</td>
                                <td class="text-right" style="font-weight: 500; color: #1e293b;">${runningBal.toLocaleString(undefined, {minimumFractionDigits: 2})}</td>
                            </tr>`;
                    });
                    
                    // Update Summary Box
                    $(".summary-box .summary-line:eq(0) span:eq(1)").text(parseFloat(data[0].openingbalance).toLocaleString());
                    $(".summary-box .summary-line:eq(1) span:eq(1)").text(parseFloat(data[0].invoices).toLocaleString());
                    $(".summary-box .summary-line:eq(2) span:eq(1)").text(parseFloat(data[0].payments).toLocaleString());
                    $(".closing-balance-box span:eq(1)").text(parseFloat(data[0].closingbalance).toLocaleString());
                } else {
                    rows = '<tr><td colspan="6" class="text-center py-4">No transactions found for this period</td></tr>';
                }
                $("#statement-history-body").html(rows);
            });

            // Load Aging Analysis
            $.getJSON("../controllers/reportoperations.php", { getcustomeraginganalysis: true, basedate: enddate, customerid }, function(data) {
                if (data && data.length > 0) {
                    const aging = data[0];
                    $(".aging-card:eq(0) .aging-val").text(parseFloat(aging.thirty).toLocaleString());
                    $(".aging-card:eq(1) .aging-val").text(parseFloat(aging.sixty).toLocaleString());
                    $(".aging-card:eq(2) .aging-val").text(parseFloat(aging.ninety).toLocaleString());
                    $(".aging-card:eq(3) .aging-val").text(parseFloat(aging.onetwenty).toLocaleString());
                    $(".aging-card:eq(4) .aging-val").text(parseFloat(aging.aboveonetwenty).toLocaleString());
                    $(".aging-card.total .aging-val").text(parseFloat(aging.total).toLocaleString());
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
                                <td class="text-right">${parseFloat(item.debit).toLocaleString(undefined, {minimumFractionDigits: 2})}</td>
                                <td class="text-right" style="color: #10b981;">${parseFloat(item.credit).toLocaleString(undefined, {minimumFractionDigits: 2})}</td>
                                <td class="text-right" style="font-weight: 500; color: #1e293b;">${runningBal.toLocaleString(undefined, {minimumFractionDigits: 2})}</td>
                            </tr>`;
                    });
                } else {
                    rows = '<tr><td colspan="6" class="text-center py-4">No suspense records found</td></tr>';
                }
                $("#statement-history-body").html(rows);
                // Suspense mode usually doesn't show aging or standard summary in same format
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

        // Expiry Picker (jQuery UI Datepicker)
        $("#discount-expiry-picker").datepicker({
            dateFormat: "dd-M-yy", // dd-MMM-yyyy
            minDate: 0,
            changeMonth: true,
            changeYear: true
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
        
        data.forEach(item => {
            const balance = item.invoiceamount - item.paid;
            html += `
                <tr>
                    <td>${item.invoiceno}</td>
                    <td class="ref-cell">${item.reference}</td>
                    <td>${item.date}</td>
                    <td class="text-right">${$.number(item.invoiceamount, 2)}</td>
                    <td class="text-right">${$.number(item.paid, 2)}</td>
                    <td class="bal-cell text-right">${$.number(balance, 2)}</td>
                    <td class="text-right">
                        <div class="amt-pay-editable" contenteditable="true">${balance}</div>
                    </td>
                </tr>
            `;
        });
        
        $("#receivables-list").html(html);
        calculatePaymentTotal();
    };

    // Mock Fetch for Receivables
    window.loadCustomerReceivables = function(customerid) {
        // Standard JSON Structure per request
        const mockData = [
            { invoiceno: 269, reference: "INV-2025-07-11", date: "2025-07-11", invoiceamount: 1845.00, paid: 0.00 },
            { invoiceno: 5180, reference: "INV-2026-03-17", date: "2026-03-17", invoiceamount: 250.00, paid: 0.00 },
            { invoiceno: 5192, reference: "INV-2026-04-02", date: "2026-04-02", invoiceamount: 1200.00, paid: 500.00 },
            { invoiceno: 5205, reference: "INV-2026-04-15", date: "2026-04-15", invoiceamount: 5500.00, paid: 0.00 },
            { invoiceno: 5218, reference: "INV-2026-04-25", date: "2026-04-25", invoiceamount: 3000.00, paid: 0.00 }
        ];
        renderReceivables(mockData);
    };

    function loadParameters() {
        // Load Categories
        $.getJSON("../controllers/customeroperations.php", { getcustomercategories: "GET" }, function(data) {
            let html = '<option value="">Choose One</option>';
            data.forEach(item => {
                html += `<option value="${item.id}">${item.description}</option>`;
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
            } else {
                // Handle mock data selection
                const mock = allCustomers.find(c => c.customerid == customerid);
                if (mock) {
                    updateHeaderStats({
                        customername: mock.customername,
                        idno: mock.idno,
                        openingbalance: 50000,
                        creditlimit: 200000,
                        creditterm: 30
                    });
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
        $("#h-id").text("ID: " + (c.customerno || 'CUST-'+c.id.toString().padStart(4, '0')));
        
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
            customerid: c.id,
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
        console.log(c)
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

    // Sidebar Toggle
    $("#menu-toggle").on("click", function() {
        $(".sidebar").toggleClass("close1");
    });
});
