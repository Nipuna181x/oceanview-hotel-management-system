package com.oceanview.hotel.util;

import com.oceanview.hotel.model.User;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Utility class for managing HTTP sessions and cookies.
 *
 * Sessions store the logged-in user server-side.
 * A "remember me" cookie stores the username client-side (non-sensitive).
 *
 * Design Pattern: Utility / Helper class
 */
public class SessionUtil {

    public static final String SESSION_USER_KEY = "loggedInUser";
    public static final String COOKIE_USERNAME = "oceanview_user";
    private static final int COOKIE_MAX_AGE = 7 * 24 * 60 * 60; // 7 days in seconds

    private SessionUtil() {
    }

    /**
     * Store the authenticated user in the HTTP session.
     * @param request the HTTP request
     * @param user    the authenticated user
     */
    public static void setLoggedInUser(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute(SESSION_USER_KEY, user);
        session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout
    }

    /**
     * Retrieve the logged-in user from the session.
     * @param request the HTTP request
     * @return the logged-in User, or null if not authenticated
     */
    public static User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute(SESSION_USER_KEY);
    }

    /**
     * Check if a user is currently logged in.
     * @param request the HTTP request
     * @return true if a user session exists
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoggedInUser(request) != null;
    }

    /**
     * Invalidate the session (logout).
     * @param request  the HTTP request
     * @param response the HTTP response
     */
    public static void logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Clear remember-me cookie
        Cookie cookie = new Cookie(COOKIE_USERNAME, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    /**
     * Set a remember-me cookie with the username.
     * @param response the HTTP response
     * @param username the username to store
     */
    public static void setRememberMeCookie(HttpServletResponse response, String username) {
        Cookie cookie = new Cookie(COOKIE_USERNAME, username);
        cookie.setMaxAge(COOKIE_MAX_AGE);
        cookie.setPath("/");
        cookie.setHttpOnly(true); // Prevent JavaScript access
        response.addCookie(cookie);
    }

    /**
     * Get the remembered username from cookie, if present.
     * @param request the HTTP request
     * @return the username from cookie, or null
     */
    public static String getRememberedUsername(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (COOKIE_USERNAME.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
}

