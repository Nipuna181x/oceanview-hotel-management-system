package com.oceanview.hotel.observer;

import com.oceanview.hotel.util.EmailUtil;

// Sends email to guests when reservations are created, cancelled, or status changes
public class EmailNotificationListener implements EventListener {

    @Override
    public void onEvent(String eventType, Object data) {
        String message = buildMessage(eventType, data);
        // In production, call EmailUtil.send(guestEmail, subject, message)
        System.out.println("[EmailNotification] Event: " + eventType + " | " + message);
    }

    private String buildMessage(String eventType, Object data) {
        switch (eventType) {
            case EventManager.EVENT_RESERVATION_CREATED:
                return "Your reservation has been confirmed. Details: " + data;
            case EventManager.EVENT_RESERVATION_CANCELLED:
                return "Your reservation has been cancelled. Details: " + data;
            case EventManager.EVENT_GUEST_CHECKED_IN:
                return "Check-in confirmed. Welcome to Ocean View Resort! Details: " + data;
            case EventManager.EVENT_GUEST_CHECKED_OUT:
                return "Thank you for staying with us. Your bill is ready. Details: " + data;
            default:
                return "Notification: " + data;
        }
    }
}
