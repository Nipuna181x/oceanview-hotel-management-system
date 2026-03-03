package com.oceanview.hotel.controller;

import com.oceanview.hotel.model.User;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet controller for the main dashboard.
 * Requires authentication — protected by AuthenticationFilter.
 */
@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = SessionUtil.getLoggedInUser(request);
        request.setAttribute("currentUser", user);
        request.getRequestDispatcher("/WEB-INF/view/dashboard.jsp").forward(request, response);
    }
}

