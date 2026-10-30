import java.util.*;

public class Set3_Task3_HubNetworkBFSDFS {
    static void dfs(String v, Map<String, List<String>> graph, Set<String> seen) {
        if (!seen.add(v)) return;
        for (String w : graph.get(v)) dfs(w, graph, seen);
    }
    public static void main(String[] args) {
        Map<String, List<String>> graph = new LinkedHashMap<>();
        graph.put("CHN", List.of("BLR","HYD"));
        graph.put("BLR", List.of("CBE","MYS"));
        graph.put("HYD", List.of("PUN"));
        graph.put("CBE", List.of("MUM"));
        graph.put("MYS", List.of("CBE"));
        graph.put("PUN", List.of("DEL"));
        graph.put("MUM", List.of());
        graph.put("DEL", List.of());
        graph.put("KOL", List.of("DEL"));
        graph.put("JAI", List.of("PUN"));

        Queue<String> queue = new ArrayDeque<>();
        Map<String, String> parent = new HashMap<>();
        queue.add("CHN");
        parent.put("CHN", null);
        while (!queue.isEmpty()) {
            String v = queue.remove();
            for (String w : graph.get(v)) if (!parent.containsKey(w)) {
                parent.put(w, v);
                queue.add(w);
            }
        }
        List<String> path = new ArrayList<>();
        if (parent.containsKey("MUM")) {
            for (String v = "MUM"; v != null; v = parent.get(v)) path.add(v);
            Collections.reverse(path);
        }
        Set<String> visited = new LinkedHashSet<>();
        dfs("CHN", graph, visited);
        System.out.println("Fewest-hop route: " + path);
        System.out.println("Reachable from CHN: " + visited);
    }
}
