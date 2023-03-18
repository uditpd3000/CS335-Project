#include <bits/stdc++.h>

using namespace std;
// extern ofstream fout;

class Instruction{
    public:

        bool isLabel=false;
        string label="";


        string result="";

        virtual string print(){
            return "";
        }

        virtual void setIndex(int i){
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

        void setIndex(int i){
        }
};

class UnconditionalJump: public Instruction{
    public:
        string arg1="goto";
        string arg2="";
        int index;

        string result = "";

        string print(){
            if(arg2=="") return (arg1 + " " + to_string(index));
            else return (arg1 + " " +arg2);
        }

        void setIndex(int i){
            index=i;
        }

};

class ConditionalJump: public Instruction{
    public:
        string arg1="if";
        string arg2;
        string arg3="goto";
        string arg4="";
        int index;

        string result = "";

        string print(){
            if(arg4=="") return (arg1 + " " + arg2 + " " + arg3 + " " +to_string(index));
            else return (arg1 + " " + arg2 + " " + arg3 + " " +arg4);
        }

        void setIndex(int i){
            index=i;
        }

};

class Block: public Instruction{
    public:
    string label;

    vector<Instruction*> codes;

    string print(){
        string s = label + ":\n";
        for(auto x : codes){
            if (x->result!="") s += "\t" + x->result + " := " +  x->print() + "\n";
            else s += x->print() + "\n";
        }
        return s;
    }
};



class IR{
    public:

        vector<Instruction*> quadruple;
        vector<Block*> blocks;

        int local_reg_count=0;
        int local_label_count=0;


        string getVar(int index){
            return quadruple[index]->result;
        }

        string getLocalVar(){
            return "t"+to_string(local_reg_count++);
        }
        string getLocalLabel(){
            return "L"+to_string(local_label_count++);
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

        // block
        string makeBlock(int start, int end){
            Block* myInstruction = new Block();
            myInstruction->label = getLocalLabel();
            
            for(int i=start;i<end;i++){
                myInstruction->codes.push_back(quadruple[i]);
            }

            quadruple.erase(quadruple.begin()+start,quadruple.begin()+end);

            blocks.push_back(myInstruction);

            return myInstruction->label;
        }
        string makeBlock(int index){
            Block* myInstruction = new Block();
            myInstruction->label = getLocalLabel();

            myInstruction->codes.push_back(quadruple[index]);

            quadruple.erase(quadruple.begin()+index,quadruple.begin()+index+1);

            blocks.push_back(myInstruction);

            return myInstruction->label;

        }

        int insertAss(string myArg1, string myArg2, string op,string res=""){
            return insert(create(myArg1,myArg2,op,res));
        }

        // unconditional jump
        int insertJump(int myArg2){
            UnconditionalJump* myInstruction = new UnconditionalJump();

            myInstruction->index=myArg2;

            quadruple.push_back(myInstruction);
            return quadruple.size()-1;
        }

        // else statements
        int insertElse(int index, int arg1){
            UnconditionalJump* myInstruction = new UnconditionalJump();
            myInstruction->arg2 = makeBlock(arg1);

            Instruction*  myCondition = myInstruction;
            quadruple.insert(quadruple.begin()+index,myCondition);

            return quadruple.size()-1;
        }
        int insertElse(int index, string arg1){
            UnconditionalJump* myInstruction = new UnconditionalJump();
            myInstruction->arg2 = arg1;

            Instruction*  myCondition = myInstruction;
            quadruple.insert(quadruple.begin()+index,myCondition);

            return quadruple.size()-1;
        }

        // conditional jump
        int insertIf(int index ,string arg2){
            ConditionalJump* myInstruction = new ConditionalJump();

            myInstruction->arg2= quadruple[index]->print(); // if a>b
            myInstruction->arg4=arg2;

            Instruction*  myCondition = myInstruction;

            // cout << myCondition->print();

            quadruple[index] = myCondition;

            return index;
        }
        int insertIf(int index ,int arg2){
            ConditionalJump* myInstruction = new ConditionalJump();

            myInstruction->arg2= quadruple[index]->print(); // if a>b
            myInstruction->arg4=makeBlock(arg2);

            Instruction*  myCondition = myInstruction;

            // cout << myCondition->print();

            quadruple[index] = myCondition;

            return index;
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
        // int insertFor(int index1, int myArg1, Instruction* myArg2){
        //     int index2 = insert(myArg2);

        //     return insertIf(myArg1,index1+1);
        // }

        void print(){
            for(int i=0;i<quadruple.size();i++){
                // cout<<i<<": ";
                if(quadruple[i]->result!="") cout<<quadruple[i]->result<<" := ";
                cout<<quadruple[i]->print();
                cout<<endl;
            }
            for(int i=0;i<blocks.size();i++){
                // cout<<i<<": ";
                cout<<blocks[i]->print();
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