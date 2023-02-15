%{
    #include <bits/stdc++.h>

    using namespace std;

    map<string, pair<string,pair<int,int>>> mymap;

    int num=0;

    void insertMap(string lexeme, string token){
        if(mymap.find(lexeme)!=mymap.end()){
            mymap[lexeme].second.first++;
        }
        else {
            mymap.insert({lexeme,{token,{1,num++}}});

        }
    }

    bool helper(pair<string,pair<string,pair<int,int>>> &a, pair<string,pair<string,pair<int,int>>>&b){
        return a.second.second.second < b.second.second.second;
    }

    void mysort( map<string, pair<string,pair<int,int>>> &m, vector<pair<string,pair<string,pair<int,int>>>> &vec){ 
        for(auto it: m){
            vec.push_back(it);
        }
        sort(vec.begin(),vec.end(),helper);
    }

    void report_error(int lineno, string illegal){
       cout<<"Error on line no "<<lineno<<", Unexpected character found: "<<illegal<<endl;
    }

%}

%option yylineno

string ["]([^"\n]|\\\")*["]
text_block ["]["]["][\n\r]([^"]|(\"[^"])|(\"\"[^"]))*["]["]["]
char [']([^\n\r])[']
number 0|([1-9][0-9]*)([_]*[0-9])*
afterdot ([0-9][0-9]*)([_]*[0-9])*
hexdigit [0-9a-fA-F]
binarydigit [01]
octaldigit [0-7]
hexdigits {hexdigit}|{hexdigit}+([_]*{hexdigit})*
octaldigits {octaldigit}|{octaldigit}+([_]*{octaldigit})*
binarydigits {binarydigit}|{binarydigit}+([_]*{binarydigit})*
hexnumber 0[xX]{hexdigits}+
octal 0[_]*{octaldigits}+
binary 0[bB]{binarydigits}+
long ({hexnumber}|{binary}|{octal}|{number})[lL]
boolean true|false
multi_line_comment \/\*(([^*]|((\*)+[^/]))*)\*\/
single_line_comment (\/\/([^\n\r]*))
hexfloat ({hexnumber}|0[xX]{hexdigits}*)"."?{hexdigits}*[pP][-+]?{number}[fFdD]?
float1 {number}+"."{afterdot}*[fFdD]?|{number}?"."{afterdot}+[fFdD]?
float2 {number}*"."?{afterdot}*[eE][-+]?{number}[fFdD]?
float {float1}|{float2}|{number}[fFdD]|{hexnumber}[fFdD]

%%

[ \t\n\f\r]+ {}
{multi_line_comment}|{single_line_comment} {}
","|";"|"("|")"|"["|"]"|"."|"..."|"@"|"::"|"{"|"}" {insertMap(yytext,"Seperator");}  
abstract|continue|for|new|switch|assert|default|if|package|synchronized|boolean|do|goto|private|this|break|double|implements|protected|throw|byte|else|import|public|throws|case|enum|instanceof|return|transient|catch|extends|int|short|try|char|final|interface|static|void|class|finally|long|strictfp|volatile|const|float|native|super|while|_|exports|opens|requires|uses|module|permits|sealed|var|non-sealed|provides|to|with|open|record|transitive|yield {insertMap(yytext,"Keyword");}
null|{string}|{text_block}|{char}|{number}|{hexnumber}|{octal}|{binary}|{long}|{boolean}|{hexfloat}|{float} {insertMap(yytext,"Literal");}
"+"|"-"|"*"|"/"|"%" {return ARITHMETIC_OP;}
"--"|"++" {return INCR_DECR;}
"<"|"<="|">="|">"|"=="|"!=" {return RELATIONAL_OP;}
"^"|"~"|"&"|"|"|"<<"|">>"|">>>" {return BITWISE_OP;}
"|="|"%="|"+="|"-="|"*="|"/="|"&="|"^="| {return ASSIGN_OP;}
"&&"|"||"|"!" {return LOGICAL_OP;}
"?"|":" {return TERNARY_OPERATOR;}
[a-zA-Z_][a-zA-Z0-9_]* {insertMap(yytext,"Identifier");}

. {report_error(yylineno,yytext);return 0;}
%%

int yywrap(){}

int main(int argc,char *argv[]) 
{
if(argc != 2) {
       printf("Input file expected\n");
}
else yyin = fopen(argv[1], "r" );
yylex();

ofstream outputFile;
ofstream fs;
fs.open("output.csv");
fs << "Lexeme" << "," << "Token" << "," << "Count" << endl;
vector<pair<string,pair<string,pair<int,int>>>> vec;
mysort(mymap,vec);

for(auto it:vec){
    fs<<it.first <<","<<it.second.first<<","<<it.second.second.first<<endl;
    }
return 0;
}
