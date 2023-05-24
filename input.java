public class SieveOfEratosthenesDemo {

    public static int sieveOfEratosthenes(int n) {
        int primes[] = new int [100];
        for (int i = 2; i * i <= n; i++) {
                    primes[i] = 1;
        }

        primes[0] = 0;
        primes[1] = 0;

        if(n==2) return 1;

        for (int i = 2; i * i <= n; i++) {
            if (primes[i]==1) {
                if(n%i==0) return 0;
                for (int j = i * i; j <= n; j += i) {
                    primes[j] = 0;
                }
            }
        }
        return 1;
    }

    public static void main(String[] args) {
        int n = 7;
        int x = 2;
        if(sieveOfEratosthenes(n)==1){
          System.out.println(n);
        }
    }
}