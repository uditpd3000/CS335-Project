
public class Main {

    int notfinal;
    final static int finalvar[]={1,2,3};
    static int stVar = 1;
    static int staticFunc(){
        return 0;
    }
    public int nonstatic(){
        return 1;
    }
    public static int sum(int start, int end) {
        stVar = 10;

        // finalvar[1]= 10;
        // int z = nonstatic();
        return start + end + stVar;
    }

    public static void main(String[] args) {
        int result = sum(5, 10);
        System.out.println(result);
    }
}