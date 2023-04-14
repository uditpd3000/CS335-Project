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
        }
        int allocateIntoMem(int mysize){
            int x = offset;
            offset+=mysize;
            return x;
        }

        vector<string> getReg(string name, int offset=-1, int mysize=-1){
            vector<string> v;
            string u,t;
            if(mysize!=-1) {
                int x = allocateIntoMem(mysize);
                tVarsToMem.insert({name,x}); // allocated a temporary 
                u = "mov [ebp -" + to_string(offset + x) + "], ";
            }
            else{
                u = "mov [ebp -" + to_string(offset) + "], ";
            }

            t = usedRegs.front();
            u+=t;
            regTovar[t] = name;
            usedRegs.pop(); usedRegs.push(t);
            
            v.push_back(u);
            v.push_back(t);

            return v;
            
        }

        int getMemoryLocation(string var){
            SymbolTable * curr = global_sym_table->current_symbol_table;
            while(curr->scope!="Global" && curr->isMethod==false)curr=curr->parent;
            for(auto v:curr->vars){
                if(v->name==var)return v->offset;
            }

        }

};