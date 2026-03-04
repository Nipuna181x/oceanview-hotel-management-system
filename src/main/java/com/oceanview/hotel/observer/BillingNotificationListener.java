package com.oceanview.hotel.observer;

// Logs a reminder when a guest checks out — bill should be generated
public class BillingNotificationListener implements EventListener {

    @Override
    public void onEvent(String eventType, Object data) {
        if (EventManager.EVENT_GUEST_CHECKED_OUT.equals(eventType)) {
            System.out.println("[BillingNotification] Guest checked out — bill generation triggered. " + data);
        }
    }
}
