#include <bits/stdc++.h>

using namespace std;
extern ofstream fout;

class Node {
  public:
    string label; //seperator
    string lexeme; //}

    vector<Node*> objects;

    Node(){
        label="";
        lexeme="";
    }
    Node(string l){
        label=l;
        lexeme="";
    }
    Node(string a,string b){
        label=a;
        lexeme=b;
    }

    void add(Node* a){
        objects.push_back(a);
    }
    void add(vector<Node*> a){
        for(auto x:a) objects.push_back(x);
    }

    void print(){
        fout<<label;
        if(lexeme!=""){
            if(lexeme[0]!='"' && lexeme[lexeme.length()-1]) fout<<"__"<<lexeme; //seperator__}
            else{
                fout<<"__\\"<<lexeme.substr(0,lexeme.length()-1)<<"\\\"";
            }
        }

    }
};

class Variable{
    public:
    string name;
    string type;
    vector<string> modifiers;
    bool isArray;
    int dims;
    int lineNo;
    vector<int> size;

    Variable(){
        name="";
    }
    Variable(string name, string type, int lineNo, vector<string> Modifiers){
        name = name;
        type = type;
        isArray = false;
        modifiers = modifiers;
        lineNo = lineNo;

    }
    Variable(string name, string type, vector<string> Modifiers, int lineNo, bool isArray, int dims, vector<int> size){
        name = name;
        type = type;
        isArray = true;
        modifiers = modifiers;
        dims = dims;
        size = size;
        lineNo = lineNo;
    }
};

class Method{
    public:
    string name;
    string ret_type;
    vector<Variable*> parameters; 
    vector<string> modifiers;
    int lineNo;

    Method(){
        name="";
    }
    Method(string name, string ret_type, vector<Variable*> parameters, vector<string> modifiers){
        name = name;
        ret_type = ret_type;
        parameters = parameters;
        modifiers = modifiers;
        lineNo = lineNo;
    }


};

class Class{
    public:
    string name;
    vector<string> modifiers;
    int lineNo;

    Class(){
        name="";
    }
    Class(string name, vector<string> modifiers, int lineNo){
        name = name;
        modifiers = modifiers;
        lineNo = lineNo;

    }

};

class SymbolTable {

    public:

    SymbolTable * parent;
    string scope;
    vector<Variable*> vars;
    vector<Class*> classes;
    vector<Method*> methods;

    SymbolTable(SymbolTable* parent, string scope){
        parent = parent;
        scope = scope;
        vars = {};
        classes = {};
        methods = {};

    }

    void insert_variable(Variable* var){
        vars.push_back(var);
    }
    void insert_method(Method* method){
        methods.push_back(method);
    }
    void insert_class(Class* classs){
        classes.push_back(classs);
    }
    


};

class GlobalSymbolTable {
    public:

    string current_scope;
    SymbolTable* current_symbol_table;
    int scope_count=0;

    GlobalSymbolTable(){

        current_scope="Yayyy";
        SymbolTable* initial = new SymbolTable(NULL, current_scope);
        current_symbol_table = initial;
    }

    Variable* lookup_var(string s, int pp){

        SymbolTable* curr = current_symbol_table;

        while(curr->parent!=NULL){
            for(int i=0; i<curr->vars.size();i++){
                if(curr->vars[i]->name==s)return curr->vars[i];
            }
            curr=curr->parent;
        }

        if(pp)cout<<"Error: Variable " << s << " is not declared in this scope"<<endl;
        return NULL;
    }

    Method* lookup_method(string s, int pp){

        SymbolTable* curr = current_symbol_table;

        while(curr->parent!=NULL){
            for(int i=0; i<curr->methods.size();i++){
                if(curr->methods[i]->name==s)return curr->methods[i];
            }
            curr=curr->parent;
        }

        if(pp)cout<<"Error: Method " << s << " is not declared in this scope"<<endl;
        return NULL;
        
    }

    Class* lookup_class(string s, int pp){

        SymbolTable* curr = current_symbol_table;

        while(curr->parent!=NULL){
            for(int i=0; i<curr->classes.size();i++){
                if(curr->classes[i]->name==s)return curr->classes[i];
            }
            curr=curr->parent;
        }

        if(pp)cout<<"Error: Class " << s << " is not declared in this scope"<<endl;
        return NULL;

    }

    SymbolTable* makeTable(string scope){

        // SymbolTable* nnn = current_symbol_table

        SymbolTable *newTable = new SymbolTable(current_symbol_table, scope );
        current_scope = scope;
        return newTable;
    }

    string generate_scopename(){

        string x = "S_";
        x+=to_string(scope_count++);
        return x;

    }

    SymbolTable* makeTable(){

        SymbolTable *newTable = new SymbolTable(current_symbol_table, generate_scopename());
        // current_scope
        return newTable;

    }

    bool insertCheck(string symbol){
        if(lookup_var(symbol,0)==NULL){
            if(lookup_method(symbol,0)==NULL){
                if(lookup_class(symbol,0)==NULL){
                    return true;
                    
                }
            }
        }
        cout<<"Redeclaration of symbol : "<<symbol <<endl; 
        return false;
        
    }

    void insert(Variable* var){
        if(insertCheck(var->name)){
           current_symbol_table->insert_variable(var);
        }
        
    }
     void insert(Method* method){
        if(insertCheck(method->name)){
           current_symbol_table->insert_method(method);
        }
        
    }
     void insert(Class* classs){
        if(insertCheck(classs->name)){
           current_symbol_table->insert_class(classs);
        }
        
    }

};

// #include <bits/stdc++.h>

// using namespace std;
// extern ofstream fout;

// class Symbol{
//     public:
//         string name; // x
//         string token; // identifier
//         string type; // int
//         string value; // 5
//         string lineNo; // 2

//         vector<string> modifiers; // public, static

//         // if array type
//         int dims; // max 3
//         vector<int> size; // of size equal to dims
//         map<string,Symbol*> vals; // array access // parameters in case of functions

//         Symbol(){

//         }
//         Symbol(string lexeme, string myType, string myVal){
//             name=lexeme;
//             // token=mymap[lexeme].token;
//             type=myType;
//             value=myVal;
//             // lineNo=mymap[lexeme].lineNo;
//         }
//         Symbol(string lexeme, string RetType, vector<Symbol*>parameters){
//             name=lexeme;
//             type=RetType;

//             for(auto x:parameters){
//                 vals.insert({x->name,x});
//             }
//         }

//         void addModifiers(string myMod){
//             modifiers.push_back(myMod);
//         }
//         void addModifiers(vector<string> myMods){
//             for(auto x:myMods) modifiers.push_back(x);
//         }

//         void addDims(vector<int>mySizes){
//             // int x[]={1,2,3};
//             // int sum[][]= new int[rows][columns]; dim=2, rows,clm
//             dims=mySizes.size();
//             size= mySizes;
//         }

//         Symbol* getArrayAcess(string index){
//             // sum[1][2]=5;
//             // sum + [1][2]
//             return vals[index];
//         }

// };

// // class Function{

// //     map<string,Symbol*>params;
// //     string retType;

// //     vector<string> modifiers; // public, static

// // };

// class SymbolTable{
//     public:
//     string label;
//     string scope;
//     string parent=""; // scope of parent
//     map<string,Symbol*> syms;
//     map<string,Symbol*> functions;
//     map<string,string> blocks;

//     SymbolTable(string myLabel, string myScope){
//         label=myLabel;
//         scope=myScope;
//     }

//     void addSym(string lexeme, string myType, string myVal, vector<string>modifs, vector<int>mySizes){
//         if(syms.find(lexeme)==syms.end()){
//             auto x = new Symbol(lexeme,myType,myVal);
//             syms.insert({lexeme,x});
//             // add Modifiers, dims
//             if(modifs.size()) x->addModifiers(modifs);
//             if(mySizes.size()) x->addDims(mySizes);
//         }
//         else {
//             cout<<"Symbol \""<<lexeme<<"\" redeclared, check your program\n";
//             exit(-1);
//         }
//     }
//     void addFunc(){}
// };

// class ScopeTable{
//     // maintains list of symTables

//     int labelCount=0;
//     int tempVarCount=0;
//     string scope="start";
//     string prefix="j";
//     SymbolTable* symTable; // parent none

//     map<string,SymbolTable*> linkMap;

//     ScopeTable(string label){
//         symTable = new SymbolTable(label,scope);
//         scope = label;
//         linkMap.insert({scope,symTable});
//     }

//     void endScope(){
//         scope=linkMap[scope]->parent;
//     }

//     string makeLabel(){
//         labelCount++;
//         return prefix+ to_string(labelCount);
//     }

//     string makeTemp(){
//         string px = "t";
//         tempVarCount++;
//         return px + to_string(tempVarCount);
//     }

//     string getParentScope(){
//         return linkMap[scope]->parent;
//     }

//     Symbol* lookup(string symbol,bool is_func=false){
//         string curr_scope=scope;

//         while(scope!=""){
//             if(!is_func){
//                 if(linkMap[curr_scope]->syms.find(symbol)!=linkMap[curr_scope]->syms.end())
//                     return linkMap[curr_scope]->syms[symbol];
//                 else{
//                     for(auto x: linkMap[curr_scope]->functions){
//                         if(x.second->vals.find(symbol)!=x.second->vals.end())
//                             return x.second->vals[symbol];
//                     }
//                 }
//             }
//             else if(is_func && linkMap[curr_scope]->functions.find(symbol)!=linkMap[curr_scope]->functions.end()){
//                 return linkMap[curr_scope]->functions[symbol];
//             }
//             else{
//                 curr_scope=linkMap[curr_scope]->parent;
//             }
//         }
//         return NULL;
//     }

//     //Universal function to insert any symbol into current symbol table
//     // Returns a string representing the new scope name if a new block is
//     // about to start; otherwise returns None

//     string insert(string myName, string myType,vector<string> myModifiers, string myVal="",bool is_func=false, vector<Symbol*> args = vector<Symbol*>(),bool is_array=false,vector<int> arr_size=vector<int>(),string myScope=""){
//         if(myScope==""){
//             myScope=scope;
//         }
//         if(!is_func){
//             linkMap[myScope]->addSym(myName, myType, myVal, myModifiers, arr_size);
//             return "";
//         }
//         else{
//             linkMap[myScope]->addFunc();
//         }
//     }
// };

// class Node {
//   public:
//     string label; //seperator
//     string lexeme; //}

//     vector<Node*> objects;

//     Node(){
//         label="";
//         lexeme="";
//     }
//     Node(string l){
//         label=l;
//         lexeme="";
//     }
//     Node(string a,string b){
//         label=a;
//         lexeme=b;
//     }

//     void add(Node* a){
//         objects.push_back(a);
//     }
//     void add(vector<Node*> a){
//         for(auto x:a) objects.push_back(x);
//     }

//     void print(){
//         fout<<label;
//         if(lexeme!=""){
//             if(lexeme[0]!='"' && lexeme[lexeme.length()-1]) fout<<"__"<<lexeme; //seperator__}
//             else{
//                 fout<<"__\\"<<lexeme.substr(0,lexeme.length()-1)<<"\\\"";
//             }
//         }

//     }
// };