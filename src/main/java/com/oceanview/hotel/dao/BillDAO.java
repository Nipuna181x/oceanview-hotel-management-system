package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.Bill;

/**
 * DAO interface for Bill data access operations.
 * DAO Pattern — abstracts all billing persistence behind an interface.
 */
public interface BillDAO {

    /**
     * Save a new bill to the database.
     * @return the generated bill ID
     */
    int save(Bill bill);

    /**
     * Find a bill by its reservation ID.
     */
    Bill findByReservationId(int reservationId);

    /**
     * Find a bill by its ID.
     */
    Bill findById(int billId);

    /**
     * Update an existing bill.
     */
    boolean update(Bill bill);
}

