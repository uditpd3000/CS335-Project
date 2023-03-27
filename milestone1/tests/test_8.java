

public class Fibonacci {
    private int[] memo;

    public Fibonacci(int n) {
        memo = new int[n + 1];
    }

    public int fib(int n) {
        if (n == 0 || n == 1) {
            return n;
        }

        if (memo[n] != 0) {
            return memo[n];
        }

        int result = fib(n - 1) + fib(n - 2);
        memo[n] = result;
        return result;
    }

    public static void main(String[] args) {
        Fibonacci fib = new Fibonacci(10);

        for (int i = 0; i <= 10; i++) {
            System.out.println("Fibonacci(" + i + ") = " + fib.fib(i));
        }
    }
}