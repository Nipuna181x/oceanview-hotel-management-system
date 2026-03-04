package com.oceanview.hotel.observer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// Manages event listeners — subscribe/unsubscribe and fire events by type
public class EventManager {

    private final Map<String, List<EventListener>> listeners = new HashMap<>();

    public static final String EVENT_RESERVATION_CREATED   = "RESERVATION_CREATED";
    public static final String EVENT_RESERVATION_CANCELLED = "RESERVATION_CANCELLED";
    public static final String EVENT_GUEST_CHECKED_IN      = "GUEST_CHECKED_IN";
    public static final String EVENT_GUEST_CHECKED_OUT     = "GUEST_CHECKED_OUT";

    public void subscribe(String eventType, EventListener listener) {
        listeners.computeIfAbsent(eventType, k -> new ArrayList<>()).add(listener);
    }

    public void unsubscribe(String eventType, EventListener listener) {
        List<EventListener> eventListeners = listeners.get(eventType);
        if (eventListeners != null) eventListeners.remove(listener);
    }

    public void notify(String eventType, Object data) {
        List<EventListener> eventListeners = listeners.getOrDefault(eventType, new ArrayList<>());
        for (EventListener listener : eventListeners) {
            listener.onEvent(eventType, data);
        }
    }
}
