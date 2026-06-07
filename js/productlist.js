$(document).ready(function(){
    const addproduct=$("#addproduct, #addproduct_fab"),
        goback=$("#goback"),
        productlist=$("#productlist"),
        productstable=$("#productstable"),
        errordiv=$("#errors")

    $.getJSON(
        "../controllers/productoperations.php",
        {
            filterproductbyname:true,
            name:''
        },
        function(data){
            var results=''
            for (var i = 0; i < data.length; i++) {
                var addedby = data[i].addedbyname || "System";
                results+=`<tr><td>${parseInt(i+1)}</td>`
                results+=`<td class="d-none d-lg-table-cell">${data[i].categoryname}</td>`
                results+=`<td>${data[i].itemcode}</td>`
                results+=`<td>${data[i].itemname}</td>`
                results+=`<td class="d-none d-md-table-cell">${$.number(data[i].buyingprice)}</td>`
                results+=`<td>${$.number(data[i].sellingprice,2)}</td>`
                results+=`<td class="d-none d-md-table-cell">${$.number(data[i].wholesaleprice,2)}</td>`
                results+=`<td class="d-none d-lg-table-cell">${data[i].dateadded}</td>`
                results+=`<td class="d-none d-lg-table-cell">${addedby}</td>`
                results+=`<td class='text-right' style='padding-right: 20px;'>`
                results+=`<div class='dropdown'>`
                results+=`<a class='text-secondary px-2 dropdown-toggle dropdown-toggle-nocaret' href='#' role='button' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false' style='cursor: pointer; display: inline-block; padding: 4px 8px;'>`
                results+=`<i class='fal fa-ellipsis-v' style='font-size: 1.3rem;'></i>`
                results+=`</a>`
                results+=`<div class='dropdown-menu dropdown-menu-right shadow-sm'>`
                results+=`<a class='dropdown-item py-1' href='productdetails.php?itemcode=${data[i].itemcode}' style='font-size:0.8rem;'><i class='fal fa-edit mr-2 text-primary' style='font-size: 0.78rem;'></i>Edit</a>`
                results+=`<a class='dropdown-item delete py-1' href='#' data-id='${data[i].productid}' style='font-size:0.8rem;'><i class='fal fa-trash-alt mr-2 text-danger' style='font-size: 0.78rem;'></i>Delete</a>`
                results+=`</div>`
                results+=`</div>`
                results+=`</td>`
                results+=`</tr>`
            } 
            
            if ($.fn.dataTable.isDataTable(productstable)) {
                productstable.DataTable().clear().destroy();
            }
            productlist.empty();
            $(results).appendTo(productlist);

            var windowHeight = $(window).height();
            var defaultPageLength = 15;
            if (windowHeight < 600) {
                defaultPageLength = 10;
            } else if (windowHeight < 800) {
                defaultPageLength = 15;
            } else if (windowHeight < 1000) {
                defaultPageLength = 20;
            } else {
                defaultPageLength = 25;
            }

            var lengthMenuValues = [10, 15, 20, 25, 50, 100];
            if (lengthMenuValues.indexOf(defaultPageLength) === -1) {
                lengthMenuValues.push(defaultPageLength);
                lengthMenuValues.sort(function(a, b){ return a - b; });
            }
            var lengthMenuLabels = lengthMenuValues.slice();
            lengthMenuValues.push(-1);
            lengthMenuLabels.push("All");

            productstable.DataTable({
                "autoWidth": false,
                "lengthMenu": [lengthMenuValues, lengthMenuLabels],
                "pageLength": defaultPageLength,
                dom: '<"dt-buttons-container mb-3"B><"dt-controls-container d-flex flex-column flex-sm-row justify-content-between align-items-sm-center mb-3"lf>rtip',
                buttons: [
                    {
                        extend: 'csvHtml5',
                        text: '<i class="fal fa-file-csv mr-1"></i> CSV',
                        className: 'btn btn-xs btn-primary mr-2'
                    },
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fal fa-file-excel mr-1"></i> Excel',
                        className: 'btn btn-xs btn-success mr-2'
                    },
                    {
                        extend: 'pdfHtml5',
                        text: '<i class="fal fa-file-pdf mr-1"></i> PDF',
                        className: 'btn btn-xs btn-danger mr-2'
                    },
                    {
                        extend: 'print',
                        text: '<i class="fal fa-print mr-1"></i> Print',
                        className: 'btn btn-xs btn-info'
                    }
                ]
            });
        }
    )

    addproduct.on("click",function(){
        window.location.href="productdetails.php"
    })

    if (goback.length) {
        goback.on("click",function(){
            window.location.href="main.php"
        })
    }
    
    // listen to delete button
    productlist.on("click",".delete",function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var parent = $(this).closest("tr");
        var itemname=parent.find("td").eq(3).text()
        
        // Check if the product has transactions before attempting deletion
        $.post(
            "../controllers/productoperations.php",
            {
                checktransactions: true,
                productid: id
            },
            function(checkData) {
                if ($.trim(checkData.toString()) === "has_transactions") {
                    // Fetch list of products to populate merge targets
                    $.getJSON(
                        "../controllers/productoperations.php",
                        {
                            filterproductbyname: true,
                            name: ''
                        },
                        function(products) {
                            var options = '<option value="">-- Select Product to Merge With --</option>';
                            for (var i = 0; i < products.length; i++) {
                                if (products[i].productid != id) {
                                    options += `<option value="${products[i].productid}">${products[i].itemname} (${products[i].itemcode})</option>`;
                                }
                            }
                            
                            var formHtml = `
                                <div class="form-group mb-0">
                                    <label class="font-weight-bold">Merge transactions into:</label>
                                    <select id="merge_target_id" class="form-control">
                                        ${options}
                                    </select>
                                </div>
                            `;
                            
                            bootbox.dialog({
                                title: `Merge & Delete <strong>${itemname}</strong>`,
                                message: `<p class="alert alert-warning py-2 small mb-3"><i class="fal fa-exclamation-triangle mr-2"></i>This product has active transactions (sales, purchases, stock sheets, transfers, etc.) and cannot be deleted directly.</p>` + formHtml,
                                buttons: {
                                    cancel: {
                                        label: "Cancel",
                                        className: "btn-secondary btn-sm",
                                        callback: function() {
                                            $('.bootbox').modal('hide');
                                        }
                                    },
                                    success: {
                                        label: "Merge & Delete",
                                        className: "btn-danger btn-sm",
                                        callback: function() {
                                            var targetId = $('#merge_target_id').val();
                                            if (!targetId) {
                                                errordiv.html(showAlert("info", "Please select a target product to merge transactions with."));
                                                return false; // keeps modal open
                                            }
                                            
                                            $.post(
                                                "../controllers/productoperations.php",
                                                {
                                                    mergeanddelete: true,
                                                    sourceid: id,
                                                    targetid: targetId
                                                },
                                                function(mergeResult) {
                                                    if ($.trim(mergeResult.toString()) === "success") {
                                                        var successMsg = showAlert("success", "Product merged and deleted successfully.");
                                                        parent.remove();
                                                        errordiv.html(successMsg);
                                                    } else {
                                                        var errorMsg = showAlert("danger", "Error: " + mergeResult.toString());
                                                        errordiv.html(errorMsg);
                                                    }
                                                }
                                            );
                                            $('.bootbox').modal('hide');
                                        }
                                    }
                                }
                            });
                        }
                    );
                } else {
                    // No transactions: proceed with normal delete dialog
                    bootbox.dialog({
                        message: "Are you sure you want to DELETE <strong>"+itemname+"</strong>?",
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
                                    $.post(
                                        "../controllers/productoperations.php",
                                        {
                                            deleteproduct:true,
                                            productid:id
                                        },
                                        function(data){
                                            if($.trim(data.toString())=="The product has been deleted successfully." || $.trim(data.toString())=="success"){
                                                errors=showAlert("success", "The product has been deleted successfully.");
                                                parent.remove()
                                            }else{
                                                errors=showAlert("danger", data.toString());
                                            }
                                            errordiv.html(errors)
                                        }
                                    )
                                    $('.bootbox').modal('hide');
                                }
                            }
                        }
                    });
                }
            }
        );
    })

    // --- Bulk Import System ---
    let parsedProducts = [];

    // Trigger Import Modal
    $("#btnImportProducts").on("click", function() {
        resetImportForm();
        $("#importModal").modal("show");
    });

    // Toggle Category Input Mode
    $('input[name="categoryMode"]').on("change", function() {
        if ($(this).val() === "specific") {
            $("#importCategorySelect").fadeIn(200);
            loadImportCategories();
        } else {
            $("#importCategorySelect").fadeOut(200);
        }
    });

    // Toggle Opening Balance Section
    $("#chkImportOpeningBalance").on("change", function() {
        if ($(this).is(":checked")) {
            $("#openingBalanceSection").slideDown(250);
            loadImportLocations($("#importBalanceCategory").val());
        } else {
            $("#openingBalanceSection").slideUp(250);
        }
    });

    // Toggle Balance Location Type
    $("#importBalanceCategory").on("change", function() {
        loadImportLocations($(this).val());
    });

    // Handle File Selection and Parsing
    $("#importExcelFile").on("change", function(e) {
        const file = e.target.files[0];
        if (!file) return;

        // Update custom file label
        $(this).next(".custom-file-label").text(file.name);

        // Show parsing status
        $("#previewEmptyState").html(`
            <div class="text-center text-muted p-4">
                <i class="fal fa-spinner fa-spin fa-3x mb-3 text-primary"></i>
                <p class="mb-0 small">Reading and parsing file data, please wait...</p>
            </div>
        `).addClass("d-flex").removeClass("d-none");
        $("#previewTableContainer").hide();
        $("#btnDoImport").prop("disabled", true);

        const reader = new FileReader();
        reader.onload = function(evt) {
            try {
                const data = evt.target.result;
                const workbook = XLSX.read(data, { type: 'binary' });
                const firstSheetName = workbook.SheetNames[0];
                const worksheet = workbook.Sheets[firstSheetName];
                const jsonData = XLSX.utils.sheet_to_json(worksheet);

                renderPreviewTable(jsonData);
            } catch (error) {
                bootbox.alert({
                    title: "Parsing Failed",
                    message: `<div class="alert alert-danger py-2 small mb-0"><i class="fal fa-times-circle mr-2"></i>Could not read the selected file. Details: ${error.message}</div>`,
                    buttons: { ok: { label: 'OK', className: 'btn-danger btn-sm' } }
                });
                resetImportForm();
            }
        };
        reader.onerror = function() {
            bootbox.alert("Error reading file.");
            resetImportForm();
        };
        reader.readAsBinaryString(file);
    });

    // Render preview table in modal
    function renderPreviewTable(data) {
        parsedProducts = data;
        const tbody = $("#previewTableBody");
        tbody.empty();

        if (!data || data.length === 0) {
            $("#previewEmptyState").html(`
                <div class="text-center text-muted p-4">
                    <i class="fal fa-exclamation-circle fa-3x mb-3 text-warning"></i>
                    <p class="mb-0 small">The file is empty or contains no readable rows.</p>
                </div>
            `).addClass("d-flex").removeClass("d-none");
            $("#previewTableContainer").hide();
            $("#btnDoImport").prop("disabled", true);
            $("#previewRowCount").text("0 rows loaded");
            return;
        }

        data.forEach((row, index) => {
            const itemcode = row['Item Code'] || '';
            const itemname = row['Item Name'] || '';
            const category = row['Category Name'] || '';
            const uom = row['UOM'] || 'PCS';
            const buyPrice = row['Buying Price'] || 0;
            const retailPrice = row['Retail Price'] || 0;
            const opBal = row['Opening Balance'] || 0;

            const tr = $("<tr>");
            tr.append($("<td>").text(index + 1));
            tr.append($("<td>").text(itemcode));
            tr.append($("<td>").text(itemname).addClass(itemname ? "" : "text-danger font-italic").html(itemname ? itemname : "Missing Name"));
            tr.append($("<td>").text(category));
            tr.append($("<td>").text(uom));
            tr.append($("<td>").addClass("text-right").text($.number(buyPrice, 2)));
            tr.append($("<td>").addClass("text-right").text($.number(retailPrice, 2)));
            tr.append($("<td>").addClass("text-right").text(opBal));

            // Delete action
            const btnDelete = $("<button>")
                .addClass("btn btn-link text-danger p-0 border-0")
                .html('<i class="fal fa-trash-alt" style="font-size: 0.82rem;"></i>')
                .attr("title", "Remove row")
                .on("click", function() {
                    parsedProducts.splice(index, 1);
                    renderPreviewTable(parsedProducts);
                });
            tr.append($("<td>").addClass("text-center").append(btnDelete));

            tbody.append(tr);
        });

        $("#previewEmptyState").addClass("d-none").removeClass("d-flex");
        $("#previewTableContainer").show();
        $("#btnDoImport").prop("disabled", false);
        $("#previewRowCount").text(`${data.length} rows loaded`);
    }

    // Load Category options for specific assignment
    function loadImportCategories() {
        $.getJSON("../controllers/categoryoperations.php", { getcategories: true }, function(data) {
            let options = '<option value="">&lt;Select Category&gt;</option>';
            data.forEach(cat => {
                options += `<option value="${cat.categoryid}">${cat.categoryname}</option>`;
            });
            $("#importCategorySelect").html(options);
        });
    }

    // Load locations based on selected stock category (outlet vs warehouse)
    function loadImportLocations(type) {
        const select = $("#importBalanceLocation");
        select.html('<option value="">Loading locations...</option>');
        if (type === 'outlet') {
            getPointsOfSale(select, 'choose');
        } else {
            getwarehouses(select, 'choose');
        }
    }

    // Download Import Template CSV
    $("#btnDownloadTemplate").on("click", function(e) {
        e.preventDefault();
        const headers = [
            "Item Code",
            "Item Name",
            "Category Name",
            "UOM",
            "Buying Price",
            "Retail Price",
            "Wholesale Price",
            "Reorder Level",
            "Opening Balance",
            "Unit Cost"
        ];
        
        const sampleRows = [
            ["PROD1001", "Premium Motor Oil 5W-30", "Lubricants", "Litre", "250.00", "350.00", "320.00", "10", "45", "250.00"],
            ["", "Spark Plug A7TC", "Engine Parts", "PCS", "80.00", "120.00", "100.00", "50", "200", "80.00"],
            ["PROD1002", "Brake Pad Front Set", "Brakes", "Set", "1200.00", "1600.00", "1450.00", "5", "0", "0.00"]
        ];

        let csvContent = "\uFEFF"; // UTF-8 BOM
        csvContent += headers.join(",") + "\r\n";
        sampleRows.forEach(row => {
            csvContent += row.map(val => `"${val.toString().replace(/"/g, '""')}"`).join(",") + "\r\n";
        });

        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement("a");
        const url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        link.setAttribute("download", "salesflow_products_template.csv");
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    });

    // Start products import
    $("#btnDoImport").on("click", function() {
        const categoryMode = $('input[name="categoryMode"]:checked').val();
        const specificCategoryId = $("#importCategorySelect").val();

        if (categoryMode === "specific" && !specificCategoryId) {
            bootbox.alert({
                title: "Validation Error",
                message: "Please select a specific category.",
                buttons: { ok: { label: 'OK', className: 'btn-warning btn-sm' } }
            });
            return;
        }

        const importOpeningBalance = $("#chkImportOpeningBalance").is(":checked") ? 1 : 0;
        const balanceCategory = $("#importBalanceCategory").val();
        const balanceLocation = $("#importBalanceLocation").val();
        const autoReconcile = $("#chkAutoReconcile").is(":checked") ? 1 : 0;

        if (importOpeningBalance && !balanceLocation) {
            bootbox.alert({
                title: "Validation Error",
                message: "Please choose a store/location for the opening balance.",
                buttons: { ok: { label: 'OK', className: 'btn-warning btn-sm' } }
            });
            return;
        }

        const checkExists = $("#chkCheckExists").is(":checked") ? 1 : 0;
        const generateCode = $("#chkGenerateCode").is(":checked") ? 1 : 0;

        // Sanitize: replace single quotes with two single quotes in text fields
        // to prevent SQL errors from apostrophes (e.g. "O'Brien's Oil")
        const sanitizeQuotes = (val) => (val ? String(val).replace(/'/g, "''") : val);
        const sanitizedProducts = parsedProducts.map(row => {
            const clean = Object.assign({}, row);
            if (clean['Item Name']    !== undefined) clean['Item Name']    = sanitizeQuotes(clean['Item Name']);
            if (clean['Category Name']!== undefined) clean['Category Name']= sanitizeQuotes(clean['Category Name']);
            if (clean['Item Code']    !== undefined) clean['Item Code']    = sanitizeQuotes(clean['Item Code']);
            if (clean['UOM']          !== undefined) clean['UOM']          = sanitizeQuotes(clean['UOM']);
            return clean;
        });

        // Disable buttons & show progress
        $("#btnDoImport").prop("disabled", true).html('<i class="fal fa-spinner fa-spin mr-1" style="font-size: 0.82rem;"></i> Importing...');
        $("#importProgressContainer").show();
        $("#importProgressBar").css("width", "5%").removeClass("bg-danger").addClass("bg-success");
        $("#importProgressPercent").text("5%");
        $("#importStatusText").text("Uploading data...");

        // Simulate smooth progress: crawl from 5% → 90% while waiting for server
        let simProgress = 5;
        const progressMessages = [
            { at: 20, msg: "Uploading data..." },
            { at: 45, msg: "Validating rows..." },
            { at: 65, msg: "Saving products..." },
            { at: 80, msg: "Finalising import..." },
            { at: 88, msg: "Almost done..." }
        ];
        const progressTimer = setInterval(function() {
            if (simProgress < 90) {
                // Decelerate as we approach 90%
                const step = Math.max(0.3, (90 - simProgress) * 0.04);
                simProgress = Math.min(90, simProgress + step);
                const pct = Math.floor(simProgress);
                $("#importProgressBar").css("width", pct + "%");
                $("#importProgressPercent").text(pct + "%");
                // Update status label at milestones
                progressMessages.forEach(function(m) {
                    if (pct >= m.at && $("#importStatusText").text() !== m.msg) {
                        $("#importStatusText").text(m.msg);
                    }
                });
            }
        }, 120);

        $.post(
            "../controllers/productoperations.php",
            {
                importproducts: true,
                products: JSON.stringify(sanitizedProducts),
                categoryMode: categoryMode,
                specificCategoryId: specificCategoryId,
                checkExists: checkExists,
                generateCode: generateCode,
                importOpeningBalance: importOpeningBalance,
                balanceCategory: balanceCategory,
                balanceLocation: balanceLocation,
                autoReconcile: autoReconcile
            },
            function(response) {
                clearInterval(progressTimer);
                $("#importProgressBar").css("width", "100%");
                $("#importProgressPercent").text("100%");
                $("#importStatusText").text("Processing complete.");

                try {
                    const res = JSON.parse(response);

                    // Hide preview table, show results inline
                    $("#previewTableContainer").hide();
                    $("#previewEmptyState").addClass("d-none").removeClass("d-flex");

                    if (res.status === "success") {
                        $("#importProgressBar").removeClass("bg-danger");
                        let errHtml = "";
                        if (res.errors && res.errors.length > 0) {
                            errHtml = `
                                <p class="font-weight-bold text-danger mb-1 small mt-3">
                                    <i class="fal fa-exclamation-circle mr-1"></i> Errors encountered:
                                </p>
                                <div class="bg-light border rounded p-2 small" style="max-height:160px; overflow-y:auto; font-family:monospace;">
                                    ${res.errors.map(e => `<div class="text-danger mb-1">${e}</div>`).join('')}
                                </div>`;
                        }

                        $("#importResultsContainer").html(`
                            <div class="p-3 border rounded bg-white h-100 d-flex flex-column">
                                ${showAlert("success", "Import completed successfully!")}
                                <table class="table table-bordered table-sm small mb-0">
                                    <tr>
                                        <td>Products Imported</td>
                                        <td class="font-weight-bold text-success text-right">${res.imported}</td>
                                    </tr>
                                    <tr>
                                        <td>Rows Skipped / Duplicates</td>
                                        <td class="font-weight-bold text-muted text-right">${res.skipped}</td>
                                    </tr>
                                </table>
                                ${errHtml}
                                <div class="mt-auto pt-3">
                                    <button type="button" class="btn btn-success btn-sm" id="btnReloadAfterImport">
                                        <i class="fal fa-sync mr-1" style="font-size: 0.8rem;"></i> Done — Reload Products
                                    </button>
                                </div>
                            </div>
                        `).show();

                        // Reload on Done click
                        $(document).one("click", "#btnReloadAfterImport", function() {
                            location.reload();
                        });

                        // Update modal header to reflect completion
                        $("#importModalLabel").html('<i class="fal fa-check-circle text-success mr-2" style="font-size:1.25rem;"></i> Import Report');
                        // Disable close via X until user clicks Done
                        $("#importModal .close").hide();
                        // Restore Start Import button state
                        resetImportProgress();

                    } else {
                        $("#importProgressBar").addClass("bg-danger").removeClass("bg-success");
                        $("#importProgressPercent").text("Failed");
                        $("#importStatusText").text("Import failed.");

                        $("#importResultsContainer").html(`
                            <div class="alert alert-danger py-3 small mb-0">
                                <p class="font-weight-bold mb-1"><i class="fal fa-times-circle mr-2"></i> Import Error</p>
                                <p class="mb-0">${res.message || "An unexpected error occurred."}</p>
                            </div>
                        `).show();

                        resetImportProgress();
                    }

                } catch(e) {
                    $("#importProgressBar").addClass("bg-danger").removeClass("bg-success");
                    $("#importProgressPercent").text("Error");
                    $("#importStatusText").text("Server response error.");

                    $("#importResultsContainer").html(`
                        <div class="alert alert-danger py-3 small mb-0">
                            <p class="font-weight-bold mb-1"><i class="fal fa-bug mr-2"></i> Parse Error</p>
                            <p class="mb-1">Failed to read server response.</p>
                            <pre class="bg-dark text-white p-2 small mt-2 rounded" style="max-height:100px; overflow-y:auto;">${response}</pre>
                        </div>
                    `).show();

                    resetImportProgress();
                }
            }
        ).fail(function() {
            clearInterval(progressTimer);
            $("#importProgressBar").addClass("bg-danger").removeClass("bg-success");
            $("#importStatusText").text("Network error.");

            $("#importResultsContainer").html(`
                <div class="alert alert-danger py-3 small mb-0">
                    <i class="fal fa-wifi-slash mr-2"></i> Failed to reach the server. Please check your connection and try again.
                </div>
            `).show();

            resetImportProgress();
        });
    });

    // Reset import modal form to empty state
    function resetImportForm() {
        parsedProducts = [];
        $("#importExcelFile").val("").next(".custom-file-label").text("Choose file...");
        $("#catModeDynamic").prop("checked", true);
        $("#importCategorySelect").val("").hide();
        $("#chkCheckExists").prop("checked", true);
        $("#chkGenerateCode").prop("checked", false);
        $("#chkImportOpeningBalance").prop("checked", false);
        $("#openingBalanceSection").hide();
        $("#importBalanceCategory").val("outlet");
        $("#importBalanceLocation").html('<option value="">&lt;Choose Location&gt;</option>');
        $("#chkAutoReconcile").prop("checked", true);
        
        $("#previewEmptyState").html(`
            <div class="text-center text-muted p-4">
                <i class="fal fa-file-excel fa-3x mb-3 text-secondary" style="font-size: 3rem;"></i>
                <p class="mb-0 small">Choose an Excel/CSV file to load the data preview here.</p>
            </div>
        `).addClass("d-flex").removeClass("d-none");
        $("#previewTableContainer").hide();
        $("#previewRowCount").text("0 rows loaded");

        // Clear inline results panel
        $("#importResultsContainer").hide().empty();

        // Restore modal header and close button
        $("#importModalLabel").html('<i class="fal fa-file-import text-primary mr-2" style="font-size: 1.25rem;"></i> Bulk Product Import');
        $("#importModal .close").show();
        
        resetImportProgress();
    }

    function resetImportProgress() {
        $("#btnDoImport").prop("disabled", parsedProducts.length === 0).html('<i class="fal fa-file-import mr-1" style="font-size: 0.82rem;"></i> Start Import');
        $("#importProgressContainer").hide();
        $("#importProgressBar").css("width", "0%");
        $("#importProgressPercent").text("0%");
        $("#importStatusText").text("");
    }
})