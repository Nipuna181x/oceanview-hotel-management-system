package com.oceanview.hotel.api;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.ReservationDAOImpl;
import com.oceanview.hotel.dao.RoomDAOImpl;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.ReservationNotFoundException;
import com.oceanview.hotel.service.ReservationService;
import com.oceanview.hotel.service.RoomNotAvailableException;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST resource for reservation endpoints.
 * POST /api/v1/reservations              — create reservation
 * GET  /api/v1/reservations              — list all reservations
 * GET  /api/v1/reservations/{resNumber}  — get by reservation number
 * PUT  /api/v1/reservations/{id}/cancel  — cancel reservation
 * PUT  /api/v1/reservations/{id}/checkout — check out guest
 */
@Path("/reservations")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ReservationResource {

    private final ReservationService reservationService;

    public ReservationResource() {
        this.reservationService = new ReservationService(
                new ReservationDAOImpl(DBConnectionFactory.getConnection()),
                new RoomDAOImpl(DBConnectionFactory.getConnection())
        );
    }

    @POST
    public Response createReservation(Map<String, String> body,
                                      @Context HttpServletRequest request) {
        try {
            User loggedInUser = (User) request.getSession(false).getAttribute("loggedInUser");
            int createdBy = (loggedInUser != null) ? loggedInUser.getUserId() : 1;

            String resNumber = reservationService.createReservation(
                    body.get("guestName"),
                    body.get("address"),
                    body.get("contactNumber"),
                    body.get("email"),
                    body.get("nic"),
                    body.get("numGuests") != null ? Integer.parseInt(body.get("numGuests")) : 1,
                    Integer.parseInt(body.get("roomId")),
                    LocalDate.parse(body.get("checkInDate")),
                    LocalDate.parse(body.get("checkOutDate")),
                    createdBy
            );

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("reservationNumber", resNumber);
            result.put("message", "Reservation created successfully");
            return Response.status(Response.Status.CREATED).entity(result).build();

        } catch (IllegalArgumentException e) {
            return buildError(Response.Status.BAD_REQUEST, e.getMessage());
        } catch (RoomNotAvailableException e) {
            return buildError(Response.Status.CONFLICT, e.getMessage());
        } catch (Exception e) {
            return buildError(Response.Status.INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    }

    @GET
    public Response getAllReservations() {
        List<Reservation> reservations = reservationService.getAllReservations();
        return Response.ok(reservations).build();
    }

    @GET
    @Path("/{reservationNumber}")
    public Response getByReservationNumber(@PathParam("reservationNumber") String reservationNumber) {
        try {
            Reservation reservation = reservationService.getByReservationNumber(reservationNumber);
            return Response.ok(reservation).build();
        } catch (ReservationNotFoundException e) {
            return buildError(Response.Status.NOT_FOUND, e.getMessage());
        }
    }

    @PUT
    @Path("/{id}/cancel")
    public Response cancelReservation(@PathParam("id") int id) {
        try {
            reservationService.cancelReservation(id);
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Reservation cancelled successfully");
            return Response.ok(result).build();
        } catch (ReservationNotFoundException e) {
            return buildError(Response.Status.NOT_FOUND, e.getMessage());
        } catch (IllegalStateException e) {
            return buildError(Response.Status.CONFLICT, e.getMessage());
        }
    }

    @PUT
    @Path("/{id}/checkout")
    public Response checkOut(@PathParam("id") int id) {
        try {
            reservationService.checkOut(id);
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Guest checked out successfully");
            return Response.ok(result).build();
        } catch (ReservationNotFoundException e) {
            return buildError(Response.Status.NOT_FOUND, e.getMessage());
        } catch (IllegalStateException e) {
            return buildError(Response.Status.CONFLICT, e.getMessage());
        }
    }

    private Response buildError(Response.Status status, String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        return Response.status(status).entity(error).build();
    }
}

