class Testarray1{  
    public static void main(String args[]){  
    int arr[]={33,3,4,5};  
    //printing array using for-each loop
    for(int i:arr)  
    System.out.println(i);  
    }}
    public class TypeCheck1 {
        public int a;
        float b;
    
        public TypeCheck1(int a1, int b1) {
            this.a = a1;
            this.b = b1;
        }
    
        public int getA() {
            return this.a;
        }
    
        public float getB() {
            return this.b;
        }
    
        public void setA(int a1) {
            this.a = a1;
        }
    
        public void setB(float b1) {
            this.b = b1;
            return;
        }
    
        public static void main(String[] args) {
            TypeCheck1 obj = new TypeCheck1(1, 2);
    
            // Same names
            int a = obj.a;
            float b = obj.b;
            
            // Different names
            int c = obj.a;
            float d = obj.b;
    
            System.out.println("a: " );
        }
}