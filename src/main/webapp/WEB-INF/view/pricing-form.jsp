<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${empty strategy ? 'Add Pricing Strategy' : 'Edit Pricing Strategy'} — Ocean View Resort HMS</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#f0f4f8; }
        .navbar { background:linear-gradient(135deg,#0a3d62,#1e6091); color:white; padding:0 30px; display:flex; align-items:center; justify-content:space-between; height:60px; }
        .navbar .brand { font-size:18px; font-weight:700; }
        .navbar .brand span { color:#85c1e9; }
        .navbar a { color:#d6eaf8; text-decoration:none; margin-left:20px; font-size:14px; }
        .navbar .btn-logout { background:#e74c3c; padding:6px 14px; border-radius:6px; }
        .main { padding:30px; max-width:560px; margin:0 auto; }
        .page-header { margin-bottom:24px; }
        .page-header h2 { color:#0a3d62; font-size:22px; }
        .card { background:white; border-radius:12px; padding:32px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .form-group { margin-bottom:20px; }
        label { display:block; font-size:13px; font-weight:600; color:#2c3e50; margin-bottom:6px; }
        input[type=text], input[type=number], select, textarea {
            width:100%; padding:12px 14px; border:1px solid #d5d8dc; border-radius:8px;
            font-size:14px; transition:border-color 0.2s;
        }
        textarea { resize:vertical; min-height:80px; }
        input:focus, select:focus, textarea:focus { outline:none; border-color:#2980b9; box-shadow:0 0 0 3px rgba(41,128,185,0.1); }
        .hint { font-size:12px; color:#95a5a6; margin-top:4px; }
        .btn { padding:12px 24px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
        .btn-primary { background:linear-gradient(135deg,#0a3d62,#2980b9); color:white; }
        .btn-secondary { background:#ecf0f1; color:#2c3e50; }
        .form-actions { display:flex; gap:12px; margin-top:28px; }
        .alert-error { background:#fdecea; border-left:4px solid #e74c3c; color:#c0392b; padding:12px 16px; border-radius:6px; margin-bottom:20px; font-size:13px; }
        .admin-badge { background:#e74c3c; color:white; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:700; margin-left:8px; }
        .checkbox-group { display:flex; align-items:center; gap:8px; }
        .checkbox-group input[type=checkbox] { width:auto; }
        .preview-box { background:#f8fbff; border:1px solid #d6eaf8; border-radius:8px; padding:14px 16px; margin-top:16px; font-size:13px; }
        .preview-box strong { color:#0a3d62; }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="brand">🌊 Ocean View <span>Resort HMS</span></div>
    <div>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/pricing">Pricing Strategies</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>
<div class="main">
    <div class="page-header">
        <h2>${empty strategy ? '➕ Add Pricing Strategy' : '✏️ Edit Pricing Strategy'} <span class="admin-badge">ADMIN</span></h2>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert-error">⚠ ${errorMessage}</div>
    </c:if>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/pricing">
            <input type="hidden" name="action" value="${empty strategy ? 'create' : 'update'}"/>
            <c:if test="${not empty strategy}">
                <input type="hidden" name="strategyId" value="${strategy.strategyId}"/>
            </c:if>

            <div class="form-group">
                <label for="name">Strategy Name *</label>
                <input type="text" id="name" name="name"
                       value="${not empty strategy ? strategy.name : ''}"
                       required placeholder="e.g. Seasonal, Weekend, Holiday"/>
                <p class="hint">Give a descriptive name for this pricing strategy.</p>
            </div>

            <div class="form-group">
                <label for="adjustmentType">Adjustment Type *</label>
                <select id="adjustmentType" name="adjustmentType" required onchange="updatePreview()">
                    <option value="SURCHARGE" ${strategy.adjustmentType.toString() == 'SURCHARGE' ? 'selected' : ''}>
                        📈 Surcharge (+%) — increase the base rate
                    </option>
                    <option value="DISCOUNT" ${strategy.adjustmentType.toString() == 'DISCOUNT' ? 'selected' : ''}>
                        📉 Discount (-%) — decrease the base rate
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label for="adjustmentPercent">Adjustment Percentage (%) *</label>
                <input type="number" id="adjustmentPercent" name="adjustmentPercent"
                       value="${not empty strategy ? strategy.adjustmentPercent : '0'}"
                       required min="0" max="100" step="0.1" placeholder="e.g. 20"
                       oninput="updatePreview()"/>
                <p class="hint">Enter the percentage value. E.g. 20 for +20% surcharge or -20% discount.</p>
            </div>

            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description"
                          placeholder="e.g. Peak season surcharge for summer months">${not empty strategy ? strategy.description : ''}</textarea>
                <p class="hint">Optional. Helps staff understand when this strategy applies.</p>
            </div>

            <div class="form-group">
                <div class="checkbox-group">
                    <input type="checkbox" id="isDefault" name="isDefault" ${strategy.strategyDefault ? 'checked' : ''}/>
                    <label for="isDefault" style="margin-bottom:0;">Set as Default Strategy</label>
                </div>
                <p class="hint">The default strategy is pre-selected when generating bills. Only one can be default.</p>
            </div>

            <div class="preview-box" id="previewBox">
                <strong>💡 Preview:</strong> If room rate is <strong>Rs. 5,000/night</strong> for <strong>3 nights</strong>:
                <br/>Subtotal = 5,000 × 3 × <span id="previewMultiplier">1.00</span> = <strong>Rs. <span id="previewTotal">15,000.00</span></strong>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    ${empty strategy ? '➕ Add Strategy' : '💾 Save Changes'}
                </button>
                <a href="${pageContext.request.contextPath}/pricing" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
    function updatePreview() {
        var type = document.getElementById('adjustmentType').value;
        var pct = parseFloat(document.getElementById('adjustmentPercent').value) || 0;
        var multiplier;
        if (type === 'DISCOUNT') {
            multiplier = 1.0 - (pct / 100.0);
        } else {
            multiplier = 1.0 + (pct / 100.0);
        }
        var base = 5000;
        var nights = 3;
        var total = base * nights * multiplier;
        document.getElementById('previewMultiplier').textContent = multiplier.toFixed(2);
        document.getElementById('previewTotal').textContent = total.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
    updatePreview();
</script>
</body>
</html>

