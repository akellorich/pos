<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Redesigned Dashboard </title>
    
    <!-- External Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.4/moment.min.js"></script>
    
    <!-- Design System Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

    <style>
        :root {
            --primary-color: #0059bb;
            --background-color: #f9f9fc;
            --surface-color: #ffffff;
            --border-color: #eeeef0;
            --text-main: #1a1c1e;
            --text-muted: #717786;
        }

        body {
            background-color: var(--background-color);
            font-family: 'Inter', sans-serif;
            color: var(--text-main);
            font-size: 0.85rem;
        }

        h1, h2, h3, h4, h5, h6, .font-manrope {
            font-family: 'Manrope', sans-serif;
        }

        /* Dashboard Specific Styles */
        #dashboard-v2-container {
            padding: 1.5rem;
        }

        .card-custom {
            background: var(--surface-color);
            border: 1px solid var(--border-color);
            border-radius: 0.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            padding: 0.75rem 1rem;
            margin-bottom: 0.5rem;
        }

        .section-header {
            font-family: 'Manrope', sans-serif;
            font-size: 0.85rem;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.02em;
        }

        /* Summary Stats Cards */
        .stat-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--surface-color);
            border: 1px solid var(--border-color);
            border-radius: 0.5rem;
            padding: 1.25rem;
            margin-bottom: 1.5rem;
        }

        .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .stat-label {
            color: var(--text-muted);
            font-size: 10px;
            font-weight: 600;
            margin-bottom: 2px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .stat-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-main);
            margin: 0;
        }

        /* Filter Row Refinement */
        .filter-row {
            background: var(--surface-color);
            border: 1px solid var(--border-color);
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .reporting-label {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-main);
            font-family: 'Manrope', sans-serif;
        }

        /* Flatpickr Airline Style Overrides */
        .flatpickr-calendar {
            box-shadow: 0 10px 30px rgba(0,0,0,0.1) !important;
            border: none !important;
            border-radius: 8px !important;
            width: 600px !important;
            padding: 20px !important;
        }
        .flatpickr-months .flatpickr-month {
            background: white !important;
            color: #1a1c1e !important;
        }
        .flatpickr-current-month {
            font-family: 'Manrope', sans-serif !important;
            font-weight: 700 !important;
            font-size: 1.1rem !important;
        }
        .flatpickr-weekday {
            font-family: 'Inter', sans-serif !important;
            font-weight: 600 !important;
            color: #717786 !important;
        }
        .flatpickr-day {
            border-radius: 50% !important;
            font-family: 'Inter', sans-serif !important;
            font-weight: 500 !important;
        }
        .flatpickr-day.selected, .flatpickr-day.startRange, .flatpickr-day.endRange {
            background: var(--primary-color) !important;
            border-color: var(--primary-color) !important;
            color: white !important;
        }
        .flatpickr-day.inRange {
            background: rgba(0, 89, 187, 0.08) !important;
            box-shadow: -5px 0 0 rgba(0, 89, 187, 0.08), 5px 0 0 rgba(0, 89, 187, 0.08) !important;
            border-color: transparent !important;
        }
        .flatpickr-day:hover {
            background: #e9ecef !important;
        }
        .flatpickr-day.selected.startRange + .endRange:not(:nth-child(7n+1)), 
        .flatpickr-day.startRange.startRange + .endRange:not(:nth-child(7n+1)), 
        .flatpickr-day.endRange.startRange + .endRange:not(:nth-child(7n+1)) {
             box-shadow: -10px 0 0 rgba(0, 89, 187, 0.08) !important;
        }
        
        /* Range Indicator Bar at Top of Flatpickr */
        .fp-range-indicator {
            padding: 0 10px 20px 10px;
            font-family: 'Manrope', sans-serif;
            font-weight: 600;
            font-size: 1.4rem;
            color: #002e6b;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 2px solid #f1f1f4;
            margin-bottom: 20px;
        }
        .fp-range-indicator .arrow {
            color: #717786;
            font-size: 1.2rem;
        }
        
        .fp-footer {
            display: flex;
            justify-content: flex-end;
            padding-top: 20px;
            border-top: 1px solid #f1f1f4;
            margin-top: 10px;
        }
        .fp-done-btn {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 30px;
            border-radius: 25px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
        }

        .filter-btn-group {
            background: #f1f1f4;
            padding: 4px;
            border-radius: 0.5rem;
            display: flex;
            gap: 4px;
        }

        .filter-btn {
            border: none;
            background: transparent;
            font-size: 11px;
            font-weight: 500;
            padding: 4px 12px;
            border-radius: 0.4rem;
            color: var(--text-muted);
            transition: all 0.2s;
        }

        .filter-btn.active {
            background: white;
            color: var(--primary-color);
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .custom-range-trigger {
            border: 1px solid var(--border-color);
            background: white;
            padding: 4px 12px;
            border-radius: 0.5rem;
            font-size: 11px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            position: relative;
        }

        #range-picker-input {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        /* Tables */
        .table-custom {
            width: 100%;
            font-size: 12px;
        }

        .table-custom thead th {
            background: #f9f9fc;
            text-transform: uppercase;
            font-size: 9px;
            color: var(--text-muted);
            font-weight: 700;
            padding: 8px 20px;
            border: none;
        }

        .table-custom tbody td {
            padding: 8px 20px;
            vertical-align: middle;
            border-top: 1px solid #f1f1f4;
        }

        /* Progress Bars */
        .progress-slim {
            height: 6px;
            background-color: #f1f1f4;
            border-radius: 3px;
            overflow: hidden;
        }

        .progress-bar-primary {
            background-color: var(--primary-color);
        }

        /* Material Symbols adjustment */
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }

        /* Sidebar compatibility */
        .home-section {
            left: 260px;
            width: calc(100% - 260px);
            padding: 0;
        }
        .sidebar.close1 ~ .home-section {
            left: 78px;
            width: calc(100% - 78px);
        }

        /* Chart Axis Customization */
        .apexcharts-yaxis-texts-g text,
        .apexcharts-xaxis-texts-g text {
            font-size: 11px !important;
            font-weight: 600 !important;
            fill: var(--text-main) !important;
        }
        #salesbypaymentmode-chart .apexcharts-yaxis-texts-g text,
        #salesbypaymentmode-chart .apexcharts-xaxis-texts-g text {
            font-size: 0px !important;
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            #dashboard-v2-container {
                padding: 0.75rem;
            }
            
            body {
                font-size: 0.75rem;
            }

            .filter-row {
                flex-direction: column;
                align-items: flex-start !important;
                gap: 1rem;
            }

            .filter-row > div:nth-child(2) {
                flex-direction: column;
                align-items: flex-start !important;
                width: 100%;
                gap: 0.75rem;
            }

            .filter-btn-group {
                width: 100%;
                margin-right: 0 !important;
                display: flex;
                justify-content: space-between;
            }

            .custom-range-trigger {
                width: 100%;
                justify-content: center;
            }

            .stat-value {
                font-size: 1.1rem;
            }

            .stat-icon {
                width: 36px;
                height: 36px;
            }

            .stat-icon .material-symbols-outlined {
                font-size: 18px;
            }

            .card-custom {
                padding: 0.75rem;
                /* padding-top: 0 !important; */
                margin-bottom: 0 !important;
            }

            .section-header {
                font-size: 0.75rem;
            }

            .reporting-label {
                font-size: 0.9rem;
            }

            .stat-label {
                font-size: 9px;
            }

            .filter-row {
                margin-bottom: 1rem !important;
            }

            .stat-card {
                margin-bottom: 0.75rem !important;
            }

            .table-custom tbody td {
                font-size: 11px !important;
                font-weight: 400 !important;
            }

            .table-custom tbody td.font-weight-bold {
                font-weight: 500 !important;
                font-size: 11px !important;
            }

            .table-custom thead th {
                font-size: 8px !important;
                padding: 6px 10px !important;
            }
        }
    </style>
</head>
<body>
    <?php require_once("sidebar.html") ?>
    <section class="home-section min-vh-100">
        <!-- Page Header -->
        <div class="home-content bg-white border-bottom px-4 py-2 d-flex align-items-center">
            <i class='bx bx-menu cursor-pointer font-size-lg mr-3' style="font-size: 24px;"></i>
            <span class="h5 mb-0 font-manrope font-weight-bold">Dashboard</span>
        </div>

        <div id="dashboard-v2-container">
            <!-- Filter Row -->
            <div class="filter-row">
                <div class="d-flex align-items-center mb-2 mb-md-0">
                    <span class="material-symbols-outlined text-muted mr-3" style="font-size: 24px;">calendar_today</span>
                    <span class="reporting-label">Reporting Period</span>
                </div>
                <div class="d-flex align-items-center">
                    <div class="filter-btn-group mr-4">
                        <button class="filter-btn active" data-range="today">Today</button>
                        <button class="filter-btn" data-range="week">Week</button>
                        <button class="filter-btn" data-range="month">Month</button>
                        <button class="filter-btn" data-range="year">Year</button>
                    </div>
                    <div class="custom-range-trigger" id="custom-range-btn">
                        <span id="current-range-label" style="font-size: 13px; font-weight: 600;">Custom Range</span>
                        <span class="material-symbols-outlined text-muted" style="font-size: 20px;">date_range</span>
                        <input type="text" id="range-picker-input">
                    </div>
                </div>
            </div>

            <!-- Summary Stats -->
            <div class="row no-gutters mx-n2">
                <!-- Total Sales -->
                <div class="col-6 col-lg px-2">
                    <div class="stat-card">
                        <div>
                            <p class="stat-label">Total Sales</p>
                            <h3 class="stat-value" id="totalsalesplaceholder">0</h3>
                        </div>
                        <div class="stat-icon" style="background: #fff9c4; color: #fbc02d;">
                            <span class="material-symbols-outlined">trending_up</span>
                        </div>
                    </div>
                </div>

                <!-- Total Customers -->
                <div class="col-6 col-lg px-2">
                    <div class="stat-card">
                        <div>
                            <p class="stat-label">Active Customers</p>
                            <h3 class="stat-value" id="activecustomersplaceholder">0</h3>
                        </div>
                        <div class="stat-icon" style="background: #e3f2fd; color: #0059bb;">
                            <span class="material-symbols-outlined">group</span>
                        </div>
                    </div>
                </div>

                <!-- Open Receivables -->
                <div class="col-6 col-lg px-2">
                    <div class="stat-card">
                        <div>
                            <p class="stat-label">Open Receivables</p>
                            <h3 class="stat-value" id="openreceivablesplaceholder">0</h3>
                        </div>
                        <div class="stat-icon" style="background: #e8f5e9; color: #2e7d32;">
                            <span class="material-symbols-outlined">payments</span>
                        </div>
                    </div>
                </div>

                <!-- Open Payables -->
                <div class="col-6 col-lg px-2">
                    <div class="stat-card">
                        <div>
                            <p class="stat-label">Open Payables</p>
                            <h3 class="stat-value" id="openpayablesplaceholder">0</h3>
                        </div>
                        <div class="stat-icon" style="background: #fff3e0; color: #ef6c00;">
                            <span class="material-symbols-outlined">account_balance_wallet</span>
                        </div>
                    </div>
                </div>

                <!-- Open Purchase Orders -->
                <div class="col-6 col-lg px-2">
                    <div class="stat-card">
                        <div>
                            <p class="stat-label">Open Orders</p>
                            <h3 class="stat-value" id="openpurchaseordersplaceholder">0</h3>
                        </div>
                        <div class="stat-icon" style="background: #f3e5f5; color: #7b1fa2;">
                            <span class="material-symbols-outlined">shopping_cart</span>
                        </div>
                    </div>
                </div>

                <!-- Reorder Items -->
                <div class="col-6 col-lg px-2">
                    <div class="stat-card">
                        <div>
                            <p class="stat-label">Reorder Items</p>
                            <h3 class="stat-value" id="reorderitemsplaceholder">0</h3>
                        </div>
                        <div class="stat-icon" style="background: #ffebee; color: #c62828;">
                            <span class="material-symbols-outlined">warning</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts & Lists -->
            <div class="row no-gutters mx-n2 mt-3">
                <!-- Sale By Value -->
                <div class="col-12 col-lg-8 px-2 mb-4">
                    <div class="card-custom">
                        <div class="d-flex align-items-center justify-content-between mb-4">
                            <h4 class="section-header mb-0">Sale By Value</h4>
                            <div id="salesbyvalue-legend"></div>
                        </div>
                        <div id="salesbyvalue-chart" style="height: 260px;"></div>
                    </div>
                </div>

                <!-- Sale By Payment Mode -->
                <div class="col-12 col-lg-4 px-2 mb-4">
                    <div class="card-custom">
                        <h4 class="section-header mb-4">Sale By Payment Mode</h4>
                        <div id="salesbypaymentmode-chart" style="height: 260px;"></div>
                    </div>
                </div>

                <!-- Sale By Quantity -->
                <div class="col-12 col-lg-4 px-2 mb-4">
                    <div class="card-custom">
                        <h4 class="section-header mb-4">Sale By Quantity</h4>
                        <div id="salesbyquantity-chart" style="height: 260px;"></div>
                    </div>
                </div>

                <!-- Customer Count -->
                <div class="col-12 col-lg-4 px-2 mb-4">
                    <div class="card-custom">
                        <h4 class="section-header mb-4">Customer Count</h4>
                        <div id="salesbycustomercount-chart" style="height: 260px;"></div>
                    </div>
                </div>

                <!-- Sale By Outlet -->
                <div class="col-12 col-lg-4 px-2 mb-4">
                    <div class="card-custom">
                        <h4 class="section-header mb-4">Sale By Outlet</h4>
                        <div id="salesbyoutlet-container" class="mt-3">
                            <!-- JS Content -->
                        </div>
                    </div>
                </div>

                <!-- Best Selling Product -->
                <div class="col-12 col-lg-6 px-2 mb-4">
                    <div class="card-custom p-0 overflow-hidden">
                        <div class="p-4 border-bottom">
                            <h4 class="section-header mb-0">Best Selling Product</h4>
                        </div>
                        <div id="bestsellingproduct-container">
                            <!-- JS Content -->
                        </div>
                    </div>
                </div>

                <!-- Best Selling Category -->
                <div class="col-12 col-lg-6 px-2 mb-4">
                    <div class="card-custom p-0 overflow-hidden">
                        <div class="p-4 border-bottom">
                            <h4 class="section-header mb-0">Best Selling Category</h4>
                        </div>
                        <div id="bestsellingcategory-container">
                            <!-- JS Content -->
                        </div>
                    </div>
                </div>

                <!-- Customer Sales Value Trends -->
                <div class="col-12 px-2 mb-4 mt-2">
                    <div class="card-custom">
                        <h4 class="section-header mb-5">Customer Sales Value Trends</h4>
                        <div id="salesbycustomervalue-chart" style="height: 320px;"></div>
                    </div>
                </div>

                <!-- Sales Performance by Salesperson -->
                <div class="col-12 px-2 mb-1 mt-2">
                    <div class="card-custom">
                        <h4 class="section-header">Sales Performance by Salesperson</h4>
                        <div class="row" id="salesbysalesperson-container">
                            <!-- JS Content -->
                        </div>
                    </div>
                </div>

                <!-- Sales Performance by Customer -->
                <div class="col-12 px-2 mb-1 mt-2">
                    <div class="card-custom">
                        <h4 class="section-header">Sales Performance by Customer</h4>
                        <div class="row" id="salesbycustomer-container">
                            <!-- JS Content -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <?php require_once("footer.txt") ?>
    <script src="../js/dashboard_v2.js"></script>
</body>
</html>
