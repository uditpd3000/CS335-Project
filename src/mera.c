#include<stdio.h>

int main(){
    int count = 0, num = 0003452;

    while (num != 0) {
      // num = num/10
      num /= 10;
      ++count;
    }
    printf("%d\n",count);
}