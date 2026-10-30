import java.util.*;

public class Set1_Task3_MicroserviceGraph {
    public static void main(String[] args) {
        Map<String, List<String>> graph = new LinkedHashMap<>();
        graph.put("cart", List.of("pricing"));
        graph.put("pricing", List.of("inventory"));
        graph.put("inventory", List.of("payment"));
        graph.put("payment", List.of());

        Map<String, Integer> indegree = new HashMap<>();
        for (String v : graph.keySet()) indegree.put(v, 0);
        for (String v : graph.keySet())
            for (String w : graph.get(v)) indegree.put(w, indegree.get(w) + 1);

        Queue<String> queue = new ArrayDeque<>();
        for (String v : graph.keySet()) if (indegree.get(v) == 0) queue.add(v);
        List<String> order = new ArrayList<>();
        while (!queue.isEmpty()) {
            String v = queue.remove();
            order.add(v);
            for (String w : graph.get(v)) {
                indegree.put(w, indegree.get(w) - 1);
                if (indegree.get(w) == 0) queue.add(w);
            }
        }
        System.out.println("Deployment order: " + order);
        System.out.println("Circular dependency: " + (order.size() != graph.size()));
    }
}
