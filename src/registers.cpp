#include <bits/stdc++.h>

using namespace std;

class X86{
    public:
        map<string,string>regTovar;
        map<string,string>varToreg;

        vector<string> regs{"rax","rbx","rcx","rdx","r8","r9","r10","r11","r12","r13","r14","r15"};
        queue<string> usedRegs;
        queue<string> unusedRegs;

        X86(){
            for (auto i:regs){
                unusedRegs.push(i);
            }
        }

        string getReg(){
            if(!(unusedRegs.empty())){
                string t = unusedRegs.front();
                unusedRegs.pop();
                usedRegs.push(t);
                return t;
            }
            string t = usedRegs.front();
            usedRegs.pop();
            // store in memory
            usedRegs.push(t);
            return t;
            
        }

};