package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.UserDAO;
import com.oceanview.hotel.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * TDD Test class for StaffService.
 * Covers: create staff, update staff, delete staff, list all staff.
 * Follows Given / When / Then naming convention.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("StaffService Tests")
class StaffServiceTest {

    @Mock
    private UserDAO userDAO;

    @InjectMocks
    private StaffService staffService;

    private User existingStaff;

    @BeforeEach
    void setUp() {
        existingStaff = new User();
        existingStaff.setUserId(2);
        existingStaff.setUsername("staff1");
        existingStaff.setPasswordHash("$2a$12$hashedpassword");
        existingStaff.setFullName("John Smith");
        existingStaff.setEmail("john@oceanview.com");
        existingStaff.setRole(User.Role.STAFF);
        existingStaff.setActive(true);
        existingStaff.setCreatedAt(LocalDateTime.now());
    }

    // ─────────────────────────────────────────────
    // CREATE STAFF
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid staff details, When createStaff, Then staff is saved successfully")
    void givenValidDetails_whenCreateStaff_thenSaveSucceeds() {
        when(userDAO.findByUsername("newstaff")).thenReturn(null);
        when(userDAO.save(any(User.class))).thenReturn(true);

        boolean result = staffService.createStaff("newstaff", "password123", "New Staff", "new@oceanview.com");

        assertTrue(result);
        verify(userDAO, times(1)).save(any(User.class));
    }

    @Test
    @DisplayName("Given duplicate username, When createStaff, Then throw IllegalArgumentException")
    void givenDuplicateUsername_whenCreateStaff_thenThrowException() {
        when(userDAO.findByUsername("staff1")).thenReturn(existingStaff);

        assertThrows(IllegalArgumentException.class, () ->
                staffService.createStaff("staff1", "password123", "John Smith", "john@oceanview.com"));

        verify(userDAO, never()).save(any(User.class));
    }

    @Test
    @DisplayName("Given blank username, When createStaff, Then throw IllegalArgumentException")
    void givenBlankUsername_whenCreateStaff_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                staffService.createStaff("", "password123", "John Smith", "john@oceanview.com"));
    }

    @Test
    @DisplayName("Given blank password, When createStaff, Then throw IllegalArgumentException")
    void givenBlankPassword_whenCreateStaff_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                staffService.createStaff("newstaff", "", "John Smith", "john@oceanview.com"));
    }

    // ─────────────────────────────────────────────
    // UPDATE STAFF
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid staff ID, When updateStaff, Then update succeeds")
    void givenValidId_whenUpdateStaff_thenUpdateSucceeds() {
        when(userDAO.findById(2)).thenReturn(existingStaff);
        when(userDAO.update(any(User.class))).thenReturn(true);

        boolean result = staffService.updateStaff(2, "updatedname", "Updated Name", "updated@oceanview.com");

        assertTrue(result);
        verify(userDAO, times(1)).update(any(User.class));
    }

    @Test
    @DisplayName("Given non-existent staff ID, When updateStaff, Then throw IllegalArgumentException")
    void givenNonExistentId_whenUpdateStaff_thenThrowException() {
        when(userDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                staffService.updateStaff(99, "nouser", "No User", "no@oceanview.com"));
    }

    // ─────────────────────────────────────────────
    // DELETE STAFF
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid staff ID, When deleteStaff, Then delete succeeds")
    void givenValidId_whenDeleteStaff_thenDeleteSucceeds() {
        when(userDAO.findById(2)).thenReturn(existingStaff);
        when(userDAO.delete(2)).thenReturn(true);

        boolean result = staffService.deleteStaff(2);

        assertTrue(result);
        verify(userDAO, times(1)).delete(2);
    }

    @Test
    @DisplayName("Given non-existent staff ID, When deleteStaff, Then throw IllegalArgumentException")
    void givenNonExistentId_whenDeleteStaff_thenThrowException() {
        when(userDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                staffService.deleteStaff(99));
    }

    @Test
    @DisplayName("Given admin user ID, When deleteStaff, Then throw IllegalArgumentException")
    void givenAdminId_whenDeleteStaff_thenThrowException() {
        User admin = new User();
        admin.setUserId(1);
        admin.setRole(User.Role.ADMIN);
        when(userDAO.findById(1)).thenReturn(admin);

        assertThrows(IllegalArgumentException.class, () ->
                staffService.deleteStaff(1));
    }

    // ─────────────────────────────────────────────
    // LIST ALL STAFF
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given staff exist, When getAllStaff, Then return list of staff")
    void givenStaffExist_whenGetAllStaff_thenReturnList() {
        when(userDAO.findAllStaff()).thenReturn(Arrays.asList(existingStaff));

        List<User> result = staffService.getAllStaff();

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("staff1", result.get(0).getUsername());
    }

    @Test
    @DisplayName("Given staff ID, When getStaffById, Then return correct staff")
    void givenStaffId_whenGetById_thenReturnStaff() {
        when(userDAO.findById(2)).thenReturn(existingStaff);

        User result = staffService.getStaffById(2);

        assertNotNull(result);
        assertEquals(2, result.getUserId());
    }
}

