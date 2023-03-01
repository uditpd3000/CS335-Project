flex lexer.l
bison -d -t parser.y
g++ lex.yy.c parser.tab.c
./a.out ./tests/test_1.java
# dot -Tps graph.dot -o graph.ps