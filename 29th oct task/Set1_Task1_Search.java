import java.util.Arrays;

public class Set1_Task1_Search {
    public static void main(String[] args) {
        int[] ids = new int[50000];
        for (int i = 0; i < ids.length; i++) ids[i] = 100001 + i;
        int key = 125000;

        int checks = 0, found = -1;
        for (int i = 0; i < ids.length; i++) {
            checks++;
            if (ids[i] == key) { found = i; break; }
        }
        System.out.println("Orders loaded: " + ids.length);
        System.out.println("Linear: index=" + found + ", comparisons=" + checks);

        int left = 0, right = ids.length - 1;
        checks = 0; found = -1;
        while (left <= right) {
            checks++;
            int mid = left + (right - left) / 2;
            if (ids[mid] == key) { found = mid; break; }
            if (ids[mid] < key) left = mid + 1;
            else right = mid - 1;
        }
        System.out.println("Binary: index=" + found + ", comparisons=" + checks);
    }
}
