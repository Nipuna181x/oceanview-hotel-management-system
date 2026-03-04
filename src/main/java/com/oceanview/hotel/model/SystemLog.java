package com.oceanview.hotel.model;

import java.time.LocalDateTime;

/**
 * Represents a system audit log entry.
 * Only Admins can view system logs.
 */
public class SystemLog {

    private int logId;
    private int userId;
    private String username;
    private String action;
    private String details;
    private String ipAddress;
    private LocalDateTime loggedAt;

    public SystemLog() {}

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public LocalDateTime getLoggedAt() { return loggedAt; }
    public void setLoggedAt(LocalDateTime loggedAt) { this.loggedAt = loggedAt; }

    @Override
    public String toString() {
        return "SystemLog{logId=" + logId + ", username='" + username +
                "', action='" + action + "', loggedAt=" + loggedAt + "}";
    }
}

