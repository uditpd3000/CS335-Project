#include <bits/stdc++.h>

using namespace std;
extern ofstream fout;

extern int yylineno;

extern map<string,int> typeToSize;

extern void throwError(string, int);

class Variable{
    public:
    string name;
    string type;
    string value;
    vector<string> modifiers;
    bool isArray;
    int dims;
    int lineNo;
    vector<int> dimsSize;
    string classs_name;
    int size;
    int offset;
    bool inherited;
    string objName;

    Variable(string myname, string mytype, int mylineNo, vector<string> myModifiers, string myvalue){
        name = myname;
        type = mytype;
        isArray = false;
        modifiers = myModifiers;
        lineNo = mylineNo;
        value = myvalue;
        dims=0;
        if(typeToSize.find(mytype)!=typeToSize.end()){
            size = typeToSize[mytype];
            cout<<myname<<"---------------------------------------------------------------"<<size<<"\n";
            
        }

    }
    Variable(string myname, string mytype, vector<string> myModifiers, int mylineNo, bool myisArray, int mydims, vector<int> mysize, string myvalue){
        name = myname;
        type = mytype;
        isArray = true;
        modifiers = myModifiers;
        dims = mydims;
        dimsSize = mysize;
        lineNo = mylineNo;
        value = myvalue;
        if(typeToSize.find(mytype)!=typeToSize.end()){
            int size1= typeToSize[mytype];
            if(dimsSize.size()!=0){    
                cout<<dimsSize.size()<<"sizeeeeeeeeeeeeeeeeeeeeeee\n";
                for (int i=0;i<dimsSize.size();i++){
                    size1*=dimsSize[dimsSize.size()-1-i];
                }
            }
            size = size1;
            
        }

    }
};

class Method{
    public:
    string name;
    string ret_type;    
    vector<Variable*> parameters ; 
    vector<string> modifiers;
    int lineNo;
    bool ifConstructor = false;
    bool inherited;

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
    bool inherited;
    Class(string myname, vector<string> mymodifiers, int mylineNo){
        name = myname;
        modifiers = mymodifiers;
        lineNo = mylineNo;
        // scope_count = scope_count;
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
    int offset = 0;

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
    int get_offset(Variable* var){
        return var->offset;
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

    void print_table_CSV(){
        std::ofstream myfile;
        string fileName="output/"+scope+".csv";
        myfile.open (fileName);
        myfile<<"Token,Symbol,Type,isArray,dims,LineNo,Size,offset\n";
        for(auto i:vars){myfile<<"Variable,"<<i->name<<","<<i->type<<","<<i->isArray<<","<<i->dims<<","<<i->lineNo<<","<<i->size<<","<<i->offset<<"\n";
        if(i->dimsSize.size()!=0)for(auto jj:i->dimsSize)cout<<jj<<" ";}
        for(auto i:methods){myfile<<"Function,"<<i->name<<","<<i->ret_type<<",0,0,"<<i->lineNo<<"\n";}
        for(auto i:classes){myfile<<"Class,"<<i->name<<","<<""<<",0,0,"<<i->lineNo<<"\n";}
        myfile.close();
    }
};

class GlobalSymbolTable {
    public:

    string current_scope;
    SymbolTable* current_symbol_table;
    int scope_count=0;
    bool isForScope;

    map<int,SymbolTable*> tablemap; // scope-number maped
    map<string,SymbolTable*> linkmap; // scope
    map<string,int>sameTypeMap;

    GlobalSymbolTable(){

        current_scope="Yayyy";
        SymbolTable* initial = new SymbolTable(NULL, current_scope, scope_count++);
        tablemap[scope_count-1]=initial;
        linkmap[current_scope]= initial;
        current_symbol_table = initial;
        initialiseMap();
    }

    void initialiseMap(){
        typeToSize["int"]=4;
        typeToSize["float"]=4;
        typeToSize["double"]=8;
        typeToSize["char"]=2;
        typeToSize["long"]=8;
        typeToSize["byte"]=1;
        typeToSize["short"]=2;
    }

    // lookups
    Variable* lookup_var(string s, int pp, string scope){

        SymbolTable* curr = linkmap[scope];

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

    string lookup_var_get_scope(string s, int pp, string scope){

        SymbolTable* curr = linkmap[scope];

        while(curr->parent!=NULL){
            for(int i=0; i<curr->vars.size();i++){
                if(curr->vars[i]->name==s)return curr->scope;
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

        SymbolTable* curr = linkmap[scope];

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

        SymbolTable* curr = linkmap[scope];

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

    string get_current_class(){
        SymbolTable* curr = current_symbol_table;
        while(curr->isClass==false){
            curr=curr->parent;
        }
        return curr->scope;


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
        linkmap[scopee] = newTable;
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
        throwError("Error: Redeclaration of symbol :"+symbol,yylineno);
        return false;
        
    }

    void insert(Variable* var){
        if(insertCheck(var->name)){
           current_symbol_table->insert_variable(var);
        }
        
    }
    void insert(Method* method){
        if(method->ifConstructor==true||insertCheck(method->name)){
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
            tablemap[i]->print_table_CSV();
        }
    }

    bool finalCheck(string symbol){
        int flag=0;
        for(auto x:lookup_var(symbol,0,current_scope)->modifiers){
            if(x=="final"){
                flag=1; 
            }
        }
        if(flag==1){
            cout<<"  harshit    "<<lookup_var(symbol,0,current_scope)->value<<yylineno;
            if(lookup_var(symbol,0,current_scope)->value!=""){
                cout<<"    harshitxyz    ";
                throwError("Error: cannot change value of final type :"+symbol,yylineno);
                return false;
            }
        }
        return true;
    }
    bool typeCheckHelperLiteral(string s1,string s2){
        map<string,vector<string>> check_map;
        vector<string> byte_conversion{"byte","short","int","long","float","double"};
        vector<string>short_conversion{"short","int","long","float","double"};
        vector<string>int_conversion{"int","long","float","double","short","byte"};
        vector<string>long_conversion{"long","float","double"};
        vector<string>float_conversion{"float","double"};
        vector<string>double_conversion{"double","float"};
        check_map["byte"]=byte_conversion;
        check_map["short"]=short_conversion;
        check_map["int"]=int_conversion;
        check_map["long"]=long_conversion;
        check_map["float"]=float_conversion;
        check_map["double"]=double_conversion;
        int flag=0;
        for(auto x:check_map[s1]){
            if(x==s2) flag++;
        }
        if(flag==0) return true;
        else return false;
    }

    bool typeCheckHelper(string s1,string s2){
        map<string,vector<string>> check_map;
        vector<string> byte_conversion{"short","byte","int","long","float","double"};
        vector<string>short_conversion{"int","short","long","float","double"};
        vector<string>int_conversion{"long","int","float","double"};
        vector<string>long_conversion{"float","long","double"};
        vector<string>float_conversion{"float","double"};
        check_map["byte"]=byte_conversion;
        check_map["short"]=short_conversion;
        check_map["int"]=int_conversion;
        check_map["long"]=long_conversion;
        check_map["float"]=float_conversion;
        int flag=0;
        for(auto x:check_map[s1]){
            if(x==s2) flag++;
        }
        if(flag==0) return true;
        else return false;
    }
    bool typeCheckVar(string s1, string s2, int myLineno){

        Variable* v1 = lookup_var(s1,1,current_scope);
        Variable* v2 = lookup_var(s2,1,current_scope);
        // if(v1->type == "int"&& v2->type == "long")return true;
        if(v1->type!=v2->type){
            if(typeCheckHelper(v2->type,v1->type)) throwError("Type mismatch: "+v1->type+" cannot be converted to "+v2->type,myLineno);
            else cout<<"     hello a     "<<endl;
        }
        return true;   
    }
    bool typeCheckVar(Variable* v1, Variable* v2,int myLineno){
        // if(v1->type == "int"&& v2->type == "long")return true;
        if(v1->type!=v2->type){
            if(typeCheckHelper(v2->type,v1->type)) throwError("Type mismatch: "+v1->type+" cannot be converted to "+v2->type,myLineno);
            else cout<<"     hello b     "<<endl;
        }
        return true;   
    }
    bool typeCheckVar(Variable* v1, string myType,int myLineno){
        // if(v1->type == "int"&& myType == "long")return true;
        if(v1->type!=myType){
            if(typeCheckHelperLiteral(v1->type,myType)) throwError("Type mismatch: "+v1->type+" cannot be converted to "+myType,myLineno);
            else cout<<"     hello c     "<<endl;
        }
        return true;   
    }

};