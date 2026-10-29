import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Set2_Task3_DuplicatePostings {
    static class Txn {
        String account, merchant; int amount; long seconds;
        Txn(String account, int amount, String merchant, long seconds) {
            this.account = account; this.amount = amount; this.merchant = merchant; this.seconds = seconds;
        }
    }
    public static void main(String[] args) {
        List<Txn> tx = Arrays.asList(
            new Txn("A10", 900, "ShopX", 1000),
            new Txn("A10", 900, "ShopX", 1040));
        Map<String, Long> last = new HashMap<String, Long>();
        for (Txn t : tx) {
            String key = t.account + "|" + t.amount + "|" + t.merchant;
            Long previous = last.get(key);
            if (previous != null && t.seconds - previous <= 60)
                System.out.println("POSSIBLE DUPLICATE: " + key + " in " + (t.seconds - previous) + " seconds");
            last.put(key, t.seconds);
        }
    }
}
