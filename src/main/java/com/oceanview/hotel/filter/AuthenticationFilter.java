package com.oceanview.hotel.filter;

import com.oceanview.hotel.util.SessionUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet filter that protects all application URLs except login.
 *
 * If a request arrives for any protected resource without a valid session,
 * the user is redirected to the login page.
 *
 * Design Pattern: Chain of Responsibility (Servlet Filter chain)
 */
@WebFilter(urlPatterns = {"/dashboard", "/reservations/*", "/billing/*",
        "/rooms/*", "/reports/*", "/help", "/api/v1/*", "/staff/*", "/pricing/*", "/logs/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialisation needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        if (SessionUtil.isLoggedIn(httpRequest)) {
            // User is authenticated — continue the chain
            chain.doFilter(request, response);
        } else {
            // Not authenticated — redirect to login
            String contextPath = httpRequest.getContextPath();
            httpResponse.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

