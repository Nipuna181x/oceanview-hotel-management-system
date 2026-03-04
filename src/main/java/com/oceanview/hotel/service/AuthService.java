package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.UserDAO;
import com.oceanview.hotel.model.User;
import org.mindrot.jbcrypt.BCrypt;

// Handles login and password operations using BCrypt
public class AuthService {

    private final UserDAO userDAO;

    public AuthService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    // Validate credentials — throws if missing or wrong
    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }

        User user = userDAO.findByUsername(username.trim());
        if (user == null) {
            throw new InvalidCredentialsException("Invalid username or password");
        }

        if (!BCrypt.checkpw(password, user.getPasswordHash())) {
            throw new InvalidCredentialsException("Invalid username or password");
        }

        return user;
    }

    public String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    public boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    public boolean isAdmin(User user) {
        if (user == null) return false;
        return User.Role.ADMIN.equals(user.getRole());
    }
}
