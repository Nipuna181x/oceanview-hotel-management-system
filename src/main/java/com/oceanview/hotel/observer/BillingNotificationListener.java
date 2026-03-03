package com.oceanview.hotel.observer;

/**
 * Observer Pattern — Concrete listener that logs billing-related
 * notifications when reservation events occur.
 *
 * Registered for GUEST_CHECKED_OUT events to trigger bill generation reminders.
 */
public class BillingNotificationListener implements EventListener {

    @Override
    public void onEvent(String eventType, Object data) {
        if (EventManager.EVENT_GUEST_CHECKED_OUT.equals(eventType)) {
            System.out.println("[BillingNotification] Guest checked out — bill generation triggered. " + data);
        }
    }
}

