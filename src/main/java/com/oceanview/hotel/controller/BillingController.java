package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.*;
import com.oceanview.hotel.model.Bill;
import com.oceanview.hotel.model.PricingRate;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.service.*;
import com.oceanview.hotel.util.LogUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet controller for billing operations.
 * Handles: bill history list, view single bill, generate bill page.
 */
@WebServlet("/billing/*")
public class BillingController extends HttpServlet {

    private BillingService billingService;
    private ReservationService reservationService;
    private PricingRateService pricingRateService;

    @Override
    public void init() throws ServletException {
        PricingRateDAOImpl pricingDAO = new PricingRateDAOImpl(DBConnectionFactory.getConnection());
        billingService = new BillingService(
                new BillDAOImpl(DBConnectionFactory.getConnection()),
                new ReservationDAOImpl(DBConnectionFactory.getConnection()),
                pricingDAO
        );
        reservationService = new ReservationService(
                new ReservationDAOImpl(DBConnectionFactory.getConnection()),
                new RoomDAOImpl(DBConnectionFactory.getConnection())
        );
        pricingRateService = new PricingRateService(pricingDAO);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // null, "/", "/view", "/generate"

        if (pathInfo == null || pathInfo.equals("/")) {
            // Bill history list
            List<Bill> bills = billingService.getAllBills();
            request.setAttribute("bills", bills);
            request.getRequestDispatcher("/WEB-INF/view/billing-list.jsp").forward(request, response);

        } else if (pathInfo.equals("/view")) {
            // View a single bill by billId
            String billIdStr = request.getParameter("billId");
            try {
                int billId = Integer.parseInt(billIdStr);
                Bill bill = billingService.getBillById(billId);
                // Load full reservation for display
                Reservation reservation = reservationService.getById(bill.getReservationId());
                request.setAttribute("bill", bill);
                request.setAttribute("reservation", reservation);
                request.getRequestDispatcher("/WEB-INF/view/billing-view.jsp").forward(request, response);
            } catch (BillNotFoundException e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/billing-list.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/billing");
            }

        } else if (pathInfo.equals("/generate")) {
            // Load strategies and unbilled reservations
            request.setAttribute("unbilledReservations", billingService.getUnbilledReservations());
            request.setAttribute("strategies", pricingRateService.getAllStrategies());
            // Pre-fill reservationId if passed via query param (e.g. from reservation details page)
            String preselect = request.getParameter("reservationId");
            if (preselect != null && !preselect.isEmpty()) {
                request.setAttribute("preselectedReservationId", preselect);
            }
            request.getRequestDispatcher("/WEB-INF/view/billing-generate.jsp").forward(request, response);

        } else if (pathInfo.equals("/for-reservation")) {
            // Smart redirect from reservation details:
            // If bill already exists → go to bill view; otherwise → go to generate page with ID pre-filled
            String resIdStr = request.getParameter("reservationId");
            try {
                int reservationId = Integer.parseInt(resIdStr);
                Bill existing = billingService.getBillByReservationId(reservationId);
                // Bill exists — redirect to view it
                response.sendRedirect(request.getContextPath() + "/billing/view?billId=" + existing.getBillId());
            } catch (BillNotFoundException e) {
                // No bill yet — redirect to generate page with reservationId pre-filled
                response.sendRedirect(request.getContextPath() + "/billing/generate?reservationId=" + resIdStr);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/billing/generate");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/billing");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if ("/generate".equals(pathInfo)) {
            String reservationIdStr = request.getParameter("reservationId");
            String strategyIdStr = request.getParameter("strategyId");

            try {
                int reservationId = Integer.parseInt(reservationIdStr);
                int strategyId = Integer.parseInt(strategyIdStr);

                Bill bill = billingService.generateBill(reservationId, strategyId);
                LogUtil.log(request, "GENERATE_BILL", "Generated bill for reservation ID: " + reservationId + " | Total: Rs." + bill.getTotalAmount() + " | Strategy: " + bill.getPricingStrategyUsed());
                Reservation reservation = reservationService.getById(reservationId);
                request.setAttribute("bill", bill);
                request.setAttribute("reservation", reservation);
                request.setAttribute("successMessage", "Bill generated successfully!");
                request.getRequestDispatcher("/WEB-INF/view/billing-view.jsp").forward(request, response);
            } catch (ReservationNotFoundException e) {
                request.setAttribute("errorMessage", "Reservation not found: " + reservationIdStr);
                request.setAttribute("unbilledReservations", billingService.getUnbilledReservations());
                request.setAttribute("strategies", pricingRateService.getAllStrategies());
                request.getRequestDispatcher("/WEB-INF/view/billing-generate.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.setAttribute("unbilledReservations", billingService.getUnbilledReservations());
                request.setAttribute("strategies", pricingRateService.getAllStrategies());
                request.getRequestDispatcher("/WEB-INF/view/billing-generate.jsp").forward(request, response);
            }
        }
    }
}
