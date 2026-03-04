<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pricing Strategies - Ocean View HMS</title><%@ include file="_layout-head.jsp" %></head><body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Pricing Rates" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
<div class="top-strip">
<div class="ts-left">
<div class="ts-hi">Pricing Strategies</div>
<div class="ts-sub">Manage rate adjustment strategies</div>
</div>
<div class="ts-right">
<a href="${pageContext.request.contextPath}/pricing/new" class="strip-btn btn-primary">
<svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
New Strategy
</a>
</div>
</div>

<c:if test="${not empty sessionScope.successMessage}"><div class="alert alert-success">${sessionScope.successMessage}</div><c:remove var="successMessage" scope="session"/></c:if>
<c:if test="${not empty sessionScope.errorMessage}"><div class="alert alert-error">${sessionScope.errorMessage}</div><c:remove var="errorMessage" scope="session"/></c:if>

<div class="panel">
<c:choose>
<c:when test="${not empty strategies}">
<table class="tbl"><thead><tr><th>Name</th><th>Type</th><th>Adjustment</th><th>Description</th><th>Default</th><th>Created</th><th>Actions</th></tr></thead>
<tbody>
<c:forEach var="s" items="${strategies}">
<tr>
<td class="font-bold">${s.name}</td>
<td><span class="badge badge-${s.adjustmentType.toString().toLowerCase()}">${s.adjustmentType}</span></td>
<td><c:choose><c:when test="${s.adjustmentPercent == 0}"><span class="text-muted">No adjustment</span></c:when><c:when test="${s.adjustmentType.toString() == 'DISCOUNT'}"><span class="text-success">-${s.adjustmentPercent}%</span></c:when><c:otherwise><span style="color:var(--amber);">+${s.adjustmentPercent}%</span></c:otherwise></c:choose></td>
<td class="text-muted text-sm">${not empty s.description ? s.description : '-'}</td>
<td><c:if test="${s.strategyDefault}"><span class="badge badge-success">Default</span></c:if></td>
<td class="text-muted text-sm">${s.createdAt}</td>
<td style="white-space:nowrap;">
<a href="${pageContext.request.contextPath}/pricing/edit?id=${s.strategyId}" class="strip-btn btn-warning-o btn-sm">Edit</a>
<c:if test="${!s.strategyDefault}"><a href="${pageContext.request.contextPath}/pricing/delete?id=${s.strategyId}" class="strip-btn btn-danger-o btn-sm" onclick="return confirm('Delete this strategy?')">Delete</a></c:if>
</td>
</tr>
</c:forEach>
</tbody></table>
</c:when>
<c:otherwise><div class="empty-state"><p>No pricing strategies defined. <a href="${pageContext.request.contextPath}/pricing/new">Create the first one</a>.</p></div></c:otherwise>
</c:choose>
</div>
</div>
</div>
</body></html>
