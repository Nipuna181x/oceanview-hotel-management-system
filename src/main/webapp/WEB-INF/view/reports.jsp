<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:1200px; margin:0 auto; }
        .page-header { margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .filter-card { background:white; border-radius:12px; padding:24px; box-shadow:0 2px 12px rgba(0,0,0,0.07); margin-bottom:24px; }
        .filter-row { display:flex; gap:16px; align-items:flex-end; flex-wrap:wrap; }
        .filter-group label { display:block; font-size:12px; font-weight:700; color:#2c3e50; margin-bottom:6px; }
        .filter-group input { padding:10px 14px; border:1px solid #d5d8dc; border-radius:8px; font-size:14px; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; border:none; padding:11px 22px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; }
        .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:16px; margin-bottom:24px; }
        .stat-card { background:white; border-radius:12px; padding:20px 24px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .stat-card .value { font-size:32px; font-weight:800; color:#0a3d62; }
        .stat-card .label { font-size:12px; color:#7f8c8d; margin-top:4px; font-weight:600; text-transform:uppercase; }
        .stat-card.blue  { border-top:4px solid #2980b9; }
        .stat-card.green { border-top:4px solid #27ae60; }
        .stat-card.orange{ border-top:4px solid #e67e22; }
        .stat-card.red   { border-top:4px solid #e74c3c; }
        .card { background:white; border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,0.07); overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        thead { background:#0a3d62; color:white; }
        th { padding:12px 16px; text-align:left; font-size:13px; font-weight:600; }
        td { padding:12px 16px; font-size:13px; color:#2c3e50; border-bottom:1px solid #f0f4f8; }
        tr:hover td { background:#f8fbff; }
        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; }
        .badge-confirmed  { background:#eaf4fb; color:#1e6091; }
        .badge-checked_in { background:#eafaf1; color:#1e8449; }
        .badge-checked_out{ background:#f4f6f7; color:#5d6d7e; }
        .badge-cancelled  { background:#fdecea; color:#c0392b; }
        .empty-state { text-align:center; padding:40px; color:#aaa; }
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
    <div class="page-header"><h2>📊 Occupancy & Revenue Reports</h2></div>

    <div class="filter-card">
        <form action="${pageContext.request.contextPath}/reports" method="get" class="filter-row">
            <div class="filter-group">
                <label>From Date</label>
                <input type="date" name="from" value="${param.from}" />
            </div>
            <div class="filter-group">
                <label>To Date</label>
                <input type="date" name="to" value="${param.to}" />
            </div>
            <button type="submit" class="btn-primary">🔍 Generate Report</button>
        </form>
    </div>

    <c:if test="${not empty summary}">
        <div class="stats-grid">
            <div class="stat-card blue"><div class="value">${summary.totalReservations}</div><div class="label">Total Reservations</div></div>
            <div class="stat-card green"><div class="value">${summary.confirmedCount}</div><div class="label">Confirmed</div></div>
            <div class="stat-card orange"><div class="value">${summary.checkedOutCount}</div><div class="label">Checked Out</div></div>
            <div class="stat-card red"><div class="value">${summary.cancelledCount}</div><div class="label">Cancelled</div></div>
        </div>
    </c:if>

    <c:if test="${not empty reservations}">
        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>Res. Number</th>
                        <th>Guest Name</th>
                        <th>Room</th>
                        <th>Check-In</th>
                        <th>Check-Out</th>
                        <th>Nights</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="res" items="${reservations}">
                        <tr>
                            <td><strong>${res.reservationNumber}</strong></td>
                            <td>${res.guest.fullName}</td>
                            <td>${res.room.roomNumber} (${res.room.roomType})</td>
                            <td>${res.checkInDate}</td>
                            <td>${res.checkOutDate}</td>
                            <td>${res.checkOutDate.toEpochDay() - res.checkInDate.toEpochDay()}</td>
                            <td><span class="badge badge-${res.status.toString().toLowerCase()}">${res.status}</span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
    <c:if test="${empty reservations && not empty param.from}">
        <div class="card"><div class="empty-state">No reservations found for the selected date range.</div></div>
    </c:if>
</div>
</body>
</html>

