package com.oceanview.hotel.api;

import com.oceanview.hotel.dao.BillDAOImpl;
import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.dao.PricingRateDAOImpl;
import com.oceanview.hotel.dao.ReservationDAOImpl;
import com.oceanview.hotel.model.Bill;
import com.oceanview.hotel.service.BillNotFoundException;
import com.oceanview.hotel.service.BillingService;
import com.oceanview.hotel.service.ReservationNotFoundException;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.HashMap;
import java.util.Map;

/**
 * REST resource for billing endpoints.
 * POST /api/v1/billing/{reservationId}/generate — generate bill
 * GET  /api/v1/billing/{reservationId}          — get existing bill
 */
@Path("/billing")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class BillingResource {

    private final BillingService billingService;

    public BillingResource() {
        this.billingService = new BillingService(
                new BillDAOImpl(DBConnectionFactory.getConnection()),
                new ReservationDAOImpl(DBConnectionFactory.getConnection()),
                new PricingRateDAOImpl(DBConnectionFactory.getConnection())
        );
    }

    @POST
    @Path("/{reservationId}/generate")
    public Response generateBill(@PathParam("reservationId") int reservationId,
                                 Map<String, String> body) {
        try {
            int strategyId = 1; // default
            if (body != null && body.get("strategyId") != null) {
                strategyId = Integer.parseInt(body.get("strategyId"));
            }

            Bill bill = billingService.generateBill(reservationId, strategyId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("billId", bill.getBillId());
            result.put("reservationId", bill.getReservationId());
            result.put("numNights", bill.getNumNights());
            result.put("ratePerNight", bill.getRatePerNight());
            result.put("subtotal", bill.getSubtotal());
            result.put("taxAmount", bill.getTaxAmount());
            result.put("totalAmount", bill.getTotalAmount());
            result.put("pricingStrategy", bill.getPricingStrategyUsed());
            return Response.status(Response.Status.CREATED).entity(result).build();

        } catch (ReservationNotFoundException e) {
            return buildError(Response.Status.NOT_FOUND, e.getMessage());
        } catch (IllegalArgumentException e) {
            return buildError(Response.Status.BAD_REQUEST, e.getMessage());
        }
    }

    @GET
    @Path("/{reservationId}")
    public Response getBill(@PathParam("reservationId") int reservationId) {
        try {
            Bill bill = billingService.getBillByReservationId(reservationId);
            return Response.ok(bill).build();
        } catch (BillNotFoundException e) {
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

