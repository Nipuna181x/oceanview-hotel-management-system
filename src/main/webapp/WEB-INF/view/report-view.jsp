<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Report #${report.reportId} - Ocean View HMS</title><%@ include file="_layout-head.jsp" %>
<style>
.report-card{max-width:800px;margin:0 auto;}
.report-title{text-align:center;border-bottom:2px solid var(--border);padding-bottom:20px;margin-bottom:24px;}
.report-title h1{font-size:18px;color:var(--ink);font-weight:700;letter-spacing:-.3px;}
.report-title .period{font-size:14px;color:var(--muted);margin-top:6px;}
.report-title .generated{font-size:12px;color:var(--faint);margin-top:4px;}
.stats-grid-sm{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:24px;}
.stat-box{border-radius:var(--r);padding:16px;text-align:center;background:var(--bg);border:1px solid var(--border);}
.stat-box .val{font-size:28px;font-weight:700;color:var(--ink);}
.stat-box .lbl{font-size:10.5px;font-weight:600;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-top:4px;}
.stat-box.blue .val{color:var(--blue);} .stat-box.green .val{color:var(--emerald);}
.stat-box.orange .val{color:var(--amber);} .stat-box.red .val{color:var(--coral);}
.stat-box.teal .val{color:var(--teal);} .stat-box.gold .val{color:var(--amber);}
.meta-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:24px;}
.meta-item label{display:block;font-size:10.5px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:1px;margin-bottom:3px;}
.meta-item span{font-size:14px;color:var(--ink);font-weight:500;}
.insight-box{padding:16px;background:var(--blue-bg);border-radius:var(--r);border:1px solid var(--blue-bd);margin-top:20px;}
.insight-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;text-align:center;}
.insight-grid .iv{font-size:20px;font-weight:700;}
.insight-grid .il{font-size:10.5px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:1px;margin-top:2px;}
@media print{.sidebar,.topbar,.no-print{display:none!important;}.main{margin:0;}.content{padding:20px;}.report-card,.panel{box-shadow:none;}@page{margin:18mm;}}
</style></head><body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Report #${report.reportId}" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
<div class="top-strip no-print">
<div class="ts-left">
<a href="${pageContext.request.contextPath}/reports" class="strip-btn btn-ghost">Back to Reports</a>
</div>
<div class="ts-right">
<button class="strip-btn btn-success-o" onclick="window.print()">Print / Save PDF</button>
<a href="${pageContext.request.contextPath}/reports/delete?id=${report.reportId}" class="strip-btn btn-danger-o" onclick="return confirm('Delete this report?')">Delete</a>
</div>
</div>

<div class="panel report-card">
<div class="report-title"><h1>Ocean View Resort - Occupancy & Revenue Report</h1>
<div class="period">Period: <strong>${report.fromDate}</strong> to <strong>${report.toDate}</strong></div>
<div class="generated">Generated: ${report.generatedAt} | Report ID: #${report.reportId}</div></div>

<div style="font-size:13px;font-weight:700;color:var(--ink);margin-bottom:12px;padding-bottom:6px;border-bottom:1px solid var(--border);">Report Details</div>
<div class="meta-grid">
<div class="meta-item"><label>Report Type</label><span>${report.reportType}</span></div>
<div class="meta-item"><label>Period</label><span>${report.fromDate} to ${report.toDate}</span></div>
<div class="meta-item"><label>Generated At</label><span>${report.generatedAt}</span></div>
<div class="meta-item"><label>Report ID</label><span>#${report.reportId}</span></div>
</div>

<div style="font-size:13px;font-weight:700;color:var(--ink);margin-bottom:12px;padding-bottom:6px;border-bottom:1px solid var(--border);">Summary Statistics</div>
<div class="stats-grid-sm">
<div class="stat-box blue"><div class="val">${report.totalReservations}</div><div class="lbl">Total Reservations</div></div>
<div class="stat-box green"><div class="val">${report.confirmedCount}</div><div class="lbl">Confirmed</div></div>
<div class="stat-box teal"><div class="val">${report.checkedInCount}</div><div class="lbl">Checked In</div></div>
<div class="stat-box orange"><div class="val">${report.checkedOutCount}</div><div class="lbl">Checked Out</div></div>
<div class="stat-box red"><div class="val">${report.cancelledCount}</div><div class="lbl">Cancelled</div></div>
<div class="stat-box gold"><div class="val">Rs. <fmt:formatNumber value="${report.totalRevenue}" pattern="#,##0.00"/></div><div class="lbl">Total Revenue</div></div>
</div>

<c:if test="${report.totalReservations > 0}">
<div class="insight-box"><div style="font-size:13px;font-weight:700;margin-bottom:10px;">Occupancy Insights</div>
<div class="insight-grid">
<div><div class="iv" style="color:var(--blue);"><fmt:formatNumber value="${report.checkedOutCount * 100 / report.totalReservations}" pattern="#,##0"/>%</div><div class="il">Completion Rate</div></div>
<div><div class="iv" style="color:var(--coral);"><fmt:formatNumber value="${report.cancelledCount * 100 / report.totalReservations}" pattern="#,##0"/>%</div><div class="il">Cancellation Rate</div></div>
<c:if test="${report.checkedOutCount > 0}"><div><div class="iv" style="color:var(--emerald);">Rs. <fmt:formatNumber value="${report.totalRevenue / report.checkedOutCount}" pattern="#,##0"/></div><div class="il">Avg Revenue/Checkout</div></div></c:if>
</div></div></c:if>

<div style="margin-top:32px;padding-top:14px;border-top:1px solid var(--border);text-align:center;font-size:11px;color:var(--muted);">Ocean View Resort HMS | Report #${report.reportId} | ${report.generatedAt}</div>
</div>

<div style="text-align:center;margin:20px 0;" class="no-print"><button class="strip-btn btn-success-o" onclick="window.print()">Print / Save PDF</button></div>
</div>
</div>
</body></html>
