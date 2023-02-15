%{  
#include <bits/stdc++.h>
using namespace std;

extern int yyparse();
int yylex (void);
int yyerror (char const *);

extern void set_input_file(const char* filename);
extern void set_output_file(const char* filename);
extern void close_output_file();


int chapters=0,sections=0,paras=0,w=0,words=0,dec_sentences=0,ex_sentences=0,interr_sentences=0;

vector<string> v;
void update_stats(string s){
  
}


void print_stats(){

  fstream fout;
  fout.open("output.txt", ios::out); /* the statistical output csv file */

  
  fout.close();
}

/* {} 0 or more
[] 0 or one*/

%}

%union{
  char* sym;
}

%token curly_open curly_close box_open box_close dot less_than greater_than comma ques_mark and_symbol at colon OR brac_open brac_close
%token class_just_class class_modifier literal_type AssignmentOperator boolean literal keyword
%token Identifier extends super implements permits 
%token ARITHMETIC_OP LOGICAL_OP BITWISE_OP RELATIONAL_OP INCR_DECR VOID THIS
%glr-parser

%%

input : Expression
| Expression input
;
Expression : literal
| AssignmentExpression
;

AssignmentExpression : 
 Assignment
;

Assignment:
  LeftHandSide AssignmentOperator Expression {cout<<"mera ho gaya\n";}
;

LeftHandSide:
FieldAccess      {cout<<"Fieldacc\n";}
| ExpressionName {cout<<"Expname\n";}
| ArrayAccess    {cout<<"Arraceess\n";}
;

ExpressionName:
Identifier {cout<<"Id-Expname\n";}
| AmbiguousName dot Identifier {cout<<"Id-Expname2\n";}
;

AmbiguousName:
Identifier {cout<<"Id-Expna\n";}
| AmbiguousName dot Identifier
;

FieldAccess:
Primary dot Identifier 
| super dot Identifier
| TypeName dot super dot Identifier
;

Primary:
PrimaryNoNewArray
;

PrimaryNoNewArray:
literal
| ClassLiteral
| THIS
| TypeName dot THIS
| brac_open Expression brac_close
| FieldAccess
| ArrayAccess
;

TypeName:
TypeIdentifier
| PackageOrTypeName dot TypeIdentifier 
;

TypeIdentifier:
 Identifier   {cout<<"IDentifier\n";}
;

PackageOrTypeName:
Identifier {cout<<"Id2-1\n";}
| PackageOrTypeName dot Identifier {cout<<"Id2-2\n";}
;

ArrayAccess:
ExpressionName box_open Expression box_close
| PrimaryNoNewArray box_open Expression box_close
;

squarebox: box_open box_close 
| squarebox box_open box_close
;

ClassLiteral : TypeName squarebox dot class_just_class
| TypeName dot class_just_class
| literal_type squarebox dot class_just_class
| literal_type dot class_just_class
| boolean squarebox dot class_just_class
| boolean dot class_just_class
| VOID dot class_just_class


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
    print_stats();

    return 0;
}

int yyerror (char const *s)
{
  return yyerror(string(s));
}