import java.util.Arrays;

public class Set2_Task5_MergeRegionalClaims {
    public static void main(String[] args) {
        int[] north = {101,104,109,115};
        int[] south = {102,104,110,120};
        int i = 0, j = 0, k = 0;
        int[] merged = new int[north.length + south.length];
        while (i < north.length && j < south.length) {
            if (north[i] <= south[j]) merged[k++] = north[i++];
            else merged[k++] = south[j++];
        }
        while (i < north.length) merged[k++] = north[i++];
        while (j < south.length) merged[k++] = south[j++];
        System.out.println("Merged claims: " + Arrays.toString(merged));
    }
}
