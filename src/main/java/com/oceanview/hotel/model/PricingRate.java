package com.oceanview.hotel.model;

import java.time.LocalDateTime;

/**
 * Represents an admin-configurable pricing strategy.
 * E.g. "Standard" (0%), "Seasonal" (+20%), "Long Stay" (-10%).
 */
public class PricingRate {

    public enum AdjustmentType {
        SURCHARGE, DISCOUNT
    }

    private int strategyId;
    private String name;
    private AdjustmentType adjustmentType;
    private double adjustmentPercent;
    private String description;
    private boolean isDefault;
    private LocalDateTime createdAt;

    public PricingRate() {}

    public int getStrategyId() { return strategyId; }
    public void setStrategyId(int strategyId) { this.strategyId = strategyId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public AdjustmentType getAdjustmentType() { return adjustmentType; }
    public void setAdjustmentType(AdjustmentType adjustmentType) { this.adjustmentType = adjustmentType; }

    public double getAdjustmentPercent() { return adjustmentPercent; }
    public void setAdjustmentPercent(double adjustmentPercent) { this.adjustmentPercent = adjustmentPercent; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }

    /** Alias for JSP EL — avoids 'default' reserved keyword: use ${s.strategyDefault} */
    public boolean isStrategyDefault() { return isDefault; }
    public void setStrategyDefault(boolean isDefault) { this.isDefault = isDefault; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    /**
     * Returns the effective multiplier.
     * SURCHARGE +20% → 1.20, DISCOUNT 10% → 0.90
     */
    public double getMultiplier() {
        if (adjustmentType == AdjustmentType.DISCOUNT) {
            return 1.0 - (adjustmentPercent / 100.0);
        }
        return 1.0 + (adjustmentPercent / 100.0);
    }

    /**
     * Human-readable label for display: e.g. "+20%" or "-10%"
     */
    public String getAdjustmentLabel() {
        if (adjustmentPercent == 0) return "0%";
        if (adjustmentType == AdjustmentType.DISCOUNT) return "-" + adjustmentPercent + "%";
        return "+" + adjustmentPercent + "%";
    }

    @Override
    public String toString() {
        return "PricingRate{strategyId=" + strategyId + ", name='" + name +
                "', " + adjustmentType + " " + adjustmentPercent + "%, default=" + isDefault + "}";
    }
}
