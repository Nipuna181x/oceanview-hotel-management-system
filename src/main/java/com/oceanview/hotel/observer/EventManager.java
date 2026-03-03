package com.oceanview.hotel.observer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Observer Pattern — the Subject/Publisher that manages listeners and fires events.
 *
 * Design Pattern: Observer — decouples reservation events from their side effects.
 * When a reservation is created or cancelled, the EventManager notifies all
 * registered listeners (e.g. EmailNotificationListener, BillingNotificationListener)
 * without the ReservationService needing to know about them directly.
 *
 * This satisfies the Open/Closed Principle — new listeners can be added
 * without modifying existing code.
 */
public class EventManager {

    private final Map<String, List<EventListener>> listeners = new HashMap<>();

    // Standard event types
    public static final String EVENT_RESERVATION_CREATED   = "RESERVATION_CREATED";
    public static final String EVENT_RESERVATION_CANCELLED = "RESERVATION_CANCELLED";
    public static final String EVENT_GUEST_CHECKED_IN      = "GUEST_CHECKED_IN";
    public static final String EVENT_GUEST_CHECKED_OUT     = "GUEST_CHECKED_OUT";

    /**
     * Subscribe a listener to a specific event type.
     */
    public void subscribe(String eventType, EventListener listener) {
        listeners.computeIfAbsent(eventType, k -> new ArrayList<>()).add(listener);
    }

    /**
     * Unsubscribe a listener from a specific event type.
     */
    public void unsubscribe(String eventType, EventListener listener) {
        List<EventListener> eventListeners = listeners.get(eventType);
        if (eventListeners != null) {
            eventListeners.remove(listener);
        }
    }

    /**
     * Notify all listeners subscribed to the given event type.
     * @param eventType the event that occurred
     * @param data      contextual data to pass to listeners
     */
    public void notify(String eventType, Object data) {
        List<EventListener> eventListeners = listeners.getOrDefault(eventType, new ArrayList<>());
        for (EventListener listener : eventListeners) {
            listener.onEvent(eventType, data);
        }
    }
}

