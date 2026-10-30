import java.util.*;

public class Set2_Task3_ClaimApprovalGraph {
    static boolean cycle(String v, Map<String, List<String>> graph,
                         Set<String> visiting, Set<String> done) {
        if (visiting.contains(v)) return true;
        if (done.contains(v)) return false;
        visiting.add(v);
        for (String w : graph.get(v))
            if (cycle(w, graph, visiting, done)) return true;
        visiting.remove(v);
        done.add(v);
        return false;
    }

    public static void main(String[] args) {
        Map<String, List<String>> graph = new LinkedHashMap<>();
        graph.put("registration", List.of("assessment"));
        graph.put("assessment", List.of("surveyor", "settlement"));
        graph.put("surveyor", List.of("settlement"));
        graph.put("settlement", List.of());

        String start = "registration", target = "settlement";
        Queue<String> queue = new ArrayDeque<>();
        Map<String, String> parent = new HashMap<>();
        queue.add(start);
        parent.put(start, null);
        while (!queue.isEmpty()) {
            String v = queue.remove();
            if (v.equals(target)) break;
            for (String w : graph.get(v)) if (!parent.containsKey(w)) {
                parent.put(w, v);
                queue.add(w);
            }
        }
        List<String> path = new ArrayList<>();
        if (parent.containsKey(target)) {
            for (String v = target; v != null; v = parent.get(v)) path.add(v);
            Collections.reverse(path);
        }
        System.out.println("Shortest path: " + path);
        Set<String> visiting = new HashSet<>(), done = new HashSet<>();
        System.out.println("Cycle detected: " + cycle(start, graph, visiting, done));
    }
}
