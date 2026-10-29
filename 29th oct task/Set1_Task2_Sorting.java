import java.util.Arrays;

public class Set1_Task2_Sorting {
    static void bubbleDescending(int[] a) {
        for (int i = 0; i < a.length - 1; i++) {
            for (int j = 0; j < a.length - 1 - i; j++) {
                if (a[j] < a[j + 1]) {
                    int t = a[j]; a[j] = a[j + 1]; a[j + 1] = t;
                }
            }
        }
    }
    public static void main(String[] args) {
        int[] values = {450, 1200, 99, 700, 320};
        int[] bubble = values.clone();
        bubbleDescending(bubble);

        int[] builtIn = values.clone();
        Arrays.sort(builtIn);
        for (int i = 0; i < builtIn.length / 2; i++) {
            int t = builtIn[i];
            builtIn[i] = builtIn[builtIn.length - 1 - i];
            builtIn[builtIn.length - 1 - i] = t;
        }
        System.out.println("Bubble descending: " + Arrays.toString(bubble));
        System.out.println("Built-in descending: " + Arrays.toString(builtIn));
        System.out.println("Bubble sort: O(n^2); built-in sort: O(n log n) typical.");
    }
}
