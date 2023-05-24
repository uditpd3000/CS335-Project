// Test Case 1 :: Nested Loops(For and while) and Ifs.

public class Prime {

    public static void main(String[] args) {

        int low = 20, high = 50;
        int arr[][] =new int[5][6];
        arr[3][2]=10;

        while (low < high) {
            boolean flag = false;

            for(int i = 2; i <= low/2; ++i) {
                // condition for nonprime number
                if(low % i == 0) {
                    flag = true;
                    break;
                }
            }

            if (!flag && low != 0 && low != 1)
                System.out.println(low);

            ++low;
        }
    }
}













