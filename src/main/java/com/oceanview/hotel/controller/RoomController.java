package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.RoomDAOImpl;
import com.oceanview.hotel.model.Room;
import com.oceanview.hotel.service.RoomService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet controller for room management.
 */
@WebServlet("/rooms")
public class RoomController extends HttpServlet {

    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        roomService = new RoomService(new RoomDAOImpl(DBConnectionFactory.getConnection()));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
        request.getRequestDispatcher("/WEB-INF/view/rooms.jsp").forward(request, response);
    }
}

