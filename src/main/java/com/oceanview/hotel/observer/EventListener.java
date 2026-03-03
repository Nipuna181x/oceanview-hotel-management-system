package com.oceanview.hotel.observer;

/**
 * Observer Pattern — defines the listener interface.
 * Any class that wants to receive reservation events must implement this.
 */
public interface EventListener {

    /**
     * Called when a reservation event occurs.
     * @param eventType the type of event (e.g. "RESERVATION_CREATED", "RESERVATION_CANCELLED")
     * @param data      contextual data about the event (e.g. reservation number, guest email)
     */
    void onEvent(String eventType, Object data);
}

