package com.oceanview.hotel.api;

import org.glassfish.jersey.server.ResourceConfig;
import javax.ws.rs.ApplicationPath;

/**
 * JAX-RS Application entry point.
 * Registers all REST resources under /api/v1
 *
 * Design Pattern: Facade — all REST endpoints are registered here,
 * providing a single entry point to the distributed web service layer.
 */
@ApplicationPath("/api/v1")
public class RestApplication extends ResourceConfig {

    public RestApplication() {
        packages("com.oceanview.hotel.api");
    }
}

