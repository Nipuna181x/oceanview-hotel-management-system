package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.PricingRate;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of PricingRateDAO — backed by pricing_strategies table.
 */
public class PricingRateDAOImpl implements PricingRateDAO {

    public PricingRateDAOImpl(Connection connection) {}

    private Connection conn() { return DBConnectionFactory.getConnection(); }

    @Override
    public List<PricingRate> findAll() {
        List<PricingRate> list = new ArrayList<>();
        String sql = "SELECT * FROM pricing_strategies ORDER BY is_default DESC, name";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public PricingRate findById(int strategyId) {
        String sql = "SELECT * FROM pricing_strategies WHERE strategy_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, strategyId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public PricingRate findByName(String name) {
        String sql = "SELECT * FROM pricing_strategies WHERE name = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public PricingRate findDefault() {
        String sql = "SELECT * FROM pricing_strategies WHERE is_default = TRUE LIMIT 1";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public int save(PricingRate strategy) {
        String sql = "INSERT INTO pricing_strategies (name, adjustment_type, adjustment_percent, description, is_default) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, strategy.getName());
            stmt.setString(2, strategy.getAdjustmentType().name());
            stmt.setDouble(3, strategy.getAdjustmentPercent());
            stmt.setString(4, strategy.getDescription());
            stmt.setBoolean(5, strategy.isDefault());
            stmt.executeUpdate();
            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    @Override
    public boolean update(PricingRate strategy) {
        String sql = "UPDATE pricing_strategies SET name=?, adjustment_type=?, adjustment_percent=?, description=?, is_default=? WHERE strategy_id=?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, strategy.getName());
            stmt.setString(2, strategy.getAdjustmentType().name());
            stmt.setDouble(3, strategy.getAdjustmentPercent());
            stmt.setString(4, strategy.getDescription());
            stmt.setBoolean(5, strategy.isDefault());
            stmt.setInt(6, strategy.getStrategyId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean delete(int strategyId) {
        String sql = "DELETE FROM pricing_strategies WHERE strategy_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, strategyId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private PricingRate mapRow(ResultSet rs) throws SQLException {
        PricingRate pr = new PricingRate();
        pr.setStrategyId(rs.getInt("strategy_id"));
        pr.setName(rs.getString("name"));
        pr.setAdjustmentType(PricingRate.AdjustmentType.valueOf(rs.getString("adjustment_type")));
        pr.setAdjustmentPercent(rs.getDouble("adjustment_percent"));
        pr.setDescription(rs.getString("description"));
        pr.setDefault(rs.getBoolean("is_default"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) pr.setCreatedAt(ts.toLocalDateTime());
        return pr;
    }
}
