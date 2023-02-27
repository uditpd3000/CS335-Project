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

// public class Main {
//   int x = 5;

//   public static void main(String[] args) {
//     Main myObj1 = new Main();  // Object 1
//     Main myObj2 = new Main();  // Object 2
//     System.out.println(myObj1.x);
//     System.out.println(myObj2.x);
//   }
// }