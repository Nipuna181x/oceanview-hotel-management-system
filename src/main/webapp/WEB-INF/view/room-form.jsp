<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${empty room ? 'Add Room' : 'Edit Room'} — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:620px; margin:0 auto; }
        .page-header { margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .card { background:white; border-radius:12px; padding:32px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .form-group { margin-bottom:20px; }
        label { display:block; font-size:13px; font-weight:600; color:#2c3e50; margin-bottom:6px; }
        input[type=text], input[type=number], select, textarea {
            width:100%; padding:12px 14px; border:1px solid #d5d8dc; border-radius:8px;
            font-size:14px; transition:border-color 0.2s; font-family:'Segoe UI',sans-serif;
        }
        textarea { resize:vertical; min-height:90px; }
        input:focus, select:focus, textarea:focus { outline:none; border-color:#2980b9; box-shadow:0 0 0 3px rgba(41,128,185,0.1); }
        .input-prefix { position:relative; }
        .input-prefix span { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:#7f8c8d; font-size:14px; font-weight:600; pointer-events:none; }
        .input-prefix input { padding-left:38px; }
        .btn { padding:12px 24px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-secondary { background:#ecf0f1; color:#2c3e50; }
        .form-actions { display:flex; gap:12px; margin-top:28px; }
        .alert-error { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:13px; }
        .admin-badge { background:#e74c3c; color:white; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; margin-left:8px; }
        .section-label { font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:0.8px; color:#7f8c8d; margin-bottom:16px; margin-top:4px; padding-bottom:8px; border-bottom:1px solid #f0f0f0; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/rooms">Rooms</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>${empty room ? '➕ Add New Room' : '✏️ Edit Room'} <span class="admin-badge">ADMIN</span></h2>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert-error">⚠ ${errorMessage}</div>
    </c:if>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/rooms">
            <input type="hidden" name="action" value="${empty room ? 'create' : 'update'}"/>
            <c:if test="${not empty room}">
                <input type="hidden" name="roomId" value="${room.roomId}"/>
            </c:if>

            <div class="section-label">Room Identity</div>

            <div class="form-row">
                <div class="form-group">
                    <label for="roomNumber">Room No. *</label>
                    <input type="text" id="roomNumber" name="roomNumber"
                           value="${not empty room ? room.roomNumber : ''}"
                           required placeholder="e.g. 101, 201A"/>
                </div>
                <div class="form-group">
                    <label for="roomType">Room Type *</label>
                    <select id="roomType" name="roomType" required>
                        <option value="">-- Select Type --</option>
                        <option value="SINGLE"  ${room.roomType == 'SINGLE'  ? 'selected' : ''}>🛏  Single</option>
                        <option value="DOUBLE"  ${room.roomType == 'DOUBLE'  ? 'selected' : ''}>🛏🛏 Double</option>
                        <option value="SUITE"   ${room.roomType == 'SUITE'   ? 'selected' : ''}>🏨  Suite</option>
                        <option value="DELUXE"  ${room.roomType == 'DELUXE'  ? 'selected' : ''}>👑  Deluxe</option>
                    </select>
                </div>
            </div>

            <div class="section-label">Capacity &amp; Pricing</div>

            <div class="form-row">
                <div class="form-group">
                    <label for="maxOccupancy">Max Occupancy *</label>
                    <input type="number" id="maxOccupancy" name="maxOccupancy"
                           value="${not empty room ? room.maxOccupancy : '2'}"
                           required min="1" max="20" placeholder="e.g. 2"/>
                </div>
                <div class="form-group">
                    <label for="ratePerNight">Rate Per Night (Rs.) *</label>
                    <div class="input-prefix">
                        <span>Rs.</span>
                        <input type="number" id="ratePerNight" name="ratePerNight"
                               value="${not empty room ? room.ratePerNight : ''}"
                               required min="1" step="0.01" placeholder="e.g. 15000.00"/>
                    </div>
                </div>
            </div>

            <div class="section-label">Details &amp; Status</div>

            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description"
                          placeholder="e.g. Sea-facing room with balcony, king-size bed, air conditioning...">${not empty room ? room.description : ''}</textarea>
            </div>

            <div class="form-group">
                <label for="available">Status *</label>
                <select id="available" name="available" required>
                    <option value="true"  ${(empty room || room.available)  ? 'selected' : ''}>✓ Available</option>
                    <option value="false" ${(not empty room && !room.available) ? 'selected' : ''}>✗ Occupied / Unavailable</option>
                </select>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    ${empty room ? '➕ Add Room' : '💾 Save Changes'}
                </button>
                <a href="${pageContext.request.contextPath}/rooms" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>

