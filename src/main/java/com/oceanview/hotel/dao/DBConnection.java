package com.oceanview.hotel.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// Singleton DB connection — double-checked locking to stay thread-safe
public class DBConnection {

	private static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/oceanviewresort_hms";
	private static final String DB_USER = "root";
	private static final String DB_PASSWORD = "";

	private static DBConnection instance;
	private Connection connection;

	private DBConnection() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			this.connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
	}

	public static DBConnection getInstance() {
		if (instance == null) {
			synchronized (DBConnection.class) {
				if (instance == null) {
					instance = new DBConnection();
				}
			}
		}
		return instance;
	}

	public Connection getConnection() {
		return connection;
	}
}
