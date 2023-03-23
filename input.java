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

// Test Case 3 :: Nested Conditional Statement

// public class LargestNumberExample  
// {  
// public static void main(String args[])  
// {  
// int x=69;  
// int y=89;  
// int z=79;  
// boolean res=false;
// int largestNumber= res ? z : x;  
// // System.out.println(largestNumber);  
// }  
// }

// Test Case 4 :: 












public class Prime {

    public void fun1(float a,float b){
      float c=a+b;
      return;
    }

    public static void main(String[] args) {

        // final float x=10;
        // float y;
        // y=x;

        // fun1(x,y);




        // x++;
    // byte a=1;
    // short b=2;
    // int c=3;
    // long d=4;
    // float e=5;
    // double f=6;

    // e=1*1.1;
    // e=+1.1;
    // ++f;
    // f++;
    // boolean p = true;
    // p=~p;
    // int i,t;
    // for(i=0;i<10;i++){
      
    //   for(i=5;i<10;i++){
    //   // while(i==1){
    //   //   t++;
    //   //   if(i<10){
    //   //     int j=10;
    //   //     continue;
    //   //   }
    //   //   else break;
    //   }
    //   t++;

    // // }
    // }
    int j=6,k=7;
    boolean t=j>5;
    int i = t ? j+k : k-j;
    // if(j>5) k++;

//     int x=69;  
// int y=89;  
// int z=79;  
// boolean res=false;
// int largestNumber= res ? z : x;  
    // i++;
    // a=c;
    // a=d;
    // a=e;
    // a=f;


        // int low = 20, high = 50;

        // if(low==1)
        // System.out.println(low);

        // while (low < high) {
        //     boolean flag = false;
        //     System.out.println(low);

        //     for(int i = 2; i <= low/2; ++i) {
        //         // condition for nonprime number
        //         if(low % i == 0) {
        //             flag = true;
        //             int ii,j,k;
        //             ii = t?j+k:j-k;
        //             break;
        //         }
        //         System.out.println(low);
        //     }

        //     if (!flag && low != 0 && low != 1)
        //     low++;
        //         // System.out.println("harshit");

        //     ++low;
        // }
    }
}
