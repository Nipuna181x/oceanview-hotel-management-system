package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.BillDAO;
import com.oceanview.hotel.dao.PricingRateDAO;
import com.oceanview.hotel.dao.ReservationDAO;
import com.oceanview.hotel.model.Bill;
import com.oceanview.hotel.model.PricingRate;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.Room;
import com.oceanview.hotel.strategy.DatabasePricingStrategy;
import com.oceanview.hotel.strategy.PricingStrategy;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

// Calculates and saves bills using the chosen pricing strategy
public class BillingService {

    private static final double TAX_RATE = 0.10; // 10%

    private final BillDAO billDAO;
    private final ReservationDAO reservationDAO;
    private final PricingRateDAO pricingRateDAO;

    public BillingService(BillDAO billDAO, ReservationDAO reservationDAO, PricingRateDAO pricingRateDAO) {
        this.billDAO = billDAO;
        this.reservationDAO = reservationDAO;
        this.pricingRateDAO = pricingRateDAO;
    }

    public Bill generateBill(int reservationId, int strategyId) {
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException("Reservation not found with ID: " + reservationId);
        }

        PricingRate strategyRecord = pricingRateDAO.findById(strategyId);
        if (strategyRecord == null) {
            throw new IllegalArgumentException("Pricing strategy not found with ID: " + strategyId);
        }
        PricingStrategy strategy = new DatabasePricingStrategy(strategyRecord);

        Room room = reservation.getRoom();
        double ratePerNight = room.getRatePerNight();

        LocalDate checkIn = reservation.getCheckInDate();
        LocalDate checkOut = reservation.getCheckOutDate();
        int numNights = (int) ChronoUnit.DAYS.between(checkIn, checkOut);

        double subtotal = strategy.calculateSubtotal(ratePerNight, numNights);
        double taxAmount = Math.round(subtotal * TAX_RATE * 100.0) / 100.0;
        double totalAmount = Math.round((subtotal + taxAmount) * 100.0) / 100.0;
        subtotal = Math.round(subtotal * 100.0) / 100.0;

        Bill bill = new Bill();
        bill.setReservationId(reservationId);
        bill.setNumNights(numNights);
        bill.setRatePerNight(ratePerNight);
        bill.setSubtotal(subtotal);
        bill.setTaxAmount(taxAmount);
        bill.setTotalAmount(totalAmount);
        bill.setPricingStrategyUsed(strategy.getStrategyName());
        bill.setGeneratedAt(LocalDateTime.now());

        int billId = billDAO.save(bill);
        bill.setBillId(billId);
        return bill;
    }

    public Bill getBillByReservationId(int reservationId) {
        Bill bill = billDAO.findByReservationId(reservationId);
        if (bill == null) {
            throw new BillNotFoundException("No bill found for reservation ID: " + reservationId);
        }
        return bill;
    }

    public List<Bill> getAllBills() {
        return billDAO.findAll();
    }

    public Bill getBillById(int billId) {
        Bill bill = billDAO.findById(billId);
        if (bill == null) {
            throw new BillNotFoundException("No bill found with ID: " + billId);
        }
        return bill;
    }

    // Only checked-in/out reservations that haven't been billed yet
    public List<Reservation> getUnbilledReservations() {
        List<Reservation> all = reservationDAO.findAll();
        return all.stream()
                .filter(r -> r.getStatus() == Reservation.Status.CHECKED_IN
                          || r.getStatus() == Reservation.Status.CHECKED_OUT)
                .filter(r -> billDAO.findByReservationId(r.getReservationId()) == null)
                .collect(Collectors.toList());
    }
}
