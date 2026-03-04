package com.oceanview.hotel.observer;

// Implement this to listen for reservation events
public interface EventListener {
    void onEvent(String eventType, Object data);
}
