package com.oceanview.hotel.dao;

import java.sql.Connection;

// Thin wrapper so controllers don't have to call DBConnection.getInstance() directly
public class DBConnectionFactory {

    public static Connection getConnection() {
        return DBConnection.getInstance().getConnection();
    }
}
