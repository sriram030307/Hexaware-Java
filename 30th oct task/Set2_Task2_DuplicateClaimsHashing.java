import java.util.*;

public class Set2_Task2_DuplicateClaimsHashing {
    static String normalize(String s) {
        return s.replaceAll("\\\\s+", "").toUpperCase(Locale.ROOT);
    }
    public static void main(String[] args) {
        String[] policy = {" ab 120 ", "AB120", "xy-450"};
        String[] date = {"2026-10-01", "2026-10-01", "2026-10-02"};
        Set<String> seen = new HashSet<>();
        for (int i = 0; i < policy.length; i++) {
            String key = normalize(policy[i]) + "|" + date[i];
            if (!seen.add(key)) System.out.println("DUPLICATE CLAIM: " + key);
            else System.out.println("ACCEPTED: " + key);
        }
    }
}
