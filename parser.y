%{  
#include <bits/stdc++.h>
#include "nodes.cpp"
#include "ThreeAC.cpp"
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

int num=0;
int indd=0;

ofstream fout;
ofstream vout;

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
CompilationUnit {generate_graph($$);global_sym_table->printAll();}
;

CompilationUnit: {$$= new Node("CompilationUnit");}
| CompilationUnit ClassDeclaration  { $$=$1; $$->add($2);}
| CompilationUnit ImportDeclarations ClassDeclaration  {$$=$1;vector<Node*>v{$2,$3};$$->add(v);}
;

ClassDeclaration:
  Modifiers class_just_class Identifier {

    Class *classs = new Class($3,$1->var->modifiers,yylineno);

    global_sym_table->insert(classs);
    global_sym_table->makeTable($3);
    global_sym_table->current_symbol_table->isClass=true;
    mycode->makeBlock(mycode->quadruple.size(),$3);

   
  } 
  ClassDecTillTypeParameters {
    $$= new Node("ClassDeclaration"); 
    $$->add($1->objects); 
    string t1=$2,t2=$3; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v); 
    $$->add($5->objects); 
    global_sym_table->end_scope();
     
  }
| class_just_class Identifier {
    vector<string> mod;
    Class* classs =  new Class($2,mod,yylineno);
    global_sym_table->insert(classs);
    global_sym_table->makeTable($2);
    mycode->makeBlock(mycode->quadruple.size(),$2);
  } 
  ClassDecTillTypeParameters {
    $$= new Node("ClassDeclaration"); 
    string t1=$1,t2=$2; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v); 
    $$->add($4->objects);
    global_sym_table->end_scope();
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
  curly_open ClassBodyDeclaration curly_close {string t1=$1,t2=$3; $$ =new Node("ClassBody"); vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)}; $$->add(v);}
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
    method->ifConstructor = true;
    global_sym_table->insert(method);
    global_sym_table->makeTable("cons_"+ $2->method->name);
    mycode->makeBlock(mycode->quadruple.size(),$2->method->name+".Constr");
    BeginEnd* myIns = new BeginEnd();
    myIns->arg1="\tBeginConstr";
    myIns->arg2 = $2->method->name;
    mycode->insert(myIns);
    for(auto i:method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;
    }

  } 
  ConstructorDeclarationEnd {
    $$=new Node("ConstructorDeclaration"); 
    string t=$1; 
    vector<Node*>v{new Node(mymap[t],t),$2}; $$->add(v); 
    $$->add($4->objects);
    global_sym_table->end_scope(); 
    BeginEnd* myIns = new BeginEnd();
    myIns->arg1="\tEndConstr";
    myIns->arg2 = $2->method->name;
    mycode->insert(myIns);
  }
| ConstructorDeclarator {

    Method* method = new Method($1->method->name,"",$1->method->parameters,{},yylineno);
    method->ifConstructor = true;
    global_sym_table->insert(method);
    global_sym_table->makeTable("cons_"+ $1->method->name);
    mycode->makeBlock(mycode->quadruple.size(),$1->method->name+".Constr");
    BeginEnd* myIns = new BeginEnd();
    myIns->arg1="\tBeginConstr";
    myIns->arg2 = $1->method->name;
    mycode->insert(myIns);
    for(auto i:method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;
    }
  } 
  ConstructorDeclarationEnd {
    $$=new Node("ConstructorDeclaration"); 
    vector<Node*>v{$1}; $$->add(v); 
    $$->add($3->objects);
    global_sym_table->end_scope(); 
    BeginEnd* myIns = new BeginEnd();
    myIns->arg1="\tEndConstr";
    myIns->arg2 = $1->method->name;
    mycode->insert(myIns);
    
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
    $$->variables.push_back($1->var);
    }
| ArgumentList comma Expression   {
    $$=new Node("Arglist");
    string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};
    $$->add(v);
    $$->variables=$1->variables;
    $$->variables.push_back($3->var);
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
    global_sym_table->end_scope();
    }
;

InstanceInitializer:
 {global_sym_table->makeTable();}
 Block {
  $$ = $2;
  global_sym_table->end_scope();
  }
;

Block:
  curly_open BlockStatements curly_close {
    $$=new Node("Block");
     string t1=$1,t2=$3;
      vector<Node*>v{(new Node(mymap[t1],t1)),$2,(new Node(mymap[t2],t2))};
       $$->add(v); 
      
       $$->index = (mycode->makeBlock($2->start));
       $$->result = mycode->getVar($$->index);
       $$->start = $2->start;

       }
| curly_open curly_close {
  $$=new Node("Block");
  string t1=$1,t2=$2;
  vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; 
  $$->add(v);
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

  $$->index = $1->index;
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
  }
| UnannType {$$=new Node(); 
  $$->add($1); 
  $$->method = new Method("",$1->type,{},{},yylineno);
  }
;

MethodDeclaration:
  MethodAndFieldStart MethodDeclarator {
    Method* _method = new Method($2->method->name,$1->method->ret_type,$2->method->parameters,$1->method->modifiers,yylineno);
    global_sym_table->insert(_method);
    global_sym_table->makeTable(global_sym_table->current_scope +"_"+ $2->method->name);
    mycode->makeBlock(mycode->quadruple.size(),$2->method->name);
    BeginEnd* myIns = new BeginEnd();
    myIns->arg1="\tBeginFunc";
    myIns->arg2 = "";
    mycode->insert(myIns);
    global_sym_table->current_symbol_table->isMethod=true;
    for(auto i:_method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;
    }
    cout<<"wow\n";
  }
  MethodDeclarationEnd {
    $$=new Node("MethodDeclaration"); 
    $$->add($1->objects); 
    $$->add($2->objects); 
    $$->add($4->objects); 
    global_sym_table->end_scope();
    BeginEnd* myIns = new BeginEnd();
    myIns->arg1="\tEndFunc";
    myIns->arg2 = $2->method->name;
    mycode->insert(myIns); 
    
    }

| Modifiers MethodHeader {
    Method* _method = new Method($2->method->name,$2->method->ret_type,$2->method->parameters,$1->var->modifiers,yylineno);
    global_sym_table->insert(_method);
    global_sym_table->makeTable(global_sym_table->current_scope +"_"+ $2->method->name);
    mycode->makeBlock(mycode->quadruple.size(),$2->method->name);
    BeginEnd* myIns = new BeginEnd();
    myIns->arg1="\tBeginFunc";
    myIns->arg2 = $2->method->name;
    mycode->insert(myIns);
    global_sym_table->current_symbol_table->isMethod=true;
    for(auto i:_method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;
    }
  }
  MethodDeclarationEnd {
    $$=new Node("MethodDeclaration"); 
    $$->add($1->objects); 
    $$->add($2);
     $$->add($4->objects);
     global_sym_table->end_scope();
     BeginEnd* myIns = new BeginEnd();
    myIns->arg1="\tEndFunc";
    myIns->arg2 = $2->method->name;
    mycode->insert(myIns); 
     }

| MethodHeader{
    Method* _method = new Method($1->method->name,$1->method->ret_type,$1->method->parameters,{},yylineno);
    global_sym_table->insert(_method);
    global_sym_table->makeTable(global_sym_table->current_scope +"_"+ $1->method->name);
    mycode->makeBlock(mycode->quadruple.size(),$1->method->name);
    BeginEnd* myIns = new BeginEnd();
    myIns->arg1="\tBeginFunc";
    myIns->arg2 = $1->method->name;
    mycode->insert(myIns);
    global_sym_table->current_symbol_table->isMethod=true;
    for(auto i:_method->parameters){
        i->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(i);
        global_sym_table->current_symbol_table->offset+=i->size;
    }
  } 
  MethodDeclarationEnd {
    $$=new Node("MethodDeclaration"); 
    $$->add($1); 
    $$->add($3->objects); 
    global_sym_table->end_scope();
    BeginEnd* myIns = new BeginEnd();
    myIns->arg1="EndFunc";
    myIns->arg2 = $1->method->name;
    mycode->insert(myIns); 
    
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
    $3->var->name = "_"+$3->var->name;
    $$->method->parameters.push_back($3->var);
    }
;

FormalParameter:
  FINAL UnannType VariableDeclaratorId {
  $$= new Node("FormalParameter"); 
  string t1=$1; vector<Node*>v{(new Node(mymap[t1],t1)),$2,$3}; 
  $$->add(v);
  $$->var=$3->var;
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
    $$->var->type = $1->type;
    if(typeToSize.find($$->var->type)!=typeToSize.end())$$->var->size = typeToSize[$$->var->type];
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
  }
;

VariableArityParameter:
 dots Identifier {$$= new Node("VariableArityParameter"); string t1=$1,t2=$2; vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; $$->add(v);}
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
          // cout<<"MEko daanti\n";
          global_sym_table->typeCheckVar(i,$1->method->ret_type,yylineno);
        }
        
        Variable* varr = new Variable(i->name,$1->method->ret_type,$1->method->modifiers,yylineno,true,i->dims,i->dimsSize,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
        
        
      }
      else{
        cout<<"Meko daanti\n";
        if(i->type!=""){
          cout<<i->type<<endl;
          global_sym_table->typeCheckVar(i,$1->method->ret_type,yylineno);
        }
        Variable* varr = new Variable(i->name,$1->method->ret_type,yylineno,$1->method->modifiers,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
        cout<<varr->name<<"---- "<<varr->classs_name<<endl;
      }

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
  // cout<<"aab"<<$2<<endl;
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
    // cout<<"hi-- "<<$1->var->name<<" ";
    }
| VariableDeclaratorList comma VariableDeclarator { 
    $$=$1; 
    string t1=$2; 
    vector<Node*>v{new Node(mymap[t1],t1),$3}; 
    $$->add(v); 
    $$->variables.push_back($3->var);
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
    }
;

VariableDeclarator:
  Identifier {
    $$ = new Node("VariableDeclarator"); 
    string t1=$1; 
    vector<Node*>v{new Node(mymap[t1],t1)}; 
    $$->add(v);
    $$->var = new Variable($1,"",yylineno,{},"");
    }
| Identifier Dims {
    $$ = new Node("VariableDeclarator"); 
    string t1=$1; 
    vector<Node*>v{new Node(mymap[t1],t1),$2}; 
    $$->add(v);
    $$->var = new Variable($1,"",{},yylineno,true,$2->var->dims,$2->var->dimsSize,"");
    $$->dims = $2->dims;
  }
| Identifier assign VariableInitializer {
  // cout<<"---\n";
    $$ = new Node("VariableDeclarator"); 
    string t1=$1,t2=$2; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3}; 
    $$->add(v);                                                        //Change change
    if($3->dims!=0){
      throwError("TypeError: Cannot convert "+to_string($3->dims)+" dimensional Array to "+$3->type+"\n",yylineno );
    }
    $$->var = new Variable($1,$3->type,yylineno,{},$3->var->value);
    if($3->isObj)$$->var->classs_name = $3->anyName;
    $$->dims=$3->dims;
    cout<<"---huu\n"<<$$->dims;
    cout<<$3->result<<endl;
    $$->index = mycode->insertAss($3->result,"","",$1);
    // $$->result = $3->result;
  }
| Identifier Dims assign VariableInitializer {                        // Change change
    $$ = new Node("VariableDeclarator"); 
    string t1=$1,t2=$3; 
    vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4}; 
    $$->add(v);
    if($2->var->dims!=$4->dims){
      throwError("TypeError: Cannot convert "+to_string($4->dims)+" dimensional Array to "+to_string($2->var->dims)+" dimesions",yylineno );
    }
    $$->var = new Variable($1,$4->type,{},yylineno,true,$2->var->dims,$4->var->dimsSize,$4->var->value);
    $$->dims=$4->dims;
    cout<<"hurrahii"<<$$->type<<endl;
    $$->index = mycode->insertAss($4->result,"","",$1);
    // $$->result = $4->result;
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
    cout<<"$$\n";
    cout<<"$"<<$1->var->name<<"\n";
  } // $$->add($1);
| ArrayInitializer {
    // $$ = new Node();
    $$ = $1;
    $$->dims++;
    } // 
; 

TypeParameters:
  less_than TypeParameterList greater_than {$$=new Node("TypeParameters"); string t1=$1,t2=$3; $$->add(new Node(mymap[t1],t1)); $$->add($2->objects); $$->add(new Node(mymap[t2],t2));}
;

ClassExtends:
  extends ClassType {$$ = new Node(); string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2);}
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
| ArrayType {$$=$1;cout<<"Array"<<$$->dims<<"\n";}
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
  {indd = mycode->quadruple.size(); } AssignmentExpression {$$=$2; $$->lineno=yylineno;cout<<"maiyaha"; $$->start = indd;}
;

AssignmentExpression: 
Assignment                {$$=$1;  }
| ConditionalExpression   {$$=$1; if($$->var!=NULL&& $$->var->type!="")$$->type=$1->var->type; }
;

Assignment:
  LeftHandSide AssignmentOperator Expression  {
    $$=new Node("Assignment");
    vector<Node*>v{$1,$2,$3};
    $$->add(v);
    if($1->type!=$3->type){
      throwError("cannot convert from "+ $3->type + " to " + $1->type ,yylineno);
    }
    if($1->dims!=$3->dims){
      throwError("Cannot convert from "+ to_string($3->dims)+" dimensions to "+to_string($1->dims)+" dimensions",yylineno);
      
    }
    $$->type=$1->type;
    $$->var = $3->var;
    cout<<"$@@@"<<$2->lexeme;
    string x = "";
    x+=($2->lexeme)[0];
    if($2->lexeme=="=")$$->index = mycode->insertAss($3->result,"","",$1->result);
    else $$->index = mycode->insertAss($3->result,$1->result,x,$1->result);
    $$->start = $$->index;
    $$->result = $1->result;
    }
;

/* fixme */
LeftHandSide:
FieldAccess      {$$=$1;}
| TypeName       {$$=$1;}
| ArrayAccess    {$$=$1;}
;

FieldAccess:
Primary dot Identifier              {
  $$=new Node("FieldAccess");
  string t1=$2,t2=$3;
  vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};
  $$->add(v);
  if($1->type=="Class"){
    $$->var=global_sym_table->lookup_var($3,1,$1->anyName);
    $$->type = $$->var->type;
  }

  cout<<"ab naa hoga"; 
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
  literal                           {$$=$1;$$->result = $1->var->value;}
| ClassLiteral                      {$$=$1;}
| THIS                              {
    string t1=$1; 
    $$= new Node(mymap[t1],t1);
    SymbolTable* temp;
    temp=global_sym_table->current_symbol_table;
    while(temp->parent->scope!="Yayyy"){
      temp=temp->parent;
    }
    t1= temp->scope;
    $$->cls= global_sym_table->lookup_class(t1,0,global_sym_table->current_scope);
    $$->type="Class";
    $$->anyName = $$->cls->name;

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
    }
| FieldAccess                       {$$=$1;} 
| ArrayAccess                       {$$=$1;} 
| MethodInvocation                  {$$=$1;} 
| ClassInstanceCreationExpression   {$$=$1;cout<<"tukaha\n";$$->var=new Variable("","",yylineno,{},"");} 
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
    Variable *var = global_sym_table->lookup_var($1,0,global_sym_table->current_scope);
    // Class* cls = global_sym_table->lookup_class($1,1,global_sym_table->current_scope);
    if(cls!=NULL){
      $$->cls = cls;
      $$->type = "Class";
      if(cls->name=="String"){
        $$->type="String";
      }
      $$->anyName = $$->cls->name;
    }
    else if(met !=NULL){
      $$->method = met;
      $$->type = met->ret_type;
      $$->anyName=$$->method->name;
    }
    else if(var!=NULL){
      $$->var = var;
      $$->type = var->type;
      $$->anyName = var->classs_name;
      $$->dims = var->dims;
      if($$->type!="Class"){
        
        $$->anyName=$$->var->name;
      }
      
    }
    else {
      throwError("Variable "+t1 + "not declared in appropriate scope",yylineno);
    }

    $$->result = $1;
    
    // exit(1);
    }
| TypeName dot Identifier {
    $$=$1; 
    string t1=$2,t2=$3; 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; 
    $$->add(v);
    Class* cls = global_sym_table->lookup_class($3,0,$1->anyName);
    Method* met = global_sym_table->lookup_method($3,0,$1->anyName);
    Variable *var = global_sym_table->lookup_var($3,0,$1->anyName);
    if(cls!=NULL){
      $$->cls = cls;
      $$->type = "Class";
      $$->anyName = cls->name;

    }
    else if(met !=NULL){
      $$->method = met;
      $$->type = met->ret_type;
    }
    else if(var!=NULL){
      $$->var = var;
      $$->type = var->type;
      $$->dims = var->dims;
    }
    else {
      throwError("Variable "+t2+" not declared in appropriate scope",yylineno);
    }

    $$->result = $1->result;
    
  }
;

ArrayAccess:
  Identifier box_open Expression box_close{
    $$=new Node("ArrayAcc");
    string t1=$1,t2=$2,t4=$4;
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3,new Node(mymap[t4],t4)};
    $$->add(v);
    Variable* v1 = global_sym_table->lookup_var($1,1,global_sym_table->current_scope);
    if(v1->isArray==false){
      throwError(t1+"is not of type Array",yylineno);
    }
    if($3->type!="int"){
      throwError("Array index cannot be of type "+$3->type,yylineno);
    }
    $$->var= v1;
    $$->dims=v1->dims-1;
    $$->type = v1->type;
  }
| TypeName dot Identifier box_open Expression box_close  {
    $$=new Node("ArrayAcc");
    string t2=$2,t3=$3,t4=$4,t6=$6;
    vector<Node*>v{$1,new Node(mymap[t2],t2),new Node(mymap[t3],t3),new Node(mymap[t4],t4),$5,new Node(mymap[t6],t6)};
    $$->add(v);
    Variable* v1 = global_sym_table->lookup_var($3,1,$1->cls->name);
    if(v1->isArray==false){
      throwError(t3+" is not of type Array",yylineno);
    }
    $$->var= v1;
    $$->dims=v1->dims-1;

    }
| PrimaryNoNewArray box_open Expression box_close    {
    $$=new Node("ArrayAcc");
    string t1=$2,t2=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),$3,new Node(mymap[t2],t2)};
    $$->add(v);
    $$->var = $1->var;
    $$->cls = $1->cls;
    $$->method = $1->method;
    $$->type= $1->type;
    cout<<"kkk";
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
    ConditionalOrExpression                                                          {$$=$1;}
    | ConditionalOrExpression ques_mark Expression colon ConditionalExpression       {string t1=$2,t2=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),$3,new Node(mymap[t2],t2),$5};$$->add(v);}
    ;

ConditionalOrExpression:
    ConditionalAndExpression                                                         {$$=$1;}
  | ConditionalOrExpression OR ConditionalAndExpression                            {
      string t2=$2;$$=new Node("ConditionalExpression");
      vector<Node*>v{$1,new Node(mymap[t2],$2),$3};$$->add(v); 

      $$->lineno=yylineno;
      global_sym_table->typeCheckVar($1->var, $3->var,$$->lineno);
      global_sym_table->typeCheckVar($1->var, "boolean",$$->lineno);
      $$->var=new Variable("","boolean",yylineno,{},"");
      $$->index = mycode->insertAss($1->result,$3->result,$2);
      $$->start = $1->start;
      $$->result = mycode->getVar($$->index);
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

      map<string,int>priority;
      priority["int"]=0;
      priority["char"]=0;
      priority["float"]=1;
      priority["double"]=2;
      priority["String"]=3;

      if(priority.find($1->var->type)==priority.end() || priority.find($3->var->type)==priority.end()){
        throwError("bad operand types for additive operator on line number",yylineno);
      }

      int x1 = max(priority[$1->var->type],priority[$3->var->type]);

      if(x1==0) $$->var=new Variable("","int",yylineno,{},"");
      else if(x1==1) $$->var=new Variable("","float",yylineno,{},"");
      else if(x1==2) $$->var=new Variable("","double",yylineno,{},"");
      else if(x1==3) $$->var=new Variable("","String",yylineno,{},"");

      $$->index = mycode->insertAss($1->result,$3->result,$2);
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
      map<string,int>priority;
      priority["int"]=0;
      priority["char"]=0;
      priority["float"]=1;

      if(priority.find($1->var->type)==priority.end() || priority.find($3->var->type)==priority.end()){
        throwError("bad operand types for additive operator on line number",yylineno);
      }

      int x1 = max(priority[$1->var->type],priority[$3->var->type]);

      if(x1==0) $$->var=new Variable("","int",yylineno,{},"");
      else if(x1==1) $$->var=new Variable("","float",yylineno,{},"");

      $$->index = mycode->insertAss($1->result,$3->result,$2);
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

        $$->index = mycode->insertAss(t1+"1",$2->result,"*");
        $$->start = $2->start;
        $$->result = mycode->getVar($$->index);
    }
    ;

PreIncrDecrExpression:
    INCR_DECR UnaryExpression                                                        {
      string t1=$1;
      $$=new Node("ConditionalExpression");
      vector<Node*>v{new Node(mymap[t1],$1),$2};
      $$->add(v); 
      $$->var=new Variable("",$2->var->type,yylineno,{},"");

      $$->index = mycode->insertAss($2->result,"1","+",$2->result);
      $$->start = $2->start;
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

      if($2->var->type=="boolean"){
        $$->index = mycode->insertAss($2->result,$1,"");
      }
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

    $$->index = mycode->insertAss($1->result,"","");
    $$->start = $1->start;
    mycode->insertAss($1->result,"1","+",$1->result);
    $$->result = mycode->getVar($$->index);
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
| brac_open ClassType dot TypeName brac_close UnaryExpressionNotPlusMinus         {
  $$=new Node("CastExp");
  string t1=$1,t2=$3;
  vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4};
  $$->add(v);
  $$->var=new Variable("",t2,yylineno,{},$6->var->value);
  }
| brac_open ReferenceType AdditionalBound brac_close UnaryExpressionNotPlusMinus  {
  $$=new Node("CastExp");
  string t1=$1,t2=$4;
  vector<Node*>v{new Node(mymap[t1],t1),$2,$3,new Node(mymap[t2],t2),$5};
  $$->add(v); 
  $$->var=new Variable("",$2->var->type,yylineno,{},"");
  }
;

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
    Method* method;
    if($1->method->name==""){
      method = global_sym_table->lookup_method($1->method->name,1,global_sym_table->current_scope);
    } 
    else {
      method = $1->method;
    }
    if(method->parameters.size()!=$3->variables.size()){
      cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<$3->variables.size()<<endl;
      exit(1);
    }
    for(int i=0;i<method->parameters.size();i++){
      if(method->parameters[i]->type!=$3->variables[i]->type){
        cout<<"TypeError: Expected type of argument[" <<i+1<<"] :"<< method->parameters[i]->type<<", Found: "<<$3->variables[i]->type<<endl;
        exit(1);
      }
    }
    $$->type= method->ret_type;
    $$->method=method;

    }
| TypeName brac_open brac_close                                                      {
    $$=new Node("MethodInvocation");
    string t2=$2,t3=$3;
    vector<Node*>v{$1,new Node(mymap[t2],t2),new Node(mymap[t3],t3)};
    $$->add(v);  Method* method;
    if($1->method->name==""){
      method = global_sym_table->lookup_method($1->method->name,1,global_sym_table->current_scope);
    } 
    else {
      method = $1->method;
    }
    if(method->parameters.size()!=0){
      cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<0<<endl;
      exit(1);
    }
    $$->type= method->ret_type;
    $$->method=method;
    }
| MethodIncovationStart TypeArguments Identifier  brac_open ArgumentList brac_close    {$$=new Node("MethodInvocation");string t1=$3,t2=$4,t3=$6;$$->add($1->objects); vector<Node*>v{$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2),$5,new Node(mymap[t3],t3)};$$->add(v);}
| MethodIncovationStart TypeArguments Identifier  brac_open brac_close                 {$$=new Node("MethodInvocation");string t1=$3,t2=$4,t3=$5;$$->add($1->objects); vector<Node*>v{$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| MethodIncovationStart Identifier  brac_open brac_close                               {
    $$=new Node("MethodInvocation");
    string t1=$2,t2=$3,t3=$4;
    $$->add($1->objects); 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};
    $$->add(v); 
    Method* method = global_sym_table->lookup_method($2,1,$1->cls->name);
    if(method->parameters.size()!=0){
        cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<0<<endl;
        exit(1);
      }
    $$->type= method->ret_type;
    $$->method=method;
    
  }
| MethodIncovationStart Identifier  brac_open ArgumentList brac_close                  {
    $$=new Node("MethodInvocation");
    string t1=$2,t2=$3,t3=$5;
    $$->add($1->objects); 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$4,new Node(mymap[t3],t3)};
    $$->add(v);
    Method* method = global_sym_table->lookup_method($2,1,$1->cls->name);
    if(method->parameters.size()!=$4->variables.size()){
      cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<$4->variables.size()<<endl;
      exit(1);
    }
    for(int i=0;i<method->parameters.size();i++){
      if(method->parameters[i]->type!=$4->variables[i]->type){
        cout<<"TypeError: Expected type of argument[" <<i+1<<"] :"<< method->parameters[i]->type<<", Found: "<<$4->variables[i]->type<<endl;
        exit(1);
      }
    }
    $$->type= method->ret_type;
    $$->method=method;
    }
  | Primary dot Identifier brac_open ArgumentList brac_close {
    $$=new Node("MethodInvocation");
    string t1=$2,t2=$3,t3=$4,t6=$6;
    $$->add($1->objects); 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),$5,new Node(mymap[t6],t6)};
    $$->add(v); 
    Method* method = global_sym_table->lookup_method($3,1,$1->cls->name);
    if(method->parameters.size()!=$5->variables.size()){
      cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<$5->variables.size()<<endl;
      exit(1);
    }
    for(int i=0;i<method->parameters.size();i++){
      if(method->parameters[i]->type!=$5->variables[i]->type){
        cout<<"TypeError: Expected type of argument[" <<i+1<<"] :"<< method->parameters[i]->type<<", Found: "<<$5->variables[i]->type<<endl;
        exit(1);
      }
    }
    $$->type= method->ret_type;
    $$->method=method;
  }
  | Primary dot Identifier brac_open brac_close {
    $$=new Node("MethodInvocation");
    string t1=$2,t2=$3,t3=$4,t6=$5;
    $$->add($1->objects); 
    vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),new Node(mymap[t6],t6)};
    $$->add(v); 
    Method* method = global_sym_table->lookup_method($3,1,$1->cls->name);
    if(method->parameters.size()!=0){
        cout<<"Error: Expected number of arguments: "<<method->parameters.size()<<" Found: "<<0<<endl;
        exit(1);
      }
    $$->type= method->ret_type;
    $$->method=method;
  }
; 

MethodIncovationStart:
  TypeName dot                   {$$=new Node("MethodIncovationStart");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);}
| super dot                      {$$=new Node("MethodIncovationStart");string t1=$1,t2=$2;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v); }
| TypeName dot super dot         {$$=new Node("MethodIncovationStart");string t1=$2,t2=$3,t3=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
;

ClassInstanceCreationExpression:
  UnqualifiedClassInstanceCreationExpression                {$$=$1;$$->isObj = true;cout<<"maiyaha\n";}
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
    }
;

UnqualifiedClassInstanceCreationExpressionAfter_bracopen:
  ArgumentList brac_close ClassBody      {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
| brac_close ClassBody                   {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v); cout<<"UnqualifiedClassInstanceCreationExpressionAfter_bracopen\n";}
| brac_close                             {string t1=$1; $$=new Node(mymap[t1],t1);}
| ArgumentList brac_close                {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);}
;

ClassOrInterfaceTypeToInstantiate:
 Identifier                                                 {
    string t1=$1; 
    $$=(new Node(mymap[t1],t1));
     
    $$->cls = global_sym_table->lookup_class($1,1,global_sym_table->current_scope);
    $$->type = "Class";
    cout<<$$->cls->name<<"bana";
    

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

     if($3->type=="boolean" || $3->type=="NULL"){
      "invalid type to print. \n";
      exit(1);
     }

     }
;

StatementWithoutTrailingSubstatement:
{if(global_sym_table->isForScope==false)global_sym_table->makeTable();global_sym_table->isForScope=false;} 
  Block {
    $$=$2;
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
BREAK  semi_colon                        {$$= new Node("BreakStatement");string t1= $1,t2=$2; $$->add(new Node(mymap[t1],t1));$$->add(new Node(mymap[t2],t2));}
| BREAK Identifier semi_colon             {$$= new Node("BreakStatement"); string t1= $1, t2=$2,t3=$3; $$->add(new Node(mymap[t1],t1));$$->add(new Node(mymap[t2],t2)); $$->add(new Node(mymap[t3],t3));}
;

ContinueStatement:
CONTINUE semi_colon                     {$$= new Node("ContinueStatement");string t1= $1,t2=$2; $$->add(new Node(mymap[t1],t1));$$->add(new Node(mymap[t2],t2));}
| CONTINUE Identifier semi_colon           {$$= new Node("ContinueStatement"); string t1= $1, t2=$2,t3=$3; $$->add(new Node(mymap[t1],t1));$$->add(new Node(mymap[t2],t2)); $$->add(new Node(mymap[t3],t3));}
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
  cout<<"----\n";
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

  if(!mycode->quadruple[$5->index]->isBlock) $5->result = mycode->getVar(mycode->makeBlock($5->start));
  $$->index = mycode->insertIf($3->index,$3->result,$5->result,"");
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

  cout<<endl<<$7->start<<endl;

  if(!mycode->quadruple[$7->index]->isBlock) $7->result = mycode->getVar(mycode->makeBlock($7->start));
  if(!mycode->quadruple[$5->index]->isBlock) $5->result = mycode->getVar(mycode->makeBlock($5->start));
  $$->index = mycode->insertIf($3->index,$3->result,$5->result,$7->result);

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

  if(!mycode->quadruple[$7->index]->isBlock) $7->result = mycode->getVar(mycode->makeBlock($7->start));
  if(!mycode->quadruple[$5->index]->isBlock) $5->result = mycode->getVar(mycode->makeBlock($5->start));
  $$->index = mycode->insertIf($3->index,$3->result,$5->result,$7->result);

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
      }
;

ForStatement:
BasicForStatement                                                      {$$=new Node("ForStatement"); $$->add($1);global_sym_table->end_scope(); }
| EnhancedForStatement                                                 {$$=new Node("ForStatement"); $$->add($1);global_sym_table->end_scope();}
;

ForStatementNoShortIf:
BasicForStatementNoShortIf {$$=$1;}
| EnhancedForStatementNoShortIf {$$=$1;}
;

BasicForStatement:
BasicForStatementStart Statement                                       {$$=new Node("BasicForStatement"); $$->add($1->objects); $$->add($2);}
;

BasicForStatementNoShortIf:
BasicForStatementStart StatementNoShortIf                              {$$=new Node("BasicForStatementNoShortIf"); $$->add($1->objects); $$->add($2);}

BasicForStatementStart:
forr brac_open semi_colon semi_colon brac_close                         {
  $$ = new Node();
   string t1= $1,t2=$2,t3=$3, t4=$4, t5=$5; 
   vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), new Node(mymap[t4], $4), new Node(mymap[t5], $5) };
   $$->add(v);
   }
| forr brac_open ForInit semi_colon semi_colon brac_close               {
  $$ = new Node();
   string t1= $1,t2=$2,t4=$4, t5=$5, t6=$6; 
   vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), new Node(mymap[t5], $5), new Node(mymap[t6], $6) };
     $$->add(v);
      } 
| forr brac_open semi_colon Expression semi_colon brac_close            {
  $$ = new Node(); string t1= $1,t2=$2,t3=$3, t5=$5, t6=$6;
   vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), $4, new Node(mymap[t5], $5), new Node(mymap[t6], $6) };
  $$->add(v); 
  $$->lineno=$4->lineno;
  global_sym_table->typeCheckVar($4->var,"boolean",$$->lineno);
  }
| forr brac_open semi_colon semi_colon ForUpdate brac_close             {
  $$ = new Node(); string t1= $1,t2=$2,t3=$3, t4=$4, t6=$6;
   vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6) };
   $$->add(v);
   }
| forr brac_open semi_colon Expression semi_colon ForUpdate brac_close  {
  $$ = new Node(); string t1= $1,t2=$2,t3=$3, t5=$5, t7=$7;
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), $4, new Node(mymap[t5], $5), $6, new Node(mymap[t7], $7) }; 
  $$->add(v);
  $$->lineno=$4->lineno;
  global_sym_table->typeCheckVar($4->var,"boolean",$$->lineno);
  }
| forr brac_open ForInit semi_colon semi_colon ForUpdate brac_close     {
  $$ = new Node(); 
  string t1= $1,t2=$2,t4=$4, t5=$5, t7=$7;
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), new Node(mymap[t5], $5), $6, new Node(mymap[t7], $7) };
  $$->add(v);
  }
| forr brac_open ForInit semi_colon Expression semi_colon brac_close    {
  $$ = new Node();
  string t1= $1,t2=$2,t4=$4, t6=$6, t7=$7;
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6),new Node(mymap[t7], $7) };
  $$->add(v); 
  $$->lineno=$5->lineno;
  global_sym_table->typeCheckVar($5->var,"boolean",$$->lineno);
  }
| forr brac_open ForInit semi_colon Expression semi_colon ForUpdate brac_close {
  $$ = new Node(); 
  string t1= $1,t2=$2,t4=$4, t6=$6, t8=$8; 
  vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6), $7, new Node(mymap[t8], $8) };
  $$->add(v);
  $$->lineno=$5->lineno;
  global_sym_table->typeCheckVar($5->var,"boolean",$$->lineno);
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
StatementExpression {$$= new Node("StatementExpressionList"); $$->add($1);}
| StatementExpressionList comma StatementExpression  {$$ = $1; string t1 = $2; $$->add(new Node(mymap[t1],$2));$$->add($3);}
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
  }
;

LocalVariableDeclaration:
LocalVariableType VariableDeclaratorList {
  $$= new Node ("LocalVariableDeclaration"); 
  $$->add($1->objects); 
  $$->add($2);
  $$->type = $1->type;
  $$->dims = $1->dims+ $2->dims;
  cout<<"Whyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy";
  cout<<"hurrah"<<$$->dims<<endl;
  for(auto i:$2->variables){
      if(i->isArray){
        if(i->type!=""){
          cout<<"---iswaleme\n";
          global_sym_table->typeCheckVar(i,$1->type,yylineno);
        }
        cout<<i->dimsSize.size()<<"sizeeee";
        Variable* varr = new Variable(i->name,$1->type,{},yylineno,true,i->dims,i->dimsSize,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
        $$->variables.push_back(varr);
        cout<<varr->name<<"-- "<<varr->classs_name<<endl;
        
      }
      else{
        
        if(i->type!=""){
          // cout<<"MEko daanti\n";
          global_sym_table->typeCheckVar(i,$1->type,yylineno);
        }
        Variable* varr = new Variable(i->name,$1->type,yylineno,{},i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
        $$->variables.push_back(varr);
        cout<<varr->name<<"-- "<<varr->classs_name<<endl;
      }

    }
  }
| Modifiers LocalVariableType VariableDeclaratorList {
    $$= new Node ("LocalVariableDeclaration"); 
    $$->add($1->objects); 
    $$->add($2->objects); 
    $$->add($3);
    for(auto i:$3->variables){
      if(i->isArray){
        if(i->type!=""){
          // cout<<"MEko daanti\n";
          global_sym_table->typeCheckVar(i,$1->type,yylineno);
        }
        
        Variable* varr = new Variable(i->name,$2->type,$1->var->modifiers,yylineno,true,i->dims,i->dimsSize,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
        
      }
      else{
        if(i->type!=""){
          // cout<<"MEko daanti\n";
          global_sym_table->typeCheckVar(i,$1->type,yylineno);
        }

        Variable* varr = new Variable(i->name,$2->type,yylineno,$1->var->modifiers,i->value);
        varr->classs_name=i->classs_name;
        varr->offset = global_sym_table->current_symbol_table->offset;
        global_sym_table->insert(varr);
        global_sym_table->current_symbol_table->offset+=varr->size;
      }

    }

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
  }
| newprimtype ArrayCreationExpressionAfterType {
  $$= new Node("ArrayCreationExpression"); 
  $$->add($1->objects); 
  $$->add($2->objects); 
  $$->dims = $2->dims;
  $$->type = $1->type;
  $$->var = $2->var;
  // cout<<"yyy"<<$$->type<<endl;
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
    }
| Dims ArrayInitializer {$$=new Node(); $$->add($1);$$->add($2);}
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
  cout<<$2->var->value<<"lexeme"<<endl;
  ss.push_back((int)stoi($2->var->value));
  $$->var = new Variable("","",{},yylineno,true,1,ss,$2->var->value);
  $$->dims=1;
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
    $$->var= new Variable("","",yylineno,{},"");
    // $$->var->isArray=true;
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
      $$->var= new Variable("","",yylineno,{},"");
      }
;

VariableInitializerList:
VariableInitializer {
  $$= new Node("VariableInitializerList"); 
  $$->add($1);
  // $$->variables.push_back($1->var);
  $$->type=$1->type;
  cout<<"yyyy"<<$$->type;
  $$->dims = $1->dims;
  }
| VariableInitializerList comma VariableInitializer {
  $$= $1; 
  string t1=$2;  
  $$->add(new Node(mymap[t1],$2)); 
  $$->add($3);
  cout<<"hi\n" ;
  if($1->type!=$3->type) throwError("kuch  bhi ",yylineno);
  cout<<"::mo2\n";
  // $$->variables.push_back($3->var);
  
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
    if (argc == 3)
	{
		set_input_file(argv[1]);
    fout.open(argv[2]);
	}
  else{
    fout.open("graph.dot");
  }
	
	yyparse();

    /* printf("%d %d %d %d\n",titles,paras,words,sentences)); */
    /* fout<<titles<<" "<<paras<<" "<<words<<" "<<sentences<<endl; */

    mycode->print();

    return 0;
}

int yyerror (char const *s)
{
  return yyerror(string(s));
}