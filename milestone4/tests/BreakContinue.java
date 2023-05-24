public class BreakContinueDemo {
    public static void main(String[] args) {
        int nums[] = { 1, 2, 3, 4, 5 };

        // Break example
        for (int i = 0; i < 5; i++) {
            if (nums[i] == 3) {
                break;
            }
            System.out.println(nums[i]);
        }

        // Continue example
        for (int i = 0; i < 5; i++) {
            if (nums[i] == 3) {
                continue;
            }
            System.out.println(nums[i]);
        }
    }
}