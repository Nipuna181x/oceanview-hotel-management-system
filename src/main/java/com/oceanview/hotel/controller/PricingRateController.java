package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.PricingRateDAOImpl;
import com.oceanview.hotel.model.PricingRate;
import com.oceanview.hotel.model.Room;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.PricingRateService;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet controller for Pricing Rate Management.
 * ADMIN only — all requests checked for ADMIN role.
 */
@WebServlet("/pricing/*")
public class PricingRateController extends HttpServlet {

    private PricingRateService pricingRateService;

    @Override
    public void init() throws ServletException {
        pricingRateService = new PricingRateService(
                new PricingRateDAOImpl(DBConnectionFactory.getConnection()));
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

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            List<PricingRate> rates = pricingRateService.getAllRates();
            request.setAttribute("rates", rates);
            request.getRequestDispatcher("/WEB-INF/view/pricing-list.jsp").forward(request, response);

        } else if (pathInfo.equals("/new")) {
            request.getRequestDispatcher("/WEB-INF/view/pricing-form.jsp").forward(request, response);

        } else if (pathInfo.equals("/edit")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                PricingRate rate = pricingRateService.getRateById(id);
                request.setAttribute("rate", rate);
                request.getRequestDispatcher("/WEB-INF/view/pricing-form.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/pricing");
            }

        } else if (pathInfo.equals("/delete")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                pricingRateService.deleteRate(id);
                request.getSession().setAttribute("successMessage", "Pricing rate deleted successfully.");
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/pricing");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request, response)) return;

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            try {
                Room.RoomType roomType = Room.RoomType.valueOf(request.getParameter("roomType").toUpperCase());
                String season = request.getParameter("season");
                double rate = Double.parseDouble(request.getParameter("ratePerNight"));
                String description = request.getParameter("description");
                pricingRateService.addRate(roomType, season, rate, description);
                request.getSession().setAttribute("successMessage", "Pricing rate added successfully.");
                response.sendRedirect(request.getContextPath() + "/pricing");
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/pricing-form.jsp").forward(request, response);
            }

        } else if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("rateId"));
                Room.RoomType roomType = Room.RoomType.valueOf(request.getParameter("roomType").toUpperCase());
                String season = request.getParameter("season");
                double rate = Double.parseDouble(request.getParameter("ratePerNight"));
                String description = request.getParameter("description");
                pricingRateService.updateRate(id, roomType, season, rate, description);
                request.getSession().setAttribute("successMessage", "Pricing rate updated successfully.");
                response.sendRedirect(request.getContextPath() + "/pricing");
            } catch (Exception e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/pricing-form.jsp").forward(request, response);
            }
        }
    }
}

