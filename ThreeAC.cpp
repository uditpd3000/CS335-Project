#include <bits/stdc++.h>

using namespace std;
// extern ofstream fout;

class Instruction{
    public:

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

            string s="";

            if(result!="") s = result + " := ";

            if(op!="") {
                if(arg2!="") return ( s + arg1 + " " + op + " " + arg2);
                else return (s + arg1 + op);
            }
            else{
                return s + arg1;
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

        string print(){
            if(arg2=="") return (arg1 + " " + to_string(index));
            else return (arg1 + " " +arg2);
        }

};

class ConditionalJump: public Instruction{
    public:
        string arg1="if";
        string arg2;
        string arg3="goto";
        string arg4="";
        int index;

        string print(){
            if(arg4=="") return (arg1 + " " + arg2 + " " + arg3 + " " +to_string(index));
            else return (arg1 + " " + arg2 + " " + arg3 + " " +arg4);
        }

};

class Block: public Instruction{
    public:

    vector<Instruction*> codes;

    string print(){
        string s = result + ":\n";
        for(auto x : codes){
            s += "\t" + x->print() + "\n";
        }
        return s;
    }
};

class BeginEnd: public Instruction{
    public:
        string arg1;
        string arg2;
    string print(){
        return arg1+" "+arg2;
    }
};


class IR{
    public:

        vector<Instruction*> quadruple;
        map<string,Block*> blocks;

        int local_var_count=0;
        int local_label_count=0;


        string getVar(int index){
            return quadruple[index]->result;
        }

        string getLocalVar(){
            return "t"+to_string(local_var_count++);
        }
        string getLocalLabel(){
            return "L"+to_string(local_label_count++);
        }
        string nextLabel(){
            return "L"+to_string(local_label_count+2);
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
        int makeBlock(int index, string name=""){
            Block* myInstruction = new Block();

            if(name=="") myInstruction->result = getLocalLabel();
            else myInstruction->result=name;

            for(int i=index;i<quadruple.size();i++){
                myInstruction->codes.push_back(quadruple[i]);
            }

            quadruple.erase(quadruple.begin()+index,quadruple.begin()+quadruple.size());

            blocks.insert({myInstruction->result,myInstruction});

            UnconditionalJump* myInstruction2 = new UnconditionalJump();
            myInstruction2->arg2=myInstruction->result;
            myInstruction2->result=myInstruction->result;
            quadruple.push_back(myInstruction2);

            return quadruple.size()-1;
        }

        int insertAss(string myArg1, string myArg2, string op,string res=""){
            return insert(create(myArg1,myArg2,op,res));
        }

        // unconditional jump
        int insertJump(string myArg2){
            UnconditionalJump* myInstruction = new UnconditionalJump();

            myInstruction->arg2=myArg2;

            quadruple.push_back(myInstruction);
            return quadruple.size()-1;
        }

        // after if label
        void insertNextJump(string arg, string jumphere){

            Block*  myCondition = blocks[arg];

            UnconditionalJump* myInstruction2 = new UnconditionalJump();
            myInstruction2->arg2=jumphere;

            Instruction* myCondition2 = myInstruction2;
            myCondition->codes.push_back(myCondition2);

        }

        // if statement
        int insertIf(int index ,string arg1,string arg2, string arg3){
            // indexx in vector- arg2

            ConditionalJump* myInstruction = new ConditionalJump();

            myInstruction->arg2= arg1; // if a>b

            string next = nextLabel();
            // myInstruction->arg4= nextLabel(); // goto x
            if(arg3!="")myInstruction->arg4=arg3;
            else myInstruction->arg4= next;

            // next instructions inside - "goto x"
            insertNextJump(arg2,myInstruction->arg4); // after working with if-statement jump
            if(arg3!="") insertNextJump(arg3,myInstruction->arg4); // after working with else-statement jump

            quadruple.insert(quadruple.begin()+index+1,myInstruction);

            arg3 = makeBlock(index+1);

            makeBlock(0);
            quadruple.pop_back();

            return 0;
        }



        void print(){
            for(int i=0;i<quadruple.size();i++){
                // cout<<i<<": ";
                cout<<quadruple[i]->print();
                cout<<endl;
            }
            for(auto x : blocks){
                cout<<x.second->print();
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