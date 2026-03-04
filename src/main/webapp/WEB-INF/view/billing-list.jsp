<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill History - Ocean View HMS</title>
    <%@ include file="_layout-head.jsp" %>
</head>
<body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Billing" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
    <div class="top-strip">
        <div class="ts-left">
            <div class="ts-hi">Bill History</div>
            <div class="ts-sub">View all generated bills and invoices</div>
        </div>
        <div class="ts-right">
            <a href="${pageContext.request.contextPath}/billing/generate" class="strip-btn btn-primary">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                Generate New Bill
            </a>
        </div>
    </div>

    <c:if test="${not empty errorMessage}"><div class="alert alert-error">${errorMessage}</div></c:if>

    <div class="search-bar">
        <input type="text" id="billSearch" placeholder="Search by guest, reservation number..." oninput="filterBills()">
        <select id="strategyFilter" onchange="filterBills()"><option value="">All Strategies</option><option value="Standard">Standard</option><option value="Seasonal">Seasonal</option><option value="Long Stay">Long Stay</option></select>
        <button class="clear-btn" onclick="clearBillFilters()">Clear</button>
        <span class="result-count" id="billCount"></span>
    </div>

    <div class="panel">
        <c:choose>
            <c:when test="${empty bills}"><div class="empty-state"><p>No bills generated yet.</p><br/><a href="${pageContext.request.contextPath}/billing/generate" class="strip-btn btn-primary">Generate First Bill</a></div></c:when>
            <c:otherwise>
                <table class="tbl"><thead><tr><th>Bill #</th><th>Reservation</th><th>Guest</th><th>Nights</th><th>Rate/Night</th><th>Strategy</th><th>Total</th><th>Generated</th><th>Action</th></tr></thead>
                <tbody>
                    <c:forEach var="bill" items="${bills}">
                        <tr data-search="${bill.reservationNumber} ${bill.guestName} ${bill.pricingStrategyUsed}" data-strategy="${bill.pricingStrategyUsed}">
                            <td>#${bill.billId}</td>
                            <td class="font-mono">${not empty bill.reservationNumber ? bill.reservationNumber : bill.reservationId}</td>
                            <td>${not empty bill.guestName ? bill.guestName : '-'}</td>
                            <td>${bill.numNights}</td>
                            <td>Rs. ${bill.ratePerNight}</td>
                            <td><span class="badge badge-info">${bill.pricingStrategyUsed}</span></td>
                            <td class="font-bold">Rs. ${bill.totalAmount}</td>
                            <td class="text-muted text-sm">${bill.generatedAt}</td>
                            <td><a href="${pageContext.request.contextPath}/billing/view?billId=${bill.billId}" class="strip-btn btn-ghost btn-sm">View</a></td>
                        </tr>
                    </c:forEach>
                </tbody></table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</div>

<script>
function filterBills(){const q=document.getElementById('billSearch').value.toLowerCase();const s=document.getElementById('strategyFilter').value.toLowerCase();const rows=document.querySelectorAll('tbody tr');let v=0;rows.forEach(r=>{const show=(!q||(r.dataset.search||'').toLowerCase().includes(q))&&(!s||(r.dataset.strategy||'').toLowerCase().includes(s));r.style.display=show?'':'none';if(show)v++;});document.getElementById('billCount').textContent=v+' bills';}
function clearBillFilters(){document.getElementById('billSearch').value='';document.getElementById('strategyFilter').value='';filterBills();}
window.onload=()=>{const r=document.querySelectorAll('tbody tr');document.getElementById('billCount').textContent=r.length+' bills';};
</script>
</body></html>