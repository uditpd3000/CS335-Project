

public class Employee {
    private final int age;
    private double salary;

    // Constructor
    public Employee(String name, int ag, double salar) {
        this.age = ag;
        this.salary = salar;
        // this.salary = salary* 2 + salar + 10;
    }

    // Method declaration
    public void raiseSalary(double amount) {
        double newSalary ;
        newSalary = salary + amount;
        System.out.println("My salary is" + salary);
        // salary = newSalary;
    }
}
