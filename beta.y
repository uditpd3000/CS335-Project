%{
    #include<bits/stdc++.h>
    using namespace std;
%}

%union{
    int num;
    char sym;
}

%token boolean byte short int long char float double box_open box_close if else brac_close 
%token brac_open colon while for semi_colon equal INCR DECR While Identifier



%%
input: 
| PrimitiveType
| Array
| ControlStatement
;

PrimitiveType:
    NumericType
    |boolean
;

NumericType:
    IntegralType
    |FloatingPointType
;

IntegralType:
    byte
    |short
    |int
    |long
    |char
;

FloatingPointType:
    |float
    |double
;

Array: ArrayCreationExpression
| ArrayAccess
| ArrayType
;

ArrayType: PrimitiveType
;

ArrayCreationExpression: PrimitiveType dims
| PrimitiveType dims dims
| PrimitiveType dims dims dims
| PrimitiveType dims ArrayInitializer
| PrimitiveType dims dims ArrayInitializer
| PrimitiveType dims dims dims ArrayInitializer
;

ArrayInitializer: 
| VariableInitializerList
;

VariableInitializerList: 
| VariableInitializer VariableInitializerList
;

VariableInitializer: Expression
| ArrayInitializer
;

ArrayAccess: Identifier dims
| Identifier dims dims
| Identifier dims dims dims
;

dims: 
| box_open Expression box_close
;

ControlStatement: IfElse
| ForStatement
| WhileStatement
;

IfElse: IfThenStatement
| IfThenElseStatement
| IfThenElseStatementNoShortIf
;

IfThenStatement:
if Condition Statement
;

IfThenElseStatement:
if Condition StatementNoShortIf else Statement
;

IfThenElseStatementNoShortIf:
if Condition StatementNoShortIf else StatementNoShortIf
;

Condition: brac_open Expression brac_close
;

StatementNoShortIf: Identifier colon StatementNoShortIf
| while Condition StatementNoShortIf
| for ForCondition StatementNoShortIf
| for EnhancedForCondition StatementNoShortIf
;

ForCondition: ForInit semi_colon Expression semi_colon ForUpdate
;

ForInit: LocalVariableDeclaration
;

LocalVariableDeclaration: LocalVariableType VariableDeclaratorList
;

LocalVariableType: 
| PrimitiveType
;


VariableDeclaratorList: VariableDeclarator VariableDeclaratorList
;

VariableDeclarator: VariableDeclaratorId 
| VariableDeclaratorId equal VariableInitializer
;

VariableDeclaratorId: Identifier
;

VariableInitializer: Expression
| ArrayInitializer
;

ForUpdate: StatementExpressionList
;

StatementExpressionList: StatementExpression StatementExpressionList
;

StatementExpression: Assignment
| PreIncrimentExpression
| PreDecrimentExpression
| PostIncrimentExpression
| PreDecrimentExpression
;

PreIncrimentExpression: INCR UnaryExpression
;

PreDecrimentExpression: DECR UnaryExpression
;

PostIncrimentExpression: UnaryExpression INCR
;

PostIncrimentExpression: UnaryExpression DECR
;

EnhancedForCondition: LocalVariableDeclaration colon Expression
;

ForStatement: BasicForStatement
| EnhancedForStatement
;

BasicForStatement: for ForCondition Statement
;

EnhancedForStatement: for EnhancedForCondition Statement
;

Statement: BlockStatements
| LabeledStatement
| IfThenStatement
| IfThenElseStatement
| WhileStatement
| ForStatement
;

LabeledStatement: Identifier colon Statement
;

WhileStatement: While Condition Statement
| WhileStatementNoShortIf
;

WhileStatementNoShortIf: While Condition StatementNoShortIf
;






%%

int main(){
    yyparse();

    return 0;
}