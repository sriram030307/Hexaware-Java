public class Set2_Task5_MinMax {
    static int[] minMax(int[] a, int low, int high) {
        if (low == high) return new int[]{a[low], a[low]};
        if (high == low + 1) return new int[]{Math.min(a[low], a[high]), Math.max(a[low], a[high])};
        int mid = low + (high - low) / 2;
        int[] left = minMax(a, low, mid);
        int[] right = minMax(a, mid + 1, high);
        return new int[]{Math.min(left[0], right[0]), Math.max(left[1], right[1])};
    }
    public static void main(String[] args) {
        int[] a = {120, 45, 980, 20, 500, 760, 35};
        int[] result = minMax(a, 0, a.length - 1);
        System.out.println("Minimum transaction: " + result[0]);
        System.out.println("Maximum transaction: " + result[1]);
        System.out.println("Brute-force scan time: O(n); divide-and-conquer time: O(n)");
    }
}
