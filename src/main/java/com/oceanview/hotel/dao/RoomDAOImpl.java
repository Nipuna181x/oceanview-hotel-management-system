package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.Room;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of RoomDAO.
 */
public class RoomDAOImpl implements RoomDAO {

    public RoomDAOImpl(Connection connection) {}
    private Connection conn() { return DBConnectionFactory.getConnection(); }

    @Override
    public Room findById(int roomId) {
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRowToRoom(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Room findByRoomNumber(String roomNumber) {
        String sql = "SELECT * FROM rooms WHERE room_number = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, roomNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRowToRoom(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Room> findAll() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_number";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRowToRoom(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Room> findAvailable(Room.RoomType type) {
        List<Room> list = new ArrayList<>();
        String sql = type != null
                ? "SELECT * FROM rooms WHERE is_available = TRUE AND room_type = ? ORDER BY room_number"
                : "SELECT * FROM rooms WHERE is_available = TRUE ORDER BY room_number";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            if (type != null) stmt.setString(1, type.name());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRowToRoom(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateAvailability(int roomId, boolean available) {
        String sql = "UPDATE rooms SET is_available = ? WHERE room_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setBoolean(1, available);
            stmt.setInt(2, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean save(Room room) {
        String sql = "INSERT INTO rooms (room_number, room_type, max_occupancy, rate_per_night, description, is_available) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setString(2, room.getRoomType().name());
            stmt.setInt(3, room.getMaxOccupancy());
            stmt.setDouble(4, room.getRatePerNight());
            stmt.setString(5, room.getDescription());
            stmt.setBoolean(6, room.isAvailable());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Room room) {
        String sql = "UPDATE rooms SET room_number=?, room_type=?, max_occupancy=?, rate_per_night=?, description=?, is_available=? WHERE room_id=?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setString(2, room.getRoomType().name());
            stmt.setInt(3, room.getMaxOccupancy());
            stmt.setDouble(4, room.getRatePerNight());
            stmt.setString(5, room.getDescription());
            stmt.setBoolean(6, room.isAvailable());
            stmt.setInt(7, room.getRoomId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(int roomId) {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        try (PreparedStatement stmt = conn().prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Room mapRowToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(Room.RoomType.valueOf(rs.getString("room_type")));
        room.setMaxOccupancy(rs.getInt("max_occupancy"));
        room.setRatePerNight(rs.getDouble("rate_per_night"));
        room.setDescription(rs.getString("description"));
        room.setAvailable(rs.getBoolean("is_available"));
        return room;
    }
}


