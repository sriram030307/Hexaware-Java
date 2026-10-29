import java.util.Arrays;

public class Set1_Task5_GreedyVsDP {
    public static void main(String[] args) {
        int[] coins = {4, 3, 1};
        int amount = 6, remaining = amount, greedyCount = 0;
        for (int coin : coins) {
            greedyCount += remaining / coin;
            remaining %= coin;
        }

        int[] dp = new int[amount + 1];
        Arrays.fill(dp, 999);
        dp[0] = 0;
        for (int x = 1; x <= amount; x++) {
            for (int coin : coins) {
                if (coin <= x) dp[x] = Math.min(dp[x], dp[x - coin] + 1);
            }
        }
        System.out.println("Greedy coins for 6: " + greedyCount);
        System.out.println("DP minimum coins for 6: " + dp[amount]);
        System.out.println("DP solution: 3 + 3");
    }
}
