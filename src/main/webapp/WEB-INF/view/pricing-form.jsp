<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty strategy ? 'New' : 'Edit'} Strategy - Ocean View HMS</title>
    <%@ include file="_layout-head.jsp" %>
</head>

<body>
    <%@ include file="_sidebar.jsp" %>

    <div class="main">
        <c:set var="pageTitle" value="${empty strategy ? 'New Strategy' : 'Edit Strategy'}" scope="request" />
        <%@ include file="_header.jsp" %>

        <div class="content" style="max-width:740px;">
            <div class="top-strip">
                <div class="ts-left">
                    <div class="ts-hi">${empty strategy ? 'Create New Strategy' : 'Edit Strategy'}</div>
                    <div class="ts-sub">Define pricing adjustments for billing</div>
                </div>
                <div class="ts-right">
                    <a href="${pageContext.request.contextPath}/pricing" class="strip-btn btn-ghost">Back to Pricing</a>
                </div>
            </div>

            <div class="panel">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${errorMessage}</div>
                </c:if>
                <form action="${pageContext.request.contextPath}/pricing" method="post">
                    <input type="hidden" name="action" value="${empty strategy ? 'create' : 'update'}" />
                    <c:if test="${not empty strategy}">
                        <input type="hidden" name="strategyId" value="${strategy.strategyId}" />
                    </c:if>
                    <div class="form-group">
                        <label for="name">Strategy Name *</label>
                        <input type="text" id="name" name="name" value="${not empty strategy ? strategy.name : ''}"
                            required placeholder="e.g. Seasonal Peak" />
                    </div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="adjustmentType">Adjustment Type *</label>
                            <select id="adjustmentType" name="adjustmentType" required>
                                <option value="SURCHARGE"
                                    ${strategy.adjustmentType.toString() == 'SURCHARGE' ? 'selected' : ''}>
                                    Surcharge (+%)</option>
                                <option value="DISCOUNT"
                                    ${strategy.adjustmentType.toString() == 'DISCOUNT' ? 'selected' : ''}>
                                    Discount (-%)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="adjustmentPercent">Adjustment % *</label>
                            <input type="number" id="adjustmentPercent" name="adjustmentPercent"
                                value="${not empty strategy ? strategy.adjustmentPercent : '0'}" min="0" max="100"
                                step="0.1" required />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <input type="text" id="description" name="description"
                            value="${not empty strategy ? strategy.description : ''}"
                            placeholder="e.g. Applied during peak holiday season" />
                    </div>
                    <div class="form-group">
                        <label><input type="checkbox" id="isDefault" name="isDefault"
                                ${strategy.strategyDefault ? 'checked' : ''} style="width:auto;margin-right:8px;" />Set as
                            Default Strategy</label>
                    </div>
                    <div style="display:flex;gap:12px;margin-top:20px;">
                        <button type="submit" class="strip-btn btn-primary">
                            ${empty strategy ? 'Create Strategy' : 'Update Strategy'}
                        </button>
                        <a href="${pageContext.request.contextPath}/pricing" class="strip-btn btn-ghost">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>

</html>
