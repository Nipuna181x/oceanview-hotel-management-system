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

    /**
     * Add a new room. Admin only.
     *
     * @param roomNumber  unique room number (e.g. "101")
     * @param roomType    type of the room
     * @param ratePerNight nightly rate (must be > 0)
     * @return true if saved successfully
     * @throws IllegalArgumentException if validation fails or room number taken
     */
    public boolean addRoom(String roomNumber, Room.RoomType roomType, double ratePerNight) {
        if (roomNumber == null || roomNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Room number cannot be blank");
        }
        if (ratePerNight <= 0) {
            throw new IllegalArgumentException("Rate per night must be greater than zero");
        }
        if (roomDAO.findByRoomNumber(roomNumber.trim()) != null) {
            throw new IllegalArgumentException("Room number already exists: " + roomNumber);
        }

        Room room = new Room();
        room.setRoomNumber(roomNumber.trim());
        room.setRoomType(roomType);
        room.setRatePerNight(ratePerNight);
        room.setAvailable(true);
        return roomDAO.save(room);
    }

    /**
     * Update an existing room's details. Admin only.
     *
     * @param roomId      ID of the room to update
     * @param roomNumber  new room number
     * @param roomType    new room type
     * @param ratePerNight new nightly rate
     * @return true if updated successfully
     * @throws IllegalArgumentException if room not found
     */
    public boolean updateRoom(int roomId, String roomNumber, Room.RoomType roomType, double ratePerNight) {
        Room room = roomDAO.findById(roomId);
        if (room == null) {
            throw new IllegalArgumentException("Room not found with ID: " + roomId);
        }
        room.setRoomNumber(roomNumber != null ? roomNumber.trim() : room.getRoomNumber());
        room.setRoomType(roomType);
        room.setRatePerNight(ratePerNight);
        return roomDAO.update(room);
    }

    /**
     * Delete a room by ID. Admin only.
     * Cannot delete occupied (unavailable) rooms.
     *
     * @param roomId ID of the room to delete
     * @return true if deleted successfully
     * @throws IllegalArgumentException if room not found or currently occupied
     */
    public boolean deleteRoom(int roomId) {
        Room room = roomDAO.findById(roomId);
        if (room == null) {
            throw new IllegalArgumentException("Room not found with ID: " + roomId);
        }
        if (!room.isAvailable()) {
            throw new IllegalArgumentException("Cannot delete room " + room.getRoomNumber() + " — it is currently occupied");
        }
        return roomDAO.delete(roomId);
    }
}

