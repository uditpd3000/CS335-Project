#include <bits/stdc++.h>

using namespace std;
extern ofstream fout;

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

class Node {
  public:
    string label; //seperator
    string lexeme; //}

    Variable* var;
    Method* method;
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

class Class{
    public:
    string name;
    vector<string> modifiers;
    int lineNo;
    Class(string myname, vector<string> mymodifiers, int mylineNo){
        name = myname;
        modifiers = mymodifiers;
        lineNo = mylineNo;

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
    map<int,SymbolTable*> tablemap;

    GlobalSymbolTable(){

        current_scope="Yayyy";
        SymbolTable* initial = new SymbolTable(NULL, current_scope, scope_count++);
        tablemap[scope_count-1]=initial;
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

        SymbolTable *newTable = new SymbolTable(current_symbol_table, scope, scope_count++ );
        tablemap[scope_count-1]=newTable;
        current_symbol_table= newTable;
        cout<<scope_count;
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
        // cout<<scope_count;
        tablemap[scope_count-1]=newTable;
        return newTable;

    }

    void end_scope(){
        current_scope= current_symbol_table->parent->scope;
        current_symbol_table=current_symbol_table->parent;
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
        // cout<<classs->name<<"k";
        if(insertCheck(classs->name)){
           current_symbol_table->insert_class(classs);
        }
        
    }
    void printAll(){
        for(int i=0;i<scope_count;i++){
            tablemap[i]->printTable();
        }
    }

};
