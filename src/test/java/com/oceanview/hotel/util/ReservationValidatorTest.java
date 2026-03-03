package com.oceanview.hotel.util;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

/**
 * TDD Test class for ReservationValidator.
 * Tests all validation rules for reservation input data.
 */
@DisplayName("ReservationValidator Tests")
class ReservationValidatorTest {

    private ReservationValidator validator;

    @BeforeEach
    void setUp() {
        validator = new ReservationValidator();
    }

    // ================================================================
    // GUEST NAME VALIDATION
    // ================================================================

    @Test
    @DisplayName("Given valid guest name, When validateGuestName, Then no exception")
    void givenValidGuestName_whenValidate_thenNoException() {
        assertDoesNotThrow(() -> validator.validateGuestName("John Smith"));
    }

    @Test
    @DisplayName("Given null guest name, When validateGuestName, Then throw IllegalArgumentException")
    void givenNullGuestName_whenValidate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateGuestName(null));
    }

    @Test
    @DisplayName("Given empty guest name, When validateGuestName, Then throw IllegalArgumentException")
    void givenEmptyGuestName_whenValidate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateGuestName(""));
    }

    @Test
    @DisplayName("Given guest name too short, When validateGuestName, Then throw IllegalArgumentException")
    void givenTooShortGuestName_whenValidate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateGuestName("Jo"));
    }

    @Test
    @DisplayName("Given guest name too long, When validateGuestName, Then throw IllegalArgumentException")
    void givenTooLongGuestName_whenValidate_thenThrowException() {
        String longName = "A".repeat(101);
        assertThrows(IllegalArgumentException.class, () -> validator.validateGuestName(longName));
    }

    // ================================================================
    // CONTACT NUMBER VALIDATION
    // ================================================================

    @Test
    @DisplayName("Given valid contact number, When validateContactNumber, Then no exception")
    void givenValidContactNumber_whenValidate_thenNoException() {
        assertDoesNotThrow(() -> validator.validateContactNumber("0771234567"));
    }

    @Test
    @DisplayName("Given valid international contact number, When validateContactNumber, Then no exception")
    void givenValidInternationalNumber_whenValidate_thenNoException() {
        assertDoesNotThrow(() -> validator.validateContactNumber("+94771234567"));
    }

    @Test
    @DisplayName("Given null contact number, When validateContactNumber, Then throw IllegalArgumentException")
    void givenNullContactNumber_whenValidate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateContactNumber(null));
    }

    @Test
    @DisplayName("Given contact number with letters, When validateContactNumber, Then throw IllegalArgumentException")
    void givenContactNumberWithLetters_whenValidate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateContactNumber("077ABC4567"));
    }

    @Test
    @DisplayName("Given too short contact number, When validateContactNumber, Then throw IllegalArgumentException")
    void givenTooShortContactNumber_whenValidate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateContactNumber("12345"));
    }

    // ================================================================
    // DATE VALIDATION
    // ================================================================

    @Test
    @DisplayName("Given valid future dates, When validateDates, Then no exception")
    void givenValidFutureDates_whenValidateDates_thenNoException() {
        LocalDate checkIn = LocalDate.now().plusDays(1);
        LocalDate checkOut = LocalDate.now().plusDays(4);
        assertDoesNotThrow(() -> validator.validateDates(checkIn, checkOut));
    }

    @Test
    @DisplayName("Given check-in in the past, When validateDates, Then throw IllegalArgumentException")
    void givenPastCheckIn_whenValidateDates_thenThrowException() {
        LocalDate checkIn = LocalDate.now().minusDays(1);
        LocalDate checkOut = LocalDate.now().plusDays(4);
        assertThrows(IllegalArgumentException.class, () -> validator.validateDates(checkIn, checkOut));
    }

    @Test
    @DisplayName("Given check-out before check-in, When validateDates, Then throw IllegalArgumentException")
    void givenCheckOutBeforeCheckIn_whenValidateDates_thenThrowException() {
        LocalDate checkIn = LocalDate.now().plusDays(4);
        LocalDate checkOut = LocalDate.now().plusDays(1);
        assertThrows(IllegalArgumentException.class, () -> validator.validateDates(checkIn, checkOut));
    }

    @Test
    @DisplayName("Given same check-in and check-out date, When validateDates, Then throw IllegalArgumentException")
    void givenSameDates_whenValidateDates_thenThrowException() {
        LocalDate date = LocalDate.now().plusDays(1);
        assertThrows(IllegalArgumentException.class, () -> validator.validateDates(date, date));
    }

    @Test
    @DisplayName("Given null check-in date, When validateDates, Then throw IllegalArgumentException")
    void givenNullCheckIn_whenValidateDates_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                validator.validateDates(null, LocalDate.now().plusDays(4))
        );
    }

    @Test
    @DisplayName("Given null check-out date, When validateDates, Then throw IllegalArgumentException")
    void givenNullCheckOut_whenValidateDates_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                validator.validateDates(LocalDate.now().plusDays(1), null)
        );
    }

    @Test
    @DisplayName("Given stay longer than 30 nights, When validateDates, Then throw IllegalArgumentException")
    void givenStayLongerThan30Nights_whenValidateDates_thenThrowException() {
        LocalDate checkIn = LocalDate.now().plusDays(1);
        LocalDate checkOut = LocalDate.now().plusDays(32);
        assertThrows(IllegalArgumentException.class, () -> validator.validateDates(checkIn, checkOut));
    }

    // ================================================================
    // ADDRESS VALIDATION
    // ================================================================

    @Test
    @DisplayName("Given valid address, When validateAddress, Then no exception")
    void givenValidAddress_whenValidate_thenNoException() {
        assertDoesNotThrow(() -> validator.validateAddress("123 Beach Road, Galle"));
    }

    @Test
    @DisplayName("Given null address, When validateAddress, Then throw IllegalArgumentException")
    void givenNullAddress_whenValidate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateAddress(null));
    }

    @Test
    @DisplayName("Given empty address, When validateAddress, Then throw IllegalArgumentException")
    void givenEmptyAddress_whenValidate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () -> validator.validateAddress(""));
    }
}

