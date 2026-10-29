public class Set2_Task2_SortStability {
    static class Txn {
        String id; int time; int amount;
        Txn(String id, int time, int amount) { this.id = id; this.time = time; this.amount = amount; }
    }
    public static void main(String[] args) {
        Txn[] tx = {new Txn("T1", 930, 100), new Txn("T2", 915, 250), new Txn("T3", 930, 75)};
        for (int i = 1; i < tx.length; i++) {
            Txn key = tx[i];
            int j = i - 1;
            while (j >= 0 && tx[j].time > key.time) { tx[j + 1] = tx[j]; j--; }
            tx[j + 1] = key;
        }
        for (Txn t : tx) System.out.println(t.id + " " + t.time + " amount=" + t.amount);
        System.out.println("Equal timestamp order T1 then T3 is preserved (stable).");
    }
}
