package com.oceanview.hotel.api;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.RoomDAOImpl;
import com.oceanview.hotel.model.Room;
import com.oceanview.hotel.service.RoomService;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST resource for room endpoints.
 * GET /api/v1/rooms           — list all rooms (optional ?type=&available=)
 * GET /api/v1/rooms/{id}      — get a specific room
 */
@Path("/rooms")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class RoomResource {

    private final RoomService roomService;

    public RoomResource() {
        this.roomService = new RoomService(
                new RoomDAOImpl(DBConnectionFactory.getConnection())
        );
    }

    @GET
    public Response getRooms(@QueryParam("type") String type,
                             @QueryParam("available") Boolean available) {
        try {
            List<Room> rooms;
            if (Boolean.TRUE.equals(available)) {
                Room.RoomType roomType = (type != null) ? Room.RoomType.valueOf(type.toUpperCase()) : null;
                rooms = roomService.getAvailableRooms(roomType);
            } else {
                rooms = roomService.getAllRooms();
            }
            return Response.ok(rooms).build();
        } catch (IllegalArgumentException e) {
            return buildError(Response.Status.BAD_REQUEST, e.getMessage());
        }
    }

    @GET
    @Path("/{id}")
    public Response getRoomById(@PathParam("id") int id) {
        try {
            Room room = roomService.getRoomById(id);
            return Response.ok(room).build();
        } catch (IllegalArgumentException e) {
            return buildError(Response.Status.NOT_FOUND, e.getMessage());
        }
    }

    private Response buildError(Response.Status status, String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        return Response.status(status).entity(error).build();
    }
}

