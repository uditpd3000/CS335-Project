class first
  {
    public int tui;
      public int Count(int a, int b, int c)
      {
          int i = a, cnt = 0;
          while(i < b){
              i = i + 1;
              cnt = cnt + 1;
          }
          return cnt*c;
      }
      first(int zz){
        this.tui = zz;
      }

      public void sum(){
        int i=0;
        while(i<10){
          continue;
          i=1;
        }
        return ;
      }

      public void Main()
      {
          int i = 9,j=10,k=11;
          // int sid[] = {4, 7, 8, 10};
          // int xxx = 2+3;
          int res = Count( i, j,k);
          first.sum();
          // int res = Count(i, j, k);

          // print(res);
          // print("\n");
      }
  }
