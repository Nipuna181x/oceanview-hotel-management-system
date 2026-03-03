package com.oceanview.hotel.strategy;

/**
 * Seasonal pricing strategy — applies a 20% surcharge to the base rate.
 * Used during peak tourist seasons.
 * subtotal = ratePerNight * 1.20 * numNights
 */
public class SeasonalPricingStrategy implements PricingStrategy {

    private static final double SEASONAL_SURCHARGE = 1.20;

    @Override
    public double calculateSubtotal(double ratePerNight, int numNights) {
        return ratePerNight * SEASONAL_SURCHARGE * numNights;
    }

    @Override
    public String getStrategyName() {
        return "SEASONAL";
    }
}

