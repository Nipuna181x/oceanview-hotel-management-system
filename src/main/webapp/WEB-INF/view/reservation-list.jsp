<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservations - Ocean View HMS</title>
    <%@ include file="_layout-head.jsp" %>
</head>
<body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Reservations" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
    <div class="top-strip">
        <div class="ts-left">
            <div class="ts-hi">All Reservations</div>
            <div class="ts-sub">Manage guest bookings and check-in status</div>
        </div>
        <div class="ts-right">
            <a href="${pageContext.request.contextPath}/reservations/new" class="strip-btn btn-primary">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                New Reservation
            </a>
        </div>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">${successMessage}</div>
    </c:if>

    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="Search by guest name, reservation number, room..." oninput="filterTable()">
        <select id="statusFilter" onchange="filterTable()">
            <option value="">All Statuses</option>
            <option value="CONFIRMED">Confirmed</option>
            <option value="CHECKED_IN">Checked In</option>
            <option value="CHECKED_OUT">Checked Out</option>
            <option value="CANCELLED">Cancelled</option>
        </select>
        <input type="date" id="dateFrom" onchange="filterTable()" style="width:150px;">
        <input type="date" id="dateTo" onchange="filterTable()" style="width:150px;">
        <button class="clear-btn" onclick="clearFilters()">Clear</button>
        <span class="result-count" id="resultCount"></span>
    </div>

    <div class="panel">
        <c:choose>
            <c:when test="${not empty reservations}">
                <table class="tbl">
                    <thead><tr><th>Res. Number</th><th>Guest Name</th><th>Room</th><th>Check-In</th><th>Check-Out</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <c:forEach var="res" items="${reservations}">
                            <tr data-search="${res.reservationNumber} ${res.guest.fullName} ${res.room.roomNumber} ${res.room.roomType}"
                                data-status="${res.status}" data-checkin="${res.checkInDate}">
                                <td><strong>${res.reservationNumber}</strong></td>
                                <td>${res.guest.fullName}</td>
                                <td>Room ${res.room.roomNumber} (${res.room.roomType})</td>
                                <td>${res.checkInDate}</td>
                                <td>${res.checkOutDate}</td>
                                <td><span class="sp sp-${res.status.toString().toLowerCase()}">${res.status}</span></td>
                                <td style="white-space:nowrap;">
                                    <a href="${pageContext.request.contextPath}/reservations/${res.reservationNumber}" class="strip-btn btn-ghost btn-sm">View</a>
                                    <c:if test="${res.status == 'CONFIRMED' || res.status == 'CHECKED_IN'}">
                                        <a href="${pageContext.request.contextPath}/reservations/${res.reservationId}/cancel"
                                           class="strip-btn btn-danger-o btn-sm" onclick="return confirm('Cancel this reservation?')">Cancel</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <p>No reservations found. <a href="${pageContext.request.contextPath}/reservations/new">Create the first one</a>.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
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
        const show = (!q || text.includes(q)) && (!status || rowStatus === status) && (!from || checkin >= from) && (!to || checkin <= to);
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });
    document.getElementById('resultCount').textContent = visible + ' result' + (visible !== 1 ? 's' : '');
}
function clearFilters() { document.getElementById('searchInput').value=''; document.getElementById('statusFilter').value=''; document.getElementById('dateFrom').value=''; document.getElementById('dateTo').value=''; filterTable(); }
window.onload = () => { document.getElementById('resultCount').textContent = document.querySelectorAll('tbody tr').length + ' results'; };
</script>
</body>
</html>
