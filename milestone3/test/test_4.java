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

//    for (int i=0;i<arrayLength;i++) {
//      sum += numbers[i];
//    }

    for(int x:numbers){
        sum += x;
    }
  
   // get the total number of elements

   // calculate the average
   // convert the average from int to double
   average =  sum/arrayLength;

   System.out.println(sum);
   System.out.println(average);
 }
}

