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

// All reservation business logic lives here
public class ReservationService {

    private final ReservationDAO reservationDAO;
    private final RoomDAO roomDAO;
    private final ReservationValidator validator;

    public ReservationService(ReservationDAO reservationDAO, RoomDAO roomDAO) {
        this.reservationDAO = reservationDAO;
        this.roomDAO = roomDAO;
        this.validator = new ReservationValidator();
    }

    // Validates inputs, checks room availability, then saves via DAO
    public String createReservation(String guestName, String address, String contactNumber,
                                    String email, String nic, int numGuests, int roomId,
                                    LocalDate checkIn, LocalDate checkOut, int createdBy) {
        validator.validateAll(guestName, address, contactNumber, checkIn, checkOut);

        if (numGuests <= 0) {
            throw new IllegalArgumentException("Number of guests must be at least 1");
        }

        Room room = roomDAO.findById(roomId);
        if (room == null) {
            throw new IllegalArgumentException("Room with ID " + roomId + " does not exist");
        }

        if (!room.isAvailable()) {
            throw new RoomNotAvailableException(
                    "Room " + room.getRoomNumber() + " is not available for the requested dates");
        }

        if (numGuests > room.getMaxOccupancy()) {
            throw new IllegalArgumentException(
                    "Number of guests (" + numGuests + ") exceeds room max occupancy (" + room.getMaxOccupancy() + ")");
        }

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

        return reservationDAO.save(reservation, guest);
    }

    public Reservation getByReservationNumber(String reservationNumber) {
        if (reservationNumber == null || reservationNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Reservation number cannot be null or empty");
        }
        Reservation reservation = reservationDAO.findByReservationNumber(reservationNumber);
        if (reservation == null) {
            throw new ReservationNotFoundException("Reservation not found: " + reservationNumber);
        }
        return reservation;
    }

    public Reservation getById(int reservationId) {
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException("Reservation not found with ID: " + reservationId);
        }
        return reservation;
    }

    public List<Reservation> getAllReservations() {
        return reservationDAO.findAll();
    }

    public void cancelReservation(int reservationId) {
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException("Reservation not found with ID: " + reservationId);
        }
        if (reservation.getStatus() == Reservation.Status.CANCELLED) {
            throw new IllegalStateException("Reservation is already cancelled");
        }
        if (reservation.getStatus() == Reservation.Status.CHECKED_OUT) {
            throw new IllegalStateException("Cannot cancel a reservation that has already checked out");
        }
        reservationDAO.updateStatus(reservationId, Reservation.Status.CANCELLED);
    }

    public void checkIn(int reservationId) {
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException("Reservation not found with ID: " + reservationId);
        }
        if (reservation.getStatus() != Reservation.Status.CONFIRMED) {
            throw new IllegalStateException("Only CONFIRMED reservations can be checked in");
        }
        reservationDAO.updateStatus(reservationId, Reservation.Status.CHECKED_IN);
    }

    public void checkOut(int reservationId) {
        Reservation reservation = reservationDAO.findById(reservationId);
        if (reservation == null) {
            throw new ReservationNotFoundException("Reservation not found with ID: " + reservationId);
        }
        if (reservation.getStatus() != Reservation.Status.CHECKED_IN) {
            throw new IllegalStateException("Only CHECKED_IN reservations can be checked out");
        }
        reservationDAO.updateStatus(reservationId, Reservation.Status.CHECKED_OUT);
    }
}
