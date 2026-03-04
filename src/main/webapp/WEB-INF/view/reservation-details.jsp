<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Details - Ocean View HMS</title>
    <%@ include file="_layout-head.jsp" %>
    <style>
        .detail-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
        .detail-item label{display:block;font-size:10.5px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:1px;margin-bottom:4px;}
        .detail-item span{font-size:14px;color:var(--ink);font-weight:500;}
        .res-number{font-size:22px;font-weight:700;color:var(--ink);font-family:'SF Mono','Consolas',monospace;letter-spacing:-.5px;}
    </style>
</head>
<body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Reservation Details" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content" style="max-width:940px;">
    <div class="top-strip">
        <div class="ts-left">
            <div class="ts-hi">Reservation Details</div>
            <div class="ts-sub">${reservation.reservationNumber}</div>
        </div>
        <div class="ts-right">
            <a href="${pageContext.request.contextPath}/reservations" class="strip-btn btn-ghost">Back to List</a>
        </div>
    </div>

    <div class="panel">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;">
            <div class="res-number">${reservation.reservationNumber}</div>
            <span class="sp sp-${reservation.status.toString().toLowerCase()}">${reservation.status}</span>
        </div>

        <div class="section-label">Guest Information</div>
        <div class="detail-grid" style="margin:14px 0 24px;">
            <div class="detail-item"><label>Full Name</label><span>${reservation.guest.fullName}</span></div>
            <div class="detail-item"><label>NIC Number</label><span>${not empty reservation.guest.nic ? reservation.guest.nic : '-'}</span></div>
            <div class="detail-item"><label>Contact Number</label><span>${reservation.guest.contactNumber}</span></div>
            <div class="detail-item"><label>Email</label><span>${not empty reservation.guest.email ? reservation.guest.email : '-'}</span></div>
            <div class="detail-item"><label>Address</label><span>${reservation.guest.address}</span></div>
        </div>

        <div class="section-label">Room & Stay Details</div>
        <div class="detail-grid" style="margin:14px 0 24px;">
            <div class="detail-item"><label>Room Number</label><span>${reservation.room.roomNumber}</span></div>
            <div class="detail-item"><label>Room Type</label><span>${reservation.room.roomType}</span></div>
            <div class="detail-item"><label>Rate Per Night</label><span>Rs. ${reservation.room.ratePerNight}</span></div>
            <div class="detail-item"><label>No. of Guests</label><span>${reservation.numGuests}</span></div>
            <div class="detail-item"><label>Check-In Date</label><span>${reservation.checkInDate}</span></div>
            <div class="detail-item"><label>Check-Out Date</label><span>${reservation.checkOutDate}</span></div>
            <div class="detail-item"><label>Created At</label><span>${reservation.createdAt}</span></div>
        </div>

        <div style="display:flex;gap:10px;flex-wrap:wrap;">
            <c:if test="${reservation.status == 'CONFIRMED'}">
                <a href="${pageContext.request.contextPath}/reservations/${reservation.reservationId}/checkin" class="strip-btn btn-success-o">Check In</a>
            </c:if>
            <c:if test="${reservation.status == 'CHECKED_IN'}">
                <a href="${pageContext.request.contextPath}/reservations/${reservation.reservationId}/checkout" class="strip-btn btn-primary">Check Out</a>
            </c:if>
            <c:if test="${reservation.status == 'CHECKED_IN' || reservation.status == 'CHECKED_OUT'}">
                <a href="${pageContext.request.contextPath}/billing/for-reservation?reservationId=${reservation.reservationId}" class="strip-btn btn-primary">View / Generate Bill</a>
            </c:if>
            <c:if test="${reservation.status == 'CONFIRMED' || reservation.status == 'CHECKED_IN'}">
                <a href="${pageContext.request.contextPath}/reservations/${reservation.reservationId}/cancel" class="strip-btn btn-danger-o" onclick="return confirm('Are you sure you want to cancel this reservation?')">Cancel Reservation</a>
            </c:if>
        </div>
    </div>
</div>
</div>
</body>
</html>
