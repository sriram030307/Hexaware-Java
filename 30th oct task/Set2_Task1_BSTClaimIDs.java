public class Set2_Task1_BSTClaimIDs {
    static class Node {
        int id;
        Node left, right;
        Node(int id) { this.id = id; }
    }
    static Node add(Node n, int x) {
        if (n == null) return new Node(x);
        if (x < n.id) n.left = add(n.left, x);
        else if (x > n.id) n.right = add(n.right, x);
        return n;
    }
    static boolean has(Node n, int x) {
        if (n == null) return false;
        if (n.id == x) return true;
        return x < n.id ? has(n.left, x) : has(n.right, x);
    }
    static void inorder(Node n) {
        if (n != null) { inorder(n.left); System.out.print(n.id + " "); inorder(n.right); }
    }
    static void preorder(Node n) {
        if (n != null) { System.out.print(n.id + " "); preorder(n.left); preorder(n.right); }
    }
    static void postorder(Node n) {
        if (n != null) { postorder(n.left); postorder(n.right); System.out.print(n.id + " "); }
    }
    public static void main(String[] args) {
        int[] ids = {50,30,70,20,40,60,80};
        Node root = null;
        for (int x : ids) root = add(root, x);
        System.out.print("Inorder: "); inorder(root);
        System.out.print("\\nPreorder: "); preorder(root);
        System.out.print("\\nPostorder: "); postorder(root);
        System.out.println("\\nClaim 60 found: " + has(root, 60));
    }
}
