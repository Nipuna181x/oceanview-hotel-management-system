package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.Bill;

import java.util.List;

/**
 * DAO interface for Bill data access operations.
 * DAO Pattern — abstracts all billing persistence behind an interface.
 */
public interface BillDAO {

    int save(Bill bill);

    Bill findByReservationId(int reservationId);

    Bill findById(int billId);

    boolean update(Bill bill);

    /**
     * Return all bills ordered by most recent first.
     */
    List<Bill> findAll();
}

