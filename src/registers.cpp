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

        vector<string> getReg(string name, string scope, int mysize=4){
            vector<string> v;
            string u,t;
            int offset;

            t = usedRegs.front();

            if(name[0]<='9' && name[0]>='0'){
                u = "mov "+t+", $" +name;
            }
            else if(name.length()>1 && (name[0]=='t' && name[1]=='_')) {
                int x;
                if(tVarsToMem.find(name)==tVarsToMem.end()){
                    x = allocateIntoMem(mysize);
                    tVarsToMem.insert({name,x}); // allocated a temporary 
                    offset = getTotalSize(scope);
                }
                else {
                    x=tVarsToMem[name];
                }
                u = "mov "+t+",[ebp -" + to_string(offset + x) + "]";
            }
            else{
                offset = getMemoryLocation(name,scope);
                u = "mov "+t+", [ebp -" + to_string(offset) + "]";
            }

            regTovar[t] = name;
            usedRegs.pop(); usedRegs.push(t);
            
            v.push_back(u);
            v.push_back(t);

            return v;
            
        }

        int getMemoryLocation(string var, string scope){
            SymbolTable * curr = global_sym_table->linkmap[scope];
            while(curr->scope!="Global" && curr->isMethod==false)curr=curr->parent;
            for(auto v:curr->vars){
                if(v->name==var)return v->offset;
            }
            return -1;
        }

        int getTotalSize(string scope){
            SymbolTable * curr = global_sym_table->linkmap[scope];
            while(curr->scope!="Global" && curr->isMethod==false)curr=curr->parent;
            return curr->offset;
        }

};