-- =====================================================
-- Ocean View Hotel Management System - Database Schema
-- =====================================================
-- Version: 1.0.0
-- Date: March 2026
-- Description: Complete database schema for HMS
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS oceanviewresort_hms
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE oceanviewresort_hms;

-- =====================================================
-- TABLE: users
-- Description: Stores admin and staff user accounts
-- =====================================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'STAFF') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: rooms
-- Description: Hotel room inventory
-- =====================================================
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type ENUM('SINGLE', 'DOUBLE', 'SUITE', 'DELUXE') NOT NULL,
    max_occupancy INT NOT NULL,
    rate_per_night DECIMAL(10,2) NOT NULL,
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_room_number (room_number),
    INDEX idx_room_type (room_type),
    INDEX idx_available (is_available)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: guests
-- Description: Guest information
-- =====================================================
CREATE TABLE guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_number VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    nic VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_contact (contact_number),
    INDEX idx_email (email)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: reservations
-- Description: Booking records
-- =====================================================
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_number VARCHAR(20) UNIQUE NOT NULL,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    num_guests INT DEFAULT 1,
    status ENUM('CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED') DEFAULT 'CONFIRMED',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id) ON DELETE RESTRICT,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE RESTRICT,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_reservation_number (reservation_number),
    INDEX idx_status (status),
    INDEX idx_dates (check_in_date, check_out_date)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: pricing_rates
-- Description: Dynamic pricing strategies
-- =====================================================
CREATE TABLE pricing_rates (
    strategy_id INT AUTO_INCREMENT PRIMARY KEY,
    strategy_name VARCHAR(100) UNIQUE NOT NULL,
    adjustment_type ENUM('SURCHARGE', 'DISCOUNT') NOT NULL,
    adjustment_percent DECIMAL(5,2) NOT NULL,
    description TEXT,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_strategy_name (strategy_name)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: bills
-- Description: Billing and invoices
-- =====================================================
CREATE TABLE bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT UNIQUE NOT NULL,
    num_nights INT NOT NULL,
    rate_per_night DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    pricing_strategy_used VARCHAR(100),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE RESTRICT,
    INDEX idx_reservation (reservation_id)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: system_logs
-- Description: Audit trail for system activities
-- =====================================================
CREATE TABLE system_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_timestamp (timestamp),
    INDEX idx_action (action)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: report_history
-- Description: Generated reports archive
-- =====================================================
CREATE TABLE report_history (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    report_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_revenue DECIMAL(12,2),
    total_reservations INT,
    occupancy_rate DECIMAL(5,2),
    generated_by INT,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (generated_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_dates (start_date, end_date)
) ENGINE=InnoDB;

-- =====================================================
-- STORED PROCEDURE: sp_create_reservation
-- Description: Atomic reservation creation with guest
-- =====================================================
DELIMITER //

DROP PROCEDURE IF EXISTS sp_create_reservation//

CREATE PROCEDURE sp_create_reservation(
    IN p_guest_name VARCHAR(100),
    IN p_address TEXT,
    IN p_contact VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_nic VARCHAR(20),
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE,
    IN p_created_by INT,
    IN p_num_guests INT,
    OUT p_reservation_number VARCHAR(20)
)
BEGIN
    DECLARE v_guest_id INT;
    DECLARE v_res_number VARCHAR(20);
    DECLARE v_room_available BOOLEAN;

    -- Check if room is available
    SELECT is_available INTO v_room_available
    FROM rooms WHERE room_id = p_room_id;

    IF v_room_available = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Room is not available';
    END IF;

    -- Generate unique reservation number
    SET v_res_number = CONCAT('RES', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(FLOOR(RAND() * 10000), 4, '0'));

    -- Insert or update guest
    INSERT INTO guests (full_name, address, contact_number, email, nic)
    VALUES (p_guest_name, p_address, p_contact, p_email, p_nic);
    SET v_guest_id = LAST_INSERT_ID();

    -- Create reservation
    INSERT INTO reservations (
        reservation_number, guest_id, room_id, check_in_date,
        check_out_date, num_guests, status, created_by
    )
    VALUES (
        v_res_number, v_guest_id, p_room_id, p_check_in,
        p_check_out, p_num_guests, 'CONFIRMED', p_created_by
    );

    -- Update room availability
    UPDATE rooms SET is_available = FALSE WHERE room_id = p_room_id;

    SET p_reservation_number = v_res_number;
END//

DELIMITER ;

-- =====================================================
-- SAMPLE DATA: Admin User
-- =====================================================
-- Note: Password is 'admin123' hashed with BCrypt
-- You should regenerate this hash using BCrypt with your own salt
INSERT INTO users (username, password_hash, role, full_name, email)
VALUES ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMye1ICFRKX/8zXDELxXJ5pDEq8mIx.GCuC', 'ADMIN', 'System Administrator', 'admin@oceanview.com');

-- =====================================================
-- SAMPLE DATA: Rooms
-- =====================================================
INSERT INTO rooms (room_number, room_type, max_occupancy, rate_per_night, description) VALUES
('101', 'SINGLE', 1, 5000.00, 'Cozy single room with garden view'),
('102', 'SINGLE', 1, 5000.00, 'Single room with balcony'),
('103', 'SINGLE', 1, 5000.00, 'Single room, ground floor'),
('201', 'DOUBLE', 2, 8000.00, 'Spacious double room'),
('202', 'DOUBLE', 2, 8000.00, 'Double room with ocean view'),
('203', 'DOUBLE', 2, 8500.00, 'Double room with king-size bed'),
('301', 'SUITE', 4, 15000.00, 'Luxury suite with living area'),
('302', 'SUITE', 4, 16000.00, 'Executive suite with kitchenette'),
('401', 'DELUXE', 4, 20000.00, 'Premium deluxe room with private balcony'),
('402', 'DELUXE', 4, 22000.00, 'Deluxe penthouse with ocean view');

-- =====================================================
-- SAMPLE DATA: Pricing Strategies
-- =====================================================
INSERT INTO pricing_rates (strategy_name, adjustment_type, adjustment_percent, description, is_default) VALUES
('Standard Rate', 'SURCHARGE', 0.00, 'Default pricing with no adjustments', TRUE),
('Weekend Surcharge', 'SURCHARGE', 15.00, 'Applied for Friday-Sunday bookings'),
('Holiday Premium', 'SURCHARGE', 25.00, 'Peak season pricing for holidays'),
('Early Bird Discount', 'DISCOUNT', 10.00, 'Discount for bookings made 30+ days in advance'),
('Extended Stay Discount', 'DISCOUNT', 15.00, 'Discount for stays of 7+ nights'),
('Group Booking Discount', 'DISCOUNT', 5.00, 'Discount for group bookings (5+ rooms)');

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================
-- Run these after setup to verify installation

-- Check tables
SHOW TABLES;

-- Check admin user
SELECT user_id, username, role, full_name FROM users WHERE role = 'ADMIN';

-- Check rooms
SELECT COUNT(*) as total_rooms FROM rooms;

-- Check pricing strategies
SELECT strategy_name, adjustment_type, adjustment_percent FROM pricing_rates;

-- Check stored procedure
SHOW PROCEDURE STATUS WHERE Db = 'oceanviewresort_hms';

-- =====================================================
-- USEFUL QUERIES FOR MAINTENANCE
-- =====================================================

-- Reset all rooms to available (use with caution)
-- UPDATE rooms SET is_available = TRUE;

-- Delete test reservations
-- DELETE FROM reservations WHERE reservation_number LIKE 'RES%TEST%';

-- View system statistics
-- SELECT
--     (SELECT COUNT(*) FROM rooms) as total_rooms,
--     (SELECT COUNT(*) FROM rooms WHERE is_available = TRUE) as available_rooms,
--     (SELECT COUNT(*) FROM reservations WHERE status = 'CHECKED_IN') as current_guests,
--     (SELECT COUNT(*) FROM users) as total_users;

-- =====================================================
-- END OF SCHEMA
-- =====================================================

