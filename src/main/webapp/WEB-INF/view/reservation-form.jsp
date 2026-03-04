<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Reservation - Ocean View HMS</title>
    <%@ include file="_layout-head.jsp" %>
</head>
<body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="New Reservation" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content" style="max-width:940px;">
    <div class="top-strip">
        <div class="ts-left">
            <div class="ts-hi">Create New Reservation</div>
            <div class="ts-sub">Fill in the guest and room details to create a new booking.</div>
        </div>
        <div class="ts-right">
            <a href="${pageContext.request.contextPath}/reservations" class="strip-btn btn-ghost">Back to List</a>
        </div>
    </div>

    <div class="panel">
        <c:if test="${not empty errorMessage}"><div class="alert alert-error">${errorMessage}</div></c:if>
        <c:if test="${not empty successMessage}"><div class="alert alert-success">${successMessage}</div></c:if>

        <form action="${pageContext.request.contextPath}/reservations/new" method="post">
            <div class="section-label">Guest Information</div>
            <div class="form-grid" style="margin-top:14px;">
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

            <div class="section-label">Room & Date Details</div>
            <div class="form-grid" style="margin-top:14px;">
                <div class="form-group">
                    <label for="roomId">Select Room *</label>
                    <select id="roomId" name="roomId" required onchange="updateMaxOccupancy(this)">
                        <option value="">-- Select Available Room --</option>
                        <c:forEach var="room" items="${availableRooms}">
                            <option value="${room.roomId}" data-max="${room.maxOccupancy}">
                                Room ${room.roomNumber} - ${room.roomType} (Rs. ${room.ratePerNight}/night) | Max: ${room.maxOccupancy}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="numGuests">No. of Guests *</label>
                    <input type="number" id="numGuests" name="numGuests" value="1" min="1" max="20" required />
                    <p class="text-muted text-sm" style="margin-top:4px;" id="maxOccHint"></p>
                </div>
                <div class="form-group">
                    <label for="pricingStrategy">Pricing Strategy *</label>
                    <select id="pricingStrategy" name="pricingStrategy">
                        <c:forEach var="s" items="${strategies}">
                            <option value="${s.name}" ${s.strategyDefault ? 'selected' : ''}>
                                ${s.name} - ${s.adjustmentLabel}<c:if test="${s.strategyDefault}"> (Default)</c:if>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="checkInDate">Check-In Date *</label>
                    <input type="date" id="checkInDate" name="checkInDate" required min="${today}" />
                </div>
                <div class="form-group">
                    <label for="checkOutDate">Check-Out Date *</label>
                    <input type="date" id="checkOutDate" name="checkOutDate" required min="${today}" />
                </div>
            </div>

            <div style="display:flex;gap:12px;margin-top:24px;">
                <button type="submit" class="strip-btn btn-primary">Create Reservation</button>
                <a href="${pageContext.request.contextPath}/reservations" class="strip-btn btn-ghost">Cancel</a>
            </div>
        </form>
    </div>
</div>
</div>

<script>
const today = new Date().toISOString().split('T')[0];
document.getElementById('checkInDate').min = today;
document.getElementById('checkOutDate').min = today;
document.getElementById('checkInDate').addEventListener('change', function() { document.getElementById('checkOutDate').min = this.value; });
function updateMaxOccupancy(sel) {
    var opt = sel.options[sel.selectedIndex];
    var maxOcc = opt.getAttribute('data-max');
    var hint = document.getElementById('maxOccHint');
    if (maxOcc) { document.getElementById('numGuests').max = maxOcc; hint.textContent = 'Max occupancy for selected room: ' + maxOcc + ' guests'; }
    else { document.getElementById('numGuests').max = 20; hint.textContent = ''; }
}
</script>
</body>
</html>
