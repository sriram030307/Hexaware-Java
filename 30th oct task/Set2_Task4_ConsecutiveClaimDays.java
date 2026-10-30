public class Set2_Task4_ConsecutiveClaimDays {
    public static void main(String[] args) {
        int[] claims = {80,120,135,150,90,110,125,140,160,70,105,115};
        int best = 0, current = 0, bestEnd = -1;
        for (int i = 0; i < claims.length; i++) {
            if (claims[i] > 100) {
                current++;
                if (current > best) { best = current; bestEnd = i; }
            } else current = 0;
        }
        int start = bestEnd - best + 1;
        System.out.println("Longest run length: " + best);
        System.out.println("Day indexes: " + start + " to " + bestEnd);
    }
}
