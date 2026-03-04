package com.oceanview.hotel.strategy;

// Interface for billing calculations — swap strategies without changing billing logic
public interface PricingStrategy {

    // Calculate subtotal (before tax) for a stay
    double calculateSubtotal(double ratePerNight, int numNights);

    // Name stored on the bill record
    String getStrategyName();
}
