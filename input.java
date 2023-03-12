public static class Fibonacci { //1
    public int memo;

    public Fibonacci(int n) {
        memo = new int[n + 1];
    }

    private int fib(int n, int z) {
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
}
class Myclass{

    public class Onemore{
        public static void fatak(char z){

        }
    }

    public Myclass(int n) {
        memo11 = new int[n + 1];
    }

    private int fib11(int n, int z) {
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

}