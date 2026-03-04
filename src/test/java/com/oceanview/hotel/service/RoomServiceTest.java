package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.RoomDAO;
import com.oceanview.hotel.model.Room;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * TDD Test class for RoomService.
 * Tests room availability checking and filtering logic.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("RoomService Tests")
class RoomServiceTest {

    @Mock
    private RoomDAO roomDAO;

    @InjectMocks
    private RoomService roomService;

    private Room singleAvailable;
    private Room doubleAvailable;
    private Room suiteUnavailable;
    private Room deluxeAvailable;

    @BeforeEach
    void setUp() {
        singleAvailable  = new Room(1, "101", Room.RoomType.SINGLE,  75.00,  true);
        doubleAvailable  = new Room(2, "201", Room.RoomType.DOUBLE,  120.00, true);
        suiteUnavailable = new Room(3, "301", Room.RoomType.SUITE,   250.00, false);
        deluxeAvailable  = new Room(4, "401", Room.RoomType.DELUXE,  350.00, true);
    }

    // ================================================================
    // GET ALL ROOMS
    // ================================================================

    @Test
    @DisplayName("Given rooms exist, When getAllRooms is called, Then return full list")
    void givenRoomsExist_whenGetAllRooms_thenReturnFullList() {
        when(roomDAO.findAll()).thenReturn(
                Arrays.asList(singleAvailable, doubleAvailable, suiteUnavailable, deluxeAvailable));

        List<Room> result = roomService.getAllRooms();

        assertNotNull(result);
        assertEquals(4, result.size());
        verify(roomDAO, times(1)).findAll();
    }

    @Test
    @DisplayName("Given no rooms, When getAllRooms is called, Then return empty list")
    void givenNoRooms_whenGetAllRooms_thenReturnEmptyList() {
        when(roomDAO.findAll()).thenReturn(Collections.emptyList());

        List<Room> result = roomService.getAllRooms();

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    // ================================================================
    // GET AVAILABLE ROOMS
    // ================================================================

    @Test
    @DisplayName("Given available rooms exist, When getAvailableRooms is called, Then return only available rooms")
    void givenAvailableRooms_whenGetAvailableRooms_thenReturnOnlyAvailable() {
        when(roomDAO.findAvailable(null)).thenReturn(
                Arrays.asList(singleAvailable, doubleAvailable, deluxeAvailable));

        List<Room> result = roomService.getAvailableRooms(null);

        assertNotNull(result);
        assertEquals(3, result.size());
        assertTrue(result.stream().allMatch(Room::isAvailable));
    }

    @Test
    @DisplayName("Given filter by SINGLE type, When getAvailableRooms is called, Then return only SINGLE rooms")
    void givenSingleFilter_whenGetAvailableRooms_thenReturnOnlySingleRooms() {
        when(roomDAO.findAvailable(Room.RoomType.SINGLE)).thenReturn(
                Collections.singletonList(singleAvailable));

        List<Room> result = roomService.getAvailableRooms(Room.RoomType.SINGLE);

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(Room.RoomType.SINGLE, result.get(0).getRoomType());
    }

    @Test
    @DisplayName("Given no available rooms, When getAvailableRooms is called, Then return empty list")
    void givenNoAvailableRooms_whenGetAvailableRooms_thenReturnEmptyList() {
        when(roomDAO.findAvailable(null)).thenReturn(Collections.emptyList());

        List<Room> result = roomService.getAvailableRooms(null);

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    // ================================================================
    // GET ROOM BY ID
    // ================================================================

    @Test
    @DisplayName("Given valid room ID, When getRoomById is called, Then return Room")
    void givenValidRoomId_whenGetRoomById_thenReturnRoom() {
        when(roomDAO.findById(1)).thenReturn(singleAvailable);

        Room result = roomService.getRoomById(1);

        assertNotNull(result);
        assertEquals("101", result.getRoomNumber());
        assertEquals(75.00, result.getRatePerNight(), 0.01);
    }

    @Test
    @DisplayName("Given invalid room ID, When getRoomById is called, Then throw IllegalArgumentException")
    void givenInvalidRoomId_whenGetRoomById_thenThrowException() {
        when(roomDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () -> roomService.getRoomById(99));
    }

    // ================================================================
    // AVAILABILITY CHECK
    // ================================================================

    @Test
    @DisplayName("Given available room, When isRoomAvailable is called, Then return true")
    void givenAvailableRoom_whenIsRoomAvailable_thenReturnTrue() {
        when(roomDAO.findById(1)).thenReturn(singleAvailable);

        assertTrue(roomService.isRoomAvailable(1));
    }

    @Test
    @DisplayName("Given unavailable room, When isRoomAvailable is called, Then return false")
    void givenUnavailableRoom_whenIsRoomAvailable_thenReturnFalse() {
        when(roomDAO.findById(3)).thenReturn(suiteUnavailable);

        assertFalse(roomService.isRoomAvailable(3));
    }

    // ================================================================
    // RATE PER NIGHT BY TYPE
    // ================================================================

    @Test
    @DisplayName("Given SUITE room type, When getRateByType is called, Then return correct rate")
    void givenSuiteType_whenGetRateByType_thenReturnCorrectRate() {
        double rate = roomService.getRateByType(Room.RoomType.SUITE);
        assertEquals(250.00, rate, 0.01);
    }

    @Test
    @DisplayName("Given SINGLE room type, When getRateByType is called, Then return correct rate")
    void givenSingleType_whenGetRateByType_thenReturnCorrectRate() {
        double rate = roomService.getRateByType(Room.RoomType.SINGLE);
        assertEquals(75.00, rate, 0.01);
    }

    @Test
    @DisplayName("Given null room type, When getRateByType is called, Then throw IllegalArgumentException")
    void givenNullType_whenGetRateByType_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () -> roomService.getRateByType(null));
    }

    // ================================================================
    // ADD ROOM (Admin only)
    // ================================================================

    @Test
    @DisplayName("Given valid room details, When addRoom, Then room is saved successfully")
    void givenValidDetails_whenAddRoom_thenSaveSucceeds() {
        when(roomDAO.findByRoomNumber("501")).thenReturn(null);
        when(roomDAO.save(any(Room.class))).thenReturn(true);

        boolean result = roomService.addRoom("501", Room.RoomType.SUITE, 250.00);

        assertTrue(result);
        verify(roomDAO, times(1)).save(any(Room.class));
    }

    @Test
    @DisplayName("Given duplicate room number, When addRoom, Then throw IllegalArgumentException")
    void givenDuplicateRoomNumber_whenAddRoom_thenThrowException() {
        when(roomDAO.findByRoomNumber("101")).thenReturn(singleAvailable);

        assertThrows(IllegalArgumentException.class, () ->
                roomService.addRoom("101", Room.RoomType.SINGLE, 75.00));

        verify(roomDAO, never()).save(any(Room.class));
    }

    @Test
    @DisplayName("Given blank room number, When addRoom, Then throw IllegalArgumentException")
    void givenBlankRoomNumber_whenAddRoom_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                roomService.addRoom("", Room.RoomType.SINGLE, 75.00));
    }

    @Test
    @DisplayName("Given negative rate, When addRoom, Then throw IllegalArgumentException")
    void givenNegativeRate_whenAddRoom_thenThrowException() {
        assertThrows(IllegalArgumentException.class, () ->
                roomService.addRoom("502", Room.RoomType.SINGLE, -10.00));
    }

    // ================================================================
    // UPDATE ROOM (Admin only)
    // ================================================================

    @Test
    @DisplayName("Given valid room ID, When updateRoom, Then update succeeds")
    void givenValidId_whenUpdateRoom_thenUpdateSucceeds() {
        when(roomDAO.findById(1)).thenReturn(singleAvailable);
        when(roomDAO.update(any(Room.class))).thenReturn(true);

        boolean result = roomService.updateRoom(1, "101", Room.RoomType.SINGLE, 80.00);

        assertTrue(result);
        verify(roomDAO, times(1)).update(any(Room.class));
    }

    @Test
    @DisplayName("Given non-existent room ID, When updateRoom, Then throw IllegalArgumentException")
    void givenNonExistentId_whenUpdateRoom_thenThrowException() {
        when(roomDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                roomService.updateRoom(99, "999", Room.RoomType.SINGLE, 75.00));
    }

    // ================================================================
    // DELETE ROOM (Admin only)
    // ================================================================

    @Test
    @DisplayName("Given valid room ID, When deleteRoom, Then delete succeeds")
    void givenValidId_whenDeleteRoom_thenDeleteSucceeds() {
        when(roomDAO.findById(1)).thenReturn(singleAvailable);
        when(roomDAO.delete(1)).thenReturn(true);

        boolean result = roomService.deleteRoom(1);

        assertTrue(result);
        verify(roomDAO, times(1)).delete(1);
    }

    @Test
    @DisplayName("Given non-existent room ID, When deleteRoom, Then throw IllegalArgumentException")
    void givenNonExistentId_whenDeleteRoom_thenThrowException() {
        when(roomDAO.findById(99)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () ->
                roomService.deleteRoom(99));
    }

    @Test
    @DisplayName("Given occupied room, When deleteRoom, Then throw IllegalArgumentException")
    void givenOccupiedRoom_whenDeleteRoom_thenThrowException() {
        when(roomDAO.findById(3)).thenReturn(suiteUnavailable);

        assertThrows(IllegalArgumentException.class, () ->
                roomService.deleteRoom(3));
    }
}


