<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Report #${report.reportId} — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:900px; margin:0 auto; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .btn { padding:10px 20px; border-radius:8px; font-size:13px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-back   { background:#ecf0f1; color:#2c3e50; }
        .btn-print  { background:linear-gradient(135deg,#27ae60,#1e8449); color:white; }
        .btn-delete { background:#e74c3c; color:white; }
        .btn-row    { display:flex; gap:10px; }

        /* Report card */
        .report-card { background:white; border-radius:12px; padding:36px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .report-title { text-align:center; border-bottom:2px solid #eaf4fb; padding-bottom:20px; margin-bottom:28px; }
        .report-title h1 { font-size:20px; color:#0a3d62; }
        .report-title .period { font-size:14px; color:#7f8c8d; margin-top:6px; }
        .report-title .generated { font-size:12px; color:#aaa; margin-top:4px; }

        .stats-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-bottom:28px; }
        .stat-box { border-radius:10px; padding:18px 20px; text-align:center; }
        .stat-box .val  { font-size:30px; font-weight:800; }
        .stat-box .lbl  { font-size:11px; font-weight:700; text-transform:uppercase; color:#7f8c8d; margin-top:4px; }
        .stat-box.blue   { background:#eaf4fb; border:1px solid #bee3f8; }
        .stat-box.blue   .val { color:#1e6091; }
        .stat-box.green  { background:#eafaf1; border:1px solid #a9dfbf; }
        .stat-box.green  .val { color:#1e8449; }
        .stat-box.teal   { background:#e8f8f5; border:1px solid #a2d9ce; }
        .stat-box.teal   .val { color:#16a085; }
        .stat-box.orange { background:#fef9e7; border:1px solid #f9e79f; }
        .stat-box.orange .val { color:#d68910; }
        .stat-box.red    { background:#fdecea; border:1px solid #f5b7b1; }
        .stat-box.red    .val { color:#c0392b; }
        .stat-box.gold   { background:#fef5e7; border:1px solid #fad7a0; grid-column:1/-1; }
        .stat-box.gold   .val { color:#e67e22; font-size:26px; }

        .section-title { font-size:13px; font-weight:700; color:#0a3d62; text-transform:uppercase; letter-spacing:0.6px; margin-bottom:12px; padding-bottom:6px; border-bottom:1px solid #eaf4fb; }
        .meta-grid { display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-bottom:28px; }
        .meta-item label { display:block; font-size:11px; font-weight:700; color:#7f8c8d; text-transform:uppercase; margin-bottom:3px; }
        .meta-item span  { font-size:14px; color:#2c3e50; font-weight:500; }

        /* Print */
        @media print {
            body { background:white; }
            .navbar, .page-header, .btn-row, .no-print { display:none !important; }
            .main { padding:0; max-width:100%; }
            .report-card { box-shadow:none; padding:0; }
            @page { margin:18mm; }
        }
    </style>
</head>
<body>
<nav class="navbar no-print">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/reports">Reports</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="main">
    <div class="page-header no-print">
        <h2>📄 Report #${report.reportId}</h2>
        <div class="btn-row">
            <button class="btn btn-print" onclick="window.print()">🖨️ Print / Save as PDF</button>
            <a href="${pageContext.request.contextPath}/reports/delete?id=${report.reportId}"
               class="btn btn-delete"
               onclick="return confirm('Delete this report permanently?')">🗑 Delete</a>
            <a href="${pageContext.request.contextPath}/reports" class="btn btn-back">← Back to Reports</a>
        </div>
    </div>

    <div class="report-card">

        <%-- Report Header --%>
        <div class="report-title">
            <h1>🌊 Ocean View Resort — Occupancy &amp; Revenue Report</h1>
            <div class="period">
                Period: <strong>${report.fromDate}</strong> &nbsp;to&nbsp; <strong>${report.toDate}</strong>
            </div>
            <div class="generated">
                Generated: ${report.generatedAt} &nbsp;|&nbsp; Report ID: #${report.reportId}
            </div>
        </div>

        <%-- Meta Info --%>
        <div class="section-title">Report Details</div>
        <div class="meta-grid" style="margin-bottom:24px;">
            <div class="meta-item"><label>Report Type</label><span>${report.reportType}</span></div>
            <div class="meta-item"><label>Report Period</label><span>${report.fromDate} → ${report.toDate}</span></div>
            <div class="meta-item"><label>Generated At</label><span>${report.generatedAt}</span></div>
            <div class="meta-item"><label>Report ID</label><span>#${report.reportId}</span></div>
        </div>

        <%-- Stats Grid --%>
        <div class="section-title">Summary Statistics</div>
        <div class="stats-grid">
            <div class="stat-box blue">
                <div class="val">${report.totalReservations}</div>
                <div class="lbl">Total Reservations</div>
            </div>
            <div class="stat-box green">
                <div class="val">${report.confirmedCount}</div>
                <div class="lbl">Confirmed</div>
            </div>
            <div class="stat-box teal">
                <div class="val">${report.checkedInCount}</div>
                <div class="lbl">Checked In</div>
            </div>
            <div class="stat-box orange">
                <div class="val">${report.checkedOutCount}</div>
                <div class="lbl">Checked Out</div>
            </div>
            <div class="stat-box red">
                <div class="val">${report.cancelledCount}</div>
                <div class="lbl">Cancelled</div>
            </div>
            <div class="stat-box gold" style="grid-column:auto;">
                <div class="val">
                    Rs. <fmt:formatNumber value="${report.totalRevenue}" pattern="#,##0.00"/>
                </div>
                <div class="lbl">💰 Total Revenue Earned</div>
            </div>
        </div>

        <%-- Occupancy Rate --%>
        <c:if test="${report.totalReservations > 0}">
        <div style="margin-top:20px; padding:16px; background:#f8fbff; border-radius:8px; border:1px solid #d6eaf8;">
            <div class="section-title" style="margin-bottom:8px;">Occupancy Insights</div>
            <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:16px; text-align:center;">
                <div>
                    <div style="font-size:22px; font-weight:800; color:#0a3d62;">
                        <fmt:formatNumber value="${report.checkedOutCount * 100 / report.totalReservations}" pattern="#,##0"/>%
                    </div>
                    <div style="font-size:11px; color:#7f8c8d; font-weight:700; text-transform:uppercase;">Completion Rate</div>
                </div>
                <div>
                    <div style="font-size:22px; font-weight:800; color:#c0392b;">
                        <fmt:formatNumber value="${report.cancelledCount * 100 / report.totalReservations}" pattern="#,##0"/>%
                    </div>
                    <div style="font-size:11px; color:#7f8c8d; font-weight:700; text-transform:uppercase;">Cancellation Rate</div>
                </div>
                <div>
                    <c:if test="${report.checkedOutCount > 0}">
                    <div style="font-size:22px; font-weight:800; color:#27ae60;">
                        Rs. <fmt:formatNumber value="${report.totalRevenue / report.checkedOutCount}" pattern="#,##0.00"/>
                    </div>
                    <div style="font-size:11px; color:#7f8c8d; font-weight:700; text-transform:uppercase;">Avg Revenue / Checkout</div>
                    </c:if>
                </div>
            </div>
        </div>
        </c:if>

        <%-- Print footer --%>
        <div style="margin-top:40px; padding-top:16px; border-top:1px solid #eee; text-align:center; font-size:11px; color:#aaa;">
            Ocean View Resort HMS &nbsp;|&nbsp; Report #${report.reportId} &nbsp;|&nbsp; ${report.generatedAt}
        </div>
    </div>

    <%-- Bottom print button --%>
    <div style="text-align:center; margin:20px 0;" class="no-print">
        <button class="btn btn-print" onclick="window.print()">🖨️ Print / Save as PDF</button>
    </div>
</div>
</body>
</html>

