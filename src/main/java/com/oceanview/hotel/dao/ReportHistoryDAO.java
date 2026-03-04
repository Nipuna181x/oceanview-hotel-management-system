package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.ReportHistory;

import java.util.List;

/**
 * DAO interface for ReportHistory persistence.
 */
public interface ReportHistoryDAO {
    int save(ReportHistory report);
    List<ReportHistory> findAll();
}

