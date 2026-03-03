package com.oceanview.hotel.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for password hashing and verification using BCrypt.
 *
 * Design Pattern: Utility / Helper class
 * BCrypt is the industry standard for password hashing — it is salted,
 * adaptive, and computationally expensive to brute-force.
 */
public class PasswordHasher {

    private static final int SALT_ROUNDS = 12;

    // Private constructor — utility class, not instantiable
    private PasswordHasher() {
    }

    /**
     * Hash a plain-text password using BCrypt.
     * @param plainPassword the password to hash
     * @return BCrypt hash string
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(SALT_ROUNDS));
    }

    /**
     * Verify a plain-text password against a BCrypt hash.
     * @param plainPassword the plain-text password
     * @param hashedPassword the BCrypt hash
     * @return true if the password matches the hash
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}

