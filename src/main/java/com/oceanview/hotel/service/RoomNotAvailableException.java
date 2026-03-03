package com.oceanview.hotel.service;

/**
 * Exception thrown when a requested room is not available for booking.
 */
public class RoomNotAvailableException extends RuntimeException {

    public RoomNotAvailableException(String message) {
        super(message);
    }
}

