package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.PricingRate;
import com.oceanview.hotel.model.Room;

import java.util.List;

/**
 * DAO interface for PricingRate data access operations.
 * DAO Pattern — abstracts all pricing rate persistence behind an interface.
 */
public interface PricingRateDAO {

    List<PricingRate> findAll();

    PricingRate findById(int rateId);

    List<PricingRate> findByRoomType(Room.RoomType roomType);

    int save(PricingRate rate);

    boolean update(PricingRate rate);

    boolean delete(int rateId);
}

