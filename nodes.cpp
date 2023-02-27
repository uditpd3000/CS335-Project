#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
#include <list>

using namespace std;

class Node {
  public:
    string label; //seperator
    string lexeme; //}

    vector<Node*> objects;

    Node(){
        cout<<"here";
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
        cout<<label;
        if(lexeme!=""){
            cout<<"__"<<lexeme; //seperator__}
        }
    }
};