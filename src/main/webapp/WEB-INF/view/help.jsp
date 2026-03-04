<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Help — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:900px; margin:0 auto; }
        .page-header { margin-bottom:28px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .page-header p { color:#7f8c8d; font-size:14px; margin-top:4px; }
        .help-card { background:white; border-radius:12px; padding:28px 32px; box-shadow:0 2px 12px rgba(0,0,0,0.07); margin-bottom:20px; border-left:5px solid #2980b9; }
        .help-card h3 { color:#0a3d62; font-size:16px; margin-bottom:12px; display:flex; align-items:center; gap:8px; }
        .help-card p, .help-card li { color:#444; font-size:14px; line-height:1.8; }
        .help-card ul, .help-card ol { padding-left:20px; }
        .help-card.green  { border-left-color:#27ae60; }
        .help-card.orange { border-left-color:#e67e22; }
        .help-card.purple { border-left-color:#8e44ad; }
        .help-card.teal   { border-left-color:#16a085; }
        .help-card.red    { border-left-color:#e74c3c; }
        .tip { background:#fff8e1; border-radius:8px; padding:10px 14px; font-size:13px; color:#7d6608; margin-top:12px; }
        .tip strong { color:#b7770d; }
        .api-table { width:100%; border-collapse:collapse; margin-top:12px; font-size:13px; }
        .api-table th { background:#0a3d62; color:white; padding:8px 12px; text-align:left; }
        .api-table td { padding:8px 12px; border-bottom:1px solid #f0f4f8; color:#2c3e50; }
        .api-table tr:hover td { background:#f8fbff; }
        .method { display:inline-block; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; font-family:monospace; }
        .get  { background:#eafaf1; color:#1e8449; }
        .post { background:#eaf4fb; color:#1e6091; }
        .put  { background:#fff3e0; color:#e67e22; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/reservations">Reservations</a>
        <a href="${pageContext.request.contextPath}/rooms">Rooms</a>
        <a href="${pageContext.request.contextPath}/billing">Billing</a>
        <a href="${pageContext.request.contextPath}/reports">Reports</a>
        <a href="${pageContext.request.contextPath}/help">Help</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>❓ Help & User Guide</h2>
        <p>A complete guide for hotel staff on using the Ocean View Resort HMS.</p>
    </div>

    <div class="help-card">
        <h3>🔐 Logging In</h3>
        <p>Use your staff credentials (username and password) to log in. Contact your administrator if you need a new account or have forgotten your password.</p>
        <div class="tip"><strong>Tip:</strong> Use "Remember Me" to stay logged in for 7 days on trusted devices.</div>
    </div>

    <div class="help-card green">
        <h3>📋 Creating a Reservation</h3>
        <ol>
            <li>Click <strong>New Reservation</strong> from the Dashboard or Reservations menu.</li>
            <li>Enter the guest's full name, contact number, address, and email.</li>
            <li>Select an available room from the dropdown.</li>
            <li>Choose a pricing strategy from the dropdown (configured by admin in Pricing Strategies).</li>
            <li>Enter the check-in and check-out dates. Check-in cannot be in the past.</li>
            <li>Click <strong>Create Reservation</strong>. A unique reservation number (e.g. RES-20260304-001) will be generated.</li>
        </ol>
    </div>

    <div class="help-card orange">
        <h3>🔍 Finding a Reservation</h3>
        <p>Go to <strong>Reservations</strong> to see all bookings. Click <strong>View</strong> on any row to see full details. You can check in, check out, or cancel from the details page.</p>
    </div>

    <div class="help-card purple">
        <h3>💳 Generating a Bill</h3>
        <ol>
            <li>Go to <strong>Billing</strong> from the menu.</li>
            <li>Enter the Reservation ID and select a pricing strategy from the dropdown.</li>
            <li>Click <strong>Generate Bill</strong> to calculate and display the invoice.</li>
            <li>Click <strong>Print Invoice</strong> to print or save as PDF.</li>
        </ol>
        <div class="tip"><strong>Pricing Strategies:</strong> Managed by admin via Pricing Strategies page. Each strategy applies a surcharge (+%) or discount (-%) to the base room rate.</div>
    </div>

    <div class="help-card teal">
        <h3>📊 Reports</h3>
        <p>Go to <strong>Reports</strong> and enter a date range to generate an occupancy and revenue report. The report shows all reservations within the period with status summary counts.</p>
    </div>

    <div class="help-card red">
        <h3>🌐 REST API Reference</h3>
        <p>The system exposes a REST API at <code>/api/v1/</code> for integration with external systems.</p>
        <table class="api-table">
            <thead><tr><th>Method</th><th>Endpoint</th><th>Description</th></tr></thead>
            <tbody>
                <tr><td><span class="method post">POST</span></td><td>/api/v1/auth/login</td><td>Login and create session</td></tr>
                <tr><td><span class="method get">GET</span></td><td>/api/v1/rooms</td><td>List all rooms (?available=true&type=SINGLE)</td></tr>
                <tr><td><span class="method post">POST</span></td><td>/api/v1/reservations</td><td>Create a new reservation</td></tr>
                <tr><td><span class="method get">GET</span></td><td>/api/v1/reservations</td><td>List all reservations</td></tr>
                <tr><td><span class="method get">GET</span></td><td>/api/v1/reservations/{resNumber}</td><td>Get reservation by number</td></tr>
                <tr><td><span class="method put">PUT</span></td><td>/api/v1/reservations/{id}/cancel</td><td>Cancel a reservation</td></tr>
                <tr><td><span class="method post">POST</span></td><td>/api/v1/billing/{id}/generate</td><td>Generate bill</td></tr>
                <tr><td><span class="method get">GET</span></td><td>/api/v1/reports/occupancy</td><td>Occupancy report (?from=&to=)</td></tr>
                <tr><td><span class="method get">GET</span></td><td>/api/v1/reports/revenue</td><td>Revenue summary (?from=&to=)</td></tr>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

