package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.UserDAO;
import com.oceanview.hotel.model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Service class handling user authentication and password operations.
 *
 * Design Patterns used:
 * - Service Layer / Facade: encapsulates all authentication business logic
 *   so controllers and REST resources only call this class.
 *
 * BCrypt is used for password hashing — industry standard, salted,
 * one-way hash. Each hash is unique even for the same password.
 */
public class AuthService {

    private final UserDAO userDAO;

    public AuthService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    /**
     * Authenticate a user with username and password.
     *
     * @param username the username
     * @param password the plain-text password
     * @return the authenticated User object
     * @throws IllegalArgumentException     if username or password is null/empty
     * @throws InvalidCredentialsException  if credentials are incorrect
     */
    public User login(String username, String password) {
        // Validate inputs
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }

        // Look up user
        User user = userDAO.findByUsername(username.trim());
        if (user == null) {
            throw new InvalidCredentialsException("Invalid username or password");
        }

        // Verify password against BCrypt hash
        if (!BCrypt.checkpw(password, user.getPasswordHash())) {
            throw new InvalidCredentialsException("Invalid username or password");
        }

        return user;
    }

    /**
     * Hash a plain-text password using BCrypt.
     *
     * @param plainPassword the password to hash
     * @return BCrypt hashed password string
     */
    public String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Check if a plain-text password matches a BCrypt hash.
     *
     * @param plainPassword the plain-text password to check
     * @param hashedPassword the BCrypt hash to check against
     * @return true if password matches, false otherwise
     */
    public boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    /**
     * Check if a user has the ADMIN role.
     *
     * @param user the user to check
     * @return true if user is ADMIN, false otherwise
     */
    public boolean isAdmin(User user) {
        if (user == null) {
            return false;
        }
        return User.Role.ADMIN.equals(user.getRole());
    }
}

