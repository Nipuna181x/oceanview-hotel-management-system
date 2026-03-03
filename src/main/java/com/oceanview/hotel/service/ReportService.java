package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.ReservationDAO;
import com.oceanview.hotel.model.Reservation;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Service class for generating occupancy and revenue reports.
 *
 * Design Pattern: Service Layer / Facade — encapsulates all reporting
 * logic behind a clean interface used by controllers and REST resources.
 */
public class ReportService {

    private final ReservationDAO reservationDAO;

    public ReportService(ReservationDAO reservationDAO) {
        this.reservationDAO = reservationDAO;
    }

    /**
     * Get all reservations within a date range for occupancy reporting.
     *
     * @param startDate start of the report period (inclusive)
     * @param endDate   end of the report period (inclusive)
     * @throws IllegalArgumentException if dates are null or end is before start
     */
    public List<Reservation> getOccupancyReport(LocalDate startDate, LocalDate endDate) {
        validateDateRange(startDate, endDate);

        return reservationDAO.findAll().stream()
                .filter(r -> !r.getCheckInDate().isBefore(startDate)
                          && !r.getCheckOutDate().isAfter(endDate))
                .collect(Collectors.toList());
    }

    /**
     * Get all active (non-cancelled) reservations.
     */
    public List<Reservation> getActiveReservations() {
        return reservationDAO.findAll().stream()
                .filter(r -> r.getStatus() != Reservation.Status.CANCELLED)
                .collect(Collectors.toList());
    }

    /**
     * Get a revenue and status summary map for a given date range.
     * Returns a map with keys: totalReservations, confirmedCount,
     * cancelledCount, checkedOutCount, checkedInCount.
     */
    public Map<String, Object> getRevenueSummary(LocalDate startDate, LocalDate endDate) {
        validateDateRange(startDate, endDate);

        List<Reservation> reservations = reservationDAO.findAll().stream()
                .filter(r -> !r.getCheckInDate().isBefore(startDate)
                          && !r.getCheckOutDate().isAfter(endDate))
                .collect(Collectors.toList());

        long confirmed   = reservations.stream().filter(r -> r.getStatus() == Reservation.Status.CONFIRMED).count();
        long checkedIn   = reservations.stream().filter(r -> r.getStatus() == Reservation.Status.CHECKED_IN).count();
        long checkedOut  = reservations.stream().filter(r -> r.getStatus() == Reservation.Status.CHECKED_OUT).count();
        long cancelled   = reservations.stream().filter(r -> r.getStatus() == Reservation.Status.CANCELLED).count();

        Map<String, Object> summary = new HashMap<>();
        summary.put("totalReservations", reservations.size());
        summary.put("confirmedCount",    (int) confirmed);
        summary.put("checkedInCount",    (int) checkedIn);
        summary.put("checkedOutCount",   (int) checkedOut);
        summary.put("cancelledCount",    (int) cancelled);
        summary.put("startDate",         startDate.toString());
        summary.put("endDate",           endDate.toString());

        return summary;
    }

    /**
     * Get all reservations filtered by status.
     *
     * @throws IllegalArgumentException if status is null
     */
    public List<Reservation> getReservationsByStatus(Reservation.Status status) {
        if (status == null) {
            throw new IllegalArgumentException("Status cannot be null");
        }
        return reservationDAO.findAll().stream()
                .filter(r -> r.getStatus() == status)
                .collect(Collectors.toList());
    }

    /**
     * Validate that the date range is valid.
     */
    private void validateDateRange(LocalDate startDate, LocalDate endDate) {
        if (startDate == null) {
            throw new IllegalArgumentException("Start date cannot be null");
        }
        if (endDate == null) {
            throw new IllegalArgumentException("End date cannot be null");
        }
        if (endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("End date cannot be before start date");
        }
    }
}

