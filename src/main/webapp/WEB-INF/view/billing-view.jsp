<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Bill — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:800px; margin:0 auto; }
        .page-header { margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .card { background:white; border-radius:12px; padding:36px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .bill-header { text-align:center; padding-bottom:20px; border-bottom:2px dashed #ddd; margin-bottom:24px; }
        .bill-header .hotel-name { font-size:24px; font-weight:800; color:#0a3d62; }
        .bill-header .sub { font-size:13px; color:#7f8c8d; margin-top:4px; }
        .bill-header .res-num { font-size:17px; font-weight:700; color:#2980b9; margin-top:10px; font-family:monospace; }
        .bill-section { margin-bottom:22px; }
        .bill-section h4 { font-size:12px; font-weight:700; color:#1e6091; margin-bottom:10px; text-transform:uppercase; letter-spacing:0.5px; border-bottom:1px solid #ecf0f1; padding-bottom:6px; }
        .bill-row { display:flex; justify-content:space-between; padding:8px 0; font-size:14px; color:#2c3e50; border-bottom:1px solid #f9f9f9; }
        .bill-row.total { font-size:20px; font-weight:800; color:#0a3d62; border-top:2px solid #0a3d62; border-bottom:none; padding-top:14px; margin-top:6px; }
        .bill-row.tax { color:#e67e22; }
        .strategy-badge { display:inline-block; background:#eaf4fb; color:#1e6091; padding:3px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .btn { padding:11px 22px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-print { background:#27ae60; color:white; }
        .btn-secondary { background:#ecf0f1; color:#2c3e50; }
        .alert-success { background:#eafaf1; border-left:4px solid #27ae60; color:#1e8449; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:14px; }
        @media print {
            .navbar, .page-header, .btn, .alert-success { display:none !important; }
            body { background:white; }
            .card { box-shadow:none; padding:0; }
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/reservations">Reservations</a>
        <a href="${pageContext.request.contextPath}/billing">Billing</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>🧾 Bill Invoice</h2>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert-success">✓ ${successMessage}</div>
    </c:if>

    <div class="card">
        <div class="bill-header">
            <div class="hotel-name">🌊 Ocean View Resort</div>
            <div class="sub">Galle, Sri Lanka &nbsp;|&nbsp; Tel: +94 91 234 5678</div>
            <div class="res-num">INVOICE — ${reservation.reservationNumber}</div>
        </div>

        <div class="bill-section">
            <h4>Guest Details</h4>
            <div class="bill-row"><span>Guest Name</span><span>${reservation.guest.fullName}</span></div>
            <div class="bill-row"><span>Contact</span><span>${reservation.guest.contactNumber}</span></div>
            <div class="bill-row"><span>Email</span><span>${reservation.guest.email}</span></div>
            <div class="bill-row"><span>Address</span><span>${reservation.guest.address}</span></div>
        </div>

        <div class="bill-section">
            <h4>Stay Details</h4>
            <div class="bill-row"><span>Room Number</span><span>${reservation.room.roomNumber} (${reservation.room.roomType})</span></div>
            <div class="bill-row"><span>Check-In Date</span><span>${reservation.checkInDate}</span></div>
            <div class="bill-row"><span>Check-Out Date</span><span>${reservation.checkOutDate}</span></div>
            <div class="bill-row"><span>Number of Nights</span><span>${bill.numNights}</span></div>
            <div class="bill-row"><span>Rate Per Night</span><span>$${bill.ratePerNight}</span></div>
            <div class="bill-row"><span>Pricing Strategy</span><span><span class="strategy-badge">${bill.pricingStrategyUsed}</span></span></div>
        </div>

        <div class="bill-section">
            <h4>Charges</h4>
            <div class="bill-row"><span>Subtotal</span><span>$${bill.subtotal}</span></div>
            <div class="bill-row tax"><span>Tax (10%)</span><span>$${bill.taxAmount}</span></div>
            <div class="bill-row total"><span>TOTAL DUE</span><span>$${bill.totalAmount}</span></div>
        </div>

        <div style="margin-top:28px; display:flex; gap:12px;">
            <button onclick="window.print()" class="btn btn-print">🖨️ Print Invoice</button>
            <a href="${pageContext.request.contextPath}/billing" class="btn btn-secondary">← Back to History</a>
            <a href="${pageContext.request.contextPath}/billing/generate" class="btn btn-secondary">+ New Bill</a>
        </div>
    </div>
</div>
</body>
</html>

