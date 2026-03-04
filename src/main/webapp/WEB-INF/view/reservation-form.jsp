<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Reservation — Ocean View Resort HMS</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }
        .navbar {
            background: linear-gradient(135deg, #0a3d62, #1e6091);
            color: white; padding: 0 30px;
            display: flex; align-items: center; justify-content: space-between;
            height: 60px; box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }
        .navbar .brand { font-size: 18px; font-weight: 700; }
        .navbar .brand span { color: #85c1e9; }
        .navbar a { color: #d6eaf8; text-decoration: none; margin-left: 20px; font-size: 14px; }
        .navbar .btn-logout { background: #e74c3c; padding: 6px 14px; border-radius: 6px; }
        .main { padding: 30px; max-width: 900px; margin: 0 auto; }
        .page-header { margin-bottom: 24px; }
        .page-header h2 { color: #0a3d62; font-size: 22px; }
        .page-header p { color: #7f8c8d; font-size: 14px; margin-top: 4px; }
        .card {
            background: white; border-radius: 12px;
            padding: 32px; box-shadow: 0 2px 12px rgba(0,0,0,0.07);
        }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { margin-bottom: 0; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label {
            display: block; font-size: 13px; font-weight: 600;
            color: #2c3e50; margin-bottom: 7px;
        }
        .form-group input, .form-group select {
            width: 100%; padding: 11px 14px;
            border: 1px solid #d5d8dc; border-radius: 8px;
            font-size: 14px; color: #2c3e50; outline: none;
            transition: border-color 0.2s;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: #2980b9;
            box-shadow: 0 0 0 3px rgba(41,128,185,0.15);
        }
        .section-title {
            font-size: 14px; font-weight: 700; color: #1e6091;
            margin: 24px 0 16px; padding-bottom: 8px;
            border-bottom: 2px solid #eaf4fb;
        }
        .alert-error {
            background: #fdecea; border-left: 4px solid #e74c3c;
            color: #c0392b; padding: 12px 16px; border-radius: 6px;
            font-size: 13px; margin-bottom: 20px;
        }
        .alert-success {
            background: #eafaf1; border-left: 4px solid #2ecc71;
            color: #1e8449; padding: 12px 16px; border-radius: 6px;
            font-size: 13px; margin-bottom: 20px;
        }
        .btn-row { display: flex; gap: 12px; margin-top: 28px; }
        .btn-primary {
            background: linear-gradient(135deg, #0a3d62, #2980b9);
            color: white; border: none; padding: 12px 28px;
            border-radius: 8px; font-size: 14px; font-weight: 600;
            cursor: pointer; transition: opacity 0.2s;
        }
        .btn-primary:hover { opacity: 0.9; }
        .btn-secondary {
            background: #ecf0f1; color: #2c3e50; border: none;
            padding: 12px 28px; border-radius: 8px; font-size: 14px;
            cursor: pointer; text-decoration: none; display: inline-flex;
            align-items: center;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
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
    <div class="page-header">
        <h2>📋 New Reservation</h2>
        <p>Fill in the guest and room details to create a new reservation.</p>
    </div>
    <div class="card">
        <c:if test="${not empty errorMessage}">
            <div class="alert-error">⚠ ${errorMessage}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert-success">✓ ${successMessage}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reservations/new" method="post">
            <div class="section-title">👤 Guest Information</div>
            <div class="form-grid">
                <div class="form-group">
                    <label for="guestName">Full Name *</label>
                    <input type="text" id="guestName" name="guestName" placeholder="e.g. John Smith" required />
                </div>
                <div class="form-group">
                    <label for="nic">NIC Number *</label>
                    <input type="text" id="nic" name="nic" placeholder="e.g. 199012345678 or 901234567V" required />
                </div>
                <div class="form-group">
                    <label for="contactNumber">Contact Number *</label>
                    <input type="text" id="contactNumber" name="contactNumber" placeholder="e.g. 0771234567" required />
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="e.g. john@email.com" />
                </div>
                <div class="form-group full">
                    <label for="address">Address *</label>
                    <input type="text" id="address" name="address" placeholder="e.g. 123 Beach Road, Galle" required />
                </div>
            </div>

            <div class="section-title">🛏️ Room & Date Details</div>
            <div class="form-grid">
                <div class="form-group">
                    <label for="roomId">Select Room *</label>
                    <select id="roomId" name="roomId" required onchange="updateMaxOccupancy(this)">
                        <option value="">-- Select Available Room --</option>
                        <c:forEach var="room" items="${availableRooms}">
                            <option value="${room.roomId}" data-max="${room.maxOccupancy}">
                                Room ${room.roomNumber} — ${room.roomType} (Rs. ${room.ratePerNight}/night) | Max: ${room.maxOccupancy} guests
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="numGuests">No. of Guests *</label>
                    <input type="number" id="numGuests" name="numGuests" value="1" min="1" max="20" required
                           placeholder="e.g. 2"/>
                    <p style="font-size:12px;color:#95a5a6;margin-top:4px;" id="maxOccHint"></p>
                </div>
                <div class="form-group">
                    <label for="pricingStrategy">Pricing Strategy *</label>
                    <select id="pricingStrategy" name="pricingStrategy">
                        <c:forEach var="s" items="${strategies}">
                            <option value="${s.name}" ${s.strategyDefault ? 'selected' : ''}>
                                ${s.name} — ${s.adjustmentLabel}<c:if test="${s.strategyDefault}"> ★ Default</c:if>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="checkInDate">Check-In Date *</label>
                    <input type="date" id="checkInDate" name="checkInDate" required
                           min="${today}" />
                </div>
                <div class="form-group">
                    <label for="checkOutDate">Check-Out Date *</label>
                    <input type="date" id="checkOutDate" name="checkOutDate" required
                           min="${today}" />
                </div>
            </div>

            <div class="btn-row">
                <button type="submit" class="btn-primary">✓ Create Reservation</button>
                <a href="${pageContext.request.contextPath}/reservations" class="btn-secondary">✕ Cancel</a>
            </div>
        </form>
    </div>
</div>
<script>
    // Auto-set min date to today
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('checkInDate').min = today;
    document.getElementById('checkOutDate').min = today;
    // Ensure check-out is always after check-in
    document.getElementById('checkInDate').addEventListener('change', function() {
        document.getElementById('checkOutDate').min = this.value;
    });

    function updateMaxOccupancy(sel) {
        var opt = sel.options[sel.selectedIndex];
        var maxOcc = opt.getAttribute('data-max');
        var numGuestsInput = document.getElementById('numGuests');
        var hint = document.getElementById('maxOccHint');
        if (maxOcc) {
            numGuestsInput.max = maxOcc;
            hint.textContent = '👥 Max occupancy for selected room: ' + maxOcc + ' guests';
        } else {
            numGuestsInput.max = 20;
            hint.textContent = '';
        }
    }
</script>
</body>
</html>

