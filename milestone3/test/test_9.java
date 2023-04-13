public class Rectangle {
  private int length;
  private int width;

  public Rectangle(int length, int width) {
    this.length = length;
    this.width = width;
  }

  public int area() {
    return this.length * this.width;
  }

  public static void main(String[] args) {
    Rectangle rectangle = new Rectangle(5, 10);
    int myarea = rectangle.area();
    System.out.println(myarea);
  }
}