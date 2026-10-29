import java.util.Arrays;

public class Set3_Task5_AppointmentDP {
    public static void main(String[] args) {
        int[] start = {9, 9, 10, 11};
        int[] end = {10, 12, 11, 12};
        int n = start.length;
        int[] dp = new int[n + 1];

        for (int i = 1; i <= n; i++) {
            int previous = i - 2;
            while (previous >= 0 && end[previous] > start[i - 1]) previous--;
            dp[i] = Math.max(dp[i - 1], 1 + dp[previous + 1]);
        }
        System.out.println("DP table: " + Arrays.toString(dp));
        System.out.println("Maximum compatible appointments: " + dp[n]);
        System.out.println("For unweighted intervals, earliest-finish greedy is optimal.");
    }
}
