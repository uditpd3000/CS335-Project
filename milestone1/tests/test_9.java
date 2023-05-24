import java.util.Scanner;

public class Division {
  public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);

    System.out.print("Enter the dividend: ");
    int dividend = scanner.nextInt();

    System.out.print("Enter the divisor: ");
    int divisor = scanner.nextInt();

  }

  private static void divide(int dividend, int divisor) {
    if (divisor == 0) {
      throw new ArithmeticException("Error: Division by zero");
    }
    return dividend / divisor;
  }
}
