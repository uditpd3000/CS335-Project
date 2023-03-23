// Test Case 1 :: Nested Loops and Ifs.

public class Prime {

    public static void main(String[] args) {

        int low = 20, high = 50;

        while (low < high) {
            boolean flag = false;

            for(int i = 2; i <= low/2; ++i) {
                // condition for nonprime number
                if(low % i == 0) {
                    flag = true;
                    break;
                }
            }

            if (!flag && low != 0 && low != 1)
                System.out.println(low);

            ++low;
        }
    }
}


// Test Case 2 :: Declaring and calling function from another function.

public class Armstrong {

    public static boolean checkArmstrong(int num) {
        int digits = 0;
        int result = 0;
        int originalNumber = num;

        // number of digits calculation
        while (originalNumber != 0) {
            originalNumber /= 10;
            ++digits;
        }

        originalNumber = num;

        // result contains sum of nth power of its digits
        while (originalNumber != 0) {
            int remainder = originalNumber % 10;
            // result += Math.pow(remainder, digits);
            originalNumber /= 10;
        }

        if (result == num)
            return true;

        return false;
    }

    public static void main(String[] args) {

        int low = 999, high = 99999;

        for(int number = low + 1; number < high; ++number) {

            if (checkArmstrong(number))
                System.out.println(number);
        }
    }
}

// Test Case 3 :: Conditional Statement

public class LargestNumberExample  
{  
public static void main(String args[])  
{  
int x=69;  
int y=89;  
int z=79;  
boolean res=z<y;
int largestNumber= res ? z : x;  
// System.out.println(largestNumber);  
}  
}

// Test Case 4 :: Array

class Main {
 public static void main(String[] args) {

   int numbers[] = {2, -9, 0, 5, 12, -25, 22, 9, 8, 12};
  // int numbers[];
  // for(int i=0;i<10;i++){
  //   numbers[i]=i;
  // }
   int sum = 0;
   double average;
   
   // access all elements using for each loop
   // add each element in sum
    int arrayLength = 10;

   for (int i=0;i<arrayLength;i++) {
     sum += numbers[i];
   }
  
   // get the total number of elements

   // calculate the average
   // convert the average from int to double
   average =  sum/arrayLength;

   System.out.println(sum);
   System.out.println(average);
 }
}

// Test Case 5 :: type casting


public class typeCast{
  public static void main(String[] args){
      byte a=1;
      short b=2;
      int c=3;
      long d=4;
      float e=5;
      double f=6;

      e=1*1.1;
      e=+1.1;
      ++f;
      f++;

      f=c;
      // c=f;

  }
}

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










