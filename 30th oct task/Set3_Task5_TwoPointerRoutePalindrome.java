public class Set3_Task5_TwoPointerRoutePalindrome {
    public static void main(String[] args) {
        String route = "CHN-BLR / CBE / BLR-CHN";
        StringBuilder clean = new StringBuilder();
        for (char c : route.toUpperCase().toCharArray())
            if (Character.isLetterOrDigit(c)) clean.append(c);

        int left = 0, right = clean.length() - 1;
        boolean palindrome = true;
        while (left < right) {
            if (clean.charAt(left) != clean.charAt(right)) {
                palindrome = false;
                break;
            }
            left++;
            right--;
        }
        System.out.println("Normalised route: " + clean);
        System.out.println("Palindrome: " + palindrome);
    }
}
