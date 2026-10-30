import java.util.*;

public class Set3_Task2_ParcelScanHashMap {
    record Scan(String tracking, String hub) {}
    public static void main(String[] args) {
        List<Scan> scans = List.of(
                new Scan("TRK101","CHN"), new Scan("TRK102","BLR"),
                new Scan("TRK101","CHN"), new Scan("TRK101","HYD"));
        Map<String, Set<String>> seen = new HashMap<>();
        for (Scan scan : scans) {
            Set<String> hubs = seen.computeIfAbsent(scan.tracking(), k -> new HashSet<>());
            if (!hubs.add(scan.hub()))
                System.out.println("REPEATED SCAN: " + scan.tracking() + " at " + scan.hub());
        }
        System.out.println("Tracking lookup TRK102: " + seen.containsKey("TRK102"));
    }
}
