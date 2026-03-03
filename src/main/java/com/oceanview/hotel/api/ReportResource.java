package com.oceanview.hotel.api;

import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.ReservationDAOImpl;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.service.ReportService;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST resource for reporting endpoints.
 * GET /api/v1/reports/occupancy?from=&to= — occupancy report
 * GET /api/v1/reports/revenue?from=&to=   — revenue summary
 */
@Path("/reports")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ReportResource {

    private final ReportService reportService;

    public ReportResource() {
        this.reportService = new ReportService(
                new ReservationDAOImpl(DBConnectionFactory.getConnection())
        );
    }

    @GET
    @Path("/occupancy")
    public Response getOccupancyReport(@QueryParam("from") String from,
                                       @QueryParam("to") String to) {
        try {
            LocalDate startDate = (from != null) ? LocalDate.parse(from) : LocalDate.now().withDayOfMonth(1);
            LocalDate endDate   = (to   != null) ? LocalDate.parse(to)   : LocalDate.now();

            List<Reservation> report = reportService.getOccupancyReport(startDate, endDate);

            Map<String, Object> result = new HashMap<>();
            result.put("startDate", startDate.toString());
            result.put("endDate", endDate.toString());
            result.put("totalReservations", report.size());
            result.put("reservations", report);
            return Response.ok(result).build();

        } catch (IllegalArgumentException e) {
            return buildError(Response.Status.BAD_REQUEST, e.getMessage());
        }
    }

    @GET
    @Path("/revenue")
    public Response getRevenueSummary(@QueryParam("from") String from,
                                      @QueryParam("to") String to) {
        try {
            LocalDate startDate = (from != null) ? LocalDate.parse(from) : LocalDate.now().withDayOfMonth(1);
            LocalDate endDate   = (to   != null) ? LocalDate.parse(to)   : LocalDate.now();

            Map<String, Object> summary = reportService.getRevenueSummary(startDate, endDate);
            return Response.ok(summary).build();

        } catch (IllegalArgumentException e) {
            return buildError(Response.Status.BAD_REQUEST, e.getMessage());
        }
    }

    private Response buildError(Response.Status status, String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        return Response.status(status).entity(error).build();
    }
}

