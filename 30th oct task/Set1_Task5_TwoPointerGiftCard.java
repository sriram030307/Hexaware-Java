public class Set1_Task5_TwoPointerGiftCard {
    public static void main(String[] args) {
        int[] values = {10,20,30,40,50,60,70};
        int target = 90, left = 0, right = values.length - 1;
        while (left < right) {
            int sum = values[left] + values[right];
            if (sum == target) {
                System.out.println(values[left] + " + " + values[right]);
                left++;
                right--;
            } else if (sum < target) left++;
            else right--;
        }
    }
}
