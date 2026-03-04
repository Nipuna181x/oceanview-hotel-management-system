package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.UserDAOImpl;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.StaffService;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet controller for Staff Management.
 * ADMIN only — all requests checked for ADMIN role.
 */
@WebServlet("/staff/*")
public class StaffController extends HttpServlet {

    private StaffService staffService;

    @Override
    public void init() throws ServletException {
        staffService = new StaffService(new UserDAOImpl(DBConnectionFactory.getConnection()));
    }

    /** Enforce admin-only access */
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

        String pathInfo = request.getPathInfo(); // e.g. null, "/new", "/edit", "/delete"

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all staff
            List<User> staffList = staffService.getAllStaff();
            request.setAttribute("staffList", staffList);
            request.getRequestDispatcher("/WEB-INF/view/staff-list.jsp").forward(request, response);

        } else if (pathInfo.equals("/new")) {
            // Show create form
            request.getRequestDispatcher("/WEB-INF/view/staff-form.jsp").forward(request, response);

        } else if (pathInfo.equals("/edit")) {
            // Show edit form
            String idStr = request.getParameter("id");
            try {
                int id = Integer.parseInt(idStr);
                User staff = staffService.getStaffById(id);
                request.setAttribute("staff", staff);
                request.getRequestDispatcher("/WEB-INF/view/staff-form.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/staff");
            }

        } else if (pathInfo.equals("/delete")) {
            // Handle delete via GET with confirmation
            String idStr = request.getParameter("id");
            try {
                int id = Integer.parseInt(idStr);
                staffService.deleteStaff(id);
                request.getSession().setAttribute("successMessage", "Staff member deleted successfully.");
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/staff");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request, response)) return;

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email    = request.getParameter("email");
            try {
                staffService.createStaff(username, password, fullName, email);
                request.getSession().setAttribute("successMessage", "Staff member created successfully.");
                response.sendRedirect(request.getContextPath() + "/staff");
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.setAttribute("formAction", "create");
                request.getRequestDispatcher("/WEB-INF/view/staff-form.jsp").forward(request, response);
            }

        } else if ("update".equals(action)) {
            String idStr   = request.getParameter("userId");
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String email    = request.getParameter("email");
            String newPass  = request.getParameter("newPassword");
            try {
                int id = Integer.parseInt(idStr);
                staffService.updateStaff(id, username, fullName, email);
                if (newPass != null && !newPass.trim().isEmpty()) {
                    staffService.resetPassword(id, newPass);
                }
                request.getSession().setAttribute("successMessage", "Staff member updated successfully.");
                response.sendRedirect(request.getContextPath() + "/staff");
            } catch (Exception e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/staff-form.jsp").forward(request, response);
            }
        }
    }
}

