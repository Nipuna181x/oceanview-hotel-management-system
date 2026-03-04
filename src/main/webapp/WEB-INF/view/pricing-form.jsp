<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${empty rate ? 'Add Pricing Rate' : 'Edit Pricing Rate'} — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:560px; margin:0 auto; }
        .page-header { margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .card { background:white; border-radius:12px; padding:32px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .form-group { margin-bottom:20px; }
        label { display:block; font-size:13px; font-weight:600; color:#2c3e50; margin-bottom:6px; }
        input[type=text], input[type=number], select, textarea {
            width:100%; padding:12px 14px; border:1px solid #d5d8dc; border-radius:8px;
            font-size:14px; transition:border-color 0.2s;
        }
        textarea { resize:vertical; min-height:80px; }
        input:focus, select:focus, textarea:focus { outline:none; border-color:#2980b9; box-shadow:0 0 0 3px rgba(41,128,185,0.1); }
        .hint { font-size:12px; color:#95a5a6; margin-top:4px; }
        .btn { padding:12px 24px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-secondary { background:#ecf0f1; color:#2c3e50; }
        .form-actions { display:flex; gap:12px; margin-top:28px; }
        .alert-error { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:13px; }
        .admin-badge { background:#e74c3c; color:white; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; margin-left:8px; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/pricing">Pricing Rates</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>${empty rate ? '➕ Add Pricing Rate' : '✏️ Edit Pricing Rate'} <span class="admin-badge">ADMIN</span></h2>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert-error">⚠ ${errorMessage}</div>
    </c:if>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/pricing">
            <input type="hidden" name="action" value="${empty rate ? 'create' : 'update'}"/>
            <c:if test="${not empty rate}">
                <input type="hidden" name="rateId" value="${rate.rateId}"/>
            </c:if>

            <div class="form-group">
                <label for="roomType">Room Type *</label>
                <select id="roomType" name="roomType" required>
                    <option value="SINGLE" ${rate.roomType == 'SINGLE' ? 'selected' : ''}>🛏 Single</option>
                    <option value="DOUBLE" ${rate.roomType == 'DOUBLE' ? 'selected' : ''}>🛏🛏 Double</option>
                    <option value="SUITE"  ${rate.roomType == 'SUITE'  ? 'selected' : ''}>🏨 Suite</option>
                    <option value="DELUXE" ${rate.roomType == 'DELUXE' ? 'selected' : ''}>👑 Deluxe</option>
                </select>
            </div>

            <div class="form-group">
                <label for="season">Season *</label>
                <select id="season" name="season" required>
                    <option value="STANDARD"  ${rate.season == 'STANDARD'  ? 'selected' : ''}>Standard</option>
                    <option value="PEAK"      ${rate.season == 'PEAK'      ? 'selected' : ''}>Peak Season</option>
                    <option value="OFF_PEAK"  ${rate.season == 'OFF_PEAK'  ? 'selected' : ''}>Off Peak</option>
                    <option value="WEEKEND"   ${rate.season == 'WEEKEND'   ? 'selected' : ''}>Weekend</option>
                    <option value="HOLIDAY"   ${rate.season == 'HOLIDAY'   ? 'selected' : ''}>Holiday</option>
                </select>
            </div>

            <div class="form-group">
                <label for="ratePerNight">Rate Per Night ($) *</label>
                <input type="number" id="ratePerNight" name="ratePerNight"
                       value="${not empty rate ? rate.ratePerNight : ''}"
                       required min="1" step="0.01" placeholder="e.g. 120.00"/>
            </div>

            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description"
                          placeholder="e.g. Peak season surcharge for summer months">${not empty rate ? rate.description : ''}</textarea>
                <p class="hint">Optional. Helps staff understand when this rate applies.</p>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    ${empty rate ? '➕ Add Rate' : '💾 Save Changes'}
                </button>
                <a href="${pageContext.request.contextPath}/pricing" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>

