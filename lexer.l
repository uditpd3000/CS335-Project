%{  
#include <bits/stdc++.h>
#include "nodes.cpp" 
#include "parser.tab.h"

#include <bits/stdc++.h>
using namespace std;

int yyerror(char *s);

extern void close_input_file();
FILE* pInputFile = NULL;

bool flag=false; /* flag to indicate any lexical-error found */

%}

%option yylineno 

NonZeroDigit [1-9]
Digit [0-9]
Digits {Digit}+([_]*{Digit}+)*

DecimalNumeral ([0])|({NonZeroDigit}+([_]{Digits}+)*{Digits}*)
HexNumeral [0-9a-fA-F]([0-9a-fA-F_]*[0-9a-fA-F])*
OctalNumeral [0][_]*[0-7]([0-7_]*[0-7])*
BinaryNumeral [0][bB][01]([01_]*[01])*

IntegerTypeSuffix [lL]

DecimalIntegerLiteral {DecimalNumeral}{IntegerTypeSuffix}?
HexIntegerLiteral [0][xX]{HexNumeral}{IntegerTypeSuffix}?
OctalIntegerLiteral {OctalNumeral}{IntegerTypeSuffix}?
BinaryIntegerLiteral {BinaryNumeral}{IntegerTypeSuffix}?

DecimalFloatingPointLiteral {NonZeroDigit}{Digits}*([.]{Digits}*)?([eE][+-]?{Digits}+)?[fFdD]?
HexadecimalFloatingPointLiteral ([0][xX]{HexNumeral}*[.]{HexNumeral}?)[pP][+-]?{Digits}+[fFdD]?
FloatingPointLiteral {DecimalFloatingPointLiteral}|{HexadecimalFloatingPointLiteral}

CharacterLiteral ['][^'][']
BooleanLiteral true|false
NullLiteral null
TextBlock ["]["]["](([^"]*)|(["][^"]*["][^"]+)|([\n]))*["]["]["]
StringLiteral \"[^\n"]+\" 
%%

"//"(.*[ \t]*.*)*[\n] /* for single line comments */
[ \t\n\r\f]+ /* space terminators */

"/*"([^*]|\*+[^*/])*\*+"/" /* multiline comments */

"::"  /* seperators */
"(" {return brac_open;}
")" {return brac_close;}
"{" {yylval.sym = strdup(yytext); return curly_open;}
"}" {yylval.sym = strdup(yytext); return curly_close;}
"[" {return box_open;}
"]" {return box_close;}
"," {return comma;}
"?" {return ques_mark;}
"@" {return at;}
"=="|"!=" {return EQUALNOTEQUAL;}
"=" {return assign;}
"." {return dot;}
"..." {return dots;}
"<" {return less_than;}
">" {return greater_than;}
";" {cout<<";\n";return semi_colon;}
":" {return colon;}
"||" {return OR;}
"&&" {return AND;}
"&" {return bitwise_and;}
"^" {return bitwise_xor;}
"|" {return bitwise_or;}
"|="|"%="|"+="|"-="|"*="|"/="|"&="|"^=" {return AssignmentOperator1;}
"+"|"-" {return ARITHMETIC_OP_ADDITIVE;}
"*"|"/"|"%" {return ARITHMETIC_OP_MULTIPLY;}
"--"|"++" {return INCR_DECR;}
"<="|">=" {return RELATIONAL_OP1;}
"<<"|">>"|">>>" {return SHIFT_OP;}
"~"|"!" {return LOGICAL_OP;}

switch|assert|default|package|synchronized|boolean|do|goto|import|case|catch|try|interface|finally|const|"_" {return keyword;} /* keywords */

class {return class_just_class;}
public|private|protected {return class_access;}
static {return STATIC;}
final {return FINAL;}
sealed|non-sealed {return key_SEAL;}
abstract {return key_abstract;}
strictfp {return key_STRICTFP;}
transient|volatile {return field_modifier;}
native|synchronized {return method_modifier;}
extends {return extends;}
super {return super;}
enum {return enum_just_enum;}
this {return THIS;}
record {return record_just_record;}
implements {yylval.sym = strdup(yytext); return implements;}
permits {yylval.sym = strdup(yytext);return permits;}
var {return var;}
void {return VOID;}
throws {return throws;}
throw {return THROW;}
return {return RETURN;}
continue {return CONTINUE;}
for {return FOR;}
while {return WHILE;}
if {return IF;}
else {return ELSE;}
byte|short|int|long|char|float|double {return literal_type;}
instanceof {return INSTANCE_OF;}
new {return NEW;}

{FloatingPointLiteral}|{BinaryIntegerLiteral}|{OctalIntegerLiteral}|{HexIntegerLiteral}|{DecimalIntegerLiteral}|{NullLiteral}|{CharacterLiteral}|{TextBlock}|{StringLiteral}|{BooleanLiteral} { return literal;} /* literals */


[a-zA-Z_][a-zA-Z0-9_]*  {return Identifier;} /* identifiers */

. {printf("Error on line %d : read an invalid character %s\n", yylineno, yytext ); flag=true; return 0;} /* lexical error */

%%

void close_input_file()
{
	if(pInputFile)
	{
		fclose(pInputFile);
		pInputFile = NULL;
	}
}

void set_input_file(const char* filename)
{
	if(filename)
	{
		yyin = fopen(filename,"r");
	}
}

int yywrap(){return 1;}