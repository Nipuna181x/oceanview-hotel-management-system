package com.oceanview.hotel.model;

import java.time.LocalDateTime;

/**
 * Represents a bill generated for a reservation.
 * Stores calculated totals including tax.
 */
public class Bill {

    private int billId;
    private int reservationId;
    private int numNights;
    private double ratePerNight;
    private double subtotal;
    private double taxAmount;
    private double totalAmount;
    private String pricingStrategyUsed;
    private LocalDateTime generatedAt;

    // Transient reference for display
    private Reservation reservation;

    public Bill() {
    }

    public Bill(int billId, int reservationId, int numNights, double ratePerNight,
                double subtotal, double taxAmount, double totalAmount,
                String pricingStrategyUsed, LocalDateTime generatedAt) {
        this.billId = billId;
        this.reservationId = reservationId;
        this.numNights = numNights;
        this.ratePerNight = ratePerNight;
        this.subtotal = subtotal;
        this.taxAmount = taxAmount;
        this.totalAmount = totalAmount;
        this.pricingStrategyUsed = pricingStrategyUsed;
        this.generatedAt = generatedAt;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public int getNumNights() {
        return numNights;
    }

    public void setNumNights(int numNights) {
        this.numNights = numNights;
    }

    public double getRatePerNight() {
        return ratePerNight;
    }

    public void setRatePerNight(double ratePerNight) {
        this.ratePerNight = ratePerNight;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public double getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(double taxAmount) {
        this.taxAmount = taxAmount;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPricingStrategyUsed() {
        return pricingStrategyUsed;
    }

    public void setPricingStrategyUsed(String pricingStrategyUsed) {
        this.pricingStrategyUsed = pricingStrategyUsed;
    }

    public LocalDateTime getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(LocalDateTime generatedAt) {
        this.generatedAt = generatedAt;
    }

    public Reservation getReservation() {
        return reservation;
    }

    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    @Override
    public String toString() {
        return "Bill{" +
                "billId=" + billId +
                ", reservationId=" + reservationId +
                ", numNights=" + numNights +
                ", ratePerNight=" + ratePerNight +
                ", subtotal=" + subtotal +
                ", taxAmount=" + taxAmount +
                ", totalAmount=" + totalAmount +
                ", pricingStrategyUsed='" + pricingStrategyUsed + '\'' +
                ", generatedAt=" + generatedAt +
                '}';
    }
}

