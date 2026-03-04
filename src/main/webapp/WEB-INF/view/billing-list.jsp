<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bill History — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; box-shadow:0 2px 8px rgba(0,0,0,0.3); }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:1100px; margin:0 auto; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .btn { padding:10px 20px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-view { background:#1e6091; color:white; padding:6px 14px; font-size:13px; }
        .card { background:white; border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,0.07); overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        thead { background:#0a3d62; color:white; }
        thead th { padding:14px 16px; text-align:left; font-size:13px; font-weight:600; }
        tbody tr { border-bottom:1px solid #f0f0f0; transition:background 0.15s; }
        tbody tr:hover { background:#f8fbff; }
        tbody td { padding:14px 16px; font-size:14px; color:#2c3e50; }
        .badge { display:inline-block; padding:3px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .badge-standard { background:#eaf4fb; color:#1e6091; }
        .badge-seasonal  { background:#fef9e7; color:#d68910; }
        .badge-discount  { background:#eafaf1; color:#1e8449; }
        .alert-error { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:14px; }
        .empty-state { text-align:center; padding:60px 20px; color:#aaa; }
        .empty-state .icon { font-size:48px; margin-bottom:12px; }
        .total-amount { font-weight:700; color:#0a3d62; }
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
        <h2>💳 Bill History</h2>
        <a href="${pageContext.request.contextPath}/billing/generate" class="btn btn-primary">+ Generate New Bill</a>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert-error">⚠ ${errorMessage}</div>
    </c:if>

    <div class="card">
        <c:choose>
            <c:when test="${empty bills}">
                <div class="empty-state">
                    <div class="icon">🧾</div>
                    <p>No bills have been generated yet.</p>
                    <br/>
                    <a href="${pageContext.request.contextPath}/billing/generate" class="btn btn-primary">Generate First Bill</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Bill #</th>
                            <th>Reservation</th>
                            <th>Guest</th>
                            <th>Nights</th>
                            <th>Rate/Night</th>
                            <th>Strategy</th>
                            <th>Subtotal</th>
                            <th>Tax</th>
                            <th>Total</th>
                            <th>Generated</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="bill" items="${bills}">
                            <tr>
                                <td>#${bill.billId}</td>
                                <td><code>${not empty bill.reservationNumber ? bill.reservationNumber : bill.reservationId}</code></td>
                                <td>${not empty bill.guestName ? bill.guestName : '—'}</td>
                                <td>${bill.numNights}</td>
                                <td>$${bill.ratePerNight}</td>
                                <td>
                                    <span class="badge badge-${bill.pricingStrategyUsed.toLowerCase()}">
                                        ${bill.pricingStrategyUsed}
                                    </span>
                                </td>
                                <td>$${bill.subtotal}</td>
                                <td>$${bill.taxAmount}</td>
                                <td class="total-amount">$${bill.totalAmount}</td>
                                <td style="font-size:12px;color:#888;">${bill.generatedAt}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/billing/view?billId=${bill.billId}" class="btn btn-view">👁 View</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>

