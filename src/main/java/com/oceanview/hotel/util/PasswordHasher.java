package com.oceanview.hotel.util;

import org.mindrot.jbcrypt.BCrypt;

// BCrypt password hashing helpers
public class PasswordHasher {

    private static final int SALT_ROUNDS = 12;

    private PasswordHasher() {}

    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(SALT_ROUNDS));
    }

    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
