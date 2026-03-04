<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty staffUser ? 'Add Staff' : 'Edit Staff'} - Ocean View HMS</title>
    <%@ include file="_layout-head.jsp" %>
</head>

<body>
    <%@ include file="_sidebar.jsp" %>

    <div class="main">
        <c:set var="pageTitle" value="${empty staffUser ? 'Add Staff' : 'Edit Staff'}" scope="request" />
        <%@ include file="_header.jsp" %>

        <div class="content" style="max-width:740px;">
            <div class="top-strip">
                <div class="ts-left">
                    <div class="ts-hi">${empty staffUser ? 'Add New Staff Member' : 'Edit Staff Member'}</div>
                    <div class="ts-sub">Manage user account details</div>
                </div>
                <div class="ts-right">
                    <a href="${pageContext.request.contextPath}/staff" class="strip-btn btn-ghost">Back to Staff</a>
                </div>
            </div>

            <div class="panel">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${errorMessage}</div>
                </c:if>
                <form action="${pageContext.request.contextPath}/staff" method="post">
                    <input type="hidden" name="action" value="${empty staffUser ? 'create' : 'update'}" />
                    <c:if test="${not empty staffUser}">
                        <input type="hidden" name="userId" value="${staffUser.userId}" />
                    </c:if>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="username">Username *</label>
                            <input type="text" id="username" name="username"
                                value="${not empty staffUser ? staffUser.username : ''}" required />
                        </div>
                        <div class="form-group">
                            <label for="fullName">Full Name *</label>
                            <input type="text" id="fullName" name="fullName"
                                value="${not empty staffUser ? staffUser.fullName : ''}" required />
                        </div>
                        <div class="form-group">
                            <label for="email">Email *</label>
                            <input type="email" id="email" name="email"
                                value="${not empty staffUser ? staffUser.email : ''}" required />
                        </div>
                        <div class="form-group">
                            <label for="role">Role *</label>
                            <select id="role" name="role" required>
                                <option value="STAFF" ${staffUser.role == 'STAFF' ? 'selected' : ''}>Staff</option>
                                <option value="ADMIN" ${staffUser.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                            </select>
                        </div>
                    </div>
                    <c:if test="${empty staffUser}">
                        <div class="form-group">
                            <label for="password">Password *</label>
                            <input type="password" id="password" name="password" required />
                        </div>
                    </c:if>
                    <div style="display:flex;gap:12px;margin-top:20px;">
                        <button type="submit" class="strip-btn btn-primary">
                            ${empty staffUser ? 'Create Staff' : 'Update Staff'}
                        </button>
                        <a href="${pageContext.request.contextPath}/staff" class="strip-btn btn-ghost">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>

</html>
