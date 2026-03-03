package com.oceanview.hotel.strategy;

/**
 * Standard pricing strategy — base rate with no modifications.
 * subtotal = ratePerNight * numNights
 */
public class StandardPricingStrategy implements PricingStrategy {

    @Override
    public double calculateSubtotal(double ratePerNight, int numNights) {
        return ratePerNight * numNights;
    }

    @Override
    public String getStrategyName() {
        return "STANDARD";
    }
}

