package com.oceanview.hotel.util;

import com.oceanview.hotel.model.User;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Session and remember-me cookie helpers
public class SessionUtil {

    public static final String SESSION_USER_KEY = "loggedInUser";
    public static final String COOKIE_USERNAME = "oceanview_user";
    private static final int COOKIE_MAX_AGE = 7 * 24 * 60 * 60; // 7 days

    private SessionUtil() {}

    public static void setLoggedInUser(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute(SESSION_USER_KEY, user);
        session.setMaxInactiveInterval(30 * 60); // 30 min timeout
    }

    public static User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute(SESSION_USER_KEY);
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoggedInUser(request) != null;
    }

    public static void logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();

        // Clear the remember-me cookie
        Cookie cookie = new Cookie(COOKIE_USERNAME, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    public static void setRememberMeCookie(HttpServletResponse response, String username) {
        Cookie cookie = new Cookie(COOKIE_USERNAME, username);
        cookie.setMaxAge(COOKIE_MAX_AGE);
        cookie.setPath("/");
        cookie.setHttpOnly(true); // JS can't touch this
        response.addCookie(cookie);
    }

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
