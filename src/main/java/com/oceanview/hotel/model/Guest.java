package com.oceanview.hotel.model;

import java.time.LocalDateTime;

// Guest who made a reservation
public class Guest {

    private int guestId;
    private String fullName;
    private String address;
    private String contactNumber;
    private String email;
    private String nic;
    private LocalDateTime createdAt;

    public Guest() {
    }

    public Guest(int guestId, String fullName, String address, String contactNumber, String email, String nic, LocalDateTime createdAt) {
        this.guestId = guestId;
        this.fullName = fullName;
        this.address = address;
        this.contactNumber = contactNumber;
        this.email = email;
        this.nic = nic;
        this.createdAt = createdAt;
    }

    public int getGuestId() {
        return guestId;
    }

    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNic() {
        return nic;
    }

    public void setNic(String nic) {
        this.nic = nic;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Guest{" +
                "guestId=" + guestId +
                ", fullName='" + fullName + '\'' +
                ", address='" + address + '\'' +
                ", contactNumber='" + contactNumber + '\'' +
                ", email='" + email + '\'' +
                ", nic='" + nic + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
