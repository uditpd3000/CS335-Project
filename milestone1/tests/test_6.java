

public class Employee {
    private final int age;
    private double salary;

    // Constructor
    public Employee(String name, int age, double salary) {
        this.age = age;
        this.salary = salary;
        this.salary = salary * 2 + salary + 10;
    }

    // Method declaration
    public void raiseSalary(double amount) {
        double newSalary = salary + amount;
        System.out.println("My salary is" + salary);
        salary = newSalary;
    }
}
