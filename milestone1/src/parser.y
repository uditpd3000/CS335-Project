%{  
#include <bits/stdc++.h>
#include "nodes.cpp"
using namespace std;

extern int yyparse();
extern map<string, string> mymap;
extern void insertMap(string, string );
int yylex (void);
int yyerror (char const *);

extern void set_input_file(const char* filename);
extern void set_output_file(const char* filename);
extern void close_output_file();

int num=0;

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

/* {} 0 or more
[] 0 or 1*/

%}

%union{
  char* sym;
  Node* node;
}
 
%token<sym> curly_open curly_close class_access STATIC FINAL key_SEAL key_abstract key_STRICTFP field_modifier method_modifier
%token<sym> box_open box_close dot dots less_than greater_than comma ques_mark bitwise_and at colon OR brac_open brac_close bitwise_xor bitwise_or assign semi_colon
%token<sym> class_just_class literal_type AssignmentOperator1 boolean literal keyword throws var
%token<sym> Identifier extends super implements permits IMPORT DOT_STAR
%token<sym> ARITHMETIC_OP_ADDITIVE ARITHMETIC_OP_MULTIPLY LOGICAL_OP Equality_OP INCR_DECR VOID THIS AND EQUALNOTEQUAL SHIFT_OP INSTANCE_OF RELATIONAL_OP1 NEW THROW RETURN CONTINUE FOR IF ELSE WHILE BREAK PRINTLN

%type<node> input
%type<node> ClassDeclaration ClassBody ClassPermits InterfaceTypeList ClassType ClassBodyDeclaration
%type<node> ClassDecTillPermits ClassDecTillImplements ClassImplements ClassDecTillExtends ClassDecTillTypeParameters ClassExtends
%type<node> StaticInitializer 
%type<node> ClassMemberDeclaration MethodAndFieldStart FieldDeclaration
%type<node> TypeArguments TypeArgumentList TypeArgument TypeName TypeParameters TypeParameterList TypeParameter TypeBound
%type<node> WildcardBounds ReferenceType ArrayType Dims PrimitiveType AdditionalBound
%type<node> UnannArrayType UnannPrimitiveType UnannReferenceType UnannType
%type<node> Block BlockStatements BlockStatement LocalVariableDeclaration LocalVariableType LocalClassOrInterfaceDeclaration InstanceInitializer
%type<node> VariableDeclarator VariableDeclaratorList VariableInitializer Modifiers CompilationUnit VariableInitializerList ArrayInitializer DimExpr DimExprs ArrayCreationExpression ArrayCreationExpressionAfterType newclasstype newprimtype WhileStatement EnhancedForStatementNoShortIf
%type<node> StatementExpressionList ForInit ForUpdate BasicForStatement BasicForStatementNoShortIf BasicForStatementStart StatementExpression EnhancedForStatement ForStatement ForStatementNoShortIf WhileStatementNoShortIf LabeledStatementNoShortIf StatementNoShortIf IfThenElseStatement IfThenElseStatementNoShortIf IfThenStatement ExpressionStatement LabeledStatement
%type<node> StatementWithoutTrailingSubstatement ThrowStatement ReturnStatement ContinueStatement BreakStatement Statement
%type<node> ConstructorBody ConstructorBodyEnd ConstructorDeclaration ConstructorDeclarationEnd ConstructorDeclarator ConstructorDeclaratorStart ExplicitConstructorInvocation ConstructorDeclaratorEnd
%type<node> Throws ExceptionTypeList ExplicitConsInvTillTypeArgs ArgumentList ReceiverParameter FormalParameter FormalParameterList VariableDeclaratorId VariableArityParameter
%type<node> MethodDeclaration MethodDeclarationEnd MethodDeclarator MethodDeclaratorEnd MethodDeclaratorTillFP MethodDeclaratorTillRP MethodHeader MethodHeaderStart
%type<node> Assignment LeftHandSide AssignmentOperator AssignmentExpression ConditionalExpression Expression ConditionalOrExpression
%type<node> UnaryExpression InstanceofExpression PreIncrDecrExpression UnaryExpressionNotPlusMinus Primary PrimaryNoNewArray PostfixExpression CastExpression
%type<node> PostIncrDecrExpression ClassLiteral FieldAccess ArrayAccess MethodInvocation ClassInstanceCreationExpression RELATIONAL_OP
%type<node> Idboxopen Typenameboxopen squarebox MethodIncovationStart UnqualifiedClassInstanceCreationExpression
%type<node> ClassOrInterfaceTypeToInstantiate UnqualifiedClassInstanceCreationExpressionAfter_bracopen TypeArgumentsOrDiamond ClassOrInterfaceType2 ConditionalOrExpressionStart ConditionalOrExpressionEnd
%type<node> ImportDeclaration SingleTypeImportDeclaration SingleStaticImportDeclaration StaticImportOnDemandDeclaration ImportDeclarations


%type<sym> CommonModifier 

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

%error-verbose


%%

input: 
CompilationUnit {generate_graph($$);}
;

CompilationUnit: {$$= new Node("CompilationUnit");}
| CompilationUnit ClassDeclaration  { $$=$1; $$->add($2);}
| CompilationUnit ImportDeclarations ClassDeclaration  {$$=$1;vector<Node*>v{$2,$3};$$->add(v);}
;

ClassDeclaration:
  Modifiers class_just_class Identifier ClassDecTillTypeParameters {$$= new Node("ClassDeclaration"); $$->add($1->objects); string t1=$2,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); $$->add($4->objects); }
| class_just_class Identifier ClassDecTillTypeParameters {$$= new Node("ClassDeclaration"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); $$->add($3->objects); }
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
  class_access ConstructorDeclarator ConstructorDeclarationEnd {$$=new Node("ConstructorDeclaration"); string t=$1; vector<Node*>v{new Node(mymap[t],t),$2}; $$->add(v); $$->add($3->objects); }
| ConstructorDeclarator ConstructorDeclarationEnd {$$=new Node("ConstructorDeclaration"); vector<Node*>v{$1}; $$->add(v); $$->add($2->objects); }
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

/* fixme */
ArgumentList:
  Expression                      {$$=new Node("Arglist");vector<Node*>v{$1};$$->add(v);}
| ArgumentList comma Expression   {$$=new Node("Arglist");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
;

ConstructorDeclarator:
  ConstructorDeclaratorStart ConstructorDeclaratorEnd {$$ = new Node("ConstructorDeclarator"); $$->add($1->objects); $$->add($2->objects); }
;

ConstructorDeclaratorStart:
  TypeParameters Identifier brac_open {$$ = new Node(); string t1=$2,t2=$3; vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); }
| Identifier brac_open {$$ = new Node(); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); }
;

ConstructorDeclaratorEnd:
  ReceiverParameter FormalParameterList brac_close {$$ = new Node(); string t1=$3; vector<Node*>v{$1,$2,new Node(mymap[t1],t1)}; $$->add(v);}
| FormalParameterList brac_close {$$ = new Node(); string t1=$2; vector<Node*>v{$1,new Node(mymap[t1],t1)}; $$->add(v);}
| ReceiverParameter brac_close {$$ = new Node(); string t1=$2; vector<Node*>v{$1,new Node(mymap[t1],t1)}; $$->add(v); }
| brac_close {$$ = new Node(); string t1=$1; vector<Node*>v{new Node(mymap[t1],t1)}; $$->add(v); }
;

StaticInitializer:
  STATIC Block {string t1=$1; $$ =new Node("StaticInitializer");vector<Node*>v{new Node("Keyword",t1),$2};$$->add(v); }
;

InstanceInitializer:
 Block {$$ = $1;}
;

Block:
  curly_open BlockStatements curly_close {$$=new Node("Block"); string t1=$1,t2=$3; vector<Node*>v{(new Node(mymap[t1],t1)),$2,(new Node(mymap[t2],t2))}; $$->add(v);}
| curly_open curly_close {$$=new Node("Block"); string t1=$1,t2=$2; vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; $$->add(v);}
;

BlockStatements:
  BlockStatement {$$=new Node("BlockStatements"); $$->add($1); }
| BlockStatements BlockStatement {$$=$1; $$->add($2);}
;


BlockStatement:
  Assignment semi_colon {string t1=$2;$$=new Node("BlockStatement"); vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v); }
| LocalClassOrInterfaceDeclaration {$$ = new Node("LocalClassOrInterfaceDeclaration"); $$->add($1); }
| LocalVariableDeclaration semi_colon {$$ =$1; string t1=$2; $$->add(new Node(mymap[t1],t1));  }
| Statement { $$=new Node("BlockStatement"); $$->add($1);}
;

LocalVariableType:
  UnannType {$$=$1;}
| var {string t1= $1; $$=new Node(mymap[t1],t1);}
;

LocalClassOrInterfaceDeclaration:
  ClassDeclaration {$$=$1;}
;

/* ClassMemberDeclaration:
  FieldDeclaration
| MethodDeclaration
| ClassDeclaration
| InterfaceDeclaration
; */

ClassMemberDeclaration:
  FieldDeclaration {$$=$1; }
| MethodDeclaration {$$=$1; }
| ClassDeclaration {$$=$1; }
| semi_colon {string t1=$1; $$= new Node(mymap[t1],t1);}
;

MethodAndFieldStart:
Modifiers UnannType {$$=new Node(); $$->add($1); $$->add($2);}
| UnannType {$$=new Node(); $$->add($1);}
;

MethodDeclaration:
  MethodAndFieldStart MethodDeclarator MethodDeclarationEnd {$$=new Node("MethodDeclaration"); $$->add($1->objects); $$->add($2->objects); $$->add($3->objects); }
| Modifiers MethodHeader MethodDeclarationEnd {$$=new Node("MethodDeclaration"); $$->add($1->objects); $$->add($2); $$->add($3->objects); }
| MethodHeader MethodDeclarationEnd {$$=new Node("MethodDeclaration"); $$->add($1); $$->add($2->objects); }
;

MethodDeclarationEnd:
  Block {$$=$1;}
| semi_colon {string t1=$1; $$=new Node(mymap[t1],t1); }
;


MethodHeader:
  TypeParameters MethodHeaderStart {$$= new Node("MethodHeader"); $$->add($1); $$->add($2->objects);}
| MethodHeaderStart {$$= new Node("MethodHeader"); $$->add($1->objects); }
;

MethodHeaderStart:
 VOID MethodDeclarator {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2->objects); }
| VOID MethodDeclarator Throws {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2->objects); $$->add($3); }
;

Throws:
  throws ExceptionTypeList semi_colon {$$=new Node("Throws"); string t1=$1,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),}; $$->add(v); }
;

ExceptionTypeList:
  ClassType {$$= new Node("ExceptionTypeList"); $$->add($1);}
| ExceptionTypeList comma ClassType {$$=$1; string t1=$2; $$->add(new Node(mymap[t1],t1)); $$->add($3);}
;

MethodDeclarator:
  Identifier brac_open MethodDeclaratorTillRP {string t1=$1,t2=$2; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add(new Node(mymap[t2],t2)); $$->add($3->objects);}
;

MethodDeclaratorTillRP:
  UnannType ReceiverParameter MethodDeclaratorTillFP {$$=new Node(); $$->add($1); $$->add($2); $$->add($3->objects);}
| MethodDeclaratorTillFP {$$=new Node(); $$->add($1->objects);}
;

MethodDeclaratorTillFP:
  FormalParameterList MethodDeclaratorEnd {$$=new Node(); $$->add($1); $$->add($2->objects);}
| MethodDeclaratorEnd {$$=new Node(); $$->add($1->objects);}
;

MethodDeclaratorEnd:
  brac_close {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1));}
| brac_close Dims {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2);}
;

FormalParameterList:
  FormalParameter {$$= new Node("FormalParameterList"); $$->add($1);}
| FormalParameterList comma FormalParameter {$$=$1; string t1=$2; $$->add(new Node(mymap[t1],t1)); $$->add($3);}
;

FormalParameter:
  FINAL UnannType VariableDeclaratorId {$$= new Node("FormalParameter"); string t1=$1; vector<Node*>v{(new Node(mymap[t1],t1)),$2,$3}; $$->add(v);}
| UnannType VariableDeclaratorId {$$= new Node("FormalParameter"); vector<Node*>v{$1,$2}; $$->add(v);}
| VariableArityParameter {$$= $1;}
;


VariableDeclaratorId:
  Identifier Dims {$$= new Node("VariableDeclaratorId"); string t1=$1; vector<Node*>v{(new Node(mymap[t1],t1)),$2}; $$->add(v);}
| Identifier {$$= new Node("VariableDeclaratorId"); string t1=$1; vector<Node*>v{(new Node(mymap[t1],t1))}; $$->add(v); }
;

VariableArityParameter:
 dots Identifier {$$= new Node("VariableArityParameter"); string t1=$1,t2=$2; vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; $$->add(v);}
;

ReceiverParameter:
  THIS comma {$$ = new Node("ReceiverParameter"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); }
| Identifier dot THIS comma  {$$ = new Node("ReceiverParameter"); string t1=$1,t2=$2,t3=$3,t4=$4; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),new Node(mymap[t4],t4)}; $$->add(v);}
;

FieldDeclaration:
  MethodAndFieldStart VariableDeclaratorList semi_colon {string t1=$3; $$=new Node("FieldDeclaration"); $$->add($1->objects); vector<Node*>v{$2,new Node(mymap[t1],t1)}; $$->add(v);}
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
CommonModifier {string t1=$1; $$ = new Node("Modifiers"); $$->add(new Node(mymap[t1],t1));}
| Modifiers CommonModifier {$$=new Node("Modifiers"); $$->add($1->objects); string t1=$2; $$->add(new Node(mymap[t1],t1));}
;

VariableDeclaratorList:
  VariableDeclarator {$$= new Node("VariableDeclaratorList"); $$->add($1); }
| VariableDeclaratorList comma VariableDeclarator { $$=$1; string t1=$2; vector<Node*>v{new Node(mymap[t1],t1),$3}; $$->add(v); }
;

UnannType:
  UnannPrimitiveType {$$ = new Node("UnannType"); $$->add($1); }
| UnannReferenceType {$$ = new Node("UnannType"); $$->add($1); }
;

UnannPrimitiveType:
  boolean {string t1= $1; $$=new Node(mymap[t1],t1);}
| literal_type {string t1= $1; $$=new Node(mymap[t1],t1); }
;

UnannReferenceType:
  ClassType {$$=$1;}
// | Identifier {string t1= $1; $$=new Node(mymap[t1],t1);}
| UnannArrayType {$$=$1;}
;

UnannArrayType:
  UnannPrimitiveType Dims {$$ = new Node("UnannArrayType"); vector<Node*>v{$1,$2}; $$->add(v);}
| ClassType Dims {$$ = new Node("UnannArrayType"); vector<Node*>v{$1,$2}; $$->add(v);}
// | Identifier Dims {$$ = new Node("UnannArrayType"); string t1=$1; vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v);}
;

VariableDeclarator:
  Identifier {$$ = new Node("VariableDeclarator"); string t1=$1; vector<Node*>v{new Node(mymap[t1],t1)}; $$->add(v);}
| Identifier Dims {$$ = new Node("VariableDeclarator"); string t1=$1; vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v);}
| Identifier assign VariableInitializer {$$ = new Node("VariableDeclarator"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3}; $$->add(v);}
| Identifier Dims assign VariableInitializer {$$ = new Node("VariableDeclarator"); string t1=$1,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4}; $$->add(v);}
;

VariableInitializer:
  Expression {$$ = new Node("VariableInitializer"); $$->add($1);} // $$->add($1);
| ArrayInitializer {$$ = new Node();$$ = $1;} // 
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

ClassType:
TypeName {$$=new Node("ClassType"); $$->add($1);}
| TypeName TypeArguments {$$=new Node("ClassType"); vector<Node*>v{$1,$2}; $$->add(v);}
| ClassType dot Identifier {$$=new Node(); $$=new Node("ClassType"); string t1=$2,t2=$3; vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);}
| ClassType dot Identifier TypeArguments {$$=new Node("ClassType"); $$=new Node(); string t1=$2,t2=$3; vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2),$4}; $$->add(v);}
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
  PrimitiveType Dims   {$$=new Node("ArrayType"); $$->add($1); $$->add($2->objects);   }
| ClassType Dims       {$$=new Node("ArrayType"); $$->add($1->objects); $$->add($2->objects);  }
;

Dims:
 box_open box_close          {$$=new Node("Dims"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);}
| Dims box_open box_close    {$$=$1; string t1=$2,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);}
;

PrimitiveType:
  literal_type {string t1=$1; $$= new Node(mymap[t1],t1);}
;

Expression: 
  AssignmentExpression {$$=$1; }
;

AssignmentExpression: 
Assignment                {$$=$1;  }
| ConditionalExpression   {$$=$1; }
;

Assignment:
  LeftHandSide AssignmentOperator Expression  {$$=new Node("Assignment");vector<Node*>v{$1,$2,$3};$$->add(v);}
;

LeftHandSide:
FieldAccess      {$$=$1;}
| TypeName       {$$=$1;}
| ArrayAccess    {$$=$1;}
;

FieldAccess:
Primary dot Identifier              {$$=new Node("FieldAccess");string t1=$2,t2=$3;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v); }
| super dot Identifier              {$$=new Node("FieldAccess");string t1=$1,t2=$2,t3=$3;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| TypeName dot super dot Identifier {$$=new Node("FieldAccess");string t1=$2,t2=$3,t3=$4,t4=$5;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),new Node(mymap[t4],t4)};$$->add(v);}
;

/* fixmme */
Primary:
PrimaryNoNewArray                   {$$=$1;}
| ArrayCreationExpression           {$$=$1;}
;

PrimaryNoNewArray:
  literal                           {string t1=$1; $$= new Node(mymap[t1],t1);}
| ClassLiteral                      {$$=$1; }
| THIS                              {string t1=$1; $$= new Node(mymap[t1],t1);}
| TypeName dot THIS                 {$$=new Node("PrimaryNoNewArray");string t1=$2,t2=$3;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);}
| brac_open Expression brac_close   {$$=new Node("PrimaryNoNewArray");string t1=$1,t2=$3;vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)};$$->add(v);}
| FieldAccess                       {$$=$1;} 
| ArrayAccess                       {$$=$1;} 
| MethodInvocation                  {$$=$1;} 
| ClassInstanceCreationExpression   {$$=$1;} 
;

TypeName:
  Identifier {string t1=$1; $$=new Node("TypeName"); $$->add(new Node(mymap[t1],t1));}
| TypeName dot Identifier {string t1 =$2,t2=$3; $$=$1; vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; $$->add(v); }
;

Idboxopen:
Identifier box_open                {$$=new Node("IdboxOpen");string t1=$1,t2=$2;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);}
;

Typenameboxopen:
Idboxopen                           {$$=new Node("Typenameboxopen");$$->add($1->objects);}
| TypeName dot Idboxopen            {$$=new Node("Typenameboxopen");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);$$->add($3->objects);}
;

ArrayAccess:
Typenameboxopen Expression box_close                 {$$=new Node("ArrayAccess");$$->add($1->objects); string t1=$3;vector<Node*>v{$2,new Node(mymap[t1],t1)};$$->add(v);}
| PrimaryNoNewArray box_open Expression box_close    {$$=new Node("ArrayAccess"); string t1=$2,t2=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),$3,new Node(mymap[t2],t2)};$$->add(v);}
;

squarebox: 
  box_open box_close                                 {$$=new Node("squarebox");string t1=$1,t2=$2;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);}
| squarebox box_open box_close                       {$$=new Node("squarebox");string t1=$2,t2=$3;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);}
;

ClassLiteral : 
  TypeName squarebox dot class_just_class            {$$=new Node("ClassLiteral");string t1=$3,t2=$4;vector<Node*>v{$1,$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);}
| TypeName dot class_just_class                      {$$=new Node("ClassLiteral");string t1=$2,t2=$3;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v);}
| literal_type squarebox dot class_just_class        {$$=new Node("ClassLiteral");string t1=$1,t2=$3,t3=$4;vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| literal_type dot class_just_class                  {$$=new Node("ClassLiteral");string t1=$1,t2=$2,t3=$3;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| boolean squarebox dot class_just_class             {$$=new Node("ClassLiteral");string t1=$1,t2=$3,t3=$4;vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| boolean dot class_just_class                       {$$=new Node("ClassLiteral");string t1=$1,t2=$2,t3=$3;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| VOID dot class_just_class                          {$$=new Node("ClassLiteral");string t1=$1,t2=$2,t3=$3;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
;

ConditionalExpression: 
  ConditionalOrExpression                                                   { $$=$1;}
| ConditionalOrExpression ques_mark Expression colon ConditionalExpression  {string t1=$2,t2=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),$3,new Node(mymap[t2],t2),$5};$$->add(v);}
;

ConditionalOrExpressionStart:
  UnaryExpression               {$$=$1;}
| InstanceofExpression          {$$=$1;}
;

ConditionalOrExpression :
ConditionalOrExpressionStart                                           {$$=$1;}
| ConditionalOrExpressionStart ConditionalOrExpressionEnd              {$$=new Node("ConditionalOrExpression"); $$->add($1);$$->add($2->objects);}
;

ConditionalOrExpressionEnd:
  OR ConditionalOrExpression                      {$$=new Node(); string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v); }
| AND ConditionalOrExpression                     {$$=new Node(); string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v); }
| bitwise_or ConditionalOrExpression              {$$=new Node(); string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v); }
| bitwise_xor ConditionalOrExpression             {$$=new Node(); string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v); }
| bitwise_and ConditionalOrExpression             {$$=new Node(); string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v); }
| EQUALNOTEQUAL ConditionalOrExpression           {$$=new Node(); string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v); }
| RELATIONAL_OP ConditionalOrExpression           {$$=new Node(); vector<Node*>v{$1,$2}; $$->add(v); }
| SHIFT_OP ConditionalOrExpression                {$$=new Node(); string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v); }
| ARITHMETIC_OP_ADDITIVE ConditionalOrExpression  {$$=new Node(); string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v); }
| ARITHMETIC_OP_MULTIPLY ConditionalOrExpression  {$$=new Node(); string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2}; $$->add(v); }
;

UnaryExpression:
  PreIncrDecrExpression                     {$$=$1; }
| ARITHMETIC_OP_ADDITIVE UnaryExpression    {$$=new Node("UnaryExpression");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v);}
| UnaryExpressionNotPlusMinus               {$$=$1;}
;

PreIncrDecrExpression:
INCR_DECR UnaryExpression                   {$$=new Node("PreIncrDecrExpression");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v);}
;

UnaryExpressionNotPlusMinus:
  LOGICAL_OP UnaryExpression                {$$=new Node("UnaryExpressionNotPlusMinus");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v);}
| PostfixExpression                         {$$=$1;}
| CastExpression                            {$$=$1; }
;

PostfixExpression:
  Primary                                   {$$=$1; }
| TypeName                                  {$$=$1;}
| PostIncrDecrExpression                    {$$=$1;}
;

PostIncrDecrExpression:
  PostfixExpression INCR_DECR               {$$=new Node("PostIncrDecrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);}
;

RELATIONAL_OP :
RELATIONAL_OP1                   {string t1=$1;$$=(new Node(mymap[t1],t1));}
| greater_than                   {string t1=$1;$$=(new Node(mymap[t1],t1));}
| less_than                      {string t1=$1;$$=(new Node(mymap[t1],t1));}
;


CastExpression:
  brac_open literal_type brac_close UnaryExpression                               {$$=new Node("CastExpression");string t1=$1,t2=$2,t3=$3;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),$4};$$->add(v);}
| brac_open ReferenceType brac_close UnaryExpressionNotPlusMinus                  {$$=new Node("CastExpression");string t1=$1,t2=$3;vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4};$$->add(v);}
| brac_open ReferenceType AdditionalBound brac_close UnaryExpressionNotPlusMinus  {$$=new Node("CastExpression");string t1=$1,t2=$4;vector<Node*>v{new Node(mymap[t1],t1),$2,$3,new Node(mymap[t2],t2),$5};$$->add(v);}
;

AssignmentOperator:
assign                {string t1=$1; $$=new Node(mymap[t1],t1);}
| AssignmentOperator1 {string t1=$1; $$=new Node(mymap[t1],t1);}
;

InstanceofExpression:
  ConditionalOrExpression INSTANCE_OF ReferenceType                      {$$=new Node("InstanceofExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v); }
| ConditionalOrExpression INSTANCE_OF LocalVariableDeclaration  {$$=new Node("InstanceofExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
; 

MethodInvocation:
  TypeName brac_open ArgumentList brac_close                                         {$$=new Node("MethodInvocation");string t2=$2,t3=$4;vector<Node*>v{$1,new Node(mymap[t2],t2),$3,new Node(mymap[t3],t3)};$$->add(v);}
| TypeName brac_open brac_close                                                      {$$=new Node("MethodInvocation");string t2=$2,t3=$3;vector<Node*>v{$1,new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| MethodIncovationStart TypeArguments Identifier  brac_open ArgumentList brac_close    {$$=new Node("MethodInvocation");string t1=$3,t2=$4,t3=$6;$$->add($1->objects); vector<Node*>v{$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2),$5,new Node(mymap[t3],t3)};$$->add(v);}
| MethodIncovationStart TypeArguments Identifier  brac_open brac_close                 {$$=new Node("MethodInvocation");string t1=$3,t2=$4,t3=$5;$$->add($1->objects); vector<Node*>v{$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| MethodIncovationStart Identifier  brac_open brac_close                               {$$=new Node("MethodInvocation");string t1=$2,t2=$3,t3=$4;$$->add($1->objects); vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v); cout<<"methodinvocation\n";}
| MethodIncovationStart Identifier  brac_open ArgumentList brac_close                  {$$=new Node("MethodInvocation");string t1=$2,t2=$3,t3=$5;$$->add($1->objects); vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$4,new Node(mymap[t3],t3)};$$->add(v);}
;

MethodIncovationStart:
  TypeName dot                   {$$=new Node("MethodIncovationStart");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);}
| Primary dot                    {$$=new Node("MethodIncovationStart");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);}
| super dot                      {$$=new Node("MethodIncovationStart");string t1=$1,t2=$2;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v); }
| TypeName dot super dot         {$$=new Node("MethodIncovationStart");string t1=$2,t2=$3,t3=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
;

ClassInstanceCreationExpression:
  UnqualifiedClassInstanceCreationExpression                {$$=$1;}
| TypeName dot UnqualifiedClassInstanceCreationExpression   {$$=new Node("ClassInstanceCreationExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
| Primary dot UnqualifiedClassInstanceCreationExpression    {$$=new Node("ClassInstanceCreationExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
;

UnqualifiedClassInstanceCreationExpression:
  NEW TypeArguments ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen  {$$=new Node("UnqualifiedClassInstanceCreationExpression");string t1=$1,t2=$4;vector<Node*>v{new Node(mymap[t1],t1),$2,$3,new Node(mymap[t2],t2),$5};$$->add(v);}
| NEW ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen                {$$=new Node("UnqualifiedClassInstanceCreationExpression");string t1=$1,t2=$3;vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4};$$->add(v); }
;

UnqualifiedClassInstanceCreationExpressionAfter_bracopen:
  ArgumentList brac_close ClassBody      {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
| brac_close ClassBody                   {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v); cout<<"UnqualifiedClassInstanceCreationExpressionAfter_bracopen\n";}
| brac_close                             {string t1=$1; $$=new Node(mymap[t1],t1);}
| ArgumentList brac_close                {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);}
;

ClassOrInterfaceTypeToInstantiate:
 Identifier                                                 {string t1=$1; $$=(new Node(mymap[t1],t1)); }
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
StatementWithoutTrailingSubstatement     {$$= new Node("Statement");$$->add($1);}
| LabeledStatement                       {$$= new Node("Statement");$$->add($1);}
| IfThenStatement                        {$$= new Node("Statement");$$->add($1);}
| IfThenElseStatement                    {$$= new Node("Statement");$$->add($1);}
| WhileStatement                         {$$= new Node("Statement");$$->add($1);}
| ForStatement                           {$$= new Node("Statement");$$->add($1);}
| PRINTLN brac_open Expression brac_close semi_colon {$$= new Node("Statement");string t1=$1,t2=$2,t4=$4,t5=$5; vector<Node*>v {new Node(mymap[t1],$1),new Node(mymap[t2],$2), $3, new Node(mymap[t4],$4),new Node(mymap[t5],$5)}; $$->add(v);}
// | PRINTLN brac_open literal brac_close semi_colon {$$= new Node("Statement");string t1=$1,t2=$2,t3=$3,t4=$4,t5=$5; vector<Node*>v {new Node(mymap[t1],$1),new Node(mymap[t2],$2), new Node(mymap[t3],$3) , new Node(mymap[t4],$4),new Node(mymap[t5],$5)}; $$->add(v);}
;

StatementWithoutTrailingSubstatement:
Block                           {$$=$1;}
| semi_colon                    { string t1 = $1; $$=new Node(mymap[t1],$1);}
| ExpressionStatement           {$$=$1;}
| BreakStatement                {$$=$1;}
| ContinueStatement             {$$=$1;}
| ReturnStatement               {$$=$1;}
| ThrowStatement                {$$=$1;}
;

BreakStatement:
BREAK                            {$$= new Node("BreakStatement");string t1= $1;$$->add(new Node(mymap[t1],$1));}
| BREAK Identifier               {$$= new Node("BreakStatement"); string t1= $1, t2=$2; $$->add(new Node(mymap[t1],$1));$$->add(new Node(mymap[t2],$2));}
;

ContinueStatement:
CONTINUE                         {$$= new Node("ContinueStatement");string t1= $1;$$->add(new Node(mymap[t1],$1));}
| CONTINUE Identifier            {$$= new Node("ContinueStatement"); string t1= $1, t2=$2; $$->add(new Node(mymap[t1],$1));$$->add(new Node(mymap[t2],$2));}
;

ReturnStatement:
RETURN                           {$$= new Node("ReturnStatement");string t1= $1;$$->add(new Node(mymap[t1],$1));}
| RETURN Expression              {$$= new Node("ReturnStatement"); string t1= $1; $$->add(new Node(mymap[t1],$1));$$->add($2);}
;

ThrowStatement:
THROW Expression                 {$$= new Node("ThrowStatement"); string t1= $1; $$->add(new Node(mymap[t1],$1));$$->add($2);}
;

StatementExpression:
Assignment                       {$$=$1;}
| PreIncrDecrExpression          {$$=$1;}
| PostIncrDecrExpression         {$$=$1;}
| MethodInvocation               {$$=$1;}
| ClassInstanceCreationExpression{$$=$1;}
;

ExpressionStatement:
StatementExpression semi_colon                                                {$$ = new Node("ExpressionStatement"); string t2= $2; $$->add($1);$$->add(new Node(mymap[t2],$2));}
;

LabeledStatement:
Identifier colon Statement                                                    {$$= new Node("LabeledStatement"); string t1=$1, t2=$2; vector<Node*> v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3};$$->add(v);}
;
IfThenStatement:
IF brac_open Expression brac_close Statement                                  {$$ = new Node("IfThenStatement"); string t1 = $1,t2= $2,t4=$4; vector<Node*>v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3,new Node (mymap[t4],$4),$5 }; $$->add(v); }   
;

IfThenElseStatement:
IF brac_open Expression brac_close StatementNoShortIf ELSE Statement           {$$ = new Node("IfThenElseStatement"); string t1 = $1,t2= $2,t4=$4,t6=$6; vector<Node*>v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3,new Node (mymap[t4],$4),$5,new Node (mymap[t6],$6),$7 }; $$->add(v); }
;

IfThenElseStatementNoShortIf:
IF brac_open Expression brac_close StatementNoShortIf ELSE StatementNoShortIf  {$$ = new Node("IfThenElseStatementNoShortIf"); string t1 = $1,t2= $2,t4=$4,t6=$6; vector<Node*>v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3,new Node (mymap[t4],$4),$5,new Node (mymap[t6],$6) } ;$$->add(v); }
;

StatementNoShortIf:
StatementWithoutTrailingSubstatement {$$=$1;}
| LabeledStatementNoShortIf         {$$=$1;}
| IfThenElseStatementNoShortIf      {$$=$1;}
| WhileStatementNoShortIf           {$$=$1;}
| ForStatementNoShortIf             {$$=$1;}
;

LabeledStatementNoShortIf:
Identifier colon StatementNoShortIf                                    {$$= new Node("LabeledStatementNoShortIf"); string t1 = $1;string t2= $2; vector<Node*>v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3 }; $$->add(v); }                      
;

WhileStatementNoShortIf:
WHILE curly_open Expression curly_close StatementNoShortIf             {$$ = new Node("WhileStatementNoShortIf"); string t1= $1,t2=$2, t4=$4; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5 };  $$->add(v);}
;

ForStatement:
BasicForStatement                                                      {$$=new Node("ForStatement"); $$->add($1); }
| EnhancedForStatement                                                 {$$=new Node("ForStatement"); $$->add($1);}
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
FOR brac_open semi_colon semi_colon brac_close                         {$$ = new Node(); string t1= $1,t2=$2,t3=$3, t4=$4, t5=$5; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), new Node(mymap[t4], $4), new Node(mymap[t5], $5) };  $$->add(v);}
| FOR brac_open ForInit semi_colon semi_colon brac_close               {$$ = new Node(); string t1= $1,t2=$2,t4=$4, t5=$5, t6=$6; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), new Node(mymap[t5], $5), new Node(mymap[t6], $6) };  $$->add(v); } 
| FOR brac_open semi_colon Expression semi_colon brac_close            {$$ = new Node(); string t1= $1,t2=$2,t3=$3, t5=$5, t6=$6; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), $4, new Node(mymap[t5], $5), new Node(mymap[t6], $6) };  $$->add(v); }
| FOR brac_open semi_colon semi_colon ForUpdate brac_close             {$$ = new Node(); string t1= $1,t2=$2,t3=$3, t4=$4, t6=$6; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6) };  $$->add(v); }
| FOR brac_open semi_colon Expression semi_colon ForUpdate brac_close  {$$ = new Node(); string t1= $1,t2=$2,t3=$3, t5=$5, t7=$7; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), new Node(mymap[t3], $3), $4, new Node(mymap[t5], $5), $6, new Node(mymap[t7], $7) };  $$->add(v);}
| FOR brac_open ForInit semi_colon semi_colon ForUpdate brac_close     {$$ = new Node(); string t1= $1,t2=$2,t4=$4, t5=$5, t7=$7; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), new Node(mymap[t5], $5), $6, new Node(mymap[t7], $7) };  $$->add(v);}
| FOR brac_open ForInit semi_colon Expression semi_colon brac_close    {$$ = new Node(); string t1= $1,t2=$2,t4=$4, t6=$6, t7=$7; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6),new Node(mymap[t7], $7) };  $$->add(v); }
| FOR brac_open ForInit semi_colon Expression semi_colon ForUpdate brac_close {$$ = new Node(); string t1= $1,t2=$2,t4=$4, t6=$6, t8=$8; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6), $7, new Node(mymap[t8], $8) };  $$->add(v); }
;


ForInit: 
StatementExpressionList {$$=$1;}
| LocalVariableDeclaration {$$=$1;}
;

ForUpdate:
StatementExpressionList {$$=$1;}
;

StatementExpressionList:
StatementExpression {$$= new Node("StatementExpressionList"); $$->add($1);}
| StatementExpressionList comma StatementExpression  {$$ = $1; string t1 = $2; $$->add(new Node(mymap[t1],$2));$$->add($3);}
;

EnhancedForStatement:
FOR brac_open LocalVariableDeclaration colon Expression brac_close Statement {$$ = new Node("EnhancedForStatement"); string t1= $1,t2=$2,t4=$4, t6=$6; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6), $7 };  $$->add(v); }
;

EnhancedForStatementNoShortIf:
FOR brac_open LocalVariableDeclaration colon Expression brac_close StatementNoShortIf {$$ = new Node("EnhancedForStatementNoShortIf"); string t1= $1,t2=$2,t4=$4, t6=$6; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6), $7 };  $$->add(v);}
;

WhileStatement:
WHILE brac_open Expression brac_close Statement {$$ = new Node("WhileStatement"); string t1= $1,t2=$2,t4=$4; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5};  $$->add(v); }
;

LocalVariableDeclaration:
LocalVariableType VariableDeclaratorList {$$= new Node ("LocalVariableDeclaration"); $$->add($1->objects); $$->add($2);}
| Modifiers LocalVariableType VariableDeclaratorList {$$= new Node ("LocalVariableDeclaration"); $$->add($1->objects); $$->add($2->objects); $$->add($3);}
;

ArrayCreationExpression: 
newclasstype ArrayCreationExpressionAfterType  {$$= new Node("ArrayCreationExpression"); $$->add($1->objects); $$->add($2->objects); }
| newprimtype ArrayCreationExpressionAfterType {$$= new Node("ArrayCreationExpression"); $$->add($1->objects); $$->add($2->objects); }
;

ArrayCreationExpressionAfterType:
DimExprs { $$=$1; }
| DimExprs Dims {$$= new Node(); $$->add($1);$$->add($2);}
| Dims ArrayInitializer {$$=new Node(); $$->add($1);$$->add($2);}
;

newprimtype:
NEW PrimitiveType {$$=new Node(); string t1= $1; $$->add(new Node(mymap[t1],$1));$$->add($2);}
;

newclasstype:
NEW ClassType {$$=new Node(); string t1= $1; $$->add(new Node(mymap[t1],$1));$$->add($2);}
;

DimExprs:
  DimExpr {$$=$1;}
| DimExprs DimExpr {$$=$1; $$->add($2);}
;

DimExpr:  
box_open Expression box_close  {string t1=$1; $$=new Node("DimExpr"); $$->add(new Node(mymap[t1],$1)); $$->add($2); t1=$3; $$->add(new Node(mymap[t1],$1));}

ArrayInitializer: 
curly_open VariableInitializerList curly_close {string t1=$1; $$=new Node("ArrayInitializer"); $$->add(new Node(mymap[t1],$1)); $$->add($2); t1=$3; $$->add(new Node(mymap[t1],$1));}
| curly_open VariableInitializerList comma curly_close {string t1=$1; $$=new Node("ArrayInitializer"); $$->add(new Node(mymap[t1],$1)); $$->add($2); t1=$3; $$->add(new Node(mymap[t1],$1)); t1=$4; $$->add(new Node(mymap[t1],$1));}
;

VariableInitializerList:
VariableInitializer {$$= new Node("VariableInitializerList"); $$->add($1);}
| VariableInitializerList comma VariableInitializer {$$= $1; string t1=$2;  $$->add(new Node(mymap[t1],$2)); $$->add($3); }
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
  else if(argc==2){
    set_input_file(argv[1]);
    fout.open("graph.dot");
  }
  else {
    fout.open("graph.dot");
  }
	
	yyparse();

    /* printf("%d %d %d %d\n",titles,paras,words,sentences)); */
    /* fout<<titles<<" "<<paras<<" "<<words<<" "<<sentences<<endl; */

    return 0;
}

int yyerror (char const *s)
{
  return yyerror(string(s));
}