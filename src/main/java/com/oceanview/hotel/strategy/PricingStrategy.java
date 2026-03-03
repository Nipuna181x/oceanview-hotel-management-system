package com.oceanview.hotel.strategy;

/**
 * Strategy Pattern — defines the algorithm interface for billing calculations.
 *
 * Each concrete strategy implements a different pricing algorithm:
 * - StandardPricingStrategy: base rate, no modifications
 * - SeasonalPricingStrategy: 20% surcharge for peak season
 * - DiscountPricingStrategy: 10% discount for stays of 7+ nights
 *
 * This pattern avoids large if-else chains and allows new pricing
 * strategies to be added without modifying existing code (Open/Closed Principle).
 */
public interface PricingStrategy {

    /**
     * Calculate the subtotal for a stay.
     *
     * @param ratePerNight the room's base rate per night
     * @param numNights    the number of nights
     * @return the calculated subtotal (before tax)
     */
    double calculateSubtotal(double ratePerNight, int numNights);

    /**
     * Return the name of this strategy (used for bill records).
     */
    String getStrategyName();
}

