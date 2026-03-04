package com.oceanview.hotel.builder;

import com.oceanview.hotel.model.Reservation;

import java.time.LocalDate;
import java.time.LocalDateTime;

// Fluent builder for Reservation — avoids long constructor calls
public class ReservationBuilder {

    private int reservationId;
    private String reservationNumber;
    private int guestId;
    private int roomId;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private Reservation.Status status = Reservation.Status.CONFIRMED;
    private int createdBy;
    private LocalDateTime createdAt = LocalDateTime.now();

    public ReservationBuilder reservationId(int reservationId) { this.reservationId = reservationId; return this; }
    public ReservationBuilder reservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; return this; }
    public ReservationBuilder guestId(int guestId) { this.guestId = guestId; return this; }
    public ReservationBuilder roomId(int roomId) { this.roomId = roomId; return this; }
    public ReservationBuilder checkIn(LocalDate checkInDate) { this.checkInDate = checkInDate; return this; }
    public ReservationBuilder checkOut(LocalDate checkOutDate) { this.checkOutDate = checkOutDate; return this; }
    public ReservationBuilder status(Reservation.Status status) { this.status = status; return this; }
    public ReservationBuilder createdBy(int createdBy) { this.createdBy = createdBy; return this; }
    public ReservationBuilder createdAt(LocalDateTime createdAt) { this.createdAt = createdAt; return this; }

    public Reservation build() {
        if (roomId <= 0) throw new IllegalStateException("Room ID is required");
        if (checkInDate == null) throw new IllegalStateException("Check-in date is required");
        if (checkOutDate == null) throw new IllegalStateException("Check-out date is required");
        if (createdBy <= 0) throw new IllegalStateException("Created-by user ID is required");

        return new Reservation(reservationId, reservationNumber, guestId, roomId,
                checkInDate, checkOutDate, status, createdBy, createdAt);
    }
}
