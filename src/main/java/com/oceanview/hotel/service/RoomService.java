package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.RoomDAO;
import com.oceanview.hotel.model.Room;

import java.util.List;

/**
 * Service class for room management business logic.
 *
 * Design Pattern: Service Layer / Facade — single entry point for
 * all room-related operations used by controllers and REST resources.
 */
public class RoomService {

    private final RoomDAO roomDAO;

    // Default rates per room type (used when no specific room is loaded)
    private static final double SINGLE_RATE  = 75.00;
    private static final double DOUBLE_RATE  = 120.00;
    private static final double SUITE_RATE   = 250.00;
    private static final double DELUXE_RATE  = 350.00;

    public RoomService(RoomDAO roomDAO) {
        this.roomDAO = roomDAO;
    }

    /**
     * Get all rooms regardless of availability.
     */
    public List<Room> getAllRooms() {
        return roomDAO.findAll();
    }

    /**
     * Get available rooms, optionally filtered by room type.
     * @param type filter by room type, or null for all available rooms
     */
    public List<Room> getAvailableRooms(Room.RoomType type) {
        return roomDAO.findAvailable(type);
    }

    /**
     * Get a room by its ID.
     * @throws IllegalArgumentException if room not found
     */
    public Room getRoomById(int roomId) {
        Room room = roomDAO.findById(roomId);
        if (room == null) {
            throw new IllegalArgumentException("Room not found with ID: " + roomId);
        }
        return room;
    }

    /**
     * Check if a specific room is available.
     */
    public boolean isRoomAvailable(int roomId) {
        Room room = roomDAO.findById(roomId);
        if (room == null) {
            return false;
        }
        return room.isAvailable();
    }

    /**
     * Get the default rate per night for a given room type.
     * @throws IllegalArgumentException if roomType is null
     */
    public double getRateByType(Room.RoomType roomType) {
        if (roomType == null) {
            throw new IllegalArgumentException("Room type cannot be null");
        }
        switch (roomType) {
            case SINGLE:  return SINGLE_RATE;
            case DOUBLE:  return DOUBLE_RATE;
            case SUITE:   return SUITE_RATE;
            case DELUXE:  return DELUXE_RATE;
            default: throw new IllegalArgumentException("Unknown room type: " + roomType);
        }
    }
}

