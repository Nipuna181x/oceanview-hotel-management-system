package com.oceanview.hotel.model;

// Hotel room with its type, rate and availability status
public class Room {

    public enum RoomType {
        SINGLE, DOUBLE, SUITE, DELUXE
    }

    private int roomId;
    private String roomNumber;
    private RoomType roomType;
    private int maxOccupancy;
    private double ratePerNight;
    private String description;
    private boolean available;

    public Room() {
    }

    public Room(int roomId, String roomNumber, RoomType roomType, int maxOccupancy, double ratePerNight, String description, boolean available) {
        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.roomType = roomType;
        this.maxOccupancy = maxOccupancy;
        this.ratePerNight = ratePerNight;
        this.description = description;
        this.available = available;
    }

    /** Backwards-compat constructor, defaults to occupancy 2 */
    public Room(int roomId, String roomNumber, RoomType roomType, double ratePerNight, boolean available) {
        this(roomId, roomNumber, roomType, 2, ratePerNight, null, available);
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    public int getMaxOccupancy() {
        return maxOccupancy;
    }

    public void setMaxOccupancy(int maxOccupancy) {
        this.maxOccupancy = maxOccupancy;
    }

    public double getRatePerNight() {
        return ratePerNight;
    }

    public void setRatePerNight(double ratePerNight) {
        this.ratePerNight = ratePerNight;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    @Override
    public String toString() {
        return "Room{" +
                "roomId=" + roomId +
                ", roomNumber='" + roomNumber + '\'' +
                ", roomType=" + roomType +
                ", maxOccupancy=" + maxOccupancy +
                ", ratePerNight=" + ratePerNight +
                ", description='" + description + '\'' +
                ", available=" + available +
                '}';
    }
}
