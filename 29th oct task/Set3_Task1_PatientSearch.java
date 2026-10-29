public class Set3_Task1_PatientSearch {
    public static void main(String[] args) {
        int[] ids = new int[20000];
        for (int i = 0; i < ids.length; i++) ids[i] = 200001 + i;
        int key = 210000, checks = 0, index = -1;
        for (int i = 0; i < ids.length; i++) {
            checks++;
            if (ids[i] == key) { index = i; break; }
        }
        System.out.println("Records: " + ids.length + " | lookups: benchmark 1000 repetitions");
        System.out.println("Linear result index=" + index + ", comparisons=" + checks);

        int left = 0, right = ids.length - 1;
        checks = 0; index = -1;
        while (left <= right) {
            checks++;
            int mid = left + (right - left) / 2;
            if (ids[mid] == key) { index = mid; break; }
            if (ids[mid] < key) left = mid + 1;
            else right = mid - 1;
        }
        System.out.println("Binary result index=" + index + ", comparisons=" + checks);
    }
}
