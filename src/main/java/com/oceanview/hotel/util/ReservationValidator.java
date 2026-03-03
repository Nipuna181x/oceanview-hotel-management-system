package com.oceanview.hotel.util;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * Validates all reservation input fields.
 *
 * Design Pattern: Utility class — centralises all validation logic so it
 * can be reused by both the Service layer and REST resources.
 */
public class ReservationValidator {

    private static final int MIN_NAME_LENGTH = 3;
    private static final int MAX_NAME_LENGTH = 100;
    private static final int MAX_STAY_NIGHTS = 30;
    private static final String CONTACT_REGEX = "^[+]?[0-9]{7,15}$";

    /**
     * Validate guest full name.
     */
    public void validateGuestName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Guest name cannot be null or empty");
        }
        if (name.trim().length() < MIN_NAME_LENGTH) {
            throw new IllegalArgumentException("Guest name must be at least " + MIN_NAME_LENGTH + " characters");
        }
        if (name.trim().length() > MAX_NAME_LENGTH) {
            throw new IllegalArgumentException("Guest name cannot exceed " + MAX_NAME_LENGTH + " characters");
        }
    }

    /**
     * Validate contact number — digits only, 7-15 chars, optional leading +.
     */
    public void validateContactNumber(String contactNumber) {
        if (contactNumber == null || contactNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Contact number cannot be null or empty");
        }
        if (!contactNumber.matches(CONTACT_REGEX)) {
            throw new IllegalArgumentException(
                    "Contact number must be 7-15 digits, optionally starting with '+'");
        }
    }

    /**
     * Validate address.
     */
    public void validateAddress(String address) {
        if (address == null || address.trim().isEmpty()) {
            throw new IllegalArgumentException("Address cannot be null or empty");
        }
    }

    /**
     * Validate check-in and check-out dates.
     * Rules:
     *   - Neither date can be null
     *   - Check-in cannot be in the past
     *   - Check-out must be after check-in
     *   - Stay cannot exceed MAX_STAY_NIGHTS
     */
    public void validateDates(LocalDate checkIn, LocalDate checkOut) {
        if (checkIn == null) {
            throw new IllegalArgumentException("Check-in date cannot be null");
        }
        if (checkOut == null) {
            throw new IllegalArgumentException("Check-out date cannot be null");
        }
        if (checkIn.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Check-in date cannot be in the past");
        }
        if (!checkOut.isAfter(checkIn)) {
            throw new IllegalArgumentException("Check-out date must be after check-in date");
        }
        long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
        if (nights > MAX_STAY_NIGHTS) {
            throw new IllegalArgumentException(
                    "Stay cannot exceed " + MAX_STAY_NIGHTS + " nights");
        }
    }

    /**
     * Run all validations together.
     */
    public void validateAll(String guestName, String address, String contactNumber,
                            LocalDate checkIn, LocalDate checkOut) {
        validateGuestName(guestName);
        validateAddress(address);
        validateContactNumber(contactNumber);
        validateDates(checkIn, checkOut);
    }
}

