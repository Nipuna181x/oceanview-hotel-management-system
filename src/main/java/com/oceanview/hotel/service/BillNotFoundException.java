package com.oceanview.hotel.service;

/**
 * Exception thrown when a bill is not found for a reservation.
 */
public class BillNotFoundException extends RuntimeException {

    public BillNotFoundException(String message) {
        super(message);
    }
}

