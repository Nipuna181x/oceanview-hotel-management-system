package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.Guest;
import com.oceanview.hotel.model.Reservation;
import com.oceanview.hotel.model.Room;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of ReservationDAO.
 * Calls the sp_create_reservation stored procedure for atomic reservation creation.
 */
public class ReservationDAOImpl implements ReservationDAO {

    public ReservationDAOImpl(Connection connection) {}
    private Connection conn() { return DBConnectionFactory.getConnection(); }

    @Override
    public String save(Reservation reservation, Guest guest) {
        // Call the stored procedure sp_create_reservation
        String sql = "{CALL sp_create_reservation(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = conn().prepareCall(sql)) {
            stmt.setString(1, guest.getFullName());
            stmt.setString(2, guest.getAddress());
            stmt.setString(3, guest.getContactNumber());
            stmt.setString(4, guest.getEmail());
            stmt.setString(5, guest.getNic());
            stmt.setInt(6, reservation.getRoomId());
            stmt.setDate(7, Date.valueOf(reservation.getCheckInDate()));
            stmt.setDate(8, Date.valueOf(reservation.getCheckOutDate()));
            stmt.setInt(9, reservation.getCreatedBy());
            stmt.setInt(10, reservation.getNumGuests());
            stmt.registerOutParameter(11, Types.VARCHAR);
            stmt.execute();
            return stmt.getString(11);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to create reservation: " + e.getMessage(), e);
        }
    }

    @Override
    public Reservation findByReservationNumber(String reservationNumber) {
        String sql = "SELECT r.*, g.full_name, g.address, g.contact_number, g.email, g.nic, " +
                "rm.room_number, rm.room_type, rm.rate_per_night, rm.is_available " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE r.reservation_number = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, reservationNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToReservation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Reservation findById(int reservationId) {
        String sql = "SELECT r.*, g.full_name, g.address, g.contact_number, g.email, g.nic, " +
                "rm.room_number, rm.room_type, rm.rate_per_night, rm.is_available " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE r.reservation_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToReservation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Reservation> findAll() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, g.full_name, g.address, g.contact_number, g.email, g.nic, " +
                "rm.room_number, rm.room_type, rm.rate_per_night, rm.is_available " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "ORDER BY r.created_at DESC";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRowToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateStatus(int reservationId, Reservation.Status status) {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, reservationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Reservation mapRowToReservation(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setReservationId(rs.getInt("reservation_id"));
        r.setReservationNumber(rs.getString("reservation_number"));
        r.setGuestId(rs.getInt("guest_id"));
        r.setRoomId(rs.getInt("room_id"));
        r.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        r.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        r.setStatus(Reservation.Status.valueOf(rs.getString("status")));
        r.setCreatedBy(rs.getInt("created_by"));
        r.setNumGuests(rs.getInt("num_guests"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) r.setCreatedAt(ts.toLocalDateTime());

        // Map guest
        Guest g = new Guest();
        g.setGuestId(rs.getInt("guest_id"));
        g.setFullName(rs.getString("full_name"));
        g.setAddress(rs.getString("address"));
        g.setContactNumber(rs.getString("contact_number"));
        g.setEmail(rs.getString("email"));
        g.setNic(rs.getString("nic"));
        r.setGuest(g);

        // Map room
        Room rm = new Room();
        rm.setRoomId(rs.getInt("room_id"));
        rm.setRoomNumber(rs.getString("room_number"));
        rm.setRoomType(Room.RoomType.valueOf(rs.getString("room_type")));
        rm.setRatePerNight(rs.getDouble("rate_per_night"));
        rm.setAvailable(rs.getBoolean("is_available"));
        r.setRoom(rm);

        return r;
    }
}


