package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.User;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Concrete implementation of UserDAO using JDBC and MySQL.
 * Part of the DAO design pattern.
 */
public class UserDAOImpl implements UserDAO {

    public UserDAOImpl(Connection connection) {}
    private Connection conn() { return DBConnectionFactory.getConnection(); }

    @Override
    public User findByUsername(String username) {
        String sql = "SELECT user_id, username, password_hash, role, full_name, email, is_active, created_at FROM users WHERE username = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRowToUser(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User findById(int userId) {
        String sql = "SELECT user_id, username, password_hash, role, full_name, email, is_active, created_at FROM users WHERE user_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRowToUser(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean save(User user) {
        String sql = "INSERT INTO users (username, password_hash, role, full_name, email, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getRole().name());
            stmt.setString(4, user.getFullName());
            stmt.setString(5, user.getEmail());
            stmt.setBoolean(6, user.isActive());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE users SET username = ?, password_hash = ?, role = ?, full_name = ?, email = ?, is_active = ? WHERE user_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getRole().name());
            stmt.setString(4, user.getFullName());
            stmt.setString(5, user.getEmail());
            stmt.setBoolean(6, user.isActive());
            stmt.setInt(7, user.getUserId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<User> findAllStaff() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, username, password_hash, role, full_name, email, is_active, created_at FROM users WHERE role = 'STAFF' ORDER BY username";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRowToUser(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(User.Role.valueOf(rs.getString("role")));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setActive(rs.getBoolean("is_active"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) user.setCreatedAt(ts.toLocalDateTime());
        return user;
    }
}


