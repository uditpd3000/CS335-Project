public class OuterClass {
  private int x = 10;

  OuterClass(){
    x += 100;
  }

  public class InnerClass {
    public void printX() {
      // System.out.println("The value of x is " + x);
      // OuterClass xxxxxx = new OuterClass();
     
      boolean c,a=true,b=false;
      int d=5,e,f,ff;

      // a=true;
      
      // b=1;jo
      // c = a || b;
      // d = e;
      // f=e;
      // if(f==e){
      //   f=e;
      //   e=3;
      //   if(e==3){
      //     ff=2;
          
      //   }
      //   else if(e+ff==4){
      //       d=10;
      //     }
      // }
      f=2;
      for(d=5;d<10;d++,e=1){
        f=10;
        ff=10;
        while(ff<=8){
          ff=9/f;

        }
      }
      
    }
  }
}