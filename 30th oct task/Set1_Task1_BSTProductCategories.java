public class Set1_Task1_BSTProductCategories {
    static class Node {
        String key;
        Node left, right;
        Node(String key) { this.key = key; }
    }

    static Node insert(Node root, String key) {
        if (root == null) return new Node(key);
        int c = key.compareTo(root.key);
        if (c < 0) root.left = insert(root.left, key);
        else if (c > 0) root.right = insert(root.right, key);
        return root;
    }

    static boolean search(Node root, String key) {
        if (root == null) return false;
        if (root.key.equals(key)) return true;
        return key.compareTo(root.key) < 0
                ? search(root.left, key) : search(root.right, key);
    }

    static void inorder(Node n) {
        if (n != null) { inorder(n.left); System.out.print(n.key + " "); inorder(n.right); }
    }
    static void preorder(Node n) {
        if (n != null) { System.out.print(n.key + " "); preorder(n.left); preorder(n.right); }
    }
    static void postorder(Node n) {
        if (n != null) { postorder(n.left); postorder(n.right); System.out.print(n.key + " "); }
    }

    public static void main(String[] args) {
        String[] categories = {"Electronics", "Books", "Clothing", "Laptops", "Mobiles",
                "Fiction", "Nonfiction", "Men", "Women", "Shoes", "Home", "Kitchen",
                "Furniture", "Sports", "Toys"};
        Node root = null;
        for (String category : categories) root = insert(root, category);
        System.out.print("Inorder: "); inorder(root);
        System.out.print("\\nPreorder: "); preorder(root);
        System.out.print("\\nPostorder: "); postorder(root);
        System.out.println("\\nSearch Mobiles: " + search(root, "Mobiles"));
    }
}
