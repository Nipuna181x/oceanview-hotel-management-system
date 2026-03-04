package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.PricingRateDAO;
import com.oceanview.hotel.model.PricingRate;
import com.oceanview.hotel.model.Room;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * TDD Test class for PricingRateService.
 * Covers: add, update, delete, list pricing rates.
 * Follows Given / When / Then naming convention.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("PricingRateService Tests")
class PricingRateServiceTest {

    @Mock
    private PricingRateDAO pricingRateDAO;

    @InjectMocks
    private PricingRateService pricingRateService;

    private PricingRate existingRate;

    @BeforeEach
    void setUp() {
        existingRate = new PricingRate();
        existingRate.setRateId(1);
        existingRate.setRoomType(Room.RoomType.SINGLE);
        existingRate.setSeason("STANDARD");
        existingRate.setRatePerNight(75.00);
        existingRate.setDescription("Standard single room rate");
        existingRate.setCreatedAt(LocalDateTime.now());
    }

    // ─────────────────────────────────────────────
    // GET ALL RATES
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given rates exist, When getAllRates, Then return list")
    void givenRatesExist_whenGetAllRates_thenReturnList() {
        when(pricingRateDAO.findAll()).thenReturn(Arrays.asList(existingRate));

        List<PricingRate> result = pricingRateService.getAllRates();

        assertNotNull(result);
        assertEquals(1, result.size());
        verify(pricingRateDAO, times(1)).findAll();
    }

    @Test
    @DisplayName("Given no rates, When getAllRates, Then return empty list")
    void givenNoRates_whenGetAllRates_thenReturnEmpty() {
        when(pricingRateDAO.findAll()).thenReturn(Collections.emptyList());

        List<PricingRate> result = pricingRateService.getAllRates();

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    // ─────────────────────────────────────────────
    // GET BY ID
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid ID, When getRateById, Then return rate")
    void givenValidId_whenGetRateById_thenReturnRate() {
        when(pricingRateDAO.findById(1)).thenReturn(existingRate);

        PricingRate result = pricingRateService.getRateById(1);

        assertNotNull(result);
        assertEquals(1, result.getRateId());
    }

    @Test
    @DisplayName("Given invalid ID, When getRateById, Then throw IllegalArgumentException")
    void givenInvalidId_whenGetRateById_thenThrowException() {
        when(pricingRateDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.getRateById(99));
    }

    // ─────────────────────────────────────────────
    // ADD RATE
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid details, When addRate, Then save succeeds")
    void givenValidDetails_whenAddRate_thenSaveSucceeds() {
        when(pricingRateDAO.save(any(PricingRate.class))).thenReturn(1);

        int result = pricingRateService.addRate(Room.RoomType.DOUBLE, "PEAK", 160.00, "Peak season rate");

        assertTrue(result > 0);
        verify(pricingRateDAO, times(1)).save(any(PricingRate.class));
    }

    @Test
    @DisplayName("Given null room type, When addRate, Then throw IllegalArgumentException")
    void givenNullRoomType_whenAddRate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.addRate(null, "STANDARD", 75.00, "desc"));
    }

    @Test
    @DisplayName("Given blank season, When addRate, Then throw IllegalArgumentException")
    void givenBlankSeason_whenAddRate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.addRate(Room.RoomType.SINGLE, "", 75.00, "desc"));
    }

    @Test
    @DisplayName("Given zero rate, When addRate, Then throw IllegalArgumentException")
    void givenZeroRate_whenAddRate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.addRate(Room.RoomType.SINGLE, "STANDARD", 0.00, "desc"));
    }

    @Test
    @DisplayName("Given negative rate, When addRate, Then throw IllegalArgumentException")
    void givenNegativeRate_whenAddRate_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.addRate(Room.RoomType.SINGLE, "STANDARD", -50.00, "desc"));
    }

    // ─────────────────────────────────────────────
    // UPDATE RATE
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid ID, When updateRate, Then update succeeds")
    void givenValidId_whenUpdateRate_thenUpdateSucceeds() {
        when(pricingRateDAO.findById(1)).thenReturn(existingRate);
        when(pricingRateDAO.update(any(PricingRate.class))).thenReturn(true);

        boolean result = pricingRateService.updateRate(1, Room.RoomType.SINGLE, "PEAK", 90.00, "Updated");

        assertTrue(result);
        verify(pricingRateDAO, times(1)).update(any(PricingRate.class));
    }

    @Test
    @DisplayName("Given non-existent ID, When updateRate, Then throw IllegalArgumentException")
    void givenNonExistentId_whenUpdateRate_thenThrowException() {
        when(pricingRateDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.updateRate(99, Room.RoomType.SINGLE, "STANDARD", 75.00, "desc"));
    }

    // ─────────────────────────────────────────────
    // DELETE RATE
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid ID, When deleteRate, Then delete succeeds")
    void givenValidId_whenDeleteRate_thenDeleteSucceeds() {
        when(pricingRateDAO.findById(1)).thenReturn(existingRate);
        when(pricingRateDAO.delete(1)).thenReturn(true);

        boolean result = pricingRateService.deleteRate(1);

        assertTrue(result);
        verify(pricingRateDAO, times(1)).delete(1);
    }

    @Test
    @DisplayName("Given non-existent ID, When deleteRate, Then throw IllegalArgumentException")
    void givenNonExistentId_whenDeleteRate_thenThrowException() {
        when(pricingRateDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.deleteRate(99));
    }
}

