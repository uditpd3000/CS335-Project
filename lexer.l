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

map<string, string> mymap;


void insertMap(string lexeme, string token){
	if(mymap.find(lexeme)==mymap.end())mymap.insert({lexeme,token});

}


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

"::" {insertMap(strdup(yytext),"Seperator");} /* seperators */
"(" {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return brac_open;}
")" {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return brac_close;}
"{" {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return curly_open;}
"}" {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return curly_close;}
"[" {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return box_open;}
"]" {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return box_close;}
"," {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return comma;}
"?" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return ques_mark;}
"@" {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return at;}
"=="|"!=" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return EQUALNOTEQUAL;}
"=" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return assign;}
"." {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return dot;}
"..." {insertMap(strdup(yytext),"Seperator");yylval.sym = strdup(yytext); return dots;}
"<" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return less_than;}
">" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return greater_than;}
";" {insertMap(strdup(yytext),"Seperator");cout<<";\n";return semi_colon;}
":" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return colon;}
"||" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return OR;}
"&&" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return AND;}
"&" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return bitwise_and;}
"^" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return bitwise_xor;}
"|" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return bitwise_or;}
"|="|"%="|"+="|"-="|"*="|"/="|"&="|"^=" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return AssignmentOperator1;}
"+"|"-" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return ARITHMETIC_OP_ADDITIVE;}
"*"|"/"|"%" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return ARITHMETIC_OP_MULTIPLY;}
"--"|"++" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return INCR_DECR;}
"<="|">=" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return RELATIONAL_OP1;}
"<<"|">>"|">>>" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return SHIFT_OP;}
"~"|"!" {insertMap(strdup(yytext),"Operator");yylval.sym = strdup(yytext); return LOGICAL_OP;}

switch|assert|default|package|synchronized|boolean|do|goto|import|case|catch|try|interface|finally|const|"_" {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return keyword;} /* keywords */

class {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return class_just_class;}
public|private|protected {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return class_access;}
static {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return STATIC;}
final {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return FINAL;}
sealed|non-sealed {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return key_SEAL;}
abstract {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return key_abstract;}
strictfp {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return key_STRICTFP;}
transient|volatile {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return field_modifier;}
native|synchronized {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return method_modifier;}
extends {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return extends;}
super {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return super;}
enum {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return enum_just_enum;}
this {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return THIS;}
record {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return record_just_record;}
implements {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return implements;}
permits {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext);return permits;}
var {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return var;}
void {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return VOID;}
throws {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return throws;}
throw {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return THROW;}
return {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return RETURN;}
continue {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return CONTINUE;}
for {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return FOR;}
while {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return WHILE;}
if {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return IF;}
else {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return ELSE;}
byte|short|int|long|char|float|double {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return literal_type;}
instanceof {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return INSTANCE_OF;}
new {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return NEW;}
"System.out.println" {insertMap(strdup(yytext),"Keyword");yylval.sym = strdup(yytext); return PRINTLN;}

{FloatingPointLiteral}|{BinaryIntegerLiteral}|{OctalIntegerLiteral}|{HexIntegerLiteral}|{DecimalIntegerLiteral}|{NullLiteral}|{CharacterLiteral}|{TextBlock}|{StringLiteral}|{BooleanLiteral} {insertMap(strdup(yytext),"Literal"); return literal;} /* literals */


[a-zA-Z_][a-zA-Z0-9_]*  {insertMap(strdup(yytext),"Identifier");yylval.sym = strdup(yytext);return Identifier;} /* identifiers */

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