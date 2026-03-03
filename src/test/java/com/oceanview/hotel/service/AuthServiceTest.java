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

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * TDD Test class for AuthService.
 * Tests user authentication, password hashing, and session management logic.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("AuthService Tests")
class AuthServiceTest {

    @Mock
    private UserDAO userDAO;

    @InjectMocks
    private AuthService authService;

    private User validAdminUser;
    private User validStaffUser;

    @BeforeEach
    void setUp() {
        // Generate a real BCrypt hash of "admin123" at runtime
        String hashedPassword = org.mindrot.jbcrypt.BCrypt.hashpw("admin123", org.mindrot.jbcrypt.BCrypt.gensalt(12));

        validAdminUser = new User();
        validAdminUser.setUserId(1);
        validAdminUser.setUsername("admin");
        validAdminUser.setPasswordHash(hashedPassword);
        validAdminUser.setRole(User.Role.ADMIN);
        validAdminUser.setCreatedAt(LocalDateTime.now());

        validStaffUser = new User();
        validStaffUser.setUserId(2);
        validStaffUser.setUsername("staff1");
        validStaffUser.setPasswordHash(hashedPassword);
        validStaffUser.setRole(User.Role.STAFF);
        validStaffUser.setCreatedAt(LocalDateTime.now());
    }

    // ================================================================
    // LOGIN SUCCESS TESTS
    // ================================================================

    @Test
    @DisplayName("Given valid credentials, When login is called, Then return authenticated User")
    void givenValidCredentials_whenLogin_thenReturnUser() {
        // Arrange
        when(userDAO.findByUsername("admin")).thenReturn(validAdminUser);

        // Act
        User result = authService.login("admin", "admin123");

        // Assert
        assertNotNull(result);
        assertEquals("admin", result.getUsername());
        assertEquals(User.Role.ADMIN, result.getRole());
        verify(userDAO, times(1)).findByUsername("admin");
    }

    @Test
    @DisplayName("Given valid staff credentials, When login is called, Then return Staff User")
    void givenValidStaffCredentials_whenLogin_thenReturnStaffUser() {
        // Arrange
        when(userDAO.findByUsername("staff1")).thenReturn(validStaffUser);

        // Act
        User result = authService.login("staff1", "admin123");

        // Assert
        assertNotNull(result);
        assertEquals("staff1", result.getUsername());
        assertEquals(User.Role.STAFF, result.getRole());
    }

    // ================================================================
    // LOGIN FAILURE TESTS
    // ================================================================

    @Test
    @DisplayName("Given wrong password, When login is called, Then throw InvalidCredentialsException")
    void givenWrongPassword_whenLogin_thenThrowException() {
        // Arrange
        when(userDAO.findByUsername("admin")).thenReturn(validAdminUser);

        // Act & Assert
        assertThrows(InvalidCredentialsException.class,
                () -> authService.login("admin", "wrongpassword"));
    }

    @Test
    @DisplayName("Given non-existent username, When login is called, Then throw InvalidCredentialsException")
    void givenNonExistentUsername_whenLogin_thenThrowException() {
        // Arrange
        when(userDAO.findByUsername("unknown")).thenReturn(null);

        // Act & Assert
        assertThrows(InvalidCredentialsException.class,
                () -> authService.login("unknown", "admin123"));
    }

    @Test
    @DisplayName("Given null username, When login is called, Then throw IllegalArgumentException")
    void givenNullUsername_whenLogin_thenThrowIllegalArgumentException() {
        assertThrows(IllegalArgumentException.class,
                () -> authService.login(null, "admin123"));
    }

    @Test
    @DisplayName("Given empty username, When login is called, Then throw IllegalArgumentException")
    void givenEmptyUsername_whenLogin_thenThrowIllegalArgumentException() {
        assertThrows(IllegalArgumentException.class,
                () -> authService.login("", "admin123"));
    }

    @Test
    @DisplayName("Given null password, When login is called, Then throw IllegalArgumentException")
    void givenNullPassword_whenLogin_thenThrowIllegalArgumentException() {
        assertThrows(IllegalArgumentException.class,
                () -> authService.login("admin", null));
    }

    @Test
    @DisplayName("Given empty password, When login is called, Then throw IllegalArgumentException")
    void givenEmptyPassword_whenLogin_thenThrowIllegalArgumentException() {
        assertThrows(IllegalArgumentException.class,
                () -> authService.login("admin", ""));
    }

    // ================================================================
    // PASSWORD HASHING TESTS
    // ================================================================

    @Test
    @DisplayName("Given a plain password, When hashPassword is called, Then return BCrypt hash")
    void givenPlainPassword_whenHashPassword_thenReturnBcryptHash() {
        // Act
        String hash = authService.hashPassword("admin123");

        // Assert
        assertNotNull(hash);
        assertTrue(hash.startsWith("$2a$"));
        assertNotEquals("admin123", hash);
    }

    @Test
    @DisplayName("Given same password hashed twice, When compared, Then hashes are different but both valid")
    void givenSamePasswordHashedTwice_whenCompared_thenBothHashesValid() {
        // BCrypt uses random salt - each hash is unique
        String hash1 = authService.hashPassword("admin123");
        String hash2 = authService.hashPassword("admin123");

        assertNotEquals(hash1, hash2); // different due to salt
        assertTrue(authService.checkPassword("admin123", hash1));
        assertTrue(authService.checkPassword("admin123", hash2));
    }

    @Test
    @DisplayName("Given correct password and hash, When checkPassword is called, Then return true")
    void givenCorrectPasswordAndHash_whenCheckPassword_thenReturnTrue() {
        String hash = authService.hashPassword("securePass99");
        assertTrue(authService.checkPassword("securePass99", hash));
    }

    @Test
    @DisplayName("Given wrong password and hash, When checkPassword is called, Then return false")
    void givenWrongPasswordAndHash_whenCheckPassword_thenReturnFalse() {
        String hash = authService.hashPassword("securePass99");
        assertFalse(authService.checkPassword("wrongPass", hash));
    }

    // ================================================================
    // ADMIN ROLE CHECK TESTS
    // ================================================================

    @Test
    @DisplayName("Given Admin user, When isAdmin is called, Then return true")
    void givenAdminUser_whenIsAdmin_thenReturnTrue() {
        assertTrue(authService.isAdmin(validAdminUser));
    }

    @Test
    @DisplayName("Given Staff user, When isAdmin is called, Then return false")
    void givenStaffUser_whenIsAdmin_thenReturnFalse() {
        assertFalse(authService.isAdmin(validStaffUser));
    }

    @Test
    @DisplayName("Given null user, When isAdmin is called, Then return false")
    void givenNullUser_whenIsAdmin_thenReturnFalse() {
        assertFalse(authService.isAdmin(null));
    }
}

