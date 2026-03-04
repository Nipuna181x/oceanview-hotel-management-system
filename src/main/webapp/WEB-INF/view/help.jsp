<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Help - Ocean View HMS</title><%@ include file="_layout-head.jsp" %>
<style>
.help-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:24px;}
.help-card{background:var(--bg);border:1.5px solid var(--border);border-radius:10px;padding:18px;transition:all .2s;display:flex;flex-direction:column;gap:8px;}
.help-card:hover{border-color:var(--blue);background:var(--blue-bg);transform:translateY(-1px);box-shadow:0 4px 14px rgba(53,99,233,.1);}
.help-card .hc-ic{width:34px;height:34px;border-radius:9px;background:var(--white);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;transition:all .2s;}
.help-card:hover .hc-ic{background:var(--blue);border-color:var(--blue);}
.help-card:hover .hc-ic svg{stroke:#fff;}
.help-card .hc-ic svg{width:16px;height:16px;stroke:var(--ink2);transition:stroke .2s;}
.help-card h4{font-size:13px;font-weight:700;color:var(--ink);}
.help-card p{font-size:12px;color:var(--muted);line-height:1.6;}
.help-section{margin-bottom:28px;}
.help-section:last-child{margin-bottom:0;}
.help-section h3{font-size:15px;font-weight:700;color:var(--ink);margin-bottom:14px;letter-spacing:-.2px;padding-bottom:8px;border-bottom:1px solid var(--border);}
.help-section p{font-size:13px;color:var(--muted);line-height:1.8;margin-bottom:10px;}
.help-section ul{padding-left:0;list-style:none;display:flex;flex-direction:column;gap:6px;}
.help-section ul li{font-size:13px;color:var(--muted);line-height:1.7;padding:8px 12px;background:var(--bg);border-radius:var(--rs);border:1px solid var(--border);display:flex;gap:10px;align-items:flex-start;}
.help-section ul li::before{content:'→';color:var(--blue);font-weight:700;flex-shrink:0;margin-top:1px;}
.help-section ul li strong{color:var(--ink2);}
.steps{counter-reset:step;padding-left:0;list-style:none;display:flex;flex-direction:column;gap:8px;}
.steps li{display:flex;gap:12px;align-items:flex-start;padding:10px 14px;background:var(--bg);border-radius:var(--rs);border:1px solid var(--border);}
.steps li::before{counter-increment:step;content:counter(step);width:22px;height:22px;background:var(--blue);color:#fff;border-radius:50%;font-size:11px;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0;margin-top:1px;}
.steps li span{font-size:13px;color:var(--muted);line-height:1.6;}
.steps li span strong{color:var(--ink2);}
.help-panel-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
@media(max-width:700px){.help-grid{grid-template-columns:1fr 1fr;}.help-panel-grid{grid-template-columns:1fr;}}
</style></head><body>
<%@ include file="_sidebar.jsp" %>

<div class="main">
<c:set var="pageTitle" value="Help & Guide" scope="request"/>
<%@ include file="_header.jsp" %>

<div class="content" style="max-width:960px;">
<div class="top-strip">
<div class="ts-left">
<div class="ts-hi">Help &amp; Documentation</div>
<div class="ts-sub">Step-by-step guidance for using the Ocean View HMS</div>
</div>
</div>

<!-- Module cards -->
<div class="help-grid">
  <div class="help-card">
    <div class="hc-ic"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg></div>
    <h4>Reservations</h4>
    <p>Create, view, check-in, check-out, and cancel reservations from the Reservations module.</p>
  </div>
  <div class="help-card">
    <div class="hc-ic"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg></div>
    <h4>Room Management</h4>
    <p>View all rooms, filter by type or availability. Admins can add, edit, and delete rooms.</p>
  </div>
  <div class="help-card">
    <div class="hc-ic"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
    <h4>Billing</h4>
    <p>Generate bills for completed stays. Select a reservation and pricing strategy, then print the invoice as PDF.</p>
  </div>
  <div class="help-card">
    <div class="hc-ic"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg></div>
    <h4>Reports</h4>
    <p>Generate occupancy and revenue reports by date range. View report history and print or delete saved reports.</p>
  </div>
  <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
  <div class="help-card">
    <div class="hc-ic"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div>
    <h4>Pricing Strategies</h4>
    <p>Admin only. Create surcharge or discount strategies applied during billing. One strategy must always be set as default.</p>
  </div>
  <div class="help-card">
    <div class="hc-ic"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/></svg></div>
    <h4>Staff Management</h4>
    <p>Admin only. Create, edit, and delete staff accounts. Assign Admin or Staff roles to control access levels.</p>
  </div>
  </c:if>
  <c:if test="${sessionScope.loggedInUser.role != 'ADMIN'}">
  <div class="help-card">
    <div class="hc-ic"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg></div>
    <h4>Dashboard</h4>
    <p>Your home screen. Shows today's occupancy stats, quick action shortcuts, and quick links to billing and reports.</p>
  </div>
  <div class="help-card">
    <div class="hc-ic"><svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
    <h4>System Logs</h4>
    <p>View a full audit trail of all actions performed in the system, filterable by action type and user.</p>
  </div>
  </c:if>
</div>

<!-- Detailed Guidance -->
<div class="help-panel-grid">

  <!-- How to make a reservation -->
  <div class="panel">
    <div class="help-section">
      <h3>How to Create a Reservation</h3>
      <ol class="steps">
        <li><span>Go to <strong>Reservations</strong> in the sidebar and click <strong>New Reservation</strong>.</span></li>
        <li><span>Enter the <strong>guest's full name</strong>, NIC number, and contact number.</span></li>
        <li><span>Select the <strong>room</strong> from the dropdown (only available rooms are listed).</span></li>
        <li><span>Set the <strong>check-in</strong> and <strong>check-out</strong> dates.</span></li>
        <li><span>Click <strong>Create Reservation</strong>. The system will confirm the booking and show the reservation number.</span></li>
      </ol>
    </div>
  </div>

  <!-- Check-in / Check-out -->
  <div class="panel">
    <div class="help-section">
      <h3>Check-In &amp; Check-Out Process</h3>
      <ol class="steps">
        <li><span>Navigate to <strong>Reservations</strong> and find the guest's booking using the search bar.</span></li>
        <li><span>Click <strong>View</strong> on the reservation row to open the details page.</span></li>
        <li><span>Click <strong>Check In</strong> to mark the guest as arrived. The room status updates automatically.</span></li>
        <li><span>On departure, return to the same reservation and click <strong>Check Out</strong>.</span></li>
        <li><span>After check-out, go to <strong>Billing</strong> to generate the invoice for the stay.</span></li>
      </ol>
    </div>
  </div>

  <!-- Billing -->
  <div class="panel">
    <div class="help-section">
      <h3>How to Generate a Bill</h3>
      <ol class="steps">
        <li><span>Go to <strong>Billing</strong> in the sidebar and click <strong>Generate New Bill</strong>.</span></li>
        <li><span>Select the <strong>reservation</strong> from the dropdown (only checked-out unbilled reservations appear).</span></li>
        <li><span>Choose a <strong>pricing strategy</strong> — the default strategy is pre-selected.</span></li>
        <li><span>Click <strong>Generate Bill</strong>. The invoice will display with all charges and tax.</span></li>
        <li><span>Use the <strong>Print / Save PDF</strong> button to export the invoice for the guest.</span></li>
      </ol>
    </div>
  </div>

  <!-- Reports -->
  <div class="panel">
    <div class="help-section">
      <h3>How to Generate a Report</h3>
      <ol class="steps">
        <li><span>Go to <strong>Reports</strong> in the sidebar.</span></li>
        <li><span>Enter a <strong>From Date</strong> and <strong>To Date</strong> in the filter bar.</span></li>
        <li><span>Click <strong>Generate Report</strong>. A summary of reservations and revenue for the period will appear.</span></li>
        <li><span>The report is automatically <strong>saved to history</strong> and appears in the Report History table below.</span></li>
        <li><span>Click <strong>Print / Save PDF</strong> to export the report. Click <strong>View</strong> to see a saved report again.</span></li>
      </ol>
    </div>
  </div>

  <!-- Tips -->
  <div class="panel">
    <div class="help-section">
      <h3>Useful Tips</h3>
      <ul>
        <li><strong>Search bars</strong> on list pages filter results in real-time — no need to press Enter.</li>
        <li>Use <strong>filter dropdowns</strong> (e.g. room type, status) alongside the search box for refined results.</li>
        <li>All <strong>bills and reports can be printed</strong> directly from the browser using the Print button — no extra software needed.</li>
        <li>A reservation <strong>cannot be billed twice</strong> — once a bill is generated it is removed from the billing dropdown.</li>
        <li>If a room shows <strong>Occupied</strong>, it cannot be assigned to a new reservation until the current guest checks out.</li>
        <li>Use the <strong>System Logs</strong> page to review all actions taken in the system, including logins and changes.</li>
      </ul>
    </div>
  </div>

  <!-- Quick Reference -->
  <div class="panel">
    <div class="help-section">
      <h3>Status Reference</h3>
      <ul>
        <li><strong>Confirmed</strong> — Reservation created, guest not yet arrived.</li>
        <li><strong>Checked In</strong> — Guest has arrived and the room is occupied.</li>
        <li><strong>Checked Out</strong> — Guest has departed; bill can now be generated.</li>
        <li><strong>Cancelled</strong> — Reservation was cancelled; room is freed.</li>
        <li><strong>Available (Room)</strong> — Room is ready and can be assigned.</li>
        <li><strong>Occupied (Room)</strong> — Room is currently occupied by a checked-in guest.</li>
      </ul>
    </div>
  </div>

</div>
</div>
</div>
</body></html>
