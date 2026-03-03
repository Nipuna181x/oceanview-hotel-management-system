package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.BillDAO;
import com.oceanview.hotel.dao.ReservationDAO;
import com.oceanview.hotel.model.Bill;
import com.oceanview.hotel.model.Guest;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.Room;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * TDD Test class for BillingService.
 * Tests all three pricing strategies, tax calculation, and edge cases.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("BillingService Tests")
class BillingServiceTest {

    @Mock
    private BillDAO billDAO;

    @Mock
    private ReservationDAO reservationDAO;

    @InjectMocks
    private BillingService billingService;

    private Reservation reservation3Nights;
    private Reservation reservation7Nights;
    private Reservation reservation1Night;
    private Room singleRoom;
    private Room suiteRoom;

    @BeforeEach
    void setUp() {
        singleRoom = new Room(1, "101", Room.RoomType.SINGLE, 75.00, false);
        suiteRoom = new Room(2, "301", Room.RoomType.SUITE, 250.00, false);

        Guest guest = new Guest();
        guest.setGuestId(1);
        guest.setFullName("John Smith");

        reservation3Nights = new Reservation();
        reservation3Nights.setReservationId(1);
        reservation3Nights.setReservationNumber("RES-20260304-001");
        reservation3Nights.setCheckInDate(LocalDate.of(2026, 3, 5));
        reservation3Nights.setCheckOutDate(LocalDate.of(2026, 3, 8));
        reservation3Nights.setStatus(Reservation.Status.CONFIRMED);
        reservation3Nights.setRoom(singleRoom);
        reservation3Nights.setGuest(guest);

        reservation7Nights = new Reservation();
        reservation7Nights.setReservationId(2);
        reservation7Nights.setReservationNumber("RES-20260304-002");
        reservation7Nights.setCheckInDate(LocalDate.of(2026, 3, 5));
        reservation7Nights.setCheckOutDate(LocalDate.of(2026, 3, 12));
        reservation7Nights.setStatus(Reservation.Status.CONFIRMED);
        reservation7Nights.setRoom(suiteRoom);
        reservation7Nights.setGuest(guest);

        reservation1Night = new Reservation();
        reservation1Night.setReservationId(3);
        reservation1Night.setReservationNumber("RES-20260304-003");
        reservation1Night.setCheckInDate(LocalDate.of(2026, 3, 5));
        reservation1Night.setCheckOutDate(LocalDate.of(2026, 3, 6));
        reservation1Night.setStatus(Reservation.Status.CONFIRMED);
        reservation1Night.setRoom(singleRoom);
        reservation1Night.setGuest(guest);
    }

    // ================================================================
    // STANDARD PRICING STRATEGY TESTS
    // ================================================================

    @Test
    @DisplayName("Given 3-night stay at 75/night, When generateBill with STANDARD, Then total = 247.50")
    void givenStandardPricing_3Nights_whenGenerateBill_thenCorrectTotal() {
        when(reservationDAO.findById(1)).thenReturn(reservation3Nights);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(1, "STANDARD");

        assertNotNull(bill);
        assertEquals(3, bill.getNumNights());
        assertEquals(75.00, bill.getRatePerNight(), 0.01);
        assertEquals(225.00, bill.getSubtotal(), 0.01);
        assertEquals(22.50, bill.getTaxAmount(), 0.01);
        assertEquals(247.50, bill.getTotalAmount(), 0.01);
        assertEquals("STANDARD", bill.getPricingStrategyUsed());
    }

    @Test
    @DisplayName("Given 1-night stay at 75/night, When generateBill with STANDARD, Then total = 82.50")
    void givenStandardPricing_1Night_whenGenerateBill_thenCorrectTotal() {
        when(reservationDAO.findById(3)).thenReturn(reservation1Night);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(3, "STANDARD");

        assertEquals(1, bill.getNumNights());
        assertEquals(75.00, bill.getSubtotal(), 0.01);
        assertEquals(7.50, bill.getTaxAmount(), 0.01);
        assertEquals(82.50, bill.getTotalAmount(), 0.01);
    }

    // ================================================================
    // SEASONAL PRICING STRATEGY TESTS (20% surcharge)
    // ================================================================

    @Test
    @DisplayName("Given 3-night stay at 75/night, When generateBill with SEASONAL, Then total = 297.00")
    void givenSeasonalPricing_3Nights_whenGenerateBill_thenCorrectTotal() {
        when(reservationDAO.findById(1)).thenReturn(reservation3Nights);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(1, "SEASONAL");

        assertNotNull(bill);
        assertEquals(3, bill.getNumNights());
        assertEquals(270.00, bill.getSubtotal(), 0.01);
        assertEquals(27.00, bill.getTaxAmount(), 0.01);
        assertEquals(297.00, bill.getTotalAmount(), 0.01);
        assertEquals("SEASONAL", bill.getPricingStrategyUsed());
    }

    @Test
    @DisplayName("Given 7-night suite stay, When generateBill with SEASONAL, Then correct total applied")
    void givenSeasonalPricing_7NightsSuite_whenGenerateBill_thenCorrectTotal() {
        when(reservationDAO.findById(2)).thenReturn(reservation7Nights);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(2, "SEASONAL");

        assertEquals(7, bill.getNumNights());
        assertEquals(2100.00, bill.getSubtotal(), 0.01);
        assertEquals(210.00, bill.getTaxAmount(), 0.01);
        assertEquals(2310.00, bill.getTotalAmount(), 0.01);
    }

    // ================================================================
    // DISCOUNT PRICING STRATEGY TESTS (10% discount for 7+ nights)
    // ================================================================

    @Test
    @DisplayName("Given 7-night stay, When generateBill with DISCOUNT, Then 10% discount applied")
    void givenDiscountPricing_7Nights_whenGenerateBill_thenDiscountApplied() {
        when(reservationDAO.findById(2)).thenReturn(reservation7Nights);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(2, "DISCOUNT");

        assertEquals(7, bill.getNumNights());
        assertEquals(1575.00, bill.getSubtotal(), 0.01);
        assertEquals(157.50, bill.getTaxAmount(), 0.01);
        assertEquals(1732.50, bill.getTotalAmount(), 0.01);
        assertEquals("DISCOUNT", bill.getPricingStrategyUsed());
    }

    @Test
    @DisplayName("Given 3-night stay, When generateBill with DISCOUNT, Then standard rate applied (no discount)")
    void givenDiscountPricing_3Nights_whenGenerateBill_thenNoDiscount() {
        when(reservationDAO.findById(1)).thenReturn(reservation3Nights);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(1, "DISCOUNT");

        assertEquals(225.00, bill.getSubtotal(), 0.01);
        assertEquals(247.50, bill.getTotalAmount(), 0.01);
    }

    // ================================================================
    // ERROR / EDGE CASE TESTS
    // ================================================================

    @Test
    @DisplayName("Given non-existent reservation, When generateBill, Then throw ReservationNotFoundException")
    void givenNonExistentReservation_whenGenerateBill_thenThrowException() {
        when(reservationDAO.findById(99)).thenReturn(null);

        assertThrows(ReservationNotFoundException.class, () ->
                billingService.generateBill(99, "STANDARD")
        );
    }

    @Test
    @DisplayName("Given invalid strategy name, When generateBill, Then throw IllegalArgumentException")
    void givenInvalidStrategy_whenGenerateBill_thenThrowException() {
        when(reservationDAO.findById(1)).thenReturn(reservation3Nights);

        assertThrows(IllegalArgumentException.class, () ->
                billingService.generateBill(1, "INVALID_STRATEGY")
        );
    }

    @Test
    @DisplayName("Given null strategy, When generateBill, Then throw IllegalArgumentException")
    void givenNullStrategy_whenGenerateBill_thenThrowException() {
        when(reservationDAO.findById(1)).thenReturn(reservation3Nights);

        assertThrows(IllegalArgumentException.class, () ->
                billingService.generateBill(1, null)
        );
    }

    @Test
    @DisplayName("Given reservation with existing bill, When getBill, Then return existing bill")
    void givenExistingBill_whenGetBill_thenReturnBill() {
        Bill existingBill = new Bill(1, 1, 3, 75.00, 225.00, 22.50, 247.50, "STANDARD", LocalDateTime.now());
        when(billDAO.findByReservationId(1)).thenReturn(existingBill);

        Bill result = billingService.getBillByReservationId(1);

        assertNotNull(result);
        assertEquals(247.50, result.getTotalAmount(), 0.01);
        assertEquals("STANDARD", result.getPricingStrategyUsed());
    }

    @Test
    @DisplayName("Given no bill exists, When getBill, Then throw BillNotFoundException")
    void givenNoBill_whenGetBill_thenThrowException() {
        when(billDAO.findByReservationId(99)).thenReturn(null);

        assertThrows(BillNotFoundException.class, () ->
                billingService.getBillByReservationId(99)
        );
    }
}

