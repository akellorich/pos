$(document).ready(function () {
    // get POS
    const startdatefield = $("#startdate"),
        searchbutton = $("#search"),
        report = $("#report"),
        errordiv = $("#errors"),
        stocklistreport = $("#stocklistreport")

    // assign date picker to date fields
    startdatefield.datepicker({ dateFormat: 'dd-M-yy' })

    // Reload the stocksheet when toggle switch state changes
    $("#omit_zero").on("change", function () {
        console.log("Omit Zero Quantity switch toggled. Checked prop:", $(this).prop("checked"));
        searchbutton.trigger("click");
    });

    searchbutton.on("click", function () {
        var errors = ''
        if (startdatefield.val() == "") {
            errors = "Please provide As At date"
            errordiv.html(showAlert("info", errors))
        } else {
            errordiv.html("")
            $.getJSON(
                "../controllers/reportoperations.php",
                {
                    asatdate: startdatefield.val(),
                    getstocksheet: true
                },
                function (data) {
                    if (data && data.length > 0) {
                        let filteredData = data;
                        let isFilterChecked = $("#omit_zero").prop("checked");
                        console.log("API returned items count:", data.length);
                        console.log("Is Filter Checked (prop):", isFilterChecked);

                        // Safe numeric conversion: strip commas and check if the total quantity is exactly 0
                        if (isFilterChecked) {
                            filteredData = data.filter(item => {
                                let qty = parseDbNumber(item["Total Quantity"]);
                                return qty !== 0;
                            });
                        }
                        console.log("Filtered items count to render:", filteredData);

                        if (filteredData.length > 0) {
                            populateStocklistTable(stocklistreport, filteredData);
                        } else {
                            errordiv.html(showAlert("info", "Sorry no records matching filter options found"))
                            stocklistreport.find("tbody").html("<tr><td colspan='5' class='text-center text-muted py-3'>No records matching filter options found</td></tr>");
                            stocklistreport.find("tfoot").html("")
                            if ($.fn.DataTable.isDataTable(stocklistreport)) {
                                stocklistreport.DataTable().clear().draw();
                            }
                        }
                    } else {
                        errordiv.html(showAlert("info", "Sorry no records matching filter options found"))
                        stocklistreport.find("tbody").html("")
                        stocklistreport.find("tfoot").html("")
                        if ($.fn.DataTable.isDataTable(stocklistreport)) {
                            stocklistreport.DataTable().clear().draw();
                        }
                    }
                }
            ).fail(function () {
                errordiv.html(showAlert("danger", "Failed to fetch stock sheet data from server."))
            })
        }
    })

    // Safe utility to strip commas and return a valid clean number
    function parseDbNumber(val) {
        if (val === null || val === undefined) return 0;
        let clean = String(val).replace(/,/g, "").trim();
        let num = Number(clean);
        return isNaN(num) ? 0 : num;
    }

    function populateStocklistTable(tablename, data, pagelength = 15) {
        if (data.length > 0) {
            // ALWAYS destroy the existing DataTable instance first before modifying table structure!
            if ($.fn.DataTable.isDataTable(tablename)) {
                tablename.DataTable().destroy();
                tablename.empty(); // Safely clear out elements to build from scratch
            }

            // Dynamically discover all warehouse/location keys returned from stored procedure
            let locationKeys = [];
            let firstItem = data[0];
            Object.keys(firstItem).forEach(key => {
                if (key !== "categoryname" && key !== "itemcode" && key !== "itemname" && 
                    key !== "Total Quantity" && key !== "Total Purchase" && key !== "Total Selling") {
                    locationKeys.push(key);
                }
            });

            // Build dynamic headers with responsive priority
            let headers = "<tr>" +
                "<th data-priority='1'>Item Code</th>" +
                "<th data-priority='2'>Item Name</th>";
            
            locationKeys.forEach(loc => {
                headers += `<th class='text-right' data-priority='6'>${loc}</th>`;
            });

            headers += "<th class='text-right' data-priority='3'>Total Quantity</th>" +
                "<th class='text-right' data-priority='4'>Total Purchase</th>" +
                "<th class='text-right' data-priority='5'>Total Selling</th>" +
                "</tr>";
            
            // Build the containers if they were emptied
            if (tablename.find("thead").length === 0) tablename.append("<thead></thead>");
            if (tablename.find("tbody").length === 0) tablename.append("<tbody></tbody>");
            if (tablename.find("tfoot").length === 0) tablename.append("<tfoot></tfoot>");

            tablename.find("thead").html(headers);

            // Populate table body rows
            let details = "";
            data.forEach(item => {
                let code = item.itemcode || "";
                let name = item.itemname || "";
                let qty = parseDbNumber(item["Total Quantity"]);
                let purchase = parseDbNumber(item["Total Purchase"]);
                let selling = parseDbNumber(item["Total Selling"]);

                details += `<tr>
                    <td>${code}</td>
                    <td>${name}</td>`;

                // Add individual warehouse quantities
                locationKeys.forEach(loc => {
                    let locQty = parseDbNumber(item[loc]);
                    details += `<td class="text-right">${$.number(locQty, 2)}</td>`;
                });

                details += `<td class="text-right">${$.number(qty, 2)}</td>
                    <td class="text-right">${$.number(purchase, 2)}</td>
                    <td class="text-right">${$.number(selling, 2)}</td>
                </tr>`;
            });
            tablename.find("tbody").html(details);

            // Sum totals
            let locationTotals = {};
            locationKeys.forEach(loc => {
                locationTotals[loc] = 0;
            });

            let totalQty = 0, totalPurchase = 0, totalSelling = 0;
            data.forEach(item => {
                locationKeys.forEach(loc => {
                    locationTotals[loc] += parseDbNumber(item[loc]);
                });
                totalQty += parseDbNumber(item["Total Quantity"]);
                totalPurchase += parseDbNumber(item["Total Purchase"]);
                totalSelling += parseDbNumber(item["Total Selling"]);
            });

            // Build dynamic footer totals row
            let totals = `<tr>
                <th><strong>TOTALS:</strong></th>
                <th></th>`;

            locationKeys.forEach(loc => {
                totals += `<th class="text-right"><strong>${$.number(locationTotals[loc], 2)}</strong></th>`;
            });

            totals += `<th class="text-right"><strong>${$.number(totalQty, 2)}</strong></th>
                <th class="text-right"><strong>${$.number(totalPurchase, 2)}</strong></th>
                <th class="text-right"><strong>${$.number(totalSelling, 2)}</strong></th>
            </tr>`;
            tablename.find("tfoot").html(totals);

            // Initialize DataTable with sorting and responsiveness but keep the totals row fixed at the bottom
            tablename.DataTable({
                responsive: true,
                dom: '<"dt-buttons-container mb-3"B><"dt-controls-container d-flex flex-column flex-sm-row justify-content-between align-items-sm-center mb-3"lf>rtip',
                "lengthMenu": [[10, 15, 25, 50, 100, -1], [10, 15, 25, 50, 100, "All"]],
                "pageLength": pagelength,
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fal fa-file-excel mr-1"></i> Excel',
                        className: 'btn btn-xs btn-success mr-2'
                    },
                    {
                        extend: 'csvHtml5',
                        text: '<i class="fal fa-file-csv mr-1"></i> CSV',
                        className: 'btn btn-xs btn-primary mr-2'
                    },
                    {
                        extend: 'pdfHtml5',
                        text: '<i class="fal fa-file-pdf mr-1"></i> PDF',
                        className: 'btn btn-xs btn-danger mr-2'
                    },
                    {
                        extend: 'print',
                        text: '<i class="fal fa-print mr-1"></i> Printer',
                        className: 'btn btn-xs btn-info'
                    }
                ],
                orderCellsTop: true, // Ensures sorting applies only to the header
                drawCallback: function () {
                    let api = this.api();
                    let totalsRow = tablename.find("tfoot tr").detach();
                    tablename.find("tfoot").append(totalsRow); // Reappend totals row after sorting
                }
            });
        }
    }

    // Generate formatted today's date for 'dd-M-yy' format (e.g., 31-May-2026)
    function getFormattedToday() {
        const date = new Date();
        const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        const day = String(date.getDate()).padStart(2, '0');
        const month = months[date.getMonth()];
        const year = date.getFullYear();
        return `${day}-${month}-${year}`;
    }

    // Populate current date and trigger auto-generation on page load
    startdatefield.val(getFormattedToday());
    searchbutton.trigger("click");
})