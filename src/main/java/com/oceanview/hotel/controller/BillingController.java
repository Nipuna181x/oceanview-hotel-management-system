package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.BillDAOImpl;
import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.ReservationDAOImpl;
import com.oceanview.hotel.model.Bill;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.service.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet controller for billing operations.
 */
@WebServlet("/billing")
public class BillingController extends HttpServlet {

    private BillingService billingService;
    private ReservationService reservationService;

    @Override
    public void init() throws ServletException {
        billingService = new BillingService(
                new BillDAOImpl(DBConnectionFactory.getConnection()),
                new ReservationDAOImpl(DBConnectionFactory.getConnection())
        );
        reservationService = new ReservationService(
                new ReservationDAOImpl(DBConnectionFactory.getConnection()),
                new com.oceanview.hotel.dao.RoomDAOImpl(DBConnectionFactory.getConnection())
        );
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reservationIdStr = request.getParameter("reservationId");
        String strategy = request.getParameter("strategy");
        if (strategy == null || strategy.isEmpty()) strategy = "STANDARD";

        if (reservationIdStr != null && !reservationIdStr.isEmpty()) {
            try {
                int reservationId = Integer.parseInt(reservationIdStr);
                Bill bill = billingService.generateBill(reservationId, strategy);
                Reservation reservation = reservationService.getById(reservationId);
                request.setAttribute("bill", bill);
                request.setAttribute("reservation", reservation);
            } catch (ReservationNotFoundException e) {
                request.setAttribute("errorMessage", "Reservation not found with ID: " + reservationIdStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
            }
        }

        request.getRequestDispatcher("/WEB-INF/view/billing.jsp").forward(request, response);
    }
}

