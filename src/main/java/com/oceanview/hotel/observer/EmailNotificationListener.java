package com.oceanview.hotel.observer;

import com.oceanview.hotel.util.EmailUtil;

/**
 * Observer Pattern — Concrete listener that sends email notifications
 * when reservation events occur.
 *
 * Registered with EventManager for RESERVATION_CREATED and
 * RESERVATION_CANCELLED events. When fired, it calls EmailUtil
 * to send a notification email to the guest.
 */
public class EmailNotificationListener implements EventListener {

    @Override
    public void onEvent(String eventType, Object data) {
        String message = buildMessage(eventType, data);
        // In production: EmailUtil.send(guestEmail, subject, message)
        // For demonstration, we log to console
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

