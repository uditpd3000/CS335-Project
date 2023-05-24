import java.util.Stack;

public class Parser {

  public Parser(String input) {
    private String input;
  private Stack<Character> stack; 

    this.input = input;
    this.stack = new Stack<Character>();
  }

  public void parse() {
    int index = 0;
    while (index < input.length()) {
      char symbol = input.charAt(index);
      if (symbol == '(') {
        stack.push('(');
      } else if (symbol == ')') {
        if (stack.empty()) {
          System.out.println("Error: unexpected ')'");
          return;
        }
        stack.pop();
      } else if (isOperator(symbol)) {
        if (stack.empty()) {
          System.out.println("Error: operator with no operands");
          return;
        }
        char top = stack.peek();
        if (!isOperand(top)) {
          System.out.println("Error: operator with no operands");
          return;
        }
        stack.pop();
        if (stack.empty() || !isOperand(stack.peek())) {
          System.out.println("Error: operator with no operands");
          return;
        }
        stack.pop();
        stack.push('e');
      } else {
        if (!isOperand(symbol)) {
          System.out.println("Error: invalid symbol");
          return;
        }
        stack.push('o');
      }
      index++;
    }
    if (!stack.empty()) {
      System.out.println("Error: missing ')'");
    } else {
      System.out.println("Parsing successful");
    }
  }

}
