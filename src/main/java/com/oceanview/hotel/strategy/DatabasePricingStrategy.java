package com.oceanview.hotel.strategy;

import com.oceanview.hotel.model.PricingRate;

// Reads the adjustment multiplier from the DB-backed PricingRate record
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
