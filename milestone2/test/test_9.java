
// Test Case 9 :: Full programme for calculating Simple and Compound Interest.

class SimpleInterest {
  public static void main(String[] args) {

    // take input from users
    System.out.println("Enter the principal: ");
    double principal = 10000;

    System.out.println("Enter the rate: ");
    double rate = 10;

    System.out.println("Enter the time: ");
    double time = 5;

    double interest = principal * time * rate / 100;

    System.out.println(principal);
    System.out.println(rate);
    System.out.println(time);
    System.out.println(interest);

  }
}


class CompoundInterest {
  public static void main(String[] args) {

    // take input from users
    System.out.println("Enter the principal: ");
    double principal = 10000;

    System.out.println("Enter the rate: ");
    double rate = 10;

    System.out.println("Enter the time: ");
    double time = 5;

    System.out.println("Enter number of times interest is compounded: ");
    int number = 4;

    double rateFactor=1;
    for(int i=0;i<time*number;i++){
        rateFactor=rateFactor*(1+rate/100);
    }
    double interest = principal * rateFactor - principal;

    System.out.println(principal);
    System.out.println(rate);
    System.out.println(time);
    System.out.println(number);
    System.out.println(interest);

  }
}