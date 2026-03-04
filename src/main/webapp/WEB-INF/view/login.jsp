<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Ocean View HMS</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
            font-family:'DM Sans',sans-serif;
            background:#0f1d35;
            min-height:100vh;
            display:flex;align-items:center;justify-content:center;
            -webkit-font-smoothing:antialiased;
        }
        .login-wrapper{
            display:flex;width:880px;max-width:95vw;
            min-height:520px;border-radius:18px;overflow:hidden;
            box-shadow:0 25px 60px rgba(0,0,0,.4);
        }
        .login-brand{
            flex:1;
            background:linear-gradient(160deg,#0f1d35 0%,#162d52 50%,#1a3460 100%);
            display:flex;flex-direction:column;align-items:center;justify-content:center;
            padding:48px 36px;color:white;position:relative;overflow:hidden;
        }
        .login-brand::before{
            content:'';position:absolute;bottom:-40px;left:-40px;
            width:200px;height:200px;border-radius:50%;
            background:rgba(53,99,233,.08);
        }
        .login-brand::after{
            content:'';position:absolute;top:-30px;right:-30px;
            width:150px;height:150px;border-radius:50%;
            background:rgba(53,99,233,.06);
        }
        .login-brand .logo-mark{
            width:56px;height:56px;border-radius:14px;
            background:#3563e9;display:flex;align-items:center;justify-content:center;
            margin-bottom:20px;position:relative;z-index:1;
        }
        .login-brand .logo-mark svg{width:28px;height:28px;color:white;}
        .login-brand h1{font-size:22px;font-weight:700;text-align:center;margin-bottom:4px;position:relative;z-index:1;letter-spacing:-.3px;}
        .login-brand .tagline{font-size:13px;color:#7a8aa8;text-align:center;margin-bottom:28px;position:relative;z-index:1;}
        .login-brand .divider{width:40px;height:2px;background:#3563e9;margin-bottom:28px;border-radius:2px;position:relative;z-index:1;}
        .login-brand .features{list-style:none;width:100%;position:relative;z-index:1;}
        .login-brand .features li{
            font-size:13px;color:#b3bed4;padding:7px 0;
            display:flex;align-items:center;gap:10px;
        }
        .login-brand .features li::before{
            content:'';width:6px;height:6px;border-radius:50%;
            background:#3563e9;flex-shrink:0;
        }

        .login-form-panel{
            flex:1;background:#ffffff;
            display:flex;flex-direction:column;justify-content:center;
            padding:48px 40px;
        }
        .login-form-panel h2{font-size:22px;color:#0f1d35;font-weight:700;margin-bottom:4px;letter-spacing:-.3px;}
        .login-form-panel .subtitle{font-size:13px;color:#7a8aa8;margin-bottom:28px;}

        .alert-error{
            background:#fff1f1;border:1px solid #fcc;color:#e84545;
            padding:10px 14px;border-radius:9px;font-size:13px;margin-bottom:16px;
        }
        .alert-success{
            background:#ecfdf5;border:1px solid #a7f3d0;color:#059669;
            padding:10px 14px;border-radius:9px;font-size:13px;margin-bottom:16px;
        }

        .form-group{margin-bottom:18px;}
        .form-group label{display:block;font-size:12.5px;font-weight:600;color:#0f1d35;margin-bottom:6px;}
        .form-group input[type="text"],
        .form-group input[type="password"]{
            width:100%;padding:11px 14px;border:1px solid #e2e7f1;border-radius:9px;
            font-size:14px;color:#0f1d35;outline:none;font-family:'DM Sans',sans-serif;
            transition:border-color 0.15s, box-shadow 0.15s;
        }
        .form-group input:focus{border-color:#3563e9;box-shadow:0 0 0 3px rgba(53,99,233,.1);}

        .form-group-inline{
            display:flex;align-items:center;margin-bottom:22px;
        }
        .form-group-inline input[type="checkbox"]{width:16px;height:16px;margin-right:8px;accent-color:#3563e9;}
        .form-group-inline label{font-size:13px;color:#7a8aa8;}

        .btn-login{
            width:100%;padding:12px;background:#3563e9;color:white;
            border:none;border-radius:9px;font-size:14px;font-weight:600;
            cursor:pointer;font-family:'DM Sans',sans-serif;transition:background 0.18s;
        }
        .btn-login:hover{background:#2952cc;}

        .login-footer{margin-top:24px;text-align:center;font-size:11px;color:#b3bed4;}

        @media (max-width:640px){
            .login-brand{display:none;}
            .login-form-panel{padding:40px 24px;}
        }
    </style>
</head>
<body>
<div class="login-wrapper">
    <div class="login-brand">
        <div class="logo-mark">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
                <path d="M2 12c2-2 4-3 6-3s4 1 6 3 4 3 6 3"/>
                <path d="M2 17c2-2 4-3 6-3s4 1 6 3 4 3 6 3"/>
                <circle cx="12" cy="5" r="2"/>
                <line x1="12" y1="7" x2="12" y2="12"/>
            </svg>
        </div>
        <h1>Ocean View Resort</h1>
        <div class="tagline">Hotel Management System</div>
        <div class="divider"></div>
        <ul class="features">
            <li>Room Reservations & Check-in</li>
            <li>Guest Management</li>
            <li>Billing & Invoicing</li>
            <li>Reports & Analytics</li>
            <li>Real-time Availability</li>
        </ul>
    </div>
    <div class="login-form-panel">
        <h2>Welcome Back</h2>
        <p class="subtitle">Sign in to access the management system</p>

        <c:if test="${not empty errorMessage}">
            <div class="alert-error">${errorMessage}</div>
        </c:if>
        <c:if test="${param.message == 'loggedout'}">
            <div class="alert-success">You have been logged out successfully.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username"
                       value="${not empty enteredUsername ? enteredUsername : (not empty rememberedUsername ? rememberedUsername : '')}"
                       required autofocus />
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required />
            </div>
            <div class="form-group-inline">
                <input type="checkbox" id="rememberMe" name="rememberMe" ${not empty rememberedUsername ? 'checked' : ''} />
                <label for="rememberMe">Remember me for 7 days</label>
            </div>
            <button type="submit" class="btn-login">Sign In</button>
        </form>
        <div class="login-footer">Ocean View Resort HMS &copy; 2026 | CIS6003 Advanced Software Engineering</div>
    </div>
</div>
</body>
</html>

