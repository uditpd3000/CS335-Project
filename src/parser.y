%{  
#include <bits/stdc++.h>
#include "nodes.cpp"
using namespace std;

extern int yyparse();
extern map<string, string> mymap;
extern map<string,int> typeToSize;
extern void insertMap(string, string );
int yylex (void);
int yyerror (char const *);
extern int yylineno;

extern void set_input_file(const char* filename);
extern void set_output_file(const char* filename);
extern void close_output_file();

map<string,int> typeToSize;

GlobalSymbolTable* global_sym_table = new GlobalSymbolTable(); 
IR* mycode =new IR();
X86* target=new X86();

int num=0;
int indd=0;
int methstart=0,classstart=0, consstart=0;
bool gotReturn=false;
bool madeConstr;
vector<string> arrayRowMajor;
string someThing;

string sourceFile;
ofstream fout;
ofstream vout;

ofstream tacout,sout;
void set_tac_file(const char* filename){
  tacout.open(filename);
}

void set_x86_file(const char* filename){
  sout.open(filename);
}

void generatetree(Node* n){
  int ptr=num;
    num++;


    if(n->objects.size()){

        for(auto x : n->objects){

            fout<<n->label<<ptr<<"->";
            
            if(x->lexeme!="") vout<<"generating tree for the "<< x->lexeme <<" lexeme"<<endl;

            generatetree(x);
           
        }

        fout<<n->label<<ptr;
        fout<<"[label=\"";
        n->print();
        fout<<"\"];"<<endl;
        // cout<<"ye1\n";
        
    }
    else{
      fout<<n->label<<ptr<<";\n";

      fout<<n->label<<ptr;
          fout<<"[label=\"";
          n->print();
          fout<<"\"];"<<endl;
    }

}

void generate_graph(Node *n){

  
  vout.open("verbose.txt");

  vout<<"started generating the graph.dot file.\n"<<endl;

  fout<<"digraph G {\n";
  generatetree(n);
  fout <<"\n}";

  vout<<"\n Generation of the graph.dot file completed."<<endl;

  vout.close();
  fout.close();
}

void throwError(string s, int lineno){
  cout<<"\nSemantic Error: "<<s<<" at lineno: "<<lineno<<endl;
  exit(1);
}

int getTemporarySize(string name){
    // to empty temprories
    int siz = 0;
    for(auto t : mycode->blocks[name]->codes){

        if(t->isBlock) siz+=getTemporarySize(t->result);
        else if(t->result[0]=='t'){
            siz+=t->resSize;
            // cout<<"--------"<<t->result<<endl;
        }
    }
    return siz;
}

/* {} 0 or more
[] 0 or 1*/

%}

%union{
  char* sym;
  Node* node;
}
 
%token<sym> curly_open curly_close class_access STATIC FINAL key_SEAL key_abstract key_STRICTFP field_modifier method_modifier
%token<sym> box_open box_close dot dots less_than greater_than comma ques_mark bitwise_and at colon OR brac_open brac_close bitwise_xor bitwise_or assign semi_colon
%token<sym> class_just_class literal_type AssignmentOperator1 keyword throws var
%token<sym> Identifier extends super implements permits IMPORT DOT_STAR
%token<sym> ARITHMETIC_OP_ADDITIVE ARITHMETIC_OP_MULTIPLY LOGICAL_OP Equality_OP INCR_DECR VOID THIS AND EQUALNOTEQUAL SHIFT_OP INSTANCE_OF RELATIONAL_OP1 NEW THROW RETURN CONTINUE FOR IF ELSE WHILE BREAK PRINTLN
%token<sym>   FloatingPoint BinaryInteger OctalInteger HexInteger DecimalInteger NullLiteral CharacterLiteral TextBlock StringLiteral BooleanLiteral

%type<node> input
%type<node> ClassDeclaration ClassBody ClassPermits InterfaceTypeList ClassType ClassBodyDeclaration
%type<node> ClassDecTillPermits ClassDecTillImplements ClassImplements ClassDecTillExtends ClassDecTillTypeParameters ClassExtends
%type<node> StaticInitializer 
%type<node> ClassMemberDeclaration MethodAndFieldStart FieldDeclaration
%type<node> TypeArguments TypeArgumentList TypeArgument TypeName TypeParameters TypeParameterList TypeParameter TypeBound
%type<node> WildcardBounds ReferenceType ArrayType Dims PrimitiveType AdditionalBound
%type<node> UnannType ClassTypeWithArgs literal
%type<node> Block BlockStatements BlockStatement LocalVariableDeclaration LocalVariableType LocalClassOrInterfaceDeclaration InstanceInitializer
%type<node> VariableDeclarator VariableDeclaratorList VariableInitializer Modifiers CompilationUnit VariableInitializerList ArrayInitializer DimExpr DimExprs ArrayCreationExpression ArrayCreationExpressionAfterType newclasstype newprimtype WhileStatement EnhancedForStatementNoShortIf
%type<node> StatementExpressionList ForInit ForUpdate BasicForStatement BasicForStatementNoShortIf BasicForStatementStart StatementExpression EnhancedForStatement ForStatement ForStatementNoShortIf WhileStatementNoShortIf LabeledStatementNoShortIf StatementNoShortIf IfThenElseStatement IfThenElseStatementNoShortIf IfThenStatement ExpressionStatement LabeledStatement
%type<node> StatementWithoutTrailingSubstatement ThrowStatement ReturnStatement ContinueStatement BreakStatement Statement
%type<node> ConstructorBody ConstructorBodyEnd ConstructorDeclaration ConstructorDeclarationEnd ConstructorDeclarator ConstructorDeclaratorStart ExplicitConstructorInvocation ConstructorDeclaratorEnd
%type<node> Throws ExceptionTypeList ExplicitConsInvTillTypeArgs ArgumentList ReceiverParameter FormalParameter FormalParameterList VariableDeclaratorId VariableArityParameter
%type<node> MethodDeclaration MethodDeclarationEnd MethodDeclarator MethodDeclaratorEnd MethodDeclaratorTillFP MethodDeclaratorTillRP MethodHeader MethodHeaderStart
%type<node> Assignment LeftHandSide AssignmentOperator AssignmentExpression ConditionalExpression Expression ConditionalOrExpression
%type<node> UnaryExpression PreIncrDecrExpression UnaryExpressionNotPlusMinus Primary PrimaryNoNewArray PostfixExpression CastExpression
%type<node> PostIncrDecrExpression ClassLiteral FieldAccess ArrayAccess MethodInvocation ClassInstanceCreationExpression RELATIONAL_OP
%type<node> squarebox MethodIncovationStart UnqualifiedClassInstanceCreationExpression
%type<node> ClassOrInterfaceTypeToInstantiate UnqualifiedClassInstanceCreationExpressionAfter_bracopen TypeArgumentsOrDiamond ClassOrInterfaceType2
%type<node> ImportDeclaration SingleTypeImportDeclaration SingleStaticImportDeclaration StaticImportOnDemandDeclaration ImportDeclarations
%type<node> ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression ShiftExpression AdditiveExpression MultiplicativeExpression 

%type<sym> CommonModifier forr

%left OR
%left AND
%left bitwise_or bitwise_xor
%left bitwise_and
%left EQUALNOTEQUAL
%nonassoc RELATIONAL_OP1 greater_than less_than INSTANCE_OF
%left SHIFT_OP
%left ARITHMETIC_OP_ADDITIVE 
%left ARITHMETIC_OP_MULTIPLY
%right LOGICAL_OP
%right AssignmentOperator1 assign
%nonassoc INCR_DECR
%left dot
%left super
%nonassoc NEW
%right RETURN
%right ques_mark colon

%left class_access field_modifier method_modifier
%left Identifier
%left brac_close box_close curly_close
%left brac_open box_open semi_colon curly_open
%left class_just_class literal_type extends implements permits

%define parse.error verbose


%%

input: 
CompilationUnit {
generate_graph($$);
global_sym_table->printAll();
}
;

CompilationUnit: {$$= new Node("CompilationUnit");}
| CompilationUnit ClassDeclaration  { 
    $$=$1; 
    $$->add($2);

    for(auto x : $2->cls->modifiers){
      if(x=="static") throwError("Modifier \"static\" not allowed for non-nested classes",$2->cls->lineNo);
    } 
  
  }
| CompilationUnit ImportDeclarations ClassDeclaration  {
    $$=$1;vector<Node*>v{$2,$3};
    $$->add(v);
    for(auto x : $3->cls->modifiers){
      if(x=="static") throwError("Modifier \"static\" not allowed for non-nested classes",$3->cls->lineNo);
    }
  }
;

ClassDeclaration:
  Modifiers class_just_class Identifier {

    Class *classs = new Class($3,$1->var->modifiers,yylineno);
    classs->offset = global_sym_table->current_symbol_table->offset;
    global_sym_table->insert(classs);
    global_sym_table->makeTable($3);
    global_sym_table->current_symbol_table->isClass=true;
    // mycode->makeBlock(mycode->quadruple.size(),$3);

    madeConstr=false;
   
  } 
  ClassDecTillTypeParameters {
    $$= new Node("ClassDeclaration"); 
    $$->add($1->objects); 
    string t1=$2,t2=$3; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v); 
    $$->add($5->objects);
    classstart= mycode->makeBlock(classstart,$3);
    global_sym_table->end_scope();
    mycode->updateConstructor($3);


    $$->cls = new Class($3,$1->var->modifiers,$1->var->lineNo);
     
  }
| class_just_class Identifier {
    vector<string> mod;
    Class* classs =  new Class($2,mod,yylineno);
    classs->offset = global_sym_table->current_symbol_table->offset;
    global_sym_table->insert(classs);
    global_sym_table->makeTable($2);
    global_sym_table->current_symbol_table->isClass=true;
    // mycode->makeBlock(mycode->quadruple.size(),$2);
    madeConstr=false;
  } 
  ClassDecTillTypeParameters {
    $$= new Node("ClassDeclaration"); 
    string t1=$1,t2=$2; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v); 
    $$->add($4->objects);
    classstart=mycode->makeBlock(classstart,$2);
    global_sym_table->end_scope();
    mycode->updateConstructor($2);

    $$->cls = new Class($2,vector<string>{},yylineno);

  }
;

ClassDecTillTypeParameters:
  TypeParameters ClassDecTillExtends {$$=$1; $$->add($2->objects);}
| ClassDecTillExtends {$$=$1;}
;

ClassDecTillExtends:
 ClassExtends ClassDecTillImplements {$$=$1; $$->add($2->objects);}
| ClassDecTillImplements {$$=$1;}
;

ClassDecTillImplements:
  ClassImplements ClassDecTillPermits {$$=$1; $$->add($2->objects);}
| ClassDecTillPermits {$$=$1;}
;

ClassDecTillPermits:
  permits ClassPermits ClassBody {string t1=$1; $$ = new Node();  vector<Node*>v{new Node(mymap[t1],t1),$2,$3}; $$->add(v);}
| ClassBody {$$ = new Node(); $$->add($1);}
;

ClassBody:
  curly_open ClassBodyDeclaration curly_close {
    string t1=$1,t2=$3; $$ =new Node("ClassBody"); 
    vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)}; 
    $$->add(v);
    }
| curly_open curly_close {string t1=$1,t2=$2; $$ =new Node("ClassBody");vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); }
;

ClassBodyDeclaration:
  ClassMemberDeclaration {$$=new Node("ClassBodyDeclaration"); $$->add($1); }
| InstanceInitializer {$$=new Node("ClassBodyDeclaration"); $$->add($1); }
| StaticInitializer {$$=new Node("ClassBodyDeclaration"); $$->add($1);  }
| ConstructorDeclaration {$$=new Node("ClassBodyDeclaration");$$->add($1); }
| ClassBodyDeclaration ClassMemberDeclaration {$$=$1; $$->add($2); }
| ClassBodyDeclaration InstanceInitializer {$$=$1; $$->add($2); }
| ClassBodyDeclaration StaticInitializer {$$=$1; $$->add($2); }
| ClassBodyDeclaration ConstructorDeclaration {$$=$1; $$->add($2); }
;

ConstructorDeclaration:
  class_access ConstructorDeclarator {
    vector<string> mod;
    mod.push_back($1);
    Method* method = new Method($2->method->name,"",$2->method->parameters,mod,yylineno);
    if(!madeConstr){
      method->ifConstructor = true;
      madeConstr=true;
    }
    global_sym_table->insert(method);
    global_sym_table->makeTable("cons_"+ $2->method->name);
    // mycode->makeBlock(mycode->quadruple.size(),$2->method->name+".Constr");
    TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tBeginConstr";
    global_sym_table->current_symbol_table->isMethodOrConst=true;
    myIns->arg2 = $2->method->name;
    consstart = mycode->insert(myIns);

    vector<pair<string,int>>params;
    for(auto i:method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;

        params.push_back(make_pair(i->name,typeToSize[i->type]));
    }

    reverse(params.begin(),params.end());
    int tp = mycode->insertAss("popparam","","","");    
    someThing = mycode -> getVar(tp);
    mycode->insertFunctnCall($2->method->name,params,1,true);

  } 
  ConstructorDeclarationEnd {
    $$=new Node("ConstructorDeclaration"); 
    string t=$1; 
    vector<Node*>v{new Node(mymap[t],t),$2}; $$->add(v); 
    $$->add($4->objects);
    global_sym_table->end_scope(); 
    TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tEndConstr";
    myIns->arg2 = $2->method->name;
    mycode->insert(myIns);
    mycode->makeBlock(consstart,$2->method->name+".Constr");
  }
| ConstructorDeclarator {

    Method* method = new Method($1->method->name,"",$1->method->parameters,{},yylineno);
    if(!madeConstr){
      method->ifConstructor = true;
      madeConstr=true;
    }
    global_sym_table->insert(method);
    global_sym_table->makeTable("cons_"+ $1->method->name);
    // mycode->makeBlock(mycode->quadruple.size(),$1->method->name+".Constr");
    TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tBeginConstr";
    global_sym_table->current_symbol_table->isMethodOrConst=true;
    myIns->arg2 = $1->method->name;
    consstart = mycode->insert(myIns);
    int tp = mycode->insertAss("popparam","","","");
    
    someThing = mycode -> getVar(tp);

    vector<pair<string,int>>params;
    for(auto i:method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;

        params.push_back(make_pair(i->name,typeToSize[i->type]));
    }

    reverse(params.begin(),params.end());
    mycode->insertFunctnCall($1->method->name,params,1,true);
  } 
  ConstructorDeclarationEnd {
    $$=new Node("ConstructorDeclaration"); 
    vector<Node*>v{$1}; $$->add(v); 
    $$->add($3->objects);
    global_sym_table->end_scope(); 
    TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tEndConstr";
    myIns->arg2 = $1->method->name;
    mycode->insert(myIns);
    mycode->makeBlock(consstart,$1->method->name+".Constr");
    
  }
;

ConstructorDeclarationEnd:
  Throws ConstructorBody {$$=new Node(); vector<Node*>v{$1,$2}; $$->add(v);}
| ConstructorBody {$$=new Node(); $$->add($1);}
;

ConstructorBody:
  curly_open ExplicitConstructorInvocation ConstructorBodyEnd {$$=new Node("ConstructorBody"); string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2); $$->add($3->objects); }
| curly_open ConstructorBodyEnd {$$=new Node("ConstructorBody");string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2->objects);}
;

ConstructorBodyEnd:
  BlockStatements curly_close {$$= new Node(); string t1=$2; vector<Node*>v{$1,new Node(mymap[t1],t1)}; $$->add(v); }
| curly_close {$$= new Node(); string t1=$1; $$->add(new Node(mymap[t1],t1));}
;

/* ExplicitConstructorInvocation:
| TypeArguments this brac_open ArgumentList brac_close semi_colon
| TypeArguments super brac_open ArgumentList brac_close semi_colon
| ExpressionName dot TypeArguments super brac_open ArgumentList brac_close semi_colon
| Primary dot TypeArguments super brac_open ArgumentList brac_close semi_colon
; */

ExplicitConstructorInvocation:
  TypeArguments ExplicitConsInvTillTypeArgs {$$= new Node("ExplicitConstructorInvocation"); $$->add($1); $$->add($2);}
| ExplicitConsInvTillTypeArgs {$$= $1;}
| TypeName dot TypeArguments super brac_open ArgumentList brac_close semi_colon {$$= new Node("ExplicitConstructorInvocation"); string t1=$2,t2=$4,t3=$5,t4=$7,t5=$8; vector<Node*>v{$1,new Node(mymap[t1],t1),$3,new Node(mymap[t2],t2),new Node(mymap[t3],t3),$6,new Node(mymap[t4],t4),new Node(mymap[t5],t5)}; $$->add(v);}
| Primary dot TypeArguments super brac_open ArgumentList brac_close semi_colon {$$= new Node("ExplicitConstructorInvocation"); string t1=$2,t2=$4,t3=$5,t4=$7,t5=$8; vector<Node*>v{$1,new Node(mymap[t1],t1),$3,new Node(mymap[t2],t2),new Node(mymap[t3],t3),$6,new Node(mymap[t4],t4),new Node(mymap[t5],t5)}; $$->add(v);}
;

ExplicitConsInvTillTypeArgs:
  THIS brac_open ArgumentList brac_close semi_colon {$$ = new Node("ExplicitConstructorInvocation"); string t1=$1,t2=$2,t3=$4,t4=$5; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3,new Node(mymap[t3],t3),new Node(mymap[t4],t4)}; $$->add(v);}
| super brac_open ArgumentList brac_close semi_colon {$$ = new Node("ExplicitConstructorInvocation"); string t1=$1,t2=$2,t3=$4,t4=$5; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3,new Node(mymap[t3],t3),new Node(mymap[t4],t4)}; $$->add(v);}
;

ArgumentList:
  Expression                      {
    $$=new Node("Arglist");
    vector<Node*>v{$1};
    $$->add(v);
    $1->var->type = $1->type;
    $$->variables.push_back($1->var);

    $$->index = $1->index; $$->start = $1->start;
    int t=-1;
    if($1->result[0]=='*'){
      t= mycode->insertAss($1->result,"","","");
      cout<<"wohooo";

    }
    if($1->var->isArray){
        if(t==-1)$$->resList.push_back(make_pair($1->result,8));
        else $$->resList.push_back(make_pair(mycode->getVar(t),8));
    }
    else{
        if(t==-1)$$->resList.push_back(make_pair($1->result,typeToSize[$1->type]));
        else $$->resList.push_back(make_pair(mycode->getVar(t),typeToSize[$1->type]));
      // $$->resList.push_back(make_pair(mycode->getVar(t),typeToSize[$1->type]));
    }
  }
| ArgumentList comma Expression   {
    $$=new Node("Arglist");
    string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};
    $$->add(v);
    $$->variables=$1->variables;
    $3->var->type = $3->type;
    $$->variables.push_back($3->var);

    $$->index = $3->index; $$->start = $1->start;
    $1->resList.push_back(make_pair($3->result,typeToSize[$3->type]));
    $$->resList = $1->resList;
    }
;

ConstructorDeclarator:
  ConstructorDeclaratorStart ConstructorDeclaratorEnd {
    $$ = new Node("ConstructorDeclarator"); 
    $$->add($1->objects); 
    $$->add($2->objects); 
    $$->method = $2->method;
    $$->method->name = $1->method->name;
    }
;

ConstructorDeclaratorStart:
  TypeParameters Identifier brac_open {
    $$ = new Node(); 
    string t1=$2,t2=$3; 
    vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v); 
    $$->method = new Method($2,"",{},{},yylineno);
    }
| Identifier brac_open {
    $$ = new Node(); 
    string t1=$1,t2=$2; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v); 
    $$->method = new Method($1,"",{},{},yylineno);
  }
;

ConstructorDeclaratorEnd:
  ReceiverParameter FormalParameterList brac_close {
    $$ = new Node(); 
    string t1=$3; 
    vector<Node*>v{$1,$2,new Node(mymap[t1],t1)}; 
    $$->add(v);
    $$->method = $2->method;
    }
| FormalParameterList brac_close {
    $$ = new Node(); 
    string t1=$2; 
    vector<Node*>v{$1,new Node(mymap[t1],t1)}; 
    $$->add(v);
    $$->method = $1->method;
  }
| ReceiverParameter brac_close {$$ = new Node(); string t1=$2; vector<Node*>v{$1,new Node(mymap[t1],t1)}; $$->add(v); }
| brac_close {
    $$ = new Node(); 
    string t1=$1; 
    vector<Node*>v{new Node(mymap[t1],t1)}; 
    $$->add(v); 
    $$->method = new Method("","",{},{},yylineno);
  }
;

StaticInitializer:
  STATIC {
    global_sym_table->makeTable();
    }
  Block {
    string t1=$1;
    $$ =new Node("StaticInitializer");
    vector<Node*>v{new Node("Keyword",t1),$3};
    $$->add(v); 
    SymbolTable* parentTable = global_sym_table->current_symbol_table;

    while(parentTable->isMethod==false && parentTable->parent!=NULL){
      parentTable = parentTable->parent;
    }
    
    for(auto it: global_sym_table->current_symbol_table->vars){
      it->offset = parentTable->offset;
      parentTable->offset += it->size;
      it->otherScope = true;
      parentTable->insert_variable(it);
    }
    if(global_sym_table->isForScope==false)global_sym_table->end_scope();
    }
;

InstanceInitializer:
 {global_sym_table->makeTable();}
 Block {
  $$ = $2;
  SymbolTable* parentTable = global_sym_table->current_symbol_table;

    while(parentTable->isMethod==false && parentTable->parent!=NULL){
      parentTable = parentTable->parent;
    }
    
    for(auto it: global_sym_table->current_symbol_table->vars){
      it->offset = parentTable->offset;
      it->otherScope = true;
      parentTable->offset += it->size;
      parentTable->insert_variable(it);
    }
  global_sym_table->end_scope();
  }
;

Block:
  curly_open BlockStatements curly_close {
    $$=new Node("Block");
     string t1=$1,t2=$3;
      vector<Node*>v{(new Node(mymap[t1],t1)),$2,(new Node(mymap[t2],t2))};
       $$->add(v); 
      //  $$->index = (mycode->makeBlock($2->start));
       $$->result = mycode->getVar($2->index);
       $$->start = $2->start;
       $$->index=$2->index;

       }
| curly_open curly_close {
  $$=new Node("Block");
  string t1=$1,t2=$2;
  vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; 
  $$->add(v);

  $$->index = mycode->makeBlock();
  $$->result = mycode->getVar($$->index);
  $$->start = $$->index;
  }
;

BlockStatements:
  BlockStatement {
    $$=new Node("BlockStatements"); 
    $$->add($1);

    $$->index = $1->index;
    $$->start = $1->start;
    }
| BlockStatements BlockStatement {
  $$=$1; 
  $$->add($2);

  $$->index = $2->index;
  $$->start = $1->start;
  }
;


BlockStatement:
  // Assignment semi_colon {string t1=$2;$$=new Node("BlockStatement"); vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v); }
 LocalClassOrInterfaceDeclaration {
  $$ = new Node("LocalClassOrInterfaceDeclaration"); 
  $$->add($1);
  $$->result =$1->result;
  $$->index = $1->index;
  $$->start = $1->start;
  }
| LocalVariableDeclaration semi_colon {
  $$ =$1; string t1=$2;
   $$->add(new Node(mymap[t1],t1));
   $$->result =$1->result;
  $$->index = $1->index; 
  $$->start = $1->start; 
   
  }
| Statement { 
  $$=new Node("BlockStatement"); 
  $$->add($1);
  $$->result =$1->result;
  $$->start = $1->start;
  $$->index = $1->index;
  }
;

LocalVariableType:
  UnannType {$$=$1;}
| var {
    string t1= $1; 
    $$=new Node(mymap[t1],t1); 
    // $$->var = new Variable($1,$1,yylineno,{});
    $$->type="var";
    }
;

LocalClassOrInterfaceDeclaration:
  ClassDeclaration {$$=$1;}
;

ClassMemberDeclaration:
  FieldDeclaration {$$=$1; }
| MethodDeclaration {$$=$1; }
| ClassDeclaration {$$=$1; }
| semi_colon {string t1=$1; $$= new Node(mymap[t1],t1);}
;

MethodAndFieldStart:
Modifiers UnannType {
  $$=new Node(); 
  $$->add($1); 
  $$->add($2);
  $$->method = new Method("",$2->type,{},$1->var->modifiers,yylineno);
  $$->anyName = $2->anyName;
  }
| UnannType {$$=new Node(); 
  $$->add($1); 
  $$->method = new Method("",$1->type,{},{},yylineno);
  $$->anyName = $1->anyName;
  }
;

MethodDeclaration:
  MethodAndFieldStart MethodDeclarator {
    Method* _method = new Method($2->method->name,$1->method->ret_type,$2->method->parameters,$1->method->modifiers,yylineno);
    _method->offset = global_sym_table->current_symbol_table->offset;
    global_sym_table->current_symbol_table->offset+=4;
    global_sym_table->insert(_method);
    global_sym_table->makeTable(global_sym_table->current_scope +"_"+ $2->method->name);
    
    // mycode->makeBlock(mycode->quadruple.size(),$2->method->name);

    gotReturn=false;
    TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tBeginFunc";
    myIns->arg2 = "";
    methstart = mycode->insert(myIns);
    int tp = mycode->insertAss("popparam","","","");
    someThing = mycode->getVar(tp);
    vector<pair<string,int>>params;

    global_sym_table->current_symbol_table->isMethod=true;
    global_sym_table->current_symbol_table->isMethodOrConst=true;
    for(auto i:_method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;

        params.push_back(make_pair(i->name,typeToSize[i->type]));
    }

    reverse(params.begin(),params.end());
    mycode->insertFunctnCall($2->method->name,params,1);
    
  }
  MethodDeclarationEnd {
    $$=new Node("MethodDeclaration"); 
    $$->add($1->objects); 
    $$->add($2->objects); 
    $$->add($4->objects); 
    global_sym_table->end_scope();

    if(!gotReturn){
      mycode->InsertTwoWordInstr("\tpop","basePointer");
      mycode->InsertTwoWordInstr("\treturn","");

      if($1->method->ret_type!="void") throwError("missing return statement for non-void type method",yylineno);
    }
    TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tEndFunc";
    myIns->arg2 = $2->method->name;
    mycode->insert(myIns); 
    mycode->makeBlock(methstart,$2->method->name);
      gotReturn=false;
      
    }
    

| Modifiers MethodHeader {
    Method* _method = new Method($2->method->name,$2->method->ret_type,$2->method->parameters,$1->var->modifiers,yylineno);
    _method->offset = global_sym_table->current_symbol_table->offset;
    global_sym_table->current_symbol_table->offset+=4;
    global_sym_table->insert(_method);
    global_sym_table->makeTable(global_sym_table->current_scope +"_"+ $2->method->name);
    // mycode->makeBlock(mycode->quadruple.size(),$2->method->name);

    gotReturn=false;
    TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tBeginFunc";
    myIns->arg2 = $2->method->name;
    methstart= mycode->insert(myIns);
    int tp = mycode->insertAss("popparam","","","");
    someThing = mycode->getVar(tp);
    global_sym_table->current_symbol_table->isMethod=true;
    global_sym_table->current_symbol_table->isMethodOrConst=true;

    vector<pair<string,int>>params;
    for(auto i:_method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;

        params.push_back(make_pair(i->name,typeToSize[i->type]));
    }

    reverse(params.begin(),params.end());
    mycode->insertFunctnCall($2->method->name,params,1);
  }
  MethodDeclarationEnd {
    $$=new Node("MethodDeclaration"); 
    $$->add($1->objects); 
    $$->add($2);
     $$->add($4->objects);
     global_sym_table->end_scope();
    
     if(!gotReturn){
      mycode->InsertTwoWordInstr("\tpop","basePointer");
      mycode->InsertTwoWordInstr("\treturn","");

      if($2->method->ret_type!="void") throwError("missing return statement for non-void type method",yylineno);
    }

     TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tEndFunc";
    myIns->arg2 = $2->method->name;
    mycode->insert(myIns); 
    mycode->makeBlock(methstart,$2->method->name);
    gotReturn=false;
     }

| MethodHeader{
    Method* _method = new Method($1->method->name,$1->method->ret_type,$1->method->parameters,{},yylineno);
    _method->offset = global_sym_table->current_symbol_table->offset;
    global_sym_table->current_symbol_table->offset+=4;
    global_sym_table->insert(_method);
    global_sym_table->makeTable(global_sym_table->current_scope +"_"+ $1->method->name);
    // mycode->makeBlock(mycode->quadruple.size(),$1->method->name);

    gotReturn=false;
    TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tBeginFunc";
    myIns->arg2 = $1->method->name;
    methstart=mycode->insert(myIns);
    int tp = mycode->insertAss("popparam","","","");
    someThing = mycode->getVar(tp);
    global_sym_table->current_symbol_table->isMethod=true;
    global_sym_table->current_symbol_table->isMethodOrConst=true;

     vector<pair<string,int>>params;
    for(auto i:_method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;

        params.push_back(make_pair(i->name,typeToSize[i->type]));
    }

    reverse(params.begin(),params.end());
    mycode->insertFunctnCall($1->method->name,params,1);
  } 
  MethodDeclarationEnd {
    $$=new Node("MethodDeclaration"); 
    $$->add($1); 
    $$->add($3->objects); 
    global_sym_table->end_scope();

    if(!gotReturn){
      mycode->InsertTwoWordInstr("\tpop","basePointer");
      mycode->InsertTwoWordInstr("\treturn","");

      if($1->method->ret_type!="void") throwError("missing return statement for non-void type method",yylineno);
    }
    TwoWordInstr* myIns = new TwoWordInstr();
    myIns->arg1="\tEndFunc";
    myIns->arg2 = $1->method->name;

    mycode->insert(myIns); 

    mycode->makeBlock(methstart,$1->method->name);
    gotReturn=false;
    
    }
;

MethodDeclarationEnd:
  Block {$$=$1;}
| semi_colon {string t1=$1; $$=new Node(mymap[t1],t1); }
;


MethodHeader:
  TypeParameters MethodHeaderStart {
    $$= new Node("MethodHeader"); 
    $$->add($1); 
    $$->add($2->objects);
    $$->method = $2->method;
    }
| MethodHeaderStart {
    $$= new Node("MethodHeader"); 
    $$->add($1->objects); 
    $$->method = $1->method;
    }
;

MethodHeaderStart:
 VOID MethodDeclarator {
  string t1=$1; 
  $$=new Node(); 
  $$->add(new Node(mymap[t1],t1)); 
  $$->add($2->objects);
  $$->method = $2->method;
  $$->method->ret_type = $1;
  }
| VOID MethodDeclarator Throws {
  string t1=$1; 
  $$=new Node(); 
  $$->add(new Node(mymap[t1],t1)); 
  $$->add($2->objects); 
  $$->add($3); 
  $$->method = $2->method;
  $$->method->ret_type = $1;
  }
;

Throws:
  throws ExceptionTypeList semi_colon {$$=new Node("Throws"); string t1=$1,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),}; $$->add(v); }
;

ExceptionTypeList:
  ClassType {$$= new Node("ExceptionTypeList"); $$->add($1);}
| ExceptionTypeList comma ClassType {$$=$1; string t1=$2; $$->add(new Node(mymap[t1],t1)); $$->add($3);}
;

MethodDeclarator:
  Identifier brac_open MethodDeclaratorTillRP {
    string t1=$1,t2=$2; 
    $$=new Node(); 
    $$->add(new Node(mymap[t1],t1)); 
    $$->add(new Node(mymap[t2],t2)); 
    $$->add($3->objects);
    $$->method = $3->method;
    $$->method->name = $1;
    
    }
;

MethodDeclaratorTillRP:
  UnannType ReceiverParameter MethodDeclaratorTillFP {
    $$=new Node(); 
    $$->add($1); $$->add($2); 
    $$->add($3->objects);
    $$->method=$3->method;
    $$->type = $1->type;
    $$->dims = $1->dims;
    }
| MethodDeclaratorTillFP {
    $$=new Node(); 
    $$->add($1->objects);
    $$->method = $1->method;
  }
;

MethodDeclaratorTillFP:
  FormalParameterList MethodDeclaratorEnd {
    $$=new Node(); 
    $$->add($1); 
    $$->add($2->objects);
    $$->method = $1->method;
    }
| MethodDeclaratorEnd {
  $$=new Node(); 
  $$->add($1->objects);
  $$->method = new Method("","",{},{},yylineno);
  }
;

MethodDeclaratorEnd:
  brac_close {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1));}
| brac_close Dims {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2);}
;

FormalParameterList:
  FormalParameter {
    $$= new Node("FormalParameterList"); 
    $$->add($1);
    vector<Variable*> varss;
    varss.push_back($1->var);
    $$->method = new Method("","",varss,{},yylineno);
    }
| FormalParameterList comma FormalParameter {
    $$=$1; 
    string t1=$2; 
    $$->add(new Node(mymap[t1],t1)); 
    $$->add($3);
    $$->method=$1->method;
    $$->method->parameters.push_back($3->var);
    }
;

FormalParameter:
  FINAL UnannType VariableDeclaratorId {
  $$= new Node("FormalParameter"); 
  string t1=$1; vector<Node*>v{(new Node(mymap[t1],t1)),$2,$3}; 
  $$->add(v);
  $$->var=$3->var;
  $$->var->isParameter = true;
  $$->var->type=$2->type;
  if(typeToSize.find($$->var->type)!=typeToSize.end())$$->var->size = typeToSize[$$->var->type];
  if($2->dims==0){
    $$->var->isArray=false;
  }
  else{
    $$->var->isArray=true;
    $$->var->dims=$2->dims;
  }
  $$->var->modifiers.push_back($1);
  }

| UnannType VariableDeclaratorId {
    $$= new Node("FormalParameter"); 
    vector<Node*>v{$1,$2}; 
    $$->add(v);
    $$->var= $2->var;
    $$->var->isParameter = true;
    $$->var->type = $1->type;
    if(typeToSize.find($$->var->type)!=typeToSize.end()){
      if(!$$->var->isArray) $$->var->size = typeToSize[$$->var->type];
      else $$->var->size=8;
    }
    if($1->dims==0 && $2->dims==0){
    $$->var->isArray=false;
    }
    else{
    $$->var->isArray=true;
    $$->var->dims=$1->dims+$2->dims;
    }
  }
| VariableArityParameter {$$= $1;}
;


VariableDeclaratorId:
  Identifier Dims {
    $$= new Node("VariableDeclaratorId"); 
    string t1=$1; 
    vector<Node*>v{(new Node(mymap[t1],t1)),$2}; 
    $$->add(v);
    $$->var = new Variable($1,"",{},yylineno,true,$2->var->dims,{},"");
    $$->dims = $2->var->dims;

    }
| Identifier {
    $$= new Node("VariableDeclaratorId"); 
    string t1=$1; 
    vector<Node*>v{(new Node(mymap[t1],t1))}; 
    $$->add(v);
    $$->var = new Variable($1,"",yylineno,{},"");
    $$->var->value = $1; //fixme
  }
;

VariableArityParameter:
 dots Identifier {
  $$= new Node("VariableArityParameter"); 
  string t1=$1,t2=$2; vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; 
  $$->add(v);
  }
;

ReceiverParameter:
  THIS comma {$$ = new Node("ReceiverParameter"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); }
| Identifier dot THIS comma  {$$ = new Node("ReceiverParameter"); string t1=$1,t2=$2,t3=$3,t4=$4; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),new Node(mymap[t4],t4)}; $$->add(v);}
;

FieldDeclaration:
  MethodAndFieldStart VariableDeclaratorList semi_colon {
    string t1=$3; 
    $$=new Node("FieldDeclaration"); 
    $$->add($1->objects); 
    vector<Node*>v{$2,new Node(mymap[t1],t1)}; 
    $$->add(v);
    for(auto i:$2->variables){

      if(i->isArray){
        if(i->type!=""){
          global_sym_table->typeCheckVar(i,$1->method->ret_type,yylineno);
        }
        
        Variable* varr = new Variable(i->name,$1->method->ret_type,$1->method->modifiers,yylineno,true,i->dims,i->dimsSize,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        varr->objName = i->objName;
        varr->isField = true;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
        
        
      }
      else{
        if(i->classs_name!=""){
          if(i->classs_name!=$1->anyName){
            throwError("Type error: Cannot convert from "+i->classs_name+" to "+$1->anyName,yylineno);
          }
        }
        if(i->type!=""){
          global_sym_table->typeCheckVar(i,$1->method->ret_type,yylineno);
        }
        Variable* varr = new Variable(i->name,$1->method->ret_type,yylineno,$1->method->modifiers,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        varr->objName = i->objName;
        varr->isField = true;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
      }

    }

    bool isStatic=false;
    for(auto x : $1->method->modifiers){
      if(x=="static"){
        isStatic=true;
      }
    }

    if(isStatic){
      // cout<<$2->start<<"=="<<mycode->quadruple.size()<<endl;
      // cout<<mycode->quadruple[0]->print()<<endl;
      for(int i=$2->start;i<mycode->quadruple.size();i++){
        mycode->globals.push_back(mycode->quadruple[i]);
      }
      mycode->quadruple.erase(mycode->quadruple.begin() + $2->start, mycode->quadruple.end());
    }
    
  }
;


CommonModifier:
  class_access
| STATIC
| FINAL
| method_modifier
| field_modifier
| key_abstract
| key_STRICTFP
;

Modifiers:
CommonModifier {
  string t1=$1; $$ = new Node("Modifiers"); $$->add(new Node(mymap[t1],t1));
  vector<string> mod;
  mod.push_back($1);
  $$->var = new Variable($1,"",yylineno,mod,"");
  }
| Modifiers CommonModifier {
  $$=new Node("Modifiers"); 
  $$->add($1->objects); 
  string t1=$2; 
  $$->add(new Node(mymap[t1],t1));
  $$->var = $1->var;
  $$->var->modifiers.push_back($2);
  }
;

VariableDeclaratorList:
  VariableDeclarator {
    $$= new Node("VariableDeclaratorList"); 
    $$->add($1); 
    $$->variables.push_back($1->var);
    $$->start=$1->start;
    $$->index=$1->index;
    }
| VariableDeclaratorList comma VariableDeclarator { 
    $$=$1; 
    string t1=$2; 
    vector<Node*>v{new Node(mymap[t1],t1),$3}; 
    $$->add(v); 
    $$->variables.push_back($3->var);

    $$->start=$1->start;
    $$->index=$3->index;
    }
;

UnannType:
  PrimitiveType {
    $$ = new Node("UnannType"); 
    $$->add($1); 
    $$->type=$1->lexeme; 
    }
| ReferenceType {
    $$ = new Node("UnannType"); 
    $$->add($1); 
    $$->type = $1->type;
    $$->dims = $1->dims;
    $$->anyName = $1->anyName;
    }
;

VariableDeclarator:
  Identifier {
    $$ = new Node("VariableDeclarator"); 
    string t1=$1; 
    vector<Node*>v{new Node(mymap[t1],t1)}; 
    $$->add(v);
    $$->var = new Variable($1,"",yylineno,{},"");

    $$->index = mycode->insertAss("0","","",$1);
    $$->result = $1;
    $$->start=$$->index;
    }
| Identifier Dims {
    $$ = new Node("VariableDeclarator"); 
    string t1=$1; 
    vector<Node*>v{new Node(mymap[t1],t1),$2}; 
    $$->add(v);
    $$->var = new Variable($1,"",{},yylineno,true,$2->var->dims,$2->var->dimsSize,"");
    $$->dims = $2->dims;

    $$->start=mycode->quadruple.size()-1;
    $$->index=$$->start;
  }
| Identifier assign VariableInitializer {
    $$ = new Node("VariableDeclarator"); 
    string t1=$1,t2=$2; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3}; 
    $$->add(v);                                                        //Change change
    if($3->dims!=0){
      throwError("TypeError: Cannot convert "+to_string($3->dims)+" dimensional Array to "+$3->type+"\n",yylineno );
    }

    $$->var = new Variable($1,$3->type,yylineno,{},$3->var->value);
    $$->var->objName = $3->objOffset;
    // cout<<$3->objOffset<<endl;
    if($3->isObj){$$->var->classs_name = $3->anyName;}
    $$->dims=$3->dims;

    $$->index = mycode->insertAss($3->result,"","",$1);
    $$->result = $1;
    global_sym_table->staticCheck($3->var->isField,$3->staticOk,global_sym_table->current_scope,yylineno);

    $$->start=$3->start;
    // $$->objOffset = $3->objOffset;

  }
| Identifier Dims assign VariableInitializer {                        // Change change
    $$ = new Node("VariableDeclarator"); 
    string t1=$1,t2=$3; 
    if(arrayRowMajor.size()>0){
        
        int allocmem =typeToSize[$4->type];
        // int a1 = mycode->insertAss(to_string(allocmem),"","","");
        for(auto i:$4->var->dimsSize){
          allocmem*=i;
        }
        int ind = mycode->insertAss(to_string(allocmem),"","","");
        string z = mycode->getVar(ind);
        mycode->InsertTwoWordInstr("\tparam",z);
        // mycode->InsertTwoWordInstr("\tallocmem","1");
        string zz = mycode->getVar(mycode->insertAss("allocmem","",z,""));
        $4->result = zz;
        mycode->insertArray(zz,arrayRowMajor,typeToSize[$4->type]);
        arrayRowMajor.clear();
        // global_sym_table->staticCheck($3->var->isField,$3->staticOk,global_sym_table->current_scope,yylineno);
    }
    vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4}; 
    $$->add(v);
    if($2->var->dims!=$4->dims){
      throwError("TypeError: Cannot convert "+to_string($4->dims)+" dimensional Array to "+to_string($2->var->dims)+" dimesions",yylineno );
    }
    $$->var = new Variable($1,$4->type,{},yylineno,true,$2->var->dims,$4->var->dimsSize,$4->var->value);
    $$->dims=$4->dims;
    $$->start=$4->start;
    $$->index = mycode->insertAss($4->result,"","",$1);
    $$->result = $1;
    global_sym_table->staticCheck($4->var->isField,$4->staticOk,global_sym_table->current_scope,yylineno);
    }
;

VariableInitializer:
  Expression {$$ = new Node("VariableInitializer"); $$->add($1);
    $$->type =$1->type;
    $$->var=$1->var;
    $$->method=$1->method;
    $$->cls=$1->cls; 
    $$->isObj = $1->isObj;
    $$->anyName = $1->anyName;
    $$->dims = $1->dims;
    $$->result = $1->result;
    $$->objOffset = $1->objOffset;
    $$->start=$1->start;
    $$->index=$1->index;
    $$->staticOk=$1->staticOk;
    $$->finalOk = $1->finalOk;
  } // $$->add($1);
| ArrayInitializer {
    // $$ = new Node();
    $$ = $1;
    reverse($$->var->dimsSize.begin(),$$->var->dimsSize.end());
    $$->dims++;

    } // 
; 

TypeParameters:
  less_than TypeParameterList greater_than {$$=new Node("TypeParameters"); string t1=$1,t2=$3; $$->add(new Node(mymap[t1],t1)); $$->add($2->objects); $$->add(new Node(mymap[t2],t2));}
;

ClassExtends:
  extends ClassType {
    $$ = new Node(); 
    string t1=$1; 
    $$->add(new Node(mymap[t1],t1)); 
    $$->add($2);
    Class* cls = $2->cls;
    SymbolTable* base = global_sym_table->linkmap[cls->name];
    for(auto var: base->vars){
      var->inherited = true;
      global_sym_table->insert(var);
    }
    for(auto met: base->methods){
      met->inherited = true;
      global_sym_table->insert(met);
    }
    for(auto clss: base->classes){
      clss->inherited = true;
      clss->offset = global_sym_table->current_symbol_table->offset;
      global_sym_table->insert(clss);
    }

    }
;

ClassImplements:
 implements InterfaceTypeList {$$ = new Node(); string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2);}
;

ClassPermits:
  ClassPermits comma TypeName {$$=$1; string t2=$3->lexeme; $$->lexeme=$$->lexeme+","+t2;}
|  TypeName {$$=$1;}
;

TypeParameterList:
  TypeParameterList comma TypeParameter {$$=$1; string t2=$2; $$->add(new Node(mymap[t2],t2)); $$->add($3); }
| TypeParameter {$$= new Node("TypeParameterList"); $$->add($1);}
;


InterfaceTypeList:
 ClassType {$$=new Node("InterfaceTypeList"); $$->add($1->objects); }
| InterfaceTypeList comma ClassType { $$=$1; $$->add(new Node("seperator",$2)); $$->add($3->objects); }
;

TypeParameter:
 Identifier TypeBound {string t1=$1; $$=new Node("TypeParameter"); $$->add(new Node(mymap[t1],t1)); $$->add($2->objects);}
| Identifier {string t1=$1; $$=new Node("TypeParameter"); $$->add(new Node(mymap[t1],t1));}
;

TypeBound:
  extends ClassType {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2); }
| extends ClassType AdditionalBound {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2); $$->add($3->objects);}
;

AdditionalBound:
  AdditionalBound bitwise_and ClassType {string t1=$2; $$=$1; $$->add(new Node(mymap[t1],t1)); $$->add($3);}
| bitwise_and ClassType {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2);}
;

/* fixme */
ClassType:
TypeName {$$=$1;}
| ClassTypeWithArgs {
  $$=new Node("ClassType");
   $$->add($1->objects); 
   $$->var=new Variable("",$1->var->type,yylineno,{},"");
   }
| ClassTypeWithArgs dot Identifier {
  $$=new Node("ClassType"); 
  $$->add($1->objects); 
  string t1=$2,t2=$3; 
  vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); 
  $$->var=new Variable("",$1->var->type,yylineno,{},"");
  }
| ClassTypeWithArgs dot Identifier TypeArguments {
  $$=new Node("ClassType"); 
  $$->add($1->objects); 
  string t1=$2,t2=$3; 
  vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$4}; 
  $$->add(v); 
  $$->var=new Variable("",$1->var->type,yylineno,{},"");
  }
;

ClassTypeWithArgs:
  TypeName TypeArguments {$$=new Node(); $$->add($1);  $$->add($2); $$->var=new Variable("",$1->var->type,yylineno,{},"");}
;

TypeArguments:
  less_than TypeArgumentList greater_than {$$=new Node("TypeArguments"); string t1=$1,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)}; $$->add(v); }
;

TypeArgumentList:
 TypeArgumentList comma TypeArgument {$$=$1; string t1=$2; vector<Node*>v{new Node(mymap[t1],t1),$3}; $$->add(v); }
| TypeArgument {$$= new Node("TypeArgumentList"); $$->add($1);}
;

TypeArgument:
  ReferenceType {$$ = $1;}
| ques_mark {string t1=$1; $$ = new Node(mymap[t1],t1);}
| ques_mark WildcardBounds {string t1=$1; vector<Node*>v{new Node(mymap[t1],t1),$2}; $$ = new Node("TypeArgument"); $$->add(v); }
;

WildcardBounds:
  extends ReferenceType {$$ = new Node("WildcardBounds"); string t1=$1; $$->add(new Node(mymap[t1],$1)); $$->add($2->objects); }
| super ReferenceType {$$ = new Node("WildcardBounds"); string t1=$1; $$->add(new Node(mymap[t1],$1)); $$->add($2->objects); }
;

ReferenceType:
  ClassType {$$=$1;}
| ArrayType {$$=$1;}
;

ArrayType:
  PrimitiveType Dims   {
    $$=new Node("ArrayType"); 
    $$->add($1); 
    $$->add($2->objects);   
    $$->var = $2->var;
    $$->var->type = $1->lexeme;
    $$->type = $1->lexeme;
    $$->dims = $2->var->dims;
    }
| ClassType Dims       {
    $$=new Node("ArrayType"); 
    $$->add($1->objects); 
    $$->add($2->objects);
    $$->var = new Variable($1->cls->name,$1->type,yylineno,{},"");
    $$->var->isArray= true;
    $$->var->dims = $2->var->dims;
    $$->var->dimsSize = $2->var->dimsSize;  
    $$->type = $1->type;
    $$->dims = $2->var->dims;

    }
;

Dims:
  box_open box_close          {
    $$=new Node("Dims"); 
    string t1=$1,t2=$2; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v);
    $$->var= new Variable("","",{},yylineno,true,1,{},"");
    }
| Dims box_open box_close    {
    $$=$1; 
    string t1=$2,t2=$3; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v);
    $$->var->dims++;
    }
;

PrimitiveType:
  literal_type {string t1=$1; $$= new Node(mymap[t1],t1);}
;

Expression: 
  {indd = mycode->quadruple.size();} AssignmentExpression {$$=$2; if(indd<$2->start || $2->start<=0 || $2->start>$2->index)$$->start = indd;$$->index=mycode->quadruple.size()-1; $$->lineno=yylineno;$$->var->type = $$->type;}
;

AssignmentExpression: 
Assignment                {$$=$1;  }
| ConditionalExpression   {$$=$1; if($$->var!=NULL&& $$->var->type!=""){$$->type=$1->var->type;}global_sym_table->staticCheck($1->var->isField,$1->staticOk,global_sym_table->current_scope,yylineno); }
;

Assignment:
  LeftHandSide AssignmentOperator Expression  {
    $$=new Node("Assignment");
    vector<Node*>v{$1,$2,$3};
    $$->add(v);

    if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }
    // cout<<"1415\n";
    if($1->type!=$3->type){
      if(!global_sym_table->typeCheckHelper($3->type, $1->type)){
        int p = mycode->insertAss("",$3->result,"cast_to_"+$1->type);
        $3->result = mycode->getVar(p);
      }
      else {
        throwError("cannot convert from "+ $3->type + " to " + $1->type ,yylineno);
      }
    }
    // cout<<"1425\n";
    $$->type=$1->type;
    $$->var = $3->var;
    string x = "";
    x+=($2->lexeme)[0];
    if($2->lexeme=="=")$$->index = mycode->insertAss($3->result,"","",$1->result);
    else $$->index = mycode->insertAss($1->result,$3->result,x+$1->type,$1->result);
    if($1->start) $$->start = $1->start;
    else $$->start = $3->start;
    $$->result = $1->result;
    // cout<<"1435\n";
    // cout<<"dukh\n"; mycode->print(); exit(1);
    global_sym_table->finalCheck($1->var->name,$1->finalOk,global_sym_table->current_scope,yylineno);
    global_sym_table->staticCheck($1->var->isField,$1->staticOk,global_sym_table->current_scope,yylineno);
    global_sym_table->staticCheck($3->var->isField,$3->staticOk,global_sym_table->current_scope,yylineno);
    // cout<<"1440"<<endl;

    // cout<<mycode->getVar($$->start)<<"==========="<<mycode->getVar($$->index)<<endl;

    }
;

/* fixme */
LeftHandSide:
FieldAccess      {$$=$1;}
| TypeName       {$$=$1;}
| ArrayAccess    { $$=$1;}
;

FieldAccess:
Primary dot Identifier              {
  $$=new Node("FieldAccess");
  string t1=$2,t2=$3;
  vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};
  $$->add(v);
  if($1->type=="Class"){
    
    // $$->type = $1->var->type;
    // cout<<$1->anyName<<endl;
    $$->var=global_sym_table->lookup_var($3,1,1,$1->anyName);
    // $$->type = $$->var->type;
    bool isStatic=false;
    for(auto f:$$->var->modifiers){
      if(f=="static") isStatic=true;
    }
    int t3 = mycode->insertGetFromSymTable($1->anyName,$$->var->name,"",$$->var->offset);
    // int t4 = mycode->insertPointerAssignment($1->result,mycode->getVar(t3),"");
    // $$->index = mycode->insertPointerAssignment(mycode->getVar(t3),"0","");
    if(!isStatic){
      $$->result = "*("+mycode->getVar(t3)+")";
      // cout<<$1->lexeme<<endl;
      if($1->lexeme == "this")$$->result = "*("+someThing+"+"+mycode->getVar(t3)+")";
      // someThing = "";
    }
    else{
      $$->result = mycode->getVar(t3);
    }
    $$->dims = $$->var->dims;
    $$->type = $$->var->type;
  }

  }
| super dot Identifier              {$$=new Node("FieldAccess");string t1=$1,t2=$2,t3=$3;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| TypeName dot super dot Identifier {$$=new Node("FieldAccess");string t1=$2,t2=$3,t3=$4,t4=$5;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),new Node(mymap[t4],t4)};$$->add(v);}
;

/* fixmme */
Primary:
PrimaryNoNewArray                   {$$=$1;}
| ArrayCreationExpression           {$$=$1;}
;

/* fixmme */
PrimaryNoNewArray:
  literal                           {$$=$1;$$->result = $1->var->value;$$->index = -1;}
| ClassLiteral                      {$$=$1;}
| THIS                              {
  // cout<<"999\n";
    string t1=$1; 
    $$= new Node(mymap[t1],t1);
    SymbolTable* temp;
    temp=global_sym_table->current_symbol_table;
    while(temp->parent->scope!="Global"){
      temp=temp->parent;
    }
    t1= temp->scope;
    $$->cls= global_sym_table->lookup_class(t1,0,global_sym_table->current_scope);
    $$->type="Class";
    $$->anyName = $$->cls->name;
    $$->which_scope=$$->cls->name;
    

    // exit(1);
    
  }
| TypeName dot THIS                 {$$=new Node("PrimaryNoNewArray");string t1=$2,t2=$3;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);}
| brac_open Expression brac_close   {
    $$=new Node("PrimaryNoNewArray");
    string t1=$1,t2=$3;
    vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)};
    $$->add(v);
    $$->type = $2->type;
    $$->cls = $2->cls;
    $$->var = $2->var;
    $$->method = $2->method;
    $$->result = $2->result;
    $$->start = $2->start;
    $$->index = $2->index;
    $$->staticOk = $2->staticOk;
    $$->finalOk = $2->finalOk;
    }
| FieldAccess                       {$$=$1;} 
| ArrayAccess                       {$$=$1;} 
| MethodInvocation                  {$$=$1;$$->var=new Variable("",$1->type,yylineno,{},"");} 
| ClassInstanceCreationExpression   {$$=$1;$$->var=new Variable("","",yylineno,{},"");} 
;

literal:
  FloatingPoint {
    string t1=$1; 
    $$= new Node(mymap[t1],t1); 
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="float";
    $$->type="float";
    }
| BinaryInteger {
    string t1=$1; 
    $$= new Node(mymap[t1],t1);
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="int";
    $$->type="int";
    }
| OctalInteger {string t1=$1; 
    $$= new Node(mymap[t1],t1); 
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="int";
    $$->type="int";
    }
| HexInteger {
    string t1=$1; 
    $$= new Node(mymap[t1],t1); 
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="int";
    $$->type="int";
    }
| DecimalInteger {
    string t1=$1; 
    $$= new Node(mymap[t1],t1);
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="int";
    $$->type="int";
    }
| NullLiteral {
    string t1=$1; 
    $$= new Node(mymap[t1],t1);
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="NULL";
    $$->type="NULL";
    }
| CharacterLiteral {
    string t1=$1; 
    $$= new Node(mymap[t1],t1); 
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="char";
    $$->type="char";
    }
| TextBlock {
    string t1=$1; 
    $$= new Node(mymap[t1],t1);
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="String";
    $$->type="String";
    }
| StringLiteral {
    string t1=$1; 
    $$= new Node(mymap[t1],t1); 
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="String";
    $$->type="String";
    }
| BooleanLiteral {
    string t1=$1; 
    $$= new Node(mymap[t1],t1); 
    $$->var = new Variable($1,$1,yylineno,{},$1);
    $$->var->type="boolean";
    $$->type="boolean";
    }
;

TypeName:
  Identifier {
    string t1=$1; 
    $$=new Node("TypeName"); 
    $$->add(new Node("Identifier",t1));
    Class* cls = global_sym_table->lookup_class($1,0,global_sym_table->current_scope);
    Method* met = global_sym_table->lookup_method($1,0,global_sym_table->current_scope);
    Variable *var = global_sym_table->lookup_var($1,0,1,global_sym_table->current_scope);
    $$->result = $1;
    $$->objectName = $1;
    // Class* cls = global_sym_table->lookup_class($1,1,global_sym_table->current_scope);
    if(cls!=NULL){
      if(cls->inherited==true){
        for(auto mod: cls->modifiers){
          if(mod=="private"){
            throwError("Class "+ t1 +" is of private access",yylineno);
          }
        }
      }
      $$->cls = cls;
      $$->type = "Class";
      if(cls->name=="String"){
        $$->type="String";
      }
      $$->anyName = $$->cls->name;
    }
    else if(met !=NULL){
      if(met->inherited==true){
        for(auto mod: met->modifiers){
          if(mod=="private"){
            throwError("Method "+ t1 +" is of private access",yylineno);
          }
        }
      }
      $$->method = met;
      $$->type = met->ret_type;
      $$->anyName=$$->method->name;
    }
    else if(var!=NULL){
      if(var->inherited==true){
        for(auto mod: var->modifiers){
          if(mod=="private"){
            throwError("Variable "+ t1 +" is of private access",yylineno);
          }
        }
      }
      if(var->objName!=""){
        $$->objOffset = var->objName;
      }
      for(auto mod: var->modifiers)if(mod=="static")$$->staticOk = true;
      $$->var = var;
      $$->type = var->type;
      $$->anyName = var->classs_name;
      $$->dims = var->dims;
      if($$->type!="Class"){
        
        $$->anyName=$$->var->name;
      }
      if(var->isField){
        SymbolTable* curr = global_sym_table->current_symbol_table;
        while(curr->parent!=NULL && curr->isClass==false)curr=curr->parent;
        int t3 = mycode->insertGetFromSymTable(curr->scope,t1,"",var->offset);
        if(!$$->staticOk)  $$->result = "*("+someThing+"+"+mycode->getVar(t3)+")";
        else $$->result = mycode->getVar(t3);
        // $$->result = "xxx";
    }
      
    }
    else {
      throwError("Variable "+t1 + " not declared in appropriate scope",yylineno);
    }

    
    $$->index = mycode->quadruple.size();
    
    // exit(1);
    }
| TypeName dot Identifier {
    $$=$1; 
    string t1=$2,t2=$3; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v);
    Class* cls = global_sym_table->lookup_class($3,0,$1->anyName);
    Method* met = global_sym_table->lookup_method($3,0,$1->anyName);
    Variable *var = global_sym_table->lookup_var($3,0,1,$1->anyName);
    string cur_class = global_sym_table->get_current_class();
    $$->result = $3;
    $$->staticOk = true;
    $$->index = mycode->quadruple.size();
    if(cls!=NULL){
      if(cls->inherited==true){
        for(auto mod: cls->modifiers){
          if(mod=="private"){
            throwError("Class "+ t2 +" is of private access",yylineno);
          }
        }
      }
      $$->cls = cls;
      $$->type = "Class";
      $$->anyName = cls->name;

    }
    else if(met !=NULL){
      if(cur_class!=$1->anyName){
        for(auto mod: met->modifiers){
          if(mod=="static"){
            throwError("Cannot make a non-static reference to the static method" + t2 +" of static ",yylineno);
          }
        }
      }
      if(met->inherited==true||cur_class!=$1->anyName){
        for(auto mod: met->modifiers){
          if(mod=="private"){
            throwError("Method "+ t2 +" is of private access",yylineno);
          }
        }
      }
      $$->method = met;
      $$->type = met->ret_type;
    }
    else if(var!=NULL){
      if(var->inherited==true || cur_class!=$1->anyName){
        for(auto mod: var->modifiers){
          if(mod=="private"){
            throwError("Variable "+ t2 +" is of private access",yylineno);
          }
        }
      }
      $$->var = var;
      $$->type = var->type;
      $$->dims = var->dims;
      int t3 = mycode->insertGetFromSymTable($1->anyName,var->name,"", var->offset);
      int flag=0;
      for(auto x : $1->var->modifiers) {
        if(x=="static") flag=1;
      }
      if(!flag){
          $$->result = "*("+$1->objectName+"+"+mycode->getVar(t3)+")";
      }
      else {
        $$->index = mycode->insertPointerAssignment(mycode->getVar(t3),"","");
        $$->result = mycode->getVar($$->index);
      }
    }
    else {
      throwError("Variable "+t2+" not declared in appropriate scope",yylineno);
    } 
    $$->staticOk = true;
    $$->finalOk = true;
    $$->diffClass = $1->anyName;
  }
;

ArrayAccess:
  Identifier box_open Expression box_close{
    $$=new Node("ArrayAcc");
    string t1=$1,t2=$2,t4=$4;
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3,new Node(mymap[t4],t4)};
    $$->add(v);
    $$->start=$3->start;
    Variable* v1 = global_sym_table->lookup_var($1,1,1,global_sym_table->current_scope);
    if(v1->inherited==true){
        for(auto mod: v1->modifiers){
          if(mod=="private"){
            throwError("Variable "+ t1 +" is of private access",yylineno);
          }
        }
      }
    $$->which_scope = global_sym_table->lookup_var_get_scope($1,1,global_sym_table->current_scope);
    if(v1->isArray==false){
      throwError(t1+"is not of type Array",yylineno);
    }
    if($3->type!="int"){
      throwError("Array index cannot be of type "+$3->type,yylineno);
    }
    $$->var= v1;
    int ss = $$->var->dimsSize.size();
    // cout<<ss<<"ghghgh"<<endl;
    if(ss || v1->isParameter){
      int ll=1;
      int zz = v1->dims-1; 
      // cout<<zz<<"hghgh"<<endl;
      if(zz<0){
      throwError("Dimension mismatch for "+t1,yylineno);
    }
    while(zz>0){ll*=$$->var->dimsSize[zz];zz--;}
      $$->index = mycode->insertAss($3->result,to_string(ll),"*int","");
      if(v1->dims==1){
        string t1 = mycode->getVar($$->index);
        int t4 = mycode->insertAss(t1,to_string(typeToSize[v1->type]),"*int","");
        int t3 = mycode->insertGetFromSymTable($$->which_scope,v1->name,"",v1->offset);
        int t5 = mycode->insertAss("getAddress","",mycode->getVar(t3),"");
        $$->index=t5;
        // $$->index = mycode->insertPointerAssignment(mycode->getVar(t3),mycode->getVar(t4),"");
        $$->result = "*("+mycode->getVar(t5)+"+"+mycode->getVar(t4)+")";
      }
      
    }
    else {
      throwError("Array "+t1+" may not be initialised",yylineno);
    }
    $$->dims=v1->dims-1;
    $$->type = v1->type;
    $$->finalOk = true;
  }
| TypeName dot Identifier box_open Expression box_close  {
    $$=new Node("ArrayAcc");
    string t2=$2,t3=$3,t4=$4,t6=$6;
    vector<Node*>v{$1,new Node(mymap[t2],t2),new Node(mymap[t3],t3),new Node(mymap[t4],t4),$5,new Node(mymap[t6],t6)};
    $$->add(v);
    // exit(1);
    $$->objOffset=$1->objOffset;

    Variable* v1 = global_sym_table->lookup_var($3,1,1,$1->anyName);
    if(v1->inherited==true){
        for(auto mod: v1->modifiers){
          if(mod=="private"){
            throwError("Variable "+ t3 +" is of private access",yylineno);
          }
        }
      }
    if(v1->isArray==false){
      throwError(t3+" is not of type Array",yylineno);
    }
    if($5->type!="int"){
      throwError("Array index cannot be of type "+$5->type,yylineno);
    }
    $$->var= v1;
    int ss = $$->var->dimsSize.size();
    // cout<<ss<<"ghghgh"<<endl;
    if(ss|| v1->isParameter){
      int ll=1;
      int zz = v1->dims-1; 
      // cout<<zz<<"hghgh"<<endl;
      if(zz<0){
      throwError("Dimension mismatch for "+$$->var->name,yylineno);
    }
      while(zz>0){ll*=$$->var->dimsSize[zz];zz--;}
      $$->index = mycode->insertAss($5->result,to_string(ll),"*int","");
      if(v1->dims==1){
        string t1 = mycode->getVar($$->index);
        int t4 = mycode->insertAss(t1,to_string(typeToSize[v1->type]),"*int",t1);
        int t3 = mycode->insertGetFromSymTable($1->anyName,v1->name,"",v1->offset);
        int t5 = mycode->insertPointerAssignment($1->objOffset,mycode->getVar(t3),"");
        int t6 = mycode->insertAss("getAddress","",mycode->getVar(t3),"");
        $$->index=t6;
        // $$->index = mycode->insertPointerAssignment(mycode->getVar(t5),mycode->getVar(t4),"");
        $$->result = "*("+mycode->getVar(t6)+"+"+mycode->getVar(t4)+")";
        // $$->result = mycode->getVar($$->index);
      }
      $$->start=$1->start;
      
    }
    else {
      throwError("Array "+$$->var->name+" may not be initialised",yylineno);
    }
    $$->dims=v1->dims-1;
    $$->type = v1->type;
    $$->which_scope=$1->anyName;
    $$->finalOk = true;
    $$->staticOk = true;

    }
| PrimaryNoNewArray box_open Expression box_close    {
    $$=new Node("ArrayAcc");
    string t1=$2,t2=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),$3,new Node(mymap[t2],t2)};
    $$->add(v);
    $$->var = $1->var;
    $$->cls = $1->cls;
    $$->method = $1->method;
    $$->type= $1->type;
    $$->which_scope=$1->which_scope;
    int ss = $$->var->dimsSize.size();
    if(ss|| $$->var->isParameter){
      int ll=1;
      int zz = ss-1; 
      int loo = $1->dims-1;
      if(loo<0){
      throwError("Dimension mismatch for "+$$->var->name,yylineno);
    }
       while(loo--){ll*=$$->var->dimsSize[zz];zz--;}
      int temp = mycode->insertAss($3->result,to_string(ll),"*int","");
      // int temp = mycode->insertAss($3->result,mycode->getVar(aa),"*int","");
      string t1 = mycode->getVar(temp);
      string t2 = mycode->getVar($1->index);
      $$->index = mycode->insertAss(t1,t2,"+int","");
      if($1->dims==1){
        string t1 = mycode->getVar($$->index);
        int t4 = mycode->insertAss(t1,to_string(typeToSize[$$->type]),"*int",t1);
        int t3 = mycode->insertGetFromSymTable($$->which_scope,$1->var->name,"",$1->var->offset);
        if($1->objOffset!=""){
          int t5 = mycode->insertPointerAssignment($1->objOffset,mycode->getVar(t3),"");
          int t6 = mycode->insertAss("getAddress","",mycode->getVar(t3),"");
          $$->result = "*("+mycode->getVar(t6)+"+"+mycode->getVar(t4)+")";
          $$->index=t6;
          // $$->index = mycode->insertPointerAssignment(mycode->getVar(t5),mycode->getVar(t4),"");
        }
        else {
          int t6 = mycode->insertAss("getAddress","",mycode->getVar(t3),"");
          $$->index=t6;
          
          $$->result = "*("+mycode->getVar(t6)+"+"+mycode->getVar(t4)+")";
        }
        // $$->result = mycode->getVar($$->index);
      }

    }
    if($$->var->isArray==true){
      // cout<<"llllllllllllllllllllllll";
      $$->dims=$1->dims-1;
      
      // cout<<$$->dims<<"----------";
      if($$->dims>$$->var->dims){
        throwError("Expected dimension of "+$$->var->name +" is "+(to_string)($$->var->dims)+" but provided more",yylineno);
      }
    }
    else{
      throwError($1->var->name+" is not of type Array",yylineno);
    }
    if($3->type!="int"){
      throwError("Array index cannot be of type "+$3->type,yylineno);
    }

    $$->start = $1->start;
    $$->finalOk = true;
    $$->staticOk = $3->staticOk;
    // cout<<mycode->getVar($$->start)<<"=========="<<mycode->getVar($$->index)<<endl;

    }

;

squarebox: 
  box_open box_close                                 {$$=new Node("sqbox");string t1=$1,t2=$2;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);}
| squarebox box_open box_close                       {$$=new Node("sqbox");string t1=$2,t2=$3;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);}
;

ClassLiteral: 
  TypeName squarebox dot class_just_class            {
    $$=new Node("Classliteral");string t1=$3,t2=$4;
    vector<Node*>v{$1,$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);
     $$->var = new Variable("","Class",yylineno,{},"");
     }
| TypeName dot class_just_class                      {
    $$=new Node("Classliteral");string t1=$2,t2=$3;
    vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);  
    $$->var = new Variable("","Class",yylineno,{},"");
    }
| literal_type squarebox dot class_just_class        {
    $$=new Node("Classliteral");string t1=$1,t2=$3,t3=$4;
    vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),new Node(mymap[t3],t3)};
    $$->add(v); 
    $$->var = new Variable("","Class",yylineno,{},"");
    }
| literal_type dot class_just_class                  {
    $$=new Node("Classliteral");string t1=$1,t2=$2,t3=$3;
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};
    $$->add(v); 
    $$->var = new Variable("","Class",yylineno,{},"");
    }
| VOID dot class_just_class         {
    $$=new Node("Classliteral");string t1=$1,t2=$2,t3=$3;
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};
    $$->add(v);  
    $$->var = new Variable("","Class",yylineno,{},"");
    }
;


ConditionalExpression:
    ConditionalOrExpression                                               {
          $$=$1;
          // cout<<"yaha"<<$1->var->isField<<" "<<$1->staticOk<<"\n";
          // cout<<"nottt"<<$1->anyName<<endl;
      }
    | ConditionalOrExpression ques_mark Expression colon ConditionalExpression       {
      // $$ = new Node("ConditionalExpression");
      string t1=$2,t2=$4;
      vector<Node*>v{new Node(mymap[t1],t1),$3,new Node(mymap[t2],t2),$5};
      $$->add(v);

      if($3->type!=$5->var->type) throwError("type mismatch",yylineno);
      if($1->type!="boolean") throwError("type mismatch for conditional",yylineno);
      $$->var->type = $3->type;
      $$->type = $3->type;
      // cout<<"2008"<<endl;
      if($3->index+1 < mycode->quadruple.size()){
        if(!mycode->quadruple[$3->index+1]->isBlock || $3->index+1!=mycode->quadruple.size()-1) 
          $5->result = mycode->getVar(mycode->makeBlock($3->index+1));
      }
      if($3->start <= $3->index && $3->index<=mycode->quadruple.size()-1 ){
        if(!mycode->quadruple[$3->start]->isBlock || $3->start!=$3->index)
          $3->result = mycode->getVar(mycode->makeBlock($3->start,"",$3->index+1));
      }
      // if(!mycode->quadruple[$3->index+1]->isBlock || $3->index+1!=mycode->quadruple.size()-1) $5->result = mycode->getVar(mycode->makeBlock($3->index+1));
      // if(!mycode->quadruple[$3->start]->isBlock || $3->start!=$3->index) $3->result = mycode->getVar(mycode->makeBlock($3->start,"",$3->index+1));
      // cout<<"2008"<<endl;
      $$->result=mycode->insertTernary($3->start-1,$1->result,$3->result,$5->result);
      $$->index = mycode->quadruple.size()-1;
      // cout<<"2011"<<endl;

      
      }
    ;

ConditionalOrExpression:
    ConditionalAndExpression                                                         {$$=$1;}
  | ConditionalOrExpression OR ConditionalAndExpression                            {
      string t2=$2;
      $$=new Node("ConditionalExpression");
      vector<Node*>v{$1,new Node(mymap[t2],$2),$3};$$->add(v); 

      $$->lineno=yylineno;
      global_sym_table->typeCheckVar($1->var, $3->var,$$->lineno);
      global_sym_table->typeCheckVar($1->var, "boolean",$$->lineno);
      $$->var=new Variable("","boolean",yylineno,{},"");
      $$->index = mycode->insertAss($1->result,$3->result,$2);
      $$->start = $1->start;
      $$->result = mycode->getVar($$->index);
      if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }
      }
;

ConditionalAndExpression:
    InclusiveOrExpression                                                            {$$=$1;}
    | ConditionalAndExpression AND InclusiveOrExpression                             {
        string t2=$2;$$=new Node("ConditionalExpression");
        vector<Node*>v{$1,new Node(mymap[t2],$2),$3};$$->add(v);
        $$->lineno=yylineno;
        global_sym_table->typeCheckVar($1->var, $3->var,$$->lineno);
        global_sym_table->typeCheckVar($1->var, "boolean",$$->lineno);

        $$->var=new Variable("","boolean",yylineno,{},"");
        $$->index = mycode->insertAss($1->result,$3->result,$2);
        $$->start = $1->start;
        $$->result = mycode->getVar($$->index);
        if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }
        }
    ;

InclusiveOrExpression:
    ExclusiveOrExpression                                                            {$$=$1;}
    | InclusiveOrExpression bitwise_or ExclusiveOrExpression                         {
        string t2=$2;$$=new Node("ConditionalExpression");
        vector<Node*>v{$1,new Node(mymap[t2],$2),$3};$$->add(v);
        $$->lineno=yylineno;
        global_sym_table->typeCheckVar($1->var, $3->var,$$->lineno);
        global_sym_table->typeCheckVar($1->var, "int",$$->lineno);
        $$->var=new Variable("","int",yylineno,{},"");

        $$->index = mycode->insertAss($1->result,$3->result,$2);
        $$->start = $1->start;
        $$->result = mycode->getVar($$->index);
        if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }
        }
    ;

ExclusiveOrExpression:
    AndExpression                                                                    {$$=$1;}
    | ExclusiveOrExpression bitwise_xor AndExpression                                {
        string t2=$2;$$=new Node("ConditionalExpression");
        vector<Node*>v{$1,new Node(mymap[t2],$2),$3};
        $$->add(v);
        $$->lineno=yylineno;
        global_sym_table->typeCheckVar($1->var, $3->var,$$->lineno);
        global_sym_table->typeCheckVar($1->var, "int",$$->lineno);
        $$->var=new Variable("","int",yylineno,{},"");

        $$->index = mycode->insertAss($1->result,$3->result,$2);
        $$->start = $1->start;
        $$->result = mycode->getVar($$->index);
        if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }
        }
    ;

AndExpression:
    EqualityExpression                                                               {$$=$1;}
    | AndExpression bitwise_and EqualityExpression                                   {
        string t2=$2;$$=new Node("ConditionalExpression");
        vector<Node*>v{$1,new Node(mymap[t2],$2),$3};
        $$->add(v);
        $$->lineno=yylineno;
        global_sym_table->typeCheckVar($1->var, $3->var,$$->lineno);
      global_sym_table->typeCheckVar($1->var, "int",$$->lineno);
      $$->var=new Variable("","int",yylineno,{},"");
      
      $$->index = mycode->insertAss($1->result,$3->result,$2);
      $$->start = $1->start;
      $$->result = mycode->getVar($$->index);
      if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }
    }
    ;

EqualityExpression:
    RelationalExpression                                                             {$$=$1;}
    | EqualityExpression EQUALNOTEQUAL RelationalExpression                          {
      string t2=$2;$$=new Node("ConditionalExpression");
      vector<Node*>v{$1,new Node(mymap[t2],$2),$3};
      $$->add(v);
      $$->lineno=yylineno;

      map<string,int>priority;
      priority["int"]=0;
      priority["char"]=1;
      priority["float"]=0;
      priority["String"]=2;

      if(priority.find($1->var->type)!=priority.end() && priority.find($3->var->type)!=priority.end()){
        if(priority[$1->var->type]!=priority[$3->var->type]){
          throwError("bad operands type for equality check: \""+$1->var->type+"\" and \""+$3->var->type,yylineno);
        }
        else {
          $$->var=new Variable("","boolean",yylineno,{},"");
        }
      }
      else if(($1->var->type==$3->var->type) || ($1->var->type=="NULL" || $3->var->type=="NULL")){
        $$->var=new Variable("","boolean",yylineno,{},"");
      }
      else {
        throwError("bad operands type for equality check: \""+$1->var->type+"\" and \""+$3->var->type,yylineno);
      }

      $$->index = mycode->insertAss($1->result,$3->result,$2);
      $$->start = $1->start;
      $$->result = mycode->getVar($$->index);
      if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }

      }
    ;

RelationalExpression:
    ShiftExpression                                                                  {$$=$1;}
    // | InstanceofExpression                                                           {$$=$1;}
    | RelationalExpression RELATIONAL_OP ShiftExpression                             {
      $$=new Node("ConditionalExpression");
      vector<Node*>v{$1,$2,$3};$$->add(v); 
      $$->var=new Variable("","boolean",yylineno,{},"");

      $$->index = mycode->insertAss($1->result,$3->result,$2->lexeme);
      $$->start = $1->start;
      $$->result = mycode->getVar($$->index);

      }
    | RelationalExpression INSTANCE_OF ReferenceType                                 {
      string t2=$2;$$=new Node("ConditionalExpression");
      vector<Node*>v{$1,new Node(mymap[t2],$2),$3};$$->add(v); 
      $$->var=new Variable("","boolean",yylineno,{},"");

      $$->index = mycode->insertAss($1->result,$3->result,$2);
      $$->start = $1->start;
      $$->result = mycode->getVar($$->index);

      }
    // | RelationalExpression INSTANCE_OF LocalVariableDeclaration                                {string t2=$2;$$=new Node("ConditionalExpression");vector<Node*>v{$1,new Node(mymap[t2],$2),$3};$$->add(v);}
    ;

ShiftExpression:
AdditiveExpression SHIFT_OP AdditiveExpression                                   {
      string t2=$2;$$=new Node("ConditionalExpression");
      vector<Node*>v{$1,new Node(mymap[t2],$2),$3};$$->add(v);
      $$->lineno=yylineno;
      global_sym_table->typeCheckVar($1->var, $3->var,$$->lineno);
      global_sym_table->typeCheckVar($1->var, "int",$$->lineno);
      $$->var=new Variable("","int",yylineno,{},"");

      $$->index = mycode->insertAss($1->result,$3->result,$2);
      $$->start = $1->start;
      $$->result = mycode->getVar($$->index);
      }
| AdditiveExpression                                                             {$$=$1;}
;

AdditiveExpression:
    AdditiveExpression ARITHMETIC_OP_ADDITIVE MultiplicativeExpression              {
      string t2=$2;$$=new Node("ConditionalExpression");
      vector<Node*>v{$1,new Node(mymap[t2],$2),$3};$$->add(v);

      $$->lineno=yylineno;

      string myType;
      // if(global_sym_table->lookup_method($1->result,0,global_sym_table->current_scope)!=NULL) $$->type=$1->type;

      if($1->var->type==$3->var->type){
        myType=$1->var->type;
      }
      else if(!global_sym_table->typeCheckHelper($1->var->type, $3->var->type)){
        // 1->3
        int p = mycode->insertAss("",$1->result,"cast_to_"+$3->var->type);
        myType=$3->var->type;
        $1->result = mycode->getVar(p);
      }
      else if(!global_sym_table->typeCheckHelper($3->var->type, $1->var->type)){
        int p = mycode->insertAss("",$3->result,"cast_to_"+$1->var->type);
        myType=$1->var->type;
        $3->result = mycode->getVar(p);
      }
      else {
        throwError("Incompatible operand for additive operator of type " +$1->var->type+" & "+$3->var->type +" on line number",yylineno);
      }

      
      if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }
      // if(myType=="") $$->type=global_sym_table->lookup_method($1->result,0,global_sym_table->current_scope)->ret_type;

      $$->var=new Variable("",myType,yylineno,{},"");
      $$->index = mycode->insertAss($1->result,$3->result,$2+myType);
      $$->start = $1->start;
      $$->result = mycode->getVar($$->index);

    }
    | MultiplicativeExpression                                                       {$$=$1;}
    ;

MultiplicativeExpression:
    UnaryExpression ARITHMETIC_OP_MULTIPLY MultiplicativeExpression                  {
      string t2=$2;$$=new Node("ConditionalExpression");
      vector<Node*>v{$1,new Node(mymap[t2],$2),$3};
      $$->add(v);
      
      $$->lineno=yylineno;

      string myType;
      // if(global_sym_table->lookup_method($1->result,0,global_sym_table->current_scope)) $$->type=$1->method->ret_type;

      if(!global_sym_table->typeCheckHelperLiteral($1->var->type, $3->var->type)){
        // 1->3
        if($1->var->type!=$3->var->type){
          int p = mycode->insertAss("",$1->result,"cast_to_"+$3->var->type);
          $1->result = mycode->getVar(p);
        }
        myType=$3->var->type;
      }
      else if(!global_sym_table->typeCheckHelperLiteral($3->var->type, $1->var->type)){
        if($1->var->type!=$3->var->type){
          int p = mycode->insertAss("",$3->result,"cast_to_"+$1->var->type);
          $3->result = mycode->getVar(p);
        }
        myType=$1->var->type;
      }
      else {
        throwError("Incompatible operand for multiplicative operator of type " +$1->var->type +" & "+$3->var->type + " on line number",yylineno);
      }
      if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }

      $$->var=new Variable("",myType,yylineno,{},"");
      $$->index = mycode->insertAss($1->result,$3->result,$2+myType);
      $$->start = $1->start;
      $$->result = mycode->getVar($$->index);

      }
    | UnaryExpression                                                                {$$=$1;}
    ;

UnaryExpression:
    PreIncrDecrExpression                                                            {$$=$1;}
    | UnaryExpressionNotPlusMinus                                                    {$$=$1;}
    | ARITHMETIC_OP_ADDITIVE UnaryExpression                                         {
        string t1=$1;$$=new Node("ConditionalExpression");
        vector<Node*>v{new Node(mymap[t1],$1),$2}; $$->add(v); 
        $$->var=new Variable("",$2->var->type,yylineno,{},"");

        string x=t1+"1";
        if(global_sym_table->typeCheckHelperLiteral("int", $2->var->type)){
          throwError("Incompatible operator + with operand of type "+ $2->var->type,yylineno);
        }
        else if("int"!=$2->var->type){
          int p = mycode->insertAss("",x,"cast_to_"+$2->var->type);
          x = mycode->getVar(p);
        }

        $$->index = mycode->insertAss(x,$2->result,"*" + $2->var->type);
        $$->start = $2->start;
        $$->result = mycode->getVar($$->index);
    }
    ;

PreIncrDecrExpression:
    INCR_DECR UnaryExpression                                                        {
      string t1=$1;
      string zz = "";
      zz += t1[0];
      $$=new Node("ConditionalExpression");
      vector<Node*>v{new Node(mymap[t1],$1),$2};
      $$->add(v); 
      $$->var=new Variable("",$2->var->type,yylineno,{},"");

      global_sym_table->finalCheck($2->var->name,$2->finalOk,global_sym_table->current_scope,yylineno);
      global_sym_table->staticCheck($2->var->isField,$2->staticOk,global_sym_table->current_scope,yylineno);

      string x="1";
      if(global_sym_table->typeCheckHelperLiteral("int", $2->var->type)){
        throwError("Incompatible operator + with operand of type "+ $2->var->type,yylineno);
      }
      else if("int"!=$2->var->type){
        int p = mycode->insertAss("",x,"cast_to_"+$2->var->type);
        x = mycode->getVar(p);
      }
      

      
      mycode->insertAss($2->result,"1",zz+$2->var->type,$2->result);
      $$->start = $2->index;
      $$->index = $2->index;
      $$->result = mycode->getVar($$->index);
    }
    ;

UnaryExpressionNotPlusMinus:
  PostfixExpression                                                                {$$=$1;}
  | CastExpression                                                                 {$$=$1; }
  | LOGICAL_OP UnaryExpression                                                     {
      string t1=$1;
      $$=new Node("ConditionalExpression");
      vector<Node*>v{new Node(mymap[t1],$1),$2};$$->add(v); 
      $$->var=new Variable("",$2->var->type,yylineno,{},"");

      if(($2->var->type=="boolean" && t1=="!") || ($2->var->type=="int" && t1=="~")){
        $$->index = mycode->insertAss("",$2->result,t1);
        $$->result = mycode->getVar($$->index);
      }
      else throwError("Type mismatch for "+$2->type + " with operand "+t1 ,yylineno);
    }
    ;

PostfixExpression:
  Primary                                   {$$=$1;}
| TypeName                                  {$$=$1;}
| PostIncrDecrExpression                    {$$=$1;}
;

PostIncrDecrExpression:
  PostfixExpression INCR_DECR               {
    $$=new Node("PostIncrDecExp");
    string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v); 
    $$->var=new Variable("",$1->var->type,yylineno,{},"");

    int z = mycode->insertAss($1->result,"","");
    string zz = "";
    zz+=$2[0];
    $$->start = $1->index;

    global_sym_table->finalCheck($1->var->name,$1->finalOk,global_sym_table->current_scope,yylineno);
    global_sym_table->staticCheck($1->var->isField,$1->staticOk,global_sym_table->current_scope,yylineno);
    string x="1";
    if(global_sym_table->typeCheckHelperLiteral("int", $1->var->type)){
      throwError("Incompatible operator + with operand of type "+ $1->var->type,yylineno);
    }
    else if("int"!=$1->var->type){
      int p = mycode->insertAss("",x,"cast_to_"+$1->var->type);
      x = mycode->getVar(p);
    }

    mycode->insertAss($1->result,x,zz+$1->var->type,$1->result);
    $$->result = mycode->getVar(z);
    $$->index=$1->index;
    }
;

RELATIONAL_OP :
RELATIONAL_OP1                   {string t1=$1;$$=(new Node(mymap[t1],t1));}
| greater_than                   {string t1=$1;$$=(new Node(mymap[t1],t1));}
| less_than                      {string t1=$1;$$=(new Node(mymap[t1],t1));}
;

/* fixme */
CastExpression:
  brac_open literal_type brac_close UnaryExpression                               {
    $$=new Node("CastExp");
    string t1=$1,t2=$2,t3=$3;
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),$4};$$->add(v);
    if($4->var->type=="String"){
      throwError("String cannot be converted to "+t2,yylineno);
    }
    $$->var=new Variable("",t2,yylineno,{},$4->var->value);
    }

AssignmentOperator:
assign                {$$=new Node("AssignmentOperator");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1)};$$->add(v);$$->lexeme = "=";}
| AssignmentOperator1 {$$=new Node("AssignmentOperator");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1)};$$->add(v);$$->lexeme = $1;}
;

// InstanceofExpression:
//  RelationalExpression INSTANCE_OF ReferenceType {$$=new Node("InstanceofExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
// | RelationalExpression INSTANCE_OF LocalVariableDeclaration  {$$=new Node("InstanceofExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
// ;

MethodInvocation:
  TypeName brac_open ArgumentList brac_close                                         {
    $$=new Node("MethodInvocation");
    string t2=$2,t3=$4;
    vector<Node*>v{$1,new Node(mymap[t2],t2),$3,new Node(mymap[t3],t3)};
    $$->add(v);
    string mysize;
    Method* method;
    // cout<< $1->anyName<<endl;
    if($1->method->name==""){
      method = global_sym_table->lookup_method($1->method->name,1,global_sym_table->current_scope);
    } 
    else {
      method = $1->method;
    }
    // cout<<"why\n";
    
    if($1->diffClass=="")mysize = global_sym_table->getSize($1->method->name,global_sym_table->current_scope);
    else mysize = global_sym_table->getSize($1->method->name,$1->anyName);

    // cout<<"why\n";
    if(method->parameters.size()!=$3->variables.size()){
      throwError("Error: Expected number of arguments: "+to_string(method->parameters.size())+" Found: "+to_string($3->variables.size()),yylineno);
    }
    int parasize=0;
    for(int i=0;i<method->parameters.size();i++){
      if(method->parameters[i]->type!=$3->variables[i]->type){
        throwError("TypeError: Expected type of argument["+to_string(i+1)+"] : "+method->parameters[i]->type + ", Found: " + $3->variables[i]->type,yylineno);
      }
      parasize+=typeToSize[method->parameters[i]->type];
    }
    mysize = to_string(stoi(mysize)-parasize);
    $$->type= method->ret_type;
    $$->method=method;

    $$->start = $1->start;
    if($$->type!="void"){
      $$->index = mycode->insertFunctnCall($1->objectName+"#"+$1->result,$3->resList,0,false,mysize,false);
    }
    else $$->index = mycode->insertFunctnCall($1->objectName+"#"+$1->result,$3->resList,0,false,mysize);
    
    $$->result = mycode->getVar($$->index-1);
    bool boo = false;
    for (auto it:method->modifiers)if(it=="static")boo=true;
    if($1->diffClass!="")boo=true;
    // cout<<"qwert\n";
    global_sym_table->staticCheck(true,boo,global_sym_table->current_scope, yylineno);

    }
| TypeName brac_open brac_close                                                      {
    $$=new Node("MethodInvocation");
    string t2=$2,t3=$3;
    vector<Node*>v{$1,new Node(mymap[t2],t2),new Node(mymap[t3],t3)};
    $$->add(v);  

    string mysize;
    Method* method;
    if($1->method->name==""){
      method = global_sym_table->lookup_method($1->method->name,1,global_sym_table->current_scope);
    } 
    else {
      method = $1->method;
    }
    // cout<<"why\n";
    if($1->diffClass=="")mysize = global_sym_table->getSize($1->method->name,global_sym_table->current_scope);
    else mysize = global_sym_table->getSize($1->method->name,$1->anyName);
    // cout<<"why\n";
    if(method->parameters.size()!=0){
      cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<0<<endl;
      exit(1);
    }
    $$->type= method->ret_type;
    $$->method=method;

    $$->start = $1->start;
    if($$->type!="void"){
      $$->index = mycode->insertFunctnCall($1->objectName+"#"+$1->result,vector<pair<string,int>>{},0,false,mysize,false);
    }
    else $$->index = mycode->insertFunctnCall($1->objectName+"#"+$1->result,vector<pair<string,int>>{},0,false,mysize);

    $$->result = mycode->getVar($$->index-1);
     bool boo = false;
    for (auto it:method->modifiers)if(it=="static")boo=true;
    if($1->diffClass!="")boo=true;
    // cout<<$1->anyName<<"-";
    global_sym_table->staticCheck(true,boo,global_sym_table->current_scope, yylineno);


    }
| MethodIncovationStart TypeArguments Identifier  brac_open ArgumentList brac_close    {
  $$=new Node("MethodInvocation");
  string t1=$3,t2=$4,t3=$6;$$->add($1->objects); 
  vector<Node*>v{$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2),$5,new Node(mymap[t3],t3)};
  $$->add(v);

    $$->start = $1->start;
    if($$->type!="void"){
      $$->index = mycode->insertFunctnCall($3,$5->resList,0,false,"",false);
    }
    else $$->index = mycode->insertFunctnCall($3,$5->resList);

    $$->result = mycode->getVar($$->index-1);
  }
| MethodIncovationStart TypeArguments Identifier  brac_open brac_close                 {
  $$=new Node("MethodInvocation");
  string t1=$3,t2=$4,t3=$5;$$->add($1->objects); 
  vector<Node*>v{$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};
  $$->add(v);

    $$->start = $1->start;
    if($$->type!="void"){
      $$->index = mycode->insertFunctnCall($3,vector<pair<string,int>>{},0,false,"",false);
    }
    else $$->index = mycode->insertFunctnCall($3,vector<pair<string,int>>{});

    $$->result = mycode->getVar($$->index-1);
  }
| MethodIncovationStart Identifier  brac_open brac_close                               {
    $$=new Node("MethodInvocation");
    string t1=$2,t2=$3,t3=$4;
    $$->add($1->objects); 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};
    $$->add(v); 
    
    Method* method = global_sym_table->lookup_method($2,1,$1->cls->name);
    string mysize = global_sym_table->getSize($2,$1->cls->name);
    if(method->parameters.size()!=0){
        cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<0<<endl;
        exit(1);
      }
    $$->type= method->ret_type;
    $$->method=method;

    $$->start = $1->start;
    if($$->type!="void"){
      $$->index = mycode->insertFunctnCall($2,vector<pair<string,int>>{},0,false,mysize,false);
    }
    else $$->index = mycode->insertFunctnCall($2,vector<pair<string,int>>{},0,false,mysize);

    $$->result = mycode->getVar($$->index-1);
     bool boo = false;
    // for (auto it:method->modifiers)if(it=="static")boo=true;
    // if($1->anyName!="")boo=false;
    global_sym_table->staticCheck(true,boo,global_sym_table->current_scope, yylineno);

  }
| MethodIncovationStart Identifier  brac_open ArgumentList brac_close                  {
    $$=new Node("MethodInvocation");
    string t1=$2,t2=$3,t3=$5;
    $$->add($1->objects); 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$4,new Node(mymap[t3],t3)};
    $$->add(v);
    Method* method = global_sym_table->lookup_method($2,1,$1->cls->name);
    string mysize = global_sym_table->getSize($2,$1->cls->name);
    if(method->parameters.size()!=$4->variables.size()){
      cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<$4->variables.size()<<endl;
      exit(1);
    }
    int parasize=0;
    for(int i=0;i<method->parameters.size();i++){
      if(method->parameters[i]->type!=$4->variables[i]->type){
        cout<<"TypeError: Expected type of argument[" <<i+1<<"] :"<< method->parameters[i]->type<<", Found: "<<$4->variables[i]->type<<endl;
        exit(1);
      }
      parasize+=typeToSize[method->parameters[i]->type];
    }
    // mysize = to_string(stoi(mysize)-parasize);

    $$->type= method->ret_type;
    $$->method=method;

    $$->start = $1->start;
    if($$->type!="void"){
      $$->index = mycode->insertFunctnCall($2,$4->resList,0,false,mysize,false);
    }
    else $$->index = mycode->insertFunctnCall($2,$4->resList,0,false,mysize);

    $$->result = mycode->getVar($$->index-1);
     bool boo = true;
    // for (auto it:method->modifiers)if(it=="static")boo=true;
    // if($1->anyName!="")boo=false;
    global_sym_table->staticCheck(true,boo,global_sym_table->current_scope, yylineno);
  }
| Primary dot Identifier brac_open ArgumentList brac_close {
    $$=new Node("MethodInvocation");
    string t1=$2,t2=$3,t3=$4,t6=$6;
    $$->add($1->objects); 
    vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),$5,new Node(mymap[t6],t6)};
    $$->add(v); 
    Method* method = global_sym_table->lookup_method($3,1,$1->cls->name);
    string mysize = global_sym_table->getSize($3,$1->cls->name);
    if(method->parameters.size()!=$5->variables.size()){
      cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<$5->variables.size()<<endl;
      exit(1);
    }
    int parasize=0;
    for(int i=0;i<method->parameters.size();i++){
      if(method->parameters[i]->type!=$5->variables[i]->type){
        cout<<"TypeError: Expected type of argument[" <<i+1<<"] :"<< method->parameters[i]->type<<", Found: "<<$5->variables[i]->type<<endl;
        exit(1);
      }
      parasize+=typeToSize[method->parameters[i]->type];
    }
    // mysize = to_string(stoi(mysize)-parasize);
    $$->type= method->ret_type;
    $$->method=method;

    $$->start = $1->start;
    if($$->type!="void"){
      $$->index = mycode->insertFunctnCall("#"+t2,$5->resList,0,false,mysize,false);
    }
    else $$->index = mycode->insertFunctnCall("#"+t2,$5->resList,0,false,mysize);

    $$->result = mycode->getVar($$->index-1);
     bool boo = true;
    global_sym_table->staticCheck(true,boo,global_sym_table->current_scope, yylineno);

  }
| Primary dot Identifier brac_open brac_close {
    $$=new Node("MethodInvocation");
    string t1=$2,t2=$3,t3=$4,t6=$5;
    $$->add($1->objects); 
    vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),new Node(mymap[t6],t6)};
    $$->add(v); 
    Method* method = global_sym_table->lookup_method($3,1,$1->cls->name);
    string mysize = global_sym_table->getSize($3,$1->cls->name);
    if(method->parameters.size()!=0){
        cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<0<<endl;
        exit(1);
      }
    $$->type= method->ret_type;
    $$->method=method;

    $$->start = $1->start;
    if($$->type!="void"){
      $$->index = mycode->insertFunctnCall("#"+t2,vector<pair<string,int>>{},0,false,mysize,false);
    }
    else $$->index = mycode->insertFunctnCall("#"+t2,vector<pair<string,int>>{},0,false,mysize);

    $$->result = mycode->getVar($$->index-1);
     bool boo = true;
    for (auto it:method->modifiers)if(it=="static")boo=true;
    global_sym_table->staticCheck(true,boo,global_sym_table->current_scope, yylineno);

  }
; 

MethodIncovationStart:
  TypeName dot                   {$$=new Node("MethodIncovationStart");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v); $$->start = $1->start; $$->objectName = $1->objectName; }
| super dot                      {$$=new Node("MethodIncovationStart");string t1=$1,t2=$2;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v); $$->start = mycode->quadruple.size(); }
| TypeName dot super dot         {$$=new Node("MethodIncovationStart");string t1=$2,t2=$3,t3=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v); $$->start = $1->start;}
;

ClassInstanceCreationExpression:
  UnqualifiedClassInstanceCreationExpression                {$$=$1;
    $$->isObj = true;
    }
| TypeName dot UnqualifiedClassInstanceCreationExpression   {$$=new Node("ClassInstCreatExp");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
| Primary dot UnqualifiedClassInstanceCreationExpression    {$$=new Node("ClassInstCreatExp");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
;

UnqualifiedClassInstanceCreationExpression:
  NEW TypeArguments ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen  {
    $$=new Node("UnqualifiedClassInstanceCreationExpression");
    string t1=$1,t2=$4;
    vector<Node*>v{new Node(mymap[t1],t1),$2,$3,new Node(mymap[t2],t2),$5};
    $$->add(v);
    }
| NEW ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen                {
    $$=new Node("UnqualifiedClassInstanceCreationExpression");
    string t1=$1,t2=$3;
    vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4};
    $$->add(v); 
    $$->cls = $2->cls;
    $$->type = "Class";
    $$->anyName=$2->cls->name;
    if($2->method->parameters.size()!=$4->variables.size()){
      throwError("Error: Expected number of arguments: "+to_string($2->method->parameters.size())+" Found: "+to_string($4->resList.size()),yylineno);
    }
    int parasize=0;
    for(int i=0;i<$2->method->parameters.size();i++){
      if($2->method->parameters[i]->type!=$4->variables[i]->type){
        throwError("TypeError: Expected type of argument["+to_string(i+1)+"] : "+$2->method->parameters[i]->type + ", Found: " +$4->variables[i]->type,yylineno);
      }
      parasize+=typeToSize[$2->method->parameters[i]->type];
    }

    int ind = mycode->insertAss(to_string(global_sym_table->linkmap[$$->cls->name]->offset),"","","");
    string z = mycode->getVar(ind);
    mycode->InsertTwoWordInstr("\tparam",z);
    // mycode->InsertTwoWordInstr("\tallocmem","1");
        // cout<<$2->result<<"\n";
    string mysize = global_sym_table->getSize($2->result,global_sym_table->current_scope);
    mysize = to_string(stoi(mysize)-parasize);
    string zz = mycode->getVar(mycode->insertAss("allocmem","",z,""));
    $$->objOffset = zz;
    mycode->InsertTwoWordInstr("\tsetObjectRef",zz);
    $$->index = mycode->insertFunctnCall($2->result+".Constr",$4->resList,0,true,mysize);
    $$->index = mycode->insertAss("popObject","","","");
    $$->result = mycode->getVar($$->index);
    // cout<<"!\n";


    }
;

UnqualifiedClassInstanceCreationExpressionAfter_bracopen:
  ArgumentList brac_close ClassBody      {
    $$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");
    string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};
    $$->add(v);
    $$->resList= $1->resList;
    $$->variables = $1->variables;
    }
| brac_close ClassBody                   {
    $$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");
    string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v); 
    vector<Variable*> v1;
    $$->variables=v1;
    }
| brac_close                             {
    string t1=$1; 
    $$=new Node(mymap[t1],t1);
    vector<Variable*> v1;
    $$->variables=v1;
    }
| ArgumentList brac_close                {
    $$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");
    string t1=$2;
    vector<Node*>v{$1,new Node(mymap[t1],t1)};
    $$->add(v);
    $$->resList= $1->resList;
    $$->variables= $1->variables;
  }
;

ClassOrInterfaceTypeToInstantiate:
 Identifier                                                 {
    string t1=$1; 
    $$=(new Node(mymap[t1],t1));
    $$->method = global_sym_table->lookup_method($1,1,global_sym_table->current_scope);
    $$->cls = global_sym_table->lookup_class($1,1,global_sym_table->current_scope);
    string curr_cls = global_sym_table->get_current_class();
    if(curr_cls!=$$->cls->name){
      for(auto method: global_sym_table->linkmap[$$->cls->name]->methods){
        if(method->name==$$->cls->name){
          for(auto mod: method->modifiers){
            if(mod=="private"){
              throwError("Constructor of "+method->name+ " is of private access type",yylineno);
            }
          }
        }
      }
    }
    $$->type = "Class";
    $$->result = $1;
    

  }
| Identifier TypeArgumentsOrDiamond                         {string t1=$1; $$=new Node("ClassOrInterfaceTypeToInstantiate"); $$->add(new Node(mymap[t1],t1)); $$->add($2->objects);}
| Identifier ClassOrInterfaceType2                          {string t1=$1; $$=new Node("ClassOrInterfaceTypeToInstantiate"); $$->add(new Node(mymap[t1],t1)); $$->add($2);}
| Identifier ClassOrInterfaceType2 TypeArgumentsOrDiamond   {string t1=$1; $$=new Node("ClassOrInterfaceTypeToInstantiate"); $$->add(new Node(mymap[t1],t1)); $$->add($2); $$->add($3->objects);}
;

TypeArgumentsOrDiamond:
  TypeArguments               {$$=new Node(); $$->add($1);}
| less_than greater_than      {$$=new Node(); string t1=$1,t2=$2; $$->add(new Node(mymap[t1],t1)); $$->add(new Node(mymap[t2],t2));}
;

ClassOrInterfaceType2:
  dot Identifier                           {$$=new Node("ClassOrInterfaceType2"); string t1=$1,t2=$2; $$->add(new Node(mymap[t1],t1)); $$->add(new Node(mymap[t2],t2));}
| ClassOrInterfaceType2 dot Identifier     {$$=$1; string t1=$2,t2=$3; $$->add(new Node(mymap[t1],t1)); $$->add(new Node(mymap[t2],t2));}
;

Statement:
StatementWithoutTrailingSubstatement     {$$= new Node("Statement");$$->add($1); $$->result =$1->result; $$->index = $1->index; $$->start = $1->start;}
| LabeledStatement                       {$$= new Node("Statement");$$->add($1); $$->result =$1->result; $$->index = $1->index; $$->start = $1->start;}
| IfThenStatement                        {$$= new Node("Statement");$$->add($1); $$->result =$1->result; $$->index = $1->index; $$->start = $1->start;}
| IfThenElseStatement                    {$$= new Node("Statement");$$->add($1); $$->result =$1->result; $$->index = $1->index; $$->start = $1->start;}
| WhileStatement                         {$$= new Node("Statement");$$->add($1); $$->result =$1->result; $$->index = $1->index; $$->start = $1->start;}
| ForStatement                           {$$= new Node("Statement");$$->add($1); $$->result =$1->result; $$->index = $1->index; $$->start = $1->start;}
| PRINTLN brac_open Expression brac_close semi_colon {
    $$= new Node("Statement");
    string t1=$1,t2=$2,t4=$4,t5=$5; 
    vector<Node*>v {new Node(mymap[t1],$1),new Node(mymap[t2],$2), $3, new Node(mymap[t4],$4),new Node(mymap[t5],$5)};
     $$->add(v);

     if(!($3->type=="int" || $3->type=="float"||$3->type=="long" || $3->type=="short"||$3->type=="byte" || $3->type=="String"||$3->type=="boolean" || $3->type=="char"||$3->type=="double")){
      throwError("Invalid type to print",yylineno);
     }
     $$->index = mycode->insertAss($3->result,"","","");
     $$->index = mycode->InsertTwoWordInstr("\tprint",mycode->getVar($$->index));
     $$->start = $3->start;

     }
;

StatementWithoutTrailingSubstatement:
{if(global_sym_table->isForScope==false)global_sym_table->makeTable();global_sym_table->isForScope=false;} 
  Block {
    $$=$2;
    SymbolTable* parentTable = global_sym_table->current_symbol_table;

    while(parentTable->isMethod==false && parentTable->parent!=NULL){
      parentTable = parentTable->parent;
    }
    
    for(auto it: global_sym_table->current_symbol_table->vars){
       it->offset = parentTable->offset;
       it->otherScope = true;
      parentTable->offset += it->size;
      parentTable->insert_variable(it);
    }
    global_sym_table->end_scope();

    $$->result = $2->result;
    $$->index = $2->index;
    $$->start = $2->start;
  }
| semi_colon                    { string t1 = $1; $$=new Node(mymap[t1],$1);}
| ExpressionStatement           {$$=$1;}
| BreakStatement                {$$=$1;}
| ContinueStatement             {$$=$1;}
| ReturnStatement               {$$=$1;}
| ThrowStatement                {$$=$1;}
;

BreakStatement:
BREAK  semi_colon                        {
  $$= new Node("BreakStatement");
  string t1= $1,t2=$2; 
  $$->add(new Node(mymap[t1],t1));
  $$->add(new Node(mymap[t2],t2));

  $$->index = mycode->insertIncompleteJump("break");
  $$->start = $$->index;
  }
| BREAK Identifier semi_colon             {
  $$= new Node("BreakStatement"); 
  string t1= $1, t2=$2,t3=$3; 
  $$->add(new Node(mymap[t1],t1));
  $$->add(new Node(mymap[t2],t2)); 
  $$->add(new Node(mymap[t3],t3));

  $$->index = mycode->insertIncompleteJump("break");
  $$->start = $$->index;
  }
;

ContinueStatement:
CONTINUE semi_colon                     {
  $$= new Node("ContinueStatement");
  string t1= $1,t2=$2; 
  $$->add(new Node(mymap[t1],t1));
  $$->add(new Node(mymap[t2],t2));

  $$->index = mycode->insertIncompleteJump("continue");
  $$->start = $$->index;
  }
| CONTINUE Identifier semi_colon           {
  $$= new Node("ContinueStatement"); 
  string t1= $1, t2=$2,t3=$3; 
  $$->add(new Node(mymap[t1],t1));
  $$->add(new Node(mymap[t2],t2)); 
  $$->add(new Node(mymap[t3],t3));

  $$->index = mycode->insertIncompleteJump("continue");
  $$->start = $$->index;
  }
;

ReturnStatement:
RETURN  semi_colon                         {
  $$= new Node("ReturnStatement");
  string t1= $1,t2=$2;
  $$->add(new Node(mymap[t1],t1));
  $$->add(new Node(mymap[t2],t2)); 
  
  SymbolTable* parentTable = global_sym_table->current_symbol_table;

  while(parentTable->isMethod==false && parentTable->parent!=NULL){
    parentTable = parentTable->parent;
  }

  string methodName= parentTable->scope;
  parentTable = parentTable->parent;
  methodName= methodName.substr(parentTable->scope.length()+1,methodName.length() -(parentTable->scope.length()));
  for (auto x: parentTable->methods){
    if(x->name==methodName){
      if(x->ret_type!="void"){
        throwError("return type mismatch : expected \" void \" found \"" + x->ret_type + "\"",yylineno);
      }
    }
  }
  $$->start = mycode->quadruple.size();

  gotReturn=true;
  $$->start = mycode->InsertTwoWordInstr("\tpop","basePointer");
 $$->index =  mycode->InsertTwoWordInstr("\treturn","");


  }
| RETURN Expression semi_colon           {
  $$= new Node("ReturnStatement"); 
  string t1= $1,t2=$3; 
  $$->add(new Node(mymap[t1],$1));
  $$->add($2);$$->add(new Node(mymap[t2],t2));

  SymbolTable* parentTable = global_sym_table->current_symbol_table;

  while(parentTable->isMethod==false && parentTable->parent!=NULL){
    parentTable = parentTable->parent;
  }
  string methodName= parentTable->scope;
  parentTable = parentTable->parent;
  methodName= methodName.substr(parentTable->scope.length()+1,methodName.length() -(parentTable->scope.length()));
  for (auto x: parentTable->methods){
    if(x->name==methodName){
      if(x->ret_type!=$2->var->type){
        if((x->ret_type=="long")&&($2->var->type=="int") )break;
        if((x->ret_type=="int")&&($2->var->type=="short") )break;
        if((x->ret_type=="int")&&($2->var->type=="int") )break;
        if((x->ret_type=="long")&&($2->var->type=="short") )break;
        if((x->ret_type=="short")&&($2->var->type=="byte") )break;
        if((x->ret_type=="long")&&($2->var->type=="byte") )break;
        throwError("return type mismatch : expected \""+ x->ret_type + "\" found \"" + $2->var->type + "\"",yylineno);
      }
    }
  }
  $$->start = $2->start;
  gotReturn=true;
  mycode->InsertTwoWordInstr("\tpush",$2->result);
  mycode->InsertTwoWordInstr("\tpop","basePointer");
  $$->index = mycode->InsertTwoWordInstr("\treturn","");

  }
;

ThrowStatement:
THROW Expression semi_colon               {$$= new Node("ThrowStatement"); string t1= $1,t2=$3; $$->add(new Node(mymap[t1],$1));$$->add($2);$$->add(new Node(mymap[t2],t2));}
;

StatementExpression:
Assignment                       {$$=$1;}
| PreIncrDecrExpression          {$$=$1;}
| PostIncrDecrExpression         {$$=$1;}
| MethodInvocation               {$$=$1;}
| ClassInstanceCreationExpression{$$=$1;}
;

ExpressionStatement:
StatementExpression semi_colon                                                {
  $$ = new Node("ExpressionStatement"); 
  string t2= $2; $$->add($1);
  $$->add(new Node(mymap[t2],$2)); 

  $$->index=$1->index; $$->result=$1->result;
  $$->start = $1->start;

  }
;

LabeledStatement:
Identifier colon Statement                                                    {
  $$= new Node("LabeledStatement"); 
  string t1=$1, t2=$2; 
  vector<Node*> v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3};
  $$->add(v);

  $$->index = mycode->makeBlock($3->start,t1);
  $$->start=$$->index;
  $$->result = t1;
  }
;

IfThenStatement:
IF brac_open Expression brac_close Statement                                  {
  $$ = new Node("IfThenStatement");
  string t1 = $1,t2= $2,t4=$4;
  vector<Node*>v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3,new Node (mymap[t4],$4),$5 }; 
  $$->add(v);
  $$->lineno=$3->lineno;

  if($3->type!="boolean") throwError($3->type+" cannot be converted to boolean type",$3->lineno);

  if(!mycode->quadruple[$5->start]->isBlock || $5->start!=$5->index) $5->result = mycode->getVar(mycode->makeBlock($5->start));
  $$->index = mycode->insertIf($5->start-1,$3->result,$5->result,"");
  // cout<<"Blockkkk\n";
  $$->start = $3->start;
   

  }   
;

IfThenElseStatement:
IF brac_open Expression brac_close StatementNoShortIf ELSE Statement           {
  $$ = new Node("IfThenElseStatement"); 
  string t1 = $1,t2= $2,t4=$4,t6=$6; 
  vector<Node*>v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3,new Node (mymap[t4],$4),$5,new Node (mymap[t6],$6),$7 }; 
  $$->add(v); 
  $$->lineno=$3->lineno;
  global_sym_table->typeCheckVar($3->var,"boolean",$$->lineno);

  if($3->type!="boolean") throwError($3->type+" cannot be converted to boolean type",$3->lineno);

  if(!mycode->quadruple[$7->start]->isBlock || $7->start!=$7->index) $7->result = mycode->getVar(mycode->makeBlock($7->start));
  if(!mycode->quadruple[$5->start]->isBlock || $5->start!=$5->index) $5->result = mycode->getVar(mycode->makeBlock($5->start,"",$7->start));
  $$->index = mycode->insertIf($5->start-1,$3->result,$5->result,$7->result);

  $$->start = $3->start;

  }
;

IfThenElseStatementNoShortIf:
IF brac_open Expression brac_close StatementNoShortIf ELSE StatementNoShortIf  {
  $$ = new Node(); 
  string t1 = $1,t2= $2,t4=$4,t6=$6; 
  vector<Node*>v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3,new Node (mymap[t4],$4),$5,new Node (mymap[t6],$6) } ;
  $$->add(v);
  $$->lineno=$3->lineno;
  global_sym_table->typeCheckVar($3->var,"boolean",$$->lineno);

  if($3->type!="boolean") throwError($3->type+" cannot be converted to boolean type",$3->lineno);

  if(!mycode->quadruple[$7->start]->isBlock || $7->start!=$7->index) $7->result = mycode->getVar(mycode->makeBlock($7->start));
  if(!mycode->quadruple[$5->start]->isBlock || $5->start!=$5->index) $5->result = mycode->getVar(mycode->makeBlock($5->start,"",$7->start));
  $$->index = mycode->insertIf($5->start-1,$3->result,$5->result,$7->result);

  $$->start = $3->start;

  }
;

StatementNoShortIf:
StatementWithoutTrailingSubstatement {$$=$1;}
| LabeledStatementNoShortIf         {$$=$1;}
| IfThenElseStatementNoShortIf      {$$=$1;}
| WhileStatementNoShortIf           {$$=$1;}
| ForStatementNoShortIf             {$$=$1;}
;

LabeledStatementNoShortIf:
Identifier colon StatementNoShortIf                                    {$$= new Node(); string t1 = $1;string t2= $2; vector<Node*>v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3 }; $$->add(v); }                      
;

WhileStatementNoShortIf:
WHILE brac_open Expression brac_close StatementNoShortIf             {$$ = new Node();
  string t1= $1,t2=$2, t4=$4;
    vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5 };
      $$->add(v);
      $$->lineno=$3->lineno;
      global_sym_table->typeCheckVar($3->var,"boolean",$$->lineno);

      $$->start = $3->start;
      if(!mycode->quadruple[$5->start]->isBlock || $5->start!=$5->index) $5->result = mycode->getVar(mycode->makeBlock($5->start));
      $$->index = mycode->insertWhile($3->start,$5->start-1,$3->result,$5->result);

      $$->result=mycode->getVar($$->start);
}
;

ForStatement:
BasicForStatement                                                      {
  $$=new Node("ForStatement"); 
  $$->add($1);
  $$->start=$1->start; $$->index=$1->index;
  }
| EnhancedForStatement                                                 {
  $$=new Node("ForStatement"); 
  $$->add($1);
  $$->start=$1->start; $$->index=$1->index;
  }
;

ForStatementNoShortIf:
BasicForStatementNoShortIf {$$=$1;}
| EnhancedForStatementNoShortIf {$$=$1;}
;

BasicForStatement:
BasicForStatementStart Statement                                       {
  $$=new Node("BasicForStatement"); 
  $$->add($1->objects); $$->add($2);

  if(!mycode->quadruple[$2->start]->isBlock || $2->start!=$2->index) $2->result = mycode->getVar(mycode->makeBlock($2->start));

  $$->index = mycode->insertFor($1->prestart, $1->start,$1->index,$1->result, $2->result);
  // cout<<$2->start-1<<" "<<$1->index<<"barabar?\n";

  $$->start = $$->index;
  if(global_sym_table->isForScope==true){
    global_sym_table->isForScope=false;
    SymbolTable* parentTable = global_sym_table->current_symbol_table;

    while(parentTable->isMethod==false && parentTable->parent!=NULL){
      parentTable = parentTable->parent;
    }
    
    for(auto it: global_sym_table->current_symbol_table->vars){
      it->offset = parentTable->offset;
      parentTable->offset += it->size;
      it->otherScope = true;
      parentTable->insert_variable(it);
    }
  global_sym_table->end_scope();
  }
  }
;

BasicForStatementNoShortIf:
BasicForStatementStart StatementNoShortIf                              {
  $$=new Node("BasicForStatementNoShortIf"); 
  $$->add($1->objects); $$->add($2);

  if(!mycode->quadruple[$2->start]->isBlock || $2->start!=$2->index) $2->result = mycode->getVar(mycode->makeBlock($2->start));
  $$->index = mycode->insertFor($1->prestart,$1->start,$1->index,$1->result, $2->result);
  // cout<<$2->start-1<<" "<<$1->index<<"barabar?\n";
  $$->start = $$->index;
  if(global_sym_table->isForScope==true){
    global_sym_table->isForScope=false;
    SymbolTable* parentTable = global_sym_table->current_symbol_table;

    while(parentTable->isMethod==false && parentTable->parent!=NULL){
      parentTable = parentTable->parent;
    }
    
    for(auto it: global_sym_table->current_symbol_table->vars){
      it->offset = parentTable->offset;
      parentTable->offset += it->size;
      it->otherScope = true;
      parentTable->insert_variable(it);
    }
    global_sym_table->end_scope();
  }
}

BasicForStatementStart:
forr brac_open semi_colon semi_colon brac_close                         {
  $$ = new Node();
   string t1= $1,t2=$2,t3=$3, t4=$4, t5=$5; 
   vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), new Node(mymap[t4], $4), new Node(mymap[t5], $5) };
   $$->add(v);
  
  $$->prestart=-1;
  $$->start =-1;
  $$->index = mycode->quadruple.size();
  $$->result="";

   }
| forr brac_open ForInit semi_colon semi_colon brac_close               {
  $$ = new Node();
   string t1= $1,t2=$2,t4=$4, t5=$5, t6=$6; 
   vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), new Node(mymap[t5], $5), new Node(mymap[t6], $6) };
     $$->add(v);

    $$->prestart=$3->start;
    $$->start =-1;
    $$->index = $3->index;
    $$->result="";

  } 
| forr brac_open semi_colon Expression semi_colon brac_close            {
  $$ = new Node(); string t1= $1,t2=$2,t3=$3, t5=$5, t6=$6;
   vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), $4, new Node(mymap[t5], $5), new Node(mymap[t6], $6) };
  $$->add(v); 
  $$->lineno=$4->lineno;
  global_sym_table->typeCheckVar($4->var,"boolean",$$->lineno);

  $$->prestart=$4->start;
  $$->start =$4->start;
  $$->index = mycode->quadruple.size()-1;
  $$->result="";

  }
| forr brac_open semi_colon semi_colon ForUpdate brac_close             {
  $$ = new Node(); string t1= $1,t2=$2,t3=$3, t4=$4, t6=$6;
   vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6) };
   $$->add(v);

    $$->prestart= $5->start;
    $$->start =-1;
    $$->index = $5->start - 1;
    if(!mycode->quadruple[$5->start]->isBlock || $5->start!=$5->index) $5->result = mycode->getVar(mycode->makeBlock($5->start));
    $$->result=$5->result;

   }
| forr brac_open semi_colon Expression semi_colon ForUpdate brac_close  {
  $$ = new Node(); string t1= $1,t2=$2,t3=$3, t5=$5, t7=$7;
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), $4, new Node(mymap[t5], $5), $6, new Node(mymap[t7], $7) }; 
  $$->add(v);
  $$->lineno=$4->lineno;
  global_sym_table->typeCheckVar($4->var,"boolean",$$->lineno);

  $$->prestart= $4->start;
  $$->start =$4->start;
  $$->index = $4->index;
  if(!mycode->quadruple[$6->start]->isBlock || $6->start!=$6->index) $6->result = mycode->getVar(mycode->makeBlock($6->start));
  $$->result=$6->result;

  }
| forr brac_open ForInit semi_colon semi_colon ForUpdate brac_close     {
  $$ = new Node(); 
  string t1= $1,t2=$2,t4=$4, t5=$5, t7=$7;
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), new Node(mymap[t5], $5), $6, new Node(mymap[t7], $7) };
  $$->add(v);

  $$->prestart= $3->start;
  $$->start =-1;
  $$->index = $3->index;
  if(!mycode->quadruple[$6->start]->isBlock || $6->start!=$6->index) $6->result = mycode->getVar(mycode->makeBlock($6->start));
  $$->result=$6->result;

  }
| forr brac_open ForInit semi_colon Expression semi_colon brac_close    {
  $$ = new Node();
  string t1= $1,t2=$2,t4=$4, t6=$6, t7=$7;
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6),new Node(mymap[t7], $7) };
  $$->add(v); 
  $$->lineno=$5->lineno;
  global_sym_table->typeCheckVar($5->var,"boolean",$$->lineno);

  $$->prestart= $3->start;
  $$->start =$5->start;
  $$->index = $5->index;
  $$->result="";

  }
| forr brac_open ForInit semi_colon Expression semi_colon ForUpdate brac_close {
  $$ = new Node(); 
  string t1= $1,t2=$2,t4=$4, t6=$6, t8=$8; 
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6), $7, new Node(mymap[t8], $8) };
  $$->add(v);
  $$->lineno=$5->lineno;
  global_sym_table->typeCheckVar($5->var,"boolean",$$->lineno);

  $$->prestart= $3->start;
  $$->start =$5->start;
  $$->index = $5->index;
  if(!mycode->quadruple[$7->start]->isBlock || $7->start!=$7->index) $7->result = mycode->getVar(mycode->makeBlock($7->start));
  $$->result=$7->result;

  }
;

forr:
FOR {
  global_sym_table->isForScope=true;
  global_sym_table->makeTable();
  }
;


ForInit: 
StatementExpressionList {$$=$1;}
| LocalVariableDeclaration {
  $$=$1;
  }
;

ForUpdate:
StatementExpressionList {$$=$1;}
;

StatementExpressionList:
StatementExpression {
  $$= new Node("StatementExpressionList"); $$->add($1);
  $$->start=$1->start; $$->index = $1->index;
  }
| StatementExpressionList comma StatementExpression  {
  $$ = $1; string t1 = $2; 
  $$->add(new Node(mymap[t1],$2));
  $$->add($3);

  $$->start=$1->start; $$->index = $3->index;
  }
;

EnhancedForStatement:
forr brac_open LocalVariableDeclaration colon Expression brac_close Statement {
  $$ = new Node("EnhancedForStatement"); 
  string t1= $1,t2=$2,t4=$4, t6=$6; 
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6), $7 }; 
  $$->add(v);
  $$->lineno=$5->lineno;
  global_sym_table->typeCheckVar($5->var,$3->type,$$->lineno);
  if($3->variables[0]->dims!=$5->dims-1){
    throwError("Type mismatch: Cannot iterate over "+to_string($5->dims)+" dimensional object using "+to_string($3->dims)+" dimesnional object",$5->lineno);
  }

  if(!mycode->quadruple[$7->start]->isBlock || $7->start!=$7->index) $7->result = mycode->getVar(mycode->makeBlock($7->start));
  mycode->quadruple.pop_back();

  string init,change;

  // for init
  string myscope = global_sym_table->getScope($5->result, global_sym_table->current_scope,1);
  Variable* var = global_sym_table->lookup_var($5->result,1, 1,global_sym_table->current_scope);

  int pp,pp1,pp2, ss, ee;
  // string myscope = global_sym_table->getScope($5->result, global_sym_table->current_scope,1);
  pp = mycode->insertGetFromSymTable(myscope,$5->result,"",var->offset);
  // int t5 = mycode->insertAss("getAddress","",mycode->getVar(pp),"");
  // pp1 = mycode->insertAss()
  pp1 = mycode->insertPointerAssignment(mycode->getVar(pp),"0","");
  pp2 = mycode->insertAss(mycode->getVar(pp),"0","+int");
  mycode->insertAss(mycode->getVar(pp1),"","",$3->var->name);

  $$->index = mycode->makeBlock(pp);
  init = mycode->getVar($$->index);

  // conditional
  // Variable* vp = global_sym_table->lookup_var($5->result,0,myscope);
  ee = mycode->insertAss(mycode->getVar(pp2),to_string(var->arrSize),"<");

  // for changeexp
  ss = mycode->insertAss(mycode->getVar(pp2),to_string(typeToSize[$3->type]),"+",mycode->getVar(pp2));
  $$->index = mycode->makeBlock(ss);


  Instruction* myInstruction = mycode->blocks[$7->result];
  mycode->quadruple.push_back(myInstruction);
  $$->start = pp;
  $$->index = mycode->insertFor(pp,ee,ee,mycode->getVar(ss),$7->result);

  }
;

EnhancedForStatementNoShortIf:
forr brac_open LocalVariableDeclaration colon Expression brac_close StatementNoShortIf {
  $$ = new Node("EnhancedForStatementNoShortIf"); 
  string t1= $1,t2=$2,t4=$4, t6=$6; 
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6), $7 };  
  $$->add(v);
  $$->lineno=$5->lineno;
  global_sym_table->typeCheckVar($5->var,$3->type,$$->lineno);
  if($3->variables[0]->dims!=$5->dims-1){
    throwError("Type mismatch: Cannot iterate over "+to_string($5->dims)+" dimensional object using "+to_string($3->dims)+" dimesnional object",$5->lineno);
  }


   if(!mycode->quadruple[$7->start]->isBlock || $7->start!=$7->index) $7->result = mycode->getVar(mycode->makeBlock($7->start));
  mycode->quadruple.pop_back();

  string init,change;

  // for init
  string myscope = global_sym_table->getScope($5->result, global_sym_table->current_scope,1);
  Variable* var = global_sym_table->lookup_var($5->result,1,1, global_sym_table->current_scope);

  int pp,pp1,pp2, ss, ee;
  // string myscope = global_sym_table->getScope($5->result, global_sym_table->current_scope,1);
  pp = mycode->insertGetFromSymTable(myscope,$5->result,"",var->offset);
  pp1 = mycode->insertPointerAssignment(mycode->getVar(pp),"0","");
  pp2 = mycode->insertAss(mycode->getVar(pp),"0","+int");
  mycode->insertAss(mycode->getVar(pp1),"","",$3->var->name);

  $$->index = mycode->makeBlock(pp);
  init = mycode->getVar($$->index);

  // conditional
  // Variable* vp = global_sym_table->lookup_var($5->result,0,myscope);
  ee = mycode->insertAss(mycode->getVar(pp2),to_string(var->size),"<");

  // for changeexp
  ss = mycode->insertAss(mycode->getVar(pp2),to_string(typeToSize[$3->type]),"+",mycode->getVar(pp2));
  $$->index = mycode->makeBlock(ss);


  Instruction* myInstruction = mycode->blocks[$7->result];
  mycode->quadruple.push_back(myInstruction);
  $$->start = pp;
  $$->index = mycode->insertFor(pp,ee,ee,mycode->getVar(ss),$7->result);

  }
;

WhileStatement:
WHILE brac_open Expression brac_close Statement {
  $$ = new Node("WhileStatement"); 
  string t1= $1,t2=$2,t4=$4; 
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5};  
  $$->add(v);
  $$->lineno=$3->lineno;
  global_sym_table->typeCheckVar($3->var,"boolean",$$->lineno);


  $$->start = $3->start;

  if(!mycode->quadruple[$5->start]->isBlock || $5->start!=$5->index) $5->result = mycode->getVar(mycode->makeBlock($5->start));
  $$->index = mycode->insertWhile($3->start,$5->start-1,$3->result,$5->result);
  $$->result = mycode->getVar($3->start);
  
  }
;

LocalVariableDeclaration:
LocalVariableType VariableDeclaratorList {
  $$= new Node ("LocalVariableDeclaration"); 
  $$->add($1->objects); 
  $$->add($2);
  $$->type = $1->type;
  $$->dims = $1->dims+ $2->dims;
  for(auto i:$2->variables){
      if(i->isArray){
        if(i->type!=""){
          global_sym_table->typeCheckVar(i,$1->type,yylineno);
        }
        Variable* varr = new Variable(i->name,$1->type,{},yylineno,true,i->dims,i->dimsSize,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        varr->objName=i->objName;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
        $$->variables.push_back(varr);
        
      }
      else{

        if(i->classs_name!=""){
          if(i->classs_name!=$1->anyName){
            throwError("Type error: Cannot convert from "+i->classs_name+" to "+$1->anyName,yylineno);
          }
        }
        if(i->type!=""){
          global_sym_table->typeCheckVar(i,$1->type,yylineno);
        }
        Variable* varr = new Variable(i->name,$1->type,yylineno,{},i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        varr->objName=i->objName;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
        $$->variables.push_back(varr);
      }

    }
    $$->var  = $2->variables[0];
    $$->start=$2->start;
    $$->index=$2->index;
  }
| Modifiers LocalVariableType VariableDeclaratorList {
    $$= new Node ("LocalVariableDeclaration"); 
    $$->add($1->objects); 
    $$->add($2->objects); 
    $$->add($3);
    for(auto i:$3->variables){
      if(i->isArray){
        if(i->type!=""){
          global_sym_table->typeCheckVar(i,$2->type,yylineno);
        }
        
        Variable* varr = new Variable(i->name,$2->type,$1->var->modifiers,yylineno,true,i->dims,i->dimsSize,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        varr->objName = i->objName;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
        
      }
      else{
        if(i->type!=""){
          global_sym_table->typeCheckVar(i,$2->type,yylineno);
        }

        Variable* varr = new Variable(i->name,$2->type,yylineno,$1->var->modifiers,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        varr->objName=i->objName;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
      }

    }
    $$->var  = $3->variables[0];
    $$->start=$3->start;
    $$->index=$3->index;

    }
;

ArrayCreationExpression: 
newclasstype ArrayCreationExpressionAfterType  {
  $$= new Node("ArrayCreationExpression"); 
  $$->add($1->objects); 
  $$->add($2->objects); 
  $$->dims = $2->dims;
  $$->type = $1->type;
  $$->var=$2->var;

  $$->start=$2->start;
  $$->index=$2->index;
  }
| newprimtype ArrayCreationExpressionAfterType {
  $$= new Node("ArrayCreationExpression"); 
  $$->add($1->objects); 
  $$->add($2->objects); 
  $$->dims = $2->dims;
  $$->type = $1->type;
  $$->var = $2->var;
  
  int allocmem =typeToSize[$1->type];
        for(auto i:$2->var->dimsSize){
    allocmem*=i;
  }
  int ind = mycode->insertAss(to_string(allocmem),"","","");
          // cout<<"yaha\n";
  string z = mycode->getVar(ind);
  mycode->InsertTwoWordInstr("\tparam",z);
  // mycode->InsertTwoWordInstr("\tallocmem","1");
  string zz = mycode->getVar(mycode->insertAss("allocmem","",z,""));
  $$->result = zz;

  $$->start=$2->start;
  $$->index=mycode->quadruple.size()-1;

  }
;

ArrayCreationExpressionAfterType:
DimExprs { $$=$1; }
| DimExprs Dims {
    $$= new Node(); 
    $$->add($1);
    $$->add($2);
    $$->dims = $1->dims+$2->var->dims;
    $$->var = $1->var;

    $$->start=$1->start;
    $$->index=$1->index;
    }
| Dims ArrayInitializer {
    $$=new Node(); 
    $$->add($1);
    $$->add($2);
    if($1->var->dims!=$2->var->dimsSize.size()){
      throwError("Dimensions unmatched",yylineno);
    }
    $$->dims = $1->var->dims;
    $$->var = $2->var;
    // arrayRowMajor = $2->arrayRowMajor;

    $$->start=$2->start;
    $$->index=$2->index;

    }
;

newprimtype:
NEW PrimitiveType {
  $$=new Node(); 
  string t1= $1; 
  $$->add(new Node(mymap[t1],$1));
  $$->add($2);
  $$->type = $2->lexeme;
  }
;

newclasstype:
NEW ClassType {
  $$=new Node(); 
  string t1= $1; 
  $$->add(new Node(mymap[t1],$1));
  $$->add($2);
  $$->type = $2->type;
  }
;

DimExprs:
  DimExpr {$$=$1;}
| DimExprs DimExpr {
    $$=$1; 
    $$->add($2);
    $$->dims++;
    $$->var->dimsSize.push_back($2->var->dimsSize[0]);

    $$->start=$1->start;
    $$->index=$2->index;
    }
;

DimExpr:  
box_open Expression box_close  {
  string t1=$1; 
  $$=new Node("DimExpr"); 
  $$->add(new Node(mymap[t1],$1)); 
  $$->add($2); 
  t1=$3;
  $$->add(new Node(mymap[t1],$3));
  if($2->type!="int"){
     throwError("Array cannot be initialized using "+$2->type+"as index",yylineno);
  }
  vector<int> ss;
  ss.push_back((int)stoi($2->var->value));
  $$->var = new Variable("","",{},yylineno,true,1,ss,$2->var->value);
  $$->dims=1;

  $$->start=$2->start;
  $$->index=$2->index;

  }

ArrayInitializer: 
  curly_open VariableInitializerList curly_close {
    string t1=$1; 
    $$=new Node("ArrayInitializer"); 
    $$->add(new Node(mymap[t1],$1)); 
    $$->add($2); 
    t1=$3; 
    $$->add(new Node(mymap[t1],$1));
    // $$->variables=$2->variables;
    $$->type = $2->type;
    $$->dims=$2->dims;
    $$->var= $2->var;
    // arrayRowMajor = $2->arrayRowMajor;
    // cout<<"3153"<<arrayRowMajor.size();
    // $$->var->dimsSize.push_back($2->arrSize);
    // $$->var->isArray=true;
    $$->start=$2->start;
    $$->index=$2->index;
    }
  | curly_open VariableInitializerList comma curly_close {
      string t1=$1; 
      $$=new Node("ArrayInitializer"); 
      $$->add(new Node(mymap[t1],$1)); 
      $$->add($2); 
      t1=$3; 
      $$->add(new Node(mymap[t1],$1)); 
      t1=$4; 
      $$->add(new Node(mymap[t1],$1));
      // $$->variables=$2->variables;
      $$->type = $2->type;
      $$->dims=$2->dims;
      // $$->var= new Variable("","",yylineno,{},"");
      $$->var= $2->var;
      $$->start=$2->start;
      $$->index=$2->index;
      }
;

VariableInitializerList:
VariableInitializer {
  $$= new Node("VariableInitializerList"); 
  $$->add($1);
  // $$->variables.push_back($1->var);
  $$->type=$1->type;
  $$->dims = $1->dims;
  $$->arrSize = 1;
  $$->var = $1->var;
  $$->var->dimsSize.push_back(1);

  $$->start=$1->start;
  $$->index=$1->index;
  // arrayRowMajor=$1->arrayRowMajor;
  arrayRowMajor.push_back($1->result);
  
  }
| VariableInitializerList comma VariableInitializer {
  $$= $1; 
  string t1=$2;  
  $$->add(new Node(mymap[t1],$2)); 
  $$->add($3);
  if($1->type!=$3->type){
    throwError("TypeError: Array cannot be of 2 different datatypes "+$1->type+" and "+$3->type,yylineno);
  }
  $$->var = $1->var;
  $$->var->dimsSize[$$->var->dimsSize.size()-1]++;
  arrayRowMajor.push_back($3->result);
  // $$->arrSize = $1->arrSize+1;
  // $$->variables.push_back($3->var);

  $$->start=$1->start;
  $$->index=$3->index;
  
  }
;

ImportDeclarations: 
ImportDeclaration                      {$$= new Node("ImportDeclarations"); $$->add($1);}
| ImportDeclarations ImportDeclaration    {$$=new Node("ImportDeclarations");vector<Node*>v{$1,$2};$$->add(v);}
;

ImportDeclaration:
SingleTypeImportDeclaration        {$$=new Node("ImportDeclaration");$$->add($1);}
| SingleStaticImportDeclaration    {$$=new Node("ImportDeclaration");$$->add($1);}
| StaticImportOnDemandDeclaration  {$$=new Node("ImportDeclaration");$$->add($1);}
;

SingleTypeImportDeclaration:
IMPORT TypeName semi_colon                        {$$=new Node("SingleTypeImportDeclaration");string t1=$1,t2=$3;vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)};$$->add(v);}
| IMPORT TypeName DOT_STAR semi_colon             {$$=new Node("SingleTypeImportDeclaration");string t1=$1,t2=$3,t3=$4;vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
;

SingleStaticImportDeclaration:
IMPORT STATIC TypeName dot Identifier semi_colon  {$$=new Node("SingleStaticImportDeclaration");string t1=$1,t2=$2,t3=$4,t4=$5,t5=$6;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3,new Node(mymap[t3],t3),new Node(mymap[t4],t4),new Node(mymap[t5],t5)};$$->add(v);}
;

StaticImportOnDemandDeclaration:        
IMPORT STATIC TypeName DOT_STAR semi_colon        {$$=new Node("StaticImportOnDemandDeclaration");string t1=$1,t2=$2,t3=$4,t4=$5;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3,new Node(mymap[t3],t3),new Node(mymap[t4],t4)};$$->add(v);}
;


%%

int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int main(int argc, char *argv[])
{
	
		set_input_file(argv[1]);
    fout.open(argv[2]);
    sourceFile = argv[1];
    set_tac_file(argv[3]);
    set_x86_file(argv[4]);

	
	yyparse();

    /* printf("%d %d %d %d\n",titles,paras,words,sentences)); */
    /* fout<<titles<<" "<<paras<<" "<<words<<" "<<sentences<<endl; */
    mycode->print();
    mycode->x86print();

    return 0;
}

int yyerror (char const *s)
{
  return yyerror(string(s));
}