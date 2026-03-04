package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.User;

import java.util.List;

/**
 * DAO interface for User data access operations.
 * Part of the DAO design pattern — abstracts persistence behind an interface.
 */
public interface UserDAO {

    User findByUsername(String username);

    User findById(int userId);

    boolean save(User user);

    boolean update(User user);

    /**
     * Delete a user by ID.
     */
    boolean delete(int userId);

    /**
     * Find all users with STAFF role.
     */
    List<User> findAllStaff();
}

