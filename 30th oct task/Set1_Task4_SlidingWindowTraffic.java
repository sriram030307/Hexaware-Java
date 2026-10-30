public class Set1_Task4_SlidingWindowTraffic {
    public static void main(String[] args) {
        int[] rpm = {120,150,180,90,210,240,200,160,130,110,100,90,
                80,100,120,140,160,180,200,220,240,260,230,190};
        int k = 3, sum = 0;
        for (int i = 0; i < k; i++) sum += rpm[i];
        int best = sum, bestStart = 0;
        for (int i = k; i < rpm.length; i++) {
            sum += rpm[i] - rpm[i - k];
            if (sum > best) { best = sum; bestStart = i - k + 1; }
        }
        System.out.println("Busiest 3-hour window: hours " + bestStart + "-" + (bestStart + 2));
        System.out.println("Requests in window: " + best);
        System.out.println("Average RPM: " + (best / 3.0));
    }
}
