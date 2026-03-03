<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Ocean View Resort HMS</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0a3d62 0%, #1e6091 50%, #2980b9 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-wrapper {
            display: flex;
            width: 900px;
            max-width: 95vw;
            min-height: 520px;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.4);
        }

        /* Left panel — branding */
        .login-brand {
            flex: 1;
            background: linear-gradient(180deg, #0a3d62 0%, #1a5276 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 30px;
            color: white;
        }

        .login-brand .logo {
            font-size: 56px;
            margin-bottom: 16px;
        }

        .login-brand h1 {
            font-size: 22px;
            font-weight: 700;
            letter-spacing: 1px;
            text-align: center;
            margin-bottom: 8px;
        }

        .login-brand p {
            font-size: 13px;
            color: #a9cce3;
            text-align: center;
            line-height: 1.6;
        }

        .login-brand .divider {
            width: 50px;
            height: 2px;
            background: #2980b9;
            margin: 20px auto;
        }

        .login-brand .features {
            list-style: none;
            text-align: left;
            width: 100%;
        }

        .login-brand .features li {
            font-size: 13px;
            color: #d6eaf8;
            padding: 6px 0;
        }

        .login-brand .features li::before {
            content: "✓ ";
            color: #2ecc71;
            font-weight: bold;
        }

        /* Right panel — form */
        .login-form-panel {
            flex: 1;
            background: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 50px 40px;
        }

        .login-form-panel h2 {
            font-size: 24px;
            color: #0a3d62;
            margin-bottom: 6px;
            font-weight: 700;
        }

        .login-form-panel .subtitle {
            font-size: 13px;
            color: #7f8c8d;
            margin-bottom: 30px;
        }

        .alert-error {
            background: #fdecea;
            border-left: 4px solid #e74c3c;
            color: #c0392b;
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .alert-success {
            background: #eafaf1;
            border-left: 4px solid #2ecc71;
            color: #1e8449;
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 7px;
        }

        .form-group input[type="text"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #d5d8dc;
            border-radius: 8px;
            font-size: 14px;
            color: #2c3e50;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }

        .form-group input:focus {
            border-color: #2980b9;
            box-shadow: 0 0 0 3px rgba(41,128,185,0.15);
        }

        .form-group-inline {
            display: flex;
            align-items: center;
            margin-bottom: 24px;
        }

        .form-group-inline input[type="checkbox"] {
            width: 16px;
            height: 16px;
            margin-right: 8px;
            accent-color: #2980b9;
        }

        .form-group-inline label {
            font-size: 13px;
            color: #555;
        }

        .btn-login {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #0a3d62, #2980b9);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            letter-spacing: 0.5px;
            transition: opacity 0.2s, transform 0.1s;
        }

        .btn-login:hover {
            opacity: 0.92;
            transform: translateY(-1px);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .login-footer {
            margin-top: 24px;
            text-align: center;
            font-size: 12px;
            color: #aaa;
        }

        @media (max-width: 640px) {
            .login-brand { display: none; }
            .login-form-panel { padding: 40px 24px; }
        }
    </style>
</head>
<body>

<div class="login-wrapper">

    <!-- Left Branding Panel -->
    <div class="login-brand">
        <div class="logo">🌊</div>
        <h1>Ocean View Resort</h1>
        <p>Hotel Management System</p>
        <div class="divider"></div>
        <ul class="features">
            <li>Room Reservations</li>
            <li>Guest Management</li>
            <li>Billing & Reports</li>
            <li>Real-time Availability</li>
        </ul>
    </div>

    <!-- Right Form Panel -->
    <div class="login-form-panel">
        <h2>Welcome Back</h2>
        <p class="subtitle">Sign in to access the management system</p>

        <!-- Error message -->
        <c:if test="${not empty errorMessage}">
            <div class="alert-error">⚠ ${errorMessage}</div>
        </c:if>

        <!-- Logged out success message -->
        <c:if test="${param.message == 'loggedout'}">
            <div class="alert-success">✓ You have been logged out successfully.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username"
                       placeholder="Enter your username"
                       value="${not empty enteredUsername ? enteredUsername : (not empty rememberedUsername ? rememberedUsername : '')}"
                       required autofocus />
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Enter your password"
                       required />
            </div>

            <div class="form-group-inline">
                <input type="checkbox" id="rememberMe" name="rememberMe"
                       ${not empty rememberedUsername ? 'checked' : ''} />
                <label for="rememberMe">Remember me for 7 days</label>
            </div>

            <button type="submit" class="btn-login">Sign In</button>
        </form>

        <div class="login-footer">
            Ocean View Resort HMS &copy; 2026 &nbsp;|&nbsp; CIS6003 Advanced Programming
        </div>
    </div>

</div>

</body>
</html>

