#include <bits/stdc++.h>

using namespace std;
// extern ofstream fout;

class Instruction{
    public:

        string result="";
        bool isBlock=false;
        bool incomplete = false;

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

            string s="\t";

            if(result!="") s += result + " := ";

            if(op!="") {
                if(arg2!="") return ( s + arg1 + " " + op + " " + arg2);
                else return (s + arg1 + op);
            }
            else{
                return s + arg1;
            }
        }
};

class UnconditionalJump: public Instruction{
    public:
        string arg1="goto";
        string arg2="";
        int index;

        string print(){
            if(arg2=="") return ("\t"+ arg1 + " " + to_string(index));
            else return ("\t"+ arg1 + " " +arg2);
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
            if(arg4=="") return ("\t"+ arg1 + " " + arg2 + " " + arg3 + " " +to_string(index));
            else return ("\t"+ arg1 + " " + arg2 + " " + arg3 + " " +arg4);
        }

};

class Block: public Instruction{
    public:

    vector<Instruction*> codes;

    string print(){
        string s =result + ":";
        for(auto x : codes){
            s +="\n"+ x->print();
        }
        return s;
    }
};

class TwoWordInstr: public Instruction{
    public:
        string arg1;
        string arg2;
    string print(){
        return arg1+" "+arg2;
    }
};

class FunctnCall: public Instruction{
    public:
        string name;
        vector<string> params;
        bool isCall=false;
        bool isConstr = false;
        string constrName = "";

        string print(){

            string s="";

            if(!isCall) return s;

            for(auto x:params){
                s+= "\tparam "+x + "\n";
            }
            s=s.substr(0,s.length()-1);

            return s;
        }
};

class ConstrCall: public Instruction{
    public:
        string name;
        vector<string> params;
        bool isCall=false;

        string print(){

            string s="";

            if(!isCall) return s;

            for(auto x:params){
                s+= "\tparam "+x + "\n";
            }
            s=s.substr(0,s.length()-1);

            return s;
        }
};

class SymbolTableOffset: public Instruction{
    public:
        string classname;
        string offset;

        string print(){
            string s="\t"+result+" := SymTable( "+classname+" , "+offset+")";
            return s;
        }
};

class PointerAssignment: public Instruction{
    public:
        string start;
        string offset;

        string print(){
            string s="\t"+result+" :=  *("+start+" + "+offset+")";
            return s;
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
            return "L"+to_string(local_label_count+1);
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
        int makeBlock(int index, string name="", int endindex=-1){
            if(endindex==-1)endindex=quadruple.size();

            Block* myInstruction = new Block();

            if(name=="") myInstruction->result = getLocalLabel();
            else myInstruction->result=name;

            for(int i=index;i<endindex;i++){
                myInstruction->codes.push_back(quadruple[i]);
            }

            quadruple.erase(quadruple.begin()+index,quadruple.begin()+endindex);

            blocks.insert({myInstruction->result,myInstruction});

            Instruction* myInstruction2 = myInstruction;
            myInstruction2->isBlock=true;
            quadruple.push_back(myInstruction2);

            return quadruple.size()-1;
        }

        int insertAss(string myArg1, string myArg2, string op,string res=""){
            return insert(create(myArg1,myArg2,op,res));
        }

        // unconditional jump
        int insertJump(string myArg2, int index=-1){
            UnconditionalJump* myInstruction = new UnconditionalJump();

            myInstruction->arg2=myArg2;

            if(index==-1) quadruple.push_back(myInstruction);
            else{
                quadruple.insert(quadruple.begin()+index+1,myInstruction);
            }

            if(blocks.find(myArg2)==blocks.end()){
                Block* myBlock = new Block();
                myBlock->result = myArg2;
                myBlock->isBlock=true;
                blocks.insert({myArg2,myBlock});

                Instruction* justLabel = myBlock;
                quadruple.push_back(justLabel);
            }

            return quadruple.size()-1;
        }
        void insertNextJump(string arg1, string jumphere){
            UnconditionalJump* myInstruction = new UnconditionalJump();
            myInstruction->arg2=jumphere;

            Instruction* myJump= myInstruction;

            // cout<<arg1<<"uuuuuuuuuuuuu"<<blocks[arg1]->codes.size()<<endl;
            blocks[arg1]->codes.push_back(myJump);
            // cout<<arg1<<"uuuuuuuuuuuuu"<<blocks[arg1]->codes.size()<<endl;

            if(blocks.find(jumphere)==blocks.end()){
                Block* myBlock = new Block();
                myBlock->result = jumphere;
                myBlock->isBlock=true;
                blocks.insert({jumphere,myBlock});

                Instruction* justLabel = myBlock;
                quadruple.push_back(justLabel);
            }
        }

        // if statement
        int insertIf(int index ,string arg1,string arg2, string arg3){

            ConditionalJump* myInstruction = new ConditionalJump();

            string next = getLocalLabel();

            myInstruction->arg2= arg1; // if a>b
            myInstruction->arg4= arg2; // goto x


            quadruple.insert(quadruple.begin()+index+1,myInstruction);

            insertNextJump(arg2, next);

            if(arg3!=""){
                insertJump(arg3,index+1);
                insertNextJump(arg3, next);
            }
            else insertJump(next, index+1);

            return index;
        }

        int insertWhile(int startindex, int endindex, string condition, string arg2){

            ConditionalJump* myInstruction = new ConditionalJump();

            string next = getLocalLabel();

            myInstruction->arg2= condition; // if a>b
            myInstruction->arg4= arg2; // goto x
            
            quadruple.insert(quadruple.begin()+endindex+1,myInstruction);
            insertJump(next, endindex+1);
           

            int x = makeBlock(startindex);

            insertNextJump(arg2,quadruple[x]->result);

            updateIncompleteJump(quadruple[x]->result,quadruple[x]->result,next);

            return endindex;
        }

        int insertFor(int startindex, int endindex, string changeExp, string arg2 ){
            //  for (i=0;i<10;i++)
            // i=0;
            // L1:
            // if i<10 goto arg2
            // goto next
            // arg2: 
            // goto chageexp
            // changeexp:
            // goto L1


            ConditionalJump* myInstruction = new ConditionalJump();

            string next = getLocalLabel();

            if(startindex>=0) myInstruction->arg2= quadruple[endindex]->result; // if a>b
            else myInstruction->arg2 = "true";

            myInstruction->arg4= arg2; // goto x

            quadruple.insert(quadruple.begin()+endindex+1,myInstruction); // if-inserted
            insertJump(next, endindex+1); // goto next

            int x;
            if(startindex>=0) x = makeBlock(startindex); // l1:
            else x = makeBlock(endindex+1);

            if(changeExp!=""){
                insertNextJump(arg2,changeExp); // in arg2: goto changeexp
                insertNextJump(changeExp,quadruple[x]->result); // in changeexp: goto L1
            }
            else {
                insertNextJump(arg2,quadruple[x]->result);
            }

            // updateIncompleteJump(quadruple[x]->result,quadruple[x]->result,next);
    
            return quadruple.size()-1;
        }

        int InsertTwoWordInstr(string instr, string arg2){

            TwoWordInstr* print = new TwoWordInstr();
            print->arg1 = instr;
            print->arg2 = arg2;
            cout<<instr<<";;;\n";
            return insert(print);
        }


        int insertFunctnCall(string funcName, vector<string> argList, int isdec=0, bool isConstr=false){
            FunctnCall* myCall = new FunctnCall();
            myCall->name = funcName;
            for(auto x: argList){
                myCall->params.push_back(x);
            }
            if(!isdec) myCall->isCall=true;

            

            Instruction* myInstruction = myCall;

            quadruple.push_back(myInstruction);

            if(!isdec){
                if(argList.size()) insertAss("call "+funcName + " " + to_string(argList.size()),"","");
                else insertAss("call "+funcName,"","");
            }
            else {
                for(auto x : argList){
                    insertAss("popparam","","",x);
                }
            }

            return quadruple.size()-1;
        }

        int insertGetFromSymTable(string classs, string offset, string res){
            SymbolTableOffset* instr = new SymbolTableOffset();
            if(res=="")instr->result=getLocalVar();
            else instr->result = res;
            instr->classname = classs;
            instr->offset = offset;
            
            return insert(instr);
        }

        int insertPointerAssignment(string start, string offset, string res){
            PointerAssignment* instr = new PointerAssignment();
            if(res=="")instr->result=getLocalVar();
            else instr->result = res;
            instr->start = start;
            instr->offset = offset;
            return insert(instr);
        }

        int insertIncompleteJump(string arg1){
            UnconditionalJump* myJump = new UnconditionalJump();
            myJump->result=arg1;
            myJump->incomplete=true;

            quadruple.push_back(myJump);
            return quadruple.size()-1;
        }
        void updateIncompleteJump(string currBlock,string beforeBlock,string afterBlock){
            int i=0;
            for(auto x : blocks[currBlock]->codes){
                if(x->isBlock){
                    updateIncompleteJump(x->result,beforeBlock,afterBlock);
                }
                else if(x->incomplete){
                    UnconditionalJump* myJump = new UnconditionalJump();
                    string arg2;

                    if(x->result=="continue") arg2=beforeBlock;
                    else arg2=afterBlock;

                    myJump->arg2=arg2;

                    blocks[currBlock]->codes[i]=myJump;
                    // cout<<x->print()<<"\nmyjump\n"<<myJump->print();
                }
                i++;
            }
        }

        string insertTernary(int index, string cond,string first, string sec){
            string res1,res2,res=getLocalVar();
            res1=blocks[first]->codes[blocks[first]->codes.size()-1]->result;
            res2=blocks[sec]->codes[blocks[sec]->codes.size()-1]->result;

            blocks[first]->codes.push_back(create(res1,"","",res));
            blocks[sec]->codes.push_back(create(res2,"","",res));

            insertIf(index,cond,first,sec);

            return res;
        }

        void print(){
            for(int i=0;i<quadruple.size();i++){
                // cout<<i<<": ";
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