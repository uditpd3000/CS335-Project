// Test Case 7 :: Method call from another class.

class TestValues  
{  
      
    int MAX(int a,int b)  
    {  
        int maxValue=a;  
  
        if(a>b){
            maxValue=a; 
        }
        else{
            maxValue=b;
        }
        return maxValue;//This method will return the max value present in the array.  
    }  
  
    int MIN(int a,int b)  
    {  
        int minValue=a;  
  
        if(a>b){
            minValue=b; 
        }
        else{
            minValue=a;
        } 
        return minValue;  
    }  
}  
  
public class DifferenceArry  
{  
    public static void main(String[] args)  
    {  
        int n;  
  
        System.out.println("Enter the array elements:" );  
  
        int a=5,b=9;   
  
        TestValues obj=new TestValues();  
        System.out.println(obj.MAX(a,b));  
        System.out.println(obj.MIN(a,b));  
        int diff=obj.MAX(a,b)-obj.MIN(a,b);  
        System.out.println(diff );     
    }  
} 