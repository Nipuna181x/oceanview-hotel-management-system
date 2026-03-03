package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.Guest;
import com.oceanview.hotel.model.Reservation;

import java.util.List;

/**
 * DAO interface for Reservation data access operations.
 * DAO Pattern — abstracts all reservation persistence behind an interface.
 */
public interface ReservationDAO {

    /**
     * Save a new reservation and guest (calls sp_create_reservation).
     * @return the generated reservation number
     */
    String save(Reservation reservation, Guest guest);

    /**
     * Find a reservation by its unique reservation number.
     */
    Reservation findByReservationNumber(String reservationNumber);

    /**
     * Find a reservation by its ID.
     */
    Reservation findById(int reservationId);

    /**
     * Get all reservations.
     */
    List<Reservation> findAll();

    /**
     * Update the status of a reservation.
     */
    boolean updateStatus(int reservationId, Reservation.Status status);
}

