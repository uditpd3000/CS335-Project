flex lexer.l
bison -d -t parser.y
g++ lex.yy.c parser.tab.c
./a.out ../input.java ../output/graph.dot
dot -Tps ../output/graph.dot -o graph.ps
