package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.SystemLogDAOImpl;
import com.oceanview.hotel.model.SystemLog;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.SystemLogService;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet controller for System Logs.
 * ADMIN only — all requests checked for ADMIN role.
 */
@WebServlet("/logs/*")
public class SystemLogController extends HttpServlet {

    private SystemLogService systemLogService;

    @Override
    public void init() throws ServletException {
        systemLogService = new SystemLogService(
                new SystemLogDAOImpl(DBConnectionFactory.getConnection()));
    }

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = SessionUtil.getLoggedInUser(request);
        if (user == null || !User.Role.ADMIN.equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request, response)) return;

        String filterAction = request.getParameter("action");
        String filterUserId = request.getParameter("userId");

        List<SystemLog> logs;

        try {
            if (filterAction != null && !filterAction.trim().isEmpty()) {
                logs = systemLogService.getLogsByAction(filterAction.trim());
            } else if (filterUserId != null && !filterUserId.trim().isEmpty()) {
                logs = systemLogService.getLogsByUser(Integer.parseInt(filterUserId));
            } else {
                logs = systemLogService.getAllLogs();
            }
        } catch (Exception e) {
            logs = systemLogService.getAllLogs();
        }

        request.setAttribute("logs", logs);
        request.setAttribute("filterAction", filterAction);
        request.getRequestDispatcher("/WEB-INF/view/system-logs.jsp").forward(request, response);
    }
}

