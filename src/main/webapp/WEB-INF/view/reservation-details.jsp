<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reservation Details — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:900px; margin:0 auto; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .card { background:white; border-radius:12px; padding:32px; box-shadow:0 2px 12px rgba(0,0,0,0.07); margin-bottom:20px; }
        .section-title { font-size:14px; font-weight:700; color:#1e6091; margin-bottom:16px; padding-bottom:8px; border-bottom:2px solid #eaf4fb; }
        .detail-grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .detail-item label { display:block; font-size:11px; font-weight:700; color:#7f8c8d; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:4px; }
        .detail-item span { font-size:15px; color:#2c3e50; font-weight:500; }
        .badge { display:inline-block; padding:4px 14px; border-radius:20px; font-size:12px; font-weight:700; }
        .badge-confirmed  { background:#eaf4fb; color:#1e6091; }
        .badge-checked_in { background:#eafaf1; color:#1e8449; }
        .badge-checked_out{ background:#f4f6f7; color:#5d6d7e; }
        .badge-cancelled  { background:#fdecea; color:#c0392b; }
        .btn-row { display:flex; gap:12px; margin-top:8px; flex-wrap:wrap; }
        .btn { padding:10px 22px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-green   { background:#27ae60; color:white; }
        .btn-danger  { background:#e74c3c; color:white; }
        .btn-secondary { background:#ecf0f1; color:#2c3e50; }
        .res-number { font-size:24px; font-weight:800; color:#0a3d62; font-family:monospace; }
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
        <h2>🔍 Reservation Details</h2>
        <a href="${pageContext.request.contextPath}/reservations" class="btn btn-secondary">← Back to List</a>
    </div>

    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
            <div class="res-number">${reservation.reservationNumber}</div>
            <span class="badge badge-${reservation.status.toString().toLowerCase()}">${reservation.status}</span>
        </div>

        <div class="section-title">👤 Guest Information</div>
        <div class="detail-grid" style="margin-bottom:24px;">
            <div class="detail-item"><label>Full Name</label><span>${reservation.guest.fullName}</span></div>
            <div class="detail-item"><label>Contact Number</label><span>${reservation.guest.contactNumber}</span></div>
            <div class="detail-item"><label>Email</label><span>${not empty reservation.guest.email ? reservation.guest.email : '—'}</span></div>
            <div class="detail-item"><label>Address</label><span>${reservation.guest.address}</span></div>
        </div>

        <div class="section-title">🛏️ Room & Stay Details</div>
        <div class="detail-grid" style="margin-bottom:24px;">
            <div class="detail-item"><label>Room Number</label><span>${reservation.room.roomNumber}</span></div>
            <div class="detail-item"><label>Room Type</label><span>${reservation.room.roomType}</span></div>
            <div class="detail-item"><label>Rate Per Night</label><span>$${reservation.room.ratePerNight}</span></div>
            <div class="detail-item"><label>Check-In Date</label><span>${reservation.checkInDate}</span></div>
            <div class="detail-item"><label>Check-Out Date</label><span>${reservation.checkOutDate}</span></div>
            <div class="detail-item"><label>Created At</label><span>${reservation.createdAt}</span></div>
        </div>

        <div class="btn-row">
            <c:if test="${reservation.status == 'CONFIRMED'}">
                <a href="${pageContext.request.contextPath}/reservations/${reservation.reservationId}/checkin"
                   class="btn btn-green">✓ Check In</a>
            </c:if>
            <c:if test="${reservation.status == 'CHECKED_IN'}">
                <a href="${pageContext.request.contextPath}/reservations/${reservation.reservationId}/checkout"
                   class="btn btn-primary">⬆ Check Out</a>
            </c:if>
            <c:if test="${reservation.status == 'CHECKED_IN' || reservation.status == 'CHECKED_OUT'}">
                <a href="${pageContext.request.contextPath}/billing?reservationId=${reservation.reservationId}"
                   class="btn btn-primary">💳 View / Generate Bill</a>
            </c:if>
            <c:if test="${reservation.status == 'CONFIRMED' || reservation.status == 'CHECKED_IN'}">
                <a href="${pageContext.request.contextPath}/reservations/${reservation.reservationId}/cancel"
                   class="btn btn-danger"
                   onclick="return confirm('Are you sure you want to cancel this reservation?')">✕ Cancel</a>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>

