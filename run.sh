flex lexer.l
bison -d -t parser.y
g++ lex.yy.c parser.tab.c
./a.out input.java > graph.dot
# dot -Tps graph.dot -o graph.ps