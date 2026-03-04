package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.PricingRateDAO;
import com.oceanview.hotel.model.PricingRate;
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
 * TDD Test class for PricingRateService (strategy management).
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("PricingRateService Tests")
class PricingRateServiceTest {

    @Mock
    private PricingRateDAO pricingRateDAO;

    @InjectMocks
    private PricingRateService pricingRateService;

    private PricingRate standardStrategy;

    @BeforeEach
    void setUp() {
        standardStrategy = new PricingRate();
        standardStrategy.setStrategyId(1);
        standardStrategy.setName("Standard");
        standardStrategy.setAdjustmentType(PricingRate.AdjustmentType.SURCHARGE);
        standardStrategy.setAdjustmentPercent(0);
        standardStrategy.setDefault(true);
        standardStrategy.setDescription("Base rate — no adjustment");
        standardStrategy.setCreatedAt(LocalDateTime.now());
    }

    // ─────────────────────────────────────────────
    // GET ALL STRATEGIES
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given strategies exist, When getAllStrategies, Then return list")
    void givenStrategiesExist_whenGetAll_thenReturnList() {
        when(pricingRateDAO.findAll()).thenReturn(Arrays.asList(standardStrategy));

        List<PricingRate> result = pricingRateService.getAllStrategies();

        assertNotNull(result);
        assertEquals(1, result.size());
        verify(pricingRateDAO, times(1)).findAll();
    }

    @Test
    @DisplayName("Given no strategies, When getAllStrategies, Then return empty list")
    void givenNoStrategies_whenGetAll_thenReturnEmpty() {
        when(pricingRateDAO.findAll()).thenReturn(Collections.emptyList());

        List<PricingRate> result = pricingRateService.getAllStrategies();

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    // ─────────────────────────────────────────────
    // GET BY ID
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid ID, When getById, Then return strategy")
    void givenValidId_whenGetById_thenReturnStrategy() {
        when(pricingRateDAO.findById(1)).thenReturn(standardStrategy);

        PricingRate result = pricingRateService.getById(1);

        assertNotNull(result);
        assertEquals(1, result.getStrategyId());
        assertEquals("Standard", result.getName());
    }

    @Test
    @DisplayName("Given invalid ID, When getById, Then throw IllegalArgumentException")
    void givenInvalidId_whenGetById_thenThrowException() {
        when(pricingRateDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.getById(99));
    }

    // ─────────────────────────────────────────────
    // ADD STRATEGY
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid details, When addStrategy, Then save succeeds")
    void givenValidDetails_whenAddStrategy_thenSaveSucceeds() {
        when(pricingRateDAO.save(any(PricingRate.class))).thenReturn(2);

        int result = pricingRateService.addStrategy("Seasonal",
                PricingRate.AdjustmentType.SURCHARGE, 20.0, "Peak season", false);

        assertTrue(result > 0);
        verify(pricingRateDAO, times(1)).save(any(PricingRate.class));
    }

    @Test
    @DisplayName("Given blank name, When addStrategy, Then throw IllegalArgumentException")
    void givenBlankName_whenAddStrategy_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.addStrategy("", PricingRate.AdjustmentType.SURCHARGE, 20.0, "desc", false));
    }

    @Test
    @DisplayName("Given null adjustment type, When addStrategy, Then throw IllegalArgumentException")
    void givenNullType_whenAddStrategy_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.addStrategy("Test", null, 20.0, "desc", false));
    }

    @Test
    @DisplayName("Given negative percent, When addStrategy, Then throw IllegalArgumentException")
    void givenNegativePercent_whenAddStrategy_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.addStrategy("Test", PricingRate.AdjustmentType.DISCOUNT, -5.0, "desc", false));
    }

    // ─────────────────────────────────────────────
    // UPDATE STRATEGY
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid ID, When updateStrategy, Then update succeeds")
    void givenValidId_whenUpdateStrategy_thenUpdateSucceeds() {
        when(pricingRateDAO.findById(1)).thenReturn(standardStrategy);
        when(pricingRateDAO.update(any(PricingRate.class))).thenReturn(true);

        boolean result = pricingRateService.updateStrategy(1, "Updated",
                PricingRate.AdjustmentType.SURCHARGE, 5.0, "Updated desc", true);

        assertTrue(result);
        verify(pricingRateDAO, times(1)).update(any(PricingRate.class));
    }

    @Test
    @DisplayName("Given non-existent ID, When updateStrategy, Then throw IllegalArgumentException")
    void givenNonExistentId_whenUpdateStrategy_thenThrowException() {
        when(pricingRateDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.updateStrategy(99, "Test",
                        PricingRate.AdjustmentType.SURCHARGE, 10.0, "desc", false));
    }

    // ─────────────────────────────────────────────
    // DELETE STRATEGY
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given non-default strategy, When deleteStrategy, Then delete succeeds")
    void givenNonDefault_whenDeleteStrategy_thenDeleteSucceeds() {
        PricingRate nonDefault = new PricingRate();
        nonDefault.setStrategyId(2);
        nonDefault.setName("Seasonal");
        nonDefault.setDefault(false);

        when(pricingRateDAO.findById(2)).thenReturn(nonDefault);
        when(pricingRateDAO.delete(2)).thenReturn(true);

        boolean result = pricingRateService.deleteStrategy(2);

        assertTrue(result);
        verify(pricingRateDAO, times(1)).delete(2);
    }

    @Test
    @DisplayName("Given default strategy, When deleteStrategy, Then throw IllegalArgumentException")
    void givenDefaultStrategy_whenDeleteStrategy_thenThrowException() {
        when(pricingRateDAO.findById(1)).thenReturn(standardStrategy);

        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.deleteStrategy(1));
    }

    @Test
    @DisplayName("Given non-existent ID, When deleteStrategy, Then throw IllegalArgumentException")
    void givenNonExistentId_whenDeleteStrategy_thenThrowException() {
        when(pricingRateDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                pricingRateService.deleteStrategy(99));
    }
}

