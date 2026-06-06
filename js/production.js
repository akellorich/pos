$(document).ready(function () {
    // Form and table fields
    const alldates = $("#alldates");
    const startdatefield = $("#startdate");
    const enddatefield = $("#enddate");
    const filterwarehouse = $("#filterwarehouse");
    const filterproduct = $("#filterproduct");
    const btnfilter = $("#btnfilter");

    const btnaddproduction = $("#btnaddproduction");
    const mobileAddProductionFAB = $("#mobileAddProductionFAB");
    const productionmodal = $("#productionmodal");
    const btnsaveproduction = $("#btnsaveproduction");

    // Modal fields
    const modaltitle = $("#modaltitle");
    const productionid = $("#productionid");
    const productiondate = $("#productiondate");
    const modalproduct = $("#modalproduct");
    const quantity = $("#quantity");
    const uom = $("#uom");
    const warehouse = $("#warehouse");
    const modalnotifications = $("#modalnotifications");

    const productiontable = $("#productiontable");
    const productiontablebody = $("#productiontable tbody");
    const productionlistnotifications = $("#productionlistnotifications");

    // Initialize datepickers
    startdatefield.datepicker({ dateFormat: 'dd-M-yy' });
    enddatefield.datepicker({ dateFormat: 'dd-M-yy' });
    productiondate.datepicker({ dateFormat: 'dd-M-yy' });

    // Setup date defaults
    const today = new Date();
    const formattedToday = $.datepicker.formatDate('dd-M-yy', today);
    startdatefield.val(formattedToday);
    enddatefield.val(formattedToday);
    productiondate.val(formattedToday);

    alldates.prop("checked", true);
    startdatefield.prop("disabled", true);
    enddatefield.prop("disabled", true);

    // Toggle date filter inputs
    alldates.on("click", function () {
        const checked = alldates.prop("checked");
        startdatefield.prop("disabled", checked);
        enddatefield.prop("disabled", checked);
    });

    // Load Warehouses
    $.getJSON("../controllers/warehouseoperations.php", { getwarehouses: 1 }, function (data) {
        let filterHtml = '<option value="0">All Warehouses</option>';
        let modalHtml = '<option value="">Select a warehouse...</option>';
        for (let i = 0; i < data.length; i++) {
            filterHtml += `<option value="${data[i].id}">${data[i].description}</option>`;
            modalHtml += `<option value="${data[i].id}">${data[i].description}</option>`;
        }
        filterwarehouse.html(filterHtml);
        warehouse.html(modalHtml);
    });

    // Load Products with Recipes
    function loadProductsWithRecipes() {
        return $.getJSON("../controllers/productionoperations.php", { getproductswithrecipes: 1 }, function (data) {
            let filterHtml = '<option value="0">All Products</option>';
            let modalHtml = '<option value="">Select a product...</option>';
            for (let i = 0; i < data.length; i++) {
                filterHtml += `<option value="${data[i].productid}">${data[i].itemname} (${data[i].itemcode})</option>`;
                modalHtml += `<option value="${data[i].productid}" data-uom="${data[i].uom || ''}">${data[i].itemname} (${data[i].itemcode})</option>`;
            }
            filterproduct.html(filterHtml);
            modalproduct.html(modalHtml);
        });
    }

    // Modal Product Selection Change
    modalproduct.on("change", function () {
        const selectedOption = $(this).find("option:selected");
        const uomVal = selectedOption.attr("data-uom") || "";
        uom.val(uomVal);
    });

    // Open Modal for adding production
    function openAddModal() {
        modaltitle.text("Add Production Record");
        productionid.val("0");
        productiondate.val(formattedToday);
        modalproduct.val("");
        uom.val("");
        quantity.val("");
        modalnotifications.html("");
        productionmodal.modal("show");
    }

    btnaddproduction.on("click", openAddModal);
    mobileAddProductionFAB.on("click", openAddModal);

    // Filter list
    btnfilter.on("click", function () {
        refreshProductionList();
    });

    // Save production
    btnsaveproduction.on("click", function (e) {
        e.preventDefault();
        modalnotifications.html("");

        const id = productionid.val();
        const dateVal = productiondate.val();
        const prodId = modalproduct.val();
        const qtyVal = parseFloat(quantity.val());
        const whId = warehouse.val();

        if (dateVal === "") {
            modalnotifications.html(showAlert("info", "Please select a valid production date."));
            return;
        }
        if (prodId === "" || prodId === null) {
            modalnotifications.html(showAlert("info", "Please select a valid product."));
            modalproduct.focus();
            return;
        }
        if (isNaN(qtyVal) || qtyVal <= 0) {
            modalnotifications.html(showAlert("info", "Please enter a valid quantity greater than 0."));
            quantity.focus();
            return;
        }
        if (!whId || whId === "0" || whId === "") {
            modalnotifications.html(showAlert("info", "Please select a receiving warehouse."));
            return;
        }

        modalnotifications.html(showAlert("processing", "Saving production record. Please wait..."));

        $.post(
            "../controllers/productionoperations.php",
            {
                saveproduction: 1,
                id: id,
                productiondate: dateVal,
                productid: prodId,
                quantity: qtyVal,
                warehouseid: whId
            },
            function (data) {
                if ($.trim(data) === "success") {
                    modalnotifications.html(showAlert("success", "Production record saved successfully!"));
                    setTimeout(function () {
                        productionmodal.modal("hide");
                        refreshProductionList();
                    }, 1000);
                } else {
                    modalnotifications.html(showAlert("danger", "Error saving production record: " + data));
                }
            }
        ).fail(function (xhr, status, error) {
            modalnotifications.html(showAlert("danger", "Connection error: " + error));
        });
    });

    // Populate dynamic table
    function refreshProductionList() {
        const alldatesVal = alldates.prop("checked") ? 1 : 0;
        const startVal = startdatefield.val();
        const endVal = enddatefield.val();
        const whVal = filterwarehouse.val() || 0;
        const prodVal = filterproduct.val() || 0;

        productionlistnotifications.html(showAlert("processing", "Fetching production records. Please wait..."));

        $.getJSON(
            "../controllers/productionoperations.php",
            {
                getproductions: 1,
                alldates: alldatesVal,
                startdate: startVal,
                enddate: endVal,
                warehouseid: whVal,
                productid: prodVal
            },
            function (data) {
                productionlistnotifications.html("");
                let html = "";
                for (let i = 0; i < data.length; i++) {
                    const row = data[i];
                    html += `
                    <tr data-id="${row.id}" data-date="${row.productiondate_fmt}" data-productid="${row.productid}" data-productname="${row.itemname}" data-qty="${row.quantity}" data-uom="${row.uom || ''}" data-warehouseid="${row.warehouseid}">
                        <td>${i + 1}</td>
                        <td>${row.productiondate_fmt}</td>
                        <td>${row.itemcode}</td>
                        <td>${row.itemname}</td>
                        <td>${$.number(row.quantity, 2)}</td>
                        <td>${row.uom || ''}</td>
                        <td>${row.warehousename}</td>
                        <td>${row.dateadded_fmt}</td>
                        <td>${row.addedby}</td>
                        <td class="text-center">
                            <div class="dropdown">
                                <a class="btn btn-sm btn-link text-secondary p-0" href="#" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-size: 1.2rem; text-decoration: none;">
                                    <i class="fal fa-ellipsis-v"></i>
                                </a>
                                <div class="dropdown-menu dropdown-menu-right shadow border-0" style="border-radius: 8px; font-size: 0.85rem; z-index: 1050 !important;">
                                    <a class="dropdown-item btn-edit" href="#" data-id="${row.id}">
                                        <i class="fal fa-edit fa-fw mr-2" style="color: #6c757d; font-size: 0.72rem;"></i> Edit
                                    </a>
                                    <a class="dropdown-item btn-delete text-danger" href="#" data-id="${row.id}">
                                        <i class="fal fa-trash-alt fa-fw mr-2" style="color: red; font-size: 0.72rem;"></i> Delete
                                    </a>
                                </div>
                            </div>
                        </td>
                    </tr>`;
                }

                makedatatable(productiontable, html, 15);
            }
        ).fail(function (xhr, status, error) {
            productionlistnotifications.html(showAlert("danger", "Connection error: " + error));
        });
    }

    // Edit button click handler
    productiontable.on("click", ".btn-edit", function (e) {
        e.preventDefault();
        const tr = $(this).closest("tr");
        const id = tr.attr("data-id");
        const dateVal = tr.attr("data-date");
        const prodId = tr.attr("data-productid");
        const qtyVal = tr.attr("data-qty");
        const itemUom = tr.attr("data-uom");
        const whId = tr.attr("data-warehouseid");

        modaltitle.text("Edit Production Record");
        productionid.val(id);
        productiondate.val(dateVal);
        modalproduct.val(prodId);
        quantity.val(qtyVal);
        uom.val(itemUom);
        warehouse.val(whId);
        modalnotifications.html("");

        productionmodal.modal("show");
    });

    // Delete button click handler
    productiontable.on("click", ".btn-delete", function (e) {
        e.preventDefault();
        const id = $(this).attr("data-id");

        bootbox.confirm({
            message: "Are you sure you want to delete this production record?",
            buttons: {
                confirm: {
                    label: 'Yes, Delete',
                    className: 'btn-danger btn-sm'
                },
                cancel: {
                    label: 'Cancel',
                    className: 'btn-secondary btn-sm'
                }
            },
            callback: function (result) {
                if (result) {
                    $.post(
                        "../controllers/productionoperations.php",
                        {
                            deleteproduction: 1,
                            id: id
                        },
                        function (data) {
                            if ($.trim(data) === "success") {
                                refreshProductionList();
                            } else {
                                bootbox.alert("Error deleting production record: " + data);
                            }
                        }
                    );
                }
            }
        });
    });

    // Initial loading sequences
    loadProductsWithRecipes().then(function () {
        refreshProductionList();
    });

    // Toggle Filters collapsible panel text & icons
    $('#filterCollapse').on('show.bs.collapse', function () {
        $('#toggleFiltersBtn span').text('Close');
        $('#toggleFiltersBtn i').removeClass('fa-filter').addClass('fa-times');
    });
    $('#filterCollapse').on('hide.bs.collapse', function () {
        $('#toggleFiltersBtn span').text('Filters');
        $('#toggleFiltersBtn i').removeClass('fa-times').addClass('fa-filter');
    });
});
