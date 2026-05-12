<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
    <?php require_once("header.txt") ?> 
    <title> SalesFlow | Customers Management </title>
    
    <!-- External Libraries -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

    <style>
        :root {
            --primary-blue: #0056b3;
            --success-green: #009966;
            --danger-red: #e63946;
            --sidebar-gray: #6c757d;
            --background-gray: #f8f9fa;
            --border-light: #dee2e6;
            --text-dark: #212529;
            --text-muted: #6c757d;
        }

        body {
            background-color: var(--background-gray);
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            overflow-x: hidden;
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Inter', sans-serif;
        }

        /* Home Section & Header (From Dashboard V2) */
        .home-section {
            left: 260px;
            width: calc(100% - 260px);
            transition: all 0.5s ease;
        }
        .sidebar.close1 ~ .home-section {
            left: 78px;
            width: calc(100% - 78px);
        }

        .top-nav {
            background: white;
            border-bottom: 1px solid var(--border-light);
            padding: 0.75rem 1.5rem;
            display: flex;
            align-items: center;
        }

        /* Management Layout */
        .mgmt-container {
            padding: 0.4rem 0.5rem;
            width: 100%;
            margin: 0;
        }

        /* Top Scorecard Area */
        /* Top Scorecard Area - Exact Match Refinement */
        .customer-header-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 0;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            margin-bottom: 0.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            overflow: hidden;
        }

        .header-section {
            padding: 0.5rem 1rem 0;
            border-right: 1px solid #f1f5f9;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            min-height: 100px;
            height: auto;
        }

        .header-section:last-child {
            border-right: none;
        }

        .header-profile {
            padding: 1.15rem 0.25rem !important;
        }

        .profile-info h5 {
            font-weight: 600;
            margin-bottom: 2px;
            font-size: 1.05rem;
            color: #0f172a;
        }

        .badge-elite {
            background: #e0e7ff;
            color: #4338ca;
            font-size: 9px;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 6px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-dot {
            width: 6px;
            height: 6px;
            background: #10b981;
            border-radius: 50%;
            display: inline-block;
            margin-right: 4px;
        }

        .manager-chip {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #f8fafc;
            padding: 6px 10px;
            border-radius: 6px;
            width: fit-content;
            text-align: right;
            margin-bottom: 4px;
        }

        .manager-icon {
            width: 28px;
            height: 28px;
            background: #e2e8f0;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #475569;
        }

        .financial-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
            align-items: start;
        }

        .f-stat label {
            font-size: 9px;
            font-weight: 600;
            color: #717786;
            text-transform: uppercase;
            margin-bottom: 5px;
            display: block;
            letter-spacing: 0.08em;
            font-family: 'Inter', sans-serif;
        }

        .f-stat .val {
            font-size: 1.625rem; /* 26px */
            font-weight: 500;
            line-height: 1;
            font-family: 'Inter', sans-serif;
            letter-spacing: -0.02em;
        }

        .f-stat .sub {
            font-size: 10.5px;
            color: #64748b;
            font-weight: 600;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .progress-container {
            height: 5px;
            background: #f1f5f9;
            border-radius: 10px;
            margin-top: 12px;
            width: 100%;
            overflow: hidden;
        }

        .progress-bar-blue {
            height: 100%;
            background: #0056b3;
            border-radius: 10px;
        }

        .stat-icon-box {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .progress-bar-available {
            height: 4px;
            background: #eef2f7;
            border-radius: 2px;
            margin-top: 8px;
            width: 100%;
        }

        .progress-fill {
            height: 100%;
            background: var(--primary-blue);
            border-radius: 2px;
        }

        .info-card-stat {
            padding-left: 1rem;
            border-right: 1px solid #f1f1f4;
        }

        .info-card-stat:last-child {
            border-right: none;
        }

        .stat-icon-wrapper {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 8px;
        }

        /* Split Screen Content */
        .management-grid {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 0.5rem;
            height: calc(100vh - 68px);
            overflow: hidden;
        }

        /* Sidebar Design */
        .sidebar-mgmt {
            background: white;
            border: 1px solid var(--border-light);
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .sidebar-actions {
            padding: 1rem 0.75rem;
            display: flex;
            flex-direction: row;
            gap: 6px;
        }

        .btn-mgmt {
            border: none;
            border-radius: 6px;
            padding: 8px 4px;
            font-weight: 500;
            font-size: 10px;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 4px;
            text-transform: uppercase;
            flex: 1;
        }

        .btn-add { background: #00a65a; }
        .btn-filter { background: #6c757d; }
        .btn-delete { background: #dc3545; }

        .search-container {
            padding: 0 0.75rem 0.5rem;
        }

        .search-box {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 6px 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-box input {
            border: none;
            background: transparent;
            width: 100%;
            font-size: 13px;
            outline: none;
        }

        .customer-list {
            flex: 1;
            overflow-y: auto;
            border-top: 1px solid var(--border-light);
            max-height: 100%;
        }

        .main-content-mgmt {
            overflow-y: auto;
            flex: 1 1 0%;
            background: white;
            border: 1px solid var(--border-light);
            border-radius: 8px;
            display: flex;
            flex-direction: column;
        }

        .customer-row {
            padding: 12px 1.25rem;
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            border-bottom: 1px solid #f1f1f4;
            transition: all 0.2s;
            position: relative;
        }

        .customer-row:hover { background: #f8f9fa; }

        .customer-row.selected {
            background: #E0EEFF;
            border-left: 4px solid var(--primary-blue);
        }

        .customer-row.selected::after {
            content: 'check_circle';
            font-family: 'Material Symbols Outlined';
            position: absolute;
            right: 1.25rem;
            color: var(--primary-blue);
            font-size: 20px;
            font-variation-settings: 'FILL' 1;
        }

        .row-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #eef2f7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #0056b3;
            font-size: 14px;
        }

        .row-info h6 {
            margin: 0;
            font-weight: 700;
            font-size: 13px;
        }

        .row-info p {
            margin: 0;
            font-size: 11px;
            color: var(--text-muted);
            font-weight: 600;
        }

        .sidebar-footer {
            padding: 0.5rem 1.25rem;
            border-top: 1px solid var(--border-light);
            display: flex;
            gap: 1.5rem;
        }

        .cb-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        /* Empty State */
        /* Tab Interface Styling */
        .mgmt-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 1.25rem 0;
            margin-top: 0;
        }

        .mgmt-title h2 {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 2px;
            color: #0f172a;
        }

        .mgmt-title p {
            font-size: 12px;
            color: #64748b;
            margin-bottom: 0;
        }

        .mgmt-tabs {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;
            padding: 0 1.25rem;
            margin-bottom: 0;
        }

        .mgmt-tab {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 4px;
            font-size: 13px;
            font-weight: 600;
            color: #64748b;
            cursor: pointer;
            position: relative;
            transition: all 0.2s;
        }

        .mgmt-tab.active {
            color: #0056b3;
        }

        .mgmt-tab.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 2px;
            background: #0056b3;
        }

        .mgmt-tab .material-symbols-outlined {
            font-size: 18px;
        }

        .form-section-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1.25rem 1.25rem 0 1.25rem;
            margin-bottom: 8px;
        }

        .form-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 1.5rem;
        }

        .form-section-title .material-symbols-outlined {
            color: #0056D2;
            font-size: 20px;
        }

        .field-group {
            margin-bottom: 0.75rem;
        }

        .field-group label {
            display: block;
            font-size: 9px;
            font-weight: 800;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 6px;
        }

        .nexus-input {
            width: 100%;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 6px 12px;
            font-size: 13px;
            color: #1e293b;
            background: #fff;
            outline: none;
            transition: border-color 0.2s;
        }

        .nexus-input:focus {
            border-color: #0056D2;
        }

        .nexus-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2364748b'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 14px;
            padding-right: 36px;
        }

        .photo-upload-box {
            width: 134px;
            height: 134px;
            border: 1px dashed #cbd5e1;
            border-radius: 8px;
            background: #f8fafc;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s;
            margin-right: 1.5rem;
            flex-shrink: 0;
        }

        .photo-upload-box:hover {
            border-color: #0056D2;
            background: #E0EEFF;
        }

        .photo-upload-box p {
            font-size: 8px;
            font-weight: 800;
            color: #94a3b8;
            text-transform: uppercase;
            margin-bottom: 0;
            text-align: center;
        }

        .nexus-toggle {
            position: relative;
            display: inline-block;
            width: 36px;
            height: 20px;
        }

        .nexus-toggle input { opacity: 0; width: 0; height: 0; }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: #e2e8f0;
            transition: .4s;
            border-radius: 20px;
        }

        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 14px; width: 14px;
            left: 3px; bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .toggle-slider { background-color: #0056D2; }
        input:checked + .toggle-slider:before { transform: translateX(16px); }

        .consent-box {
            background: #E0EEFF;
            border-radius: 8px;
            padding: 12px;
            display: flex;
            gap: 10px;
        }

        .consent-box .material-symbols-outlined {
            font-size: 18px;
            color: #0056D2;
        }

        .consent-box p {
            font-size: 11px;
            color: #1e40af;
            font-weight: 500;
            margin-bottom: 0;
            line-height: 1.4;
        }

        .contact-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .contact-table th {
            padding: 8px 12px;
            font-size: 9px;
            font-weight: 800;
            color: #64748b;
            text-transform: uppercase;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
        }

        .contact-table td {
            padding: 6px 12px;
            font-size: 13px;
            border-bottom: 1px solid #f1f5f9;
            color: #1e293b;
        }

        .badge-cat {
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 10px;
            font-weight: 700;
        }

        .btn-nexus-primary {
            background: #0056b3;
            color: white;
            padding: 0 20px;
            height: 32px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border: none;
            transition: all 0.2s;
        }

        .input-group-custom {
            position: relative;
            display: flex;
            align-items: center;
        }

        .btn-auto-inline {
            position: absolute;
            right: 4px;
            top: 4px;
            bottom: 4px;
            background: #0056D2;
            color: white;
            border: none;
            border-radius: 6px;
            width: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            cursor: pointer;
            z-index: 5;
        }

        .btn-auto-inline:hover {
            background: #0045a8;
        }

        .btn-auto-inline span {
            font-size: 16px;
        }

        /* Statement Tab Styles */
        .statement-filter-bar {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1.25rem;
            margin-bottom: 0.4rem; /* Reduced from 0.75rem */
            display: grid;
            grid-template-columns: repeat(3, 1fr) auto;
            gap: 1.25rem;
            align-items: end;
        }

        .statement-input-wrap {
            position: relative;
            display: flex;
            align-items: center;
        }

        .statement-input-wrap .material-symbols-outlined {
            position: absolute;
            right: 12px;
            color: #94a3b8;
            font-size: 18px;
            pointer-events: none;
        }

        .form-input-statement {
            width: 100%;
            padding: 0.5rem 1rem; /* Reduced vertical padding */
            padding-right: 36px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 13px;
            color: #1e293b;
            height: 38px; /* Fixed height for matching */
            outline: none;
            transition: all 0.2s;
        }

        .form-input-statement:focus {
            border-color: #0056D2;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
        }

        .btn-generate {
            background: #1e293b;
            color: white;
            border: none;
            border-radius: 8px;
            height: 38px; /* Matched to input height */
            padding: 0 1.5rem;
            font-weight: 600;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-generate:hover {
            background: #0f172a;
        }

        .statement-header-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
            margin-bottom: 0.4rem; /* Further reduced from 0.75rem */
        }

        .account-info-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 2rem;
            position: relative;
        }

        .balance-summary-card {
            background: #0056D2;
            color: white;
            border-radius: 12px;
            padding: 2rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .summary-line {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.4rem; /* Tightened from 0.75rem */
            font-size: 13px; /* Reduced from 14px */
            opacity: 0.95;
        }

        .closing-balance-box {
            border-top: 1px solid rgba(255,255,255,0.2);
            margin-top: 0.75rem; /* Tightened from 1.5rem */
            padding-top: 0.75rem; /* Tightened from 1.5rem */
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .history-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 0;
            margin-bottom: 0.4rem; /* Further reduced from 0.75rem */
            overflow: hidden;
        }

        .history-header {
            padding: 1.25rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f1f5f9;
        }

        .status-badge {
            background: #f0fdf4;
            color: #166534;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .aging-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 1rem;
            margin-top: 1rem;
        }

        .aging-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem; /* Reduced from 1.25rem */
            text-align: center;
        }

        .aging-card.total {
            background: #0056D2;
            color: white;
            border-color: #0056D2;
        }

        .aging-label {
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            color: #64748b;
            margin-bottom: 2px; /* Reduced from 8px */
        }

        .aging-card.total .aging-label {
            color: rgba(255,255,255,0.8);
        }

        .aging-val {
            font-size: 18px;
            font-weight: 500; /* Reduced from 700 */
            color: #1e293b;
        }

        .aging-card.total .aging-val {
            color: white;
            font-size: 20px;
            font-weight: 500; /* Reduced from 700 */
        }

        .btn-nexus-outline {
            border: 1px solid #e2e8f0;
            background: white;
            padding: 0 16px;
            height: 32px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s;
        }

        /* Action Menu Popup */
        .action-popup {
            position: absolute;
            right: 0;
            top: 100%;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
            z-index: 100;
            width: 180px;
            display: none;
            overflow: hidden;
        }

        .action-item {
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 12px;
            font-weight: 500;
            color: #475569;
            cursor: pointer;
            transition: all 0.2s;
            border-bottom: 1px solid #f8fafc;
        }

        .action-item:last-child { border-bottom: none; }
        .action-item:hover { background: #f8fafc; color: #0056D2; }
        .action-item .material-symbols-outlined { font-size: 18px; }

        /* Discount Scorecards */
        .discount-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .discount-stat-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .ds-icon {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .ds-info h6 {
            margin: 0;
            font-size: 11px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .ds-info .val {
            font-size: 24px;
            font-weight: 700;
            color: #1e293b;
            margin: 2px 0;
        }

        .ds-info .sub {
            font-size: 11px;
            font-weight: 500;
        }

        /* Status Badges */
        .badge-status {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .badge-status::before {
            content: '';
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .status-active { background: #f0fdf4; color: #166534; }
        .status-active::before { background: #22c55e; }
        .status-expiring { background: #fff7ed; color: #9a3412; }
        .status-expiring::before { background: #f97316; }

        .type-pill {
            background: #f1f5f9;
            color: #475569;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
        }

        /* Custom DataTable Styles for Discounts */
        #discount-table_wrapper .dataTables_length,
        #discount-table_wrapper .dataTables_filter {
            display: none;
        }

        #discount-table {
            width: calc(100% - 3rem) !important;
            margin: 0 1.5rem 1rem 1.5rem !important;
            border-top: 1px solid #f1f5f9;
        }

        #discount-table_wrapper .dataTables_info {
            padding: 1.25rem 1.5rem;
            font-size: 11px;
            color: #64748b;
        }

        #discount-table_wrapper .dataTables_paginate {
            padding: 1rem 1.5rem;
            display: flex;
            gap: 12px;
            align-items: center;
        }

        #discount-table_wrapper .dataTables_paginate {
            padding: 1rem 1.5rem;
            display: flex;
            gap: 6px;
            align-items: center;
        }

        #discount-table_wrapper .paginate_button {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50% !important;
            border: 1px solid transparent !important;
            background: transparent !important;
            cursor: pointer;
            margin: 0 2px !important;
            transition: all 0.2s;
            font-size: 13px !important;
            font-weight: 500 !important;
            color: #64748b !important;
        }

        #discount-table_wrapper .paginate_button.current {
            background: #0056D2 !important;
            border-color: #0056D2 !important;
            color: white !important;
            font-weight: 700 !important;
        }

        #discount-table_wrapper .paginate_button.previous,
        #discount-table_wrapper .paginate_button.next {
            border: 1px solid #e2e8f0 !important;
            color: #94a3b8 !important;
        }

        #discount-table_wrapper .paginate_button:hover:not(.current):not(.disabled) {
            background: #f8fafc !important;
            border-color: #cbd5e1 !important;
            color: #1e293b !important;
        }

        #discount-table_wrapper .paginate_button.disabled {
            opacity: 0.3;
            cursor: default;
        }

        #discount-table_wrapper .paginate_button > span {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* New Modal Design (Match Design Image) */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(4px);
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            visibility: hidden;
            transition: all 0.25s ease;
        }

        .modal-overlay.show {
            opacity: 1;
            visibility: visible;
        }

        .modal-container {
            background: white;
            width: 540px;
            max-width: 95vw;
            border-radius: 16px;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            transform: scale(0.95);
            transition: all 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        .modal-overlay.show .modal-container {
            transform: scale(1);
        }

        .modal-header-new {
            background: #f8fafc;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 1px solid #f1f5f9;
        }

        .modal-header-new h2 {
            font-size: 20px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 4px;
        }

        .modal-header-new p {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 0;
        }

        .modal-body-new {
            padding: 2rem;
            background: white;
        }

        .modal-footer-new {
            background: #f8fafc;
            padding: 1.25rem 2rem;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 2rem;
            border-top: 1px solid #f1f5f9;
        }

        .close-btn-new {
            background: transparent;
            border: none;
            color: #64748b;
            cursor: pointer;
            padding: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color 0.2s;
        }

        .close-btn-new:hover { color: #0f172a; }

        .input-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .input-full {
            margin-bottom: 1.5rem;
        }

        .form-label-new {
            font-size: 13px;
            font-weight: 500;
            color: #475569;
            margin-bottom: 8px;
            display: block;
        }

        .input-wrapper-new {
            position: relative;
        }

        .input-wrapper-new .material-symbols-outlined {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 20px;
            color: #94a3b8;
        }

        .form-input-new {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            color: #1e293b;
            background: white;
            transition: all 0.2s;
        }

        .form-input-new:focus {
            outline: none;
            border-color: #0056D2;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-input-new.has-icon {
            padding-left: 42px;
        }

        .form-input-new.read-only {
            background: #f1f5f9;
            color: #64748b;
            border-color: #e2e8f0;
        }

        .toggle-box-new {
            border: 1.5px solid #f1f5f9;
            border-radius: 14px;
            padding: 1.25rem 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 0.5rem;
        }

        .toggle-info-new {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .toggle-icon-box {
            width: 40px;
            height: 40px;
            background: #E0EEFF;
            color: #0056D2;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .toggle-text-new h6 {
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 2px;
        }

        .toggle-text-new p {
            font-size: 11px;
            color: #64748b;
            margin-bottom: 0;
        }

        .btn-apply-discount {
            background: #10b981;
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.2);
        }

        .btn-apply-discount:hover {
            background: #059669;
            transform: translateY(-1px);
            box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.2);
        }

        .btn-discard-new {
            color: #475569;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-discard-new:hover { color: #0f172a; }

        /* Datepicker Z-Index Fix */
        .ui-datepicker {
            z-index: 10001 !important;
        }

        /* Refined Payment Tab Styling (Softened) */
        .receivables-container {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 0;
            margin-bottom: 0.5rem;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
            overflow: hidden; /* Ensures child headers respect the radius */
        }

        .receivables-header {
            padding: 1.25rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: white;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
        }

        .receivables-header-title {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .wallet-icon-box {
            width: 32px;
            height: 32px;
            background: #0056D2;
            color: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 4px rgba(37, 99, 235, 0.15);
        }

        .receivables-header h4 {
            font-size: 18px;
            font-weight: 600;
            color: #1e293b;
            margin: 0;
        }

        .receivables-header p {
            font-size: 12px;
            color: #64748b;
            margin: 0;
        }

        .receivables-table {
            width: 100%;
            border-collapse: collapse;
        }

        .receivables-table th {
            background: #f8fafc;
            padding: 0.75rem 1.5rem;
            font-size: 11px;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-align: left;
            border-bottom: 1px solid #f1f5f9;
        }

        .receivables-table td {
            padding: 0.15rem 1.5rem;
            font-size: 12px;
            color: #475569;
            border-bottom: 1px solid #f1f5f9;
        }

        .receivables-table .ref-cell {
            font-weight: 600;
            color: #1e293b;
        }

        .receivables-table .bal-cell {
            font-weight: 600;
            color: #ba1a1a;
        }

        .amt-pay-editable {
            width: 100px;
            padding: 6px 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            text-align: right;
            font-size: 13px;
            font-weight: 600;
            color: #1e293b;
            background: white;
            display: inline-block;
        }

        .summary-footer-row {
            padding: 0.85rem 2rem;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            background: white;
            border-top: 1px solid #f1f5f9;
        }

        .summary-item-box {
            display: flex;
            align-items: center;
            gap: 12rem; /* Increased space as requested */
        }

        .payment-details-card {
            background: #f8fafc;
            border: 1px solid #f1f5f9;
            border-radius: 12px;
            padding: 1.25rem 2rem;
            margin-top: 0;
            margin-bottom: 0.5rem;
        }

        .payment-details-card .card-header-custom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.25rem;
        }

        .payment-details-card .header-title-box {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .payment-details-card h6 {
            color: #1e293b;
            font-weight: 600;
            font-size: 16px;
            margin: 0;
        }

        .details-icon-box {
            width: 28px;
            height: 28px;
            background: #0056D2;
            color: white;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .details-icon-box span {
            font-size: 18px;
        }

        /* iOS Style Pill Toggles */
        .ios-switch-container {
            display: flex;
            align-items: center;
            gap: 1.25rem; /* Increased space between label and switch */
            cursor: pointer;
            user-select: none;
        }

        .ios-switch-label {
            font-size: 11px;
            font-weight: 600;
            color: #64748b;
        }

        .ios-switch {
            position: relative;
            display: inline-block;
            width: 36px;
            height: 20px;
        }

        .ios-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .ios-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #cbd5e1;
            transition: .3s;
            border-radius: 20px;
        }

        .ios-slider:before {
            position: absolute;
            content: "";
            height: 14px;
            width: 14px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .3s;
            border-radius: 50%;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        input:checked + .ios-slider {
            background-color: #0056D2;
        }

        input:checked + .ios-slider:before {
            transform: translateX(16px);
        }

        .form-input-new.overpay-field {
            background: #fef2f2;
            color: #ba1a1a;
            border-color: #fee2e2;
            font-weight: 600;
        }

        .payment-action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 0.5rem;
        }

        .btn-payment-action {
            height: 40px;
            padding: 0 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
            cursor: pointer;
        }

        .btn-clear {
            border: 1.5px solid #dc2626;
            color: #dc2626;
            background: white;
        }

        .btn-auto {
            border: 1.5px solid #0056D2;
            color: #0056D2;
            background: white;
            margin-right: 1.25rem;
        }

        .btn-post {
            background: #10b981;
            color: white;
            border: none;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .management-grid { grid-template-columns: 1fr; }
            .customer-header-card { grid-template-columns: 1fr 1fr; gap: 1rem; }
        }
    </style>
</head>
<body>
    <?php require_once("sidebar.html") ?>
    
    <section class="home-section min-vh-100">
        <!-- Top Nav (Menus same as dashboard_v2) -->
        <div class="top-nav">
            <i class='bx bx-menu cursor-pointer mr-3' style="font-size: 24px;" id="menu-toggle"></i>
            <h5 class="mb-0 font-weight-bold">Customers</h5>
        </div>

        <div class="mgmt-container">
            <!-- Management Grid -->
            <div class="management-grid">
                <!-- Sidebar -->
                <div class="sidebar-mgmt">
                    <div class="sidebar-actions">
                        <button class="btn-mgmt btn-add" id="add-btn" title="Add Customer">
                            <span class="material-symbols-outlined" style="font-size: 20px;">person_add</span>
                        </button>
                        <button class="btn-mgmt btn-filter" id="filter-btn" title="Filter List">
                            <span class="material-symbols-outlined" style="font-size: 20px;">filter_list</span>
                        </button>
                        <button class="btn-mgmt btn-delete" id="delete-btn" title="Delete Customer">
                            <span class="material-symbols-outlined" style="font-size: 20px;">delete</span>
                        </button>
                    </div>

                    <div class="search-container">
                        <div class="search-box">
                            <span class="material-symbols-outlined" style="font-size: 20px; color: #adb5bd;">search</span>
                            <input type="text" id="master-search" placeholder="Search master list...">
                        </div>
                    </div>

                    <div class="customer-list" id="customer-list-box">
                        <!-- Customer rows go here -->
                        <div class="text-center py-5 text-muted">
                            <div class="spinner-border spinner-border-sm mb-2"></div>
                            <p class="small">Loading list...</p>
                        </div>
                    </div>

                    <div class="sidebar-footer">
                        <label class="cb-label">
                            <input type="checkbox" id="cb-regular" checked> Regular
                        </label>
                        <label class="cb-label">
                            <input type="checkbox" id="cb-onetime"> One Time
                        </label>
                    </div>
                </div>

                <!-- Right Side Column: Header + Details -->
                <div class="main-column-mgmt d-flex flex-column" style="gap: 0.5rem; overflow: hidden; height: 100%;">
                    <!-- Top Scorecard Area (Now inside the grid) -->
                    <div class="customer-header-card mb-0">
                        <!-- Section 1: Profile -->
                        <div class="header-section header-profile d-flex flex-row justify-content-between align-items-start">
                            <div class="d-flex align-items-start">
                                <img src="../images/noimage.jpg" class="header-avatar mr-2" id="h-avatar" style="width: 64px; height: 64px; border-radius: 50%; background: #000;">
                                <div class="profile-info">
                                    <div class="d-flex align-items-center mb-1">
                                        <span class="badge-elite" style="margin-right: 10px;">Elite Member</span>
                                        <div class="d-flex align-items-center" style="font-size: 11px; font-weight: 700; color: #10b981;">
                                            <span class="status-dot"></span> Active
                                        </div>
                                    </div>
                                    <h5 id="h-name" class="mb-1">John Doe Ente...</h5>
                                    <p class="text-muted small mb-0" id="h-id" style="font-weight: 600; font-size: 11px;">ID: CUST-0892</p>
                                </div>
                            </div>
                            <div class="manager-chip">
                                <div class="manager-icon" style="width: 24px; height: 24px; border-radius: 4px;">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">badge</span>
                                </div>
                                <div>
                                    <p class="mb-0 text-muted" style="font-size: 7.5px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em;">Manager</p>
                                    <p class="mb-0 font-weight-bold" style="font-size: 12px; color: #334155;" id="managersname">-</p>
                                </div>
                            </div>
                        </div>

                        <!-- Section 2: Financials -->
                        <div class="header-section">
                            <div class="financial-grid">
                                <div class="f-stat">
                                    <label>Outstanding</label>
                                    <div class="val" style="color: #ba1a1a;" id="h-outstanding">50K</div>
                                    <div class="sub">
                                        <span class="material-symbols-outlined" style="font-size: 14px; color: #475569;">warning</span>
                                        <span id="h-pending">0 Pending</span>
                                    </div>
                                </div>
                                <div class="f-stat">
                                    <label>Credit Limit</label>
                                    <div class="val" style="color: #0f172a;" id="h-limit">200K</div>
                                    <div class="sub" style="font-size: 10px;" id="h-terms">Net 30 Terms</div>
                                </div>
                                <div class="f-stat">
                                    <label style="color: #0056D2;">Available</label>
                                    <div class="val" style="color: #0056D2;" id="h-available">150K</div>
                                    <div class="progress-container">
                                        <div class="progress-bar-blue" style="width: 75%;" id="h-progress"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Section 3: Latest Payment -->
                        <div class="header-section d-flex flex-row align-items-start">
                            <div class="stat-icon-box" style="background: #dcfce7; color: #166534;">
                                <span class="material-symbols-outlined" style="font-size: 24px;">payments</span>
                            </div>
                            <div>
                                <label>Latest Payment</label>
                                <div class="val" style="color: #0f172a; font-size: 1.625rem; font-weight: 500;" id="h-last-pay-amount">12,400</div>
                                <div class="sub d-flex align-items-center">
                                    <span id="h-last-pay-date"></span>
                                    <span style="width: 4px; height: 4px; background: #cbd5e1; border-radius: 50%; margin: 0 10px;"></span>
                                    <div class="d-flex align-items-center gap-1" style="background: #16a34a; color: white; padding: 2px 6px; border-radius: 4px; font-size: 9px; font-weight: 800;">
                                        <span class="material-symbols-outlined" style="font-size: 10px;">check</span> <span id="last-payment-mode">-</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Section 4: Oldest Charge -->
                        <div class="header-section d-flex flex-row align-items-start">
                            <div class="stat-icon-box" style="background: #fef3c7; color: #92400e;">
                                <span class="material-symbols-outlined" style="font-size: 24px;">history</span>
                            </div>
                            <div>
                                <label>Oldest Charge</label>
                                <div class="val" style="color: #ba1a1a; font-size: 1.625rem; font-weight: 500;" id="h-oldest-amount">0</div>
                                <div class="sub d-flex align-items-center">
                                    <span id="h-oldest-ref">INV-2034</span>
                                    <span style="width: 4px; height: 4px; background: #cbd5e1; border-radius: 50%; margin: 0 10px;"></span>
                                    <span style="color: #ba1a1a; font-weight: 700;" id="h-oldest-days">-</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content (Detailed Profile View) -->
                    <div class="main-content-mgmt flex-grow-1" id="details-view">
                    <input type="hidden" id="customer-id-val" value="0">
                    <!-- Tabs & Actions Nav -->
                    <div class="mgmt-tabs">
                        <div class="d-flex" style="gap: 2rem;">
                            <div class="mgmt-tab active" data-tab="biodata">
                                <span class="material-symbols-outlined">badge</span> Biodata
                            </div>
                            <div class="mgmt-tab" data-tab="discounts">
                                <span class="material-symbols-outlined">percent</span> Discounts
                            </div>
                            <div class="mgmt-tab" data-tab="payment">
                                <span class="material-symbols-outlined">payments</span> Payment
                            </div>
                            <div class="mgmt-tab" data-tab="statement">
                                <span class="material-symbols-outlined">history_edu</span> Statement
                            </div>
                        </div>
                        
                        <div class="mgmt-actions">
                            <button class="btn-nexus-primary" id="btn-save-customer" style="padding: 6px 16px; font-size: 13px;">
                                <span class="material-symbols-outlined" style="font-size: 18px;">save</span> Save Customer
                            </button>
                        </div>
                    </div>

                    <!-- Tab Content: Biodata -->
                    <div class="tab-content-container p-3 tab-pane active" id="pane-biodata" style="background: #f8fafc; border-radius: 0 0 12px 12px;">
                        <div class="row gx-2">
                            <!-- Left Column -->
                            <div class="col-lg-7">
                                <!-- General Info -->
                                <div class="form-section-card">
                                    <div class="form-section-title">
                                        <span class="material-symbols-outlined">person</span> General Information
                                    </div>
                                    <div class="d-flex align-items-start">
                                        <div class="photo-upload-box">
                                            <span class="material-symbols-outlined" style="font-size: 32px; color: #94a3b8;">add_a_photo</span>
                                            <p>Customer Photo</p>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="row">
                                                <div class="col-6">
                                                    <div class="field-group">
                                                        <label>Category</label>
                                                        <select class="nexus-input nexus-select" id="sel-category">
                                                            <option value="">Choose One</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="field-group">
                                                        <label>Home Outlet</label>
                                                        <select class="nexus-input nexus-select" id="sel-outlet">
                                                            <option value="">Choose One</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="field-group">
                                                        <label>Customer Name</label>
                                                        <input type="text" class="nexus-input" id="customer-name" placeholder="Full legal name" autocomplete="off">
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="field-group">
                                                        <label>Trading Name</label>
                                                        <input type="text" class="nexus-input" id="customer-trading-name" placeholder="Business or alias name" autocomplete="off">
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="field-group">
                                                        <label>ID Number</label>
                                                        <input type="text" class="nexus-input" id="customer-id-no" autocomplete="off">
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="field-group">
                                                        <label>PIN Number</label>
                                                        <input type="text" class="nexus-input" id="customer-pin-no" autocomplete="off">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Address & Contact -->
                                <div class="form-section-card">
                                    <div class="form-section-title">
                                        <span class="material-symbols-outlined">location_on</span> Address & Contact
                                    </div>
                                    <div class="field-group">
                                        <label>Physical Address</label>
                                        <textarea class="nexus-input" id="customer-physical-address" style="height: 48px;"></textarea>
                                    </div>
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="field-group">
                                                <label>Postal Address</label>
                                                <input type="text" class="nexus-input" id="customer-postal-address" autocomplete="off">
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="field-group">
                                                <label>Mobile</label>
                                                <input type="text" class="nexus-input" id="customer-mobile" placeholder="+254..." autocomplete="off">
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <div class="field-group">
                                                <label>Email</label>
                                                <input type="email" class="nexus-input" id="customer-email" placeholder="example@domain.com" autocomplete="off">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column -->
                            <div class="col-lg-5 d-flex flex-column" style="margin-bottom: 0.4rem;">
                                <div class="form-section-card flex-grow-1 mb-0">
                                    <div class="form-section-title">
                                        <span class="material-symbols-outlined">account_balance</span> Account & Financial Settings
                                    </div>
                                    
                                    <div class="d-flex justify-content-between align-items-center mb-4 p-3" style="background: #f8fafc; border-radius: 8px;">
                                        <div>
                                            <p class="mb-0 font-weight-bold" style="font-size: 13px; color: #1e293b;">One-time Customer</p>
                                            <p class="mb-0 text-muted" style="font-size: 10px; text-transform: uppercase; font-weight: 700; letter-spacing: 0.05em;">Do not save history</p>
                                        </div>
                                        <label class="nexus-toggle">
                                            <input type="checkbox" id="customer-onetime">
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>

                                    <div class="row">
                                        <div class="col-6">
                                            <div class="field-group">
                                                <label>Main Zone</label>
                                                <select class="nexus-input nexus-select" id="sel-mainzone"><option value="">Choose One</option></select>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="field-group">
                                                <label>Sub Zone</label>
                                                <select class="nexus-input nexus-select" id="sel-subzone"><option value="">Choose One</option></select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="field-group">
                                        <label>Opening Balance</label>
                                        <div style="position: relative;">
                                            <span style="position: absolute; left: 12px; top: 10px; font-size: 10px; font-weight: 800; color: #94a3b8;">KES</span>
                                            <input type="text" class="nexus-input" id="customer-opening-balance" value="0.00" style="padding-left: 42px;" autocomplete="off">
                                        </div>
                                    </div>

                                    <div class="field-group">
                                        <label>Credit Limit</label>
                                        <div style="position: relative;">
                                            <span style="position: absolute; left: 12px; top: 10px; font-size: 10px; font-weight: 800; color: #94a3b8;">KES</span>
                                            <input type="text" class="nexus-input" id="customer-credit-limit" value="50,000.00" style="padding-left: 42px;" autocomplete="off">
                                        </div>
                                    </div>

                                    <div class="field-group">
                                        <label>Credit Terms</label>
                                        <select class="nexus-input nexus-select" id="customer-credit-terms">
                                            <option value="0">On Account</option>
                                            <option value="7">Net 7 Days</option>
                                            <option value="14">Net 14 Days</option>
                                            <option value="30" selected>Net 30 Days</option>
                                            <option value="60">Net 60 Days</option>
                                            <option value="90">Net 90 Days</option>
                                        </select>
                                    </div>

                                    <div class="consent-box mt-4 justify-content-between align-items-center">
                                        <div class="d-flex align-items-start">
                                            <span class="material-symbols-outlined" style="color: #0056D2; margin-right: 12px; margin-top: 2px;">info</span>
                                            <div>
                                                <p style="color: #0056D2; font-weight: 700; font-size: 12px;">Processing Consent</p>
                                                <p style="font-size: 10px; color: #475569;">Storage and processing of personal data</p>
                                            </div>
                                        </div>
                                        <label class="nexus-toggle">
                                            <input type="checkbox" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Associated Contacts (Full Width Bottom) -->
                        <div class="form-section-card mt-1">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div class="form-section-title mb-0">
                                    <span class="material-symbols-outlined">contact_page</span> Associated Contacts
                                </div>
                            </div>

                            <div class="row align-items-end g-2 mb-4">
                                <div class="col-md-2">
                                    <div class="field-group mb-0">
                                        <label>Category</label>
                                        <select class="nexus-input nexus-select"><option>Billing</option></select>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="field-group mb-0">
                                        <label>Contact Name</label>
                                        <input type="text" class="nexus-input" autocomplete="off">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="field-group mb-0">
                                        <label>ID Number</label>
                                        <input type="text" class="nexus-input" autocomplete="off">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="field-group mb-0">
                                        <label>Mobile</label>
                                        <input type="text" class="nexus-input" autocomplete="off">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="field-group mb-0">
                                        <label>Email</label>
                                        <input type="email" class="nexus-input" autocomplete="off">
                                    </div>
                                </div>
                                <div class="col-md-1">
                                    <button class="btn-nexus-primary w-100 justify-content-center p-0">
                                        <span class="material-symbols-outlined">add</span>
                                    </button>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="contact-table">
                                    <thead>
                                        <tr>
                                            <th>Category</th>
                                            <th>Names</th>
                                            <th>ID Number</th>
                                            <th>Mobile</th>
                                            <th>Email</th>
                                            <th>ID Copy</th>
                                            <th>Consent</th>
                                            <th class="text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><span class="badge-cat" style="background: #E0EEFF; color: #0056D2;">Billing</span></td>
                                            <td class="font-weight-bold">Jane Doe</td>
                                            <td>12345678</td>
                                            <td>+254 712 345 678</td>
                                            <td>jane.doe@example.com</td>
                                            <td><span class="material-symbols-outlined" style="color: #cbd5e1;">description</span></td>
                                            <td><span class="material-symbols-outlined" style="color: #0056D2; font-variation-settings: 'FILL' 1;">check_circle</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">visibility</span> View</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">upload_file</span> Upload ID</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">fingerprint</span> Enroll Biometrics</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">check_circle</span> Consent Signed</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge-cat" style="background: #fff7ed; color: #ea580c;">Receiving</span></td>
                                            <td class="font-weight-bold">John Smith</td>
                                            <td>87654321</td>
                                            <td>+254 723 456 789</td>
                                            <td>j.smith@procurement.co.ke</td>
                                            <td><span class="material-symbols-outlined" style="color: #0056D2;">description</span></td>
                                            <td><span class="material-symbols-outlined" style="color: #cbd5e1;">check_circle</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">visibility</span> View</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">upload_file</span> Upload ID</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">fingerprint</span> Enroll Biometrics</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">check_circle</span> Consent Signed</div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Tab Content: Discounts -->
                    <div class="tab-content-container p-4 tab-pane d-none" id="pane-discounts" style="background: #f8fafc; border-radius: 0 0 12px 12px;">
                        <!-- Summary Stats -->
                        <div class="discount-stats">
                            <div class="discount-stat-card">
                                <div class="ds-icon" style="background: #E0EEFF; color: #0056D2;">
                                    <span class="material-symbols-outlined">redeem</span>
                                </div>
                                <div class="ds-info">
                                    <h6>Total Discounts</h6>
                                    <div class="val" style="font-weight: 500;">1,482.00</div>
                                    <div class="sub text-success">
                                        <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: middle;">trending_up</span> +12% from last month
                                    </div>
                                </div>
                            </div>
                            <div class="discount-stat-card">
                                <div class="ds-icon" style="background: #f0fdf4; color: #16a34a;">
                                    <span class="material-symbols-outlined">check_circle</span>
                                </div>
                                <div class="ds-info">
                                    <h6>Currently Active</h6>
                                    <div class="val" style="font-weight: 500;">08</div>
                                    <div class="sub text-muted">Across 4 item categories</div>
                                </div>
                            </div>
                            <div class="discount-stat-card">
                                <div class="ds-icon" style="background: #fef2f2; color: #dc2626;">
                                    <span class="material-symbols-outlined">timer</span>
                                </div>
                                <div class="ds-info">
                                    <h6>Expiring Soon</h6>
                                    <div class="val" style="font-weight: 500;">03</div>
                                    <div class="sub text-danger">Within the next 48 hours</div>
                                </div>
                            </div>
                        </div>

                        <!-- Active Discounts Table Section -->
                        <div class="form-section-card p-0 overflow-hidden">
                            <div class="d-flex justify-content-between align-items-center p-4 border-bottom">
                                <div>
                                    <h5 class="mb-1" style="font-weight: 700; color: #1e293b;">Active Discounts</h5>
                                    <p class="mb-0 text-muted small">Manage current price reductions and campaign offers</p>
                                </div>
                                <div class="d-flex" style="gap: 40px;">
                                    <div style="position: relative; width: 280px;">
                                        <span class="material-symbols-outlined" style="position: absolute; left: 12px; top: 8px; font-size: 18px; color: #94a3b8;">search</span>
                                        <input type="text" id="discount-search" class="nexus-input" style="padding-left: 40px;" placeholder="Search item or code..." autocomplete="off">
                                    </div>
                                    <button class="btn-nexus-primary" id="create-discount-btn" style="font-weight: 500;">
                                        <span class="material-symbols-outlined">add</span> Create Discount
                                    </button>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="contact-table mb-0" id="discount-table">
                                    <thead>
                                        <tr>
                                            <th>Item Code</th>
                                            <th>Item Name</th>
                                            <th>Original Price</th>
                                            <th>Value</th>
                                            <th>Type</th>
                                            <th>Final Price</th>
                                            <th>Expiry Date</th>
                                            <th>Status</th>
                                            <th class="text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-9021-X</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Premium Leather Wallet</div>
                                                <div style="font-size: 11px; color: #64748b;">Accessories / Leather</div>
                                            </td>
                                            <td style="color: #64748b;">89.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">-15.00</td>
                                            <td><span class="type-pill">Flat</span></td>
                                            <td style="font-weight: 500;">74.00</td>
                                            <td style="color: #475569;">Oct 24, 2024</td>
                                            <td><span class="badge-status status-active">Active</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-1142-P</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Noise Cancelling Headsets</div>
                                                <div style="font-size: 11px; color: #64748b;">Electronics / Audio</div>
                                            </td>
                                            <td style="color: #64748b;">249.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">20% OFF</td>
                                            <td><span class="type-pill">Percentage</span></td>
                                            <td style="font-weight: 500;">199.20</td>
                                            <td style="color: #475569;">Tomorrow</td>
                                            <td><span class="badge-status status-expiring">Expiring</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-4401-K</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Ergonomic Office Chair</div>
                                                <div style="font-size: 11px; color: #64748b;">Furniture / Office</div>
                                            </td>
                                            <td style="color: #64748b;">450.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">-50.00</td>
                                            <td><span class="type-pill">Flat</span></td>
                                            <td style="font-weight: 500;">400.00</td>
                                            <td style="color: #475569;">Nov 12, 2024</td>
                                            <td><span class="badge-status status-active">Active</span></td>
                                            <td class="text-right">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-8829-A</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Stainless Steel Water Bottle</div>
                                                <div style="font-size: 11px; color: #64748b;">Lifestyle / Sports</div>
                                            </td>
                                            <td style="color: #64748b;">35.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">15% OFF</td>
                                            <td><span class="type-pill">Percentage</span></td>
                                            <td style="font-weight: 500;">29.75</td>
                                            <td style="color: #475569;">Dec 01, 2024</td>
                                            <td><span class="badge-status status-active">Active</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-2023-M</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Mechanical Keyboard</div>
                                                <div style="font-size: 11px; color: #64748b;">Electronics / Computing</div>
                                            </td>
                                            <td style="color: #64748b;">120.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">-25.00</td>
                                            <td><span class="type-pill">Flat</span></td>
                                            <td style="font-weight: 500;">95.00</td>
                                            <td style="color: #475569;">Oct 30, 2024</td>
                                            <td><span class="badge-status status-active">Active</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-7712-B</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Bluetooth Soundbar</div>
                                                <div style="font-size: 11px; color: #64748b;">Electronics / Audio</div>
                                            </td>
                                            <td style="color: #64748b;">199.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">10% OFF</td>
                                            <td><span class="type-pill">Percentage</span></td>
                                            <td style="font-weight: 500;">179.10</td>
                                            <td style="color: #475569;">Nov 05, 2024</td>
                                            <td><span class="badge-status status-active">Active</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-4412-G</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Gaming Mousepad XL</div>
                                                <div style="font-size: 11px; color: #64748b;">Accessories / Gaming</div>
                                            </td>
                                            <td style="color: #64748b;">29.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">-5.00</td>
                                            <td><span class="type-pill">Flat</span></td>
                                            <td style="font-weight: 500;">24.00</td>
                                            <td style="color: #475569;">Tomorrow</td>
                                            <td><span class="badge-status status-expiring">Expiring</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-5501-T</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Tripod Stand 60"</div>
                                                <div style="font-size: 11px; color: #64748b;">Photography / Gear</div>
                                            </td>
                                            <td style="color: #64748b;">55.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">-10.00</td>
                                            <td><span class="type-pill">Flat</span></td>
                                            <td style="font-weight: 500;">45.00</td>
                                            <td style="color: #475569;">Nov 20, 2024</td>
                                            <td><span class="badge-status status-active">Active</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-1002-L</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Laptop Backpack</div>
                                                <div style="font-size: 11px; color: #64748b;">Lifestyle / Travel</div>
                                            </td>
                                            <td style="color: #64748b;">75.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">25% OFF</td>
                                            <td><span class="type-pill">Percentage</span></td>
                                            <td style="font-weight: 500;">56.25</td>
                                            <td style="color: #475569;">Dec 15, 2024</td>
                                            <td><span class="badge-status status-active">Active</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-3321-W</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">Wall Clock Modern</div>
                                                <div style="font-size: 11px; color: #64748b;">Home / Decor</div>
                                            </td>
                                            <td style="color: #40.00;">40.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">-12.00</td>
                                            <td><span class="type-pill">Flat</span></td>
                                            <td style="font-weight: 500;">28.00</td>
                                            <td style="color: #475569;">Nov 10, 2024</td>
                                            <td><span class="badge-status status-active">Active</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: #64748b; font-size: 11px; font-weight: 400;">SKU-9901-C</td>
                                            <td>
                                                <div style="font-weight: 500; color: #1e293b;">USB-C Hub 7-in-1</div>
                                                <div style="font-size: 11px; color: #64748b;">Electronics / Access.</div>
                                            </td>
                                            <td style="color: #64748b;">85.00</td>
                                            <td style="color: #dc2626; font-weight: 500;">10% OFF</td>
                                            <td><span class="type-pill">Percentage</span></td>
                                            <td style="font-weight: 500;">76.50</td>
                                            <td style="color: #475569;">Oct 28, 2024</td>
                                            <td><span class="badge-status status-active">Active</span></td>
                                            <td class="text-right position-relative">
                                                <button class="btn btn-light btn-sm action-trigger">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">more_vert</span>
                                                </button>
                                                <div class="action-popup">
                                                    <div class="action-item"><span class="material-symbols-outlined">edit</span> Edit</div>
                                                    <div class="action-item"><span class="material-symbols-outlined">bar_chart</span> View Utility</div>
                                                    <div class="action-item text-danger"><span class="material-symbols-outlined">delete</span> Delete</div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            
                            <!-- Dynamic Pagination via DataTable will appear here -->
                        </div>
                    </div>

                    <!-- Tab Content: Statement -->
                    <div class="tab-content-container p-4 tab-pane d-none" id="pane-statement" style="background: #f1f5f9; border-radius: 0 0 12px 12px; min-height: 800px; padding-top: 0.4rem !important;">
                        <!-- Filter Bar -->
                        <div class="statement-filter-bar">
                            <div class="form-group mb-0">
                                <label class="form-label-new">Start Date</label>
                                <div class="statement-input-wrap">
                                    <input type="text" id="statement-start-date" class="form-input-statement statement-datepicker" value="01-Oct-2023" readonly style="background: white; cursor: pointer;">
                                    <span class="material-symbols-outlined">calendar_today</span>
                                </div>
                            </div>
                            <div class="form-group mb-0">
                                <label class="form-label-new">End Date</label>
                                <div class="statement-input-wrap">
                                    <input type="text" id="statement-end-date" class="form-input-statement statement-datepicker" value="31-Oct-2023" readonly style="background: white; cursor: pointer;">
                                    <span class="material-symbols-outlined">calendar_today</span>
                                </div>
                            </div>
                            <div class="form-group mb-0">
                                <label class="form-label-new">Statement Type</label>
                                <select class="form-input-statement" id="statement-type">
                                    <option value="normal">Normal</option>
                                    <option value="suspense">Suspense Account</option>
                                </select>
                            </div>
                            <button class="btn-generate">
                                <span class="material-symbols-outlined" style="font-size: 18px;">sync</span> Generate Report
                            </button>
                        </div>

                        <!-- Header Grid -->
                        <div class="statement-header-grid">
                            <div class="account-info-card">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <div style="font-size: 10px; font-weight: 500; color: #0056D2; text-transform: uppercase; margin-bottom: 2px;">Account #100293</div>
                                        <h3 style="font-size: 20px; font-weight: 500; color: #1e293b; margin: 0;">John Doe Enterprise</h3>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <button class="btn-nexus-outline" style="width: 36px; height: 36px; padding: 0;"><span class="material-symbols-outlined" style="font-size: 18px;">print</span></button>
                                        <button class="btn-nexus-outline" style="width: 36px; height: 36px; padding: 0;"><span class="material-symbols-outlined" style="font-size: 18px;">mail</span></button>
                                    </div>
                                </div>

                                <div class="row mt-4">
                                    <div class="col-md-6">
                                        <div style="font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; margin-bottom: 8px;">Billing Address</div>
                                        <div style="font-size: 13px; color: #475569; line-height: 1.6;">
                                            742 Evergreen Terrace<br>
                                            Vipingo, Kilifi County<br>
                                            Kenya
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div style="font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; margin-bottom: 8px;">Contact Details</div>
                                        <div class="d-flex align-items-center gap-2 mb-2" style="font-size: 13px; color: #475569;">
                                            <span class="material-symbols-outlined" style="font-size: 16px; color: #94a3b8;">call</span> +254 700 000 000
                                        </div>
                                        <div class="d-flex align-items-center gap-2" style="font-size: 13px; color: #475569;">
                                            <span class="material-symbols-outlined" style="font-size: 16px; color: #94a3b8;">alternate_email</span> billing@johndoe.ent
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="balance-summary-card" style="padding: 1.5rem;">
                                <div>
                                    <h6 style="font-size: 14px; font-weight: 500; margin-bottom: 1rem; opacity: 0.9;">Current Balance Summary</h6>
                                    <div class="summary-line">
                                        <span>Opening Balance</span>
                                        <span>1,240.00</span>
                                    </div>
                                    <div class="summary-line">
                                        <span>Total Invoices (+)</span>
                                        <span>4,500.00</span>
                                    </div>
                                    <div class="summary-line">
                                        <span>Total Payments (-)</span>
                                        <span>(3,200.00)</span>
                                    </div>
                                </div>
                                <div class="closing-balance-box">
                                    <span style="font-size: 14px; font-weight: 500;">Closing Balance</span>
                                    <span style="font-size: 24px; font-weight: 500;">2,540.00</span>
                                </div>
                            </div>
                        </div>

                        <!-- Transaction History -->
                        <div class="history-card">
                            <div class="history-header">
                                <h5 style="font-size: 18px; font-weight: 600; color: #1e293b; margin: 0;">Transaction History</h5>
                                <div class="status-badge">
                                    <span style="width: 8px; height: 8px; background: #22c55e; border-radius: 50%;"></span>
                                    Statement is up to date
                                </div>
                            </div>
                            <table class="receivables-table">
                                <thead style="background: #f8fafc;">
                                    <tr>
                                        <th>Date</th>
                                        <th>Reference</th>
                                        <th>Narrative</th>
                                        <th class="text-right">Invoice</th>
                                        <th class="text-right">Payment</th>
                                        <th class="text-right">Balance</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Oct 01, 2023</td>
                                        <td style="font-weight: 500; color: #1e293b;">OB-2023</td>
                                        <td>Opening Balance Carried Forward</td>
                                        <td class="text-right">-</td>
                                        <td class="text-right">-</td>
                                        <td class="text-right" style="font-weight: 500; color: #1e293b;">1,240.00</td>
                                    </tr>
                                    <tr>
                                        <td>Oct 05, 2023</td>
                                        <td style="font-weight: 500; color: #1e293b;">INV-8821</td>
                                        <td>Service Fee - Monthly Maintenance</td>
                                        <td class="text-right">2,500.00</td>
                                        <td class="text-right">-</td>
                                        <td class="text-right" style="font-weight: 500; color: #1e293b;">3,740.00</td>
                                    </tr>
                                    <tr>
                                        <td>Oct 12, 2023</td>
                                        <td style="font-weight: 500; color: #1e293b;">RCT-5510</td>
                                        <td>Bank Transfer - Settlement</td>
                                        <td class="text-right">-</td>
                                        <td class="text-right" style="color: #10b981; font-weight: 500;">(3,200.00)</td>
                                        <td class="text-right" style="font-weight: 500; color: #1e293b;">540.00</td>
                                    </tr>
                                    <tr>
                                        <td>Oct 28, 2023</td>
                                        <td style="font-weight: 500; color: #1e293b;">INV-8954</td>
                                        <td>Inventory Purchase - Hardware</td>
                                        <td class="text-right">2,000.00</td>
                                        <td class="text-right">-</td>
                                        <td class="text-right" style="font-weight: 500; color: #1e293b;">2,540.00</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Aging Analysis -->
                        <div class="account-info-card" style="padding: 1rem 2rem;">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <span class="material-symbols-outlined" style="color: #64748b;">analytics</span>
                                <h5 style="font-size: 18px; font-weight: 600; color: #1e293b; margin: 0;">Aging Analysis</h5>
                            </div>
                            <div class="aging-grid">
                                <div class="aging-card">
                                    <div class="aging-label">0-30 Days</div>
                                    <div class="aging-val">2,000.00</div>
                                </div>
                                <div class="aging-card">
                                    <div class="aging-label">31-60 Days</div>
                                    <div class="aging-val">540.00</div>
                                </div>
                                <div class="aging-card">
                                    <div class="aging-label">61-90 Days</div>
                                    <div class="aging-val">0.00</div>
                                </div>
                                <div class="aging-card">
                                    <div class="aging-label">91-120 Days</div>
                                    <div class="aging-val">0.00</div>
                                </div>
                                <div class="aging-card">
                                    <div class="aging-label">120+ Days</div>
                                    <div class="aging-val">0.00</div>
                                </div>
                                <div class="aging-card total">
                                    <div class="aging-label">Total Outstanding</div>
                                    <div class="aging-val">2,540.00</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tab Content: Payment -->
                    <div class="tab-content-container p-4 tab-pane d-none" id="pane-payment" style="background: #f1f5f9; border-radius: 0 0 12px 12px; min-height: 600px; padding-top: 0.5rem !important;">
                        <!-- Open Receivables Section -->
                        <div class="receivables-container">
                            <div class="receivables-header">
                                <div class="receivables-header-title">
                                    <div class="wallet-icon-box">
                                        <span class="material-symbols-outlined" style="font-size: 18px;">account_balance_wallet</span>
                                    </div>
                                    <h4>Open Receivables</h4>
                                </div>
                                <p>Showing all unpaid invoices for this customer</p>
                            </div>

                            <table class="receivables-table">
                                <thead>
                                    <tr>
                                        <th style="width: 80px;">#</th>
                                        <th>Reference #</th>
                                        <th>Date</th>
                                        <th class="text-right">Invoice Amount</th>
                                        <th class="text-right">Paid</th>
                                        <th class="text-right">Balance</th>
                                        <th class="text-right" style="width: 180px;">Amount to Pay</th>
                                    </tr>
                                </thead>
                                <tbody id="receivables-list">
                                    <tr>
                                        <td>269</td>
                                        <td class="ref-cell">INV-2025-07-11</td>
                                        <td>2025-07-11</td>
                                        <td class="text-right">1,845.00</td>
                                        <td class="text-right">0.00</td>
                                        <td class="bal-cell text-right">1,845.00</td>
                                        <td class="text-right">
                                            <div class="amt-pay-editable" contenteditable="true">1845</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>5180</td>
                                        <td class="ref-cell">INV-2026-03-17</td>
                                        <td>2026-03-17</td>
                                        <td class="text-right">250.00</td>
                                        <td class="text-right">0.00</td>
                                        <td class="bal-cell text-right">250.00</td>
                                        <td class="text-right">
                                            <div class="amt-pay-editable" contenteditable="true">250</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>5192</td>
                                        <td class="ref-cell">INV-2026-04-02</td>
                                        <td>2026-04-02</td>
                                        <td class="text-right">1,200.00</td>
                                        <td class="text-right">500.00</td>
                                        <td class="bal-cell text-right">700.00</td>
                                        <td class="text-right">
                                            <div class="amt-pay-editable" contenteditable="true">700</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>5205</td>
                                        <td class="ref-cell">INV-2026-04-15</td>
                                        <td>2026-04-15</td>
                                        <td class="text-right">5,500.00</td>
                                        <td class="text-right">0.00</td>
                                        <td class="bal-cell text-right">5,500.00</td>
                                        <td class="text-right">
                                            <div class="amt-pay-editable" contenteditable="true">5500</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>5218</td>
                                        <td class="ref-cell">INV-2026-04-25</td>
                                        <td>2026-04-25</td>
                                        <td class="text-right">3,000.00</td>
                                        <td class="text-right">0.00</td>
                                        <td class="bal-cell text-right">3,000.00</td>
                                        <td class="text-right">
                                            <div class="amt-pay-editable" contenteditable="true">3000</div>
                                        </td>
                                    </tr>
                                </tbody>
                                <tfoot style="border-top: 2px solid #f1f5f9;">
                                    <tr>
                                        <td colspan="4"></td> <!-- Space for #, Ref, Date, Inv Amt -->
                                        <td class="text-right" style="font-weight: 600; color: #475569; font-size: 12px; padding: 0.75rem 1.5rem;">Summary Totals:</td>
                                        <td class="text-right" style="font-weight: 600; color: #dc2626; font-size: 13px;" id="total-balance-summary-val">11,295.00</td>
                                        <td class="text-right" style="font-weight: 600; color: #0056D2; font-size: 13px;" id="total-to-pay-display">11,295.00</td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>

                        <!-- Payment Details Form -->
                        <div class="payment-details-card">
                            <div class="card-header-custom">
                                <div class="header-title-box">
                                    <div class="details-icon-box">
                                        <span class="material-symbols-outlined">payments</span>
                                    </div>
                                    <h6>Payment Details</h6>
                                </div>
                                <div class="d-flex align-items-center" style="gap: 6rem;"> <!-- Increased gap between the two controls -->
                                    <label class="ios-switch-container">
                                        <span class="ios-switch-label">Print Receipt</span>
                                        <div class="ios-switch">
                                            <input type="checkbox" id="check-print-receipt" checked>
                                            <span class="ios-slider"></span>
                                        </div>
                                    </label>
                                    <label class="ios-switch-container">
                                        <span class="ios-switch-label">Email Receipt</span>
                                        <div class="ios-switch">
                                            <input type="checkbox" id="check-email-receipt">
                                            <span class="ios-slider"></span>
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-md-2">
                                    <label class="form-label-new">Mode of Payment</label>
                                    <select class="form-input-new">
                                        <option>MPESA</option>
                                        <option>CASH</option>
                                        <option>BANK</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label-new">Reference Number</label>
                                    <input type="text" id="payment-ref" class="form-input-new" placeholder="Enter ref..." value="OA2EXWAKO">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label-new">Narration / Remarks</label>
                                    <input type="text" id="payment-narration" class="form-input-new" placeholder="Add some notes here...">
                                </div>
                                <div class="col-md-2"> <!-- Reduced from col-md-3 (~50% effective reduction) -->
                                    <label class="form-label-new">Amount Paid</label>
                                    <div class="input-group-custom">
                                        <input type="text" id="payment-amount-paid" class="form-input-new" style="padding-right: 50px;" value="2500">
                                        <button type="button" id="btn-auto-distribute" class="btn-auto-inline" title="Auto Distribute Payment">
                                            <span class="material-symbols-outlined">auto_awesome</span>
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label-new">Overpay (Balance)</label>
                                    <input type="text" id="payment-overpay" class="form-input-new read-only overpay-field" value="405" readonly>
                                </div>
                            </div>
                        </div>

                        <!-- Actions Area -->
                        <div class="payment-action-bar">
                            <button class="btn-payment-action btn-clear" id="btn-clear-payment">
                                <span class="material-symbols-outlined">delete</span> Clear Form
                            </button>
                            <button class="btn-payment-action btn-post" id="btn-post-payment">
                                <span class="material-symbols-outlined">check_circle</span> Post Payment
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

    <!-- Add Discount Modal -->
    <div class="modal-overlay" id="add-discount-modal">
        <div class="modal-container">
            <!-- Header -->
            <div class="modal-header-new">
                <div>
                    <h2>Add Product Discount</h2>
                    <p>Configure new promotional pricing for an inventory item</p>
                </div>
                <button class="close-btn-new" id="close-discount-modal">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <!-- Body -->
            <div class="modal-body-new">
                <div class="input-full">
                    <label class="form-label-new">Item Code</label>
                    <div class="input-wrapper-new">
                        <span class="material-symbols-outlined">search</span>
                        <input type="text" class="form-input-new has-icon" placeholder="SKU-88291-BL">
                    </div>
                </div>

                <div class="input-row">
                    <div>
                        <label class="form-label-new">Item Name</label>
                        <input type="text" class="form-input-new read-only" value="Premium Leather Tote" readonly>
                    </div>
                    <div>
                        <label class="form-label-new">Selling Price</label>
                        <input type="text" class="form-input-new read-only" value="$ 149.00" readonly>
                    </div>
                </div>

                <div class="input-row">
                    <div>
                        <label class="form-label-new">Expiry Date</label>
                        <div class="input-wrapper-new">
                            <input type="text" class="form-input-new" placeholder="12/31/2024" id="discount-expiry-picker">
                            <span class="material-symbols-outlined" style="left: auto; right: 12px;">calendar_today</span>
                        </div>
                    </div>
                    <div>
                        <label class="form-label-new">Discount Value</label>
                        <input type="number" class="form-input-new" placeholder="0.00">
                    </div>
                </div>

                <div class="toggle-box-new">
                    <div class="toggle-info-new">
                        <div class="toggle-icon-box">
                            <span class="material-symbols-outlined" style="font-size: 20px;">percent</span>
                        </div>
                        <div class="toggle-text-new">
                            <h6>Discount is a percentage</h6>
                            <p>Switch off to apply fixed amount discount</p>
                        </div>
                    </div>
                    <label class="nexus-toggle">
                        <input type="checkbox" checked id="is-percentage-toggle">
                        <span class="toggle-slider"></span>
                    </label>
                </div>
            </div>

            <!-- Footer -->
            <div class="modal-footer-new">
                <a class="btn-discard-new" id="discard-discount-link">Discard</a>
                <button class="btn-apply-discount">
                    <span class="material-symbols-outlined">check_circle</span>
                    Apply Discount
                </button>
            </div>
        </div>
    </div>

    <?php require_once("footer.txt") ?>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
    <script src="../js/customers_v2.js"></script>
</body>
</html>
