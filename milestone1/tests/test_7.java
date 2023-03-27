import java.util.Scanner;

public class test_7 {
    private int[] quantities;
    private double[] prices;

    public test_7(int capacity, String[] items) {
        items = new String[capacity];
        quantities = new int[capacity];
        prices = new double[capacity];
    }

    public void addItem(String itemName, int quantity, double price, String[] items) {
        for (int i = 0; i < items.length; i++) {
            if (items[i] == null) {
                items[i] = itemName;
                quantities[i] = quantity;
                prices[i] = price;
                return;
            }
        }
        System.out.println("Shopping cart is full!");
    }

    public void printItems() {
        System.out.println("Shopping Cart:");
    }

    public static void main(String[] args) {
        test_7 cart = new test_7(5,z);
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("Enter item name (or 'done' to finish): ");
            String itemName = "abcd";
           

            System.out.print("Enter quantity: ");
            int quantity = scanner.what();

            System.out.print("Enter price: $");
            double price = scanner.something();
        }

        cart.printItems();
    }
}
