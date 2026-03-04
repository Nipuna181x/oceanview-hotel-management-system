package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.BillDAO;
import com.oceanview.hotel.dao.PricingRateDAO;
import com.oceanview.hotel.dao.ReservationDAO;
import com.oceanview.hotel.model.Bill;
import com.oceanview.hotel.model.Guest;
import com.oceanview.hotel.model.PricingRate;
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
 * Tests DB-driven pricing strategies, tax calculation, and edge cases.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("BillingService Tests")
class BillingServiceTest {

    @Mock
    private BillDAO billDAO;

    @Mock
    private ReservationDAO reservationDAO;

    @Mock
    private PricingRateDAO pricingRateDAO;

    @InjectMocks
    private BillingService billingService;

    private Reservation reservation3Nights;
    private Reservation reservation7Nights;
    private Reservation reservation1Night;

    private PricingRate standardStrategy;
    private PricingRate seasonalStrategy;
    private PricingRate discountStrategy;

    @BeforeEach
    void setUp() {
        Room singleRoom = new Room(1, "101", Room.RoomType.SINGLE, 75.00, false);
        Room suiteRoom = new Room(2, "301", Room.RoomType.SUITE, 250.00, false);

        Guest guest = new Guest();
        guest.setGuestId(1);
        guest.setFullName("John Smith");

        reservation3Nights = new Reservation();
        reservation3Nights.setReservationId(1);
        reservation3Nights.setCheckInDate(LocalDate.of(2026, 3, 5));
        reservation3Nights.setCheckOutDate(LocalDate.of(2026, 3, 8));
        reservation3Nights.setStatus(Reservation.Status.CONFIRMED);
        reservation3Nights.setRoom(singleRoom);
        reservation3Nights.setGuest(guest);

        reservation7Nights = new Reservation();
        reservation7Nights.setReservationId(2);
        reservation7Nights.setCheckInDate(LocalDate.of(2026, 3, 5));
        reservation7Nights.setCheckOutDate(LocalDate.of(2026, 3, 12));
        reservation7Nights.setStatus(Reservation.Status.CONFIRMED);
        reservation7Nights.setRoom(suiteRoom);
        reservation7Nights.setGuest(guest);

        reservation1Night = new Reservation();
        reservation1Night.setReservationId(3);
        reservation1Night.setCheckInDate(LocalDate.of(2026, 3, 5));
        reservation1Night.setCheckOutDate(LocalDate.of(2026, 3, 6));
        reservation1Night.setStatus(Reservation.Status.CONFIRMED);
        reservation1Night.setRoom(singleRoom);
        reservation1Night.setGuest(guest);

        // Standard: 0% adjustment
        standardStrategy = new PricingRate();
        standardStrategy.setStrategyId(1);
        standardStrategy.setName("Standard");
        standardStrategy.setAdjustmentType(PricingRate.AdjustmentType.SURCHARGE);
        standardStrategy.setAdjustmentPercent(0);
        standardStrategy.setDefault(true);

        // Seasonal: +20% surcharge
        seasonalStrategy = new PricingRate();
        seasonalStrategy.setStrategyId(2);
        seasonalStrategy.setName("Seasonal");
        seasonalStrategy.setAdjustmentType(PricingRate.AdjustmentType.SURCHARGE);
        seasonalStrategy.setAdjustmentPercent(20);

        // Discount: -10%
        discountStrategy = new PricingRate();
        discountStrategy.setStrategyId(3);
        discountStrategy.setName("Long Stay");
        discountStrategy.setAdjustmentType(PricingRate.AdjustmentType.DISCOUNT);
        discountStrategy.setAdjustmentPercent(10);
    }

    // ================================================================
    // STANDARD PRICING STRATEGY TESTS
    // ================================================================

    @Test
    @DisplayName("Given 3-night stay at 75/night, When generateBill with Standard, Then total = 247.50")
    void givenStandardPricing_3Nights_whenGenerateBill_thenCorrectTotal() {
        when(reservationDAO.findById(1)).thenReturn(reservation3Nights);
        when(pricingRateDAO.findById(1)).thenReturn(standardStrategy);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(1, 1);

        assertNotNull(bill);
        assertEquals(3, bill.getNumNights());
        assertEquals(75.00, bill.getRatePerNight(), 0.01);
        assertEquals(225.00, bill.getSubtotal(), 0.01);
        assertEquals(22.50, bill.getTaxAmount(), 0.01);
        assertEquals(247.50, bill.getTotalAmount(), 0.01);
        assertEquals("Standard", bill.getPricingStrategyUsed());
    }

    @Test
    @DisplayName("Given 1-night stay at 75/night, When generateBill with Standard, Then total = 82.50")
    void givenStandardPricing_1Night_whenGenerateBill_thenCorrectTotal() {
        when(reservationDAO.findById(3)).thenReturn(reservation1Night);
        when(pricingRateDAO.findById(1)).thenReturn(standardStrategy);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(3, 1);

        assertEquals(1, bill.getNumNights());
        assertEquals(75.00, bill.getSubtotal(), 0.01);
        assertEquals(7.50, bill.getTaxAmount(), 0.01);
        assertEquals(82.50, bill.getTotalAmount(), 0.01);
    }

    // ================================================================
    // SEASONAL PRICING STRATEGY TESTS (20% surcharge)
    // ================================================================

    @Test
    @DisplayName("Given 3-night stay at 75/night, When generateBill with Seasonal +20%, Then total = 297.00")
    void givenSeasonalPricing_3Nights_whenGenerateBill_thenCorrectTotal() {
        when(reservationDAO.findById(1)).thenReturn(reservation3Nights);
        when(pricingRateDAO.findById(2)).thenReturn(seasonalStrategy);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(1, 2);

        assertEquals(3, bill.getNumNights());
        assertEquals(270.00, bill.getSubtotal(), 0.01);
        assertEquals(27.00, bill.getTaxAmount(), 0.01);
        assertEquals(297.00, bill.getTotalAmount(), 0.01);
        assertEquals("Seasonal", bill.getPricingStrategyUsed());
    }

    @Test
    @DisplayName("Given 7-night suite stay, When generateBill with Seasonal, Then correct total")
    void givenSeasonalPricing_7NightsSuite_whenGenerateBill_thenCorrectTotal() {
        when(reservationDAO.findById(2)).thenReturn(reservation7Nights);
        when(pricingRateDAO.findById(2)).thenReturn(seasonalStrategy);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(2, 2);

        assertEquals(7, bill.getNumNights());
        assertEquals(2100.00, bill.getSubtotal(), 0.01);
        assertEquals(210.00, bill.getTaxAmount(), 0.01);
        assertEquals(2310.00, bill.getTotalAmount(), 0.01);
    }

    // ================================================================
    // DISCOUNT PRICING STRATEGY TESTS (-10%)
    // ================================================================

    @Test
    @DisplayName("Given 7-night stay, When generateBill with Discount -10%, Then discount applied")
    void givenDiscountPricing_7Nights_whenGenerateBill_thenDiscountApplied() {
        when(reservationDAO.findById(2)).thenReturn(reservation7Nights);
        when(pricingRateDAO.findById(3)).thenReturn(discountStrategy);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(2, 3);

        assertEquals(7, bill.getNumNights());
        assertEquals(1575.00, bill.getSubtotal(), 0.01);
        assertEquals(157.50, bill.getTaxAmount(), 0.01);
        assertEquals(1732.50, bill.getTotalAmount(), 0.01);
        assertEquals("Long Stay", bill.getPricingStrategyUsed());
    }

    @Test
    @DisplayName("Given 3-night stay, When generateBill with Discount -10%, Then discount applied")
    void givenDiscountPricing_3Nights_whenGenerateBill_thenDiscountApplied() {
        when(reservationDAO.findById(1)).thenReturn(reservation3Nights);
        when(pricingRateDAO.findById(3)).thenReturn(discountStrategy);
        when(billDAO.save(any(Bill.class))).thenReturn(1);

        Bill bill = billingService.generateBill(1, 3);

        // 75 * 3 * 0.90 = 202.50
        assertEquals(202.50, bill.getSubtotal(), 0.01);
        assertEquals(222.75, bill.getTotalAmount(), 0.01);
    }

    // ================================================================
    // ERROR / EDGE CASE TESTS
    // ================================================================

    @Test
    @DisplayName("Given non-existent reservation, When generateBill, Then throw ReservationNotFoundException")
    void givenNonExistentReservation_whenGenerateBill_thenThrowException() {
        when(reservationDAO.findById(99)).thenReturn(null);

        assertThrows(ReservationNotFoundException.class, () ->
                billingService.generateBill(99, 1)
        );
    }

    @Test
    @DisplayName("Given invalid strategy ID, When generateBill, Then throw IllegalArgumentException")
    void givenInvalidStrategyId_whenGenerateBill_thenThrowException() {
        when(reservationDAO.findById(1)).thenReturn(reservation3Nights);
        when(pricingRateDAO.findById(999)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                billingService.generateBill(1, 999)
        );
    }

    // ================================================================
    // BILL RETRIEVAL TESTS
    // ================================================================

    @Test
    @DisplayName("Given existing bill, When getBillByReservationId, Then return bill")
    void givenExistingBill_whenGetBill_thenReturnBill() {
        Bill existingBill = new Bill(1, 1, 3, 75.00, 225.00, 22.50, 247.50, "Standard", LocalDateTime.now());
        when(billDAO.findByReservationId(1)).thenReturn(existingBill);

        Bill result = billingService.getBillByReservationId(1);

        assertNotNull(result);
        assertEquals(247.50, result.getTotalAmount(), 0.01);
    }

    @Test
    @DisplayName("Given no bill exists, When getBillByReservationId, Then throw BillNotFoundException")
    void givenNoBill_whenGetBill_thenThrowException() {
        when(billDAO.findByReservationId(99)).thenReturn(null);

        assertThrows(BillNotFoundException.class, () ->
                billingService.getBillByReservationId(99)
        );
    }

    @Test
    @DisplayName("Given bills exist, When getAllBills, Then return list")
    void givenBillsExist_whenGetAllBills_thenReturnList() {
        Bill bill1 = new Bill(1, 1, 3, 75.00, 225.00, 22.50, 247.50, "Standard", LocalDateTime.now());
        Bill bill2 = new Bill(2, 2, 7, 250.00, 1750.00, 175.00, 1925.00, "Seasonal", LocalDateTime.now());
        when(billDAO.findAll()).thenReturn(java.util.Arrays.asList(bill1, bill2));

        java.util.List<Bill> result = billingService.getAllBills();

        assertNotNull(result);
        assertEquals(2, result.size());
    }

    @Test
    @DisplayName("Given valid bill ID, When getBillById, Then return bill")
    void givenValidBillId_whenGetBillById_thenReturnBill() {
        Bill bill = new Bill(1, 1, 3, 75.00, 225.00, 22.50, 247.50, "Standard", LocalDateTime.now());
        when(billDAO.findById(1)).thenReturn(bill);

        Bill result = billingService.getBillById(1);

        assertNotNull(result);
        assertEquals(1, result.getBillId());
    }

    @Test
    @DisplayName("Given invalid bill ID, When getBillById, Then throw BillNotFoundException")
    void givenInvalidBillId_whenGetBillById_thenThrowException() {
        when(billDAO.findById(99)).thenReturn(null);

        assertThrows(BillNotFoundException.class, () ->
                billingService.getBillById(99)
        );
    }
}

