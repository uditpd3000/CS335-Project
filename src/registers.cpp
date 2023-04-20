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
        map<string,string>tVarsToGlobals;

        vector<string> regs{"ecx", "edx", "r14d", "r15d"}; // 4-byte
        vector<string> regs8bit{"al","bl"}; // 8-bit regs
        vector<string> regsBig{"r8","r9","r10","r11","r12","r13"}; // 8-byte regs
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
            int x = offset;
            offset+=mysize;
            return offset;
        }

        string getReg(){
            string t = usedBigRegs.front();
            usedBigRegs.pop();
            usedBigRegs.push(t);
            return t;
        }

        vector<string> getReg(string name, string scope,  int mysize=4, bool slq = false){
            vector<string> v;
            string u,t;
            int myoffset;

            if(name=="basePointer"){
                t="rbp";

                v.push_back(u);
                v.push_back(t);

                return v;
            }
            else if(tVarsToGlobals.find(name)!=tVarsToGlobals.end()){
                t = usedRegs.front();
                u = "movl\t" + tVarsToGlobals[name] + "(%rip), %"+t;
                usedRegs.pop(); usedRegs.push(t);
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
                else if(slq==false) u = "movq\t$";
                else u = "movslq\t$";

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
                else if(slq==false) u = "movq\t-" + to_string(x) + "(%rbp), %"+t;
                else u = "movslq\t-" + to_string(x) + "(%rbp), %" + t;
            }
            else{
                myoffset = getMemoryLocation(name,scope);
                if(myoffset!=-1){
                    offsetToSize[myoffset] = mysize;

                    if(mysize==4) u = "movl\t-";
                    else if(mysize==1) u = "movb\t-";
                    else if(slq==false) u = "movq\t-";
                    else u = "movslq\t-";

                    u += to_string(myoffset) + "(%rbp), %" + t;
                }
                else{
                    myoffset = getMemoryLocation(name,scope,true);
                    u = "movq\t"+ to_string(myoffset) + "(%rdi), "+t;
                }
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
            // cout<<scope<<endl;
            // cout
            SymbolTable * curr = global_sym_table->linkmap[scope];
            if(isClass==false)while(curr->scope!="Global" && curr->isMethodOrConst==false)curr=curr->parent;
            else while(curr->scope!="Global" && curr->isClass==false)curr=curr->parent;
            // cout<<curr->scope<<endl;
            for(auto v:curr->vars){
                if(v->name==var){
                    // cout<<v->name<<"--"<<v->offset<<endl;
                    if(!isClass)
                        return v->offset+12;
                    else{
                        bool flag=false;
                        for(auto modifs : v->modifiers){
                            if(modifs=="static"){
                                flag=true;
                            }
                        }
                        if(flag) return 1;
                        else return v->offset;
                    }
                }
            }
            return -1;
        }

        int getTotalSize(string scope){
            // cout<<scope<<endl;
            SymbolTable * curr = global_sym_table->linkmap[scope];
            while(curr->scope!="Global" && (curr->isMethodOrConst==false))curr=curr->parent;
            return (curr->offset + 8);
        }

        int getOffset(string name, string scope, int mysize = 4, bool isClass = false)
        {
            int x,myoffset;
            if(name.length()>1 && (name[0]=='t' && name[1]=='_')){
                if(tVarsToMem.find(name)==tVarsToMem.end()){
                    // cout<<name<<"-"<<mysize<<endl;
                    x = allocateIntoMem(mysize);
                    myoffset = getTotalSize(scope);
                    x+=myoffset;
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
            if(x==-1){
                x=getMemoryLocation(name,scope,true);
                if(x!=1) {
                    // cout << name << ":----:" <<scope<<"---" <<x << "...."<<isClass<<endl;
                    return -x;
                }

            }
            offsetToSize.insert({x,mysize});
            return x;
        }

        void mapToMemory(string var, int offset){
            tVarsToMem.insert({var, offset});
        }

};