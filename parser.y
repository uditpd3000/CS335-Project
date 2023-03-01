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

void generatetree(Node* n){
  int ptr=num;
    num++;


    if(n->objects.size()){

        for(auto x : n->objects){

            cout<<n->label<<ptr<<"->";
            generatetree(x);
            // cout<<";\n";
        }

        cout<<n->label<<ptr;
        cout<<"[label=\"";
        n->print();
        cout<<"\"];"<<endl;
        
    }
    else{
      cout<<n->label<<ptr<<";\n";

      cout<<n->label<<ptr;
          cout<<"[label=\"";
          n->print();
          cout<<"\"];"<<endl;
    }
}

void generate_graph(Node *n){
  cout<<"\n\n\ndigraph G {\n";
  generatetree(n);
  cout <<"\n}\n\n\n";

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
%token<sym> Identifier extends super implements permits
%token<sym> ARITHMETIC_OP_ADDITIVE ARITHMETIC_OP_MULTIPLY LOGICAL_OP Equality_OP INCR_DECR VOID THIS AND EQUALNOTEQUAL SHIFT_OP INSTANCE_OF RELATIONAL_OP1 NEW THROW RETURN CONTINUE FOR IF ELSE WHILE BREAK PRINTLN

%type<node> input
%type<node> ClassDeclaration ClassBody ClassPermits InterfaceTypeList ClassType ClassBodyDeclaration
%type<node> ClassDecTillPermits ClassDecTillImplements ClassImplements ClassDecTillExtends ClassDecTillTypeParameters ClassExtends
%type<node> StaticInitializer 
%type<node> ClassMemberDeclaration MethodAndFieldStart FieldDeclaration
%type<node> TypeArguments TypeArgumentList TypeArgument TypeName TypeParameters TypeParameterList TypeParameter TypeBound
%type<node> WildcardBounds ReferenceType ArrayType Dims PrimitiveType AdditionalBound
%type<node> UnannArrayType UnannPrimitiveType UnannReferenceType UnannType
%type<node> Block BlockStatements BlockStatement LocalVariableDeclaration LocalVariableDeclarationStatement LocalVariableType LocalClassOrInterfaceDeclaration InstanceInitializer
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
%type<node> ClassOrInterfaceTypeToInstantiate UnqualifiedClassInstanceCreationExpressionAfter_bracopen TypeArgumentsOrDiamond ClassOrInterfaceType2

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

CompilationUnit: {$$= new Node("CompilationUnit"); $$->add(new Node());}
| CompilationUnit ClassDeclaration  { $$=$1; $$->add($2);}
;

ClassDeclaration:
  Modifiers class_just_class Identifier ClassDecTillTypeParameters {$$= new Node("ClassDeclaration"); $$->add($1->objects); string t1=$2,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); $$->add($4->objects); cout<<"class declared yayy!!1\n";}
| class_just_class Identifier ClassDecTillTypeParameters {$$= new Node("ClassDeclaration"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); $$->add($3->objects); cout<<"class declared yayy!!2\n";}
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
  curly_open ClassBodyDeclaration curly_close {string t1=$1,t2=$3; $$ =new Node("ClassBody"); vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)}; $$->add(v); cout<<"classbody1\n";}
| curly_open curly_close {string t1=$1,t2=$2; $$ =new Node("ClassBody");vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);  cout<<"\n---classbody2\n";}
;

ClassBodyDeclaration:
  ClassMemberDeclaration {$$=new Node("ClassBodyDeclaration"); $$->add($1); cout<<"classbodydeclaration1\n";}
| InstanceInitializer {$$=new Node("ClassBodyDeclaration"); $$->add($1); cout<<"classbodydeclaration2\n";}
| StaticInitializer {$$=new Node("ClassBodyDeclaration"); $$->add($1);  cout<<"classbodydeclaration3\n";}
| ConstructorDeclaration {$$=new Node("ClassBodyDeclaration");$$->add($1); cout<<"classbodydeclaration4\n";}
| ClassBodyDeclaration ClassMemberDeclaration {$$=$1; $$->add($2); cout<<"classbodydeclaration5\n";}
| ClassBodyDeclaration InstanceInitializer {$$=$1; $$->add($2); cout<<"classbodydeclaration6\n";}
| ClassBodyDeclaration StaticInitializer {$$=$1; $$->add($2); cout<<"classbodydeclaration7\n";}
| ClassBodyDeclaration ConstructorDeclaration {$$=$1; $$->add($2); cout<<"classbodydeclaration8\n";}
;

ConstructorDeclaration:
  class_access ConstructorDeclarator ConstructorDeclarationEnd {$$=new Node("ConstructorDeclaration"); string t=$1; vector<Node*>v{new Node(mymap[t],t),$2}; $$->add(v); $$->add($3->objects);  cout<<"constructordeclared1\n";}
| ConstructorDeclarator ConstructorDeclarationEnd {$$=new Node("ConstructorDeclaration"); vector<Node*>v{$1}; $$->add(v); $$->add($2->objects); cout<<"constructordeclared2\n";}
;

ConstructorDeclarationEnd:
  Throws ConstructorBody {$$=new Node(); vector<Node*>v{$1,$2}; $$->add(v); cout<<"constructordeclaration1\n";}
| ConstructorBody {$$=new Node(); $$->add($1); cout<<"constructordeclaration2\n";}
;

ConstructorBody:
  curly_open ExplicitConstructorInvocation ConstructorBodyEnd {$$=new Node("ConstructorBody"); string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2); $$->add($3->objects); cout<<"ConstructorBody1\n";}
| curly_open ConstructorBodyEnd {$$=new Node("ConstructorBody");string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2->objects); cout<<"ConstructorBody2\n";}
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
| Identifier brac_open {$$ = new Node(); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); cout<<"ConstructorDeclaratorStart\n";}
;

ConstructorDeclaratorEnd:
  ReceiverParameter FormalParameterList brac_close {$$ = new Node(); string t1=$3; vector<Node*>v{$1,$2,new Node(mymap[t1],t1)}; $$->add(v); cout<<"ConstructorDeclarator1\n";}
| FormalParameterList brac_close {$$ = new Node(); string t1=$2; vector<Node*>v{$1,new Node(mymap[t1],t1)}; $$->add(v); cout<<"ConstructorDeclarator2\n";}
| ReceiverParameter brac_close {$$ = new Node(); string t1=$2; vector<Node*>v{$1,new Node(mymap[t1],t1)}; $$->add(v); cout<<"ConstructorDeclarator1\n";}
| brac_close {$$ = new Node(); string t1=$1; vector<Node*>v{new Node(mymap[t1],t1)}; $$->add(v); cout<<"ConstructorDeclarator2\n";}
;

StaticInitializer:
  STATIC Block {string t1=$1; $$ =new Node("StaticInitializer");vector<Node*>v{new Node("Keyword",t1),$2};$$->add(v); cout<<"StaticInitializer\n";}
;

InstanceInitializer:
 Block {$$ = $1;}
;

Block:
  curly_open BlockStatements curly_close {$$=new Node("Block"); string t1=$1,t2=$3; vector<Node*>v{(new Node(mymap[t1],t1)),$2,(new Node(mymap[t2],t2))}; $$->add(v); cout<<"Block1\n";}
| curly_open curly_close {$$=new Node("Block"); string t1=$1,t2=$2; vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; $$->add(v); cout<<"Block2\n";}
;

BlockStatements:
  BlockStatement {$$=new Node("BlockStatements"); $$->add($1); cout<<"BlockStatements1\n";}
| BlockStatements BlockStatement {$$=$1; $$->add($2); cout<<"BlockStatements2\n";}
;

/* BlockStatement:
  LocalClassOrInterfaceDeclaration {cout<<"";}
| LocalVariableDeclarationStatement {cout<<"";}
| Statement {cout<<"";}
; */

BlockStatement:
  Assignment semi_colon {string t1=$2;$$=new Node("BlockStatement"); vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v); cout<<"mo2222222222222222222\n";}
| LocalClassOrInterfaceDeclaration {$$ = new Node("LocalClassOrInterfaceDeclaration"); $$->add($1); cout<<"LocalClassOrInterfaceDeclaration";}
| LocalVariableDeclarationStatement semi_colon {$$ =$1; string t1=$2; cout<<t1<<"==\n"; $$->add(new Node(mymap[t1],t1));  cout<<"LocalVariableDeclarationStatement\n";}
| Statement {cout<<"BlockStatement4\n"; $$=new Node("BlockStatement"); $$->add($1);}
;

LocalVariableDeclarationStatement:
  Modifiers LocalVariableType VariableDeclaratorList {$$ = new Node("LocalVariableDeclarationStatement"); vector<Node*>v{$1,$2,$3}; $$->add(v); cout<<"LocalVariableDeclarationStatement1\n";}
| LocalVariableType VariableDeclaratorList {$$ = new Node("LocalVariableDeclarationStatement"); vector<Node*>v{$1,$2}; $$->add(v); cout<<"LocalVariableDeclarationStatement2\n";}
;

LocalVariableType:
  UnannType {$$=$1; cout<<"LocalVariableType1\n";}
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
  FieldDeclaration {$$=$1; cout<<"ClassMemberDeclaration1\n";}
| MethodDeclaration {$$=$1;  cout<<"ClassMemberDeclaration2\n";}
| ClassDeclaration {$$=$1;  cout<<"ClassMemberDeclaration3\n";}
| semi_colon {string t1=$1; $$= new Node(mymap[t1],t1); cout<<"ClassMemberDeclaration4\n";}
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
  Block {$$=$1; cout<<"MethodDeclaration1\n";}
| semi_colon {string t1=$1; $$=new Node(mymap[t1],t1); cout<<"MethodDeclaration2\n";}
;


MethodHeader:
  TypeParameters MethodHeaderStart {$$= new Node("MethodHeader"); $$->add($1); $$->add($2->objects); cout<<"MethodHeader1\n";}
| MethodHeaderStart {$$= new Node("MethodHeader"); $$->add($1->objects); cout<<"MethodHeader2\n";}
;

MethodHeaderStart:
 VOID MethodDeclarator {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2->objects); cout<<"MethodHeader4\n";}
| VOID MethodDeclarator Throws {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2->objects); $$->add($3);  cout<<"MethodHeader4\n";}
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
  FormalParameterList MethodDeclaratorEnd {$$=new Node(); $$->add($1); $$->add($2->objects); cout<<"MethodDeclarator2\n";}
| MethodDeclaratorEnd {$$=new Node(); $$->add($1->objects); cout<<"MethodDeclarator3\n";}
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
| Identifier {$$= new Node("VariableDeclaratorId"); string t1=$1; vector<Node*>v{(new Node(mymap[t1],t1))}; $$->add(v); cout<<"VariableDeclaratorId2\n";}
;

VariableArityParameter:
 dots Identifier {$$= new Node("VariableArityParameter"); string t1=$1,t2=$2; vector<Node*>v{(new Node(mymap[t1],t1)),(new Node(mymap[t2],t2))}; $$->add(v);}
;

ReceiverParameter:
  THIS comma {$$ = new Node("ReceiverParameter"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v); cout<<"ReceiverParameter1\n";}
| Identifier dot THIS comma  {$$ = new Node("ReceiverParameter"); string t1=$1,t2=$2,t3=$3,t4=$4; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3),new Node(mymap[t4],t4)}; $$->add(v); cout<<"ReceiverParameter2\n";}
;

FieldDeclaration:
  MethodAndFieldStart VariableDeclaratorList semi_colon {string t1=$3; $$=new Node("FieldDeclaration"); $$->add($1->objects); vector<Node*>v{$2,new Node(mymap[t1],t1)}; $$->add(v); cout<<"FieldDeclaration2\n";}
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
CommonModifier {string t1=$1; $$ = new Node(); $$->add(new Node(mymap[t1],t1)); cout<<"classModifier \n";}
| Modifiers CommonModifier {$$=new Node("Modifiers"); $$->add($1->objects); string t1=$2; $$->add(new Node(mymap[t1],t1)); cout<<"classModifier \n";}
;

VariableDeclaratorList:
  VariableDeclarator {$$= new Node("VariableDeclaratorList"); $$->add($1); cout<<"VariableDeclaratorList1\n";}
| VariableDeclaratorList comma VariableDeclarator { $$=$1; string t1=$2; vector<Node*>v{new Node(mymap[t1],t1),$3}; $$->add(v); cout<<"VariableDeclaratorList2\n";}
;

UnannType:
  UnannPrimitiveType {$$ = new Node("UnannType"); $$->add($1); cout<<"UnannType1\n";}
| UnannReferenceType {$$ = new Node("UnannType"); $$->add($1); cout<<"UnannType2\n";}
;

UnannPrimitiveType:
  boolean {string t1= $1; $$=new Node(mymap[t1],t1);}
| literal_type {string t1= $1; $$=new Node(mymap[t1],t1); cout<<"UnannPrimitiveType\n";}
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
| Identifier assign VariableInitializer {$$ = new Node("VariableDeclarator"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3}; $$->add(v); cout<<"VariableDeclarator1\n";}
| Identifier Dims assign VariableInitializer {$$ = new Node("VariableDeclarator"); string t1=$1,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4}; $$->add(v); cout<<"VariableDeclarator1\n";}
;

VariableInitializer:
  Expression {$$ = new Node("VariableInitializer"); $$->add($1);cout<<"Varinit\n";} // $$->add($1);
| ArrayInitializer {$$ = new Node();$$ = $1;} // 
; 

TypeParameters:
  less_than TypeParameterList greater_than {$$=new Node("TypeParameters"); string t1=$1,t2=$3; $$->add(new Node(mymap[t1],t1)); $$->add($2->objects); $$->add(new Node(mymap[t2],t2)); cout<<"typeparam\n";}
;

ClassExtends:
  extends ClassType {$$ = new Node(); string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2);cout<<"extends\n";}
;

ClassImplements:
 implements InterfaceTypeList {$$ = new Node(); string t1=$1; $$->add(new Node(mymap[t1],t1)); $$->add($2); cout<<"implements\n";}
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
 ClassType {$$=new Node("InterfaceTypeList"); $$->add($1->objects); cout<<"interfacetypelist1\n";}
| InterfaceTypeList comma ClassType { $$=$1; $$->add(new Node("seperator",$2)); $$->add($3->objects);  cout<<"interfacetypelist2\n";}
;

TypeParameter:
 Identifier TypeBound {string t1=$1; $$=new Node("TypeParameter"); $$->add(new Node(mymap[t1],t1)); $$->add($2->objects);}
| Identifier {string t1=$1; $$=new Node("TypeParameter"); $$->add(new Node(mymap[t1],t1));}
;

TypeBound:
  extends ClassType {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2); cout<<"typebound1\n";}
| extends ClassType AdditionalBound {string t1=$1; $$=new Node(); $$->add(new Node(mymap[t1],t1)); $$->add($2); $$->add($3->objects); cout<<"typebound2\n";}
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
  less_than TypeArgumentList greater_than {$$=new Node("TypeArguments"); string t1=$1,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)}; $$->add(v);  cout<<"typeargs\n";}
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
  PrimitiveType Dims   {$$=new Node("ArrayType"); $$->add($1); $$->add($2->objects);   cout<<"primdims\n";}
| ClassType Dims       {$$=new Node("ArrayType"); $$->add($1->objects); $$->add($2->objects);   cout<<"primdims\n";}
;

Dims:
 box_open box_close          {$$=new Node("Dims"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);}
| Dims box_open box_close    {$$=$1; string t1=$2,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);}
;

PrimitiveType:
  literal_type {string t1=$1; $$= new Node(mymap[t1],t1);}
;

Expression: 
  AssignmentExpression {$$=$1; cout<<num++<<" Khatam----------------------------------------\n";}
;

AssignmentExpression: 
Assignment                {$$=$1; cout<<"Assignment\n"; }
| ConditionalExpression   {$$=$1; cout<<"Exp\n";}
;

Assignment:
  LeftHandSide AssignmentOperator Expression  {$$=new Node("Assignment");vector<Node*>v{$1,$2,$3};$$->add(v);}
;

LeftHandSide:
FieldAccess      {$$=$1; cout<<"Fieldacc\n";}
| TypeName       {$$=$1; cout<<"Expname\n";}
| ArrayAccess    {$$=$1; cout<<"Arraceess\n";}
;

FieldAccess:
Primary dot Identifier              {$$=new Node("FieldAccess");string t1=$2,t2=$3;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v); cout<<"PrimdotId\n";}
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
| ClassLiteral                      {$$=$1; cout<<"Classliteral\n";}
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
  ConditionalOrExpression                                                   {cout<<"ConditionalExpression\n"; $$=$1;}
| ConditionalOrExpression ques_mark Expression colon ConditionalExpression  {$$=new Node("ConditionalExpression");string t1=$2,t2=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),$3,new Node(mymap[t2],t2),$5};$$->add(v);}
;

ConditionalOrExpression : 
  UnaryExpression                                                         {$$=$1;}
| ConditionalOrExpression OR ConditionalOrExpression                      {$$=new Node("ConditionalOrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"OR\n";}
| ConditionalOrExpression AND ConditionalOrExpression                     {$$=new Node("ConditionalOrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"AND\n";}
| ConditionalOrExpression bitwise_or ConditionalOrExpression              {$$=new Node("ConditionalOrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"or\n";}
| ConditionalOrExpression bitwise_xor ConditionalOrExpression             {$$=new Node("ConditionalOrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"xor\n";}
| ConditionalOrExpression bitwise_and ConditionalOrExpression             {$$=new Node("ConditionalOrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"and\n";}
| ConditionalOrExpression EQUALNOTEQUAL ConditionalOrExpression           {$$=new Node("ConditionalOrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"Equality\n";}
| ConditionalOrExpression RELATIONAL_OP ConditionalOrExpression           {$$=new Node("ConditionalOrExpression");vector<Node*>v{$1,$2,$3};$$->add(v);cout<<"Relational\n";}
| ConditionalOrExpression SHIFT_OP ConditionalOrExpression                {$$=new Node("ConditionalOrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"Shift\n";}
| ConditionalOrExpression ARITHMETIC_OP_ADDITIVE ConditionalOrExpression  {$$=new Node("ConditionalOrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"add\n";}
| ConditionalOrExpression ARITHMETIC_OP_MULTIPLY ConditionalOrExpression  {$$=new Node("ConditionalOrExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"mult\n";}
| InstanceofExpression                                                    {$$=$1;}
;

UnaryExpression:
  PreIncrDecrExpression                     {$$=$1; cout<<"IncrDecr\n";}
| ARITHMETIC_OP_ADDITIVE UnaryExpression    {$$=new Node("UnaryExpression");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v);}
| UnaryExpressionNotPlusMinus               {$$=$1;}
;

PreIncrDecrExpression:
INCR_DECR UnaryExpression                   {$$=new Node("PreIncrDecrExpression");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v);}
;

UnaryExpressionNotPlusMinus:
  LOGICAL_OP UnaryExpression                {$$=new Node("UnaryExpressionNotPlusMinus");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v);}
| PostfixExpression                         {$$=$1;}
| CastExpression                            {$$=$1; cout<<"C---a----s---t\n";}
;

PostfixExpression:
  Primary                                   {$$=$1; cout<<"PostfixExpression\n";}
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
  ConditionalOrExpression INSTANCE_OF ReferenceType                      {$$=new Node("InstanceofExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v); cout<<"Instance//////////////////\n";}
| ConditionalOrExpression INSTANCE_OF LocalVariableDeclarationStatement  {$$=new Node("InstanceofExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);cout<<"Instance||||||||||||||||||\n";}
; 

MethodInvocation:
  Identifier brac_open ArgumentList brac_close                                         {$$=new Node("MethodInvocation");string t1=$1,t2=$2,t3=$4;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$3,new Node(mymap[t3],t3)};$$->add(v);}
| Identifier brac_open brac_close                                                      {$$=new Node("MethodInvocation");string t1=$1,t2=$2,t3=$3;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| MethodIncovationStart TypeArguments Identifier  brac_open ArgumentList brac_close    {$$=new Node("MethodInvocation");string t1=$3,t2=$4,t3=$6;$$->add($1->objects); vector<Node*>v{$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2),$5,new Node(mymap[t3],t3)};$$->add(v);}
| MethodIncovationStart TypeArguments Identifier  brac_open brac_close                 {$$=new Node("MethodInvocation");string t1=$3,t2=$4,t3=$5;$$->add($1->objects); vector<Node*>v{$2,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
| MethodIncovationStart Identifier  brac_open brac_close                               {$$=new Node("MethodInvocation");string t1=$2,t2=$3,t3=$4;$$->add($1->objects); vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v); cout<<"methodinvocation\n";}
| MethodIncovationStart Identifier  brac_open ArgumentList brac_close                  {$$=new Node("MethodInvocation");string t1=$2,t2=$3,t3=$5;$$->add($1->objects); vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2),$4,new Node(mymap[t3],t3)};$$->add(v);}
;

MethodIncovationStart:
  TypeName dot                   {$$=new Node("MethodIncovationStart");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);}
| Primary dot                    {$$=new Node("MethodIncovationStart");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);}
| super dot                      {$$=new Node("MethodIncovationStart");string t1=$1,t2=$2;vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)};$$->add(v); cout<<"MethodInvocationStart\n";}
| TypeName dot super dot         {$$=new Node("MethodIncovationStart");string t1=$2,t2=$3,t3=$4;vector<Node*>v{$1,new Node(mymap[t1],t1),new Node(mymap[t2],t2),new Node(mymap[t3],t3)};$$->add(v);}
;

ClassInstanceCreationExpression:
  UnqualifiedClassInstanceCreationExpression                {$$=$1;}
| TypeName dot UnqualifiedClassInstanceCreationExpression   {$$=new Node("ClassInstanceCreationExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
| Primary dot UnqualifiedClassInstanceCreationExpression    {$$=new Node("ClassInstanceCreationExpression");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
;

UnqualifiedClassInstanceCreationExpression:
  NEW TypeArguments ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen  {$$=new Node("UnqualifiedClassInstanceCreationExpression");string t1=$1,t2=$4;vector<Node*>v{new Node(mymap[t1],t1),$2,$3,new Node(mymap[t2],t2),$5};$$->add(v);}
| NEW ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen                {$$=new Node("UnqualifiedClassInstanceCreationExpression");string t1=$1,t2=$3;vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2),$4};$$->add(v); cout<<"UnqualifiedClassInstanceCreationExpression2\n";}
;

UnqualifiedClassInstanceCreationExpressionAfter_bracopen:
  ArgumentList brac_close ClassBody      {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1),$3};$$->add(v);}
| brac_close ClassBody                   {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1),$2};$$->add(v); cout<<"UnqualifiedClassInstanceCreationExpressionAfter_bracopen\n";}
| brac_close                             {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$1;vector<Node*>v{new Node(mymap[t1],t1)};$$->add(v);}
| ArgumentList brac_close                {$$=new Node("UnqualifiedClassInstanceCreationExpressionAfter_bracopen");string t1=$2;vector<Node*>v{$1,new Node(mymap[t1],t1)};$$->add(v);}
;

ClassOrInterfaceTypeToInstantiate:
 Identifier                                                 {string t1=$1; $$=(new Node(mymap[t1],t1)); cout<<"ClassOrInterfaceTypeToInstantiate\n";}
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
| WhileStatement                         {cout<<"Statement\n"; $$= new Node("Statement");$$->add($1);}
| ForStatement                           {$$= new Node("Statement");$$->add($1);}
| PRINTLN brac_open TypeName brac_close semi_colon {$$= new Node("Statement");string t1=$1,t2=$2,t4=$4,t5=$5; vector<Node*>v {new Node(mymap[t1],$1),new Node(mymap[t2],$2), $3, new Node(mymap[t4],$4),new Node(mymap[t5],$5)}; $$->add(v);}
| PRINTLN brac_open literal brac_close semi_colon {$$= new Node("Statement");string t1=$1,t2=$2,t3=$3,t4=$4,t5=$5; vector<Node*>v {new Node(mymap[t1],$1),new Node(mymap[t2],$2), new Node(mymap[t3],$3) , new Node(mymap[t4],$4),new Node(mymap[t5],$5)}; $$->add(v);}
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
WHILE brac_open Expression brac_close Statement {cout<<"WhileStatement\n"; $$ = new Node("WhileStatement"); string t1= $1,t2=$2,t4=$4; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5};  $$->add(v); }
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
    if (argc == 2)
	{
		set_input_file(argv[1]);
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