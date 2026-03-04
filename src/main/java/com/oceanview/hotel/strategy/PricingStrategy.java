package com.oceanview.hotel.strategy;

/**
 * Strategy Pattern — defines the algorithm interface for billing calculations.
 *
 * Concrete implementation: DatabasePricingStrategy reads adjustment
 * percentage from the pricing_strategies DB table. Admin can create
 * custom strategies with SURCHARGE (+%) or DISCOUNT (-%) adjustments.
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

