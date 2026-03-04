<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Logs — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .admin-badge { background:#e74c3c; color:white; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; margin-left:8px; }
        .main { padding:30px; max-width:1200px; margin:0 auto; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .filter-bar { background:white; border-radius:12px; padding:20px 24px; box-shadow:0 2px 12px rgba(0,0,0,0.07); margin-bottom:24px; display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap; }
        .filter-bar .form-group { display:flex; flex-direction:column; gap:6px; }
        .filter-bar label { font-size:12px; font-weight:600; color:#555; }
        .filter-bar select, .filter-bar input { padding:9px 12px; border:1px solid #d5d8dc; border-radius:8px; font-size:13px; min-width:180px; }
        .btn { padding:10px 20px; border-radius:8px; font-size:13px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-secondary { background:#ecf0f1; color:#2c3e50; }
        .card { background:white; border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,0.07); overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        thead { background:#0a3d62; color:white; }
        thead th { padding:12px 16px; text-align:left; font-size:12px; font-weight:600; text-transform:uppercase; letter-spacing:0.5px; }
        tbody tr { border-bottom:1px solid #f0f0f0; transition:background 0.15s; }
        tbody tr:hover { background:#f8fbff; }
        tbody td { padding:12px 16px; font-size:13px; color:#2c3e50; }
        .action-badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; font-family:monospace; }
        .action-create   { background:#eafaf1; color:#1e8449; }
        .action-update   { background:#fef9e7; color:#d68910; }
        .action-delete   { background:#fdecea; color:#c0392b; }
        .action-login    { background:#eaf4fb; color:#1e6091; }
        .action-logout   { background:#f0f3f4; color:#566573; }
        .action-default  { background:#f0f3f4; color:#2c3e50; }
        .empty-state { text-align:center; padding:60px 20px; color:#aaa; }
        .empty-state .icon { font-size:48px; margin-bottom:12px; }
        .ip-text { font-family:monospace; font-size:12px; color:#888; }
        .time-text { font-size:12px; color:#888; }
        .total-count { font-size:13px; color:#888; margin-bottom:12px; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/reservations">Reservations</a>
        <a href="${pageContext.request.contextPath}/staff">Staff</a>
        <a href="${pageContext.request.contextPath}/pricing">Pricing</a>
        <a href="${pageContext.request.contextPath}/logs">Logs <span class="admin-badge">ADMIN</span></a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>📋 System Logs <span class="admin-badge">ADMIN</span></h2>
    </div>

    <%-- Filter Bar --%>
    <div class="filter-bar">
        <form method="get" action="${pageContext.request.contextPath}/logs" style="display:flex;gap:12px;align-items:flex-end;flex-wrap:wrap;">
            <div class="form-group">
                <label>Filter by Action</label>
                <select name="action">
                    <option value="">All Actions</option>
                    <option value="LOGIN"               ${filterAction == 'LOGIN'               ? 'selected' : ''}>LOGIN</option>
                    <option value="LOGOUT"              ${filterAction == 'LOGOUT'              ? 'selected' : ''}>LOGOUT</option>
                    <option value="CREATE_RESERVATION"  ${filterAction == 'CREATE_RESERVATION'  ? 'selected' : ''}>CREATE_RESERVATION</option>
                    <option value="UPDATE_RESERVATION"  ${filterAction == 'UPDATE_RESERVATION'  ? 'selected' : ''}>UPDATE_RESERVATION</option>
                    <option value="CANCEL_RESERVATION"  ${filterAction == 'CANCEL_RESERVATION'  ? 'selected' : ''}>CANCEL_RESERVATION</option>
                    <option value="GENERATE_BILL"       ${filterAction == 'GENERATE_BILL'       ? 'selected' : ''}>GENERATE_BILL</option>
                    <option value="ADD_ROOM"            ${filterAction == 'ADD_ROOM'            ? 'selected' : ''}>ADD_ROOM</option>
                    <option value="DELETE_ROOM"         ${filterAction == 'DELETE_ROOM'         ? 'selected' : ''}>DELETE_ROOM</option>
                    <option value="CREATE_STAFF"        ${filterAction == 'CREATE_STAFF'        ? 'selected' : ''}>CREATE_STAFF</option>
                    <option value="DELETE_STAFF"        ${filterAction == 'DELETE_STAFF'        ? 'selected' : ''}>DELETE_STAFF</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">🔍 Filter</button>
            <a href="${pageContext.request.contextPath}/logs" class="btn btn-secondary">↺ Reset</a>
        </form>
    </div>

    <c:if test="${not empty logs}">
        <p class="total-count">Showing <strong>${logs.size()}</strong> log entries</p>
    </c:if>

    <div class="card">
        <c:choose>
            <c:when test="${empty logs}">
                <div class="empty-state">
                    <div class="icon">📋</div>
                    <p>No log entries found.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Log #</th>
                            <th>Timestamp</th>
                            <th>User</th>
                            <th>Action</th>
                            <th>Details</th>
                            <th>IP Address</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="log" items="${logs}">
                            <tr>
                                <td>#${log.logId}</td>
                                <td class="time-text">${log.loggedAt}</td>
                                <td><strong>${not empty log.username ? log.username : '—'}</strong></td>
                                <td>
                                    <c:set var="actionLower" value="${log.action.toLowerCase()}"/>
                                    <span class="action-badge
                                        <c:choose>
                                            <c:when test="${actionLower.startsWith('create') || actionLower.startsWith('add')}">action-create</c:when>
                                            <c:when test="${actionLower.startsWith('update')}">action-update</c:when>
                                            <c:when test="${actionLower.startsWith('delete') || actionLower.startsWith('cancel')}">action-delete</c:when>
                                            <c:when test="${actionLower == 'login'}">action-login</c:when>
                                            <c:when test="${actionLower == 'logout'}">action-logout</c:when>
                                            <c:otherwise>action-default</c:otherwise>
                                        </c:choose>
                                    ">${log.action}</span>
                                </td>
                                <td>${not empty log.details ? log.details : '—'}</td>
                                <td class="ip-text">${not empty log.ipAddress ? log.ipAddress : '—'}</td>
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

