%{  
#include <bits/stdc++.h>
using namespace std;

extern int yyparse();
int yylex (void);
int yyerror (char const *);

extern void set_input_file(const char* filename);
extern void set_output_file(const char* filename);
extern void close_output_file();


/* {} 0 or more
[] 0 or 1*/

%}

%union{
  char* sym;
}

%token brac_open brac_close curly_open curly_close box_open box_close dot dots less_than greater_than 
%token comma ques_mark and_symbol at assign semi_colon
%token class_just_class literal_type AssignmentOperator boolean literal keyword VOID THIS throws var 
%token class_access STATIC FINAL key_SEAL key_abstract key_STRICTFP field_modifier method_modifier
%token Identifier extends super implements permits enum_just_enum record_just_record

%%

input:
| ClassDeclaration input
;

ClassDeclaration:
  ClassModifier class_just_class Identifier TypeParameters ClassExtends ClassImplements maybe_ClassPermits ClassBody {cout<<"class declared yayy!!1\n";}
| class_just_class Identifier TypeParameters ClassExtends ClassImplements maybe_ClassPermits ClassBody {cout<<"class declared yayy!!2\n";}
;

ClassBody:
  curly_open ClassBodyDeclaration curly_close {cout<<"classbody1\n";}
| curly_open curly_close {cout<<"classbody2\n";}
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
  ConstructorModifier ConstructorDeclarator Throws ConstructorBody {cout<<"constructordeclaration1\n";}
| ConstructorDeclarator Throws ConstructorBody {cout<<"constructordeclaration2\n";}
;


ConstructorModifier:
   Annotation {cout<<"constructormodifier1\n";}
|  class_access {cout<<"constructormodifier2\n";}
|  Annotation ConstructorModifier {cout<<"constructormodifier3\n";}
|  class_access ConstructorModifier {cout<<"constructormodifier4\n";}
;

ConstructorBody:
  curly_open ExplicitConstructorInvocation BlockStatements curly_close
| curly_open ExplicitConstructorInvocation curly_close
| curly_open BlockStatements curly_close
| curly_open curly_close
;

/* ExplicitConstructorInvocation:
| TypeArguments this brac_open ArgumentList brac_close semi_colon
| TypeArguments super brac_open ArgumentList brac_close semi_colon
| ExpressionName dot TypeArguments super brac_open ArgumentList brac_close semi_colon
| Primary dot TypeArguments super brac_open ArgumentList brac_close semi_colon
; */

 ExplicitConstructorInvocation:
  TypeArguments THIS brac_open ArgumentList brac_close semi_colon {cout<<"";}
| TypeArguments super brac_open ArgumentList brac_close semi_colon {cout<<"";}
;

ArgumentList:
  Expression
| Expression comma ArgumentList
;

Expression:
  literal
;

ConstructorDeclarator:
  ConstructorDeclaratorStart ConstructorDeclaratorEnd
;

ConstructorDeclaratorStart:
  TypeParameters Identifier brac_open 
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
  LocalClassOrInterfaceDeclaration {cout<<"";}
| LocalVariableDeclarationStatement {cout<<"";}
;

LocalVariableDeclarationStatement:
  LocalVariableDeclaration
;

LocalVariableDeclaration:
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
  MethodModifier MethodHeader Block {cout<<"MethodDeclaration1\n";}
| MethodHeader Block {cout<<"MethodDeclaration\2";}
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
  Result MethodDeclarator Throws {cout<<"MethodHeader1\n";}
| TypeParameters Annotation Result MethodDeclarator Throws {cout<<"MethodHeader2\n";}
;

Throws:
| throws ExceptionTypeList
;

ExceptionTypeList:
  ExceptionType
| ExceptionType comma ExceptionTypeList
;

ExceptionType:
  ClassType
| TypeVariable
;

MethodDeclarator:
  MethodDeclaratorStart MethodDeclaratorEnd
;

MethodDeclaratorStart:
  Identifier brac_open {cout<<"MethodDeclaratorStart\n";}
;

MethodDeclaratorEnd:
  ReceiverParameter FormalParameterList brac_close {cout<<"MethodDeclarator1\n";}
| ReceiverParameter FormalParameterList brac_close Dims {cout<<"MethodDeclarator2\n";}
| FormalParameterList brac_close {cout<<"MethodDeclarator3\n";}
| FormalParameterList brac_close Dims {cout<<"MethodDeclarator4\n";}
| ReceiverParameter brac_close {cout<<"MethodDeclarator5\n";}
| ReceiverParameter brac_close Dims {cout<<"MethodDeclarator6\n";}
| brac_close {cout<<"MethodDeclarator7\n";}
| brac_close Dims {cout<<"MethodDeclarator8\n";}
;

FormalParameterList:
  FormalParameter
| FormalParameter comma FormalParameterList
;

FormalParameter:
  VariableModifier UnannType VariableDeclaratorId {cout<<"FormalParameter1\n";}
| VariableArityParameter {cout<<"FormalParameter2\n";}
;

VariableDeclaratorId:
  Identifier Dims
| Identifier {cout<<"VariableDeclaratorId2\n";}
;

VariableArityParameter:
  VariableModifier UnannType Annotation dots Identifier
;

VariableModifier:
  Annotation
| FINAL
| Annotation VariableModifier
| FINAL VariableModifier
;

ReceiverParameter:
  Annotation UnannType THIS comma {cout<<"ReceiverParameter1\n";}
| Annotation UnannType Identifier dot THIS comma  {cout<<"ReceiverParameter2\n";}
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
| UnannTypeVariable
| UnannArrayType
;

UnannTypeVariable:
  Identifier {cout<<"UnannTypeVariable\n";}
;

UnannArrayType:
  UnannPrimitiveType Dims
| ClassType Dims
| UnannTypeVariable Dims
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
| less_than TypeParameterList greater_than {cout<<"typeparam\n";}
;

ClassExtends:
| extends ClassType {cout<<"extends\n";}
;

ClassImplements:
| implements InterfaceTypeList {cout<<"implements\n";}
;

maybe_ClassPermits:
| permits ClassPermits
;

ClassPermits:
  ClassPermits comma TypeName
|  TypeName
;

TypeName:
  Identifier
| PackageOrTypeName dot Identifier
;

PackageOrTypeName:
  Identifier
| PackageOrTypeName dot Identifier
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
;

TypeBound:
| extends TypeVariable {cout<<"typebound1\n";}
| extends ClassType AdditionalBound {cout<<"typebound2\n";}
;

AdditionalBound:
| AdditionalBound and_symbol InterfaceType
| and_symbol InterfaceType
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
  Identifier TypeArguments {cout<<"classtype1\n";}
| PackageName dot Identifier TypeArguments {cout<<"classtype2\n";}
| ClassType dot Identifier TypeArguments {cout<<"classtype3\n";}
;

PackageName:
  Identifier {cout<<"packagename\n";}
| PackageName dot Identifier {cout<<"packagename\n";}
;

TypeArguments:
| less_than TypeArgumentList greater_than {cout<<"typeargs\n";}
;

TypeArgumentList :
 TypeArgumentList comma TypeArgument
| TypeArgument
;

TypeArgument:
  ReferenceType
| Wildcard
;

Wildcard:
 Annotation ques_mark
| Annotation ques_mark WildcardBounds
;

WildcardBounds:
  extends ReferenceType
| super ReferenceType
;

ReferenceType:
  ClassType
| TypeVariable
| ArrayType
;

ArrayType:
  PrimitiveType Dims
| ClassType Dims
| TypeVariable Dims
;

Dims:
  Annotation box_open box_close
| Dims Annotation box_open box_close

PrimitiveType:
  Annotation literal_type {cout<<"PrimitiveType\n";}
;

TypeVariable:
  Annotation Identifier
| Identifier
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