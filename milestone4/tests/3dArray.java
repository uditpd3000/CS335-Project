public class MyProgram {

    public static void main(String[] args) {
        int data[][][] = new int[3][4][5];

        int i = 0;
        while (i < 3) {
            int j = 0;
            while (j < 4) {
                int k = 0;
                while (k < 5) {
                    data[i][j][k] = (i + 1) * (j + 1) * (k + 1);
                    k++;
                }
                j++;
            }
            i++;
        }

        i = 0;
        while (i < 3) {
            int j = 0;
            while (j < 4) {
                int k = 0;
                while (k < 5) {
                    System.out.println(data[i][j][k]);
                    k++;
                }
                // System.out.println();
                j++;
            }
            // System.out.println();
            i++;
        }
    }
}
