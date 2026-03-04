<%-- Reusable sidebar navigation — Ocean View Resort v2 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="uri" value="${pageContext.request.requestURI}"/>
<aside class="sidebar">
  <div class="sb-brand">
    <div class="sb-logo">
      <!-- Sea / Wave / Anchor logo -->
      <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
        <path d="M2 12c2-2 4-3 6-3s4 1 6 3 4 3 6 3"/>
        <path d="M2 17c2-2 4-3 6-3s4 1 6 3 4 3 6 3"/>
        <circle cx="12" cy="5" r="2"/>
        <line x1="12" y1="7" x2="12" y2="12"/>
      </svg>
    </div>
    <div>
      <div class="sb-name">Ocean View Resort</div>
      <div class="sb-loc">Galle, Sri Lanka</div>
    </div>
  </div>

  <div class="sb-body">
    <div class="sb-grp">Main</div>
    <a href="${pageContext.request.contextPath}/dashboard" class="sb-link ${uri.contains('/dashboard') ? 'active' : ''}">
      <div class="sb-dot"></div>
      <svg class="lk-ic" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
      Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/reservations" class="sb-link ${uri.contains('/reservation') ? 'active' : ''}">
      <div class="sb-dot"></div>
      <svg class="lk-ic" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg>
      Reservations
    </a>
    <a href="${pageContext.request.contextPath}/rooms" class="sb-link ${uri.contains('/room') ? 'active' : ''}">
      <div class="sb-dot"></div>
      <svg class="lk-ic" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
      Rooms
    </a>

    <div class="sb-grp">Finance</div>
    <a href="${pageContext.request.contextPath}/billing" class="sb-link ${uri.contains('/billing') ? 'active' : ''}">
      <div class="sb-dot"></div>
      <svg class="lk-ic" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
      Billing
    </a>
    <a href="${pageContext.request.contextPath}/reports" class="sb-link ${uri.contains('/report') ? 'active' : ''}">
      <div class="sb-dot"></div>
      <svg class="lk-ic" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
      Reports
    </a>
    <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
    <a href="${pageContext.request.contextPath}/pricing" class="sb-link ${uri.contains('/pricing') ? 'active' : ''}">
      <div class="sb-dot"></div>
      <svg class="lk-ic" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
      Pricing Rates
    </a>
    </c:if>

    <div class="sb-grp">Admin</div>
    <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
    <a href="${pageContext.request.contextPath}/staff" class="sb-link ${uri.contains('/staff') ? 'active' : ''}">
      <div class="sb-dot"></div>
      <svg class="lk-ic" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>
      Staff Management
    </a>
    </c:if>
    <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
    <a href="${pageContext.request.contextPath}/logs" class="sb-link ${uri.contains('/logs') || uri.contains('/system-log') ? 'active' : ''}">
      <div class="sb-dot"></div>
      <svg class="lk-ic" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      System Logs
    </a>
    </c:if>
    <a href="${pageContext.request.contextPath}/help" class="sb-link ${uri.contains('/help') ? 'active' : ''}">
      <div class="sb-dot"></div>
      <svg class="lk-ic" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
      Help & Guide
    </a>
  </div>

  <div class="sb-foot">
    <a href="${pageContext.request.contextPath}/logout" class="sb-user">
      <div class="u-av">${sessionScope.loggedInUser.username.substring(0,1).toUpperCase()}</div>
      <div style="flex:1;min-width:0;">
        <div class="u-nm">${sessionScope.loggedInUser.username}</div>
        <div class="u-rl">${sessionScope.loggedInUser.role}</div>
      </div>
      <svg class="u-out" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
    </a>
  </div>
</aside>
