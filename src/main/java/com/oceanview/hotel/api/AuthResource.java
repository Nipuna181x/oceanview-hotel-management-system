package com.oceanview.hotel.api;

import com.oceanview.hotel.dao.UserDAOImpl;
import com.oceanview.hotel.dao.DBConnectionFactory;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.AuthService;
import com.oceanview.hotel.service.InvalidCredentialsException;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.HashMap;
import java.util.Map;

/**
 * REST resource for authentication endpoints.
 * POST /api/v1/auth/login  — authenticate and create session
 * POST /api/v1/auth/logout — invalidate session
 */
@Path("/auth")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AuthResource {

    private final AuthService authService;

    public AuthResource() {
        this.authService = new AuthService(
                new UserDAOImpl(DBConnectionFactory.getConnection())
        );
    }

    @POST
    @Path("/login")
    public Response login(Map<String, String> credentials,
                          @Context HttpServletRequest request) {
        try {
            String username = credentials.get("username");
            String password = credentials.get("password");

            User user = authService.login(username, password);

            // Store in session
            request.getSession(true).setAttribute("loggedInUser", user);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("username", user.getUsername());
            result.put("role", user.getRole().name());
            result.put("message", "Login successful");

            return Response.ok(result).build();

        } catch (IllegalArgumentException e) {
            return buildError(Response.Status.BAD_REQUEST, e.getMessage());
        } catch (InvalidCredentialsException e) {
            return buildError(Response.Status.UNAUTHORIZED, "Invalid username or password");
        }
    }

    @POST
    @Path("/logout")
    public Response logout(@Context HttpServletRequest request) {
        request.getSession(false);
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "Logged out successfully");
        return Response.ok(result).build();
    }

    private Response buildError(Response.Status status, String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        return Response.status(status).entity(error).build();
    }
}

