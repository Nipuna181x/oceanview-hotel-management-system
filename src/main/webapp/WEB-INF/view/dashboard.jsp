<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Ocean View HMS</title>
    <%@ include file="_layout-head.jsp" %>
    <style>
        .mid{display:grid;grid-template-columns:1.1fr 1fr;gap:16px;margin-bottom:20px;}
        .qa{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;}
        .qa-card{
            background:var(--bg);border:1.5px solid var(--border);
            border-radius:10px;padding:14px 12px;
            cursor:pointer;transition:all .2s;
            display:flex;flex-direction:column;gap:9px;text-decoration:none;color:inherit;
        }
        .qa-card:hover{
            border-color:var(--blue);background:var(--blue-bg);
            transform:translateY(-1px);
            box-shadow:0 4px 14px rgba(53,99,233,.1);
        }
        .qa-card:hover .qa-i{background:var(--blue);border-color:var(--blue);}
        .qa-card:hover .qa-i svg{color:#fff;}
        .qa-i{
            width:32px;height:32px;border-radius:8px;
            background:var(--white);border:1px solid var(--border);
            display:flex;align-items:center;justify-content:center;
            transition:all .2s;
        }
        .qa-i svg{width:15px;height:15px;color:var(--ink2);transition:color .2s;}
        .qa-nm{font-size:12.5px;font-weight:600;color:var(--ink);}
        .qa-ds{font-size:11px;color:var(--muted);line-height:1.35;}
        .bottom{display:grid;grid-template-columns:1.4fr 1fr;gap:16px;}
        .right-col{display:flex;flex-direction:column;gap:16px;}
        .al{display:flex;flex-direction:column;}
        .ai{display:flex;align-items:flex-start;gap:11px;padding:10px 0;border-bottom:1px solid var(--border);}
        .ai:last-child{border-bottom:none;}
        .ai-av{width:30px;height:30px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:11.5px;font-weight:700;color:#fff;flex-shrink:0;}
        .ai-b{flex:1;}
        .ai-who{font-size:12.5px;font-weight:600;color:var(--ink);}
        .ai-what{font-size:11.5px;color:var(--muted);margin-top:1px;line-height:1.4;}
        .ai-t{font-size:10.5px;color:var(--faint);white-space:nowrap;}
        .action-list{list-style:none;}
        .action-list li{padding:12px 0;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
        .action-list li:last-child{border-bottom:none;}
        .action-label{font-size:12.5px;font-weight:600;color:var(--ink);}
        .action-desc{font-size:11px;color:var(--muted);}
    </style>
</head>
<body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Dashboard" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Top strip -->
    <div class="top-strip">
        <div class="ts-left">
            <div class="ts-hi">Good morning, ${sessionScope.loggedInUser.username} &#128075;</div>
            <div class="ts-sub" id="todaySub"></div>
        </div>
        <div class="ts-right">
            <a href="${pageContext.request.contextPath}/reports" class="strip-btn btn-ghost">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                Create Report
            </a>
            <a href="${pageContext.request.contextPath}/reservations/new" class="strip-btn btn-primary">
                <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                New Reservation
            </a>
        </div>
    </div>

    <!-- Stat cards -->
    <div class="stat-row">
        <div class="sc">
            <div class="sc-head">
                <div class="sc-ic" style="background:var(--blue-bg);">
                    <svg fill="none" stroke="var(--blue)" stroke-width="2" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
                </div>
                <span class="sc-tag tag-neutral">Total</span>
            </div>
            <div class="sc-num">${totalRooms != null ? totalRooms : '--'}</div>
            <div class="sc-lbl">Total Rooms</div>
            <div class="sc-bar"><div class="sc-fill" style="width:100%;background:var(--blue);"></div></div>
        </div>
        <div class="sc">
            <div class="sc-head">
                <div class="sc-ic" style="background:var(--emerald-bg);">
                    <svg fill="none" stroke="var(--emerald)" stroke-width="2" viewBox="0 0 24 24"><path d="M15 3h4a2 2 0 012 2v14a2 2 0 01-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>
                </div>
                <span class="sc-tag tag-up">Active</span>
            </div>
            <div class="sc-num">${activeReservations != null ? activeReservations : '--'}</div>
            <div class="sc-lbl">Active Reservations</div>
            <div class="sc-bar"><div class="sc-fill" style="width:60%;background:var(--emerald);"></div></div>
        </div>
        <div class="sc">
            <div class="sc-head">
                <div class="sc-ic" style="background:var(--amber-bg);">
                    <svg fill="none" stroke="var(--amber)" stroke-width="2" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                </div>
                <span class="sc-tag tag-up">Today</span>
            </div>
            <div class="sc-num">${pendingCheckins != null ? pendingCheckins : '--'}</div>
            <div class="sc-lbl">Pending Check-ins</div>
            <div class="sc-bar"><div class="sc-fill" style="width:40%;background:var(--amber);"></div></div>
        </div>
        <div class="sc">
            <div class="sc-head">
                <div class="sc-ic" style="background:var(--violet-bg);">
                    <svg fill="none" stroke="var(--violet)" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
                </div>
                <span class="sc-tag tag-neutral">All time</span>
            </div>
            <div class="sc-num">${totalBills != null ? totalBills : '--'}</div>
            <div class="sc-lbl">Bills Generated</div>
            <div class="sc-bar"><div class="sc-fill" style="width:85%;background:var(--violet);"></div></div>
        </div>
    </div>

    <!-- Mid section -->
    <div class="mid">
        <!-- Quick Actions -->
        <div class="panel">
            <div class="ph">
                <div class="pt">Quick Actions</div>
            </div>
            <div class="qa">
                <a href="${pageContext.request.contextPath}/reservations/new" class="qa-card">
                    <div class="qa-i"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg></div>
                    <div><div class="qa-nm">New Reservation</div><div class="qa-ds">Create a guest booking</div></div>
                </a>
                <a href="${pageContext.request.contextPath}/reservations" class="qa-card">
                    <div class="qa-i"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg></div>
                    <div><div class="qa-nm">All Reservations</div><div class="qa-ds">View and manage bookings</div></div>
                </a>
                <a href="${pageContext.request.contextPath}/rooms" class="qa-card">
                    <div class="qa-i"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg></div>
                    <div><div class="qa-nm">Room Management</div><div class="qa-ds">Check availability</div></div>
                </a>
                <a href="${pageContext.request.contextPath}/billing" class="qa-card">
                    <div class="qa-i"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div>
                    <div><div class="qa-nm">Generate Bill</div><div class="qa-ds">Create guest invoice</div></div>
                </a>
                <a href="${pageContext.request.contextPath}/reports" class="qa-card">
                    <div class="qa-i"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg></div>
                    <div><div class="qa-nm">Create Report</div><div class="qa-ds">Revenue &amp; occupancy</div></div>
                </a>
                <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/staff" class="qa-card">
                    <div class="qa-i"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg></div>
                    <div><div class="qa-nm">Staff Management</div><div class="qa-ds">Manage user accounts</div></div>
                </a>
                </c:if>
                <c:if test="${sessionScope.loggedInUser.role != 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/help" class="qa-card">
                    <div class="qa-i"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></div>
                    <div><div class="qa-nm">Help &amp; Guide</div><div class="qa-ds">View documentation</div></div>
                </a>
                </c:if>
            </div>
        </div>

        <!-- Room Summary -->
        <div class="panel">
            <div class="ph">
                <div class="pt">Room Summary</div>
                <a href="${pageContext.request.contextPath}/rooms" class="plink">View all</a>
            </div>
            <div style="display:flex;align-items:baseline;gap:8px;margin-bottom:16px;">
                <span style="font-size:42px;font-weight:700;color:var(--ink);letter-spacing:-.5px;line-height:1;">${totalRooms}</span>
                <span style="font-size:13px;color:var(--muted);font-weight:500;">total rooms</span>
            </div>
            <div class="rm-grid">
                <div class="rm-card" style="background:var(--blue-bg);border-color:var(--blue-bd);">
                    <div class="rm-num" style="color:var(--blue);">${occupiedRooms}</div>
                    <div class="rm-lbl" style="color:var(--blue);">Occupied</div>
                    <div class="rm-bar" style="background:var(--blue-bd);"><div class="rm-fill" style="width:${totalRooms > 0 ? occupiedRooms * 100 / totalRooms : 0}%;background:var(--blue);"></div></div>
                </div>
                <div class="rm-card" style="background:var(--emerald-bg);border-color:var(--emerald-bd);">
                    <div class="rm-num" style="color:var(--emerald);">${availableRooms}</div>
                    <div class="rm-lbl" style="color:var(--emerald);">Available</div>
                    <div class="rm-bar" style="background:var(--emerald-bd);"><div class="rm-fill" style="width:${totalRooms > 0 ? availableRooms * 100 / totalRooms : 0}%;background:var(--emerald);"></div></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bottom section -->
    <div class="bottom">
        <!-- Quick Links -->
        <div class="panel">
            <div class="ph">
                <div class="pt">Quick Links</div>
                <a href="${pageContext.request.contextPath}/reservations" class="plink">View all</a>
            </div>
            <ul class="action-list">
                <li>
                    <div><div class="action-label">Generate a Bill</div><div class="action-desc">Create invoice for completed stays</div></div>
                    <a href="${pageContext.request.contextPath}/billing/generate" class="strip-btn btn-primary btn-sm">Go</a>
                </li>
                <li>
                    <div><div class="action-label">Generate Report</div><div class="action-desc">View performance by date range</div></div>
                    <a href="${pageContext.request.contextPath}/reports" class="strip-btn btn-primary btn-sm">Go</a>
                </li>
                <li>
                    <div><div class="action-label">View Help Guide</div><div class="action-desc">System documentation for staff</div></div>
                    <a href="${pageContext.request.contextPath}/help" class="strip-btn btn-primary btn-sm">Go</a>
                </li>
                <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                <li>
                    <div><div class="action-label">Pricing Strategies</div><div class="action-desc">Manage rate adjustments</div></div>
                    <a href="${pageContext.request.contextPath}/pricing" class="strip-btn btn-primary btn-sm">Go</a>
                </li>
                <li>
                    <div><div class="action-label">System Logs</div><div class="action-desc">Audit trail and user activity</div></div>
                    <a href="${pageContext.request.contextPath}/logs" class="strip-btn btn-primary btn-sm">Go</a>
                </li>
                </c:if>
            </ul>
        </div>

        <!-- Right col -->
        <div class="right-col">
            <div class="panel">
                <div class="ph">
                    <div class="pt">System Status</div>
                    <span class="badge badge-success">Online</span>
                </div>
                <ul class="action-list">
                    <li><div class="action-label">Database</div><span class="badge badge-success">Connected</span></li>
                    <li><div class="action-label">Version</div><span class="text-muted text-sm">v1.0.0</span></li>
                    <li><div class="action-label">Uptime</div><span class="text-muted text-sm">Healthy</span></li>
                </ul>
            </div>
        </div>
    </div>
</div>
</div>

<script>
const d = new Date();
const days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
document.getElementById('todaySub').textContent = days[d.getDay()] + ', ' + d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear() + '  \u00b7  Ocean View Resort, Galle';
</script>
</body>
</html>

