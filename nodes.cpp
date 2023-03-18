#include <bits/stdc++.h>
#include "symbol-table.cpp"

using namespace std;
extern ofstream fout;

extern int yylineno;

extern void throwError(string, int);


class Node {
  public:
    int lineno;
    string label; //seperator
    string lexeme; //}
    string anyName;
    bool isObj;

    vector<Node*> objects;

    string type;

    Variable* var;
    Method* method;
    Class* cls;
    int dims=0;
    vector<Variable*> variables;


    Node(){
        label="";
        lexeme="";
    }
    Node(string l){
        label=l;
        lexeme="";
    }
    Node(string a,string b){
        label=a;
        lexeme=b;
    }

    void add(Node* a){
        objects.push_back(a);
    }
    void add(vector<Node*> a){
        for(auto x:a) objects.push_back(x);
    }

    void print(){
        fout<<label;
        if(lexeme!=""){
            if(lexeme[0]!='"' && lexeme[lexeme.length()-1]) fout<<"__"<<lexeme; //seperator__}
            else{
                fout<<"__\\"<<lexeme.substr(0,lexeme.length()-1)<<"\\\"";
            }
        }

    }
};


