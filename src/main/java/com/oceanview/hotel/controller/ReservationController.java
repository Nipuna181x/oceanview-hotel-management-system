package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.ReservationDAOImpl;
import com.oceanview.hotel.dao.RoomDAOImpl;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.Room;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.ReservationService;
import com.oceanview.hotel.service.RoomNotAvailableException;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet controller for reservation operations.
 * MVC Pattern — Controller handling all reservation-related HTTP requests.
 */
@WebServlet(urlPatterns = {"/reservations", "/reservations/new", "/reservations/*"})
public class ReservationController extends HttpServlet {

    private ReservationService reservationService;
    private com.oceanview.hotel.service.RoomService roomService;

    @Override
    public void init() throws ServletException {
        reservationService = new ReservationService(
                new ReservationDAOImpl(DBConnectionFactory.getConnection()),
                new RoomDAOImpl(DBConnectionFactory.getConnection())
        );
        roomService = new com.oceanview.hotel.service.RoomService(
                new RoomDAOImpl(DBConnectionFactory.getConnection())
        );
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if ("/reservations/new".equals(path)) {
            // Show new reservation form with available rooms
            List<Room> availableRooms = roomService.getAvailableRooms(null);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("today", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/view/reservation-form.jsp").forward(request, response);

        } else if (pathInfo != null && pathInfo.matches("/\\d+/cancel")) {
            // Cancel reservation
            int id = Integer.parseInt(pathInfo.split("/")[1]);
            try {
                reservationService.cancelReservation(id);
                response.sendRedirect(request.getContextPath() + "/reservations?msg=cancelled");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/reservations?error=" + e.getMessage());
            }

        } else if (pathInfo != null && pathInfo.matches("/\\d+/checkin")) {
            // Check in
            int id = Integer.parseInt(pathInfo.split("/")[1]);
            try {
                reservationService.checkIn(id);
                response.sendRedirect(request.getContextPath() + "/reservations/" +
                        reservationService.getById(id).getReservationNumber());
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/reservations");
            }

        } else if (pathInfo != null && pathInfo.matches("/\\d+/checkout")) {
            // Check out
            int id = Integer.parseInt(pathInfo.split("/")[1]);
            try {
                reservationService.checkOut(id);
                response.sendRedirect(request.getContextPath() + "/reservations/" +
                        reservationService.getById(id).getReservationNumber());
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/reservations");
            }

        } else if (pathInfo != null && pathInfo.length() > 1) {
            // View single reservation by reservation number
            String resNumber = pathInfo.substring(1);
            try {
                Reservation reservation = reservationService.getByReservationNumber(resNumber);
                request.setAttribute("reservation", reservation);
                request.getRequestDispatcher("/WEB-INF/view/reservation-details.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/reservations");
            }

        } else {
            // List all reservations
            List<Reservation> reservations = reservationService.getAllReservations();
            request.setAttribute("reservations", reservations);
            if ("cancelled".equals(request.getParameter("msg"))) {
                request.setAttribute("successMessage", "Reservation cancelled successfully.");
            }
            request.getRequestDispatcher("/WEB-INF/view/reservation-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = SessionUtil.getLoggedInUser(request);
        int createdBy = (user != null) ? user.getUserId() : 1;

        String guestName     = request.getParameter("guestName");
        String address       = request.getParameter("address");
        String contactNumber = request.getParameter("contactNumber");
        String email         = request.getParameter("email");
        String roomIdStr     = request.getParameter("roomId");
        String checkInStr    = request.getParameter("checkInDate");
        String checkOutStr   = request.getParameter("checkOutDate");

        try {
            int roomId = Integer.parseInt(roomIdStr);
            LocalDate checkIn  = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);

            String resNumber = reservationService.createReservation(
                    guestName, address, contactNumber, email,
                    roomId, checkIn, checkOut, createdBy
            );

            request.setAttribute("successMessage",
                    "Reservation created successfully! Number: " + resNumber);
            List<Room> availableRooms = roomService.getAvailableRooms(null);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("today", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/view/reservation-form.jsp").forward(request, response);

        } catch (RoomNotAvailableException e) {
            request.setAttribute("errorMessage", "Room is not available: " + e.getMessage());
            List<Room> availableRooms = roomService.getAvailableRooms(null);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("today", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/view/reservation-form.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            List<Room> availableRooms = roomService.getAvailableRooms(null);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("today", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/view/reservation-form.jsp").forward(request, response);
        }
    }
}

