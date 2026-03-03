package com.oceanview.hotel.dao;

import com.oceanview.hotel.model.User;

/**
 * DAO interface for User data access operations.
 * Part of the DAO design pattern — abstracts persistence behind an interface.
 */
public interface UserDAO {

    /**
     * Find a user by their username.
     * @param username the username to search for
     * @return the User object if found, null otherwise
     */
    User findByUsername(String username);

    /**
     * Find a user by their ID.
     * @param userId the user ID
     * @return the User object if found, null otherwise
     */
    User findById(int userId);

    /**
     * Save a new user to the database.
     * @param user the user to save
     * @return true if successful
     */
    boolean save(User user);

    /**
     * Update an existing user.
     * @param user the user to update
     * @return true if successful
     */
    boolean update(User user);
}

