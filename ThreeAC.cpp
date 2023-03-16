#include <bits/stdc++.h>

using namespace std;
// extern ofstream fout;

class Instruction{
    public:

        string result="";

        virtual string print(){
            return "";
        }
};

class Assignment: public Instruction{
    public:
        string arg1;
        string arg2="";
        string op="";

        string print(){
            if(op!="") {
                if(arg2!="") return (arg1 + " " + op + " " + arg2);
                else return (arg1 + op);
            }
            else{
                return arg1;
            }
        }
};

class UnconditionalJump: public Instruction{
    public:
        string arg1="goto";
        int index;

        string result = "";

        string print(){
            return (arg1 + " " + to_string(index));
        }

};

class ConditionalJump: public Instruction{
    public:
        string arg1="if";
        string arg2;
        string arg3="goto";
        int index;

        string result = "";

        string print(){
            return (arg1 + " " + arg2 + " " + arg3 + " " +to_string(index));
        }

};

class IR{

    vector<Instruction*> quadruple;

    int local_reg_count=0;

    public:

        string getVar(int index){
            return quadruple[index]->result;
        }

        string getLocalVar(){
            return "t"+to_string(local_reg_count++);
        }

        int insert(Instruction* myInstruction){
            quadruple.push_back(myInstruction);
            return quadruple.size()-1;
        }

        //assignment
        int insert(string arg1, string res=""){
            Assignment* myInstruction = new Assignment();

            myInstruction->arg1=arg1;

            if(res=="") myInstruction->result=getLocalVar();
            else myInstruction->result=res;

            quadruple.push_back(myInstruction);
            return quadruple.size()-1;
        }

        //  normal instruction
        Instruction* create(string myArg1, string myArg2, string op,string res=""){
            Assignment* myInstruction = new Assignment();

            // if(myArg1[0]>='0' && myArg1[0]<='9') myArg1 = getVar(stoi(myArg1));
            // if(myArg2[0]>='0' && myArg2[0]<='9') myArg2 = getVar(stoi(myArg2));

            myInstruction->arg1=myArg1;
            myInstruction->arg2=myArg2;
            myInstruction->op=op;

            if(res=="") myInstruction->result=getLocalVar();
            else myInstruction->result=res;

            return myInstruction;
        }

        // unconditional jump
        int insertJump(int myArg2){
            UnconditionalJump* myInstruction = new UnconditionalJump();

            myInstruction->index=myArg2;

            quadruple.push_back(myInstruction);
            return quadruple.size()-1;
        }

        // conditional jump
        int insertIf(Instruction* myArg1, int myArg2){
            ConditionalJump* myInstruction = new ConditionalJump();

            myInstruction->arg2= myArg1->print();
            myInstruction->index=myArg2;

            quadruple.push_back(myInstruction);

            return quadruple.size()-1;
        }

        // while loop
        int insertWhile(int index){
            // i = index of conditional expression
            ConditionalJump* myInstruction = new ConditionalJump();

            myInstruction->arg2= quadruple[index]->print();
            myInstruction->index=quadruple.size()+1;

            Instruction*  myCondition = myInstruction;

            quadruple[index] = myCondition;

            return insertJump(index);
        }

        // for loopp
        int insertFor(int index1, Instruction* myArg1, Instruction* myArg2){
            int index2 = insert(myArg2);

            return insertIf(myArg1,index1+1);
        }

        void print(){
            for(int i=0;i<quadruple.size();i++){
                cout<<i<<": ";
                if(quadruple[i]->result!="") cout<<quadruple[i]->result<<" := ";
                cout<<quadruple[i]->print();
                cout<<endl;
            }
        }
};

// int main(){

//     IR* mycode = new IR();
//     int i1= mycode->insert(mycode->create("a","b",">"));
//     int i2 = mycode->insert(mycode->create("a","b","+"));
//     mycode->insert(mycode->create(mycode->getVar(i2),"b","+","a"));

//     // int i3 = mycode->insertIf(i1,i2);
//     mycode->insertWhile(i1);
//     int i3 = mycode->insert(mycode->create("e","f","+"));
//     // mycode->insert(i1);

//     // for(i=0;i<10;i++)
//     int i4= mycode->insert("0","i");
//     mycode->insert(mycode->create("g","h","+"));
//     mycode->insertFor(i4,mycode->create("i","10","<"),mycode->create("i","1","+","i"));

//     mycode->print();

//     return 0;
// }