public class AddMatrices {
  // data = new int[] {1,2,3};
  public static void main(String[] args) {
      int rows = 4, columns = 3;
      int firstMatrix[][] = { {2, 3, 4}, {5, 2, 3} };
      int secondMatrix[][] = { {-4, 5, 3}, {5, 6, 3} };
      
      // System.out.println("k");

      // Adding Two matrices
      int sum[][] = new int[rows][columns];
      int sum1[][] = new int[][]{{1,2},{2,2}};
      for(int i = 0; i < rows; i++) {
          for (int j = 0; j < columns; j++) {
              sum[i][j] = firstMatrix[i][j] + secondMatrix[i][j];
          }
      }

      // // Displaying the result
      System.out.println("Sum of two matrices is: ");
      for(int row[] : sum) {
          for (int column : row) {
              System.out.println("    ");
          }
          System.out.println("end");
      }
  }
}