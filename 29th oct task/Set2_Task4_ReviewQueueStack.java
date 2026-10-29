public class Set2_Task4_ReviewQueueStack {
    public static void main(String[] args) {
        int[] queue = new int[10];
        int head = 0, tail = 0;
        queue[tail++] = 7001; queue[tail++] = 7002;
        System.out.println("Review first: " + queue[head++]);

        int[] stack = new int[10];
        int top = -1;
        stack[++top] = 51; stack[++top] = 52;
        System.out.println("Reverse last adjustment: " + stack[top--]);
    }
}
