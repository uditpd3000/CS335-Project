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

%%

"//"(.*[ \t]*.*)*[\n] /* for single line comments */
[ \t\n\r\f]+ /* space terminators */

"/*"([^*]|\*+[^*/])*\*+"/" /* multiline comments */

"("|")"|";"|"..."|"::"  /* seperators */
"{" {return curly_open;}
"}" {return curly_close;}
"[" {return box_open;}
"]" {return box_close;}
"," {cout<<"comma--\n";return comma;}
"?" {return ques_mark;}
"@" {return at;}

"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|">>>="|"&="|"^="|"|=" {return AssignmentOperator;}
"." {cout<<"dot---\n";return dot;}
"<" {return less_than;}
">" {return greater_than;}
"&" {return and_symbol;}

continue|for|new|switch|assert|default|if|package|synchronized|boolean|do|goto|break|protected|throw|else|import|throws|case|enum|instanceof|return|transient|catch|try|interface|void|finally|volatile|const|native|while|"_" {return keyword;} /* keywords */

"class" {return class_just_class;}
public|private|abstract|static|final|sealed|non-sealed|strictfp {return class_modifier;}
extends {return extends;}
super {return super;}
implements {return implements;}
perits {return permits;}
byte|short|int|long|char|float|double {return literal_type;}
 
true|false { return boolean;} /* boolean literals */
null {} /* null literals */
['][^']['] {} /* char literals */
["]["]["](([^"]*)|(["][^"]*["][^"]+)|([\n]))*["]["]["] {} /* text-block literals */
\"[^\n"]+\" {} /* string literals */
{FloatingPointLiteral}|{BinaryIntegerLiteral}|{OctalIntegerLiteral}|{HexIntegerLiteral}|{DecimalIntegerLiteral} { return literal;} /* numerical literals */

[a-zA-Z_][a-zA-Z0-9_]*  {cout<<yytext<<"----identifier\n"; return Identifier;} /* identifiers */

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