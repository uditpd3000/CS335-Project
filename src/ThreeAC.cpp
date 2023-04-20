#include <bits/stdc++.h>
#include "registers.cpp"

using namespace std;
extern GlobalSymbolTable *global_sym_table;

extern ofstream tacout;
extern ofstream sout;
extern X86* target;

extern int getTemporarySize(string name);

class Instruction
{
public:
    string result = "";
    int resSize = 0;
    bool isBlock = false;
    bool incomplete = false;
    bool fieldDec = false;
    string scope;

    vector<string> x86code;

    virtual string print()
    {
        return "";
    }

    virtual string codegen(){
        return "";
    }

};

class Assignment : public Instruction
{
public:
    Assignment(){
        scope = global_sym_table->current_scope;
    }
    string arg1;
    string arg2 = "";
    string op = "";

    string print()
    {
        if(arg1 == "popparam")resSize = 8;
        resSize = 4;
        string s = "\t";

        if (result != "")
            s += result + " := ";

        if (op != "")
            // scope
            {
                if (arg2 != "")
                    return (s + arg1 + " " + op + " " + arg2);
                else
                    return (s + arg1 + op);
            }
        else
        {
            return s + arg1;
        }
    }

    string codegen()
    {   
        string loc ="";

        if(fieldDec==true){
            int off = target->getOffset(result,scope,4,true);
            loc = to_string(off)+"(%rdi)";
        }
        if(result[0]=='*'){
            string a1 = "";
            string a2 = "";
            int ind = 2;
            while(result[ind]!='+')a1+=result[ind++]; // start offset
            ind++;
            while (result[ind] != ')')a2+=result[ind++]; // end part

            int off1 = target->getOffset(a1,scope);
            int off2 = target->getOffset(a2,scope);

            string reg11 = target->getReg();
            string reg12 = target->getReg();
            // x86code.push_back("====");
            
            x86code.push_back("movq\t-"+to_string(off1)+"(%rbp), %"+reg11);
            if(target->offsetToSize[off2]==4){
                x86code.push_back("movslq\t-" + to_string(off2) + "(%rbp), %" + reg12);
            }
            else {
                x86code.push_back("movq\t-" + to_string(off2) + "(%rbp), %" + reg12);
            }
            x86code.push_back("addq\t%" + reg11 + ", %" + reg12);
            loc = "(%"+reg12+")";
        }
        else if(target->tVarsToGlobals.find(result)!=target->tVarsToGlobals.end()){
            loc = target->tVarsToGlobals[result]+"(%rip)";
        }

        if(result=="stackPointer" && op=="+int"){
            x86code.push_back("addq\t$"+arg2+", %rsp");
        }
        else if (arg2 != "")
        {

            string instr = "";
            string reg1,reg2,reg3;
            vector<string> code;

            if (op[0] == '+')
            {
                instr = "addl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg2 + ", %" + reg3;
                x86code.push_back(reg1);
                
                // move to destination(result)  
                if(loc==""){
                    int x = target->getOffset(result,scope);
                    if(x <0)
                    {
                        x *= -1;
                        reg1 = "movl\t%" + reg3 + ", " + to_string(x) + "(%rdi)";
                    }
                    else reg1 = "movl\t%"+reg3+", -" + to_string(x) + "(%rbp)";
                }
                else reg1 = "movl\t%"+reg3+", " + loc;
                x86code.push_back(reg1);

            }
            else if (op[0] == '-')
            {
                instr = "subl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg3 + ", %" + reg2;
                x86code.push_back(reg1);
                
                // move to destination(result)
                if(loc==""){
                    int x = target->getOffset(result,scope);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movl\t%" + reg2 + ", " + to_string(x) + "(%rdi)";
                    }
                    else reg1 = "movl\t%"+reg2+", -" + to_string(x) + "(%rbp)";
                }
                else reg1 = "movl\t%"+reg2+", " + loc;
                x86code.push_back(reg1);
            }
            else if (op[0] == '*')
            {
                instr = "imull";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg3 + ", %" + reg2;
                x86code.push_back(reg1);
                
                // move to destination(result)
                if (loc == "")
                {
                    int x = target->getOffset(result, scope);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movl\t%" + reg2 + ", " + to_string(x) + "(%rdi)";
                    }
                    else reg1 = "movl\t%" + reg2 + ", -" + to_string(x) + "(%rbp)";
                }
                else
                    reg1 = "movl\t%" + reg2 + ", " + loc;
                // int x = target->getOffset(result,scope);
                // reg1 = "movl\t%"+reg2+", -" + to_string(x) + "(%rbp)";
                x86code.push_back(reg1);
            }
            else if (op[0] == '/')
            {
                instr = "idivl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];
                x86code.push_back("movl\t%"+reg2+", %eax");

                int off = target->getOffset(arg2, scope);
                x86code.push_back("cltd");
                x86code.push_back(instr+"\t-"+to_string(off)+"(%rbp)");
                
                // move to destination(result)
                reg1 = "movl\t%eax, ";

                if(loc=="") {
                        int x = target->getOffset(result, scope);
                        if (x < 0)
                        {
                        x *= -1;
                        loc = to_string(x) + "(%rdi)";
                        }
                        else loc +="-"+ to_string(x) + "(%rbp)";
                }
                reg1 +=loc;
                x86code.push_back(reg1);
            }
            else if (op[0] == '%')
            {
                instr = "idivl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];
                x86code.push_back("movl\t%"+reg2+", %eax");

                int off = target->getOffset(arg2, scope);
                x86code.push_back("cltd");
                x86code.push_back(instr+"\t-"+to_string(off)+"(%rbp)");
                
                // move to destination(result)
                reg1 = "movl\t%edx, ";

                if(loc=="") {
                        int x = target->getOffset(result, scope);
                        if (x < 0)
                        {
                        x *= -1;
                        loc = to_string(x) + "(%rdi)";
                        }
                        else loc += "-"+to_string(x) + "(%rbp)";
                }
                reg1 +=loc;

                x86code.push_back(reg1);
            }
            else if (op == "|")
            {
                instr = "orl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg3 + ", %" + reg2;
                x86code.push_back(reg1);
                
                // move to destination(result)
                if (loc == "")
                {
                    int x = target->getOffset(result, scope);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movl\t%" + reg2 + ", " + to_string(x) + "(%rdi)";
                    }
                    else reg1 = "movl\t%" + reg2 + ", -" + to_string(x) + "(%rbp)";
                }
                else
                    reg1 = "movl\t%" + reg2 + ", " + loc;
                x86code.push_back(reg1);
            }
            else if (op == "^")
            {
                instr = "xorl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg3 + ", %" + reg2;
                x86code.push_back(reg1);
                
                // move to destination(result)
                if (loc == "")
                {
                    int x = target->getOffset(result, scope);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movl\t%" + reg2 + ", " + to_string(x) + "(%rdi)";
                    }
                    else reg1 = "movl\t%" + reg2 + ", -" + to_string(x) + "(%rbp)";
                }
                else
                    reg1 = "movl\t%" + reg2 + ", " + loc;
                x86code.push_back(reg1);
            }
            else if (op == "&")
            {
                instr = "andl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg3 + ", %" + reg2;
                x86code.push_back(reg1);
                
                // move to destination(result)
                if (loc == "")
                {
                    int x = target->getOffset(result, scope);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movl\t%" + reg2 + ", " + to_string(x) + "(%rdi)";
                    }
                    else reg1 = "movl\t%" + reg2 + ", -" + to_string(x) + "(%rbp)";
                }
                else
                    reg1 = "movl\t%" + reg2 + ", " + loc;
                x86code.push_back(reg1);
            }
            else if (op == ">="){
                instr = "cmpl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg3 + ", %" + reg2;
                x86code.push_back(reg1);

                reg1 = "setge\t%al";
                x86code.push_back(reg1);

                // move to destination(result)
                if(loc==""){
                    int x = target->getOffset(result,scope,1);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movb\t%al, "  + to_string(x) + "(%rdi)";
                    }
                    else reg1 = "movb\t%al, -" + to_string(x) + "(%rbp)";
                }
                else reg1 = "movb\t%al, " + loc;
                x86code.push_back(reg1);
            }
            else if (op == "<="){
                instr = "cmpl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg3 + ", %" + reg2;
                x86code.push_back(reg1);

                reg1 = "setle\t%al";
                x86code.push_back(reg1);

                // move to destination(result)
                if(loc==""){
                    int x = target->getOffset(result,scope,1);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movb\t%al, " + to_string(x) + "(%rdi)";
                    }
                    else reg1 = "movb\t%al, -" + to_string(x) + "(%rbp)";
                }
                else reg1 = "movb\t%al, " + loc;
                x86code.push_back(reg1);
            }
            else if(op=="=="){
                instr = "cmpl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg2 + ", %" + reg3;
                x86code.push_back(reg1);

                reg1 = "sete\t%al";
                x86code.push_back(reg1);

                // move to destination(result)
                if(loc==""){
                    int x = target->getOffset(result, scope, 1);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movb\t%al, " + to_string(x) + "(%rdi)";
                    }
                    else reg1 = "movb\t%al, -" + to_string(x) + "(%rbp)";
                }
                else reg1 = "movb\t%al, " + loc;
                x86code.push_back(reg1);
            }
            else if(op=="!="){
                instr = "cmpl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg2 + ", %" + reg3;
                x86code.push_back(reg1);

                reg1 = "setne\t%al";
                x86code.push_back(reg1);

                // move to destination(result)
                if(loc==""){
                    int x = target->getOffset(result,scope,1);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movb\t%al, " + to_string(x) + "(%rdi)";
                    }
                    else
                        reg1 = "movb\t%al, -" + to_string(x) + "(%rbp)";
                }
                else reg1 = "movb\t%al, " + loc;

                x86code.push_back(reg1);
            }
            else if(op=="<"){
                instr = "cmpl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg3 + ", %" + reg2;
                x86code.push_back(reg1);

                reg1 = "setl\t%al";
                x86code.push_back(reg1);

                // move to destination(result)
                if(loc==""){
                    int x = target->getOffset(result,scope,1);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movb\t%al, " + to_string(x) + "(%rdi)";
                    }
                    else
                        reg1 = "movb\t%al, -" + to_string(x) + "(%rbp)";
                }
                else reg1 = "movb\t%al, " + loc;
                x86code.push_back(reg1);
            }
            else if(op==">"){
                instr = "cmpl";

                code =  target->getReg(arg1,scope);
                x86code.push_back(code[0]);
                reg2 = code[1];

                code = target->getReg(arg2, scope);
                x86code.push_back(code[0]);
                reg3 = code[1];

                reg1 = instr + "\t%" +reg3 + ", %" + reg2;
                x86code.push_back(reg1);

                reg1 = "setg\t%al";
                x86code.push_back(reg1);

                // move to destination(result)
                if(loc==""){
                    int x = target->getOffset(result,scope,1);
                    if (x < 0)
                    {
                        x *= -1;
                        reg1 = "movb\t%al, " + to_string(x) + "(%rdi)";
                    }
                    else
                        reg1 = "movb\t%al, -" + to_string(x) + "(%rbp)";
                }
                else reg1 = "movb\t%al, " + loc;
                x86code.push_back(reg1);
            }
            else if(op=="||"){
                string label1,label2,label3;
                label1 = target->localLabel();
                label2 = target->localLabel();
                label3 = target->localLabel();

                code =  target->getReg(arg1,scope,1);
                x86code.push_back(code[0]);
                reg2 = code[1];

                x86code.push_back("cmpb\t$0, %"+ reg2);
                x86code.push_back("jne\t"+label1);

                code = target->getReg(arg2, scope,1);
                x86code.push_back(code[0]);
                reg3 = code[1];

                x86code.push_back("cmpb\t$0, %"+ reg3);
                x86code.push_back("je\t" + label2);

                // getting result
                // move to destination(result)
                int x;
                if(loc==""){
                    x = target->getOffset(result,scope,1);
                    if (x < 0)
                    {
                        x *= -1;
                        loc = to_string(x) + "(%rdi)";
                    }
                    else
                    loc = "-" + to_string(x) + "(%rbp)";
                }
                
                //L2
                x86code.push_back(label1+":");// add L2 label here
                x86code.push_back("movb\t$1, "+loc);
                x86code.push_back("jmp\t" + label3); // l3

                //L3
                x86code.push_back(label2+":");// add L3 label here
                x86code.push_back("movb\t$0, "+loc);

                x86code.push_back(label3+":");// add L2 label here

            }
            else if(op=="&&"){
                string label1,label2;
                label1 = target->localLabel();
                label2 = target->localLabel();

                code =  target->getReg(arg1,scope,1);
                x86code.push_back(code[0]);
                reg2 = code[1];

                x86code.push_back("cmpb\t$0, %"+ reg2);
                x86code.push_back("je\t"+label1);

                code = target->getReg(arg2, scope,1);
                x86code.push_back(code[0]);
                reg3 = code[1];

                x86code.push_back("cmpb\t$0, %"+ reg3);
                x86code.push_back("je\t" + label1);

                // getting result
                // move to destination(result)
                int x;
                if(loc==""){
                    x = target->getOffset(result,scope,1);
                    if (x < 0)
                    {
                    x *= -1;
                    loc = to_string(x) + "(%rdi)";
                    }
                    else
                    loc = "-" + to_string(x) + "(%rbp)";
                }

                x86code.push_back("movb\t$1, "+loc);
                x86code.push_back("jmp\t" + label2); // l3

                // in L2
                x86code.push_back(label1+":");// add L2 label here
                x86code.push_back("movb\t$0, "+loc);
                x86code.push_back(label2+":");// add L3 label here
            }
        }
        else {
            // x=1;
            string reg1,reg2;
            vector<string> code;
            if (arg1 == "popparam") // array ka alag kaam fixme
            {   
                resSize=8;
                x86code.push_back("movq\t%rdi, -8(%rbp)");
                target->mapToMemory(result, 8);
            }
            else if(arg1 == "popObject"){
                resSize = 8;
                int off = target->getOffset(result,scope,8);
                x86code.push_back("movq\t%rdi, -"+ to_string(off)+"(%rbp)");
            }
            else if (arg1 == "popReturnValue"){
                resSize = 4;
                int off = target->getOffset(result,scope,4);
                x86code.push_back("movq\t%rax, -" + to_string(off) + "(%rbp)");
            }
            else if(arg1 == "allocmem"){
                int off = target->getOffset(op,scope);
                x86code.push_back("movslq\t-" + to_string(off) + "(%rbp), %rdi");
                x86code.push_back("call\tmalloc");
                int x  = target->getOffset(result,scope,8);
                x86code.push_back("movq\t%rax, -"+to_string(x)+"(%rbp)");
            }
            else if (arg1 == "getAddress"){
                vector<string>code;
                int x = target->tVarsToValue[op];
                string reg1 = target->getReg();
                x86code.push_back("movq\t-"+to_string(x)+"(%rbp), %"+reg1);
                x = target->getOffset(result,scope,8);
                x86code.push_back("movq\t%"+reg1+", -"+to_string(x)+"(%rbp)");
                // code= target->getReg(op,scope,8);
                // x86code.push_back(code[0]);
                // string reg = code[1];
                // string reg1 = target->getReg();
                // x86code.push_back("movq\t%rbp, %"+reg1);
                // x86code.push_back("subq\t%" + reg + ", %"+reg1);
                // int x = target->getOffset(result, scope, 8);
                // x86code.push_back("movq\t%"+reg1 +", -"+ to_string(x) + "(%rbp)");
            }
            else{
                if(arg1=="true"){
                    resSize=1;
                    code = target->getReg("1", scope,1);
                }
                else if(arg1=="false"){
                    resSize=1;
                    code = target->getReg("0", scope,1);
                }
                else {
                    int c;
                    if((arg1[0]<='9' && arg1[0]>='0') || (arg1[0]=='-')) c=4;
                    else c = target->offsetToSize[target->getOffset(arg1,scope)];
                    // cout<<c<<"---"<<arg1<<endl;
                    // cout<<arg1<<target->getOffset(arg1,scope)<<endl;
                    if(c==1){
                        resSize=1;
                        code = target->getReg(arg1, scope,1);
                    }
                    else if (c== 8)
                    {
                        resSize = 8;
                        code = target->getReg(arg1, scope, 8);
                    }
                    else {
                        resSize=4;
                        code = target->getReg(arg1, scope);
                    }
                }

                x86code.push_back(code[0]);
                reg2 = code[1];
                
                if(loc!="")reg1 = "movl\t%"+reg2+", " + loc;
                else {
                    int x = target->getOffset(result, scope,resSize);
                    // cout<<result<<" "<<x<<"----"<<target->offsetToSize[x]<<endl;
                    string suff =  ", -" + to_string(x) + "(%rbp)";
                    if(x<0){
                        x*=-1;
                        suff = ", " + to_string(x) + "(%rdi)";
                    }
                    if(resSize==1) reg1 = "movb \t%"+reg2+ suff;
                    else if(resSize==4) reg1 = "movl\t%"+reg2 + suff;
                    else reg1 = "movq\t%"+reg2 + suff; 
                }
                x86code.push_back(reg1);
            }

        }

        string s="";
        for (auto x : x86code){
            if(x[0]!='L') s+="\t" + x+"\n";
            else s+= x+"\n";
        }
        return s;
    }
};

class UnconditionalJump : public Instruction
{
public:
    UnconditionalJump()
    {
        scope = global_sym_table->current_scope;
    }
    string arg1 = "goto";
    string arg2 = "";
    int index;

    string print()
    {   
        if (arg2 == "")
            return ("\t" + arg1 + " " + to_string(index));
        else
            return ("\t" + arg1 + " " + arg2);
    }

    string codegen(){
        string s="";
        s="jmp ";
        if (arg2 == "")
            s+= to_string(index);
        else
            s+=arg2;

        x86code.push_back(s);

        s="";
        for (auto x : x86code){
            s+="\t" + x+"\n";
        }

        return s;
    }


};

class ConditionalJump : public Instruction
{
public:
    ConditionalJump()
    {
        scope = global_sym_table->current_scope;
    }
    string arg1 = "if";
    string arg2;
    string arg3 = "goto";
    string arg4 = "";
    int index;

    string print()
    {
        if (arg4 == "")
            return ("\t" + arg1 + " " + arg2 + " " + arg3 + " " + to_string(index));
        else
            return ("\t" + arg1 + " " + arg2 + " " + arg3 + " " + arg4);
    }

    string codegen(){

        string s = "cmpb\t$1, %";

        vector<string> code;
        code = target->getReg(arg2, scope,1);
        x86code.push_back(code[0]);
        s += code[1];
        x86code.push_back(s);

        x86code.push_back("je "+arg4);

        s="";
        for (auto x : x86code){
            s+="\t" + x+"\n";
        }
        return s;
    }
};

class Block : public Instruction
{
public:
    vector<Instruction *> codes;
    Block()
    {
        scope = global_sym_table->current_scope;
    }

    string print()
    {
        string s = result + ":";
        for (auto x : codes)
        {
            s += "\n" + x->print();
        }
        return s;
    }

    string codegen(){
        string s = result + ":\n";
        for (auto x : codes)
        {
            s += x->codegen();
        }
        return s;
    }

};

class TwoWordInstr : public Instruction
{
public:
    TwoWordInstr()
    {
        scope = global_sym_table->current_scope;
    }
    string arg1;
    string arg2;
    string print()
    {   
        return arg1 + " " + arg2;
    }

    string codegen(){
        if (arg1 == "\tBeginFunc"){
            
            // reset locals
            target->initFuncLocal();

            // space for locals
            // cout<<scope<<"---------------------------------";
            string parentName = global_sym_table->linkmap[scope]->parent->scope;
            string methodName = scope.substr(parentName.length() + 1, scope.length() - (parentName.length()));
            int size = target->getTotalSize(scope) + getTemporarySize(methodName);
            int a=16;
            while(a<size) a+=16;
            size=a;
            // x86code.push_back(methodName + ":");
            x86code.push_back("\tpushq\t%rbp");
            x86code.push_back("\tmovq\t%rsp, %rbp");
            x86code.push_back("\tsubq	$" + to_string(size) + ", %rsp");
        }
        if(arg1=="\tEndConstr"){
            x86code.push_back("\tmovq\t-8(%rbp), %rdi");
        }
        if (arg1 == "\tEndFunc" || arg1 == "\tEndConstr")
        {
            x86code.push_back("\tmovq\t%rbp, %rsp");
            x86code.push_back("\tpopq\t%rbp");
            x86code.push_back("\tret");
        }
        if(arg1 == "\tcall"){
            x86code.push_back("\tcall\t" + arg2);

        }
        if(arg1=="\tpush"){
            vector<string> code;
            // cout<<"pushme\n";

            code = target->getReg(arg2, scope);
            x86code.push_back("\t"+code[0]);
            string reg = code[1];

            x86code.push_back("\tmovslq\t%"+reg+", %rax");
        }

        else if(arg1=="\tBeginConstr"){
            // reset locals
            target->initFuncLocal();
            string parentName = global_sym_table->linkmap[scope]->parent->scope;
            int size = target->getTotalSize(scope)+getTemporarySize(parentName);
            int a=16;
            while(a<size) a+=16;
            size=a;
            // cout<<size<<"-----";
            // x86code.push_back(parentName+".Constr" + ":");
            x86code.push_back("\tpushq\t%rbp");
            x86code.push_back("\tmovq\t%rsp, %rbp");
            x86code.push_back("\tsubq	$"+to_string(size)+", %rsp");
        }
        else if (arg1 == "\tsetObjectRef"){
            int off = target->getOffset(arg2,scope,8,false);
            x86code.push_back("\tmovq\t-"+to_string(off)+"(%rbp), %rdi");
        }
        else if(arg1 == "\tprint"){
        x86code.push_back("\tmov\t$printLabel, %rdi");
        int off = target->getOffset(arg2,scope,4);
        string xx = "";
        if(off>0){
            if(target->tVarsToGlobals.find(arg2)!=target->tVarsToGlobals.end()){
                xx = "\tmovslq\t" + target->tVarsToGlobals[arg2] + "(%rip), %rsi";
            }
            else xx= "\tmovslq\t-"+to_string(off)+"(%rbp), %rsi";
        }
        if(off<0){
            off*=-1;
            // to_string(x) + "(%rdi)
                xx = "\tmovslq\t" + to_string(off) + "%(%rdi), %rsi";
        }
        x86code.push_back(xx);
        x86code.push_back("\txor\t%rax, %rax");
        x86code.push_back("\tcall\tprintf");
        }
        string s = "";
        for (auto x : x86code)
        {
            s += x + "\n";
        }
        return s;
    }
};

class FunctnCall : public Instruction
{
public:
    FunctnCall()
    {
        scope = global_sym_table->current_scope;
    }
    string name;
    string objectName;
    vector<string> params;
    bool isCall = false;
    bool isConstr = false;
    string constrName = "";

    string mysize = "";

    string print()
    {

        string s = "";

        if (!isCall)
        {
            return s;
        }

        for (auto x : params)
        {
            s += "\tparam " + x + "\n";
        }
        // s=s.substr(0,s.length()-1);
        s += "\tpush basePointer\n\tbasePointer := stackPointer\n";
        s += "\tstackPointer := stackPointer -int " + mysize;

        return s;
    }

    string codegen(){
        if(isCall){
            for (auto x : params)
            {
                // s += "\tparam " + x + "\n";
                if((x[0]<='9' && x[0]>='0') || (x[0]=='-')) {
                    // x86code.push_back("push\t$"+x);
                    x86code.push_back("subq\t$4,%rsp");
                    x86code.push_back("movl\t$" + x + ", (%rsp)");
                }
                else{
                    int y;
                    vector<string> code;
                    y = target->getOffset(x, scope);
                    if(y<0){
                        y*=-1;
                        code.push_back("");
                        code.push_back(to_string(y)+"(%rdi)");
                        y=4;
                    }
                    else{
                        y = target->offsetToSize[y];
                        code = target->getReg(x, scope, y);
                        x86code.push_back(code[0]);
                    }

                    if(y==1){
                        x86code.push_back("pushb\t%"+code[1]);
                    }
                    else if(y==4){
                        x86code.push_back("subq\t$4,%rsp");
                        x86code.push_back("movl\t%"+code[1]+", (%rsp)");
                    }
                    else {
                        x86code.push_back("pushq\t%"+code[1]);
                    }
                }
            }

            // mov objec refer to reg
            if(isConstr==false){
                if(objectName!="" && objectName!=name){
                    int off1 = target->getOffset(objectName,scope,8);
                    // cout<<objectName<<endl;
                    x86code.push_back("movq\t-"+to_string(off1)+"(%rbp), %rdi");
                }
                else{
                    x86code.push_back("movq\t-8(%rbp), %rdi");
                }
            }
            // call object.func
            // x86code.push_back("call " +name);
        }

        string s="";
        for (auto x : x86code){
            s+="\t" + x+"\n";
        }
        return s;
    }
};

class ArrayInsert : public Instruction
{
public:
    ArrayInsert()
    {
        scope = global_sym_table->current_scope;
    }
    vector<string> elements;
    string array; //pointer
    int typesize;

    string print()
    {
        int off = 0;
        string s = "";
        for (auto elem : elements)
        {
            if (elem == "")
                continue;
            s += "\tpushArr " + array + " " + elem + " " + to_string(off) + "\n"; // elem = $3 offset
            off += typesize;
        }
        return s;
    }

    string codegen(){

        
        // x86code.push_back("=====");
        
        x86code.push_back("movq\t-"+to_string(target->getOffset(array,scope,8))+"(%rbp), %rax");

        int off = 0;
        for (auto elem : elements)
        {
            if (elem == "")
                continue;
            x86code.push_back("movl\t$" + elem + ", "+to_string(off)+"(%rax)");
            off += typesize;
        }

        string s="";
        for (auto x : x86code){
            s+="\t" + x+"\n";
        }
        return s;
    }
};

class SymbolTableOffset : public Instruction
{
public:
    SymbolTableOffset()
    {
        scope = global_sym_table->current_scope;
    }
    string classname;
    string offset;
    int offValue;
    bool array = false;

    string print()
    {
        resSize = 4;
        string s = "\t" + result + " := getFromSymTable( " + classname + " , " + offset + ")";
        return s;
    }

    string codegen(){
        if(array==true){

        }
        else{
            Variable* varr =  global_sym_table->lookup_var(offset,0,1,classname);
            bool flag=false;
            for(auto modifs : varr->modifiers){
                if(modifs=="static"){
                    flag=true;
                }
            }

            if(flag){
                int y = target->getOffset(result, scope,4);
                target->tVarsToGlobals[result]=offset;
            }
            else{
                int x = target->getOffset(offset, classname,8 ,true);
                if(x==1){x=target->getOffset(offset,scope,8);}
                vector<string> code;
                code = target->getReg(to_string(x), scope,8);

                target->tVarsToValue.insert({result,x});

                x86code.push_back(code[0]);
                string reg = code[1];
                int y = target->getOffset(result, scope,8);
                string xx = "movq\t%" + reg + ", -" + to_string(y) + "(%rbp)";
                x86code.push_back(xx);
                // x86code.push_back("----");
            }
            
        }
        

        string s = "";
        for (auto yy : x86code)
        {
            s += "\t" + yy + "\n";
        }
        return s;
    }
};

class PointerAssignment : public Instruction
{
public:
    PointerAssignment()
    {
        scope = global_sym_table->current_scope;
    }
    string start;
    string offset;

    string print()
    {
        resSize = 4;
        string s = "\t" + result + " :=  *(" + start + " +int " + offset + ")";
        return s;
    }

    string codegen(){
        // int off1 = target->getOffset(start, scope);
        // int off2 = target->getOffset(offset, scope);
        vector<string> code;

        code = target->getReg(start, scope, 8);
        if(code[0]!="") x86code.push_back(code[0]);
        string reg11 = code[1];

        if(target->offsetToSize[target->getOffset(offset,scope)] == 4){
            code = target->getReg(offset, scope, 8, true);
        }
        else code = target->getReg(offset, scope, 8);
        if(code[0]!="")  x86code.push_back(code[0]);
        string reg12 = code[1];

        // x86code.push_back("---");
        // x86code.push_back("movq\t-" + to_string(off1) + "(%rbp), %" + reg11);
        // x86code.push_back("movq\t-" + to_string(off2) + "(%rbp), %" + reg12);
        int off = target->getOffset(result, scope);
        x86code.push_back("addq\t%" + reg11 + ", %" + reg12); // total offset saved in reg12
        
        // if(reg11!="rbp") x86code.push_back("addq\t%rbp, %" + reg12); 
        x86code.push_back("movl\t(%"+ reg12+ "), %eax");
        x86code.push_back("movl\t%eax, -" + to_string(off) + "(%rbp)");

        string s = "";
        for (auto yy : x86code)
        {
            s += "\t" + yy + "\n";
        }
        return s;
    }
};

class IR
{
public:
    vector<Instruction *> quadruple;
    vector<Instruction *> globals;
    map<string, Block *> blocks;

    int local_var_count = 0;
    int local_label_count = 0;

    string getVar(int index)
    {
        return quadruple[index]->result;
    }

    string getLocalVar()
    {
        return "t_" + to_string(local_var_count++);
    }
    string getLocalLabel()
    {
        return "L" + to_string(local_label_count++);
    }
    string nextLabel()
    {
        return "L" + to_string(local_label_count + 1);
    }

    int insert(Instruction *myInstruction)
    {
        quadruple.push_back(myInstruction);
        return quadruple.size() - 1;
    }

    // assignment
    int insert(string arg1, string res = "")
    {
        Assignment *myInstruction = new Assignment();

        myInstruction->arg1 = arg1;

        if (res == "")
            myInstruction->result = getLocalVar();
        else
            myInstruction->result = res;

        // myInstruction->codegen();
        quadruple.push_back(myInstruction);
        return quadruple.size() - 1;
    }

    //  normal instruction
    Instruction *create(string myArg1, string myArg2, string op, string res = "")
    {
        Assignment *myInstruction = new Assignment();

        // if(myArg1[0]>='0' && myArg1[0]<='9') myArg1 = getVar(stoi(myArg1));
        // if(myArg2[0]>='0' && myArg2[0]<='9') myArg2 = getVar(stoi(myArg2));
        if(myArg1[0]=='*'){
            string a1 = "";
            string a2 = "";
            int ind = 2;
            while (myArg1[ind] != '+')
                a1 += myArg1[ind++];
            ind++;
            while (myArg1[ind] != ')')
                a2 += myArg1[ind++];
            PointerAssignment* pointer = new PointerAssignment();
            pointer->start = a1;
            pointer->offset = a2;
            string temp = getLocalVar();
            pointer->result = temp;
            quadruple.push_back(pointer);
            myArg1 = temp;
        }
        if (myArg2[0] == '*')
        {
            string a1 = "";
            string a2 = "";
            int ind = 2;
            while (myArg2[ind] != '+')
                a1 += myArg2[ind++];
            ind++;
            while (myArg2[ind] != ')')
                a2 += myArg2[ind++];
            PointerAssignment *pointer = new PointerAssignment();
            pointer->start = a1;
            pointer->offset = a2;
            string temp = getLocalVar();
            pointer->result = temp;
            quadruple.push_back(pointer);
            myArg2 = temp;
        }
        myInstruction->arg1 = myArg1;
        myInstruction->arg2 = myArg2;
        myInstruction->op = op;

        if (res == "")
            myInstruction->result = getLocalVar();
        else
            myInstruction->result = res;

        return myInstruction;
    }

    // block
    int makeBlock(int index, string name = "", int endindex = -1)
    {
        if (endindex == -1)
            endindex = quadruple.size();

        Block *myInstruction = new Block();

        if (name == "")
            myInstruction->result = getLocalLabel();
        else
            myInstruction->result = name;

        for (int i = index; i < endindex; i++)
        {
            myInstruction->codes.push_back(quadruple[i]);
        }

        quadruple.erase(quadruple.begin() + index, quadruple.begin() + endindex);

        blocks.insert({myInstruction->result, myInstruction});

        Instruction *myInstruction2 = myInstruction;
        myInstruction2->isBlock = true;
        quadruple.push_back(myInstruction2);

        return quadruple.size() - 1;
    }
    int makeBlock()
    {
        Block *myInstruction = new Block();
        myInstruction->result = getLocalLabel();

        blocks.insert({myInstruction->result, myInstruction});

        Instruction *myInstruction2 = myInstruction;
        myInstruction2->isBlock = true;
        quadruple.push_back(myInstruction2);

        return quadruple.size() - 1;
    }

    int insertAss(string myArg1, string myArg2, string op, string res = "")
    {
        return insert(create(myArg1, myArg2, op, res));
    }

    // unconditional jump
    int insertJump(string myArg2, int index = -1)
    {
        UnconditionalJump *myInstruction = new UnconditionalJump();

        myInstruction->arg2 = myArg2;

        if (index == -1)
            quadruple.push_back(myInstruction);
        else
        {
            quadruple.insert(quadruple.begin() + index + 1, myInstruction);
        }

        if (blocks.find(myArg2) == blocks.end())
        {
            Block *myBlock = new Block();
            myBlock->result = myArg2;
            myBlock->isBlock = true;
            blocks.insert({myArg2, myBlock});

            Instruction *justLabel = myBlock;
            quadruple.push_back(justLabel);
        }

        return quadruple.size() - 1;
    }
    void insertNextJump(string arg1, string jumphere)
    {
        UnconditionalJump *myInstruction = new UnconditionalJump();
        myInstruction->arg2 = jumphere;

        Instruction *myJump = myInstruction;

        blocks[arg1]->codes.push_back(myJump);

        if (blocks.find(jumphere) == blocks.end())
        {
            Block *myBlock = new Block();
            myBlock->result = jumphere;
            myBlock->isBlock = true;
            blocks.insert({jumphere, myBlock});

            Instruction *justLabel = myBlock;
            quadruple.push_back(justLabel);
        }
    }

    // if statement
    int insertIf(int index, string arg1, string arg2, string arg3)
    {

        ConditionalJump *myInstruction = new ConditionalJump();

        string next = getLocalLabel();

        myInstruction->arg2 = arg1; // if a>b
        myInstruction->arg4 = arg2; // goto x

        quadruple.insert(quadruple.begin() + index + 1, myInstruction);

        insertNextJump(arg2, next);

        if (arg3 != "")
        {
            insertJump(arg3, index + 1);
            insertNextJump(arg3, next);
        }
        else
            insertJump(next, index + 1);

        return index;
    }

    int insertWhile(int startindex, int endindex, string condition, string arg2)
    {

        ConditionalJump *myInstruction = new ConditionalJump();

        string next = getLocalLabel();

        myInstruction->arg2 = condition; // if a>b
        myInstruction->arg4 = arg2;      // goto x

        quadruple.insert(quadruple.begin() + endindex + 1, myInstruction);
        insertJump(next, endindex + 1);

        int x = makeBlock(startindex);

        insertNextJump(arg2, quadruple[x]->result);

        updateIncompleteJump(quadruple[x]->result, quadruple[x]->result, next);

        return quadruple.size() - 1;
    }

    int insertFor(int mystart, int startindex, int endindex, string changeExp, string arg2)
    {
        //  for (i=0;i<10;i++)
        // i=0;
        // L1:
        // if i<10 goto arg2
        // goto next
        // arg2:
        // goto chageexp
        // changeexp:
        // goto L1

        ConditionalJump *myInstruction = new ConditionalJump();

        string next = getLocalLabel();

        if (startindex >= 0)
            myInstruction->arg2 = quadruple[endindex]->result; // if a>b
        else
            myInstruction->arg2 = "true";

        myInstruction->arg4 = arg2; // goto x

        quadruple.insert(quadruple.begin() + endindex + 1, myInstruction); // if-inserted
        insertJump(next, endindex + 1);                                    // goto next

        int x;

        if (startindex >= 0)
            x = makeBlock(startindex); // l1:
        else
            x = makeBlock(endindex + 1);

        if (changeExp != "")
        {
            insertNextJump(arg2, changeExp);                 // in arg2: goto changeexp
            insertNextJump(changeExp, quadruple[x]->result); // in changeexp: goto L1
        }
        else
        {
            insertNextJump(arg2, quadruple[x]->result);
        }

        if (mystart >= 0)
            x = makeBlock(mystart);

        updateIncompleteJump(quadruple[x]->result, changeExp, next);

        // printtemprories(quadruple[x]->result);

        return quadruple.size() - 1;
    }

    int InsertTwoWordInstr(string instr, string arg2)
    {

        TwoWordInstr *print = new TwoWordInstr();
        print->arg1 = instr;
        print->arg2 = arg2;
        return insert(print);
    }

    int insertFunctnCall(string funcName, vector<pair<string, int>> argList, int isdec = 0, bool isConstr = false, string mysize = "", bool isVoid = true)
    {
        FunctnCall *myCall = new FunctnCall();
        
        if(!isdec && !isConstr){
            string a1 = "";
            int ind = 0;
            while (funcName[ind] != '#')
                a1 += funcName[ind++];
            ind++;
            myCall->objectName=a1;
            // cout<<"here--"<<a1<<endl;

            a1="";
            while (ind<funcName.length())
                a1 += funcName[ind++];
            funcName=a1;
        }

        myCall->name = funcName;
        for (auto x : argList)
        {
            myCall->params.push_back(x.first);
        }
        myCall->isConstr = isConstr;
        myCall->mysize = mysize;
        if (!isdec)
            myCall->isCall = true;

        Instruction *myInstruction = myCall;

        quadruple.push_back(myInstruction);

        if (!isdec)
        {
            InsertTwoWordInstr("\tcall" , funcName);

            if (!isVoid)
                insertAss("popReturnValue", "", "");

            int t = 0;
            for (auto x : argList)
            {
                t += x.second;
            }

            insertAss("stackPointer", to_string(t), "+int", "stackPointer");
        }
        else
        {
            int t = 16;
            for (auto x : argList)
            {

                PointerAssignment *intr = new PointerAssignment();
                intr->result = x.first;
                intr->start = "basePointer";
                intr->offset = to_string(t);
                quadruple.push_back(intr);

                t += x.second;
            }
        }

        return quadruple.size() - 1;
    }

    int insertGetFromSymTable(string classs, string name, string res, int offset)
    {
        SymbolTableOffset *instr = new SymbolTableOffset();

        if (res == "")
            instr->result = getLocalVar();
        else
            instr->result = res;
        instr->classname = classs;
        instr->offset = name;
        instr->offValue = offset;

        return insert(instr);
    }
    int insertPointerAssignment(string start, string offset, string res)
    {
        PointerAssignment *instr = new PointerAssignment();
        if (res == "")
            instr->result = getLocalVar();
        else
            instr->result = res;
        instr->start = start;
        instr->offset = offset;
        return insert(instr);
    }

    int insertIncompleteJump(string arg1)
    {
        UnconditionalJump *myJump = new UnconditionalJump();
        myJump->result = arg1;
        myJump->incomplete = true;

        quadruple.push_back(myJump);
        return quadruple.size() - 1;
    }

    void updateIncompleteJump(string currBlock, string beforeBlock, string afterBlock)
    {
        int i = 0;
        for (auto x : blocks[currBlock]->codes)
        {
            if (x->isBlock)
            {
                updateIncompleteJump(x->result, beforeBlock, afterBlock);
            }
            else if (x->incomplete)
            {
                UnconditionalJump *myJump = new UnconditionalJump();
                string arg2;

                if (x->result == "continue")
                    arg2 = beforeBlock;
                else
                    arg2 = afterBlock;

                myJump->arg2 = arg2;

                blocks[currBlock]->codes[i] = myJump;
            }
            i++;
        }
    }

    void updateConstructor(string className){

        string blockName = className + ".Constr";
        if(blocks.find(blockName)==blocks.end()) return;

        vector<Instruction*> vi;

        for(auto x: blocks[className]->codes){
            if(!x->isBlock){
                x->fieldDec = true;
                // int off = target->getOffset(x->result,className);

                blocks[blockName]->codes.insert(blocks[blockName]->codes.begin()+2,x);
            }
            else{
                vi.push_back(x);
            }
        }
        blocks[className]->codes = vi;
    }

    string insertTernary(int index, string cond, string first, string sec)
    {
        string res1, res2, res = getLocalVar();

        if (blocks.find(first) != blocks.end())
        {
            res1 = blocks[first]->codes[blocks[first]->codes.size() - 1]->result;
        }
        else
        {
            res1 = first;
            first = getVar(makeBlock());
        }
        blocks[first]->codes.push_back(create(res1, "", "", res));

        if (blocks.find(sec) != blocks.end())
        {
            res2 = blocks[sec]->codes[blocks[sec]->codes.size() - 1]->result;
        }
        else
        {
            res2 = sec;
            sec = getVar(makeBlock());
        }
        blocks[sec]->codes.push_back(create(res2, "", "", res));

        insertIf(index, cond, first, sec);

        return res;
    }

    int insertArray(string arr, vector<string> elementss, int typeSize)
    {
        ArrayInsert *myins = new ArrayInsert();
        myins->array = arr;
        myins->elements = elementss;
        myins->typesize = typeSize;
        return insert(myins);
    }

    void print()
    {
        for (int i = 0; i < quadruple.size(); i++)
        {
            tacout << quadruple[i]->print();
            tacout << endl;
        }
        tacout.close();
    }

    void x86print(){
        // cout<<endl;

        for(int i=0; i < globals.size() ;i++){

            string t = globals[i]->print();

            string result="", arg1="";
            int j=0;
            while(result!="\t"+globals[i]->result+" := "){
                result+=t[j++];
            }
            while(j<t.length()){
                arg1+=t[j++];
            }

            if(i==0) sout<<"\t.text\n";
            sout<<"\t.global\t"<<globals[i]->result <<"\n";
            if(i==0) sout<<"\t.data\n";
            sout<<"\t.type\tgb, @object\n\t.size\tgb, 4\n";
            sout<<globals[i]->result<<":\n\t.long\t"<<arg1<<"\n";

        }
        sout<<"\t.text\n\t.globl\tmain\n\t.type\tmain, @function\n";

        for (int i = 0; i < quadruple.size(); i++)
        {
            sout <<quadruple[i]->codegen();
            // sout << endl;
        }
        sout<<"printLabel:\n";
        sout << "\t.asciz\t\"%d\\n\" ";
        sout<<endl;
        sout.close();
    }
};