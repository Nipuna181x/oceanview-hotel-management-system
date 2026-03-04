package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.PricingRateDAOImpl;
import com.oceanview.hotel.model.PricingRate;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.PricingRateService;
import com.oceanview.hotel.util.LogUtil;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// Pricing rate CRUD — admin only
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

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                request.setAttribute("strategies", pricingRateService.getAllStrategies());
                request.getRequestDispatcher("/WEB-INF/view/pricing-list.jsp").forward(request, response);

            } else if (pathInfo.equals("/new")) {
                request.getRequestDispatcher("/WEB-INF/view/pricing-form.jsp").forward(request, response);

            } else if (pathInfo.equals("/edit")) {
                int id = Integer.parseInt(request.getParameter("id"));
                PricingRate strategy = pricingRateService.getById(id);
                request.setAttribute("strategy", strategy);
                request.getRequestDispatcher("/WEB-INF/view/pricing-form.jsp").forward(request, response);

            } else if (pathInfo.equals("/delete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                pricingRateService.deleteStrategy(id);
                LogUtil.log(request, "DELETE_STRATEGY", "Deleted pricing strategy ID: " + id);
                request.getSession().setAttribute("successMessage", "Pricing strategy deleted successfully.");
                response.sendRedirect(request.getContextPath() + "/pricing");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Pricing error: " + e.getClass().getSimpleName() + " — " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request, response)) return;

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            try {
                String name = request.getParameter("name");
                PricingRate.AdjustmentType adjustmentType =
                        PricingRate.AdjustmentType.valueOf(request.getParameter("adjustmentType").toUpperCase());
                double adjustmentPercent = Double.parseDouble(request.getParameter("adjustmentPercent"));
                String description = request.getParameter("description");
                boolean isDefault = "on".equals(request.getParameter("isDefault"));

                pricingRateService.addStrategy(name, adjustmentType, adjustmentPercent, description, isDefault);
                LogUtil.log(request, "CREATE_STRATEGY", "Created pricing strategy: " + name + " [" + adjustmentType + " " + adjustmentPercent + "%]");
                request.getSession().setAttribute("successMessage", "Pricing strategy added successfully.");
                response.sendRedirect(request.getContextPath() + "/pricing");
            } catch (Exception e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/pricing-form.jsp").forward(request, response);
            }

        } else if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("strategyId"));
                String name = request.getParameter("name");
                PricingRate.AdjustmentType adjustmentType =
                        PricingRate.AdjustmentType.valueOf(request.getParameter("adjustmentType").toUpperCase());
                double adjustmentPercent = Double.parseDouble(request.getParameter("adjustmentPercent"));
                String description = request.getParameter("description");
                boolean isDefault = "on".equals(request.getParameter("isDefault"));

                pricingRateService.updateStrategy(id, name, adjustmentType, adjustmentPercent, description, isDefault);
                LogUtil.log(request, "UPDATE_STRATEGY", "Updated pricing strategy ID: " + id + " -> " + name);
                request.getSession().setAttribute("successMessage", "Pricing strategy updated successfully.");
                response.sendRedirect(request.getContextPath() + "/pricing");
            } catch (Exception e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/pricing-form.jsp").forward(request, response);
            }
        }
    }
}
