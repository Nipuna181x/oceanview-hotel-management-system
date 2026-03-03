package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.ReservationDAO;
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
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * TDD Test class for ReportService.
 * Tests occupancy reports, revenue reports, and date range filtering.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("ReportService Tests")
class ReportServiceTest {

    @Mock
    private ReservationDAO reservationDAO;

    @InjectMocks
    private ReportService reportService;

    private Reservation res1;
    private Reservation res2;
    private Reservation res3Cancelled;

    @BeforeEach
    void setUp() {
        Room singleRoom = new Room(1, "101", Room.RoomType.SINGLE, 75.00, false);
        Room suiteRoom  = new Room(2, "301", Room.RoomType.SUITE,  250.00, false);

        Guest guest1 = new Guest();
        guest1.setFullName("John Smith");
        guest1.setContactNumber("0771234567");

        Guest guest2 = new Guest();
        guest2.setFullName("Jane Doe");
        guest2.setContactNumber("0779876543");

        res1 = new Reservation();
        res1.setReservationId(1);
        res1.setReservationNumber("RES-20260304-001");
        res1.setCheckInDate(LocalDate.of(2026, 3, 1));
        res1.setCheckOutDate(LocalDate.of(2026, 3, 4));
        res1.setStatus(Reservation.Status.CHECKED_OUT);
        res1.setRoom(singleRoom);
        res1.setGuest(guest1);
        res1.setCreatedAt(LocalDateTime.of(2026, 3, 1, 10, 0));

        res2 = new Reservation();
        res2.setReservationId(2);
        res2.setReservationNumber("RES-20260304-002");
        res2.setCheckInDate(LocalDate.of(2026, 3, 5));
        res2.setCheckOutDate(LocalDate.of(2026, 3, 12));
        res2.setStatus(Reservation.Status.CONFIRMED);
        res2.setRoom(suiteRoom);
        res2.setGuest(guest2);
        res2.setCreatedAt(LocalDateTime.of(2026, 3, 2, 14, 0));

        res3Cancelled = new Reservation();
        res3Cancelled.setReservationId(3);
        res3Cancelled.setReservationNumber("RES-20260304-003");
        res3Cancelled.setCheckInDate(LocalDate.of(2026, 3, 10));
        res3Cancelled.setCheckOutDate(LocalDate.of(2026, 3, 12));
        res3Cancelled.setStatus(Reservation.Status.CANCELLED);
        res3Cancelled.setRoom(singleRoom);
        res3Cancelled.setGuest(guest1);
        res3Cancelled.setCreatedAt(LocalDateTime.of(2026, 3, 3, 9, 0));
    }

    // ================================================================
    // OCCUPANCY REPORT TESTS
    // ================================================================

    @Test
    @DisplayName("Given reservations in range, When getOccupancyReport is called, Then return all reservations")
    void givenReservationsInRange_whenGetOccupancyReport_thenReturnAll() {
        when(reservationDAO.findAll()).thenReturn(Arrays.asList(res1, res2, res3Cancelled));

        List<Reservation> result = reportService.getOccupancyReport(
                LocalDate.of(2026, 3, 1), LocalDate.of(2026, 3, 31));

        assertNotNull(result);
        assertEquals(3, result.size());
    }

    @Test
    @DisplayName("Given no reservations, When getOccupancyReport is called, Then return empty list")
    void givenNoReservations_whenGetOccupancyReport_thenReturnEmptyList() {
        when(reservationDAO.findAll()).thenReturn(Collections.emptyList());

        List<Reservation> result = reportService.getOccupancyReport(
                LocalDate.of(2026, 3, 1), LocalDate.of(2026, 3, 31));

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("Given null start date, When getOccupancyReport is called, Then throw IllegalArgumentException")
    void givenNullStartDate_whenGetOccupancyReport_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                reportService.getOccupancyReport(null, LocalDate.of(2026, 3, 31))
        );
    }

    @Test
    @DisplayName("Given null end date, When getOccupancyReport is called, Then throw IllegalArgumentException")
    void givenNullEndDate_whenGetOccupancyReport_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                reportService.getOccupancyReport(LocalDate.of(2026, 3, 1), null)
        );
    }

    @Test
    @DisplayName("Given end date before start date, When getOccupancyReport is called, Then throw IllegalArgumentException")
    void givenEndBeforeStart_whenGetOccupancyReport_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                reportService.getOccupancyReport(
                        LocalDate.of(2026, 3, 31), LocalDate.of(2026, 3, 1))
        );
    }

    // ================================================================
    // ACTIVE RESERVATIONS ONLY
    // ================================================================

    @Test
    @DisplayName("Given mixed reservations, When getActiveReservations is called, Then exclude CANCELLED")
    void givenMixedReservations_whenGetActiveReservations_thenExcludeCancelled() {
        when(reservationDAO.findAll()).thenReturn(Arrays.asList(res1, res2, res3Cancelled));

        List<Reservation> result = reportService.getActiveReservations();

        assertNotNull(result);
        assertEquals(2, result.size());
        assertTrue(result.stream().noneMatch(r -> r.getStatus() == Reservation.Status.CANCELLED));
    }

    // ================================================================
    // REVENUE SUMMARY TESTS
    // ================================================================

    @Test
    @DisplayName("Given reservations, When getRevenueSummary is called, Then return summary map with correct keys")
    void givenReservations_whenGetRevenueSummary_thenReturnSummaryMap() {
        when(reservationDAO.findAll()).thenReturn(Arrays.asList(res1, res2, res3Cancelled));

        Map<String, Object> summary = reportService.getRevenueSummary(
                LocalDate.of(2026, 3, 1), LocalDate.of(2026, 3, 31));

        assertNotNull(summary);
        assertTrue(summary.containsKey("totalReservations"));
        assertTrue(summary.containsKey("confirmedCount"));
        assertTrue(summary.containsKey("cancelledCount"));
        assertTrue(summary.containsKey("checkedOutCount"));
    }

    @Test
    @DisplayName("Given 3 reservations (1 cancelled, 1 confirmed, 1 checked-out), When getRevenueSummary, Then counts correct")
    void givenMixedReservations_whenGetRevenueSummary_thenCountsCorrect() {
        when(reservationDAO.findAll()).thenReturn(Arrays.asList(res1, res2, res3Cancelled));

        Map<String, Object> summary = reportService.getRevenueSummary(
                LocalDate.of(2026, 3, 1), LocalDate.of(2026, 3, 31));

        assertEquals(3, summary.get("totalReservations"));
        assertEquals(1, summary.get("cancelledCount"));
        assertEquals(1, summary.get("confirmedCount"));
        assertEquals(1, summary.get("checkedOutCount"));
    }

    // ================================================================
    // RESERVATIONS BY STATUS
    // ================================================================

    @Test
    @DisplayName("Given reservations, When getReservationsByStatus CANCELLED, Then return only cancelled")
    void givenReservations_whenGetByStatusCancelled_thenReturnOnlyCancelled() {
        when(reservationDAO.findAll()).thenReturn(Arrays.asList(res1, res2, res3Cancelled));

        List<Reservation> result = reportService.getReservationsByStatus(Reservation.Status.CANCELLED);

        assertEquals(1, result.size());
        assertEquals(Reservation.Status.CANCELLED, result.get(0).getStatus());
    }

    @Test
    @DisplayName("Given null status, When getReservationsByStatus is called, Then throw IllegalArgumentException")
    void givenNullStatus_whenGetReservationsByStatus_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                reportService.getReservationsByStatus(null)
        );
    }
}

