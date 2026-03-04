<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Billing - Ocean View HMS</title><%@ include file="_layout-head.jsp" %>
<style>
.bill-card{max-width:700px;margin:0 auto;}
.bill-header{text-align:center;padding-bottom:20px;border-bottom:2px dashed var(--border);margin-bottom:20px;}
.bill-header .hotel-name{font-size:20px;font-weight:700;color:var(--ink);letter-spacing:-.3px;}
.bill-header .sub{font-size:13px;color:var(--muted);margin-top:4px;}
.bill-header .res-num{font-size:15px;font-weight:700;color:var(--blue);margin-top:8px;font-family:'SF Mono','Consolas',monospace;}
.bill-section{margin-bottom:18px;}
.bill-section h4{font-size:10.5px;font-weight:600;color:var(--muted);margin-bottom:10px;text-transform:uppercase;letter-spacing:1.5px;}
.bill-row{display:flex;justify-content:space-between;padding:8px 0;font-size:13px;color:var(--ink2);border-bottom:1px solid var(--border);}
.bill-row:last-child{border-bottom:none;}
.bill-row.total{font-size:18px;font-weight:700;color:var(--ink);border-top:2px solid var(--ink);border-bottom:none;padding-top:14px;margin-top:4px;}
.bill-row.tax{color:var(--amber);}
@media print { .sidebar,.top-header,.no-print{display:none!important;} .main-content{margin:0;padding:20px;} }
</style></head><body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Billing" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
<div class="top-strip no-print">
<div class="ts-left">
<div class="ts-hi">Billing</div>
<div class="ts-sub">Generate and manage guest invoices</div>
</div>
<div class="ts-right">
<a href="${pageContext.request.contextPath}/billing" class="strip-btn btn-ghost">All Bills</a>
<a href="${pageContext.request.contextPath}/billing/generate" class="strip-btn btn-primary">
<svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
Generate New
</a>
</div>
</div>
<c:if test="${not empty errorMessage}"><div class="alert alert-error">${errorMessage}</div></c:if>
<c:if test="${not empty successMessage}"><div class="alert alert-success no-print">${successMessage}</div></c:if>
<c:if test="${not empty bill}">
<div class="no-print" style="text-align:right;margin-bottom:16px;"><button class="strip-btn btn-success-o" onclick="window.print()">Print / Save PDF</button></div>
<div class="panel bill-card">
<div class="bill-header"><div class="hotel-name">Ocean View Resort</div><div class="sub">Tax Invoice</div><div class="res-num">${reservation.reservationNumber}</div></div>
<div class="bill-section"><h4>Guest Details</h4>
<div class="bill-row"><span>Guest Name</span><span>${reservation.guest.fullName}</span></div>
<div class="bill-row"><span>Room</span><span>${reservation.room.roomNumber} (${reservation.room.roomType})</span></div>
<div class="bill-row"><span>Check-In</span><span>${reservation.checkInDate}</span></div>
<div class="bill-row"><span>Check-Out</span><span>${reservation.checkOutDate}</span></div>
</div>
<div class="bill-section"><h4>Charges</h4>
<div class="bill-row"><span>Nights</span><span>${bill.numNights}</span></div>
<div class="bill-row"><span>Rate/Night</span><span>Rs. ${bill.ratePerNight}</span></div>
<div class="bill-row"><span>Subtotal</span><span>Rs. ${bill.subtotal}</span></div>
<div class="bill-row"><span>Strategy</span><span class="badge badge-info">${bill.pricingStrategyUsed}</span></div>
<div class="bill-row tax"><span>Tax</span><span>Rs. ${bill.taxAmount}</span></div>
<div class="bill-row total"><span>Total</span><span>Rs. ${bill.totalAmount}</span></div>
</div>
<div style="text-align:center;margin-top:16px;font-size:12px;color:var(--muted);">Generated: ${bill.generatedAt}</div>
</div>
</c:if>
<c:if test="${empty bill && empty errorMessage}">
<div class="panel"><div class="empty-state"><p>Search for a reservation or <a href="${pageContext.request.contextPath}/billing/generate">generate a new bill</a>.</p></div></div>
</c:if>
</div>
</div>
</body></html>
