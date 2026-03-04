<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>System Logs - Ocean View HMS</title><%@ include file="_layout-head.jsp" %>
<style>
.action-tag{display:inline-block;padding:3px 10px;border-radius:20px;font-size:10.5px;font-weight:600;font-family:'SF Mono','Consolas',monospace;}
.action-create,.action-create_reservation,.action-create_room,.action-create_strategy{background:var(--emerald-bg);color:var(--emerald);}
.action-update,.action-update_room,.action-update_strategy,.action-check_in,.action-check_out{background:var(--amber-bg);color:var(--amber);}
.action-delete,.action-delete_room,.action-delete_strategy,.action-cancel_reservation{background:var(--coral-bg);color:var(--coral);}
.action-login{background:var(--blue-bg);color:var(--blue);}
.action-login_failed{background:var(--coral-bg);color:var(--coral);}
.action-logout{background:var(--bg);color:var(--muted);}
.action-generate_bill{background:var(--violet-bg);color:var(--violet);}
</style></head><body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="System Logs" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content">
<div class="top-strip">
<div class="ts-left">
<div class="ts-hi">System Logs</div>
<div class="ts-sub">Audit trail of all system activity</div>
</div>
</div>

<div class="search-bar">
<input type="text" id="logSearch" placeholder="Search by user, action, details..." oninput="filterLogs()">
<select id="actionFilter" onchange="filterLogs()">
<option value="">All Actions</option><option value="LOGIN">Login</option><option value="LOGOUT">Logout</option><option value="CREATE">Create</option><option value="UPDATE">Update</option><option value="DELETE">Delete</option><option value="CHECK">Check In/Out</option><option value="GENERATE">Generate</option><option value="CANCEL">Cancel</option>
</select>
<button class="clear-btn" onclick="clearLogFilters()">Clear</button>
<span class="result-count" id="logCount"></span>
</div>

<div class="panel">
<c:choose>
<c:when test="${not empty logs}">
<table class="tbl"><thead><tr><th>Time</th><th>User</th><th>Action</th><th>Details</th><th>IP Address</th></tr></thead>
<tbody>
<c:forEach var="log" items="${logs}">
<tr data-search="${log.username} ${log.action} ${log.details}" data-action="${log.action}">
<td class="text-muted text-sm">${log.loggedAt}</td>
<td class="font-bold">${log.username}</td>
<td><span class="action-tag action-${log.action.toLowerCase()}">${log.action}</span></td>
<td class="text-sm">${log.details}</td>
<td class="font-mono text-muted">${log.ipAddress}</td>
</tr>
</c:forEach>
</tbody></table>
</c:when>
<c:otherwise><div class="empty-state"><p>No system logs recorded yet.</p></div></c:otherwise>
</c:choose>
</div>
</div>
</div>

<script>
function filterLogs(){const q=document.getElementById('logSearch').value.toLowerCase();const a=document.getElementById('actionFilter').value;const rows=document.querySelectorAll('tbody tr');let v=0;rows.forEach(r=>{const text=(r.dataset.search||'').toLowerCase();const action=r.dataset.action||'';const show=(!q||text.includes(q))&&(!a||action.includes(a));r.style.display=show?'':'none';if(show)v++;});document.getElementById('logCount').textContent=v+' entries';}
function clearLogFilters(){document.getElementById('logSearch').value='';document.getElementById('actionFilter').value='';filterLogs();}
window.onload=()=>{document.getElementById('logCount').textContent=document.querySelectorAll('tbody tr').length+' entries';};
</script>
</body></html>