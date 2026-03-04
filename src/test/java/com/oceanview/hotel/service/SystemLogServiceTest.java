package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.SystemLogDAO;
import com.oceanview.hotel.model.SystemLog;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * TDD Test class for SystemLogService.
 * Covers: write log, get all logs, get logs by user, get logs by action.
 * Follows Given / When / Then naming convention.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("SystemLogService Tests")
class SystemLogServiceTest {

    @Mock
    private SystemLogDAO systemLogDAO;

    @InjectMocks
    private SystemLogService systemLogService;

    private SystemLog existingLog;

    @BeforeEach
    void setUp() {
        existingLog = new SystemLog();
        existingLog.setLogId(1);
        existingLog.setUserId(1);
        existingLog.setUsername("admin");
        existingLog.setAction("CREATE_RESERVATION");
        existingLog.setDetails("Created reservation RES-20260304-001");
        existingLog.setIpAddress("127.0.0.1");
        existingLog.setLoggedAt(LocalDateTime.now());
    }

    // ─────────────────────────────────────────────
    // WRITE LOG
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given valid details, When writeLog, Then log is saved successfully")
    void givenValidDetails_whenWriteLog_thenSaveSucceeds() {
        when(systemLogDAO.save(any(SystemLog.class))).thenReturn(1);

        int result = systemLogService.writeLog(1, "admin", "CREATE_RESERVATION",
                "Created reservation RES-001", "192.168.1.1");

        assertTrue(result > 0);
        verify(systemLogDAO, times(1)).save(any(SystemLog.class));
    }

    @Test
    @DisplayName("Given blank action, When writeLog, Then throw IllegalArgumentException")
    void givenBlankAction_whenWriteLog_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                systemLogService.writeLog(1, "admin", "", "details", "127.0.0.1"));
    }

    @Test
    @DisplayName("Given null action, When writeLog, Then throw IllegalArgumentException")
    void givenNullAction_whenWriteLog_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                systemLogService.writeLog(1, "admin", null, "details", "127.0.0.1"));
    }

    // ─────────────────────────────────────────────
    // GET ALL LOGS
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given logs exist, When getAllLogs, Then return list")
    void givenLogsExist_whenGetAllLogs_thenReturnList() {
        when(systemLogDAO.findAll()).thenReturn(Arrays.asList(existingLog));

        List<SystemLog> result = systemLogService.getAllLogs();

        assertNotNull(result);
        assertEquals(1, result.size());
        verify(systemLogDAO, times(1)).findAll();
    }

    @Test
    @DisplayName("Given no logs, When getAllLogs, Then return empty list")
    void givenNoLogs_whenGetAllLogs_thenReturnEmpty() {
        when(systemLogDAO.findAll()).thenReturn(Collections.emptyList());

        List<SystemLog> result = systemLogService.getAllLogs();

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    // ─────────────────────────────────────────────
    // GET LOGS BY USER
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given user ID, When getLogsByUser, Then return matching logs")
    void givenUserId_whenGetLogsByUser_thenReturnLogs() {
        when(systemLogDAO.findByUserId(1)).thenReturn(Arrays.asList(existingLog));

        List<SystemLog> result = systemLogService.getLogsByUser(1);

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("admin", result.get(0).getUsername());
    }

    // ─────────────────────────────────────────────
    // GET LOGS BY ACTION
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("Given action, When getLogsByAction, Then return matching logs")
    void givenAction_whenGetLogsByAction_thenReturnLogs() {
        when(systemLogDAO.findByAction("CREATE_RESERVATION")).thenReturn(Arrays.asList(existingLog));

        List<SystemLog> result = systemLogService.getLogsByAction("CREATE_RESERVATION");

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("CREATE_RESERVATION", result.get(0).getAction());
    }

    @Test
    @DisplayName("Given blank action filter, When getLogsByAction, Then throw IllegalArgumentException")
    void givenBlankAction_whenGetLogsByAction_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                systemLogService.getLogsByAction(""));
    }
}

