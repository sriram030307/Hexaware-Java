public class Set3_Task4_WalkInQueueStack {
    public static void main(String[] args) {
        String[] queue = new String[10];
        int head = 0, tail = 0;
        queue[tail++] = "P201"; queue[tail++] = "P202";
        System.out.println("Next walk-in token: " + queue[head++]);

        String[] history = new String[10];
        int top = -1;
        history[++top] = "P100"; history[++top] = "P105";
        System.out.println("Most recently viewed: " + history[top--]);
    }
}
