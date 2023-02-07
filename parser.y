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
[] 0 or one*/

%}

%union{
  char* sym;
}

%token brac_open brac_close curly_open curly_close box_open box_close dot less_than greater_than comma ques_mark and_symbol at assign
%token class_just_class class_modifier literal_type AssignmentOperator boolean literal keyword
%token Identifier extends super implements permits enum_just_enum record_just_record


%%

input:
|   ClassDeclaration input
;

ClassDeclaration:
    NormalClassDeclaration
|    EnumDeclaration
;

NormalClassDeclaration:
  maybe_ClassModifier class_just_class TypeIdentifier TypeParameters ClassExtends ClassImplements maybe_ClassPermits ClassBody {cout<<"class declared yayy!!\n";}
;

/* 
EnumDeclaration:
  maybe_ClassModifier enum TypeIdentifier ClassImplements EnumBody
;
 */

EnumDeclaration:
  maybe_ClassModifier enum_just_enum TypeIdentifier ClassImplements ClassBody {cout<<"class declared yayy!!\n";}
;

/* 
enumBody
 */

ClassBody:
  curly_open curly_close {cout<<"classbody\n";}
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
  TypeIdentifier
| PackageOrTypeName dot TypeIdentifier
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
  Annotation TypeIdentifier TypeBound
| TypeIdentifier TypeBound
;

TypeBound:
| extends TypeVariable {cout<<"typebound1\n";}
| extends ClassOrInterfaceType AdditionalBound {cout<<"typebound2\n";}
;

AdditionalBound:
| AdditionalBound and_symbol InterfaceType
| and_symbol InterfaceType
;

ClassOrInterfaceType:
  ClassType
| InterfaceType
;

InterfaceType:
  ClassType {cout<<"interfacetype\n";}
;

/*
ClassType:
  Annotation TypeIdentifier TypeArguments {cout<<"classtype1\n";}
| PackageName dot Annotation TypeIdentifier TypeArguments {cout<<"classtype2\n";}
| ClassOrInterfaceType dot Annotation Annotation TypeIdentifier TypeArguments {cout<<"classtype3\n";}
;
*/

ClassType:
  TypeIdentifier TypeArguments {cout<<"classtype1\n";}
| PackageName dot TypeIdentifier TypeArguments {cout<<"classtype2\n";}
| ClassOrInterfaceType dot TypeIdentifier TypeArguments {cout<<"classtype3\n";}
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
 Annotation ques_mark WildcardBounds
;

WildcardBounds:
| extends ReferenceType
| super ReferenceType
;

ReferenceType:
  ClassOrInterfaceType
| TypeVariable
| ArrayType
;

ArrayType:
  PrimitiveType Dims
| ClassOrInterfaceType Dims
| TypeVariable Dims
;

Dims:
  Annotation box_open box_close
| Dims Annotation box_open box_close

PrimitiveType:
  Annotation literal_type
;

TypeVariable:
  Annotation TypeIdentifier
| TypeIdentifier
;

maybe_ClassModifier:
| ClassModifier
;
ClassModifier:
   Annotation class_modifier {cout<<"classModifier yayy!!\n";}
|  ClassModifier Annotation class_modifier {cout<<"classModifier yayy!!\n";}
;

Annotation:
| NormalAnnotation
| at TypeName
| at TypeName brac_open ElementValue brac_close
;

NormalAnnotation:
  at TypeName brac_open maybe_ElemValuePairList brac_close
;

maybe_ElemValuePairList:
| ElementValuePairList
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
  curly_open maybe_ElementValueList maybe_comma curly_close
;

maybe_comma:
| comma
;

maybe_ElementValueList:
| ElementValueList
;

ElementValueList:
  ElementValue
| ElementValueList comma ElementValue
;

TypeIdentifier:
 Identifier {cout<<"typeidentifier\n";}
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