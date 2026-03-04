<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Ocean View Resort HMS</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }

        .navbar {
            background: linear-gradient(135deg, #0a3d62, #1e6091);
            color: white;
            padding: 0 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }

        .navbar .brand { font-size: 18px; font-weight: 700; }
        .navbar .brand span { color: #85c1e9; }

        .navbar .nav-links a {
            color: #d6eaf8;
            text-decoration: none;
            margin-left: 20px;
            font-size: 14px;
            transition: color 0.2s;
        }
        .navbar .nav-links a:hover { color: white; }
        .navbar .nav-links .btn-logout {
            background: #e74c3c;
            color: white;
            padding: 6px 14px;
            border-radius: 6px;
            margin-left: 20px;
        }

        .main { padding: 40px 30px; max-width: 1200px; margin: 0 auto; }

        .welcome-banner {
            background: white;
            border-radius: 12px;
            padding: 28px 32px;
            margin-bottom: 30px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            border-left: 5px solid #2980b9;
        }

        .welcome-banner h2 { color: #0a3d62; font-size: 22px; margin-bottom: 6px; }
        .welcome-banner p { color: #7f8c8d; font-size: 14px; }
        .welcome-banner .role-badge {
            display: inline-block;
            background: #eaf4fb;
            color: #1e6091;
            border-radius: 20px;
            padding: 3px 12px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 8px;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border-radius: 12px;
            padding: 28px 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            text-decoration: none;
            color: inherit;
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
            display: block;
        }

        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.13);
        }

        .card .icon { font-size: 38px; margin-bottom: 14px; }
        .card h3 { font-size: 16px; color: #0a3d62; margin-bottom: 6px; }
        .card p { font-size: 13px; color: #7f8c8d; line-height: 1.5; }

        .card-blue  { border-top: 4px solid #2980b9; }
        .card-green { border-top: 4px solid #27ae60; }
        .card-orange{ border-top: 4px solid #e67e22; }
        .card-purple{ border-top: 4px solid #8e44ad; }
        .card-teal  { border-top: 4px solid #16a085; }
        .card-red   { border-top: 4px solid #e74c3c; }

        .footer {
            text-align: center;
            padding: 20px;
            color: #aaa;
            font-size: 12px;
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/reservations">Reservations</a>
        <a href="${pageContext.request.contextPath}/rooms">Rooms</a>
        <a href="${pageContext.request.contextPath}/billing">Billing</a>
        <a href="${pageContext.request.contextPath}/reports">Reports</a>
        <a href="${pageContext.request.contextPath}/help">Help</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="main">

    <div class="welcome-banner">
        <h2>Welcome, ${currentUser.username}! 👋</h2>
        <p>Manage reservations, billing, and reports from your dashboard.</p>
        <span class="role-badge">${currentUser.role}</span>
    </div>

    <div class="cards-grid">
        <a href="${pageContext.request.contextPath}/reservations/new" class="card card-blue">
            <div class="icon">📋</div>
            <h3>New Reservation</h3>
            <p>Add a new guest reservation with room and date details.</p>
        </a>

        <a href="${pageContext.request.contextPath}/reservations" class="card card-green">
            <div class="icon">📁</div>
            <h3>All Reservations</h3>
            <p>View and manage all existing reservations.</p>
        </a>

        <a href="${pageContext.request.contextPath}/rooms/" class="card card-orange">
            <div class="icon">🛏️</div>
            <h3>Room Management</h3>
            <p>Check availability. Admins can add, edit and delete rooms.</p>
        </a>

        <a href="${pageContext.request.contextPath}/billing/" class="card card-purple">
            <div class="icon">💳</div>
            <h3>Billing</h3>
            <p>View bill history and generate invoices for reservations.</p>
        </a>

        <a href="${pageContext.request.contextPath}/reports" class="card card-teal">
            <div class="icon">📊</div>
            <h3>Reports</h3>
            <p>View occupancy and revenue reports by date range.</p>
        </a>

        <a href="${pageContext.request.contextPath}/help" class="card card-red">
            <div class="icon">❓</div>
            <h3>Help</h3>
            <p>Usage guide and system documentation for staff.</p>
        </a>

        <c:if test="${currentUser.role == 'ADMIN'}">
        <a href="${pageContext.request.contextPath}/staff" class="card card-red">
            <div class="icon">👥</div>
            <h3>Staff Management</h3>
            <p>Create, edit and delete staff accounts. Admin only.</p>
        </a>
        </c:if>
    </div>

</div>

<div class="footer">
    Ocean View Resort HMS &copy; 2026 &nbsp;|&nbsp; CIS6003 Advanced Programming — Cardiff Metropolitan University
</div>

</body>
</html>

