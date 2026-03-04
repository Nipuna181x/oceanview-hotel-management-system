<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${empty staff ? 'Add Staff' : 'Edit Staff'} — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:600px; margin:0 auto; }
        .page-header { margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .card { background:white; border-radius:12px; padding:32px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .form-group { margin-bottom:20px; }
        label { display:block; font-size:13px; font-weight:600; color:#2c3e50; margin-bottom:6px; }
        input[type=text], input[type=email], input[type=password] {
            width:100%; padding:11px 14px; border:1px solid #d5d8dc; border-radius:8px;
            font-size:14px; transition:border-color 0.2s;
        }
        input:focus { outline:none; border-color:#2980b9; box-shadow:0 0 0 3px rgba(41,128,185,0.1); }
        .hint { font-size:12px; color:#95a5a6; margin-top:4px; }
        .btn { padding:12px 24px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-secondary { background:#ecf0f1; color:#2c3e50; }
        .form-actions { display:flex; gap:12px; margin-top:24px; }
        .alert-error { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:13px; }
        .section-divider { border:none; border-top:1px dashed #e0e0e0; margin:24px 0; }
        .section-label { font-size:12px; font-weight:700; color:#7f8c8d; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:16px; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/staff">Staff Management</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>${empty staff ? '➕ Add New Staff Member' : '✏️ Edit Staff Member'}</h2>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert-error">⚠ ${errorMessage}</div>
    </c:if>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/staff">

            <!-- Hidden action field -->
            <input type="hidden" name="action" value="${empty staff ? 'create' : 'update'}"/>
            <c:if test="${not empty staff}">
                <input type="hidden" name="userId" value="${staff.userId}"/>
            </c:if>

            <p class="section-label">Account Details</p>

            <div class="form-group">
                <label for="username">Username *</label>
                <input type="text" id="username" name="username"
                       value="${not empty staff ? staff.username : ''}"
                       required placeholder="e.g. jsmith"/>
            </div>

            <c:choose>
                <c:when test="${empty staff}">
                    <!-- Create: require password -->
                    <div class="form-group">
                        <label for="password">Password *</label>
                        <input type="password" id="password" name="password" required placeholder="Minimum 6 characters"/>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Edit: optional password reset -->
                    <hr class="section-divider"/>
                    <p class="section-label">Reset Password (leave blank to keep current)</p>
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" placeholder="Leave blank to keep existing password"/>
                        <p class="hint">Only fill this in if you want to change the password.</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <hr class="section-divider"/>
            <p class="section-label">Profile Details</p>

            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName"
                       value="${not empty staff ? staff.fullName : ''}"
                       placeholder="e.g. John Smith"/>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       value="${not empty staff ? staff.email : ''}"
                       placeholder="e.g. john@oceanview.com"/>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    ${empty staff ? '➕ Create Staff Member' : '💾 Save Changes'}
                </button>
                <a href="${pageContext.request.contextPath}/staff" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>

