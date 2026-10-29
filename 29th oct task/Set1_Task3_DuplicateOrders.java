import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Set1_Task3_DuplicateOrders {
    static class Order {
        String customer; int amount; String minute;
        Order(String customer, int amount, String minute) {
            this.customer = customer; this.amount = amount; this.minute = minute;
        }
    }
    public static void main(String[] args) {
        List<Order> orders = Arrays.asList(
            new Order("C101", 500, "10:31"),
            new Order("C205", 250, "10:32"),
            new Order("C101", 500, "10:31"));
        Set<String> seen = new HashSet<String>();
        for (Order o : orders) {
            String key = o.customer + "|" + o.amount + "|" + o.minute;
            if (!seen.add(key)) System.out.println("DUPLICATE: " + key);
        }
    }
}
