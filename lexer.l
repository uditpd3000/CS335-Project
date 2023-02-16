%{  
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

";"|"..."|"::"  /* seperators */
"{" {return curly_open;}
"}" {return curly_close;}
"[" {return box_open;}
"]" {return box_close;}
"," {return comma;}
"?" {return ques_mark;}
":" {return colon;}
"@" {return at;}
"||" {return OR;}
"&&" {return AND;}
"(" {return brac_open;}
")" {return brac_close;}

"." {return dot;}
"<" {return less_than;}
">" {return greater_than;}
"&" {return bitwise_and;}
"^" {return bitwise_xor;}
"|" {return bitwise_or;}
"=="|"!=" {return EQUALNOTEQUAL;}
"="|"|="|"%="|"+="|"-="|"*="|"/="|"&="|"^=" {return AssignmentOperator;}
"+"|"-" {return ARITHMETIC_OP_ADDITIVE;}
"*"|"/"|"%" {return ARITHMETIC_OP_MULTIPLY;}
"--"|"++" {return INCR_DECR;}
"<="|">=" {return RELATIONAL_OP1;}
"<<"|">>"|">>>" {return SHIFT_OP;}
"~"|"!" {return LOGICAL_OP;}

continue|for|new|switch|assert|default|if|package|synchronized|boolean|do|goto|break|protected|throw|else|import|throws|case|enum|return|transient|catch|try|interface|finally|volatile|const|native|while|"_" {return keyword;} /* keywords */
instanceof {return INSTANCE_OF;}
class {return class_just_class;}
void {return VOID;}
this {return THIS;}
public|private|abstract|static|final|sealed|non-sealed|strictfp {return class_modifier;}
extends {return extends;}
super {return super;}
implements {return implements;}
perits {return permits;}
byte|short|int|long|char|float|double {return literal_type;}

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