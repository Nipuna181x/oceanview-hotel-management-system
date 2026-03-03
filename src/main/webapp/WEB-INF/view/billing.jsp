<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Billing — Ocean View Resort HMS</title>
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
        .card { background:white; border-radius:12px; padding:32px; box-shadow:0 2px 12px rgba(0,0,0,0.07); margin-bottom:20px; }
        .bill-header { text-align:center; padding-bottom:20px; border-bottom:2px dashed #ddd; margin-bottom:24px; }
        .bill-header .hotel-name { font-size:22px; font-weight:800; color:#0a3d62; }
        .bill-header .sub { font-size:13px; color:#7f8c8d; margin-top:4px; }
        .bill-header .res-num { font-size:16px; font-weight:700; color:#2980b9; margin-top:8px; font-family:monospace; }
        .bill-section { margin-bottom:20px; }
        .bill-section h4 { font-size:13px; font-weight:700; color:#1e6091; margin-bottom:10px; text-transform:uppercase; letter-spacing:0.5px; }
        .bill-row { display:flex; justify-content:space-between; padding:8px 0; font-size:14px; color:#2c3e50; border-bottom:1px solid #f5f5f5; }
        .bill-row.total { font-size:18px; font-weight:800; color:#0a3d62; border-top:2px solid #0a3d62; border-bottom:none; padding-top:14px; margin-top:4px; }
        .bill-row.tax { color:#e67e22; }
        .strategy-badge { display:inline-block; background:#eaf4fb; color:#1e6091; padding:3px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .search-form { display:flex; gap:12px; margin-bottom:24px; }
        .search-form input { flex:1; padding:11px 14px; border:1px solid #d5d8dc; border-radius:8px; font-size:14px; }
        .search-form select { padding:11px 14px; border:1px solid #d5d8dc; border-radius:8px; font-size:14px; }
        .btn { padding:11px 22px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-print { background:#27ae60; color:white; }
        .alert-error { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; font-size:13px; margin-bottom:20px; }
        @media print {
            .navbar, .search-form, .btn, .page-header { display:none !important; }
            body { background:white; }
            .card { box-shadow:none; }
        }
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
        <h2>💳 Billing</h2>
    </div>

    <div class="card">
        <form action="${pageContext.request.contextPath}/billing" method="get" class="search-form">
            <input type="number" name="reservationId" placeholder="Enter Reservation ID"
                   value="${param.reservationId}" min="1" required />
            <select name="strategy">
                <option value="STANDARD" ${param.strategy == 'STANDARD' ? 'selected' : ''}>Standard Rate</option>
                <option value="SEASONAL" ${param.strategy == 'SEASONAL' ? 'selected' : ''}>Seasonal (+20%)</option>
                <option value="DISCOUNT" ${param.strategy == 'DISCOUNT' ? 'selected' : ''}>Long Stay (-10%)</option>
            </select>
            <button type="submit" class="btn btn-primary">Generate Bill</button>
        </form>

        <c:if test="${not empty errorMessage}">
            <div class="alert-error">⚠ ${errorMessage}</div>
        </c:if>

        <c:if test="${not empty bill}">
            <div class="bill-header">
                <div class="hotel-name">🌊 Ocean View Resort</div>
                <div class="sub">Galle, Sri Lanka | Tel: +94 91 234 5678</div>
                <div class="res-num">INVOICE — ${reservation.reservationNumber}</div>
            </div>

            <div class="bill-section">
                <h4>Guest Details</h4>
                <div class="bill-row"><span>Guest Name</span><span>${reservation.guest.fullName}</span></div>
                <div class="bill-row"><span>Contact</span><span>${reservation.guest.contactNumber}</span></div>
                <div class="bill-row"><span>Address</span><span>${reservation.guest.address}</span></div>
            </div>

            <div class="bill-section">
                <h4>Stay Details</h4>
                <div class="bill-row"><span>Room Number</span><span>${reservation.room.roomNumber} (${reservation.room.roomType})</span></div>
                <div class="bill-row"><span>Check-In</span><span>${reservation.checkInDate}</span></div>
                <div class="bill-row"><span>Check-Out</span><span>${reservation.checkOutDate}</span></div>
                <div class="bill-row"><span>Number of Nights</span><span>${bill.numNights}</span></div>
                <div class="bill-row"><span>Rate Per Night</span><span>$${bill.ratePerNight}</span></div>
                <div class="bill-row"><span>Pricing Strategy</span><span><span class="strategy-badge">${bill.pricingStrategyUsed}</span></span></div>
            </div>

            <div class="bill-section">
                <h4>Amount</h4>
                <div class="bill-row"><span>Subtotal</span><span>$${bill.subtotal}</span></div>
                <div class="bill-row tax"><span>Tax (10%)</span><span>$${bill.taxAmount}</span></div>
                <div class="bill-row total"><span>TOTAL DUE</span><span>$${bill.totalAmount}</span></div>
            </div>

            <div style="margin-top:20px; display:flex; gap:12px;">
                <button onclick="window.print()" class="btn btn-print">🖨️ Print Invoice</button>
                <a href="${pageContext.request.contextPath}/reservations" class="btn" style="background:#ecf0f1;color:#2c3e50;">← Back</a>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>

