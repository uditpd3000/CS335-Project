// class first
//   {
//     int tui;
//     double x=0.2;
//     double zzzzzzzzzzz;
//     public int xza[][] = new int[4][5];
//       int Count(int a, int b, int c)
//       {
//           int i = a, cnt \= 0;
//           int aa[] = new int [4];
//           int lol = 1;
//           aa[1]=1;
//           while(i < b){
//               i = i + 1;
//               cnt = cnt + 1;
//           }
//           return cnt*c;
//       }
      
//       first(int zz){
//         this.Count(0, 1, 2);
//       }

//       static public void sum(){
//         int i=0;
//         while(i<10){
//           continue;
//           i=1;
//         }
//         return ;
//       }
// }

//   //     public void Main()
//   //     {
//   //         int i = 9,j=10,k=11;
//   //         // int sid[] = {4, 7, 8, 10};
//   //         // int xxx = 2+3;
//   //         int res = Count( i, j,k);
//   //         first fff = new first(0);
//   //         fff.tui = 1;
//   //         // first.sum();
//   //         // int res = Count(i, j, k);

//   //         // print(res);
//   //         // print("\n");
//   //     }
//   // }
// class second {
// //   private int xx=0;
//   public int tuii(){
//     first rr = new first(1);
//     // int j = rr.Count(1,2,3);
//     int j = rr.tui;
//     first ss = new first(2);
//     int k = ss.tui;
// //    private double tt = 0.1;
// //     // zzzzzzzzzzz = tt;
// //     // int rrr = Count(0, 0, 0);
// //     first ruru = new first(1);
// //     // second tutu = new first(2);
// //     // ruru.tui = 1;
// //     ruru.xza[4][2]=1+2;
// //     ruru.zzzzzzzzzzz = tt;
// //     ruru.Count(1,1,1);

// //     first fff = new first(0);
// //     ruru.tui= 1;

// //     byte a=1;
// //     short b=2;
// //     int c=3;
// //     long d=4;
// //     float e=5;
// //     double f=6;

// //     e=1*1.1;
// //     e=+1.1;
// //     ++f;
// //     f++;
// //     boolean p = true;
// //     p=~p;
// //     int i,pp;
// //     for(i=0;i<10;i++){
      
// //       for(i=5;i<10;i++){
// //       // while(i==1){
// //       //   t++;
// //       //   if(i<10){
// //       //     int j=10;
// //       //     continue;
// //       //   }
// //       //   else break;
// //       }
// //       pp++;

// //     }
// //     }
//     // boolean t=false;
//     // int i,j,k;
//     // i = t?i+j:k+i+j;
//     // // i++;
//     // a=c;
//     // a=d;
//     // a=e;
//     // a=f;

//     // b=a;
//     // b=c;
//     // b=d;
//     // b=e;
//     // b=f;

//     // c=a;
//     // c=b;
//     // c=d;
//     // c=e;
//     // c=f;

//     // d=a;
//     // d=b;
//     // d=c;
//     // d=e;
//     // d=f;

//     // e=a;
//     // e=b;
//     // e=c;
//     // e=d;
//     // e=f;

//     // f=a;
//     // f=b;
//     // f=c;
//     // f=d;
//     // f=e;

//     // e=6;
//     // if(1){
//     //   e++;
//     // }

//     // if(1==1.0);
//     // int z,y;
//     // boolean b;
//     // float a =0.01;
//     // double dd =4;
//     // dd = 0.2;
//     // long uuu= 1;
//     // long u1= z;
//     // z = uuu;


//   }
// }


// // Test Case 1 :: Nested Loops and Ifs.

// public class Prime {

//     public static void main(String[] args) {

//         int low = 20, high = 50;

//         while (low < high) {
//             boolean flag = false;

//             for(int i = 2; i <= low/2; ++i) {
//                 // condition for nonprime number
//                 if(low % i == 0) {
//                     flag = true;
//                     break;
//                 }
//             }

//             if (!flag && low != 0 && low != 1)
//                 System.out.println(low);

//             ++low;
//         }
//     }
// }


// // Test Case 2 :: Declaring and calling function from another function.

// public class Armstrong {

//     public static boolean checkArmstrong(int num) {
//         int digits = 0;
//         int result = 0;
//         int originalNumber = num;

//         // number of digits calculation
//         while (originalNumber != 0) {
//             originalNumber /= 10;
//             ++digits;
//         }

//         originalNumber = num;

//         // result contains sum of nth power of its digits
//         while (originalNumber != 0) {
//             int remainder = originalNumber % 10;
//             // result += Math.pow(remainder, digits);
//             originalNumber /= 10;
//         }

//         if (result == num)
//             return true;

//         return false;
//     }

//     public static void main(String[] args) {

//         int low = 999, high = 99999;

//         for(int number = low + 1; number < high; ++number) {

//             if (checkArmstrong(number))
//                 System.out.println(number);
//         }
//     }
// }

// // Test Case 3 :: Conditional Statement

// public class LargestNumberExample  
// {  
// public static void main(String args[])  
// {  
// int x=69;  
// int y=89;  
// int z=79;  
// boolean res=z<y;
// int largestNumber= res ? z : x;  
// // System.out.println(largestNumber);  
// }  
// }

// // Test Case 4 :: Array

// class Main {
//  public static void main(String[] args) {

//    int numbers[] = {2, -9, 0, 5, 12, -25, 22, 9, 8, 12};
//   // int numbers[];
//   // for(int i=0;i<10;i++){
//   //   numbers[i]=i;
//   // }
//    int sum = 0;
//    double average;
   
//    // access all elements using for each loop
//    // add each element in sum
//     int arrayLength = 10;

//    for (int i=0;i<arrayLength;i++) {
//      sum += numbers[i];
//    }
  
//    // get the total number of elements

//    // calculate the average
//    // convert the average from int to double
//    average =  sum/arrayLength;

//    System.out.println(sum);
//    System.out.println(average);
//  }
// }

// // Test Case 5 :: type casting


// public class typeCast{
//   public static void main(String[] args){
//       byte a=1;
//       short b=2;
//       int c=3;
//       long d=4;
//       float e=5;
//       double f=6;

//       e=1*1.1;
//       e=+1.1;
//       ++f;
//       f++;

//       f=c;
//       // c=f;

//   }
// }

// // Test Case 6 :: Recursion

// public class Main {
//   public static int sum(int start, int end) {
//     if (end > start) {
//       return end + sum(start, end - 1);
//     } else {
//       return end;
//     }
//   }
//   public static void main(String[] args) {
//     int result = sum(5, 10);
//     System.out.println(result);
//   }
// }

//Test Case 7 :: array initiazing
public class AddMatrices {
  // data = new int[] {1,2,3};
  public static void main(String[] args) {
      int rows = 4, columns = 3;
      int firstMatrix[][] = { {2, 3, 4}, {5, 2, 3} };
      int secondMatrix[][] = { {-4, 5, 3}, {5, 6, 3} };
      
      // System.out.println("k");

      // Adding Two matrices
      int sum[][] = new int[rows][columns];
      // int sum1[][] = new int[][]{{1,2},{2,2}};
      for(int i = 0; i < rows; i++) {
          for (int j = 0; j < columns; j++) {
            // int sum[][] = new int[rows][columns];
              sum[i][j] = firstMatrix[i][j] + secondMatrix[i][j];
              int sum1[][] = new int[][]{{1,2},{2,2}};
          }
      }

      // // Displaying the result
      System.out.println("Sum of two matrices is: ");
      // for(int row[] : sum1) {
      //     for (int column : row) {
      //         System.out.println("    ");
      //     }
      //     System.out.println("end");
      // }
  }
}