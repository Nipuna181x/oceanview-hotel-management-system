package com.oceanview.hotel.service;

/**
 * Exception thrown when login credentials are invalid.
 * Used by AuthService to signal authentication failure.
 */
public class InvalidCredentialsException extends RuntimeException {

    public InvalidCredentialsException(String message) {
        super(message);
    }

    public InvalidCredentialsException(String message, Throwable cause) {
        super(message, cause);
    }
}

