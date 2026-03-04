package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.Bill;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of BillDAO.
 * Calls sp_calculate_bill stored procedure for bill generation.
 */
public class BillDAOImpl implements BillDAO {

    public BillDAOImpl(Connection connection) {}

    private Connection conn() { return DBConnectionFactory.getConnection(); }

    @Override
    public int save(Bill bill) {
        String sql = "INSERT INTO bills (reservation_id, num_nights, rate_per_night, subtotal, " +
                "tax_amount, total_amount, pricing_strategy_used) VALUES (?, ?, ?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE num_nights=VALUES(num_nights), rate_per_night=VALUES(rate_per_night), " +
                "subtotal=VALUES(subtotal), tax_amount=VALUES(tax_amount), total_amount=VALUES(total_amount), " +
                "pricing_strategy_used=VALUES(pricing_strategy_used), generated_at=CURRENT_TIMESTAMP";
        try (PreparedStatement stmt = conn().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, bill.getReservationId());
            stmt.setInt(2, bill.getNumNights());
            stmt.setDouble(3, bill.getRatePerNight());
            stmt.setDouble(4, bill.getSubtotal());
            stmt.setDouble(5, bill.getTaxAmount());
            stmt.setDouble(6, bill.getTotalAmount());
            stmt.setString(7, bill.getPricingStrategyUsed());
            stmt.executeUpdate();
            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public Bill findByReservationId(int reservationId) {
        String sql = "SELECT * FROM bills WHERE reservation_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRowToBill(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Bill findById(int billId) {
        String sql = "SELECT * FROM bills WHERE bill_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, billId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRowToBill(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean update(Bill bill) {
        String sql = "UPDATE bills SET num_nights=?, rate_per_night=?, subtotal=?, tax_amount=?, " +
                "total_amount=?, pricing_strategy_used=? WHERE bill_id=?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, bill.getNumNights());
            stmt.setDouble(2, bill.getRatePerNight());
            stmt.setDouble(3, bill.getSubtotal());
            stmt.setDouble(4, bill.getTaxAmount());
            stmt.setDouble(5, bill.getTotalAmount());
            stmt.setString(6, bill.getPricingStrategyUsed());
            stmt.setInt(7, bill.getBillId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Bill> findAll() {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT b.*, r.reservation_number, g.full_name AS guest_name " +
                     "FROM bills b " +
                     "JOIN reservations r ON b.reservation_id = r.reservation_id " +
                     "JOIN guests g ON r.guest_id = g.guest_id " +
                     "ORDER BY b.generated_at DESC";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Bill bill = mapRowToBill(rs);
                bill.setReservationNumber(rs.getString("reservation_number"));
                bill.setGuestName(rs.getString("guest_name"));
                list.add(bill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Bill mapRowToBill(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setReservationId(rs.getInt("reservation_id"));
        bill.setNumNights(rs.getInt("num_nights"));
        bill.setRatePerNight(rs.getDouble("rate_per_night"));
        bill.setSubtotal(rs.getDouble("subtotal"));
        bill.setTaxAmount(rs.getDouble("tax_amount"));
        bill.setTotalAmount(rs.getDouble("total_amount"));
        bill.setPricingStrategyUsed(rs.getString("pricing_strategy_used"));
        Timestamp ts = rs.getTimestamp("generated_at");
        if (ts != null) bill.setGeneratedAt(ts.toLocalDateTime());
        return bill;
    }
}
