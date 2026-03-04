package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.SystemLogDAO;
import com.oceanview.hotel.model.SystemLog;

import java.util.List;

// Reads and writes audit log entries — reading is admin-only, writing is open to all logged-in users
public class SystemLogService {

    private final SystemLogDAO systemLogDAO;

    public SystemLogService(SystemLogDAO systemLogDAO) {
        this.systemLogDAO = systemLogDAO;
    }

    public int writeLog(int userId, String username, String action,
                        String details, String ipAddress) {
        if (action == null || action.trim().isEmpty()) {
            throw new IllegalArgumentException("Log action cannot be null or blank");
        }

        SystemLog log = new SystemLog();
        log.setUserId(userId);
        log.setUsername(username);
        log.setAction(action.trim().toUpperCase());
        log.setDetails(details);
        log.setIpAddress(ipAddress);

        return systemLogDAO.save(log);
    }

    // Most recent first
    public List<SystemLog> getAllLogs() {
        return systemLogDAO.findAll();
    }

    public List<SystemLog> getLogsByUser(int userId) {
        return systemLogDAO.findByUserId(userId);
    }

    public List<SystemLog> getLogsByAction(String action) {
        if (action == null || action.trim().isEmpty()) {
            throw new IllegalArgumentException("Action filter cannot be blank");
        }
        return systemLogDAO.findByAction(action.trim().toUpperCase());
    }
}
