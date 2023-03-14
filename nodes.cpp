#include <bits/stdc++.h>

using namespace std;
extern ofstream fout;

extern int yylineno;

extern void throwError(string, int);

class Variable{
    public:
    string name;
    string type;
    vector<string> modifiers;
    bool isArray;
    int dims;
    int lineNo;
    vector<int> size;

    Variable(string myname, string mytype, int mylineNo, vector<string> myModifiers){
        name = myname;
        type = mytype;
        isArray = false;
        modifiers = myModifiers;
        lineNo = mylineNo;
        dims=0;

    }
    Variable(string myname, string mytype, vector<string> myModifiers, int mylineNo, bool myisArray, int mydims, vector<int> mysize){
        name = myname;
        type = mytype;
        isArray = true;
        modifiers = myModifiers;
        dims = mydims;
        size = mysize;
        lineNo = mylineNo;
    }
};

class Method{
    public:
    string name;
    string ret_type;
    vector<Variable*> parameters; 
    vector<string> modifiers;
    int lineNo;

    Method(string myname, string myret_type, vector<Variable*> myparameters, vector<string> mymodifiers, int mylineNo){
        name = myname;
        ret_type = myret_type;
        parameters = myparameters;
        modifiers = mymodifiers;
        lineNo = mylineNo;
    }


};

class Class{
    public:
    string name;
    vector<string> modifiers;
    int lineNo;
    int scope_count;
    Class(string myname, vector<string> mymodifiers, int mylineNo){
        name = myname;
        modifiers = mymodifiers;
        lineNo = mylineNo;
        // scope_count = scope_count;
    }
};

class Node {
  public:
    int lineno;
    string label; //seperator
    string lexeme; //}

    string type;

    Variable* var;
    Method* method;
    Class* cls;
    int dims=0;
    vector<Variable*> variables;

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


class SymbolTable {

    public:

    SymbolTable * parent;
    string scope;
    int num;
    vector<Variable*> vars;
    vector<Class*> classes;
    vector<Method*> methods;

    bool isMethod=false, isClass=false;

    SymbolTable(SymbolTable* myparent, string myscope, int mynum){
        parent = myparent;
        scope = myscope;
        num = mynum;
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
    void printTable(){
        cout<<"Scope: "<<scope<<endl;
        cout<<"Variables coming\n\n";
        for(auto i:vars){
            cout<<"Name: "<<i->name<<" Type: "<<i->type<<endl;
            cout<<"Array? "<<i->isArray;
            cout<<"Mod: ";
            for(auto j:i->modifiers){cout<<j<<" ";}
            cout<<endl;
        }
        cout<<"Methods coming\n\n";
        for(auto i:methods){
            cout<<"Name: "<<i->name<<" Type: "<<i->ret_type<<endl;
            cout<<"Parameters:";
            for(auto j:i->parameters){
                cout<<"Name: "<<j->name<<" Type: "<<j->type<<endl;
            }
            cout<<"Modifiers :";
            for(auto j:i->modifiers){
                cout<<j<<" ";
            }
            cout<<"\n\n";
        }
        cout<<"Classes coming\n\n";
        for(auto i:classes){
            cout<<"Name: "<<i->name<<" Line: "<<i->lineNo<<endl;
        }
        cout<<"\n\n---Table end---\n\n";
    }
    


};

class GlobalSymbolTable {
    public:

    string current_scope;
    SymbolTable* current_symbol_table;
    int scope_count=0;

    map<int,SymbolTable*> tablemap; // scope-number maped
    map<string,SymbolTable*> linkmap; // scope

    GlobalSymbolTable(){

        current_scope="Yayyy";
        SymbolTable* initial = new SymbolTable(NULL, current_scope, scope_count++);
        tablemap[scope_count-1]=initial;
        linkmap[current_scope]= initial;
        current_symbol_table = initial;
    }

    // lookups
    Variable* lookup_var(string s, int pp, string scope){

        SymbolTable* curr = current_symbol_table;

        while(curr->parent!=NULL){
            for(int i=0; i<curr->vars.size();i++){
                if(curr->vars[i]->name==s)return curr->vars[i];
            }
            curr=curr->parent;
        }

        if(pp){
            cout<<"Error: Variable " << s << " is not declared in this scope"<<endl;
            exit(1);
        }
        return NULL;
    }

    Method* lookup_method(string s, int pp, string scope){

        SymbolTable* curr = current_symbol_table;

        while(curr->parent!=NULL){
            for(int i=0; i<curr->methods.size();i++){
                if(curr->methods[i]->name==s)return curr->methods[i];
            }
            curr=curr->parent;
        }

        if(pp){
            cout<<"Error: Method " << s << " is not declared in this scope"<<endl;
            exit(1);
        }
        return NULL;
        
    }

    Class* lookup_class(string s, int pp, string scope){

        SymbolTable* curr = current_symbol_table;

        if(s=="String"){
            Class * Str = new Class("String",{},0);
            return Str;
        }

        while(curr!=NULL){
            // cout<<curr->scope<<"   "<<s<<"--";
            for(int i=0; i<curr->classes.size();i++){
                if(curr->classes[i]->name==s)return curr->classes[i];
            }
            curr=curr->parent;
        }

        if(pp){
            cout<<"Error: Class " << s << " is not declared in this scope"<<endl;
            exit(1);
        }
        return NULL;

    }

    SymbolTable* makeTable(string scope){

        // SymbolTable* nnn = current_symbol_table

        SymbolTable *newTable = new SymbolTable(current_symbol_table, scope, scope_count++ );
        tablemap[scope_count-1]=newTable;
        linkmap[scope]=newTable;
        current_symbol_table= newTable;
        // cout<<scope_count;
        current_scope = scope;
        return newTable;
    }

    string generate_scopename(){

        string x = "S_";
        x+=to_string(scope_count++);
        return x;

    }

    SymbolTable* makeTable(){
        string scopee = generate_scopename();

        SymbolTable *newTable = new SymbolTable(current_symbol_table, scopee, scope_count);
        current_scope = scopee;
        current_symbol_table = newTable;
        tablemap[scope_count-1]=newTable;
        return newTable;

    }

    void end_scope(){
        current_scope= current_symbol_table->parent->scope;
        current_symbol_table=current_symbol_table->parent;
    }

    bool insertCheck(string symbol){
        if(lookup_var(symbol,0,current_scope)==NULL){
            if(lookup_method(symbol,0,current_scope)==NULL){
                if(lookup_class(symbol,0,current_scope)==NULL){
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
        // cout<<classs->name<<"k";
        if(insertCheck(classs->name)){
            classs->scope_count=scope_count-1;
           current_symbol_table->insert_class(classs);
        }        
    }
    void printAll(){
        for(int i=0;i<scope_count;i++){
            tablemap[i]->printTable();
        }
    }

    bool typeCheckVar(string s1, string s2, int myLineno){
        Variable* v1 = lookup_var(s1,1,current_scope);
        Variable* v2 = lookup_var(s2,1,current_scope);
        if(v1->type!=v2->type){
            throwError("Type mismatch: "+v1->type+" cannot be converted to "+v2->type,myLineno);
        }
        return true;   
    }
    bool typeCheckVar(Variable* v1, Variable* v2,int myLineno){
        if(v1->type!=v2->type){
            throwError("Type mismatch: "+v1->type+" cannot be converted to "+v2->type,myLineno);
        }
        return true;   
    }
    bool typeCheckVar(Variable* v1, string myType,int myLineno){
        if(v1->type!=myType){
            throwError("Type mismatch: "+v1->type+" cannot be converted to "+myType,myLineno);
        }
        return true;   
    }

};
