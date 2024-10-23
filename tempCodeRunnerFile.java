import java.util.Stack;

public class NextGreaterElement {
    public static void findNextGreaterElements(Stack<Integer> stack) {
        Stack<Integer> tempStack = new Stack<>();
        int[] result = new int[stack.size()];

        for (int i = stack.size() - 1; i >= 0; i--) {
            int currElement = stack.get(i);

            while (!tempStack.isEmpty() && tempStack.peek() <= currElement) {
                tempStack.pop();
            }

            if (tempStack.isEmpty()) {
                result[i] = -1;
            } else {
                result[i] = tempStack.peek();
            }

            tempStack.push(currElement);
        }

        System.out.print("Output: ");
        for (int num : result) {
            System.out.print(num + ", ");
        }
    }

    public static void main(String[] args) {
        Stack<Integer> stack = new Stack<>();
        stack.push(5);
        stack.push(3);
        stack.push(8);
        stack.push(4);
        stack.push(2);
        stack.push(7);
        stack.push(1);
        stack.push(6);

        findNextGreaterElements(stack);
    }
}