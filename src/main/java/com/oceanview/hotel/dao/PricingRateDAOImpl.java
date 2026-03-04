package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.PricingRate;
import com.oceanview.hotel.model.Room;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of PricingRateDAO.
 */
public class PricingRateDAOImpl implements PricingRateDAO {

    private final Connection connection;

    public PricingRateDAOImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public List<PricingRate> findAll() {
        List<PricingRate> list = new ArrayList<>();
        String sql = "SELECT * FROM pricing_rates ORDER BY room_type, season";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public PricingRate findById(int rateId) {
        String sql = "SELECT * FROM pricing_rates WHERE rate_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, rateId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public List<PricingRate> findByRoomType(Room.RoomType roomType) {
        List<PricingRate> list = new ArrayList<>();
        String sql = "SELECT * FROM pricing_rates WHERE room_type = ? ORDER BY season";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, roomType.name());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public int save(PricingRate rate) {
        String sql = "INSERT INTO pricing_rates (room_type, season, rate_per_night, description) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, rate.getRoomType().name());
            stmt.setString(2, rate.getSeason());
            stmt.setDouble(3, rate.getRatePerNight());
            stmt.setString(4, rate.getDescription());
            stmt.executeUpdate();
            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    @Override
    public boolean update(PricingRate rate) {
        String sql = "UPDATE pricing_rates SET room_type=?, season=?, rate_per_night=?, description=? WHERE rate_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, rate.getRoomType().name());
            stmt.setString(2, rate.getSeason());
            stmt.setDouble(3, rate.getRatePerNight());
            stmt.setString(4, rate.getDescription());
            stmt.setInt(5, rate.getRateId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean delete(int rateId) {
        String sql = "DELETE FROM pricing_rates WHERE rate_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, rateId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private PricingRate mapRow(ResultSet rs) throws SQLException {
        PricingRate pr = new PricingRate();
        pr.setRateId(rs.getInt("rate_id"));
        pr.setRoomType(Room.RoomType.valueOf(rs.getString("room_type")));
        pr.setSeason(rs.getString("season"));
        pr.setRatePerNight(rs.getDouble("rate_per_night"));
        pr.setDescription(rs.getString("description"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) pr.setCreatedAt(ts.toLocalDateTime());
        return pr;
    }
}

