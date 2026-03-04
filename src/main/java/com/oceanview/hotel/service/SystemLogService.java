package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.SystemLogDAO;
import com.oceanview.hotel.model.SystemLog;

import java.util.List;

/**
 * Service class for system audit log operations.
 *
 * Design Patterns:
 * - Service Layer / Facade: single entry point for all log operations.
 * - DAO: delegates persistence to SystemLogDAO interface.
 *
 * Only ADMIN users should be able to READ logs (enforced at controller level).
 * Any authenticated user can WRITE a log entry (for audit trail).
 */
public class SystemLogService {

    private final SystemLogDAO systemLogDAO;

    public SystemLogService(SystemLogDAO systemLogDAO) {
        this.systemLogDAO = systemLogDAO;
    }

    /**
     * Write a new audit log entry.
     *
     * @param userId    ID of the user performing the action
     * @param username  username of the user
     * @param action    action code e.g. "CREATE_RESERVATION"
     * @param details   human-readable description
     * @param ipAddress client IP address
     * @return generated log ID
     * @throws IllegalArgumentException if action is null or blank
     */
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

    /**
     * Get all system log entries, most recent first.
     * Admin only.
     */
    public List<SystemLog> getAllLogs() {
        return systemLogDAO.findAll();
    }

    /**
     * Get log entries for a specific user.
     * Admin only.
     */
    public List<SystemLog> getLogsByUser(int userId) {
        return systemLogDAO.findByUserId(userId);
    }

    /**
     * Get log entries for a specific action type.
     * Admin only.
     *
     * @throws IllegalArgumentException if action is blank
     */
    public List<SystemLog> getLogsByAction(String action) {
        if (action == null || action.trim().isEmpty()) {
            throw new IllegalArgumentException("Action filter cannot be blank");
        }
        return systemLogDAO.findByAction(action.trim().toUpperCase());
    }
}

