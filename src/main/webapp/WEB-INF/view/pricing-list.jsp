<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pricing Strategies — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .admin-badge { background:#e74c3c; color:white; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; margin-left:8px; }
        .main { padding:30px; max-width:1000px; margin:0 auto; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .btn { padding:10px 20px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-warning { background:#e67e22; color:white; padding:6px 14px; font-size:13px; border-radius:6px; text-decoration:none; }
        .btn-danger  { background:#e74c3c; color:white; padding:6px 14px; font-size:13px; border-radius:6px; text-decoration:none; }
        .card { background:white; border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,0.07); overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        thead { background:#0a3d62; color:white; }
        thead th { padding:14px 16px; text-align:left; font-size:13px; font-weight:600; }
        tbody tr { border-bottom:1px solid #f0f0f0; transition:background 0.15s; }
        tbody tr:hover { background:#f8fbff; }
        tbody td { padding:14px 16px; font-size:14px; color:#2c3e50; }
        .badge { display:inline-block; padding:3px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .badge-surcharge { background:#fef9e7; color:#d68910; }
        .badge-discount  { background:#eafaf1; color:#1e8449; }
        .badge-default   { background:#eaf4fb; color:#1e6091; }
        .alert-success { background:#eafaf1; border-left:4px solid #27ae60; color:#1e8449; padding:12px 16px; border-radius:6px; margin-bottom:20px; }
        .alert-error   { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; }
        .empty-state { text-align:center; padding:60px 20px; color:#aaa; }
        .empty-state .icon { font-size:48px; margin-bottom:12px; }
        .adj-value { font-weight:700; font-size:15px; }
        .adj-surcharge { color:#d68910; }
        .adj-discount  { color:#27ae60; }
        .adj-neutral   { color:#7f8c8d; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/rooms/">Rooms</a>
        <a href="${pageContext.request.contextPath}/pricing">Pricing <span class="admin-badge">ADMIN</span></a>
        <a href="${pageContext.request.contextPath}/staff">Staff</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>💰 Pricing Strategy Management <span class="admin-badge">ADMIN</span></h2>
        <a href="${pageContext.request.contextPath}/pricing/new" class="btn btn-primary">+ Add New Strategy</a>
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert-success">✓ ${sessionScope.successMessage}</div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert-error">⚠ ${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="card">
        <c:choose>
            <c:when test="${empty strategies}">
                <div class="empty-state">
                    <div class="icon">💰</div>
                    <p>No pricing strategies configured yet.</p>
                    <br/>
                    <a href="${pageContext.request.contextPath}/pricing/new" class="btn btn-primary">Add First Strategy</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Strategy Name</th>
                            <th>Type</th>
                            <th>Adjustment</th>
                            <th>Description</th>
                            <th>Default</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${strategies}" varStatus="loop">
                            <tr>
                                <td>${loop.index + 1}</td>
                                <td><strong>${s.name}</strong></td>
                                <td>
                                    <span class="badge badge-${s.adjustmentType.toString().toLowerCase()}">${s.adjustmentType}</span>
                                </td>
                                <td>
                                    <span class="adj-value <c:choose><c:when test="${s.adjustmentPercent == 0}">adj-neutral</c:when><c:when test="${s.adjustmentType.toString() == 'DISCOUNT'}">adj-discount</c:when><c:otherwise>adj-surcharge</c:otherwise></c:choose>">
                                        ${s.adjustmentLabel}
                                    </span>
                                </td>
                                <td>${not empty s.description ? s.description : '—'}</td>
                                <td>
                                    <c:if test="${s.strategyDefault}"><span class="badge badge-default">✓ DEFAULT</span></c:if>
                                </td>
                                <td style="font-size:12px;color:#888;">${s.createdAt}</td>
                                <td style="white-space:nowrap;">
                                    <a href="${pageContext.request.contextPath}/pricing/edit?id=${s.strategyId}" class="btn-warning">✏ Edit</a>
                                    &nbsp;
                                    <c:if test="${!s.strategyDefault}">
                                        <a href="${pageContext.request.contextPath}/pricing/delete?id=${s.strategyId}"
                                           class="btn-danger"
                                           onclick="return confirm('Delete this pricing strategy?')">🗑 Delete</a>
                                    </c:if>
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

