<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rooms - Ocean View HMS</title>
    <%@ include file="_layout-head.jsp" %>
    <style>
        .rooms-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:14px;}
        .room-card{
            background:var(--white);border-radius:var(--r);padding:20px;
            border:1px solid var(--border);transition:all .2s;
            box-shadow:0 1px 2px rgba(15,29,53,.04);
            position:relative;overflow:hidden;
        }
        .room-card:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(15,29,53,.09);border-color:var(--border2);}
        .room-number{font-size:18px;font-weight:700;color:var(--ink);letter-spacing:-.3px;}
        .room-type{font-size:11px;color:var(--muted);text-transform:uppercase;letter-spacing:1.5px;font-weight:600;margin:4px 0 10px;}
        .room-rate{font-size:18px;font-weight:700;color:var(--blue);}
        .room-rate span{font-size:12px;color:var(--muted);font-weight:400;}
        .room-occ{font-size:12px;color:var(--muted);margin:4px 0;}
        .room-desc{font-size:12px;color:var(--muted);margin:6px 0;line-height:1.5;overflow:hidden;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;}
        .avail-badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:10.5px;font-weight:600;margin-top:10px;}
        .avail-yes{background:var(--emerald-bg);color:var(--emerald);}
        .avail-no{background:var(--coral-bg);color:var(--coral);}
        .admin-actions{display:flex;gap:8px;margin-top:12px;padding-top:12px;border-top:1px solid var(--border);}
        /* Modern left-accent stripe per room type */
        .room-card::before{content:'';position:absolute;left:0;top:0;bottom:0;width:4px;border-radius:var(--r) 0 0 var(--r);}
        .room-card.single::before{background:var(--blue);}
        .room-card.double::before{background:var(--emerald);}
        .room-card.suite::before{background:var(--violet);}
        .room-card.deluxe::before{background:var(--amber);}
        .room-card{padding-left:24px;}    </style>
</head>
<body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Rooms" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
    <div class="top-strip">
        <div class="ts-left">
            <div class="ts-hi">Room Management</div>
            <div class="ts-sub">View and manage hotel rooms</div>
        </div>
        <div class="ts-right">
            <c:if test="${isAdmin}">
                <a href="${pageContext.request.contextPath}/rooms/new" class="strip-btn btn-primary">
                    <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                    Add New Room
                </a>
            </c:if>
        </div>
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">${sessionScope.successMessage}</div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="search-bar">
        <input type="text" id="roomSearch" placeholder="Search by room number, type, description..." oninput="filterRooms()">
        <select id="availFilter" onchange="filterRooms()">
            <option value="">All Availability</option>
            <option value="available">Available</option>
            <option value="occupied">Occupied</option>
        </select>
        <button class="clear-btn" onclick="clearRoomFilters()">Clear</button>
        <span class="result-count" id="roomCount"></span>
    </div>

    <div class="filter-pills">
        <a href="${pageContext.request.contextPath}/rooms" class="filter-pill ${empty param.type ? 'active' : ''}">All</a>
        <a href="${pageContext.request.contextPath}/rooms?type=SINGLE" class="filter-pill ${param.type == 'SINGLE' ? 'active' : ''}">Single</a>
        <a href="${pageContext.request.contextPath}/rooms?type=DOUBLE" class="filter-pill ${param.type == 'DOUBLE' ? 'active' : ''}">Double</a>
        <a href="${pageContext.request.contextPath}/rooms?type=SUITE"  class="filter-pill ${param.type == 'SUITE'  ? 'active' : ''}">Suite</a>
        <a href="${pageContext.request.contextPath}/rooms?type=DELUXE" class="filter-pill ${param.type == 'DELUXE' ? 'active' : ''}">Deluxe</a>
    </div>

    <div class="rooms-grid">
        <c:forEach var="room" items="${rooms}">
            <div class="room-card ${room.roomType.toString().toLowerCase()}"
                 data-search="${room.roomNumber} ${room.roomType} ${room.description}"
                 data-avail="${room.available ? 'available' : 'occupied'}">
                <div class="room-number">Room ${room.roomNumber}</div>
                <div class="room-type">${room.roomType}</div>
                <div class="room-occ">Max Occupancy: ${room.maxOccupancy}</div>
                <div class="room-rate">Rs. ${room.ratePerNight}<span>/night</span></div>
                <c:if test="${not empty room.description}">
                    <div class="room-desc">${room.description}</div>
                </c:if>
                <div>
                    <span class="avail-badge ${room.available ? 'avail-yes' : 'avail-no'}">
                        ${room.available ? 'Available' : 'Occupied'}
                    </span>
                </div>
                <c:if test="${isAdmin}">
                    <div class="admin-actions">
                        <a href="${pageContext.request.contextPath}/rooms/edit?id=${room.roomId}" class="strip-btn btn-warning-o btn-sm">Edit</a>
                        <a href="${pageContext.request.contextPath}/rooms/delete?id=${room.roomId}" class="strip-btn btn-danger-o btn-sm" onclick="return confirm('Delete Room ${room.roomNumber}?')">Delete</a>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</div>
</div>

<script>
function filterRooms() {
    const q=document.getElementById('roomSearch').value.toLowerCase();
    const avail=document.getElementById('availFilter').value;
    const cards=document.querySelectorAll('.room-card');
    let v=0;
    cards.forEach(c=>{
        const show=(!q||(c.dataset.search||'').toLowerCase().includes(q))&&(!avail||c.dataset.avail===avail);
        c.style.display=show?'':'none'; if(show)v++;
    });
    document.getElementById('roomCount').textContent=v+' room'+(v!==1?'s':'');
}
function clearRoomFilters(){document.getElementById('roomSearch').value='';document.getElementById('availFilter').value='';filterRooms();}
window.onload=()=>{document.getElementById('roomCount').textContent=document.querySelectorAll('.room-card').length+' rooms';};
</script>
</body>
</html>
