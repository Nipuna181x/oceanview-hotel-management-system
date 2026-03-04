package com.oceanview.hotel.model;

import java.time.LocalDateTime;

// Fired when a reservation event happens (created, cancelled, check-in, check-out)
public class Notification {

    public enum NotificationType {
        EMAIL, SYSTEM
    }

    public enum NotificationStatus {
        PENDING, SENT, FAILED
    }

    private int notificationId;
    private int reservationId;
    private NotificationType type;
    private String message;
    private LocalDateTime sentAt;
    private NotificationStatus status;

    public Notification() {
    }

    public Notification(int notificationId, int reservationId, NotificationType type,
                        String message, LocalDateTime sentAt, NotificationStatus status) {
        this.notificationId = notificationId;
        this.reservationId = reservationId;
        this.type = type;
        this.message = message;
        this.sentAt = sentAt;
        this.status = status;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public NotificationType getType() {
        return type;
    }

    public void setType(NotificationType type) {
        this.type = type;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getSentAt() {
        return sentAt;
    }

    public void setSentAt(LocalDateTime sentAt) {
        this.sentAt = sentAt;
    }

    public NotificationStatus getStatus() {
        return status;
    }

    public void setStatus(NotificationStatus status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Notification{" +
                "notificationId=" + notificationId +
                ", reservationId=" + reservationId +
                ", type=" + type +
                ", message='" + message + '\'' +
                ", sentAt=" + sentAt +
                ", status=" + status +
                '}';
    }
}
