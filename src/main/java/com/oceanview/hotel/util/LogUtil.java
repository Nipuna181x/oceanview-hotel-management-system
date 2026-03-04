package com.oceanview.hotel.util;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.SystemLogDAOImpl;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.SystemLogService;

import javax.servlet.http.HttpServletRequest;

/**
 * Utility for writing system audit logs from any controller.
 * Uses a fresh DAO per call to avoid stale connection issues.
 */
public class LogUtil {

    private static SystemLogService getService() {
        return new SystemLogService(new SystemLogDAOImpl(DBConnectionFactory.getConnection()));
    }

    public static void log(HttpServletRequest request, String action, String details) {
        try {
            User user = SessionUtil.getLoggedInUser(request);
            int userId = (user != null) ? user.getUserId() : 0;
            String username = (user != null) ? user.getUsername() : "anonymous";
            String ip = request.getRemoteAddr();
            getService().writeLog(userId, username, action, details, ip);
        } catch (Exception e) {
            e.printStackTrace(); // never let logging break the main flow
        }
    }
}

