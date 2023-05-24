// Java program to demonstrate that
// The static method does not have
// access to the instance variable

public class Static {
    // static variable
    static int a = 40;

    Static() {
    }

    // instance variable
    int b = 50;

    void simpleDisplay() {
        System.out.println(a);
        System.out.println(b);
    }

    // Declaration of a static method.
    static void staticDisplay() {
        // int aa = b;
        Static obj = new Static();
        System.out.println(obj.b);
    }

    // main method
    public static void main(String[] args) {
        Static obj = new Static();
        obj.simpleDisplay();

        // Calling static method.
        staticDisplay();
    }
}
