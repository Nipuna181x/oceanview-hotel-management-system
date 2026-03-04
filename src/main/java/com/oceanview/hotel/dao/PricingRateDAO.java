package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.PricingRate;

import java.util.List;

/**
 * DAO interface for PricingStrategy (stored as PricingRate) data access.
 */
public interface PricingRateDAO {
    List<PricingRate> findAll();
    PricingRate findById(int strategyId);
    PricingRate findByName(String name);
    PricingRate findDefault();
    int save(PricingRate strategy);
    boolean update(PricingRate strategy);
    boolean delete(int strategyId);
}
