package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.ReportHistory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of ReportHistoryDAO.
 */
public class ReportHistoryDAOImpl implements ReportHistoryDAO {

    private final Connection connection;

    public ReportHistoryDAOImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public int save(ReportHistory report) {
        String sql = "INSERT INTO report_history (report_type, from_date, to_date, " +
                "total_reservations, confirmed_count, checked_in_count, checked_out_count, " +
                "cancelled_count, total_revenue, generated_by) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, report.getReportType());
            stmt.setDate(2, Date.valueOf(report.getFromDate()));
            stmt.setDate(3, Date.valueOf(report.getToDate()));
            stmt.setInt(4, report.getTotalReservations());
            stmt.setInt(5, report.getConfirmedCount());
            stmt.setInt(6, report.getCheckedInCount());
            stmt.setInt(7, report.getCheckedOutCount());
            stmt.setInt(8, report.getCancelledCount());
            stmt.setDouble(9, report.getTotalRevenue());
            stmt.setInt(10, report.getGeneratedBy());
            stmt.executeUpdate();
            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    public List<ReportHistory> findAll() {
        List<ReportHistory> list = new ArrayList<>();
        String sql = "SELECT rh.*, u.username FROM report_history rh " +
                     "LEFT JOIN users u ON rh.generated_by = u.user_id " +
                     "ORDER BY rh.generated_at DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ReportHistory rh = new ReportHistory();
                rh.setReportId(rs.getInt("report_id"));
                rh.setReportType(rs.getString("report_type"));
                rh.setFromDate(rs.getDate("from_date").toLocalDate());
                rh.setToDate(rs.getDate("to_date").toLocalDate());
                rh.setTotalReservations(rs.getInt("total_reservations"));
                rh.setConfirmedCount(rs.getInt("confirmed_count"));
                rh.setCheckedInCount(rs.getInt("checked_in_count"));
                rh.setCheckedOutCount(rs.getInt("checked_out_count"));
                rh.setCancelledCount(rs.getInt("cancelled_count"));
                rh.setTotalRevenue(rs.getDouble("total_revenue"));
                rh.setGeneratedBy(rs.getInt("generated_by"));
                Timestamp ts = rs.getTimestamp("generated_at");
                if (ts != null) rh.setGeneratedAt(ts.toLocalDateTime());
                list.add(rh);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ReportHistory findById(int reportId) {
        String sql = "SELECT * FROM report_history WHERE report_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                ReportHistory rh = new ReportHistory();
                rh.setReportId(rs.getInt("report_id"));
                rh.setReportType(rs.getString("report_type"));
                rh.setFromDate(rs.getDate("from_date").toLocalDate());
                rh.setToDate(rs.getDate("to_date").toLocalDate());
                rh.setTotalReservations(rs.getInt("total_reservations"));
                rh.setConfirmedCount(rs.getInt("confirmed_count"));
                rh.setCheckedInCount(rs.getInt("checked_in_count"));
                rh.setCheckedOutCount(rs.getInt("checked_out_count"));
                rh.setCancelledCount(rs.getInt("cancelled_count"));
                rh.setTotalRevenue(rs.getDouble("total_revenue"));
                rh.setGeneratedBy(rs.getInt("generated_by"));
                Timestamp ts2 = rs.getTimestamp("generated_at");
                if (ts2 != null) rh.setGeneratedAt(ts2.toLocalDateTime());
                return rh;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean delete(int reportId) {
        String sql = "DELETE FROM report_history WHERE report_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

