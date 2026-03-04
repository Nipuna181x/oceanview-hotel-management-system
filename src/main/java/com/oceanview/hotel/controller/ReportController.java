package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.*;
import com.oceanview.hotel.model.ReportHistory;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.ReportService;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Servlet controller for reports.
 */
@WebServlet(urlPatterns = {"/reports", "/reports/*"})
public class ReportController extends HttpServlet {

    private ReportService reportService;

    @Override
    public void init() throws ServletException {
        reportService = new ReportService(
                new ReservationDAOImpl(DBConnectionFactory.getConnection()),
                new BillDAOImpl(DBConnectionFactory.getConnection()),
                new ReportHistoryDAOImpl(DBConnectionFactory.getConnection())
        );
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // null, "/view", "/delete"

        // ── VIEW a saved report ──
        if ("/view".equals(pathInfo)) {
            String idStr = request.getParameter("id");
            try {
                int reportId = Integer.parseInt(idStr);
                ReportHistory report = reportService.getReportById(reportId);
                request.setAttribute("report", report);
                request.getRequestDispatcher("/WEB-INF/view/report-view.jsp").forward(request, response);
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Report not found.");
                response.sendRedirect(request.getContextPath() + "/reports");
            }
            return;
        }

        // ── DELETE a saved report ──
        if ("/delete".equals(pathInfo)) {
            String idStr = request.getParameter("id");
            try {
                int reportId = Integer.parseInt(idStr);
                reportService.deleteReport(reportId);
                request.getSession().setAttribute("successMessage", "Report deleted successfully.");
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Could not delete report: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/reports");
            return;
        }

        // ── MAIN reports page ──
        String from = request.getParameter("from");
        String to   = request.getParameter("to");

        // Flash messages from redirect
        String flashSuccess = (String) request.getSession().getAttribute("successMessage");
        String flashError   = (String) request.getSession().getAttribute("errorMessage");
        if (flashSuccess != null) { request.setAttribute("successMessage", flashSuccess); request.getSession().removeAttribute("successMessage"); }
        if (flashError   != null) { request.setAttribute("errorMessage",   flashError);   request.getSession().removeAttribute("errorMessage"); }

        // Always load report history
        request.setAttribute("reportHistory", reportService.getReportHistory());

        if (from != null && to != null && !from.isEmpty() && !to.isEmpty()) {
            try {
                LocalDate startDate = LocalDate.parse(from);
                LocalDate endDate   = LocalDate.parse(to);

                List<Reservation> reservations = reportService.getOccupancyReport(startDate, endDate);
                Map<String, Object> summary    = reportService.getRevenueSummary(startDate, endDate);

                request.setAttribute("reservations", reservations);
                request.setAttribute("summary", summary);

                // Save report to history
                User user = SessionUtil.getLoggedInUser(request);
                int generatedBy = (user != null) ? user.getUserId() : 1;
                reportService.saveReportHistory(summary, startDate, endDate, generatedBy);

                // Reload history so new entry shows immediately
                request.setAttribute("reportHistory", reportService.getReportHistory());

            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
            }
        }

        request.getRequestDispatcher("/WEB-INF/view/reports.jsp").forward(request, response);
    }
}
