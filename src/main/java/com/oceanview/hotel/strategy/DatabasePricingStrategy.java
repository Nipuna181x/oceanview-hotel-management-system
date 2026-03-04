package com.oceanview.hotel.strategy;

import com.oceanview.hotel.model.PricingRate;

/**
 * Database-driven pricing strategy.
 * Reads adjustment from the PricingRate record stored in the DB.
 *
 * Strategy Pattern — single implementation that replaces the 3 old
 * hardcoded strategies (Standard, Seasonal, Discount).
 */
public class DatabasePricingStrategy implements PricingStrategy {

    private final PricingRate record;

    public DatabasePricingStrategy(PricingRate record) {
        if (record == null) throw new IllegalArgumentException("Strategy record cannot be null");
        this.record = record;
    }

    @Override
    public double calculateSubtotal(double ratePerNight, int numNights) {
        return ratePerNight * numNights * record.getMultiplier();
    }

    @Override
    public String getStrategyName() {
        return record.getName();
    }
}

