package com.oceanview.hotel.util;

import org.mindrot.jbcrypt.BCrypt;
import java.io.FileWriter;

// Run this once to generate seed hashes for the DB — not used in production
public class GenerateHash {
    public static void main(String[] args) throws Exception {
        String adminHash = BCrypt.hashpw("admin123", BCrypt.gensalt(12));
        String staffHash = BCrypt.hashpw("staff123", BCrypt.gensalt(12));
        String out = "admin123 hash: " + adminHash + "\nstaff123 hash: " + staffHash + "\n";
        System.out.println(out);
        try (FileWriter fw = new FileWriter("hashes.txt")) {
            fw.write(out);
        }
    }
}
