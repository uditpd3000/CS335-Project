public class Example {
   int x;

   Example() {
      this.x = 0;
   }

   public void method3() {
      System.out.println("Inside method3");
   }

   public void method2() {
      System.out.println("Inside method2");
      method3();
   }

   public void method1() {
      System.out.println("Inside method1");
      method2();
   }

   public static void main(String[] args) {
      Example example = new Example();
      example.method1();
   }
}