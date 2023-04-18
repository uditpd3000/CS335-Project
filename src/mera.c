#include<stdio.h>


int fact(int n){
    if(n==1) return 1;
    else return(fact(n-1)+1);
}
int main(){
    int n=5;
    int res=fact(5);

    printf("%d \n",res);
    return 0;
}