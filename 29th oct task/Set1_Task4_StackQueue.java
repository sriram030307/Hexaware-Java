public class Set1_Task4_StackQueue {
    public static void main(String[] args) {
        int[] stack = new int[10];
        int top = -1;
        stack[++top] = 101;
        stack[++top] = 102;
        System.out.println("Undo last edit: " + stack[top--]);

        int[] queue = new int[10];
        int head = 0, tail = 0;
        queue[tail++] = 201;
        queue[tail++] = 202;
        System.out.println("Dispatch next: " + queue[head++]);
        System.out.println("Built-in alternative: ArrayDeque");
    }
}
