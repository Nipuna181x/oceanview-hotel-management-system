<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Management — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; box-shadow:0 2px 8px rgba(0,0,0,0.3); }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .admin-badge { background:#e74c3c; color:white; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; margin-left:8px; }
        .main { padding:30px; max-width:1100px; margin:0 auto; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .btn { padding:10px 20px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-warning { background:#e67e22; color:white; padding:6px 14px; font-size:13px; }
        .btn-danger  { background:#e74c3c; color:white; padding:6px 14px; font-size:13px; }
        .card { background:white; border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,0.07); overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        thead { background:#0a3d62; color:white; }
        thead th { padding:14px 16px; text-align:left; font-size:13px; font-weight:600; }
        tbody tr { border-bottom:1px solid #f0f0f0; transition:background 0.15s; }
        tbody tr:hover { background:#f8fbff; }
        tbody td { padding:14px 16px; font-size:14px; color:#2c3e50; }
        .badge { display:inline-block; padding:3px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .badge-staff { background:#eaf4fb; color:#1e6091; }
        .badge-admin { background:#fdecea; color:#c0392b; }
        .badge-active { background:#eafaf1; color:#1e8449; }
        .badge-inactive { background:#fdf2f8; color:#8e44ad; }
        .alert-success { background:#eafaf1; border-left:4px solid #27ae60; color:#1e8449; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:14px; }
        .alert-error   { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:14px; }
        .empty-state { text-align:center; padding:60px 20px; color:#aaa; }
        .empty-state .icon { font-size:48px; margin-bottom:12px; }
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
        <a href="${pageContext.request.contextPath}/staff">Staff <span class="admin-badge">ADMIN</span></a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>👥 Staff Management</h2>
        <a href="${pageContext.request.contextPath}/staff/new" class="btn btn-primary">+ Add New Staff</a>
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
            <c:when test="${empty staffList}">
                <div class="empty-state">
                    <div class="icon">👤</div>
                    <p>No staff members found. Click <strong>Add New Staff</strong> to create one.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Username</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="staff" items="${staffList}" varStatus="s">
                            <tr>
                                <td>${s.index + 1}</td>
                                <td><strong>${staff.username}</strong></td>
                                <td>${not empty staff.fullName ? staff.fullName : '—'}</td>
                                <td>${not empty staff.email ? staff.email : '—'}</td>
                                <td><span class="badge badge-${staff.role == 'ADMIN' ? 'admin' : 'staff'}">${staff.role}</span></td>
                                <td><span class="badge badge-${staff.active ? 'active' : 'inactive'}">${staff.active ? 'Active' : 'Inactive'}</span></td>
                                <td>${staff.createdAt != null ? staff.createdAt : '—'}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/staff/edit?id=${staff.userId}" class="btn btn-warning">✏ Edit</a>
                                    &nbsp;
                                    <a href="${pageContext.request.contextPath}/staff/delete?id=${staff.userId}"
                                       class="btn btn-danger"
                                       onclick="return confirm('Are you sure you want to delete ${staff.username}?')">🗑 Delete</a>
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

