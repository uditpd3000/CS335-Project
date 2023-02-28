class ReprChange<T extends ConvertibleTo<S>,S extends ConvertibleTo<T> > {
    {
        int a,b,c[][];
        public class ok{}
    }
}
// class Point extends ColoredPoint {}
// class ImaginaryNumber extends Number implements Arithmetic {}
// public final class ImaginaryNumber extends Number implements Arithmetic {}
// class ReprChange<T extends ConvertibleTo<S>,S extends ConvertibleTo<T> > {}
// // class Redundant implements java.lang.Cloneable, Cloneable{}

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
      Vector<string> str = new ArrayList<>();
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

      class Testarray{  
        public static void main(String args[]){  
        int a[]=new int[5];//declaration and instantiation  
        a[0]=10;//initialization  
        a[1]=20;  
        a[2]=70;  
        a[3]=40;  
        a[4]=50;  
        //traversing array  
        for(int i=0;i<a.length;i++)//length is the property of array  
        System.out.println(a);  
        }}

        class Testarray1{  
            public static void main(String args[]){  
            int arr[]={33,3,4,5};  
            //printing array using for-each loop  
            for(int i:arr)  
            System.out.println(i);  
            }}
            public class TypeCheck1 {
                public int a;
                float b;
            
                public TypeCheck1(int a1, int b1) {
                    this.a = a1;
                    this.b = b1;
                }
            
                public int getA() {
                    return this.a;
                }
            
                public float getB() {
                    return this.b;
                }
            
                public void setA(int a1) {
                    this.a = a1;
                }
            
                public void setB(float b1) {
                    this.b = b1;
                }
            
                public static void main(String[] args) {
                    TypeCheck1 obj = new TypeCheck1(1, 2);
            
                    // Same names
                    int a = obj.a;
                    float b = obj.b;
                    
                    // Different names
                    int c = obj.a;
                    float d = obj.b;
            
                    System.out.println("a: " );
                }
            }