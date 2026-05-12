<!DOCTYPE html>
<html lang="en">
<head>
    <?php require_once("header.txt") ?> 
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title> SalesFlow | Touchscreen Sale </title>
    
    <!-- Custom Design System -->
    <link rel="stylesheet" href="../css/touchscreensale_v2.css">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
</head>
<body class="font-inter">
    <?php require_once("sidebar.html") ?>
    
    <section class="home-section min-vh-100">
        <!-- Top Navbar -->
        <nav class="top-nav d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center">
                <i class='bx bx-menu cursor-pointer mr-4' style="font-size: 26px;"></i>
                <span class="font-manrope font-weight-bold h4 mb-0">Sales</span>
            </div>
            
            <div id="showhidetouchscreen" class="d-flex gap-2">
                <button class="btn btn-link text-success p-2" id="switchtorestaurant" title="Restaurant Mode">
                    <span class="material-symbols-outlined">restaurant</span>
                </button>
                <button class="btn btn-link text-success p-2" id="locksystem" title="Lock System">
                    <span class="material-symbols-outlined">lock</span>
                </button>
                <button class="btn btn-link text-success p-2" id="printersettings" title="Printer Settings">
                    <span class="material-symbols-outlined">settings</span>
                </button>
                <button class="btn btn-link text-danger p-2" id="touchscreendisplay" title="Toggle Layout">
                    <span class="material-symbols-outlined">visibility_off</span>
                </button>
            </div>
        </nav>

        <div class="pos-layout">
            <!-- Main Product Area -->
            <main class="main-pos-container">
                <div id="errors"></div>
                
                <!-- Row 1: Mode Toggle & Action Icons -->
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <div class="segmented-control">
                        <button class="btn active" id="cashsale" onclick="$('.segmented-control .btn').removeClass('active'); $(this).addClass('active')">Sale</button>
                        <button class="btn" id="quotation" onclick="$('.segmented-control .btn').removeClass('active'); $(this).addClass('active')">Quotation</button>
                        <button class="btn" id="proforma" onclick="$('.segmented-control .btn').removeClass('active'); $(this).addClass('active')">Proforma</button>
                    </div>
                    
                    <div class="d-flex gap-2">
                        <button class="btn btn-nexus-action-icon" title="Staff Mode">
                            <span class="material-symbols-outlined">person_play</span>
                        </button>
                        <button class="btn btn-nexus-action-icon" id="locksystem_v2" title="Lock">
                            <span class="material-symbols-outlined">lock</span>
                        </button>
                        <button class="btn btn-nexus-action-icon" id="settings_v2" title="Settings">
                            <span class="material-symbols-outlined">settings</span>
                        </button>
                    </div>
                </div>

                <!-- Row 2: Search Bar -->
                <div class="search-wrapper mb-4">
                    <span class="material-symbols-outlined">search</span>
                    <input id="itemcode" class="pos-search-input" placeholder="Search products by name or barcode..." type="text"/>
                </div>

                <!-- Row 3: Categories with "More" -->
                <div class="d-flex align-items-center gap-2 mb-4 position-relative">
                    <div id="categories" class="no-scrollbar">
                        <!-- Categories populated by JS -->
                    </div>
                    <button id="show-more-categories" class="btn btn-nexus-secondary" style="white-space: nowrap;">
                        <span class="material-symbols-outlined" style="font-size: 20px;">apps</span>
                        More
                    </button>

                    <!-- Popup for extra categories -->
                    <div id="categories-popup" class="categories-popup shadow-lg">
                        <div class="popup-grid" id="all-categories-list">
                            <!-- Populated by JS -->
                        </div>
                    </div>
                </div>

                <!-- Search Results List -->
                <div id="searchresultslist" style="display:none" class="position-absolute bg-white border rounded shadow-lg w-75" style="z-index: 1050; margin-top: -15px; border-radius: 12px !important;">
                    <ul id="searchproductlist" class="list-unstyled p-2 mb-0"></ul>
                </div>

                <!-- Product Grid -->
                <div id="products">
                    <!-- Products populated by JS -->
                </div>
            </main>

            <!-- Right Sidebar: Current Sale -->
            <aside class="cart-sidebar">
                <div class="cart-header">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <h5 class="font-manrope font-weight-bold mb-0">Current Sale</h5>
                        <div class="bg-light px-3 py-1 border rounded-pill d-flex align-items-center" style="color: #10b981;">
                            <span class="material-symbols-outlined mr-2" style="font-size: 14px;">calendar_today</span>
                            <input type="text" id="transactiondate" class="bg-transparent border-0 text-center font-weight-bold" style="width: 85px; font-size: 11px; outline: none; color: #10b981;" readonly disabled>
                        </div>
                    </div>

                    <div class="row no-gutters mx-n1 mb-1">
                        <div class="col-6 px-1">
                            <div class="cart-input-group">
                                <span class="material-symbols-outlined">store</span>
                                <select id="outlet"></select>
                            </div>
                        </div>
                        <div class="col-6 px-1">
                            <div class="cart-input-group">
                                <span class="material-symbols-outlined">description</span>
                                <input id="reference" placeholder="Quotation #" type="text"/>
                            </div>
                        </div>
                    </div>
                    
                    <div class="cart-input-group">
                        <span class="material-symbols-outlined">person</span>
                        <select id="customer"></select>
                    </div>
                </div>

                <div class="cart-items-container no-scrollbar">
                    <table id="salesitemsdetails">
                        <thead>
                            <tr><th>Code</th><th>Name</th><th>Desc</th><th>Price</th><th>Disc</th><th>Ext</th><th>Stock</th><th>Qty</th><th>Serial</th><th>Total</th><th></th></tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>

                <div class="cart-footer">
                    <div class="summary-row mb-3">
                        <span class="summary-label text-uppercase">Total</span>
                        <span id="overalltotalamount" class="summary-value text-success">0.00</span>
                    </div>
                    
                    <button id="addpayments" class="btn btn-nexus-charge mb-3">
                        PROCEED TO PAYMENT
                    </button>

                    <div class="d-flex" style="gap: 16px;">
                        <button id="hold" class="btn btn-nexus-secondary btn-hold flex-fill">
                            <span class="material-symbols-outlined" style="font-size: 16px;">pause</span>
                            Hold
                        </button>
                        <button id="retrieve" class="btn btn-nexus-secondary btn-retrieve flex-fill">
                            <span class="material-symbols-outlined" style="font-size: 16px;">folder_open</span>
                            Retrieve
                        </button>
                        <button id="clear" class="btn btn-nexus-secondary btn-clear flex-fill">
                            <span class="material-symbols-outlined" style="font-size: 16px;">delete</span>
                            Clear
                        </button>
                    </div>
                </div>
            </aside>
        </div>
    </section>

    <!-- Modals -->
    <div class="modal fade" id="mpesaconfirmationmodal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="font-weight-bold mb-0">MPESA Confirmation</h6>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>  
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-nexus-charge" id="addmpesatransaction">OK</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="heldsales" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content" id="heldsalesdetails">
                <div class="modal-header">
                    <h6 class="font-weight-bold mb-0">Held Sales</h6>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-nexus-secondary" data-dismiss="modal">CLOSE</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="payments" tabindex="-1" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="font-manrope">Complete Payment</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div id="paymenterror"></div>
                    
                    <h3 class="payment-section-title">
                        <span class="material-symbols-outlined" style="font-size: 18px;">payments</span>
                        Split Payment Methods
                    </h3>

                    <div id="paymentoptions">
                        <!-- Dynamic payment rows injected here -->
                    </div>

                    <div class="financial-summary-grid">
                        <div class="summary-card payable">
                            <span class="label">TOTAL TO PAY</span>
                            <div class="value-row">
                                <span class="currency"></span>
                                <span id="totalamountpayable" class="amount">0.00</span>
                            </div>
                        </div>
                        <div class="summary-card collected">
                            <span class="label">TOTAL COLLECTED</span>
                            <div class="value-row">
                                <span class="currency"></span>
                                <span id="totalpaid" class="amount">0.00</span>
                            </div>
                        </div>
                        <div class="summary-card due">
                            <span class="label">DUE / CHANGE</span>
                            <div class="value-row">
                                <span class="currency"></span>
                                <span id="change" class="amount">0.00</span>
                            </div>
                        </div>
                    </div>

                    <div class="options-bar">
                        <div class="options-section">
                            <label class="nexus-switch" for="chkprintreceipt">
                                <input type="checkbox" id="chkprintreceipt" checked>
                                <span class="switch-slider"></span>
                                <span class="switch-label">Print Receipt</span>
                            </label>
                            <label class="nexus-switch" for="chkprintlargeformat">
                                <input type="checkbox" id="chkprintlargeformat">
                                <span class="switch-slider"></span>
                                <span class="switch-label">Large Print</span>
                            </label>
                        </div>
                        <div class="options-section">
                            <label class="nexus-switch" for="sendtovault">
                                <input type="checkbox" id="sendtovault">
                                <span class="switch-slider"></span>
                                <span class="switch-label">Send to Vault</span>
                            </label>
                            <div class="d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined text-slate-400" style="font-size: 18px; color: #94a3b8;">account_balance_wallet</span>
                                <input type="text" id="walletid" class="payment-input" placeholder="Wallet ID / Mobile #" style="height: 38px; font-size: 12px; width: 180px; border-width: 1px; background: white;">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-nexus-charge" id="save">
                        <span class="material-symbols-outlined" style="font-size: 24px;">check_circle</span>
                        CONFIRM PAYMENT <span class="kbd-shortcut">(F4)</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- External Scripts -->
    <?php require_once("footer.txt") ?>
    <script src="../plugins/receiptprinter/receipt-printer-encoder.umd.js"></script>
    <script src="../plugins/receiptprinter/webbluetooth-receipt-printer.umd.js"></script>
    <script src="../plugins/receiptprinter/webusb-receipt-printer.umd.js"></script>
    <script src="../js/touchscreensale.js"></script>
    <script src="../js/touchscreensale_v2.js"></script>
</body>
</html>
