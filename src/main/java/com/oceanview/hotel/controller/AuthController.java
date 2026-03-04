package com.oceanview.hotel.controller;

import com.oceanview.hotel.dao.UserDAOImpl;
import com.oceanview.hotel.model.User;
import com.oceanview.hotel.service.AuthService;
import com.oceanview.hotel.service.InvalidCredentialsException;
import com.oceanview.hotel.util.LogUtil;
import com.oceanview.hotel.util.SessionUtil;
import com.oceanview.hotel.dao.DBConnectionFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// Handles login and logout
@WebServlet(urlPatterns = {"/login", "/logout"})
public class AuthController extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService(
                new UserDAOImpl(DBConnectionFactory.getConnection())
        );
    }

    // GET /login shows the form; GET /logout clears the session
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            LogUtil.log(request, "LOGOUT", "User logged out");
            SessionUtil.logout(request, response);
            response.sendRedirect(request.getContextPath() + "/login?message=loggedout");
            return;
        }

        // Already logged in — skip the login page
        if (SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Pre-fill username if remember-me cookie exists
        String rememberedUser = SessionUtil.getRememberedUsername(request);
        if (rememberedUser != null) {
            request.setAttribute("rememberedUsername", rememberedUser);
        }

        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }

    // POST /login — validate credentials and create session
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        try {
            User user = authService.login(username, password);

            SessionUtil.setLoggedInUser(request, user);
            LogUtil.log(request, "LOGIN", "User logged in: " + username + " [" + user.getRole() + "]");

            if ("on".equals(rememberMe)) {
                SessionUtil.setRememberMeCookie(response, username);
            }

            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);

        } catch (InvalidCredentialsException e) {
            LogUtil.log(request, "LOGIN_FAILED", "Failed login attempt for username: " + username);
            request.setAttribute("errorMessage", "Invalid username or password. Please try again.");
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }
}
