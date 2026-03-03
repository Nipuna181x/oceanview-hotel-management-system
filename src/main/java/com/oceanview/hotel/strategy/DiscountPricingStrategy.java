package com.oceanview.hotel.strategy;

/**
 * Discount pricing strategy — applies a 10% discount for stays of 7+ nights.
 * Encourages longer stays. For stays under 7 nights, standard rate applies.
 *
 * If numNights >= 7: subtotal = ratePerNight * 0.90 * numNights
 * If numNights < 7:  subtotal = ratePerNight * numNights (no discount)
 */
public class DiscountPricingStrategy implements PricingStrategy {

    private static final double DISCOUNT_MULTIPLIER = 0.90;
    private static final int MIN_NIGHTS_FOR_DISCOUNT = 7;

    @Override
    public double calculateSubtotal(double ratePerNight, int numNights) {
        if (numNights >= MIN_NIGHTS_FOR_DISCOUNT) {
            return ratePerNight * DISCOUNT_MULTIPLIER * numNights;
        }
        return ratePerNight * numNights;
    }

    @Override
    public String getStrategyName() {
        return "DISCOUNT";
    }
}

