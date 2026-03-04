<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Generate Bill - Ocean View HMS</title><%@ include file="_layout-head.jsp" %></head><body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Generate Bill" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content" style="max-width:840px;">
<div class="top-strip">
<div class="ts-left">
<div class="ts-hi">Generate New Bill</div>
<div class="ts-sub">Select a reservation and pricing strategy to generate an invoice.</div>
</div>
<div class="ts-right">
<a href="${pageContext.request.contextPath}/billing" class="strip-btn btn-ghost">Back to Bills</a>
</div>
</div>

<div class="panel">
<c:if test="${not empty errorMessage}"><div class="alert alert-error">${errorMessage}</div></c:if>
<c:if test="${not empty successMessage}"><div class="alert alert-success">${successMessage}</div></c:if>
<form action="${pageContext.request.contextPath}/billing/generate" method="post">
<div class="section-label">Reservation</div>
<div class="form-group" style="margin-top:14px;">
<label for="reservationId">Select Reservation *</label>
<select id="reservationId" name="reservationId" required>
<option value="">-- Select Unbilled Reservation --</option>
<c:forEach var="res" items="${unbilledReservations}">
<option value="${res.reservationId}">${res.reservationNumber} - ${res.guest.fullName} (Room ${res.room.roomNumber})</option>
</c:forEach>
</select>
</div>
<div class="section-label">Pricing Strategy</div>
<div class="form-group" style="margin-top:14px;">
<label for="strategy">Select Strategy *</label>
<select id="strategy" name="strategyId">
<c:forEach var="s" items="${strategies}">
<option value="${s.strategyId}" ${s.strategyDefault ? 'selected' : ''}>${s.name} - ${s.adjustmentLabel}<c:if test="${s.strategyDefault}"> (Default)</c:if></option>
</c:forEach>
</select>
</div>
<div style="display:flex;gap:12px;margin-top:24px;">
<button type="submit" class="strip-btn btn-primary">Generate Bill</button>
<a href="${pageContext.request.contextPath}/billing" class="strip-btn btn-ghost">Cancel</a>
</div>
</form>
</div>
</div>
</div>
</body></html>
