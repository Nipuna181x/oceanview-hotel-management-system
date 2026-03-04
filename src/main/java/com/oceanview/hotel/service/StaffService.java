package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.UserDAO;
import com.oceanview.hotel.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;

/**
 * Service class for staff management business logic.
 *
 * Design Patterns:
 * - Service Layer / Facade: single entry point for all staff operations.
 * - DAO: delegates persistence to UserDAO interface.
 *
 * Only ADMIN users should be allowed to call these methods
 * (enforced at the controller / filter level).
 */
public class StaffService {

    private final UserDAO userDAO;

    public StaffService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    /**
     * Create a new staff account.
     *
     * @param username plain username (must be unique)
     * @param password plain-text password (will be BCrypt-hashed)
     * @param fullName staff member's full name
     * @param email    staff member's email address
     * @return true if created successfully
     * @throws IllegalArgumentException if validation fails or username taken
     */
    public boolean createStaff(String username, String password, String fullName, String email) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be blank");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be blank");
        }
        if (userDAO.findByUsername(username.trim()) != null) {
            throw new IllegalArgumentException("Username already exists: " + username);
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt(12)));
        user.setFullName(fullName);
        user.setEmail(email);
        user.setRole(User.Role.STAFF);
        user.setActive(true);

        return userDAO.save(user);
    }

    /**
     * Update an existing staff member's details.
     *
     * @param userId   ID of the staff member to update
     * @param username new username
     * @param fullName new full name
     * @param email    new email
     * @return true if updated successfully
     * @throws IllegalArgumentException if staff not found
     */
    public boolean updateStaff(int userId, String username, String fullName, String email) {
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("Staff member not found with ID: " + userId);
        }

        user.setUsername(username != null ? username.trim() : user.getUsername());
        user.setFullName(fullName);
        user.setEmail(email);

        return userDAO.update(user);
    }

    /**
     * Reset a staff member's password.
     *
     * @param userId      ID of the staff member
     * @param newPassword plain-text new password
     * @return true if updated successfully
     * @throws IllegalArgumentException if staff not found or password blank
     */
    public boolean resetPassword(int userId, String newPassword) {
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("New password cannot be blank");
        }
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("Staff member not found with ID: " + userId);
        }

        user.setPasswordHash(BCrypt.hashpw(newPassword, BCrypt.gensalt(12)));
        return userDAO.update(user);
    }

    /**
     * Delete a staff member by ID.
     * Admin accounts cannot be deleted through this method.
     *
     * @param userId ID of the staff member
     * @return true if deleted successfully
     * @throws IllegalArgumentException if not found or user is an admin
     */
    public boolean deleteStaff(int userId) {
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("Staff member not found with ID: " + userId);
        }
        if (User.Role.ADMIN.equals(user.getRole())) {
            throw new IllegalArgumentException("Admin accounts cannot be deleted through staff management");
        }

        return userDAO.delete(userId);
    }

    /**
     * Get all staff members (STAFF role only).
     */
    public List<User> getAllStaff() {
        return userDAO.findAllStaff();
    }

    /**
     * Get a single staff member by ID.
     *
     * @throws IllegalArgumentException if not found
     */
    public User getStaffById(int userId) {
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("Staff member not found with ID: " + userId);
        }
        return user;
    }
}

