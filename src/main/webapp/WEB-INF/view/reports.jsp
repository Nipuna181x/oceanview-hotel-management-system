<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reports - Ocean View HMS</title><%@ include file="_layout-head.jsp" %>
<style>
.print-header{display:none;text-align:center;margin-bottom:24px;}
.print-header h1{font-size:20px;color:var(--ink);}
.print-header p{font-size:13px;color:var(--muted);margin-top:4px;}
.filter-card{background:var(--white);border-radius:var(--r);padding:20px;box-shadow:0 1px 2px rgba(15,29,53,.04);border:1px solid var(--border);margin-bottom:20px;}
.filter-row{display:flex;gap:16px;align-items:flex-end;flex-wrap:wrap;}
.filter-group label{display:block;font-size:12px;font-weight:600;color:var(--ink);margin-bottom:6px;}
.filter-group input{padding:10px 14px;border:1px solid var(--border);border-radius:var(--rs);font-size:13px;outline:none;font-family:'DM Sans',sans-serif;}
.filter-group input:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(53,99,233,.1);}
.rev-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border);}
.rev-row:last-child{border-bottom:none;}
@media print{
    .sidebar,.topbar,.filter-card,.no-print,#reportHistory{display:none !important;}
    .main{margin:0;}.content{padding:20px;}
    .print-header{display:block !important;}
    .panel,.sc{box-shadow:none;border:1px solid #ddd;}
    @page{margin:20mm;}
}
</style></head><body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Reports" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
<div class="print-header"><h1>Ocean View Resort - Report</h1>
<c:if test="${not empty summary}"><p>Period: ${summary.startDate} to ${summary.endDate}</p></c:if></div>

<div class="top-strip no-print">
<div class="ts-left">
<div class="ts-hi">Occupancy & Revenue Reports</div>
<div class="ts-sub">Generate and view performance reports</div>
</div>
<div class="ts-right">
<c:if test="${not empty summary}"><button class="strip-btn btn-success-o" onclick="window.print()">Print / Save PDF</button></c:if>
</div>
</div>

<c:if test="${not empty errorMessage}"><div class="alert alert-error no-print">${errorMessage}</div></c:if>
<c:if test="${not empty successMessage}"><div class="alert alert-success no-print">${successMessage}</div></c:if>

<div class="filter-card no-print">
<form action="${pageContext.request.contextPath}/reports" method="get" class="filter-row">
<div class="filter-group"><label>From Date</label><input type="date" name="from" value="${param.from}"/></div>
<div class="filter-group"><label>To Date</label><input type="date" name="to" value="${param.to}"/></div>
<button type="submit" class="strip-btn btn-primary">Generate Report</button>
</form></div>

<c:if test="${not empty summary}">
<div class="stat-row">
<div class="sc"><div class="sc-head"><div class="sc-ic" style="background:var(--blue-bg);"><svg fill="none" stroke="var(--blue)" stroke-width="2" viewBox="0 0 24 24"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg></div></div><div class="sc-num">${summary.totalReservations}</div><div class="sc-lbl">Total Reservations</div></div>
<div class="sc"><div class="sc-head"><div class="sc-ic" style="background:var(--emerald-bg);"><svg fill="none" stroke="var(--emerald)" stroke-width="2" viewBox="0 0 24 24"><path d="M15 3h4a2 2 0 012 2v14a2 2 0 01-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg></div></div><div class="sc-num">${summary.confirmedCount}</div><div class="sc-lbl">Confirmed</div></div>
<div class="sc"><div class="sc-head"><div class="sc-ic" style="background:var(--teal-bg);"><svg fill="none" stroke="var(--teal)" stroke-width="2" viewBox="0 0 24 24"><path d="M15 3h4a2 2 0 012 2v14a2 2 0 01-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg></div></div><div class="sc-num">${summary.checkedInCount}</div><div class="sc-lbl">Checked In</div></div>
<div class="sc"><div class="sc-head"><div class="sc-ic" style="background:var(--amber-bg);"><svg fill="none" stroke="var(--amber)" stroke-width="2" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg></div></div><div class="sc-num">${summary.checkedOutCount}</div><div class="sc-lbl">Checked Out</div></div>
<div class="sc"><div class="sc-head"><div class="sc-ic" style="background:var(--coral-bg);"><svg fill="none" stroke="var(--coral)" stroke-width="2" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></div></div><div class="sc-num">${summary.cancelledCount}</div><div class="sc-lbl">Cancelled</div></div>
<div class="sc"><div class="sc-head"><div class="sc-ic" style="background:var(--emerald-bg);"><svg fill="none" stroke="var(--emerald)" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div></div><div class="sc-num" style="font-size:20px;">Rs. <fmt:formatNumber value="${summary.totalRevenue}" pattern="#,##0.00"/></div><div class="sc-lbl">Total Revenue</div></div>
</div>

<c:if test="${not empty summary.revenueByType}">
<div class="panel mb-6"><div class="ph"><div class="pt">Revenue by Room Type</div></div>
<c:forEach var="entry" items="${summary.revenueByType}">
<div class="rev-row"><span style="font-size:13px;font-weight:600;">${entry.key}</span><span style="font-size:14px;font-weight:700;color:var(--emerald);">Rs. <fmt:formatNumber value="${entry.value}" pattern="#,##0.00"/></span></div>
</c:forEach></div></c:if>

<c:choose><c:when test="${not empty reservations}">
<div class="panel mb-6"><div class="ph"><div class="pt">Reservations - ${summary.startDate} to ${summary.endDate}</div></div>
<table class="tbl"><thead><tr><th>Res. Number</th><th>Guest</th><th>NIC</th><th>Room</th><th>Check-In</th><th>Check-Out</th><th>Nights</th><th>Status</th></tr></thead>
<tbody><c:forEach var="res" items="${reservations}">
<tr><td><strong>${res.reservationNumber}</strong></td><td>${res.guest.fullName}</td><td class="text-sm">${not empty res.guest.nic ? res.guest.nic : '-'}</td>
<td>${res.room.roomNumber} (${res.room.roomType})</td><td>${res.checkInDate}</td><td>${res.checkOutDate}</td>
<td>${res.checkOutDate.toEpochDay() - res.checkInDate.toEpochDay()}</td>
<td><span class="sp sp-${res.status.toString().toLowerCase()}">${res.status}</span></td></tr>
</c:forEach></tbody></table></div>
</c:when><c:otherwise><div class="panel"><div class="empty-state">No reservations found for the selected date range.</div></div></c:otherwise></c:choose>
<div style="text-align:center;margin:20px 0;" class="no-print"><button class="strip-btn btn-success-o" onclick="window.print()">Print / Save PDF</button></div>
</c:if>

<div id="reportHistory" class="no-print">
<h3 style="font-size:16px;font-weight:700;margin:28px 0 16px;padding-bottom:8px;border-bottom:1px solid var(--border);">Report History</h3>
<c:if test="${not empty reportHistory}">
<div class="search-bar"><input type="text" id="reportSearch" placeholder="Search by date period..." oninput="filterReports()">
<input type="date" id="reportFrom" onchange="filterReports()" style="width:150px;">
<input type="date" id="reportTo" onchange="filterReports()" style="width:150px;">
<button class="clear-btn" onclick="clearReportFilters()">Clear</button><span class="result-count" id="reportCount"></span></div></c:if>
<c:choose><c:when test="${not empty reportHistory}"><div class="panel">
<table class="tbl"><thead><tr><th>#</th><th>Period</th><th>Total Res.</th><th>Confirmed</th><th>Checked Out</th><th>Cancelled</th><th>Revenue</th><th>Generated</th><th>Actions</th></tr></thead>
<tbody><c:forEach var="h" items="${reportHistory}" varStatus="s">
<tr data-search="${h.fromDate} ${h.toDate}" data-from="${h.fromDate}" data-to="${h.toDate}">
<td>${s.index + 1}</td><td><strong>${h.fromDate}</strong> to <strong>${h.toDate}</strong></td>
<td>${h.totalReservations}</td><td>${h.confirmedCount}</td><td>${h.checkedOutCount}</td><td>${h.cancelledCount}</td>
<td class="text-success font-bold">Rs. <fmt:formatNumber value="${h.totalRevenue}" pattern="#,##0.00"/></td>
<td class="text-muted text-sm">${h.generatedAt}</td>
<td style="white-space:nowrap;"><a href="${pageContext.request.contextPath}/reports/view?id=${h.reportId}" class="strip-btn btn-ghost btn-sm">View</a>
<a href="${pageContext.request.contextPath}/reports/delete?id=${h.reportId}" class="strip-btn btn-danger-o btn-sm" onclick="return confirm('Delete this report?')">Delete</a></td>
</tr></c:forEach></tbody></table></div>
</c:when><c:otherwise><div class="panel"><div class="empty-state">No report history yet. Generate your first report above.</div></div></c:otherwise></c:choose>
</div>
</div>
</div>

<script>
function filterReports(){var q=(document.getElementById('reportSearch')||{}).value||'';q=q.toLowerCase();var f=(document.getElementById('reportFrom')||{}).value||'';var t=(document.getElementById('reportTo')||{}).value||'';var rows=document.querySelectorAll('#reportHistory tbody tr');var v=0;rows.forEach(function(r){var txt=(r.dataset.search||'').toLowerCase();var rf=r.dataset.from||'';var rt=r.dataset.to||'';var show=(!q||txt.indexOf(q)>=0)&&(!f||rf>=f)&&(!t||rt<=t);r.style.display=show?'':'none';if(show)v++;});var cnt=document.getElementById('reportCount');if(cnt)cnt.textContent=v+' reports';}
function clearReportFilters(){var a=document.getElementById('reportSearch');if(a)a.value='';var b=document.getElementById('reportFrom');if(b)b.value='';var c=document.getElementById('reportTo');if(c)c.value='';filterReports();}
window.onload=function(){var rows=document.querySelectorAll('#reportHistory tbody tr');var cnt=document.getElementById('reportCount');if(cnt)cnt.textContent=rows.length+' reports';};
</script></body></html>