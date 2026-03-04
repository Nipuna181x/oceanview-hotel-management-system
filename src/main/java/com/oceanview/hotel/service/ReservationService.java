package com.oceanview.hotel.service;

import com.oceanview.hotel.builder.ReservationBuilder;
import com.oceanview.hotel.dao.ReservationDAO;
import com.oceanview.hotel.dao.RoomDAO;
import com.oceanview.hotel.model.Guest;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.Room;
import com.oceanview.hotel.util.ReservationValidator;

import java.time.LocalDate;
import java.util.List;

/**
 * Service class encapsulating all reservation business logic.
 *
 * Design Patterns:
 * - Service Layer / Facade: single entry point for all reservation operations
 * - Builder: uses ReservationBuilder to construct Reservation objects
 * - DAO: delegates persistence to ReservationDAO and RoomDAO interfaces
 */
public class ReservationService {

    private final ReservationDAO reservationDAO;
    private final RoomDAO roomDAO;
    private final ReservationValidator validator;

    public ReservationService(ReservationDAO reservationDAO, RoomDAO roomDAO) {
        this.reservationDAO = reservationDAO;
        this.roomDAO = roomDAO;
        this.validator = new ReservationValidator();
    }

    /**
     * Create a new reservation after validating all inputs and checking room availability.
     *
     * @return the generated reservation number (e.g. RES-20260304-001)
     * @throws IllegalArgumentException   if any input is invalid
     * @throws RoomNotAvailableException  if the room is not available
     */
    public String createReservation(String guestName, String address, String contactNumber,
                                    String email, String nic, int numGuests, int roomId,
                                    LocalDate checkIn, LocalDate checkOut, int createdBy) {
        // Step 1: Validate all inputs
        validator.validateAll(guestName, address, contactNumber, checkIn, checkOut);

        if (numGuests <= 0) {
            throw new IllegalArgumentException("Number of guests must be at least 1");
        }

        // Step 2: Check room exists
        Room room = roomDAO.findById(roomId);
        if (room == null) {
            throw new IllegalArgumentException("Room with ID " + roomId + " does not exist");
        }

        // Step 3: Check room availability
        if (!room.isAvailable()) {
            throw new RoomNotAvailableException(
                    "Room " + room.getRoomNumber() + " is not available for the requested dates");
        }

        // Step 4: Validate numGuests against max occupancy
        if (numGuests > room.getMaxOccupancy()) {
            throw new IllegalArgumentException(
                    "Number of guests (" + numGuests + ") exceeds room max occupancy (" + room.getMaxOccupancy() + ")");
        }

        // Step 5: Build reservation and guest objects (Builder pattern)
        Reservation reservation = new ReservationBuilder()
                .roomId(roomId)
                .checkIn(checkIn)
                .checkOut(checkOut)
                .createdBy(createdBy)
                .status(Reservation.Status.CONFIRMED)
                .build();
        reservation.setNumGuests(numGuests);

        Guest guest = new Guest();
        guest.setFullName(guestName);
        guest.setAddress(address);
        guest.setContactNumber(contactNumber);
        guest.setEmail(email);
        guest.setNic(nic);

        // Step 6: Persist via DAO (calls sp_create_reservation stored procedure)
        return reservationDAO.save(reservation, guest);
    }

    /**
     * Get a reservation by its reservation number.
     *
     * @throws IllegalArgumentException      if reservationNumber is null/empty
     * @throws ReservationNotFoundException  if no reservation found
     */
    public Reservation getByReservationNumber(String reservationNumber) {
        if (reservationNumber == null || reservationNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Reservation number cannot be null or empty");
        }
        Reservation reservation = reservationDAO.findByReservationNumber(reservationNumber);
        if (reservation == null) {
            throw new ReservationNotFoundException(
                    "Reservation not found: " + reservationNumber);
        }
        return reservation;
    }

    /**
     * Get a reservation by its ID.
     *
     * @throws ReservationNotFoundException if no reservation found
     */
    public Reservation getById(int reservationId) {
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException(
                    "Reservation not found with ID: " + reservationId);
        }
        return reservation;
    }

    /**
     * Get all reservations.
     */
    public List<Reservation> getAllReservations() {
        return reservationDAO.findAll();
    }

    /**
     * Cancel a reservation.
     *
     * @throws ReservationNotFoundException if reservation doesn't exist
     * @throws IllegalStateException        if reservation cannot be cancelled
     */
    public void cancelReservation(int reservationId) {
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException(
                    "Reservation not found with ID: " + reservationId);
        }
        if (reservation.getStatus() == Reservation.Status.CANCELLED) {
            throw new IllegalStateException("Reservation is already cancelled");
        }
        if (reservation.getStatus() == Reservation.Status.CHECKED_OUT) {
            throw new IllegalStateException("Cannot cancel a reservation that has already checked out");
        }
        reservationDAO.updateStatus(reservationId, Reservation.Status.CANCELLED);
    }

    /**
     * Check in a guest.
     *
     * @throws IllegalStateException if reservation is not in CONFIRMED status
     */
    public void checkIn(int reservationId) {
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException(
                    "Reservation not found with ID: " + reservationId);
        }
        if (reservation.getStatus() != Reservation.Status.CONFIRMED) {
            throw new IllegalStateException(
                    "Only CONFIRMED reservations can be checked in");
        }
        reservationDAO.updateStatus(reservationId, Reservation.Status.CHECKED_IN);
    }

    /**
     * Check out a guest.
     *
     * @throws IllegalStateException if reservation is not in CHECKED_IN status
     */
    public void checkOut(int reservationId) {
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException(
                    "Reservation not found with ID: " + reservationId);
        }
        if (reservation.getStatus() != Reservation.Status.CHECKED_IN) {
            throw new IllegalStateException(
                    "Only CHECKED_IN reservations can be checked out");
        }
        reservationDAO.updateStatus(reservationId, Reservation.Status.CHECKED_OUT);
    }
}

