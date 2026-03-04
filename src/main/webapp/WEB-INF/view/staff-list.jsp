<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Staff - Ocean View HMS</title><%@ include file="_layout-head.jsp" %></head><body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Staff Management" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
<div class="top-strip">
<div class="ts-left">
<div class="ts-hi">Staff Management</div>
<div class="ts-sub">Manage user accounts and roles</div>
</div>
<div class="ts-right">
<a href="${pageContext.request.contextPath}/staff/new" class="strip-btn btn-primary">
<svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
Add Staff
</a>
</div>
</div>

<c:if test="${not empty sessionScope.successMessage}"><div class="alert alert-success">${sessionScope.successMessage}</div><c:remove var="successMessage" scope="session"/></c:if>
<c:if test="${not empty sessionScope.errorMessage}"><div class="alert alert-error">${sessionScope.errorMessage}</div><c:remove var="errorMessage" scope="session"/></c:if>

<div class="panel">
<c:choose>
<c:when test="${not empty staffList}">
<table class="tbl"><thead><tr><th>#</th><th>Username</th><th>Full Name</th><th>Email</th><th>Role</th><th>Created</th><th>Actions</th></tr></thead>
<tbody>
<c:forEach var="u" items="${staffList}" varStatus="s">
<tr>
<td>${s.index + 1}</td>
<td class="font-bold">${u.username}</td>
<td>${u.fullName}</td>
<td class="text-sm">${u.email}</td>
<td><span class="badge ${u.role == 'ADMIN' ? 'badge-danger' : 'badge-info'}">${u.role}</span></td>
<td class="text-muted text-sm">${u.createdAt}</td>
<td style="white-space:nowrap;">
<a href="${pageContext.request.contextPath}/staff/edit?id=${u.userId}" class="strip-btn btn-warning-o btn-sm">Edit</a>
<a href="${pageContext.request.contextPath}/staff/delete?id=${u.userId}" class="strip-btn btn-danger-o btn-sm" onclick="return confirm('Delete user ${u.username}?')">Delete</a>
</td>
</tr>
</c:forEach>
</tbody></table>
</c:when>
<c:otherwise><div class="empty-state"><p>No staff members found.</p></div></c:otherwise>
</c:choose>
</div>
</div>
</div>
</body></html>
