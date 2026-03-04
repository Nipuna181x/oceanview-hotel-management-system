package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.*;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.Room;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// Dashboard — loads stats and forwards to dashboard.jsp
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

            List<Room> allRooms = roomDAO.findAll();
            int totalRooms = allRooms.size();
            long availableRooms = allRooms.stream().filter(Room::isAvailable).count();
            long occupiedRooms = totalRooms - availableRooms;

            List<Reservation> allRes = resDAO.findAll();
            long active = allRes.stream().filter(r ->
                r.getStatus() == Reservation.Status.CONFIRMED || r.getStatus() == Reservation.Status.CHECKED_IN
            ).count();
            long pending = allRes.stream().filter(r -> r.getStatus() == Reservation.Status.CONFIRMED).count();
            int totalBills = billDAO.findAll().size();

            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("occupiedRooms", occupiedRooms);
            request.setAttribute("activeReservations", active);
            request.setAttribute("pendingCheckins", pending);
            request.setAttribute("totalBills", totalBills);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/view/dashboard.jsp").forward(request, response);
    }
}
