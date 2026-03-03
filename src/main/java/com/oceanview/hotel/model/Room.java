package com.oceanview.hotel.model;

/**
 * Represents a hotel room with type, rate, and availability.
 */
public class Room {

    public enum RoomType {
        SINGLE, DOUBLE, SUITE, DELUXE
    }

    private int roomId;
    private String roomNumber;
    private RoomType roomType;
    private double ratePerNight;
    private boolean available;

    public Room() {
    }

    public Room(int roomId, String roomNumber, RoomType roomType, double ratePerNight, boolean available) {
        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.roomType = roomType;
        this.ratePerNight = ratePerNight;
        this.available = available;
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

    public double getRatePerNight() {
        return ratePerNight;
    }

    public void setRatePerNight(double ratePerNight) {
        this.ratePerNight = ratePerNight;
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
                ", ratePerNight=" + ratePerNight +
                ", available=" + available +
                '}';
    }
}

