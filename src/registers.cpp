#include <bits/stdc++.h>
#include "symbol-table.cpp"

using namespace std;

extern GlobalSymbolTable* global_sym_table;

class X86{
    public:
        map<string,string>regTovar;
        // map<string,string>varToreg;
        map<string,int>tVarsToMem;

        vector<string> regs{"eax","ebx","ecx","edx"}; // 4-byte
        vector<string> regs8bit{"al","bl","cl","dl"}; // 8-bit regs
        queue<string>usedRegs;
        queue<string>usedRegs8bit;

        int offset;

        X86(){
            for (auto i:regs){
                usedRegs.push(i);
            }
            for (auto i:regs8bit){
                usedRegs8bit.push(i);
            }
        }

        void initFuncLocal(){
            // at time of BiginFunc
            offset=0;
            regTovar.clear();
            tVarsToMem.clear();
            // cout<<"done";
        }
        int allocateIntoMem(int mysize){
            int x = offset;
            offset+=mysize;
            return x;
        }

        vector<string> getReg(string name, string scope, int mysize=4){
            vector<string> v;
            string u,t;
            int myoffset;

            if(mysize!=1) t = usedRegs.front();
            else t=usedRegs8bit.front();

            if(name[0]<='9' && name[0]>='0'){
                u = "movl\t$" +name + ", %"+t;
            }
            else if(name.length()>1 && (name[0]=='t' && name[1]=='_')) {
                int x;
                if(tVarsToMem.find(name)==tVarsToMem.end()){
                    x = allocateIntoMem(mysize);
                    myoffset = getTotalSize(scope);
                    x+=myoffset;
                    tVarsToMem.insert({name,x}); // allocated a temporary 
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

                if(mysize==4) u = "movl\t-";
                else if(mysize==1) u = "movb\t-";
                else u = "movq\t-";

                u += to_string(myoffset) + "(%rbp), %" + t;
            }

            regTovar[t] = name;
            if(mysize!=1) {
                usedRegs.pop(); usedRegs.push(t);
            }
            else {
                usedRegs8bit.pop(); usedRegs8bit.push(t);
            }
            
            v.push_back(u);
            v.push_back(t);

            return v;
            
        }

        int getMemoryLocation(string var, string scope){
            SymbolTable * curr = global_sym_table->linkmap[scope];
            while(curr->scope!="Global" && curr->isMethod==false)curr=curr->parent;
            for(auto v:curr->vars){
                if(v->name==var)return v->offset+4;
            }
            return -1;
        }

        int getTotalSize(string scope){
            SymbolTable * curr = global_sym_table->linkmap[scope];
            while(curr->scope!="Global" && curr->isMethod==false)curr=curr->parent;
            return (curr->offset + 4);
        }

        int getOffset(string name, string scope, int mysize=4){
            int x,myoffset;
            if(name.length()>1 && (name[0]=='t' && name[1]=='_')){
                if(tVarsToMem.find(name)==tVarsToMem.end()){
                    x = allocateIntoMem(mysize);
                    myoffset = getTotalSize(scope);
                    x+=myoffset;
                    tVarsToMem.insert({name,x}); // allocated a temporary 
                }
                else {
                    x=tVarsToMem[name];
                }
            }
            else{
                x = getMemoryLocation(name,scope);
            }
            return x;
        }

};