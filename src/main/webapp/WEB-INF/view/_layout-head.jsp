<%-- Shared <head> styles for all pages — Ocean View Resort v2 design --%>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
:root{
  --bg:#f0f2f8;
  --white:#ffffff;
  --border:#e2e7f1;
  --border2:#cdd4e8;
  --ink:#0f1d35;
  --ink2:#243552;
  --muted:#7a8aa8;
  --faint:#b3bed4;

  --blue:#3563e9;
  --blue-s:#2952cc;
  --blue-bg:#eef2fd;
  --blue-bd:#c5d1f9;

  --emerald:#059669;
  --emerald-bg:#ecfdf5;
  --emerald-bd:#a7f3d0;

  --coral:#e84545;
  --coral-bg:#fff1f1;
  --coral-bd:#fcc;

  --amber:#d97706;
  --amber-bg:#fefce8;
  --amber-bd:#fde68a;

  --violet:#6d28d9;
  --violet-bg:#f5f3ff;
  --violet-bd:#ddd6fe;

  --teal:#0d9488;
  --teal-bg:#f0fdfa;

  --sidebar-w:252px;
  --header-h:62px;
  --r:14px;
  --rs:9px;
}
html{font-size:14px;}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--ink);display:flex;min-height:100vh;-webkit-font-smoothing:antialiased;}

/* ─── SIDEBAR ─── */
.sidebar{
  width:var(--sidebar-w);min-height:100vh;
  background:var(--ink);
  display:flex;flex-direction:column;
  position:fixed;top:0;left:0;z-index:100;
}
.sb-brand{
  padding:24px 20px 20px;
  border-bottom:1px solid rgba(255,255,255,.07);
  display:flex;align-items:center;gap:12px;
}
.sb-logo{
  width:36px;height:36px;border-radius:10px;
  background:var(--blue);
  display:flex;align-items:center;justify-content:center;flex-shrink:0;
}
.sb-logo svg{width:20px;height:20px;color:#fff;}
.sb-name{font-size:14.5px;font-weight:700;color:#fff;letter-spacing:-.2px;}
.sb-loc{font-size:11px;color:rgba(255,255,255,.38);margin-top:1px;font-weight:400;}

.sb-body{flex:1;padding:16px 12px;overflow-y:auto;}
.sb-grp{font-size:9.5px;font-weight:600;letter-spacing:2.5px;text-transform:uppercase;color:rgba(255,255,255,.25);padding:0 10px;margin:20px 0 7px;}
.sb-grp:first-child{margin-top:4px;}

.sb-link{
  display:flex;align-items:center;gap:10px;
  padding:9px 10px;border-radius:var(--rs);
  cursor:pointer;text-decoration:none;
  font-size:13px;font-weight:500;
  color:rgba(255,255,255,.5);
  transition:all .17s;
  margin-bottom:2px;user-select:none;
}
.sb-link:hover{background:rgba(255,255,255,.07);color:rgba(255,255,255,.85);}
.sb-link.active{background:var(--blue);color:#fff;font-weight:600;}
.sb-link.active .sb-dot{background:#fff;opacity:.9;}
.sb-dot{
  width:6px;height:6px;border-radius:50%;
  background:rgba(255,255,255,.25);flex-shrink:0;
  transition:background .17s;
}
.sb-link:hover .sb-dot{background:rgba(255,255,255,.6);}
.lk-ic{width:17px;height:17px;flex-shrink:0;opacity:.7;}
.sb-link.active .lk-ic{opacity:1;}
.sb-link:hover .lk-ic{opacity:.85;}
.sb-pill{
  margin-left:auto;font-size:10px;font-weight:700;
  padding:2px 7px;border-radius:20px;
}
.pill-b{background:var(--blue-bg);color:var(--blue);}
.pill-r{background:var(--coral-bg);color:var(--coral);}

.sb-foot{padding:14px 12px 20px;border-top:1px solid rgba(255,255,255,.07);}
.sb-user{
  display:flex;align-items:center;gap:10px;
  padding:10px;border-radius:var(--rs);
  background:rgba(255,255,255,.06);cursor:pointer;
  transition:background .17s;text-decoration:none;
}
.sb-user:hover{background:rgba(255,255,255,.09);}
.u-av{
  width:32px;height:32px;border-radius:50%;
  background:var(--blue);
  display:flex;align-items:center;justify-content:center;
  font-size:13px;font-weight:700;color:#fff;flex-shrink:0;
}
.u-nm{font-size:12.5px;font-weight:600;color:#fff;}
.u-rl{font-size:10.5px;color:rgba(255,255,255,.4);margin-top:1px;}
.u-out{margin-left:auto;color:rgba(255,255,255,.3);cursor:pointer;transition:color .17s;}
.u-out:hover{color:rgba(255,255,255,.7);}

/* ─── TOPBAR ─── */
.topbar{
  height:var(--header-h);padding:0 28px;
  display:flex;align-items:center;justify-content:space-between;
  background:var(--white);border-bottom:1px solid var(--border);
  position:sticky;top:0;z-index:50;
  box-shadow:0 1px 0 var(--border);
}
.tb-left{display:flex;align-items:center;gap:16px;}
.tb-crumb{font-size:13px;font-weight:500;color:var(--muted);}
.tb-sep{color:var(--faint);}
.tb-page{font-size:13.5px;font-weight:700;color:var(--ink);}

.tb-right{display:flex;align-items:center;gap:9px;}
.search-box{
  display:flex;align-items:center;gap:8px;
  background:var(--bg);border:1px solid var(--border);
  border-radius:9px;padding:7px 13px;width:200px;
}
.search-box svg{color:var(--faint);flex-shrink:0;width:13px;height:13px;}
.search-box input{
  border:none;background:transparent;
  font-family:'DM Sans',sans-serif;font-size:12.5px;color:var(--ink);
  outline:none;width:100%;
}
.search-box input::placeholder{color:var(--faint);}
.ic-btn{
  width:35px;height:35px;border-radius:9px;
  border:1px solid var(--border);background:var(--white);
  cursor:pointer;display:flex;align-items:center;justify-content:center;
  color:var(--muted);transition:all .17s;position:relative;
}
.ic-btn svg{width:15px;height:15px;}
.ic-btn:hover{border-color:var(--blue);color:var(--blue);background:var(--blue-bg);}
.ndot{
  position:absolute;top:7px;right:7px;
  width:6px;height:6px;background:var(--coral);
  border-radius:50%;border:2px solid #fff;
}
.prof{
  display:flex;align-items:center;gap:8px;
  padding:4px 11px 4px 4px;
  background:var(--bg);border:1px solid var(--border);
  border-radius:9px;cursor:pointer;
}
.pav{
  width:27px;height:27px;border-radius:50%;
  background:var(--blue);
  display:flex;align-items:center;justify-content:center;
  font-size:11.5px;font-weight:700;color:#fff;
}
.pnm{font-size:12px;font-weight:600;color:var(--ink);}
.prl{font-size:10px;color:var(--muted);}

/* ─── MAIN ─── */
.main{margin-left:var(--sidebar-w);flex:1;display:flex;flex-direction:column;min-height:100vh;}

/* ─── CONTENT ─── */
.content{padding:24px 28px;flex:1;margin:0 auto;width:100%;}

/* ─── TOP STRIP ─── */
.top-strip{
  display:flex;align-items:center;justify-content:space-between;
  margin-bottom:20px;
}
.ts-left{}
.ts-hi{font-size:22px;font-weight:700;color:var(--ink);letter-spacing:-.3px;}
.ts-sub{font-size:12.5px;color:var(--muted);margin-top:3px;}
.ts-right{display:flex;gap:10px;}

/* ─── PANELS / CARDS ─── */
.panel{
  background:var(--white);border:1px solid var(--border);
  border-radius:var(--r);padding:20px;
  box-shadow:0 1px 2px rgba(15,29,53,.04);
}
.ph{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;}
.pt{font-size:15px;font-weight:700;color:var(--ink);letter-spacing:-.2px;}
.plink{
  font-size:12px;font-weight:600;color:var(--blue);
  padding:4px 11px;background:var(--blue-bg);border-radius:20px;cursor:pointer;
  transition:opacity .17s;text-decoration:none;
}
.plink:hover{opacity:.8;}

/* ─── BUTTONS ─── */
.strip-btn{
  display:inline-flex;align-items:center;gap:7px;
  padding:9px 16px;border-radius:9px;
  font-family:'DM Sans',sans-serif;font-size:12.5px;font-weight:600;
  cursor:pointer;transition:all .18s;border:none;text-decoration:none;
}
.strip-btn svg{width:14px;height:14px;}
.btn-primary{background:var(--blue);color:#fff;}
.btn-primary:hover{background:var(--blue-s);}
.btn-ghost{background:var(--white);color:var(--ink2);border:1px solid var(--border);}
.btn-ghost:hover{border-color:var(--border2);background:var(--bg);}
.btn-success-o{background:var(--emerald);color:#fff;}
.btn-success-o:hover{background:#047857;}
.btn-danger-o{background:var(--coral);color:#fff;}
.btn-danger-o:hover{background:#c53030;}
.btn-warning-o{background:var(--amber);color:#fff;}
.btn-warning-o:hover{background:#b45309;}
.btn-sm{padding:5px 12px;font-size:11.5px;border-radius:7px;}

/* ─── STAT CARDS ─── */
.stat-row{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:14px;margin-bottom:20px;}
.sc{
  background:var(--white);border:1px solid var(--border);
  border-radius:var(--r);padding:18px;
  cursor:default;transition:all .2s;
  box-shadow:0 1px 2px rgba(15,29,53,.04);
}
.sc:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(15,29,53,.07);}
.sc-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;}
.sc-ic{
  width:38px;height:38px;border-radius:10px;
  display:flex;align-items:center;justify-content:center;
}
.sc-ic svg{width:17px;height:17px;}
.sc-tag{font-size:10.5px;font-weight:600;padding:3px 8px;border-radius:20px;}
.tag-up{background:var(--emerald-bg);color:var(--emerald);}
.tag-dn{background:var(--coral-bg);color:var(--coral);}
.tag-neutral{background:var(--bg);color:var(--muted);}
.sc-num{font-size:34px;font-weight:700;color:var(--ink);line-height:1;letter-spacing:-.5px;margin-bottom:4px;}
.sc-lbl{font-size:12px;color:var(--muted);font-weight:500;}
.sc-bar{height:3px;background:var(--bg);border-radius:99px;margin-top:14px;overflow:hidden;}
.sc-fill{height:100%;border-radius:99px;}

/* ─── TABLES ─── */
.tbl{width:100%;border-collapse:collapse;}
.tbl th{
  font-size:10px;font-weight:600;letter-spacing:1.5px;
  text-transform:uppercase;color:var(--muted);
  padding:0 12px 10px 0;text-align:left;
  border-bottom:2px solid var(--border);
}
.tbl td{
  font-size:12.5px;color:var(--ink2);
  padding:11px 12px 11px 0;
  border-bottom:1px solid var(--border);
  vertical-align:middle;
}
.tbl tr:last-child td{border-bottom:none;}
.tbl tr:hover td{background:var(--bg);}

/* ─── STATUS PILLS ─── */
.sp{font-size:10.5px;font-weight:600;padding:3px 9px;border-radius:20px;display:inline-block;}
.sp-confirmed, .sp-res, .badge-confirmed{background:var(--blue-bg);color:var(--blue);}
.sp-checked_in, .sp-in, .badge-checked_in{background:var(--emerald-bg);color:var(--emerald);}
.sp-checked_out, .sp-out, .badge-checked_out{background:var(--bg);color:var(--muted);}
.sp-cancelled, .badge-cancelled{background:var(--coral-bg);color:var(--coral);}
.sp-pending, .sp-pnd, .badge-pending{background:var(--amber-bg);color:var(--amber);}

/* ─── BADGES ─── */
.badge{display:inline-flex;align-items:center;padding:3px 10px;border-radius:20px;font-size:10.5px;font-weight:600;}
.badge-success{background:var(--emerald-bg);color:var(--emerald);}
.badge-warning{background:var(--amber-bg);color:var(--amber);}
.badge-info{background:var(--blue-bg);color:var(--blue);}
.badge-danger{background:var(--coral-bg);color:var(--coral);}
.badge-default{background:var(--bg);color:var(--muted);}
.badge-surcharge{background:var(--amber-bg);color:var(--amber);}
.badge-discount{background:var(--emerald-bg);color:var(--emerald);}

/* ─── FORMS ─── */
.form-group{margin-bottom:18px;}
.form-group label{
  display:block;font-size:12.5px;font-weight:600;
  color:var(--ink);margin-bottom:6px;
}
.form-group input, .form-group select, .form-group textarea{
  width:100%;padding:10px 14px;
  border:1px solid var(--border);border-radius:var(--rs);
  font-size:13px;color:var(--ink);outline:none;
  font-family:'DM Sans',sans-serif;background:var(--white);
  transition:border-color .15s, box-shadow .15s;
}
.form-group input:focus, .form-group select:focus, .form-group textarea:focus{
  border-color:var(--blue);
  box-shadow:0 0 0 3px rgba(53,99,233,.1);
}
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
.form-group.full{grid-column:1 / -1;}
.section-label{
  font-size:13px;font-weight:700;color:var(--ink);
  padding:18px 0 10px;margin-bottom:4px;
  border-bottom:1px solid var(--border);
}

/* ─── ALERTS ─── */
.alert{
  padding:12px 16px;border-radius:var(--rs);font-size:13px;
  margin-bottom:16px;display:flex;align-items:center;gap:8px;
}
.alert-success{background:var(--emerald-bg);color:var(--emerald);border:1px solid var(--emerald-bd);}
.alert-error{background:var(--coral-bg);color:var(--coral);border:1px solid var(--coral-bd);}
.alert-warning{background:var(--amber-bg);color:var(--amber);border:1px solid var(--amber-bd);}
.alert-info{background:var(--blue-bg);color:var(--blue);border:1px solid var(--blue-bd);}

/* ─── SEARCH BAR ─── */
.search-bar{
  display:flex;gap:12px;align-items:center;flex-wrap:wrap;
  margin-bottom:16px;
}
.search-bar input[type="text"], .search-bar input[type="number"],
.search-bar input[type="date"], .search-bar select{
  padding:9px 14px;border:1px solid var(--border);border-radius:var(--rs);
  font-size:12.5px;outline:none;font-family:'DM Sans',sans-serif;background:var(--white);
  color:var(--ink);
}
.search-bar input[type="text"]{flex:1;min-width:200px;}
.search-bar input:focus, .search-bar select:focus{
  border-color:var(--blue);box-shadow:0 0 0 3px rgba(53,99,233,.1);
}
.search-bar .clear-btn{
  padding:9px 16px;border-radius:var(--rs);border:1px solid var(--border);
  background:var(--white);color:var(--muted);font-size:12.5px;
  cursor:pointer;font-weight:500;font-family:'DM Sans',sans-serif;
}
.search-bar .clear-btn:hover{background:var(--bg);}
.result-count{font-size:12px;color:var(--muted);}

/* ─── FILTER PILLS ─── */
.filter-pills{display:flex;gap:8px;margin-bottom:16px;flex-wrap:wrap;}
.filter-pill{
  padding:7px 16px;border-radius:20px;border:1px solid var(--border);
  background:var(--white);color:var(--muted);font-size:12.5px;
  font-weight:500;cursor:pointer;text-decoration:none;transition:all .17s;
}
.filter-pill:hover,.filter-pill.active{
  background:var(--blue);color:white;border-color:var(--blue);
}

/* ─── EMPTY STATE ─── */
.empty-state{text-align:center;padding:60px 20px;color:var(--muted);}
.empty-state p{font-size:13px;}
.empty-state a{color:var(--blue);text-decoration:none;font-weight:600;}

/* ─── UTILITY ─── */
.text-muted{color:var(--muted);}
.text-sm{font-size:12px;}
.text-success{color:var(--emerald);}
.text-danger{color:var(--coral);}
.font-mono{font-family:'SF Mono','Consolas',monospace;font-size:12px;}
.font-bold{font-weight:700;}
.mt-4{margin-top:16px;}
.mb-4{margin-bottom:16px;}
.mb-6{margin-bottom:24px;}
.gap-row{display:flex;gap:12px;align-items:center;}

/* ─── ROOM SUMMARY ─── */
.rm-grid{display:grid;grid-template-columns:1fr 1fr;gap:9px;}
.rm-card{border-radius:10px;padding:14px;border:1px solid var(--border);display:flex;flex-direction:column;}
.rm-num{font-size:30px;font-weight:700;letter-spacing:-.5px;line-height:1;}
.rm-lbl{font-size:11.5px;font-weight:500;margin-top:3px;}
.rm-bar{height:4px;border-radius:99px;margin-top:10px;overflow:hidden;}
.rm-fill{height:100%;border-radius:99px;}

/* ─── OCCUPANCY BARS ─── */
.ob-list{display:flex;flex-direction:column;gap:13px;}
.ob-meta{display:flex;justify-content:space-between;align-items:center;margin-bottom:5px;}
.ob-nm{font-size:12.5px;font-weight:600;color:var(--ink);}
.ob-ct{font-size:11.5px;color:var(--muted);}
.ob-track{height:6px;background:var(--bg);border-radius:99px;overflow:hidden;border:1px solid var(--border);}
.ob-fill{height:100%;border-radius:99px;transition:width 1.2s cubic-bezier(.4,0,.2,1);}

/* ─── GUEST AVATAR ─── */
.gav{
  width:26px;height:26px;border-radius:50%;
  display:inline-flex;align-items:center;justify-content:center;
  font-size:10.5px;font-weight:700;color:#fff;
  margin-right:7px;vertical-align:middle;flex-shrink:0;
}

/* ─── SCROLLBAR ─── */
::-webkit-scrollbar{width:4px;}
::-webkit-scrollbar-track{background:transparent;}
::-webkit-scrollbar-thumb{background:var(--border2);border-radius:99px;}

/* ─── ANIMATIONS ─── */
@keyframes fu{from{opacity:0;transform:translateY(10px);}to{opacity:1;transform:translateY(0);}}
.top-strip{animation:fu .28s .04s ease both;}
.stat-row  {animation:fu .28s .10s ease both;}
.mid       {animation:fu .28s .16s ease both;}
.bottom    {animation:fu .28s .22s ease both;}
.content > *:nth-child(1){animation:fu .28s .04s ease both;}
.content > *:nth-child(2){animation:fu .28s .10s ease both;}
.content > *:nth-child(3){animation:fu .28s .16s ease both;}
.content > *:nth-child(4){animation:fu .28s .22s ease both;}
.content > *:nth-child(5){animation:fu .28s .28s ease both;}

/* ─── PRINT ─── */
@media print{
  .sidebar,.topbar,.no-print{display:none !important;}
  .main{margin:0;}
  .content{padding:20px;}
  .panel{box-shadow:none;}
}
</style>

