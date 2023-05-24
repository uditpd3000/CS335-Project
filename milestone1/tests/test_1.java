class ReprChange<T extends ConvertibleTo<S>,S extends ConvertibleTo<T> > {
    public class Main {
    int x,y=0;  // Create a class attribute
  
    // Create a class constructor for the Main class
    public Main() {
      x = 5;  // Set the initial value for the class attribute x
    }
     
    // method declaration
    public static void main(String[] args) {
       Main obj = new Main() ;
    }
  }
}