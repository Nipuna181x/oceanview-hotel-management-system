<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Error - Ocean View HMS</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:'DM Sans',sans-serif;background:#f0f2f8;display:flex;align-items:center;justify-content:center;min-height:100vh;-webkit-font-smoothing:antialiased;}
.error-card{background:white;border-radius:14px;padding:48px;max-width:500px;text-align:center;box-shadow:0 1px 2px rgba(15,29,53,.04);border:1px solid #e2e7f1;}
.error-code{font-size:72px;font-weight:700;color:#e2e7f1;margin-bottom:8px;letter-spacing:-2px;}
.error-title{font-size:20px;font-weight:700;color:#0f1d35;margin-bottom:8px;letter-spacing:-.3px;}
.error-msg{font-size:13px;color:#7a8aa8;line-height:1.6;margin-bottom:24px;}
.btn-home{display:inline-flex;align-items:center;gap:7px;padding:10px 24px;background:#3563e9;color:white;border-radius:9px;text-decoration:none;font-size:13px;font-weight:600;transition:background 0.18s;font-family:'DM Sans',sans-serif;}
.btn-home:hover{background:#2952cc;}
.logo-wrap{width:48px;height:48px;border-radius:12px;background:#3563e9;display:flex;align-items:center;justify-content:center;margin:0 auto 20px;}
.logo-wrap svg{width:24px;height:24px;color:#fff;}
</style></head><body>
<div class="error-card">
<div class="logo-wrap">
<svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
<path d="M2 12c2-2 4-3 6-3s4 1 6 3 4 3 6 3"/>
<path d="M2 17c2-2 4-3 6-3s4 1 6 3 4 3 6 3"/>
<circle cx="12" cy="5" r="2"/>
<line x1="12" y1="7" x2="12" y2="12"/>
</svg>
</div>
<div class="error-code">500</div>
<div class="error-title">Something went wrong</div>
<div class="error-msg">An unexpected error occurred. Please try again or contact your administrator if the problem persists.</div>
<a href="${pageContext.request.contextPath}/dashboard" class="btn-home">Go to Dashboard</a>
</div></body></html>