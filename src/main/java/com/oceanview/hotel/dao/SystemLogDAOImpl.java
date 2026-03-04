package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.SystemLog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of SystemLogDAO.
 */
public class SystemLogDAOImpl implements SystemLogDAO {

    public SystemLogDAOImpl(Connection connection) {}
    private Connection conn() { return DBConnectionFactory.getConnection(); }

    @Override
    public int save(SystemLog log) {
        String sql = "INSERT INTO system_logs (user_id, username, action, details, ip_address) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, log.getUserId());
            stmt.setString(2, log.getUsername());
            stmt.setString(3, log.getAction());
            stmt.setString(4, log.getDetails());
            stmt.setString(5, log.getIpAddress());
            stmt.executeUpdate();
            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    @Override
    public List<SystemLog> findAll() {
        List<SystemLog> list = new ArrayList<>();
        String sql = "SELECT * FROM system_logs ORDER BY logged_at DESC";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<SystemLog> findByUserId(int userId) {
        List<SystemLog> list = new ArrayList<>();
        String sql = "SELECT * FROM system_logs WHERE user_id = ? ORDER BY logged_at DESC";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<SystemLog> findByAction(String action) {
        List<SystemLog> list = new ArrayList<>();
        String sql = "SELECT * FROM system_logs WHERE action = ? ORDER BY logged_at DESC";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, action);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private SystemLog mapRow(ResultSet rs) throws SQLException {
        SystemLog log = new SystemLog();
        log.setLogId(rs.getInt("log_id"));
        log.setUserId(rs.getInt("user_id"));
        log.setUsername(rs.getString("username"));
        log.setAction(rs.getString("action"));
        log.setDetails(rs.getString("details"));
        log.setIpAddress(rs.getString("ip_address"));
        Timestamp ts = rs.getTimestamp("logged_at");
        if (ts != null) log.setLoggedAt(ts.toLocalDateTime());
        return log;
    }
}


