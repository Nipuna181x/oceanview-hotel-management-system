<%-- Reusable topbar — Ocean View Resort v2 --%>
<div class="topbar">
  <div class="tb-left">
    <span class="tb-crumb">Resort</span>
    <span class="tb-sep">/</span>
    <span class="tb-page">${pageTitle}</span>
  </div>
  <div class="tb-right">
    <div class="search-box">
      <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
      <input type="text" placeholder="Search..."/>
    </div>
    <div class="ic-btn">
      <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 01-3.46 0"/></svg>
      <div class="ndot"></div>
    </div>
    <div class="prof">
      <div class="pav">${sessionScope.loggedInUser.username.substring(0,1).toUpperCase()}</div>
      <div>
        <div class="pnm">${sessionScope.loggedInUser.username}</div>
        <div class="prl">${sessionScope.loggedInUser.role}</div>
      </div>
    </div>
  </div>
</div>
