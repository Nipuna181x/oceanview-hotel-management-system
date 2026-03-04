<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Generate Bill — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:600px; margin:0 auto; }
        .page-header { margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .card { background:white; border-radius:12px; padding:32px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .form-group { margin-bottom:20px; }
        label { display:block; font-size:13px; font-weight:600; color:#2c3e50; margin-bottom:6px; }
        input[type=number], select {
            width:100%; padding:12px 14px; border:1px solid #d5d8dc; border-radius:8px;
            font-size:14px; transition:border-color 0.2s;
        }
        input:focus, select:focus { outline:none; border-color:#2980b9; box-shadow:0 0 0 3px rgba(41,128,185,0.1); }
        .hint { font-size:12px; color:#95a5a6; margin-top:4px; }
        .btn { padding:12px 24px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-secondary { background:#ecf0f1; color:#2c3e50; }
        .form-actions { display:flex; gap:12px; margin-top:28px; }
        .alert-error { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:13px; }
        .strategy-info { background:#f8fbff; border-radius:8px; padding:16px; margin-bottom:20px; }
        .strategy-info h4 { font-size:13px; font-weight:700; color:#1e6091; margin-bottom:10px; }
        .strategy-info ul { list-style:none; font-size:13px; color:#555; }
        .strategy-info ul li { padding:4px 0; }
        .strategy-info ul li span { font-weight:600; color:#0a3d62; }
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
        <h2>🧾 Generate New Bill</h2>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert-error">⚠ ${errorMessage}</div>
    </c:if>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/billing/generate">

            <div class="form-group">
                <label for="reservationId">Reservation ID *</label>
                <input type="number" id="reservationId" name="reservationId"
                       value="${param.reservationId}" min="1" required
                       placeholder="Enter the numeric reservation ID"/>
                <p class="hint">You can find the reservation ID in the Reservations list.</p>
            </div>

            <div class="form-group">
                <label for="strategy">Pricing Strategy *</label>
                <select id="strategy" name="strategy">
                    <option value="STANDARD" ${param.strategy == 'STANDARD' || empty param.strategy ? 'selected' : ''}>
                        Standard Rate — base rate per night
                    </option>
                    <option value="SEASONAL" ${param.strategy == 'SEASONAL' ? 'selected' : ''}>
                        Seasonal Rate — base rate + 20% peak surcharge
                    </option>
                    <option value="DISCOUNT" ${param.strategy == 'DISCOUNT' ? 'selected' : ''}>
                        Long Stay Discount — 10% off for 7+ nights
                    </option>
                </select>
            </div>

            <div class="strategy-info">
                <h4>📋 Strategy Reference</h4>
                <ul>
                    <li>🔵 <span>STANDARD</span> — Room rate × nights + 10% tax</li>
                    <li>🟡 <span>SEASONAL</span> — Room rate × 1.20 × nights + 10% tax</li>
                    <li>🟢 <span>DISCOUNT</span> — Room rate × 0.90 × nights + 10% tax (7+ nights only)</li>
                </ul>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">🧾 Generate Bill</button>
                <a href="${pageContext.request.contextPath}/billing" class="btn btn-secondary">← Back to History</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>

