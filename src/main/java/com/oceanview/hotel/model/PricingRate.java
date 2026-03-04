package com.oceanview.hotel.model;

import java.time.LocalDateTime;

/**
 * Represents a configurable pricing rate for a room type.
 * Admin can create, edit, and delete pricing rates.
 */
public class PricingRate {

    private int rateId;
    private Room.RoomType roomType;
    private String season;
    private double ratePerNight;
    private String description;
    private LocalDateTime createdAt;

    public PricingRate() {}

    public int getRateId() { return rateId; }
    public void setRateId(int rateId) { this.rateId = rateId; }

    public Room.RoomType getRoomType() { return roomType; }
    public void setRoomType(Room.RoomType roomType) { this.roomType = roomType; }

    public String getSeason() { return season; }
    public void setSeason(String season) { this.season = season; }

    public double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(double ratePerNight) { this.ratePerNight = ratePerNight; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "PricingRate{rateId=" + rateId + ", roomType=" + roomType +
                ", season='" + season + "', ratePerNight=" + ratePerNight + "}";
    }
}

