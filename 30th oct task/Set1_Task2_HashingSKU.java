import java.util.*;

public class Set1_Task2_HashingSKU {
    static class ChainedHash {
        private final List<String>[] buckets;

        @SuppressWarnings("unchecked")
        ChainedHash(int size) {
            buckets = new ArrayList[size];
            for (int i = 0; i < size; i++) buckets[i] = new ArrayList<>();
        }
        int index(String key) { return Math.floorMod(key.hashCode(), buckets.length); }
        void put(String key) { buckets[index(key)].add(key); }
        boolean contains(String key) { return buckets[index(key)].contains(key); }
    }

    public static void main(String[] args) {
        ChainedHash table = new ChainedHash(5);
        table.put("SKU-100");
        table.put("SKU-105");
        System.out.println("Collision bucket: " + table.index("SKU-100")
                + " and " + table.index("SKU-105"));
        System.out.println("Chaining lookup SKU-105: " + table.contains("SKU-105"));

        Map<String, Integer> map = new HashMap<>();
        for (int i = 0; i < 100_000; i++) map.put("SKU-" + i, i);
        long start = System.nanoTime();
        for (int i = 0; i < 100_000; i++) map.get("SKU-" + i);
        long elapsed = System.nanoTime() - start;
        System.out.println("HashMap records: " + map.size());
        System.out.println("100000 lookups ns: " + elapsed);
    }
}
