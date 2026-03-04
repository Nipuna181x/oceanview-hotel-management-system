package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.PricingRateDAO;
import com.oceanview.hotel.model.PricingRate;
import com.oceanview.hotel.model.Room;

import java.util.List;

/**
 * Service class for pricing rate management business logic.
 *
 * Design Patterns:
 * - Service Layer / Facade: single entry point for all pricing rate operations.
 * - DAO: delegates persistence to PricingRateDAO interface.
 *
 * Only ADMIN users should call these methods (enforced at controller level).
 */
public class PricingRateService {

    private final PricingRateDAO pricingRateDAO;

    public PricingRateService(PricingRateDAO pricingRateDAO) {
        this.pricingRateDAO = pricingRateDAO;
    }

    /**
     * Get all pricing rates.
     */
    public List<PricingRate> getAllRates() {
        return pricingRateDAO.findAll();
    }

    /**
     * Get a single pricing rate by ID.
     *
     * @throws IllegalArgumentException if not found
     */
    public PricingRate getRateById(int rateId) {
        PricingRate rate = pricingRateDAO.findById(rateId);
        if (rate == null) {
            throw new IllegalArgumentException("Pricing rate not found with ID: " + rateId);
        }
        return rate;
    }

    /**
     * Get all pricing rates for a specific room type.
     */
    public List<PricingRate> getRatesByRoomType(Room.RoomType roomType) {
        return pricingRateDAO.findByRoomType(roomType);
    }

    /**
     * Add a new pricing rate. Admin only.
     *
     * @param roomType     the room type this rate applies to
     * @param season       season label e.g. "STANDARD", "PEAK", "OFF_PEAK"
     * @param ratePerNight nightly rate (must be > 0)
     * @param description  optional description
     * @return generated rate ID
     * @throws IllegalArgumentException if validation fails
     */
    public int addRate(Room.RoomType roomType, String season, double ratePerNight, String description) {
        if (roomType == null) {
            throw new IllegalArgumentException("Room type cannot be null");
        }
        if (season == null || season.trim().isEmpty()) {
            throw new IllegalArgumentException("Season cannot be blank");
        }
        if (ratePerNight <= 0) {
            throw new IllegalArgumentException("Rate per night must be greater than zero");
        }

        PricingRate rate = new PricingRate();
        rate.setRoomType(roomType);
        rate.setSeason(season.trim().toUpperCase());
        rate.setRatePerNight(ratePerNight);
        rate.setDescription(description);

        return pricingRateDAO.save(rate);
    }

    /**
     * Update an existing pricing rate. Admin only.
     *
     * @throws IllegalArgumentException if not found
     */
    public boolean updateRate(int rateId, Room.RoomType roomType, String season,
                               double ratePerNight, String description) {
        PricingRate rate = pricingRateDAO.findById(rateId);
        if (rate == null) {
            throw new IllegalArgumentException("Pricing rate not found with ID: " + rateId);
        }

        rate.setRoomType(roomType);
        rate.setSeason(season != null ? season.trim().toUpperCase() : rate.getSeason());
        rate.setRatePerNight(ratePerNight);
        rate.setDescription(description);

        return pricingRateDAO.update(rate);
    }

    /**
     * Delete a pricing rate by ID. Admin only.
     *
     * @throws IllegalArgumentException if not found
     */
    public boolean deleteRate(int rateId) {
        PricingRate rate = pricingRateDAO.findById(rateId);
        if (rate == null) {
            throw new IllegalArgumentException("Pricing rate not found with ID: " + rateId);
        }
        return pricingRateDAO.delete(rateId);
    }
}

