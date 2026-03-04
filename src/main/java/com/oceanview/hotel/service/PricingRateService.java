package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.PricingRateDAO;
import com.oceanview.hotel.model.PricingRate;

import java.util.List;

/**
 * Service for admin-managed pricing strategies.
 * Admins can create, edit, delete strategies with + or - % adjustments.
 */
public class PricingRateService {

    private final PricingRateDAO pricingRateDAO;

    public PricingRateService(PricingRateDAO pricingRateDAO) {
        this.pricingRateDAO = pricingRateDAO;
    }

    public List<PricingRate> getAllStrategies() {
        return pricingRateDAO.findAll();
    }

    public PricingRate getById(int id) {
        PricingRate s = pricingRateDAO.findById(id);
        if (s == null) throw new IllegalArgumentException("Strategy not found with ID: " + id);
        return s;
    }

    public PricingRate getByName(String name) {
        if (name == null || name.trim().isEmpty()) throw new IllegalArgumentException("Name cannot be blank");
        PricingRate s = pricingRateDAO.findByName(name.trim());
        if (s == null) throw new IllegalArgumentException("Strategy not found: " + name);
        return s;
    }

    public PricingRate getDefault() {
        PricingRate s = pricingRateDAO.findDefault();
        if (s == null) throw new IllegalStateException("No default pricing strategy configured");
        return s;
    }

    public int addStrategy(String name, PricingRate.AdjustmentType adjustmentType,
                           double adjustmentPercent, String description, boolean isDefault) {
        if (name == null || name.trim().isEmpty())
            throw new IllegalArgumentException("Strategy name cannot be blank");
        if (adjustmentType == null)
            throw new IllegalArgumentException("Adjustment type is required");
        if (adjustmentPercent < 0)
            throw new IllegalArgumentException("Adjustment percent cannot be negative");

        PricingRate strategy = new PricingRate();
        strategy.setName(name.trim());
        strategy.setAdjustmentType(adjustmentType);
        strategy.setAdjustmentPercent(adjustmentPercent);
        strategy.setDescription(description);
        strategy.setDefault(isDefault);

        if (isDefault) clearOtherDefaults(-1);

        return pricingRateDAO.save(strategy);
    }

    public boolean updateStrategy(int id, String name, PricingRate.AdjustmentType adjustmentType,
                                  double adjustmentPercent, String description, boolean isDefault) {
        PricingRate existing = getById(id);
        existing.setName(name != null ? name.trim() : existing.getName());
        existing.setAdjustmentType(adjustmentType != null ? adjustmentType : existing.getAdjustmentType());
        existing.setAdjustmentPercent(adjustmentPercent);
        existing.setDescription(description);
        existing.setDefault(isDefault);

        if (isDefault) clearOtherDefaults(id);

        return pricingRateDAO.update(existing);
    }

    public boolean deleteStrategy(int id) {
        PricingRate s = getById(id);
        if (s.isDefault()) throw new IllegalArgumentException("Cannot delete the default pricing strategy");
        return pricingRateDAO.delete(id);
    }

    /**
     * Clear isDefault on all strategies except the one with the given ID.
     */
    private void clearOtherDefaults(int exceptId) {
        for (PricingRate s : pricingRateDAO.findAll()) {
            if (s.getStrategyId() != exceptId && s.isDefault()) {
                s.setDefault(false);
                pricingRateDAO.update(s);
            }
        }
    }
}
