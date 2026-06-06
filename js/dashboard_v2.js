$(document).ready(function(){
    let startdate, enddate;
    let currentRange = "today";
    
    // ApexCharts Instances
    let salesByValueChart, 
        salesByQuantityChart, 
        salesByPaymentModeChart, 
        salesByCustomerCountChart, 
        salesByCustomerValueChart;

    // Brand Colors
    const primaryColor = '#0059bb';

    // Helper for formatting large numbers - 0 decimal places as requested
    function formatKMB(val) {
        if (val >= 1000000) {
            return (val / 1000000).toFixed(0) + 'M';
        } else if (val >= 1000) {
            return (val / 1000).toFixed(0) + 'K';
        }
        return val;
    }

    // Initialize Flatpickr with Airline Style Customization
    const rangePicker = flatpickr("#range-picker-input", {
        mode: "range",
        showMonths: 2,
        dateFormat: "d-M-Y",
        maxDate: "today",
        onOpen: function(selectedDates, dateStr, instance) {
            // Inject Custom Header if not exists
            if (!$(instance.calendarContainer).find('.fp-range-indicator').length) {
                $(`<div class="fp-range-indicator">
                    <span class="start-date-label">Select Start</span>
                    <span class="arrow material-symbols-outlined">arrow_forward</span>
                    <span class="end-date-label">Select End</span>
                </div>`).prependTo(instance.calendarContainer);
            }
            
            // Inject Custom Footer if not exists
            if (!$(instance.calendarContainer).find('.fp-footer').length) {
                const footer = $(`<div class="fp-footer">
                    <button class="fp-done-btn">Done</button>
                </div>`).appendTo(instance.calendarContainer);
                
                footer.find('.fp-done-btn').on('click', () => instance.close());
            }
            
            updatePickerHeader(selectedDates, instance);
        },
        onChange: function(selectedDates, dateStr, instance) {
            updatePickerHeader(selectedDates, instance);
        },
        onClose: function(selectedDates, dteStr, instance) {
            if (selectedDates.length === 2) {
                startdate = formatdate(selectedDates[0]);
                enddate = formatdate(selectedDates[1]);
                $("#current-range-label").text(startdate + " to " + enddate);
                $('.filter-btn').removeClass('active');
                currentRange = "custom";
                refreshData();
            }
        }
    });

    function updatePickerHeader(selectedDates, instance) {
        const header = $(instance.calendarContainer).find('.fp-range-indicator');
        if (selectedDates.length >= 1) {
            header.find('.start-date-label').text(moment(selectedDates[0]).format('ddd, D MMM'));
        } else {
            header.find('.start-date-label').text('Select Start');
        }
        
        if (selectedDates.length === 2) {
            header.find('.end-date-label').text(moment(selectedDates[1]).format('ddd, D MMM'));
        } else {
            header.find('.end-date-label').text('Select End');
        }
    }

    // Initialize
    initDashboard();

    // Event Listeners for Filter Buttons
    $('.filter-btn').on('click', function() {
        $('.filter-btn').removeClass('active');
        $(this).addClass('active');
        $("#current-range-label").text("Custom Range");
        
        currentRange = $(this).data('range');
        refreshDashboard(currentRange);
    });

    function initDashboard() {
        if (typeof getloggedinuser === 'function') {
            getloggedinuser();
        }
        getdashboardheader();
        refreshDashboard("today");
    }

    function refreshDashboard(range) {
        setDates(range);
        refreshData();
    }

    function refreshData() {
        // Direct mapping as requested by user
        let rangeType = "Day";
        switch (currentRange) {
            case "today":
                rangeType = "Day";
                break;
            case "week":
                rangeType = "Week";
                break;
            case "month":
                rangeType = "Month";
                break;
            case "year":
                rangeType = "Year";
                break;
            default:
                rangeType = "Day";
                break;
        }

        getSalesByValueInternal(rangeType);
        getSalesByQuantityInternal(rangeType);
        getsalesbypeymentmethodInternal();
        getsalesbycustomercountInternal(rangeType);
        getsalesbyoutletInternal();
        getsalesbysalespersonInternal();
        getbestsellingproductInternal();
        getbestsellingcategoryInternal();
        getsalesbycustomervalueInternal(rangeType);
        populateCustomerPerformance();
        populateReorderItems();
    }

    function setDates(daterange) {
        enddate = new Date();
        startdate = new Date();
        switch (daterange) {
            case "today":
                break;
            case "week":
                startdate.setDate(enddate.getDate() - 7);
                break;
            case "month":
                startdate.setDate(enddate.getDate() - 30);
                break;
            case "year":
                startdate.setDate(enddate.getDate() - 365);
                break;
        }
        startdate = formatdate(startdate);
        enddate = formatdate(enddate);
    }

    function formatdate(date) {
        const months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
        let d = new Date(date);
        return d.getDate() + "-" + months[d.getMonth()] + "-" + d.getFullYear();
    }

    function getdashboardheader() {
        setDates("today");
        $.getJSON("../controllers/reportoperations.php", {
            getdashboardheader: true,
            date: enddate
        }, function(data) {
            if (data && data[0]) {
                $("#activecustomersplaceholder").text($.number(data[0].activecustomers, 0));
                $("#openreceivablesplaceholder").text($.number(data[0].openreceivables, 0));
                $("#openpayablesplaceholder").text($.number(data[0].openpayables, 0));
                $("#openpurchaseordersplaceholder").text($.number(data[0].openorders, 0));
            }
        });
    }

    function getSalesByValueInternal(rangeType) {
        $.getJSON("../controllers/reportoperations.php", {
            getsalestrend: true,
            startdate: startdate,
            enddate: enddate,
            range: rangeType
        }, function(data) {
            let labels = [], salesdata = [];
            data.forEach(item => {
                labels.push(item.transactiondate);
                salesdata.push(parseFloat(item.amount));
            });

            const options = {
                series: [{ name: 'Revenue', data: salesdata }],
                chart: { type: 'area', height: 260, toolbar: { show: false }, zoom: { enabled: false } },
                colors: [primaryColor],
                dataLabels: { enabled: false },
                stroke: { curve: 'smooth', width: 2 },
                fill: {
                    type: 'gradient',
                    gradient: { shadeIntensity: 1, opacityFrom: 0.3, opacityTo: 0.05, stops: [0, 90, 100] }
                },
                grid: { padding: { left: 0, right: 0, top: 0, bottom: 0 } },
                xaxis: { 
                    categories: labels, 
                    labels: { style: { fontSize: '7px', fontFamily: 'Inter' }, offsetY: -2 },
                    axisBorder: { show: false },
                    axisTicks: { show: false }
                },
                yaxis: { 
                    labels: { 
                        style: { fontSize: '7px', fontFamily: 'Inter' }, 
                        offsetX: -10, 
                        formatter: val => formatKMB(val) 
                    }
                },
                tooltip: { y: { formatter: val => $.number(val, 2) } }
            };

            if (salesByValueChart) salesByValueChart.destroy();
            salesByValueChart = new ApexCharts(document.querySelector("#salesbyvalue-chart"), options);
            salesByValueChart.render();
        });
    }

    function getSalesByQuantityInternal(rangeType) {
        $.getJSON("../controllers/reportoperations.php", {
            getsalesbyquantity: true,
            startdate: startdate,
            enddate: enddate,
            range: rangeType
        }, function(data) {
            let labels = [], quantitydata = [];
            data.forEach(item => {
                labels.push(item.transactiondate);
                quantitydata.push(parseFloat(item.quantity));
            });

            const options = {
                series: [{ name: 'Units Sold', data: quantitydata }],
                chart: { type: 'bar', height: 260, toolbar: { show: false } },
                colors: [primaryColor],
                plotOptions: { bar: { borderRadius: 2, columnWidth: '40%' } },
                dataLabels: { enabled: false },
                grid: { padding: { left: 0, right: 0, top: 0, bottom: 0 } },
                xaxis: { 
                    categories: labels, 
                    labels: { style: { fontSize: '7px', fontFamily: 'Inter' }, offsetY: -2 },
                    axisBorder: { show: false },
                    axisTicks: { show: false }
                },
                yaxis: { 
                    labels: { 
                        style: { fontSize: '7px', fontFamily: 'Inter' }, 
                        offsetX: -10,
                        formatter: val => formatKMB(val)
                    } 
                }
            };

            if (salesByQuantityChart) salesByQuantityChart.destroy();
            salesByQuantityChart = new ApexCharts(document.querySelector("#salesbyquantity-chart"), options);
            salesByQuantityChart.render();
        });
    }

    function getsalesbypeymentmethodInternal() {
        $.getJSON("../controllers/reportoperations.php", {
            getsalesbypaymentmode: true,
            startdate: startdate,
            enddate: enddate
        }, function(data) {
            let labels = [], salesdata = [];
            let totalSales = 0;
            data.forEach(item => {
                labels.push(item.paymentmode);
                const amount = parseFloat(item.amount);
                salesdata.push(amount);
                totalSales += amount;
            });

            $("#totalsalesplaceholder").text($.number(totalSales, 0));

            const options = {
                series: salesdata,
                labels: labels,
                chart: { type: 'donut', height: 260 },
                colors: [primaryColor, '#c64f00', '#28a745', '#ffc107', '#dc3545'],
                legend: { position: 'bottom', fontSize: '11px', fontFamily: 'Manrope', fontWeight: 600 },
                dataLabels: { enabled: true, style: { fontSize: '7px', fontFamily: 'Inter' }, formatter: (val) => val.toFixed(0) + "%" },
                plotOptions: { pie: { donut: { size: '50%' } } }
            };

            if (salesByPaymentModeChart) salesByPaymentModeChart.destroy();
            salesByPaymentModeChart = new ApexCharts(document.querySelector("#salesbypaymentmode-chart"), options);
            salesByPaymentModeChart.render();
        });
    }

    function getsalesbycustomercountInternal(rangeType) {
        $.getJSON("../controllers/reportoperations.php", {
            getsalesbycustomercount: true,
            startdate: startdate,
            enddate: enddate,
            range: rangeType
        }, function(data) {
            let labels = [], walkin = [], regular = [];
            data.forEach(item => {
                labels.push(item.transactiondate);
                walkin.push(parseInt(item.walkin));
                regular.push(parseInt(item.Regular || item.regular));
            });

            const options = {
                series: [
                    { name: 'Walk-in', data: walkin },
                    { name: 'Regular', data: regular }
                ],
                chart: { type: 'line', height: 260, toolbar: { show: false } },
                colors: ['#ba1a1a', primaryColor],
                stroke: { width: 2, dashArray: [4, 0] },
                dataLabels: { enabled: false },
                grid: { padding: { left: 0, right: 0, top: 0, bottom: 0 } },
                xaxis: { 
                    categories: labels, 
                    labels: { style: { fontSize: '7px', fontFamily: 'Inter' }, offsetY: -2 },
                    axisBorder: { show: false },
                    axisTicks: { show: false }
                },
                yaxis: { 
                    labels: { 
                        style: { fontSize: '7px', fontFamily: 'Inter' }, 
                        offsetX: -10,
                        formatter: val => formatKMB(val)
                    } 
                },
                legend: { position: 'bottom', fontSize: '11px', fontFamily: 'Manrope', fontWeight: 600 }
            };

            if (salesByCustomerCountChart) salesByCustomerCountChart.destroy();
            salesByCustomerCountChart = new ApexCharts(document.querySelector("#salesbycustomercount-chart"), options);
            salesByCustomerCountChart.render();
        });
    }

    function getsalesbyoutletInternal() {
        $.getJSON("../controllers/reportoperations.php", {
            getsalesbyoutlet: true,
            startdate: startdate,
            enddate: enddate
        }, function(data) {
            let html = '';
            const maxTotal = Math.max(...data.map(i => parseFloat(i.total)));

            data.forEach(item => {
                const percentage = (parseFloat(item.total) / maxTotal * 100).toFixed(0);
                html += `
                <div class="mb-2">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <span style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #717786;">${item.pointofsale}</span>
                        <span class="text-primary font-weight-bold" style="font-size: 11px;">${$.number(item.total, 2)}</span>
                    </div>
                    <div class="progress-slim" style="height: 6px; border-radius: 3px;">
                        <div class="h-100 progress-bar-primary transition-all duration-700" style="width: ${percentage}%"></div>
                    </div>
                </div>`;
            });
            $("#salesbyoutlet-container").html(html);
        });
    }

    function getsalesbysalespersonInternal() {
        $.getJSON("../controllers/reportoperations.php", {
            getsalesbysalesperson: true,
            startdate: startdate,
            enddate: enddate
        }, function(data) {
            let html = '';
            const maxTotal = Math.max(...data.map(i => parseFloat(i.total)));

            data.forEach(item => {
                const percentage = (parseFloat(item.total) / maxTotal * 100).toFixed(0);
                html += `
                <div class="col-12 col-md-6 col-lg-3 mb-1">
                    <div class="d-flex align-items-center mb-1">
                        <div class="bg-light rounded-circle d-flex align-items-center justify-content-center mr-2" style="width: 32px; height: 32px; color: #717786; border: 1px solid #eeeef0;">
                            <span class="material-symbols-outlined" style="font-size: 16px;">person</span>
                        </div>
                        <div>
                            <p class="mb-0 font-weight-bold text-dark" style="font-size: 13px;">${item.userfullname}</p>
                            <p class="mb-0 text-muted font-weight-bold text-uppercase" style="font-size: 10px; letter-spacing: 0.02em;">Sales Executive</p>
                        </div>
                    </div>
                    <div>
                        <div class="d-flex justify-content-between mb-1" style="font-size: 13px;">
                            <span class="font-weight-bold text-primary">${$.number(item.total, 2)}</span>
                            <span class="text-muted font-weight-bold" style="font-size: 10px;">${percentage}% Peak</span>
                        </div>
                        <div class="progress-slim" style="height: 6px;">
                            <div class="h-100 progress-bar-primary transition-all duration-700" style="width: ${percentage}%"></div>
                        </div>
                    </div>
                </div>`;
            });
            $("#salesbysalesperson-container").html(html);
        });
    }

    function populateCustomerPerformance() {
        $.getJSON("../controllers/reportoperations.php", {
            getcustomerperformance: true,
            startdate: startdate,
            enddate: enddate
        }, function(data) {
            let html = '';
            if (data && data.length > 0) {
                data.forEach(customer => {
                    html += `
                    <div class="col-12 col-md-6 col-lg-3 mb-1">
                        <div class="d-flex align-items-center mb-1">
                            <div class="rounded-circle d-flex align-items-center justify-content-center mr-2" style="width: 32px; height: 32px; background: #e3f2fd; color: #0059bb; border: 1px solid #bbdefb;">
                                <span class="material-symbols-outlined" style="font-size: 16px;">${customer.icon || 'person'}</span>
                            </div>
                            <div>
                                <p class="mb-0 font-weight-bold text-dark" style="font-size: 13px;">${customer.name}</p>
                                <p class="mb-0 text-muted font-weight-bold text-uppercase" style="font-size: 10px; letter-spacing: 0.02em;">${customer.type}</p>
                            </div>
                        </div>
                        <div>
                            <div class="d-flex justify-content-between mb-1" style="font-size: 13px;">
                                <span class="font-weight-bold" style="color: #c64f00;">${$.number(customer.revenue, 2)}</span>
                                <span class="text-muted font-weight-bold" style="font-size: 10px;">${customer.share}% Rev</span>
                            </div>
                            <div class="progress-slim" style="height: 6px;">
                                <div class="h-100 transition-all duration-700" style="width: ${customer.share}%; background: #c64f00;"></div>
                            </div>
                        </div>
                    </div>`;
                });
            } else {
                html = '<div class="col-12 text-center py-3 text-muted">No data available</div>';
            }
            $("#salesbycustomer-container").html(html);
        });
    }

    function getbestsellingproductInternal() {
        $.getJSON("../controllers/reportoperations.php", {
            getbestsellingproduct: true,
            startdate: startdate,
            enddate: enddate
        }, function(data) {
            let html = `
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Product Name</th>
                            <th class="text-right">Price</th>
                            <th class="text-right">Sold</th>
                            <th class="text-right">Total Value</th>
                        </tr>
                    </thead>
                    <tbody>`;
            
            data.forEach(item => {
                html += `
                    <tr>
                        <td class="font-weight-bold text-dark">${item.itemname}</td>
                        <td class="text-right text-muted">${$.number(item.unitprice, 0)}</td>
                        <td class="text-right font-weight-bold">${$.number(item.quantity, 0)}</td>
                        <td class="text-right font-weight-bold text-primary">${$.number(item.unitprice * item.quantity, 0)}</td>
                    </tr>`;
            });

            html += `</tbody></table>`;
            $("#bestsellingproduct-container").html(html);
        });
    }

    function getbestsellingcategoryInternal() {
        $.getJSON("../controllers/reportoperations.php", {
            getbestsellingcategory: true,
            startdate: startdate,
            enddate: enddate
        }, function(data) {
            let html = `
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th class="text-right">Avg Price</th>
                            <th class="text-right">Quantity</th>
                            <th class="text-right">Total Value</th>
                        </tr>
                    </thead>
                    <tbody>`;
            
            data.forEach(item => {
                html += `
                    <tr>
                        <td class="font-weight-bold text-dark">${item.categoryname}</td>
                        <td class="text-right text-muted">${$.number(item.unitprice, 0)}</td>
                        <td class="text-right font-weight-bold">${$.number(item.quantity, 0)}</td>
                        <td class="text-right font-weight-bold text-primary">${$.number(item.unitprice * item.quantity, 0)}</td>
                    </tr>`;
            });

            html += `</tbody></table>`;
            $("#bestsellingcategory-container").html(html);
        });
    }

    function populateReorderItems() {
        $.getJSON("../controllers/reportoperations.php", {
            getreorderitems: true
        }, function(data) {
            $("#reorderitemsplaceholder").text(data.length);
        });
    }

    function getsalesbycustomervalueInternal(rangeType) {
        $.getJSON("../controllers/reportoperations.php", {
            getsalesbycustomervalue: true,
            startdate: startdate,
            enddate: enddate,
            range: rangeType
        }, function(data) {
            let labels = [], walkin = [], regular = [];
            data.forEach(item => {
                labels.push(item.transactiondate);
                walkin.push(parseFloat(item.walkin));
                regular.push(parseFloat(item.regular || item.Regular));
            });

            const options = {
                series: [
                    { name: 'Walk-in Revenue', data: walkin },
                    { name: 'Regular Revenue', data: regular }
                ],
                chart: { type: 'area', height: 320, toolbar: { show: false } },
                colors: ['#94a3b8', primaryColor],
                stroke: { width: 2, curve: 'smooth' },
                dataLabels: { enabled: false },
                grid: { padding: { left: 0, right: 0, top: 0, bottom: 0 } },
                xaxis: { 
                    categories: labels, 
                    labels: { style: { fontSize: '7px', fontFamily: 'Inter', fontWeight: 500 }, offsetY: -2 },
                    axisBorder: { show: false },
                    axisTicks: { show: false }
                },
                yaxis: { 
                    labels: { 
                        style: { fontSize: '7px', fontFamily: 'Inter' }, 
                        offsetX: -10, 
                        formatter: val => formatKMB(val) 
                    } 
                },
                legend: { position: 'bottom', fontSize: '11px', fontFamily: 'Manrope', fontWeight: 600 }
            };

            if (salesByCustomerValueChart) salesByCustomerValueChart.destroy();
            salesByCustomerValueChart = new ApexCharts(document.querySelector("#salesbycustomervalue-chart"), options);
            salesByCustomerValueChart.render();
        });
    }
});
