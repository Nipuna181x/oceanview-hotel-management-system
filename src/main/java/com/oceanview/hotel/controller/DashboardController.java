package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.*;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

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

        try {
            RoomDAO roomDAO = new RoomDAOImpl(DBConnectionFactory.getConnection());
            ReservationDAO resDAO = new ReservationDAOImpl(DBConnectionFactory.getConnection());
            BillDAO billDAO = new BillDAOImpl(DBConnectionFactory.getConnection());

            int totalRooms = roomDAO.findAll().size();
            List<Reservation> allRes = resDAO.findAll();
            long active = allRes.stream().filter(r ->
                r.getStatus() == Reservation.Status.CONFIRMED || r.getStatus() == Reservation.Status.CHECKED_IN
            ).count();
            long pending = allRes.stream().filter(r -> r.getStatus() == Reservation.Status.CONFIRMED).count();
            int totalBills = billDAO.findAll().size();

            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("activeReservations", active);
            request.setAttribute("pendingCheckins", pending);
            request.setAttribute("totalBills", totalBills);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/view/dashboard.jsp").forward(request, response);
    }
}
