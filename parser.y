%{  
#include <bits/stdc++.h>
using namespace std;

extern int yyparse();
int yylex (void);
int yyerror (char const *);

extern void set_input_file(const char* filename);
extern void set_output_file(const char* filename);
extern void close_output_file();

int num=0;

/* {} 0 or more
[] 0 or 1*/

%}

%union{
  char* sym;
}
 
%token class_access STATIC FINAL key_SEAL key_abstract key_STRICTFP field_modifier method_modifier
%token curly_open curly_close box_open box_close dot dots less_than greater_than comma ques_mark bitwise_and at colon OR brac_open brac_close bitwise_xor bitwise_or assign semi_colon
%token class_just_class class_modifier literal_type AssignmentOperator1 boolean literal keyword throws var
%token Identifier extends super implements permits enum_just_enum record_just_record
%token ARITHMETIC_OP_ADDITIVE ARITHMETIC_OP_MULTIPLY LOGICAL_OP Equality_OP INCR_DECR VOID THIS AND EQUALNOTEQUAL SHIFT_OP INSTANCE_OF RELATIONAL_OP1




%left OR
%left AND
%left bitwise_or bitwise_xor
%left bitwise_and
%left EQUALNOTEQUAL
%left RELATIONAL_OP1 greater_than less_than
%left SHIFT_OP
%left ARITHMETIC_OP_ADDITIVE 
%left ARITHMETIC_OP_MULTIPLY
%right LOGICAL_OP
%right AssignmentOperator1 assign
%left INCR_DECR
%left dot
%left super

%%

input:
| ClassDeclaration input
;

ClassDeclaration:
  ClassModifier class_just_class Identifier ClassDecTillTypeParameters ClassBody {cout<<"class declared yayy!!1\n";}
| class_just_class Identifier ClassDecTillTypeParameters ClassBody {cout<<"class declared yayy!!2\n";}
;

ClassDecTillTypeParameters:
  TypeParameters ClassDecTillExtends
| ClassDecTillExtends
;

ClassDecTillExtends:
 ClassExtends ClassDecTillImplements
| ClassDecTillImplements
;

ClassDecTillImplements:
  ClassImplements ClassDecTillPermits
| ClassDecTillPermits
;

ClassDecTillPermits:
  permits ClassPermits curly_open
| curly_open
;

ClassBody:
  ClassBodyDeclaration curly_close {cout<<"classbody1\n";}
| curly_close {cout<<"classbody2\n";}
;

ClassBodyDeclaration:
  ClassMemberDeclaration {cout<<"classbodydeclaration1\n";}
| InstanceInitializer {cout<<"classbodydeclaration2\n";}
| StaticInitializer {cout<<"classbodydeclaration3\n";}
| ConstructorDeclaration {cout<<"classbodydeclaration4\n";}
| ClassMemberDeclaration ClassBodyDeclaration {cout<<"classbodydeclaration5\n";}
| InstanceInitializer ClassBodyDeclaration {cout<<"classbodydeclaration6\n";}
| StaticInitializer ClassBodyDeclaration {cout<<"classbodydeclaration7\n";}
| ConstructorDeclaration ClassBodyDeclaration {cout<<"classbodydeclaration8\n";}
;

ConstructorDeclaration:
  ConstructorModifier ConstructorDeclarator ConstructorDeclarationEnd {cout<<"constructordeclared1\n";}
| ConstructorDeclarator ConstructorDeclarationEnd {cout<<"constructordeclared2\n";}
;

ConstructorDeclarationEnd:
  Throws curly_open ConstructorBody {cout<<"constructordeclaration1\n";}
| curly_open ConstructorBody {cout<<"constructordeclaration2\n";}
;

ConstructorModifier:
  Annotation {cout<<"constructormodifier1\n";}
| class_access {cout<<"constructormodifier2\n";}
| Annotation ConstructorModifier {cout<<"constructormodifier3\n";}
| class_access ConstructorModifier {cout<<"constructormodifier4\n";}
;

ConstructorBody:
  ExplicitConstructorInvocation ConstructorBodyEnd {cout<<"ConstructorBody1\n";}
| ConstructorBodyEnd {cout<<"ConstructorBody2\n";}
;

ConstructorBodyEnd:
  BlockStatements curly_close
| curly_close
;

/* ExplicitConstructorInvocation:
| TypeArguments this brac_open ArgumentList brac_close semi_colon
| TypeArguments super brac_open ArgumentList brac_close semi_colon
| ExpressionName dot TypeArguments super brac_open ArgumentList brac_close semi_colon
| Primary dot TypeArguments super brac_open ArgumentList brac_close semi_colon
; */

 ExplicitConstructorInvocation:
  TypeArguments ExplicitConsInvTillTypeArgs
| ExplicitConsInvTillTypeArgs
| TypeName dot TypeArguments super brac_open ArgumentList brac_close semi_colon
| Primary dot TypeArguments super brac_open ArgumentList brac_close semi_colon
;

ExplicitConsInvTillTypeArgs:
  THIS brac_open ArgumentList brac_close semi_colon
| super brac_open ArgumentList brac_close semi_colon
;

ArgumentList:
  Expression
| ArgumentList comma Expression
;

ConstructorDeclarator:
  ConstructorDeclaratorStart ConstructorDeclaratorEnd
;

ConstructorDeclaratorStart:
  TypeParameters Identifier brac_open 
| Identifier brac_open {cout<<"ConstructorDeclaratorStart\n";}
;

ConstructorDeclaratorEnd:
  ReceiverParameter FormalParameterList brac_close {cout<<"ConstructorDeclarator1\n";}
| FormalParameterList brac_close {cout<<"ConstructorDeclarator2\n";}
| ReceiverParameter brac_close {cout<<"ConstructorDeclarator1\n";}
| brac_close {cout<<"ConstructorDeclarator2\n";}
;

StaticInitializer:
  STATIC Block {cout<<"StaticInitializer\n";}
;

InstanceInitializer:
 Block {cout<<"";}
;

Block:
  curly_open BlockStatements curly_close {cout<<"Block1\n";}
| curly_open curly_close {cout<<"Block2\n";}
;

BlockStatements:
  BlockStatement {cout<<"BlockStatements1\n";}
| BlockStatement BlockStatements {cout<<"BlockStatements2\n";}
;

/* BlockStatement:
  LocalClassOrInterfaceDeclaration {cout<<"";}
| LocalVariableDeclarationStatement {cout<<"";}
| Statement {cout<<"";}
; */

BlockStatement:
  Assignment semi_colon
| LocalClassOrInterfaceDeclaration {cout<<"";}
| LocalVariableDeclarationStatement {cout<<"";}
;

LocalVariableDeclarationStatement:
  VariableModifier LocalVariableType VariableDeclaratorList
;

LocalVariableType:
  UnannType {cout<<"LocalVariableType1\n";}
| var
;

/* LocalClassOrInterfaceDeclaration:
  ClassDeclaration
| NormalInterfaceDeclaration
; */
LocalClassOrInterfaceDeclaration:
  ClassDeclaration
;

/* ClassMemberDeclaration:
  FieldDeclaration
| MethodDeclaration
| ClassDeclaration
| InterfaceDeclaration
; */

ClassMemberDeclaration:
  FieldDeclaration {cout<<"ClassMemberDeclaration1\n";}
| MethodDeclaration {cout<<"ClassMemberDeclaration2\n";}
| ClassDeclaration {cout<<"ClassMemberDeclaration3\n";}
| semi_colon {cout<<"ClassMemberDeclaration4\n";}
;

MethodDeclaration:
  MethodModifier MethodHeader MethodDeclarationEnd
| MethodHeader MethodDeclarationEnd
;

MethodDeclarationEnd:
  Block {cout<<"MethodDeclaration1\n";}
| semi_colon {cout<<"MethodDeclaration2\n";}
;

MethodModifier:
   Annotation method_modifiers {cout<<"method_modifiers \n";}
|  MethodModifier Annotation method_modifiers {cout<<"method_modifiers \n";}
;

method_modifiers:
  class_access
| key_abstract
| STATIC
| FINAL
| key_STRICTFP
| method_modifier
;

MethodHeader:
  TypeParameters MethodHeaderStart {cout<<"MethodHeader1\n";}
| MethodHeaderStart {cout<<"MethodHeader2\n";}
;

MethodHeaderStart:
  Annotation Result MethodDeclarator {cout<<"MethodHeader3\n";}
| Result MethodDeclarator {cout<<"MethodHeader4\n";}
| Annotation Result MethodDeclarator Throws {cout<<"MethodHeader3\n";}
| Result MethodDeclarator Throws {cout<<"MethodHeader4\n";}
;

Throws:
  throws ExceptionTypeList semi_colon
;

ExceptionTypeList:
  ClassType
| ClassType comma ExceptionTypeList
;

MethodDeclarator:
  Identifier brac_open MethodDeclaratorTillRP
;

MethodDeclaratorTillRP:
  UnannType ReceiverParameter MethodDeclaratorTillFP
|  Annotation UnannType ReceiverParameter MethodDeclaratorTillFP {cout<<"MethodDeclarator1\n";}
| MethodDeclaratorTillFP 
;

MethodDeclaratorTillFP:
  FormalParameterList MethodDeclaratorEnd {cout<<"MethodDeclarator2\n";}
| MethodDeclaratorEnd {cout<<"MethodDeclarator3\n";}
;

MethodDeclaratorEnd:
  brac_close
| brac_close Dims
;

FormalParameterList:
  FormalParameter
| FormalParameter comma FormalParameterList 
;

FormalParameter:
  VariableModifier UnannType VariableDeclaratorId
| UnannType VariableDeclaratorId
| VariableModifier UnannType VariableArityParameter
| UnannType VariableArityParameter
;


// FormalParameter:
//   VariableDeclaratorId {cout<<"FormalParameter1\n";}
// | VariableArityParameter {cout<<"FormalParameter2\n";}
// ;

VariableDeclaratorId:
  Identifier Dims
| Identifier {cout<<"VariableDeclaratorId2\n";}
;

VariableArityParameter:
  Annotation dots Identifier
| dots Identifier
;

VariableModifier:
  Annotation
| FINAL
| Annotation VariableModifier
| FINAL VariableModifier
;

ReceiverParameter:
  THIS comma {cout<<"ReceiverParameter1\n";}
| Identifier dot THIS comma  {cout<<"ReceiverParameter2\n";}
;

Result:
  UnannType {cout<<"result\n";}
| VOID
;

FieldDeclaration:
  FieldModifier UnannType VariableDeclaratorList semi_colon {cout<<"FieldDeclaration1\n";}
| UnannType VariableDeclaratorList semi_colon {cout<<"FieldDeclaration2\n";}
;

FieldModifier:
   Annotation field_modifiers {cout<<"fieldModifier \n";}
|  FieldModifier Annotation field_modifiers {cout<<"fieldModifier \n";}
;

field_modifiers:
  class_access
| STATIC
| FINAL
| field_modifier
;

VariableDeclaratorList:
  VariableDeclarator {cout<<"VariableDeclaratorList1\n";}
| VariableDeclarator comma VariableDeclaratorList {cout<<"VariableDeclaratorList2\n";}
;

UnannType:
  UnannPrimitiveType {cout<<"UnannType1\n";}
| UnannReferenceType {cout<<"UnannType2\n";}
;

UnannPrimitiveType:
  boolean
| literal_type {cout<<"UnannPrimitiveType\n";}
;

UnannReferenceType:
  ClassType
| Identifier
| UnannArrayType
;

UnannArrayType:
  UnannPrimitiveType Dims
| ClassType Dims
| Identifier Dims
;

VariableDeclarator:
  Identifier
| Identifier Dims
| Identifier assign VariableInitializer {cout<<"VariableDeclarator1\n";}
| Identifier Dims assign VariableInitializer
;

/* VariableInitializer:
  Expression
| ArrayInitializer
; */

VariableInitializer:
  literal
;

TypeParameters:
  less_than TypeParameterList greater_than {cout<<"typeparam\n";}
;

ClassExtends:
  extends ClassType {cout<<"extends\n";}
;

ClassImplements:
 implements InterfaceTypeList {cout<<"implements\n";}
;

ClassPermits:
  ClassPermits comma TypeName
|  TypeName
;

TypeParameterList:
  TypeParameterList comma TypeParameter
| TypeParameter
;

/*
InterfaceTypeList:
 InterfaceType {cout<<"interfacetypelist1\n";}
| InterfaceTypeList comma InterfaceType {cout<<"interfacetypelist2\n";}
;
*/

InterfaceTypeList:
 ClassType {cout<<"interfacetypelist1\n";}
| InterfaceTypeList comma ClassType {cout<<"interfacetypelist2\n";}
;

TypeParameter:
  Annotation Identifier TypeBound
| Identifier TypeBound
| Annotation Identifier
| Identifier
;

TypeBound:
  extends ClassType {cout<<"typebound1\n";}
| extends ClassType AdditionalBound {cout<<"typebound2\n";}
;

AdditionalBound:
  AdditionalBound bitwise_and InterfaceType
| bitwise_and InterfaceType
;

InterfaceType:
  ClassType {cout<<"interfacetype\n";}
;

/*
ClassType:
  Annotation Identifier TypeArguments {cout<<"classtype1\n";}
| PackageName dot Annotation Identifier TypeArguments {cout<<"classtype2\n";}
| ClassOrInterfaceType dot Annotation Annotation Identifier TypeArguments {cout<<"classtype3\n";}
;
*/

ClassType:
  Identifier dot {cout<<"classtype2\n";}
| ClassType Identifier dot ClassTypeTillPackage {cout<<"classtype1\n";}
| ClassTypeTillPackage
;

ClassTypeTillPackage:
  Annotation Identifier TypeArguments {cout<<"classtype3\n";}
| Annotation Identifier 
| Identifier TypeArguments
| Identifier
;

TypeArguments:
  less_than TypeArgumentList greater_than {cout<<"typeargs\n";}
;

TypeArgumentList :
 TypeArgumentList comma TypeArgument
| TypeArgument
;

TypeArgument:
  ReferenceType
| Annotation ques_mark
| Annotation ques_mark WildcardBounds
;

WildcardBounds:
  extends ReferenceType
| super ReferenceType
;

ReferenceType:
  ClassType
| ArrayType
;

ArrayType:
  PrimitiveType Dims
| ClassType Dims
;

Dims:
  Annotation box_open box_close
| box_open box_close
| Dims Annotation box_open box_close
| Dims box_open box_close
;

PrimitiveType:
  Annotation literal_type {cout<<"PrimitiveType\n";}
;

ClassModifier:
   Annotation class_modifiers {cout<<"classModifier \n";}
|  ClassModifier Annotation class_modifiers {cout<<"classModifier \n";}
;

class_modifiers:
  key_abstract
| key_STRICTFP
| class_access
| key_SEAL
| STATIC
| FINAL
;

Annotation:
| NormalAnnotation
| at TypeName
| at TypeName brac_open ElementValue brac_close
;

NormalAnnotation:
  at TypeName brac_open ElementValuePairList brac_close
;

ElementValuePairList:
  ElementValuePair
| ElementValuePairList comma ElementValuePair
;

ElementValuePair:
  Identifier assign ElementValue
;

/* 
ElementValue:
  ConditionalExpression
  ElementValueArrayInitializer
  Annotation
;
*/

ElementValue:
  ElementValueArrayInitializer
| Annotation
;

ElementValueArrayInitializer:
  curly_open ElementValueList comma curly_close
| curly_open ElementValueList curly_close
| curly_open comma curly_close
| curly_open curly_close
;

ElementValueList:
  ElementValue
| ElementValueList comma ElementValue
;

Expression : 
  AssignmentExpression {cout<<num++<<" Khatam----------------------------------------\n";}

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

Primary:
PrimaryNoNewArray
;

PrimaryNoNewArray:
literal
| ClassLiteral {cout<<"Classliteral\n";}
| THIS
| TypeName dot THIS
| brac_open Expression brac_close
| FieldAccess
| ArrayAccess
;

TypeName:
Identifier
| TypeName dot Identifier 
;

ArrayAccess:
TypeName box_open Expression box_close
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

ConditionalExpression : 
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
;

PostfixExpression:
  Primary
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

// InstanceofExpression:
  // ConditionalOrExpression INSTANCE_OF ReferenceType
// | ConditionalOrExpression INSTANCE_OF Pattern

// CastExpression:
//   brac_open PrimitiveType brac_close UnaryExpression
// | brac_open ReferenceType brac_close UnaryExpressionNotPlusMinus
// | brac_open ReferenceType AdditionalBounds brac_close UnaryExpressionNotPlusMinus
;

// AdditionalBounds:
// AdditionalBound 
// | AdditionalBounds AdditionalBound
// ;

// AdditionalBound:
// bitwise_and InterfaceType
// ;

AssignmentOperator:
assign
| AssignmentOperator1
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