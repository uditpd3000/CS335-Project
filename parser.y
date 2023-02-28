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
%type<node> VariableDeclarator VariableDeclaratorList VariableInitializer Modifiers CompilationUnit VariableInitializerList ArrayInitializer DimExpr DimExprs ArrayCreationExpression ArrayCreationExpressionAfterType newclasstype newprimtype WhileStatement EnhancedForStatementNoShortIf Expression
%type<node> StatementExpressionList ForInit ForUpdate BasicForStatement BasicForStatementNoShortIf BasicForStatementStart StatementExpression EnhancedForStatement ForStatement ForStatementNoShortIf WhileStatementNoShortIf LabeledStatementNoShortIf StatementNoShortIf IfThenElseStatement IfThenElseStatementNoShortIf IfThenStatement ExpressionStatement LabeledStatement
%type<node> StatementWithoutTrailingSubstatement ThrowStatement ReturnStatement ContinueStatement BreakStatement Statement
%type<node> ConstructorBody ConstructorBodyEnd ConstructorDeclaration ConstructorDeclarationEnd ConstructorDeclarator ConstructorDeclaratorStart ExplicitConstructorInvocation ConstructorDeclaratorEnd
%type<node> Throws ExceptionTypeList ExplicitConsInvTillTypeArgs ArgumentList Primary ReceiverParameter FormalParameter FormalParameterList VariableDeclaratorId VariableArityParameter
%type<node> MethodDeclaration MethodDeclarationEnd MethodDeclarator MethodDeclaratorEnd MethodDeclaratorTillFP MethodDeclaratorTillRP MethodHeader MethodHeaderStart


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
  Expression {$$=new Node();}
| ArgumentList comma Expression {$$=new Node();}
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
  Assignment semi_colon {cout<<"mo2222222222222222222\n";}
| LocalClassOrInterfaceDeclaration {$$ = new Node("LocalClassOrInterfaceDeclaration"); $$->add($1); cout<<"LocalClassOrInterfaceDeclaration";}
| LocalVariableDeclarationStatement semi_colon {$$ =$1; string t1=$2; cout<<t1<<"==\n"; $$->add(new Node(mymap[t1],t1));  cout<<"LocalVariableDeclarationStatement\n";}
| Statement
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
  Expression {$$ = new Node("VariableInitializer"); cout<<"Varinit\n";} // $$->add($1);
| ArrayInitializer {$$ = new Node();} // $$ = $1;
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
  less_than TypeArgumentList greater_than {$$=new Node("TypeArgument"); string t1=$1,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),$2,new Node(mymap[t2],t2)}; $$->add(v);  cout<<"typeargs\n";}
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
  PrimitiveType Dims {$$=new Node("ArrayType"); $$->add($1); $$->add($2->objects);   cout<<"primdims\n";}
| ClassType Dims {$$=new Node("ArrayType"); $$->add($1->objects); $$->add($2->objects);   cout<<"primdims\n";}
;

Dims:
 box_open box_close {$$=new Node("Dims"); string t1=$1,t2=$2; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);}
| Dims box_open box_close {$$=$1; string t1=$2,t2=$3; vector<Node*>v{new Node(mymap[t1],t1),new Node(mymap[t2],t2)}; $$->add(v);}
;

PrimitiveType:
  literal_type {string t1=$1; $$= new Node(mymap[t1],t1);}
;

Expression : 
  AssignmentExpression {$$= new Node();  cout<<num++<<" Khatam----------------------------------------\n";}

;

AssignmentExpression : 
Assignment             {cout<<"Assignment\n";}
| ConditionalExpression {cout<<"Exp\n";}
;

Assignment:
  LeftHandSide AssignmentOperator Expression 
;

LeftHandSide:
FieldAccess      {cout<<"Fieldacc\n";}
| TypeName {cout<<"Expname\n";}
| ArrayAccess    {cout<<"Arraceess\n";}
;

FieldAccess:
Primary dot Identifier {cout<<"PrimdotId\n";}
| super dot Identifier
| TypeName dot super dot Identifier
;

/* fixmme */
Primary:
PrimaryNoNewArray {$$=new Node();}
| ArrayCreationExpression {$$=new Node();}
;

PrimaryNoNewArray:
  literal
| ClassLiteral {cout<<"Classliteral\n";}
| THIS
| TypeName dot THIS
| brac_open Expression brac_close
| FieldAccess
| ArrayAccess
| MethodInvocation
| ClassInstanceCreationExpression {cout<<"ClassInstance\n";}
;

TypeName:
  Identifier {string t1=$1; $$=new Node("Identifier",t1);}
| TypeName dot Identifier {string t2 =$3; $$=$1; $$->lexeme=$$->lexeme+"."+t2;}
;

Idboxopen:
Identifier box_open
;

Typenameboxopen:
Idboxopen 
| TypeName dot Idboxopen
;

ArrayAccess:
Typenameboxopen Expression box_close
| PrimaryNoNewArray box_open Expression box_close
;

squarebox: 
  box_open box_close 
| squarebox box_open box_close
;

ClassLiteral : 
  TypeName squarebox dot class_just_class 
| TypeName dot class_just_class
| literal_type squarebox dot class_just_class 
| literal_type dot class_just_class
| boolean squarebox dot class_just_class
| boolean dot class_just_class
| VOID dot class_just_class
;

ConditionalExpression: 
  ConditionalOrExpression
| ConditionalOrExpression ques_mark Expression colon ConditionalExpression
;

ConditionalOrExpression : 
  UnaryExpression 
| ConditionalOrExpression OR ConditionalOrExpression                      {cout<<"OR\n";}
| ConditionalOrExpression AND ConditionalOrExpression                     {cout<<"AND\n";}
| ConditionalOrExpression bitwise_or ConditionalOrExpression              {cout<<"or\n";}
| ConditionalOrExpression bitwise_xor ConditionalOrExpression             {cout<<"xor\n";}
| ConditionalOrExpression bitwise_and ConditionalOrExpression             {cout<<"and\n";}
| ConditionalOrExpression EQUALNOTEQUAL ConditionalOrExpression           {cout<<"Equality\n";}
| ConditionalOrExpression RELATIONAL_OP ConditionalOrExpression           {cout<<"Relational\n";}
| ConditionalOrExpression SHIFT_OP ConditionalOrExpression                {cout<<"Shift\n";}
| ConditionalOrExpression ARITHMETIC_OP_ADDITIVE ConditionalOrExpression  {cout<<"add\n";}
| ConditionalOrExpression ARITHMETIC_OP_MULTIPLY ConditionalOrExpression  {cout<<"mult\n";}
| InstanceofExpression
;

UnaryExpression:
  PreIncrDecrExpression                 {cout<<"IncrDecr\n";}
| ARITHMETIC_OP_ADDITIVE UnaryExpression 
| UnaryExpressionNotPlusMinus 
;

PreIncrDecrExpression:
INCR_DECR UnaryExpression
;

UnaryExpressionNotPlusMinus:
  LOGICAL_OP UnaryExpression
| PostfixExpression
| CastExpression {cout<<"C---a----s---t\n";}
;

PostfixExpression:
  Primary {cout<<"PostfixExpression\n";}
| TypeName
| PostIncrDecrExpression
;

PostIncrDecrExpression:
  PostfixExpression INCR_DECR
;

RELATIONAL_OP :
RELATIONAL_OP1 
| greater_than
| less_than
;


CastExpression:
  brac_open literal_type brac_close UnaryExpression
| brac_open ReferenceType brac_close UnaryExpressionNotPlusMinus
| brac_open ReferenceType AdditionalBound brac_close UnaryExpressionNotPlusMinus
;

AssignmentOperator:
assign
| AssignmentOperator1
;

InstanceofExpression:
  ConditionalOrExpression INSTANCE_OF ReferenceType {cout<<"Instance//////////////////\n";}
| ConditionalOrExpression INSTANCE_OF LocalVariableDeclarationStatement  {cout<<"Instance||||||||||||||||||\n";}
; 

MethodInvocation:
  Identifier brac_open ArgumentList brac_close
| Identifier brac_open brac_close
| MethodIncovationStart TypeArguments Identifier  brac_open ArgumentList brac_close
| MethodIncovationStart TypeArguments Identifier  brac_open brac_close
| MethodIncovationStart Identifier  brac_open brac_close {cout<<"methodinvocation\n";}
| MethodIncovationStart Identifier  brac_open ArgumentList brac_close
;

MethodIncovationStart:
  TypeName dot
| Primary dot
| super dot          {cout<<"MethodInvocationStart\n";}
| TypeName dot super dot
;

ClassInstanceCreationExpression:
  UnqualifiedClassInstanceCreationExpression
| TypeName dot UnqualifiedClassInstanceCreationExpression
| Primary dot UnqualifiedClassInstanceCreationExpression
;

UnqualifiedClassInstanceCreationExpression:
  NEW TypeArguments ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen
| NEW ClassOrInterfaceTypeToInstantiate brac_open UnqualifiedClassInstanceCreationExpressionAfter_bracopen {cout<<"UnqualifiedClassInstanceCreationExpression2\n";}
;

UnqualifiedClassInstanceCreationExpressionAfter_bracopen:
  ArgumentList brac_close ClassBody
| brac_close ClassBody {cout<<"UnqualifiedClassInstanceCreationExpressionAfter_bracopen\n";}
| brac_close
| ArgumentList brac_close
;

ClassOrInterfaceTypeToInstantiate:
 Identifier {cout<<"ClassOrInterfaceTypeToInstantiate\n";}
| Identifier TypeArgumentsOrDiamond
| Identifier ClassOrInterfaceType2
| Identifier ClassOrInterfaceType2 TypeArgumentsOrDiamond
;

TypeArgumentsOrDiamond:
  TypeArguments
| less_than greater_than
;

ClassOrInterfaceType2:
  dot Identifier
| ClassOrInterfaceType2 dot Identifier
;

Statement:
StatementWithoutTrailingSubstatement     {$$= new Node("Statement");$$->add($1);}
| LabeledStatement                       {$$= new Node("Statement");$$->add($1);}
| IfThenStatement                        {$$= new Node("Statement");$$->add($1);}
| IfThenElseStatement                    {$$= new Node("Statement");$$->add($1);}
| WhileStatement                         {$$= new Node("Statement");$$->add($1);}
| ForStatement                           {$$= new Node("Statement");$$->add($1);}
| PRINTLN brac_open TypeName brac_close  {$$= new Node("Statement");string t1=$1,t2=$2,t4=$4; vector<Node*>v {new Node(mymap[t1],$1),new Node(mymap[t2],$2), new Node(), new Node(mymap[t4],$4)}; $$->add(v);}
| PRINTLN brac_open literal brac_close   {$$= new Node("Statement");string t1=$1,t2=$2,t3=$3,t4=$4; vector<Node*>v {new Node(mymap[t1],$1),new Node(mymap[t2],$2), new Node(mymap[t3],$3) , new Node(mymap[t4],$4)}; $$->add(v);}
;

StatementWithoutTrailingSubstatement:
Block                           {$$=new Node();}
| semi_colon                    {$$=new Node(); string t1 = $1; $$-> add(new Node(mymap[t1],$1));}
| ExpressionStatement           {$$=$1;}
| BreakStatement                {$$=$1;}
| ContinueStatement             {$$=$1;}
| ReturnStatement               {$$=$1;}
| ThrowStatement                {$$=$1;}
;

BreakStatement:
BREAK                            {$$= new Node("ReturnStatement");string t1= $1;$$->add(new Node(mymap[t1],$1));}
| BREAK Identifier               {$$= new Node("ReturnStatement"); string t1= $1, t2=$2; $$->add(new Node(mymap[t1],$1));$$->add(new Node(mymap[t2],$2));}
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
Assignment                       {$$=new Node();}
| PreIncrDecrExpression          {$$=new Node();}
| PostIncrDecrExpression         {$$=new Node();}
| MethodInvocation               {$$=new Node();}
| ClassInstanceCreationExpression{$$=new Node();}
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
IF brac_open Expression brac_close StatementNoShortIf ELSE StatementNoShortIf  {$$ = new Node(); string t1 = $1,t2= $2,t4=$4,t6=$6; vector<Node*>v{new Node (mymap[t1],$1),new Node (mymap[t2],$2),$3,new Node (mymap[t4],$4),$5,new Node (mymap[t6],$6) } ;$$->add(v); }
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
WHILE curly_open Expression curly_close StatementNoShortIf             {$$ = new Node(); string t1= $1,t2=$2, t4=$4; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5 };  $$->add(v);}
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
FOR brac_open LocalVariableDeclaration colon Expression brac_close Statement {$$ = new Node("EnhancedForStatement"); string t1= $1,t2=$2,t4=$4, t6=$6; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6), new Node() };  $$->add(v); }
;

EnhancedForStatementNoShortIf:
FOR brac_open LocalVariableDeclaration colon Expression brac_close StatementNoShortIf {$$ = new Node("EnhancedForStatementNoShortIf"); string t1= $1,t2=$2,t4=$4, t6=$6; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), $5, new Node(mymap[t6], $6), new Node() };  $$->add(v);}
;

WhileStatement:
WHILE brac_open Expression brac_close Statement {$$ = new Node("WhileStatement"); string t1= $1,t2=$2,t4=$4; vector<Node*>v{new Node (mymap[t1],$1) , new Node(mymap[t2],$2), $3, new Node(mymap[t4], $4), new Node() };  $$->add(v); }
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
box_open Expression box_close  {string t1=$1; $$=new Node("DimExpr"); $$->add(new Node(mymap[t1],$1)); $$->add(new Node()); t1=$3; $$->add(new Node(mymap[t1],$1));}

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