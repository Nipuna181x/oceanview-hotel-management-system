package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.BillDAO;
import com.oceanview.hotel.dao.ReservationDAO;
import com.oceanview.hotel.model.Bill;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.Room;
import com.oceanview.hotel.strategy.*;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.time.LocalDateTime;

/**
 * Service class encapsulating all billing business logic.
 *
 * Design Patterns:
 * - Strategy: selects the correct PricingStrategy at runtime based on the
 *   strategy name — Standard, Seasonal, or Discount. Adding a new pricing
 *   model only requires a new class implementing PricingStrategy, with no
 *   changes to BillingService itself (Open/Closed Principle).
 * - Service Layer / Facade: single entry point for all billing operations.
 * - DAO: delegates persistence to BillDAO and ReservationDAO interfaces.
 */
public class BillingService {

    private static final double TAX_RATE = 0.10; // 10% tax

    private final BillDAO billDAO;
    private final ReservationDAO reservationDAO;

    public BillingService(BillDAO billDAO, ReservationDAO reservationDAO) {
        this.billDAO = billDAO;
        this.reservationDAO = reservationDAO;
    }

    /**
     * Generate a bill for a reservation using the specified pricing strategy.
     *
     * @param reservationId  the reservation to bill
     * @param strategyName   "STANDARD", "SEASONAL", or "DISCOUNT"
     * @return the generated Bill object
     * @throws ReservationNotFoundException if reservation not found
     * @throws IllegalArgumentException     if strategyName is invalid
     */
    public Bill generateBill(int reservationId, String strategyName) {
        // Step 1: Load reservation
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException(
                    "Reservation not found with ID: " + reservationId);
        }

        // Step 2: Select pricing strategy (Strategy pattern)
        PricingStrategy strategy = resolveStrategy(strategyName);

        // Step 3: Calculate billing figures
        Room room = reservation.getRoom();
        double ratePerNight = room.getRatePerNight();

        LocalDate checkIn = reservation.getCheckInDate();
        LocalDate checkOut = reservation.getCheckOutDate();
        int numNights = (int) ChronoUnit.DAYS.between(checkIn, checkOut);

        double subtotal = strategy.calculateSubtotal(ratePerNight, numNights);
        double taxAmount = Math.round(subtotal * TAX_RATE * 100.0) / 100.0;
        double totalAmount = Math.round((subtotal + taxAmount) * 100.0) / 100.0;
        subtotal = Math.round(subtotal * 100.0) / 100.0;

        // Step 4: Build Bill object
        Bill bill = new Bill();
        bill.setReservationId(reservationId);
        bill.setNumNights(numNights);
        bill.setRatePerNight(ratePerNight);
        bill.setSubtotal(subtotal);
        bill.setTaxAmount(taxAmount);
        bill.setTotalAmount(totalAmount);
        bill.setPricingStrategyUsed(strategy.getStrategyName());
        bill.setGeneratedAt(LocalDateTime.now());

        // Step 5: Persist via DAO
        int billId = billDAO.save(bill);
        bill.setBillId(billId);

        return bill;
    }

    /**
     * Retrieve an existing bill for a reservation.
     *
     * @throws BillNotFoundException if no bill exists for the reservation
     */
    public Bill getBillByReservationId(int reservationId) {
        Bill bill = billDAO.findByReservationId(reservationId);
        if (bill == null) {
            throw new BillNotFoundException(
                    "No bill found for reservation ID: " + reservationId);
        }
        return bill;
    }

    /**
     * Resolve a strategy name to a PricingStrategy implementation.
     * Strategy Pattern — runtime selection of algorithm.
     */
    private PricingStrategy resolveStrategy(String strategyName) {
        if (strategyName == null || strategyName.trim().isEmpty()) {
            throw new IllegalArgumentException("Pricing strategy cannot be null or empty");
        }
        switch (strategyName.toUpperCase()) {
            case "STANDARD":  return new StandardPricingStrategy();
            case "SEASONAL":  return new SeasonalPricingStrategy();
            case "DISCOUNT":  return new DiscountPricingStrategy();
            default:
                throw new IllegalArgumentException(
                        "Unknown pricing strategy: " + strategyName +
                        ". Valid values: STANDARD, SEASONAL, DISCOUNT");
        }
    }
}

