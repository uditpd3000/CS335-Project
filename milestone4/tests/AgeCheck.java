public class AgeCheck {

    private int age;

    public AgeCheck(int age) {
        this.age = age;
    }

    public void sayAge() {
        System.out.println(this.age);
    }

    public int isAdult() {
        if (this.age >= 18)
            return 1;
        else
            return 0;
    }

    public static void main(String[] args) {
        int ages[] = { 10, 17, 22, 35, 12 };

        for (int i = 0; i < 5; i++) {
            AgeCheck myObject = new AgeCheck(ages[i]);
            myObject.sayAge();
            int ins;
            ins = myObject.isAdult();
            if (ins == 1) {
                System.out.println(ages[i]);
            }
        }
    }
}
