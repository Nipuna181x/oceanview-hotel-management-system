package com.oceanview.hotel.service;

import com.oceanview.hotel.dao.BillDAO;
import com.oceanview.hotel.dao.ReportHistoryDAO;
import com.oceanview.hotel.dao.ReservationDAO;
import com.oceanview.hotel.model.Bill;
import com.oceanview.hotel.model.ReportHistory;
import com.oceanview.hotel.model.Reservation;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Service class for generating occupancy and revenue reports.
 */
public class ReportService {

    private final ReservationDAO reservationDAO;
    private final BillDAO billDAO;
    private final ReportHistoryDAO reportHistoryDAO;

    public ReportService(ReservationDAO reservationDAO, BillDAO billDAO, ReportHistoryDAO reportHistoryDAO) {
        this.reservationDAO   = reservationDAO;
        this.billDAO          = billDAO;
        this.reportHistoryDAO = reportHistoryDAO;
    }

    /**
     * Get all reservations within a date range for occupancy reporting.
     */
    public List<Reservation> getOccupancyReport(LocalDate startDate, LocalDate endDate) {
        validateDateRange(startDate, endDate);
        return reservationDAO.findAll().stream()
                .filter(r -> !r.getCheckInDate().isBefore(startDate)
                          && !r.getCheckInDate().isAfter(endDate))
                .collect(Collectors.toList());
    }

    /**
     * Get a revenue and status summary map for a given date range.
     * Also calculates total revenue from bills for reservations in range.
     */
    public Map<String, Object> getRevenueSummary(LocalDate startDate, LocalDate endDate) {
        validateDateRange(startDate, endDate);

        List<Reservation> reservations = getOccupancyReport(startDate, endDate);

        long confirmed  = reservations.stream().filter(r -> r.getStatus() == Reservation.Status.CONFIRMED).count();
        long checkedIn  = reservations.stream().filter(r -> r.getStatus() == Reservation.Status.CHECKED_IN).count();
        long checkedOut = reservations.stream().filter(r -> r.getStatus() == Reservation.Status.CHECKED_OUT).count();
        long cancelled  = reservations.stream().filter(r -> r.getStatus() == Reservation.Status.CANCELLED).count();

        // Calculate total revenue from bills linked to reservations in this range
        double totalRevenue = reservations.stream()
                .filter(r -> r.getStatus() == Reservation.Status.CHECKED_OUT)
                .mapToDouble(r -> {
                    Bill bill = billDAO.findByReservationId(r.getReservationId());
                    return bill != null ? bill.getTotalAmount() : 0.0;
                })
                .sum();

        // Per-room-type revenue breakdown
        Map<String, Double> revenueByType = new HashMap<>();
        reservations.stream()
                .filter(r -> r.getStatus() == Reservation.Status.CHECKED_OUT && r.getRoom() != null)
                .forEach(r -> {
                    Bill bill = billDAO.findByReservationId(r.getReservationId());
                    if (bill != null) {
                        String type = r.getRoom().getRoomType().name();
                        revenueByType.merge(type, bill.getTotalAmount(), Double::sum);
                    }
                });

        Map<String, Object> summary = new HashMap<>();
        summary.put("totalReservations", reservations.size());
        summary.put("confirmedCount",    (int) confirmed);
        summary.put("checkedInCount",    (int) checkedIn);
        summary.put("checkedOutCount",   (int) checkedOut);
        summary.put("cancelledCount",    (int) cancelled);
        summary.put("totalRevenue",      Math.round(totalRevenue * 100.0) / 100.0);
        summary.put("revenueByType",     revenueByType);
        summary.put("startDate",         startDate.toString());
        summary.put("endDate",           endDate.toString());
        return summary;
    }

    /**
     * Save a report snapshot to history.
     */
    public void saveReportHistory(Map<String, Object> summary, LocalDate from, LocalDate to, int generatedBy) {
        ReportHistory rh = new ReportHistory();
        rh.setReportType("OCCUPANCY_REVENUE");
        rh.setFromDate(from);
        rh.setToDate(to);
        rh.setTotalReservations((Integer) summary.getOrDefault("totalReservations", 0));
        rh.setConfirmedCount((Integer) summary.getOrDefault("confirmedCount", 0));
        rh.setCheckedInCount((Integer) summary.getOrDefault("checkedInCount", 0));
        rh.setCheckedOutCount((Integer) summary.getOrDefault("checkedOutCount", 0));
        rh.setCancelledCount((Integer) summary.getOrDefault("cancelledCount", 0));
        rh.setTotalRevenue((Double) summary.getOrDefault("totalRevenue", 0.0));
        rh.setGeneratedBy(generatedBy);
        reportHistoryDAO.save(rh);
    }

    /**
     * Get all past report history entries, newest first.
     */
    public List<ReportHistory> getReportHistory() {
        return reportHistoryDAO.findAll();
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
     * Get all reservations filtered by status.
     */
    public List<Reservation> getReservationsByStatus(Reservation.Status status) {
        if (status == null) throw new IllegalArgumentException("Status cannot be null");
        return reservationDAO.findAll().stream()
                .filter(r -> r.getStatus() == status)
                .collect(Collectors.toList());
    }

    private void validateDateRange(LocalDate startDate, LocalDate endDate) {
        if (startDate == null) throw new IllegalArgumentException("Start date cannot be null");
        if (endDate == null)   throw new IllegalArgumentException("End date cannot be null");
        if (endDate.isBefore(startDate)) throw new IllegalArgumentException("End date cannot be before start date");
    }
}

