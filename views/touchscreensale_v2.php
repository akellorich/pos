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
                
                <div class="pos-controls-header">
                    <!-- Row 1: Mode Toggle & Action Icons -->
                    <div class="d-flex align-items-center justify-content-between mb-2">
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
                    <div class="d-flex align-items-center gap-3 mb-2">
                        <div class="search-wrapper flex-grow-1 mb-0">
                            <span class="material-symbols-outlined">search</span>
                            <input id="itemcode" class="pos-search-input" placeholder="Search Item ..." type="text" autocomplete="off"/>
                        </div>
                        <div class="view-toggle-group">
                            <button type="button" class="btn-view-toggle active" id="view-cards-btn" title="Card View">
                                <span class="material-symbols-outlined">grid_view</span>
                            </button>
                            <button type="button" class="btn-view-toggle" id="view-list-btn" title="List View">
                                <span class="material-symbols-outlined">view_list</span>
                            </button>
                        </div>
                    </div>

                    <!-- Row 3: Categories with "More" -->
                    <div class="d-flex align-items-center gap-2 mb-2 position-relative">
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
                </div>

                <!-- Search Results List -->
                <div id="searchresultslist" class="position-absolute bg-white border rounded shadow-lg w-75" style="display:none;">
                    <ul id="searchproductlist" class="list-unstyled p-2 mb-0"></ul>
                </div>

                <!-- Product Grid -->
                <div id="products">
                    <!-- Products populated by JS -->
                </div>
            </main>

            <!-- Resize Handle -->
            <div class="resize-handle" id="resize-handle"></div>

            <!-- Right Sidebar: Current Sale -->
            <aside class="cart-sidebar">
                <div class="cart-header">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <h5 class="font-manrope font-weight-bold mb-0">Current Sale</h5>
                        <div class="d-flex align-items-center gap-2" style="gap: 8px;">
                            <div class="bg-light px-3 py-1 border rounded-pill d-flex align-items-center" style="color: #10b981;">
                                <span class="material-symbols-outlined mr-2" style="font-size: 14px;">calendar_today</span>
                                <input type="text" id="transactiondate" class="bg-transparent border-0 text-center font-weight-bold" style="width: 85px; font-size: 11px; outline: none; color: #10b981;" readonly disabled>
                            </div>
                            <button id="btnToggleCartHeader" type="button" title="Toggle sale details"
                                style="background: none; border: none; padding: 4px 6px; cursor: pointer; color: #64748b; border-radius: 8px; display: flex; align-items: center; transition: background 0.2s;">
                                <span class="material-symbols-outlined" id="cartHeaderChevron" style="font-size: 20px; transition: transform 0.25s ease;">expand_less</span>
                            </button>
                        </div>
                    </div>

                    <div id="cart-header-details">
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
                </div>

                <div class="cart-items-container no-scrollbar">
                    <table id="salesitemsdetails">
                        <thead>
                            <tr class="cart-header-row">
                                <th class="col-delete"></th>
                                <th class="col-product">Product</th>
                                <th class="col-uom">UOM</th>
                                <th class="col-qty">Quantity</th>
                                <th class="col-price">UnitPrice</th>
                                <th class="col-total">LineTotal</th>
                            </tr>
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

    <!-- Modal for Printer Settings -->
    <div class="modal fade" id="printersettingsmodal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content" style="border-radius: 16px; border: none; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);">
                <div class="modal-header" style="border-bottom: 1px solid #f1f5f9; padding: 20px 24px;">
                    <h5 class="modal-title font-manrope font-weight-bold" style="font-size: 18px; color: #1a1c1e; display: flex; align-items: center; gap: 10px;">
                        <span class="material-symbols-outlined text-success" style="font-size: 24px;">print</span>
                        Printer Settings
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="font-size: 24px; color: #94a3b8; opacity: 1; outline: none; border: none; background: none;">&times;</button>
                </div>
                <div class="modal-body" style="padding: 24px;">
                    <div id="printernotifications" style="margin-bottom: 16px;"></div>
                    
                    <div class="input-container mb-3" style="display: flex; flex-direction: column; gap: 6px;">
                        <label for="deviceid" class="input-label" style="font-size: 10px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em;">Device ID</label>
                        <div class="payment-input-wrapper" style="position: relative; display: flex; align-items: center;">
                            <span class="material-symbols-outlined icon" style="position: absolute; left: 16px; font-size: 18px; color: #94a3b8;">devices</span>
                            <input type="text" name="deviceid" id="deviceid" class="payment-input" disabled style="padding-left: 48px; height: 48px; background-color: #f1f5f9; border: 2px solid #e2e8f0;">
                        </div>
                    </div>
                    
                    <div class="input-container mb-3" style="display: flex; flex-direction: column; gap: 6px;">
                        <label for="printerconnection" class="input-label" style="font-size: 10px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em;">Printer Connection</label>
                        <div class="payment-input-wrapper" style="position: relative; display: flex; align-items: center;">
                            <span class="material-symbols-outlined icon" style="position: absolute; left: 16px; font-size: 18px; color: #94a3b8;">settings_ethernet</span>
                            <select name="printerconnection" id="printerconnection" class="payment-input" style="padding-left: 48px; height: 48px; border: 2px solid #f1f5f9;">
                                <option value="usb">USB</option>
                                <option value="bluetooth">Bluetooth</option>
                                <option value="wifi">Wi-Fi</option>
                            </select>
                        </div>
                    </div>

                    <div class="input-container mb-3" style="display: flex; flex-direction: column; gap: 6px;">
                        <label for="printername" class="input-label" style="font-size: 10px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em;">Printer Name</label>
                        <div class="payment-input-wrapper" style="position: relative; display: flex; align-items: center;">
                            <span class="material-symbols-outlined icon" style="position: absolute; left: 16px; font-size: 18px; color: #94a3b8;">print</span>
                            <select name="printername" id="printername" class="payment-input" style="padding-left: 48px; height: 48px; border: 2px solid #f1f5f9;">
                                <option value="0x4843">POS-80</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="padding: 20px 24px; border-top: 1px solid #f1f5f9; display: flex; gap: 12px; background-color: #f8fafc;">
                    <button type="button" class="btn btn-nexus-charge flex-fill" id="saveprinterconfig" style="padding: 10px 16px; height: 42px; font-size: 13px; font-weight: 700; text-transform: uppercase; display: flex; align-items: center; justify-content: center; gap: 8px;">
                        <span class="material-symbols-outlined" style="font-size: 18px;">save</span> Save Changes
                    </button>
                    <button type="button" class="btn btn-nexus-secondary btn-retrieve flex-fill" id="testprinter" style="padding: 10px 16px; height: 42px; font-size: 13px; font-weight: 700; text-transform: uppercase; display: flex; align-items: center; justify-content: center; gap: 8px;">
                        <span class="material-symbols-outlined" style="font-size: 18px;">print</span> Test Printer
                    </button>
                    <button type="button" class="btn btn-nexus-secondary btn-clear flex-fill" data-dismiss="modal" style="padding: 10px 16px; height: 42px; font-size: 13px; font-weight: 700; text-transform: uppercase; display: flex; align-items: center; justify-content: center; gap: 8px;">
                        <span class="material-symbols-outlined" style="font-size: 18px;">close</span> Close
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
