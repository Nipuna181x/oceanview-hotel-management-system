<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reservations — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:1200px; margin:0 auto; }
        .top-bar { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .top-bar h2 { color:#0a3d62; font-size:22px; }
        .btn-new { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; text-decoration:none; padding:10px 20px; border-radius:8px; font-size:14px; font-weight:600; }
        .alert-success { background:#eafaf1; border-left:4px solid #2ecc71; color:#1e8449; padding:12px 16px; border-radius:6px; font-size:13px; margin-bottom:20px; }
        .search-bar { background:white; border-radius:12px; padding:16px 20px; box-shadow:0 2px 12px rgba(0,0,0,0.07); margin-bottom:20px; display:flex; gap:12px; flex-wrap:wrap; align-items:center; }
        .search-bar input, .search-bar select { padding:9px 14px; border:1px solid #d5d8dc; border-radius:8px; font-size:13px; outline:none; }
        .search-bar input { flex:1; min-width:200px; }
        .search-bar input:focus, .search-bar select:focus { border-color:#2980b9; }
        .search-bar label { font-size:12px; font-weight:700; color:#555; white-space:nowrap; }
        .search-bar .clear-btn { padding:9px 16px; border-radius:8px; border:none; background:#ecf0f1; color:#555; font-size:13px; cursor:pointer; font-weight:600; }
        .search-bar .clear-btn:hover { background:#d5d8dc; }
        .result-count { font-size:12px; color:#888; padding:0 4px; }
        .card { background:white; border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,0.07); overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        thead { background:#0a3d62; color:white; }
        th { padding:14px 16px; text-align:left; font-size:13px; font-weight:600; }
        td { padding:13px 16px; font-size:13px; color:#2c3e50; border-bottom:1px solid #f0f4f8; }
        tr:hover td { background:#f8fbff; }
        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; }
        .badge-confirmed  { background:#eaf4fb; color:#1e6091; }
        .badge-checked_in { background:#eafaf1; color:#1e8449; }
        .badge-checked_out{ background:#f4f6f7; color:#5d6d7e; }
        .badge-cancelled  { background:#fdecea; color:#c0392b; }
        .btn-sm { padding:5px 12px; border-radius:6px; font-size:12px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-view   { background:#eaf4fb; color:#1e6091; }
        .btn-cancel { background:#fdecea; color:#c0392b; }
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
        <a href="${pageContext.request.contextPath}/help">Help</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="top-bar">
        <h2>📁 All Reservations</h2>
        <a href="${pageContext.request.contextPath}/reservations/new" class="btn-new">+ New Reservation</a>
    </div>
    <c:if test="${not empty successMessage}">
        <div class="alert-success">✓ ${successMessage}</div>
    </c:if>

    <%-- Search & Filter Bar --%>
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="🔍 Search by guest name, reservation number, room..." oninput="filterTable()">
        <div>
            <label>Status</label><br>
            <select id="statusFilter" onchange="filterTable()">
                <option value="">All Statuses</option>
                <option value="CONFIRMED">Confirmed</option>
                <option value="CHECKED_IN">Checked In</option>
                <option value="CHECKED_OUT">Checked Out</option>
                <option value="CANCELLED">Cancelled</option>
            </select>
        </div>
        <div>
            <label>Check-In From</label><br>
            <input type="date" id="dateFrom" onchange="filterTable()" style="min-width:0;width:140px;">
        </div>
        <div>
            <label>Check-In To</label><br>
            <input type="date" id="dateTo" onchange="filterTable()" style="min-width:0;width:140px;">
        </div>
        <button class="clear-btn" onclick="clearFilters()">✕ Clear</button>
        <span class="result-count" id="resultCount"></span>
    </div>

    <div class="card">
        <c:choose>
            <c:when test="${not empty reservations}">
                <table>
                    <thead>
                        <tr>
                            <th>Res. Number</th>
                            <th>Guest Name</th>
                            <th>Room</th>
                            <th>Check-In</th>
                            <th>Check-Out</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="res" items="${reservations}">
                            <tr data-search="${res.reservationNumber} ${res.guest.fullName} ${res.room.roomNumber} ${res.room.roomType}"
                                data-status="${res.status}"
                                data-checkin="${res.checkInDate}">
                                <td><strong>${res.reservationNumber}</strong></td>
                                <td>${res.guest.fullName}</td>
                                <td>Room ${res.room.roomNumber} (${res.room.roomType})</td>
                                <td>${res.checkInDate}</td>
                                <td>${res.checkOutDate}</td>
                                <td>
                                    <span class="badge badge-${res.status.toString().toLowerCase()}">
                                        ${res.status}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/reservations/${res.reservationNumber}" class="btn-sm btn-view">View</a>
                                    <c:if test="${res.status == 'CONFIRMED' || res.status == 'CHECKED_IN'}">
                                        <a href="${pageContext.request.contextPath}/reservations/${res.reservationId}/cancel"
                                           class="btn-sm btn-cancel"
                                           onclick="return confirm('Cancel this reservation?')">Cancel</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="icon">📋</div>
                    <p>No reservations found. <a href="${pageContext.request.contextPath}/reservations/new">Create the first one</a>.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<script>
function filterTable() {
    const q = document.getElementById('searchInput').value.toLowerCase();
    const status = document.getElementById('statusFilter').value;
    const from = document.getElementById('dateFrom').value;
    const to = document.getElementById('dateTo').value;
    const rows = document.querySelectorAll('tbody tr');
    let visible = 0;
    rows.forEach(row => {
        const text = (row.dataset.search || '').toLowerCase();
        const rowStatus = row.dataset.status || '';
        const checkin = row.dataset.checkin || '';
        const matchText = !q || text.includes(q);
        const matchStatus = !status || rowStatus === status;
        const matchFrom = !from || checkin >= from;
        const matchTo = !to || checkin <= to;
        const show = matchText && matchStatus && matchFrom && matchTo;
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });
    document.getElementById('resultCount').textContent = visible + ' result' + (visible !== 1 ? 's' : '');
}
function clearFilters() {
    document.getElementById('searchInput').value = '';
    document.getElementById('statusFilter').value = '';
    document.getElementById('dateFrom').value = '';
    document.getElementById('dateTo').value = '';
    filterTable();
}
window.onload = () => { document.getElementById('resultCount').textContent = document.querySelectorAll('tbody tr').length + ' results'; };
</script>
</body>
</html>

