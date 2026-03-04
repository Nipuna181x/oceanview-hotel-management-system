<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Rooms — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:1200px; margin:0 auto; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .filter-bar { display:flex; gap:10px; margin-bottom:24px; flex-wrap:wrap; align-items:center; }
        .filter-btn { padding:8px 18px; border-radius:20px; border:2px solid #d5d8dc; background:white; color:#555; font-size:13px; font-weight:600; cursor:pointer; text-decoration:none; transition:all 0.2s; }
        .filter-btn.active, .filter-btn:hover { background:#0a3d62; color:white; border-color:#0a3d62; }
        .rooms-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:20px; }
        .room-card { background:white; border-radius:12px; padding:24px; box-shadow:0 2px 12px rgba(0,0,0,0.07); transition:transform 0.2s; }
        .room-card:hover { transform:translateY(-3px); }
        .room-card .room-icon { font-size:36px; margin-bottom:12px; }
        .room-card .room-number { font-size:20px; font-weight:800; color:#0a3d62; }
        .room-card .room-type { font-size:13px; color:#7f8c8d; margin:4px 0 12px; text-transform:uppercase; letter-spacing:0.5px; }
        .room-card .rate { font-size:22px; font-weight:700; color:#2980b9; }
        .room-card .rate span { font-size:13px; color:#aaa; font-weight:400; }
        .avail-badge { display:inline-block; padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700; margin-top:12px; }
        .avail-yes { background:#eafaf1; color:#1e8449; }
        .avail-no  { background:#fdecea; color:#c0392b; }
        .room-card.single  { border-top:4px solid #3498db; }
        .room-card.double  { border-top:4px solid #2ecc71; }
        .room-card.suite   { border-top:4px solid #9b59b6; }
        .room-card.deluxe  { border-top:4px solid #e67e22; }
        .admin-actions { display:flex; gap:8px; margin-top:14px; padding-top:14px; border-top:1px solid #f0f0f0; }
        .btn { padding:6px 14px; border-radius:6px; font-size:12px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; padding:10px 20px; font-size:14px; border-radius:8px; }
        .btn-warning { background:#e67e22; color:white; }
        .btn-danger  { background:#e74c3c; color:white; }
        .alert-success { background:#eafaf1; border-left:4px solid #27ae60; color:#1e8449; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:14px; }
        .alert-error   { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:14px; }
        .admin-badge { background:#e74c3c; color:white; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; margin-left:8px; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/reservations">Reservations</a>
        <a href="${pageContext.request.contextPath}/rooms">Rooms</a>
        <a href="${pageContext.request.contextPath}/billing/">Billing</a>
        <a href="${pageContext.request.contextPath}/reports">Reports</a>
        <a href="${pageContext.request.contextPath}/help">Help</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>🛏️ Room Management</h2>
        <c:if test="${isAdmin}">
            <a href="${pageContext.request.contextPath}/rooms/new" class="btn btn-primary">+ Add New Room</a>
        </c:if>
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert-success">✓ ${sessionScope.successMessage}</div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert-error">⚠ ${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="filter-bar">
        <a href="${pageContext.request.contextPath}/rooms" class="filter-btn ${empty param.type ? 'active' : ''}">All Rooms</a>
        <a href="${pageContext.request.contextPath}/rooms?type=SINGLE" class="filter-btn ${param.type == 'SINGLE' ? 'active' : ''}">Single</a>
        <a href="${pageContext.request.contextPath}/rooms?type=DOUBLE" class="filter-btn ${param.type == 'DOUBLE' ? 'active' : ''}">Double</a>
        <a href="${pageContext.request.contextPath}/rooms?type=SUITE"  class="filter-btn ${param.type == 'SUITE'  ? 'active' : ''}">Suite</a>
        <a href="${pageContext.request.contextPath}/rooms?type=DELUXE" class="filter-btn ${param.type == 'DELUXE' ? 'active' : ''}">Deluxe</a>
    </div>

    <div class="rooms-grid">
        <c:forEach var="room" items="${rooms}">
            <div class="room-card ${room.roomType.toString().toLowerCase()}">
                <div class="room-icon">
                    <c:choose>
                        <c:when test="${room.roomType == 'SINGLE'}">🛏</c:when>
                        <c:when test="${room.roomType == 'DOUBLE'}">🛏🛏</c:when>
                        <c:when test="${room.roomType == 'SUITE'}">🏨</c:when>
                        <c:otherwise>👑</c:otherwise>
                    </c:choose>
                </div>
                <div class="room-number">Room ${room.roomNumber}</div>
                <div class="room-type">${room.roomType}</div>
                <div class="rate">$${room.ratePerNight}<span>/night</span></div>
                <div>
                    <span class="avail-badge ${room.available ? 'avail-yes' : 'avail-no'}">
                        ${room.available ? '✓ Available' : '✗ Occupied'}
                    </span>
                </div>
                <c:if test="${isAdmin}">
                    <div class="admin-actions">
                        <a href="${pageContext.request.contextPath}/rooms/edit?id=${room.roomId}" class="btn btn-warning">✏ Edit</a>
                        <a href="${pageContext.request.contextPath}/rooms/delete?id=${room.roomId}"
                           class="btn btn-danger"
                           onclick="return confirm('Delete Room ${room.roomNumber}?')">🗑 Delete</a>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>


