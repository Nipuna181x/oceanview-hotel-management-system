package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.UserDAO;
import com.oceanview.hotel.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;

// Staff account management — admin only
public class StaffService {

    private final UserDAO userDAO;

    public StaffService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

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

    // Admin accounts are protected — can't be deleted here
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

    public List<User> getAllStaff() {
        return userDAO.findAllStaff();
    }

    public User getStaffById(int userId) {
        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("Staff member not found with ID: " + userId);
        }
        return user;
    }
}
