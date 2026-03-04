<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .filter-card { background:white; border-radius:12px; padding:24px; box-shadow:0 2px 12px rgba(0,0,0,0.07); margin-bottom:24px; }
        .filter-row { display:flex; gap:16px; align-items:flex-end; flex-wrap:wrap; }
        .filter-group label { display:block; font-size:12px; font-weight:700; color:#2c3e50; margin-bottom:6px; }
        .filter-group input { padding:10px 14px; border:1px solid #d5d8dc; border-radius:8px; font-size:14px; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; border:none; padding:11px 22px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; text-decoration:none; display:inline-block; }
        .btn-print { background:linear-gradient(135deg,#27ae60,#1e8449); color:white; border:none; padding:11px 22px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; }
        .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:16px; margin-bottom:24px; }
        .stat-card { background:white; border-radius:12px; padding:20px 24px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .stat-card .value { font-size:28px; font-weight:800; color:#0a3d62; }
        .stat-card .value.revenue { color:#27ae60; font-size:22px; }
        .stat-card .label { font-size:12px; color:#7f8c8d; margin-top:4px; font-weight:600; text-transform:uppercase; }
        .stat-card.blue   { border-top:4px solid #2980b9; }
        .stat-card.green  { border-top:4px solid #27ae60; }
        .stat-card.teal   { border-top:4px solid #16a085; }
        .stat-card.orange { border-top:4px solid #e67e22; }
        .stat-card.red    { border-top:4px solid #e74c3c; }
        .stat-card.gold   { border-top:4px solid #f39c12; }
        .revenue-breakdown { background:white; border-radius:12px; padding:24px; box-shadow:0 2px 12px rgba(0,0,0,0.07); margin-bottom:24px; }
        .revenue-breakdown h3 { font-size:14px; font-weight:700; color:#0a3d62; margin-bottom:16px; padding-bottom:8px; border-bottom:2px solid #eaf4fb; }
        .rev-row { display:flex; justify-content:space-between; align-items:center; padding:10px 0; border-bottom:1px solid #f4f6f8; }
        .rev-row:last-child { border-bottom:none; }
        .rev-type { font-size:13px; font-weight:600; color:#2c3e50; }
        .rev-amount { font-size:14px; font-weight:700; color:#27ae60; }
        .card { background:white; border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,0.07); overflow:hidden; margin-bottom:24px; }
        .card-header { background:#0a3d62; color:white; padding:14px 20px; font-size:14px; font-weight:700; }
        table { width:100%; border-collapse:collapse; }
        thead { background:#0a3d62; color:white; }
        th { padding:12px 16px; text-align:left; font-size:13px; font-weight:600; }
        td { padding:11px 16px; font-size:13px; color:#2c3e50; border-bottom:1px solid #f0f4f8; }
        tr:hover td { background:#f8fbff; }
        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; }
        .badge-confirmed   { background:#eaf4fb; color:#1e6091; }
        .badge-checked_in  { background:#eafaf1; color:#1e8449; }
        .badge-checked_out { background:#f4f6f7; color:#5d6d7e; }
        .badge-cancelled   { background:#fdecea; color:#c0392b; }
        .empty-state { text-align:center; padding:40px; color:#aaa; }
        .alert-error { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:13px; }
        .section-divider { font-size:16px; font-weight:700; color:#0a3d62; margin:32px 0 16px; padding-bottom:8px; border-bottom:2px solid #eaf4fb; }
        .history-badge { display:inline-block; padding:2px 8px; border-radius:12px; font-size:11px; font-weight:700; background:#eaf4fb; color:#1e6091; }

        /* ── Print styles ── */
        @media print {
            body { background:white; }
            .navbar, .filter-card, .btn-print, .btn-primary, .no-print, .section-divider.no-print, #reportHistory { display:none !important; }
            .main { padding:0; max-width:100%; }
            .stat-card, .revenue-breakdown, .card { box-shadow:none; border:1px solid #ddd; }
            .print-header { display:block !important; }
            @page { margin:20mm; }
        }
        .print-header { display:none; text-align:center; margin-bottom:24px; }
        .print-header h1 { font-size:20px; color:#0a3d62; }
        .print-header p  { font-size:13px; color:#555; margin-top:4px; }
    </style>
</head>
<body>
<nav class="navbar no-print">
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

    <%-- Print header (hidden on screen, visible in PDF) --%>
    <div class="print-header">
        <h1>🌊 Ocean View Resort — Report</h1>
        <c:if test="${not empty summary}">
            <p>Period: ${summary.startDate} to ${summary.endDate} &nbsp;|&nbsp; Generated: <%= new java.util.Date() %></p>
        </c:if>
    </div>

    <div class="page-header no-print">
        <h2>📊 Occupancy &amp; Revenue Reports</h2>
        <c:if test="${not empty summary}">
            <button class="btn-print" onclick="window.print()">🖨️ Print / Save as PDF</button>
        </c:if>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert-error no-print">⚠ ${errorMessage}</div>
    </c:if>

    <%-- Filter Form --%>
    <div class="filter-card no-print">
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

    <%-- ── GENERATED REPORT ── --%>
    <c:if test="${not empty summary}">

        <%-- Summary Stats --%>
        <div class="stats-grid">
            <div class="stat-card blue">
                <div class="value">${summary.totalReservations}</div>
                <div class="label">Total Reservations</div>
            </div>
            <div class="stat-card green">
                <div class="value">${summary.confirmedCount}</div>
                <div class="label">Confirmed</div>
            </div>
            <div class="stat-card teal">
                <div class="value">${summary.checkedInCount}</div>
                <div class="label">Checked In</div>
            </div>
            <div class="stat-card orange">
                <div class="value">${summary.checkedOutCount}</div>
                <div class="label">Checked Out</div>
            </div>
            <div class="stat-card red">
                <div class="value">${summary.cancelledCount}</div>
                <div class="label">Cancelled</div>
            </div>
            <div class="stat-card gold">
                <div class="value revenue">
                    Rs. <fmt:formatNumber value="${summary.totalRevenue}" pattern="#,##0.00"/>
                </div>
                <div class="label">💰 Total Revenue Earned</div>
            </div>
        </div>

        <%-- Revenue by Room Type Breakdown --%>
        <c:if test="${not empty summary.revenueByType}">
        <div class="revenue-breakdown">
            <h3>💰 Revenue Breakdown by Room Type</h3>
            <c:forEach var="entry" items="${summary.revenueByType}">
                <div class="rev-row">
                    <span class="rev-type">
                        <c:choose>
                            <c:when test="${entry.key == 'SINGLE'}">🛏 Single</c:when>
                            <c:when test="${entry.key == 'DOUBLE'}">🛏🛏 Double</c:when>
                            <c:when test="${entry.key == 'SUITE'}">🏨 Suite</c:when>
                            <c:when test="${entry.key == 'DELUXE'}">👑 Deluxe</c:when>
                            <c:otherwise>${entry.key}</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="rev-amount">
                        Rs. <fmt:formatNumber value="${entry.value}" pattern="#,##0.00"/>
                    </span>
                </div>
            </c:forEach>
        </div>
        </c:if>

        <%-- Reservations Table --%>
        <c:choose>
            <c:when test="${not empty reservations}">
                <div class="card">
                    <div class="card-header">📋 Reservations — ${summary.startDate} to ${summary.endDate}</div>
                    <table>
                        <thead>
                            <tr>
                                <th>Res. Number</th>
                                <th>Guest Name</th>
                                <th>NIC</th>
                                <th>Room</th>
                                <th>Check-In</th>
                                <th>Check-Out</th>
                                <th>Nights</th>
                                <th>Status</th>
                                <th>Amount Billed</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="res" items="${reservations}">
                                <tr>
                                    <td><strong>${res.reservationNumber}</strong></td>
                                    <td>${res.guest.fullName}</td>
                                    <td>${not empty res.guest.nic ? res.guest.nic : '—'}</td>
                                    <td>${res.room.roomNumber} (${res.room.roomType})</td>
                                    <td>${res.checkInDate}</td>
                                    <td>${res.checkOutDate}</td>
                                    <td>${res.checkOutDate.toEpochDay() - res.checkInDate.toEpochDay()}</td>
                                    <td><span class="badge badge-${res.status.toString().toLowerCase()}">${res.status}</span></td>
                                    <td>
                                        <c:set var="bill" value="${billMap[res.reservationId]}"/>
                                        <c:choose>
                                            <c:when test="${res.status == 'CHECKED_OUT'}">
                                                <%-- amount shown via bill lookup in service summary --%>
                                                <span style="color:#27ae60;font-weight:700;">—</span>
                                            </c:when>
                                            <c:otherwise><span style="color:#aaa;">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card"><div class="empty-state">No reservations found for the selected date range.</div></div>
            </c:otherwise>
        </c:choose>

        <%-- Print button at bottom too --%>
        <div style="text-align:center; margin:20px 0;" class="no-print">
            <button class="btn-print" onclick="window.print()">🖨️ Print / Save as PDF</button>
        </div>

    </c:if>

    <%-- ── REPORT HISTORY ── --%>
    <div id="reportHistory" class="no-print">
        <div class="section-divider">📁 Report History</div>
        <c:choose>
            <c:when test="${not empty reportHistory}">
                <div class="card">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Period</th>
                                <th>Total Res.</th>
                                <th>Confirmed</th>
                                <th>Checked Out</th>
                                <th>Cancelled</th>
                                <th>Revenue Earned</th>
                                <th>Generated At</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="h" items="${reportHistory}" varStatus="s">
                                <tr>
                                    <td>${s.index + 1}</td>
                                    <td><strong>${h.fromDate}</strong> → <strong>${h.toDate}</strong></td>
                                    <td>${h.totalReservations}</td>
                                    <td>${h.confirmedCount}</td>
                                    <td>${h.checkedOutCount}</td>
                                    <td>${h.cancelledCount}</td>
                                    <td style="color:#27ae60;font-weight:700;">
                                        Rs. <fmt:formatNumber value="${h.totalRevenue}" pattern="#,##0.00"/>
                                    </td>
                                    <td style="font-size:12px;color:#7f8c8d;">${h.generatedAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card"><div class="empty-state">No report history yet. Generate your first report above.</div></div>
            </c:otherwise>
        </c:choose>
    </div>

</div>
</body>
</html>

