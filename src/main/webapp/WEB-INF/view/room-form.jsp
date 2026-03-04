<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty room ? 'Add Room' : 'Edit Room'} - Ocean View HMS</title>
    <%@ include file="_layout-head.jsp" %>
    <style>textarea{min-height:80px;resize:vertical;}</style>
</head>
<body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="${empty room ? 'Add Room' : 'Edit Room'}" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content" style="max-width:840px;">
    <div class="top-strip">
        <div class="ts-left">
            <div class="ts-hi">${empty room ? 'Add New Room' : 'Edit Room'}</div>
            <div class="ts-sub">${empty room ? 'Enter the room details to add a new room.' : 'Update the room information.'}</div>
        </div>
        <div class="ts-right">
            <a href="${pageContext.request.contextPath}/rooms" class="strip-btn btn-ghost">Back to Rooms</a>
        </div>
    </div>

    <div class="panel">
        <c:if test="${not empty errorMessage}"><div class="alert alert-error">${errorMessage}</div></c:if>

        <form method="post" action="${pageContext.request.contextPath}/rooms">
            <input type="hidden" name="action" value="${empty room ? 'create' : 'update'}"/>
            <c:if test="${not empty room}"><input type="hidden" name="roomId" value="${room.roomId}"/></c:if>

            <div class="section-label">Room Identity</div>
            <div class="form-grid" style="margin-top:14px;">
                <div class="form-group">
                    <label for="roomNumber">Room No. *</label>
                    <input type="text" id="roomNumber" name="roomNumber" value="${not empty room ? room.roomNumber : ''}" required placeholder="e.g. 101, 201A"/>
                </div>
                <div class="form-group">
                    <label for="roomType">Room Type *</label>
                    <select id="roomType" name="roomType" required>
                        <option value="">-- Select Type --</option>
                        <option value="SINGLE" ${room.roomType == 'SINGLE' ? 'selected' : ''}>Single</option>
                        <option value="DOUBLE" ${room.roomType == 'DOUBLE' ? 'selected' : ''}>Double</option>
                        <option value="SUITE"  ${room.roomType == 'SUITE'  ? 'selected' : ''}>Suite</option>
                        <option value="DELUXE" ${room.roomType == 'DELUXE' ? 'selected' : ''}>Deluxe</option>
                    </select>
                </div>
            </div>

            <div class="section-label">Capacity & Pricing</div>
            <div class="form-grid" style="margin-top:14px;">
                <div class="form-group">
                    <label for="maxOccupancy">Max Occupancy *</label>
                    <input type="number" id="maxOccupancy" name="maxOccupancy" value="${not empty room ? room.maxOccupancy : '2'}" required min="1" max="20"/>
                </div>
                <div class="form-group">
                    <label for="ratePerNight">Rate Per Night (Rs.) *</label>
                    <input type="number" id="ratePerNight" name="ratePerNight" value="${not empty room ? room.ratePerNight : ''}" required min="1" step="0.01" placeholder="e.g. 15000.00"/>
                </div>
            </div>

            <div class="section-label">Details & Status</div>
            <div class="form-group" style="margin-top:14px;">
                <label for="description">Description</label>
                <textarea id="description" name="description" placeholder="e.g. Sea-facing room with balcony...">${not empty room ? room.description : ''}</textarea>
            </div>
            <div class="form-group">
                <label for="available">Status *</label>
                <select id="available" name="available" required>
                    <option value="true" ${(empty room || room.available) ? 'selected' : ''}>Available</option>
                    <option value="false" ${(not empty room && !room.available) ? 'selected' : ''}>Occupied / Unavailable</option>
                </select>
            </div>

            <div style="display:flex;gap:12px;margin-top:24px;">
                <button type="submit" class="strip-btn btn-primary">${empty room ? 'Add Room' : 'Update Room'}</button>
                <a href="${pageContext.request.contextPath}/rooms" class="strip-btn btn-ghost">Cancel</a>
            </div>
        </form>
    </div>
</div>
</div>
</body>
</html>
