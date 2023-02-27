
class Point {}
class kucchbhilikho permits kucchbhi {

}
class Point extends ColoredPoint {}
class ImaginaryNumber extends Number implements Arithmetic {}
public final class ImaginaryNumber extends Number implements Arithmetic {}
class ReprChange<T extends ConvertibleTo<S>,S extends ConvertibleTo<T> > {}
class Redundant implements java.lang.Cloneable, Cloneable{}

public class Main {
  int x = 5;

  public static void main(String[] args) {
    Main myObj1 = new Main();  // Object 1
    Main myObj2 = new Main();  // Object 2
    System.out.println(myObj1.x);
    System.out.println(myObj2.x);
  }
}

public class IfExample {  
  public static void main(String[] args) {  
      //defining an 'age' variable  
      int age=20;  
      //checking the age  
      if(age>18){  
          System.out.println("Age is greater than 18");  
      }  
  }  
  } 

  public class IfElseExample {  
    public static void main(String[] args) {  
        //defining a variable  
        int number=13;  
        //Check if the number is divisible by 2 or not  
        if(number%2==0){  
            System.out.println("even number");  
        }else{  
            System.out.println("odd number");  
        }  
    }  
    } 

    public class LeapYearExample {    
      public static void main(String[] args) {    
          int year=2020;    
          if(((year % 4 ==0) && (year % 100 !=0)) || (year % 400==0)){  
              System.out.println("LEAP YEAR");  
          }  
          else{  
              System.out.println("COMMON YEAR");  
          }  
      }    
      } 