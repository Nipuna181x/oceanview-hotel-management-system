package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.RoomDAOImpl;
import com.oceanview.hotel.model.Room;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.RoomService;
import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet controller for room management.
 * Viewing: all users. Add/Edit/Delete: Admin only.
 */
@WebServlet("/rooms/*")
public class RoomController extends HttpServlet {

    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        roomService = new RoomService(new RoomDAOImpl(DBConnectionFactory.getConnection()));
    }

    private boolean isAdmin(HttpServletRequest request) {
        User user = SessionUtil.getLoggedInUser(request);
        return user != null && User.Role.ADMIN.equals(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // null, "/", "/new", "/edit", "/delete"

        if (pathInfo == null || pathInfo.equals("/")) {
            // Room list — all users
            String typeParam = request.getParameter("type");
            List<Room> rooms;
            if (typeParam != null && !typeParam.isEmpty()) {
                try {
                    Room.RoomType type = Room.RoomType.valueOf(typeParam.toUpperCase());
                    rooms = roomService.getAvailableRooms(type);
                } catch (IllegalArgumentException e) {
                    rooms = roomService.getAllRooms();
                }
            } else {
                rooms = roomService.getAllRooms();
            }
            request.setAttribute("rooms", rooms);
            request.setAttribute("isAdmin", isAdmin(request));
            request.getRequestDispatcher("/WEB-INF/view/rooms.jsp").forward(request, response);

        } else if (pathInfo.equals("/new")) {
            if (!isAdmin(request)) { response.sendRedirect(request.getContextPath() + "/rooms"); return; }
            request.getRequestDispatcher("/WEB-INF/view/room-form.jsp").forward(request, response);

        } else if (pathInfo.equals("/edit")) {
            if (!isAdmin(request)) { response.sendRedirect(request.getContextPath() + "/rooms"); return; }
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Room room = roomService.getRoomById(id);
                request.setAttribute("room", room);
                request.getRequestDispatcher("/WEB-INF/view/room-form.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/rooms");
            }

        } else if (pathInfo.equals("/delete")) {
            if (!isAdmin(request)) { response.sendRedirect(request.getContextPath() + "/rooms"); return; }
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                roomService.deleteRoom(id);
                request.getSession().setAttribute("successMessage", "Room deleted successfully.");
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/rooms");

        } else {
            response.sendRedirect(request.getContextPath() + "/rooms");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) { response.sendRedirect(request.getContextPath() + "/rooms"); return; }

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            String roomNumber = request.getParameter("roomNumber");
            String roomTypeStr = request.getParameter("roomType");
            String maxOccStr = request.getParameter("maxOccupancy");
            String rateStr = request.getParameter("ratePerNight");
            String description = request.getParameter("description");
            String availStr = request.getParameter("available");
            try {
                Room.RoomType roomType = Room.RoomType.valueOf(roomTypeStr.toUpperCase());
                int maxOcc = Integer.parseInt(maxOccStr);
                double rate = Double.parseDouble(rateStr);
                boolean available = "true".equals(availStr);
                roomService.addRoom(roomNumber, roomType, maxOcc, rate, description, available);
                request.getSession().setAttribute("successMessage", "Room " + roomNumber + " added successfully.");
                response.sendRedirect(request.getContextPath() + "/rooms");
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/room-form.jsp").forward(request, response);
            }

        } else if ("update".equals(action)) {
            String idStr = request.getParameter("roomId");
            String roomNumber = request.getParameter("roomNumber");
            String roomTypeStr = request.getParameter("roomType");
            String maxOccStr = request.getParameter("maxOccupancy");
            String rateStr = request.getParameter("ratePerNight");
            String description = request.getParameter("description");
            String availStr = request.getParameter("available");
            try {
                int id = Integer.parseInt(idStr);
                Room.RoomType roomType = Room.RoomType.valueOf(roomTypeStr.toUpperCase());
                int maxOcc = Integer.parseInt(maxOccStr);
                double rate = Double.parseDouble(rateStr);
                boolean available = "true".equals(availStr);
                roomService.updateRoom(id, roomNumber, roomType, maxOcc, rate, description, available);
                request.getSession().setAttribute("successMessage", "Room updated successfully.");
                response.sendRedirect(request.getContextPath() + "/rooms");
            } catch (Exception e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/room-form.jsp").forward(request, response);
            }
        }
    }
}

