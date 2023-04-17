#include <bits/stdc++.h>
#include "symbol-table.cpp"

using namespace std;

extern GlobalSymbolTable* global_sym_table;

class X86{
    public:
        map<string,string>regTovar;
        // map<string,string>varToreg;
        map<string,int>tVarsToMem;
        map<int,int> offsetToSize;

        vector<string> regs{"eax","ebx","ecx","edx"}; // 4-byte
        vector<string> regs8bit{"al","bl","cl","dl"}; // 8-bit regs
        vector<string> regsBig{"rbx","rcx","rdx","r12","r13","r14"}; // 8-byte regs
        queue<string>usedRegs;
        queue<string>usedRegs8bit;
        queue<string>usedBigRegs;

        int offset;
        int labelcnt=0;

        X86(){
            for (auto i:regs){
                usedRegs.push(i);
            }
            for (auto i:regs8bit){
                usedRegs8bit.push(i);
            }
            for (auto i:regsBig){
                usedBigRegs.push(i);
            }
        }

        void initFuncLocal(){
            // at time of BiginFunc
            offset=0;
            regTovar.clear();
            tVarsToMem.clear();
            offsetToSize.clear();
            // cout<<"done";
        }
        string localLabel(){
            return "L_OP" + to_string(labelcnt++);
        }
        int allocateIntoMem(int mysize){
            cout<<mysize<<"]]]]"<<endl;
            int x = offset;
            offset+=mysize;
            return offset;
        }

        string getReg(){
            string t = usedRegs.front();
            usedRegs.pop();
            usedRegs.push(t);
            return t;
        }

        vector<string> getReg(string name, string scope, int mysize=4){
            vector<string> v;
            string u,t;
            int myoffset;

            if(name=="basePointer"){
                t="rbp";

                v.push_back(u);
                v.push_back(t);

                return v;
            }

            if(mysize==4) t = usedRegs.front();
            else if(mysize==1) t=usedRegs8bit.front();
            else t = usedBigRegs.front();

            if((name[0]<='9' && name[0]>='0') || (name[0]=='-')){

                if(mysize==4) u = "movl\t$";
                else if(mysize==1) u = "movb\t$";
                else u = "movq\t$";

                u += name + ", %"+t;
            }
            else if(name.length()>1 && (name[0]=='t' && name[1]=='_')) {
                int x;
                if(tVarsToMem.find(name)==tVarsToMem.end()){
                    x = allocateIntoMem(mysize);
                    myoffset = getTotalSize(scope);
                    x+=myoffset;
                    tVarsToMem.insert({name,x}); // allocated a temporary 
                    offsetToSize.insert({x,mysize});
                }
                else {
                    x=tVarsToMem[name];
                }

                if(mysize==4) u = "movl\t-" + to_string(x) + "(%rbp), %"+t;
                else if(mysize==1) u = "movb\t-" + to_string(x) + "(%rbp), %"+t;
                else u = "movq\t-" + to_string(x) + "(%rbp), %"+t;

            }
            else{
                myoffset = getMemoryLocation(name,scope);
                offsetToSize[myoffset] = mysize;

                if(mysize==4) u = "movl\t-";
                else if(mysize==1) u = "movb\t-";
                else u = "movq\t-";

                u += to_string(myoffset) + "(%rbp), %" + t;
            }

            regTovar[t] = name;
            if(mysize==4) {
                usedRegs.pop(); usedRegs.push(t);
            }
            else if(mysize==1){
                usedRegs8bit.pop(); usedRegs8bit.push(t);
            }
            else{
                usedBigRegs.pop(); usedBigRegs.push(t);
            }
            
            v.push_back(u);
            v.push_back(t);

            return v;
            
        }

        int getMemoryLocation(string var, string scope, bool isClass=false){
            // cout<<var<<endl;
            SymbolTable * curr = global_sym_table->linkmap[scope];
            if(isClass==false)while(curr->scope!="Global" && curr->isMethod==false)curr=curr->parent;
            else while(curr->scope!="Global" && curr->isClass==false)curr=curr->parent;
            for(auto v:curr->vars){
                if(v->name==var)return v->offset+12;
            }
            return -1;
        }

        int getTotalSize(string scope){
            SymbolTable * curr = global_sym_table->linkmap[scope];
            while(curr->scope!="Global" && curr->isMethod==false)curr=curr->parent;
            return (curr->offset + 8);
        }

        int getOffset(string name, string scope, int mysize = 4, bool isClass = false)
        {
            int x,myoffset;
            if(name.length()>1 && (name[0]=='t' && name[1]=='_')){
                if(tVarsToMem.find(name)==tVarsToMem.end()){
                    x = allocateIntoMem(mysize);
                    myoffset = getTotalSize(scope);
                    x+=myoffset;
                    cout<<x<<"x"<<endl;
                    cout<<myoffset<<"myoff";
                    tVarsToMem.insert({name,x}); // allocated a temporary
                    offsetToSize.insert({x,mysize}); 
                }
                else {
                    x=tVarsToMem[name];
                }
            }
            else{
                x = getMemoryLocation(name,scope,isClass);
            }
            return x;
        }

        void mapToMemory(string var, int offset){
            tVarsToMem.insert({var, offset});
        }

};