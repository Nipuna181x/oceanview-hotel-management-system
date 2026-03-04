package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.ReservationDAO;
import com.oceanview.hotel.dao.RoomDAO;
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
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * TDD Test class for ReservationService.
 * Follows Given/When/Then naming convention.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("ReservationService Tests")
class ReservationServiceTest {

    @Mock
    private ReservationDAO reservationDAO;

    @Mock
    private RoomDAO roomDAO;

    @InjectMocks
    private ReservationService reservationService;

    private Room availableRoom;
    private Room unavailableRoom;
    private Guest guest;
    private Reservation confirmedReservation;

    @BeforeEach
    void setUp() {
        availableRoom = new Room(1, "101", Room.RoomType.SINGLE, 75.00, true);
        unavailableRoom = new Room(2, "201", Room.RoomType.DOUBLE, 120.00, false);

        guest = new Guest();
        guest.setGuestId(1);
        guest.setFullName("John Smith");
        guest.setAddress("123 Beach Road, Galle");
        guest.setContactNumber("0771234567");
        guest.setEmail("john@email.com");

        confirmedReservation = new Reservation();
        confirmedReservation.setReservationId(1);
        confirmedReservation.setReservationNumber("RES-20260304-001");
        confirmedReservation.setGuestId(1);
        confirmedReservation.setRoomId(1);
        confirmedReservation.setCheckInDate(LocalDate.now().plusDays(1));
        confirmedReservation.setCheckOutDate(LocalDate.now().plusDays(4));
        confirmedReservation.setStatus(Reservation.Status.CONFIRMED);
        confirmedReservation.setCreatedBy(1);
        confirmedReservation.setCreatedAt(LocalDateTime.now());
        confirmedReservation.setGuest(guest);
        confirmedReservation.setRoom(availableRoom);
    }

    // ================================================================
    // CREATE RESERVATION TESTS
    // ================================================================

    @Test
    @DisplayName("Given valid reservation data, When createReservation is called, Then return reservation number")
    void givenValidData_whenCreateReservation_thenReturnReservationNumber() {
        // Arrange
        when(roomDAO.findById(1)).thenReturn(availableRoom);
        when(reservationDAO.save(any(Reservation.class), any(Guest.class))).thenReturn("RES-20260304-001");

        // Act
        String resNumber = reservationService.createReservation(
                "John Smith", "123 Beach Road", "0771234567", "john@email.com",
                "NIC123456", 2,
                1, LocalDate.now().plusDays(1), LocalDate.now().plusDays(4), 1
        );

        // Assert
        assertNotNull(resNumber);
        assertTrue(resNumber.startsWith("RES-"));
        verify(reservationDAO, times(1)).save(any(Reservation.class), any(Guest.class));
    }

    @Test
    @DisplayName("Given unavailable room, When createReservation is called, Then throw RoomNotAvailableException")
    void givenUnavailableRoom_whenCreateReservation_thenThrowException() {
        // Arrange
        when(roomDAO.findById(2)).thenReturn(unavailableRoom);

        // Act & Assert
        assertThrows(RoomNotAvailableException.class, () ->
                reservationService.createReservation(
                        "John Smith", "123 Beach Road", "0771234567", "john@email.com",
                        "NIC123456", 2,
                        2, LocalDate.now().plusDays(1), LocalDate.now().plusDays(4), 1
                )
        );
        verify(reservationDAO, never()).save(any(), any());
    }

    @Test
    @DisplayName("Given non-existent room, When createReservation is called, Then throw IllegalArgumentException")
    void givenNonExistentRoom_whenCreateReservation_thenThrowException() {
        // Arrange
        when(roomDAO.findById(99)).thenReturn(null);

        // Act & Assert
        assertThrows(IllegalArgumentException.class, () ->
                reservationService.createReservation(
                        "John Smith", "123 Beach Road", "0771234567", "john@email.com",
                        "NIC123456", 2,
                        99, LocalDate.now().plusDays(1), LocalDate.now().plusDays(4), 1
                )
        );
    }

    @Test
    @DisplayName("Given null guest name, When createReservation is called, Then throw IllegalArgumentException")
    void givenNullGuestName_whenCreateReservation_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                reservationService.createReservation(
                        null, "123 Beach Road", "0771234567", "john@email.com",
                        "NIC123456", 2,
                        1, LocalDate.now().plusDays(1), LocalDate.now().plusDays(4), 1
                )
        );
    }

    // ================================================================
    // GET RESERVATION TESTS
    // ================================================================

    @Test
    @DisplayName("Given valid reservation number, When getByReservationNumber is called, Then return Reservation")
    void givenValidResNumber_whenGetByReservationNumber_thenReturnReservation() {
        // Arrange
        when(reservationDAO.findByReservationNumber("RES-20260304-001")).thenReturn(confirmedReservation);

        // Act
        Reservation result = reservationService.getByReservationNumber("RES-20260304-001");

        // Assert
        assertNotNull(result);
        assertEquals("RES-20260304-001", result.getReservationNumber());
        assertEquals("John Smith", result.getGuest().getFullName());
    }

    @Test
    @DisplayName("Given invalid reservation number, When getByReservationNumber is called, Then throw ReservationNotFoundException")
    void givenInvalidResNumber_whenGetByReservationNumber_thenThrowException() {
        // Arrange
        when(reservationDAO.findByReservationNumber("RES-INVALID")).thenReturn(null);

        // Act & Assert
        assertThrows(ReservationNotFoundException.class, () ->
                reservationService.getByReservationNumber("RES-INVALID")
        );
    }

    @Test
    @DisplayName("Given null reservation number, When getByReservationNumber is called, Then throw IllegalArgumentException")
    void givenNullResNumber_whenGetByReservationNumber_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                reservationService.getByReservationNumber(null)
        );
    }

    // ================================================================
    // GET ALL RESERVATIONS TESTS
    // ================================================================

    @Test
    @DisplayName("Given reservations exist, When getAllReservations is called, Then return list")
    void givenReservationsExist_whenGetAll_thenReturnList() {
        // Arrange
        when(reservationDAO.findAll()).thenReturn(Arrays.asList(confirmedReservation));

        // Act
        List<Reservation> result = reservationService.getAllReservations();

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
    }

    // ================================================================
    // CANCEL RESERVATION TESTS
    // ================================================================

    @Test
    @DisplayName("Given confirmed reservation, When cancelReservation is called, Then status becomes CANCELLED")
    void givenConfirmedReservation_whenCancel_thenStatusCancelled() {
        // Arrange
        when(reservationDAO.findById(1)).thenReturn(confirmedReservation);
        when(reservationDAO.updateStatus(1, Reservation.Status.CANCELLED)).thenReturn(true);

        // Act
        reservationService.cancelReservation(1);

        // Assert
        verify(reservationDAO, times(1)).updateStatus(1, Reservation.Status.CANCELLED);
    }

    @Test
    @DisplayName("Given already cancelled reservation, When cancelReservation is called, Then throw IllegalStateException")
    void givenCancelledReservation_whenCancelAgain_thenThrowException() {
        // Arrange
        confirmedReservation.setStatus(Reservation.Status.CANCELLED);
        when(reservationDAO.findById(1)).thenReturn(confirmedReservation);

        // Act & Assert
        assertThrows(IllegalStateException.class, () ->
                reservationService.cancelReservation(1)
        );
    }

    @Test
    @DisplayName("Given checked-out reservation, When cancelReservation is called, Then throw IllegalStateException")
    void givenCheckedOutReservation_whenCancel_thenThrowException() {
        // Arrange
        confirmedReservation.setStatus(Reservation.Status.CHECKED_OUT);
        when(reservationDAO.findById(1)).thenReturn(confirmedReservation);

        // Act & Assert
        assertThrows(IllegalStateException.class, () ->
                reservationService.cancelReservation(1)
        );
    }

    // ================================================================
    // CHECKOUT TESTS
    // ================================================================

    @Test
    @DisplayName("Given CHECKED_IN reservation, When checkOut is called, Then status becomes CHECKED_OUT")
    void givenCheckedInReservation_whenCheckOut_thenStatusCheckedOut() {
        // Arrange
        confirmedReservation.setStatus(Reservation.Status.CHECKED_IN);
        when(reservationDAO.findById(1)).thenReturn(confirmedReservation);
        when(reservationDAO.updateStatus(1, Reservation.Status.CHECKED_OUT)).thenReturn(true);

        // Act
        reservationService.checkOut(1);

        // Assert
        verify(reservationDAO, times(1)).updateStatus(1, Reservation.Status.CHECKED_OUT);
    }
}

