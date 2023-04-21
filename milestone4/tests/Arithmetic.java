public class ArithmeticOperatorsDemo {
    public static void main(String[] args) {
        int num1 = 10;
        int num2 = 3;

        // Addition
        int sum = num1 + num2;
        System.out.println(sum);

        // Subtraction
        int diff = num1 - num2;
        System.out.println(diff);

        // Multiplication
        int product = num1 * num2;
        System.out.println(product);

        // Division
        int quotient = num1 / num2;
        System.out.println(quotient);

        // Modulus
        int remainder = num1 % num2;
        System.out.println(remainder);

        // Increment
        int num3 = 5;
        System.out.println(num3);
        num3++;
        System.out.println(num3);

        // Decrement
        int num4 = 7;
        System.out.println(num4);
        num4--;
        System.out.println(num4);

        num1 = 7; // binary: 0111
        num2 = 5; // binary: 0101

        // Bitwise AND
        int andResult = num1 & num2; // binary: 0101
        System.out.println(andResult);

        // Bitwise OR
        int orResult = num1 | num2; // binary: 0111
        System.out.println(orResult);

        // Bitwise XOR
        int xorResult = num1 ^ num2; // binary: 0010
        System.out.println(xorResult);

        // Bitwise NOT
        int notResult1 = ~num1; // binary: 1000 0000 0000 0110 (two's complement)
        System.out.println(notResult1);
        int notResult2 = ~num2; // binary: 1111 1111 1111 1010 (two's complement)
        System.out.println(notResult2);

        // Left shift
        int leftShiftResult = num1 << 2; // binary: 11100 (28 in decimal)
        System.out.println(leftShiftResult);

        // Right shift
        int rightShiftResult = num1 >> 2; // binary: 0001 (1 in decimal)
        System.out.println(rightShiftResult);
    }
}