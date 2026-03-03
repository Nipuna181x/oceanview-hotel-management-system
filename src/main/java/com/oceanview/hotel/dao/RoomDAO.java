package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.Room;

import java.util.List;

/**
 * DAO interface for Room data access operations.
 * DAO Pattern — abstracts all room persistence behind an interface.
 */
public interface RoomDAO {

    /**
     * Find a room by its ID.
     */
    Room findById(int roomId);

    /**
     * Find a room by its room number.
     */
    Room findByRoomNumber(String roomNumber);

    /**
     * Get all rooms.
     */
    List<Room> findAll();

    /**
     * Get all available rooms, optionally filtered by type.
     */
    List<Room> findAvailable(Room.RoomType type);

    /**
     * Update room availability.
     */
    boolean updateAvailability(int roomId, boolean available);
}

