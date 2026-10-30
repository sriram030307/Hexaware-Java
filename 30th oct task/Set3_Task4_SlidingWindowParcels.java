public class Set3_Task4_SlidingWindowParcels {
    public static void main(String[] args) {
        int[] parcels = {20,25,30,35,40,45,50,55,60,65,70,75};
        int k = 4, sum = 0;
        for (int i = 0; i < k; i++) sum += parcels[i];
        int best = sum, bestStart = 0;
        for (int i = k; i < parcels.length; i++) {
            sum += parcels[i] - parcels[i - k];
            if (sum > best) { best = sum; bestStart = i - k + 1; }
        }
        System.out.println("Best 4-hour window: " + bestStart + "-" + (bestStart + 3));
        System.out.println("Total parcels: " + best);
        System.out.println("Average per hour: " + (best / (double) k));
    }
}
