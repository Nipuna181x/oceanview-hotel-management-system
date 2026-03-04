package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.SystemLog;

import java.util.List;

/**
 * DAO interface for SystemLog data access operations.
 * DAO Pattern — abstracts all audit log persistence behind an interface.
 */
public interface SystemLogDAO {

    int save(SystemLog log);

    List<SystemLog> findAll();

    List<SystemLog> findByUserId(int userId);

    List<SystemLog> findByAction(String action);
}

