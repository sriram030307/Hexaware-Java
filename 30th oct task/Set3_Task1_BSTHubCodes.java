public class Set3_Task1_BSTHubCodes {
    static class Node {
        String code;
        Node left, right;
        Node(String code) { this.code = code; }
    }
    static Node insert(Node n, String x) {
        if (n == null) return new Node(x);
        int c = x.compareTo(n.code);
        if (c < 0) n.left = insert(n.left, x);
        else if (c > 0) n.right = insert(n.right, x);
        return n;
    }
    static boolean search(Node n, String x) {
        if (n == null) return false;
        if (n.code.equals(x)) return true;
        return x.compareTo(n.code) < 0 ? search(n.left, x) : search(n.right, x);
    }
    static int height(Node n) {
        if (n == null) return 0;
        return 1 + Math.max(height(n.left), height(n.right));
    }
    public static void main(String[] args) {
        String[] codes = {"CHN","BLR","CBE","HYD","DEL","MUM","PUN"};
        Node root = null;
        for (String s : codes) root = insert(root, s);
        System.out.println("Height (nodes): " + height(root));
        System.out.println("Search HYD: " + search(root, "HYD"));
        Node sorted = null;
        for (String s : new String[]{"A","B","C","D","E"}) sorted = insert(sorted, s);
        System.out.println("Height after sorted insertion: " + height(sorted));
    }
}
