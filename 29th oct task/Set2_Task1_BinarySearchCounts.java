public class Set2_Task1_BinarySearchCounts {
    public static void main(String[] args) {
        int n = 100000;
        int[] ids = new int[n];
        for (int i = 0; i < n; i++) ids[i] = i + 1;
        System.out.println("Records: " + n);
        System.out.println("Best binary-search comparisons: 1");
        System.out.println("Typical/worst binary-search comparisons: about 17");
        System.out.println("Linear best: 1; average successful: about 50000; worst: 100000");
        System.out.println("Assumption: IDs are sorted; successful linear-search targets are uniformly distributed.");
    }
}
