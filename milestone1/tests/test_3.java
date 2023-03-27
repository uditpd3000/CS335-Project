import java.util.Scanner; // import statement

public class MyProgram1 {
    //field declarations
    String x = "Charlie";
    public greetme(){
        System.out.println("Hello"+x+"dear");
    }
}

public class MyProgram2 {
    public static void greetOther(String[] args) {
        //using imported library
        Scanner scanner = new Scanner(System.in);
        x = scanner.nextLine();
        System.out.println("Hello"+x+"dear");
    }
}