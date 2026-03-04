<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Generate Bill — Ocean View Resort HMS</title>
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
        input[type=number], select {
            width:100%; padding:12px 14px; border:1px solid #d5d8dc; border-radius:8px;
            font-size:14px; transition:border-color 0.2s;
        }
        input:focus, select:focus { outline:none; border-color:#2980b9; box-shadow:0 0 0 3px rgba(41,128,185,0.1); }
        .hint { font-size:12px; color:#95a5a6; margin-top:4px; }
        .btn { padding:12px 24px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-secondary { background:#ecf0f1; color:#2c3e50; }
        .form-actions { display:flex; gap:12px; margin-top:28px; }
        .alert-error { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:13px; }
        .alert-info  { background:#eaf4fb; border-left:4px solid #2980b9; color:#1a5276; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:13px; }
        .strategy-info { background:#f8fbff; border-radius:8px; padding:16px; margin-bottom:20px; }
        .strategy-info h4 { font-size:13px; font-weight:700; color:#1e6091; margin-bottom:10px; }
        .strategy-info ul { list-style:none; font-size:13px; color:#555; }
        .strategy-info ul li { padding:4px 0; }
        .strategy-info ul li span { font-weight:600; color:#0a3d62; }
        .divider { display:flex; align-items:center; gap:12px; margin:4px 0 20px; }
        .divider hr { flex:1; border:none; border-top:1px solid #e0e0e0; }
        .divider span { font-size:12px; color:#aaa; font-weight:600; white-space:nowrap; }
        .res-preview { background:#f0f7ff; border:1px solid #bee3f8; border-radius:8px; padding:12px 16px; margin-top:10px; font-size:13px; color:#1a5276; display:none; }
        .res-preview strong { color:#0a3d62; }
        select option.status-checked-in  { color:#1e8449; font-weight:600; }
        select option.status-checked-out { color:#2980b9; font-weight:600; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/reservations">Reservations</a>
        <a href="${pageContext.request.contextPath}/billing">Billing</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>🧾 Generate New Bill</h2>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert-error">⚠ ${errorMessage}</div>
    </c:if>

<%-- Resolve pre-fill value: from controller attribute (GET redirect) or form re-post (POST error) --%>
<c:set var="prefillId" value="${not empty preselectedReservationId ? preselectedReservationId : param.reservationId}"/>
        <form method="post" action="${pageContext.request.contextPath}/billing/generate">

            <%-- ── DROPDOWN: pick from unbilled reservations ── --%>
            <div class="form-group">
                <label for="reservationDropdown">Select Reservation</label>
                <c:choose>
                    <c:when test="${empty unbilledReservations}">
                        <div class="alert-info">ℹ No reservations are currently awaiting billing.</div>
                    </c:when>
                    <c:otherwise>
                        <select id="reservationDropdown" onchange="syncFromDropdown(this)">
                            <option value="">— Select a reservation —</option>
                            <c:forEach var="res" items="${unbilledReservations}">
                                <option value="${res.reservationId}"
                                        data-number="${res.reservationNumber}"
                                        data-guest="${res.guest.fullName}"
                                        data-room="${res.room.roomNumber}"
                                        data-type="${res.room.roomType}"
                                        data-checkin="${res.checkInDate}"
                                        data-checkout="${res.checkOutDate}"
                                        data-status="${res.status}"
                                        class="status-${res.status.toString().toLowerCase().replace('_','-')}"
                                        ${prefillId == res.reservationId ? 'selected' : ''}>
                                    #${res.reservationId} — ${res.reservationNumber} | ${res.guest.fullName} | Room ${res.room.roomNumber} | ${res.status}
                                </option>
                            </c:forEach>
                        </select>
                        <%-- Preview card that appears when a dropdown item is selected --%>
                        <div class="res-preview" id="resPreview">
                            <strong id="prev-number"></strong> &nbsp;|&nbsp;
                            👤 <span id="prev-guest"></span> &nbsp;|&nbsp;
                            🛏 Room <span id="prev-room"></span> (<span id="prev-type"></span>) &nbsp;|&nbsp;
                            📅 <span id="prev-checkin"></span> → <span id="prev-checkout"></span> &nbsp;|&nbsp;
                            <span id="prev-status"></span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="divider"><hr/><span>OR enter ID manually</span><hr/></div>

            <%-- ── MANUAL ID INPUT ── --%>
            <div class="form-group">
                <label for="reservationId">Reservation ID *</label>
                <input type="number" id="reservationId" name="reservationId"
                       value="${prefillId}" min="1" required
                       placeholder="Enter the numeric reservation ID"
                       oninput="clearDropdown()"/>
                <p class="hint">You can find the reservation ID in the Reservations list.</p>
            </div>

            <%-- ── PRICING STRATEGY ── --%>
            <div class="form-group">
                <label for="strategy">Pricing Strategy *</label>
                <select id="strategy" name="strategyId">
                    <c:forEach var="s" items="${strategies}">
                        <option value="${s.strategyId}" ${s.strategyDefault ? 'selected' : ''}>
                            ${s.name} — ${s.adjustmentLabel}
                            <c:if test="${not empty s.description}"> (${s.description})</c:if>
                            <c:if test="${s.strategyDefault}"> ★ Default</c:if>
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="strategy-info">
                <h4>📋 Available Strategies</h4>
                <ul>
                    <c:forEach var="s" items="${strategies}">
                        <li>${s.strategyDefault ? '⭐' : '🔹'} <span>${s.name}</span> — ${s.adjustmentLabel}
                            <c:if test="${not empty s.description}"> — ${s.description}</c:if>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">🧾 Generate Bill</button>
                <a href="${pageContext.request.contextPath}/billing" class="btn btn-secondary">← Back to History</a>
            </div>
        </form>
    </div>
</div>

<script>
    function syncFromDropdown(sel) {
        var opt = sel.options[sel.selectedIndex];
        var idInput = document.getElementById('reservationId');
        var preview = document.getElementById('resPreview');

        if (!opt.value) {
            idInput.value = '';
            preview.style.display = 'none';
            return;
        }

        // Sync ID into the text input
        idInput.value = opt.value;

        // Show preview card
        document.getElementById('prev-number').textContent   = opt.getAttribute('data-number');
        document.getElementById('prev-guest').textContent    = opt.getAttribute('data-guest');
        document.getElementById('prev-room').textContent     = opt.getAttribute('data-room');
        document.getElementById('prev-type').textContent     = opt.getAttribute('data-type');
        document.getElementById('prev-checkin').textContent  = opt.getAttribute('data-checkin');
        document.getElementById('prev-checkout').textContent = opt.getAttribute('data-checkout');
        document.getElementById('prev-status').textContent   = opt.getAttribute('data-status');
        preview.style.display = 'block';
    }

    function clearDropdown() {
        var dd = document.getElementById('reservationDropdown');
        if (dd) dd.selectedIndex = 0;
        var preview = document.getElementById('resPreview');
        if (preview) preview.style.display = 'none';
    }

    // On page load, if a reservationId is pre-filled, sync the dropdown & preview
    window.addEventListener('DOMContentLoaded', function() {
        var dd = document.getElementById('reservationDropdown');
        var idInput = document.getElementById('reservationId');
        if (dd && idInput && idInput.value) {
            for (var i = 0; i < dd.options.length; i++) {
                if (dd.options[i].value == idInput.value) {
                    dd.selectedIndex = i;
                    syncFromDropdown(dd);
                    break;
                }
            }
        }
    });
</script>
</body>
</html>

