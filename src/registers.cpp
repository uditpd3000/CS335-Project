#include <bits/stdc++.h>
#include "symbol-table.cpp"

using namespace std;

extern GlobalSymbolTable* global_sym_table;

class X86{
    public:
        map<string,string>regTovar;
        // map<string,string>varToreg;
        map<string,int>tVarsToMem;

        vector<string> regs{"rax","rbx","rcx","rdx","r8","r9","r10","r11","r12","r13","r14","r15"};
        queue<string>usedRegs;

        int offset;

        X86(){
            for (auto i:regs){
                usedRegs.push(i);
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

            t = usedRegs.front();

            if(name[0]<='9' && name[0]>='0'){
                u = "movq\t$" +name + ", %"+t;
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
                u = "movq\t-" + to_string(x) + "(%rbp), %"+t;
            }
            else{
                myoffset = getMemoryLocation(name,scope);
                u = "movq\t-" + to_string(myoffset) + "(%rbp), %" + t;
            }

            regTovar[t] = name;
            usedRegs.pop(); usedRegs.push(t);
            
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
            return (curr->offset + 12);
        }

        int getOffset(string name, string scope, bool isClass=false,int mysize=4 ){
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
                x = getMemoryLocation(name,scope,isClass);
            }
            return x;
        }

        void mapToMemory(string var, int offset){
            tVarsToMem.insert({var, offset});
        }

};